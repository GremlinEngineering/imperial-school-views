import AppKit

@main struct DesignAudit {
    @MainActor static func main() async throws {
        let arguments = CommandLine.arguments
        let project = URL(fileURLWithPath: arguments[1], isDirectory: true)
        let output = URL(fileURLWithPath: arguments[2], isDirectory: true)
        let root = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString, isDirectory: true)
        defer { try? FileManager.default.removeItem(at: root) }
        let app = NSApplication.shared
        app.setActivationPolicy(.regular)
        app.finishLaunching()
        ViewsBrand.registerFonts(in: project.appendingPathComponent("branding"))
        try require(ViewsBrand.heading(20).fontName == "Oswald-SemiBold" && ViewsBrand.intro(15).fontName == "Literata-12pt" && ViewsBrand.details(12).fontName == "PTMono-Regular", "Shared brand fonts are unavailable")
        let engine = Engine(dataRoot: root)
        engine.catalog = try DataModel.read(URL(fileURLWithPath: arguments[3]))
        let screen = NSScreen.main
        let number = (screen?.deviceDescription[NSDeviceDescriptionKey("NSScreenNumber")] as? NSNumber)?.uint32Value ?? 0
        engine.displays.values = [Display(id: "test-display", number: number, title: "Встроенный дисплей", width: 3456, height: 2234)]
        let artwork = project.appendingPathComponent("preview-samples/autumn.jpg")
        let weatherBytes = try Data(contentsOf: project.appendingPathComponent("preview-samples/spring.jpg"))
        let bitmap = NSBitmapImageRep(data: weatherBytes)!
        let dimensions: JSON = ["width":bitmap.pixelsWide,"height":bitmap.pixelsHigh]
        engine.catalog["collections"] = engine.catalog.rows("collections").map { item -> JSON in
            guard item.s("id") == "riverside-house-weather" else { return item }
            var adjusted = item; adjusted["formats"] = ["macbook":dimensions]; return adjusted
        }
        let clock = Date()
        var weatherFile = dimensions
        weatherFile["format"] = "jpg"; weatherFile["rendition"] = "macbook"
        weatherFile["bytes"] = weatherBytes.count; weatherFile["sha256"] = DataModel.sha(weatherBytes)
        weatherFile["url"] = "collections/riverside-house-weather/files/spring.jpg"
        let weather: JSON = ["schema":1,"type":"weather","collection_id":"riverside-house-weather","source_id":"real","location_revision":"r1","timezone":"UTC"]
        var forecast = weather
        forecast["document_type"] = "weather-forecast"; forecast["format"] = "macbook"
        forecast["generated_at"] = DataModel.stamp(clock.addingTimeInterval(-60)); forecast["valid_until"] = DataModel.stamp(clock.addingTimeInterval(3600))
        forecast["intervals"] = [["status":"ready","valid_from":DataModel.stamp(clock.addingTimeInterval(-60)),"valid_until":DataModel.stamp(clock.addingTimeInterval(3600)),"file":weatherFile]]
        engine.fetchJSON = { url in
            if url.path.hasSuffix("/riverside-house-weather/current.json") { return weather }
            if url.path.hasSuffix("/riverside-house-weather/forecast-macbook.json") { return forecast }
            throw ViewsError("Unexpected test request")
        }
        engine.fetchImage = { _ in weatherBytes }
        let scene = "Орбитальный порт · Orbital Port"
        func wallpaper(_ collection: String) -> JSON { DataModel.profile(["mode":"weather", "collection":collection, "weather_source":"real"]) }
        engine.settings["common"] = wallpaper("orbital-port")
        engine.settings["saver"] = ["enabled":true,"mode":"own","profile":wallpaper("orbital-port")]
        engine.status = "Обои обновлены · 09:00"
        let controller = SettingsWindow(engine: engine)
        let window = controller.window!
        controller.showWindow(nil)
        window.makeKeyAndOrderFront(nil)
        let fullWidth = window.frame.width
        print("Window defaults: \(Int(window.frame.width))×\(Int(window.frame.height)); resizable: \(window.styleMask.contains(.resizable))")
        func snapshot(_ window: NSWindow, _ name: String, _ appearance: NSAppearance.Name) throws {
            window.appearance = NSAppearance(named: appearance)
            window.displayIfNeeded()
            guard let view = window.contentView?.superview else { throw ViewsError("Missing window view") }
            view.layoutSubtreeIfNeeded()
            view.displayIfNeeded()
            guard let bitmap = view.bitmapImageRepForCachingDisplay(in: view.bounds) else { throw ViewsError("No AppKit bitmap") }
            view.cacheDisplay(in: view.bounds, to: bitmap)
            guard let data = bitmap.representation(using: .png, properties: [:]) else { throw ViewsError("No PNG data") }
            try data.write(to: output.appendingPathComponent(name + ".png"))
            print("Captured \(name): \(bitmap.pixelsWide)×\(bitmap.pixelsHigh)")
        }
        controller.showPreview(artwork, title:"Сейчас на экране", detail:scene + "\nВстроенный дисплей · 3456×2234", empty:"")
        try snapshot(window, "01-wallpaper-light", .aqua)
        try snapshot(window, "02-wallpaper-dark", .darkAqua)
        for (name, popup) in [("Источник", controller.sources), ("Коллекция", controller.collections), ("На экране", controller.placement)] {
            try require((popup.accessibilityTitleUIElement() as? NSTextField)?.stringValue == name, "Missing accessible form label: \(name)")
        }
        controller.staged = wallpaper("riverside-house-weather")
        controller.advancedOpen = true
        controller.render()
        await controller.previewTask?.value
        try require(controller.previewTitle.stringValue == "Предпросмотр" && controller.previewURL?.lastPathComponent == weatherFile.s("sha256") + ".jpg", "Changing the draft did not show the selected weather image")
        try require(engine.settings.j("common").s("collection") == "orbital-port" && engine.current.isEmpty && engine.packages.isEmpty, "Draft preview changed installed settings")
        try snapshot(window, "03-weather-settings", .darkAqua)
        controller.selectedPane = 1
        controller.tabChanged()
        controller.showPreview(artwork, title:"Кадр хранителя", detail:"Встроенный дисплей · последний сохранённый кадр", empty:"")
        try snapshot(window, "04-saver-own", .aqua)
        engine.settings["saver"] = ["enabled":false,"mode":"inherit","profile":wallpaper("orbital-port")]
        controller.saverDraft = controller.saverOptions(engine.settings.j("saver"))
        controller.render()
        try require(window.frame.width < fullWidth, "Disabled saver pane is not compact")
        try snapshot(window, "05-saver-disabled", .aqua)
        controller.selectedPane = 2
        controller.tabChanged()
        try require(window.frame.width < fullWidth, "Application pane is not compact")
        try snapshot(window, "06-about", .aqua)
        let viewer = ViewerWindow(engine: engine)
        viewer.showWindow(nil)
        viewer.all = [GalleryRow(file:["width":1920,"height":1080],rules:[["title":scene,"season":"autumn","time_of_day":"dusk"]],url:artwork)]
        viewer.applyFilters()
        try snapshot(viewer.window!, "07-viewer", .darkAqua)
    }
}
