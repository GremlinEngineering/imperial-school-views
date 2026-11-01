using ImperialSchool.Views.Core;
using System.Text.Json.Nodes;

namespace ImperialSchool.Views;

internal sealed partial class Engine
{
    async Task TickWeather(Catalogue data, Settings selected, bool force, bool cached, CancellationToken token)
    {
        if(selected.Collection=="__weather_day__") {await TickCurrent(data,selected,force,token);return;}
        var c = data.Collections.SingleOrDefault(p => p.Id == selected.Collection)?.Weather ?? throw new InvalidDataException("Погодная коллекция недоступна");
        if(Weather.Text(c,"type")=="dynamic"||selected.WeatherSource=="open-meteo") {await TickCurrent(data,selected,force,token);return;}
        using var desktop = new WallpaperDesktop(); var monitors = desktop.Monitors(); var targets = Targets(monitors, selected);
        if (!force && TakenOver(desktop, monitors)) { PauseForExternal(); return; }
        var ready = new List<Plan>(); var sessions = new Dictionary<string, WeatherSession>(); var next = new List<DateTimeOffset>();
        foreach (var monitor in targets)
        {
            var size = Weather.Format(c, selected.WeatherFormat, monitor.Width, monitor.Height); var format = size.Id;
            if (!sessions.TryGetValue(format, out var session))
            {
                session = await repo.Weather.Get(c, selected.WeatherSource, format, force || refreshWeather, token); sessions[format] = session;
            }
            var frame = session.Frame; WeatherView = frame.Status + "/" + frame.File?.Sha256 + "/" + frame.Details; var now = DateTimeOffset.UtcNow; if (frame.Next > now) next.Add(frame.Next);
            next.Add(new[] { frame.Refresh, repo.Weather.RetryAt(c, selected.WeatherSource, format), now.AddSeconds(1) }.Max());
            if (frame.Status != "ready")
            {
                NextRun = next.Min(); State.Status = "Сохранены последние обои. " + (frame.Status == "stale" ? "Прогноз закончился или изменился мир." : "Нет актуального погодного кадра.") + (session.Warning.Length > 0 ? " " + session.Warning.Truncate(150) : "");
                refreshWeather = false; return;
            }
            State.Status = "Загружаю текущий погодный кадр…"; changed(); string path;
            try { path = await repo.Assets.Picture(frame.File!, token); }
            catch (PublishedAssetChanged)
            {
                State.CatalogueChecked = default; session = await repo.Weather.Get(c, selected.WeatherSource, format, true, token); sessions[format] = session; frame = session.Frame;
                Catalogue.Require(frame.Status == "ready", "Файл обновился; новый кадр пока недоступен"); path = await repo.Assets.Picture(frame.File!, token);
            }
            ready.Add(new(monitor, frame.File!, path, format));
        }
        refreshWeather = false;
        // Network reads or downloads may have crossed a real interval boundary or observed a new revision.
        foreach (var plan in ready)
        {
            var current = repo.Weather.Cached(c, selected.WeatherSource, plan.WeatherFormat, DateTimeOffset.UtcNow).Frame;
            if (current.Status != "ready" || current.File?.Sha256 != plan.File.Sha256) { NextRun = DateTimeOffset.MinValue; State.Status = "Погодный кадр сменился. Получаю актуальный…"; return; }
        }
        if (!Apply(desktop, monitors, ready, selected, force, token)) return;
        NextRun = next.Where(t => t > DateTimeOffset.UtcNow).DefaultIfEmpty(DateTimeOffset.UtcNow.AddSeconds(1)).Min();
        foreach(var session in sessions.Values) repo.Remember(session.Frame,selected.Collection);
        var captions = sessions.Values.Select(s => s.Frame.Details).Distinct();
        State.Status = string.Join(" / ", captions) + " · обои установлены" + (cached || sessions.Values.Any(s => s.Warning.Length > 0) ? " · используется сохранённый прогноз" : "");
        foreach (var (format, session) in sessions) StartPreparation(data, c, format, session, selected, force, token);
        repo.Prune(monitors.Select(m => desktop.Wallpaper(m.Id)).Concat(State.Owned.Select(o => o.Path)));
    }
    sealed class Preparation(string version, CancellationTokenSource cancellation)
    {
        public string Version { get; } = version;
        public CancellationTokenSource Cancellation { get; } = cancellation;
        public Task Task { get; set; } = Task.CompletedTask;
    }
    void StartPreparation(Catalogue data, JsonObject collection, string format, WeatherSession session, Settings selected, bool force, CancellationToken token)
    {
        var scope = "weather/" + selected.Collection + "/" + format;
        var versionKey = selected.WeatherDelivery + "/" + session.Frame.PackageVersion;
        if (archiveTasks.TryGetValue(scope, out var running) && !running.Task.IsCompleted)
        {
            if (running.Version == versionKey) return;
            running.Cancellation.Cancel();
        }
        var cancellation = CancellationTokenSource.CreateLinkedTokenSource(token); var jobToken = cancellation.Token;
        var job = new Preparation(versionKey, cancellation); archiveTasks[scope] = job;
        var ownedCollection = (JsonObject)collection.DeepClone();
        job.Task = Prepare();
        async Task Prepare()
        {
            try
            {
                void Progress(TransferProgress p)
                {
                    if (jobToken.IsCancellationRequested || token.IsCancellationRequested) return;
                    if (p.Stage == "ready" && selected.WeatherSource != "open-meteo" && repo.Weather.Cached(ownedCollection, selected.WeatherSource, format, DateTimeOffset.UtcNow).Frame.PackageVersion != session.Frame.PackageVersion)
                    {
                        Report(scope, new("outdated", "Версия ZIP изменилась", Message: "Получаю актуальные сведения; текущие обои сохранены.")); Interlocked.Exchange(ref reevaluate, 1); return;
                    }
                    Report(scope, p);
                }
                if (selected.WeatherDelivery == "zip" && session.Frame.PackageVersion is { } version)
                {
                    ArchiveDescriptor descriptor;
                    try { descriptor = Weather.Descriptor(data, ownedCollection, format); Catalogue.Require(descriptor.Version == version, "Версия ZIP изменилась"); }
                    catch (Exception e) when (e is InvalidDataException or IOException or InvalidOperationException)
                    {
                        Progress(new("pending", "Получаю сведения о ZIP"));
                        var fresh = await repo.CatalogueFor(selected, true, jobToken) ?? throw new InvalidDataException("Нет каталога ZIP");
                        var c = fresh.Collections.SingleOrDefault(p => p.Id == selected.Collection)?.Weather ?? throw new InvalidDataException("Нет погодной коллекции");
                        descriptor = Weather.Descriptor(fresh, c, format); State.CatalogueChecked = DateTimeOffset.UtcNow;
                    }
                    await repo.Assets.WeatherZip(ownedCollection, format, descriptor, version, force, Progress, jobToken);
                    // Disk retention is independent of applying another system wallpaper.
                    repo.Prune(State.Owned.Select(o => o.Path));
                }
                else
                {
                    Progress(new("images", "Загружаются отдельные JPEG"));
                    var following = session.Forecast?["intervals"]?.AsArray().FirstOrDefault(r => Weather.Text(r, "status") == "ready" && Weather.Time(r!["valid_from"]) > DateTimeOffset.UtcNow);
                    if (following?["file"] is { } file) await repo.Assets.Picture(Weather.File(file, ownedCollection, format), jobToken);
                }
            }
            catch (OperationCanceledException) when (jobToken.IsCancellationRequested) { }
            catch (Exception e)
            {
                Repository.Log(e); if (!token.IsCancellationRequested && !jobToken.IsCancellationRequested) Report(scope, new("error", "ZIP не готов", Message: Friendly(e)));
                if (e is PublishedAssetChanged && !jobToken.IsCancellationRequested && !token.IsCancellationRequested) { State.CatalogueChecked = default; refreshWeather = true; NextRun = DateTimeOffset.UtcNow.AddMinutes(1); }
            }
            finally { cancellation.Dispose(); }
        }
    }
}
