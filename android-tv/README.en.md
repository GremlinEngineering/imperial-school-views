# Imperial School Views · Android TV

[Русский](README.md) · English · [About the project](https://github.com/GremlinEngineering/imperial-school-views)

Version **0.7.0, build 12**. Android TV / Yandex TV, Android 8.0+ (API 26), application ID `ru.oopssre.imperialschool.viewstv`.

The app opens directly into an Imperial School wallpaper scene and also works as an Android system screensaver. Dynamic scenes arrive ready to display; the television does not compose their layers.

## Usage

Hold OK for one second to open the menu. A short OK press leaves the scene unchanged. Use arrows to move focus, OK to select and Back to return. Focus and scroll position are restored.

The main menu contains **Choose wallpapers**, **Music** when available, and **Settings**. The picker shows an image preview and short description alongside the collection list. Focus previews a collection; OK applies it and returns to the scene. Live scenes, weather and image collections remain available in every output mode. Current-collection settings beside the picker provide weather source or scheduled image changes.

Music retains separate app/screensaver switches and track controls. Left/right changes the selected volume setting inline. The television's system volume remains separate. About lists individual music credits rather than a full technical essay.

## Settings

- **Image display**: dynamic image/video output, Auto/4K/Full HD image resolution, fit/fill and a manual scene refresh.
- **System screensaver**: Android's screensaver settings. An arrow key exits the screensaver.
- **Storage**: usage and cleanup, preserving the selected collection and settings.
- **About**: author, version, website, source code, app updates, music credits and diagnostics. Website and GitHub links include offline QR codes and readable addresses.

Before enabling video, the app checks published metadata and declared hardware HEVC 4K support. The choice remains disabled until availability is established, with an explanation. This is a capability check, not proof of physical playback. There is no silent image fallback or software 1080p substitution.

## Data and storage

PNG retains its original format; JPEG and published HEVC 3840×2160 clips remain supported. Video uses the dynamic theme's standard `desktop_3840x2160` profile and `video` block. The next clip is verified and prepared while the current clip plays, then replaces it at a loop boundary. The last checked scene remains visible when an update fails.

The arbitrary 64 MiB total cache cap has been removed. Retention keeps the latest collection/profile snapshots and live/prepared media. Obsolete files are removed before writing; storage pressure reclaims older unused snapshots. Real filesystem free space is checked. Image decode and video preparation/playback pin their files against eviction. The individual downloaded image/video limit remains 32 MiB.

Only the focused collection is previewed, after a short debounce. No collection ZIPs or future scenes are prefetched. Cleanup drains preview, image, video and decoder work before removing cache data and reloading the selected scene. Settings remain intact. Android may reclaim cache itself.

All sixteen previous music assets remain unchanged: seven station and nine teahouse tracks, with independent saved playlist positions. Unsupported collections stop music.

## Build and distribution

Python 3, JDK 17+, Android SDK Platform 36 and Build Tools 36.0.0 are required. Gradle is not required. For a GitHub checkout, copy resources and dependencies from the complete source package; checksums are listed in `BINARY_RESOURCES.json`.

```sh
export ANDROID_HOME=/path/to/android-sdk
export IMPERIAL_TV_KEYSTORE=/private/path/imperial-tv.p12
export IMPERIAL_TV_PASSWORD_FILE=/private/path/password.txt
python3 build.py
python3 test.py
```

Signing material stays outside the source package. A different signing certificate cannot update the official application.

The website ZIP contains only the APK and `android-tv-release.json` at its root. Extract both into the existing `views.root/installers/`, then run the regular site build. The phone client's receipt is separate. The server builder creates public URLs and the release envelope. App-update checks do not depend on scene retrieval.

**215 host checks and 52 Android UI checks passed** on an API 28 emulator. Screenshots were inspected. This does not establish hardware HEVC 4K playback or physical Yandex TV behavior.

Validation results and limitations are in [VALIDATION_0.7.0.json](docs/VALIDATION_0.7.0.json). Device checks are documented in [tests/android/README.md](tests/android/README.md). Historical reports apply only to their named versions.

Author: **Дмитрий Малыхин aka Timon_Crazy**. Application code is [MIT](LICENSE). Third-party and music licenses remain applicable; see [THIRD_PARTY.md](THIRD_PARTY.md).
