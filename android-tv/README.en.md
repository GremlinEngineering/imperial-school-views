# Imperial School Views · Android TV

[Русский](README.md) · English · [About the project](https://github.com/GremlinEngineering/imperial-school-views)

Version **0.8.8, build 22**. Android TV / Yandex TV, Android 8.0+ (API 26), application ID `ru.oopssre.imperialschool.viewstv`.

The app displays Imperial School wallpapers and works as an Android system screensaver. If a frame is unavailable at launch, the app opens the menu and keeps it visible when the frame arrives. Dynamic scenes arrive ready to display; the television does not compose their layers.

## Usage

Hold OK for one second to open the menu. A short OK press leaves the scene unchanged. Use arrows to move focus, OK to select and Back to return. On the wallpaper screen, press Back twice within two seconds to exit the app. Focus and scroll position are restored.

The main menu contains **Choose wallpapers**, **Music** when available, and **Settings**. The picker shows an image preview and short description alongside the collection list. Focus previews a collection; OK applies it and returns to the scene. Live scenes, weather and image collections remain available in every output mode. Current-collection settings beside the picker provide weather source or scheduled image changes.

Music offers themed radio stations and downloadable tracks. Selecting a station opens Music and focuses its volume control. Left/right changes app volume. The app and screensaver have separate audio switches.

Starting an update from the screensaver dismisses it before opening the Android installer. On versions 0.8.6 and 0.8.7, exit the screensaver after selecting Install if it covers the installer.

## Settings

- **Image display**: dynamic image/video output, Auto/4K/Full HD image resolution, fit/fill and a manual scene refresh.
- **System screensaver**: Android's screensaver settings. An arrow key exits the screensaver.
- **Proxy** — SOCKS5 or HTTP with separate switches for radio and other external connections.
- **Storage**: usage and cleanup, preserving the selected collection and settings.
- **About**: author, version, website, source code, app updates, music credits and diagnostics. Website and GitHub links include offline QR codes and readable addresses.

Before enabling video, the app checks published metadata and declared hardware HEVC 4K support. The choice remains disabled until availability is established, with an explanation. This is a capability check, not proof of physical playback. There is no silent image fallback or software 1080p substitution.

## Data and storage

PNG retains its original format; JPEG and published HEVC 3840×2160 clips remain supported. Video uses the dynamic theme's standard `desktop_3840x2160` profile and `video` block. The next clip is verified and prepared while the current clip plays, then replaces it at a loop boundary. The last checked scene remains visible when an update fails.

The arbitrary 64 MiB total cache cap has been removed. Retention keeps the latest collection/profile snapshots and live/prepared media. Obsolete files are removed before writing; storage pressure reclaims older unused snapshots. Real filesystem free space is checked. Image decode and video preparation/playback pin their files against eviction. The individual downloaded image/video limit remains 32 MiB.

Only the focused collection is previewed, after a short debounce. No collection ZIPs or future scenes are prefetched. Cleanup drains preview, image, video and decoder work before removing cache data and reloading the selected scene. Settings remain intact. Android may reclaim cache itself.

Theme music packs are downloaded from the site and cached for offline playback. Internet radio uses AndroidX Media3.

## Build and distribution

The [0.8.8 patch sources](releases/0.8.8/README.md) rebuild the release from the official 0.8.7 APK. The Java project, `build.py`, `test.py` and `BINARY_RESOURCES.json` in this directory are for 0.7.0.

Extract the APK and `android-tv-release.json` from `ImperialSchoolViewsTV_0.8.8_site.zip` into `views.root/installers/`, then run the regular site build.

The [0.8.8 release notes](releases/0.8.8/README.md) describe the installer handoff checks. Reports in `docs/` apply to their named versions.

Author: **Дмитрий Малыхин aka Timon_Crazy**. Application code is [MIT](LICENSE). Third-party and music licenses remain applicable; see [THIRD_PARTY.md](THIRD_PARTY.md).
