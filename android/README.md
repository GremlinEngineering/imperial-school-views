# Imperial School Views for Android

English · [Русский](README.ru.md) · [Project overview](../README.md)

Version **1.4.0**, Android 8.0+ (API 26), package `ru.oopssre.imperialschool.views`.

Choose a phone-compatible collection from image cards, inspect the preview, then tap Apply and choose home, lock or both screens. Cancelling preserves existing wallpapers and settings. The Installed wallpapers menu refreshes, pauses or stops automatic changes independently of the current preview selection.

Ordinary, weather and dynamic collections remain separate. Browsing and collection notices share the same phone availability check. Adding a phone format to an existing desktop collection counts as a new phone collection. Migration establishes a quiet baseline without a notification burst.

City search and one-shot device location remain directly accessible in the weather section. Server weather, game-world weather and Open-Meteo are retained. Network policy, collection downloads, notifications and app information are in Settings.

The offline viewer supports gestures, filters and a two-second slideshow; additional actions are in its menu. Dynamic scenes use finished server JPEGs. No phone 4K or video support was added. The adaptive launcher icon pairs a phone with the TV client's gamepad and includes a monochrome layer for themed icons.

## Build

Requirements: JDK 17, Android SDK Platform 36 and Build Tools 36.0.0. The included Gradle wrapper pins Gradle 8.13 and its checksum. Initial dependency downloads require internet access.

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

See `VALIDATION.md` for the recorded validation and its limits. Release 1.4.0 passed 178 JVM/Robolectric tests. The validation record also covers the built APK and the upgrade from 1.3.9. A physical phone was not used.

Server contract notes are in `docs/CLIENT_API_1.7.0.md` and `docs/DYNAMIC_1.3.8.md`. Third-party license notices are kept in `app/src/main/assets/`.

[Wallpaper collections and downloads](https://games.oopssre.ru/) · [Blog](https://oopssre.ru/)
