using System.Collections.Concurrent;
using System.IO.Compression;
using System.Net;
using System.Security.Cryptography;
using System.Text.Json.Nodes;

namespace ImperialSchool.Views.Core;

public sealed class PublishedAssetChanged(string message) : IOException(message);
public sealed record TransferProgress(string Stage, string Title, long Received = 0, long Total = 0, int Completed = 0, int Count = 0, string Message = "");

public sealed class AssetStore : IDisposable
{
    public const string Site = "https://games.oopssre.ru/assets/arcade/views/";
    readonly string root;
    readonly HttpClient http;
    readonly Action<string, int?, int?> validate;
    readonly ConcurrentDictionary<string, SemaphoreSlim> locks = new();
    public string Images => Path.Combine(root, "cache");
    public AssetStore(string dataRoot, Action<string, int?, int?> validateImage, HttpMessageHandler? handler = null)
    {
        root = dataRoot; validate = validateImage;
        http = new(handler ?? new HttpClientHandler { AllowAutoRedirect = false, AutomaticDecompression = DecompressionMethods.All }) { Timeout = Timeout.InfiniteTimeSpan };
        http.DefaultRequestHeaders.UserAgent.ParseAdd("ImperialSchoolViews-Windows/1.2.0"); Directory.CreateDirectory(Images);
    }
    public string ImagePath(ViewFile f) => Path.Combine(Images, f.Sha256 + ".jpg");
    public static Uri Address(string relative, string? version = null)
    {
        Catalogue.Require(!Uri.TryCreate(relative, UriKind.Absolute, out _) && !relative.Contains('?') && !relative.Contains('#') && !relative.Contains('\\') && !relative.Split('/').Any(p => p is "." or ".." or ""), "Неверный адрес файла");
        var uri = new Uri(new Uri(Site), relative + (version is null ? "" : "?v=" + Uri.EscapeDataString(version)));
        Catalogue.Require(uri.Scheme == "https" && uri.Host == "games.oopssre.ru" && uri.IsDefaultPort && uri.UserInfo.Length == 0 && uri.AbsolutePath.StartsWith("/assets/arcade/views/", StringComparison.Ordinal), "Неверный адрес сервера"); return uri;
    }
    async Task<HttpResponseMessage> Response(Uri address, CancellationToken cancel)
    {
        for (var i = 0; i < 4; i++)
        {
            using var deadline = CancellationTokenSource.CreateLinkedTokenSource(cancel); deadline.CancelAfter(TimeSpan.FromSeconds(45));
            var response = await http.GetAsync(address, HttpCompletionOption.ResponseHeadersRead, deadline.Token).ConfigureAwait(false);
            if ((int)response.StatusCode is >= 300 and < 400)
            {
                var location = response.Headers.Location; response.Dispose(); Catalogue.Require(location is not null, "Нет адреса перенаправления");
                address = new Uri(address, location!); Catalogue.Require(address.Scheme == "https" && address.Host == "games.oopssre.ru" && address.IsDefaultPort && address.UserInfo.Length == 0 && address.AbsolutePath.StartsWith("/assets/arcade/views/", StringComparison.Ordinal), "Неверное перенаправление"); continue;
            }
            if (response.StatusCode is HttpStatusCode.NotFound or HttpStatusCode.Gone) { response.Dispose(); throw new PublishedAssetChanged("Файл на сайте обновлён или удалён"); }
            try { response.EnsureSuccessStatusCode(); return response; } catch { response.Dispose(); throw; }
        }
        throw new HttpRequestException("Слишком много перенаправлений");
    }
    static async Task<int> Read(Stream input, Memory<byte> buffer, CancellationToken cancel)
    {
        using var idle = CancellationTokenSource.CreateLinkedTokenSource(cancel); idle.CancelAfter(TimeSpan.FromSeconds(45));
        return await input.ReadAsync(buffer, idle.Token).ConfigureAwait(false);
    }
    public async Task<byte[]> Get(string path, long limit, CancellationToken cancel)
    {
        using var response = await Response(Address(path, DateTimeOffset.UtcNow.ToUnixTimeMilliseconds().ToString()), cancel).ConfigureAwait(false);
        Catalogue.Require(response.Content.Headers.ContentLength is null || response.Content.Headers.ContentLength <= limit, "Слишком большой ответ сервера");
        await using var input = await response.Content.ReadAsStreamAsync(cancel).ConfigureAwait(false); using var output = new MemoryStream(); var buffer = new byte[65536]; int n;
        while ((n = await Read(input, buffer, cancel).ConfigureAwait(false)) > 0) { Catalogue.Require(output.Length + n <= limit, "Слишком большой ответ сервера"); output.Write(buffer, 0, n); }
        if (!path.EndsWith(".br", StringComparison.Ordinal)) return output.ToArray();
        if(output.ToArray().SkipWhile(b=>b is 9 or 10 or 13 or 32).FirstOrDefault() is 123 or 91) return output.ToArray();
        output.Position=0; using var brotli=new BrotliStream(output,CompressionMode.Decompress); using var decoded=new MemoryStream();
        while((n=await Read(brotli,buffer,cancel).ConfigureAwait(false))>0){Catalogue.Require(decoded.Length+n<=limit,"Слишком большой JSON Brotli");decoded.Write(buffer,0,n);}return decoded.ToArray();
    }
    public async Task<bool> Valid(ViewFile file, CancellationToken cancel) => await Task.Run(() =>
    {
        var path = ImagePath(file); if (!System.IO.File.Exists(path) || new FileInfo(path).Length != file.Bytes || SafeFiles.Sha(path) != file.Sha256) return false;
        try { validate(path, file.Width, file.Height); return true; } catch (Exception e) when (e is InvalidDataException or IOException or ArgumentException or InvalidOperationException or System.Runtime.InteropServices.ExternalException) { return false; }
    }, cancel).ConfigureAwait(false);
    async Task Download(ArchiveDescriptor a, string destination, Action<long> progress, CancellationToken cancel)
    {
        using var response = await Response(Address(a.Url, a.Sha256), cancel).ConfigureAwait(false);
        if (response.Content.Headers.ContentLength is { } length && length != a.Bytes) throw new PublishedAssetChanged("Размер файла на сайте изменился");
        await using var input = await response.Content.ReadAsStreamAsync(cancel).ConfigureAwait(false);
        await using var output = new FileStream(destination, FileMode.CreateNew, FileAccess.Write, FileShare.None, 65536, FileOptions.Asynchronous);
        using var hash = IncrementalHash.CreateHash(HashAlgorithmName.SHA256); var buffer = new byte[65536]; long total = 0; var last = DateTime.UtcNow; int n;
        while ((n = await Read(input, buffer, cancel).ConfigureAwait(false)) > 0)
        {
            total += n; if (total > a.Bytes) throw new PublishedAssetChanged("Файл по постоянному адресу изменился");
            hash.AppendData(buffer, 0, n); await output.WriteAsync(buffer.AsMemory(0, n), cancel).ConfigureAwait(false);
            if (DateTime.UtcNow - last >= TimeSpan.FromMilliseconds(250)) { progress(total); last = DateTime.UtcNow; }
        }
        await output.FlushAsync(cancel).ConfigureAwait(false); output.Flush(true); progress(total);
        if (total != a.Bytes || Convert.ToHexStringLower(hash.GetHashAndReset()) != a.Sha256) throw new PublishedAssetChanged("Размер или SHA-256 скачанного файла не совпадает");
    }
    public async Task<string> Picture(ViewFile file, CancellationToken cancel)
    {
        Catalogue.Require(Catalogue.Hash.IsMatch(file.Sha256) && file.Bytes is > 0 and <= 100_000_000, "Неверные сведения об изображении");
        var gate = locks.GetOrAdd(file.Sha256, _ => new(1, 1)); await gate.WaitAsync(cancel).ConfigureAwait(false);
        var temporary = ImagePath(file) + "." + Guid.NewGuid().ToString("N") + ".download";
        try
        {
            if (await Valid(file, cancel).ConfigureAwait(false)) return ImagePath(file);
            await Download(new(file.Url, file.Bytes, file.Sha256, ""), temporary, _ => { }, cancel).ConfigureAwait(false);
            await Task.Run(() => validate(temporary, file.Width, file.Height), cancel).ConfigureAwait(false); cancel.ThrowIfCancellationRequested();
            System.IO.File.Move(temporary, ImagePath(file), true); return ImagePath(file);
        }
        finally { if (System.IO.File.Exists(temporary)) System.IO.File.Delete(temporary); gate.Release(); }
    }
    public WeatherVariant[] Variants(JsonObject c,string format,ArchiveDescriptor descriptor)
    {
        var path=Receipt(descriptor.Sha256); if(!System.IO.File.Exists(path))return [];
        try {return Weather.Package(JsonNode.Parse(System.IO.File.ReadAllText(path))!.AsObject(),c,format,descriptor.Version);}
        catch(Exception e) when(e is IOException or System.Text.Json.JsonException or InvalidDataException or InvalidOperationException){return [];}
    }
    public void InvalidatePackage(string hash) {var p=Receipt(hash);if(System.IO.File.Exists(p))System.IO.File.Delete(p);}
    string Receipt(string hash) => Path.Combine(root, "weather-packages", hash + ".json");
    static async Task<FileStream> PackageLease(string path,Action<TransferProgress> report,CancellationToken cancel)
    {
        while(true) {
            cancel.ThrowIfCancellationRequested();
            try {return new FileStream(path,FileMode.OpenOrCreate,FileAccess.ReadWrite,FileShare.None);}
            catch(IOException e) when((e.HResult&0xffff) is 11 or 32 or 33) {report(new("waiting","Пакет готовит другой экземпляр приложения или хранитель"));await Task.Delay(500,cancel).ConfigureAwait(false);}
        }
    }
    public async Task WeatherZip(JsonObject c, string format, ArchiveDescriptor descriptor, string version, bool force, Action<TransferProgress> report, CancellationToken cancel)
    {
        Catalogue.Require(descriptor.Version == version, "Версия ZIP изменилась; получаю новый каталог");
        Catalogue.Require(Catalogue.Hash.IsMatch(descriptor.Sha256) && descriptor.Bytes is > 0 and <= 8_589_934_592 && descriptor.Url == "downloads/weather-" + Weather.Text(c, "id") + "-" + format + ".zip", "Неверные сведения о ZIP");
        var gate = locks.GetOrAdd("zip-" + descriptor.Sha256, _ => new(1, 1)); await gate.WaitAsync(cancel).ConfigureAwait(false);
        var folder = Path.Combine(root, "downloads"); Directory.CreateDirectory(folder); var path = Path.Combine(folder, descriptor.Sha256 + ".zip.download"); var failure = Path.Combine(folder, descriptor.Sha256 + ".error.json");
        try
        {
            await using var lease=await PackageLease(path+".lock",report,cancel).ConfigureAwait(false);
            if (System.IO.File.Exists(Receipt(descriptor.Sha256)))
            {
                var receipt = JsonNode.Parse(await System.IO.File.ReadAllTextAsync(Receipt(descriptor.Sha256), cancel).ConfigureAwait(false))!.AsObject(); Weather.Package(receipt, c, format, version);
                report(new("ready", "ZIP готов")); return;
            }
            if (!force && System.IO.File.Exists(failure)) { report(new("error", "Загрузка ZIP отложена", Message: "Нажмите «Обновить сейчас» для повторной загрузки")); return; }
            if (System.IO.File.Exists(path)) System.IO.File.Delete(path);
            report(new("downloading", "Скачиваю погодный ZIP", Total: descriptor.Bytes));
            await Download(descriptor, path, received => report(new("downloading", "Скачиваю погодный ZIP", received, descriptor.Bytes)), cancel).ConfigureAwait(false);
            report(new("verifying", "Проверяю ZIP"));
            await Task.Run(() => ImportWeatherZip(path, c, format, descriptor, report, cancel), cancel).ConfigureAwait(false);
            if (System.IO.File.Exists(failure)) System.IO.File.Delete(failure); report(new("ready", "ZIP готов"));
        }
        catch (OperationCanceledException) when (cancel.IsCancellationRequested) { report(new("cancelled", "Загрузка остановлена")); throw; }
        catch (Exception e)
        {
            SafeFiles.Write(failure, new JsonObject { ["sha256"] = descriptor.Sha256, ["message"] = e.Message, ["at"] = DateTimeOffset.UtcNow.ToString("O") }.ToJsonString()); report(new("error", "Не удалось подготовить ZIP", Message: e.Message)); throw;
        }
        finally { if (System.IO.File.Exists(path)) System.IO.File.Delete(path); gate.Release(); }
    }
    public void ImportWeatherZip(string path, JsonObject c, string format, ArchiveDescriptor descriptor, Action<TransferProgress> report, CancellationToken cancel)
    {
        Catalogue.Require(new FileInfo(path).Length == descriptor.Bytes && SafeFiles.Sha(path) == descriptor.Sha256, "Повреждён ZIP");
        using var zip = ZipFile.OpenRead(path); var names = zip.Entries.Select(e => e.FullName).ToArray();
        Catalogue.Require(names.Length is > 0 and <= 8010 && names.Distinct(StringComparer.OrdinalIgnoreCase).Count() == names.Length, "Повтор или слишком много файлов ZIP");
        JsonObject Document(string name)
        {
            var entry = zip.GetEntry(name) ?? throw new InvalidDataException("Нет " + name); Catalogue.Require(entry.Length is > 0 and <= 5_000_000, "Слишком большой манифест ZIP");
            using var stream = entry.Open(); using var reader = new StreamReader(stream); return JsonNode.Parse(reader.ReadToEnd())!.AsObject();
        }
        var p = Document("manifest.json"); var rows = Weather.Package(p, c, format, descriptor.Version); var companion = Document("weather-package.json");
        Catalogue.Require(companion["schema"]?.GetValue<int>() == 1 && Weather.Text(companion, "type") == "weather" && Weather.Text(companion, "format") == format, "Неверный формат погодного ZIP");
        var allowed = rows.Select(v => v.File.Url).Concat(["manifest.json", "weather-package.json", "README.txt", "files/"]).ToHashSet(StringComparer.Ordinal);
        Catalogue.Require(names.All(allowed.Contains), "Посторонние файлы в ZIP");
        for (var i = 0; i < rows.Length; i++)
        {
            cancel.ThrowIfCancellationRequested(); var file = rows[i].File;
            if (i % 5 == 0) report(new("unpacking", "Проверяю и сохраняю кадры", Completed: i, Count: rows.Length));
            var target = ImagePath(file); if (System.IO.File.Exists(target) && new FileInfo(target).Length == file.Bytes && SafeFiles.Sha(target) == file.Sha256) { validate(target, file.Width, file.Height); continue; }
            var entry = zip.GetEntry(file.Url) ?? throw new InvalidDataException("Нет кадра ZIP"); Catalogue.Require(entry.Length == file.Bytes, "Размер кадра ZIP не совпадает");
            var temporary = target + "." + Guid.NewGuid().ToString("N") + ".part";
            try
            {
                using (var input = entry.Open()) using (var output = new FileStream(temporary, FileMode.CreateNew))
                {
                    var buffer = new byte[65536]; long total = 0; int n;
                    while ((n = input.Read(buffer)) > 0) { cancel.ThrowIfCancellationRequested(); total += n; Catalogue.Require(total <= file.Bytes, "Кадр ZIP слишком большой"); output.Write(buffer, 0, n); } output.Flush(true);
                    Catalogue.Require(total == file.Bytes, "Кадр ZIP неполный");
                }
                Catalogue.Require(SafeFiles.Sha(temporary) == file.Sha256, "SHA-256 кадра ZIP не совпадает"); validate(temporary, file.Width, file.Height); cancel.ThrowIfCancellationRequested(); System.IO.File.Move(temporary, target, true);
            }
            finally { if (System.IO.File.Exists(temporary)) System.IO.File.Delete(temporary); }
        }
        cancel.ThrowIfCancellationRequested(); p["client_api"] = "1.7"; SafeFiles.Write(Receipt(descriptor.Sha256), p.ToJsonString());
    }
    public async Task<string> OrdinaryZip(ArchiveDescriptor descriptor, string expectedCollection, string collectionsRoot, Action<TransferProgress> report, CancellationToken cancel)
    {
        Catalogue.Require(descriptor.Bytes is > 0 and <= 1_000_000_000 && Catalogue.Hash.IsMatch(descriptor.Sha256) && System.Text.RegularExpressions.Regex.IsMatch(descriptor.Url, "\\Adownloads/[a-zA-Z0-9._-]+\\.zip\\z"), "Неверные сведения о ZIP коллекции");
        var folder = Path.Combine(root, "downloads"); Directory.CreateDirectory(folder); var path = Path.Combine(folder, Guid.NewGuid().ToString("N") + ".zip.download");
        try
        {
            report(new("downloading", "Скачиваю коллекцию", Total: descriptor.Bytes)); await Download(descriptor, path, received => report(new("downloading", "Скачиваю коллекцию", received, descriptor.Bytes)), cancel).ConfigureAwait(false);
            report(new("unpacking", "Проверяю и сохраняю коллекцию")); var id = await Task.Run(() =>
            {
                using (var zip = ZipFile.OpenRead(path))
                {
                    var manifest = zip.GetEntry("manifest.json") ?? throw new InvalidDataException("Нет манифеста коллекции"); Catalogue.Require(manifest.Length is > 0 and <= 5_000_000, "Неверный манифест");
                    using var reader = new StreamReader(manifest.Open()); var document = JsonNode.Parse(reader.ReadToEnd())!; Catalogue.Require(Weather.Text(document, "id") == expectedCollection, "ZIP другой коллекции");
                }
                cancel.ThrowIfCancellationRequested(); return Packages.Import(path, collectionsRoot, validate);
            }, cancel).ConfigureAwait(false); report(new("ready", "Коллекция сохранена")); return id;
        }
        finally { if (System.IO.File.Exists(path)) System.IO.File.Delete(path); }
    }
    public HashSet<string> ProtectedImages(IEnumerable<ViewFile> forecastFiles)
    {
        var keep = forecastFiles.Select(ImagePath).ToHashSet(StringComparer.OrdinalIgnoreCase); var folder = Path.Combine(root, "weather-packages"); if (!Directory.Exists(folder)) return keep;
        foreach (var receipt in Directory.GetFiles(folder, "*.json"))
        {
            try { var p = JsonNode.Parse(System.IO.File.ReadAllText(receipt))!; foreach (var f in p["variants"]!.AsArray()) keep.Add(Path.Combine(Images, Weather.Text(f, "sha256") + ".jpg")); }
            catch (Exception e) when (e is InvalidDataException or IOException or System.Text.Json.JsonException or InvalidOperationException) { }
        }
        return keep;
    }
    public void PrunePackages(IReadOnlySet<string> currentVersions)
    {
        var folder = Path.Combine(root, "weather-packages"); if (!Directory.Exists(folder)) return;
        var receipts = Directory.GetFiles(folder, "*.json").Select(path => { try { return (Path: path, Json: JsonNode.Parse(System.IO.File.ReadAllText(path))!.AsObject()); } catch (Exception e) when (e is InvalidDataException or IOException or System.Text.Json.JsonException) { return (Path: path, Json: (JsonObject?)null); } }).Where(r => r.Json is not null).ToArray();
        string Key(JsonObject p) => Weather.Text(p, "id") + "/" + Weather.Text(p, "format");
        var latest = receipts.GroupBy(r => Key(r.Json!)).Select(g => g.MaxBy(r => System.IO.File.GetLastWriteTimeUtc(r.Path)).Path).ToHashSet();
        foreach (var r in receipts) if (!latest.Contains(r.Path) && !currentVersions.Contains(Key(r.Json!) + "/" + Weather.Text(r.Json!, "version")) && System.IO.File.GetLastWriteTimeUtc(r.Path) < DateTime.UtcNow.AddMinutes(-5)) System.IO.File.Delete(r.Path);
    }
    public void Dispose() => http.Dispose();
}
