package ru.oopssre.imperialschool.views

import org.json.JSONObject
import java.time.Instant
import java.time.LocalDate
import java.time.format.DateTimeFormatter
import java.util.Locale

internal data class WeatherFrame(val status: String,val row: JSONObject?=null,val title: String="",val next: Long=0,val refresh: Long=0,val message: String="")
internal object Weather {
    fun time(value: String?): Long = try { Instant.parse(value).toEpochMilli() } catch(e: Exception) { 0 }
    private fun world(o: JSONObject)=if(o.isNull("world_id"))"" else o.optString("world_id")
    fun identity(a: JSONObject,b: JSONObject)=a.optString("collection_id")==b.optString("collection_id") && a.optString("source_id")==b.optString("source_id") && world(a)==world(b) && a.optString("location_revision")==b.optString("location_revision")
    fun formats(c: JSONObject): List<String> { val f=c.getJSONObject("formats");return f.keys().asSequence().filter { f.getJSONObject(it).getInt("height")>f.getJSONObject(it).getInt("width") }.toList() }
    fun format(c: JSONObject,s: Selection): String { val ids=formats(c);requireView(ids.isNotEmpty(),"В наборе нет формата для телефона");requireView(s.weatherFormat in listOf("auto","") || s.weatherFormat in ids,"Выбранный формат больше недоступен. Выберите коллекцию заново.");return s.weatherFormat.takeIf { it in ids } ?: "phone".takeIf { it in ids } ?: ids.first() }
    fun sources(c: JSONObject)=c.getJSONArray("sources").objects()
    fun source(c: JSONObject,id: String)=sources(c).firstOrNull { it.getString("id")==id } ?: error("Источник погоды недоступен")
    fun validateCollection(c: JSONObject) {
        val specifications=c.getJSONObject("formats");val allFormats=specifications.keys().asSequence().toList()
        requireView(packId.matches(c.getString("id")) && allFormats.size in 1..20,"Неверная погодная коллекция")
        allFormats.forEach{id->val spec=specifications.getJSONObject(id);requireView(packId.matches(id) && spec.getInt("width") in 1..16384 && spec.getInt("height") in 1..16384,"Неверный формат") }
        requireView(sources(c).size in 1..2 && sources(c).map{it.getString("id")}.distinct().size==sources(c).size,"Нет источников погоды")
        sources(c).forEach { s ->
            val id=s.getString("id");val prefix="weather/"+c.getString("id")+"/"+if(id=="game-world")"sources/game-world/" else ""
            requireView(id in listOf("real","game-world") && JsonBody.endpoint(s.getString("current_url"),prefix+"current.json"),"Неверный источник")
            allFormats.forEach { f -> requireView(JsonBody.endpoint(s.getJSONObject("forecasts").getString(f),prefix+"forecast-"+f+".json"),"Неверный адрес прогноза") }
        }
    }
    fun current(p: JSONObject,c: JSONObject,source: String): JSONObject {
        requireView(p.optInt("schema")==1 && p.optString("type")=="weather" && p.optString("collection_id")==c.getString("id") && p.optString("source_id")==source && p.has("location_revision") && p.has("timezone"),"Неверная текущая погода")
        return p
    }
    fun frameFile(c: JSONObject,s: Selection,frame: WeatherFrame)=if(DailyWeather.active(s))DailyWeather.image(frame) else file(frame.row!!.getJSONObject("file"),c,format(c,s))
    fun file(f: JSONObject,c: JSONObject,format: String): ImageFile {
        val size=c.getJSONObject("formats").getJSONObject(format);val id=c.getString("id")
        requireView(f.optString("format")=="jpeg" && f.optString("rendition")==format && f.getInt("width")==size.getInt("width") && f.getInt("height")==size.getInt("height") && Regex("collections/"+id+"/files/[a-z0-9-]+-"+format+"\\.jpg").matches(f.getString("url")) && Regex("[a-f0-9]{64}").matches(f.getString("sha256")) && f.getLong("bytes") in 1..100000000,"Неверный погодный JPEG")
        return ImageFile(f.getString("url"),f.getInt("width"),f.getInt("height"),f.getLong("bytes"),f.getString("sha256"))
    }
    fun forecast(f: JSONObject,c: JSONObject,source: String,format: String): JSONObject {
        requireView(f.optInt("schema")==1 && f.optString("document_type")=="weather-forecast" && f.optString("collection_id")==c.getString("id") && f.optString("source_id")==source && f.optString("format")==format && f.has("location_revision"),"Неверный прогноз")
        if(f.optString("status")=="unavailable")return f
        requireView(time(f.optString("generated_at"))>0 && time(f.optString("valid_until"))>time(f.optString("generated_at")) && f.has("contract_version"),"Неверный срок прогноза")
        requireView(f.has("package_version") && (f.isNull("package_version") || f.get("package_version") is String && f.getString("package_version").isNotBlank()),"Прогноз на сайте обновляется. Повторю загрузку.")
        val rows=f.getJSONArray("intervals").objects();requireView(rows.size<=2000,"Прогноз слишком большой")
        rows.forEach { r -> requireView(time(r.optString("valid_until"))>time(r.optString("valid_from")),"Неверный интервал");if(r.optString("status")=="ready"){file(r.getJSONObject("file"),c,format);requireView(r.has("state_id") && r.has("moon_phase"),"Нет состояния кадра")} }
        return f
    }
    fun resolve(pair: JSONObject?,c: JSONObject,s: Selection,now: Long): WeatherFrame {
        if(pair==null)return WeatherFrame("missing",refresh=now)
        val p=current(pair.getJSONObject("current"),c,s.weatherSource);val f=forecast(pair.getJSONObject("forecast"),c,s.weatherSource,format(c,s))
        val source=p.optJSONObject("source");val title=if(s.weatherSource=="real")"Погода с сервера" else source?.optString("setting").orEmpty().ifBlank{source?.optString("name").orEmpty().ifBlank{"Игровой мир"}}
        val refresh=listOf(time(p.optString("refresh_after")),time(f.optString("refresh_after"))).filter{it>0}.minOrNull() ?: now
        if(!identity(p,f) || p.optString("timezone")!=f.optString("timezone") && f.optString("status")!="unavailable")return WeatherFrame("stale",title=title,refresh=now)
        if(p.optString("status")=="unavailable" || f.optString("status")=="unavailable")return WeatherFrame("unavailable",title=title,refresh=refresh)
        if(p.optString("status") !in listOf("ready","not_ready","stale","unresolved_weather"))return WeatherFrame("not_ready",title=title,refresh=refresh)
        if(now<time(f.optString("generated_at")) || now>=time(f.optString("valid_until")))return WeatherFrame("stale",title=title,refresh=refresh)
        val rows=f.getJSONArray("intervals").objects();val selected=rows.filter { time(it.optString("valid_from"))<=now && now<time(it.optString("valid_until")) }
        val next=(rows.flatMap { listOf(time(it.optString("valid_from")),time(it.optString("valid_until"))) }+time(f.optString("valid_until"))).filter{it>now}.minOrNull() ?: now+60000
        if(selected.size!=1)return WeatherFrame("not_ready",title=title,next=next,refresh=refresh)
        val row=selected.single();return WeatherFrame(if(row.optString("status")=="ready")"ready" else "not_ready",row,title,next,refresh)
    }
    fun packageVersion(f: JSONObject): String?=if(f.isNull("package_version"))null else f.getString("package_version").takeIf{it.isNotBlank()}
    fun imageURL(file: ImageFile)=SITE+file.url+"?v="+file.sha256
    fun details(frame: WeatherFrame): String {
        if(frame.message.isNotBlank())return frame.message
        val row=frame.row ?: return if(frame.status=="stale")"Прогноз устарел. Сохранены последние обои." else "Нет актуальных погодных данных."
        val season=mapOf("spring" to "Весна","summer" to "Лето","autumn" to "Осень","winter" to "Зима")[row.optString("season")].orEmpty()
        val date=try { LocalDate.parse(row.getString("world_date")).format(DateTimeFormatter.ofPattern("d MMMM uuuu",Locale("ru"))) }catch(e: Exception){""}
        val times=mapOf("dawn" to "Рассвет","day" to "День","dusk" to "Закат","night" to "Ночь")
        val weather=mapOf("clear" to "Ясно","partly-cloudy" to "Переменная облачность","overcast" to "Пасмурно","fog" to "Туман","drizzle" to "Морось","rain" to "Дождь","heavy-rain" to "Сильный дождь","snow" to "Снег","heavy-snow" to "Сильный снег","freezing-precipitation" to "Ледяные осадки","thunderstorm" to "Гроза","thunderstorm-hail" to "Гроза с градом","severe-thunderstorm" to "Сильная гроза")
        val text=listOf(season,date,times[row.optString("time_of_day")] ?: row.optString("time_of_day"),weather[row.optString("weather")] ?: row.optString("weather")).filter{it.isNotBlank()}.joinToString(" · ")
        return if(frame.status=="ready")text else "Текущий кадр пока недоступен. "+text
    }
    fun descriptor(data: Catalogue,c: JSONObject,format: String): JSONObject = data.downloads.singleOrNull { it.optString("collection")==c.getString("id") && it.optString("format")=="zip" && it.optString("rendition")==format }?.also {
        requireView((it.getString("url")=="downloads/weather-"+c.getString("id")+"-"+format+".zip") && it.optString("version").isNotBlank() && Regex("[a-f0-9]{64}").matches(it.getString("sha256")) && it.getLong("bytes") in 1..8589934592,"Неверный ZIP")
    } ?: error("ZIP выбранного формата ещё не опубликован")
    fun packageManifest(p: JSONObject,c: JSONObject,format: String,version: String): List<JSONObject> {
        requireView(p.optInt("schema")==3 && p.optString("document_type")=="weather-wallpaper-package" && p.optString("type")=="weather" && p.optString("id")==c.getString("id") && p.optString("format")==format && p.optString("version")==version,"ZIP другой коллекции, формата или версии")
        val rows=p.getJSONArray("variants").objects();requireView(rows.isNotEmpty() && rows.size<=8000 && rows.map{it.getString("url")}.distinct().size==rows.size,"Неверный состав ZIP")
        rows.forEach { v ->
            requireView(Regex("files/[a-z0-9-]+\\.jpg").matches(v.getString("url")) && v.has("state_id") && v.has("moon_phase"),"Неверный путь ZIP")
            file(JSONObject(v.toString()).put("url","collections/"+c.getString("id")+"/files/validated-"+format+".jpg"),c,format)
        }
        return rows
    }
}
