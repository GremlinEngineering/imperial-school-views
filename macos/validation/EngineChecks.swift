import Foundation

@main struct EngineChecks {
    @MainActor static func main() async throws {
        let fixtures = URL(fileURLWithPath:CommandLine.arguments[1])
        let jpeg = try Data(contentsOf:fixtures.appendingPathComponent("daily-1.0.13/macbook.jpg"))
        var file = try DataModel.read(fixtures.appendingPathComponent("packages/manifest.json")).rows("variants")[0]
        file["url"] = "collections/sample-weather/files/autumn-day-clear-macbook.jpg"
        let collection:JSON = ["id":"sample-weather","title":"Weather","type":"weather","formats":["macbook":["width":80,"height":50],"ultrawide":["width":3440,"height":1440]],"sources":[["id":"real","current_url":"weather/sample-weather/current.json","forecasts":["macbook":"weather/sample-weather/forecast-macbook.json","ultrawide":"weather/sample-weather/forecast-ultrawide.json"]]]]
        let catalog:JSON = ["schema":3,"title":"new","collections":[collection],"items":[],"downloads":[]]
        let profile = DataModel.profile(["mode":"weather","collection":"sample-weather","weather_source":"real","weather_delivery":"images"])
        let now = Date()
        let current:JSON = ["schema":1,"type":"weather","collection_id":"sample-weather","source_id":"real","location_revision":"r1","timezone":"UTC"]
        let forecast:JSON = ["schema":1,"document_type":"weather-forecast","collection_id":"sample-weather","source_id":"real","location_revision":"r1","timezone":"UTC","format":"macbook","contract_version":"test-1","package_version":NSNull(),"generated_at":DataModel.stamp(now.addingTimeInterval(-120)),"valid_until":DataModel.stamp(now.addingTimeInterval(3600)),"intervals":[["status":"ready","valid_from":DataModel.stamp(now.addingTimeInterval(-60)),"valid_until":DataModel.stamp(now.addingTimeInterval(600)),"state_id":"autumn-day-clear","moon_phase":"none","file":file]]]
        var roots:[URL] = []; defer { for root in roots { try? FileManager.default.removeItem(at:root) } }
        func expect(_ value: @autoclosure () -> Bool, _ text:String) throws { try require(value(),text) }
        func engine() -> Engine {
            let root = FileManager.default.temporaryDirectory.appendingPathComponent("isv-engine-"+UUID().uuidString); roots.append(root)
            let e = Engine(dataRoot:root); e.catalog = catalog; e.lastCatalog = Date(); e.lastUpdate = Date(); e.settings["common"] = profile
            e.displays.values = [Display(id:"d1",number:1,title:"Display",width:1600,height:1000)]
            e.fetchJSON = { url in if url.path.hasSuffix("manifest-v3.json") { return catalog }; if url.path.hasSuffix("current.json") { return current }; return forecast }
            e.fetchImage = { _ in jpeg }; NSWorkspace.shared.calls = 0; NSWorkspace.shared.applications = [:]; return e
        }
        func complete(_ e:Engine, force:Bool = true) async { e.refresh(force:force); let task = e.job; await task?.value; await Task.yield() }

        let a = engine(); a.settings["paused"] = true
        a.fetchJSON = { _ in try await Task.sleep(nanoseconds:1_000_000_000); return catalog }
        a.refresh(); let first = a.job!; let generation = a.generation; a.refresh(); try expect(a.generation == generation && !first.isCancelled,"Ordinary refresh replaced active job")
        a.refresh(force:true); let replacement = a.job!; try expect(first.isCancelled && a.generation == generation+1 && !replacement.isCancelled,"Forced refresh did not cancel old job")
        a.shutdown(); await first.value; await replacement.value
        print("PASS refresh: ordinary/forced/cancellation")

        let b = engine(); await complete(b)
        try expect(b.current["d1"]?.file.s("sha256") == file.s("sha256") && b.current["d1"]?.schedule != nil,"Server weather did not apply")
        b.memo.removeAll(); b.fetchJSON = { _ in throw ViewsError("offline") }; b.fetchImage = { _ in throw ViewsError("unexpected image request") }
        await complete(b); try expect(b.current["d1"]?.schedule != nil,"Compatible offline forecast lost")
        b.shutdown(); print("PASS weather: server JPEG and compatible offline forecast")

        let c = engine(); await complete(c); let previous = c.current["d1"]!.url; c.memo.removeAll()
        c.fetchJSON = { url in if url.path.hasSuffix("manifest-v3.json") { return catalog }; if url.path.hasSuffix("current.json") { var v = current; v["location_revision"] = "r2"; return v }; throw ViewsError("new forecast unavailable") }
        await complete(c); try expect(c.current["d1"]?.url == previous && c.current["d1"]?.schedule == nil && c.current["d1"]?.until == nil,"Old schedule survived changed source identity")
        let calls = NSWorkspace.shared.calls; await c.applyCachedSchedules(); try expect(NSWorkspace.shared.calls == calls,"Invalidated schedule changed wallpaper"); c.shutdown()
        print("PASS weather: changed identity retains JPEG and invalidates schedule")

        let d = engine(); d.settings["paused"] = true; var firstStarted = false; var request = 0
        d.fetchJSON = { _ in request += 1; if request == 1 { firstStarted = true; try? await Task.sleep(nanoseconds:50_000_000); var old = catalog; old["title"] = "old"; return old }; return catalog }
        d.refresh(force:true); let obsolete = d.job!; while !firstStarted { await Task.yield() }; d.refresh(force:true); let latest = d.job!; await latest.value; await obsolete.value
        try expect(d.catalog.s("title") == "new" && d.job == nil,"Cancelled response overwrote current catalog/job"); d.shutdown()
        print("PASS refresh: late cancelled response cannot overwrite latest job")

        let e = engine(); _ = try await e.installer.importCollection(fixtures.appendingPathComponent("packages/collection.zip")); e.settings["common"] = DataModel.profile(["source":"local","mode":"monthly","collection":"local-test"]); e.lastCatalog = .distantPast
        e.fetchJSON = { _ in try await Task.sleep(nanoseconds:10_000_000_000); throw ViewsError("offline") }
        e.refresh(); let slow = e.job!; let deadline = Date().addingTimeInterval(5)
        while e.current["d1"] == nil && Date() < deadline { try await Task.sleep(nanoseconds:1_000_000) }
        try expect(e.current["d1"] != nil && e.job != nil,"Cached local wallpaper waited for network"); e.shutdown(); await slow.value
        print("PASS offline: local wallpaper applies while network request is pending")

        let f = engine(); f.displays.isRefreshing = true; f.refresh(force:true); await f.applyCachedSchedules(); try expect(f.job == nil && f.current.isEmpty,"Applied wallpaper during display identity refresh"); f.displays.isRefreshing = false; f.shutdown()
        print("PASS monitors: pending identity prevents application")

        let g = engine(); g.settings["saver"] = ["enabled":true,"mode":"own","profile":profile]; var saverStarted = false
        g.fetchJSON = { url in saverStarted = true; try await Task.sleep(nanoseconds:30_000_000); return url.path.hasSuffix("current.json") ? current : forecast }
        try await g.store.save(["schema":1,"configuration_revision":"old","targets":[:]],path:"saver-state.json")
        let publishing = Task { try await g.publishSaver(force:true) }; while !saverStarted { await Task.yield() }; g.generation += 1
        do { try await publishing.value; throw ViewsError("Stale saver publication accepted") } catch is CancellationError {}
        let feed = await g.store.json("saver-state.json"); try expect(feed?.s("configuration_revision") == "old","Stale saver feed overwritten"); g.shutdown()
        print("PASS saver: obsolete configuration cannot publish feed")

        let h = engine(); h.displays.values.append(Display(id:"d2",number:2,title:"Wide",width:3440,height:1440))
        let hashA = String(repeating:"a",count:64), hashB = String(repeating:"b",count:64)
        h.catalog["downloads"] = [("macbook",hashA),("ultrawide",hashB)].map { f,h -> JSON in ["collection":"sample-weather","format":"zip","rendition":f,"version":"v1","sha256":h,"url":"downloads/weather-test-\(f).zip"] }
        for (format,hash) in [("macbook",hashA),("ultrawide",hashB)] { try await h.store.save(["id":"sample-weather","format":format,"version":"v1","variants":[file]],path:"weather-cache-1.7/packages/\(hash).json") }
        h.downloadCollection(profile,target:"d2"); try expect(Set(h.packages.keys) == Set([hashB]),"Download used first monitor instead of selected monitor"); for t in Array(h.packages.values) { await t.value }
        h.downloadCollection(profile,target:"all"); try expect(Set(h.packages.keys) == Set([hashA,hashB]),"All-monitors download skipped a format"); for t in Array(h.packages.values) { await t.value }; h.shutdown()
        print("PASS downloads: selected monitor and all monitor formats")

        let dynamicRoot = fixtures.appendingPathComponent("dynamic-0.2")
        let dynamicPath = "dynamic/test-theme/devices/landscape/"
        let dynamicCollection = try DataModel.read(dynamicRoot.appendingPathComponent("manifest-v3.json")).rows("collections")[0]
        let dynamicDescriptor = try DataModel.read(dynamicRoot.appendingPathComponent(dynamicCollection.s("current_url")))
        let dynamicState = try DataModel.read(dynamicRoot.appendingPathComponent(dynamicPath + "current.json"))
        let images = try ["current.jpg", "current-preview.jpg"].map { try Data(contentsOf: dynamicRoot.appendingPathComponent(dynamicPath + $0)) }
        let hashes = images.map(DataModel.sha)
        let export = CommandLine.arguments.dropFirst(2).first.map { URL(fileURLWithPath:$0, isDirectory:true) }
        func exportSaver(_ e: Engine, as name: String) async throws {
            guard let export else { return }
            try await e.store.save(e.settings,path:"settings.json")
            try FileManager.default.createDirectory(at:export,withIntermediateDirectories:true)
            try FileManager.default.copyItem(at:e.root,to:export.appendingPathComponent(name))
        }

        let own = engine()
        own.catalog["collections"] = [dynamicCollection]
        own.settings["saver"] = ["enabled":true,"mode":"own","profile":DataModel.profile(["mode":"weather","collection":"test-theme"])]
        for (index, image) in images.enumerated() {
            var state = dynamicState, descriptor = dynamicDescriptor, files = descriptor.j("files")
            var compatibility = state.j("image")
            compatibility["bytes"] = image.count; compatibility["sha256"] = hashes[index]
            var primary = compatibility
            primary["format"] = "png"; primary["url"] = dynamicPath + "current.png"; primary["sha256"] = DataModel.sha(Data("primary-\(index)".utf8))
            state["at"] = DataModel.stamp(now); state["valid_until"] = DataModel.stamp(now.addingTimeInterval(600))
            state["image"] = primary; state["compatibility_image"] = compatibility
            primary["compatibility_image"] = compatibility
            files["landscape"] = primary; descriptor["files"] = files
            own.fetchJSON = { url in url.path.hasSuffix(dynamicPath + "current.json") ? state : descriptor }
            own.fetchImage = { url in
                try expect(url.path.hasSuffix(dynamicPath + "current.jpg") && url.query == "v=\(hashes[index])", "Expected the published compatibility JPEG")
                return image
            }
            try await own.publishSaver(force:true)
            let output = await own.store.json("saver-state.json") ?? [:]
            let target = output.j("targets").j("d1")
            try expect(target.rows("frames").map { $0.s("sha256") } == [hashes[index]], "Own saver feed did not refresh to the compatibility JPEG")
            try await exportSaver(own,as:index == 0 ? "own-first" : "own-next")
        }
        try expect(own.current.isEmpty && NSWorkspace.shared.calls == 0,"Own saver changed the desktop")
        own.shutdown()
        print("PASS saver: own dynamic collection publishes consecutive compatibility JPEGs")

        let inherited = engine()
        var weather = collection
        weather["formats"] = ["macbook":["width":8,"height":6]]
        inherited.catalog["collections"] = [weather]
        let weatherCatalog = inherited.catalog
        inherited.settings["saver"] = ["enabled":true,"mode":"inherit"]
        let boundary = Date().addingTimeInterval(export == nil ? 300 : 10)
        var schedule = forecast, weatherFiles: [JSON] = []
        schedule["package_version"] = "v1"
        for (index, image) in images.enumerated() {
            var entry = file
            entry["width"] = 8; entry["height"] = 6; entry["bytes"] = image.count; entry["sha256"] = hashes[index]
            entry["url"] = "collections/sample-weather/files/forecast-\(index).jpg"
            _ = try await inherited.store.putImage(image,file:entry)
            weatherFiles.append(entry)
        }
        schedule["intervals"] = weatherFiles.enumerated().map { index, entry -> JSON in
            let from = index == 0 ? boundary.addingTimeInterval(-360) : boundary
            let until = index == 0 ? boundary : boundary.addingTimeInterval(360)
            return ["status":"ready","valid_from":DataModel.stamp(from),"valid_until":DataModel.stamp(until),"file":entry]
        }
        inherited.fetchJSON = { url in
            if url.path.hasSuffix("manifest-v3.json") { return weatherCatalog }
            return url.path.hasSuffix("current.json") ? current : schedule
        }
        inherited.fetchImage = { _ in throw ViewsError("Cached forecast JPEG requested from the network") }
        var draft = profile; draft["weather_delivery"] = "zip"
        let draftFrame = try await inherited.resolve(draft,display:inherited.displays.values[0],force:false,preview:true)
        let pairKey = DataModel.sha(Data("sample-weather|real|macbook".utf8))
        let savedPair = await inherited.store.json("native-pairs/\(pairKey).json")
        try expect(draftFrame.file.s("sha256") == hashes[0], "Draft preview did not select the scheduled weather JPEG")
        try expect(inherited.current.isEmpty && inherited.packages.isEmpty && inherited.pairs.isEmpty && inherited.memo.isEmpty && savedPair == nil && NSWorkspace.shared.calls == 0,"Draft preview changed the installed wallpaper or started an archive download")
        await complete(inherited)
        let inheritedFeed = await inherited.store.json("saver-state.json") ?? [:]
        let inheritedTarget = inheritedFeed.j("targets").j("d1")
        try expect(inherited.current["d1"]?.file.s("sha256") == hashes[0] && inheritedTarget.j("fallback").s("sha256") == hashes[0], "Saver did not inherit the current desktop frame")
        try expect(inheritedTarget.rows("frames").map { $0.s("sha256") } == hashes, "Inherited saver did not receive both cached forecast frames")
        try await exportSaver(inherited,as:"inherit")
        inherited.shutdown()
        print("PASS preview: scheduled weather frame without applying settings or starting a ZIP download")
        print("PASS saver: inherited desktop weather publishes the cached forecast schedule")
        print("Engine scenarios: 11 passed")
    }
}
