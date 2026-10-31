# Imperial School Views

[Русский](README.ru.md) · English

Wallpaper clients for **Imperial School / Школа Империи** on Android, macOS and Windows.

The applications connect the wallpaper collections on [games.oopssre.ru](https://games.oopssre.ru/) with your device. They select pictures by season, time of day and weather, and can display dynamic scenes composed by the server from weather and game events.

## What the project does

- Uses the site's ordinary, weather and dynamic wallpaper collections.
- Supports server weather, fictional game-world weather and Open-Meteo locations where implemented by the client.
- Keeps downloaded images available for offline viewing and preserves the last wallpaper when an update fails.
- Provides local image viewing and a slideshow in the Android and macOS clients.
- Uses platform-specific screen settings; Android supports separate home-screen and lock-screen profiles.

Dynamic scenes are received as finished server-rendered JPEGs. The Android and macOS clients do not compose layers or calculate future scenes on the device.

## Repository status

The Android 1.3.9 source is in [`android/`](android/), and the macOS 2.0.7 source is in [`macos/`](macos/). The Windows source import will follow after its current version is checked.

Build instructions and platform features are in [`android/README.md`](android/README.md) and [`macos/README.md`](macos/README.md). The application features described above are not a claim that all platforms have identical capabilities.

## Downloads and resources

- [Imperial School games and wallpaper collections](https://games.oopssre.ru/)
- [Project blog](https://oopssre.ru/)
- [Telegram](https://t.me/oopsSRE)

Official APKs and large wallpaper collections are distributed on the [website](https://games.oopssre.ru/).

## Signing and licensing

Publisher signing keys, passwords and personal signing backups must stay outside this repository. Contributors will use their own signing configuration.

Third-party components retain their respective licenses and notices in [`android/app/src/main/assets/`](android/app/src/main/assets/) and [`macos/licences/`](macos/licences/). Wallpaper artwork has its own licensing terms, separate from application code.

The application code license has not yet been specified.
