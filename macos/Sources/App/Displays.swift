import AppKit
import ColorSync
import CoreGraphics

struct Display: Sendable {
    var id: String, number: UInt32, title: String, width: Double, height: Double
    @MainActor var screen: NSScreen? { NSScreen.screens.first { ($0.deviceDescription[NSDeviceDescriptionKey("NSScreenNumber")] as? NSNumber)?.uint32Value == number } }
}
@MainActor final class Displays {
    var values: [Display] = []; var onChange: (() -> Void)?, onWillChange: (() -> Void)?; private var generation = 0
    private(set) var isRefreshing = false
    func refresh() {
        generation += 1; let revision = generation; isRefreshing = true; onWillChange?()
        let raw = NSScreen.screens.compactMap { s -> Display? in
            guard let n = s.deviceDescription[NSDeviceDescriptionKey("NSScreenNumber")] as? NSNumber else { return nil }
            let mode = CGDisplayCopyDisplayMode(n.uint32Value)
            return Display(id: "", number: n.uint32Value, title: s.localizedName, width: Double(mode?.pixelWidth ?? Int(s.frame.width * s.backingScaleFactor)), height: Double(mode?.pixelHeight ?? Int(s.frame.height * s.backingScaleFactor)))
        }
        // No subprocess, pipe, polling or arbitrary helper timeout. Only immutable
        // display numbers cross this queue; all NSScreen access stays on main.
        Task {
            let resolved = await Task.detached(priority: .userInitiated) {
                raw.compactMap { display -> Display? in
                    guard let uuid = CGDisplayCreateUUIDFromDisplayID(display.number)?.takeRetainedValue(), let text = CFUUIDCreateString(nil, uuid) as String? else { return nil }
                    var d = display; d.id = text; return d
                }
            }.value
            guard revision == generation else { return }; values = resolved; isRefreshing = false; onChange?()
        }
    }
}
