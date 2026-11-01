using System.Drawing.Text;
using System.Reflection;
using System.Runtime.InteropServices;

namespace ImperialSchool.Views;

internal sealed class Brand : IDisposable
{
    readonly PrivateFontCollection fonts = new(); readonly List<IntPtr> memory = [], registrations = [];
    [DllImport("gdi32.dll")] static extern IntPtr AddFontMemResourceEx(IntPtr data, uint size, IntPtr reserved, ref uint count);
    [DllImport("gdi32.dll")] [return: MarshalAs(UnmanagedType.Bool)] static extern bool RemoveFontMemResourceEx(IntPtr handle);
    readonly Dictionary<string, FontFamily> families = [];
    public Brand()
    {
        foreach (var name in new[] { "literata.ttf", "ptmono.ttf", "oswald_semibold.ttf" })
        {
            var bytes = Resource(name); var ptr = Marshal.AllocHGlobal(bytes.Length); Marshal.Copy(bytes, 0, ptr, bytes.Length); memory.Add(ptr);
            fonts.AddMemoryFont(ptr, bytes.Length); uint count = 0; registrations.Add(AddFontMemResourceEx(ptr, (uint)bytes.Length, IntPtr.Zero, ref count));
            var single = new PrivateFontCollection(); single.AddMemoryFont(ptr, bytes.Length); families[name] = single.Families[0]; temporaryCollections.Add(single);
        }
    }
    readonly List<PrivateFontCollection> temporaryCollections = [];
    public Font Text(float size) => new(families["literata.ttf"], size);
    public Font Mono(float size) => new(families["ptmono.ttf"], size);
    public Font Heading(float size) => new(families["oswald_semibold.ttf"], size);
    public static byte[] Resource(string name)
    {
        var assembly = Assembly.GetExecutingAssembly(); var key = assembly.GetManifestResourceNames().Single(k => k.EndsWith("." + name, StringComparison.Ordinal));
        using var stream = assembly.GetManifestResourceStream(key)!; using var output = new MemoryStream(); stream.CopyTo(output); return output.ToArray();
    }
    public static Image Image(string name) { using var s = new MemoryStream(Resource(name)); using var image = System.Drawing.Image.FromStream(s); return new Bitmap(image); }
    public static Icon Icon(string name) { using var s = new MemoryStream(Resource(name)); using var icon = new System.Drawing.Icon(s); return (Icon)icon.Clone(); }
    public void Dispose()
    {
        foreach (var family in families.Values) family.Dispose(); foreach (var c in temporaryCollections) c.Dispose(); fonts.Dispose();
        foreach (var h in registrations.Where(h => h != IntPtr.Zero)) RemoveFontMemResourceEx(h); foreach (var p in memory) Marshal.FreeHGlobal(p);
    }
}
internal sealed record Palette(Color Paper, Color Ink, Color Muted, Color Accent, Color Panel, Color Line)
{
    public static Palette Current()
    {
        using var key = Microsoft.Win32.Registry.CurrentUser.OpenSubKey(@"Software\Microsoft\Windows\CurrentVersion\Themes\Personalize");
        var dark = key?.GetValue("AppsUseLightTheme") is int n && n == 0;
        static Color C(string s) => ColorTranslator.FromHtml(s);
        return dark ? new(C("#141126"), C("#f3ecdb"), C("#b9b1ce"), C("#fbbf55"), C("#211b38"), C("#514560"))
            : new(C("#fbf8ec"), C("#272635"), C("#56536b"), C("#9d3766"), C("#f2ead9"), C("#c8c2af"));
    }
}
