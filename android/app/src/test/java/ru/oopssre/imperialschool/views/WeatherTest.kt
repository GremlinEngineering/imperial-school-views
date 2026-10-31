package ru.oopssre.imperialschool.views

import org.json.JSONArray
import org.json.JSONObject
import org.junit.Assert.*
import org.junit.Test
import java.time.Instant

class WeatherTest {
    private val now=Instant.parse("2026-10-28T12:00:00Z").toEpochMilli()
    private fun stamp(n: Long)=Instant.ofEpochMilli(n).toString()
    private fun collection(): JSONObject {
        val source=JSONObject().put("id","game-world").put("current_url","weather/test-weather/sources/game-world/current.json").put("forecasts",JSONObject().put("phone","weather/test-weather/sources/game-world/forecast-phone.json"))
        return JSONObject().put("id","test-weather").put("type","weather").put("title","Test").put("formats",JSONObject().put("phone",JSONObject().put("width",1440).put("height",3120))).put("sources",JSONArray().put(source))
    }
    private fun file(hash: String)=JSONObject().put("url","collections/test-weather/files/"+(if(hash.startsWith("a"))"summer-day-clear" else "summer-night-clear")+"-phone.jpg").put("sha256",hash).put("bytes",1).put("width",1440).put("height",3120).put("format","jpeg").put("rendition","phone")
    private fun pair(): JSONObject {
        val p=JSONObject().put("schema",1).put("type","weather").put("collection_id","test-weather").put("source_id","game-world").put("world_id","ra-1").put("location_revision","r1").put("timezone","Europe/Moscow").put("status","ready").put("refresh_after",stamp(now-1000)).put("source",JSONObject().put("setting","Гавань").put("name","Мир").put("calendar",JSONObject().put("initial_season","winter")))
        fun row(from: Long,to: Long,hash: String,time: String)=JSONObject().put("valid_from",stamp(from)).put("valid_until",stamp(to)).put("status","ready").put("state_id","summer-"+time+"-clear").put("moon_phase","none").put("season","summer").put("time_of_day",time).put("weather","clear").put("world_date","2031-06-01").put("file",file(hash))
        val f=JSONObject(p.toString()).put("document_type","weather-forecast").put("contract_version","global-v1").put("package_version","opaque+v1").put("format","phone").put("generated_at",stamp(now-60000)).put("valid_until",stamp(now+10000)).put("intervals",JSONArray().put(row(now-1,now+1000,"a".repeat(64),"day")).put(row(now+1000,now+10000,"b".repeat(64),"night")))
        return JSONObject().put("current",p).put("forecast",f)
    }
    private fun selection()=Selection(source="weather",collection="test-weather",mode="weather",weatherSource="game-world")
    @Test fun serverTitleDoesNotExposeLocationName() {
        val p=pair();p.getJSONObject("current").put("source_id","real").put("location",JSONObject().put("name","Москва"))
        p.getJSONObject("forecast").put("source_id","real")
        assertEquals("Погода с сервера",Weather.resolve(p,collection(),selection().copy(weatherSource="real"),now).title)
    }
    @Test fun intervalBoundaryChangesFromCachedForecastWithoutNewData(){
        val c=collection();val data=pair();val day=Weather.resolve(data,c,selection(),now);val night=Weather.resolve(data,c,selection(),now+1000)
        assertEquals("day",day.row!!.getString("time_of_day"));assertEquals("night",night.row!!.getString("time_of_day"));assertEquals(now+1000,day.next)
        assertTrue(day.refresh<now);assertEquals("ready",night.status)
    }
    @Test fun worldCalendarComesFromIntervalAndRetainsItsYear(){
        val frame=Weather.resolve(pair(),collection(),selection(),now)
        assertEquals("summer",frame.row!!.getString("season"));assertEquals("Гавань",frame.title);assertTrue(Weather.details(frame).contains("1 июня 2031"))
    }
    @Test fun expiredForecastIsNeverExtended(){
        assertEquals("stale",Weather.resolve(pair(),collection(),selection(),now+10000).status)
    }
    @Test fun sameWorldWithNewRevisionRejectsOldForecast(){
        val data=pair();data.getJSONObject("current").put("location_revision","r2");assertEquals("stale",Weather.resolve(data,collection(),selection(),now).status)
    }
    @Test fun unknownStatusDoesNotSelectAnImage(){
        val data=pair();data.getJSONObject("current").put("status","new_unknown_status");assertEquals("not_ready",Weather.resolve(data,collection(),selection(),now).status)
    }
    @Test fun nullWorldAndAbsentWorldAreCompatible(){
        val data=pair();data.getJSONObject("current").put("world_id",JSONObject.NULL);data.getJSONObject("forecast").remove("world_id");assertEquals("ready",Weather.resolve(data,collection(),selection(),now).status)
    }
    @Test fun shortUnavailableDocumentDoesNotNeedNormalForecastFields(){
        val data=pair();val f=data.getJSONObject("forecast");f.put("status","unavailable");listOf("contract_version","timezone","generated_at","valid_until","refresh_after").forEach{f.remove(it)};f.put("intervals",JSONArray())
        assertEquals("unavailable",Weather.resolve(data,collection(),selection(),now).status)
    }
    @Test fun wrongFileResolutionIsRejected(){
        val bad=file("a".repeat(64)).put("height",2400)
        try{Weather.file(bad,collection(),"phone");fail("wrong dimensions accepted")}catch(expected: IllegalArgumentException){}
    }
    @Test fun packageVersionIsOpaqueAndMustMatch(){
        val c=collection();val v=file("a".repeat(64)).put("url","files/summer-day-clear-none-phone.jpg").put("state_id","summer-day-clear").put("moon_phase","none")
        val p=JSONObject().put("schema",3).put("document_type","weather-wallpaper-package").put("type","weather").put("id","test-weather").put("format","phone").put("version","opaque+v1").put("variants",JSONArray().put(v))
        assertEquals(1,Weather.packageManifest(p,c,"phone","opaque+v1").size)
        try{Weather.packageManifest(p,c,"phone","different");fail("wrong version accepted")}catch(expected: IllegalArgumentException){}
    }
    @Test fun weatherOnlyCatalogueUsesV3WithoutOrdinaryScenes(){
        val data=Catalogue.parse(JSONObject().put("schema",3).put("collections",JSONArray().put(collection())).put("items",JSONArray()))
        assertEquals(listOf("weather"),data.collections.single().modes())
    }
    @Test fun changedFeaturedWithinSameDateChangesThePhoneScene(){
        val c=JSONObject().put("id","ordinary").put("title","Ordinary").put("schedule",JSONObject())
        fun item(id: String)=JSONObject().put("id",id).put("collection","ordinary").put("title",id).put("preview","collections/ordinary/previews/"+id+".jpg").put("files",JSONArray().put(file("a".repeat(64)).put("url","collections/ordinary/files/"+id+".jpg")))
        val data=JSONObject().put("schema",3).put("collections",JSONArray().put(c)).put("items",JSONArray().put(item("one")).put(item("two"))).put("wallpaper_of_day",JSONObject().put("item_id","one"))
        assertEquals("one",Catalogue.parse(data).choose("","featured").id)
        data.getJSONObject("wallpaper_of_day").put("item_id","two");assertEquals("two",Catalogue.parse(data).choose("","featured").id)
    }
    @Test fun api17ContractCatalogueAndBothPhoneForecastsMatchTheContract(){
        val fixture=JSONObject(javaClass.classLoader!!.getResourceAsStream("api17-contract.json")!!.bufferedReader().use{it.readText()})
        val data=Catalogue.parse(fixture.getJSONObject("catalogue"));val c=data.collections.single{it.id==fixture.getString("collection_id")}.weather!!
        fixture.getJSONArray("pairs").objects().forEach{item->
            val selected=Selection(source="weather",collection=c.getString("id"),mode="weather",weatherSource=item.getString("source_id"))
            Weather.current(item.getJSONObject("current"),c,selected.weatherSource)
            val f=Weather.forecast(item.getJSONObject("forecast"),c,selected.weatherSource,"phone")
            val frame=Weather.resolve(item,c,selected,Weather.time(f.optString("generated_at"))+1)
            assertTrue(frame.status in listOf("ready","not_ready","stale","unavailable"))
        }
    }

    @Test fun api17RejectsHashPathsAndRequiresPerDeviceVersion(){
        val data=pair();val f=data.getJSONObject("forecast");f.getJSONArray("intervals").getJSONObject(0).getJSONObject("file").put("url","collections/test-weather/files/"+"a".repeat(64)+".jpg")
        assertThrows(IllegalArgumentException::class.java){Weather.forecast(f,collection(),"game-world","phone")}
        val missing=pair().getJSONObject("forecast");missing.remove("package_version");assertThrows(IllegalArgumentException::class.java){Weather.forecast(missing,collection(),"game-world","phone")}
    }
    @Test fun packageVersionIsIndependentFromGlobalContractAndMayBeNull(){
        val f=pair().getJSONObject("forecast");val first=Weather.packageVersion(f);f.put("contract_version","other-device-changed");assertEquals(first,Weather.packageVersion(f))
        f.put("package_version",JSONObject.NULL);Weather.forecast(f,collection(),"game-world","phone");assertNull(Weather.packageVersion(f))
    }
    @Test fun samePublicUrlWithNewHashUsesNewCacheKeyAndBypassesHttpCache(){
        val a=Weather.file(file("a".repeat(64)),collection(),"phone");val b=a.copy(sha256="b".repeat(64));assertEquals(a.url,b.url);assertNotEquals(a.sha256,b.sha256);assertTrue(Weather.imageURL(b).endsWith("?v="+b.sha256))
    }
    @Test fun networkCatalogueDoesNotAcceptOldSchemas(){val f=JSONObject().put("schema",2).put("collections",JSONArray().put(collection())).put("items",JSONArray());assertThrows(IllegalArgumentException::class.java){Catalogue.parse(f)}}
    @Test fun missingPhoneDoesNotInvalidateDesktopOnlyCollection(){
        val c=collection();c.getJSONObject("formats").remove("phone");c.getJSONObject("formats").put("macbook",JSONObject().put("width",3840).put("height",2400))
        c.getJSONArray("sources").getJSONObject(0).getJSONObject("forecasts").put("macbook","weather/test-weather/sources/game-world/forecast-macbook.json")
        Weather.validateCollection(c);assertTrue(Weather.formats(c).isEmpty())
    }
}
