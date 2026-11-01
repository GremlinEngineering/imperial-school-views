namespace ImperialSchool.Views;
internal sealed class ViewerForm : Form
{
    readonly Repository repo;readonly CancellationTokenSource stopping=new();readonly ListBox list=new(){Dock=DockStyle.Left,Width=280};readonly PictureBox picture=new(){SizeMode=PictureBoxSizeMode.Zoom,Dock=DockStyle.Fill,BackColor=Color.Black};
    readonly Panel canvas=new(){Dock=DockStyle.Fill,AutoScroll=true};readonly Label caption=new(){Dock=DockStyle.Bottom,AutoSize=true,Padding=new(8)};
    readonly System.Windows.Forms.Timer timer=new(){Interval=2000};readonly Button play=new(){Text="▶ Слайд-шоу",AutoSize=true};
    readonly Dictionary<string,ComboBox> filters=[];List<GalleryItem> all=[];List<GalleryItem> visible=[];bool filling,full;Rectangle normal;FormWindowState normalState;
    public ViewerForm(Repository repository)
    {
        repo=repository;Text="Просмотр обоев";Icon=Brand.Icon("app.ico");ClientSize=new(1100,760);MinimumSize=new(700,450);StartPosition=FormStartPosition.CenterParent;
        var top=new FlowLayoutPanel{Dock=DockStyle.Top,AutoSize=true,WrapContents=true};var bottom=new FlowLayoutPanel{Dock=DockStyle.Bottom,AutoSize=true};
        foreach(var (key,title) in new[]{("collection","Все коллекции"),("format","Все форматы"),("season","Все сезоны"),("light","Всё время суток"),("weather","Любая погода"),("moon","Все фазы луны")}){
            var box=new ComboBox{Width=170,DropDownStyle=ComboBoxStyle.DropDownList,AccessibleName=title};filters[key]=box;top.Controls.Add(box);box.SelectedIndexChanged+=(_,_)=>{if(!filling)Filter();};
        }
        void Button(string title,Action action){var b=new Button{Text=title,AutoSize=true};b.Click+=(_,_)=>action();bottom.Controls.Add(b);}
        Button("←",()=>MoveImage(-1));Button("→",()=>MoveImage(1));bottom.Controls.Add(play);play.Click+=(_,_)=>{timer.Enabled=!timer.Enabled;play.Text=timer.Enabled?"❚❚ Пауза":"▶ Слайд-шоу";};
        var speed=new ComboBox{Width=90,DropDownStyle=ComboBoxStyle.DropDownList};foreach(var value in new[]{.5,1,2,3,5,10})speed.Items.Add(value);speed.SelectedItem=2.0;speed.SelectedIndexChanged+=(_,_)=>timer.Interval=(int)((double)speed.SelectedItem!*1000);bottom.Controls.Add(speed);
        Button("Вписать",Fit);Button("100%",()=>{if(picture.Image is {} im){picture.Dock=DockStyle.None;picture.SizeMode=PictureBoxSizeMode.AutoSize;picture.Size=im.Size;}});Button("Полный экран",Fullscreen);
        Button("Обновить список",()=>{_ = Reload();});canvas.Controls.Add(picture);Controls.Add(canvas);Controls.Add(list);Controls.Add(caption);Controls.Add(bottom);Controls.Add(top);
        list.SelectedIndexChanged+=(_,_)=>ShowImage();timer.Tick+=(_,_)=>MoveImage(1);Shown+=async(_,_)=>await Reload();KeyPreview=true;
        KeyDown+=(_,e)=>{if(e.KeyCode==Keys.Escape){if(full)Fullscreen();else Close();}if(e.KeyCode==Keys.Right)MoveImage(1);if(e.KeyCode==Keys.Left)MoveImage(-1);if(e.KeyCode==Keys.F11)Fullscreen();};
        picture.MouseWheel+=(_,e)=>{if(picture.Image is null)return;var width=(int)Math.Clamp(picture.Width*(e.Delta>0?1.2:1/1.2),100,20000);picture.Dock=DockStyle.None;picture.SizeMode=PictureBoxSizeMode.Zoom;picture.Size=new(width,(int)(width*(double)picture.Image.Height/picture.Image.Width));};picture.MouseEnter+=(_,_)=>picture.Focus();
    }
    async Task Reload(){try{all=await repo.Gallery(stopping.Token);filling=true;foreach(var (key,box) in filters){var selected=(box.SelectedItem as Option)?.Id??"";box.Items.Clear();box.Items.Add(new Option("","Все"));foreach(var id in all.Select(x=>Value(x,key)).Where(s=>s.Length>0).Distinct().Order())box.Items.Add(new Option(id,id));box.SelectedItem=box.Items.Cast<Option>().FirstOrDefault(o=>o.Id==selected)??box.Items[0];}filling=false;Filter();}catch(OperationCanceledException){}catch(Exception e){caption.Text=Engine.Friendly(e);}}
    static string Value(GalleryItem x,string k)=>k switch{"collection"=>x.Collection,"format"=>x.Format,"season"=>x.Season,"light"=>x.TimeOfDay,"weather"=>x.Condition,"moon"=>x.Moon,_=>""};
    void Filter(){visible=all.Where(x=>filters.All(p=>(p.Value.SelectedItem as Option)?.Id is not {Length:>0} id||Value(x,p.Key)==id)).DistinctBy(x=>x.Path).ToList();list.BeginUpdate();list.Items.Clear();list.Items.AddRange(visible.ToArray());list.EndUpdate();if(visible.Count>0)list.SelectedIndex=0;else{picture.Image?.Dispose();picture.Image=null;caption.Text="Нет сохранённых кадров для выбранных условий. Скачайте коллекцию.";}}
    void MoveImage(int delta){if(visible.Count>0)list.SelectedIndex=(Math.Max(0,list.SelectedIndex)+delta+visible.Count)%visible.Count;}
    void ShowImage(){if(list.SelectedItem is not GalleryItem row)return;try{using var stream=File.OpenRead(row.Path);using var im=Image.FromStream(stream);var old=picture.Image;picture.Image=new Bitmap(im);old?.Dispose();caption.Text=row.Title+" · "+row.Moon+" · "+(list.SelectedIndex+1)+" / "+visible.Count;}catch(Exception e){caption.Text=Engine.Friendly(e);}}
    void Fit(){picture.SizeMode=PictureBoxSizeMode.Zoom;picture.Dock=DockStyle.Fill;}
    void Fullscreen(){if(!full){normal=Bounds;normalState=WindowState;WindowState=FormWindowState.Normal;FormBorderStyle=FormBorderStyle.None;Bounds=Screen.FromControl(this).Bounds;TopMost=true;}else{TopMost=false;FormBorderStyle=FormBorderStyle.Sizable;Bounds=normal;WindowState=normalState;}full=!full;}
    protected override void Dispose(bool disposing){if(disposing){stopping.Cancel();stopping.Dispose();timer.Dispose();picture.Image?.Dispose();Icon?.Dispose();}base.Dispose(disposing);}
}
