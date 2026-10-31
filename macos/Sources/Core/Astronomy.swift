// Adapted from Astral 3.2, Copyright Simon Kennedy, Apache-2.0.
// Same equations, local dates and centred moon sectors as the Android/server contract.
import Foundation

public struct City {
    public let name: String, latitude: Double, longitude: Double, zone: TimeZone
    public init(_ value: JSON) throws {
        guard let lat = value["latitude"] as? NSNumber, let lon = value["longitude"] as? NSNumber, abs(lat.doubleValue) <= 90, abs(lon.doubleValue) <= 180, let zone = TimeZone(identifier: value.s("timezone")) else { throw ViewsError("Неверные координаты или часовой пояс") }
        name = value.s("name", "Моё местоположение"); latitude = lat.doubleValue; longitude = lon.doubleValue; self.zone = zone
    }
}
public enum Astronomy {
    static func rad(_ x: Double) -> Double { x * .pi / 180 }
    static func deg(_ x: Double) -> Double { x * 180 / .pi }
    static func mod(_ x: Double, _ n: Double) -> Double { let r = x.truncatingRemainder(dividingBy: n); return r < 0 ? r + n : r }
    static var utc: Calendar { var c = Calendar(identifier: .gregorian); c.timeZone = TimeZone(secondsFromGMT: 0)!; return c }
    public static func key(_ date: Date, zone: TimeZone) -> String { var c = utc; c.timeZone = zone; let p = c.dateComponents([.year, .month, .day], from: date); return String(format: "%04d-%02d-%02d", p.year!, p.month!, p.day!) }
    public static func date(_ key: String) -> Date { let p = key.split(separator: "-").compactMap { Int($0) }; return utc.date(from: DateComponents(year: p[0], month: p[1], day: p[2]))! }
    static func add(_ key: String, _ n: Int) -> String { self.key(date(key).addingTimeInterval(Double(n) * 86400), zone: utc.timeZone) }
    public static func julian(_ date: Date) -> Double {
        let p = utc.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date); var y = Double(p.year!), m = Double(p.month!)
        if m <= 2 { y -= 1; m += 12 }; let a = (y / 100).rounded(.towardZero), b = 2 - a + (a / 4).rounded(.towardZero)
        let seconds = Double(p.hour! * 3600 + p.minute! * 60 + p.second!)
        return (365.25 * (y + 4716)).rounded(.towardZero) + (30.6001 * (m + 1)).rounded(.towardZero) + Double(p.day!) + seconds / 86400 + b - 1524.5
    }
    static func century(_ jd: Double) -> Double { (jd - 2451545) / 36525 }
    static func mean(_ t: Double) -> Double { mod(280.46646 + t * (36000.76983 + 0.0003032 * t), 360) }
    static func anomaly(_ t: Double) -> Double { 357.52911 + t * (35999.05029 - 0.0001537 * t) }
    static func eccentricity(_ t: Double) -> Double { 0.016708634 - t * (0.000042037 + 0.0000001267 * t) }
    static func apparent(_ t: Double) -> Double {
        let m = rad(anomaly(t)); let center = sin(m) * (1.914602 - t * (0.004817 + 0.000014 * t)) + sin(2 * m) * (0.019993 - 0.000101 * t) + sin(3 * m) * 0.000289
        return mean(t) + center - 0.00569 - 0.00478 * sin(rad(125.04 - 1934.136 * t))
    }
    static func obliquity(_ t: Double) -> Double { let seconds = 21.448 - t * (46.815 + t * (0.00059 - t * 0.001813)); return 23 + (26 + seconds / 60) / 60 + 0.00256 * cos(rad(125.04 - 1934.136 * t)) }
    static func declination(_ t: Double) -> Double { deg(asin(sin(rad(obliquity(t))) * sin(rad(apparent(t))))) }
    static func equation(_ t: Double) -> Double {
        let l = rad(mean(t)), e = eccentricity(t), m = rad(anomaly(t)), y = pow(tan(rad(obliquity(t)) / 2), 2)
        return deg(y * sin(2 * l) - 2 * e * sin(m) + 4 * e * y * sin(m) * cos(2 * l) - 0.5 * y * y * sin(4 * l) - 1.25 * e * e * sin(2 * m)) * 4
    }
    static func refraction(_ zenith: Double) -> Double {
        let e = 90 - zenith; if e >= 85 { return 0 }; let t = tan(rad(e)); let correction: Double
        if e > 5 { correction = 58.1 / t - 0.07 / pow(t, 3) + 0.000086 / pow(t, 5) }
        else if e > -0.575 { correction = 1735 + e * (-518.2 + e * (103.4 + e * (-12.79 + e * 0.711))) }
        else { correction = -20.774 / t }; return correction / 3600
    }
    static func transit(_ key: String, city: City, zenith: Double, setting: Bool) -> Date? {
        let jd = julian(date(key)), lat = rad(min(89.8, max(-89.8, city.latitude))), ref = refraction(zenith); var adjustment = 0.0, minutes = 0.0
        for _ in 0..<2 {
            let t = century(jd + adjustment), dec = rad(declination(t)), h = (cos(rad(zenith + ref)) - sin(lat) * sin(dec)) / (cos(lat) * cos(dec))
            if h < -1 || h > 1 { return nil }; let hour = acos(h) * (setting ? -1 : 1); var offset = (-city.longitude - deg(hour)) * 4 - equation(t)
            if offset < -720 { offset += 1440 }; minutes = 720 + offset; adjustment = minutes / 1440
        }
        // Astral truncates components then stamp() drops microseconds, including negative values.
        return date(key).addingTimeInterval(floor(minutes * 60))
    }
    static func event(_ key: String, city: City, zenith: Double, setting: Bool) -> Date? {
        guard var t = transit(key, city: city, zenith: zenith, setting: setting) else { return nil }; let local = self.key(t, zone: city.zone)
        if local != key { guard let next = transit(add(key, local < key ? 1 : -1), city: city, zenith: zenith, setting: setting), self.key(next, zone: city.zone) == key else { return nil }; t = next }; return t
    }
    public static func moon(_ key: String) -> String {
        let jd = julian(date(key)), dt = pow(jd - 2382148, 2) / (41048480 * 86400), t = (jd + dt - 2451545) / 36525, t2 = t * t, t3 = t2 * t
        let d = rad(mod(297.85 + 445267.1115 * t - 0.0016300 * t2 + t3 / 545868, 360)), m = rad(mod(357.53 + 35999.0503 * t, 360)), m1 = rad(mod(134.96 + 477198.8676 * t + 0.0089970 * t2 + t3 / 69699, 360))
        let elong = deg(d) + 6.29 * sin(m1) - 2.10 * sin(m) + 1.27 * sin(2 * d - m1) + 0.66 * sin(2 * d)
        var phase = (mod(elong, 360).rounded(.towardZero) + 6.43) / 360 * 28; if phase >= 28 { phase -= 28 }; return DataModel.phases[Int(floor((phase + 1.75) / 3.5)) % 8]
    }
    public static func events(_ key: String, city: City) -> [String: Date] {
        var result: [String: Date] = [:]
        for (name, zenith, setting) in [("dawn", 96.0, false), ("sunrise", 90 + 32.0 / 120, false), ("sunset", 90 + 32.0 / 120, true), ("dusk", 96.0, true)] { result[name] = event(key, city: city, zenith: zenith, setting: setting) }; return result
    }
    static func elevation(_ date: Date, city: City) -> Double {
        let p = utc.dateComponents([.hour, .minute, .second], from: date), t = century(julian(date)), dec = rad(declination(t)), lat = rad(min(89.8, max(-89.8, city.latitude)))
        var solar = Double(p.hour! * 60 + p.minute!) + Double(p.second!) / 60 + equation(t) + 4 * city.longitude
        while solar > 1440 { solar -= 1440 }; var hour = solar / 4 - 180; if hour < -180 { hour += 360 }
        let cosine = min(1, max(-1, cos(lat) * cos(dec) * cos(rad(hour)) + sin(lat) * sin(dec))), zenith = deg(acos(cosine)); return 90 - zenith + refraction(zenith)
    }
    public static func light(_ date: Date, city: City) -> String {
        let e = events(key(date, zone: city.zone), city: city)
        for (a, b, name) in [("dawn", "sunrise", "dawn"), ("sunrise", "sunset", "day"), ("sunset", "dusk", "dusk")] { if let from = e[a], let until = e[b], from <= date, date < until { return name } }
        if e.count == 4 { return "night" }; let h = elevation(date, city: city); return h >= -0.833 ? "day" : h < -6 ? "night" : elevation(date.addingTimeInterval(30), city: city) > h ? "dawn" : "dusk"
    }
    public static func midnight(_ key: String, zone: TimeZone) -> Date? {
        let mid = Int(date(key).timeIntervalSince1970); var lo = mid - 172800, hi = mid + 172800
        while lo < hi { let m = (lo + hi) / 2; if self.key(Date(timeIntervalSince1970: Double(m)), zone: zone) < key { lo = m + 1 } else { hi = m } }; let result = Date(timeIntervalSince1970: Double(lo)); return self.key(result, zone: zone) == key ? result : nil
    }
}

public enum LocalWeather {
    public static let mapping: [Int: String] = [0:"clear",1:"partly-cloudy",2:"partly-cloudy",3:"overcast",45:"fog",48:"fog",51:"drizzle",53:"drizzle",55:"drizzle",61:"rain",63:"rain",80:"rain",81:"rain",65:"heavy-rain",82:"heavy-rain",56:"freezing-precipitation",57:"freezing-precipitation",66:"freezing-precipitation",67:"freezing-precipitation",71:"snow",73:"snow",77:"snow",85:"snow",75:"heavy-snow",86:"heavy-snow",95:"thunderstorm",97:"severe-thunderstorm",96:"thunderstorm-hail",99:"thunderstorm-hail"]
    public static func schedule(_ response: JSON, city: City, variants: [JSON], now: Date) throws -> JSON {
        let hourly = response.j("hourly"), times = hourly["time"] as? [Double] ?? [], codes = hourly["weather_code"] as? [Int] ?? []
        try require(times.count == codes.count && times.count > 1, "Open-Meteo не прислал почасовую погоду")
        let end = now.addingTimeInterval(86400); var points = Set(times.filter { $0 > now.timeIntervalSince1970 && $0 < end.timeIntervalSince1970 }); points.insert(now.timeIntervalSince1970); points.insert(end.timeIntervalSince1970)
        let first = Astronomy.key(now, zone: city.zone)
        for d in 0...2 { let key = Astronomy.key(Astronomy.date(first).addingTimeInterval(Double(d) * 86400), zone: TimeZone(secondsFromGMT: 0)!); if let m = Astronomy.midnight(key, zone: city.zone), now < m, m < end { points.insert(m.timeIntervalSince1970) }; for t in Astronomy.events(key, city: city).values where now < t && t < end { points.insert(t.timeIntervalSince1970) } }
        let sorted = points.sorted(); var rows: [JSON] = []
        for i in 0..<(sorted.count - 1) {
            let from = Date(timeIntervalSince1970: sorted[i]), until = Date(timeIntervalSince1970: sorted[i+1]); guard let hour = times.lastIndex(where: { $0 <= sorted[i] }), sorted[i] < times[hour] + 3600, let weather = mapping[codes[hour]] else { continue }
            let key = Astronomy.key(from, zone: city.zone), month = Int(key.split(separator: "-")[1])!, season = DataModel.season(month), light = Astronomy.light(from, city: city), state = "\(season)-\(light)-\(weather)", phase = Astronomy.moon(key)
            let candidates = variants.filter { $0.s("state_id") == state }; let v = candidates.first { $0.s("moon_phase") == "none" } ?? candidates.first { $0.s("moon_phase") == phase }
            var row: JSON = ["valid_from":DataModel.stamp(from),"valid_until":DataModel.stamp(until),"state_id":state,"season":season,"time_of_day":light,"weather":weather,"moon_phase":v?.s("moon_phase") ?? phase,"status":v == nil ? "not_ready" : "ready"]
            if let v { row["file"] = v }; rows.append(row)
        }
        return ["valid_until":DataModel.stamp(end),"intervals":rows,"timezone":city.zone.identifier,"source_id":"open-meteo"]
    }
}
