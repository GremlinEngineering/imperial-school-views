using ImperialSchool.Views.Core;

namespace ImperialSchool.Views;

internal sealed record Option(string Id, string Title) { public override string ToString() => Title; }
internal sealed partial class MainForm : Form
{
    readonly Repository repo; readonly Engine engine; readonly Brand brand; readonly CancellationToken cancel;
    readonly ComboBox source = new(), collection = new(), schedule = new(), monitor = new(), format = new(), weatherSource = new(), delivery = new();
    readonly Button ordinaryTab = new(), weatherTab = new(), download = new();
    readonly ProgressBar progress = new(); readonly Label downloadStatus = new(); readonly List<Control> weatherControls = [];
    Control? sourceLabel; bool weatherMode; CancellationTokenSource? previewCancel; long catalogueRevision; string appliedPreview = "";
    readonly CheckBox startup = new(), notifyCollections = new(), notifyApp = new();
    readonly PictureBox preview = new(), logo = new();
    readonly Label sceneTitle = new(), status = new(), version = new();
    readonly Button apply = new(), refresh = new(), pause = new(), update = new(), import = new(), reload = new();
    Palette colors = Palette.Current();
    Catalogue? catalogue; Settings draft; int generation; bool suppress, loading, firstShow = true;
    readonly TableLayoutPanel body = new();
    [System.ComponentModel.DesignerSerializationVisibility(System.ComponentModel.DesignerSerializationVisibility.Hidden)]
    internal bool Exiting { get; set; }
    public MainForm(Repository repository, Engine controller, Brand fonts, Action quit, CancellationToken token)
    {
        repo = repository; engine = controller; brand = fonts; cancel = token; draft = engine.Settings; weatherMode = draft.Source == "weather";
        Text = "Виды Школы Империи"; Icon = Brand.Icon("app.ico"); AutoScaleMode = AutoScaleMode.Dpi; AutoScaleDimensions = new SizeF(96, 96);
        Font = brand.Text(10); ClientSize = new Size(760, 860); MinimumSize = new Size(620, 520); StartPosition = FormStartPosition.CenterScreen;
        var root = new TableLayoutPanel { Dock = DockStyle.Fill, ColumnCount = 1, RowCount = 2, Padding = new Padding(24, 20, 24, 18) };
        root.ColumnStyles.Add(new ColumnStyle(SizeType.Percent, 100)); root.RowStyles.Add(new RowStyle(SizeType.Percent, 100)); root.RowStyles.Add(new RowStyle(SizeType.AutoSize)); Controls.Add(root);
        var scroll = new Panel { Dock = DockStyle.Fill, AutoScroll = true, Margin = new Padding(0) }; root.Controls.Add(scroll, 0, 0);
        body.Dock = DockStyle.Top; body.AutoSize = true; body.AutoSizeMode = AutoSizeMode.GrowAndShrink; body.ColumnCount = 1; body.ColumnStyles.Add(new ColumnStyle(SizeType.Percent, 100)); body.Padding = new Padding(0, 0, 18, 20); scroll.Controls.Add(body);
        void Add(Control c, int top = 0)
        {
            c.Margin = new Padding(0, top, 0, 0); c.Anchor = AnchorStyles.Left | AnchorStyles.Right | AnchorStyles.Top;
            body.RowStyles.Add(new RowStyle(SizeType.AutoSize)); body.Controls.Add(c, 0, body.RowCount++);
        }
        Label TextLabel(string text, Font font, string? role = null) => new() { Text = text, Font = font, AutoSize = true, Tag = role, Padding = new Padding(0, 2, 0, 3) };
        Label Label(string text) { var label = TextLabel(text, brand.Mono(9), "muted"); Add(label, 16); return label; }
        var badge = new FlowLayoutPanel { AutoSize = true, WrapContents = false, Margin = Padding.Empty };
        logo.SizeMode = PictureBoxSizeMode.Zoom; logo.Size = new Size(44, 42); logo.Margin = new Padding(0, 0, 14, 0); badge.Controls.Add(logo);
        badge.Controls.Add(TextLabel("ШКОЛА ИМПЕРИИ\nIMPERIAL SCHOOL", brand.Mono(9), "accent")); Add(badge);
        Add(TextLabel("Виды и обои", brand.Heading(30)), 12);
        Add(TextLabel("Пейзажи из мира Школы Империи. Места, к которым хочется возвращаться.", brand.Text(11)), 6);
        var tabs = new FlowLayoutPanel { AutoSize = true, WrapContents = true };
        ConfigureButton(ordinaryTab, "Обычные обои", () => SwitchSection(false)); ConfigureButton(weatherTab, "Погодные обои", () => SwitchSection(true)); tabs.Controls.Add(ordinaryTab); tabs.Controls.Add(weatherTab); Add(tabs, 15);
        preview.Height = 230; preview.SizeMode = PictureBoxSizeMode.Zoom; preview.BorderStyle = BorderStyle.None; preview.AccessibleName = "Предпросмотр выбранного вида"; preview.Tag = "panel"; Add(preview, 18);
        sceneTitle.Font = brand.Heading(17); sceneTitle.AutoSize = true; sceneTitle.Text = "Выберите коллекцию"; Add(sceneTitle, 7);
        foreach (var combo in new[] { source, collection, schedule, monitor, format, weatherSource, delivery })
        {
            combo.DropDownStyle = ComboBoxStyle.DropDownList; combo.Font = brand.Mono(10); combo.FlatStyle = FlatStyle.Flat; combo.DrawMode = DrawMode.OwnerDrawFixed; combo.ItemHeight = 30; combo.IntegralHeight = false; combo.DropDownHeight = 260;
            combo.DrawItem += (_, e) => { if (e.Index < 0) return; using var brush = new SolidBrush((e.State & DrawItemState.Selected) != 0 ? colors.Line : colors.Panel); e.Graphics.FillRectangle(brush, e.Bounds); TextRenderer.DrawText(e.Graphics, combo.Items[e.Index]?.ToString() ?? "", combo.Font, Rectangle.Inflate(e.Bounds, -8, 0), colors.Ink, TextFormatFlags.VerticalCenter | TextFormatFlags.EndEllipsis); e.DrawFocusRectangle(); };
        }
        sourceLabel = Label("Источник"); Add(source, 5); source.AccessibleName = "Источник обоев";
        Fill(source, [new("day", "Обои дня"), new("online", "Коллекции сайта"), new("local", "Сохранённые коллекции")], weatherMode ? "day" : draft.Source);
        var actions = new FlowLayoutPanel { AutoSize = true, WrapContents = true };
        ConfigureButton(import, "Импортировать ZIP…", Import); ConfigureButton(reload, "Обновить список", () => LoadSource(true)); actions.Controls.Add(import); actions.Controls.Add(reload); Add(actions, 9);
        Label("Коллекция"); Add(collection, 5); collection.AccessibleName = "Коллекция";
        weatherControls.Add(Label("Источник погоды")); Add(weatherSource, 5); weatherControls.Add(weatherSource);
        weatherControls.Add(Label("Загрузка погодных кадров")); Add(delivery, 5); weatherControls.Add(delivery);
        Fill(delivery, [new("zip", "Скачать ZIP с сайта · рекомендуется"), new("images", "Загружать отдельные JPEG")], draft.WeatherDelivery);
        Label("Расписание"); Add(schedule, 5); schedule.AccessibleName = "Расписание смены";
        Label("Экран"); Add(monitor, 5); monitor.AccessibleName = "Экран для обоев";
        ReloadMonitors();
        AddProfileControls(Add,Label);
        Label("Формат изображения"); Add(format, 5); format.AccessibleName = "Формат изображения";
        Fill(format, [new("auto", "Автоматически по экрану"), new("16:10", "16:10 · 3840×2400"), new("16:9", "16:9 · 3840×2160"), new("ultrawide", "Ultrawide · 3440×1440")], draft.Format);
        AddCityControls(Add);
        ConfigureButton(download, "Скачать коллекцию с сайта", DownloadCollection); Add(download, 12);
        progress.Height = 8; progress.Maximum = 100; Add(progress, 10);
        downloadStatus.AutoSize = true; downloadStatus.Font = brand.Mono(9); downloadStatus.Tag = "muted"; Add(downloadStatus, 6);
        Add(TextLabel("Для одного выбранного экрана сохраняется установленный в Windows способ заполнения.", brand.Mono(8.5f), "muted"), 8);
        void Check(CheckBox check, string text, bool value) { check.Text = text; check.Checked = value; check.AutoSize = true; check.Font = brand.Mono(9); Add(check, 12); }
        Check(startup, "Запускать при входе в Windows", Autostart.Enabled);
        Check(notifyCollections, "Сообщать о новых коллекциях", draft.NotifyCollections); Check(notifyApp, "Сообщать о новых версиях приложения", draft.NotifyApp);
        Add(TextLabel("Закрытие окна оставляет приложение в трее. Завершить работу можно через меню значка.", brand.Mono(8.5f), "muted"), 15);
        var links = new FlowLayoutPanel { AutoSize = true, WrapContents = true, Margin = Padding.Empty };
        foreach (var (title, url) in new[] { ("Аркадный зал", "https://games.oopssre.ru/gremlin.html#views"), ("Блог", "https://oopssre.ru/"), ("Telegram", "https://t.me/oopsSRE"), ("VK", "https://vk.ru/club238642156") })
        {
            var link = new LinkLabel { Text = title, Font = brand.Mono(8.5f), AutoSize = true, Margin = new Padding(0, 0, 17, 6), Tag = "accent" }; link.LinkClicked += (_, _) => Open(url); links.Controls.Add(link);
        }
        var github=new LinkLabel{Text="Исходники на GitHub",AutoSize=true,Font=brand.Mono(8.5f)};github.LinkClicked+=(_,_)=>Open("https://github.com/GremlinEngineering/imperial-school-views");links.Controls.Add(github);
        Add(links, 22);
        AddTools(Add,Label);
        var foot = new TableLayoutPanel { AutoSize = true, Dock = DockStyle.Fill, ColumnCount = 1, Padding = new Padding(0, 13, 0, 0), Margin = Padding.Empty };
        foot.ColumnStyles.Add(new ColumnStyle(SizeType.Percent, 100)); root.Controls.Add(foot, 0, 1);
        status.AutoSize = true; status.Font = brand.Mono(9); status.Tag = "muted"; status.Anchor = AnchorStyles.Left | AnchorStyles.Right; status.Margin = new Padding(0, 0, 0, 10); foot.Controls.Add(status, 0, 0);
        var buttons = new TableLayoutPanel { AutoSize = true, Dock = DockStyle.Fill, ColumnCount = 3, Margin = Padding.Empty };
        buttons.ColumnStyles.Add(new ColumnStyle(SizeType.Percent, 34)); buttons.ColumnStyles.Add(new ColumnStyle(SizeType.Percent, 38)); buttons.ColumnStyles.Add(new ColumnStyle(SizeType.Percent, 28));
        ConfigureButton(apply, "Применить", Apply); apply.Tag = "primary"; ConfigureButton(refresh, "Обновить сейчас", () => engine.Tick(true)); ConfigureButton(pause, "Пауза", Pause);
        var i = 0; foreach (var b in new[] { apply, refresh, pause }) { b.Dock = DockStyle.Fill; b.Margin = new Padding(i == 0 ? 0 : 8, 0, 0, 0); buttons.Controls.Add(b, i++, 0); } foot.Controls.Add(buttons, 0, 1);
        var release = new FlowLayoutPanel { AutoSize = true, WrapContents = true, Dock = DockStyle.Fill, Margin = new Padding(0, 10, 0, 0) };
        version.Font = brand.Mono(8.5f); version.AutoSize = true; version.Tag = "muted"; version.Margin = new Padding(0, 8, 15, 0); release.Controls.Add(version);
        ConfigureButton(update, "Проверить обновления", CheckRelease); update.Font = brand.Mono(8.5f); release.Controls.Add(update); foot.Controls.Add(release, 0, 2);
        source.SelectedIndexChanged += async (_, _) => { if (!suppress) await Guard(() => LoadSource(true)); };
        collection.SelectedIndexChanged += async (_, _) => { if (!suppress) { FillModes(); await Guard(ShowPreview); } };
        schedule.SelectedIndexChanged += async (_, _) => { if (!suppress) await Guard(ShowPreview); };
        weatherSource.SelectedIndexChanged += async (_, _) => { if (!suppress) await Guard(ShowPreview); };
        format.SelectedIndexChanged += async (_, _) => { if (!suppress) await Guard(ShowPreview); };
        monitor.SelectedIndexChanged += async (_, _) => { if (!suppress) await Guard(LoadMonitorProfile); };
        delivery.SelectedIndexChanged += (_, _) => { if (!suppress) Changed(); };
        Shown += async (_, _) => { if (firstShow) { firstShow = false; if(separate.Checked){editingMonitor="";await LoadMonitorProfile();} Bounds = Fit(Bounds, Screen.FromControl(this).WorkingArea); await Guard(() => LoadSource(false)); } };
        FormClosing += (_, e) => { if (!Exiting && e.CloseReason == CloseReason.UserClosing) { e.Cancel = true; Hide(); } };
        ApplyPalette(); Changed();
    }
    static Rectangle Fit(Rectangle desired, Rectangle area) => new(Math.Max(area.Left, Math.Min(desired.Left, area.Right - Math.Min(desired.Width, area.Width))), Math.Max(area.Top, Math.Min(desired.Top, area.Bottom - Math.Min(desired.Height, area.Height))), Math.Min(desired.Width, area.Width), Math.Min(desired.Height, area.Height));
    void ConfigureButton(Button b, string text, Func<Task> action)
    { b.Text = text; b.AutoSize = true; b.Font = brand.Mono(9); b.FlatStyle = FlatStyle.Flat; b.Padding = new Padding(10, 8, 10, 8); b.Cursor = Cursors.Hand; b.Click += async (_, _) => await Guard(action); }
    async Task Guard(Func<Task> action)
    {
        try { await action(); }
        catch (OperationCanceledException) { }
        catch (Exception e) { Repository.Log(e); if (!IsDisposed) { status.Text = Engine.Friendly(e); MessageBox.Show(this, Engine.Friendly(e), "Виды Школы Империи", MessageBoxButtons.OK, MessageBoxIcon.Warning); } }
    }
    void Open(string url) { try { AppInfo.Open(url); } catch (Exception e) { Repository.Log(e); status.Text = Engine.Friendly(e); } }
    static string Selected(ComboBox c) => (c.SelectedItem as Option)?.Id ?? "";
    static void Fill(ComboBox combo, IEnumerable<Option> rows, string selected)
    {
        combo.BeginUpdate(); combo.Items.Clear(); foreach (var row in rows) combo.Items.Add(row);
        combo.SelectedItem = combo.Items.Cast<Option>().FirstOrDefault(o => o.Id == selected); if (combo.SelectedIndex < 0 && combo.Items.Count > 0) combo.SelectedIndex = 0; combo.EndUpdate();
    }
    Settings Draft() => draft with { Source = weatherMode ? "weather" : Selected(source), Collection = collection.SelectedItem is Option p ? p.Id : draft.Collection, Mode = weatherMode ? "weather" : Selected(schedule) is "" or "featured" ? draft.Mode is "monthly" or "seasonal" or "daily" ? draft.Mode : "monthly" : Selected(schedule), Monitor = Selected(monitor), Format = weatherMode ? draft.Format : Selected(format), WeatherSource = Selected(weatherSource) is "real" or "game-world" or "open-meteo" ? Selected(weatherSource) : draft.WeatherSource, WeatherDelivery = Selected(delivery) is "images" ? "images" : "zip", WeatherFormat = weatherMode ? Selected(format) : draft.WeatherFormat, NotifyCollections = notifyCollections.Checked, NotifyApp = notifyApp.Checked, City=draft.City, Manage=!separate.Checked||manage.Checked, SaverProfile=saverProfile,SaverScheduled=saverScheduled.Checked,SaverOwn=saverOwn.Checked, SaverCollection=Selected(saverCollection), SaverSeconds=(int)saverSeconds.Value };
    public void ReloadMonitors()
    {
        if (IsDisposed) return; var selected = Selected(monitor); if (selected == "") selected = draft.Monitor;
        // Building the settings window must not activate the wallpaper COM service.
        var rows = new List<Option>(); if(!separate.Checked)rows.Add(new("all", "Все экраны"));
        var inventory=DisplayInventory.ByInterfacePath();
        rows.AddRange(Screen.AllScreens.Select((screen,index)=>new Option(inventory.FirstOrDefault(p=>p.Value.DeviceName==screen.DeviceName).Key??screen.DeviceName,$"Экран {index+1} · {screen.Bounds.Width}×{screen.Bounds.Height}")));
        if(rows.All(r=>r.Id!=selected))selected=inventory.FirstOrDefault(p=>p.Value.DeviceName==selected).Key??selected;
        if (selected != "all" && rows.All(r => r.Id != selected) && DisplayInventory.ByInterfacePath().TryGetValue(selected, out var legacy)) selected = legacy.DeviceName;
        if (selected != "all" && selected.Length>0 && rows.All(r => r.Id != selected)) rows.Add(new(selected, "Выбранный экран не подключён")); Fill(monitor, rows, selected);
    }
    async Task LoadSource(bool remote, string? chosenCollection = null, bool capture=true)
    {
        var stamp = ++generation; ++previewGeneration; loading = true; if(capture)draft = Draft();
        if (chosenCollection is not null) draft = draft with { Collection = chosenCollection };
        catalogue = null; ReplacePreview(null); sceneTitle.Text = "Загружаем вид…"; Changed(); status.Text = "Загружаем коллекции…";
        try
        {
            var result = await repo.CatalogueFor(draft, remote, cancel);
            if (stamp != generation || IsDisposed) return; catalogue = result; suppress = true;
            var collectionId = draft.Source == "day" ? result?.Scenes.FirstOrDefault(s => s.Id == result.Featured)?.Collection ?? draft.Collection : draft.Collection;
            Fill(collection, result?.Collections.Where(c => weatherMode ? c.Weather is not null && Weather.Sizes(c.Weather).Any(f => f.Width > f.Height) : c.Weather is null).Select(c => new Option(c.Id, c.Title)) ?? [], collectionId); if(weatherMode) {collection.Items.Insert(0,new Option("__weather_day__","Погода дня с сервера"));collection.SelectedItem=collection.Items.Cast<Option>().FirstOrDefault(x=>x.Id==draft.Collection)??collection.Items[0];} suppress = false; FillModes();
            await ShowPreview();
        }
        finally { if (stamp == generation && !IsDisposed) { suppress = false; loading = false; Changed(); } }
    }
    async Task SwitchSection(bool weather)
    {
        if (weatherMode == weather) return; draft = Draft(); weatherMode = weather;
        draft = draft with { Source = weather ? "weather" : Selected(source), Collection = "" }; await LoadSource(false);
    }
    void FillModes()
    {
        suppress = true;
        var pack = catalogue?.Collections.FirstOrDefault(c => c.Id == Selected(collection));
        var modes = weatherMode ? new[] { "weather" } : Selected(source) == "day" ? ["featured"] : pack?.Modes ?? [];
        Fill(schedule, modes.Select(m => new Option(m, m switch { "featured" => "Обои дня с сайта", "monthly" => "По месяцам", "seasonal" => "По сезонам", "weather" => "Погода, сезон и время суток · по прогнозу сервера", _ => "Каждый день" })), draft.Mode);
        collection.Enabled = weatherMode || Selected(source) != "day" && pack is not null; schedule.Enabled = !weatherMode && Selected(source) != "day" && modes.Length > 0;
        if (weatherMode && pack?.Weather is {} c)
        {
            var chosen = Selected(weatherSource); if (chosen.Length == 0) chosen = draft.WeatherSource;
            var sources=c["sources"]!.AsArray().Select(n=>new Option(Weather.Text(n,"id"),Weather.Text(n,"id")=="real"?"Погода Столицы Империи":"Игровой мир"));
            if(Weather.Text(c,"type")!="dynamic")sources=sources.Append(new("open-meteo","Погода в моём городе · Open-Meteo"));
            Fill(weatherSource,sources,chosen);
            var chosenFormat = Selected(format); if (chosenFormat.Length == 0 || chosenFormat is "16:9" or "16:10") chosenFormat = draft.WeatherFormat;
            Fill(format, new[] { new Option("auto", "Автоматически по экрану") }.Concat(Weather.Sizes(c).Where(f => f.Width > f.Height).Select(f => new Option(f.Id, f.Id + " · " + f.Width + "×" + f.Height))), chosenFormat);
        }
        else if(weatherMode) {Fill(weatherSource,[new("real","Погода Столицы Империи"),new("game-world","Игровой мир")],draft.WeatherSource);Fill(format,[new("auto","Автоматически по экрану")],"auto");}
        else Fill(format, [new("auto", "Автоматически по экрану"), new("16:10", "16:10"), new("16:9", "16:9"),new("ultrawide","Ultrawide · 3440×1440")], draft.Format);
        suppress = false; Changed();
    }
    (int Width, int Height) PreviewSize()
    {
        var selected = Selected(monitor); var screen = DisplayInventory.ByInterfacePath().GetValueOrDefault(selected) ?? Screen.AllScreens.FirstOrDefault(s => s.DeviceName == selected) ?? Screen.PrimaryScreen ?? Screen.AllScreens[0]; return (screen.Bounds.Width, screen.Bounds.Height);
    }
    async Task ShowPreview()
    {
        var stamp = ++previewGeneration; previewCancel?.Cancel(); previewCancel?.Dispose(); previewCancel = CancellationTokenSource.CreateLinkedTokenSource(cancel); var token = previewCancel.Token;
        if (catalogue is null) { sceneTitle.Text = weatherMode ? "Нет погодных коллекций" : "Импортируйте ZIP коллекции"; ReplacePreview(Brand.Image("no-data.png")); return; }
        var s = Draft(); var size = PreviewSize();
        try
        {
            string path;
            if (weatherMode)
            {
                var c = catalogue.Collections.FirstOrDefault(c => c.Id == s.Collection)?.Weather;
                if(s.Collection=="__weather_day__"||s.WeatherSource=="open-meteo"||Weather.Text(c,"type")=="dynamic") {
                    var frame=await engine.ResolveCurrent(catalogue,s,size.Width,size.Height,false,token,false);Catalogue.Require(frame.Status=="ready","Текущий кадр ещё не готов");
                    path=await repo.Assets.Picture(frame.File!,token);if(stamp==previewGeneration)sceneTitle.Text=frame.Details;
                } else {
                if(c is null)throw new InvalidDataException("Выберите погодную коллекцию");
                var f = Weather.Format(c, s.WeatherFormat, size.Width, size.Height); var session = await repo.Weather.Get(c, s.WeatherSource, f.Id, false, token);
                if (stamp != previewGeneration || IsDisposed) return;
                if (session.Frame.Status != "ready") { sceneTitle.Text = session.Frame.Status == "stale" ? "Прогноз закончился · последние обои сохранены" : "Нет актуальных погодных данных"; ReplacePreview(Brand.Image("no-data.png")); return; }
                sceneTitle.Text = session.Frame.Details;
                try { path = await repo.Assets.Picture(session.Frame.File!, token); }
                catch (PublishedAssetChanged)
                {
                    session = await repo.Weather.Get(c, s.WeatherSource, f.Id, true, token); Catalogue.Require(session.Frame.Status == "ready", "Текущий кадр ещё готовится"); path = await repo.Assets.Picture(session.Frame.File!, token);
                    if (stamp == previewGeneration) sceneTitle.Text = session.Frame.Details;
                }
                }
            }
            else { var scene = catalogue.Choose(s.Collection, s.EffectiveMode, DateOnly.FromDateTime(DateTime.Now)); if (stamp == previewGeneration) sceneTitle.Text = scene.Title; path = await repo.Picture(s, scene.Desktop(size.Width, size.Height, s.Format), token); }
            token.ThrowIfCancellationRequested(); using var stream = File.OpenRead(path); using var decoded = Image.FromStream(stream, false, true); var image = new Bitmap(decoded);
            if (stamp != previewGeneration || IsDisposed) { image.Dispose(); return; } ReplacePreview(image);
        }
        catch (OperationCanceledException) when (token.IsCancellationRequested) { }
        catch (Exception e) { Repository.Log(e); if (stamp == previewGeneration && !IsDisposed) { sceneTitle.Text = "Предпросмотр недоступен · " + Engine.Friendly(e); ReplacePreview(Brand.Image("no-data.png")); } }
    }
    int previewGeneration;
    void ReplacePreview(Image? image) { var old = preview.Image; preview.Image = image; old?.Dispose(); }
    async Task Import()
    {
        using var dialog = new OpenFileDialog { Title = "Выберите ZIP одной коллекции", Filter = "Коллекция обоев (*.zip)|*.zip", CheckFileExists = true };
        if (dialog.ShowDialog(this) != DialogResult.OK) return;
        var id = await engine.Import(dialog.FileName); draft = Draft() with { Source = "local", Collection = id };
        suppress = true; source.SelectedItem = source.Items.Cast<Option>().First(o => o.Id == "local"); suppress = false; await LoadSource(false, id);
    }
    async Task Apply()
    {
        Catalogue.Require(catalogue is not null, "Сначала выберите доступную коллекцию.");
        var selected = Draft();
        if (selected.Source == "weather" && selected.Collection!="__weather_day__") { var c = catalogue!.Collections.Single(p => p.Id == selected.Collection).Weather ?? throw new InvalidDataException("Не погодная коллекция"); if(Weather.Text(c,"type")!="dynamic"&&selected.WeatherSource!="open-meteo")Weather.Source(c, selected.WeatherSource); var size = PreviewSize(); Weather.Format(c, selected.WeatherFormat, size.Width, size.Height); selected = selected with { Mode = "weather" }; }
        else if(selected.Source!="weather") catalogue!.Choose(selected.Collection, selected.EffectiveMode, DateOnly.FromDateTime(DateTime.Now));
        draft = selected with { Enabled = true, Paused = false }; engine.SaveProfile(draft, separate.Checked, startup.Checked); await engine.Tick(true);
    }
    async Task DownloadCollection()
    {
        Catalogue.Require(catalogue is not null && !weatherMode && Draft().Source == "online", "Выберите коллекцию сайта");
        var stamp = generation; var id = await engine.DownloadCollection(catalogue!, Draft().Collection);
        if (stamp != generation || IsDisposed) return;
        draft = Draft() with { Source = "local", Collection = id }; suppress = true; source.SelectedItem = source.Items.Cast<Option>().First(o => o.Id == "local"); suppress = false;
        await LoadSource(false, id);
    }
    async Task Pause() { engine.SetPaused(!engine.Settings.Paused); if (!engine.Settings.Paused) await engine.Tick(true); }
    async Task CheckRelease() { if (engine.State.Release is { } release) Open(release.Url); else await engine.CheckUpdates(true); }
    public void Changed()
    {
        if (IsDisposed) return; if (InvokeRequired) { try { BeginInvoke(Changed); } catch (InvalidOperationException) { } return; }
        manage.Visible=separate.Checked;
        status.Text = engine.State.Status; version.Text = "Версия " + AppInfo.Version;
        apply.Enabled = !engine.Busy && !loading && catalogue is not null; refresh.Enabled = !engine.Busy; import.Enabled = !engine.Busy; pause.Enabled = !engine.Busy && engine.Settings.Enabled;
        pause.Text = engine.Settings.Paused ? "Продолжить" : "Пауза"; update.Text = engine.State.Release is {} r ? "Скачать " + r.Version : "Проверить обновления";
        import.Visible = !weatherMode; source.Visible = !weatherMode; if (sourceLabel is not null) sourceLabel.Visible = !weatherMode;
        foreach (var c in weatherControls) c.Visible = weatherMode;
        cityPanel.Visible=weatherMode&&Selected(weatherSource)=="open-meteo";
        cityName.Text=draft.City?.Name??"Город ещё не выбран";
        var dynamic=catalogue?.Collections.FirstOrDefault(x=>x.Id==Selected(collection))?.Weather;
        delivery.Enabled=Selected(weatherSource)!="open-meteo"&&Weather.Text(dynamic,"type")!="dynamic"&&Selected(collection)!="__weather_day__";
        ordinaryTab.Tag = weatherMode ? null : "primary"; weatherTab.Tag = weatherMode ? "primary" : null;
        ordinaryTab.BackColor = weatherMode ? colors.Panel : colors.Accent; ordinaryTab.ForeColor = weatherMode ? colors.Accent : colors.Paper;
        weatherTab.BackColor = weatherMode ? colors.Accent : colors.Panel; weatherTab.ForeColor = weatherMode ? colors.Paper : colors.Accent;
        download.Visible = !weatherMode && Selected(source) == "online"; download.Enabled = !engine.CollectionBusy && catalogue is not null && !loading;
        TransferProgress? transfer = null;
        try
        {
            if (weatherMode && catalogue?.Collections.FirstOrDefault(c => c.Id == Selected(collection))?.Weather is {} c) { var size = PreviewSize(); transfer = engine.Progress("weather/" + Selected(collection) + "/" + Weather.Format(c, Selected(format), size.Width, size.Height).Id); }
            else transfer = engine.Progress("ordinary/" + Selected(collection));
        }
        catch (InvalidDataException) { }
        progress.Visible = transfer?.Stage is "downloading" or "unpacking" or "verifying" or "pending";
        progress.Style = transfer?.Stage == "downloading" && transfer.Total > 0 ? ProgressBarStyle.Continuous : ProgressBarStyle.Marquee;
        if (transfer is { Total: > 0 }) progress.Value = (int)Math.Clamp(transfer.Received * 100 / transfer.Total, 0, 100);
        downloadStatus.Text = transfer is null ? weatherMode ? "Сначала применяется текущий кадр; ZIP загружается в фоне." : "" : transfer.Title + (transfer.Stage == "downloading" && transfer.Total > 0 ? $" · {transfer.Received / 1048576.0:F1} / {transfer.Total / 1048576.0:F1} МБ · {transfer.Received * 100 / transfer.Total}%" : transfer.Stage == "unpacking" && transfer.Count > 0 ? $" · {transfer.Completed} / {transfer.Count}" : "") + (transfer.Message.Length > 0 ? "\n" + transfer.Message : "");
        if (!loading && catalogueRevision != engine.CatalogueRevision && Draft().Online) { catalogueRevision = engine.CatalogueRevision; _ = Guard(() => LoadSource(false)); }
        var imageKey = engine.State.Signature + "/" + engine.WeatherView;
        if (!loading && catalogue is not null && appliedPreview != imageKey && Draft().Source == engine.Settings.Source && Draft().Collection == engine.Settings.Collection) { appliedPreview = imageKey; _ = Guard(ShowPreview); }
    }
    public void ApplyPalette()
    {
        if (IsDisposed) return; colors = Palette.Current();
        void Paint(Control c)
        {
            c.BackColor = c.Tag as string == "panel" || c is ComboBox or Button ? colors.Panel : colors.Paper;
            c.ForeColor = c.Tag as string == "muted" ? colors.Muted : c.Tag as string == "accent" || c is Button ? colors.Accent : colors.Ink;
            if (c is LinkLabel l) { l.LinkColor = colors.Accent; l.ActiveLinkColor = colors.Ink; l.VisitedLinkColor = colors.Accent; }
            if (c is Button b) { b.FlatAppearance.BorderColor = colors.Line; if (b.Tag as string == "primary") { b.BackColor = colors.Accent; b.ForeColor = colors.Paper; } }
            foreach (Control child in c.Controls) Paint(child);
        }
        Paint(this); var old = logo.Image; logo.Image = Brand.Image(colors.Paper.GetBrightness() < .5f ? "gamepad_dark.png" : "gamepad_light.png"); old?.Dispose(); Invalidate(true);
    }
    protected override void Dispose(bool disposing)
    { if (disposing) { previewCancel?.Cancel(); previewCancel?.Dispose(); preview.Image?.Dispose(); logo.Image?.Dispose(); Icon?.Dispose(); } base.Dispose(disposing); }
}
