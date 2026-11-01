using System.IO.Compression;
using System.Security.Cryptography;
using System.Text;
using System.Text.Json.Nodes;

namespace ImperialSchool.Views.Core;

public static class SafeFiles
{
    public static string Under(string root, string relative)
    {
        Catalogue.Require(!Path.IsPathRooted(relative) && !relative.Contains('\\') && !relative.Split('/').Any(p => p is "." or ".." or ""), "Неверный путь");
        var full = Path.GetFullPath(Path.Combine(root, relative));
        Catalogue.Require(full.StartsWith(Path.GetFullPath(root) + Path.DirectorySeparatorChar, StringComparison.OrdinalIgnoreCase), "Путь выходит за коллекцию");
        return full;
    }
    public static string Sha(string path) { using var s = File.OpenRead(path); return Convert.ToHexStringLower(SHA256.HashData(s)); }
    public static void Write(string path, string text)
    {
        Directory.CreateDirectory(Path.GetDirectoryName(path)!); var temporary = path + "." + Guid.NewGuid().ToString("N") + ".tmp";
        try
        {
            using (var stream = new FileStream(temporary, FileMode.CreateNew, FileAccess.Write, FileShare.None))
            { var b = Encoding.UTF8.GetBytes(text); stream.Write(b); stream.Flush(true); }
            File.Move(temporary, path, true);
        }
        finally { if (File.Exists(temporary)) File.Delete(temporary); }
    }
}
public static class Packages
{
    public static string Import(string archivePath, string collectionsRoot, Action<string, int?, int?> validateImage)
    {
        Directory.CreateDirectory(collectionsRoot);
        var stage = Path.Combine(collectionsRoot, ".import-" + Guid.NewGuid().ToString("N")); Directory.CreateDirectory(stage);
        try
        {
            using (var archive = ZipFile.OpenRead(archivePath))
            {
                Catalogue.Require(archive.Entries.Count is > 0 and <= 1000, "Слишком много файлов в ZIP");
                var names = new HashSet<string>(StringComparer.OrdinalIgnoreCase); long total = 0;
                foreach (var entry in archive.Entries)
                {
                    var name = entry.FullName;
                    if (name is "files/" or "previews/") continue;
                    Catalogue.Require(name is "manifest.json" or "README.txt" or "collection.md" || Catalogue.LocalPicture.IsMatch(name), "Неизвестный файл в ZIP: " + name);
                    Catalogue.Require(names.Add(name) && entry.Length is >= 0 and <= 100_000_000 && (total += entry.Length) <= 1_000_000_000, "Неверный размер или повтор файла в ZIP");
                    Catalogue.Require(name != "manifest.json" || entry.Length <= 5_000_000, "Слишком большой манифест");
                    var destination = SafeFiles.Under(stage, name); Directory.CreateDirectory(Path.GetDirectoryName(destination)!);
                    using var source = entry.Open(); using var output = File.Create(destination);
                    var buffer = new byte[65536]; long written = 0; int count;
                    while ((count = source.Read(buffer)) > 0)
                    { written += count; Catalogue.Require(written <= entry.Length, "Неверный размер файла ZIP"); output.Write(buffer, 0, count); }
                    Catalogue.Require(written == entry.Length, "Неполный файл ZIP");
                }
            }
            var manifest = File.ReadAllText(Path.Combine(stage, "manifest.json"));
            var parsed = Catalogue.Parse(Catalogue.Compose([manifest]));
            Catalogue.Require(parsed.Collections.Count == 1, "ZIP должен содержать одну коллекцию");
            var id = parsed.Collections[0].Id; var prefix = "collections/" + id + "/";
            var keep = new HashSet<string>(StringComparer.OrdinalIgnoreCase) { "manifest.json" };
            foreach (var scene in parsed.Scenes)
            {
                var preview = scene.Preview[prefix.Length..]; validateImage(SafeFiles.Under(stage, preview), null, null); keep.Add(preview);
                foreach (var f in scene.Files)
                {
                    var relative = f.Url[prefix.Length..]; var path = SafeFiles.Under(stage, relative);
                    Catalogue.Require(File.Exists(path) && new FileInfo(path).Length == f.Bytes && SafeFiles.Sha(path) == f.Sha256, "Повреждён файл: " + relative);
                    validateImage(path, f.Width, f.Height);
                    if (f.Width > f.Height) keep.Add(relative);
                }
            }
            // Verify the whole package first; only desktop originals and previews are retained.
            foreach (var path in Directory.GetFiles(stage, "*", SearchOption.AllDirectories))
                if (!keep.Contains(Path.GetRelativePath(stage, path).Replace('\\', '/'))) File.Delete(path);
            var target = Path.Combine(collectionsRoot, id); var backup = Path.Combine(collectionsRoot, ".backup-" + Guid.NewGuid().ToString("N"));
            if (Directory.Exists(target)) Directory.Move(target, backup);
            try { Directory.Move(stage, target); }
            catch { if (Directory.Exists(backup)) Directory.Move(backup, target); throw; }
            if (Directory.Exists(backup)) { try { Directory.Delete(backup, true); } catch (IOException) { /* harmless backup; discovery ignores it */ } }
            return id;
        }
        finally { if (Directory.Exists(stage)) Directory.Delete(stage, true); }
    }
    public static string? Discover(string root)
    {
        if (!Directory.Exists(root)) return null;
        var documents = Directory.GetDirectories(root).Where(p => Catalogue.PackId.IsMatch(Path.GetFileName(p))).Select(p =>
        {
            var text = File.ReadAllText(Path.Combine(p, "manifest.json")); var node = JsonNode.Parse(text)!;
            Catalogue.Require(node["id"]!.GetValue<string>() == Path.GetFileName(p), "ID коллекции не совпадает с папкой"); return text;
        }).ToArray();
        return documents.Length == 0 ? null : Catalogue.Compose(documents);
    }
}
public sealed record AppRelease(string Version, int Build, string Sha256, long Bytes, string Url)
{
    public const string AppId = "ru.oopssre.imperial-school.views.windows";
    public static AppRelease? Parse(string text)
    {
        var root = JsonNode.Parse(text)!;
        Catalogue.Require(root["schema"]?.GetValue<int>() == 1 && root["app_id"]?.GetValue<string>() == AppId && root["platform"]?.GetValue<string>() == "windows", "Неверные сведения об обновлении");
        if (root["release"] is not JsonObject r) return null;
        var version = r["version"]!.GetValue<string>(); var build = r["build"]!.GetValue<int>(); var sha = r["sha256"]!.GetValue<string>(); var bytes = r["bytes"]!.GetValue<long>(); var url = r["url"]!.GetValue<string>();
        Catalogue.Require(System.Text.RegularExpressions.Regex.IsMatch(version, @"\A(?:0|[1-9][0-9]{0,8})(?:\.(?:0|[1-9][0-9]{0,8})){2}\z") && build > 0 && Catalogue.Hash.IsMatch(sha) && bytes is > 0 and <= 9_007_199_254_740_991, "Неверная версия приложения");
        Catalogue.Require(Uri.TryCreate(url, UriKind.Absolute, out var u) && u.Scheme == "https" && u.Host == "games.oopssre.ru" && u.IsDefaultPort && u.UserInfo == "" && u.Query == "" && u.Fragment == "", "Неверная ссылка обновления");
        Catalogue.Require(u!.AbsolutePath.StartsWith("/assets/arcade/views/downloads/", StringComparison.Ordinal), "Неверная ссылка установщика");
        var name = Uri.UnescapeDataString(u.AbsolutePath["/assets/arcade/views/downloads/".Length..]);
        Catalogue.Require(u.AbsolutePath.StartsWith("/assets/arcade/views/downloads/", StringComparison.Ordinal) && name.Length > 4 && name.EndsWith(".exe", StringComparison.OrdinalIgnoreCase) && !name.Any(c => c is '/' or '\\' || char.IsControl(c)), "Неверный установщик");
        return new AppRelease(version, build, sha, bytes, url);
    }
    public bool NewerThan(string version, int build)
    { var order = System.Version.Parse(Version).CompareTo(System.Version.Parse(version)); return order > 0 || order == 0 && Build > build; }
}
