using ImperialSchool.Views.Core;
using System.Net;
using System.Security.Cryptography;
using System.Text.Json;
using System.Text.Json.Nodes;

namespace ImperialSchool.Views;

internal sealed partial class Repository : IDisposable
{
    public const string Site = "https://games.oopssre.ru/assets/arcade/views/";
    public static readonly string Root = Path.Combine(Environment.GetFolderPath(Environment.SpecialFolder.LocalApplicationData), "Imperial School", "Views");
    public string CollectionsRoot => Path.Combine(Root, "collections");
    public string CacheRoot => Path.Combine(Root, "cache");
    public AssetStore Assets { get; }
    public WeatherSessions Weather { get; }
    public CityWeather Cities { get; }
    public bool CatalogueFetched { get; private set; }
    readonly SemaphoreSlim catalogueGate = new(1, 1);
    static readonly JsonSerializerOptions Json = new() { WriteIndented = true };
    public Repository()
    {
        Directory.CreateDirectory(Root); Directory.CreateDirectory(CacheRoot);
        Assets = new AssetStore(Root, ValidateImage); Weather = new WeatherSessions(Root, Assets); Cities=new CityWeather(Root);
        var migration = Path.Combine(Root, "client-api.txt");
        if (!File.Exists(migration) || File.ReadAllText(migration) != "1.7")
        {
            var catalogue = Path.Combine(Root, "catalogue.json"); if (File.Exists(catalogue)) File.Delete(catalogue);
            // Settings, imported packs, current wallpaper and verified image bytes stay.
            SafeFiles.Write(migration, "1.7");
        }
    }
    public T Read<T>(string name) where T : new()
    {
        try { return JsonSerializer.Deserialize<T>(File.ReadAllText(Path.Combine(Root, name))) ?? new T(); }
        catch (FileNotFoundException) { return new T(); }
        catch (Exception e) when (e is IOException or JsonException) { Log(e); return new T(); }
    }
    public void Write<T>(string name, T value) => SafeFiles.Write(Path.Combine(Root, name), JsonSerializer.Serialize(value, Json));
    public static void Log(Exception e)
    {
        try
        {
            Directory.CreateDirectory(Root); var path = Path.Combine(Root, "app.log");
            if (File.Exists(path) && new FileInfo(path).Length > 1_000_000) File.Move(path, path + ".old", true);
            File.AppendAllText(path, DateTimeOffset.Now.ToString("O") + " " + e + Environment.NewLine);
        }
        catch (Exception failure) when (failure is IOException or UnauthorizedAccessException) { }
    }
    public Task<byte[]> Download(string url, long limit, CancellationToken cancel)
    {
        Catalogue.Require(url.StartsWith(Site, StringComparison.Ordinal), "Неверный адрес загрузки");
        return Assets.Get(url[Site.Length..], limit, cancel);
    }
    public async Task<Catalogue?> CatalogueFor(Settings settings, bool refresh, CancellationToken cancel)
    {
        await catalogueGate.WaitAsync(cancel);
        try { return await LoadCatalogue(settings, refresh, cancel); }
        finally { catalogueGate.Release(); }
    }
    async Task<Catalogue?> LoadCatalogue(Settings settings, bool refresh, CancellationToken cancel)
    {
        if (!settings.Online)
        {
            var local = await Task.Run(() => Packages.Discover(CollectionsRoot), cancel); return local is null ? null : Catalogue.Parse(local);
        }
        CatalogueFetched = false;
        var cached = Path.Combine(Root, "catalogue.json");
        if (refresh || !File.Exists(cached))
        {
            var text = System.Text.Encoding.UTF8.GetString(await Download(Site + "manifest-v3.json", 5_000_000, cancel));
            var parsed = Catalogue.Parse(text); SafeFiles.Write(cached, text); CatalogueFetched = true; return parsed;
        }
        try { return Catalogue.Parse(await File.ReadAllTextAsync(cached, cancel)); }
        catch (Exception e) when (e is InvalidDataException or JsonException or InvalidOperationException or FormatException) { return await LoadCatalogue(settings, true, cancel); }
    }
    public static void ValidateImage(string path, int? width, int? height)
    {
        using var stream = File.OpenRead(path); using var image = Image.FromStream(stream, false, true);
        Catalogue.Require(image.RawFormat.Guid == System.Drawing.Imaging.ImageFormat.Jpeg.Guid && image.Width is > 0 and <= 16384 && image.Height is > 0 and <= 16384 && (width is null || image.Width == width) && (height is null || image.Height == height), "Неверное изображение: " + Path.GetFileName(path));
    }
    public async Task<string> Picture(Settings settings, ViewFile file, CancellationToken cancel)
    {
        if (!settings.Online)
        {
            var path = SafeFiles.Under(Root, file.Url);
            await Task.Run(() => { Catalogue.Require(new FileInfo(path).Length == file.Bytes && SafeFiles.Sha(path) == file.Sha256, "Повреждён файл коллекции"); ValidateImage(path, file.Width, file.Height); }, cancel);
            // An imported package may later be replaced. Keep the applied original immutable.
            var pinned = Path.Combine(CacheRoot, file.Sha256 + ".jpg");
            if (!File.Exists(pinned) || new FileInfo(pinned).Length != file.Bytes || SafeFiles.Sha(pinned) != file.Sha256)
            {
                var copy = pinned + "." + Guid.NewGuid().ToString("N") + ".tmp";
                try { File.Copy(path, copy); File.Move(copy, pinned, true); }
                finally { if (File.Exists(copy)) File.Delete(copy); }
            }
            File.SetLastWriteTimeUtc(pinned, DateTime.UtcNow); return pinned;
        }
        return await Assets.Picture(file, cancel);
    }
    public async Task<Image?> Preview(Settings settings, Scene scene, CancellationToken cancel)
    {
        byte[] bytes;
        if (settings.Online) bytes = await Download(Site + scene.Preview, 8_000_000, cancel);
        else bytes = await File.ReadAllBytesAsync(SafeFiles.Under(Root, scene.Preview), cancel);
        using var stream = new MemoryStream(bytes); using var image = Image.FromStream(stream);
        Catalogue.Require(image.Width <= 4096 && image.Height <= 4096, "Слишком большое превью"); return new Bitmap(image);
    }
    public void Prune(IEnumerable<string> protectedPaths)
    {
        try { PruneCore(protectedPaths); }
        catch (Exception e) when (e is IOException or UnauthorizedAccessException or InvalidDataException or JsonException or InvalidOperationException) { Log(e); }
    }
    void PruneCore(IEnumerable<string> protectedPaths)
    {
        Assets.PrunePackages(Weather.PackageVersions(DateTimeOffset.UtcNow));
        var keep = protectedPaths.Concat(Assets.ProtectedImages(Weather.ForecastFiles(DateTimeOffset.UtcNow))).ToHashSet(StringComparer.OrdinalIgnoreCase);
        var files = new DirectoryInfo(CacheRoot).GetFiles("*.jpg").OrderByDescending(f => f.LastWriteTimeUtc).ToArray(); long bytes = 0; int count = 0;
        foreach (var f in files)
        {
            bytes += f.Length; count++;
            if ((bytes > 128_000_000 || count > 64) && f.LastWriteTimeUtc < DateTime.UtcNow.AddMinutes(-5) && !keep.Contains(f.FullName)) { try { f.Delete(); } catch (IOException) { } }
        }
    }
    public void Dispose() {Assets.Dispose();Cities.Dispose();}
}
