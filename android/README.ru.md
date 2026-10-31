# Виды и обои · Android

Русский · [English](README.md) · [О проекте](../README.ru.md)

Версия **1.3.9**, Android 8.0+ (API 26), пакет `ru.oopssre.imperialschool.views`.

Клиент устанавливает обои из коллекций «Школы Империи». Поддерживает отдельные профили главного экрана и блокировки, обычные и погодные наборы, серверную погоду и игровой мир, поиск города Open-Meteo и разовую геолокацию, скачанные погодные пакеты, просмотрщик с фильтрами и слайд-шоу каждые две секунды. Для динамических тем получает готовый JPEG с сервера; слои на телефоне не собирает.

## Сборка

Нужны JDK 17, Android SDK Platform 36 и Build Tools 35.0.0 (можно дополнительно установить 36.0.0). Gradle wrapper фиксирует Gradle 8.13 и его контрольную сумму. При первом запуске зависимости скачиваются из сети.

Из этой папки:

```sh
export ANDROID_HOME=/абсолютный/путь/к/Android/sdk
./gradlew :app:testDebugUnitTest :app:assembleDebug
```

Отладочный APK появится в `app/build/outputs/apk/debug/`. Подписанная release-сборка:

```sh
./build-android.sh
```

Скрипт использует существующие настройки подписи либо создаёт личный ключ вне репозитория в `~/.config/imperial-school-views/`. Для другого существующего файла настроек:

```sh
IMPERIAL_SIGNING_PROPERTIES=/абсолютный/личный/путь/android-signing.properties ./build-android.sh
```

Пример файла (значения заполняются только локально, файл в Git не добавляется):

```properties
storeFile=android-release.jks
storePassword=YOUR_LOCAL_PASSWORD
keyAlias=YOUR_LOCAL_ALIAS
keyPassword=YOUR_LOCAL_PASSWORD
```

Относительный путь `storeFile` считается от папки файла настроек. Сборка с личным ключом не обновляет официально установленное приложение: для обновления требуется тот же ключ подписи.

## Публикация

В `dist/` появляются подписанный APK и `android-release.json` — файлы для размещения на сайте. Исходники распространяются через этот репозиторий. Личные копии ключа хранятся отдельно; сборщик больше не создаёт резервную копию ключа в дереве исходников.

В приложении есть ссылки на [репозиторий](https://github.com/GremlinEngineering/imperial-school-views) и [сообщения об ошибках](https://github.com/GremlinEngineering/imperial-school-views/issues).

## Проверки и материалы

В `VALIDATION.md` указаны результаты проверки и её границы. У предыдущей версии 1.3.8 прошёл 161 тест JVM/Robolectric; результаты текущего выпуска записываются отдельно. Проверка на физическом телефоне отличается от проверки JVM.

Контракт сервера: `docs/CLIENT_API_1.7.0.md` и `docs/DYNAMIC_1.3.8.md`. Лицензии сторонних компонентов сохранены в `app/src/main/assets/`.

[Коллекции и загрузки](https://games.oopssre.ru/) · [Блог](https://oopssre.ru/)
