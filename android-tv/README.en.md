# Imperial School Views TV

[Русский](README.md) · English

Version **0.6.0, build 11**, for Android TV / Yandex TV, Android 8.0 (API 26) and later. Author: **Дмитрий Малыхин aka Timon_Crazy**. Application ID: `ru.oopssre.imperialschool.viewstv`.

The app opens directly into a wallpaper scene and can also run as an Android system screensaver (`DreamService`). It receives finished server output; no theme layers are composed on the TV.

## Features

- Ordinary, weather and dynamic wallpaper collections; PNG and JPEG support without converting PNG to JPEG.
- Published 3840×2160 HEVC video for dynamic collections, with the next clip downloaded and verified before switching at a loop boundary.
- Auto / 4K / Full HD image resolution and fit/fill settings.
- Remote navigation: hold OK for one second to open settings, use arrows and OK to select actions, and Back to return. Focus and scroll position are restored after leaving a submenu.
- Separate application and screensaver audio switches, volume and track controls. Music credits and technical diagnostics have their own pages.
- Cache usage and cleanup, preserving the selected collection, resolution and audio settings. Wallpaper cache limit: 64 MiB.
- Last verified scene retained on network failure; future scenes and entire collection archives are not downloaded.

## Source-only repository

This directory contains source code, text resources, tests and documentation. It excludes APKs, archives, JARs, fonts, images, audio, video, MIDI, VGM and register streams. Binary content is not embedded in text and no Git LFS pointers are used.

Before building or running tests, restore the 67 omitted files from `ImperialSchoolViewsTV_0.6.0_source.zip` at the same relative paths. [BINARY_RESOURCES.json](BINARY_RESOURCES.json) lists their sizes and SHA-256 checksums. Required files include the two `vendor/` JARs, application fonts and artwork, bundled music and binary test fixtures. The complete package contains seven station tracks and nine teahouse fragments; these audio files are excluded from GitHub.

The Java application source and runtime behavior are unchanged from the released source package. Historical reports describe their respective versions; omitted screenshots do not validate the current UI.

## Build and test

After restoring resources, install Python 3, JDK 17+, Android SDK Platform 36 and Build Tools 36.0.0. Gradle is not required.

```sh
cd android-tv
export ANDROID_HOME=/path/to/android-sdk
export IMPERIAL_TV_KEYSTORE=/private/path/imperial-tv.p12
export IMPERIAL_TV_PASSWORD_FILE=/private/path/password.txt
python3 test.py
python3 build.py
```

Use your own signing key with alias `tv` and a password file outside the repository. Publisher credentials are excluded. A self-signed build cannot replace an installed official build signed with a different certificate.

The release report records **151 host checks**: 73 core, 34 video and 44 PNG/collection/cache regression checks. The instrumentation APK compiled but was not executed in the release environment. Physical Yandex TV playback, audio focus and system update installation still require device testing. See [VALIDATION_0.6.0.json](docs/VALIDATION_0.6.0.json) and [Android test instructions](tests/android/README.md).

## Distribution and licensing

Official installers are distributed through [the project website](https://games.oopssre.ru/gremlin.html#views). The website package contains exactly the APK and `android-tv-release.json` at its root. Extract it into the existing `views.root/installers/` directory and run the regular site build; do not overwrite the phone client's `android-release.json`.

TV application code is [MIT](LICENSE). Third-party components and music retain their own licenses and credits; see [THIRD_PARTY.md](THIRD_PARTY.md).
