package ru.oopssre.imperialschool.views

import org.json.JSONObject
import org.json.JSONArray
import org.junit.Assert.*
import org.junit.Test
import java.io.File
import java.time.Instant

class LocalWeatherTest {
    private val engine=SharedWeatherScript(listOf("astronomy.js","weather-policy.js","open-meteo.js").map{File("src/main/assets/local-weather/"+it).readText()})
    private val now=Instant.parse("2026-10-30T12:00:00Z").toEpochMilli()
    private val city=JSONObject("""{"name":"Berlin","latitude":52.52,"longitude":13.4,"timezone":"Europe/Berlin"}""")
    private fun raw(): JSONObject=JSONObject().put("hourly",JSONObject().put("time",JSONArray((0..49).map{now/1000-3600+it*3600})).put("weather_code",JSONArray((0..49).map{0})))
    private fun provider()=JSONObject(engine.call("normalize",JSONObject().put("raw",raw()).put("city",city).put("now",now)))
    @Test fun astronomyMatchesMacAcrossZonesDstAndPolarDates() {
        val rows=JSONArray(javaClass.getResource("/local-astronomy-reference.json")!!.readText())
        for(i in 0 until rows.length()) {
            val row=rows.getJSONObject(i);val actual=JSONObject(engine.call("day",row));val expected=row.getJSONObject("expected")
            listOf("date","dawn","sunrise","sunset","dusk","moon_phase").forEach{k->assertEquals("${row.getString("date")} $k",expected.get(k),actual.get(k))}
            assertEquals(expected.getDouble("moon_value"),actual.getDouble("moon_value"),1e-10)
        }
    }
    @Test fun screenProfilesPreserveIndependentCities() {
        val home=Selection(source="weather",weatherSource="open-meteo",weatherCity=city.toString(),target="home")
        val lock=home.copy(target="lock",weatherCity=JSONObject(city.toString()).put("name","Other").put("longitude",20).toString())
        val p=Profiles().apply(home,"1").apply(lock,"2")
        assertEquals(home.weatherCity,Selection.parse(p.home!!.json()).weatherCity)
        assertEquals(lock.weatherCity,Selection.parse(p.lock!!.json()).weatherCity)
        assertFalse(p.linked)
        assertEquals("",Selection.parse(JSONObject()).weatherCity)
    }
    @Test fun searchValidatesCoordinatesAndDeduplicatesResults() {
        val results=JSONArray(engine.call("search",JSONObject().put("results",JSONArray().put(city).put(city).put(JSONObject(city.toString()).put("latitude",999)))))
        assertEquals(1,results.length())
    }
    @Test fun hourlyForecastRejectsHoles() {
        val r=raw();r.getJSONObject("hourly").getJSONArray("time").put(5,now/1000)
        assertThrows(Exception::class.java){engine.call("normalize",JSONObject().put("raw",r).put("city",city).put("now",now))}
    }
    @Test fun scheduleUsesArchiveAndSplitsAtSolarEvents() {
        val index=JSONObject()
        listOf("dawn","day","dusk","night").forEach{light->index.put("autumn-$light-clear|none",JSONObject().put("sha256",light))}
        val plan=JSONObject(engine.call("schedule",JSONObject().put("provider",provider()).put("city",city).put("index",index).put("now",now)))
        val rows=plan.getJSONArray("intervals");assertTrue(rows.length()>=4)
        for(i in 0 until rows.length()) {val r=rows.getJSONObject(i);assertEquals("ready",r.getString("status"));assertEquals("none",r.getString("moon_phase"));if(i>0)assertEquals(rows.getJSONObject(i-1).getString("valid_until"),r.getString("valid_from"))}
        val dawn=plan.getJSONObject("astronomy").getLong("sunset")
        assertTrue((0 until rows.length()).any{Instant.parse(rows.getJSONObject(it).getString("valid_from")).toEpochMilli()==dawn})
    }
    @Test fun lunarArchiveVariantsAndSevereThunderstormUseSharedPolicy() {
        val r=raw();val codes=r.getJSONObject("hourly").getJSONArray("weather_code")
        for(i in 0 until codes.length())codes.put(i,97)
        val p=JSONObject(engine.call("normalize",JSONObject().put("raw",r).put("city",city).put("now",now)))
        val phases=listOf("new_moon","waxing_crescent","first_quarter","waxing_gibbous","full_moon","waning_gibbous","last_quarter","waning_crescent")
        val index=JSONObject()
        listOf("dawn","day","dusk","night").forEach{light->phases.forEach{phase->index.put("autumn-$light-severe-thunderstorm|$phase",JSONObject().put("sha256",phase))}}
        val plan=JSONObject(engine.call("schedule",JSONObject().put("provider",p).put("city",city).put("index",index).put("now",now)))
        val rows=plan.getJSONArray("intervals")
        for(i in 0 until rows.length()) {val row=rows.getJSONObject(i);assertEquals("ready",row.getString("status"));assertTrue(row.getString("state_id").endsWith("severe-thunderstorm"));assertTrue(row.getString("moon_phase") in phases)}
    }
    @Test fun missingVariantsNeverSubstituteAnotherWeather() {
        val plan=JSONObject(engine.call("schedule",JSONObject().put("provider",provider()).put("city",city).put("index",JSONObject()).put("now",now)))
        assertEquals("not_ready",plan.getJSONArray("intervals").getJSONObject(0).getString("status"))
        assertThrows(Exception::class.java){engine.call("schedule",JSONObject().put("provider",provider()).put("city",city).put("index",JSONObject()).put("now",now+100*3600000))}
    }
}
