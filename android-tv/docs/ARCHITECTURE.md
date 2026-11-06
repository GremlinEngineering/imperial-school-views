# Контракты и практика Android TV

Одна сцена `TvScene` используется полноэкранной `MainActivity` и `WallpaperDream` (`DreamService`). Сетевой цикл выполняется только пока сцена активна, останавливается в lifecycle; подготовленный APK загружается только по кнопке. Нет служб автозапуска при загрузке ОС, оверлеев, сервиса доступности или прав администратора устройства.

Обои рисуются на `SurfaceView` с отдельным размером буфера. Сохранённая настройка `resolution` принимает `auto`, `4k`, `1080p` и общая для Activity/DreamService. В ручном режиме буфер задан явно; в Авто: Android TV может давать интерфейсу 1080p при физическом 4K-экране. Выбирается максимальный сообщённый системой горизонтальный режим до 3840×2160 с той же частотой. Изображение вписывается или заполняет экран с сохранением пропорций; слои на устройстве не компонуются.

Вход: `manifest-v3.json` существующего сайта. Для `orbital-port` и `sunken-teahouse` TV-клиент определяет физические режимы Display.Mode, выбирает максимальный горизонтальный режим до 4K, предпочитая текущую частоту среди режимов одного размера. Профиль Full HD/HD-ready — `desktop_1920x1080`, 4K — `desktop_3840x2160`. Размер UI не используется для определения физической панели. Верхний current.json темы сообщает готовность каждого профиля: сначала выбирается родное разрешение, затем второй готовый TV-профиль 16:9. На следующем цикле готовность проверяется снова. Кеши разрешений различаются; сохранённые дескрипторы не закрепляют прежний экран. На события DisplayManager.DisplayListener разрешение перепроверяется и при изменении перезапускается загрузка кадра. Другие динамические коллекции сохраняют выбор среди объявленных сервером форматов. Динамика: объявленный `current.json` темы, затем опубликованный JSON устройства; протокол динамических кадров 0.1/0.2, `image.url`, SHA и размеры. Погода: существующие current/forecast API и объявленные rendition, без самостоятельного расчёта осадков, Луны, часового пояса или игрового календаря. Обычные обои: schedules и формат каталога. Источником истины остаются опубликованные данные.

Кеш JPEG адресуется SHA-256, метаданные и текущие указатели записываются атомарно. Текущий кадр защищён при очистке. Неполная атомарная публикация JSON/JPEG отклоняется с повторной попыткой; ошибка сервера не заменяет успешный кадр пустотой. Отдельные источники погоды не смешивают кеши.

Обновления используют существующую Android-форму release JSON; отдельны только package ID и имя TV feed. Установка выполняется системным установщиком через частный read-only ContentProvider с разовым URI grant. Общий каталог загрузок и разрешение записи в хранилище не нужны.

Первичные источники, использованные при выборе реализации:

- Android DreamService: https://developer.android.com/reference/android/service/dreams/DreamService
- Создание Android TV приложения: https://developer.android.com/training/tv/get-started/create
- Навигация с пульта: https://developer.android.com/training/tv/get-started/navigation
- Aerial Views (приложение + заставка): https://github.com/theothernt/AerialViews
- Android DreamScene: https://github.com/klinker41/android-dreamscene
- YoWindow, официальный Android-клиент: https://play.google.com/store/apps/details?id=yo.app.free
- Установка APK на Яндекс ТВ: https://alice.yandex.ru/support/ru/tv/apps/tv-yndx

У YoWindow взят пользовательский сценарий «запустил и сразу видишь живую сцену»; утверждений о его внутренней реализации нет. Код Aerial Views и DreamScene не копировался.

## Audio modes (0.2.0)

`SceneMusic` belongs to each scene. The DreamService host creates it with
`screensaver=true`; MainActivity uses false. Persisted booleans
`music_app_enabled` (default true) and `music_screensaver_enabled` (default
false) are independent. The settings page edits each explicit key; it does
not reuse one boolean for both modes. Track position/index and music gain
are shared. Legacy `orbital_music` is read only as a fallback for app mode.

Only an active orbital scene requests audio focus and prepares MediaPlayer.
A single in-process owner prevents Activity and Dream from playing together.
Home/onPause, stop, detach, other theme and permanent audio focus loss release
the player. Transient focus loss pauses. Media buttons act on the current
mode. APK MP3 entries must be ZIP_STORED for AssetManager.openFd(). The local
source provider is isolated for a later switch to site caching; no new server
music format is introduced in this release.

## Two soundtracks (0.3.0)

Soundtracks.forTheme maps only orbital-port and sunken-teahouse to immutable
bundled packs. A scene switch releases/saves the old pack before loading the
new one. Track/position keys include pack.id, so switching collections does
not overwrite the other playlist state. The old global music_track and
music_position are read as fallback for the orbital pack only.

The two mode enable flags and gain remain shared across collections.
An unsupported theme has no pack and releases playback. Remote media keys
work for either supported collection; the settings title and track label
reflect the active pack. About lists credits for both packs.

Physical display reference: https://developer.android.com/reference/android/view/Display.Mode


0.4.1: `Protocol.publishedTheme(..., allowAlternate)` и выбор кеша разрешают подстановку только в Авто. При ручном выборе запрашивается точный TV-профиль. `SceneController` пропускает декодирование только при совпадении SHA и размера целевого буфера. Поэтому переход 1080p → 4К при неизменном JPEG восстанавливает исходный размер. Диагностика показывает `SurfaceHolder.surfaceChanged` как фактический размер буфера, размеры живого Bitmap и профиль реально показанного Frame. Размер Surface не доказывает физическое разрешение панели/HDMI.
