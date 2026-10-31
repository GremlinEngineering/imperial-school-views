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
        print("Engine scenarios: 8 passed")
    }
}
