using System.Runtime.InteropServices;
using ImperialSchool.Views.Core;
using Microsoft.Win32;
namespace ImperialSchool.Views;
internal static class ScreenSaver
{
    public static string Path => System.IO.Path.Combine(AppContext.BaseDirectory,"ImperialSchoolViews.scr");
    public static void Install() {
        Catalogue.Require(File.Exists(Path),"Модуль хранителя отсутствует. Переустановите полный пакет.");
        using var key=Registry.CurrentUser.CreateSubKey(@"Control Panel\Desktop");key.SetValue("SCRNSAVE.EXE",Path);key.SetValue("ScreenSaveActive","1");
        AppInfo.Open("ms-settings:lockscreen");
    }
    public static bool Run(string[] args) {
        var option=args.FirstOrDefault()?.ToLowerInvariant()??"";
        if(!option.StartsWith("/s")&&!option.StartsWith("/p")&&!option.StartsWith("/c")&&!option.StartsWith("--screensaver"))return false;
        Application.SetHighDpiMode(HighDpiMode.PerMonitorV2);Application.EnableVisualStyles();
        if(option.StartsWith("/c")){System.Diagnostics.Process.Start(new System.Diagnostics.ProcessStartInfo(System.IO.Path.Combine(AppContext.BaseDirectory,"ImperialSchoolViews.exe")){UseShellExecute=true});return true;}
        var parent=IntPtr.Zero;
        if(option.StartsWith("/p")) {var value=option.Contains(':')?option.Split(':')[1]:args.ElementAtOrDefault(1);if(!long.TryParse(value,out var handle)||handle==0)return true;parent=new IntPtr(handle);}
        using var repo=new Repository();var settings=repo.Read<Settings>("settings.json");using var context=new SaverContext(repo,settings,parent);Application.Run(context);return true;
    }
    sealed class SaverContext : ApplicationContext
    {
        readonly List<Form> forms=[];
        readonly Dictionary<Form,DateTimeOffset> due=[];bool resolving;readonly System.Windows.Forms.Timer timer=new();readonly CancellationTokenSource stopping=new();List<GalleryItem> rows=[];int index;
        public SaverContext(Repository repo,Settings settings,IntPtr parent) {
            foreach(var screen in parent==IntPtr.Zero?Screen.AllScreens:[Screen.PrimaryScreen??Screen.AllScreens[0]]) {
                var form=new Form{FormBorderStyle=FormBorderStyle.None,BackColor=Color.Black,StartPosition=FormStartPosition.Manual,Bounds=screen.Bounds,TopMost=parent==IntPtr.Zero,ShowInTaskbar=false};
                var picture=new PictureBox{Dock=DockStyle.Fill,SizeMode=PictureBoxSizeMode.Zoom,BackColor=Color.Black};form.Controls.Add(picture);
                var owned=repo.Read<State>("state.json").Owned.FirstOrDefault(o=>DisplayInventory.ByInterfacePath().GetValueOrDefault(o.Monitor)?.DeviceName==screen.DeviceName);
                if(owned is not null)Load(picture,owned.Path);
                Point? start=null;void MouseMove(object? sender,MouseEventArgs e){if(parent!=IntPtr.Zero)return;var p=Cursor.Position;if(start is {} s&&(Math.Abs(p.X-s.X)>5||Math.Abs(p.Y-s.Y)>5))ExitThread();start??=p;}
                picture.MouseMove+=MouseMove;form.MouseMove+=MouseMove;picture.MouseDown+=(_,_)=>{if(parent==IntPtr.Zero)ExitThread();};form.KeyDown+=(_,_)=>{if(parent==IntPtr.Zero)ExitThread();};
                form.FormClosed+=(_,_)=>ExitThread();forms.Add(form);
                if(parent!=IntPtr.Zero){form.TopLevel=false;SetParent(form.Handle,parent);form.Show();GetClientRect(parent,out var bounds);form.Size=new(bounds.Right-bounds.Left,bounds.Bottom-bounds.Top);}
                else form.Show();
            }
            if(parent==IntPtr.Zero)Cursor.Hide();
            var engine=new Engine(repo,()=>{},(_,_)=>{},stopping.Token);
            timer.Interval=settings.SaverOwn&&!settings.SaverScheduled?Math.Clamp(settings.SaverSeconds,10,3600)*1000:1000;
            timer.Tick+=async(_,_)=>{if(settings.SaverOwn){if(settings.SaverScheduled)await Scheduled();else ShowNext();}else {
                var owned=repo.Read<State>("state.json").Owned;var inventory=DisplayInventory.ByInterfacePath();foreach(var form in forms){var screen=Screen.FromRectangle(form.Bounds);var row=owned.FirstOrDefault(o=>inventory.GetValueOrDefault(o.Monitor)?.DeviceName==screen.DeviceName);if(row is not null&&form.Tag as string!=row.Path){Load((PictureBox)form.Controls[0],row.Path);form.Tag=row.Path;}}
            }};timer.Start();if(settings.SaverOwn){if(settings.SaverScheduled)_=Scheduled();else _=LoadRows();}
            async Task Scheduled(){if(resolving)return;resolving=true;try{foreach(var form in forms){if(DateTimeOffset.UtcNow<due.GetValueOrDefault(form))continue;try{var result=await engine.SaverFrame(settings.SaverProfile??settings,form.Width,form.Height,stopping.Token);stopping.Token.ThrowIfCancellationRequested();if(form.Tag as string!=result.Path){Load((PictureBox)form.Controls[0],result.Path);form.Tag=result.Path;}due[form]=result.Until;}catch(OperationCanceledException){return;}catch(Exception e){Repository.Log(e);due[form]=DateTimeOffset.UtcNow.AddMinutes(1);}}}finally{resolving=false;}}
            async Task LoadRows(){try{rows=(await repo.Gallery(stopping.Token)).Where(x=>x.Collection==settings.SaverCollection).ToList();index=0;ShowNext();}catch(OperationCanceledException){}catch(Exception e){Repository.Log(e);}}
        }
        static void Load(PictureBox picture,string path){try{using var file=File.OpenRead(path);using var im=Image.FromStream(file);var old=picture.Image;picture.Image=new Bitmap(im);old?.Dispose();}catch(Exception e)when(e is IOException or ArgumentException){Repository.Log(e);}}
        void ShowNext(){if(rows.Count==0)return;var groups=rows.GroupBy(x=>x.Title).ToArray();var group=groups[index++%groups.Length];foreach(var form in forms){var ratio=(double)form.Width/form.Height;var row=group.OrderBy(x=>{try{using var im=Image.FromFile(x.Path);return Math.Abs(Math.Log((double)im.Width/im.Height/ratio));}catch{return double.MaxValue;}}).First();Load((PictureBox)form.Controls[0],row.Path);}}
        protected override void Dispose(bool disposing){if(disposing){stopping.Cancel();stopping.Dispose();timer.Dispose();foreach(var form in forms){((PictureBox)form.Controls[0]).Image?.Dispose();form.Dispose();}Cursor.Show();}base.Dispose(disposing);}
    }
    [StructLayout(LayoutKind.Sequential)]struct Rect{public int Left,Top,Right,Bottom;}
    [DllImport("user32.dll")]static extern IntPtr SetParent(IntPtr child,IntPtr parent);
    [DllImport("user32.dll")] [return:MarshalAs(UnmanagedType.Bool)]static extern bool GetClientRect(IntPtr window,out Rect rectangle);
}
