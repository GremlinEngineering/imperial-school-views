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
        let engine = Engine(dataRoot: root)
        engine.catalog = try DataModel.read(URL(fileURLWithPath: arguments[3]))
        let screen = NSScreen.main
        let number = (screen?.deviceDescription[NSDeviceDescriptionKey("NSScreenNumber")] as? NSNumber)?.uint32Value ?? 0
        engine.displays.values = [Display(id: "test-display", number: number, title: "Встроенный дисплей", width: 3456, height: 2234)]
        let artwork = project.appendingPathComponent("preview-samples/autumn.jpg")
        let scene = "Орбитальный порт · Orbital Port"
        func wallpaper(_ collection: String) -> JSON { DataModel.profile(["mode":"weather", "collection":collection, "weather_source":"real"]) }
        engine.settings["common"] = wallpaper("orbital-port")
        engine.settings["saver"] = ["enabled":true,"mode":"own","profile":wallpaper("orbital-port")]
        engine.status = "Обои обновлены · 09:00"
        let controller = SettingsWindow(engine: engine)
        let window = controller.window!
        controller.showWindow(nil)
        window.makeKeyAndOrderFront(nil)
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
            print("Accessibility \(name): \(String(describing: popup.accessibilityLabel())); linked title: \(String(describing: popup.accessibilityTitleUIElement()))")
        }
        controller.staged = wallpaper("riverside-house-weather")
        controller.advancedOpen = true
        controller.render()
        controller.showPreview(artwork, title:"Сейчас на экране", detail:scene + "\nВстроенный дисплей · 3456×2234", empty:"")
        try snapshot(window, "03-weather-settings", .darkAqua)
        controller.selectedPane = 1
        controller.tabChanged()
        controller.showPreview(artwork, title:"Кадр хранителя", detail:"Встроенный дисплей · последний сохранённый кадр", empty:"")
        try snapshot(window, "04-saver-own", .aqua)
        engine.settings["saver"] = ["enabled":false,"mode":"inherit","profile":wallpaper("orbital-port")]
        controller.saverDraft = controller.saverOptions(engine.settings.j("saver"))
        controller.render()
        try snapshot(window, "05-saver-disabled", .aqua)
        controller.selectedPane = 2
        controller.tabChanged()
        try snapshot(window, "06-about", .aqua)
        let viewer = ViewerWindow(engine: engine)
        viewer.showWindow(nil)
        viewer.all = [GalleryRow(file:["width":1920,"height":1080],rules:[["title":scene,"season":"autumn","time_of_day":"dusk"]],url:artwork)]
        viewer.applyFilters()
        try snapshot(viewer.window!, "07-viewer", .darkAqua)
    }
}
