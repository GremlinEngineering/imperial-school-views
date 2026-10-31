# Imperial School Views for macOS

[Русский](README.ru.md) · English

Game landscapes from Imperial School on your Mac desktop and screen saver.
The app connects to the [project's wallpaper collections](https://games.oopssre.ru/),
changes pictures by schedule or weather, and provides a viewer for downloaded frames.

## Features

- Wallpaper of the day and daily, monthly or seasonal collection schedules.
- Server weather, game-world weather and a selected Open-Meteo location.
- A shared profile for all displays or separate settings for each screen.
- Offline collection downloads and ZIP import.
- A screen saver using desktop frames or its own collection and slideshow.
- An image viewer with filters, zoom, full screen and slideshow controls.
- Finished dynamic-scene frames from the server, retaining the last wallpaper
  when a new frame is unavailable.

The client uses Swift and AppKit; the screen saver uses Objective-C. It does not
run JavaScript or separate display-detection utilities. Dynamic scenes arrive
as finished JPEGs; the client does not compose image layers.

## Using the app

In **Wallpapers**, choose a display, source, collection and conditions, then
click **Apply**. Location controls appear only for local Open-Meteo weather.
Advanced options are collapsed, and the preview shows the current desktop.

The screen saver has a separate pane. The application pane contains its version,
updates, licenses and a button linking to the source repository on GitHub.

## Build

Requires macOS 12+ and Apple Command Line Tools or Xcode with Swift 5.9+.
From the repository root:

```sh
cd macos
./build-macos.sh
```

The `dist/` directory receives a universal Apple Silicon/Intel DMG and
`release.json`. Dependencies are included. Local ad-hoc signing is the default.
The build does not start the app or change the desktop wallpaper.

Options: `--app-only`, `--output DIRECTORY`, `--development`, `--signed`.
Developer ID signing and notarization use your own `DEVELOPER_ID_APPLICATION`
and `NOTARY_KEYCHAIN_PROFILE` environment variables.

For an existing DMG, generate its metadata separately:

```sh
./make-release.sh dist/ImperialSchoolViews-Mac-2.0.7.dmg
```

The descriptor contains `schema`, `app_id`, `platform`, `version`, `build` and
the DMG's SHA-256. Renaming the DMG is supported because matching uses its hash.

## Install

Quit the previous client from its menu-bar icon. Drag the app from the DMG into
Applications, eject the disk image, then open the app from Applications.
Settings and downloaded collections remain in
`~/Library/Application Support/Imperial School Views`.

Install the screen saver from its pane, then select it in macOS System Settings.

## Checks and licenses

Run `./test-core.sh` separately for core and coordination checks. Tests using
modeled system classes do not replace running AppKit, location services or the
screen saver on macOS.

Third-party components: ZIPFoundation 0.9.20 and Brotli 1.2.1 (MIT), system zlib;
astronomical equations adapted from Astral 3.2 (Apache-2.0). License texts and
notices are in [`licences/`](licences/). The application code license has not yet
been specified; wallpaper artwork has separate licensing terms.

[Collections and downloads](https://games.oopssre.ru/) · [Blog](https://oopssre.ru/) ·
[Telegram](https://t.me/oopsSRE) · [VK](https://vk.ru/club238642156)
