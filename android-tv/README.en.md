# Imperial School Views · Android TV

[Русский](README.md) · English · [About the project](../README.md)

Version **0.6.0, build 11**. Android TV / Yandex TV, Android 8.0+ (API 26), application ID `ru.oopssre.imperialschool.viewstv`.

The app displays Imperial School wallpaper collections on a television and works as an Android system screensaver. It opens directly into the wallpaper scene. Dynamic scenes arrive ready to display from the server; no layers are composed on the TV.

## Features

- Ordinary, weather and dynamic collections, with PNG and JPEG support.
- Server-published 3840×2160 HEVC video for dynamic themes.
- Auto / 4K / Full HD image resolution and fit/fill settings.
- Server weather, game-world weather and scheduled changes for ordinary collections.
- Independent application and screensaver audio settings, volume and track controls.
- Cache usage and cleanup, preserving the selected theme and settings.
- Last verified image or video retained when an update fails.

## Usage

Hold OK for **one second** to open settings. Use arrows to move focus and a short OK press to select an item. Back returns to the previous page, closes settings to the scene, or exits from the scene. Focus and scroll position are restored after leaving a submenu.

Choose a collection in **Wallpapers**, then the output mode, resolution and scaling in **Screen**. Weather and ordinary collections use images; the video preference is retained for dynamic themes.

**Music** provides separate application and screensaver sound switches, volume and track controls. It appears for collections with a soundtrack. Credits are in **About → Music and authors**; technical information is in **Diagnostics**.

**Cache** shows total usage, wallpaper storage and the downloaded app update. Cleanup removes cached images, clips, metadata and the update installer, then reloads the current scene. The selected theme, resolution and audio settings are preserved.

Open the system screensaver settings to select the app using Android's controls. Pressing an arrow key exits the screensaver.

## Data and updates

Wallpapers use a private cache limited to **64 MiB**. Entire collection archives and future scenes are not downloaded. The last verified scene remains available if the network fails.

The next clip is downloaded and verified while the previous one keeps playing, then replaces it at a loop boundary. Video requires a published `desktop_3840x2160` profile and a `video` block for the dynamic theme. If no clip has been published, image mode can be selected.

The application package includes seven station music fragments and nine teahouse fragments, with separate saved playlist positions. Playback stops for collections without music. App volume does not change the television's system volume.

App updates are checked using the settings button. The package, signing certificate and checksum are verified before opening Android's system installer.

## Build

Python 3, JDK 17+, Android SDK Platform 36 and Build Tools 36.0.0 are required. Gradle is not required.

Before building or running tests, copy dependencies and resources from `ImperialSchoolViewsTV_0.6.0_source.zip`, preserving their relative paths. File paths and checksums are listed in [BINARY_RESOURCES.json](BINARY_RESOURCES.json).

From the repository root:

```sh
cd android-tv
export ANDROID_HOME=/path/to/android-sdk
export IMPERIAL_TV_KEYSTORE=/private/path/imperial-tv.p12
export IMPERIAL_TV_PASSWORD_FILE=/private/path/password.txt
python3 build.py
```

Use your own signing key with alias `tv` and a password file outside the repository. A build signed with a different certificate cannot update an installed official application.

The build creates an APK, `android-tv-release.json` and a website package in `dist/`. The APK is universal and does not depend on Google Play Services.

## Website distribution

`ImperialSchoolViewsTV_0.6.0_site.zip` contains the APK and `android-tv-release.json` at its root. Extract them into the existing `views.root/installers/` directory and run the regular site build. The phone client's `android-release.json` is a separate file.

Official installers are distributed on [the project website](https://games.oopssre.ru/gremlin.html#views).

## Checks and licensing

Run the host checks with:

```sh
python3 test.py
```

**151 checks passed**: 73 core, 34 video and 44 PNG/catalogue/cache regression checks. The Android test APK compiled; physical Yandex TV playback, audio focus and system update installation still require device testing.

Results and validation limits are in [VALIDATION_0.6.0.json](docs/VALIDATION_0.6.0.json). Remote-control and screensaver tests are described in [tests/android/README.md](tests/android/README.md).

Author: **Дмитрий Малыхин aka Timon_Crazy**. TV application code is [MIT](LICENSE). Third-party component and music licenses and credits are in [THIRD_PARTY.md](THIRD_PARTY.md).
