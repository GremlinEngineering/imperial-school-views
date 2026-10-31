package ru.oopssre.imperialschool.views

import android.content.Context
import androidx.work.*
import org.json.JSONObject
import java.io.File
import java.util.concurrent.ConcurrentHashMap

internal fun Repository.cachedCatalogue(s: Selection): Catalogue? = try {
    if(online(s))File(root,"catalogue.json").takeIf{it.isFile}?.let{Catalogue.parse(JSONObject(it.readText()))} else local()
}catch(e: Exception){null}
class RefreshWorker(context: Context,parameters: WorkerParameters): Worker(context,parameters) {
    override fun doWork(): Result {
        val repo=Repository(applicationContext);val profiles=repo.activeTargets().map{repo.settings(it)}.filter{!it.paused || repo.manual(it)}
        val online=profiles.filter{repo.online(it)};if(online.isEmpty())return Result.success()
        val force=(inputData.getBoolean("force",false) && runAttemptCount==0) || repo.number("catalogue_checked")==0L;val interval=if(online.any{it.source!="weather"})3600000 else 86400000
        return try{
            val data=repo.catalogue(Selection(source="online"),force || System.currentTimeMillis()<repo.number("catalogue_checked") || System.currentTimeMillis()-repo.number("catalogue_checked")>=interval)
            val known=repo.text("known_collections").split('|').filter{it.isNotBlank()}.toSet();val added=data.collections.filter{it.id !in known}
            if(known.isNotEmpty() && online.any{it.notifyCollections} && added.isNotEmpty())Notices.send(applicationContext,1,"Новые коллекции обоев",added.joinToString(", "){it.title})
            repo.put("known_collections",(known+data.collections.map{it.id}).sorted().joinToString("|"))
            online.forEach{s->try{
                if(s.source=="dynamic")Schedule.dynamic(applicationContext,Dynamic.collection(data,s),s,force)
                else if(s.source=="weather")Schedule.weather(applicationContext,repo.weatherCollection(data,s),s,force)
                else repo.image(data.choose(s.collection,s.mode),s)
            }catch(e: Exception){repo.status(s.target,"Сохранены последние обои. "+e.message)}}
            try{AppRelease.check(applicationContext,repo)}catch(ignored: Exception){}
            Schedule.now(applicationContext,false);Result.success()
        }catch(e: Exception){online.forEach{repo.status(it.target,"Сохранены последние обои. "+UiErrors.message(e))};Result.retry()}
        finally{WeatherCache.prune(repo);Schedule.configure(applicationContext)}
    }
}
class WeatherRefreshWorker(context: Context,parameters: WorkerParameters): Worker(context,parameters) {
    companion object{private val locks=ConcurrentHashMap<String,Any>()}
    override fun doWork(): Result {
        val repo=Repository(applicationContext)
        val c=try{JSONObject(inputData.getString("collection")!!).let{if(it.optString("id")==DailyWeather.ID)DailyWeather.collection() else it.also{Weather.validateCollection(it)}}}catch(e: Exception){return Result.failure()}
        val s=Selection.parse(JSONObject(inputData.getString("selection") ?: return Result.failure()));val scope=weatherScope(c,s);val force=inputData.getBoolean("force",false) && runAttemptCount==0
        return synchronized(locks.getOrPut(scope){Any()}){
            try{
                if(DailyWeather.active(s)){
                    try{
                        val frame=DailyWeather.refresh(repo,s,force,{isStopped})
                        repo.put("weather_message_"+scope,if(frame.status=="ready")"" else Weather.details(frame))
                        if(frame.status=="ready")repo.put("weather_verified_api","1.7")
                    }finally{Schedule.now(applicationContext,false)}
                    return@synchronized Result.success()
                }
                if(LocalWeather.active(s)){
                    val data=repo.cachedCatalogue(s) ?: error("Нет каталога")
                    try{LocalWeather.refresh(repo,data,c,s,force)}finally{Schedule.now(applicationContext,false)}
                    return@synchronized Result.success()
                }
                var pair=repo.weatherPair(c,s);val before=try{Weather.resolve(pair,c,s,System.currentTimeMillis())}catch(e: Exception){pair=null;WeatherFrame("missing",refresh=System.currentTimeMillis())}
                if(force || repo.text("weather_refresh_"+s.collection)=="1" || pair==null || before.refresh<=System.currentTimeMillis() || before.status in listOf("stale","missing")){
                    repo.put("weather_message_"+scope,"Обновляю прогноз…")
                    pair=repo.refreshWeatherPair(c,s,{isStopped}){path->JSONObject(String(Net.json(SITE+path+"?v="+System.currentTimeMillis(),5000000),Charsets.UTF_8))}
                        ?: return@synchronized Result.success()
                    repo.put("weather_refresh_"+s.collection,"")
                }
                val data=repo.cachedCatalogue(s)
                val requested=repo.activeTargets().map{repo.settings(it)}.firstOrNull{!it.paused && it.source=="weather" && it.collection==s.collection && it.weatherSource==s.weatherSource && Weather.format(c,it)==Weather.format(c,s) && it.weatherDelivery=="zip"}
                val packageVersion=Weather.packageVersion(pair!!.getJSONObject("forecast"))
                if(data!=null && requested!=null && packageVersion!=null)try{Archive.ensure(repo,data,c,requested,packageVersion,force)}catch(e: Exception){repo.put("weather_message_"+scope,"ZIP: "+e.message);repo.putNumber("catalogue_checked",0);Schedule.refresh(applicationContext,false)}
                val frame=Weather.resolve(pair,c,s,System.currentTimeMillis())
                if(frame.status!="ready"){repo.put("weather_message_"+scope,Weather.details(frame));Schedule.now(applicationContext,false);return@synchronized if(frame.status in listOf("stale","missing"))Result.retry() else Result.success()}
                val current=Weather.file(frame.row!!.getJSONObject("file"),c,Weather.format(c,s))
                repo.put("weather_message_"+scope,"Загружаю текущий кадр…");fetchImage(current,repo.weatherPath(current));repo.put("weather_verified_api","1.7")
                if(isStopped)return@synchronized Result.success()
                if(!repo.text("weather_message_"+scope).startsWith("ZIP:"))repo.put("weather_message_"+scope,"");Schedule.now(applicationContext,false)
                val next=pair!!.getJSONObject("forecast").getJSONArray("intervals").objects().firstOrNull{it.optString("status")=="ready" && Weather.time(it.optString("valid_from"))>System.currentTimeMillis()}
                if(next!=null && !isStopped){val f=Weather.file(next.getJSONObject("file"),c,Weather.format(c,s));fetchImage(f,repo.weatherPath(f))}
                Result.success()
            }catch(e: Exception){if(e is PublishedAssetChanged){repo.put("weather_refresh_"+s.collection,"1");repo.putNumber("catalogue_checked",0);Schedule.refresh(applicationContext,false)};repo.put("weather_message_"+scope,"Обновление отложено: "+UiErrors.message(e));Result.retry()}
            finally{WeatherCache.prune(repo);Schedule.configure(applicationContext)}
        }
    }
}
