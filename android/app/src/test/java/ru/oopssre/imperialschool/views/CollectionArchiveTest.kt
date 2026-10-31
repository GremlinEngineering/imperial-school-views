package ru.oopssre.imperialschool.views

import org.json.JSONObject
import org.junit.Assert.*
import org.junit.Test

class CollectionArchiveTest {
    private val row=JSONObject().put("id","collection-seasonal").put("url","downloads/imperial-school-seasonal.zip").put("bytes",37518248).put("sha256","a".repeat(64))
    private fun data(download: JSONObject=row)=Catalogue(listOf(Collection("seasonal","Четыре сезона",emptyMap())),emptyList(),downloads=listOf(download))
    @Test fun publishedLegacyDownloadWithoutFormatOrCollectionIsSupported(){
        val archive=CollectionArchive.find(data(),"seasonal")!!
        assertEquals("seasonal",archive.collection);assertEquals(37518248,archive.bytes);assertEquals("downloads/imperial-school-seasonal.zip",archive.url)
    }
    @Test fun missingOrOtherCollectionNeverSubstitutesAnotherPack(){assertNull(CollectionArchive.find(data(),"monthly"));assertNull(CollectionArchive.find(data(JSONObject(row.toString()).put("id","collection-other")),"seasonal"))}
    @Test fun weatherPackageCannotBeOfferedAsOrdinaryZip(){val c=Collection("seasonal","Weather",emptyMap(),JSONObject());assertNull(CollectionArchive.find(data().copy(collections=listOf(c)),"seasonal"))}
    @Test fun unsafePathsAndMissingIntegrityAreRejected(){
        for((key,value) in listOf("url" to "https://example.com/pack.zip","url" to "downloads/../pack.zip","sha256" to "bad","bytes" to 0)){
            try{CollectionArchive.find(data(JSONObject(row.toString()).put(key,value)),"seasonal");fail("Accepted $key=$value")}catch(expected: IllegalArgumentException){}
        }
    }
    @Test fun ambiguousDownloadIsRejected(){try{CollectionArchive.find(data().copy(downloads=listOf(row,row)),"seasonal");fail("Duplicate accepted")}catch(expected: IllegalArgumentException){}}
    @Test fun publishedPackageKeepsOfflineSeasonScheduleAndPhoneImages(){
        val pack=JSONObject(javaClass.getResourceAsStream("/published-seasonal-package.json")!!.bufferedReader().readText())
        val local=Catalogue.compose(listOf(pack))!!
        for((month,season) in listOf(1 to "seasonal--season-01",4 to "seasonal--season-02",7 to "seasonal--season-03",10 to "seasonal--season-04")){
            val scene=local.choose("seasonal","seasonal",java.time.LocalDate.of(2026,month,1))
            assertEquals(season,scene.id);assertTrue(scene.phone().height>scene.phone().width)
        }
    }
}
