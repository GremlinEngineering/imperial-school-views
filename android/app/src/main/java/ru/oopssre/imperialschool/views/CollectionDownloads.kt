package ru.oopssre.imperialschool.views

import android.app.DownloadManager
import android.content.Context
import android.net.Uri
import android.os.Environment
import androidx.work.*
import org.json.JSONObject
import java.io.File

internal data class CollectionArchive(val collection: String,val title: String,val url: String,val bytes: Long,val sha256: String) {
    fun json()=JSONObject().put("collection",collection).put("title",title).put("url",url).put("bytes",bytes).put("sha256",sha256)
    companion object {
        fun find(data: Catalogue,id: String): CollectionArchive? {
            val collection=data.collections.firstOrNull{it.id==id && it.weather==null && it.dynamic==null} ?: return null
            val rows=data.downloads.filter{it.optString("id")=="collection-"+id || it.optString("collection")==id && it.optString("format")=="zip"}
            if(rows.isEmpty())return null
            requireView(rows.size==1,"Неоднозначный ZIP коллекции")
            val row=rows.single();val url=row.getString("url");val bytes=row.getLong("bytes");val hash=row.getString("sha256")
            requireView(packId.matches(id) && Regex("downloads/[a-zA-Z0-9._-]+\\.zip").matches(url) && bytes in 1..1000000000 && Regex("[a-f0-9]{64}").matches(hash),"Неверное описание ZIP коллекции")
            return CollectionArchive(id,collection.title,url,bytes,hash)
        }
    }
}

internal object CollectionDownloads {
    private val lock=Any()
    private fun path(repo: Repository,id: String)=File(repo.root,"collection-downloads/"+id+".json")
    private fun manager(repo: Repository)=repo.context.getSystemService(DownloadManager::class.java)
    fun progress(repo: Repository,id: String): JSONObject {
        if(!packId.matches(id))return JSONObject()
        val job=try{JSONObject(path(repo,id).readText())}catch(e: Exception){return JSONObject()}
        if(job.optString("stage")=="ready" && !File(repo.root,"collections/"+id+"/manifest.json").isFile)job.put("stage","error").put("message","Сохранённый пакет отсутствует. Скачайте его снова.")
        if(job.optString("stage")!="downloading")return job
        manager(repo).query(DownloadManager.Query().setFilterById(job.getLong("download_id")))?.use{cursor->
            if(!cursor.moveToFirst()){job.put("stage","error").put("message","Загрузка отменена. Можно скачать снова.");return@use}
            job.put("received",cursor.getLong(cursor.getColumnIndexOrThrow(DownloadManager.COLUMN_BYTES_DOWNLOADED_SO_FAR)))
            val actualTotal=cursor.getLong(cursor.getColumnIndexOrThrow(DownloadManager.COLUMN_TOTAL_SIZE_BYTES))
            if(actualTotal>0)job.put("total",actualTotal)
            val status=cursor.getInt(cursor.getColumnIndexOrThrow(DownloadManager.COLUMN_STATUS));job.put("transfer_status",status)
            when(status){
                DownloadManager.STATUS_SUCCESSFUL->{job.put("stage","downloaded");verify(repo,id)}
                DownloadManager.STATUS_FAILED->job.put("stage","error").put("message",UiErrors.download(cursor.getInt(cursor.getColumnIndexOrThrow(DownloadManager.COLUMN_REASON))))
                DownloadManager.STATUS_PAUSED->job.put("message",when(cursor.getInt(cursor.getColumnIndexOrThrow(DownloadManager.COLUMN_REASON))){DownloadManager.PAUSED_QUEUED_FOR_WIFI->if(DownloadRequests.policy(repo)=="wifi")"Ожидание Wi-Fi" else "Android ограничил мобильную загрузку. Проверьте ограничения трафика.";DownloadManager.PAUSED_WAITING_TO_RETRY->"Android повторит загрузку";else->"Ожидаю сеть"})
                DownloadManager.STATUS_PENDING->job.put("message","Ожидаю начала загрузки")
                else->job.put("message","Скачиваю пакет")
            }
        }
        return job
    }
    fun start(repo: Repository,archive: CollectionArchive)=synchronized(lock){
        val previous=progress(repo,archive.collection)
        if(previous.optString("sha256")==archive.sha256 && previous.optString("stage") in listOf("downloading","downloaded","verifying","ready") && (previous.optString("stage")!="ready" || File(repo.root,"collections/"+archive.collection+"/manifest.json").isFile))return@synchronized
        val work=WorkManager.getInstance(repo.context);work.cancelUniqueWork("collection-package-"+archive.collection)
        if(previous.has("download_id"))manager(repo).remove(previous.getLong("download_id"))
        val name="collection-"+archive.sha256+".zip"
        val destination=File(repo.context.getExternalFilesDir(Environment.DIRECTORY_DOWNLOADS),name);destination.parentFile!!.mkdirs();destination.delete()
        val request=DownloadRequests.allowNetworks(DownloadManager.Request(Uri.parse(SITE+archive.url+"?v="+archive.sha256)),DownloadRequests.policy(repo)).setTitle("Обои · "+archive.title).setDescription("Обычная коллекция для работы без интернета")
            .setNotificationVisibility(DownloadManager.Request.VISIBILITY_VISIBLE_NOTIFY_COMPLETED)
            .setDestinationInExternalFilesDir(repo.context,Environment.DIRECTORY_DOWNLOADS,name)
        val job=archive.json().put("download_id",manager(repo).enqueue(request)).put("path",destination.path).put("stage","downloading").put("network_policy",DownloadRequests.policy(repo)).put("total",archive.bytes)
        Net.atomic(path(repo,archive.collection),job.toString().toByteArray())
    }
    fun cancel(repo: Repository,id: String)=synchronized(lock){
        val job=JSONObject(path(repo,id).readText())
        if(job.optString("stage")!="downloading")return@synchronized
        manager(repo).remove(job.getLong("download_id"));job.put("stage","cancelled").put("message","Загрузка отменена. Можно скачать снова.")
        Net.atomic(path(repo,id),job.toString().toByteArray())
    }
    private fun verify(repo: Repository,id: String){WorkManager.getInstance(repo.context).enqueueUniqueWork("collection-package-"+id,ExistingWorkPolicy.KEEP,OneTimeWorkRequestBuilder<CollectionPackageWorker>().setInputData(workDataOf("collection" to id)).build())}
    fun completed(context: Context,id: Long){val repo=Repository(context);File(repo.root,"collection-downloads").listFiles()?.forEach{file->try{val job=JSONObject(file.readText());if(job.optLong("download_id")==id && job.optString("stage")=="downloading")progress(repo,job.getString("collection"))}catch(ignored: Exception){}}}
    fun unpack(repo: Repository,id: String,stopped: ()->Boolean){
        requireView(packId.matches(id),"Неверная коллекция")
        // Serialize a replacement request against installation of the previous download.
        synchronized(lock){
            val p=path(repo,id);val job=JSONObject(p.readText())
            fun state(stage: String,message: String){job.put("stage",stage).put("message",message);Net.atomic(p,job.toString().toByteArray())}
            if(job.optString("stage")=="cancelled")return
            try{
                requireView(!stopped(),"Подготовка пакета остановлена")
                state("verifying","Проверяю ZIP и сохраняю коллекцию…")
                val file=File(job.getString("path"));requireView(file.isFile,"ZIP отсутствует. Повторите загрузку.")
                requireView(Net.sha(file)==job.getString("sha256"),"SHA-256 ZIP не совпадает. Обновите список и скачайте ZIP заново.")
                requireView(!stopped(),"Подготовка пакета остановлена")
                repo.importZip({file.inputStream()},id)
                state("ready","Пакет сохранён. Можно выбрать его для работы без интернета.")
                manager(repo).remove(job.getLong("download_id"))
            }catch(e: Exception){state("error",UiErrors.message(e));repo.putNumber("catalogue_checked",0);Schedule.refresh(repo.context,false);throw e}
        }
    }
}
class CollectionPackageWorker(context: Context,parameters: WorkerParameters): Worker(context,parameters){
    override fun doWork(): Result=try{CollectionDownloads.unpack(Repository(applicationContext),inputData.getString("collection").orEmpty()){isStopped};Result.success()}catch(e: Exception){Result.failure()}
}
