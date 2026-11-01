using System.Collections.Concurrent;
using System.Text;
using System.Text.Json;
using System.Text.Json.Nodes;

namespace ImperialSchool.Views.Core;

public sealed record WeatherSession(JsonObject? Current, JsonObject? Forecast, WeatherFrame Frame, string Warning = "");
public sealed class WeatherSessions(string root, AssetStore assets)
{
    readonly ConcurrentDictionary<string, SemaphoreSlim> locks = new();
    readonly ConcurrentDictionary<string, DateTimeOffset> retry = new();
    readonly ConcurrentDictionary<string, JsonObject> observed = new();
    string PathFor(JsonObject c, string source, string format) => SafeFiles.Under(Path.Combine(root, "weather"), Weather.Text(c, "id") + "/" + source + "/" + format + ".json");
    public WeatherSession Cached(JsonObject c, string source, string format, DateTimeOffset now)
    {
        try
        {
            Weather.Source(c, source);
            var pair = JsonNode.Parse(File.ReadAllText(PathFor(c, source, format)))!;
            var p = pair["current"]?.AsObject(); var f = pair["forecast"]?.AsObject();
            if (observed.TryGetValue(PathFor(c, source, format), out var latest))
            {
                p = latest;
                if (f is not null && !Weather.Identity(latest, f)) f = null;
            }
            return new(p, f, Weather.Resolve(c, source, format, p, f, now));
        }
        catch (Exception e) when (e is InvalidDataException or IOException or UnauthorizedAccessException or JsonException or InvalidOperationException or KeyNotFoundException or NullReferenceException or FormatException) { return new(observed.GetValueOrDefault(PathFor(c, source, format)), null, new("missing", "Нет сохранённого прогноза", Refresh: now)); }
    }
    void Save(JsonObject c, string source, string format, JsonObject p, JsonObject? f, CancellationToken cancel)
    {
        cancel.ThrowIfCancellationRequested(); SafeFiles.Write(PathFor(c, source, format), new JsonObject { ["current"] = p.DeepClone(), ["forecast"] = f?.DeepClone() }.ToJsonString());
    }
    public DateTimeOffset RetryAt(JsonObject c, string source, string format) => retry.GetValueOrDefault(PathFor(c, source, format));
    public void Reconnect() => retry.Clear();
    public async Task<WeatherSession> Get(JsonObject c, string source, string format, bool force, CancellationToken cancel)
    {
        var key = PathFor(c, source, format); var gate = locks.GetOrAdd(key, _ => new(1, 1)); await gate.WaitAsync(cancel);
        try
        {
            var now = DateTimeOffset.UtcNow; var saved = Cached(c, source, format, now);
            if (!force && now < retry.GetValueOrDefault(key)) return saved;
            if (!force && saved.Frame.Refresh > now && saved.Frame.Status is not ("stale" or "missing")) return saved;
            var active = saved;
            try
            {
                var description = Weather.Source(c, source);
                for (var attempt = 0; attempt < 2; attempt++)
                {
                    var p = Weather.Current(JsonNode.Parse(Encoding.UTF8.GetString(await assets.Get(Weather.Text(description, "current_url"), 5_000_000, cancel)))!.AsObject(), c, source);
                    cancel.ThrowIfCancellationRequested(); observed[key] = p;
                    var old = active.Forecast is not null && Weather.Identity(p, active.Forecast) ? active.Forecast : null;
                    Save(c, source, format, p, old, cancel); active = Cached(c, source, format, now);
                    var f = Weather.Forecast(JsonNode.Parse(Encoding.UTF8.GetString(await assets.Get(Weather.Text(description["forecasts"], format), 5_000_000, cancel)))!.AsObject(), c, source, format);
                    if (!Weather.Identity(p, f)) continue;
                    Save(c, source, format, p, f, cancel); retry[key] = now.AddMinutes(1); return Cached(c, source, format, DateTimeOffset.UtcNow);
                }
                throw new InvalidDataException("Погода и прогноз разных ревизий. Повторю обновление.");
            }
            catch (OperationCanceledException) when (cancel.IsCancellationRequested) { throw; }
            catch (Exception e) when (e is InvalidDataException or IOException or UnauthorizedAccessException or HttpRequestException or OperationCanceledException or JsonException or InvalidOperationException or NullReferenceException or FormatException)
            {
                retry[key] = DateTimeOffset.UtcNow.AddMinutes(1);
                // A newly observed world/revision was saved before reading its forecast.
                // Cached() therefore cannot revive a forecast from the previous revision.
                active = Cached(c, source, format, DateTimeOffset.UtcNow);
                return active with { Warning = e.Message };
            }
        }
        finally { gate.Release(); }
    }
    public IEnumerable<ViewFile> ForecastFiles(DateTimeOffset now)
    {
        var folder = Path.Combine(root, "weather"); if (!Directory.Exists(folder)) return [];
        var files = new List<ViewFile>();
        foreach (var path in Directory.GetFiles(folder, "*.json", SearchOption.AllDirectories))
        {
            try
            {
                var pair = JsonNode.Parse(File.ReadAllText(path))!; var p = pair["current"]!.AsObject(); var f = pair["forecast"]!.AsObject();
                if (!Weather.Identity(p, f) || now >= Weather.Time(f["valid_until"])) continue;
                foreach (var row in f["intervals"]!.AsArray().Where(r => Weather.Text(r, "status") == "ready"))
                {
                    var file = row!["file"]!; var hash = Weather.Text(file, "sha256"); if (Catalogue.Hash.IsMatch(hash)) files.Add(new(Weather.Text(file, "url"), file["width"]!.GetValue<int>(), file["height"]!.GetValue<int>(), file["bytes"]!.GetValue<long>(), hash));
                }
            }
            catch (Exception e) when (e is InvalidDataException or IOException or JsonException or InvalidOperationException or NullReferenceException) { }
        }
        return files;
    }
    public HashSet<string> PackageVersions(DateTimeOffset now)
    {
        var versions = new HashSet<string>(); var folder = Path.Combine(root, "weather"); if (!Directory.Exists(folder)) return versions;
        foreach (var path in Directory.GetFiles(folder, "*.json", SearchOption.AllDirectories))
        {
            try { var pair = JsonNode.Parse(File.ReadAllText(path))!; var p = pair["current"]!.AsObject(); var f = pair["forecast"]!.AsObject(); if (Weather.Identity(p, f) && now < Weather.Time(f["valid_until"]) && f["package_version"] is not null) versions.Add(Weather.Text(f, "collection_id") + "/" + Weather.Text(f, "format") + "/" + Weather.Text(f, "package_version")); }
            catch (Exception e) when (e is InvalidDataException or IOException or JsonException or InvalidOperationException or NullReferenceException) { }
        }
        return versions;
    }
}
