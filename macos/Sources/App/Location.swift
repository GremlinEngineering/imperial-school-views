import Foundation
import CoreLocation

private struct LocationFix: Sendable {
    let latitude: Double, longitude: Double, accuracy: Double, timestamp: Date
}
private enum LocationEvent: Sendable {
    case authorization, fixes([LocationFix]), failure(String)
}

// CoreLocation's delegate protocol is nonisolated. This adapter owns no UI or
// request state and sends only immutable values to the main actor.
private final class LocationDelegate: NSObject, CLLocationManagerDelegate {
    private let send: @Sendable (LocationEvent) -> Void
    init(send: @escaping @Sendable (LocationEvent) -> Void) { self.send = send; super.init() }
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) { send(.authorization) }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        send(.fixes(locations.map { LocationFix(latitude:$0.coordinate.latitude,longitude:$0.coordinate.longitude,accuracy:$0.horizontalAccuracy,timestamp:$0.timestamp) }))
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) { send(.failure(error.localizedDescription)) }
}

@MainActor final class LocationService: NSObject {
    private var manager: CLLocationManager?, bridge: LocationDelegate?, activeRequest: UUID?
    private var pending: CheckedContinuation<LocationFix, Error>?, timeout: Task<Void,Never>?
    var fetchData: @Sendable (URL) async throws -> Data = { try await Network.data($0,limit:5_000_000) }
    func cancel() { activeRequest = nil; finishCoordinates(.failure(CancellationError())) }
    func locate() async throws -> JSON {
        try Task.checkCancellation()
        cancel(); let request = UUID(); activeRequest = request
        defer { if activeRequest == request { activeRequest = nil } }
        let fix: LocationFix = try await withTaskCancellationHandler(operation: {
          try await withCheckedThrowingContinuation { continuation in
            pending = continuation
            let adapter = LocationDelegate { [weak self] event in
                Task { @MainActor [weak self] in self?.receive(event,request:request) }
            }
            let native = CLLocationManager(); native.delegate = adapter; native.desiredAccuracy = kCLLocationAccuracyKilometer
            bridge = adapter; manager = native
            timeout = Task { [weak self] in
                do { try await Task.sleep(nanoseconds:25_000_000_000) } catch { return }
                guard let self, activeRequest == request else { return }
                finishCoordinates(.failure(ViewsError("Не удалось определить местоположение за 25 секунд")))
            }
            guard CLLocationManager.locationServicesEnabled() else { finishCoordinates(.failure(ViewsError("Геолокация отключена в настройках macOS"))); return }
            requestLocationIfAuthorized()
          }
        }, onCancel: { [weak self] in
            Task { @MainActor [weak self] in
                guard let self, self.activeRequest == request else { return }; self.cancel()
            }
        })
        try Task.checkCancellation(); guard activeRequest == request else { throw CancellationError() }
        var url = URLComponents(string:"https://api.open-meteo.com/v1/forecast")!
        url.queryItems = [URLQueryItem(name:"latitude",value:String(fix.latitude)),URLQueryItem(name:"longitude",value:String(fix.longitude)),URLQueryItem(name:"timezone",value:"auto"),URLQueryItem(name:"current",value:"weather_code"),URLQueryItem(name:"forecast_days",value:"1")]
        // Data is Sendable; parse the dictionary on the owning main actor.
        let data = try await fetchData(url.url!); try Task.checkCancellation()
        guard activeRequest == request else { throw CancellationError() }
        let response = try DataModel.object(data); try require(TimeZone(identifier:response.s("timezone")) != nil,"Сервис не определил часовой пояс")
        return ["latitude":fix.latitude,"longitude":fix.longitude,"accuracy":fix.accuracy,"measured_at":DataModel.stamp(fix.timestamp),"timezone":response.s("timezone"),"name":"Моё местоположение","provider":"core-location"]
    }
    private func requestLocationIfAuthorized() {
        guard pending != nil, let manager else { return }
        switch manager.authorizationStatus {
        case .denied, .restricted: finishCoordinates(.failure(ViewsError("Разрешите геолокацию для Imperial School Views в настройках macOS")))
        case .notDetermined: manager.requestWhenInUseAuthorization()
        default: manager.requestLocation()
        }
    }
    private func receive(_ event:LocationEvent, request:UUID) {
        guard activeRequest == request, pending != nil else { return }
        switch event {
        case .authorization: requestLocationIfAuthorized()
        case .failure(let message): finishCoordinates(.failure(ViewsError(message)))
        case .fixes(let locations):
            guard let fix = locations.filter({ $0.accuracy >= 0 && $0.accuracy <= 25000 && abs($0.timestamp.timeIntervalSinceNow) <= 600 && $0.latitude.isFinite && abs($0.latitude) <= 90 && $0.longitude.isFinite && abs($0.longitude) <= 180 }).min(by: { $0.accuracy < $1.accuracy }) else { finishCoordinates(.failure(ViewsError("Получены устаревшие или неточные координаты"))); return }
            finishCoordinates(.success(fix))
        }
    }
    private func finishCoordinates(_ result:Result<LocationFix,Error>) {
        manager?.stopUpdatingLocation(); manager?.delegate = nil; manager = nil; bridge = nil
        timeout?.cancel(); timeout = nil; let continuation = pending; pending = nil
        continuation?.resume(with:result)
    }
    static func search(_ query:String) async throws -> [JSON] {
        var url = URLComponents(string:"https://geocoding-api.open-meteo.com/v1/search")!
        url.queryItems = [URLQueryItem(name:"name",value:query),URLQueryItem(name:"count",value:"15"),URLQueryItem(name:"language",value:"ru"),URLQueryItem(name:"format",value:"json")]
        let data = try await Network.data(url.url!,limit:5_000_000)
        return try DataModel.object(data).rows("results").filter { TimeZone(identifier:$0.s("timezone")) != nil }
    }
}
