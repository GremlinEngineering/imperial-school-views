import Foundation
import ViewsNative

public typealias JSON = [String: Any]
public struct ViewsError: LocalizedError { public let message: String; public init(_ message: String) { self.message = message }; public var errorDescription: String? { message } }
public func require(_ condition: @autoclosure () throws -> Bool, _ message: String) throws { if try !condition() { throw ViewsError(message) } }
public extension Dictionary where Key == String, Value == Any {
    func s(_ key: String, _ fallback: String = "") -> String { self[key] as? String ?? fallback }
    func n(_ key: String, _ fallback: Double = 0) -> Double { (self[key] as? NSNumber)?.doubleValue ?? fallback }
    func b(_ key: String, _ fallback: Bool = false) -> Bool { self[key] as? Bool ?? fallback }
    func j(_ key: String) -> JSON { self[key] as? JSON ?? [:] }
    func rows(_ key: String) -> [JSON] { self[key] as? [JSON] ?? [] }
}
public enum DataModel {
    public static let version = "2.0.7"
    public static let manifestURL = "https://games.oopssre.ru/assets/arcade/views/manifest-v3.json"
    public static let phases = ["new_moon", "waxing_crescent", "first_quarter", "waxing_gibbous", "full_moon", "waning_gibbous", "last_quarter", "waning_crescent"]
    public static func matches(_ text: String, _ pattern: String) -> Bool { text.range(of: pattern, options: .regularExpression) != nil }
    public static func hash(_ value: String) -> Bool { matches(value, "^[a-f0-9]{64}$") }
    public static func id(_ value: String) -> Bool { matches(value, "^[a-z0-9][a-z0-9_-]{0,161}$") }
    public static func stamp(_ date: Date = Date()) -> String { ISO8601DateFormatter().string(from: date) }
    public static func date(_ text: String) -> Date? {
        guard matches(text, "(Z|[+-][0-9]{2}:[0-9]{2})$") else { return nil }
        let f = ISO8601DateFormatter(); f.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return f.date(from: text) ?? ISO8601DateFormatter().date(from: text)
    }
    public static func read(_ url: URL) throws -> JSON { try object(Data(contentsOf: url)) }
    public static func object(_ data: Data) throws -> JSON { guard let value = try JSONSerialization.jsonObject(with: data) as? JSON else { throw ViewsError("JSON должен содержать объект") }; return value }
    public static func write(_ value: JSON, to url: URL) throws { try FileManager.default.createDirectory(at: url.deletingLastPathComponent(), withIntermediateDirectories: true); try JSONSerialization.data(withJSONObject: value, options: [.sortedKeys]).write(to: url, options: .atomic) }
    public static func publish(_ source: URL, to destination: URL) throws { try require(ISVPublishFile(source.path,destination.path) != 0,"Не удалось атомарно сохранить файл") }
    public static func sha(_ data: Data) -> String { var out = [CChar](repeating: 0, count: 65); data.withUnsafeBytes { p in ISVHashData(p.bindMemory(to: UInt8.self).baseAddress, data.count, &out) }; return String(decoding: out.prefix(64).map { UInt8(bitPattern:$0) }, as: UTF8.self) }
    public static func sha(_ url: URL) throws -> String { var out = [CChar](repeating: 0, count: 65); try require(ISVHashFile(url.path, &out) != 0, "Не удалось вычислить SHA-256"); return String(decoding: out.prefix(64).map { UInt8(bitPattern:$0) }, as: UTF8.self) }
    public static func resource(_ relative: String, manifest: String = manifestURL) throws -> URL {
        try require(matches(relative, "^[A-Za-z0-9_./-]+$") && !relative.contains("..") && !relative.contains("//") && !relative.hasPrefix("/"), "Небезопасный путь ресурса")
        let base = try catalogURL(manifest)
        return base.deletingLastPathComponent().appendingPathComponent(relative)
    }
    public static func catalogURL(_ text: String) throws -> URL {
        guard let url = URL(string:text), url.scheme == "https", let host = url.host, !host.isEmpty, url.user == nil, url.password == nil, url.query == nil, url.fragment == nil, url.port == nil || url.port == 443, matches(url.path,"^/[A-Za-z0-9_./-]+\\.json(?:\\.br)?$"), !url.path.contains("..") else { throw ViewsError("Адрес каталога должен быть HTTPS JSON") }; return url
    }
    public static func season(_ month: Int) -> String { month >= 3 && month <= 5 ? "spring" : month >= 6 && month <= 8 ? "summer" : month >= 9 && month <= 11 ? "autumn" : "winter" }
    public static func profile(_ input: JSON = [:]) -> JSON {
        var p = input
        let mode = ["featured", "daily", "monthly", "seasonal", "weather", "slideshow"].contains(p.s("mode")) ? p.s("mode") : "featured"
        let source = mode == "weather" ? "weather" : p.s("source") == "local" ? "local" : mode == "featured" ? "day" : "online"
        p["mode"] = mode; p["source"] = source; p["online"] = source != "local"
        p["weather_source"] = p.s("weather_source") == "real" ? "real" : "game-world"
        p["weather_provider"] = p.s("weather_provider") == "open-meteo" ? "open-meteo" : "server"
        p["weather_delivery"] = p.s("weather_delivery") == "zip" ? "zip" : "images"
        if p.s("weather_provider") == "open-meteo" { p["weather_source"] = "real"; p["weather_delivery"] = "zip" }
        if p.s("collection") == "__weather_day__" { p["weather_provider"] = "server"; p["weather_delivery"] = "images" }
        p["weather_format"] = p.s("weather_format", "auto"); p["format"] = p.s("format", "auto")
        p["placement"] = p.s("placement") == "fill" ? "fill" : "fit"; p["manage"] = p.b("manage", true)
        p["paused"] = p.b("paused"); p["notify_collections"] = p.b("notify_collections", true)
        if p["revision"] == nil { p["revision"] = UUID().uuidString }; return p
    }
    public static func settings(_ input: JSON = [:]) -> JSON {
        var s = input; s["schema"] = 2; s["common"] = profile(input.j("common").isEmpty ? input : input.j("common"))
        s["linked"] = input.b("linked", true); s["paused"] = input.b("paused"); s["monitors"] = input.j("monitors").mapValues { profile($0 as? JSON ?? [:]) }
        s["manifest_url"] = input.s("manifest_url", manifestURL); s["known_displays"] = input.j("known_displays")
        if input["configuration_revision"] == nil { s["configuration_revision"] = UUID().uuidString }
        var saver = input.j("saver"); saver["enabled"] = saver.b("enabled"); saver["mode"] = saver.s("mode") == "own" ? "own" : "inherit"
        saver["interval"] = min(3600, max(10, saver.n("interval", 60))); saver["profile"] = profile(saver.j("profile")); s["saver"] = saver
        return s
    }
    public static func profile(for display: String, settings: JSON) -> JSON {
        if settings.b("linked",true) { return settings.j("common") }
        if let own = settings.j("monitors")[display] as? JSON { return own }
        var p = settings.j("common"); p["manage"] = false; return p
    }
    public static func merging(packs: [JSON], catalog: JSON, replaceExisting: Bool = true) -> JSON {
        var result = catalog; if result.isEmpty { result = ["schema":3,"collections":[],"items":[],"downloads":[]] }
        var collections = result.rows("collections"), items = result.rows("items")
        for pack in packs where pack["enabled"] as? Bool != false && !pack.rows("items").isEmpty && id(pack.s("id")) {
            let id = pack.s("id"); if !replaceExisting && collections.contains(where: { $0.s("id") == id }) { continue }; collections.removeAll { $0.s("id") == id }; items.removeAll { $0.s("collection") == id }
            var c = pack; c.removeValue(forKey:"items"); c["manifest"] = "collections/\(id)/manifest.json"; var schedule: JSON = [:]
            for (mode,value) in pack.j("schedule") { schedule[mode] = (value as? JSON ?? [:]).mapValues { id + "--" + ($0 as? String ?? "") } }; c["schedule"] = schedule; collections.append(c)
            for original in pack.rows("items") { var i = original; i["id"] = id + "--" + i.s("id"); i["collection"] = id; i["preview"] = "collections/\(id)/" + i.s("preview"); i["files"] = i.rows("files").map { f -> JSON in var f = f; f["url"] = "collections/\(id)/" + f.s("url"); return f }; items.append(i) }
        }; result["collections"] = collections; result["items"] = items; return result
    }
    public static func validateFile(_ file: JSON) throws {
        try require(hash(file.s("sha256")), "Неверный SHA-256 изображения")
        try require(file.n("width") > 0 && file.n("height") > 0 && file.n("width") <= 16384 && file.n("height") <= 16384, "Неверные размеры изображения")
        try require(file.n("bytes") > 0 && file.n("bytes") <= 100_000_000, "Неверный объём изображения")
        _ = try resource(file.s("url"))
    }
    @discardableResult public static func validateCatalog(_ data: JSON) throws -> JSON {
        try require(data.n("schema") == 3 && !data.rows("collections").isEmpty && data.rows("collections").count <= 1000 && data.rows("items").count <= 5000, "Неверный каталог видов")
        var ids = Set<String>(); for c in data.rows("collections") { try require(id(c.s("id")) && !c.s("title").isEmpty && ids.insert(c.s("id")).inserted, "Неверная коллекция") }
        var items = Set<String>(); for i in data.rows("items") { try require(id(i.s("id")) && items.insert(i.s("id")).inserted && ids.contains(i.s("collection")) && !i.rows("files").isEmpty, "Неверный вид"); for f in i.rows("files") { try validateFile(f) } }
        return data
    }
    public static func bestFile(_ rows: [JSON], width: Double, height: Double, format: String = "auto") throws -> JSON {
        let candidates = rows.filter { $0.n("width") > 0 && $0.n("height") > 0 && (format == "auto" || $0.s("rendition") == format || "\(Int($0.n("width")))x\(Int($0.n("height")))" == format) }
        func rank(_ f: JSON) -> Double { abs(log((f.n("width") / f.n("height")) / (width / height))) * 100 + (f.n("width") < width || f.n("height") < height ? 1 : 0) + f.n("width") * f.n("height") / 1e12 }
        guard let result = candidates.min(by: { rank($0) < rank($1) }) else { throw ViewsError("Нет подходящего формата") }; return result
    }
    public static func selectItem(catalog: JSON, profile: JSON, now: Date = Date()) throws -> JSON {
        let rows = catalog.rows("items"), mode = profile.s("mode")
        if mode == "featured" { guard let i = rows.first(where: { $0.s("id") == catalog.j("wallpaper_of_day").s("item_id") }) else { throw ViewsError("Сайт ещё не опубликовал обои дня") }; return i }
        let id = profile.s("collection"), items = rows.filter { $0.s("collection") == id }; guard !items.isEmpty else { throw ViewsError("Коллекция не загружена") }
        let cal = Calendar.current, month = cal.component(.month, from: now)
        if mode == "daily" || mode == "slideshow" { var utc = Calendar(identifier: .gregorian); utc.timeZone = TimeZone(secondsFromGMT: 0)!; let local = cal.dateComponents([.year, .month, .day], from: now); let index = Int((utc.date(from: local) ?? now).timeIntervalSince1970 / 86400); return items[((index % items.count) + items.count) % items.count] }
        let collection = catalog.rows("collections").first { $0.s("id") == id } ?? [:], table = collection.j("schedule").j(mode)
        let key = mode == "monthly" ? String(month) : season(month), selected = table.s(key)
        guard let item = items.first(where: { $0.s("id") == selected || id + "--" + $0.s("id") == selected }) else { throw ViewsError("В расписании нет вида для выбранного периода") }; return item
    }
}
