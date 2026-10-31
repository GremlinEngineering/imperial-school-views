package ru.oopssre.imperialschool.views

import android.app.WallpaperManager
import android.content.Context
import java.io.File
import java.util.concurrent.ConcurrentHashMap

internal object FrameEngine {
    private val lock=Any()
    fun run(context: Context,requested: String="both",force: Boolean=false) {
        val repo=Repository(context)
        if(!repo.installed())return
        val targets=repo.activeTargets().filter { requested=="both" || it==requested || repo.targets(repo.settings(it)).contains(requested) }
        targets.forEach { target ->
            synchronized(lock){
                val s=repo.settings(target);val manual=force || repo.manual(s)
                if(s.paused && !manual)return@synchronized
                try {
                    val data=repo.cachedCatalogue(s) ?: run{repo.status(target,"Нет сохранённого каталога. Получаю данные…",s.revision);if(repo.online(s))Schedule.refresh(context,manual);return@synchronized}
                    var caption="";val signature: String;val file: File
                    if(s.source=="dynamic"){
                        val c=Dynamic.collection(data,s);val state=Dynamic.cached(repo,c,s)
                        if(state==null || Weather.time(state.optString("at"))>System.currentTimeMillis()+60000 || Weather.time(state.optString("valid_until"))<=System.currentTimeMillis()){
                            repo.status(target,"Сохранены последние обои. "+Dynamic.message(repo,c,s),s.revision)
                            if(Dynamic.due(repo,c,s))Schedule.dynamic(context,c,s,false)
                            return@synchronized
                        }
                        val f=Dynamic.image(state,c,s);file=Dynamic.path(repo,f);signature=f.sha256
                        if(!validImage(file,f)){repo.status(target,"Текущий динамический кадр ещё не загружен. Сохранены последние обои.",s.revision);repo.putNumber("dynamic_next_"+Dynamic.scope(c,s),0);Schedule.dynamic(context,c,s,false);return@synchronized}
                        caption=c.getString("title")+" · "+Dynamic.details(state)
                        if(Dynamic.due(repo,c,s))Schedule.dynamic(context,c,s,false)
                    }else if(s.source=="weather"){
                        val c=repo.weatherCollection(data,s);val frame=repo.resolveWeather(c,s)
                        if(frame.status!="ready"){repo.status(target,"Сохранены последние обои. "+Weather.details(frame),s.revision);Schedule.weather(context,c,s,false);return@synchronized}
                        val f=Weather.frameFile(c,s,frame);val path=repo.weatherPath(f)
                        if(!validImage(path,f)){if(LocalWeather.active(s))LocalWeather.repair(repo,data,c,s);repo.status(target,"Текущий кадр ещё не загружен. Сохранены последние обои.",s.revision);Schedule.weather(context,c,s,false);return@synchronized}
                        signature=f.sha256;file=path;caption=frame.title+" · "+Weather.details(frame)
                    }else{
                        val scene=data.choose(s.collection,s.mode);signature=scene.phone().sha256;val cached=repo.cachedScene(scene,s)
                        if(cached==null){repo.status(target,"Получаю текущий кадр. Сохранены последние обои.",s.revision);if(repo.online(s))Schedule.refresh(context,manual);return@synchronized}
                        file=cached;caption=scene.title
                    }
                    val manager=WallpaperManager.getInstance(context)
                    requireView(manager.isWallpaperSupported && manager.isSetWallpaperAllowed,"Установка обоев недоступна на этом устройстве")
                    val destinations=repo.targets(s);val flags=destinations.map{if(it=="home")WallpaperManager.FLAG_SYSTEM else WallpaperManager.FLAG_LOCK}
                    val oldHome=repo.number("wallpaper_1")
                    if(repo.number("wallpaper_2")==-1L && oldHome>0 && manager.getWallpaperId(WallpaperManager.FLAG_LOCK).toLong()==oldHome)repo.putNumber("wallpaper_2",oldHome)
                    val externallyChanged=if(manual)emptyList() else destinations.filter { t->val flag=if(t=="home")WallpaperManager.FLAG_SYSTEM else WallpaperManager.FLAG_LOCK;repo.number("wallpaper_"+flag)!=0L && repo.number("wallpaper_"+flag)!=manager.getWallpaperId(flag).toLong() }
                    if(externallyChanged.isNotEmpty()){externallyChanged.forEach{repo.setPaused(it,true);repo.status(it,"Обои изменены вне приложения. Автосмена этого экрана приостановлена.")};return@synchronized}
                    if(repo.settings(target)!=s || repo.targets(s)!=destinations)return@synchronized
                    if(s.source=="weather"){
                        val c=repo.weatherCollection(data,s);val latest=repo.resolveWeather(c,s)
                        if(latest.status!="ready" || latest.row!!.getJSONObject("file").getString("sha256")!=signature)return@synchronized
                    }
                    if(s.source=="dynamic"){
                        val c=Dynamic.collection(data,s);val latest=Dynamic.cached(repo,c,s)
                        if(latest==null || Weather.time(latest.optString("valid_until"))<=System.currentTimeMillis() || Dynamic.image(latest,c,s).sha256!=signature)return@synchronized
                    }
                    val changed=manual || flags.any{repo.text("hash_"+it)!=signature || repo.number("wallpaper_"+it)!=manager.getWallpaperId(it).toLong()}
                    if(changed && !repo.ifCurrent(s,destinations){
                        val previousHome=manager.getWallpaperId(WallpaperManager.FLAG_SYSTEM).toLong()
                        val id=file.inputStream().use{manager.setStream(it,null,false,flags.reduce{a,b->a or b})}
                        requireView(id!=0,"Android не подтвердил установку обоев")
                        if(repo.number("wallpaper_2")==-1L && manager.getWallpaperId(WallpaperManager.FLAG_LOCK).toLong()==previousHome)repo.putNumber("wallpaper_2",previousHome)
                        flags.forEach{flag->repo.put("hash_"+flag,signature);repo.putNumber("wallpaper_"+flag,manager.getWallpaperId(flag).toLong())}
                    })return@synchronized
                    destinations.forEach{repo.clearManual(it,s.revision);repo.status(it,"Обои установлены: "+caption,s.revision);repo.put("current_title_"+it,caption)}
                    repo.clearOnlineCache(setOf(repo.text("hash_1")+".jpg",repo.text("hash_2")+".jpg"))
                }catch(e: Exception){repo.status(target,"Сохранены последние обои. "+(e.message ?: "Не удалось обновить изображение"),s.revision)}
            }
        }
        Schedule.configure(context)
    }
}
