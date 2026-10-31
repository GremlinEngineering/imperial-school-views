package ru.oopssre.imperialschool.views

import android.graphics.Bitmap
import org.json.JSONArray
import org.json.JSONObject
import org.junit.Assert.*
import org.junit.Test
import org.junit.runner.RunWith
import org.robolectric.RobolectricTestRunner
import org.robolectric.RuntimeEnvironment
import org.robolectric.annotation.Config
import java.io.ByteArrayOutputStream
import java.io.File
import java.time.Instant

@RunWith(RobolectricTestRunner::class)
@Config(sdk=[34])
class DynamicTest {
    private val repo get()=Repository(RuntimeEnvironment.getApplication())
    private val now=System.currentTimeMillis()
    private val s=Selection(source="dynamic",collection="test_theme",mode="dynamic",weatherSource="real",weatherDelivery="images")
    private fun collection()=JSONObject().put("id",s.collection).put("title","Тестовая динамическая тема").put("type","dynamic").put("current_url","dynamic/test_theme/current.json")
        .put("formats",JSONObject().put("phone_16x32",JSONObject().put("width",16).put("height",32)).put("desktop_32x16",JSONObject().put("width",32).put("height",16)))
    private fun jpeg(color: Int): ByteArray {val b=Bitmap.createBitmap(16,32,Bitmap.Config.ARGB_8888);b.eraseColor(color);return ByteArrayOutputStream().also{b.compress(Bitmap.CompressFormat.JPEG,90,it);b.recycle()}.toByteArray()}
    private fun sha(bytes: ByteArray)=java.security.MessageDigest.getInstance("SHA-256").digest(bytes).joinToString(""){"%02x".format(it)}
    private fun stamp(t: Long)=Instant.ofEpochMilli(t).toString()
    private fun state(bytes: ByteArray,id: String="a".repeat(64),version: String="0.2"): JSONObject {
        val input=JSONObject().put("schema_version",version).put("device","phone_16x32").put("at",stamp(now-1000)).put("active",JSONArray(listOf("season.autumn","time.night","weather.rain","moon.full_moon","game.record"))).put("derived",JSONObject().put("life_slot",13))
        val p=JSONObject().put("schema",1).put("type","dynamic-state").put("theme_id",s.collection).put("device","phone_16x32").put("at",stamp(now-1000)).put("valid_until",stamp(now+3600000)).put("id",id).put("inputs",input)
            .put("recipe",JSONObject().put("schema_version",version).put("theme_id",s.collection).put("device","phone_16x32").put("width",16).put("height",32).put("layers",JSONArray()))
            .put("image",JSONObject().put("url","dynamic/test_theme/devices/phone_16x32/current.jpg").put("width",16).put("height",32).put("format","jpg").put("bytes",bytes.size).put("sha256",sha(bytes)))
        if(version=="0.2")p.put("schema_version",version).put("life",JSONObject().put("timezone","Europe/Moscow").put("reason","stable_base"))
        return p
    }
    private fun top(p: JSONObject)=JSONObject().put("schema",1).put("type","dynamic").put("collection_id",s.collection).put("format_status",JSONObject().put("phone_16x32",JSONObject().put("status","ready")))
        .put("files",JSONObject().put("phone_16x32",p.getJSONObject("image"))).put("states",JSONObject().put("phone_16x32","dynamic/test_theme/devices/phone_16x32/current.json"))
    private fun refresh(p: JSONObject,bytes: ByteArray,force: Boolean=true,header: JSONObject=top(p))=Dynamic.refresh(repo,collection(),s,force,now,json={path->if(path==collection().getString("current_url"))header else p},fetch={_,path->Net.atomic(path,bytes)})
    private fun manifest(vararg collections: JSONObject)=JSONObject().put("schema",3).put("collections",JSONArray(collections.toList())).put("items",JSONArray())
    @Test fun dynamicOnlyCatalogueWithUnderscoreIdsAndNoOrdinaryItemsIsAccepted(){
        val data=Catalogue.parse(manifest(collection()));assertEquals("dynamic",data.collections.single().modes().single());assertNotNull(data.collections.single().dynamic)
    }
    @Test fun mixedCatalogueKeepsLegacyCollectionsAndDoesNotTreatDynamicAsAnOrdinaryZip(){
        val raw=JSONObject(javaClass.getResource("/published-catalogue.json")!!.readText());raw.getJSONArray("collections").put(collection())
        val parsed=Catalogue.parse(raw);assertTrue(parsed.collections.any{it.weather!=null});assertNull(CollectionArchive.find(parsed,s.collection));assertEquals(s.collection,Dynamic.collection(parsed,s).getString("id"))
    }
    @Test fun desktopOnlyDynamicThemeIsValidButCannotBorrowItsPictureForPhone(){
        val c=collection();c.getJSONObject("formats").remove("phone_16x32");Catalogue.parse(manifest(c));assertTrue(Dynamic.formats(c).isEmpty());assertThrows(IllegalArgumentException::class.java){Dynamic.device(c,s)}
    }
    @Test fun explicitlyRemovedDeviceIsNotSilentlyReplaced(){assertThrows(IllegalArgumentException::class.java){Dynamic.device(collection(),s.copy(weatherFormat="phone_old"))}}
    @Test fun downloadsOnlyCurrentJsonAndJpegAndCommitsVerifiedPair(){
        val bytes=jpeg(android.graphics.Color.RED);val p=state(bytes);val paths=mutableListOf<String>();var fetched=0
        assertTrue(Dynamic.refresh(repo,collection(),s,true,now,json={path->paths.add(path);if(path==collection().getString("current_url"))top(p) else p},fetch={f,path->fetched++;assertTrue(f.url.endsWith("current.jpg"));Net.atomic(path,bytes)}))
        assertEquals(2,paths.size);assertFalse(paths.any{it.contains("zip")});assertEquals(1,fetched);assertEquals(p.getString("id"),Dynamic.cached(repo,collection(),s)!!.getString("id"))
        assertTrue(validImage(Dynamic.path(repo,Dynamic.image(p,collection(),s)),Dynamic.image(p,collection(),s)))
    }
    @Test fun metadataChangeWithSameJpegDoesNotFetchImageAgain(){
        val bytes=jpeg(android.graphics.Color.RED);val p=state(bytes);refresh(p,bytes)
        val changed=state(bytes,"b".repeat(64)).also{it.getJSONObject("inputs").getJSONArray("active").put("game.new_game")}
        Dynamic.refresh(repo,collection(),s,true,now,json={if(it==collection().getString("current_url"))top(changed) else changed},fetch={_,_->fail("unchanged JPEG downloaded")})
        assertEquals(changed.getString("id"),Dynamic.cached(repo,collection(),s)!!.getString("id"));assertTrue(Dynamic.details(changed).contains("Новая игра"))
    }
    @Test fun intervalPreventsRepeatedRequestsUntilDue(){
        val bytes=jpeg(android.graphics.Color.RED);refresh(state(bytes),bytes)
        assertFalse(Dynamic.refresh(repo,collection(),s,false,now+100,json={error("request before due")},fetch={_,_->error("download before due")}))
    }
    @Test fun failedNewImagePreservesOldPairAndShowsError(){
        val old=jpeg(android.graphics.Color.RED);val p=state(old);refresh(p,old);val before=Dynamic.cached(repo,collection(),s)!!.toString();val next=state(jpeg(android.graphics.Color.BLUE),"b".repeat(64))
        assertThrows(java.io.IOException::class.java){Dynamic.refresh(repo,collection(),s,true,now,json={if(it==collection().getString("current_url"))top(next) else next},fetch={_,_->throw java.io.IOException("Нет сети")})}
        assertEquals(before,Dynamic.cached(repo,collection(),s)!!.toString());assertTrue(Dynamic.message(repo,collection(),s).contains("сети"))
    }
    @Test fun partiallyPublishedImageRetriesMetadataAndKeepsLastGoodPair(){
        val bytes=jpeg(android.graphics.Color.RED);val p=state(bytes);refresh(p,bytes);val next=state(jpeg(android.graphics.Color.BLUE),"b".repeat(64));var reads=0
        assertThrows(PublishedAssetChanged::class.java){Dynamic.refresh(repo,collection(),s,true,now,json={reads++;if(it==collection().getString("current_url"))top(p) else next},fetch={_,_->fail("mismatched publication fetched")})}
        assertEquals(4,reads);assertEquals(p.getString("id"),Dynamic.cached(repo,collection(),s)!!.getString("id"))
    }
    @Test fun publicationRaceCanRecoverOnBoundedSecondAttempt(){
        val bytes=jpeg(android.graphics.Color.RED);val p=state(bytes);var calls=0
        assertTrue(Dynamic.refresh(repo,collection(),s,true,now,json={if(it==collection().getString("current_url"))top(p) else p},fetch={_,path->calls++;if(calls==1)throw PublishedAssetChanged("Публикация меняется") else Net.atomic(path,bytes)}));assertEquals(2,calls)
    }
    @Test fun notReadyOrStalePhoneNeverUsesTheReadyDesktop(){
        val bytes=jpeg(android.graphics.Color.RED);val p=state(bytes);val header=top(p);header.getJSONObject("format_status").getJSONObject("phone_16x32").put("status","stale")
        assertThrows(IllegalArgumentException::class.java){refresh(p,bytes,header=header)};assertNull(Dynamic.cached(repo,collection(),s))
    }
    @Test fun staleOrFuturePublicationCannotReplaceCurrentPair(){
        val bytes=jpeg(android.graphics.Color.RED);val p=state(bytes);refresh(p,bytes)
        val stale=state(bytes,"b".repeat(64)).put("valid_until",stamp(now-1)).put("at",stamp(now-7200000)).also{it.getJSONObject("inputs").put("at",stamp(now-7200000))}
        assertThrows(IllegalArgumentException::class.java){refresh(stale,bytes)};assertEquals(p.getString("id"),Dynamic.cached(repo,collection(),s)!!.getString("id"))
        val future=state(bytes,"c".repeat(64)).put("at",stamp(now+120000)).also{it.getJSONObject("inputs").put("at",stamp(now+120000))}
        assertThrows(IllegalArgumentException::class.java){refresh(future,bytes)}
    }
    @Test fun crossThemeDeviceAndExternalStateUrlsAreRejected(){
        val bytes=jpeg(android.graphics.Color.RED);val p=state(bytes)
        assertThrows(IllegalArgumentException::class.java){Dynamic.state(JSONObject(p.toString()).put("theme_id","other"),collection(),s)}
        assertThrows(IllegalArgumentException::class.java){Dynamic.state(JSONObject(p.toString()).put("device","desktop_32x16"),collection(),s)}
        val header=top(p);header.getJSONObject("states").put("phone_16x32","https://example.com/current.json")
        assertThrows(IllegalArgumentException::class.java){refresh(p,bytes,header=header)}
    }
    @Test fun wrongImageHashIsNotCommitted(){val bytes=jpeg(android.graphics.Color.RED);val p=state(bytes);p.getJSONObject("image").put("sha256","b".repeat(64));assertThrows(IllegalArgumentException::class.java){refresh(p,bytes)};assertNull(Dynamic.cached(repo,collection(),s))}
    @Test fun supportsVersion01And02ButRejectsUnknownContractsAndInvalidLifeSlot(){
        val bytes=jpeg(android.graphics.Color.RED);Dynamic.state(state(bytes,version="0.1"),collection(),s)
        val bad=state(bytes);bad.getJSONObject("inputs").getJSONObject("derived").put("life_slot",1.5)
        assertThrows(IllegalArgumentException::class.java){Dynamic.state(bad,collection(),s)}
        assertThrows(IllegalArgumentException::class.java){Dynamic.state(state(bytes,version="0.3"),collection(),s)}
    }
    @Test fun viewerUsesCachedFramesAndDisplaysGameAndLifeConditions(){
        val bytes=jpeg(android.graphics.Color.RED);val p=state(bytes);refresh(p,bytes)
        Net.atomic(File(repo.root,"catalogue.json"),manifest(collection()).toString().toByteArray())
        val item=SavedWallpapers.load(repo,s).items.single();val label=item.conditions.single().label()
        assertTrue(label.contains("Дождь"));assertTrue(label.contains("Рекорд"));assertTrue(label.contains("час 13"));assertTrue(WallpaperFilter(season="autumn",moon="full_moon").accepts(item))
    }
    @Test fun retentionCapsRepeatedStatesEvenWhenTheirImageIsPinned(){
        val bytes=jpeg(android.graphics.Color.RED);val p=state(bytes);refresh(p,bytes);repo.put("hash_1",sha(bytes))
        for(i in 1..30){val row=state(bytes,"%064x".format(i));refresh(row,bytes);File(repo.root,"dynamic-history/"+row.getString("id")+".json").setLastModified(now-1000000+i*1000)}
        assertEquals(24,File(repo.root,"dynamic-history").listFiles()!!.size)
        assertTrue(Dynamic.path(repo,Dynamic.image(p,collection(),s)).isFile)
    }
    @Test fun retentionPreservesPinnedOldImageAndGraceProtectsAnInFlightFile(){
        val red=jpeg(android.graphics.Color.RED);refresh(state(red),red);repo.put("hash_1",sha(red))
        val oldOrphan=File(repo.root,"dynamic-images/"+"c".repeat(64)+".jpg").apply{writeBytes(red);setLastModified(System.currentTimeMillis()-600000)}
        val freshOrphan=File(repo.root,"dynamic-images/"+"d".repeat(64)+".jpg").apply{writeBytes(red)}
        val blue=jpeg(android.graphics.Color.BLUE)
        for(i in 1..25)refresh(state(blue,"%064x".format(i)),blue)
        assertFalse(oldOrphan.exists());assertTrue(freshOrphan.exists());assertTrue(File(repo.root,"dynamic-images/"+sha(red)+".jpg").isFile)
    }
    @Test fun byteLimitEvictsOldestUnpinnedImageAfterGraceAndMakesItRefreshable(){
        val red=java.util.Arrays.copyOf(jpeg(android.graphics.Color.RED),22000000)
        val blue=java.util.Arrays.copyOf(jpeg(android.graphics.Color.BLUE),22000000)
        val green=java.util.Arrays.copyOf(jpeg(android.graphics.Color.GREEN),22000000)
        val first=state(red,"a".repeat(64));refresh(first,red)
        val firstFile=Dynamic.path(repo,Dynamic.image(first,collection(),s));firstFile.setLastModified(System.currentTimeMillis()-600000)
        refresh(state(blue,"b".repeat(64)),blue);refresh(state(green,"c".repeat(64)),green)
        assertFalse(firstFile.exists());assertEquals(2,File(repo.root,"dynamic-history").listFiles()!!.size)
        assertTrue(File(repo.root,"dynamic-images").listFiles()!!.sumOf{it.length()}<=64000000)
        assertEquals("c".repeat(64),Dynamic.cached(repo,collection(),s)!!.getString("id"))
    }
    @Test fun pauseAndIndependentScreenSettingsAcceptDynamicSource(){
        repo.save(s.copy(target="home"));repo.save(Selection(source="online",collection="ordinary",mode="daily",target="lock"));repo.setPaused("home",true)
        assertEquals("dynamic",repo.settings("home").source);assertTrue(repo.settings("home").paused);assertEquals("online",repo.settings("lock").source);assertFalse(repo.settings("lock").paused)
    }
}
