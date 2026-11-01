# Imperial School Views for Windows

[Русский](README.md) · English

Windows 1.2.0, build 4, for Windows 10/11 x64. C# / Windows Forms client for
[Imperial School wallpaper collections](https://games.oopssre.ru/).

## Features

- Wallpaper of the day, monthly and seasonal schedules, daily picture rotation.
- Online collections, ZIP downloads with progress, local imports and offline collections.
- Server weather, fictional game-world weather and a selected Open-Meteo city.
- City search and Windows geolocation; timezone resolved from coordinates.
- A shared monitor profile or independent collection, source and format per monitor.
- Weather of the day and finished dynamic JPEG frames from the server.
- Image viewer with collection, format, season, time, weather and moon filters,
  zoom, fullscreen and slideshow.
- Windows screensaver: current monitor wallpapers, its own downloaded slideshow,
  or a separate ordinary/weather profile.
- Tray controls, pause, launch at sign-in, update checks and a GitHub link.

Dynamic layers are composed by the server. The client validates the JSON and JPEG,
checks their identity and expiration, and preserves the last wallpaper if an update fails.
Server weather uses the Russian caption «Погода Столицы Империи»; a city appears only
for the user's Open-Meteo location.

## Build

Install .NET SDK **10.0.403** and NSIS 3.x on Windows. From the repository root:

```powershell
cd windows
.\build-windows.ps1
```

Alternatively run `build-windows.cmd`. The build publishes a self-contained x64 client,
adds the `.scr` apphost and produces `dist/imperial-school-views-windows-1.2.0-setup.exe`
and `dist/windows-release.json`. End users do not need a separate .NET installation.
The installer supports upgrading previous versions while retaining user data.

`windows-release.json` follows the existing six-field contract: `schema`, `app_id`,
`platform`, `version`, `build`, `sha256`. Publish the EXE and JSON through the site's
existing `editorial/wallpapers/views/installers/` directory.

## Development checks

```powershell
dotnet run --project Checks/Checks.csproj -c Release
```

Use `-- --live` for an explicit catalogue and current-JPEG check against the website.
59 portable checks passed. The actual x64 client and installer were built, and every
payload file was compared after installer extraction. Native Windows UI, geolocation,
wallpaper COM operations, screensaver and installer execution still require Windows testing.
See [VALIDATION.md](VALIDATION.md) for the scope and recorded results.

## Data and licensing

Data stays in `%LOCALAPPDATA%\Imperial School\Views`; logs are in `app.log`.
Select the screensaver from the application; Windows controls its idle timeout and
sign-in requirements. The Russian README contains detailed profile and viewer instructions.

Third-party notices are in [Licenses/](Licenses/) and font licenses in
[Desktop/Assets/](Desktop/Assets/). The application code license has not yet been
specified. Wallpaper artwork has separate terms.
