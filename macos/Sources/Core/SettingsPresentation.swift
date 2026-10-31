import Foundation

// The window and the tests use the same rules for relevant settings.
public struct SettingsChoice: Equatable {
    public let id: String, title: String
    public init(_ id: String, _ title: String) { self.id = id; self.title = title }
}

public struct SettingsPresentation {
    public let profile: JSON, collection: JSON, saver: Bool, own: Bool, enabled: Bool
    public init(profile: JSON, collection: JSON, saver: Bool = false, own: Bool = false, enabled: Bool = true) {
        self.profile = profile; self.collection = collection; self.saver = saver; self.own = own; self.enabled = enabled
    }
    public var weather: Bool { profile.s("source") == "weather" }
    public var dynamic: Bool { weather && collection.s("type") == "dynamic" }
    public var dailyWeather: Bool { weather && profile.s("collection") == "__weather_day__" }
    public var showProfile: Bool { !saver || (enabled && own) }
    public var showCollection: Bool { showProfile && profile.s("source") != "day" }
    public var showCity: Bool { showProfile && weather && !dynamic && !dailyWeather && profile.s("weather_provider") == "open-meteo" }
    public var showDelivery: Bool { showProfile && weather && !dynamic && !dailyWeather && !showCity }
    public var showInterval: Bool { saver && enabled && own && profile.s("mode") == "slideshow" }
    public var showDownload: Bool { showCollection && !dynamic && !dailyWeather && profile.s("source") != "local" }
    public var conditions: [SettingsChoice] {
        guard weather && !dynamic else { return [] }
        let ids = dailyWeather ? ["real", "game-world"] : collection.rows("sources").map { $0.s("id") }
        var result = [SettingsChoice]()
        if ids.contains("real") { result.append(SettingsChoice("real", "Погода с сервера")) }
        if ids.contains("game-world") { result.append(SettingsChoice("game-world", "Игровой мир")) }
        if !dailyWeather && !collection.isEmpty { result.append(SettingsChoice("open-meteo", "Погода в моём городе")) }
        return result
    }
    public var condition: String { profile.s("weather_provider") == "open-meteo" ? "open-meteo" : profile.s("weather_source", "game-world") }
    public var hint: String {
        switch profile.s("source") {
        case "weather":
            if dynamic { return "Готовый кадр приходит с сервера. Если новый кадр ещё не готов, текущие обои сохраняются." }
            if showCity { return "Условия берутся из прогноза Open-Meteo для выбранного города. Погодная коллекция скачивается целиком." }
            if condition == "game-world" { return "Кадр меняется по погоде и времени игрового мира. Город на компьютере не используется." }
            return "Кадр меняется по условиям, опубликованным сервером. Выбирать город на компьютере не нужно."
        case "local": return "Используются только скачанные изображения. Новую коллекцию можно импортировать из ZIP."
        case "online": return profile.s("mode") == "daily" ? "Коллекция с сайта. Каждый день выбирается следующий кадр." : "Коллекция с сайта. Кадры меняются по выбранному расписанию."
        default: return "Каждый день — обои, выбранные на сайте. Коллекцию выбирать не нужно."
        }
    }
    public static func settingCondition(_ choice: String, in profile: JSON) -> JSON {
        var p = profile
        p["weather_provider"] = choice == "open-meteo" ? "open-meteo" : "server"
        p["weather_source"] = choice == "game-world" ? "game-world" : "real"
        if choice == "open-meteo" { p["weather_delivery"] = "zip" }
        // Retain the last city for returning to local weather; visibility never
        // depends on whether this retained value happens to exist.
        return p
    }
    public static func modes(source: String, collection: JSON, saver: Bool) -> [SettingsChoice] {
        if source == "day" { return [SettingsChoice("featured", "Обои дня")] }
        if source == "weather" { return [SettingsChoice("weather", "По текущим условиям")] }
        var result = [SettingsChoice]()
        if !collection.j("schedule").j("monthly").isEmpty { result.append(SettingsChoice("monthly", "По месяцам")) }
        if !collection.j("schedule").j("seasonal").isEmpty { result.append(SettingsChoice("seasonal", "По сезонам")) }
        result.append(SettingsChoice("daily", "Каждый день"))
        if saver { result.append(SettingsChoice("slideshow", "Слайд-шоу")) }
        return result
    }
    public static func equal(_ a: JSON, _ b: JSON) -> Bool {
        func data(_ input: JSON) -> Data? {
            var p = input; p.removeValue(forKey:"revision"); p.removeValue(forKey:"updated_at")
            return try? JSONSerialization.data(withJSONObject:p, options:[.sortedKeys])
        }
        return data(a) == data(b)
    }
}
