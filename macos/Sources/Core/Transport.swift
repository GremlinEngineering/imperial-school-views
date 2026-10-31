import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif
import ViewsNative

public struct HTTPResult { public let data: Data; public let response: HTTPURLResponse }
private final class Transfer: NSObject, URLSessionDataDelegate, @unchecked Sendable {
    let request: URLRequest, limit: Int64, destination: URL?, progress: ((Int64, Int64) -> Void)?
    var session: URLSession?, continuation: CheckedContinuation<HTTPResult, Error>?, response: HTTPURLResponse?, handle: FileHandle?, buffer = Data(), received: Int64 = 0
    let lock = NSLock(); var cancelled = false
    var lastProgress = Date.distantPast; var writeError: Error?
    init(_ request: URLRequest, limit: Int64, destination: URL?, progress: ((Int64, Int64) -> Void)?) { self.request = request; self.limit = limit; self.destination = destination; self.progress = progress }
    func run() async throws -> HTTPResult {
        try await withTaskCancellationHandler(operation: {
            try await withCheckedThrowingContinuation { c in
                lock.lock(); defer { lock.unlock() }; if cancelled { c.resume(throwing: CancellationError()); return }; continuation = c
                do { if let destination { try FileManager.default.createDirectory(at: destination.deletingLastPathComponent(), withIntermediateDirectories: true); _ = FileManager.default.createFile(atPath: destination.path, contents: nil); handle = try FileHandle(forWritingTo: destination) } }
                catch { continuation = nil; c.resume(throwing: error); return }
                let config = URLSessionConfiguration.ephemeral; config.timeoutIntervalForRequest = 35; config.timeoutIntervalForResource = destination == nil ? 90 : 7200; config.urlCache = nil
                let queue = OperationQueue(); queue.maxConcurrentOperationCount = 1
                session = URLSession(configuration: config, delegate: self, delegateQueue: queue); session!.dataTask(with: request).resume()
            }
        }, onCancel: { self.lock.lock(); self.cancelled = true; let session = self.session; self.lock.unlock(); session?.invalidateAndCancel() })
    }
    func urlSession(_ session: URLSession, task: URLSessionTask, willPerformHTTPRedirection response: HTTPURLResponse, newRequest: URLRequest, completionHandler: @escaping (URLRequest?) -> Void) {
        guard let original = request.url, let next = newRequest.url, next.scheme == "https", next.host == original.host, next.port == original.port else { completionHandler(nil); return }; completionHandler(newRequest)
    }
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse, completionHandler: @escaping (URLSession.ResponseDisposition) -> Void) {
        guard let http = response as? HTTPURLResponse, (200..<300).contains(http.statusCode), response.expectedContentLength <= limit else { writeError = ViewsError("Сервер вернул HTTP \((response as? HTTPURLResponse)?.statusCode ?? 0) или превышен предел размера"); completionHandler(.cancel); return }; self.response = http; completionHandler(.allow)
    }
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        received += Int64(data.count); guard received <= limit else { writeError = ViewsError("Ответ сервера превышает предел размера"); dataTask.cancel(); return }
        do { if let handle { try handle.write(contentsOf: data) } else { buffer.append(data) }; if Date().timeIntervalSince(lastProgress) >= 0.25 { lastProgress = Date(); progress?(received, response?.expectedContentLength ?? -1) } } catch { writeError = error; dataTask.cancel() }
    }
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        do { try handle?.synchronize(); try handle?.close() } catch { writeError = error }; handle = nil
        lock.lock(); let c = continuation; continuation = nil; let cancelled = self.cancelled; self.session = nil; lock.unlock()
        if cancelled || writeError != nil || error != nil { if let destination { try? FileManager.default.removeItem(at: destination) }; c?.resume(throwing: cancelled ? CancellationError() : (writeError ?? error!)) }
        else if let response, received <= limit { c?.resume(returning: HTTPResult(data: buffer, response: response)) }
        else { if let destination { try? FileManager.default.removeItem(at: destination) }; c?.resume(throwing: ViewsError("Ответ сервера отклонён или превышен предел размера")) }
        session.finishTasksAndInvalidate()
    }
}
public enum Network {
    public static func request(_ url: URL) -> URLRequest { var r = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 35); r.setValue("ImperialSchoolViews/" + DataModel.version + " (macOS; Swift)", forHTTPHeaderField: "User-Agent"); return r }
    public static func data(_ url: URL, limit: Int64 = 100_000_000) async throws -> Data { try Task.checkCancellation(); return try await Transfer(request(url), limit: limit, destination: nil, progress: nil).run().data }
    public static func json(_ url: URL) async throws -> JSON {
        try Task.checkCancellation()
        let r = try await Transfer(request(url), limit: 5_000_000, destination: nil, progress: nil).run()
        try Task.checkCancellation()
        return try decodeJSON(r.data, encoding: r.response.value(forHTTPHeaderField: "Content-Encoding") ?? "", sidecar: url.path.hasSuffix(".json.br"))
    }
    public static func decodeJSON(_ data: Data, encoding: String, sidecar: Bool) throws -> JSON {
        try require(!data.isEmpty && data.count <= 5_000_000, "Превышен предел JSON")
        // URLSession may already have decoded Content-Encoding. Parse before decoding;
        // a .json.br without HTTP encoding still needs our bounded native decoder.
        if let parsed = try? DataModel.object(data) { return parsed }
        var encodings = [encoding]; if sidecar && !encoding.isEmpty { encodings.append("") }
        for encoding in encodings {
            var out: UnsafeMutablePointer<UInt8>?, count = 0
            let ok = data.withUnsafeBytes { p in ISVDecode(p.bindMemory(to: UInt8.self).baseAddress, data.count, encoding, sidecar ? 1 : 0, 5_000_000, &out, &count) }
            if ok != 0, let out { let decoded = Data(bytes: out, count: count); ISVFree(out); if let parsed = try? DataModel.object(decoded) { return parsed } }
        }; throw ViewsError("Повреждённый JSON или неподдерживаемое сжатие")
    }
    public static func download(_ url: URL, to destination: URL, progress: ((Int64, Int64) -> Void)? = nil) async throws {
        _ = try await Transfer(request(url), limit: 8 * 1024 * 1024 * 1024, destination: destination, progress: progress).run(); try Task.checkCancellation()
    }
}
