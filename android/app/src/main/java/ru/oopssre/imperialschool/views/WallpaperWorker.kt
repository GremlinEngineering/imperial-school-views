package ru.oopssre.imperialschool.views

import android.Manifest
import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.app.WallpaperManager
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.os.Build
import androidx.work.*
import org.json.JSONObject
import java.time.Duration
import java.time.ZonedDateTime
import java.util.concurrent.TimeUnit

internal object Notices {
    fun send(context: Context,id: Int,title: String,message: String) {
        if(Build.VERSION.SDK_INT>=33 && context.checkSelfPermission(Manifest.permission.POST_NOTIFICATIONS)!=PackageManager.PERMISSION_GRANTED)return
        val manager=context.getSystemService(NotificationManager::class.java)
        manager.createNotificationChannel(NotificationChannel("views","Коллекции и обновления",NotificationManager.IMPORTANCE_DEFAULT))
        val intent=Intent(context,MainActivity::class.java).putExtra("updates",id==2)
        val pending=PendingIntent.getActivity(context,id,intent,PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE)
        manager.notify(id,Notification.Builder(context,"views").setSmallIcon(R.drawable.ic_notification).setContentTitle(title).setContentText(message).setStyle(Notification.BigTextStyle().bigText(message)).setContentIntent(pending).setAutoCancel(true).build())
    }
}
internal object AppRelease {
    fun available(repo: Repository): JSONObject? = try { JSONObject(repo.text("app_release","{}" )).takeIf { it.optLong("build")>BuildConfig.VERSION_CODE && validURL(it.optString("url")) } } catch(e: Exception) { null }
    private fun validURL(url: String): Boolean {
        val prefix=SITE+"downloads/";if(!url.startsWith(prefix))return false
        return try { val name=android.net.Uri.decode(url.removePrefix(prefix));name.isNotBlank() && !name.any { it=='/' || it=='\\' || it.code<32 || it.code==127 } && !url.contains('?') && !url.contains('#') && name.endsWith(".apk",true) } catch(e: Exception) { false }
    }
    fun check(context: Context,repo: Repository,force: Boolean=false): String {
        val now=System.currentTimeMillis()
        if(!force && now>=repo.number("app_checked") && now-repo.number("app_checked")<86400000)return ""
        repo.putNumber("app_checked",now)
        val data=JSONObject(String(Net.json(SITE+"android-release.json?v=$now",100000),Charsets.UTF_8))
        requireView(data.getInt("schema")==1 && data.getString("app_id")==BuildConfig.APPLICATION_ID && data.getString("platform")=="android","Неверные сведения о версии")
        if(data.isNull("release")) { repo.put("app_release","{}");return "Сайт пока не опубликовал сведения о версии Android." }
        val r=data.getJSONObject("release")
        requireView(Regex("[0-9]+\\.[0-9]+\\.[0-9]+").matches(r.getString("version")) && r.getLong("build") in 1..2147483647 && r.getLong("bytes")>0 && Regex("[a-f0-9]{64}").matches(r.getString("sha256")) && validURL(r.getString("url")),"Неверные сведения о версии")
        repo.put("app_release",r.toString())
        if(r.getLong("build")<=BuildConfig.VERSION_CODE)return "Установлена актуальная версия приложения."
        val key=r.getString("version")+"+"+r.getLong("build")
        if(repo.settings().notifyApp && repo.text("app_notified")!=key) { repo.put("app_notified",key);Notices.send(context,2,"Виды Школы Империи · обновление","Доступна версия ${r.getString("version")}. Скачать её можно в приложении.") }
        return "Доступна версия ${r.getString("version")}. Ссылка на скачивание — внизу."
    }
}
class WallpaperWorker(context: Context,parameters: WorkerParameters): Worker(context,parameters) {
    override fun doWork(): Result { FrameEngine.run(applicationContext,inputData.getString("target") ?: "both",inputData.getBoolean("force",false));return Result.success() }
}
