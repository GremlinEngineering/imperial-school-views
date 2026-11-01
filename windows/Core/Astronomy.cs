// Equations adapted from Astral 3.2, Simon Kennedy, Apache-2.0; same contract as macOS.
using System.Text.Json.Nodes;
namespace ImperialSchool.Views.Core;

public sealed record City(string Name, double Latitude, double Longitude, string Timezone)
{
    [System.Text.Json.Serialization.JsonIgnore]
    public TimeZoneInfo Zone { get { Validate(); return TimeZoneInfo.FindSystemTimeZoneById(Timezone); } }
    public void Validate()
    {
        Catalogue.Require(double.IsFinite(Latitude) && double.IsFinite(Longitude) && Math.Abs(Latitude)<=90 && Math.Abs(Longitude)<=180 && !string.IsNullOrWhiteSpace(Name), "Неверное местоположение");
        try { _ = TimeZoneInfo.FindSystemTimeZoneById(Timezone); } catch(TimeZoneNotFoundException) { throw new InvalidDataException("Неизвестный часовой пояс города"); }
    }
    public override string ToString()=>Name;
}
public static class Astronomy
{
    static double Rad(double x)=>x*Math.PI/180;
    static double Deg(double x)=>x*180/Math.PI;
    static double Mod(double x,double n)=>(x%n+n)%n;
    public static DateOnly Date(DateTimeOffset at,City c)=>DateOnly.FromDateTime(TimeZoneInfo.ConvertTime(at,c.Zone).DateTime);
    static DateTimeOffset Utc(DateOnly d)=>new(d.ToDateTime(TimeOnly.MinValue, DateTimeKind.Utc));
    public static double Julian(DateTimeOffset at)=>at.ToUnixTimeSeconds()/86400.0+2440587.5;
    static double Century(double j)=>(j-2451545)/36525;
    static double Mean(double t)=>Mod(280.46646+t*(36000.76983+.0003032*t),360);
    static double Anomaly(double t)=>357.52911+t*(35999.05029-.0001537*t);
    static double Ecc(double t)=>.016708634-t*(.000042037+.0000001267*t);
    static double Apparent(double t) {
        var m=Rad(Anomaly(t)); var center=Math.Sin(m)*(1.914602-t*(.004817+.000014*t))+Math.Sin(2*m)*(.019993-.000101*t)+Math.Sin(3*m)*.000289;
        return Mean(t)+center-.00569-.00478*Math.Sin(Rad(125.04-1934.136*t));
    }
    static double Obliquity(double t) {var s=21.448-t*(46.815+t*(.00059-t*.001813));return 23+(26+s/60)/60+.00256*Math.Cos(Rad(125.04-1934.136*t));}
    static double Declination(double t)=>Deg(Math.Asin(Math.Sin(Rad(Obliquity(t)))*Math.Sin(Rad(Apparent(t)))));
    static double Equation(double t) {
        var l=Rad(Mean(t));var e=Ecc(t);var m=Rad(Anomaly(t));var y=Math.Pow(Math.Tan(Rad(Obliquity(t))/2),2);
        return Deg(y*Math.Sin(2*l)-2*e*Math.Sin(m)+4*e*y*Math.Sin(m)*Math.Cos(2*l)-.5*y*y*Math.Sin(4*l)-1.25*e*e*Math.Sin(2*m))*4;
    }
    static double Refraction(double z) {
        var e=90-z;if(e>=85)return 0;var t=Math.Tan(Rad(e));double correction;
        if(e>5)correction=58.1/t-.07/Math.Pow(t,3)+.000086/Math.Pow(t,5);
        else if(e>-.575)correction=1735+e*(-518.2+e*(103.4+e*(-12.79+e*.711)));
        else correction=-20.774/t;
        return correction/3600;
    }
    static DateTimeOffset? Transit(DateOnly d,City c,double z,bool setting) {
        var jd=Julian(Utc(d));var lat=Rad(Math.Clamp(c.Latitude,-89.8,89.8));var refr=Refraction(z);double adj=0,min=0;
        for(int i=0;i<2;i++) {
            var t=Century(jd+adj);var dec=Rad(Declination(t));var h=(Math.Cos(Rad(z+refr))-Math.Sin(lat)*Math.Sin(dec))/(Math.Cos(lat)*Math.Cos(dec));
            if(h is <-1 or >1)return null;var hour=Math.Acos(h)*(setting?-1:1);var offset=(-c.Longitude-Deg(hour))*4-Equation(t);if(offset< -720)offset+=1440;min=720+offset;adj=min/1440;
        }
        return Utc(d).AddSeconds(Math.Floor(min*60));
    }
    static DateTimeOffset? Event(DateOnly d,City c,double z,bool setting) {
        var t=Transit(d,c,z,setting);if(t is null)return null;var local=Date(t.Value,c);if(local==d)return t;
        t=Transit(d.AddDays(local<d?1:-1),c,z,setting);return t is not null && Date(t.Value,c)==d?t:null;
    }
    public static Dictionary<string,DateTimeOffset> Events(DateOnly d,City c) {
        var events=new Dictionary<string,DateTimeOffset>();
        foreach(var (name,z,setting) in new[]{("dawn",96.0,false),("sunrise",90+32.0/120,false),("sunset",90+32.0/120,true),("dusk",96.0,true)})if(Event(d,c,z,setting) is {} t)events[name]=t;
        return events;
    }
    static double Elevation(DateTimeOffset at,City c) {
        var t=Century(Julian(at));var dec=Rad(Declination(t));var lat=Rad(Math.Clamp(c.Latitude,-89.8,89.8));var solar=at.UtcDateTime.TimeOfDay.TotalMinutes+Equation(t)+4*c.Longitude;
        while(solar>1440)solar-=1440;var h=solar/4-180;if(h< -180)h+=360;
        var z=Deg(Math.Acos(Math.Clamp(Math.Cos(lat)*Math.Cos(dec)*Math.Cos(Rad(h))+Math.Sin(lat)*Math.Sin(dec),-1,1)));return 90-z+Refraction(z);
    }
    public static string Light(DateTimeOffset at,City c) {
        var e=Events(Date(at,c),c);
        foreach(var(a,b,name) in new[]{("dawn","sunrise","dawn"),("sunrise","sunset","day"),("sunset","dusk","dusk")})if(e.TryGetValue(a,out var from)&&e.TryGetValue(b,out var until)&&from<=at&&at<until)return name;
        if(e.Count==4)return "night";var h=Elevation(at,c);return h>=-.833?"day":h< -6?"night":Elevation(at.AddSeconds(30),c)>h?"dawn":"dusk";
    }
    public static readonly string[] Phases=["new_moon","waxing_crescent","first_quarter","waxing_gibbous","full_moon","waning_gibbous","last_quarter","waning_crescent"];
    public static string Moon(DateOnly date) {
        var jd=Julian(Utc(date));var dt=Math.Pow(jd-2382148,2)/(41048480*86400.0);var t=(jd+dt-2451545)/36525;var t2=t*t;var t3=t2*t;
        var d=Rad(Mod(297.85+445267.1115*t-.0016300*t2+t3/545868,360));var m=Rad(Mod(357.53+35999.0503*t,360));var m1=Rad(Mod(134.96+477198.8676*t+.0089970*t2+t3/69699,360));
        var elong=Deg(d)+6.29*Math.Sin(m1)-2.10*Math.Sin(m)+1.27*Math.Sin(2*d-m1)+.66*Math.Sin(2*d);
        var phase=(Math.Truncate(Mod(elong,360))+6.43)/360*28;if(phase>=28)phase-=28;return Phases[(int)Math.Floor((phase+1.75)/3.5)%8];
    }
    public static DateTimeOffset Midnight(DateOnly date, City c) {
        // Find first instant of this local date, including DST gaps and midnight transitions.
        long lo=Utc(date).ToUnixTimeSeconds()-172800,hi=lo+345600;
        while(lo<hi){var mid=lo+(hi-lo)/2;if(Date(DateTimeOffset.FromUnixTimeSeconds(mid),c)<date)lo=mid+1;else hi=mid;}
        return DateTimeOffset.FromUnixTimeSeconds(lo);
    }
}
public static class LocalWeather
{
    public static string? Condition(int code)=>code switch {0=>"clear",1 or 2=>"partly-cloudy",3=>"overcast",45 or 48=>"fog",51 or 53 or 55=>"drizzle",61 or 63 or 80 or 81=>"rain",65 or 82=>"heavy-rain",56 or 57 or 66 or 67=>"freezing-precipitation",71 or 73 or 77 or 85=>"snow",75 or 86=>"heavy-snow",95=>"thunderstorm",97=>"severe-thunderstorm",96 or 99=>"thunderstorm-hail",_=>null};
    public static WeatherFrame Resolve(JsonObject response, City city, WeatherVariant[] variants, DateTimeOffset now,string version) {
        city.Validate();var hourly=response["hourly"]!;var times=hourly["time"]!.AsArray().Select(n=>DateTimeOffset.FromUnixTimeSeconds(n!.GetValue<long>())).ToArray();var codes=hourly["weather_code"]!.AsArray();
        Catalogue.Require(times.Length==codes.Count && times.Length>1 && times.Zip(times.Skip(1)).All(p=>p.First<p.Second),"Неверный почасовой прогноз Open-Meteo");
        var i=Array.FindLastIndex(times,t=>t<=now);Catalogue.Require(i>=0&&now<times[i].AddHours(1),"Прогноз Open-Meteo истёк");
        var condition=Condition(codes[i]?.GetValue<int>()??-1)??throw new InvalidDataException("Нет погодного состояния для кода Open-Meteo");
        var d=Astronomy.Date(now,city);var season=d.Month switch {>=3 and <=5=>"spring",>=6 and <=8=>"summer",>=9 and <=11=>"autumn",_=>"winter"};var light=Astronomy.Light(now,city);var phase=Astronomy.Moon(d);var state=season+"-"+light+"-"+condition;
        var v=variants.FirstOrDefault(v=>v.StateId==state&&v.MoonPhase=="none")??variants.FirstOrDefault(v=>v.StateId==state&&v.MoonPhase==phase);
        var next=Astronomy.Events(d,city).Values.Append(Astronomy.Midnight(d.AddDays(1),city)).Append(times[i].AddHours(1)).Where(t=>t>now).Min();
        return new(v is null?"not_ready":"ready",city.Name,v?.File,state,v?.MoonPhase??phase,season,light,d.ToString("yyyy-MM-dd"),condition,next,now.AddHours(1),version);
    }
}
