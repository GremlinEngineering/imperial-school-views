import XCTest
@testable import ViewsCore

final class SettingsPresentationTests: XCTestCase {
    let collection: JSON = ["id":"sample", "type":"weather", "sources":[["id":"real"],["id":"game-world"]]]
    let city: JSON = ["name":"Old test city", "latitude":15.25, "longitude":23.75, "timezone":"Africa/Khartoum"]
    func testRetainedCityOnlyAppearsForLocalWeather() {
        let p = DataModel.profile(["mode":"weather","collection":"sample","weather_provider":"open-meteo","weather_city":city])
        for choice in ["real", "game-world", "open-meteo"] {
            let next = SettingsPresentation.settingCondition(choice,in:p)
            let ui = SettingsPresentation(profile:next,collection:collection)
            XCTAssertEqual(ui.showCity,choice == "open-meteo")
            XCTAssertEqual(ui.condition,choice)
            XCTAssertEqual(next.j("weather_city").s("name"),"Old test city")
            XCTAssertEqual(next.s("weather_provider"),choice == "open-meteo" ? "open-meteo" : "server")
            XCTAssertEqual(next.s("weather_source"),choice == "game-world" ? "game-world" : "real")
            XCTAssertEqual(ui.showDelivery,choice != "open-meteo")
        }
    }
    func testConditionChoicesAreDistinctAndRespectPublishedSources() {
        let p = DataModel.profile(["mode":"weather","collection":"sample"])
        let ui = SettingsPresentation(profile:p,collection:collection)
        XCTAssertEqual(ui.conditions.map(\.id),["real","game-world","open-meteo"])
        XCTAssertEqual(Set(ui.conditions.map(\.title)).count,3)
        let gameOnly: JSON = ["type":"weather","sources":[["id":"game-world"]]]
        XCTAssertEqual(SettingsPresentation(profile:p,collection:gameOnly).conditions.map(\.id),["game-world","open-meteo"])
        var daily = p; daily["collection"] = "__weather_day__"; daily["weather_provider"] = "server"
        let dailyUI = SettingsPresentation(profile:daily,collection:[:])
        XCTAssertEqual(dailyUI.conditions.map(\.id),["real","game-world"])
        XCTAssertFalse(dailyUI.showCity); XCTAssertFalse(dailyUI.showDelivery); XCTAssertFalse(dailyUI.showDownload)
        let dynamic = SettingsPresentation(profile:p,collection:["type":"dynamic"])
        XCTAssertTrue(dynamic.conditions.isEmpty); XCTAssertFalse(dynamic.showCity); XCTAssertFalse(dynamic.showDelivery); XCTAssertFalse(dynamic.showDownload)
    }
    func testSaverOptionsDependOnEnabledOwnAndSlideshow() {
        let p = DataModel.profile(["mode":"slideshow","collection":"sample"])
        for enabled in [false,true] { for own in [false,true] {
            let ui = SettingsPresentation(profile:p,collection:[:],saver:true,own:own,enabled:enabled)
            XCTAssertEqual(ui.showProfile,enabled && own)
            XCTAssertEqual(ui.showInterval,enabled && own)
        } }
        let weather = DataModel.profile(["mode":"weather","collection":"sample","weather_provider":"open-meteo","weather_city":city])
        let inherited = SettingsPresentation(profile:weather,collection:collection,saver:true,own:false)
        XCTAssertFalse(inherited.showCity); XCTAssertFalse(inherited.showCollection)
        XCTAssertFalse(SettingsPresentation(profile:weather,collection:collection,saver:true,own:true).showInterval)
        XCTAssertFalse(SettingsPresentation(profile:p,collection:[:]).showInterval)
    }
    func testSourcesAndSlideshowChoices() {
        let day = SettingsPresentation(profile:DataModel.profile(),collection:[:])
        XCTAssertFalse(day.showCollection); XCTAssertFalse(day.showCity); XCTAssertFalse(day.showDownload)
        let local = SettingsPresentation(profile:DataModel.profile(["mode":"daily","source":"local"]),collection:[:])
        XCTAssertTrue(local.showCollection); XCTAssertFalse(local.showDownload)
        let schedule: JSON = ["schedule":["monthly":["1":"a"],"seasonal":["winter":"b"]]]
        XCTAssertEqual(SettingsPresentation.modes(source:"online",collection:schedule,saver:false).map(\.id),["monthly","seasonal","daily"])
        XCTAssertEqual(SettingsPresentation.modes(source:"online",collection:schedule,saver:true).map(\.id),["monthly","seasonal","daily","slideshow"])
        XCTAssertEqual(SettingsPresentation.modes(source:"weather",collection:schedule,saver:true).map(\.id),["weather"])
    }
}
