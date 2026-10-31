package ru.oopssre.imperialschool.views

import org.json.JSONObject

/** Publish only compatible pairs. A failed refresh must not destroy valid cached coverage. */
internal fun Repository.refreshWeatherPair(c: JSONObject,s: Selection,stopped: ()->Boolean={false},load: (String)->JSONObject): JSONObject? {
    val source=Weather.source(c,s.weatherSource);val format=Weather.format(c,s)
    val previous=weatherPair(c,s)
    val p=Weather.current(load(source.getString("current_url")),c,s.weatherSource)
    if(stopped())return null
    val oldCurrent=previous?.optJSONObject("current")
    if(oldCurrent==null || !Weather.identity(oldCurrent,p) || oldCurrent.optString("timezone")!=p.optString("timezone") || p.optString("status")=="unavailable") {
        // A confirmed change of world/location invalidates old coverage even if the next GET fails.
        val missing=JSONObject(p.toString()).put("document_type","weather-forecast").put("format",format).put("status","unavailable")
        storePair(c,s,p,missing)
    }
    val f=Weather.forecast(load(source.getJSONObject("forecasts").getString(format)),c,s.weatherSource,format)
    requireView(Weather.identity(p,f) && (f.optString("status")=="unavailable" || p.optString("timezone")==f.optString("timezone")),"Погодные данные на сайте обновляются. Повторю загрузку.")
    if(stopped())return null
    storePair(c,s,p,f)
    return weatherPair(c,s)
}
