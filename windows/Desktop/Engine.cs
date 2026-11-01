using ImperialSchool.Views.Core;
using System.Reflection;
using Microsoft.Win32;

namespace ImperialSchool.Views;

internal static class AppInfo
{
    public static string Version => typeof(AppInfo).Assembly.GetName().Version!.ToString(3);
    public static int Build => System.Version.Parse(typeof(AppInfo).Assembly.GetCustomAttribute<AssemblyFileVersionAttribute>()!.Version).Revision;
    public static void Open(string url) => System.Diagnostics.Process.Start(new System.Diagnostics.ProcessStartInfo(url) { UseShellExecute = true });
}
internal static class Autostart
{
    const string Key = @"Software\Microsoft\Windows\CurrentVersion\Run";
    const string Name = "ImperialSchoolViews";
    public static bool Enabled { get { using var k = Registry.CurrentUser.OpenSubKey(Key); return k?.GetValue(Name) is string; } }
    public static void Set(bool enabled)
    {
        using var key = Registry.CurrentUser.CreateSubKey(Key);
        if (enabled) key.SetValue(Name, "\"" + Application.ExecutablePath + "\" --background"); else key.DeleteValue(Name, false);
    }
}
internal sealed partial class Engine
{
    readonly Repository repo; readonly Action changed; readonly Action<string,string> notify; readonly CancellationToken cancel;
    readonly SemaphoreSlim gate = new(1,1), updateGate = new(1,1);
    CancellationTokenSource selection;
    readonly System.Collections.Concurrent.ConcurrentDictionary<string,TransferProgress> transfers = new();
    readonly Dictionary<string,Preparation> archiveTasks = [];
    public Settings Settings { get; private set; }
    public State State { get; }
    public bool Busy { get; private set; }
    public bool CollectionBusy { get; private set; }
    public DateTimeOffset NextRun { get; private set; }
    public Catalogue? CurrentCatalogue { get; private set; }
    public long CatalogueRevision { get; private set; }
    bool refreshWeather = true;
    int reevaluate;
    public string WeatherView { get; private set; } = "";
    public Engine(Repository repository, Action onChanged, Action<string,string> onNotify, CancellationToken stopping)
    {
        repo=repository;changed=onChanged;notify=onNotify;cancel=stopping;selection=CancellationTokenSource.CreateLinkedTokenSource(stopping);
        Settings=repo.Read<Settings>("settings.json");State=repo.Read<State>("state.json");State.Owned ??= [];
    }
    public string TrayCaption {
        get {var profiles=Settings.SeparateMonitors?Settings.Profiles.Values.Where(p=>p.Manage):[Settings];var cities=profiles.Where(p=>p.Source=="weather"&&p.WeatherSource=="open-meteo"&&p.Collection!="__weather_day__").Select(p=>p.City?.Name).Where(n=>!string.IsNullOrWhiteSpace(n)).Distinct();return ("Виды Школы Империи"+(cities.Any()?" · "+string.Join(" / ",cities):"")+(Settings.Paused?" · пауза":"")).Truncate(63);}
    }
    public TransferProgress? Progress(string scope) => transfers.GetValueOrDefault(scope);
    void Report(string scope, TransferProgress progress) { transfers[scope]=progress;changed(); }
    public void PersistState() { repo.Write("state.json",State);changed(); }
    void NewSelection() { selection.Cancel();selection.Dispose();selection=CancellationTokenSource.CreateLinkedTokenSource(cancel);archiveTasks.Clear();NextRun=DateTimeOffset.MinValue; }
    public void Save(Settings settings,bool autostart)
    {
        ValidateSettings(settings);
        foreach(var p in settings.Profiles.Values) ValidateSettings(p);
        if(settings.SaverOwn&&settings.SaverScheduled){Catalogue.Require(settings.SaverProfile is not null,"Выберите отдельный профиль хранителя");ValidateSettings(settings.SaverProfile!);}
        Autostart.Set(autostart);repo.Write("settings.json",settings);NewSelection();Settings=settings;
        if(settings.SeparateMonitors) {var inventory=DisplayInventory.ByInterfacePath();State.Owned=State.Owned.Where(o=>MonitorProfiles.Get(settings,o.Monitor,inventory.GetValueOrDefault(o.Monitor)?.DeviceName).Manage).ToList();}
        else if(settings.Monitor!="all") {var inventory=DisplayInventory.ByInterfacePath();State.Owned=State.Owned.Where(o=>o.Monitor==settings.Monitor||inventory.GetValueOrDefault(o.Monitor)?.DeviceName==settings.Monitor).ToList();}
        refreshWeather=true;changed();
    }
    static void ValidateSettings(Settings s)
    {
        Catalogue.Require(s.Source is "day" or "online" or "local" or "weather" && s.Mode is "monthly" or "seasonal" or "daily" or "weather" && s.Format is "auto" or "16:10" or "16:9" or "ultrawide" && s.WeatherSource is "real" or "game-world" or "open-meteo" && s.WeatherDelivery is "zip" or "images" && (s.WeatherFormat=="auto" || System.Text.RegularExpressions.Regex.IsMatch(s.WeatherFormat,"^[a-z0-9][a-z0-9_-]{0,79}$")),"Неверные настройки");
        if(s.WeatherSource=="open-meteo"&&s.Source=="weather") (s.City??throw new InvalidDataException("Выберите город")).Validate();
    }
    public Settings Profile(string monitor) => MonitorProfiles.Get(Settings,monitor,DisplayInventory.ByInterfacePath().GetValueOrDefault(monitor)?.DeviceName);
    public void SaveProfile(Settings profile,bool separate,bool startup)
    {
        var identities=DisplayInventory.ByInterfacePath().Select(p=>new MonitorIdentity(p.Key,p.Value.DeviceName)).ToArray();
        Save(MonitorProfiles.Save(Settings,profile,separate,identities),startup);
    }
    public void SetPaused(bool paused)
    {
        NewSelection();Settings=Settings with {Paused=paused};repo.Write("settings.json",Settings);State.Status=paused?"Автоматическая смена приостановлена.":"Автоматическая смена включена.";PersistState();
    }
    public void InvalidateSchedule(bool reconnect=false) { NextRun=DateTimeOffset.MinValue;if(reconnect){repo.Weather.Reconnect();refreshWeather=true;} }
    public async Task<string> Import(string path)
    {
        await gate.WaitAsync(cancel);Busy=true;changed();
        try{return await Task.Run(()=>Packages.Import(path,repo.CollectionsRoot,Repository.ValidateImage),cancel);}
        finally{Busy=false;gate.Release();changed();}
    }
    public static ArchiveDescriptor OrdinaryArchive(Catalogue data,string collection)
    {
        Catalogue.Require(data.Collections.Any(c=>c.Id==collection && c.Weather is null),"Выберите обычную коллекцию");
        var rows=(data.Downloads??[]).Where(d=>Weather.Text(d,"id")=="collection-"+collection || Weather.Text(d,"collection")==collection && Weather.Text(d,"format")=="zip").ToArray();
        Catalogue.Require(rows.Length==1,"ZIP этой коллекции пока не опубликован");var d=rows[0];return new(Weather.Text(d,"url"),d["bytes"]!.GetValue<long>(),Weather.Text(d,"sha256"),"");
    }
    public async Task<string> DownloadCollection(Catalogue data,string collection)
    {
        Catalogue.Require(!CollectionBusy,"Коллекция уже загружается");CollectionBusy=true;changed();
        try{return await repo.Assets.OrdinaryZip(OrdinaryArchive(data,collection),collection,repo.CollectionsRoot,p=>Report("ordinary/"+collection,p),cancel);}
        catch(Exception e){Report("ordinary/"+collection,new("error","Не удалось скачать коллекцию",Message:Friendly(e)));throw;}
        finally{CollectionBusy=false;changed();}
    }
    void CollectionsChanged(Catalogue catalogue)
    {
        var ids=catalogue.Collections.Select(c=>c.Id).ToArray();
        if(State.KnownCollections is {} known)
        {
            var fresh=catalogue.Collections.Where(c=>!known.Contains(c.Id)).ToArray();if(fresh.Length>0 && Settings.NotifyCollections)notify("Новые коллекции",string.Join(" · ",fresh.Select(c=>c.Title)).Truncate(240));
            State.KnownCollections=known.Union(ids).TakeLast(5000).ToArray();
        }else State.KnownCollections=ids;
    }
    public async Task CheckUpdates(bool manual)
    {
        if(!manual && (!MonitorProfiles.Online(Settings) || DateTimeOffset.UtcNow>=State.UpdateChecked && DateTimeOffset.UtcNow-State.UpdateChecked<TimeSpan.FromHours(24)))return;
        if(!await updateGate.WaitAsync(0,cancel))return;
        try
        {
            var bytes=await repo.Download(Repository.Site+"windows-release.json",16384,cancel);var release=AppRelease.Parse(System.Text.Encoding.UTF8.GetString(bytes));State.UpdateChecked=DateTimeOffset.UtcNow;
            State.Release=release?.NewerThan(AppInfo.Version,AppInfo.Build)==true?release:null;
            if(State.Release is {} newer){var key=newer.Version+":"+newer.Build+":"+newer.Sha256;if(Settings.NotifyApp && State.NotifiedRelease!=key){notify("Новая версия приложения","Доступна версия "+newer.Version+". Ссылка на установщик — в окне приложения.");State.NotifiedRelease=key;}}
            else if(manual)State.Status="Установлена актуальная версия "+AppInfo.Version+".";PersistState();
        }
        catch(Exception e) when(e is not OperationCanceledException || !cancel.IsCancellationRequested){Repository.Log(e);State.UpdateChecked=DateTimeOffset.UtcNow-TimeSpan.FromHours(23);if(manual)State.Status="Не удалось проверить обновления. "+Friendly(e);PersistState();}
        finally{updateGate.Release();}
    }
    static DateTimeOffset NextDay() => new DateTimeOffset(DateTime.Today.AddDays(1)).ToUniversalTime();
    public async Task Tick(bool force=false)
    {
        if (Interlocked.Exchange(ref reevaluate, 0) != 0) NextRun=DateTimeOffset.MinValue;
        if(!force&&(!Settings.Enabled||Settings.Paused||DateTimeOffset.UtcNow<NextRun))return;
        if(!await gate.WaitAsync(0,cancel))return;
        var snapshot=Settings;var token=selection.Token;Busy=true;changed();
        try
        {
            using var desktop=new WallpaperDesktop();var monitors=desktop.Monitors();
            if(!force&&TakenOver(desktop,monitors)){PauseForExternal();return;}
            var profiles=snapshot.SeparateMonitors?monitors.Select(m=>(Monitor:m,Profile:MonitorProfiles.Get(snapshot,m.Id,m.DisplayName))).Where(p=>p.Profile.Manage).Select(p=>p.Profile with {Monitor=p.Monitor.Id}).ToArray():[snapshot];
            var due=new List<DateTimeOffset>();var messages=new List<string>();
            foreach(var profile in profiles)
            {
                token.ThrowIfCancellationRequested();
                try {await Evaluate(profile,force,token);due.Add(NextRun);messages.Add(State.Status);}
                catch(OperationCanceledException)when(token.IsCancellationRequested){throw;}
                catch(Exception e){Repository.Log(e);due.Add(DateTimeOffset.UtcNow.AddMinutes(1));messages.Add("Последние обои сохранены. "+Friendly(e));}
            }
            NextRun=due.DefaultIfEmpty(DateTimeOffset.UtcNow.AddMinutes(1)).Min();State.Status=profiles.Length==0?"Выберите экран для управления обоями.":string.Join(" / ",messages.Distinct());
            repo.Prune(State.Owned.Select(o=>o.Path));
        }
        catch(OperationCanceledException)when(token.IsCancellationRequested){}
        catch(Exception e){Repository.Log(e);NextRun=DateTimeOffset.UtcNow.AddMinutes(1);State.Status="Сохранены последние обои. "+Friendly(e);}
        finally{Busy=false;try{PersistState();}finally{gate.Release();}}
    }
    async Task Evaluate(Settings selected,bool force,CancellationToken token)
    {
        var now=DateTimeOffset.UtcNow;var period=selected.Source=="weather"?TimeSpan.FromDays(1):TimeSpan.FromHours(1);
        var refresh=selected.Online&&(force||now<State.CatalogueChecked||now-State.CatalogueChecked>=period)&&(force||now>=State.RetryAfter);
        Catalogue? catalogue;var cached=false;
        try{catalogue=await repo.CatalogueFor(selected,refresh,token);if(selected.Online&&repo.CatalogueFetched){State.CatalogueChecked=now;State.RetryAfter=default;if(catalogue is not null){CurrentCatalogue=catalogue;CatalogueRevision++;CollectionsChanged(catalogue);}}}
        catch(Exception e)when(e is HttpRequestException or IOException or TaskCanceledException&&!token.IsCancellationRequested){catalogue=await repo.CatalogueFor(selected,false,token);cached=true;State.RetryAfter=now.AddMinutes(1);}
        if(catalogue is null)throw new InvalidDataException("Сначала импортируйте ZIP коллекции.");
        if(selected.Source=="weather"){await TickWeather(catalogue,selected,force,cached,token);return;}
        NextRun=selected.Online?new[]{NextDay(),cached?State.RetryAfter:State.CatalogueChecked+period}.Where(t=>t>now).DefaultIfEmpty(now.AddMinutes(1)).Min():NextDay();
        var scene=catalogue.Choose(selected.Collection,selected.EffectiveMode,DateOnly.FromDateTime(DateTime.Now));
        using var desktop=new WallpaperDesktop();var monitors=desktop.Monitors();var ready=new List<Plan>();
        foreach(var m in Targets(monitors,selected)){var file=scene.Desktop(m.Width,m.Height,selected.Format);ready.Add(new(m,file,await repo.Picture(selected,file,token)));}
        if(!Apply(desktop,monitors,ready,selected,force,token))return;
        State.Status=scene.Title+" · обои установлены"+(Settings.Paused?" · пауза сохранена":"")+(cached?" · сохранённый каталог":"");
    }
    sealed record Plan(DesktopMonitor Monitor,ViewFile File,string Path,string WeatherFormat="");
    static DesktopMonitor[] Targets(DesktopMonitor[] monitors,Settings selected)
    {
        var targets=monitors.Where(m=>selected.Monitor=="all" || m.Id==selected.Monitor || m.DisplayName==selected.Monitor).ToArray();Catalogue.Require(targets.Length>0,"Выбранный экран не подключён.");return targets;
    }
    bool TakenOver(WallpaperDesktop desktop,DesktopMonitor[] monitors) => State.Owned.Any(o=>monitors.Any(m=>m.Id==o.Monitor) && !string.Equals(desktop.Wallpaper(o.Monitor),o.Path,StringComparison.OrdinalIgnoreCase)) || State.Owned.Count>0 && State.Position>=0 && desktop.Position!=State.Position;
    void PauseForExternal(){SetPaused(true);State.Status="Обои изменены вне приложения. Автосмена приостановлена.";}
    bool Apply(WallpaperDesktop desktop,DesktopMonitor[] monitors,List<Plan> ready,Settings selected,bool force,CancellationToken token)
    {
        token.ThrowIfCancellationRequested();if(token.IsCancellationRequested)return false;
        if(!force && TakenOver(desktop,monitors)){PauseForExternal();return false;}
        var signature=string.Join("|",ready.Select(p=>p.Monitor.Id+":"+p.File.Sha256));
        if(!force && ready.All(p=>State.Owned.Any(o=>o.Monitor==p.Monitor.Id&&o.Sha256==p.File.Sha256)))return true;
        if(ready.Count==monitors.Length)desktop.Fill();
        var owned=State.Owned.Where(o=>monitors.Any(m=>m.Id==o.Monitor)).ToDictionary(o=>o.Monitor);
        foreach(var p in ready)
        {
            token.ThrowIfCancellationRequested();if(token.IsCancellationRequested)return false;
            desktop.Set(p.Monitor.Id,p.Path);var actual=desktop.Wallpaper(p.Monitor.Id);
            Catalogue.Require(string.Equals(Path.GetFullPath(actual),Path.GetFullPath(p.Path),StringComparison.OrdinalIgnoreCase),"Windows не подтвердила выбранный файл обоев");
            owned[p.Monitor.Id]=new(p.Monitor.Id,actual,p.File.Sha256);State.Owned=owned.Values.ToList();State.Position=desktop.Position;repo.Write("state.json",State);
        }
        State.Signature=string.Join("|",State.Owned.OrderBy(o=>o.Monitor).Select(o=>o.Monitor+":"+o.Sha256));return true;
    }
    public static string Friendly(Exception e)=>e switch{HttpRequestException=>"Нет связи с сайтом.",TaskCanceledException=>"Сайт не ответил вовремя.",NativeOperationException=>e.Message,System.Runtime.InteropServices.COMException=>NativeOperationException.Describe("выполнить системную операцию",e),_=>e.Message.Truncate(300)};
}
internal static class TextLimit { public static string Truncate(this string s,int length)=>s.Length>length?s[..length]+"…":s; }
