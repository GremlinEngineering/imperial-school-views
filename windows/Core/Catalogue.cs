using System.Text.Json.Nodes;
using System.Text.RegularExpressions;

namespace ImperialSchool.Views.Core;

public sealed record ViewFile(string Url, int Width, int Height, long Bytes, string Sha256)
{
    public double Ratio => (double)Width / Height;
}
public sealed record Scene(string Id, string Collection, string Title, string Preview, IReadOnlyList<ViewFile> Files)
{
    public ViewFile Desktop(int width, int height, string format = "auto")
    {
        var rows = Files.Where(f => f.Width > f.Height);
        if (format != "auto")
        {
            var ratio = format switch { "16:10" => 1.6, "16:9" => 16.0 / 9, "ultrawide" => 3440.0 / 1440, _ => throw new InvalidDataException("Неизвестный формат") };
            rows = rows.Where(f => Math.Abs(f.Ratio - ratio) < 0.01);
        }
        var screenRatio = (double)Math.Max(1, width) / Math.Max(1, height);
        return rows.OrderBy(f => Math.Abs(Math.Log(f.Ratio / screenRatio)))
            .ThenByDescending(f => (long)f.Width * f.Height).FirstOrDefault()
            ?? throw new InvalidDataException("В коллекции нет выбранного формата: " + Title);
    }
}
public sealed record Collection(string Id, string Title, Dictionary<string, Dictionary<string, string>> Schedule, JsonObject? Weather = null)
{
    public string[] Modes => Weather is not null ? ["weather"] : new[] { "monthly", "seasonal" }.Where(Schedule.ContainsKey).Append("daily").ToArray();
}
public sealed record Catalogue(IReadOnlyList<Collection> Collections, IReadOnlyList<Scene> Scenes, string? Featured, IReadOnlyList<JsonObject>? Downloads = null)
{
    public static readonly Regex PackId = new(@"\A[a-z0-9][a-z0-9-]{0,79}\z", RegexOptions.CultureInvariant);
    static readonly Regex SceneId = new(@"\A[a-z0-9][a-z0-9-]{0,161}\z", RegexOptions.CultureInvariant);
    public static readonly Regex Hash = new(@"\A[a-f0-9]{64}\z", RegexOptions.CultureInvariant);
    public static readonly Regex LocalPicture = new(@"\A(?:files|previews)/[a-z0-9-]+\.jpg\z", RegexOptions.CultureInvariant);
    public Scene Choose(string collection, string mode, DateOnly date)
    {
        if (mode == "featured") return Scenes.FirstOrDefault(s => s.Id == Featured) ?? throw new InvalidDataException("Сайт ещё не опубликовал обои дня");
        var pack = Collections.FirstOrDefault(c => c.Id == collection) ?? throw new InvalidDataException("Коллекция недоступна. Выберите другую.");
        var rows = Scenes.Where(s => s.Collection == collection).ToArray();
        if (mode == "daily")
        {
            var days = date.DayNumber - new DateOnly(1970, 1, 1).DayNumber;
            return rows[((days % rows.Length) + rows.Length) % rows.Length];
        }
        var period = mode switch
        {
            "monthly" => date.Month.ToString(System.Globalization.CultureInfo.InvariantCulture),
            "seasonal" => date.Month switch { >= 3 and <= 5 => "spring", >= 6 and <= 8 => "summer", >= 9 and <= 11 => "autumn", _ => "winter" },
            _ => throw new InvalidDataException("Неизвестное расписание")
        };
        if (!pack.Schedule.TryGetValue(mode, out var table) || !table.TryGetValue(period, out var id)) throw new InvalidDataException("Нет изображения для текущего периода");
        return rows.First(s => s.Id == id);
    }
    public static void Require(bool ok, string message) { if (!ok) throw new InvalidDataException(message); }
    static string Text(JsonNode node, string key) => node[key]?.GetValue<string>() ?? throw new InvalidDataException("Нет поля: " + key);
    static bool ValidText(string s) => !string.IsNullOrWhiteSpace(s) && s.Length <= 300;
    public static Catalogue Parse(string text)
    {
        var root = JsonNode.Parse(text) ?? throw new InvalidDataException("Пустой каталог");
        Require(root["schema"]?.GetValue<int>() == 3, "Неверный каталог API 1.7");
        var packs = new List<Collection>(); var scenes = new List<Scene>();
        foreach (var value in root["collections"]?.AsArray() ?? throw new InvalidDataException("Нет коллекций"))
        {
            var c = value ?? throw new InvalidDataException("Неверная коллекция");
            var schedule = new Dictionary<string, Dictionary<string, string>>();
            foreach (var pair in (c["schedule"] ?? root["schedule"])?.AsObject() ?? new JsonObject())
                schedule[pair.Key] = pair.Value!.AsObject().ToDictionary(p => p.Key, p => p.Value!.GetValue<string>());
            var weather = c["type"]?.GetValue<string>() is "weather" or "dynamic" ? c.AsObject() : null;
            if (weather is not null) Weather.ValidateCollection(weather);
            packs.Add(new Collection(Text(c, "id"), Text(c, "title"), schedule, weather));
        }
        Require(packs.Count is > 0 and <= 500 && packs.Select(c => c.Id).Distinct().Count() == packs.Count, "Неверный список коллекций");
        foreach (var c in packs) Require(PackId.IsMatch(c.Id) && ValidText(c.Title), "Неверное описание коллекции");
        foreach (var value in root["items"]?.AsArray() ?? throw new InvalidDataException("Нет видов"))
        {
            var item = value ?? throw new InvalidDataException("Неверный вид");
            var files = (item["files"]?.AsArray() ?? throw new InvalidDataException("Нет файлов")).Select(f => new ViewFile(Text(f!, "url"), f!["width"]!.GetValue<int>(), f["height"]!.GetValue<int>(), f["bytes"]!.GetValue<long>(), Text(f, "sha256"))).ToArray();
            scenes.Add(new Scene(Text(item, "id"), Text(item, "collection"), Text(item, "title"), Text(item, "preview"), files));
        }
        Require(scenes.Count <= 5000 && (scenes.Count > 0 || packs.Any(c => c.Weather is not null)) && scenes.Select(s => s.Id).Distinct().Count() == scenes.Count, "Неверный список видов");
        foreach (var s in scenes)
        {
            Require(SceneId.IsMatch(s.Id) && packs.Any(c => c.Id == s.Collection) && ValidText(s.Title), "Неверное описание вида");
            var prefix = "collections/" + s.Collection + "/";
            Require(s.Preview.StartsWith(prefix + "previews/", StringComparison.Ordinal) && LocalPicture.IsMatch(s.Preview[prefix.Length..]), "Неверное превью");
            Require(s.Files.Count is > 0 and <= 20 && s.Files.Select(f => f.Url).Distinct().Count() == s.Files.Count, "Неверный список файлов");
            foreach (var f in s.Files)
                Require(f.Url.StartsWith(prefix + "files/", StringComparison.Ordinal) && LocalPicture.IsMatch(f.Url[prefix.Length..]) && f.Width is >= 640 and <= 16384 && f.Height is >= 360 and <= 16384 && f.Bytes is > 0 and <= 100_000_000 && Hash.IsMatch(f.Sha256), "Неверный файл изображения");
            Require(s.Files.Any(f => f.Width > f.Height), "В коллекции нет обоев для компьютера");
        }
        foreach (var c in packs)
        {
            if (c.Weather is not null) continue;
            Require(scenes.Any(s => s.Collection == c.Id), "Пустая коллекция");
            foreach (var (mode, table) in c.Schedule)
            {
                var periods = mode switch { "monthly" => Enumerable.Range(1, 12).Select(x => x.ToString()).ToArray(), "seasonal" => ["winter", "spring", "summer", "autumn"], _ => throw new InvalidDataException("Неизвестное расписание") };
                Require(table.Keys.ToHashSet().SetEquals(periods) && table.Values.All(id => scenes.Any(s => s.Id == id && s.Collection == c.Id)), "Неполное расписание");
            }
        }
        var featured = root["wallpaper_of_day"]?["item_id"]?.GetValue<string>();
        Require(featured is null || scenes.Any(s => s.Id == featured), "В каталоге отсутствуют обои дня");
        return new Catalogue(packs, scenes, featured, root["downloads"]?.AsArray().Select(n => n!.AsObject()).ToArray() ?? []);
    }
    public static string Compose(IEnumerable<string> documents)
    {
        var packs = documents.Select(d => JsonNode.Parse(d) ?? throw new InvalidDataException("Пустой пакет")).OrderBy(p => Text(p, "id")).ToArray();
        var collections = new JsonArray(); var items = new JsonArray();
        foreach (var p in packs)
        {
            if (p["enabled"]?.GetValue<bool>() == false) continue;
            var id = Text(p, "id"); Require(p["schema"]?.GetValue<int>() == 1 && PackId.IsMatch(id), "Неверный пакет");
            var schedule = new JsonObject(); var prefix = "collections/" + id + "/";
            foreach (var (mode, values) in p["schedule"]?.AsObject() ?? new JsonObject())
            {
                var table = new JsonObject();
                foreach (var (period, value) in values!.AsObject()) table[period] = id + "--" + value!.GetValue<string>();
                schedule[mode] = table;
            }
            collections.Add(new JsonObject { ["id"] = id, ["title"] = Text(p, "title"), ["schedule"] = schedule });
            foreach (var original in p["items"]?.AsArray() ?? throw new InvalidDataException("Нет видов"))
            {
                var item = original!.DeepClone(); var local = Text(item, "id"); var preview = Text(item, "preview");
                Require(PackId.IsMatch(local) && preview.StartsWith("previews/", StringComparison.Ordinal) && LocalPicture.IsMatch(preview), "Неверный вид пакета");
                item["id"] = id + "--" + local; item["collection"] = id; item["preview"] = prefix + preview;
                foreach (var f in item["files"]!.AsArray())
                {
                    var url = Text(f!, "url"); Require(url.StartsWith("files/", StringComparison.Ordinal) && LocalPicture.IsMatch(url), "Неверный путь пакета"); f!["url"] = prefix + url;
                }
                items.Add(item);
            }
        }
        var json = new JsonObject { ["schema"] = 3, ["collections"] = collections, ["items"] = items }.ToJsonString();
        Parse(json); return json;
    }
}
