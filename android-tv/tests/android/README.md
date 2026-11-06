# Проверка Android TV 0.6.0

Только отдельный тестовый телевизор или чистый эмулятор: `TvUiTest` сбрасывает настройки TV-клиента, записывает тестовый снимок каталога и проверяет очистку кеша. На основном устройстве без необходимости не запускать.

Собрать основной APK, затем `python3 tests/android/build_test.py` в той же среде SDK/подписи.

```sh
adb install -r dist/ImperialSchoolViewsTV_0.6.0.apk
adb install -r tests/android/build/test.apk
adb shell am instrument -w ru.oopssre.imperialschool.viewstv.test/ru.oopssre.imperialschool.viewstv.TvUiTest > instrumentation.txt
python3 tests/android/extract_proofs.py instrumentation.txt proofs
```

Тест проходит новый интерфейс пультом, проверяет короткий/долгий OK, Back и восстановление фокуса, видимость всех трёх групп при включённом видео, выбор погодных и обычных картинок, возврат к видео, независимые переключатели музыки, отсутствие технических описаний в повседневном меню, About/диагностику, нативное чтение PNG через Repository и очистку кеша с сохранением параметров.

`TvAutoTest`, `Tv4kTest` и `TvVideoTest` сохраняют отдельные проверки профилей/видеоконтракта; для аппаратного HEVC 4K требуется подходящее устройство. Полноценную 4K возможность нельзя подтвердить размером меню Android.

В среде выпуска 0.6.0 instrumentation APK скомпилирован, но не запущен: эмулятора или физического TV здесь нет. Исторические отчёты и снимки не подтверждают новую версию.
