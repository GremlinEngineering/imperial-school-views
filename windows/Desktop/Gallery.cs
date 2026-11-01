using System.Text.Json.Nodes;
using ImperialSchool.Views.Core;
namespace ImperialSchool.Views;
internal sealed record GalleryItem(string Path,string Collection,string Title,string Format,string Season="",string TimeOfDay="",string Condition="",string Moon="")
{
    public override string ToString()=>Title+" · "+Format;
}
internal sealed partial class Repository
{
    readonly Dictionary<string,DateTimeOffset> jsonRetry=[];
    public async Task<JsonObject> CurrentJson(string path,bool force,CancellationToken token)
    {
        _=AssetStore.Address(path);var key=Convert.ToHexStringLower(System.Security.Cryptography.SHA256.HashData(System.Text.Encoding.UTF8.GetBytes(path)));var cache=Path.Combine(Root,"current",key+".json");JsonObject? saved=null;
        try{saved=JsonNode.Parse(await File.ReadAllTextAsync(cache,token))!.AsObject();}catch(Exception e)when(e is IOException or System.Text.Json.JsonException){}
        var now=DateTimeOffset.UtcNow;
        if(force||now>=jsonRetry.GetValueOrDefault(key)) {
            jsonRetry[key]=now.AddMinutes(1);
            try {var doc=JsonNode.Parse(await Assets.Get(path,5_000_000,token))!.AsObject();token.ThrowIfCancellationRequested();SafeFiles.Write(cache,doc.ToJsonString());return doc;}
            catch(OperationCanceledException)when(token.IsCancellationRequested){throw;}
            catch(Exception e)when(e is IOException or HttpRequestException or OperationCanceledException){if(saved is null)throw;}
        }
        return saved??throw new InvalidDataException("Нет сохранённого текущего кадра");
    }
    public void Remember(WeatherFrame frame,string collection)
    {
        if(frame.File is not {} file)return;
        var entries=Read<List<GalleryItem>>("history.json");var row=new GalleryItem(Assets.ImagePath(file),collection,frame.Details,file.Width+"×"+file.Height,frame.Season,frame.TimeOfDay,frame.Condition,frame.MoonPhase);
        entries.RemoveAll(x=>x.Path==row.Path&&x.Title==row.Title);entries.Add(row);Write("history.json",entries.TakeLast(96).ToList());
    }
    public async Task<List<GalleryItem>> Gallery(CancellationToken token)
    {
        var rows=Read<List<GalleryItem>>("history.json").Where(x=>File.Exists(x.Path)).ToList();
        foreach(var online in new[]{false,true}) {
            Catalogue? data;try{data=await CatalogueFor(new Settings{Source=online?"online":"local"},false,token);}catch(Exception e)when(e is IOException or HttpRequestException or InvalidDataException){continue;}
            foreach(var s in data?.Scenes??[])foreach(var f in s.Files.Where(f=>f.Width>f.Height)) {
                var p=online?Assets.ImagePath(f):SafeFiles.Under(Root,f.Url);if(File.Exists(p))rows.Add(new(p,s.Collection,s.Title,f.Width+"×"+f.Height));
            }
        }
        var folder=Path.Combine(Root,"weather-packages");
        foreach(var p in Directory.Exists(folder)?Directory.GetFiles(folder,"*.json"):[]) {
            try {var doc=JsonNode.Parse(await File.ReadAllTextAsync(p,token))!;foreach(var v in doc["variants"]!.AsArray()) {
                var path=Path.Combine(CacheRoot,ImperialSchool.Views.Core.Weather.Text(v,"sha256")+".jpg");if(!File.Exists(path))continue;
                var state=ImperialSchool.Views.Core.Weather.Text(v,"state_id");var parts=state.Split('-');var season=ImperialSchool.Views.Core.Weather.Text(v,"season");if(season.Length==0)season=parts.ElementAtOrDefault(0)??"";var light=ImperialSchool.Views.Core.Weather.Text(v,"time_of_day");if(light.Length==0)light=parts.ElementAtOrDefault(1)??"";var condition=ImperialSchool.Views.Core.Weather.Text(v,"weather");if(condition.Length==0)condition=string.Join("-",parts.Skip(2));
                rows.Add(new(path,ImperialSchool.Views.Core.Weather.Text(doc,"id"),new WeatherFrame("ready",state,Season:season,TimeOfDay:light,Condition:condition).Details,ImperialSchool.Views.Core.Weather.Text(doc,"format"),season,light,condition,ImperialSchool.Views.Core.Weather.Text(v,"moon_phase")));
            }}catch(Exception e)when(e is IOException or System.Text.Json.JsonException or InvalidOperationException){Log(e);}
        }
        return rows.DistinctBy(x=>(x.Path,x.Collection,x.Season,x.TimeOfDay,x.Condition,x.Moon)).OrderBy(x=>x.Collection).ThenBy(x=>x.Title).ToList();
    }
}
