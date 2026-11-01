using System.Globalization;
using System.Text.Json.Nodes;
using System.Text.RegularExpressions;

namespace ImperialSchool.Views.Core;

public sealed record WeatherSize(string Id, int Width, int Height);
public sealed record ArchiveDescriptor(string Url, long Bytes, string Sha256, string Version);
public sealed record WeatherVariant(ViewFile File, string StateId, string MoonPhase);
public sealed record WeatherFrame(string Status, string Title, ViewFile? File = null, string StateId = "", string MoonPhase = "", string Season = "", string TimeOfDay = "", string WorldDate = "", string Condition = "", DateTimeOffset Next = default, DateTimeOffset Refresh = default, string? PackageVersion = null)
{
    public string Details
    {
        get
        {
            static string Label(string id) => id switch { "winter" => "Зима", "spring" => "Весна", "summer" => "Лето", "autumn" => "Осень", "dawn" => "Рассвет", "day" => "День", "dusk" => "Закат", "night" => "Ночь", "clear" => "Ясно", "partly-cloudy" => "Переменная облачность", "overcast" => "Пасмурно", "rain" => "Дождь", "snow" => "Снег", "fog" => "Туман", "drizzle" => "Морось", "heavy-rain" => "Сильный дождь", "heavy-snow" => "Сильный снег", "freezing-precipitation" => "Ледяные осадки", "thunderstorm" => "Гроза", "thunderstorm-hail" => "Гроза с градом", "severe-thunderstorm" => "Сильная гроза", _ => id };
            var date = DateOnly.TryParseExact(WorldDate, "yyyy-MM-dd", CultureInfo.InvariantCulture, DateTimeStyles.None, out var d) ? d.ToString("d MMMM yyyy", CultureInfo.GetCultureInfo("ru-RU")) : "";
            return string.Join(" · ", new[] { Title, Label(Season), date, Label(TimeOfDay), Label(Condition) }.Where(s => s.Length > 0));
        }
    }
}

public static class Weather
{
    public static string Text(JsonNode? n, string key) => n?[key]?.GetValue<string>() ?? "";
    public static DateTimeOffset Time(JsonNode? n) => DateTimeOffset.TryParse(n?.GetValue<string>(), CultureInfo.InvariantCulture, DateTimeStyles.None, out var t) ? t : DateTimeOffset.MinValue;
    static void Require(bool ok, string message) => Catalogue.Require(ok, message);
    public static WeatherSize[] Sizes(JsonObject c) => c["formats"]!.AsObject().Select(p => new WeatherSize(p.Key, p.Value!["width"]!.GetValue<int>(), p.Value["height"]!.GetValue<int>())).ToArray();
    public static WeatherSize Format(JsonObject c, string requested, int width, int height)
    {
        var all = Sizes(c); var selected = all.FirstOrDefault(f => f.Id == requested);
        Require(selected is null || selected.Width > selected.Height, "Телефонный формат недоступен для рабочего стола");
        return selected ?? all.Where(f => f.Width > f.Height).OrderBy(f => Math.Abs(Math.Log(((double)f.Width / f.Height) / ((double)Math.Max(width, 1) / Math.Max(height, 1))))).ThenByDescending(f => (long)f.Width * f.Height).FirstOrDefault() ?? throw new InvalidDataException("В наборе нет обоев для компьютера");
    }
    public static JsonObject Source(JsonObject c, string source) => c["sources"]!.AsArray().Select(n => n!.AsObject()).SingleOrDefault(n => Text(n, "id") == source) ?? throw new InvalidDataException("Источник погоды недоступен");
    public static void ValidateCollection(JsonObject c)
    {
        var id = Text(c, "id"); Require(Catalogue.PackId.IsMatch(id), "Неверная погодная коллекция");
        var sizes = Sizes(c); Require(sizes.Length is > 0 and <= 20, "Неверные форматы");
        foreach (var f in sizes) Require(System.Text.RegularExpressions.Regex.IsMatch(f.Id,"^[a-z0-9][a-z0-9_-]{0,79}$") && f.Width is > 0 and <= 16384 && f.Height is > 0 and <= 16384, "Неверный размер формата");
        if (Text(c, "type") == "dynamic") { CurrentFrames.ValidateCollection(c); return; }
        var sources = c["sources"]!.AsArray(); Require(sources.Count is > 0 and <= 2 && sources.Select(n => Text(n, "id")).Distinct().Count() == sources.Count, "Неверные источники");
        foreach (var s in sources)
        {
            var source = Text(s, "id"); var prefix = "weather/" + id + "/" + (source == "game-world" ? "sources/game-world/" : "");
            Require(source is "real" or "game-world" && CurrentFrames.Endpoint(Text(s, "current_url"), prefix + "current.json"), "Неверный адрес погоды");
            foreach (var f in sizes) Require(CurrentFrames.Endpoint(Text(s!["forecasts"], f.Id), prefix + "forecast-" + f.Id + ".json"), "Неверный адрес прогноза");
        }
    }
    public static JsonObject Current(JsonObject p, JsonObject c, string source)
    {
        Require(p["schema"]?.GetValue<int>() == 1 && Text(p, "type") == "weather" && Text(p, "collection_id") == Text(c, "id") && Text(p, "source_id") == source && Text(p, "location_revision").Length > 0 && Text(p, "timezone").Length > 0, "Неверная текущая погода"); return p;
    }
    public static ViewFile File(JsonNode f, JsonObject c, string format)
    {
        var size = Sizes(c).Single(s => s.Id == format); var path = Text(f, "url");
        Require(Regex.IsMatch(path, "\\Acollections/" + Regex.Escape(Text(c, "id")) + "/files/[a-z0-9-]+-" + Regex.Escape(format) + "\\.jpg\\z") && Text(f, "format") == "jpeg" && Text(f, "rendition") == format, "Неверный погодный JPEG");
        var file = new ViewFile(path, f["width"]!.GetValue<int>(), f["height"]!.GetValue<int>(), f["bytes"]!.GetValue<long>(), Text(f, "sha256"));
        Require(file.Width == size.Width && file.Height == size.Height && file.Bytes is > 0 and <= 100_000_000 && Catalogue.Hash.IsMatch(file.Sha256), "Неверные сведения о JPEG"); return file;
    }
    public static JsonObject Forecast(JsonObject f, JsonObject c, string source, string format)
    {
        Require(f["schema"]?.GetValue<int>() == 1 && Text(f, "document_type") == "weather-forecast" && Text(f, "collection_id") == Text(c, "id") && Text(f, "source_id") == source && Text(f, "format") == format && Text(f, "location_revision").Length > 0, "Неверный прогноз");
        if (Text(f, "status") == "unavailable") return f;
        Require(Time(f["generated_at"]) > DateTimeOffset.MinValue && Time(f["valid_until"]) > Time(f["generated_at"]) && f.ContainsKey("contract_version") && f.ContainsKey("package_version") && (f["package_version"] is null || Text(f, "package_version").Length > 0), "Неверный срок или версия прогноза");
        var rows = f["intervals"]!.AsArray(); Require(rows.Count <= 2000, "Слишком большой прогноз");
        foreach (var row in rows)
        {
            Require(row is not null && Time(row["valid_from"]) > DateTimeOffset.MinValue && Time(row["valid_until"]) > Time(row["valid_from"]), "Неверный интервал");
            if (Text(row, "status") == "ready") { File(row!["file"]!, c, format); Require(Text(row, "state_id").Length > 0 && Text(row, "moon_phase").Length > 0, "Нет состояния кадра"); }
        }
        return f;
    }
    public static bool Identity(JsonObject a, JsonObject b) => new[] { "collection_id", "source_id", "world_id", "location_revision" }.All(k => Text(a, k) == Text(b, k));
    public static WeatherFrame Resolve(JsonObject c, string source, string format, JsonObject? current, JsonObject? forecast, DateTimeOffset now)
    {
        if (current is null || forecast is null) return new("missing", "Нет погодных данных", Refresh: now);
        var p = Current(current, c, source); var f = Forecast(forecast, c, source, format);
        string First(params string[] a) => a.FirstOrDefault(s => !string.IsNullOrWhiteSpace(s)) ?? "";
        var title = source == "real" ? "Погода Столицы Империи" : First(Text(p["source"], "setting"), Text(p["source"], "name"), "Игровой мир");
        var refresh = new[] { Time(p["refresh_after"]), Time(f["refresh_after"]) }.Where(t => t > DateTimeOffset.MinValue).DefaultIfEmpty(now).Min();
        WeatherFrame Empty(string status) => new(status, title, Refresh: refresh);
        if (!Identity(p, f) || Text(f, "status") != "unavailable" && Text(p, "timezone") != Text(f, "timezone")) return Empty("stale") with { Refresh = now };
        if (Text(p, "status") == "unavailable" || Text(f, "status") == "unavailable") return Empty("unavailable");
        if (Text(p, "status") is not ("ready" or "not_ready" or "stale" or "unresolved_weather")) return Empty("not_ready");
        if (now < Time(f["generated_at"]) || now >= Time(f["valid_until"])) return Empty("stale");
        var rows = f["intervals"]!.AsArray(); var selected = rows.Where(r => Time(r!["valid_from"]) <= now && now < Time(r["valid_until"])).ToArray();
        var next = rows.SelectMany(r => new[] { Time(r!["valid_from"]), Time(r["valid_until"]) }).Append(Time(f["valid_until"])).Where(t => t > now).DefaultIfEmpty(now.AddMinutes(1)).Min();
        if (selected.Length != 1) return Empty("not_ready") with { Next = next };
        var row = selected[0]!; var ready = Text(row, "status") == "ready";
        return new(ready ? "ready" : "not_ready", title, ready ? File(row["file"]!, c, format) : null, Text(row, "state_id"), Text(row, "moon_phase"), Text(row, "season"), Text(row, "time_of_day"), Text(row, "world_date"), Text(row, "weather"), next, refresh, f["package_version"]?.GetValue<string>());
    }
    public static ArchiveDescriptor Descriptor(Catalogue data, JsonObject c, string format)
    {
        var rows = (data.Downloads ?? []).Where(n => Text(n, "collection") == Text(c, "id") && Text(n, "format") == "zip" && Text(n, "rendition") == format).ToArray();
        Require(rows.Length == 1, "ZIP выбранного формата пока не опубликован"); var d = rows[0];
        var a = new ArchiveDescriptor(Text(d, "url"), d["bytes"]!.GetValue<long>(), Text(d, "sha256"), Text(d, "version"));
        Require(a.Url == "downloads/weather-" + Text(c, "id") + "-" + format + ".zip" && a.Bytes is > 0 and <= 8_589_934_592 && Catalogue.Hash.IsMatch(a.Sha256) && a.Version.Length > 0, "Неверные сведения о погодном ZIP"); return a;
    }
    public static WeatherVariant[] Package(JsonObject p, JsonObject c, string format, string version)
    {
        Require(p["schema"]?.GetValue<int>() == 3 && Text(p, "document_type") == "weather-wallpaper-package" && Text(p, "type") == "weather" && Text(p, "id") == Text(c, "id") && Text(p, "format") == format && Text(p, "version") == version, "ZIP другой коллекции, формата или версии");
        var rows = p["variants"]!.AsArray(); Require(rows.Count is > 0 and <= 8000, "Пустой или слишком большой ZIP");
        var variants = rows.Select(n =>
        {
            var path = Text(n, "url"); Require(Regex.IsMatch(path, "\\Afiles/[a-z0-9-]+\\.jpg\\z") && Text(n, "state_id").Length > 0 && Text(n, "moon_phase").Length > 0, "Неверный файл ZIP");
            var copy = n!.DeepClone(); copy["url"] = "collections/" + Text(c, "id") + "/files/validated-" + format + ".jpg";
            var f = File(copy, c, format); return new WeatherVariant(f with { Url = path }, Text(n, "state_id"), Text(n, "moon_phase"));
        }).ToArray();
        Require(variants.Select(v => v.File.Url).Distinct(StringComparer.OrdinalIgnoreCase).Count() == variants.Length && variants.Sum(v => v.File.Bytes) <= 8_589_934_592, "Повтор файлов или слишком большой ZIP"); return variants;
    }
}
