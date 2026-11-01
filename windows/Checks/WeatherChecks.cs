using ImperialSchool.Views.Core;
using System.IO.Compression;
using System.Net;
using System.Security.Cryptography;
using System.Text;
using System.Text.Json.Nodes;

static class WeatherChecks
{
    sealed class Handler(Func<HttpRequestMessage, CancellationToken, Task<HttpResponseMessage>> send) : HttpMessageHandler
    { protected override Task<HttpResponseMessage> SendAsync(HttpRequestMessage request, CancellationToken token) => send(request, token); }
    static HttpResponseMessage Response(byte[] bytes) => new(HttpStatusCode.OK) { Content = new ByteArrayContent(bytes) };
    static HttpResponseMessage Response(JsonObject document) => Response(Encoding.UTF8.GetBytes(document.ToJsonString()));
    static JsonObject Clone(JsonObject p) => (JsonObject)p.DeepClone();
    static void Must(bool condition) { if (!condition) throw new Exception("Weather contract failed"); }
    static void Reject(Action action) { try { action(); } catch (Exception e) when (e is InvalidDataException or IOException or ArgumentException or System.Text.Json.JsonException or InvalidOperationException) { return; } throw new Exception("Invalid weather input accepted"); }
    static JsonObject Load(string name) => JsonNode.Parse(File.ReadAllText(Path.Combine(AppContext.BaseDirectory, "Fixtures/" + name)))!.AsObject();
    public static async Task<int> Run()
    {
        int count = 0;
        void Check(string name, Action action) { action(); Console.WriteLine("OK " + name); count++; }
        async Task Async(string name, Func<Task> action) { await action(); Console.WriteLine("OK " + name); count++; }
        var catalogue = Catalogue.Parse(File.ReadAllText(Path.Combine(AppContext.BaseDirectory, "Fixtures/site.json")));
        var c = catalogue.Collections.Single(p => p.Weather is not null).Weather!;
        var pair = Load("weather-game-world.json"); var p = pair["current"]!.AsObject(); var f = pair["forecast"]!.AsObject();
        var readyRow = f["intervals"]!.AsArray().First(r => Weather.Text(r, "status") == "ready")!;
        var at = new[] { Weather.Time(f["generated_at"]), Weather.Time(readyRow["valid_from"]) }.Max().AddMilliseconds(1);
        var descriptor = Weather.Descriptor(catalogue, c, "macbook");
        Check("Existing Windows settings and monitor selection survive the new weather defaults", () =>
        {
            var old = System.Text.Json.JsonSerializer.Deserialize<Settings>("{\"Source\":\"online\",\"Collection\":\"monthly\",\"Mode\":\"monthly\",\"Monitor\":\"display-saved\",\"Format\":\"16:9\",\"Enabled\":true,\"Paused\":true}")!;
            Must(old.Source == "online" && old.Collection == "monthly" && old.Monitor == "display-saved" && old.Format == "16:9" && old.Enabled && old.Paused && old.WeatherDelivery == "zip" && old.WeatherSource == "game-world");
        });
        Check("Server can replace the wallpaper of the day without a date change", () =>
        {
            var date = new DateOnly(2026, 10, 28); var first = catalogue.Choose("", "featured", date); var other = catalogue.Scenes.First(s => s.Id != first.Id);
            Must((catalogue with { Featured = other.Id }).Choose("", "featured", date).Id == other.Id);
        });
        Check("Published API 1.7 desktop forecasts, sources and interval boundaries", () =>
        {
            foreach (var source in new[] { "real", "game-world" })
            {
                var live = Load("weather-" + source + ".json"); var current = live["current"]!.AsObject(); var forecast = live["forecast"]!.AsObject();
                Weather.Current(current, c, source); Weather.Forecast(forecast, c, source, "macbook");
                foreach (var row in forecast["intervals"]!.AsArray())
                {
                    var start = Weather.Time(row!["valid_from"]); if (start < Weather.Time(forecast["generated_at"])) continue;
                    var resolved = Weather.Resolve(c, source, "macbook", current, forecast, start);
                    Must(resolved.Next <= Weather.Time(row["valid_until"])); if (Weather.Text(row, "status") == "ready") Must(resolved.File!.Sha256 == Weather.Text(row["file"], "sha256"));
                }
            }
        });
        Check("Desktop-only selection rejects phone and tolerates removed format", () => { Must(Weather.Format(c, "auto", 3440, 1440).Width > Weather.Format(c, "auto", 3440, 1440).Height); Must(Weather.Format(c, "display", 3840, 2400).Id == "macbook"); Reject(() => Weather.Format(c, "phone", 1920, 1080)); });
        Check("API 1.7 refuses old catalogue schemas", () => { var invalid = JsonNode.Parse(File.ReadAllText(Path.Combine(AppContext.BaseDirectory, "Fixtures/site.json")))!; invalid["schema"] = 2; Reject(() => Catalogue.Parse(invalid.ToJsonString())); });
        Check("Published ZIP manifest matches all ready forecasts and phases", () =>
        {
            var package = Load("weather-package.json"); var rows = Weather.Package(package, c, "macbook", descriptor.Version);
            Must(rows.Length == 264);
            foreach (var source in new[] { "real", "game-world" }) foreach (var r in Load("weather-" + source + ".json")["forecast"]!["intervals"]!.AsArray().Where(r => Weather.Text(r, "status") == "ready"))
                Must(rows.Count(v => v.StateId == Weather.Text(r, "state_id") && v.MoonPhase == Weather.Text(r, "moon_phase") && v.File.Sha256 == Weather.Text(r!["file"], "sha256")) == 1);
        });
        Check("Same world with another location revision refuses old forecast", () => { var changed = Clone(p); changed["location_revision"] = "different"; Must(Weather.Resolve(c, "game-world", "macbook", changed, f, at).Status == "stale"); });
        Check("Another world refuses old forecast", () => { var changed = Clone(p); changed["world_id"] = "different"; Must(Weather.Resolve(c, "game-world", "macbook", changed, f, at).Status == "stale"); });
        Check("Season and complete world year come from server interval", () => { var changed = Clone(f); var r = changed["intervals"]!.AsArray().First(r => Weather.Text(r, "state_id") == Weather.Text(readyRow, "state_id"))!; r["world_date"] = "2031-06-01"; r["season"] = "summer"; var frame = Weather.Resolve(c, "game-world", "macbook", p, changed, at); Must(frame.Season == "summer" && frame.Details.Contains("2031") && frame.Title == Weather.Text(p["source"], "setting")); });
        Check("Expired refresh time does not expire a compatible forecast", () => { var current = Clone(p); var forecast = Clone(f); current["refresh_after"] = at.AddHours(-1).ToString("O"); forecast["refresh_after"] = at.AddHours(-1).ToString("O"); Must(Weather.Resolve(c, "game-world", "macbook", current, forecast, at).Status == "ready"); });
        Check("Forecast end is exclusive and cannot be extended offline", () => Must(Weather.Resolve(c, "game-world", "macbook", p, f, Weather.Time(f["valid_until"])).Status == "stale"));
        Check("Overlapping intervals refuse arbitrary frame selection", () => { var forecast = Clone(f); forecast["intervals"]!.AsArray().Add(readyRow.DeepClone()); Must(Weather.Resolve(c, "game-world", "macbook", p, forecast, at).Status == "not_ready"); });
        Check("Unknown status preserves the previous wallpaper", () => { var current = Clone(p); current["status"] = "unknown"; Must(Weather.Resolve(c, "game-world", "macbook", current, f, at).Status == "not_ready"); });
        Check("Per-device package version is independent from contract version", () => { var forecast = Clone(f); forecast["contract_version"] = "another-device-changed"; Must(Weather.Resolve(c, "game-world", "macbook", p, forecast, at).PackageVersion == Weather.Text(f, "package_version")); forecast["package_version"] = null; Must(Weather.Resolve(c, "game-world", "macbook", p, forecast, at).PackageVersion is null); });
        Check("Old hashed JPEG and wrong device dimensions are refused", () => { var forecast = Clone(f); forecast["intervals"]![0]!["file"]!["url"] = "collections/" + Weather.Text(c, "id") + "/files/" + new string('a', 64) + ".jpg"; Reject(() => Weather.Forecast(forecast, c, "game-world", "macbook")); var file = readyRow["file"]!.DeepClone(); file["width"] = 1; Reject(() => Weather.File(file, c, "macbook")); });
        Check("ZIP revision and format cannot be substituted", () => { var package = Load("weather-package.json"); Reject(() => Weather.Package(package, c, "macbook", "other-version")); Reject(() => Weather.Package(package, c, "phone", descriptor.Version)); });
        Check("Short unavailable forecast needs no normal interval fields", () => { var forecast = new JsonObject { ["schema"] = 1, ["document_type"] = "weather-forecast", ["collection_id"] = Weather.Text(c, "id"), ["source_id"] = "game-world", ["format"] = "macbook", ["location_revision"] = Weather.Text(p, "location_revision"), ["world_id"] = Weather.Text(p, "world_id"), ["status"] = "unavailable" }; Must(Weather.Resolve(c, "game-world", "macbook", p, forecast, at).Status == "unavailable"); });
        var work = Path.Combine(Path.GetTempPath(), "views-weather-" + Guid.NewGuid().ToString("N")); Directory.CreateDirectory(work);
        try
        {
            var now = DateTimeOffset.UtcNow;
            var current = Clone(p); var forecast = Clone(f); current["refresh_after"] = now.AddHours(-1).ToString("O"); forecast["refresh_after"] = now.AddHours(-1).ToString("O"); forecast["generated_at"] = now.AddMinutes(-1).ToString("O"); forecast["valid_until"] = now.AddHours(2).ToString("O");
            var r = readyRow.DeepClone(); r["valid_from"] = now.AddMinutes(-1).ToString("O"); r["valid_until"] = now.AddHours(2).ToString("O"); forecast["intervals"] = new JsonArray(r);
            var requests = 0; var offline = false; var failForecast = false;
            using var assets = new AssetStore(work, (_, _, _) => { }, new Handler((request, _) => { requests++; if (offline || failForecast && request.RequestUri!.AbsolutePath.Contains("forecast-")) throw new HttpRequestException("offline"); return Task.FromResult(Response(request.RequestUri!.AbsolutePath.EndsWith("current.json") ? current : forecast)); }));
            var sessions = new WeatherSessions(work, assets);
            await Async("JSON refresh retry waits a minute while cached intervals remain usable", async () => { var result = await sessions.Get(c, "game-world", "macbook", false, default); Must(result.Frame.Status == "ready" && requests == 2); await sessions.Get(c, "game-world", "macbook", false, default); Must(requests == 2); });
            await Async("Network loss keeps verified forecast until its original expiry", async () => { offline = true; var result = await sessions.Get(c, "game-world", "macbook", true, default); Must(result.Frame.Status == "ready" && result.Warning.Length > 0); Must(sessions.Cached(c, "game-world", "macbook", now.AddHours(3)).Frame.Status == "stale"); offline = false; });
            await Async("New current revision invalidates old forecast even when next request fails", async () => { current["location_revision"] = "new-revision"; failForecast = true; var result = await sessions.Get(c, "game-world", "macbook", true, default); Must(result.Frame.Status != "ready" && result.Current is not null && result.Forecast is null); failForecast = false; forecast["location_revision"] = "new-revision"; result = await sessions.Get(c, "game-world", "macbook", true, default); Must(result.Frame.Status == "ready"); });
            await Async("An older cache file cannot revive an already observed world revision", async () =>
            {
                var path = Directory.GetFiles(Path.Combine(work, "weather"), "*.json", SearchOption.AllDirectories).Single(); var saved = File.ReadAllText(path);
                current["location_revision"] = "latest-revision"; failForecast = true; var result = await sessions.Get(c, "game-world", "macbook", true, default); Must(result.Frame.Status != "ready");
                File.WriteAllText(path, saved); Must(sessions.Cached(c, "game-world", "macbook", now).Frame.Status != "ready");
                failForecast = false; forecast["location_revision"] = "latest-revision"; await sessions.Get(c, "game-world", "macbook", true, default);
            });
            await Async("Malformed cached forecast is replaced rather than retried forever", async () => { var path = Directory.GetFiles(Path.Combine(work, "weather"), "*.json", SearchOption.AllDirectories).Single(); var bad = JsonNode.Parse(File.ReadAllText(path))!; bad["forecast"]!.AsObject().Remove("package_version"); File.WriteAllText(path, bad.ToJsonString()); sessions.Reconnect(); var result = await sessions.Get(c, "game-world", "macbook", false, default); Must(result.Frame.Status == "ready"); });
            await Async("Cancelled JSON response cannot overwrite saved selection data", async () => { using var cancelled = new CancellationTokenSource(); cancelled.Cancel(); var path = Directory.GetFiles(Path.Combine(work, "weather"), "*.json", SearchOption.AllDirectories).Single(); var before = File.ReadAllText(path); try { await sessions.Get(c, "game-world", "macbook", true, cancelled.Token); throw new Exception("Cancellation ignored"); } catch (OperationCanceledException) { } Must(File.ReadAllText(path) == before); });
            var bytes = new byte[] { 1, 2, 3, 4, 5 }; var hash = Convert.ToHexStringLower(SHA256.HashData(bytes));
            var image = new ViewFile("collections/" + Weather.Text(c, "id") + "/files/summer-day-clear-macbook.jpg", 3840, 2400, bytes.Length, hash);
            int downloads = 0, decodes = 0; var wrong = false;
            using var images = new AssetStore(Path.Combine(work, "images"), (path, w, h) => { Must(File.ReadAllBytes(path).SequenceEqual(bytes) && w == 3840 && h == 2400); decodes++; }, new Handler((request, _) => { Must(request.RequestUri!.Query == "?v=" + hash); downloads++; return Task.FromResult(Response(wrong ? [9, 9, 9, 9, 9] : bytes)); }));
            await Async("JPEG transfer checks hash before decoder and reuses verified cache", async () => { var path = await images.Picture(image, default); await images.Picture(image, default); Must(File.Exists(path) && downloads == 1 && decodes == 2); });
            await Async("Damaged cached JPEG is downloaded again", async () => { File.WriteAllBytes(images.ImagePath(image), [8, 8]); await images.Picture(image, default); Must(downloads == 2); });
            await Async("Wrong downloaded JPEG never replaces verified cached bytes", async () => { var changed = image with { Sha256 = new string('b', 64) }; wrong = true; using var bad = new AssetStore(Path.Combine(work, "bad-image"), (_, _, _) => throw new Exception("Decoder must not see unverified bytes"), new Handler((_, _) => Task.FromResult(Response(bytes)))); try { await bad.Picture(changed, default); throw new Exception("Bad hash accepted"); } catch (PublishedAssetChanged) { } Must(!File.Exists(bad.ImagePath(changed)) && File.ReadAllBytes(images.ImagePath(image)).SequenceEqual(bytes)); });
            var packageRoot = Path.Combine(work, "package");
            using var packageAssets = new AssetStore(packageRoot, (path, _, _) => Must(File.ReadAllBytes(path).SequenceEqual(bytes)));
            var variant = new JsonObject { ["url"] = "files/test-macbook.jpg", ["format"] = "jpeg", ["rendition"] = "macbook", ["width"] = 3840, ["height"] = 2400, ["bytes"] = bytes.Length, ["sha256"] = hash, ["state_id"] = "summer-day-clear", ["moon_phase"] = "none" };
            var packageDoc = new JsonObject { ["schema"] = 3, ["document_type"] = "weather-wallpaper-package", ["type"] = "weather", ["id"] = Weather.Text(c, "id"), ["format"] = "macbook", ["version"] = "test-package", ["variants"] = new JsonArray(variant) };
            string MakeZip(string? extra = null, bool corrupt = false)
            {
                var path = Path.Combine(work, Guid.NewGuid().ToString("N") + ".zip"); using var zip = ZipFile.Open(path, ZipArchiveMode.Create);
                void Entry(string name, byte[] data) { using var stream = zip.CreateEntry(name).Open(); stream.Write(data); }
                Entry("manifest.json", Encoding.UTF8.GetBytes(packageDoc.ToJsonString())); Entry("weather-package.json", Encoding.UTF8.GetBytes("{\"schema\":1,\"type\":\"weather\",\"format\":\"macbook\"}")); Entry("files/test-macbook.jpg", corrupt ? [9, 9, 9, 9, 9] : bytes); if (extra is not null) Entry(extra, bytes); return path;
            }
            ArchiveDescriptor Describe(string path) => new("downloads/weather-" + Weather.Text(c, "id") + "-macbook.zip", new FileInfo(path).Length, SafeFiles.Sha(path), "test-package");
            Check("Weather ZIP installs only fully verified files and commits receipt last", () => { var path = MakeZip(); var d = Describe(path); packageAssets.ImportWeatherZip(path, c, "macbook", d, _ => { }, default); Must(File.Exists(Path.Combine(packageRoot, "weather-packages", d.Sha256 + ".json")) && File.ReadAllBytes(Path.Combine(packageAssets.Images, hash + ".jpg")).SequenceEqual(bytes)); });
            Check("ZIP path traversal, unknown files and Windows case duplicates are rejected", () => { foreach (var extra in new[] { "../bad", "evil.exe", "FILES/TEST-MACBOOK.JPG" }) { var path = MakeZip(extra); Reject(() => packageAssets.ImportWeatherZip(path, c, "macbook", Describe(path), _ => { }, default)); } });
            Check("Wrong ZIP version leaves previous installed receipt intact", () => { var receipts = Directory.GetFiles(Path.Combine(packageRoot, "weather-packages")); var path = MakeZip(); Reject(() => packageAssets.ImportWeatherZip(path, c, "macbook", Describe(path) with { Version = "other" }, _ => { }, default)); Must(Directory.GetFiles(Path.Combine(packageRoot, "weather-packages")).SequenceEqual(receipts)); });
            Check("Damaged ZIP frame does not commit a package receipt", () =>
            {
                var path = MakeZip(corrupt: true); var empty = Path.Combine(work, "broken-package"); using var broken = new AssetStore(empty, (_, _, _) => { });
                Reject(() => broken.ImportWeatherZip(path, c, "macbook", Describe(path), _ => { }, default));
                Must(!Directory.Exists(Path.Combine(empty, "weather-packages")) && !Directory.GetFiles(broken.Images).Any());
            });
            Check("Cache cleanup protects package files and separately pinned forecast JPEG", () => { var keep = packageAssets.ProtectedImages([image with { Sha256 = new string('c', 64) }]); Must(keep.Contains(Path.Combine(packageAssets.Images, hash + ".jpg")) && keep.Contains(Path.Combine(packageAssets.Images, new string('c', 64) + ".jpg"))); });
            await Async("Invalid ZIP metadata fails before any archive HTTP request", async () => { var calls = 0; using var zipAssets = new AssetStore(Path.Combine(work, "version"), (_, _, _) => { }, new Handler((_, _) => { calls++; throw new Exception("Wrong archive requested"); })); var path = MakeZip(); try { await zipAssets.WeatherZip(c, "macbook", Describe(path), "wrong", false, _ => { }, default); throw new Exception("Wrong ZIP version accepted"); } catch (InvalidDataException) { } Must(calls == 0); });
            await Async("Failed ZIP is not downloaded repeatedly; explicit retry can complete it", async () =>
            {
                var path = MakeZip(); var body = File.ReadAllBytes(path); var d = Describe(path); var calls = 0; var fail = true; var stages = new List<string>();
                using var retryStore = new AssetStore(Path.Combine(work, "zip-retry"), (_, _, _) => { }, new Handler((_, _) => { calls++; return Task.FromResult(Response(fail ? [1, 2, 3] : body)); }));
                try { await retryStore.WeatherZip(c, "macbook", d, d.Version, false, p => stages.Add(p.Stage), default); throw new Exception("Bad ZIP accepted"); } catch (PublishedAssetChanged) { }
                await retryStore.WeatherZip(c, "macbook", d, d.Version, false, p => stages.Add(p.Stage), default); Must(calls == 1);
                fail = false; await retryStore.WeatherZip(c, "macbook", d, d.Version, true, p => stages.Add(p.Stage), default);
                Must(calls == 2 && stages.Contains("downloading") && stages.Contains("verifying") && stages.Contains("unpacking") && stages.Last() == "ready");
            });
            await Async("Cancelled ZIP does not commit a receipt or block future attempts", async () =>
            {
                var path = MakeZip(); var d = Describe(path); using var source = new CancellationTokenSource(); var folder = Path.Combine(work, "cancel-zip");
                using var cancelled = new AssetStore(folder, (_, _, _) => { }, new Handler((_, _) => Task.FromResult(Response(File.ReadAllBytes(path)))));
                try { await cancelled.WeatherZip(c, "macbook", d, d.Version, false, p => { if (p.Stage == "downloading") source.Cancel(); }, source.Token); throw new Exception("Cancellation ignored"); } catch (OperationCanceledException) { }
                Must(!Directory.Exists(Path.Combine(folder, "weather-packages")) && !Directory.GetFiles(Path.Combine(folder, "downloads")).Any(p=>!p.EndsWith(".lock",StringComparison.Ordinal)));
            });
            await Async("App and screensaver share one weather ZIP transfer",async()=>
            {
                var path=MakeZip();var d=Describe(path);var body=File.ReadAllBytes(path);var folder=Path.Combine(work,"shared-zip");var calls=0;
                var started=new TaskCompletionSource(TaskCreationOptions.RunContinuationsAsynchronously);var release=new TaskCompletionSource(TaskCreationOptions.RunContinuationsAsynchronously);var waiting=new TaskCompletionSource(TaskCreationOptions.RunContinuationsAsynchronously);
                using var timeout=new CancellationTokenSource(TimeSpan.FromSeconds(8));
                using var first=new AssetStore(folder,(_,_,_)=>{},new Handler(async(_,token)=>{Interlocked.Increment(ref calls);started.TrySetResult();await release.Task.WaitAsync(token);return Response(body);}));
                using var second=new AssetStore(folder,(_,_,_)=>{},new Handler((_,_)=>{Interlocked.Increment(ref calls);return Task.FromResult(Response(body));}));
                var a=first.WeatherZip(c,"macbook",d,d.Version,false,_=>{},timeout.Token);await started.Task.WaitAsync(timeout.Token);
                var b=second.WeatherZip(c,"macbook",d,d.Version,false,p=>{if(p.Stage=="waiting")waiting.TrySetResult();},timeout.Token);
                try {await waiting.Task.WaitAsync(timeout.Token);}finally{release.TrySetResult();}
                await Task.WhenAll(a,b);Must(calls==1&&File.Exists(Path.Combine(folder,"weather-packages",d.Sha256+".json")));
            });
            await Async("Ordinary archive cannot install another collection", async () =>
            {
                var path = MakeZip(); var d = Describe(path) with { Url = "downloads/ordinary.zip" }; var folder = Path.Combine(work, "ordinary");
                using var ordinary = new AssetStore(folder, (_, _, _) => { }, new Handler((_, _) => Task.FromResult(Response(File.ReadAllBytes(path)))));
                try { await ordinary.OrdinaryZip(d, "another-collection", Path.Combine(folder, "collections"), _ => { }, default); throw new Exception("Wrong collection installed"); } catch (InvalidDataException) { }
                Must(!Directory.Exists(Path.Combine(folder, "collections")));
            });
        }
        finally { Directory.Delete(work, true); }
        return count;
    }
}
