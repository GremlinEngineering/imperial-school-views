package ru.oopssre.imperialschool.views

import org.json.JSONObject
import org.json.JSONArray
import java.io.File
import java.net.URL
import java.net.HttpURLConnection
import java.net.URLEncoder
import java.time.Instant
import java.time.ZoneId

internal object LocalWeather {
    private data class Cached(val stamp: String,val from: Long,val frame: WeatherFrame)
    private val frames=java.util.concurrent.ConcurrentHashMap<String,Cached>()
    @Volatile private var sharedScript: SharedWeatherScript?=null
    fun active(s: Selection)=s.source=="weather" && s.weatherSource=="open-meteo"
    private fun script(repo: Repository): SharedWeatherScript=sharedScript ?: synchronized(this){sharedScript ?: SharedWeatherScript(listOf("astronomy.js","weather-policy.js","open-meteo.js").map{repo.context.assets.open("local-weather/"+it).bufferedReader().use{r->r.readText()}}).also{sharedScript=it}}
    fun city(s: Selection): JSONObject {
        requireView(s.weatherCity.isNotBlank(),"Выберите город для Open-Meteo")
        val c=JSONObject(s.weatherCity)
        requireView(c.getString("name").isNotBlank() && c.getString("name").length<=200,"Выберите город")
        requireView(c.getDouble("latitude").isFinite() && c.getDouble("latitude") in -90.0..90.0 && c.getDouble("longitude").isFinite() && c.getDouble("longitude") in -180.0..180.0,"Неверные координаты")
        ZoneId.of(c.getString("timezone"));return c
    }
    fun cityTitle(s: Selection)=try{val c=city(s);if(c.optString("origin")=="device")"Моё местоположение · "+String.format(java.util.Locale.ROOT,"%.3f, %.3f",c.getDouble("latitude"),c.getDouble("longitude"))+" · "+c.getString("timezone") else listOf(c.getString("name"),c.optString("admin1").takeUnless{it==c.getString("name")}.orEmpty(),c.optString("country")).filter{it.isNotBlank()}.joinToString(" · ")}catch(e: Exception){"Выберите город"}
    fun key(s: Selection): String {val c=city(s);return java.security.MessageDigest.getInstance("SHA-256").digest(listOf(c.getDouble("latitude"),c.getDouble("longitude"),c.getString("timezone")).joinToString("|").toByteArray()).joinToString(""){"%02x".format(it)}}
    private fun encode(v: String)=URLEncoder.encode(v,"UTF-8")
    // External provider has its own allowlist; the existing site downloader stays restricted.
    private fun get(url: String): JSONObject {
        val u=URL(url);requireView(u.protocol=="https" && u.host in listOf("api.open-meteo.com","geocoding-api.open-meteo.com") && u.userInfo==null && u.port in listOf(-1,443),"Неверный адрес Open-Meteo")
        val c=u.openConnection() as HttpURLConnection;c.connectTimeout=10000;c.readTimeout=20000;c.instanceFollowRedirects=false;JsonBody.configure(c)
        try{requireView(c.responseCode==200,"Open-Meteo недоступен (${c.responseCode})");return JSONObject(c.inputStream.use{String(JsonBody.read(it,c.getHeaderField("Content-Encoding"),url,2000000),Charsets.UTF_8)})}finally{c.disconnect()}
    }
    fun search(repo: Repository,query: String): List<JSONObject> {
        val q=query.trim();requireView(q.length in 2..120,"Введите от 2 до 120 символов")
        return JSONArray(script(repo).call("search",get("https://geocoding-api.open-meteo.com/v1/search?name="+encode(q)+"&count=20&language=ru&format=json"))).objects()
    }
    fun coordinates(latitude: Double,longitude: Double,load: (String)->JSONObject={get(it)}): JSONObject {
        requireView(latitude.isFinite() && latitude in -90.0..90.0 && longitude.isFinite() && longitude in -180.0..180.0,"Не удалось определить координаты")
        val raw=load("https://api.open-meteo.com/v1/forecast?latitude="+latitude+"&longitude="+longitude+"&timezone=auto&forecast_days=1")
        val zone=raw.getString("timezone");ZoneId.of(zone)
        return JSONObject().put("name","Моё местоположение").put("latitude",latitude).put("longitude",longitude).put("timezone",zone).put("origin","device")
    }
    fun deviceLocation(s: Selection)=try{city(s).optString("origin")=="device"}catch(e: Exception){false}
    private fun providerFile(repo: Repository,s: Selection)=File(repo.root,"open-meteo/"+key(s)+".json")
    fun refresh(repo: Repository,data: Catalogue,c: JSONObject,s: Selection,force: Boolean) {
        val city=city(s);val file=providerFile(repo,s);val now=System.currentTimeMillis()
        val old=try{JSONObject(file.readText())}catch(e: Exception){null}
        var failure: Exception?=null
        if(force || old==null || now<old.optLong("fetched_at") || now-old.optLong("fetched_at")>=3600000)try {
            val raw=get("https://api.open-meteo.com/v1/forecast?latitude="+city.getDouble("latitude")+"&longitude="+city.getDouble("longitude")+"&hourly=weather_code&timezone=UTC&timeformat=unixtime&forecast_hours=49&past_hours=1")
            val p=script(repo).call("normalize",JSONObject().put("raw",raw).put("city",city).put("now",now))
            Net.atomic(file,p.toByteArray())
        }catch(e: Exception){failure=e}
        val d=Weather.descriptor(data,c,Weather.format(c,s))
        Archive.ensure(repo,data,c,s.copy(weatherDelivery="zip"),d.getString("version"),force)
        repo.put("weather_message_"+weatherScope(c,s),if(failure==null)"" else "Open-Meteo недоступен. Используется сохранённый прогноз.")
        if(failure!=null)throw failure
    }
    fun repair(repo: Repository,data: Catalogue,c: JSONObject,s: Selection) {
        val descriptor=Weather.descriptor(data,c,Weather.format(c,s))
        File(repo.root,"weather-packages/"+descriptor.getString("sha256")+".json").delete()
        frames.remove(weatherScope(c,s))
    }
    fun resolve(repo: Repository,data: Catalogue,c: JSONObject,s: Selection,now: Long): WeatherFrame {
        val title="Open-Meteo · "+cityTitle(s)
        try {
            val sourceFile=providerFile(repo,s)
            val descriptor=Weather.descriptor(data,c,Weather.format(c,s))
            val receipt=File(repo.root,"weather-packages/"+descriptor.getString("sha256")+".json")
            val cacheKey=weatherScope(c,s)
            val stamp=sourceFile.lastModified().toString()+"/"+receipt.lastModified()+"/"+descriptor.getString("sha256")
            frames[cacheKey]?.let{if(it.stamp==stamp && now>=it.from && now<it.frame.next)return it.frame}
            val provider=JSONObject(sourceFile.readText())
            val refresh=provider.getLong("fetched_at")+3600000
            if(provider.getLong("valid_until")<=now || provider.getLong("fetched_at")>now)return WeatherFrame("stale",title=title,refresh=now)
            if(!receipt.isFile)return WeatherFrame("missing",title=title,refresh=refresh,message="Нужен ZIP выбранной коллекции. Скачайте его в приложении.")
            val p=JSONObject(receipt.readText())
            val rows=Weather.packageManifest(p,c,Weather.format(c,s),descriptor.getString("version"))
            val index=JSONObject()
            rows.forEach { v ->
                val k=v.getString("state_id")+"|"+v.getString("moon_phase")
                requireView(!index.has(k),"Неоднозначное состояние ZIP")
                val f=JSONObject(v.toString()).put("url","collections/"+c.getString("id")+"/files/local-"+Weather.format(c,s)+".jpg")
                index.put(k,f)
            }
            val plan=JSONObject(script(repo).call("schedule",JSONObject().put("provider",provider).put("city",city(s)).put("index",index).put("now",now)))
            val row=plan.getJSONArray("intervals").objects().singleOrNull{Weather.time(it.getString("valid_from"))<=now && now<Weather.time(it.getString("valid_until"))} ?: return WeatherFrame("not_ready",title=title,refresh=refresh)
            row.put("world_date",Instant.ofEpochMilli(now).atZone(ZoneId.of(city(s).getString("timezone"))).toLocalDate().toString())
            val frame=WeatherFrame(row.getString("status"),row,title,Weather.time(row.getString("valid_until")),refresh)
            if(frames.size>16)frames.clear()
            frames[cacheKey]=Cached(stamp,now,frame)
            return frame
        }catch(e: java.io.FileNotFoundException){return WeatherFrame("missing",title=title,refresh=now,message="Прогноз ещё не загружен. Нажмите «Обновить сейчас» после применения настроек.")}
        catch(e: Exception){return WeatherFrame("error",title=title,refresh=now,message=UiErrors.message(e))}
    }
}

internal fun Repository.resolveWeather(c: JSONObject,s: Selection,now: Long=System.currentTimeMillis()): WeatherFrame =
    if(DailyWeather.active(s))DailyWeather.resolve(DailyWeather.cached(this,s),s,now) else if(LocalWeather.active(s))LocalWeather.resolve(this,cachedCatalogue(s) ?: error("Нет каталога"),c,s,now) else Weather.resolve(weatherPair(c,s),c,s,now)
