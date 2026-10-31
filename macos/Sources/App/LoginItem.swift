import AppKit
import Darwin

enum LoginItem {
    static let label = "ru.oopssre.imperial-school.views"
    static func run(_ arguments: [String]) async {
        await withCheckedContinuation { continuation in
            DispatchQueue.global(qos: .utility).async {
                let process = Process(); process.executableURL = URL(fileURLWithPath:"/bin/launchctl"); process.arguments = arguments; process.standardOutput = FileHandle.nullDevice; process.standardError = FileHandle.nullDevice
                process.terminationHandler = { _ in continuation.resume() }
                do { try process.run() } catch { continuation.resume() }
            }
        }
    }
    static func migrate(root: URL) async {
        let domain = "gui/\(getuid())", agents = FileManager.default.homeDirectoryForCurrentUser.appendingPathComponent("Library/LaunchAgents")
        let old = agents.appendingPathComponent(label + ".plist"), menu = agents.appendingPathComponent(label + ".menu.plist")
        let oldData = try? Data(contentsOf:old)
        let oldPlist = oldData.flatMap { try? PropertyListSerialization.propertyList(from:$0,options:[],format:nil) as? JSON }
        let arguments = oldPlist?["ProgramArguments"] as? [String] ?? []
        let legacy = arguments.contains { $0.contains("osascript") || $0.hasSuffix("agent.js") } || FileManager.default.fileExists(atPath:menu.path)
        if legacy {
            await run(["bootout",domain + "/" + label]); await run(["bootout",domain + "/" + label + ".menu"])
            try? FileManager.default.removeItem(at: old); try? FileManager.default.removeItem(at: menu)
            try? DataModel.write(["version":DataModel.version,"at":DataModel.stamp()], to:root.appendingPathComponent("native-migration.json"))
        }
        guard let executable = Bundle.main.executableURL, !Bundle.main.bundleURL.path.hasPrefix("/Volumes/") else { return }
        let value: JSON = ["Label":label,"ProgramArguments":[executable.path,"--background"],"RunAtLoad":true,"KeepAlive":false,"ProcessType":"Interactive"]
        if let data = try? PropertyListSerialization.data(fromPropertyList:value, format:.xml, options:0) { try? FileManager.default.createDirectory(at:agents, withIntermediateDirectories:true); try? data.write(to:old, options:.atomic) }
    }
}
