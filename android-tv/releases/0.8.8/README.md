# Android TV 0.8.8, сборка 22

[Руководство пользователя](../../README.md) · [История изменений](../../CHANGELOG.md)

Исправлена передача управления установщику. Из заставки запрос передаётся обычному окну приложения. Заставка закрывается, и после получения фокуса приложение открывает установщик. Если Android запрашивает разрешение, после возврата из настроек приложение проверяет его и продолжает установку. При отказе можно повторить попытку из меню обновлений.

На 0.8.6 и 0.8.7, если после «Установить» заставка остаётся на экране, выйдите из неё. Android покажет уже открытое окно установки.

## Сборка

Входной файл — официальный `ImperialSchoolViewsTV_0.8.7.apk`. Скрипт проверяет SHA-256, применяет изменения к восстановленному байткоду, проверяет переходы и собирает APK. Нужны Python 3.8+, JDK 17+, Apktool 2.12.1, Android Build Tools 36.0.0, `patch` и `sha256sum`.

```sh
export ANDROID_BUILD_TOOLS=/path/to/android-sdk/build-tools/36.0.0
./rebuild_unsigned.sh /path/to/ImperialSchoolViewsTV_0.8.7.apk \
  /path/to/apktool_2.12.1.jar "$ANDROID_BUILD_TOOLS" /tmp/ImperialSchoolViewsTV_0.8.8_unsigned.apk
python3 package_site.py /tmp/ImperialSchoolViewsTV_0.8.8_unsigned.apk dist
```

Для подписи на машине издателя задайте `IMPERIAL_TV_KEYSTORE` и `IMPERIAL_TV_PASSWORD_FILE`. Скрипт проверяет сертификат и упаковывает APK и `android-tv-release.json`.

## Проверки

`qa/check_handoff.py` исполняет изменённые инструкции с моделями Android. Проверяются обычное окно, выход из заставки, однократный запуск после получения фокуса, разрешение и отказ, отсутствующий APK и ошибка запуска Activity.
