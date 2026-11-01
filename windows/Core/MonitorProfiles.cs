namespace ImperialSchool.Views.Core;
public sealed record MonitorIdentity(string Id,string? Alias=null);
public static class MonitorProfiles
{
    public static Settings Get(Settings settings,string id,string? alias=null)
    {
        if(!settings.SeparateMonitors)return settings;
        return settings.Profiles.GetValueOrDefault(id) ?? (alias is null?null:settings.Profiles.GetValueOrDefault(alias)) ?? settings with{Monitor=id,Manage=false,Profiles=[],SeparateMonitors=false};
    }
    public static Settings Save(Settings settings,Settings profile,bool separate,MonitorIdentity[] monitors)
    {
        if(!separate)return profile with{SeparateMonitors=false,Profiles=settings.Profiles};
        Catalogue.Require(profile.Monitor!="all","Для отдельного профиля выберите экран");var profiles=new Dictionary<string,Settings>(settings.Profiles);
        if(!settings.SeparateMonitors)foreach(var m in monitors)profiles[m.Id]=settings with{Monitor=m.Id,Profiles=[],SeparateMonitors=false,Manage=settings.Monitor=="all"||settings.Monitor==m.Id||settings.Monitor==m.Alias};
        profiles[profile.Monitor]=profile with{SeparateMonitors=false,Profiles=[]};
        return settings with{SeparateMonitors=true,Profiles=profiles,Enabled=true,Paused=false,NotifyApp=profile.NotifyApp,NotifyCollections=profile.NotifyCollections,SaverProfile=profile.SaverProfile,SaverScheduled=profile.SaverScheduled,SaverOwn=profile.SaverOwn,SaverCollection=profile.SaverCollection,SaverSeconds=profile.SaverSeconds};
    }
    public static bool Online(Settings settings)=>settings.Online||settings.SeparateMonitors&&settings.Profiles.Values.Any(p=>p.Manage&&p.Online);
}
