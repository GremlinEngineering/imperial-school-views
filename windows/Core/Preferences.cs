namespace ImperialSchool.Views.Core;

public sealed record Settings
{
    public string Source { get; init; } = "day";
    public string Collection { get; init; } = "";
    public string Mode { get; init; } = "monthly";
    public string Monitor { get; init; } = "all";
    public string Format { get; init; } = "auto";
    public bool Enabled { get; init; }
    public bool Paused { get; init; }
    public bool NotifyCollections { get; init; } = true;
    public bool NotifyApp { get; init; } = true;
    public string WeatherSource { get; init; } = "game-world";
    public string WeatherDelivery { get; init; } = "zip";
    public string WeatherFormat { get; init; } = "auto";
    public City? City { get; init; }
    public bool SeparateMonitors { get; init; }
    public Dictionary<string, Settings> Profiles { get; init; } = [];
    public bool Manage { get; init; } = true;
    public Settings? SaverProfile { get; init; }
    public bool SaverScheduled { get; init; }
    public bool SaverOwn { get; init; }
    public string SaverCollection { get; init; } = "";
    public int SaverSeconds { get; init; } = 60;
    public bool Online => Source is "day" or "online" or "weather";
    public string EffectiveMode => Source == "day" ? "featured" : Mode;
}
public sealed record OwnedWallpaper(string Monitor, string Path, string Sha256);
public sealed class State
{
    public List<OwnedWallpaper> Owned { get; set; } = [];
    public int Position { get; set; } = -1;
    public string Signature { get; set; } = "";
    public DateTimeOffset CatalogueChecked { get; set; }
    public DateTimeOffset UpdateChecked { get; set; }
    public string[]? KnownCollections { get; set; }
    public string NotifiedRelease { get; set; } = "";
    public AppRelease? Release { get; set; }
    public string Status { get; set; } = "Выберите источник и нажмите «Применить».";
    public DateTimeOffset RetryAfter { get; set; }
}
