package ru.oopssre.imperialschool.views

import org.json.JSONObject
import org.junit.Assert.*
import org.junit.Test
import org.junit.runner.RunWith
import org.robolectric.RobolectricTestRunner
import org.robolectric.RuntimeEnvironment
import org.robolectric.annotation.Config
import java.time.Instant
import java.io.IOException

@RunWith(RobolectricTestRunner::class)
@Config(sdk=[34])
class DailyWeatherTest {
    private val now=Instant.parse("2026-10-31T12:00:00Z").toEpochMilli()
    private fun stamp(n: Long)=Instant.ofEpochMilli(n).toString()
    private fun selected(source: String="real")=Selection(source="weather",collection=DailyWeather.ID,weatherSource=source,weatherDelivery="images",mode="weather",target="home")
    private fun current(source: String="real",id: String="test-weather",hash: String="a".repeat(64)): JSONObject {
        val f=JSONObject().put("url","collections/$id/files/autumn-day-clear-phone.jpg").put("format","jpeg").put("rendition","phone").put("width",640).put("height",1280).put("bytes",100).put("sha256",hash)
        return JSONObject().put("schema",1).put("document_type","weather-of-day").put("type","weather").put("source_id",source).put("selection_date","2026-10-31").put("status","ready")
            .put("collection_id",id).put("title","Тестовая коллекция").put("timezone","Europe/Moscow").put("location_revision","r1").put("world_id",JSONObject.NULL)
            .put("valid_from",stamp(now-60000)).put("valid_until",stamp(now+3600000)).put("refresh_after",stamp(now+3600000)).put("forecast_valid_until",stamp(now+7200000))
            .put("season","autumn").put("time_of_day","day").put("weather","clear").put("world_date","2031-10-31")
            .put("formats",JSONObject().put("phone",JSONObject().put("width",640).put("height",1280))).put("files",JSONObject().put("phone",f))
    }
    private fun saved(p: JSONObject)=JSONObject().put("checked_at",now).put("current",p)
    private fun repo()=Repository(RuntimeEnvironment.getApplication())
    @Test fun bothSourcesUseDailyCurrentWithoutCollectionSpecificForecast() {
        for(source in listOf("real","game-world")){
            val calls=mutableListOf<String>();val downloads=mutableListOf<ImageFile>();val s=selected(source)
            val frame=DailyWeather.refresh(repo(),s,true,load={calls.add(it);current(source)},fetch={f,_->downloads.add(f)},now=now)
            assertEquals(listOf("weather/daily/$source/current.json"),calls);assertEquals("ready",frame.status);assertEquals(1,downloads.size)
            assertEquals("collections/test-weather/files/autumn-day-clear-phone.jpg",downloads.single().url)
        }
    }
    @Test fun serverMayChangeCollectionDuringTheSameDay() {
        val r=repo();val s=selected()
        DailyWeather.refresh(r,s,true,load={current()},fetch={_,_->},now=now)
        val changed=DailyWeather.refresh(r,s,false,load={current(id="another-weather",hash="b".repeat(64))},fetch={_,_->},now=now+60000)
        assertEquals("another-weather",changed.row!!.getString("collection_id"));assertEquals("b".repeat(64),DailyWeather.image(changed).sha256)
    }
    @Test fun dailyPollIsBoundedToOneMinuteEvenWhenServerRefreshIsLater() {
        val r=repo();val s=selected();var calls=0
        DailyWeather.refresh(r,s,true,load={calls++;current()},fetch={_,_->},now=now)
        DailyWeather.refresh(r,s,false,load={calls++;current()},fetch={_,_->},now=now+59999)
        assertEquals(1,calls)
        DailyWeather.refresh(r,s,false,load={calls++;current()},fetch={_,_->},now=now+60000)
        assertEquals(2,calls)
    }
    @Test fun networkFailureLeavesPreviouslyValidatedDocumentIntact() {
        val r=repo();val s=selected();DailyWeather.refresh(r,s,true,load={current()},fetch={_,_->},now=now)
        val old=DailyWeather.cached(r,s)!!.toString()
        assertThrows(IOException::class.java){DailyWeather.refresh(r,s,true,load={throw IOException("offline")},fetch={_,_->},now=now+60000)}
        assertEquals(old,DailyWeather.cached(r,s)!!.toString());assertEquals("ready",DailyWeather.resolve(DailyWeather.cached(r,s),s,now+60000).status)
    }
    @Test fun expiredAndFutureIntervalsCannotBeApplied() {
        val p=current();assertEquals("stale",DailyWeather.resolve(saved(p),selected(),now+3600000).status)
        p.put("valid_from",stamp(now+1000));assertEquals("stale",DailyWeather.resolve(saved(p),selected(),now).status)
    }
    @Test fun forecastCoverageMayEndBeforeCurrentInterval() {
        val p=current().put("forecast_valid_until",stamp(now+1000))
        assertEquals(now+1000,DailyWeather.resolve(saved(p),selected(),now).next)
        assertEquals("stale",DailyWeather.resolve(saved(p),selected(),now+1000).status)
        p.put("forecast_valid_until",JSONObject.NULL);assertEquals("ready",DailyWeather.resolve(saved(p),selected(),now).status)
    }
    @Test fun missingPhoneCannotFallBackToDesktopOrAnotherCollection() {
        val p=current();p.getJSONObject("files").remove("phone")
        p.getJSONObject("formats").put("display",JSONObject().put("width",3840).put("height",2160))
        p.getJSONObject("files").put("display",JSONObject().put("url","collections/test-weather/files/autumn-day-clear-display.jpg").put("format","jpeg").put("rendition","display").put("width",3840).put("height",2160).put("bytes",100).put("sha256","c".repeat(64)))
        val frame=DailyWeather.resolve(saved(p),selected(),now)
        assertEquals("not_ready",frame.status);assertNull(frame.row);assertTrue(Weather.details(frame).contains("для телефона"))
    }
    @Test fun disabledAndNotReadyDocumentsNeedNoLocationOrFormats() {
        for(status in listOf("disabled","not_ready")){
            val p=JSONObject().put("schema",1).put("document_type","weather-of-day").put("type","weather").put("source_id","real").put("selection_date","2026-10-31").put("status",status).put("files",JSONObject())
            assertEquals(status,DailyWeather.resolve(saved(p),selected(),now).status)
        }
    }
    @Test fun sourceAndSafePathsAndDimensionsAreValidatedBeforeCaching() {
        assertThrows(IllegalArgumentException::class.java){DailyWeather.validate(current(),"game-world")}
        for((key,value) in listOf("url" to "https://evil.test/x.jpg","url" to "collections/another/files/autumn-day-clear-phone.jpg","width" to 1200,"sha256" to "bad")){
            val p=current();p.getJSONObject("files").getJSONObject("phone").put(key,value)
            assertThrows(IllegalArgumentException::class.java){DailyWeather.validate(p,"real")}
        }
    }
    @Test fun directImageAliasesAreOptionalAndNeverInvented() {
        val frame=DailyWeather.resolve(saved(current().put("delivery",JSONObject().put("direct_image",JSONObject().put("enabled",false)))),selected(),now)
        assertEquals("collections/test-weather/files/autumn-day-clear-phone.jpg",DailyWeather.image(frame).url)
        val p=current().put("image_url","weather/daily/game-world/current.jpg")
        assertThrows(IllegalArgumentException::class.java){DailyWeather.validate(p,"real")}
    }
    @Test fun realSourceNeverDisplaysServerLocationAndWorldDateIsPreserved() {
        val p=current().put("location",JSONObject().put("name","Москва"))
        val frame=DailyWeather.resolve(saved(p),selected(),now)
        assertFalse(frame.title.contains("Москва"));assertTrue(frame.title.contains("Погода с сервера"));assertTrue(Weather.details(frame).contains("2031"))
    }
    @Test fun sourcesHaveSeparateCachesAndCancelledFetchCannotPublish() {
        val r=repo();DailyWeather.refresh(r,selected(),true,load={current()},fetch={_,_->},now=now)
        DailyWeather.refresh(r,selected("game-world"),true,load={current("game-world",hash="b".repeat(64))},fetch={_,_->},now=now)
        assertEquals("a".repeat(64),DailyWeather.image(DailyWeather.resolve(DailyWeather.cached(r,selected()),selected(),now)).sha256)
        DailyWeather.refresh(r,selected(),true,{true},load={current(id="cancelled")},fetch={_,_->fail("cancelled transfer downloaded image")},now=now)
        assertEquals("test-weather",DailyWeather.cached(r,selected())!!.getJSONObject("current").getString("collection_id"))
    }
    @Test fun profilePersistsDailyModeAsImagesAndKeepsOtherScreen() {
        val r=repo();r.save(Selection(source="online",collection="ordinary",target="lock"));r.save(selected().copy(weatherDelivery="zip"))
        assertEquals("images",r.settings("home").weatherDelivery);assertEquals(DailyWeather.ID,r.settings("home").collection)
        assertEquals("ordinary",r.settings("lock").collection)
        assertThrows(IllegalArgumentException::class.java){r.save(selected("open-meteo"))}
    }
    @Test fun publishedDailyDocumentsUsePhoneAndOriginalFileUrls() {
        for(source in listOf("real","game-world")){
            val p=JSONObject(javaClass.getResource("/published-daily-$source.json")!!.readText())
            DailyWeather.validate(p,source)
            val start=Weather.time(p.getString("valid_from"))+1
            val frame=DailyWeather.resolve(JSONObject().put("checked_at",start).put("current",p),selected(source),start)
            assertEquals("ready",frame.status)
            assertEquals(p.getJSONObject("files").getJSONObject("phone").getString("url"),DailyWeather.image(frame).url)
            assertEquals(1440,DailyWeather.image(frame).width);assertEquals(3120,DailyWeather.image(frame).height)
        }
    }
}
