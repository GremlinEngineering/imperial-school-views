import Foundation
@main struct StartupChecks {
    @MainActor static func main() async throws {
        func expect(_ value: Bool, _ message: String) throws { if !value { throw NSError(domain:message,code:1) } }
        func reset() { NSApp.terminated = false; NSAlert.messages = []; NSRunningApplication.running = []; NSWorkspace.shared.failure = nil; NSWorkspace.shared.requested = nil }
        func settle() async { let deadline = Date().addingTimeInterval(5); while !NSApp.terminated && Date() < deadline { try? await Task.sleep(nanoseconds:1_000_000) } }
        reset()
        let early = StartupDelegate()
        _ = early.applicationShouldHandleReopen(NSApp,hasVisibleWindows:false)
        try expect(early.wantsSettings && early.settings == nil,"Reopen before engine was not deferred")
        early.engine = Engine(); early.openSettings()
        try expect(early.settings?.shown == true && early.settings?.window?.deminiaturized == true && early.settings?.window?.ordered == true,"Window not shown and restored")
        print("PASS startup: early reopen and minimized window")
        reset()
        let running = NSRunningApplication(ProcessInfo.processInfo.processIdentifier + 1,URL(fileURLWithPath:"/Applications/Imperial School Views.app"))
        NSRunningApplication.running = [running]
        let reopen = StartupDelegate(); defer { withExtendedLifetime(reopen) {} }; reopen.reopenExisting(); await settle()
        try expect(NSWorkspace.shared.requested == running.bundleURL && NSWorkspace.shared.config?.createsNewApplicationInstance == false && NSWorkspace.shared.config?.activates == true && NSApp.terminated,"Existing instance did not receive reopen")
        print("PASS startup: forward to existing instance")
        reset(); NSRunningApplication.running = [running]
        NSWorkspace.shared.failure = NSError(domain:"test reopen failed",code:1)
        let failed = StartupDelegate(); defer { withExtendedLifetime(failed) {} }; failed.reopenExisting(); await settle()
        try expect(!NSAlert.messages.isEmpty && NSApp.terminated,"Reopen failure remained silent")
        print("PASS startup: reopen failure is visible")
        reset()
        let orphan = StartupDelegate(); orphan.reopenExisting()
        try expect(!NSAlert.messages.isEmpty && NSWorkspace.shared.requested == nil && NSApp.terminated,"Unknown lock owner remained silent")
        print("PASS startup: unknown lock owner is visible")
        print("Startup scenarios: 4 passed (modeled AppKit adapters)")
    }
}
