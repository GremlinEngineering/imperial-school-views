# Imperial School Views

[Русский](README.ru.md) · English

Wallpaper clients for **Imperial School / Школа Империи** on Android, macOS and Windows.

The applications connect the wallpaper collections on [games.oopssre.ru](https://games.oopssre.ru/) with your device. They select pictures by season, time of day and weather, and can display dynamic scenes composed by the server from weather and game events.

## What the project does

- Uses the site's ordinary, weather and dynamic wallpaper collections.
- Supports server weather, fictional game-world weather and Open-Meteo locations where implemented by the client.
- Keeps downloaded images available for offline viewing and preserves the last wallpaper when an update fails.
- Provides local image viewing and a slideshow in the Android client.
- Uses platform-specific screen settings; Android supports separate home-screen and lock-screen profiles.

Dynamic scenes are received as finished server-rendered JPEGs. The current Android implementation does not compose layers or calculate future scenes on the device.

## Repository status

This repository currently contains the project documentation. The Android 1.3.8 source import is pending; macOS and Windows sources will be added separately after their current versions are checked.

Platform features and build instructions will be documented with each source import. The application features described above are not a claim that all platforms have identical capabilities.

## Downloads and resources

- [Imperial School games and wallpaper collections](https://games.oopssre.ru/)
- [Project blog](https://oopssre.ru/)
- [Telegram](https://t.me/oopsSRE)

Application packages and large wallpaper collections are distributed separately from the source repository.

## Signing and licensing

Publisher signing keys, passwords and personal signing backups must stay outside this repository. Contributors will use their own signing configuration.

The code license will be specified with the source import. Third-party components retain their respective licenses; wallpaper artwork has its own licensing terms.
