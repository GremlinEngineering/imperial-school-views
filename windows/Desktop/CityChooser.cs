using System.Runtime.InteropServices;
using ImperialSchool.Views.Core;
namespace ImperialSchool.Views;
internal sealed class CityChooser : Form
{
    public City? SelectedCity {get;private set;}
    readonly TextBox query=new(){Dock=DockStyle.Top,PlaceholderText="Название города"};
    readonly ListBox rows=new(){Dock=DockStyle.Fill};
    readonly Label status=new(){Dock=DockStyle.Bottom,AutoSize=true};
    readonly CancellationTokenSource stopping=new();
    public CityChooser(Repository repo,City? previous)
    {
        Text="Погода в моём городе";ClientSize=new(650,430);MinimumSize=new(480,320);StartPosition=FormStartPosition.CenterParent;
        var buttons=new FlowLayoutPanel{Dock=DockStyle.Bottom,AutoSize=true};
        var search=new Button{Text="Найти город",AutoSize=true};var locate=new Button{Text="Моё местоположение",AutoSize=true};var choose=new Button{Text="Выбрать",AutoSize=true};
        buttons.Controls.AddRange([search,locate,choose]);Controls.Add(rows);Controls.Add(query);Controls.Add(status);Controls.Add(buttons);
        if(previous is not null){rows.Items.Add(previous);rows.SelectedIndex=0;query.Text=previous.Name.Split(',')[0];}
        search.Click+=async(_,_)=>await Guard(async()=>{var result=await repo.Cities.Search(query.Text,stopping.Token);rows.Items.Clear();rows.Items.AddRange(result);if(rows.Items.Count>0)rows.SelectedIndex=0;status.Text=result.Length==0?"Город не найден. Уточните название.":"Выберите город и часовой пояс из списка.";});
        query.KeyDown+=(_,e)=>{if(e.KeyCode==Keys.Enter){search.PerformClick();e.SuppressKeyPress=true;}};
        locate.Click+=async(_,_)=>await Guard(async()=>{locate.Enabled=false;try{SelectedCity=await repo.Cities.AtLocation(await DeviceLocation.Get(Handle,stopping.Token),stopping.Token);rows.Items.Clear();rows.Items.Add(SelectedCity);rows.SelectedIndex=0;status.Text="Координаты Windows · часовой пояс выбран по местоположению. Можно выбрать город поиском.";}finally{locate.Enabled=true;}});
        choose.Click+=(_,_)=>Choose();rows.DoubleClick+=(_,_)=>Choose();
    }
    void Choose(){if(rows.SelectedItem is City c){SelectedCity=c;DialogResult=DialogResult.OK;Close();}}
    async Task Guard(Func<Task> action){try{status.Text="Получаю данные…";await action();}catch(OperationCanceledException){}catch(Exception e){Repository.Log(e);status.Text=Engine.Friendly(e);}}
    protected override void Dispose(bool disposing){if(disposing){stopping.Cancel();stopping.Dispose();}base.Dispose(disposing);}
}
internal static class DeviceLocation
{
    [ComImport,Guid("AB2ECE69-56D9-4F28-B525-DE1B0EE44237"),InterfaceType(ComInterfaceType.InterfaceIsIUnknown)]
    interface ILocation
    {
        void RegisterForReport(IntPtr events,ref Guid report,uint interval);
        void UnregisterForReport(ref Guid report);
        void GetReport(ref Guid report,[MarshalAs(UnmanagedType.Interface)]out object result);
        void GetReportStatus(ref Guid report,out int status);
        void GetReportInterval(ref Guid report,out uint interval);
        void SetReportInterval(ref Guid report,uint interval);
        void GetDesiredAccuracy(ref Guid report,out int accuracy);
        void SetDesiredAccuracy(ref Guid report,int accuracy);
        void RequestPermissions(IntPtr parent,[In,MarshalAs(UnmanagedType.LPArray,SizeParamIndex=2)]Guid[] reports,uint count,[MarshalAs(UnmanagedType.Bool)]bool modal);
    }
    [ComImport,Guid("7FED806D-0EF8-4F07-80AC-36A0BEAE3134"),InterfaceType(ComInterfaceType.InterfaceIsIUnknown)]
    interface ILatLongReport
    {
        void GetSensorID(out Guid id);
        void GetTimestamp(IntPtr systemTime);
        void GetValue(IntPtr key,IntPtr value);
        void GetLatitude(out double latitude);
        void GetLongitude(out double longitude);
        void GetErrorRadius(out double radius);
        void GetAltitude(out double altitude);
        void GetAltitudeError(out double error);
    }
    public static async Task<City> Get(IntPtr parent,CancellationToken token)
    {
        var location=(ILocation)Activator.CreateInstance(Type.GetTypeFromCLSID(new Guid("E5B8E079-EE6D-4E33-A438-C87F2E959254"),true)!)!;
        try {
            var id=typeof(ILatLongReport).GUID;location.RequestPermissions(parent,[id],1,true);
            for(var i=0;i<60;i++) {
                token.ThrowIfCancellationRequested();location.GetReportStatus(ref id,out var state);
                if(state==2)throw new InvalidDataException("Windows не разрешила геолокацию. Включите доступ к местоположению в настройках Windows или найдите город по названию.");
                if(state==4) {
                    location.GetReport(ref id,out var raw);
                    try {var report=(ILatLongReport)raw;report.GetLatitude(out var lat);report.GetLongitude(out var lon);var zone=TimeZoneInfo.Local.Id; if(TimeZoneInfo.TryConvertWindowsIdToIanaId(zone,out var iana))zone=iana;
                        var city=new City("Моё местоположение",lat,lon,zone);city.Validate();return city;}
                    finally{Marshal.ReleaseComObject(raw);}
                }
                await Task.Delay(250,token);
            }
            throw new InvalidDataException("Windows не определила местоположение. Найдите город по названию.");
        }finally{Marshal.ReleaseComObject(location);}
    }
}
