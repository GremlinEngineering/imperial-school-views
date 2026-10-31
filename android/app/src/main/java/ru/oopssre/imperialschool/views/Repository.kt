package ru.oopssre.imperialschool.views

import android.content.Context
import android.net.Uri
import android.graphics.BitmapFactory
import org.json.JSONObject
import java.io.File
import java.io.InputStream
import java.net.HttpURLConnection
import java.net.URL
import java.security.MessageDigest
import java.util.UUID
import java.util.zip.ZipInputStream

internal object Net {
    fun json(url: String,limit: Long): ByteArray = get(url,limit,true)
    fun get(url: String, limit: Long,json: Boolean=false): ByteArray {
        var address=URL(url)
        repeat(4) {
            requireView(address.protocol=="https" && address.host=="games.oopssre.ru" && address.userInfo==null && (address.port==-1 || address.port==443),"Неверный адрес загрузки")
            val connection=address.openConnection() as HttpURLConnection
            connection.connectTimeout=10000; connection.readTimeout=30000; connection.instanceFollowRedirects=false
            if(json)JsonBody.configure(connection)
            try {
                val status=connection.responseCode
                if(status in 300..399) { address=URL(address,connection.getHeaderField("Location") ?: error("Нет адреса перенаправления")) }
                else {
                    requireView(status in 200..299,"Сайт недоступен ($status)")
                    requireView(connection.contentLengthLong<=limit,"Файл слишком большой")
                    return connection.inputStream.use { if(json)JsonBody.read(it,connection.getHeaderField("Content-Encoding"),address.toString(),limit) else bounded(it,limit) }
                }
            } finally { connection.disconnect() }
        }
        error("Слишком много перенаправлений")
    }
    fun bounded(input: InputStream, limit: Long): ByteArray {
        val out=java.io.ByteArrayOutputStream(); val buffer=ByteArray(32768);var count=0L
        while(true) { val n=input.read(buffer);if(n<0)break;count+=n;requireView(count<=limit,"Файл слишком большой");out.write(buffer,0,n) }
        return out.toByteArray()
    }
    fun sha(file: File): String { val digest=MessageDigest.getInstance("SHA-256");file.inputStream().use { input -> val b=ByteArray(65536);while(true){val n=input.read(b);if(n<0)break;digest.update(b,0,n)} };return digest.digest().joinToString(""){"%02x".format(it)} }
    fun atomic(file: File, bytes: ByteArray) { file.parentFile!!.mkdirs();val part=File(file.parentFile,".${file.name}.${UUID.randomUUID()}.part");try { part.outputStream().use { it.write(bytes);it.fd.sync() }; java.nio.file.Files.move(part.toPath(),file.toPath(),java.nio.file.StandardCopyOption.REPLACE_EXISTING,java.nio.file.StandardCopyOption.ATOMIC_MOVE) } finally { part.delete() } }
}
internal class Repository(val context: Context) {
    val root=File(context.filesDir,"views").apply { mkdirs() }
    private val prefs=context.getSharedPreferences("views",Context.MODE_PRIVATE)
    init { synchronized(prefsLock){
        if(prefs.getString("weather_api",null)!="1.7"){
            // Preserve screen profiles, imported collections and verified JPEG bytes.
            File(root,"catalogue.json").delete()
            File(root,"weather").deleteRecursively()
            File(root,"downloads").listFiles()?.forEach{f->try{val job=JSONObject(f.readText());context.getSystemService(android.app.DownloadManager::class.java).remove(job.optLong("download_id",-1))}catch(ignored: Exception){}}
            File(root,"downloads").deleteRecursively()
            val edit=prefs.edit().putString("weather_api","1.7").remove("catalogue_checked").remove("weather_verified_api")
            prefs.all.keys.filter{it.startsWith("zip_descriptor_") || it.startsWith("weather_message_")}.forEach{edit.remove(it)};edit.commit()
        }
    } }
    private fun profiles()=Profiles(prefs.getString("profile_home",null)?.let{Selection.parse(JSONObject(it))},prefs.getString("profile_lock",null)?.let{Selection.parse(JSONObject(it))},prefs.getBoolean("profiles_linked",false))
    fun editingTarget()=prefs.getString("editing_target","both")!!
    fun editTarget(target: String){requireView(target in listOf("home","lock","both"),"Неверный экран");put("editing_target",target)}
    private fun migrate() {
        if(!prefs.getBoolean("configured",false) || prefs.contains("profiles_migrated"))return
        val old=Selection(prefs.getString("source","day")!!,prefs.getString("collection","")!!,prefs.getString("mode","featured")!!,prefs.getString("target","both")!!,prefs.getBoolean("paused",false),prefs.getBoolean("notify_collections",true),prefs.getBoolean("notify_app",true),revision=UUID.randomUUID().toString())
        val migrated=Profiles.migrate(old);val edit=prefs.edit().putBoolean("profiles_migrated",true).putBoolean("profiles_linked",migrated.linked).putString("editing_target",old.target)
        migrated.home?.let{edit.putString("profile_home",it.json().toString())};migrated.lock?.let{edit.putString("profile_lock",it.json().toString())};edit.commit()

    }
    fun settings(target: String?=null): Selection = synchronized(prefsLock) {
        migrate();profiles().select(target ?: editingTarget())
    }
    fun installed(): Boolean = synchronized(prefsLock){migrate();prefs.contains("profile_home") || prefs.contains("profile_lock")}
    fun savedProfiles(): Profiles = synchronized(prefsLock){migrate();profiles()}
    fun stopManaging(target: String)=synchronized(prefsLock){
        requireView(target in listOf("home","lock","both"),"Неверный экран")
        migrate();val next=profiles().without(target);val edit=prefs.edit().putBoolean("profiles_linked",false)
        listOf("home" to next.home,"lock" to next.lock).forEach{(name,s)->if(s==null)edit.remove("profile_"+name).remove("manual_"+name).putString("status_"+name,"Приложение не меняет обои этого экрана.") else edit.putString("profile_"+name,s.json().toString())};edit.commit()
    }
    fun activeTargets(): List<String> = synchronized(prefsLock){migrate();profiles().activeTargets()}
    fun targets(s: Selection): List<String> = synchronized(prefsLock){profiles().targets(s)}
    fun save(s: Selection) = synchronized(prefsLock) {
        requireView(s.source in listOf("day","online","weather","dynamic","local") && s.target in listOf("home","lock","both") && s.weatherSource in listOf("real","game-world","open-meteo") && s.weatherDelivery in listOf("zip","images"),"Неверные настройки")
        if(DailyWeather.active(s))requireView(s.weatherSource in listOf("real","game-world"),"Выберите серверный источник погоды дня")
        if(LocalWeather.active(s)){LocalWeather.city(s);requireView(s.weatherDelivery=="zip","Для Open-Meteo нужен ZIP коллекции")}
        migrate();val revision=UUID.randomUUID().toString();val next=profiles().apply(if(DailyWeather.active(s))s.copy(weatherDelivery="images") else s,revision);val edit=prefs.edit().putBoolean("profiles_migrated",true).putBoolean("profiles_linked",next.linked).putString("editing_target",s.target).putBoolean("configured",true)
        next.home?.let{edit.putString("profile_home",it.json().toString())};next.lock?.let{edit.putString("profile_lock",it.json().toString())}
        (if(s.target=="both")listOf("home","lock") else listOf(s.target)).forEach{target->edit.putString("manual_"+target,revision)};edit.commit()
    }
    fun setPaused(target: String,paused: Boolean)=synchronized(prefsLock){
        migrate();val next=profiles().pause(target,paused,UUID.randomUUID().toString());val edit=prefs.edit().putBoolean("profiles_linked",next.linked)
        next.home?.let{edit.putString("profile_home",it.json().toString())};next.lock?.let{edit.putString("profile_lock",it.json().toString())}
        (if(target=="both")listOf("home","lock") else listOf(target)).forEach{edit.putString("status_"+it,if(paused)"Смена обоев приостановлена." else "Продолжаю смену обоев…")};edit.commit()
    }

    fun requestManual(target: String){val edit=prefs.edit();(if(target=="both")listOf("home","lock") else listOf(target)).forEach{edit.putString("manual_"+it,settings(it).revision)};edit.commit()}
    fun manual(s: Selection)=text("manual_"+s.target)==s.revision && s.revision.isNotBlank()
    fun clearManual(target: String,revision: String){synchronized(prefsLock){if(text("manual_"+target)==revision)prefs.edit().remove("manual_"+target).commit()}}
    fun pauseIfCurrent(expected: Selection)=synchronized(prefsLock){if(settings(expected.target)==expected)setPaused(expected.target,true)}
    fun online(s: Selection)=s.source in listOf("day","online","weather","dynamic")
    fun status(target: String,message: String,revision: String?=null)=synchronized(prefsLock){
        if(revision!=null && settings(target).revision!=revision)return@synchronized
        put("status_"+target,message);put("status",message)
    }
    fun ifCurrent(s: Selection,destinations: List<String>,action: ()->Unit): Boolean=synchronized(prefsLock){
        if(settings(s.target)!=s || targets(s)!=destinations)return@synchronized false
        action();true
    }
    fun catalogue(s: Selection, refresh: Boolean=false): Catalogue {
        if(!online(s))return local() ?: error(text("local_catalogue_error").ifBlank{"Добавьте коллекцию из ZIP"})
        val file=File(root,"catalogue.json")
        if(refresh || !file.isFile) {
            try {
                val bytes=Net.json(SITE+"manifest-v3.json?v="+System.currentTimeMillis(),5000000)
                val next=Catalogue.parse(JSONObject(String(bytes,Charsets.UTF_8)))
                requireView(next.scenes.any { it.files.any { f -> f.height>f.width } } || next.collections.any{it.weather!=null || it.dynamic!=null},"Нет обоев для телефона")
                Net.atomic(file,bytes);put("catalogue_error","");putNumber("catalogue_checked",System.currentTimeMillis());return next
            } catch(e: Exception) { put("catalogue_error",UiErrors.message(e));if(!file.isFile)throw e }
        }
        return Catalogue.parse(JSONObject(file.readText()))
    }
    fun local(): Catalogue? {
        val errors=mutableListOf<String>()
        val packs=File(root,"collections").listFiles()?.filter { it.isDirectory && packId.matches(it.name) }?.sortedBy { it.name }?.mapNotNull { folder ->
            try {
                val path=File(folder,"manifest.json");requireView(path.isFile,"Нет манифеста")
                val json=JSONObject(path.readText());requireView(json.getString("id")==folder.name,"Неверный ID коллекции")
                Catalogue.compose(listOf(json));json
            }catch(e: Exception){errors.add(folder.name);null}
        } ?: emptyList()
        put("local_catalogue_error",if(errors.isEmpty())"" else "Не открылись наборы: "+errors.joinToString(", ")+". Импортируйте их заново."+(if(packs.isNotEmpty())" Исправные наборы доступны." else ""))
        return Catalogue.compose(packs)
    }
    fun image(scene: Scene,s: Selection): File {
        val f=scene.phone();val path=if(online(s))File(root,"online/"+f.sha256+".jpg") else File(root,f.url)
        if(validImage(path,f))return path
        requireView(online(s),"В сохранённой коллекции отсутствует изображение")
        return fetchImage(f,path)
    }
    fun importZip(uri: Uri): String=importZip({context.contentResolver.openInputStream(uri) ?: error("Не удалось открыть ZIP")})
    fun importZip(input: ()->InputStream,expectedCollection: String?=null): String = synchronized(lock) {
        val stage=File(root,"import-${UUID.randomUUID()}").apply { mkdirs() }; var backup: File?=null
        try {
            val names=mutableSetOf<String>();var total=0L
            input().use { raw -> ZipInputStream(raw).use { zip ->
                while(true) {
                    val entry=zip.nextEntry ?: break;val name=entry.name
                    requireView(names.add(name) && names.size<=1000 && Regex("(?:manifest\\.json|README\\.txt|collection\\.md|(?:files|previews)/|(?:files|previews)/[a-z0-9-]+\\.jpg)").matches(name),"Неверное содержимое ZIP")
                    if(!entry.isDirectory) {
                        val file=File(stage,name);file.parentFile!!.mkdirs();var size=0L
                        file.outputStream().use { output -> val bytes=ByteArray(32768);while(true){val n=zip.read(bytes);if(n<0)break;size+=n;total+=n;requireView(size<=100000000 && total<=1000000000,"ZIP слишком большой");output.write(bytes,0,n)} }
                    }
                    zip.closeEntry()
                }
            } }
            val manifest=File(stage,"manifest.json"); requireView(manifest.isFile && manifest.length()<=5000000,"В ZIP нет манифеста коллекции")
            val pack=JSONObject(manifest.readText());val id=pack.getString("id");requireView(packId.matches(id) && pack.optBoolean("enabled",true),"Коллекция отключена или повреждена")
            requireView(expectedCollection==null || id==expectedCollection,"ZIP относится к другой коллекции")
            val data=Catalogue.compose(listOf(pack)) ?: error("Пустая коллекция")
            data.scenes.forEach { scene ->
                scene.phone()
                scene.files.forEach { f -> val file=File(stage,f.url.removePrefix("collections/$id/"));requireView(file.isFile && file.length()==f.bytes && Net.sha(file)==f.sha256,"Повреждён файл коллекции");val o=BitmapFactory.Options().apply{inJustDecodeBounds=true};BitmapFactory.decodeFile(file.path,o);requireView(o.outWidth==f.width && o.outHeight==f.height,"Неверный размер изображения") }
            }
            // Only phone images are retained; the collection keeps its independent manifest.
            val keep=data.scenes.map { it.phone().url.removePrefix("collections/$id/") }.toSet()
            File(stage,"files").listFiles()?.filter { "files/"+it.name !in keep }?.forEach { it.delete() }
            val destination=File(root,"collections/$id");destination.parentFile!!.mkdirs()
            if(destination.exists()) { backup=File(root,"backup-${UUID.randomUUID()}");requireView(destination.renameTo(backup),"Не удалось обновить коллекцию") }
            if(!stage.renameTo(destination)) { backup?.renameTo(destination);error("Не удалось сохранить коллекцию") }
            backup?.deleteRecursively();return@synchronized id
        } finally { stage.deleteRecursively() }
    }
    fun text(key: String, fallback: String="")=prefs.getString(key,fallback)!!
    fun put(key: String,value: String) { prefs.edit().putString(key,value).commit() }
    fun number(key: String)=prefs.getLong(key,0)
    fun putNumber(key: String,value: Long) { prefs.edit().putLong(key,value).commit() }
    fun clearOnlineCache(keep: Set<String>) {
        val files=File(root,"online").listFiles()?.filter { it.extension=="jpg" }?.sortedBy { it.lastModified() } ?: return
        var bytes=files.sumOf { it.length() };var count=files.size
        files.filter { it.name !in keep }.forEach { if(bytes>64000000 || count>64) { val size=it.length();if(it.delete()){bytes-=size;count--} } }
    }
    companion object { val lock=Any();private val prefsLock=Any() }
}
