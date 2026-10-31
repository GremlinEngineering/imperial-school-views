package ru.oopssre.imperialschool.views

import android.app.WallpaperManager
import org.json.JSONObject
import java.io.File

internal data class WallpaperCondition(val season: String="",val time: String="",val weather: String="",val moon: String="",val title: String="",val state: String="",val events: String="") {
    fun label(): String = listOf(SavedWallpapers.seasons[season] ?: season,SavedWallpapers.times[time] ?: time,SavedWallpapers.weather[weather] ?: weather,SavedWallpapers.moons[moon] ?: moon,events).filter{it.isNotBlank()}.joinToString(" · ").ifBlank{title.ifBlank{"Условия не указаны в данных набора"}}
}
internal data class SavedWallpaper(val file: File,val image: ImageFile,val title: String,val conditions: List<WallpaperCondition>,val installed: List<String>)
internal data class WallpaperFilter(val season: String="",val time: String="",val weather: String="",val moon: String="") {
    // All predicates must match the SAME rule, not different rules sharing one image.
    fun accepts(item: SavedWallpaper)=item.conditions.any{c->(season.isBlank() || season==c.season) && (time.isBlank() || time==c.time) && (weather.isBlank() || weather==c.weather) && (moon.isBlank() || moon==c.moon)}
    fun json()=JSONObject().put("season",season).put("time",time).put("weather",weather).put("moon",moon)
    companion object { fun parse(o: JSONObject)=WallpaperFilter(o.optString("season"),o.optString("time"),o.optString("weather"),o.optString("moon")) }
}
internal data class SavedWallpaperList(val title: String,val items: List<SavedWallpaper>,val warning: String="")

/** Reads existing manifests and files only. Opening the viewer never enqueues or fetches anything. */
internal object SavedWallpapers {
    val seasons=linkedMapOf("winter" to "Зима","spring" to "Весна","summer" to "Лето","autumn" to "Осень")
    val times=linkedMapOf("dawn" to "Рассвет","day" to "День","dusk" to "Закат","night" to "Ночь")
    val weather=linkedMapOf("cloudy" to "Облачно","clear" to "Ясно","partly-cloudy" to "Переменная облачность","overcast" to "Пасмурно","fog" to "Туман","drizzle" to "Морось","rain" to "Дождь","heavy-rain" to "Сильный дождь","snow" to "Снег","heavy-snow" to "Сильный снег","freezing-precipitation" to "Ледяные осадки","thunderstorm" to "Гроза","thunderstorm-hail" to "Гроза с градом","severe-thunderstorm" to "Сильная гроза")
    val moons=linkedMapOf("none" to "Без лунного слоя","new_moon" to "Новолуние","waxing_crescent" to "Растущий серп","first_quarter" to "Первая четверть","waxing_gibbous" to "Растущая Луна","full_moon" to "Полнолуние","waning_gibbous" to "Убывающая Луна","last_quarter" to "Последняя четверть","waning_crescent" to "Убывающий серп")
    fun condition(row: JSONObject): WallpaperCondition {
        // Package v3 may provide only state_id; consume the two fixed prefixes and keep
        // the weather suffix intact (severe-thunderstorm, partly-cloudy, ...).
        val state=row.optString("state_id").takeUnless{it=="null"}.orEmpty()
        val known=Regex("^(winter|spring|summer|autumn)-(dawn|day|dusk|night)-(.+)$").matchEntire(state)
        fun field(key: String,fallback: String)=row.optString(key).takeUnless{it.isBlank() || it=="null"} ?: fallback
        return WallpaperCondition(field("season",known?.groupValues?.get(1).orEmpty()),field("time_of_day",known?.groupValues?.get(2).orEmpty()),field("weather",known?.groupValues?.get(3).orEmpty()),field("moon_phase",""),field("state_title",field("title","")),state)
    }
    private fun read(file: File): JSONObject {requireView(file.length() in 1..5000000,"Неверный размер сохранённых данных");return JSONObject(file.readText())}
    fun load(repo: Repository,s: Selection): SavedWallpaperList {
        val data=repo.cachedCatalogue(s)
        val selected=if(s.source=="day")data?.scenes?.firstOrNull{it.id==data.featured}?.collection.orEmpty() else s.collection
        val collection=data?.collections?.firstOrNull{it.id==selected}
        var title=if(DailyWeather.active(s))"Погода дня" else collection?.title ?: "Скачанные обои"
        val result=linkedMapOf<String,SavedWallpaper>();var unreadable=0
        val manager=repo.context.getSystemService(WallpaperManager::class.java)
        fun installed(hash: String)=listOf(1 to "Главный экран",2 to "Экран блокировки").mapNotNull{(flag,name)->
            if(repo.text("hash_"+flag)==hash && repo.number("wallpaper_"+flag)>0 && try{manager.getWallpaperId(flag).toLong()==repo.number("wallpaper_"+flag)}catch(e: Exception){false})name else null
        }
        fun add(f: ImageFile,path: File,name: String,conditions: List<WallpaperCondition>) {
            if(!Regex("[a-f0-9]{64}").matches(f.sha256) || f.height<=f.width || !path.isFile || path.length()!=f.bytes)return
            if(!path.canonicalPath.startsWith(repo.root.canonicalPath+File.separator))return
            val old=result[f.sha256]
            result[f.sha256]=if(old!=null)old.copy(conditions=(old.conditions+conditions).distinct()) else SavedWallpaper(path,f,name,conditions.distinct(),installed(f.sha256))
        }
        fun weatherRow(row: JSONObject,file: JSONObject?=row.optJSONObject("file")) {
            if(file==null)return
            val f=ImageFile(file.getString("url"),file.getInt("width"),file.getInt("height"),file.getLong("bytes"),file.getString("sha256"))
            add(f,repo.weatherPath(f),row.optString("title").ifBlank{row.optString("state_title").ifBlank{title}},listOf(condition(row)))
        }
        if(s.source=="dynamic"){
            collection?.dynamic?.let{c->Dynamic.history(repo,c,s).forEach{state->try{
                val f=Dynamic.image(state,c,s);add(f,Dynamic.path(repo,f),title,listOf(Dynamic.condition(state).copy(title=Dynamic.details(state)+"\nСобрано: "+state.optString("at"))))
            }catch(e: Exception){unreadable++}}}
        }else if(s.source=="weather"){
            if(DailyWeather.active(s)){
                DailyWeather.cached(repo,s)?.optJSONObject("current")?.let{p->
                    title=p.optString("collection_title").ifBlank{title}
                    weatherRow(p,p.optJSONObject("files")?.optJSONObject("phone"))
                }
            }else{
                val format=try{collection?.weather?.let{Weather.format(it,s)}}catch(e: Exception){null}
                File(repo.root,"weather-packages").listFiles()?.filter{it.extension=="json"}?.sortedByDescending{it.lastModified()}?.forEach{p->try{
                    val pack=read(p)
                    if(pack.optString("id")==selected && pack.optString("format")==format && pack.optString("client_api")=="1.7"){
                        pack.getJSONArray("variants").objects().forEach{v->weatherRow(v,v)}
                    }
                }catch(e: Exception){unreadable++}}
                // Include on-demand JPEGs from all cached sources/cities of this collection.
                val scope=File(repo.root,"weather/$selected")
                if(packId.matches(selected))scope.walkTopDown().maxDepth(5).filter{it.isFile && it.extension=="json"}.forEach{p->try{
                    val pair=read(p);val f=pair.optJSONObject("forecast")
                    if(f?.optString("collection_id")==selected && f.optString("format")==format)f.optJSONArray("intervals")?.objects()?.forEach{weatherRow(it)}
                }catch(e: Exception){unreadable++}}
            }
        }else if(data!=null){
            data.scenes.filter{it.collection==selected}.forEach{scene->try{
                val f=scene.phone();val rules=collection?.schedule.orEmpty().flatMap{(mode,table)->table.filterValues{it==scene.id}.keys.map{period->
                    if(mode=="seasonal")WallpaperCondition(season=period,title=scene.title) else WallpaperCondition(title="Месяц: $period · "+scene.title)
                }}.ifEmpty{listOf(WallpaperCondition(title=scene.title))}
                val path=File(repo.root,f.url)
                add(f,if(path.isFile)path else File(repo.root,"online/"+f.sha256+".jpg"),scene.title,rules)
            }catch(e: Exception){unreadable++}}
        }
        return SavedWallpaperList(title,result.values.toList(),if(unreadable>0)"Часть сохранённых описаний не удалось прочитать. Доступные кадры показаны." else "")
    }
}
