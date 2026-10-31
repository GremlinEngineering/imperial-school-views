// Test adapters only. This does not validate AppKit, ImageIO or physical displays.
import Foundation
struct NSScreen { let number: UInt32 }
struct NSColor { static let black = NSColor() }
enum NSImageScaling: Int { case scaleProportionallyUpOrDown }
final class NSWorkspace {
    enum DesktopImageOptionKey { case imageScaling, allowClipping, fillColor }
    static let shared = NSWorkspace()
    var applications: [UInt32:URL] = [:], calls = 0
    func desktopImageURL(for screen:NSScreen) -> URL? { applications[screen.number] }
    func setDesktopImageURL(_ url:URL,for screen:NSScreen,options:[DesktopImageOptionKey:Any]) throws { applications[screen.number] = url; calls += 1 }
}
struct Display { var id:String, number:UInt32, title:String, width:Double, height:Double; var screen:NSScreen? { NSScreen(number:number) } }
@MainActor final class Displays { var values:[Display] = [], isRefreshing = false; var onChange:(()->Void)?, onWillChange:(()->Void)?; func refresh() {} }
enum LoginItem { static func migrate(root:URL) async {} }
class UNMutableNotificationContent { var title = "", body = "" }
struct UNNotificationRequest { init(identifier:String,content:UNMutableNotificationContent,trigger:Int?) {} }
class UNUserNotificationCenter { static func current() -> UNUserNotificationCenter { UNUserNotificationCenter() }; func add(_ request:UNNotificationRequest) {} }
