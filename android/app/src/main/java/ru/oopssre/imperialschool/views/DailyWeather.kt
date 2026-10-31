package ru.oopssre.imperialschool.views

import org.json.JSONArray
import org.json.JSONObject
import java.io.File
import java.time.LocalDate

internal object DailyWeather {
    const val ID="__weather_day__"
    fun active(s: Selection)=s.source=="weather" && s.collection==ID
    fun collection(): JSONObject = JSONObject().put("id",ID).put("type","weather").put("title","Погода дня — выбор сервера")
        .put("formats",JSONObject().put("phone",JSONObject().put("width",1440).put("height",3120)))
        .put("sources",JSONArray(listOf("real","game-world").map{id->JSONObject().put("id",id).put("title",if(id=="real")"Погода с сервера" else "Игровой мир").put("current_url",endpoint(id))}))
    fun endpoint(source: String): String {
        requireView(source in listOf("real","game-world"),"Погода дня доступна для серверной погоды и игрового мира")
        return "weather/daily/"+source+"/current.json"
    }
    fun validate(p: JSONObject,source: String): JSONObject {
        endpoint(source)
        requireView(p.optInt("schema")==1 && p.optString("document_type")=="weather-of-day" && p.optString("type")=="weather" && p.optString("source_id")==source,"Неверный документ погоды дня")
        requireView(p.optString("status") in listOf("ready","not_ready","disabled"),"Неверный статус погоды дня")
        LocalDate.parse(p.getString("selection_date"))
        val files=p.getJSONObject("files");requireView(files.length()<=20,"Неверный список файлов погоды дня")
        if(p.optString("status")!="ready"){requireView(files.length()==0,"Неготовая погода дня содержит файлы");return p}
        requireView(packId.matches(p.getString("collection_id")),"Неверная коллекция погоды дня")
        val collection=JSONObject(p.toString()).put("id",p.getString("collection_id"))
        Weather.current(p,collection,source)
        val from=Weather.time(p.optString("valid_from"));val until=Weather.time(p.optString("valid_until"))
        requireView(from>0 && until>from && Weather.time(p.optString("refresh_after"))>0,"Неверный срок погоды дня")
        if(p.has("forecast_valid_until") && !p.isNull("forecast_valid_until"))requireView(Weather.time(p.optString("forecast_valid_until"))>from,"Неверный срок прогноза погоды дня")
        requireView(files.length()>0,"Нет файлов погоды дня")
        val formats=p.getJSONObject("formats")
        files.keys().forEach{format->
            requireView(packId.matches(format),"Неверный формат погоды дня")
            val spec=formats.getJSONObject(format)
            requireView(spec.getInt("width") in 1..16384 && spec.getInt("height") in 1..16384,"Неверные размеры погоды дня")
            val file=files.getJSONObject(format);Weather.file(file,collection,format)
            if(file.has("image_url"))requireView(file.getString("image_url")=="weather/daily/"+source+"/current-"+format+".jpg","Неверный адрес погоды дня")
        }
        if(p.has("image_url"))requireView(p.getString("image_url")=="weather/daily/"+source+"/current.jpg","Неверный адрес погоды дня")
        return p
    }
    private fun path(repo: Repository,s: Selection): File {endpoint(s.weatherSource);return File(repo.root,"weather-daily/"+s.weatherSource+".json")}
    fun cached(repo: Repository,s: Selection): JSONObject?=try{JSONObject(path(repo,s).readText()).also{validate(it.getJSONObject("current"),s.weatherSource)}}catch(e: Exception){null}
    fun resolve(saved: JSONObject?,s: Selection,now: Long): WeatherFrame {
        val title=if(s.weatherSource=="real")"Погода с сервера" else "Игровой мир"
        if(saved==null)return WeatherFrame("missing",title=title,refresh=now,message="Получаю погоду дня…")
        val p=validate(saved.getJSONObject("current"),s.weatherSource)
        val displayTitle=if(s.weatherSource=="game-world")p.optJSONObject("source")?.optString("setting").orEmpty().ifBlank{title} else title
        val caption=listOf(displayTitle,p.optString("title")).filter{it.isNotBlank()}.joinToString(" · ")
        val refresh=minOf(saved.optLong("checked_at")+60000,Weather.time(p.optString("refresh_after")).takeIf{it>0} ?: Long.MAX_VALUE)
        if(p.optString("status")!="ready")return WeatherFrame(p.optString("status"),title=caption,next=now+60000,refresh=refresh,message=if(p.optString("status")=="disabled")"Источник погоды дня отключён на сервере." else "На сервере нет готового кадра погоды дня.")
        val until=minOf(Weather.time(p.getString("valid_until")),Weather.time(p.optString("forecast_valid_until")).takeIf{it>0} ?: Long.MAX_VALUE)
        if(now<Weather.time(p.getString("valid_from")) || now>=until)return WeatherFrame("stale",title=caption,refresh=refresh,message="Погода дня устарела. Сохранены последние обои.")
        val f=p.getJSONObject("files").optJSONObject("phone")
        if(f==null || f.getInt("height")<=f.getInt("width"))return WeatherFrame("not_ready",title=caption,next=until,refresh=refresh,message="У выбранной сервером коллекции нет готового формата для телефона. Сохранены последние обои.")
        val row=JSONObject(p.toString()).put("file",f).put("valid_until",java.time.Instant.ofEpochMilli(until).toString())
        return WeatherFrame("ready",row,caption,until,refresh)
    }
    fun image(frame: WeatherFrame): ImageFile {
        requireView(frame.status=="ready","Нет текущего кадра погоды дня")
        val f=frame.row!!.getJSONObject("file")
        return ImageFile(f.getString("url"),f.getInt("width"),f.getInt("height"),f.getLong("bytes"),f.getString("sha256"))
    }
    fun refresh(repo: Repository,s: Selection,force: Boolean,stopped: ()->Boolean={false},
        load: (String)->JSONObject={JSONObject(String(Net.json(SITE+it+"?v="+System.currentTimeMillis(),5000000),Charsets.UTF_8))},
        fetch: (ImageFile,File)->Unit={f,path->fetchImage(f,path);Unit},now: Long=System.currentTimeMillis()): WeatherFrame {
        var saved=cached(repo,s);var frame=resolve(saved,s,now)
        if(force || saved==null || now<saved.optLong("checked_at") || frame.refresh<=now){
            val p=validate(load(endpoint(s.weatherSource)),s.weatherSource)
            if(stopped())return frame
            saved=JSONObject().put("current",p).put("checked_at",now)
            Net.atomic(path(repo,s),saved.toString().toByteArray());frame=resolve(saved,s,now)
        }
        if(frame.status=="ready" && !stopped()){val f=image(frame);fetch(f,repo.weatherPath(f))}
        return frame
    }
}
