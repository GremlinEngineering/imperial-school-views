package ru.oopssre.imperialschool.viewstv;

/** User-facing states; technical detail remains available in Diagnostics. */
public final class SceneCopy {
    private SceneCopy() {}
    public static String waiting(String value) {
        if (value == null) return "Загружаю обои…";
        if (value.contains("Недостаточно места") || value.contains("No space left"))
            return "На телевизоре не хватает свободного места. Откройте Настройки → Хранилище.";
        if (value.contains("Нет аппаратного"))
            return "Этот телевизор не поддерживает видео 4К. Выберите изображение в настройках показа.";
        if (value.contains("Видео для текущего кадра") || value.contains("4К-видео"))
            return "Видео этой сцены ещё не готово. Изображение доступно в настройках показа.";
        if (value.contains("не опубликован") || value.contains("ещё не готов"))
            return "Эта сцена ещё не готова. Проверю позже.";
        if (value.contains("памяти"))
            return "Не удалось открыть изображение. Выберите меньшее разрешение в настройках показа.";
        if (value.contains("Ошибка") || value.contains("не получено") || value.contains("Нет связи") || value.contains("Нет кадра"))
            return "Не удалось загрузить обои. Повторю попытку.";
        return "Загружаю обои…";
    }
    public static String parent(String page) {
        switch (page) {
            case "themes": case "music": case "settings": return "menu";
            case "screen": case "cache": case "info": return "settings";
            case "collection": return "themes";
            case "weather": case "mode": return "collection";
            case "resolution": case "scale": case "output": return "screen";
            case "volume": return "music";
            case "diagnostics": case "music_credits": case "updates": case "project": return "info";
            case "credits_detail": return "music_credits";
            default: return "menu";
        }
    }
}
