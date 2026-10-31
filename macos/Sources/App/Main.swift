import AppKit
import Darwin

@main struct ViewsMain {
    @MainActor static func main() { let app = NSApplication.shared; let delegate = AppDelegate(); app.delegate = delegate; withExtendedLifetime(delegate) { app.run() } }
}
@MainActor final class AppDelegate: NSObject, NSApplicationDelegate {
    var engine: Engine!, settings: SettingsWindow?, item: NSStatusItem!, observations: [NSObjectProtocol] = [], lease: InstanceLease?
    var wantsSettings = false
    func applicationDidFinishLaunching(_ notification:Notification) {
        let root = FileManager.default.homeDirectoryForCurrentUser.appendingPathComponent("Library/Application Support/Imperial School Views")
        do { lease = try InstanceLease(dataRoot:root) }
        catch InstanceLeaseError.busy { reopenExisting(); return }
        catch { startupFailure(error.localizedDescription); return }
        do { try InstanceLease.checkDataDirectory(root) }
        catch { startupFailure("Нет доступа к папке данных:\n" + root.path + "\n\n" + error.localizedDescription); return }
        NSApp.setActivationPolicy(.accessory); installMenu(); engine = Engine(); engine.onChange = { [weak self] in self?.settings?.updateState(); self?.rebuildMenu() }
        item = NSStatusBar.system.statusItem(withLength:NSStatusItem.squareLength); item.button?.image = NSImage(systemSymbolName:"gamecontroller",accessibilityDescription:"Виды и обои"); rebuildMenu(); engine.start()
        observations.append(NotificationCenter.default.addObserver(forName:NSApplication.didChangeScreenParametersNotification,object:nil,queue:.main) { [weak self] _ in Task { @MainActor in self?.engine.displays.refresh() } })
        observations.append(NSWorkspace.shared.notificationCenter.addObserver(forName:NSWorkspace.didWakeNotification,object:nil,queue:.main) { [weak self] _ in Task { @MainActor in self?.engine.displays.refresh() } })
        if wantsSettings || !CommandLine.arguments.contains("--background") { openSettings() }
    }
    func startupFailure(_ message: String) {
        NSApp.setActivationPolicy(.regular); NSApp.activate(ignoringOtherApps:true)
        let alert = NSAlert(); alert.messageText = "Не удалось открыть «Виды и обои»"; alert.informativeText = message; alert.addButton(withTitle:"Закрыть"); alert.runModal(); NSApp.terminate(nil)
    }
    func reopenExisting() {
        guard let running = NSRunningApplication.runningApplications(withBundleIdentifier:"ru.oopssre.imperial-school.views").first(where:{ $0.processIdentifier != ProcessInfo.processInfo.processIdentifier }), let url = running.bundleURL else {
            startupFailure("Другой экземпляр приложения занимает файл запуска. Завершите ImperialSchoolViews в «Мониторинге системы» и откройте приложение снова."); return
        }
        running.activate(options:[.activateIgnoringOtherApps])
        let config = NSWorkspace.OpenConfiguration(); config.activates = true; config.createsNewApplicationInstance = false
        // A Launch Services reopen request reaches applicationShouldHandleReopen;
        // activating an accessory process alone does not reopen its window.
        NSWorkspace.shared.openApplication(at:url,configuration:config) { [weak self] _, error in
            let message = error?.localizedDescription
            Task { @MainActor in
                if let message { self?.startupFailure(message) } else { NSApp.terminate(nil) }
            }
        }
    }
    func rebuildMenu() {
        guard item != nil else { return }; let menu = NSMenu(); let title = NSMenuItem(title:"Виды и обои · \(DataModel.version)",action:nil,keyEquivalent:""); title.isEnabled = false; menu.addItem(title)
        add(menu,"Настройки…",#selector(openSettings)); add(menu,"Просмотрщик…",#selector(openViewer)); add(menu,"Обновить сейчас",#selector(refresh)); add(menu,engine?.settings.b("paused") == true ? "Продолжить смену обоев" : "Приостановить смену обоев",#selector(pause)); menu.addItem(.separator()); add(menu,"Выйти",#selector(quit)); item.menu = menu
    }
    func add(_ menu:NSMenu,_ title:String,_ action:Selector) { let item = NSMenuItem(title:title,action:action,keyEquivalent:""); item.target = self; menu.addItem(item) }
    func installMenu() {
        let bar = NSMenu(), root = NSMenuItem(), app = NSMenu(title:"Виды и обои")
        let settings = NSMenuItem(title:"Настройки…",action:#selector(openSettings),keyEquivalent:","); settings.target = self; app.addItem(settings)
        let viewer = NSMenuItem(title:"Просмотрщик…",action:#selector(openViewer),keyEquivalent:"o"); viewer.target = self; app.addItem(viewer)
        app.addItem(.separator())
        let quitItem = NSMenuItem(title:"Выйти",action:#selector(quit),keyEquivalent:"q"); quitItem.target = self; app.addItem(quitItem)
        root.submenu = app; bar.addItem(root); NSApp.mainMenu = bar
        let editRoot = NSMenuItem(), edit = NSMenu(title:"Правка")
        edit.addItem(NSMenuItem(title:"Вырезать",action:#selector(NSText.cut(_:)),keyEquivalent:"x"))
        edit.addItem(NSMenuItem(title:"Копировать",action:#selector(NSText.copy(_:)),keyEquivalent:"c"))
        edit.addItem(NSMenuItem(title:"Вставить",action:#selector(NSText.paste(_:)),keyEquivalent:"v"))
        edit.addItem(NSMenuItem(title:"Выбрать всё",action:#selector(NSText.selectAll(_:)),keyEquivalent:"a"))
        editRoot.submenu = edit; bar.addItem(editRoot)
    }
    @objc func openSettings() { guard engine != nil else { wantsSettings = true; return }; if settings == nil { settings = SettingsWindow(engine:engine) }; settings?.showWindow(nil); settings?.window?.deminiaturize(nil); settings?.window?.makeKeyAndOrderFront(nil); NSApp.activate(ignoringOtherApps:true) }
    @objc func openViewer() { if settings == nil { settings = SettingsWindow(engine:engine) }; settings?.openViewer() }
    @objc func refresh() { engine.refresh(force:true) }
    @objc func pause() { engine.settings["paused"] = !engine.settings.b("paused"); engine.commit() }
    @objc func quit() { NSApp.terminate(nil) }
    func applicationShouldHandleReopen(_ sender:NSApplication,hasVisibleWindows flag:Bool) -> Bool { openSettings(); return true }
    func applicationWillTerminate(_ notification:Notification) { engine?.shutdown(); lease?.release(); lease = nil }
}
