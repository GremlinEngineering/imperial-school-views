package ru.oopssre.imperialschool.views

import org.json.JSONObject
import java.io.File

internal object WeatherCache {
    data class Plan(val receipts: Set<String>,val images: Set<String>)
    fun plan(receipts: Map<String,JSONObject>,versions: Set<String>,pinnedImages: Set<String>): Plan {
        val valid=receipts.filterValues{it.optString("id").isNotBlank() && it.optString("format").isNotBlank() && it.optJSONArray("variants")!=null}
        fun key(p: JSONObject)=p.getString("id")+"/"+p.getString("format")
        val latest=valid.entries.groupBy{key(it.value)}.values.mapNotNull{rows->rows.maxByOrNull{Weather.time(it.value.optString("installed_at"))}?.key}.toSet()
        val keep=latest+valid.filterValues{key(it)+"/"+it.optString("version") in versions}.keys
        val images=pinnedImages+keep.flatMap{hash->valid.getValue(hash).getJSONArray("variants").objects().map{it.getString("sha256")}}
        return Plan(keep,images)
    }
    fun prune(repo: Repository){
        try{
            val pins=mutableSetOf(repo.text("hash_1"),repo.text("hash_2"));val versions=mutableSetOf<String>()
            val profiles=repo.savedProfiles()
            listOfNotNull(profiles.home,profiles.lock).filter{it.source=="weather"}.forEach{s->
                if(DailyWeather.active(s)){
                    DailyWeather.cached(repo,s)?.optJSONObject("current")?.optJSONObject("files")?.optJSONObject("phone")?.optString("sha256")?.let{pins.add(it)}
                    return@forEach
                }
                val c=repo.cachedCatalogue(s)?.collections?.firstOrNull{it.id==s.collection}?.weather ?: return@forEach
                val pair=repo.weatherPair(c,s) ?: return@forEach;val f=pair.optJSONObject("forecast") ?: return@forEach
                if(Weather.time(f.optString("valid_until"))<=System.currentTimeMillis())return@forEach
                Weather.packageVersion(f)?.let{versions.add(c.getString("id")+"/"+Weather.format(c,s)+"/"+it)}
                f.optJSONArray("intervals")?.objects()?.forEach{row->row.optJSONObject("file")?.optString("sha256")?.let{pins.add(it)}}
            }
            val files=File(repo.root,"weather-packages").listFiles()?.filter{it.extension=="json"}.orEmpty()
            val receipts=files.mapNotNull{f->try{f.nameWithoutExtension to JSONObject(f.readText()).put("installed_at",java.time.Instant.ofEpochMilli(f.lastModified()).toString())}catch(e: Exception){null}}.toMap()
            if(repo.text("weather_verified_api")!="1.7" && receipts.values.none{it.optString("client_api")=="1.7"})return
            val plan=plan(receipts.filterValues{it.optString("client_api")=="1.7"},versions,pins);val before=System.currentTimeMillis()-300000
            files.filter{it.nameWithoutExtension !in plan.receipts && it.lastModified()<before}.forEach{it.delete()}
            File(repo.root,"weather-images").listFiles()?.filter{it.extension=="jpg" && it.nameWithoutExtension !in plan.images && it.lastModified()<before}?.forEach{it.delete()}
            File(repo.root,"downloads").listFiles()?.forEach{f->try{val job=JSONObject(f.readText());val hash=job.getJSONObject("archive").getString("sha256");if(hash !in plan.receipts && job.optString("stage") in listOf("ready","error") && f.lastModified()<before){repo.context.getSystemService(android.app.DownloadManager::class.java).remove(job.optLong("download_id",-1));f.delete()}}catch(ignored: Exception){}}
        }catch(ignored: Exception){/* Retention failure must not prevent installing a verified frame. */}
    }
}
