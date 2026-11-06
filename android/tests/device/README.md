# Native Android UI checks

Use a disposable emulator or test device only: the runner replaces the application's settings and local collections with deterministic fixtures. The fixture image is supplied locally and is not published with the source.

Build the app release with the existing publisher key. Set `ANDROID_HOME` and `IMPERIAL_SIGNING_PROPERTIES` as for the release build, then:

```sh
python3 tests/device/build.py --image /absolute/path/to/portrait.jpg
adb install -r dist/ImperialSchoolViews_Android_1.4.0.apk
adb install -r tests/device/build/test.apk
adb shell am instrument -w ru.oopssre.imperialschool.views.test/ru.oopssre.imperialschool.views.test.PhoneUiTest
```

For an upgrade check, install 1.3.9 first, install the test APK, run the instrumentation with `-e mode seed`, then install 1.4.0 with `-r` and rerun with `-e mode verify-upgrade`. Both app APKs and the test APK must use the same signing certificate.

Checks cover device eligibility in the gallery, the native adaptive icon, hidden secondary preferences, destination choice and cancellation, independent home/lock selection, installed-wallpaper management, and the offline viewer. Screenshots are written to the app's external `qa-140` directory. Test fixture screens are not evidence of a live weather-server integration or physical-device behaviour.
