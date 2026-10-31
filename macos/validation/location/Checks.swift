import Foundation
import CoreLocation
@MainActor final class Outcome { var value:JSON?, error:Error? }
actor DataGate {
    var waiting:CheckedContinuation<Data,Never>?
    func get() async -> Data { await withCheckedContinuation { waiting = $0 } }
    func entered() -> Bool { waiting != nil }
    func release() { waiting?.resume(returning:Data("{\"timezone\":\"Europe/Moscow\"}".utf8)); waiting = nil }
}
@main struct LocationChecks {
    @MainActor static func main() async throws {
        let payload = Data("{\"timezone\":\"Europe/Moscow\",\"latitude\":0,\"longitude\":0}".utf8)
        func expect(_ condition:Bool,_ message:String) throws { try require(condition,message) }
        func start(_ service:LocationService,_ result:Outcome) -> Task<Void,Never> { Task { @MainActor in do { result.value = try await service.locate() } catch { result.error = error } } }
        func waitForManager(after count:Int) async -> CLLocationManager { while CLLocationManager.created.count <= count { await Task.yield() }; return CLLocationManager.created.last! }
        let service = LocationService(); service.fetchData = { _ in payload }
        let a = Outcome(), n = CLLocationManager.created.count, first = start(service,a), manager = await waitForManager(after:n)
        manager.delegate!.locationManager(manager,didUpdateLocations:[CLLocation(latitude:55.12345,longitude:37.6789)])
        await first.value
        try expect(a.error == nil && a.value?.n("latitude") == 55.12345 && a.value?.n("longitude") == 37.6789 && a.value?.s("timezone") == "Europe/Moscow","Measured coordinates were replaced or lookup failed")
        try expect(manager.stopped && manager.delegate == nil,"Location manager did not stop")
        print("PASS location: value snapshots and original measured coordinates")

        let b = Outcome(), oldCount = CLLocationManager.created.count, obsolete = start(service,b), old = await waitForManager(after:oldCount), oldDelegate = old.delegate!
        service.cancel(); await obsolete.value; try expect(b.error is CancellationError,"Request cancellation failed")
        let c = Outcome(), newCount = CLLocationManager.created.count, latest = start(service,c), current = await waitForManager(after:newCount)
        oldDelegate.locationManager(old,didUpdateLocations:[CLLocation(latitude:10,longitude:20)])
        for _ in 0..<20 { await Task.yield() }
        try expect(c.value == nil && c.error == nil,"Obsolete delegate completed the new request")
        current.delegate!.locationManager(current,didUpdateLocations:[CLLocation(latitude:56,longitude:38)])
        await latest.value; try expect(c.value?.n("latitude") == 56,"New request received stale coordinates")
        print("PASS location: late callback cannot complete a newer request")

        let d = Outcome(), badCount = CLLocationManager.created.count, invalid = start(service,d), bad = await waitForManager(after:badCount)
        bad.delegate!.locationManager(bad,didUpdateLocations:[CLLocation(latitude:55,longitude:37,accuracy:100000)])
        await invalid.value; try expect(d.value == nil && d.error != nil,"Inaccurate fix accepted")
        let stale = Outcome(), staleCount = CLLocationManager.created.count, staleTask = start(service,stale), staleManager = await waitForManager(after:staleCount)
        staleManager.delegate!.locationManager(staleManager,didUpdateLocations:[CLLocation(latitude:55,longitude:37,timestamp:Date().addingTimeInterval(-3600))])
        await staleTask.value; try expect(stale.value == nil && stale.error != nil,"Stale fix accepted")
        print("PASS location: inaccurate and stale fixes rejected")

        CLLocationManager.authorization = .denied
        let denied = Outcome(), deniedTask = start(service,denied); await deniedTask.value
        try expect(denied.value == nil && denied.error != nil && CLLocationManager.created.last!.requests == 0,"Denied permission still requested location")
        CLLocationManager.authorization = .authorizedWhenInUse; CLLocationManager.services = false
        let disabled = Outcome(), disabledTask = start(service,disabled); await disabledTask.value
        try expect(disabled.value == nil && disabled.error != nil,"Disabled services accepted")
        CLLocationManager.services = true
        print("PASS location: denied permission and disabled services")

        let cancelled = Outcome(), cancelCount = CLLocationManager.created.count, cancelledTask = start(service,cancelled), cancelManager = await waitForManager(after:cancelCount)
        cancelledTask.cancel(); await cancelledTask.value
        try expect(cancelled.error is CancellationError && cancelManager.stopped,"Task cancellation did not stop manager")
        print("PASS location: task cancellation stops pending coordinates")

        let gate = DataGate(); service.fetchData = { _ in await gate.get() }
        let pending = Outcome(), pendingCount = CLLocationManager.created.count, pendingTask = start(service,pending), pendingManager = await waitForManager(after:pendingCount)
        pendingManager.delegate!.locationManager(pendingManager,didUpdateLocations:[CLLocation(latitude:55,longitude:37)])
        while !(await gate.entered()) { await Task.yield() }
        service.cancel(); await gate.release(); await pendingTask.value
        try expect(pending.value == nil && pending.error is CancellationError,"Cancelled timezone lookup applied stale result")
        print("PASS location: cancelled timezone response cannot apply")
        print("Location scenarios: 6 groups passed; strict Swift 6, warnings as errors")
    }
}
