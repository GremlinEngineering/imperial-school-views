// Portable test doubles. These do not validate Apple SDK signatures or AppKit rendering.
import Foundation
@MainActor final class NSApplication {
    enum ActivationPolicy { case regular }
    static let shared = NSApplication()
    var terminated = false
    func setActivationPolicy(_ policy: ActivationPolicy) {}
    func activate(ignoringOtherApps: Bool) {}
    func terminate(_ sender: Any?) { terminated = true }
}
@MainActor var NSApp: NSApplication { NSApplication.shared }
@MainActor final class NSAlert {
    static var messages: [String] = []
    var messageText = "", informativeText = ""
    func addButton(withTitle: String) {}
    func runModal() { Self.messages.append(informativeText) }
}
@MainActor final class NSRunningApplication {
    struct ActivationOptions: OptionSet { let rawValue: Int; static let activateIgnoringOtherApps = Self(rawValue:1) }
    static var running: [NSRunningApplication] = []
    let processIdentifier: Int32, bundleURL: URL?
    init(_ pid: Int32, _ url: URL?) { processIdentifier = pid; bundleURL = url }
    static func runningApplications(withBundleIdentifier: String) -> [NSRunningApplication] { running }
    func activate(options: ActivationOptions) {}
}
@MainActor final class NSWorkspace {
    final class OpenConfiguration { var activates = false, createsNewApplicationInstance = true }
    static let shared = NSWorkspace()
    var failure: Error?, requested: URL?, config: OpenConfiguration?
    func openApplication(at url: URL, configuration: OpenConfiguration, completionHandler: (NSRunningApplication?,Error?) -> Void) {
        requested = url; config = configuration; completionHandler(NSRunningApplication.running.first,failure)
    }
}
@MainActor final class Engine {}
@MainActor final class TestWindow {
    var deminiaturized = false, ordered = false
    func deminiaturize(_ sender: Any?) { deminiaturized = true }
    func makeKeyAndOrderFront(_ sender: Any?) { ordered = true }
}
@MainActor final class SettingsWindow {
    let window: TestWindow? = TestWindow()
    var shown = false
    init(engine: Engine) {}
    func showWindow(_ sender: Any?) { shown = true }
}
