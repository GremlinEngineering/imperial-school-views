using System.Text.Json.Nodes;
using ImperialSchool.Views.Core;
namespace ImperialSchool.Views;
internal sealed partial class Engine
{
    async Task TickCurrent(Catalogue data,Settings selected,bool force,CancellationToken token)
    {
        using var desktop=new WallpaperDesktop();var monitors=desktop.Monitors();var ready=new List<Plan>();var frames=new List<WeatherFrame>();
        foreach(var m in Targets(monitors,selected))
        {
            var frame=await ResolveCurrent(data,selected,m.Width,m.Height,force,token);Catalogue.Require(frame.Status=="ready","Текущий кадр ещё не готов");
            var path=await repo.Assets.Picture(frame.File!,token);token.ThrowIfCancellationRequested();
            Catalogue.Require(frame.Next>DateTimeOffset.UtcNow,"Кадр сменился во время загрузки");
            ready.Add(new(m,frame.File!,path));frames.Add(frame);repo.Remember(frame,selected.Collection);
        }
        if(!Apply(desktop,monitors,ready,selected,force,token))return;
        NextRun=frames.SelectMany(f=>new[]{f.Next,f.Refresh}).Where(t=>t>DateTimeOffset.UtcNow).Append(DateTimeOffset.UtcNow.AddMinutes(1)).Min();
        State.Status=string.Join(" / ",frames.Select(f=>f.Details).Distinct())+" · обои установлены";
        WeatherView=string.Join("/",frames.Select(f=>f.File!.Sha256));
    }
    public async Task<WeatherFrame> ResolveCurrent(Catalogue data,Settings selected,int width,int height,bool force,CancellationToken token,bool prepare=true)
    {
        var now=DateTimeOffset.UtcNow;
        if(selected.Collection=="__weather_day__") {
            var d=await repo.CurrentJson("weather/daily/"+selected.WeatherSource+"/current.json",force,token);
            return CurrentFrames.Daily(d,selected.WeatherSource,width,height,selected.WeatherFormat,now);
        }
        var c=data.Collections.Single(p=>p.Id==selected.Collection).Weather??throw new InvalidDataException("Не погодная коллекция");var format=Weather.Format(c,selected.WeatherFormat,width,height).Id;
        if(Weather.Text(c,"type")=="dynamic") {
            var d=await repo.CurrentJson(Weather.Text(c,"current_url"),force,token);var path=Weather.Text(d["states"],format);
            Catalogue.Require(CurrentFrames.Endpoint(path,"dynamic/"+selected.Collection+"/devices/"+format+"/current.json"),"Неверный адрес кадра темы");
            var state=await repo.CurrentJson(path,force,token);return CurrentFrames.Dynamic(d,state,c,format,now);
        }
        var city=selected.City??throw new InvalidDataException("Выберите город");var descriptor=Weather.Descriptor(data,c,format);var variants=repo.Assets.Variants(c,format,descriptor);var scope="weather/"+selected.Collection+"/"+format;
        if(variants.Length==0) {
            if(!prepare)throw new InvalidDataException("Для своего города нажмите «Применить»: будет скачан погодный пакет.");
            StartPreparation(data,c,format,new(null,null,new("missing",city.Name,PackageVersion:descriptor.Version)),selected with{WeatherDelivery="zip"},force,token);
            throw new InvalidDataException("Скачивается пакет для погоды в выбранном городе. Прогресс показан в окне.");
        }
        var response=await repo.Cities.Forecast(city,force,token);var frame=LocalWeather.Resolve(response,city,variants,now,descriptor.Version);
        if(frame.File is {} file&&!await repo.Assets.Valid(file,token)) {
            if(!prepare)throw new InvalidDataException("Требуется восстановить погодный пакет. Нажмите «Применить».");
            repo.Assets.InvalidatePackage(descriptor.Sha256);StartPreparation(data,c,format,new(null,null,frame),selected with{WeatherDelivery="zip"},force,token);
            throw new InvalidDataException("Восстанавливается повреждённый погодный пакет");
        }
        Report(scope,new("ready","Пакет города готов"));return frame;
    }
}
