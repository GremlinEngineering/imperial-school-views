using System.Runtime.InteropServices;
using ImperialSchool.Views.Core;

namespace ImperialSchool.Views;

internal sealed record DesktopMonitor(string Id, int Width, int Height, string Title, string? DisplayName);
internal sealed class WallpaperDesktop : IDisposable
{
    // COM methods are declared in SDK vtable order, not the alphabetical documentation order.
    [ComImport, Guid("B92B56A9-8B55-4E14-9A89-0199BBB6F93B"), InterfaceType(ComInterfaceType.InterfaceIsIUnknown)]
    interface IDesktopWallpaper
    {
        void SetWallpaper([MarshalAs(UnmanagedType.LPWStr)] string monitor, [MarshalAs(UnmanagedType.LPWStr)] string path);
        void GetWallpaper([MarshalAs(UnmanagedType.LPWStr)] string monitor, [MarshalAs(UnmanagedType.LPWStr)] out string path);
        void GetMonitorDevicePathAt(uint index, [MarshalAs(UnmanagedType.LPWStr)] out string monitor);
        void GetMonitorDevicePathCount(out uint count);
        [PreserveSig] int GetMonitorRECT([MarshalAs(UnmanagedType.LPWStr)] string monitor, out Rect rect);
        void SetBackgroundColor(uint color);
        void GetBackgroundColor(out uint color);
        void SetPosition(int position);
        void GetPosition(out int position);
    }
    [StructLayout(LayoutKind.Sequential)] struct Rect { public int Left, Top, Right, Bottom; }
    readonly IDesktopWallpaper native;
    public WallpaperDesktop()
    {
        native = Call("создать компонент смены обоев", () =>
            (IDesktopWallpaper)Activator.CreateInstance(Type.GetTypeFromCLSID(new Guid("C2CF3110-460E-4FC1-B9D0-8A1C0C9CC4BD"), true)!)!);
    }
    static T Call<T>(string operation, Func<T> action)
    {
        try { return action(); }
        catch (Exception e) when (e is COMException or InvalidCastException) { throw new NativeOperationException(operation, e); }
    }
    static void Call(string operation, Action action) => Call(operation, () => { action(); return true; });
    public DesktopMonitor[] Monitors()
    {
        var count = Call("получить число экранов для обоев", () => { native.GetMonitorDevicePathCount(out var value); return value; });
        var list = new List<DesktopMonitor>();
        // GetMonitorRECT can fail for wallpaper entries left behind by detached/virtual displays.
        // Link active GDI displays to their monitor interface paths without asking that API for bounds.
        var displays = DisplayInventory.ByInterfacePath();
        for (uint i = 0; i < count; i++)
        {
            var id = Call("получить идентификатор экрана", () => { native.GetMonitorDevicePathAt(i, out var value); return value; });
            if (!displays.TryGetValue(id, out var active)) continue;
            list.Add(new DesktopMonitor(id, active.Bounds.Width, active.Bounds.Height, $"Экран {list.Count + 1} · {active.Bounds.Width}×{active.Bounds.Height}", active.DeviceName));
        }
        if (list.Count == 0) throw new InvalidOperationException("Не удалось сопоставить подключённые экраны с компонентом обоев Windows.");
        return list.ToArray();
    }
    public string Wallpaper(string monitor) => Call("получить текущие обои", () => { native.GetWallpaper(monitor, out var path); return path; });
    public int Position => Call("получить способ заполнения экрана", () => { native.GetPosition(out var mode); return mode; });
    public void Set(string monitor, string path) => Call("установить обои", () => native.SetWallpaper(monitor, path));
    public void Fill() => Call("выбрать заполнение экрана", () => native.SetPosition(4)); // DWPOS_FILL; global Windows setting.
    public void Dispose() { if (Marshal.IsComObject(native)) Marshal.FinalReleaseComObject(native); }
}
