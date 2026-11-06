package ru.oopssre.imperialschool.views

import org.json.JSONObject
import org.junit.Assert.*
import org.junit.Test
import org.junit.runner.RunWith
import org.robolectric.RobolectricTestRunner
import org.robolectric.RuntimeEnvironment
import org.robolectric.annotation.Config

@RunWith(RobolectricTestRunner::class)
@Config(sdk=[34])
class PhoneAvailabilityTest {
    private val portrait=ImageFile("files/phone.jpg",720,1560,100,"a".repeat(64))
    private val landscape=portrait.copy(url="files/desktop.jpg",width=1920,height=1080)
    private fun ordinary(id: String,phone: Boolean)=Catalogue(listOf(Collection(id,id,emptyMap())),listOf(Scene(id,id,id,"previews/image.jpg",listOf(if(phone)portrait else landscape))))
    private fun dynamic(phone: Boolean): Collection {
        val formats=JSONObject().put("desktop",JSONObject().put("width",1920).put("height",1080))
        if(phone)formats.put("phone",JSONObject().put("width",720).put("height",1560))
        return Collection("scene","Сцена",emptyMap(),dynamic=JSONObject().put("formats",formats))
    }
    @Test fun desktopOnlyCollectionsNeverEnterPhoneGalleryOrNotices(){
        val data=ordinary("desktop",false).let{it.copy(collections=it.collections+dynamic(false))}
        assertTrue(data.phoneCollections().isEmpty());assertTrue(CollectionNotices.added(data,emptySet()).isEmpty())
    }
    @Test fun addingPhoneFormatToAnExistingDynamicCollectionIsNewForThisClient(){
        val old=Catalogue(listOf(dynamic(false)),emptyList())
        val next=old.copy(collections=listOf(dynamic(true)))
        assertEquals(listOf("scene"),CollectionNotices.added(next,old.phoneCollections().map{it.id}.toSet()).map{it.id})
    }
    @Test fun addingPortraitImagesToAnExistingOrdinaryCollectionIsNew(){
        val old=ordinary("theme",false);val next=ordinary("theme",true)
        assertEquals(listOf("theme"),CollectionNotices.added(next,old.phoneCollections().map{it.id}.toSet()).map{it.id})
    }
    @Test fun weatherUsesTheSamePortraitPredicate(){
        val desktop=Collection("weather","Погода",emptyMap(),weather=JSONObject().put("formats",JSONObject().put("desktop",JSONObject().put("width",1920).put("height",1080))))
        val phone=desktop.copy(weather=JSONObject().put("formats",JSONObject().put("phone",JSONObject().put("width",720).put("height",1560))))
        assertFalse(Catalogue(listOf(desktop),emptyList()).availableOnPhone(desktop))
        assertTrue(Catalogue(listOf(phone),emptyList()).availableOnPhone(phone))
    }
    @Test fun migrationIsQuietThenNotifiesOnceEvenWhenTheOldRegistryKnewDesktopId(){
        val repo=Repository(RuntimeEnvironment.getApplication());repo.put("known_collections","theme")
        assertTrue(CollectionNotices.observe(repo,ordinary("theme",false)).isEmpty())
        assertEquals(listOf("theme"),CollectionNotices.observe(repo,ordinary("theme",true)).map{it.id})
        assertTrue(CollectionNotices.observe(repo,ordinary("theme",true)).isEmpty())
        CollectionNotices.observe(repo,ordinary("theme",false))
        assertTrue(CollectionNotices.observe(repo,ordinary("theme",true)).isEmpty())
    }
    @Test fun emptyInitialPhoneCatalogueIsStillAnInitializedBaseline(){
        val repo=Repository(RuntimeEnvironment.getApplication())
        CollectionNotices.observe(repo,Catalogue(emptyList(),emptyList()))
        assertEquals(1,CollectionNotices.observe(repo,ordinary("new",true)).size)
    }
    @Test fun firstEligibleCatalogueDoesNotProduceAnUpgradeNotificationStorm(){
        val repo=Repository(RuntimeEnvironment.getApplication())
        assertTrue(CollectionNotices.observe(repo,ordinary("existing",true)).isEmpty())
        assertTrue(CollectionNotices.observe(repo,ordinary("existing",true)).isEmpty())
    }
    @Test fun dailyRotationSkipsLandscapeOnlyScenesAndFeaturedDoesNotSilentlySubstitute(){
        val phone=ordinary("theme",true);val desktop=phone.scenes.first().copy(id="desktop",files=listOf(landscape))
        val data=phone.copy(scenes=phone.scenes+desktop,featured=desktop.id)
        for(day in 1..28)assertEquals("theme",data.choose("theme","daily",java.time.LocalDate.of(2026,11,day)).id)
        assertThrows(IllegalStateException::class.java){data.choose("theme","featured")}
    }
    @Test fun notificationPreferencesPersistWithoutApplyingOrReplacingWallpapers(){
        val repo=Repository(RuntimeEnvironment.getApplication());val saved=Selection(source="online",collection="theme",mode="daily",target="home")
        repo.save(saved);val before=repo.savedProfiles()
        repo.put("notify_collections_preference","0");repo.put("notify_app_preference","0")
        assertFalse(repo.settings("home").notifyCollections);assertFalse(repo.settings("home").notifyApp)
        assertEquals(before,repo.savedProfiles());assertEquals(saved.collection,repo.settings("home").collection)
    }
}
