package ru.oopssre.imperialschool.views

import android.app.DownloadManager
import android.net.Uri
import org.json.JSONObject
import java.io.File

internal object DownloadRequests {
    fun policy(repo: Repository)=repo.text("download_network","any").takeIf{it in listOf("wifi","any")} ?: "any"
    fun allowNetworks(request: DownloadManager.Request,policy: String="any"): DownloadManager.Request =
        request.setAllowedNetworkTypes(if(policy=="wifi")DownloadManager.Request.NETWORK_WIFI else -1)
            .setAllowedOverMetered(policy!="wifi").setAllowedOverRoaming(policy!="wifi")
    data class Migration(val restarted: Int=0,val errors: List<String> = emptyList())
    fun select(repo: Repository,policy: String): Migration {
        requireView(policy in listOf("wifi","any"),"Неверная сеть загрузки")
        repo.put("download_network",policy);return resumeLegacy(repo)
    }

    /** Existing requests keep their original network flags, so replace only legacy queues. */
    fun resumeLegacy(repo: Repository): Migration {
        val errors=mutableListOf<String>();var restarted=0
        repo.put("download_migration_error","")
        val policy=policy(repo)
        val manager=repo.context.getSystemService(DownloadManager::class.java)
        listOf("downloads","collection-downloads").forEach{folder->
            File(repo.root,folder).listFiles()?.filter{it.extension=="json"}?.forEach{file->
                var job: JSONObject?=null;var removed=false
                try {
                    job=JSONObject(file.readText())
                    if(job.optString("stage")!="downloading")return@forEach
                    if(job.optString("network_policy")==policy){if(job.optString("network_error").isNotBlank()){job.remove("network_error");Net.atomic(file,job.toString().toByteArray())};return@forEach}
                    val old=job.getLong("download_id")
                    val status=manager.query(DownloadManager.Query().setFilterById(old))?.use{cursor->if(cursor.moveToFirst())cursor.getInt(cursor.getColumnIndexOrThrow(DownloadManager.COLUMN_STATUS)) else 0}
                    if(status==DownloadManager.STATUS_SUCCESSFUL)return@forEach
                    val archive=job.optJSONObject("archive") ?: job
                    val relative=archive.getString("url")
                    requireView(Regex("downloads/[a-zA-Z0-9._-]+\\.zip").matches(relative),"Неверный адрес ZIP")
                    val destination=File(job.getString("path"))
                    val allowed=File(repo.context.getExternalFilesDir(android.os.Environment.DIRECTORY_DOWNLOADS) ?: error("Хранилище недоступно"),".").canonicalFile
                    requireView(destination.canonicalFile.parentFile==allowed,"Повреждены сведения о загрузке. Скачайте ZIP заново.")
                    requireView(Regex("[a-f0-9]{64}").matches(archive.getString("sha256")),"Повреждены сведения о ZIP")
                    manager.remove(old);removed=true;destination.delete()
                    val request=allowNetworks(DownloadManager.Request(Uri.parse(SITE+relative+"?v="+archive.getString("sha256"))),policy)
                        .setTitle("Обои · ZIP коллекции").setNotificationVisibility(DownloadManager.Request.VISIBILITY_VISIBLE_NOTIFY_COMPLETED)
                        .setDestinationUri(Uri.fromFile(destination))
                    job.put("download_id",manager.enqueue(request)).put("network_policy",policy).put("message","ZIP добавлен в очередь с выбранной сетью.").put("network_error","")
                    Net.atomic(file,job.toString().toByteArray());restarted++
                }catch(e: Exception){
                    val message=UiErrors.message(e);errors.add(message)
                    job?.let{it.put("network_error",message);if(removed)it.put("stage","error").put("message","Не удалось перезапустить ZIP. "+message);try{Net.atomic(file,it.toString().toByteArray())}catch(ignored: Exception){}}
                }
            }
        }
        repo.put("download_migration_error",errors.joinToString("\n"))
        return Migration(restarted,errors)
    }
    fun message(policy: String,result: Migration): String = if(result.errors.isNotEmpty())
        "Настройка сети сохранена, но переключить загрузку ZIP не удалось. "+result.errors.distinct().joinToString(" ")+" Повторите загрузку."
        else if(policy=="wifi")"ZIP: выбрана только сеть Wi-Fi." else "ZIP: разрешены Wi-Fi и мобильная сеть."
}
