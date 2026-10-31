package ru.oopssre.imperialschool.views

import android.app.AlarmManager
import android.app.PendingIntent
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.net.Uri
import android.net.ConnectivityManager
import android.net.NetworkCapabilities
import android.os.Build
import android.os.PowerManager
import androidx.work.*
import org.json.JSONObject
import java.time.ZonedDateTime
import java.util.concurrent.TimeUnit

internal object Schedule {
    private fun connected(context: Context): Boolean {val network=context.getSystemService(ConnectivityManager::class.java);return network.getNetworkCapabilities(network.activeNetwork)?.hasCapability(NetworkCapabilities.NET_CAPABILITY_VALIDATED)==true}
    fun exact(context: Context)=Build.VERSION.SDK_INT<31 || context.getSystemService(AlarmManager::class.java).canScheduleExactAlarms()
    private fun alarm(context: Context,target: String,kind: String,at: Long) {
        val intent=Intent(context,FrameAlarm::class.java).setAction(kind).setData(Uri.parse("imperial://alarm/"+target+"/"+kind)).putExtra("target",target)
        val pending=PendingIntent.getBroadcast(context,0,intent,PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE)
        val manager=context.getSystemService(AlarmManager::class.java);manager.cancel(pending)
        if(at<=0)return
        val whenAt=maxOf(System.currentTimeMillis()+1000,at)
        try {if(exact(context))manager.setExactAndAllowWhileIdle(AlarmManager.RTC_WAKEUP,whenAt,pending) else manager.setAndAllowWhileIdle(AlarmManager.RTC_WAKEUP,whenAt,pending)}
        catch(e: SecurityException){manager.setAndAllowWhileIdle(AlarmManager.RTC_WAKEUP,whenAt,pending)}
    }
    fun configure(context: Context,selection: Selection?=null) {
        val repo=Repository(context);val work=WorkManager.getInstance(context);work.cancelUniqueWork("imperial-wallpapers")
        val active=repo.activeTargets()
        listOf("home","lock").forEach{target->
            if(target !in active || repo.settings(target).paused){alarm(context,target,"frame",0);alarm(context,target,"refresh",0);return@forEach}
            val s=repo.settings(target);val now=System.currentTimeMillis()
            try {
                if(s.source=="dynamic"){
                    val c=Dynamic.collection(repo.cachedCatalogue(s) ?: error("Нет каталога"),s)
                    alarm(context,target,"frame",now+900000)
                    if(connected(context))alarm(context,target,"refresh",maxOf(now+60000,Dynamic.nextCheck(repo,c,s)))
                    else{alarm(context,target,"refresh",0);dynamic(context,c,s,false)}
                }else if(s.source=="weather"){
                    val c=repo.weatherCollection(repo.cachedCatalogue(s) ?: error("Нет каталога"),s);val frame=repo.resolveWeather(c,s,now)
                    alarm(context,target,"frame",if(frame.next>now)frame.next else now+900000)
                    if(connected(context))alarm(context,target,"refresh",maxOf(now+60000,frame.refresh))
                    else{alarm(context,target,"refresh",0);weather(context,c,s,false)}
                }else{
                    val date=ZonedDateTime.now();alarm(context,target,"frame",date.toLocalDate().plusDays(1).atStartOfDay(date.zone).toInstant().toEpochMilli());alarm(context,target,"refresh",0)
                }
            }catch(e: Exception){alarm(context,target,"frame",now+900000);if(repo.online(s))alarm(context,target,"refresh",now+60000)}
        }
        val online=active.map{repo.settings(it)}.filter{!it.paused && repo.online(it)}
        if(online.isNotEmpty()){
            val hours=if(online.any{it.source!="weather"})1L else 24L
            work.enqueueUniquePeriodicWork("imperial-catalogue",ExistingPeriodicWorkPolicy.UPDATE,PeriodicWorkRequestBuilder<RefreshWorker>(hours,TimeUnit.HOURS).setConstraints(Constraints.Builder().setRequiredNetworkType(NetworkType.CONNECTED).build()).build())
        }else work.cancelUniqueWork("imperial-catalogue")
        if(active.any{!repo.settings(it).paused})work.enqueueUniquePeriodicWork("imperial-clock-backup",ExistingPeriodicWorkPolicy.KEEP,PeriodicWorkRequestBuilder<WallpaperWorker>(15,TimeUnit.MINUTES).build())
        else work.cancelUniqueWork("imperial-clock-backup")
    }
    fun now(context: Context,force: Boolean=true,target: String="both") {
        if(force)Repository(context).requestManual(target)
        WorkManager.getInstance(context).enqueueUniqueWork("frame-"+target,ExistingWorkPolicy.REPLACE,OneTimeWorkRequestBuilder<WallpaperWorker>().setInputData(workDataOf("target" to target,"force" to force)).build())
    }
    fun refresh(context: Context,force: Boolean=false){WorkManager.getInstance(context).enqueueUniqueWork("catalogue-refresh",if(force)ExistingWorkPolicy.REPLACE else ExistingWorkPolicy.KEEP,OneTimeWorkRequestBuilder<RefreshWorker>().setConstraints(Constraints.Builder().setRequiredNetworkType(NetworkType.CONNECTED).build()).setInputData(workDataOf("force" to force)).build())}
    fun dynamic(context: Context,c: JSONObject,s: Selection,force: Boolean=false){
        val scope=Dynamic.scope(c,s)
        WorkManager.getInstance(context).enqueueUniqueWork("dynamic-"+scope,if(force)ExistingWorkPolicy.REPLACE else ExistingWorkPolicy.KEEP,OneTimeWorkRequestBuilder<DynamicRefreshWorker>().setConstraints(Constraints.Builder().setRequiredNetworkType(NetworkType.CONNECTED).build()).setBackoffCriteria(BackoffPolicy.EXPONENTIAL,60,TimeUnit.SECONDS).setInputData(workDataOf("collection" to Dynamic.descriptor(c).toString(),"selection" to s.json().toString(),"force" to force)).build())
    }
    fun weather(context: Context,c: JSONObject,s: Selection,force: Boolean=false) {
        val scope=weatherScope(c,s)
        WorkManager.getInstance(context).enqueueUniqueWork("weather-"+scope,if(force)ExistingWorkPolicy.REPLACE else ExistingWorkPolicy.KEEP,OneTimeWorkRequestBuilder<WeatherRefreshWorker>().setConstraints(Constraints.Builder().setRequiredNetworkType(NetworkType.CONNECTED).build()).setBackoffCriteria(BackoffPolicy.EXPONENTIAL,60,TimeUnit.SECONDS).setInputData(workDataOf("collection" to c.toString(),"selection" to s.json().toString(),"force" to force)).build())
    }
}
class FrameAlarm: BroadcastReceiver() {
    override fun onReceive(context: Context,intent: Intent){
        val target=intent.getStringExtra("target").orEmpty();if(target !in listOf("home","lock"))return
        if(intent.action=="refresh"){val repo=Repository(context);val s=repo.settings(target);if(s.paused)return;try{if(s.source=="dynamic")Schedule.dynamic(context,Dynamic.collection(repo.cachedCatalogue(s) ?: error("Нет каталога"),s),s) else if(s.source=="weather")Schedule.weather(context,repo.weatherCollection(repo.cachedCatalogue(s) ?: error("Нет каталога"),s),s) else Schedule.refresh(context)}catch(e: Exception){Schedule.refresh(context)};return}
        if(intent.action!="frame")return
        val pending=goAsync()
        Thread{
            val wake=context.getSystemService(PowerManager::class.java).newWakeLock(PowerManager.PARTIAL_WAKE_LOCK,"ImperialViews:frame")
            try{wake.acquire(9500);FrameEngine.run(context,target,false)}catch(e: Exception){Repository(context).status(target,"Сохранены последние обои. "+(e.message ?: "Обновление отложено"))}finally{if(wake.isHeld)wake.release();pending.finish()}
        }.start()
    }
}
class SystemEvents: BroadcastReceiver() {
    override fun onReceive(context: Context,intent: Intent){
        if(intent.action !in listOf(Intent.ACTION_BOOT_COMPLETED,Intent.ACTION_TIME_CHANGED,Intent.ACTION_TIMEZONE_CHANGED,Intent.ACTION_MY_PACKAGE_REPLACED,AlarmManager.ACTION_SCHEDULE_EXACT_ALARM_PERMISSION_STATE_CHANGED))return
        Schedule.configure(context);Schedule.now(context,false)
    }
}
class DownloadEvents: BroadcastReceiver() {
    override fun onReceive(context: Context,intent: Intent){if(intent.action==android.app.DownloadManager.ACTION_DOWNLOAD_COMPLETE){val id=intent.getLongExtra(android.app.DownloadManager.EXTRA_DOWNLOAD_ID,-1);Archive.completed(context,id);CollectionDownloads.completed(context,id)}}
}
