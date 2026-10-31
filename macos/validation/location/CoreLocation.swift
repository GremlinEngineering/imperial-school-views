// Test-only CoreLocation protocol surface. This is not Apple's SDK.
import Foundation
public enum CLAuthorizationStatus: Sendable { case denied, restricted, notDetermined, authorizedAlways, authorizedWhenInUse }
public struct CLLocationCoordinate2D { public let latitude:Double, longitude:Double }
public final class CLLocation: NSObject {
    public let coordinate:CLLocationCoordinate2D, horizontalAccuracy:Double, timestamp:Date
    public init(latitude:Double,longitude:Double,accuracy:Double = 100,timestamp:Date = Date()) { coordinate = CLLocationCoordinate2D(latitude:latitude,longitude:longitude); horizontalAccuracy = accuracy; self.timestamp = timestamp }
}
public let kCLLocationAccuracyKilometer = 1000.0
public protocol CLLocationManagerDelegate: AnyObject {
    func locationManagerDidChangeAuthorization(_ manager:CLLocationManager)
    func locationManager(_ manager:CLLocationManager,didUpdateLocations:[CLLocation])
    func locationManager(_ manager:CLLocationManager,didFailWithError:Error)
}
@MainActor public final class CLLocationManager {
    public static var created:[CLLocationManager] = [], services = true, authorization:CLAuthorizationStatus = .authorizedWhenInUse
    public weak var delegate:(any CLLocationManagerDelegate)?
    public var desiredAccuracy = 0.0, stopped = false, requests = 0, prompts = 0
    public var authorizationStatus:CLAuthorizationStatus { Self.authorization }
    public init() { Self.created.append(self) }
    public static func locationServicesEnabled() -> Bool { services }
    public func requestWhenInUseAuthorization() { prompts += 1 }
    public func requestLocation() { requests += 1 }
    public func stopUpdatingLocation() { stopped = true }
}
