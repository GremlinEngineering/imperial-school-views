using ImperialSchool.Views.Core;
namespace ImperialSchool.Views;
internal sealed partial class MainForm
{
    readonly CheckBox separate=new(){Text="Отдельные настройки каждого экрана",AutoSize=true},manage=new(){Text="Менять обои этого экрана",Checked=true,AutoSize=true};
    readonly FlowLayoutPanel cityPanel=new(){AutoSize=true,WrapContents=true};readonly Label cityName=new(){AutoSize=true};
    readonly CheckBox saverOwn=new(){Text="Собственная коллекция хранителя",AutoSize=true};readonly ComboBox saverCollection=new(){DropDownStyle=ComboBoxStyle.DropDownList,Width=300};readonly NumericUpDown saverSeconds=new(){Minimum=10,Maximum=3600,Value=60,Width=90};
    Settings? saverProfile;
    readonly CheckBox saverScheduled=new(){Text="Использовать расписание или погоду отдельного профиля",AutoSize=true};
    string editingMonitor="";
    void AddProfileControls(Action<Control,int> add,Func<string,Label> label)
    {
        separate.Checked=engine.Settings.SeparateMonitors;manage.Checked=draft.Manage;editingMonitor=Selected(monitor);if(separate.Checked){suppress=true;ReloadMonitors();suppress=false;}add(separate,8);add(manage,4);
        separate.CheckedChanged+=async(_,_)=>{if(suppress)return;draft=Draft();suppress=true;ReloadMonitors();suppress=false;await Guard(LoadMonitorProfile);};
    }
    async Task LoadMonitorProfile()
    {
        var id=Selected(monitor);if(id==editingMonitor||id.Length==0)return;editingMonitor=id;
        if(separate.Checked) {
            draft=engine.Profile(id) with{Monitor=id};weatherMode=draft.Source=="weather";suppress=true;
            Fill(source,[new("day","Обои дня"),new("online","Коллекции сайта"),new("local","Сохранённые коллекции")],weatherMode?"day":draft.Source);
            manage.Checked=draft.Manage;weatherSource.Items.Clear();format.Items.Clear();Fill(delivery,[new("zip","Скачать ZIP с сайта"),new("images","Загружать отдельные JPEG")],draft.WeatherDelivery);suppress=false;
            await LoadSource(false,capture:false);
        } else if(catalogue is not null)await ShowPreview();
    }
    void AddCityControls(Action<Control,int> add)
    {
        var choose=new Button();ConfigureButton(choose,"Выбрать город…",()=>{using var dialog=new CityChooser(repo,draft.City);if(dialog.ShowDialog(this)==DialogResult.OK){draft=draft with{City=dialog.SelectedCity};cityName.Text=draft.City?.Name;return ShowPreview();}return Task.CompletedTask;});cityPanel.Controls.Add(choose);cityPanel.Controls.Add(cityName);add(cityPanel,10);
    }
    void AddTools(Action<Control,int> add,Func<string,Label> label)
    {
        label("Просмотр и хранитель экрана");var tools=new FlowLayoutPanel{AutoSize=true,WrapContents=true};
        var view=new Button();ConfigureButton(view,"Просмотр и слайд-шоу",()=>{var window=new ViewerForm(repo);window.Show(this);return Task.CompletedTask;});tools.Controls.Add(view);
        var installSaver=new Button();ConfigureButton(installSaver,"Выбрать хранитель Windows",()=>{ScreenSaver.Install();return Task.CompletedTask;});tools.Controls.Add(installSaver);add(tools,6);
        saverProfile=engine.Settings.SaverProfile;saverScheduled.Checked=engine.Settings.SaverScheduled;
        saverOwn.Checked=engine.Settings.SaverOwn;saverSeconds.Value=Math.Clamp(engine.Settings.SaverSeconds,10,3600);add(saverOwn,10);add(saverCollection,5);
        var interval=new FlowLayoutPanel{AutoSize=true};interval.Controls.Add(new Label{Text="Интервал слайд-шоу, секунд",AutoSize=true});interval.Controls.Add(saverSeconds);add(interval,5);
        add(saverScheduled,6);
        var copyProfile=new Button();ConfigureButton(copyProfile,"Взять выбранные настройки для хранителя",()=>{saverProfile=Draft() with {Profiles=[],SeparateMonitors=false,SaverProfile=null,Monitor="all"};saverOwn.Checked=true;saverScheduled.Checked=true;status.Text="Профиль хранителя выбран: "+saverProfile.Collection+". Нажмите «Применить» для сохранения.";return Task.CompletedTask;});add(copyProfile,5);
        var hint=new Label{Text="Без собственной коллекции хранитель показывает текущие обои экранов. Для собственного расписания выберите обои вверху окна, возьмите эти настройки для хранителя, затем нажмите «Применить».",AutoSize=true};add(hint,4);
        var run=new Button();ConfigureButton(run,"Предпросмотр хранителя",()=>{System.Diagnostics.Process.Start(new System.Diagnostics.ProcessStartInfo(Application.ExecutablePath,"--screensaver"){UseShellExecute=true});return Task.CompletedTask;});add(run,6);
        Shown+=async(_,_)=>{try{var rows=await repo.Gallery(cancel);Fill(saverCollection,rows.Select(x=>x.Collection).Distinct().Select(x=>new Option(x,x)),engine.Settings.SaverCollection);}catch(Exception e){Repository.Log(e);}};
        saverOwn.CheckedChanged+=(_,_)=>{saverCollection.Enabled=saverOwn.Checked;saverSeconds.Enabled=saverOwn.Checked;};saverCollection.Enabled=saverSeconds.Enabled=saverOwn.Checked;
    }
}
