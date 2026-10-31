import XCTest
@testable import ViewsCore

final class CoreTests: XCTestCase {
    var fixtures: URL { URL(fileURLWithPath:#filePath).deletingLastPathComponent().appendingPathComponent("Fixtures") }
    func json(_ path:String) throws -> JSON { try DataModel.read(fixtures.appendingPathComponent(path)) }
    func testSHA256KnownVectors() throws {
        XCTAssertEqual(DataModel.sha(Data()),"e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855")
        XCTAssertEqual(DataModel.sha(Data("abc".utf8)),"ba7816bf8f01cfea414140de5dae2223b00361a396177a9cb410ff61f20015ad")
    }
    func testMigrationPreservesProfilesAndCoordinates() {
        let city:JSON = ["name":"Chosen","latitude":13.125,"longitude":-11.25,"timezone":"Africa/Dakar"]
        let s = DataModel.settings(["schema":2,"linked":false,"common":["mode":"weather","collection":"test","weather_city":city],"monitors":["uuid-a":["mode":"daily","collection":"other","manage":false]],"saver":["enabled":true,"mode":"own","interval":90,"profile":["mode":"slideshow","collection":"gallery"]]])
        XCTAssertFalse(s.b("linked")); XCTAssertEqual(s.j("common").j("weather_city").n("latitude"),13.125); XCTAssertFalse(DataModel.profile(for:"uuid-a",settings:s).b("manage",true)); XCTAssertEqual(s.j("saver").j("profile").s("mode"),"slideshow"); XCTAssertEqual(s.j("saver").n("interval"),90)
        XCTAssertFalse(DataModel.profile(for:"new-display",settings:s).b("manage",true))
    }
    func testURLTraversalAndForeignPathsRejected() throws {
        for path in ["../private","https://evil/x","/files/a.jpg","files/%2e%2e/a.jpg","files//a.jpg","files/a.jpg?x=1","files/a\\b.jpg"] { XCTAssertThrowsError(try DataModel.resource(path),path) }
        XCTAssertEqual(try DataModel.resource("dynamic/theme/devices/desktop_3456x2234/current.json").scheme,"https")
    }
    func testCompressionFormatsAndAlreadyDecodedURLSession() throws {
        for (path,encoding,sidecar) in [("plain.json","",false),("plain.json.br","",true),("http-gzip","gzip",false),("stack-gzip-br","gzip, br",false),("sidecar-http-gzip","gzip",true),("plain.json","br",false),("plain.json","br",true)] {
            let data = try Data(contentsOf:fixtures.appendingPathComponent("compression/"+path)); XCTAssertEqual(try Network.decodeJSON(data,encoding:encoding,sidecar:sidecar).s("hello"),"native")
        }
    }
    func testCorruptAndOversizedJSONRejected() throws {
        XCTAssertThrowsError(try Network.decodeJSON(Data(repeating:0,count:5_000_001),encoding:"",sidecar:false))
        XCTAssertThrowsError(try Network.decodeJSON(Data(contentsOf:fixtures.appendingPathComponent("compression/bomb.br")),encoding:"br",sidecar:false))
        XCTAssertThrowsError(try Network.decodeJSON(Data("bad".utf8),encoding:"br",sidecar:true))
    }
    func testDynamicServerJPEGContract() throws {
        let catalog = try json("dynamic-0.2/manifest-v3.json"), descriptor = try json("dynamic-0.2/dynamic/test-theme/current.json"), state = try json("dynamic-0.2/dynamic/test-theme/devices/landscape/current.json"), now = DataModel.date("2026-10-31T10:10:00Z")!
        let file = try Contracts.dynamic(descriptor:descriptor,state:state,collection:catalog.rows("collections")[0],device:"landscape",at:now)
        XCTAssertEqual(file.s("format"),"jpg"); XCTAssertEqual(file.n("width"),8)
        var broken = state; broken["device"] = "portrait"; XCTAssertThrowsError(try Contracts.dynamic(descriptor:descriptor,state:broken,collection:catalog.rows("collections")[0],device:"landscape",at:now))
        XCTAssertThrowsError(try Contracts.dynamic(descriptor:descriptor,state:state,collection:catalog.rows("collections")[0],device:"landscape",at:now.addingTimeInterval(7200)))
        broken = state; var image = state.j("image"); image["sha256"] = String(repeating:"0",count:64); broken["image"] = image; XCTAssertThrowsError(try Contracts.dynamic(descriptor:descriptor,state:broken,collection:catalog.rows("collections")[0],device:"landscape",at:now))
    }
    func testDailyNotReadyAndExpiredHoldWallpaper() throws {
        let d = try json("daily-1.0.13/real-ready.json"), t = DataModel.date(d.s("valid_from"))!.addingTimeInterval(1)
        XCTAssertNoThrow(try Contracts.daily(d,source:"real",at:t)); XCTAssertThrowsError(try Contracts.daily(d,source:"game-world",at:t)); XCTAssertThrowsError(try Contracts.daily(d,source:"real",at:DataModel.date(d.s("valid_until"))!))
        XCTAssertThrowsError(try Contracts.daily(json("daily-1.0.13/not-ready.json"),source:"real",at:t))
    }
    func testWeatherForecastCompatibilityAndBoundary() throws {
        let catalog = try json("daily-1.0.13/catalog.json"), collection = catalog.rows("collections").first { $0.s("id") == "sample-weather" }!, forecast = try json("daily-1.0.13/forecast-macbook.json")
        var current:JSON = ["schema":1,"type":"weather","collection_id":collection.s("id"),"source_id":forecast.s("source_id"),"location_revision":forecast.s("location_revision"),"timezone":forecast.s("timezone")]; if let world = forecast["world_id"] { current["world_id"] = world }
        try Contracts.weatherPair(current:current,forecast:forecast,collection:collection,source:forecast.s("source_id"),format:"macbook")
        current["location_revision"] = "different"; XCTAssertThrowsError(try Contracts.weatherPair(current:current,forecast:forecast,collection:collection,source:forecast.s("source_id"),format:"macbook"))
        let rows = forecast.rows("intervals"); XCTAssertEqual(try Contracts.interval(forecast,at:DataModel.date(rows[0].s("valid_from"))!).s("state_id"),rows[0].s("state_id"))
        XCTAssertThrowsError(try Contracts.interval(forecast,at:DataModel.date(rows[0].s("valid_until"))!))
    }
    func testAstronomyGoldenAcrossTimezonesDSTAndPolarDays() throws {
        let rows = try JSONSerialization.jsonObject(with:Data(contentsOf:fixtures.appendingPathComponent("astronomy-golden.json"))) as! [JSON]
        XCTAssertEqual(rows.count,56)
        for row in rows {
            let city = try City(row.j("city")), key = row.s("date"), events = Astronomy.events(key,city:city)
            XCTAssertEqual(Astronomy.moon(key),row.s("moon"),"\(city.name) \(key)")
            XCTAssertEqual(Astronomy.midnight(key,zone:city.zone)?.timeIntervalSince1970,row.n("midnight"))
            for name in ["dawn","sunrise","sunset","dusk"] { if row.j("events")[name] is NSNull { XCTAssertNil(events[name]) } else { XCTAssertEqual(events[name]?.timeIntervalSince1970,row.j("events").n(name),"\(city.name) \(key) \(name)") } }
        }
    }
    func testGalleryFiltersUseOneRuleAndKeepMoonNoneDistinct() {
        let file:JSON = ["sha256":String(repeating:"a",count:64)], url = URL(fileURLWithPath:"/sample")
        let rows = GalleryRow.merge([(file,["season":"winter","time_of_day":"day","moon_phase":"none"],url),(file,["season":"summer","time_of_day":"night","moon_phase":"new_moon"],url)])
        XCTAssertEqual(rows.count,1); XCTAssertFalse(rows[0].matches(["season":"winter","time_of_day":"night"])); XCTAssertTrue(rows[0].matches(["moon_phase":"none"])); XCTAssertTrue(rows[0].matches(["moon_phase":"new_moon"]))
    }
    func testZIPUsesSHAWithStaleCatalogBytes() async throws {
        let dir = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString); defer { try? FileManager.default.removeItem(at:dir) }; let store = CacheStore(root:dir), zip = fixtures.appendingPathComponent("packages/valid.zip"), descriptor:JSON = ["sha256":try DataModel.sha(zip),"bytes":1]
        let receipt = try await store.installWeatherZIP(zip,descriptor:descriptor,collection:"sample-weather",format:"macbook",version:"opaque-v1"); XCTAssertEqual(receipt.rows("variants").count,1)
        let url = await store.cached(receipt.rows("variants")[0]); XCTAssertNotNil(url)
    }
    func testZIPTraversalSymlinkMissingAndWrongHashRejected() async throws {
        let dir = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString); defer { try? FileManager.default.removeItem(at:dir) }; let store = CacheStore(root:dir)
        for name in ["traversal.zip","symlink.zip","missing.zip"] { let zip = fixtures.appendingPathComponent("packages/"+name); do { _ = try await store.installWeatherZIP(zip,descriptor:["sha256":try DataModel.sha(zip)],collection:"sample-weather",format:"macbook",version:"opaque-v1"); XCTFail("Accepted \(name)") } catch {} }
        do { _ = try await store.installWeatherZIP(fixtures.appendingPathComponent("packages/valid.zip"),descriptor:["sha256":String(repeating:"0",count:64)],collection:"sample-weather",format:"macbook",version:"opaque-v1"); XCTFail("Accepted wrong hash") } catch {}
    }
    func testOrdinaryZIPImportAndOfflineSelection() async throws {
        let dir = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString); defer { try? FileManager.default.removeItem(at:dir) }; let store = CacheStore(root:dir)
        _ = try await store.importCollection(fixtures.appendingPathComponent("packages/collection.zip"))
        let catalog = DataModel.merging(packs:await store.localPacks(),catalog:[:]), item = try DataModel.selectItem(catalog:catalog,profile:["mode":"monthly","collection":"local-test"])
        XCTAssertEqual(item.s("id"),"local-test--view"); let url = await store.cached(item.rows("files")[0]); XCTAssertNotNil(url)
    }
    func testLegacyCollectionImagesMigrateWithoutNetwork() async throws {
        let dir = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString); defer { try? FileManager.default.removeItem(at:dir) }; let store = CacheStore(root:dir)
        var file = try json("packages/manifest.json").rows("variants")[0]; file["url"] = "collections/local-test/files/view.jpg"
        let path = dir.appendingPathComponent(file.s("url")); try FileManager.default.createDirectory(at:path.deletingLastPathComponent(),withIntermediateDirectories:true); try Data(contentsOf:fixtures.appendingPathComponent("daily-1.0.13/macbook.jpg")).write(to:path)
        let cached = await store.cached(file); XCTAssertEqual(cached?.lastPathComponent,file.s("sha256")+".jpg"); XCTAssertTrue(FileManager.default.fileExists(atPath:path.path))
    }
    func testModifiedCachedJPEGIsRejected() async throws {
        let dir = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString); defer { try? FileManager.default.removeItem(at:dir) }; let store = CacheStore(root:dir), file = try json("packages/manifest.json").rows("variants")[0]
        let url = try await store.putImage(Data(contentsOf:fixtures.appendingPathComponent("daily-1.0.13/macbook.jpg")),file:file); let before = await store.cached(file); XCTAssertNotNil(before)
        var corrupt = try Data(contentsOf:url); corrupt[10] ^= 1; try corrupt.write(to:url); try FileManager.default.setAttributes([.modificationDate:Date().addingTimeInterval(1)],ofItemAtPath:url.path)
        let after = await store.cached(file); XCTAssertNil(after)
    }
    func testCatalogEndpointRejectsInvalidSettingsWithoutCrashing() throws {
        for bad in ["http://host/a.json","https://host/a.txt","https://host/a.json?q=1","https://user:pass@host/a.json","https://host:8080/a.json","http://[bad","https://host/../a.json"] { XCTAssertThrowsError(try DataModel.catalogURL(bad),bad) }
        XCTAssertEqual(try DataModel.catalogURL(DataModel.manifestURL+".br").scheme,"https")
    }
    func testAtomicImagePublicationAcrossIndependentStores() async throws {
        let dir = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString); defer { try? FileManager.default.removeItem(at:dir) }
        let a = CacheStore(root:dir), b = CacheStore(root:dir), file = try json("packages/manifest.json").rows("variants")[0], data = try Data(contentsOf:fixtures.appendingPathComponent("daily-1.0.13/macbook.jpg"))
        async let first = a.putImage(data,file:file); async let second = b.putImage(data,file:file)
        let pair = try await (first,second); XCTAssertEqual(pair.0,pair.1); XCTAssertEqual(try DataModel.sha(pair.0),file.s("sha256"))
    }
    func testLocalGallerySurvivesChangedOnlineCatalog() async throws {
        let dir = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString); defer { try? FileManager.default.removeItem(at:dir) }; let store = CacheStore(root:dir)
        _ = try await store.importCollection(fixtures.appendingPathComponent("packages/collection.zip"))
        let rows = await store.gallery(catalog:["schema":3,"collections":[],"items":[]]); XCTAssertTrue(rows.contains { $0.rules.contains { $0.s("collection") == "local-test" } })
    }
    func testCancellationBeforeJSONRequest() async throws {
        let task = Task { while !Task.isCancelled { await Task.yield() }; return try await Network.json(URL(string:"https://example.invalid/should-not-load.json")!) }
        task.cancel(); do { _ = try await task.value; XCTFail("Cancelled JSON request succeeded") } catch is CancellationError {} catch { XCTFail("Expected cancellation, received \(error)") }
    }
}
