using ImperialSchool.Views.Core;
using System.Text.Json;
using System.Text.Json.Nodes;
using System.IO.Compression;
using System.Net;
using System.Text;
static class ParityChecks
{
    public static async Task<int> Run()
    {
        int count=0;void Check(string name,Action action){action();count++;Console.WriteLine("OK "+name);}void Require(bool ok){if(!ok)throw new Exception("Parity check failed");}void Reject(Action a){try{a();}catch(InvalidDataException){return;}throw new Exception("Bad frame accepted");}
        string Read(string f)=>File.ReadAllText(Path.Combine(AppContext.BaseDirectory,"Fixtures",f));
        Check("Astronomy matches Mac and server golden data across timezones and polar days",()=>{
            foreach(var row in JsonNode.Parse(Read("astronomy-golden.json"))!.AsArray()) {
                var c=row!["city"]!;var city=new City(Weather.Text(c,"name"),c["latitude"]!.GetValue<double>(),c["longitude"]!.GetValue<double>(),Weather.Text(c,"timezone"));var date=DateOnly.Parse(Weather.Text(row,"date"));
                var events=Astronomy.Events(date,city);foreach(var (key,value) in row["events"]!.AsObject()) {
                    if(value is null)Require(!events.ContainsKey(key));else Require(events.ContainsKey(key)&&Math.Abs(events[key].ToUnixTimeSeconds()-value.GetValue<long>())<=1);
                }
                Require(Astronomy.Moon(date)==Weather.Text(row,"moon"));Require(Astronomy.Midnight(date,city).ToUnixTimeSeconds()==row["midnight"]!.GetValue<long>());
            }
        });
        Check("Sunrise and sunset are exact half-open time transitions",()=>{
            var city=new City("Москва",55.75,37.62,"Europe/Moscow");var events=Astronomy.Events(new(2026,10,25),city);
            foreach(var key in new[]{"dawn","sunrise","sunset","dusk"}) {var expected=key switch{"sunrise"=>"day","sunset"=>"dusk","dusk"=>"night",_=>"dawn"};Require(Astronomy.Light(events[key],city)==expected);Require(Astronomy.Light(events[key].AddSeconds(-1),city)!=expected);}
        });
        Check("New screens stay unmanaged; switching profiles preserves other displays and stable identities",()=>{
            var common=new Settings{Source="online",Collection="autumn",Monitor="all",Enabled=true};var displays=new[]{new MonitorIdentity("stable-a","DISPLAY1"),new MonitorIdentity("stable-b","DISPLAY2")};
            var split=MonitorProfiles.Save(common,common with{Monitor="stable-a",Collection="winter"},true,displays);Require(split.SeparateMonitors&&MonitorProfiles.Get(split,"stable-a").Collection=="winter"&&MonitorProfiles.Get(split,"stable-b").Collection=="autumn");
            split=MonitorProfiles.Save(split,MonitorProfiles.Get(split,"stable-b") with{Collection="summer",Monitor="stable-b"},true,displays);Require(MonitorProfiles.Get(split,"stable-a").Collection=="winter"&&MonitorProfiles.Get(split,"stable-b","DISPLAY1").Collection=="summer"&&!MonitorProfiles.Get(split,"stable-c").Manage);
            var restored=JsonSerializer.Deserialize<Settings>(JsonSerializer.Serialize(split))!;Require(MonitorProfiles.Get(restored,"stable-a").Collection=="winter");
            var linked=MonitorProfiles.Save(restored,common,false,displays);Require(!linked.SeparateMonitors&&linked.Profiles.Count==2);
        });
        Check("Legacy monitor-only setup does not take over other monitors",()=>{
            var old=new Settings{Source="day",Monitor="DISPLAY1"};var split=MonitorProfiles.Save(old,old with{Monitor="stable-a"},true,[new("stable-a","DISPLAY1"),new("stable-b","DISPLAY2")]);Require(MonitorProfiles.Get(split,"stable-a").Manage&&!MonitorProfiles.Get(split,"stable-b").Manage);
        });
        Check("City round-trip keeps coordinates and timezone without serializing runtime timezone data",()=>{
            var city=new City("Paris",48.85,2.35,"Europe/Paris");var text=JsonSerializer.Serialize(new Settings{City=city});Require(!text.Contains("BaseUtcOffset")&&!text.Contains("Zone"));Require(JsonSerializer.Deserialize<Settings>(text)!.City==city);
            Reject(()=>new City("bad",double.NaN,0,"UTC").Validate());Reject(()=>new City("bad",1,1,"Missing/Zone").Validate());
        });
        Check("Open-Meteo uses exact state and moon, rejects unknown codes and expired weather",()=>{
            var city=new City("Москва",55.75,37.62,"Europe/Moscow");var now=DateTimeOffset.Parse("2026-10-25T12:00:00Z");var file=new ViewFile("files/a.jpg",100,60,50,new('a',64));
            JsonObject Forecast(int code)=>new(){["hourly"]=new JsonObject{["time"]=new JsonArray(now.ToUnixTimeSeconds(),now.AddHours(1).ToUnixTimeSeconds()),["weather_code"]=new JsonArray(code,code)}};
            var state="autumn-day-clear";var rows=new[]{new WeatherVariant(file,state,"full_moon")};var frame=LocalWeather.Resolve(Forecast(0),city,rows,now,"v");Require(frame.Status=="ready"&&frame.File==file&&frame.MoonPhase=="full_moon"&&frame.Next==now.AddHours(1));
            Require(LocalWeather.Resolve(Forecast(97),city,rows,now,"v").Status=="not_ready");Require(LocalWeather.Condition(97)=="severe-thunderstorm");Reject(()=>LocalWeather.Resolve(Forecast(-1),city,rows,now,"v"));Reject(()=>LocalWeather.Resolve(Forecast(0),city,rows,now.AddHours(3),"v"));
        });
        Check("Server weather keeps the Imperial caption instead of exposing source city",()=>{
            // Golden ready daily document contains source city Moscow, but UI caption stays fixed.
            var d=JsonNode.Parse(Read("daily-1.0.13/real-ready.json"))!.AsObject();var f=CurrentFrames.Daily(d,"real",3440,1440,"auto",DateTimeOffset.Parse("2026-10-30T12:00:00Z"));Require(f.Title=="Погода Столицы Империи"&&!f.Details.Contains("Москва"));
        });
        Check("Daily weather validates expiry, identity and desktop format",()=>{
            var d=JsonNode.Parse(Read("daily-1.0.13/real-ready.json"))!.AsObject();var now=DateTimeOffset.Parse("2026-10-30T12:00:00Z");Require(CurrentFrames.Daily(d,"real",3440,1440,"auto",now).File!.Width==3440);
            Reject(()=>CurrentFrames.Daily(d,"game-world",3440,1440,"auto",now));Reject(()=>CurrentFrames.Daily(d,"real",3440,1440,"auto",Weather.Time(d["valid_until"])));
            d["files"]!["ultrawide"]!["url"]="../secret";Reject(()=>CurrentFrames.Daily(d,"real",3440,1440,"auto",now));
        });
        Check("Dynamic manifest and state validate identity, hash, device, expiry and ready status",()=>{
            var catalog=Catalogue.Parse(Read("dynamic-0.2/manifest-v3.json"));var c=catalog.Collections[0].Weather!;var d=JsonNode.Parse(Read("dynamic-0.2/dynamic/test-theme/current.json"))!.AsObject();var s=JsonNode.Parse(Read("dynamic-0.2/dynamic/test-theme/devices/landscape/current.json"))!.AsObject();var now=Weather.Time(s["at"]);
            Require(CurrentFrames.Dynamic(d,s,c,"landscape",now).File!.Width==8);Reject(()=>CurrentFrames.Dynamic(d,s,c,"landscape",Weather.Time(s["valid_until"])));
            var bad=(JsonObject)s.DeepClone();bad["image"]!["sha256"]=new string('f',64);Reject(()=>CurrentFrames.Dynamic(d,bad,c,"landscape",now));bad=(JsonObject)s.DeepClone();bad["device"]="portrait";Reject(()=>CurrentFrames.Dynamic(d,bad,c,"landscape",now));
            var other=(JsonObject)d.DeepClone();other["format_status"]!["landscape"]!["status"]="not_ready";Reject(()=>CurrentFrames.Dynamic(other,s,c,"landscape",now));
        });
        var folder=Path.Combine(Path.GetTempPath(),"wallpaper-parity-"+Guid.NewGuid().ToString("N"));Directory.CreateDirectory(folder);
        try {
            var plain=Encoding.UTF8.GetBytes("{\"ready\":true}");using var compressed=new MemoryStream();using(var br=new BrotliStream(compressed,CompressionMode.Compress,true))br.Write(plain);
            using var assets=new AssetStore(folder,(_,_,_)=>{},new Handler(_=>new(HttpStatusCode.OK){Content=new ByteArrayContent(compressed.ToArray())}));
            var result=await assets.Get("test.json.br",1000,CancellationToken.None);Check("Brotli sidecar JSON decodes with a decompressed limit",()=>Require(result.SequenceEqual(plain)));
            bool rejected=false;try{await assets.Get("test.json.br",5,CancellationToken.None);}catch(InvalidDataException){rejected=true;}Check("Brotli expansion cannot exceed configured JSON limit",()=>Require(rejected));
            int requests=0;using var cities=new CityWeather(folder,new Handler(_=>{requests++;return new(HttpStatusCode.OK){Content=new StringContent("{\"hourly\":{\"time\":[1,3601],\"weather_code\":[0,0]}}")};}));var city=new City("A",1,2,"UTC");await cities.Forecast(city,false,CancellationToken.None);await cities.Forecast(city,false,CancellationToken.None);Check("City forecast reuses hourly cache",()=>Require(requests==1));await cities.Forecast(city with{Longitude=3},false,CancellationToken.None);Check("Changing location invalidates city forecast cache",()=>Require(requests==2));
        }finally{Directory.Delete(folder,true);}
        return count;
    }
    sealed class Handler(Func<HttpRequestMessage,HttpResponseMessage> run):HttpMessageHandler{protected override Task<HttpResponseMessage> SendAsync(HttpRequestMessage request,CancellationToken token)=>Task.FromResult(run(request));}
}
