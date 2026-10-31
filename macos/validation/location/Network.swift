import Foundation
// No HTTP requests in these checks. LocationService.fetchData is injected.
@MainActor enum Network {
    static func data(_ url:URL,limit:Int64 = 5_000_000) async throws -> Data { throw ViewsError("Unexpected HTTP request") }
}
