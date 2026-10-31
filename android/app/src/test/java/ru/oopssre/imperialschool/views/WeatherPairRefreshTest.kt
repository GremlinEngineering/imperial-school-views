package ru.oopssre.imperialschool.views

import org.json.JSONObject
import org.junit.Assert.*
import org.junit.Test
import org.junit.runner.RunWith
import org.robolectric.RobolectricTestRunner
import org.robolectric.RuntimeEnvironment
import org.robolectric.annotation.Config
import java.io.IOException

@RunWith(RobolectricTestRunner::class)
@Config(sdk=[34])
class WeatherPairRefreshTest {
    private fun fixture()=JSONObject(javaClass.getResource("/api17-contract.json")!!.readText())
    private fun context(): Triple<Repository,JSONObject,Selection> {
        val j=fixture();val c=Catalogue.parse(j.getJSONObject("catalogue")).collections.single{it.id==j.getString("collection_id")}.weather!!
        val p=j.getJSONArray("pairs").getJSONObject(0)
        val s=Selection(source="weather",collection=c.getString("id"),weatherSource=p.getJSONObject("current").getString("source_id"))
        val repo=Repository(RuntimeEnvironment.getApplication());repo.storePair(c,s,p.getJSONObject("current"),p.getJSONObject("forecast"))
        return Triple(repo,c,s)
    }
    @Test fun failedForecastKeepsTheCompleteCompatibleCachedPair() {
        val(r,c,s)=context();val old=r.weatherPair(c,s)!!;val fresh=JSONObject(old.getJSONObject("current").toString()).put("refresh_after","2099-01-01T00:00:00Z")
        assertThrows(IOException::class.java){r.refreshWeatherPair(c,s){path->if(path.contains("current.json"))fresh else throw IOException("offline")}}
        assertEquals(old.toString(),r.weatherPair(c,s)!!.toString())
    }
    @Test fun newLocationCannotReuseOldCoverageAfterForecastFailure() {
        val(r,c,s)=context();val p=JSONObject(r.weatherPair(c,s)!!.getJSONObject("current").toString()).put("location_revision","new-location")
        assertThrows(IOException::class.java){r.refreshWeatherPair(c,s){path->if(path.contains("current.json"))p else throw IOException("offline")}}
        val after=r.weatherPair(c,s)!!;assertEquals("unavailable",after.getJSONObject("forecast").getString("status"));assertEquals("new-location",after.getJSONObject("current").getString("location_revision"))
    }
    @Test fun incompatiblePublicationDoesNotReplaceThePreviousValidPair() {
        val(r,c,s)=context();val old=r.weatherPair(c,s)!!
        assertThrows(IllegalArgumentException::class.java){r.refreshWeatherPair(c,s){path->if(path.contains("current.json"))old.getJSONObject("current") else JSONObject(old.getJSONObject("forecast").toString()).put("location_revision","wrong")}}
        assertEquals(old.toString(),r.weatherPair(c,s)!!.toString())
    }
    @Test fun successfulRefreshPublishesBothDocumentsTogether() {
        val(r,c,s)=context();val old=r.weatherPair(c,s)!!
        val current=JSONObject(old.getJSONObject("current").toString()).put("location_revision","next")
        val forecast=JSONObject(old.getJSONObject("forecast").toString()).put("location_revision","next")
        r.refreshWeatherPair(c,s){path->if(path.contains("current.json"))current else forecast}
        val after=r.weatherPair(c,s)!!;assertTrue(Weather.identity(after.getJSONObject("current"),after.getJSONObject("forecast")));assertEquals("next",after.getJSONObject("forecast").getString("location_revision"))
    }
    @Test fun stoppedTransferCannotPublishNewCurrent() {
        val(r,c,s)=context();val old=r.weatherPair(c,s)!!
        assertNull(r.refreshWeatherPair(c,s,{true}){old.getJSONObject("current")})
        assertEquals(old.toString(),r.weatherPair(c,s)!!.toString())
    }
}
