package ru.oopssre.imperialschool.views

import android.Manifest
import android.content.Context
import android.content.pm.PackageManager
import android.location.Location
import android.location.LocationListener
import android.location.LocationManager
import android.os.Bundle
import android.os.Handler
import android.os.Looper
import android.os.SystemClock

/** One foreground fix, released on success, cancellation or timeout. No background subscription. */
internal class DeviceLocation(private val context: Context,private val handler: Handler=Handler(Looper.getMainLooper())) {
    private val manager=context.getSystemService(LocationManager::class.java)
    private var listener: LocationListener?=null
    private var timeout: Runnable?=null
    companion object {
        fun permitted(context: Context)=listOf(Manifest.permission.ACCESS_COARSE_LOCATION,Manifest.permission.ACCESS_FINE_LOCATION).any{context.checkSelfPermission(it)==PackageManager.PERMISSION_GRANTED}
        fun usable(location: Location,nowNanos: Long=SystemClock.elapsedRealtimeNanos()): Boolean {
            val age=nowNanos-location.elapsedRealtimeNanos
            return location.latitude.isFinite() && location.latitude in -90.0..90.0 && location.longitude.isFinite() && location.longitude in -180.0..180.0 &&
                location.hasAccuracy() && location.accuracy.isFinite() && location.accuracy in 0f..25000f && age in 0..600000000000L
        }
    }
    fun cancel() {
        listener?.let{try{manager.removeUpdates(it)}catch(ignored: SecurityException){}}
        listener=null;timeout?.let{handler.removeCallbacks(it)};timeout=null
    }
    fun start(success: (Location)->Unit,failure: (String)->Unit) {
        cancel()
        if(!permitted(context)){failure("Разрешите доступ к местоположению или выберите город вручную.");return}
        val providers=manager.getProviders(true).filter{it!=LocationManager.PASSIVE_PROVIDER}
        if(providers.isEmpty()){failure("Геолокация выключена. Включите её в настройках Android или выберите город вручную.");return}
        val cached=providers.mapNotNull{try{manager.getLastKnownLocation(it)}catch(ignored: SecurityException){null}}.filter{usable(it)}.maxByOrNull{it.elapsedRealtimeNanos}
        if(cached!=null){success(cached);return}
        val current=object: LocationListener {
            override fun onLocationChanged(location: Location) { if(listener===this && usable(location)){cancel();success(location)} }
            override fun onProviderDisabled(provider: String){}
            override fun onProviderEnabled(provider: String){}
            @Deprecated("Android compatibility") override fun onStatusChanged(provider: String?,status: Int,extras: Bundle?){}
        }
        listener=current
        var subscribed=false
        for(provider in providers)try{manager.requestLocationUpdates(provider,1000L,0f,current,Looper.getMainLooper());subscribed=true}catch(ignored: SecurityException){}catch(ignored: IllegalArgumentException){}
        if(!subscribed){cancel();failure("Не удалось получить координаты. Проверьте разрешение и геолокацию Android или выберите город вручную.");return}
        timeout=Runnable{if(listener===current){cancel();failure("Не удалось определить местоположение за 25 секунд. Повторите попытку или выберите город вручную.")}}.also{handler.postDelayed(it,25000)}
    }
}
