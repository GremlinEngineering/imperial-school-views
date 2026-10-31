package ru.oopssre.imperialschool.views

import org.json.JSONObject

internal data class Selection(
    val source: String="day",val collection: String="",val mode: String="featured",
    val target: String="both",val paused: Boolean=false,val notifyCollections: Boolean=true,val notifyApp: Boolean=true,
    val weatherSource: String="game-world",val weatherDelivery: String="zip",val weatherFormat: String="auto",val revision: String="",val weatherCity: String=""
) {
    fun json()=JSONObject().put("source",source).put("collection",collection).put("mode",mode).put("target",target).put("paused",paused)
        .put("notify_collections",notifyCollections).put("notify_app",notifyApp).put("weather_source",weatherSource).put("weather_delivery",weatherDelivery).put("weather_format",weatherFormat).put("revision",revision).put("weather_city",weatherCity)
    companion object {
        fun parse(o: JSONObject)=Selection(o.optString("source","day"),o.optString("collection"),o.optString("mode","featured"),o.optString("target","both"),o.optBoolean("paused"),o.optBoolean("notify_collections",true),o.optBoolean("notify_app",true),o.optString("weather_source","game-world"),o.optString("weather_delivery","zip"),o.optString("weather_format","auto"),o.optString("revision"),o.optString("weather_city"))
    }
}

internal data class Profiles(val home: Selection?=null,val lock: Selection?=null,val linked: Boolean=false) {
    fun select(target: String): Selection = (when(target){"home"->home;"lock"->lock;else->home ?: lock} ?: Selection()).copy(target=target)
    fun activeTargets()=if(linked && home!=null && lock!=null)listOf("home") else listOfNotNull("home".takeIf{home!=null},"lock".takeIf{lock!=null})
    fun targets(s: Selection)=if(s.target=="home" && linked)listOf("home","lock") else listOf(s.target)
    fun without(target: String)=copy(home=home.takeUnless{target in listOf("home","both")},lock=lock.takeUnless{target in listOf("lock","both")},linked=false)
    fun apply(s: Selection,revision: String): Profiles {
        val next=s.copy(revision=revision)
        return when(s.target){
            "both"->Profiles(next.copy(target="home"),next.copy(target="lock"),true)
            "home"->copy(home=next.copy(target="home"),linked=false)
            "lock"->copy(lock=next.copy(target="lock"),linked=false)
            else->error("Неверный экран")
        }
    }
    fun pause(target: String,paused: Boolean,revision: String)=copy(
        home=home?.let{if(target in listOf("home","both"))it.copy(paused=paused,revision=revision) else it},
        lock=lock?.let{if(target in listOf("lock","both"))it.copy(paused=paused,revision=revision) else it},
        linked=linked && target=="both"
    )
    companion object {
        fun migrate(old: Selection)=Profiles().apply(old,old.revision)
    }
}
