package ru.oopssre.imperialschool.views

import android.app.DownloadManager
import android.content.Context
import android.graphics.BitmapFactory
import android.net.Uri
import android.os.Environment
import org.json.JSONObject
import java.io.File
import java.io.InputStream
import java.net.HttpURLConnection
import java.net.URL
import java.nio.file.Files
import java.nio.file.StandardCopyOption
import java.security.MessageDigest
import java.util.UUID
import java.util.zip.ZipFile
import androidx.work.*

internal fun Repository.weatherCollection(data: Catalogue,s: Selection)=if(DailyWeather.active(s))DailyWeather.collection() else data.collections.firstOrNull{it.id==s.collection}?.weather ?: error("Погодная коллекция недоступна")
internal fun weatherScope(c: JSONObject,s: Selection)=c.getString("id")+"/"+s.weatherSource+"/"+(if(LocalWeather.active(s))LocalWeather.key(s)+"/" else "")+Weather.format(c,s)
internal fun Repository.weatherPair(c: JSONObject,s: Selection): JSONObject?=try{JSONObject(File(root,"weather/"+weatherScope(c,s)+".json").readText())}catch(e: Exception){null}
internal fun Repository.storePair(c: JSONObject,s: Selection,p: JSONObject,f: JSONObject)=Net.atomic(File(root,"weather/"+weatherScope(c,s)+".json"),JSONObject().put("current",p).put("forecast",f).toString().toByteArray())
internal fun Repository.weatherPath(f: ImageFile)=File(root,"weather-images/"+f.sha256+".jpg")
internal fun validImage(path: File,f: ImageFile): Boolean=try{
    if(!path.isFile || path.length()!=f.bytes || Net.sha(path)!=f.sha256)false else {
        val o=BitmapFactory.Options().apply{inJustDecodeBounds=true};BitmapFactory.decodeFile(path.path,o);o.outWidth==f.width && o.outHeight==f.height
    }
}catch(e: Exception){false}
internal class PublishedAssetChanged(message: String): java.io.IOException(message)
internal fun writeImage(input: InputStream,path: File,f: ImageFile) {
    path.parentFile!!.mkdirs();val part=File(path.parentFile,"."+UUID.randomUUID()+".part")
    try {
        var count=0L;part.outputStream().use { out -> val buffer=ByteArray(65536);while(true){val n=input.read(buffer);if(n<0)break;count+=n;if(count>f.bytes)throw PublishedAssetChanged("Изображение по постоянному URL изменилось");out.write(buffer,0,n)};out.fd.sync() }
        if(!validImage(part,f))throw PublishedAssetChanged("Размер, SHA-256 или разрешение изображения не совпадает")
        Files.move(part.toPath(),path.toPath(),StandardCopyOption.REPLACE_EXISTING,StandardCopyOption.ATOMIC_MOVE)
    }finally{part.delete()}
}
internal fun fetchImage(f: ImageFile,path: File): File {
    if(validImage(path,f))return path
    var address=URL(Weather.imageURL(f))
    repeat(4){
        requireView(address.protocol=="https" && address.host=="games.oopssre.ru" && address.userInfo==null && address.port in listOf(-1,443),"Неверный адрес изображения")
        val connection=address.openConnection() as HttpURLConnection;connection.connectTimeout=10000;connection.readTimeout=30000;connection.instanceFollowRedirects=false
        try {
            if(connection.responseCode in 300..399)address=URL(address,connection.getHeaderField("Location") ?: error("Нет адреса"))
            else{if(connection.responseCode in listOf(404,410))throw PublishedAssetChanged("Погодный файл на сервере обновлён");requireView(connection.responseCode in 200..299,"Не удалось скачать изображение");connection.inputStream.use{writeImage(it,path,f)};return path}
        }finally{connection.disconnect()}
    };error("Слишком много перенаправлений")
}
internal fun Repository.cachedScene(scene: Scene,s: Selection): File? {
    val f=scene.phone();val path=if(online(s))File(root,"online/"+f.sha256+".jpg") else File(root,f.url)
    return path.takeIf{validImage(it,f)}
}
internal object Archive {
    private val lock=Any()
    private fun manager(repo: Repository)=repo.context.getSystemService(DownloadManager::class.java)
    private fun key(c: JSONObject,format: String)="zip_descriptor_"+c.getString("id")+"_"+format
    private fun jobPath(repo: Repository,hash: String)=File(repo.root,"downloads/"+hash+".json")
    fun ensure(repo: Repository,data: Catalogue,c: JSONObject,s: Selection,version: String,force: Boolean=false)=synchronized(lock){
        if(s.weatherDelivery!="zip")return@synchronized
        val format=Weather.format(c,s);val now=System.currentTimeMillis();val k=key(c,format)
        val old=try{JSONObject(repo.text(k))}catch(e: Exception){null}
        val descriptor=if(old!=null && !force && old.optString("version")==version && now-old.optLong("checked_at") in 0 until 86400000)old else Weather.descriptor(data,c,format).also{it.put("checked_at",now);repo.put(k,it.toString())}
        requireView(descriptor.getString("version")==version,"Версия ZIP изменилась. Обновляю каталог.")
        val hash=descriptor.getString("sha256");val receipt=File(repo.root,"weather-packages/"+hash+".json")
        if(receipt.isFile && JSONObject(receipt.readText()).optString("version")==version)return@synchronized
        val file=jobPath(repo,hash);var previous=try{JSONObject(file.readText())}catch(e: Exception){null}
        if(previous?.optString("stage")=="ready" && !receipt.isFile){file.delete();previous=null}
        if(previous?.optString("stage")=="cancelled"){
            if(!force)return@synchronized
            file.delete();previous=null
        }
        if(previous!=null){
            val observed=progress(repo,c,s)
            if(observed.optString("stage")=="error" && previous.optString("stage")=="downloading"){previous=observed.put("updated_at",now);Net.atomic(file,previous.toString().toByteArray())}
            if(previous.optString("stage")=="error" && force){manager(repo).remove(previous.optLong("download_id"));file.delete()}
            else {if(progress(repo,c,s).optString("stage")=="downloaded")verify(repo,hash);return@synchronized}
        }
        val destination=File(repo.context.getExternalFilesDir(Environment.DIRECTORY_DOWNLOADS),hash+".zip");destination.parentFile!!.mkdirs();destination.delete()
        val request=DownloadRequests.allowNetworks(DownloadManager.Request(Uri.parse(SITE+descriptor.getString("url")+"?v="+hash)),DownloadRequests.policy(repo)).setTitle("Обои · "+c.getString("title"))
            .setDescription("Пакет погодных кадров для телефона").setNotificationVisibility(DownloadManager.Request.VISIBILITY_VISIBLE_NOTIFY_COMPLETED)
            .setDestinationInExternalFilesDir(repo.context,Environment.DIRECTORY_DOWNLOADS,hash+".zip")
        val id=manager(repo).enqueue(request)
        val job=JSONObject().put("download_id",id).put("collection",c).put("format",format).put("version",version).put("archive",descriptor).put("path",destination.path).put("stage","downloading").put("network_policy",DownloadRequests.policy(repo)).put("updated_at",now)
        Net.atomic(file,job.toString().toByteArray())
    }
    fun verify(repo: Repository,hash: String){WorkManager.getInstance(repo.context).enqueueUniqueWork("package-"+hash,ExistingWorkPolicy.KEEP,OneTimeWorkRequestBuilder<PackageWorker>().setInputData(workDataOf("hash" to hash)).build())}
    fun completed(context: Context,id: Long) {
        val repo=Repository(context);File(repo.root,"downloads").listFiles()?.filter{it.extension=="json"}?.forEach{f->try{val j=JSONObject(f.readText());if(j.optLong("download_id")==id && j.optString("stage")!="ready"){
                manager(repo).query(DownloadManager.Query().setFilterById(id))?.use{cursor->if(cursor.moveToFirst() && cursor.getInt(cursor.getColumnIndexOrThrow(DownloadManager.COLUMN_STATUS))==DownloadManager.STATUS_SUCCESSFUL)verify(repo,j.getJSONObject("archive").getString("sha256"))}
            }}catch(ignored: Exception){}}
    }
    fun progress(repo: Repository,c: JSONObject,s: Selection): JSONObject {
        val descriptor=try{JSONObject(repo.text(key(c,Weather.format(c,s))))}catch(e: Exception){return JSONObject()}
        val receipt=File(repo.root,"weather-packages/"+descriptor.getString("sha256")+".json")
        val job=try{JSONObject(jobPath(repo,descriptor.getString("sha256")).readText())}catch(e: Exception){return if(receipt.isFile)JSONObject().put("stage","ready") else JSONObject()}
        if(job.optString("stage")=="ready" && !receipt.isFile)return JSONObject().put("stage","error").put("message","Архив ещё не подготовлен. Нажмите «Повторить загрузку ZIP».")
        if(job.optString("stage")=="ready"){
            val expected=repo.weatherPair(c,s)?.optJSONObject("forecast")?.let{Weather.packageVersion(it)}
            if(!expected.isNullOrBlank() && job.optString("version")!=expected)job.put("stage","outdated").put("message","ZIP другой версии. Используется проверенный текущий JPEG.")
        }
        if(job.optString("stage") !in listOf("downloading","downloaded"))return job
        manager(repo).query(DownloadManager.Query().setFilterById(job.getLong("download_id")))?.use { cursor ->
            if(cursor.moveToFirst()){
                val status=cursor.getInt(cursor.getColumnIndexOrThrow(DownloadManager.COLUMN_STATUS))
                val bytes=cursor.getLong(cursor.getColumnIndexOrThrow(DownloadManager.COLUMN_BYTES_DOWNLOADED_SO_FAR))
                val actualTotal=cursor.getLong(cursor.getColumnIndexOrThrow(DownloadManager.COLUMN_TOTAL_SIZE_BYTES))
                job.put("received",bytes).put("total",if(actualTotal>0)actualTotal else descriptor.getLong("bytes"))
                job.put("transfer_status",status)
                when(status){DownloadManager.STATUS_SUCCESSFUL->{job.put("stage","downloaded");verify(repo,descriptor.getString("sha256"))};DownloadManager.STATUS_FAILED->job.put("stage","error").put("message",UiErrors.download(cursor.getInt(cursor.getColumnIndexOrThrow(DownloadManager.COLUMN_REASON))));DownloadManager.STATUS_PAUSED->job.put("message",when(cursor.getInt(cursor.getColumnIndexOrThrow(DownloadManager.COLUMN_REASON))){DownloadManager.PAUSED_QUEUED_FOR_WIFI->if(DownloadRequests.policy(repo)=="wifi")"Ожидание Wi-Fi" else "Android ограничил мобильную загрузку. Проверьте ограничения трафика.";DownloadManager.PAUSED_WAITING_TO_RETRY->"Android повторит загрузку ZIP";DownloadManager.PAUSED_WAITING_FOR_NETWORK->"Ожидаю сеть для ZIP";else->"Android приостановил загрузку ZIP"});DownloadManager.STATUS_PENDING->job.put("message","Ожидаю начала загрузки ZIP");else->job.put("message","Скачиваю ZIP")}
            }else job.put("stage","error").put("message","Загрузка ZIP отменена. Нажмите «Обновить сейчас».")
        };return job
    }
    fun cancel(repo: Repository,c: JSONObject,s: Selection)=synchronized(lock){
        val descriptor=JSONObject(repo.text(key(c,Weather.format(c,s))))
        val file=jobPath(repo,descriptor.getString("sha256"));val job=JSONObject(file.readText())
        if(job.optString("stage")!="downloading")return@synchronized
        manager(repo).remove(job.getLong("download_id"))
        job.put("stage","cancelled").put("message","Загрузка отменена. Текущие обои сохранены.")
        Net.atomic(file,job.toString().toByteArray())
    }

}
class PackageWorker(context: Context,parameters: WorkerParameters): Worker(context,parameters) {
    override fun doWork(): Result {
        val repo=Repository(applicationContext);val hash=inputData.getString("hash").orEmpty()
        if(!Regex("[a-f0-9]{64}").matches(hash))return Result.failure()
        val path=File(repo.root,"downloads/"+hash+".json");val job=try{JSONObject(path.readText())}catch(e: Exception){return Result.failure()}
        if(job.optString("stage")=="cancelled")return Result.success()
        fun state(stage: String,message: String="",done: Int=0,total: Int=0){job.put("stage",stage).put("message",message).put("completed",done).put("count",total).put("updated_at",System.currentTimeMillis());Net.atomic(path,job.toString().toByteArray())}
        try{
            val file=File(job.getString("path"));val archive=job.getJSONObject("archive")
            requireView(file.isFile,"ZIP отсутствует. Повторите загрузку.")
            state("verifying","Проверяю ZIP");requireView(Net.sha(file)==hash,"SHA-256 ZIP не совпадает")
            ZipFile(file).use { zip ->
                val names=zip.entries().asSequence().map{it.name}.toList();requireView(names.distinct().size==names.size && names.size<=8010,"Неверный состав ZIP")
                val manifest=zip.getEntry("manifest.json") ?: error("В ZIP нет манифеста");requireView(manifest.size in 1..5000000,"Неверный манифест ZIP")
                val p=JSONObject(zip.getInputStream(manifest).use{String(Net.bounded(it,5000000),Charsets.UTF_8)})
                val rows=Weather.packageManifest(p,job.getJSONObject("collection"),job.getString("format"),job.getString("version"))
                val allowed=rows.map{it.getString("url")}.toSet()+setOf("manifest.json","weather-package.json","README.txt","files/")
                requireView(names.all{it in allowed} && rows.sumOf{it.getLong("bytes")}<=8589934592,"Посторонние файлы в ZIP")
                rows.forEachIndexed { i,v ->
                    if(isStopped)throw java.io.IOException("Подготовка ZIP остановлена")
                    if(i%5==0)state("unpacking","Проверяю и сохраняю кадры",i,rows.size)
                    val f=ImageFile(v.getString("url"),v.getInt("width"),v.getInt("height"),v.getLong("bytes"),v.getString("sha256"));val dest=repo.weatherPath(f)
                    if(!validImage(dest,f)){val entry=zip.getEntry(f.url) ?: error("Нет файла ZIP");requireView(entry.size==f.bytes,"Неверный размер файла ZIP");zip.getInputStream(entry).use{writeImage(it,dest,f)}}
                }
                Net.atomic(File(repo.root,"weather-packages/"+hash+".json"),p.put("client_api","1.7").toString().toByteArray())
            }
            state("ready","ZIP готов");WeatherCache.prune(repo);applicationContext.getSystemService(DownloadManager::class.java).remove(job.getLong("download_id"));Schedule.now(applicationContext,false);return Result.success()
        }catch(e: Exception){applicationContext.getSystemService(DownloadManager::class.java).remove(job.optLong("download_id",-1));repo.put("weather_refresh_"+job.getJSONObject("collection").getString("id"),"1");repo.putNumber("catalogue_checked",0);state("error",UiErrors.message(e));Schedule.refresh(applicationContext,false);return Result.failure()}
    }
}
