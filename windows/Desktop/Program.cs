using System.Net.NetworkInformation;
using Microsoft.Win32;

namespace ImperialSchool.Views;

internal static class Program
{
    internal const string MutexName = @"Local\ImperialSchoolViews.Windows";
    const string ActivateName = @"Local\ImperialSchoolViews.Windows.Activate", QuitName = @"Local\ImperialSchoolViews.Windows.Quit";
    [STAThread]
    static int Main(string[] args)
    {
        try {if(ScreenSaver.Run(args))return 0;}catch(Exception e){Repository.Log(e);return 1;}
        if (args.Contains("--quit"))
        {
            try { using var signal = EventWaitHandle.OpenExisting(QuitName); signal.Set(); return 0; }
            catch (WaitHandleCannotBeOpenedException) { return 0; }
        }
        using var mutex = new Mutex(true, MutexName, out var first);
        if (!first)
        {
            for (var i = 0; i < 20; i++)
            {
                try { using var signal = EventWaitHandle.OpenExisting(ActivateName); signal.Set(); return 0; }
                catch (WaitHandleCannotBeOpenedException) { Thread.Sleep(100); }
            }
            MessageBox.Show("Приложение уже запущено. Откройте его через значок в трее.", "Виды Школы Империи"); return 0;
        }
        try
        {
            Application.SetHighDpiMode(HighDpiMode.PerMonitorV2); Application.EnableVisualStyles(); Application.SetCompatibleTextRenderingDefault(false);
            Application.SetUnhandledExceptionMode(UnhandledExceptionMode.CatchException);
            Application.ThreadException += (_, e) => { Repository.Log(e.Exception); MessageBox.Show(Engine.Friendly(e.Exception), "Виды Школы Империи", MessageBoxButtons.OK, MessageBoxIcon.Error); };
            AppDomain.CurrentDomain.UnhandledException += (_, e) => { if (e.ExceptionObject is Exception error) Repository.Log(error); };
            using var active = new EventWaitHandle(false, EventResetMode.AutoReset, ActivateName);
            using var quit = new EventWaitHandle(false, EventResetMode.AutoReset, QuitName);
            using var host = new Host(active, quit, args.Contains("--background")); Application.Run(host); return 0;
        }
        catch (Exception e) { Repository.Log(e); MessageBox.Show(Engine.Friendly(e) + "\n\nЖурнал: " + Path.Combine(Repository.Root, "app.log"), "Не удалось запустить Виды Школы Империи", MessageBoxButtons.OK, MessageBoxIcon.Error); return 1; }
        finally { mutex.ReleaseMutex(); }
    }
}
internal sealed class Host : ApplicationContext
{
    readonly Repository repo = new(); readonly Brand brand = new(); readonly CancellationTokenSource stopping = new();
    readonly MainForm form; readonly Engine engine; readonly NotifyIcon tray; readonly ContextMenuStrip menu;
    readonly System.Windows.Forms.Timer timer = new() { Interval = 1_000 };
    readonly RegisteredWaitHandle activateWait, quitWait;
    bool exiting;
    public Host(EventWaitHandle active, EventWaitHandle quit, bool background)
    {
        engine = new Engine(repo, Changed, Notify, stopping.Token);
        // Normalize optional persisted fields before callbacks or background work can use them.
        engine.State.Owned ??= [];
        menu = new ContextMenuStrip(); tray = new NotifyIcon { Icon = Brand.Icon("tray.ico"), Text = "Виды Школы Империи", ContextMenuStrip = menu, Visible = true };
        form = new MainForm(repo, engine, brand, Exit, stopping.Token); _ = form.Handle;
        Item("Открыть", () => { Show(); return Task.CompletedTask; });
        Item("Обновить обои сейчас", () => engine.Tick(true));
        Item("Пауза / продолжить", async () => { if (!engine.Settings.Enabled) return; engine.SetPaused(!engine.Settings.Paused); if (!engine.Settings.Paused) await engine.Tick(true); });
        menu.Items.Add(new ToolStripSeparator()); Item("Проверить обновления", () => engine.CheckUpdates(true));
        Item("Аркадный зал", () => { AppInfo.Open("https://games.oopssre.ru/gremlin.html#views"); return Task.CompletedTask; });
        menu.Items.Add(new ToolStripSeparator()); Item("Завершить", () => { Exit(); return Task.CompletedTask; });
        tray.DoubleClick += (_, _) => Show();
        activateWait = ThreadPool.RegisterWaitForSingleObject(active, (_, _) => Post(Show), null, Timeout.Infinite, false);
        quitWait = ThreadPool.RegisterWaitForSingleObject(quit, (_, _) => Post(Exit), null, Timeout.Infinite, false);
        timer.Tick += async (_, _) => { if (!exiting) { await Safe(() => engine.Tick()); await Safe(() => engine.CheckUpdates(false)); } }; timer.Start();
        SystemEvents.PowerModeChanged += PowerChanged; SystemEvents.DisplaySettingsChanged += DisplayChanged; SystemEvents.UserPreferenceChanged += PreferenceChanged; SystemEvents.TimeChanged += TimeChanged; NetworkChange.NetworkAvailabilityChanged += NetworkChanged;
        if (!background) Show();
        Post(async () => { await Safe(() => engine.Tick()); await Safe(() => engine.CheckUpdates(false)); });
    }
    void Item(string text, Func<Task> action) { var item = menu.Items.Add(text); item.Click += async (_, _) => await Safe(action); }
    async Task Safe(Func<Task> action)
    {
        try { await action(); }
        catch (OperationCanceledException) when (stopping.IsCancellationRequested) { }
        catch (Exception e) { Repository.Log(e); if (!exiting) { engine.State.Status = Engine.Friendly(e); Changed(); } }
    }
    void Post(Action action) { if (!exiting && !form.IsDisposed) { try { form.BeginInvoke(action); } catch (InvalidOperationException) { } } }
    void Changed() { if (!exiting && form is not null && !form.IsDisposed) Post(() => { form.Changed(); tray.Text = engine.TrayCaption; }); }
    void Notify(string title, string message) { if (!exiting) { tray.BalloonTipTitle = title; tray.BalloonTipText = message; tray.BalloonTipIcon = ToolTipIcon.Info; tray.ShowBalloonTip(6000); } }
    void Show() { if (!exiting) { form.Show(); if (form.WindowState == FormWindowState.Minimized) form.WindowState = FormWindowState.Normal; form.Activate(); } }
    void PowerChanged(object sender, PowerModeChangedEventArgs e) { if (e.Mode == PowerModes.Resume) Post(async () => { engine.InvalidateSchedule(true); await Safe(() => engine.Tick()); }); }
    void DisplayChanged(object? sender, EventArgs e) => Post(async () => { await Safe(() => { form.ReloadMonitors(); return Task.CompletedTask; }); engine.InvalidateSchedule(); await Safe(() => engine.Tick()); });
    void TimeChanged(object? sender, EventArgs e) => Post(async () => { engine.InvalidateSchedule(true); await Safe(() => engine.Tick()); });
    void NetworkChanged(object? sender, NetworkAvailabilityEventArgs e) { if (e.IsAvailable) Post(async () => { engine.InvalidateSchedule(true); await Safe(() => engine.Tick()); }); }
    void PreferenceChanged(object sender, UserPreferenceChangedEventArgs e) => Post(form.ApplyPalette);
    void Exit()
    {
        if (exiting) return; exiting = true; stopping.Cancel(); timer.Stop(); tray.Visible = false;
        form.Exiting = true; form.Close(); ExitThread();
    }
    protected override void Dispose(bool disposing)
    {
        if (disposing)
        {
            exiting = true; stopping.Cancel(); timer.Stop();
            SystemEvents.PowerModeChanged -= PowerChanged; SystemEvents.DisplaySettingsChanged -= DisplayChanged; SystemEvents.UserPreferenceChanged -= PreferenceChanged; SystemEvents.TimeChanged -= TimeChanged; NetworkChange.NetworkAvailabilityChanged -= NetworkChanged;
            activateWait.Unregister(null); quitWait.Unregister(null); timer.Dispose(); tray.Visible = false; tray.Icon?.Dispose(); tray.Dispose(); menu.Dispose(); form.Dispose(); brand.Dispose(); repo.Dispose(); stopping.Dispose();
        }
        base.Dispose(disposing);
    }
}
