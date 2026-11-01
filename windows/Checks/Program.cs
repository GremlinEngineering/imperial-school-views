using ImperialSchool.Views.Core;
using System.Text.Json.Nodes;
using System.IO.Compression;
using System.Security.Cryptography;

var count = 0;
void Check(string name, Action action) { action(); Console.WriteLine("OK " + name); count++; }
void Require(bool ok) { if (!ok) throw new Exception("Contract failed"); }
void Reject(Action action) { try { action(); } catch (Exception e) when (e is InvalidDataException or ArgumentException or System.Text.Json.JsonException or FileNotFoundException) { return; } throw new Exception("Invalid input accepted"); }
var live = File.ReadAllText(Path.Combine(AppContext.BaseDirectory, "Fixtures/site.json"));
var site = Catalogue.Parse(live);
Check("DISPLAY_DEVICEW layout matches the Windows SDK Unicode ABI", () => {
    Require(System.Runtime.InteropServices.Marshal.SizeOf<DisplayDevice>() == 840);
    Require(System.Runtime.InteropServices.Marshal.OffsetOf<DisplayDevice>(nameof(DisplayDevice.StateFlags)).ToInt32() == 324);
    Require(System.Runtime.InteropServices.Marshal.OffsetOf<DisplayDevice>(nameof(DisplayDevice.DeviceId)).ToInt32() == 328);
    Require(DisplayDevice.Create().Size == 840);
});
Check("Native failures preserve operation and HRESULT without inventing a denial", () => {
    var original = new System.Runtime.InteropServices.COMException("Class not registered", unchecked((int)0x80040154));
    var error = new NativeOperationException("создать компонент смены обоев", original);
    Require(error.HResult == original.HResult && error.InnerException == original && error.Message.Contains("0x80040154") && error.Message.Contains("создать компонент"));
    Require(!error.Message.Contains("отказала в доступе"));
    var failed = new NativeOperationException("получить границы экрана", new System.Runtime.InteropServices.COMException("Failure", unchecked((int)0x80004005)));
    Require(failed.Message.Contains("0x80004005") && !failed.Message.Contains("отказала в доступе"));
    var denied = new NativeOperationException("установить обои", new System.Runtime.InteropServices.COMException("Access denied", unchecked((int)0x80070005)));
    Require(denied.Message.Contains("0x80070005") && denied.Message.Contains("отказала в доступе"));
});
Check("Actual website catalogue: every scene has both desktop formats", () => {
    Require(site.Collections.Count >= 2 && site.Scenes.Count >= 16);
    foreach (var s in site.Scenes) { Require(Math.Abs(s.Desktop(3840, 2400).Ratio - 1.6) < .01); Require(Math.Abs(s.Desktop(3840, 2160).Ratio - 16.0 / 9) < .01); }
    Require(site.Choose("", "featured", new DateOnly(2026, 10, 27)).Id == site.Featured);
});
Check("All months and seasonal boundaries stay in the selected collection", () => {
    foreach (var p in site.Collections.Where(c => c.Weather is null)) foreach (var mode in p.Schedule.Keys) for (var m = 1; m <= 12; m++) Require(site.Choose(p.Id, mode, new DateOnly(2026, m, 1)).Collection == p.Id);
    foreach (var p in site.Collections.Where(c => c.Weather is null)) Require(site.Choose(p.Id, "daily", new DateOnly(1960, 1, 1)).Collection == p.Id);
});
Check("Wide screens and explicit formats", () => {
    var s = site.Scenes[0]; Require(Math.Abs(s.Desktop(3440, 1440).Ratio - 16.0 / 9) < .01); Require(Math.Abs(s.Desktop(3840, 2160, "16:10").Ratio - 1.6) < .01);
    Reject(() => s.Desktop(1920, 1080, "invalid")); var phone = s with { Files = s.Files.Where(f => f.Height > f.Width).ToArray() }; Reject(() => phone.Desktop(1920, 1080));
});
var monthly = File.ReadAllText(Path.Combine(AppContext.BaseDirectory, "Fixtures/monthly.json"));
Check("Twenty independent packages discover without a registry", () => {
    var docs = Enumerable.Range(0, 20).Select(i => { var p = JsonNode.Parse(monthly)!; p["id"] = "pack-" + i; return p.ToJsonString(); }).ToArray();
    var catalog = Catalogue.Parse(Catalogue.Compose(docs)); Require(catalog.Collections.Count == 20 && catalog.Scenes.Count == 240);
    foreach (var p in catalog.Collections) Require(catalog.Choose(p.Id, "monthly", new DateOnly(2026, 12, 1)).Id == p.Id + "--month-12");
});
Check("Invalid paths and cross-collection schedules are rejected", () => {
    var bad = JsonNode.Parse(live)!; bad["items"]![0]!["preview"] = "../secret"; Reject(() => Catalogue.Parse(bad.ToJsonString()));
    bad = JsonNode.Parse(live)!; bad["items"]![0]!["files"]![0]!["url"] = "collections/wrong/files/a.jpg"; Reject(() => Catalogue.Parse(bad.ToJsonString()));
    var p = JsonNode.Parse(monthly)!; p["schedule"]!["monthly"]!.AsObject().Remove("12"); Reject(() => Catalogue.Compose([p.ToJsonString()]));
    Reject(() => SafeFiles.Under(Path.GetTempPath(), "../secret")); Reject(() => SafeFiles.Under(Path.GetTempPath(), "files\\a.jpg"));
});
Check("Update identity, numeric versions and renamed setup", () => {
    string Metadata(string url = "https://games.oopssre.ru/assets/arcade/views/downloads/Windows%20%2B%20100%25%20%23%20%3F.exe", string version = "1.0.10", int build = 10) => new JsonObject { ["schema"] = 1, ["app_id"] = AppRelease.AppId, ["platform"] = "windows", ["release"] = new JsonObject { ["version"] = version, ["build"] = build, ["sha256"] = new string('a', 64), ["bytes"] = 100, ["url"] = url } }.ToJsonString();
    Require(AppRelease.Parse(Metadata())!.NewerThan("1.0.9", 9)); Require(!AppRelease.Parse(Metadata())!.NewerThan("1.0.11", 1));
    Require(AppRelease.Parse(Metadata(version: "1.0.0", build: 2))!.NewerThan("1.0.0", 1));
    Reject(() => AppRelease.Parse(Metadata("https://evil.test/a.exe"))); Reject(() => AppRelease.Parse(Metadata("https://games.oopssre.ru/x"))); Reject(() => AppRelease.Parse(Metadata("https://games.oopssre.ru/assets/arcade/views/downloads/a%2fb.exe"))); Reject(() => AppRelease.Parse(Metadata(version: "1.00.0")));
});
var work = Path.Combine(Path.GetTempPath(), "isv-checks-" + Guid.NewGuid().ToString("N")); Directory.CreateDirectory(work);
try
{
    string Zip(string id, bool corrupt = false, bool traversal = false)
    {
        var files = new JsonArray(); var bytes = new byte[] { 1, 2, 3, 4 }; var sha = Convert.ToHexStringLower(SHA256.HashData(bytes));
        foreach (var (name, w, h) in new[] { ("wide", 640, 400), ("monitor", 640, 360), ("phone", 640, 1280) }) files.Add(new JsonObject { ["url"] = "files/" + name + ".jpg", ["width"] = w, ["height"] = h, ["bytes"] = bytes.Length, ["sha256"] = sha });
        var p = new JsonObject { ["schema"] = 1, ["id"] = id, ["title"] = id, ["items"] = new JsonArray(new JsonObject { ["id"] = "a", ["title"] = "A", ["preview"] = "previews/a.jpg", ["files"] = files }) };
        var path = Path.Combine(work, Guid.NewGuid().ToString("N") + ".zip"); using var z = ZipFile.Open(path, ZipArchiveMode.Create);
        void Entry(string name, byte[] data) { using var s = z.CreateEntry(name).Open(); s.Write(data); }
        Entry("manifest.json", System.Text.Encoding.UTF8.GetBytes(p.ToJsonString())); Entry("previews/a.jpg", bytes);
        foreach (var name in new[] { "wide", "monitor", "phone" }) Entry("files/" + name + ".jpg", corrupt && name == "wide" ? [9, 9, 9, 9] : bytes);
        if (traversal) Entry("../secret", bytes); return path;
    }
    var root = Path.Combine(work, "collections");
    Check("ZIP imports retain desktop files and keep other packages", () => {
        var validates = 0; Packages.Import(Zip("one"), root, (_, _, _) => validates++); Require(validates == 4);
        Require(!File.Exists(Path.Combine(root, "one/files/phone.jpg")) && File.Exists(Path.Combine(root, "one/files/wide.jpg")));
        var old = File.ReadAllText(Path.Combine(root, "one/manifest.json")); Packages.Import(Zip("two"), root, (_, _, _) => { });
        Require(File.ReadAllText(Path.Combine(root, "one/manifest.json")) == old && Catalogue.Parse(Packages.Discover(root)!).Collections.Count == 2);
    });
    Check("Corrupt ZIP and path traversal leave the installed collection intact", () => {
        var old = File.ReadAllText(Path.Combine(root, "one/manifest.json")); Reject(() => Packages.Import(Zip("one", corrupt: true), root, (_, _, _) => { })); Require(File.ReadAllText(Path.Combine(root, "one/manifest.json")) == old);
        Reject(() => Packages.Import(Zip("three", traversal: true), root, (_, _, _) => { })); Require(!Directory.Exists(Path.Combine(root, "three")));
    });
}
finally { Directory.Delete(work, true); }
count += await WeatherChecks.Run();
count += await ParityChecks.Run();
if (args.Contains("--live")) count += await LiveChecks.Run(args);
Console.WriteLine($"{count} contract checks passed. Native Windows UI, COM and installer execution are separate checks.");
