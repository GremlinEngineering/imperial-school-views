package ru.oopssre.imperialschool.views

import org.json.JSONObject
import org.json.JSONArray
import org.junit.Assert.*
import org.junit.Test
import java.time.LocalDate

class CatalogueTest {
    private fun pack(id: String="monthly"): JSONObject {
        val items=JSONArray();val schedule=JSONObject()
        (1..12).forEach { m ->
            val file=JSONObject().put("url","files/month-$m.jpg").put("width",1440).put("height",3120).put("bytes",100).put("sha256","a".repeat(64))
            items.put(JSONObject().put("id","month-$m").put("title","Месяц $m").put("preview","previews/month-$m.jpg").put("files",JSONArray().put(file)))
            schedule.put(m.toString(),"month-$m")
        }
        return JSONObject().put("schema",1).put("id",id).put("title",id).put("schedule",JSONObject().put("monthly",schedule)).put("items",items)
    }
    @Test fun twentyIndependentPacksAndAllMonths() {
        val data=Catalogue.compose((1..20).map{pack("year-$it")})!!
        assertEquals(20,data.collections.size);assertEquals(240,data.scenes.size)
        (1..12).forEach { m->assertEquals("year-17--month-$m",data.choose("year-17","monthly",LocalDate.of(2026,m,1)).id) }
        assertEquals(1440,data.choose("year-1","monthly").phone().width)
    }
    @Test fun dailyUsesLocalCalendarAndOnlySelectedCollection() {
        val data=Catalogue.compose(listOf(pack("first"),pack("second")))!!
        val first=data.choose("second","daily",LocalDate.of(2026,10,27));val next=data.choose("second","daily",LocalDate.of(2026,10,28))
        assertTrue(first.id.startsWith("second--"));assertNotEquals(first.id,next.id)
    }
    @Test fun seasonsIncludeDecemberAndJanuaryInWinter() {
        val scenes=listOf("winter","spring","summer","autumn").map{Scene(it,"seasonal",it,"previews/$it.jpg",listOf(ImageFile("files/$it.jpg",1440,3120,100,"a".repeat(64))))}
        val data=Catalogue(listOf(Collection("seasonal","Сезоны",mapOf("seasonal" to scenes.associate{it.id to it.id}))),scenes)
        mapOf(1 to "winter",3 to "spring",6 to "summer",9 to "autumn",12 to "winter").forEach{(m,s)->assertEquals(s,data.choose("seasonal","seasonal",LocalDate.of(2026,m,1)).id)}
    }
    @Test fun featuredCanBelongToAnotherCollectionAndRetainsPhoneImage() {
        val source=Catalogue.compose(listOf(pack("first"),pack("second")))!!
        val data=source.copy(featured="second--month-12")
        assertEquals("second--month-12",data.choose("first","featured").id);assertEquals(3120,data.choose("first","featured").phone().height)
    }
    @Test fun disabledPackDoesNotEnterCatalogue() { assertNull(Catalogue.compose(listOf(pack().put("enabled",false)))) }
    @Test fun rejectsCrossCollectionSchedulesAndTraversal() {
        val wrong=pack();wrong.getJSONObject("schedule").getJSONObject("monthly").put("12","missing")
        assertThrows(IllegalArgumentException::class.java){Catalogue.compose(listOf(wrong))}
        val unsafe=pack();unsafe.getJSONArray("items").getJSONObject(0).getJSONArray("files").getJSONObject(0).put("url","files/../../private.jpg")
        assertThrows(IllegalArgumentException::class.java){Catalogue.compose(listOf(unsafe))}
    }
    @Test fun refusesLandscapeInsteadOfStretchingItIntoPhoneWallpaper() {
        val scene=Scene("id","pack","Вид","previews/id.jpg",listOf(ImageFile("files/id.jpg",3840,2160,100,"a".repeat(64))))
        assertThrows(IllegalStateException::class.java){scene.phone()}
    }
    @Test fun readsTheExistingMonthlyArchiveManifest() {
        val json=javaClass.getResourceAsStream("/monthly.json")!!.bufferedReader().use{JSONObject(it.readText())}
        val data=Catalogue.compose(listOf(json))!!
        (1..12).forEach { m->val image=data.choose(json.getString("id"),"monthly",LocalDate.of(2026,m,1)).phone();assertTrue(image.height>image.width) }
    }
    @Test fun readsThePublishedSiteCatalogueAndPhoneVersionOfFeaturedScene() {
        val json=javaClass.getResourceAsStream("/site.json")!!.bufferedReader().use{JSONObject(it.readText())}
        val data=Catalogue.parse(json)
        assertTrue(data.collections.size>1)
        data.collections.forEach { c->c.modes().forEach { m->assertTrue(data.choose(c.id,m).phone().height>data.choose(c.id,m).phone().width) } }
        if(data.featured!=null)assertEquals(data.featured,data.choose(data.collections.first().id,"featured").id)
    }
}
