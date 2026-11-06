# Входной комплект 0.6.0

В корне `ImperialSchoolViewsTV_0.6.0_site.zip` только `ImperialSchoolViewsTV_0.6.0.apk` и `android-tv-release.json`.
Оба файла положить в `views.root/installers/`, затем запустить обычную сборку. Публикатор сам создаёт публичные URL. Телефонный `android-release.json` не заменять.

Ключи входной build receipt: schema, app_id, platform, version, build, bytes, sha256. Контрольная сумма и размер APK сверяются при упаковке.
