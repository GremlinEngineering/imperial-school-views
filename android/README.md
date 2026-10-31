# Imperial School Views for Android

English · [Русский](README.ru.md) · [Project overview](../README.md)

Version **1.3.9**, Android 8.0+ (API 26), package `ru.oopssre.imperialschool.views`.

The Android client sets wallpapers from the Imperial School collections. It supports independent home/lock profiles, ordinary and weather collections, server weather and game-world weather, Open-Meteo city search and one-shot device location, downloaded weather packs, a local viewer with filters and a two-second slideshow. Dynamic collections use finished server JPEGs; no layer composition runs on the phone.

## Build

Requirements: JDK 17, Android SDK Platform 36 and Build Tools 35.0.0 (36.0.0 may also be installed). The included Gradle wrapper pins Gradle 8.13 and its checksum. Initial dependency downloads require internet access.

From this directory:

```sh
export ANDROID_HOME=/absolute/path/to/Android/sdk
./gradlew :app:testDebugUnitTest :app:assembleDebug
```

The debug APK is written to `app/build/outputs/apk/debug/`. For a signed release:

```sh
./build-android.sh
```

The script uses an existing signing configuration or creates a personal key outside the repository under `~/.config/imperial-school-views/`. To use a different existing configuration:

```sh
IMPERIAL_SIGNING_PROPERTIES=/absolute/private/path/android-signing.properties ./build-android.sh
```

Example configuration (replace the placeholders locally; never commit the filled file):

```properties
storeFile=android-release.jks
storePassword=YOUR_LOCAL_PASSWORD
keyAlias=YOUR_LOCAL_ALIAS
keyPassword=YOUR_LOCAL_PASSWORD
```

A relative `storeFile` resolves against the configuration file's directory. A personally signed build cannot update the official installed application unless it uses the same signing key.

## Publish

`dist/` contains the signed APK and `android-release.json`. These are the website deployment files. Source is distributed through this repository; publisher key backups remain outside it. The build no longer writes a signing backup into the source tree.

The application links to [this repository](https://github.com/GremlinEngineering/imperial-school-views) and its [issue tracker](https://github.com/GremlinEngineering/imperial-school-views/issues).

## Validation and resources

See `VALIDATION.md` for the recorded validation and its limits. The earlier 1.3.8 release passed 161 JVM/Robolectric tests; current-release results are recorded separately. A physical-device test is distinct from JVM checks.

Server contract notes are in `docs/CLIENT_API_1.7.0.md` and `docs/DYNAMIC_1.3.8.md`. Third-party license notices are kept in `app/src/main/assets/`.

[Wallpaper collections and downloads](https://games.oopssre.ru/) · [Blog](https://oopssre.ru/)
