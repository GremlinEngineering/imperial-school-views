import Foundation

public enum Contracts {
    public static func format(_ collection: JSON, width: Double, height: Double, requested: String) throws -> String {
        let rows: [JSON] = collection.j("formats").compactMap { key, value in guard var f = value as? JSON, f.n("width") > f.n("height") else { return nil }; f["rendition"] = key; return f }
        return try DataModel.bestFile(rows, width: width, height: height, format: requested).s("rendition")
    }
    public static func source(_ collection: JSON, id: String) throws -> JSON {
        guard let s = collection.rows("sources").first(where: { $0.s("id") == id }) else { throw ViewsError("Источник погоды недоступен") }
        let prefix = "weather/\(collection.s("id"))/" + (id == "game-world" ? "sources/game-world/" : "")
        try endpoint(s.s("current_url"), expected: prefix + "current.json")
        for (format, value) in s.j("forecasts") { try endpoint(value as? String ?? "", expected: prefix + "forecast-\(format).json") }; return s
    }
    public static func endpoint(_ actual: String, expected: String) throws { try require(actual == expected || actual == expected + ".br", "Неверный адрес JSON") }
    public static func identity(_ document: JSON) -> String { [document.s("collection_id"), document.s("source_id"), document.s("location_revision"), document.s("world_id"), document.s("timezone")].joined(separator: "|") }
    public static func weatherPair(current: JSON, forecast: JSON, collection: JSON, source: String, format: String) throws {
        try require(current.n("schema") == 1 && current.s("type") == "weather" && current.s("collection_id") == collection.s("id") && current.s("source_id") == source && !current.s("location_revision").isEmpty && TimeZone(identifier: current.s("timezone")) != nil, "Неверная текущая погода")
        try require(forecast.n("schema") == 1 && forecast.s("document_type") == "weather-forecast" && forecast.s("format") == format && identity(current) == identity(forecast), "Прогноз относится к другому источнику или местоположению")
        guard let generated = DataModel.date(forecast.s("generated_at")), let until = DataModel.date(forecast.s("valid_until")), generated < until else { throw ViewsError("Неверный срок прогноза") }
        try require(forecast.rows("intervals").count <= 4000, "Слишком большой прогноз")
        var end: Date?
        for row in forecast.rows("intervals") {
            guard let a = DataModel.date(row.s("valid_from")), let b = DataModel.date(row.s("valid_until")), a < b, end == nil || end! <= a else { throw ViewsError("Пересекающиеся интервалы прогноза") }; end = b
            if row.s("status") == "ready" {
                let file = row.j("file"); try DataModel.validateFile(file)
                try require(file.s("rendition") == format && file.n("width") == collection.j("formats").j(format).n("width") && file.n("height") == collection.j("formats").j(format).n("height") && file.s("url").hasPrefix("collections/\(collection.s("id"))/files/") && file.s("url").hasSuffix(".jpg"), "Файл не соответствует погодному формату")
            }
        }
    }
    public static func interval(_ forecast: JSON, at now: Date) throws -> JSON {
        guard let until = DataModel.date(forecast.s("valid_until")), now < until else { throw ViewsError("Прогноз истёк; сохранён последний кадр") }
        let rows = forecast.rows("intervals").filter { row in guard let a = DataModel.date(row.s("valid_from")), let b = DataModel.date(row.s("valid_until")) else { return false }; return a <= now && now < b }
        try require(rows.count == 1 && rows[0].s("status") == "ready", "Текущий погодный кадр ещё не готов"); return rows[0]
    }
    public static func daily(_ document: JSON, source: String, at now: Date) throws {
        try require(document.n("schema") == 1 && document.s("document_type") == "weather-of-day" && document.s("source_id") == source, "Неверная погода дня")
        try require(document.s("status") == "ready", "Погода дня ещё не опубликована")
        guard let from = DataModel.date(document.s("valid_from")), let until = DataModel.date(document.s("valid_until")), from <= now && now < until else { throw ViewsError("Погода дня истекла; сохранён последний кадр") }
        for (_, value) in document.j("files") { try DataModel.validateFile(value as? JSON ?? [:]) }
    }
    public static func dynamic(descriptor: JSON, state: JSON, collection: JSON, device: String, at now: Date) throws -> JSON {
        let id = collection.s("id"), prefix = "dynamic/\(id)/devices/\(device)/"
        try require(descriptor.n("schema") == 1 && descriptor.s("type") == "dynamic" && descriptor.s("collection_id") == id && descriptor.s("source_id") == "real" && descriptor.s("status") == "ready", "Динамическая тема ещё не опубликована")
        try endpoint(descriptor.j("states").s(device), expected: prefix + "current.json")
        try require(["ready", "stale"].contains(descriptor.j("format_status").j(device).s("status")), "Этот формат темы ещё не готов")
        try require(state.n("schema") == 1 && state.s("schema_version") == "0.2" && state.s("type") == "dynamic-state" && state.s("theme_id") == id && state.s("device") == device, "Неверный кадр динамической темы")
        guard let at = DataModel.date(state.s("at")), let until = DataModel.date(state.s("valid_until")), at <= now.addingTimeInterval(60), now < until else { throw ViewsError("Кадр темы истёк; сохранён последний кадр") }
        let file = state.j("image"), spec = collection.j("formats").j(device); try DataModel.validateFile(file)
        try require(["jpg", "jpeg"].contains(file.s("format")) && file.s("url") == prefix + "current.jpg" && file.s("sha256") == descriptor.j("files").j(device).s("sha256") && file.n("width") == spec.n("width") && file.n("height") == spec.n("height"), "Кадр не соответствует описанию темы")
        return file
    }
    public static func package(_ manifest: JSON, id: String, format: String, version: String) throws {
        try require(manifest.n("schema") == 3 && manifest.s("document_type") == "weather-wallpaper-package" && manifest.s("id") == id && manifest.s("format") == format && manifest.s("version") == version && !manifest.rows("variants").isEmpty && manifest.rows("variants").count <= 8000, "ZIP относится к другому погодному пакету")
        var paths = Set<String>()
        for v in manifest.rows("variants") { try DataModel.validateFile(v); try require(v.s("rendition") == format && DataModel.matches(v.s("url"), "^files/[a-z0-9-]+\\.jpg$") && paths.insert(v.s("url")).inserted && (v.s("moon_phase") == "none" || DataModel.phases.contains(v.s("moon_phase"))), "Неверный вариант пакета") }
    }
}

public struct GalleryRow {
    public var file: JSON; public var rules: [JSON]; public var url: URL
    public var title: String { rules.first?.s("title", rules.first?.s("state_id", "Вид") ?? "Вид") ?? "Вид" }
    public static func merge(_ values: [(JSON, JSON, URL)]) -> [GalleryRow] {
        var indices: [String: Int] = [:], rows: [GalleryRow] = []
        for (file, rule, url) in values { let key = file.s("sha256"); if let i = indices[key] { rows[i].rules.append(rule) } else { indices[key] = rows.count; rows.append(GalleryRow(file: file, rules: [rule], url: url)) } }; return rows
    }
    public func matches(_ filters: [String: String]) -> Bool { rules.contains { rule in filters.allSatisfy { key, value in value.isEmpty || rule.s(key) == value } } }
}
