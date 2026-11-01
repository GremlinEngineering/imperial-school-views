using System.Text.Json.Nodes;
namespace ImperialSchool.Views.Core;
public static class CurrentFrames
{
    public static bool Endpoint(string actual,string expected)=>actual==expected||actual==expected+".br";
    public static void ValidateCollection(JsonObject c) {
        Catalogue.Require(Endpoint(Weather.Text(c,"current_url"),"dynamic/"+Weather.Text(c,"id")+"/current.json"),"Неверный адрес динамической темы");
    }
    static ViewFile File(JsonNode n) {
        var f=new ViewFile(Weather.Text(n,"url"),n["width"]!.GetValue<int>(),n["height"]!.GetValue<int>(),n["bytes"]!.GetValue<long>(),Weather.Text(n,"sha256"));
        _=AssetStore.Address(f.Url);Catalogue.Require(f.Width is >0 and <=16384&&f.Height is >0 and <=16384&&f.Bytes is >0 and <=100_000_000&&Catalogue.Hash.IsMatch(f.Sha256),"Неверный файл текущего кадра");return f;
    }
    public static WeatherFrame Daily(JsonObject d,string source,int width,int height,string requested,DateTimeOffset now) {
        Catalogue.Require(d["schema"]?.GetValue<int>()==1&&Weather.Text(d,"document_type")=="weather-of-day"&&Weather.Text(d,"source_id")==source&&Weather.Text(d,"status")=="ready", "Погода дня ещё не опубликована");
        Catalogue.Require(Weather.Time(d["valid_from"])<=now&&now<Weather.Time(d["valid_until"]),"Погода дня истекла");
        var rows=d["files"]!.AsObject().Where(p=>requested=="auto"||p.Key==requested).Select(p=>File(p.Value!)).Where(f=>f.Width>f.Height).ToArray();
        Catalogue.Require(rows.Length>0,"Нет формата погоды дня для этого экрана");var file=rows.OrderBy(f=>Math.Abs(Math.Log(f.Ratio/((double)width/height)))).First();
        Catalogue.Require(file.Url.StartsWith("collections/"+Weather.Text(d,"collection_id")+"/files/",StringComparison.Ordinal)&&file.Url.EndsWith(".jpg",StringComparison.Ordinal),"Неверный путь погоды дня");
        return new("ready",source=="real"?"Погода Столицы Империи":Weather.Text(d["source"],"setting") is {Length:>0} s?s:"Игровой мир",file,Weather.Text(d,"state_id"),Weather.Text(d,"moon_phase"),Weather.Text(d,"season"),Weather.Text(d,"time_of_day"),Weather.Text(d,"world_date"),Weather.Text(d,"weather"),Weather.Time(d["valid_until"]),Weather.Time(d["refresh_after"]));
    }
    public static WeatherFrame Dynamic(JsonObject descriptor,JsonObject state,JsonObject c,string device,DateTimeOffset now) {
        var id=Weather.Text(c,"id");var prefix="dynamic/"+id+"/devices/"+device+"/";
        Catalogue.Require(descriptor["schema"]?.GetValue<int>()==1&&Weather.Text(descriptor,"type")=="dynamic"&&Weather.Text(descriptor,"collection_id")==id&&Weather.Text(descriptor,"source_id")=="real"&&Weather.Text(descriptor,"status")=="ready"&&Endpoint(Weather.Text(descriptor["states"],device),prefix+"current.json"),"Динамическая тема ещё не опубликована");
        Catalogue.Require(Weather.Text(descriptor["format_status"]?[device],"status") is "ready" or "stale","Этот формат темы ещё не готов");
        Catalogue.Require(state["schema"]?.GetValue<int>()==1&&Weather.Text(state,"schema_version")=="0.2"&&Weather.Text(state,"type")=="dynamic-state"&&Weather.Text(state,"theme_id")==id&&Weather.Text(state,"device")==device,"Неверный кадр динамической темы");
        Catalogue.Require(Weather.Time(state["at"])>DateTimeOffset.MinValue&&Weather.Time(state["at"])<=now.AddMinutes(1)&&now<Weather.Time(state["valid_until"]),"Кадр темы истёк");var f=File(state["image"]!);var size=Weather.Sizes(c).Single(s=>s.Id==device);
        Catalogue.Require(f.Url==prefix+"current.jpg"&&f.Sha256==Weather.Text(descriptor["files"]?[device],"sha256")&&f.Width==size.Width&&f.Height==size.Height&&Weather.Text(state["image"],"format") is "jpg" or "jpeg","Кадр не соответствует описанию темы");
        return new("ready",Weather.Text(c,"title"),f,Next:Weather.Time(state["valid_until"]),Refresh:now.AddMinutes(1));
    }
}
