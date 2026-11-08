# Android TV 0.8.7, сборка 21

[Руководство пользователя](../../README.md) · [История изменений](../../CHANGELOG.md)

`smali/` содержит 212 классов приложения, восстановленных из релизного байткода. Java-проект в `../../app/` соответствует версии 0.7.0. Оригинальный Java/C++ проект 0.8.x пока отсутствует.

Воспроизводимая сборка использует официальный APK 0.8.6 как вход. Скрипт проверяет SHA-256, заменяет классы приложения восстановленными исходниками, проверяет сценарии навигации, собирает DEX и выставляет версию 0.8.7. Ресурсы, зависимости AndroidX и нативные библиотеки берутся из входного APK. Личный список станций и значение локального кода также берутся из входного APK.

## Сборка

Нужны Python 3.8+, JDK 17+, Apktool 2.12.1 и Android Build Tools 36.0.0. Входной `ImperialSchoolViewsTV_0.8.6.apk` находится в официальном пакете `ImperialSchoolViewsTV_0.8.6_site.zip`.

Из каталога `android-tv/releases/0.8.7`:

```sh
export ANDROID_BUILD_TOOLS=/path/to/android-sdk/build-tools/36.0.0
./rebuild_unsigned.sh /path/to/ImperialSchoolViewsTV_0.8.6.apk \
  /path/to/apktool_2.12.1.jar "$ANDROID_BUILD_TOOLS" /tmp/ImperialSchoolViewsTV_0.8.7_unsigned.apk
```

Для официального пакета на машине издателя задайте `IMPERIAL_TV_KEYSTORE` и `IMPERIAL_TV_PASSWORD_FILE`. Скрипт проверяет сертификат и создаёт ZIP с подписанным APK и `android-tv-release.json`.

```sh
python3 package_site.py /tmp/ImperialSchoolViewsTV_0.8.7_unsigned.apk dist
```

## Проверки

Хост-проверка в `qa/check_navigation.py` исполняет инструкции изменённых методов с моделями экрана и пульта. Она охватывает старт без кадра, выбор станции, фокус громкости, навигацию «Назад», истечение двух секунд и выход из заставки. `qa/NavigationProbe.java` содержит сценарий для Android TV. Полный прогон в эмуляторе остановился на установке APK. Поведение на физическом ТВ этим выпуском проверки не подтверждено.
