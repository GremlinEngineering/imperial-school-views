using ImperialSchool.Views.Core;
namespace ImperialSchool.Views;
internal sealed partial class Engine
{
    DateTimeOffset saverCatalogueRefresh;
    public async Task<(string Path,DateTimeOffset Until)> SaverFrame(Settings profile,int width,int height,CancellationToken token)
    {
        var refresh=profile.Online&&DateTimeOffset.UtcNow>=saverCatalogueRefresh;
        Catalogue? data;
        try{data=await repo.CatalogueFor(profile,refresh,token);if(refresh)saverCatalogueRefresh=DateTimeOffset.UtcNow.AddHours(1);}
        catch(Exception e)when(e is IOException or HttpRequestException){data=await repo.CatalogueFor(profile,false,token);saverCatalogueRefresh=DateTimeOffset.UtcNow.AddMinutes(1);}
        if(data is null)throw new InvalidDataException("Нет коллекции хранителя");
        if(profile.Source!="weather") {
            var scene=data.Choose(profile.Collection,profile.EffectiveMode,DateOnly.FromDateTime(DateTime.Now));var file=scene.Desktop(width,height,profile.Format);
            return(await repo.Picture(profile,file,token),new[]{NextDay(),DateTimeOffset.UtcNow.AddHours(1)}.Min());
        }
        var c=data.Collections.FirstOrDefault(c=>c.Id==profile.Collection)?.Weather;WeatherFrame frame;
        if(profile.Collection=="__weather_day__"||profile.WeatherSource=="open-meteo"||Weather.Text(c,"type")=="dynamic")frame=await ResolveCurrent(data,profile,width,height,false,token);
        else {if(c is null)throw new InvalidDataException("Нет погодной коллекции хранителя");var format=Weather.Format(c,profile.WeatherFormat,width,height).Id;var session=await repo.Weather.Get(c,profile.WeatherSource,format,false,token);frame=session.Frame;if(frame.Status=="ready")StartPreparation(data,c,format,session,profile,false,token);}
        Catalogue.Require(frame.Status=="ready","Нет актуального кадра хранителя");var path=await repo.Assets.Picture(frame.File!,token);
        Catalogue.Require(frame.Next>DateTimeOffset.UtcNow,"Погодный интервал сменился во время загрузки");
        return(path,new[]{frame.Next,frame.Refresh,DateTimeOffset.UtcNow.AddMinutes(1)}.Where(t=>t>DateTimeOffset.UtcNow).Min());
    }
}
