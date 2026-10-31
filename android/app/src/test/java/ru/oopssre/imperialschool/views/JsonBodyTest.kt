package ru.oopssre.imperialschool.views

import org.json.JSONObject
import org.junit.Assert.*
import org.junit.Test
import java.net.HttpURLConnection
import java.net.URL

class JsonBodyTest {
    private fun fixture(name: String)=javaClass.getResourceAsStream("/compression/"+name)!!.use{it.readBytes()}
    private fun read(name: String,encoding: String?=null,url: String=SITE+"manifest-v3.json?v=1",limit: Long=5000000)=JsonBody.read(fixture(name).inputStream(),encoding,url,limit)
    @Test fun ordinaryJsonAndGzipAndBrotliYieldTheSameCatalogue() {
        val expected=fixture("catalogue.json")
        assertArrayEquals(expected,read("catalogue.json"))
        assertArrayEquals(expected,read("catalogue.json.gz","gzip"))
        val actual=read("catalogue.json.br","br")
        assertArrayEquals(expected,actual)
        val catalogue=Catalogue.parse(JSONObject(String(actual,Charsets.UTF_8)))
        assertTrue(catalogue.collections.any{it.weather!=null && Weather.formats(it.weather).isNotEmpty()})
    }
    @Test fun directSidecarWithoutEncodingAndWithEncodingIsDecodedOnce() {
        val expected=fixture("catalogue.json");val url=SITE+"manifest-v3.json.br?v=2"
        assertArrayEquals(expected,read("catalogue.json.br",url=url))
        assertArrayEquals(expected,read("catalogue.json.br","Br",url))
    }
    @Test fun stackedEncodingsAreRemovedInReverseOrder() {
        assertArrayEquals(fixture("catalogue.json"),read("catalogue.json.br.gz","br, gzip"))
    }
    @Test fun decompressedSizeIsBoundedEvenWhenTheTransferFits() {
        val compressed=fixture("catalogue.json.br");val limit=compressed.size.toLong()+100
        assertThrows(IllegalArgumentException::class.java){read("catalogue.json.br","br",limit=limit)}
    }
    @Test fun wireSizeIsBounded() {
        assertThrows(IllegalArgumentException::class.java){read("catalogue.json",limit=10)}
    }
    @Test fun corruptCompressedBodyReportsActionableError() {
        val e=assertThrows(JsonTransferException::class.java){read("catalogue.json","br")}
        assertTrue(UiErrors.message(e).contains("распаковать JSON"))
    }
    @Test fun unknownEncodingIsRejected() {
        assertThrows(JsonTransferException::class.java){read("catalogue.json","zstd")}
    }
    @Test fun jsonRequestsExplicitlyNegotiateSupportedEncodings() {
        val c=object: HttpURLConnection(URL(SITE)){override fun connect(){};override fun disconnect(){};override fun usingProxy()=false}
        JsonBody.configure(c)
        assertEquals("br, gzip",c.getRequestProperty("Accept-Encoding"))
        assertEquals("application/json",c.getRequestProperty("Accept"))
    }
    @Test fun sidecarEndpointDoesNotPermitAnotherPathOrHost() {
        val path="weather/test/current.json"
        assertTrue(JsonBody.endpoint(path,path));assertTrue(JsonBody.endpoint(path+".br",path))
        for(bad in listOf(path+".br.br",path+"/x",path+"?redirect=x","https://evil.test/"+path,"../"+path))assertFalse(JsonBody.endpoint(bad,path))
    }
    @Test fun catalogueAcceptsBrotliSourceUrlsAndStillRejectsForeignEndpoints() {
        val json=JSONObject(String(fixture("catalogue.json"),Charsets.UTF_8))
        json.getJSONArray("collections").objects().filter{it.optString("type")=="weather"}.forEach{c->
            Weather.sources(c).forEach{s->
                s.put("current_url",s.getString("current_url")+".br")
                val f=s.getJSONObject("forecasts");f.keys().asSequence().toList().forEach{k->f.put(k,f.getString(k)+".br")}
            }
        }
        val data=Catalogue.parse(json)
        val c=data.collections.first{it.weather!=null && Weather.formats(it.weather).isNotEmpty()}.weather!!
        assertThrows(IllegalArgumentException::class.java){Weather.format(c,Selection(weatherFormat="unpublished-format"))}
        Weather.sources(c).first().put("current_url","https://evil.test/current.json.br")
        assertThrows(IllegalArgumentException::class.java){Weather.validateCollection(c)}
    }
}
