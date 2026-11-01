using System.Globalization;
using System.Net;
using System.Security.Cryptography;
using System.Text;
using System.Text.Json.Nodes;
namespace ImperialSchool.Views.Core;
public sealed class CityWeather : IDisposable
{
    readonly HttpClient http;
    readonly string root;
    readonly Dictionary<string,DateTimeOffset> retry=[];
    public CityWeather(string folder,HttpMessageHandler? handler=null) {
        root=folder;http=new(handler??new HttpClientHandler{AutomaticDecompression=DecompressionMethods.All,AllowAutoRedirect=false}){Timeout=TimeSpan.FromSeconds(30)};http.DefaultRequestHeaders.UserAgent.ParseAdd("ImperialSchoolViews-Windows/1.2.0");
    }
    async Task<JsonObject> Get(string url,CancellationToken token) {
        using var response=await http.GetAsync(url,HttpCompletionOption.ResponseHeadersRead,token);response.EnsureSuccessStatusCode();
        await using var input=await response.Content.ReadAsStreamAsync(token);using var output=new MemoryStream();var buffer=new byte[16384];int n;
        while((n=await input.ReadAsync(buffer,token))>0){Catalogue.Require(output.Length+n<=2_000_000,"Слишком большой ответ Open-Meteo");output.Write(buffer,0,n);}
        return JsonNode.Parse(output.ToArray())!.AsObject();
    }
    public async Task<City[]> Search(string name,CancellationToken token) {
        Catalogue.Require(name.Trim().Length>=2,"Введите хотя бы две буквы названия города");
        var doc=await Get("https://geocoding-api.open-meteo.com/v1/search?name="+Uri.EscapeDataString(name.Trim())+"&count=15&language=ru&format=json",token);
        return (doc["results"]?.AsArray()??[]).Select(n=>new City(string.Join(", ",new[]{Weather.Text(n,"name"),Weather.Text(n,"admin1"),Weather.Text(n,"country")}.Where(s=>s.Length>0).Distinct()),n!["latitude"]!.GetValue<double>(),n["longitude"]!.GetValue<double>(),Weather.Text(n,"timezone"))).Where(c=>Valid(c)).ToArray();
    }
    public async Task<City> AtLocation(City coordinates,CancellationToken token)
    {
        var d=await Get("https://api.open-meteo.com/v1/forecast?latitude="+coordinates.Latitude.ToString("R",CultureInfo.InvariantCulture)+"&longitude="+coordinates.Longitude.ToString("R",CultureInfo.InvariantCulture)+"&timezone=auto&forecast_days=1&hourly=weather_code",token);
        var result=coordinates with{Timezone=Weather.Text(d,"timezone")};result.Validate();return result;
    }
    static bool Valid(City c){try{c.Validate();return true;}catch(InvalidDataException){return false;}}
    public async Task<JsonObject> Forecast(City city,bool force,CancellationToken token) {
        city.Validate();var coords=city.Latitude.ToString("R",CultureInfo.InvariantCulture)+"/"+city.Longitude.ToString("R",CultureInfo.InvariantCulture)+"/"+city.Timezone;
        var key=Convert.ToHexStringLower(SHA256.HashData(Encoding.UTF8.GetBytes(coords)));var path=Path.Combine(root,"cities",key+".json");JsonObject? saved=null;
        try{saved=JsonNode.Parse(await File.ReadAllTextAsync(path,token))!.AsObject();}catch(Exception e) when(e is IOException or System.Text.Json.JsonException){}
        var now=DateTimeOffset.UtcNow;
        if((force||saved is null||now-Weather.Time(saved["fetched_at"])>=TimeSpan.FromHours(1)) && (force||now>=retry.GetValueOrDefault(key))) {
            retry[key]=now.AddMinutes(3);
            try {
                var url="https://api.open-meteo.com/v1/forecast?latitude="+city.Latitude.ToString("R",CultureInfo.InvariantCulture)+"&longitude="+city.Longitude.ToString("R",CultureInfo.InvariantCulture)+"&hourly=weather_code&timeformat=unixtime&timezone=UTC&past_days=1&forecast_days=3";
                var data=await Get(url,token);token.ThrowIfCancellationRequested();saved=new JsonObject{["fetched_at"]=now.ToString("O"),["data"]=data};SafeFiles.Write(path,saved.ToJsonString());
            }catch(OperationCanceledException) when(token.IsCancellationRequested){throw;}catch(Exception e) when(e is HttpRequestException or IOException or OperationCanceledException){if(saved is null)throw;}
        }
        return saved?["data"]?.AsObject()??throw new InvalidDataException("Нет прогноза Open-Meteo");
    }
    public void Dispose()=>http.Dispose();
}
