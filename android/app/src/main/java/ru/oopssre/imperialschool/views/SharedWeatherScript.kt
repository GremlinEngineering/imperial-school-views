package ru.oopssre.imperialschool.views

import org.json.JSONObject
import org.mozilla.javascript.BaseFunction
import org.mozilla.javascript.Context
import org.mozilla.javascript.Scriptable
import org.mozilla.javascript.ScriptableObject
import java.time.Instant
import java.time.ZoneId

/** Run the identical, bundled Mac weather policy in an isolated arithmetic interpreter. */
internal class SharedWeatherScript(private val sources: List<String>) {
    fun call(operation: String, input: JSONObject): String {
        val cx=Context.enter()
        try {
            cx.optimizationLevel=-1
            cx.languageVersion=Context.VERSION_ES6
            val scope=cx.initSafeStandardObjects()
            ScriptableObject.putProperty(scope,"calendar",object: BaseFunction() {
                override fun call(ctx: Context,sc: Scriptable,self: Scriptable,args: Array<out Any>): Any {
                    val t=Instant.ofEpochMilli(Context.toNumber(args[0]).toLong()).atZone(ZoneId.of(Context.toString(args[1])))
                    val o=ctx.newObject(scope)
                    mapOf("date" to t.toLocalDate().toString(),"hour" to t.hour,"minute" to t.minute,"second" to t.second).forEach{(k,v)->ScriptableObject.putProperty(o,k,v)}
                    return o
                }
            })
            sources.forEachIndexed{i,s->cx.evaluateString(scope,s,"shared-weather-$i",1,null)}
            ScriptableObject.putProperty(scope,"inputJSON",input.toString())
            val expression=when(operation) {
                "city"->"ViewsOpenMeteo.city(v)"
                "search"->"ViewsOpenMeteo.searchResults(v)"
                "normalize"->"ViewsOpenMeteo.normalize(v.raw,v.city,v.now)"
                "schedule"->"ViewsOpenMeteo.schedule(v.provider,v.city,v.index,v.now,{calendar:calendar,load:function(){return null;},save:function(){}})"
                "day"->"ViewsAstronomy.day(v.date,v.city,calendar)"
                else->error("Unknown weather operation")
            }
            return Context.toString(cx.evaluateString(scope,"var v=JSON.parse(inputJSON);JSON.stringify($expression)","android-weather",1,null))
        } finally { Context.exit() }
    }
}
