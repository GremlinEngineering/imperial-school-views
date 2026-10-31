import Foundation
import ZIPFoundation

public actor CacheStore {
    public nonisolated let root: URL
    let validateJPEG: (URL, JSON) throws -> Void
    private var verified: [String: String] = [:]
    public init(root: URL, validateJPEG: @escaping (URL, JSON) throws -> Void = { _, _ in }) { self.root = root; self.validateJPEG = validateJPEG }
    public nonisolated func imageURL(_ hash: String) -> URL { root.appendingPathComponent("weather-images/\(hash).jpg") }
    public func cached(_ file: JSON) -> URL? {
        guard DataModel.hash(file.s("sha256")) else { return nil }; let url = imageURL(file.s("sha256"))
        if (try? verify(url, file: file)) != nil { return url }
        if file.s("url").hasPrefix("collections/"), (try? DataModel.resource(file.s("url"))) != nil {
            let legacy = root.appendingPathComponent(file.s("url")); if (try? verify(legacy,file:file)) != nil, let data = try? Data(contentsOf:legacy), let migrated = try? putImage(data,file:file) { return migrated }
        }; return nil
    }
    public func verify(_ url: URL, file: JSON) throws {
        try DataModel.validateFile(file); let attrs = try FileManager.default.attributesOfItem(atPath: url.path)
        try require(attrs[.type] as? FileAttributeType == .typeRegular && (attrs[.size] as? NSNumber)?.doubleValue == file.n("bytes"), "Объём JPEG не соответствует описанию")
        let signature = file.s("sha256") + ":\(file.n("width")):\(file.n("height")):\((attrs[.modificationDate] as? Date)?.timeIntervalSince1970 ?? 0):\(attrs[.systemFileNumber] as? NSNumber ?? 0)"
        if verified[url.path] == signature { return }
        try require(try DataModel.sha(url) == file.s("sha256"), "SHA-256 JPEG не совпадает"); try validateJPEG(url, file)
        verified[url.path] = signature
    }
    public func putImage(_ data: Data, file: JSON) throws -> URL {
        try require(DataModel.sha(data) == file.s("sha256"), "SHA-256 JPEG не совпадает")
        let folder = root.appendingPathComponent("weather-images"); try FileManager.default.createDirectory(at: folder, withIntermediateDirectories: true)
        let temporary = folder.appendingPathComponent(".\(UUID().uuidString).jpg"); defer { try? FileManager.default.removeItem(at: temporary) }; try data.write(to: temporary, options: .atomic); try verify(temporary, file: file)
        let target = imageURL(file.s("sha256")); try DataModel.publish(temporary,to:target); return target
    }
    public func json(_ path: String) -> JSON? { try? DataModel.read(root.appendingPathComponent(path)) }
    public func save(_ value: JSON, path: String) throws { try DataModel.write(value, to: root.appendingPathComponent(path)) }
    public func packageReceipt(_ hash: String) -> JSON? { guard DataModel.hash(hash) else { return nil }; return json("weather-cache-1.7/packages/\(hash).json") }
    public func receipts() -> [JSON] { let folder = root.appendingPathComponent("weather-cache-1.7/packages"); return ((try? FileManager.default.contentsOfDirectory(at: folder, includingPropertiesForKeys: nil)) ?? []).filter { $0.pathExtension == "json" }.compactMap { try? DataModel.read($0) } }
    public func gallery(catalog: JSON) -> [GalleryRow] {
        var values: [(JSON, JSON, URL)] = []
        for receipt in receipts() { for v in receipt.rows("variants") { if let url = cached(v) { var rule = v; rule["collection"] = receipt.s("id"); rule["rendition"] = receipt.s("format"); let p = v.s("state_id").split(separator: "-", maxSplits: 2).map(String.init); if p.count == 3 { rule["season"] = p[0]; rule["time_of_day"] = p[1]; rule["weather"] = p[2] }; values.append((v, rule, url)) } } }
        let local = DataModel.merging(packs:localPacks(),catalog:[:])
        for i in catalog.rows("items") + local.rows("items") { for f in i.rows("files") { if let url = cached(f) { var rule = i; rule["rendition"] = "\(Int(f.n("width")))x\(Int(f.n("height")))"; values.append((f, rule, url)) } } }
        // Include downloaded current server/dynamic images without inventing package rules.
        let snapshots = root.appendingPathComponent("native-current"); for u in (try? FileManager.default.contentsOfDirectory(at: snapshots, includingPropertiesForKeys: nil)) ?? [] { if let s = try? DataModel.read(u), let url = cached(s.j("file")) { values.append((s.j("file"), s.j("rule"), url)) } }
        return GalleryRow.merge(values).sorted { $0.title < $1.title }
    }
    public func importLegacyImages(catalog: JSON) throws {
        for i in catalog.rows("items") { for f in i.rows("files") where cached(f) == nil {
            let path = f.s("url"); _ = try DataModel.resource(path)
            let candidates = [root.appendingPathComponent(path), root.appendingPathComponent(path.replacingOccurrences(of: "collections/", with: "collections/"))]
            if let url = candidates.first(where: { (try? verify($0, file: f)) != nil }) { _ = try putImage(Data(contentsOf: url), file: f) }
        } }
    }
    public func installWeatherZIP(_ zip: URL, descriptor: JSON, collection: String, format: String, version: String) throws -> JSON {
        // Catalog bytes is a progress estimate. SHA-256 authenticates the complete ZIP.
        try require(DataModel.hash(descriptor.s("sha256")) && (try DataModel.sha(zip)) == descriptor.s("sha256"), "SHA-256 ZIP не совпадает")
        let archive = try Archive(url: zip, accessMode: .read)
        var entries: [String: Entry] = [:], total: UInt64 = 0
        for e in archive {
            try require(e.type != .symlink && e.path.utf8.count < 240 && !e.path.hasPrefix("/") && !e.path.contains("..") && !e.path.contains("\\"), "Небезопасный путь в ZIP")
            total += UInt64(e.uncompressedSize); try require(total <= 17 * 1024 * 1024 * 1024 && entries.count < 10000 && entries[e.path] == nil, "ZIP превышает предел размера или содержит дубликаты"); entries[e.path] = e
        }
        guard let manifestEntry = entries["manifest.json"], manifestEntry.type == .file, manifestEntry.uncompressedSize <= 5_000_000 else { throw ViewsError("В ZIP нет manifest.json") }
        var bytes = Data(); let crc = try archive.extract(manifestEntry) { bytes.append($0); try require(bytes.count <= 5_000_000, "Слишком большой манифест") }; try require(crc == manifestEntry.checksum, "CRC манифеста не совпадает"); let manifest = try DataModel.object(bytes)
        try Contracts.package(manifest, id: collection, format: format, version: version)
        let wanted = Set(manifest.rows("variants").map { $0.s("url") })
        for (path, e) in entries where e.type == .file { try require(path == "manifest.json" || path == "weather-package.json" || wanted.contains(path) || DataModel.matches(path, "^(README[^/]*|licen[cs]es/[^/]+|previews/[a-z0-9-]+\\.jpg)$"), "Неожиданный файл в погодном ZIP") }
        let stage = root.appendingPathComponent("native-staging/\(UUID().uuidString)"); try FileManager.default.createDirectory(at: stage, withIntermediateDirectories: true); defer { try? FileManager.default.removeItem(at: stage) }
        for v in manifest.rows("variants") {
            guard let e = entries[v.s("url")], e.type == .file, Double(e.uncompressedSize) == v.n("bytes") else { throw ViewsError("В ZIP отсутствует заявленный JPEG") }
            let file = stage.appendingPathComponent(v.s("sha256") + ".jpg"); if !FileManager.default.fileExists(atPath: file.path) { try boundedExtract(archive,entry:e,to:file,cap:Int64(v.n("bytes"))) }; try verify(file, file: v)
        }
        let folder = root.appendingPathComponent("weather-images"); try FileManager.default.createDirectory(at: folder, withIntermediateDirectories: true)
        for v in manifest.rows("variants") { let source = stage.appendingPathComponent(v.s("sha256") + ".jpg"), target = imageURL(v.s("sha256")); if !FileManager.default.fileExists(atPath: source.path) { continue }; if cached(v) == nil { try DataModel.publish(source,to:target) } }
        let receipt: JSON = ["id":collection,"format":format,"sha256":descriptor.s("sha256"),"version":version,"variants":manifest.rows("variants"),"installed_at":DataModel.stamp()]
        try save(receipt, path: "weather-cache-1.7/packages/\(descriptor.s("sha256")).json"); return receipt
    }
    public func importCollection(_ zip: URL, descriptor: JSON? = nil) throws -> JSON {
        if let descriptor { let sha = try DataModel.sha(zip); try require(DataModel.hash(descriptor.s("sha256")) && sha == descriptor.s("sha256"), "SHA-256 ZIP не совпадает") }
        let archive = try Archive(url:zip,accessMode:.read); var entries: [String: Entry] = [:], total: UInt64 = 0
        for e in archive { try require(e.type != .symlink && DataModel.matches(e.path,"^(manifest\\.json|README\\.txt|collection\\.md|(?:files|previews)/|(?:files|previews)/[a-z0-9-]+\\.jpg)$") && entries[e.path] == nil && entries.count < 10000, "Неверное содержимое ZIP коллекции"); total += UInt64(e.uncompressedSize); try require(total <= 17 * 1024 * 1024 * 1024,"Коллекция слишком велика"); entries[e.path] = e }
        guard let entry = entries["manifest.json"], entry.uncompressedSize <= 5_000_000 else { throw ViewsError("В ZIP нет manifest.json") }
        var data = Data(); let crc = try archive.extract(entry) { data.append($0); try require(data.count <= 5_000_000,"Слишком большой манифест") }; try require(crc == entry.checksum,"CRC манифеста не совпадает"); let pack = try DataModel.object(data)
        try require(pack.n("schema") == 1 && DataModel.id(pack.s("id")) && !pack.s("id").contains("_") && !pack.b("disabled") && pack["enabled"] as? Bool != false && !["weather","dynamic"].contains(pack.s("type")) && !pack.rows("items").isEmpty,"Неверный манифест коллекции")
        if let descriptor { try require(descriptor.s("collection",pack.s("id")) == pack.s("id"),"ZIP относится к другой коллекции") }
        try DataModel.validateCatalog(DataModel.merging(packs:[pack],catalog:[:]))
        let stage = root.appendingPathComponent("native-staging/\(UUID().uuidString)"); try FileManager.default.createDirectory(at:stage,withIntermediateDirectories:true); defer { try? FileManager.default.removeItem(at:stage) }
        for (path,e) in entries where e.type == .file { try boundedExtract(archive,entry:e,to:stage.appendingPathComponent(path),cap:path == "manifest.json" ? 5_000_000 : 100_000_000) }
        for item in pack.rows("items") { for f in item.rows("files") { try require(DataModel.matches(f.s("url"),"^files/[a-z0-9-]+\\.jpg$"),"Неверный путь JPEG коллекции"); let url = stage.appendingPathComponent(f.s("url")); try verify(url,file:f); if cached(f) == nil { _ = try putImage(Data(contentsOf:url),file:f) } } }
        let target = root.appendingPathComponent("collections/\(pack.s("id"))"), backup = root.appendingPathComponent("native-staging/\(UUID().uuidString)")
        try FileManager.default.createDirectory(at:target.deletingLastPathComponent(),withIntermediateDirectories:true)
        if FileManager.default.fileExists(atPath:target.path) { try FileManager.default.moveItem(at:target,to:backup) }
        do { try FileManager.default.moveItem(at:stage,to:target); try? FileManager.default.removeItem(at:backup) } catch { if FileManager.default.fileExists(atPath:backup.path) { try? FileManager.default.moveItem(at:backup,to:target) }; throw error }; return pack
    }
    public func localPacks() -> [JSON] { ((try? FileManager.default.contentsOfDirectory(at:root.appendingPathComponent("collections"),includingPropertiesForKeys:nil)) ?? []).compactMap { try? DataModel.read($0.appendingPathComponent("manifest.json")) } }
    private func boundedExtract(_ archive:Archive, entry:Entry, to url:URL, cap:Int64) throws {
        try require(Int64(entry.uncompressedSize) <= cap,"Файл ZIP превышает предел размера"); try FileManager.default.createDirectory(at:url.deletingLastPathComponent(),withIntermediateDirectories:true)
        _ = FileManager.default.createFile(atPath:url.path,contents:nil); let handle = try FileHandle(forWritingTo:url); defer { try? handle.close() }; var size: Int64 = 0
        let crc = try archive.extract(entry) { data in size += Int64(data.count); try require(size <= cap && size <= Int64(entry.uncompressedSize),"Распакованный файл превышает заявленный размер"); try handle.write(contentsOf:data) }
        try require(size == Int64(entry.uncompressedSize) && crc == entry.checksum,"CRC или длина файла ZIP не совпадает")
    }
}
