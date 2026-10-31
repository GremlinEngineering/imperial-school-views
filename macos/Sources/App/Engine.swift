import AppKit
import ImageIO
import UserNotifications

struct Frame { var file: JSON, rule: JSON, url: URL; var until: Date?; var schedule: JSON?; var token = UUID() }
@MainActor final class Engine {
    let root: URL, store: CacheStore, installer: CacheStore, displays = Displays(), archiveGate = ArchiveGate()
    var settings: JSON, catalog: JSON = [:], status = "Запуск…", progress = "", onChange: (() -> Void)?
    var current: [String: Frame] = [:], pairs: [String: JSON] = [:], lastRequest: [String: Date] = [:], memo: [String: (Date, JSON)] = [:]
    var timer: Timer?, boundary: Timer?, job: Task<Void, Never>?, packages: [String: Task<Void, Never>] = [:], lastCatalog = Date.distantPast
    var update: JSON?, lastUpdate = Date.distantPast, generation = 0
    var currentRevisions: [String:String] = [:]
    var fetchJSON: (URL) async throws -> JSON = Network.json
    var fetchImage: (URL) async throws -> Data = { try await Network.data($0) }
    init(dataRoot: URL = FileManager.default.homeDirectoryForCurrentUser.appendingPathComponent("Library/Application Support/Imperial School Views")) {
        root = dataRoot
        settings = DataModel.settings((try? DataModel.read(root.appendingPathComponent("settings.json"))) ?? [:])
        let validator: (URL,JSON) throws -> Void = { url, file in
            guard let src = CGImageSourceCreateWithURL(url as CFURL, nil), CGImageSourceGetType(src) as String? == "public.jpeg", let p = CGImageSourceCopyPropertiesAtIndex(src, 0, nil) as? [CFString: Any], let w = p[kCGImagePropertyPixelWidth] as? NSNumber, let h = p[kCGImagePropertyPixelHeight] as? NSNumber, w.doubleValue == file.n("width"), h.doubleValue == file.n("height"), CGImageSourceCreateImageAtIndex(src, 0, nil) != nil else { throw ViewsError("JPEG повреждён или его размеры не совпадают") }
        }
        store = CacheStore(root:root,validateJPEG:validator); installer = CacheStore(root:root,validateJPEG:validator)
        displays.onChange = { [weak self] in self?.topologyChanged() }
        displays.onWillChange = { [weak self] in
            guard let self else { return }; generation += 1; job?.cancel(); job = nil; boundary?.invalidate(); status = "Определяю мониторы…"; changed()
        }
    }
    func start() {
        settings["transfer_id"] = UUID().uuidString; settings["configuration_revision"] = UUID().uuidString; settings["app_build"] = DataModel.version; settings["native_anchor"] = DataModel.stamp()
        try? DataModel.write(settings, to: root.appendingPathComponent("settings.json"))
        Task {
            await LoginItem.migrate(root: root)
            if let saved = await store.json("manifest.json"), (try? DataModel.validateCatalog(saved)) != nil { catalog = saved }
            catalog = DataModel.merging(packs:await store.localPacks(),catalog:catalog,replaceExisting:false)
            displays.refresh(); changed()
        }
        timer = Timer.scheduledTimer(withTimeInterval: 60, repeats: true) { [weak self] _ in Task { @MainActor in self?.refresh() } }
    }
    func changed() { onChange?() }
    func topologyChanged() {
        generation += 1; job?.cancel(); job = nil
        var known = settings.j("known_displays"); for d in displays.values { known[d.id] = ["id":d.id,"title":d.title,"width":d.width,"height":d.height] }; settings["known_displays"] = known
        try? DataModel.write(settings, to: root.appendingPathComponent("settings.json")); refresh(force: true)
    }
    func save(profile: JSON, target: String) {
        var p = DataModel.profile(profile); p["revision"] = UUID().uuidString; p["updated_at"] = DataModel.stamp()
        if target == "saver" { var s = settings.j("saver"); s["profile"] = p; settings["saver"] = s }
        else if target == "all" { settings["linked"] = true; settings["common"] = p }
        else { var monitors = settings.j("monitors"); if settings.b("linked", true) { for d in displays.values { monitors[d.id] = settings.j("common") } }; monitors[target] = p; settings["monitors"] = monitors; settings["linked"] = false }
        commit()
    }
    func commit() {
        generation += 1; job?.cancel(); job = nil; boundary?.invalidate()
        settings["configuration_revision"] = UUID().uuidString; settings["transfer_id"] = UUID().uuidString; settings["native_anchor"] = DataModel.stamp()
        do { try DataModel.write(settings, to: root.appendingPathComponent("settings.json")); status = "Настройки сохранены" } catch { status = error.localizedDescription }; changed(); refresh(force: true)
    }
    func refresh(force: Bool = false) {
        guard !displays.isRefreshing else { return }
        Task { await applyCachedSchedules() }
        if let running = job {
            guard force else { return }
            running.cancel(); job = nil; generation += 1
        }
        let revision = generation; job = Task { [weak self] in
            guard let self else { return }; defer { if revision == generation { job = nil; changed() } }
            do {
                try Task.checkCancellation()
                if force || Date().timeIntervalSince(lastCatalog) >= 3600 || catalog.isEmpty {
                    do { let fresh = try await fetchJSON(DataModel.catalogURL(settings.s("manifest_url", DataModel.manifestURL))); try Task.checkCancellation(); try DataModel.validateCatalog(fresh); let old = Set(catalog.rows("collections").map { $0.s("id") }); catalog = DataModel.merging(packs:await store.localPacks(),catalog:fresh,replaceExisting:false); lastCatalog = Date(); try await store.save(catalog, path: "manifest.json"); if !old.isEmpty { let added = fresh.rows("collections").filter { !old.contains($0.s("id")) }; if !added.isEmpty && settings.j("common").b("notify_collections", true) { notify("Новые коллекции", added.map { $0.s("title") }.joined(separator: ", ")) } } }
                    catch is CancellationError { throw CancellationError() } catch { if catalog.isEmpty { throw error }; status = "Сохранённый каталог · " + error.localizedDescription }
                }
                try Task.checkCancellation(); var errors: [String] = []
                for d in displays.values {
                    let p = DataModel.profile(for: d.id, settings: settings)
                    guard !settings.b("paused"), !p.b("paused"), p.b("manage", true) else { continue }
                    do {
                        let frame = try await resolve(p, display: d, force: force); try Task.checkCancellation()
                        guard revision == generation, displays.values.contains(where: { $0.id == d.id && $0.number == d.number }), let screen = d.screen else { continue }
                        let options: [NSWorkspace.DesktopImageOptionKey: Any] = [.imageScaling: NSImageScaling.scaleProportionallyUpOrDown.rawValue, .allowClipping: p.s("placement") == "fill", .fillColor: NSColor.black]
                        if force || currentRevisions[d.id] != p.s("revision") || NSWorkspace.shared.desktopImageURL(for: screen)?.standardizedFileURL != frame.url.standardizedFileURL { try NSWorkspace.shared.setDesktopImageURL(frame.url, for: screen, options: options) }
                        current[d.id] = frame
                        currentRevisions[d.id] = p.s("revision")
                        try await store.save(["file":frame.file,"rule":frame.rule], path: "native-current/\(d.id).json")
                    } catch is CancellationError { throw CancellationError() } catch { errors.append("\(d.title): \(error.localizedDescription)") }
                }
                guard revision == generation else { return }; try await publishSaver(force: force)
                try Task.checkCancellation(); guard revision == generation else { return }
                status = settings.b("paused") ? "Смена обоев приостановлена" : displays.values.isEmpty ? "Мониторы не определены" : errors.isEmpty ? "Обои обновлены · " + DateFormatter.localizedString(from: Date(), dateStyle: .none, timeStyle: .short) : errors.joined(separator: "\n")
                scheduleBoundary(); if Date().timeIntervalSince(lastUpdate) > 86400 { Task { await self.checkUpdate(manual: false) } }
            } catch is CancellationError {} catch { if revision == generation { status = error.localizedDescription } }
        }
    }
    func resource(_ path: String) throws -> URL { try DataModel.resource(path, manifest: settings.s("manifest_url", DataModel.manifestURL)) }
    func json(_ path: String, force: Bool) async throws -> JSON {
        if !force, let m = memo[path], Date().timeIntervalSince(m.0) < 55 { return m.1 }
        let revision = generation
        let value = try await fetchJSON(resource(path)); try Task.checkCancellation(); guard revision == generation else { throw CancellationError() }; memo[path] = (Date(), value); return value
    }
    func image(_ file: JSON, network: Bool = true) async throws -> URL {
        if let url = await store.cached(file) { return url }; try require(network, "Этот кадр ещё не скачан")
        var url = try resource(file.s("url")); var c = URLComponents(url: url, resolvingAgainstBaseURL: false)!; c.queryItems = [URLQueryItem(name: "v", value: file.s("sha256"))]; url = c.url!
        let data = try await fetchImage(url); try Task.checkCancellation(); return try await store.putImage(data, file: file)
    }
    func resolve(_ p: JSON, display: Display, force: Bool) async throws -> Frame {
        let revision = generation, now = Date(), id = p.s("collection"), online = p.s("source") != "local"
        if p.s("mode") != "weather" {
            let data: JSON
            if online { data = catalog } else { data = DataModel.merging(packs:await store.localPacks(),catalog:[:]) }
            let item = try DataModel.selectItem(catalog: data, profile: p, now: now)
            let file = try DataModel.bestFile(item.rows("files").filter { $0.n("width") > $0.n("height") }, width: display.width, height: display.height, format: p.s("format", "auto"))
            return Frame(file: file, rule: item, url: try await image(file, network: online), until: Calendar.current.nextDate(after: now, matching: DateComponents(hour: 0), matchingPolicy: .nextTime), schedule: nil)
        }
        if id == "__weather_day__" {
            let source = p.s("weather_source", "game-world"), document = try await json("weather/daily/\(source)/current.json", force: force); try Contracts.daily(document, source: source, at: now)
            let rows: [JSON] = document.j("files").compactMap { _, v in v as? JSON }; let file = try DataModel.bestFile(rows.filter { $0.n("width") > $0.n("height") }, width: display.width, height: display.height, format: p.s("weather_format", "auto"))
            return Frame(file: file, rule: document, url: try await image(file), until: DataModel.date(document.s("valid_until")), schedule: nil)
        }
        guard let collection = catalog.rows("collections").first(where: { $0.s("id") == id }) else { throw ViewsError("Коллекция отсутствует в каталоге") }
        let format = try Contracts.format(collection, width: display.width, height: display.height, requested: p.s("weather_format", "auto"))
        if collection.s("type") == "dynamic" {
            try Contracts.endpoint(collection.s("current_url"), expected: "dynamic/\(id)/current.json")
            let descriptor = try await json(collection.s("current_url"), force: force)
            try require(descriptor.s("status") == "ready", "Динамическая тема ещё не опубликована")
            let path = descriptor.j("states").s(format); try Contracts.endpoint(path, expected: "dynamic/\(id)/devices/\(format)/current.json")
            let state = try await json(path, force: force), file = try Contracts.dynamic(descriptor: descriptor, state: state, collection: collection, device: format, at: now)
            var rule = state; rule["collection"] = id; rule["rendition"] = format; rule["title"] = collection.s("title")
            return Frame(file: file, rule: rule, url: try await image(file), until: DataModel.date(state.s("valid_until")), schedule: nil)
        }
        if p.s("weather_provider") == "open-meteo" { return try await local(p, collection: collection, format: format, now: now, force: force) }
        let source = p.s("weather_source", "game-world"), s = try Contracts.source(collection, id: source), key = DataModel.sha(Data("\(id)|\(source)|\(format)".utf8)), path = "native-pairs/\(key).json"
        let savedPair = await store.json(path); var pair = pairs[key] ?? savedPair ?? [:]
        do {
            let current = try await json(s.s("current_url"), force: force)
            // A newly observed identity invalidates the old forecast immediately,
            // even if the new forecast is temporarily unavailable.
            if !pair.isEmpty && Contracts.identity(current) != Contracts.identity(pair.j("current")) {
                invalidateSchedule(collection:id,source:source,format:format)
                pair = [:]; pairs[key] = [:]; try await store.save([:], path: path)
            }
            let forecast = try await json(s.j("forecasts").s(format), force: force); try Contracts.weatherPair(current: current, forecast: forecast, collection: collection, source: source, format: format)
            try Task.checkCancellation(); guard revision == generation else { throw CancellationError() }
            pair = ["current":current,"forecast":forecast]; pairs[key] = pair; try await store.save(pair, path: path)
        } catch is CancellationError { throw CancellationError() } catch { if pair.isEmpty { throw error } }
        try Contracts.weatherPair(current: pair.j("current"), forecast: pair.j("forecast"), collection: collection, source: source, format: format)
        let forecast = pair.j("forecast"), row = try Contracts.interval(forecast, at: now), file = row.j("file")
        let url = try await image(file)
        if p.s("weather_delivery") == "zip", !forecast.s("package_version").isEmpty { queuePackage(collection: collection, format: format, version: forecast.s("package_version")) }
        var rule = row; rule["collection"] = id; rule["rendition"] = format; rule["source_id"] = source
        return Frame(file: file, rule: rule, url: url, until: DataModel.date(row.s("valid_until")), schedule: forecast)
    }
    func local(_ p: JSON, collection: JSON, format: String, now: Date, force: Bool) async throws -> Frame {
        let city = try City(p.j("weather_city")); let id = collection.s("id")
        guard let d = catalog.rows("downloads").first(where: { $0.s("collection") == id && $0.s("rendition") == format && $0.s("format") == "zip" }) else { throw ViewsError("Погодный ZIP этого формата ещё не опубликован") }
        guard let receipt = await store.packageReceipt(d.s("sha256")), receipt.s("version") == d.s("version"), receipt.s("id") == id, receipt.s("format") == format, !receipt.rows("variants").isEmpty else { queuePackage(collection: collection, format: format, version: d.s("version"),repair:true); throw ViewsError("Скачивается пакет для погоды в выбранном городе") }
        var c = URLComponents(string: "https://api.open-meteo.com/v1/forecast")!; c.queryItems = [URLQueryItem(name:"latitude",value:String(city.latitude)),URLQueryItem(name:"longitude",value:String(city.longitude)),URLQueryItem(name:"hourly",value:"weather_code"),URLQueryItem(name:"timeformat",value:"unixtime"),URLQueryItem(name:"timezone",value:"UTC"),URLQueryItem(name:"past_days",value:"1"),URLQueryItem(name:"forecast_days",value:"3")]
        let cache = "native-meteo/" + DataModel.sha(Data(c.url!.absoluteString.utf8)) + ".json"; var saved = await store.json(cache) ?? [:]
        if force || now.timeIntervalSince(DataModel.date(saved.s("fetched_at")) ?? .distantPast) >= 3600 {
            if force || now.timeIntervalSince(lastRequest[cache] ?? .distantPast) >= 180 { lastRequest[cache] = now; do { let data = try await fetchJSON(c.url!); try Task.checkCancellation(); saved = ["fetched_at":DataModel.stamp(),"data":data]; try await store.save(saved, path: cache) } catch is CancellationError { throw CancellationError() } catch { if saved.isEmpty { throw error } } }
        }
        let schedule = try LocalWeather.schedule(saved.j("data"), city: city, variants: receipt.rows("variants"), now: now), row = try Contracts.interval(schedule, at: now), file = row.j("file")
        var rule = row; rule["collection"] = id; rule["rendition"] = format; rule["city"] = city.name
        guard let local = await store.cached(file) else { queuePackage(collection:collection,format:format,version:d.s("version"),repair:true); throw ViewsError("Восстанавливается повреждённый погодный пакет") }
        return Frame(file: file, rule: rule, url: local, until: DataModel.date(row.s("valid_until")), schedule: schedule)
    }
    func queuePackage(collection: JSON, format: String, version: String, repair: Bool = false) {
        guard let d = catalog.rows("downloads").first(where: { $0.s("collection") == collection.s("id") && $0.s("rendition") == format && $0.s("format") == "zip" && $0.s("version") == version }) else { lastCatalog = .distantPast; progress = "Обновляю каталог для ZIP формата \(format)"; return }
        guard DataModel.hash(d.s("sha256")), packages[d.s("sha256")] == nil else { return }
        let hash = d.s("sha256"); packages[hash] = Task { [self] in
            defer { packages[hash] = nil; changed() }
            if !repair, let receipt = await store.packageReceipt(hash), receipt.s("version") == version, receipt.s("id") == collection.s("id"), receipt.s("format") == format, !receipt.rows("variants").isEmpty { return }
            // One archive transfer at a time; frame JSON/JPEG requests remain independent.
            await archiveGate.acquire(); defer { Task { await archiveGate.release() } }; if Task.isCancelled { return }
            let temp = root.appendingPathComponent("native-downloads/\(hash).zip"); defer { try? FileManager.default.removeItem(at: temp) }
            do { progress = "Скачивается \(collection.s("title")) · \(format)"; changed(); let url = try resource(d.s("url")); try await Network.download(url, to: temp) { [weak self] received, total in Task { @MainActor in self?.progress = "ZIP: \(ByteCountFormatter.string(fromByteCount: received, countStyle: .file))" + (total > 0 ? " / \(ByteCountFormatter.string(fromByteCount: total, countStyle: .file))" : ""); self?.changed() } }; progress = "Проверка и установка ZIP…"; changed(); _ = try await installer.installWeatherZIP(temp, descriptor: d, collection: collection.s("id"), format: format, version: version); progress = "Пакет установлен"; refresh(force: true) }
            catch is CancellationError { progress = "Загрузка отменена" } catch { progress = error.localizedDescription }
        }
    }
    func downloadCollection(_ p: JSON, target: String = "all") {
        guard let c = catalog.rows("collections").first(where: { $0.s("id") == p.s("collection") }) else { status = "Выберите коллекцию"; changed(); return }
        if c.s("type") == "dynamic" { status = "Для этой темы загружается только текущий готовый JPEG"; changed(); return }
        if c.s("type") == "weather" {
            let selected = target == "all" || target == "saver" ? displays.values : displays.values.filter { $0.id == target }
            guard !selected.isEmpty else { status = "Выбранный монитор недоступен"; changed(); return }
            var seen = Set<String>()
            for d in selected {
                guard let format = try? Contracts.format(c,width:d.width,height:d.height,requested:p.s("weather_format","auto")), seen.insert(format).inserted else { continue }
                if let archive = catalog.rows("downloads").first(where: { $0.s("collection") == c.s("id") && $0.s("rendition") == format && $0.s("format") == "zip" }) { queuePackage(collection:c,format:format,version:archive.s("version")) } else { status = "Погодный ZIP формата \(format) ещё не опубликован"; changed() }
            }; return
        }
        guard let d = catalog.rows("downloads").first(where: { $0.s("id") == "collection-" + c.s("id") || ($0.s("collection") == c.s("id") && $0.s("format") == "zip") }), DataModel.hash(d.s("sha256")), packages[d.s("sha256")] == nil else { status = "ZIP коллекции недоступен или уже скачивается"; changed(); return }
        let hash = d.s("sha256"); packages[hash] = Task { [self] in defer { packages[hash] = nil; changed() }; await archiveGate.acquire(); defer { Task { await archiveGate.release() } }; if Task.isCancelled { return }; let temp = root.appendingPathComponent("native-downloads/\(hash).zip"); defer { try? FileManager.default.removeItem(at:temp) }
            do { progress = "Скачивается \(c.s("title"))"; changed(); try await Network.download(resource(d.s("url")),to:temp) { [weak self] received,_ in Task { @MainActor in self?.progress = "Скачано " + ByteCountFormatter.string(fromByteCount:received,countStyle:.file); self?.changed() } }; _ = try await installer.importCollection(temp,descriptor:d); progress = "Коллекция скачана. Доступен локальный режим."; refresh(force:true) } catch { progress = error.localizedDescription }
        }
    }
    func importZIP(_ url: URL) {
        Task { do { progress = "Проверяю ZIP…"; changed(); _ = try await installer.importCollection(url); catalog = DataModel.merging(packs:await store.localPacks(),catalog:catalog); try await store.save(catalog,path:"manifest.json"); progress = "Коллекция импортирована" } catch { progress = error.localizedDescription }; changed() }
    }
    func invalidateSchedule(collection: String, source: String, format: String) {
        for (id,frame) in current where frame.schedule?.s("collection_id") == collection && frame.schedule?.s("source_id") == source && frame.schedule?.s("format") == format {
            var retained = frame; retained.schedule = nil; retained.until = nil; retained.token = UUID(); current[id] = retained
        }
    }
    func scheduleBoundary() {
        boundary?.invalidate(); let dates = (current.values.compactMap(\.until) + current.values.flatMap { $0.schedule?.rows("intervals").compactMap { DataModel.date($0.s("valid_from")) } ?? [] }).filter { $0 > Date() }; let next = dates.min() ?? Date().addingTimeInterval(60)
        boundary = Timer.scheduledTimer(withTimeInterval: max(0.5, min(60, next.timeIntervalSinceNow + 0.1)), repeats: false) { [weak self] _ in Task { @MainActor in self?.refresh() } }
    }
    func applyCachedSchedules() async {
        let revision = generation; defer { if revision == generation { scheduleBoundary() } }
        guard !settings.b("paused"), !displays.isRefreshing else { return }
        var didApply = false
        for d in displays.values {
            let frameToken = current[d.id]?.token
            let p = DataModel.profile(for:d.id,settings:settings)
            guard p.b("manage",true), !p.b("paused") else { continue }
            var row: JSON, file: JSON, schedule: JSON?, until: Date?
            if p.s("mode") == "weather" {
                guard currentRevisions[d.id] == p.s("revision"), let saved = current[d.id]?.schedule, let active = try? Contracts.interval(saved,at:Date()) else { continue }
                row = active; file = row.j("file"); schedule = saved; until = DataModel.date(row.s("valid_until"))
            } else {
                let data: JSON
                if p.s("source") == "local" { data = DataModel.merging(packs:await store.localPacks(),catalog:[:]) } else { data = catalog }
                guard let item = try? DataModel.selectItem(catalog:data,profile:p), let f = try? DataModel.bestFile(item.rows("files").filter { $0.n("width") > $0.n("height") },width:d.width,height:d.height,format:p.s("format","auto")) else { continue }
                row = item; file = f; until = Calendar.current.nextDate(after:Date(),matching:DateComponents(hour:0),matchingPolicy:.nextTime)
            }
            guard let url = await store.cached(file), revision == generation, current[d.id]?.token == frameToken, let screen = d.screen else { continue }
            if current[d.id]?.url == url && current[d.id]?.until == until && currentRevisions[d.id] == p.s("revision") { continue }
            do {
                if currentRevisions[d.id] != p.s("revision") || NSWorkspace.shared.desktopImageURL(for:screen)?.standardizedFileURL != url.standardizedFileURL { try NSWorkspace.shared.setDesktopImageURL(url,for:screen,options:[.imageScaling:NSImageScaling.scaleProportionallyUpOrDown.rawValue,.allowClipping:p.s("placement") == "fill",.fillColor:NSColor.black]) }
                row["collection"] = p.s("collection"); row["rendition"] = file.s("rendition"); let frame = Frame(file:file,rule:row,url:url,until:until,schedule:schedule); current[d.id] = frame; currentRevisions[d.id] = p.s("revision")
                try await store.save(["file":frame.file,"rule":frame.rule],path:"native-current/\(d.id).json"); didApply = true
            } catch { status = error.localizedDescription; changed() }
        }
        if didApply { status = "Кадр изменён по сохранённому расписанию"; changed(); if settings.j("saver").s("mode") != "own" { try? await publishSaver(force:false) } }
    }
    func publishSaver(force: Bool) async throws {
        let revision = generation, configuration = settings.s("configuration_revision"), saver = settings.j("saver"); guard saver.b("enabled") else { return }; var targets: JSON = [:]
        for d in displays.values {
            let own = saver.s("mode") == "own", p = own ? saver.j("profile") : DataModel.profile(for: d.id, settings: settings)
            var frame = current[d.id]; if own { frame = try? await resolve(p, display: d, force: force) }
            guard let frame else { continue }; var frames = [frame.file.merging(["valid_from":DataModel.stamp(Date().addingTimeInterval(-60)),"valid_until":DataModel.stamp(frame.until ?? Date().addingTimeInterval(86400))]) { _, n in n }]
            var mode = "forecast"
            if own && p.s("mode") == "slideshow" {
                let gallery = await store.gallery(catalog: catalog); frames = gallery.filter { row in row.rules.contains { $0.s("collection") == p.s("collection") } }.map(\.file); mode = "slideshow"
            } else if let schedule = frame.schedule {
                frames = []; for row in schedule.rows("intervals") where row.s("status") == "ready" { if await store.cached(row.j("file")) != nil { frames.append(row.j("file").merging(["valid_from":row.s("valid_from"),"valid_until":row.s("valid_until")]) { _, n in n }) } }
            }
            targets[d.id] = ["mode":mode,"placement":p.s("placement", "fit"),"frames":frames,"fallback":frame.file,"interval":saver.n("interval", 60),"anchor":settings.s("native_anchor",DataModel.stamp())]
        }
        try Task.checkCancellation(); guard revision == generation && configuration == settings.s("configuration_revision") else { throw CancellationError() }
        try await store.save(["schema":1,"configuration_revision":configuration,"targets":targets], path: "saver-state.json")
    }
    func checkUpdate(manual: Bool) async {
        lastUpdate = Date()
        do { let data = try await fetchJSON(URL(string:"https://games.oopssre.ru/assets/arcade/views/app-release.json")!); try require(data.n("schema") == 1 && data.s("app_id") == "ru.oopssre.imperial-school.views" && data.s("platform") == "macos", "Неверные сведения о версии"); let r = data.j("release"); if !r.isEmpty { try require(DataModel.matches(r.s("version"), "^[0-9]+\\.[0-9]+\\.[0-9]+$") && DataModel.hash(r.s("sha256")) && r.s("url").hasPrefix("https://games.oopssre.ru/assets/arcade/views/downloads/") && r.s("url").hasSuffix(".dmg"), "Неверная ссылка обновления"); if r.s("version").compare(DataModel.version, options: .numeric) == .orderedDescending { update = r } }; if manual { status = update == nil ? "Установлена актуальная версия \(DataModel.version)" : "Доступна версия \(update!.s("version"))" } }
        catch { if manual { status = error.localizedDescription } }; changed()
    }
    func notify(_ title: String, _ body: String) { let content = UNMutableNotificationContent(); content.title = title; content.body = body; UNUserNotificationCenter.current().add(UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: nil)) }
    func shutdown() { timer?.invalidate(); boundary?.invalidate(); job?.cancel(); for p in packages.values { p.cancel() } }
}

actor ArchiveGate {
    private var busy = false; private var waiting: [CheckedContinuation<Void,Never>] = []
    func acquire() async { if !busy { busy = true; return }; await withCheckedContinuation { waiting.append($0) } }
    func release() { if waiting.isEmpty { busy = false } else { waiting.removeFirst().resume() } }
}
