package ru.oopssre.imperialschool.views

import org.json.JSONArray
import org.json.JSONObject
import org.junit.Assert.*
import org.junit.Test

class WeatherCacheTest {
    private fun receipt(format: String,version: String,date: String,vararg images: String)=JSONObject().put("id","art").put("format",format).put("version",version).put("installed_at",date).put("variants",JSONArray(images.map{JSONObject().put("sha256",it)}))
    @Test fun cleanupPreservesBothScreensSharedImagesAndLatestOtherDevice(){
        val receipts=mapOf("old" to receipt("phone","v1","2026-10-28T10:00:00Z","old","shared"),"new" to receipt("phone","v2","2026-10-28T11:00:00Z","new","shared"),"mac" to receipt("macbook","m1","2026-10-28T10:00:00Z","mac"))
        val plan=WeatherCache.plan(receipts,emptySet(),setOf("current-home","current-lock"))
        assertEquals(setOf("new","mac"),plan.receipts);assertTrue(plan.images.containsAll(listOf("new","shared","mac","current-home","current-lock")));assertFalse(plan.images.contains("old"))
        val pinned=WeatherCache.plan(receipts,setOf("art/phone/v1"),emptySet());assertEquals(setOf("old","new","mac"),pinned.receipts)
    }
    @Test fun noVerifiedReceiptCannotRemovePinnedCurrentWallpaper(){val p=WeatherCache.plan(emptyMap(),emptySet(),setOf("current"));assertEquals(setOf("current"),p.images)}
}
