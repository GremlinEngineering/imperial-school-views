package ru.oopssre.imperialschool.views

import android.content.Context
import androidx.work.Worker
import androidx.work.WorkerParameters
import org.json.JSONObject
import java.io.File
import java.util.concurrent.ConcurrentHashMap

/** Server-rendered JPEGs only. Theme rules, PNG layers and history ZIPs are never downloaded. */
internal object Dynamic {
    val id=Regex("[a-z][a-z0-9_-]{0,79}")
    private val hash=Regex("[a-f0-9]{64}")
    private val storageLock=Any()
    private val locks=ConcurrentHashMap<String,Any>()
    fun validateCollection(c: JSONObject){
        requireView(c.optString("type")=="dynamic" && id.matches(c.getString("id")),"Неверная динамическая коллекция")
        requireView(JsonBody.endpoint(c.getString("current_url"),"dynamic/"+c.getString("id")+"/current.json"),"Неверный адрес динамической коллекции")
        val formats=c.getJSONObject("formats");requireView(formats.length() in 1..20,"Нет форматов динамической темы")
        formats.keys().forEach{device->val spec=formats.getJSONObject(device);requireView(id.matches(device) && spec.getInt("width") in 1..16384 && spec.getInt("height") in 1..16384,"Неверный формат динамической темы")}
    }
    fun descriptor(c: JSONObject)=JSONObject().put("id",c.getString("id")).put("type","dynamic").put("title",c.getString("title")).put("current_url",c.getString("current_url")).put("formats",c.getJSONObject("formats"))
    fun formats(c: JSONObject)=c.getJSONObject("formats").let{specs->specs.keys().asSequence().filter{specs.getJSONObject(it).getInt("height")>specs.getJSONObject(it).getInt("width")}.toList()}
    fun device(c: JSONObject,s: Selection): String {
        validateCollection(c);val choices=formats(c)
        requireView(choices.isNotEmpty(),"Для этой динамической темы ещё нет формата телефона")
        requireView(s.weatherFormat in listOf("auto","") || s.weatherFormat in choices,"Выбранный формат динамической темы больше недоступен")
        return s.weatherFormat.takeIf{it in choices} ?: "phone_1440x3120".takeIf{it in choices} ?: choices.first()
    }
    fun collection(data: Catalogue,s: Selection)=data.collections.firstOrNull{it.id==s.collection}?.dynamic ?: error("Динамическая тема недоступна в каталоге")
    fun scope(c: JSONObject,s: Selection)=c.getString("id")+"/"+device(c,s)
    fun prefix(c: JSONObject,s: Selection)="dynamic/"+c.getString("id")+"/devices/"+device(c,s)+"/"
    fun image(p: JSONObject,c: JSONObject,s: Selection): ImageFile {
        val f=p.getJSONObject("image");val spec=c.getJSONObject("formats").getJSONObject(device(c,s))
        requireView(f.getString("url")==prefix(c,s)+"current.jpg" && f.optString("format")=="jpg" && hash.matches(f.getString("sha256")) && f.getLong("bytes") in 1..100000000 && f.getInt("width")==spec.getInt("width") && f.getInt("height")==spec.getInt("height"),"Неверный JPEG динамической темы")
        return ImageFile(f.getString("url"),f.getInt("width"),f.getInt("height"),f.getLong("bytes"),f.getString("sha256"))
    }
    fun state(p: JSONObject,c: JSONObject,s: Selection): JSONObject {
        val inputs=p.getJSONObject("inputs");val recipe=p.getJSONObject("recipe");val version=p.optString("schema_version",inputs.optString("schema_version"))
        requireView(p.optInt("schema")==1 && p.optString("type")=="dynamic-state" && p.getString("theme_id")==c.getString("id") && p.getString("device")==device(c,s) && hash.matches(p.getString("id")),"Состояние относится к другой динамической теме или устройству")
        requireView(version in listOf("0.1","0.2") && inputs.optString("schema_version")==version && recipe.optString("schema_version")==version && inputs.optString("device")==device(c,s) && recipe.optString("device")==device(c,s) && recipe.optString("theme_id")==c.getString("id"),"Неподдерживаемое состояние динамической темы")
        val at=Weather.time(p.optString("at"));requireView(at>0 && at==Weather.time(inputs.optString("at")) && Weather.time(p.optString("valid_until"))>at,"Неверное время динамического кадра")
        val f=image(p,c,s);requireView(recipe.optInt("width")==f.width && recipe.optInt("height")==f.height && recipe.getJSONArray("layers").length()<=1000 && inputs.getJSONArray("active").length()<=100,"Неверное описание динамического кадра")
        if(version=="0.2"){
            val life=p.getJSONObject("life");java.time.ZoneId.of(life.getString("timezone"))
            val derived=inputs.getJSONObject("derived");requireView(derived.has("life_slot"),"Нет бытового состояния")
            requireView(derived.isNull("life_slot") || derived.get("life_slot") is Number && derived.getDouble("life_slot").let{it.isFinite() && it in 0.0..23.0 && it%1==0.0},"Неверный бытовой час")
            requireView(life.optString("reason") in listOf("first_build","base_changed","hour_blocked","stable_base"),"Неверная причина бытового состояния")
        }
        return p
    }
    fun path(repo: Repository,f: ImageFile)=File(repo.root,"dynamic-images/"+f.sha256+".jpg")
    private fun current(repo: Repository,c: JSONObject,s: Selection)=File(repo.root,"dynamic/"+scope(c,s)+"/current.json")
    fun cached(repo: Repository,c: JSONObject,s: Selection): JSONObject?=try{
        val file=current(repo,c,s);requireView(file.length() in 1..5000000,"Нет сохранённого состояния");state(JSONObject(file.readText()).getJSONObject("state"),c,s)
    }catch(e: Exception){null}
    fun nextCheck(repo: Repository,c: JSONObject,s: Selection)=repo.number("dynamic_next_"+scope(c,s))
    fun due(repo: Repository,c: JSONObject,s: Selection,now: Long=System.currentTimeMillis()): Boolean {
        if(now>=nextCheck(repo,c,s))return true
        val p=cached(repo,c,s) ?: return repo.number("dynamic_checked_"+scope(c,s))==0L
        return !path(repo,image(p,c,s)).isFile
    }
    fun message(repo: Repository,c: JSONObject,s: Selection): String = repo.text("dynamic_message_"+scope(c,s)).ifBlank{
        val p=cached(repo,c,s)
        if(p==null)"Текущий кадр ещё не получен с сервера." else if(Weather.time(p.optString("valid_until"))<=System.currentTimeMillis())"Обновление задерживается. Сохранён последний кадр." else details(p)
    }
    fun condition(p: JSONObject): WallpaperCondition {
        val active=p.getJSONObject("inputs").getJSONArray("active").let{a->(0 until a.length()).map{a.getString(it)}}
        fun code(prefix: String)=active.firstOrNull{it.startsWith(prefix+".")}?.substringAfter('.').orEmpty()
        val events=active.filter{it.startsWith("game.")}.map{game[it] ?: it}.filter{it!="Без игровых событий"}
        val slot=p.optJSONObject("inputs")?.optJSONObject("derived")?.let{if(it.isNull("life_slot"))null else it.optInt("life_slot",-1).takeIf{h->h in 0..23}}
        return WallpaperCondition(code("season"),code("time"),code("weather"),code("moon"),state=p.optString("id"),events=(events+listOfNotNull(slot?.let{"Бытовая сцена · час $it"})).joinToString(" · "))
    }
    private val game=mapOf("game.neutral" to "Без игровых событий","game.playing" to "Игра идёт","game.achievement" to "Достижение","game.rare_achievement" to "Редкое достижение","game.beaten" to "Игра пройдена","game.completed" to "Игра завершена","game.mastered" to "Мастерство","game.rank_drop" to "Снижение позиции","game.record" to "Рекорд","game.new_game" to "Новая игра","game.new_recommendation" to "Новая рекомендация","game.new_backlog" to "Новая игра в планах")
    fun details(p: JSONObject): String {
        val reason=when(p.optJSONObject("life")?.optString("reason")){"first_build"->"Первый кадр темы";"base_changed"->"Сцена изменилась — бытовое действие отложено";"hour_blocked"->"Бытовое действие отложено до следующего часа";else->""}
        return listOf(condition(p).label(),reason).filter{it.isNotBlank()}.joinToString(" · ")
    }
    fun refresh(repo: Repository,c: JSONObject,s: Selection,force: Boolean=false,now: Long=System.currentTimeMillis(),
        json: (String)->JSONObject={JSONObject(String(Net.json(SITE+it+"?v="+System.currentTimeMillis(),5000000),Charsets.UTF_8))},
        fetch: (ImageFile,File)->Unit={f,path->fetchImage(f,path)},stopped: ()->Boolean={false}): Boolean = synchronized(locks.getOrPut(scope(c,s)){Any()}){
        if(!force && !due(repo,c,s,now))return@synchronized false
        val key=scope(c,s)
        try{
            var saved=false
            for(attempt in 0..1){
                if(stopped())return@synchronized false
                try{
                    val top=json(c.getString("current_url"));val device=device(c,s)
                    requireView(top.optInt("schema")==1 && top.optString("type")=="dynamic" && top.optString("collection_id")==c.getString("id"),"Неверная публикация динамической темы")
                    requireView(top.optJSONObject("format_status")?.optJSONObject(device)?.optString("status")=="ready","Сервер ещё не опубликовал готовый кадр для телефона. Сохранены последние обои.")
                    val stateUrl=top.getJSONObject("states").getString(device)
                    requireView(JsonBody.endpoint(stateUrl,prefix(c,s)+"current.json"),"Неверный адрес состояния телефона")
                    val p=state(json(stateUrl),c,s);val f=image(p,c,s)
                    val advertised=top.getJSONObject("files").getJSONObject(device)
                    if(advertised.optString("sha256")!=f.sha256)throw PublishedAssetChanged("Сервер обновляет динамический кадр")
                    requireView(Weather.time(p.optString("at"))<=now+60000 && Weather.time(p.optString("valid_until"))>now,"Обновление динамического кадра задерживается. Сохранены последние обои.")
                    val dest=path(repo,f)
                    if(!validImage(dest,f))fetch(f,dest)
                    requireView(validImage(dest,f),"Не удалось проверить динамический кадр")
                    if(stopped())return@synchronized false
                    val wrapper=JSONObject().put("collection",descriptor(c)).put("state",p).toString().toByteArray()
                    synchronized(storageLock){
                        Net.atomic(File(repo.root,"dynamic-history/"+p.getString("id")+".json"),wrapper)
                        Net.atomic(current(repo,c,s),wrapper)
                    }
                    repo.put("dynamic_message_"+key,"");repo.putNumber("dynamic_checked_"+key,now)
                    repo.putNumber("dynamic_next_"+key,minOf(now+3600000,maxOf(now+60000,Weather.time(p.getString("valid_until")))))
                    saved=true;break
                }catch(e: PublishedAssetChanged){if(attempt==1)throw e}
            }
            try{synchronized(storageLock){prune(repo)}}catch(ignored: Exception){};saved
        }catch(e: Exception){repo.put("dynamic_message_"+key,UiErrors.message(e));repo.putNumber("dynamic_checked_"+key,now);repo.putNumber("dynamic_next_"+key,now+300000);throw e}
    }
    fun history(repo: Repository,c: JSONObject,s: Selection): List<JSONObject> = File(repo.root,"dynamic-history").listFiles()?.filter{it.extension=="json"}?.sortedByDescending{it.lastModified()}?.mapNotNull{file->try{
        requireView(file.length() in 1..5000000,"Повреждённое описание");val p=JSONObject(file.readText()).getJSONObject("state")
        if(p.optString("theme_id")==c.getString("id") && p.optString("device")==device(c,s))state(p,c,s) else null
    }catch(e: Exception){null}}.orEmpty()
    private fun prune(repo: Repository){
        // A small client cache, independent of the server's JSON-only history archive.
        val pinned=setOf(repo.text("hash_1"),repo.text("hash_2"));val keep=pinned.toMutableSet();val described=mutableSetOf<String>();var bytes=0L;var count=0
        File(repo.root,"dynamic-history").listFiles()?.filter{it.extension=="json"}?.sortedByDescending{it.lastModified()}?.forEach{file->try{
            val p=JSONObject(file.readText()).getJSONObject("state");val sha=p.getJSONObject("image").getString("sha256");val size=File(repo.root,"dynamic-images/$sha.jpg").length()
            if(count==0 || sha in pinned && sha !in described || count<24 && (sha in keep || bytes+size<=64000000)){if(sha !in keep)bytes+=size;keep.add(sha);described.add(sha);count++}else file.delete()
        }catch(e: Exception){file.delete()}}
        File(repo.root,"dynamic").walkTopDown().maxDepth(4).filter{it.isFile && it.name=="current.json"}.forEach{file->try{if(JSONObject(file.readText()).getJSONObject("state").getJSONObject("image").getString("sha256") !in keep){file.delete();val key=file.parentFile.relativeTo(File(repo.root,"dynamic")).invariantSeparatorsPath;repo.putNumber("dynamic_next_"+key,0);repo.putNumber("dynamic_checked_"+key,0)}}catch(e: Exception){file.delete()}}
        File(repo.root,"dynamic-images").listFiles()?.filter{it.extension=="jpg" && it.nameWithoutExtension !in keep && it.lastModified()<System.currentTimeMillis()-300000}?.forEach{it.delete()}
    }
}

class DynamicRefreshWorker(context: Context,parameters: WorkerParameters): Worker(context,parameters){
    override fun doWork(): Result {
        val repo=Repository(applicationContext)
        return try{
            val c=JSONObject(inputData.getString("collection") ?: return Result.failure());Dynamic.validateCollection(c)
            val s=Selection.parse(JSONObject(inputData.getString("selection") ?: return Result.failure()))
            requireView(s.source=="dynamic" && s.collection==c.getString("id"),"Неверные настройки динамической темы")
            Dynamic.refresh(repo,c,s,inputData.getBoolean("force",false) && runAttemptCount==0,stopped={isStopped})
            Schedule.now(applicationContext,false);Result.success()
        }catch(e: Exception){Result.retry()}
        finally{Schedule.configure(applicationContext)}
    }
}
