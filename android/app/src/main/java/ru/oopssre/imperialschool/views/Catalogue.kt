package ru.oopssre.imperialschool.views

import org.json.JSONArray
import org.json.JSONObject
import java.time.LocalDate

internal const val SITE = "https://games.oopssre.ru/assets/arcade/views/"
internal val packId = Regex("[a-z0-9][a-z0-9-]{0,79}")
internal val sceneId = Regex("[a-z0-9][a-z0-9-]{0,161}")
internal val picturePath = Regex("(?:collections/[a-z0-9][a-z0-9-]{0,79}/)?(?:files|previews)/[a-z0-9-]+\\.jpg")
internal fun requireView(ok: Boolean, message: String) { require(ok) { message } }
internal fun JSONArray.objects(): List<JSONObject> = (0 until length()).map { getJSONObject(it) }
internal data class ImageFile(val url: String, val width: Int, val height: Int, val bytes: Long, val sha256: String)
internal data class Scene(val id: String, val collection: String, val title: String, val preview: String, val files: List<ImageFile>) {
    fun phone(): ImageFile = files.filter { it.height > it.width }.maxByOrNull { it.width.toLong() * it.height }
        ?: error("В коллекции нет вертикального изображения: $title")
}
internal data class Collection(val id: String, val title: String, val schedule: Map<String, Map<String,String>>,val weather: JSONObject?=null,val dynamic: JSONObject?=null) {
    fun modes() = if(dynamic!=null)listOf("dynamic") else if(weather!=null)listOf("weather") else listOf("monthly", "seasonal").filter { schedule.containsKey(it) } + "daily"
}
internal data class Catalogue(val collections: List<Collection>, val scenes: List<Scene>, val featured: String? = null,val downloads: List<JSONObject> = emptyList()) {
    fun choose(collection: String, mode: String, date: LocalDate = LocalDate.now()): Scene {
        if (mode == "featured") return scenes.firstOrNull { it.id == featured } ?: error("Сайт ещё не опубликовал обои дня")
        val pack = collections.firstOrNull { it.id == collection } ?: error("Коллекция недоступна. Выберите другую.")
        val rows = scenes.filter { it.collection == collection }
        if (mode == "daily") return rows[Math.floorMod(date.toEpochDay(), rows.size.toLong()).toInt()]
        val period = when (mode) {
            "monthly" -> date.monthValue.toString()
            "seasonal" -> when(date.monthValue) { in 3..5 -> "spring"; in 6..8 -> "summer"; in 9..11 -> "autumn"; else -> "winter" }
            else -> error("Неизвестное расписание")
        }
        val id = pack.schedule[mode]?.get(period) ?: error("Нет изображения для текущего периода")
        return rows.firstOrNull { it.id == id } ?: error("Изображение отсутствует в коллекции")
    }
    companion object {
        fun parse(json: JSONObject): Catalogue {
            requireView(json.optInt("schema")==3, "Неверный каталог")
            val collections = json.getJSONArray("collections").objects().map { c ->
                Collection(c.getString("id"), c.getString("title"), schedules(c.optJSONObject("schedule")),c.takeIf { it.optString("type")=="weather" }?.also { Weather.validateCollection(it) },c.takeIf{it.optString("type")=="dynamic"}?.also{Dynamic.validateCollection(it)})
            }
            val scenes = json.getJSONArray("items").objects().map { item ->
                Scene(item.getString("id"), item.getString("collection"), item.getString("title"), item.getString("preview"), item.getJSONArray("files").objects().map { f ->
                    ImageFile(f.getString("url"), f.getInt("width"), f.getInt("height"), f.getLong("bytes"), f.getString("sha256"))
                })
            }
            requireView(collections.isNotEmpty() && collections.size <= 500 && collections.map { it.id }.distinct().size == collections.size, "Неверный список коллекций")
            collections.forEach { requireView((if(it.dynamic!=null)Dynamic.id.matches(it.id) else packId.matches(it.id)) && it.title.isNotBlank() && it.title.length <= 300, "Неверное описание коллекции") }
            requireView((scenes.isNotEmpty() || collections.any{it.weather!=null || it.dynamic!=null}) && scenes.size <= 5000 && scenes.map { it.id }.distinct().size == scenes.size, "Неверный список видов")
            scenes.forEach { scene ->
                requireView(sceneId.matches(scene.id) && collections.any { it.id == scene.collection } && scene.title.isNotBlank() && scene.title.length <= 300, "Неверное описание вида")
                requireView(picturePath.matches(scene.preview) && scene.preview.contains("/previews/") || Regex("previews/[a-z0-9-]+\\.jpg").matches(scene.preview), "Неверное превью")
                requireView(scene.files.isNotEmpty() && scene.files.size <= 20 && scene.files.map { it.url }.distinct().size == scene.files.size, "Неверный список файлов")
                scene.files.forEach { f -> requireView(picturePath.matches(f.url) && (f.url.startsWith("files/") || f.url.contains("/files/")) && f.width in 640..16384 && f.height in 360..16384 && f.bytes in 1..100000000 && Regex("[a-f0-9]{64}").matches(f.sha256), "Неверный файл изображения") }
            }
            collections.forEach { c ->
                requireView(c.weather!=null || c.dynamic!=null || scenes.any { it.collection == c.id }, "Пустая коллекция")
                c.schedule.forEach { (mode, table) ->
                    val periods = when(mode) { "monthly" -> (1..12).map(Int::toString); "seasonal" -> listOf("winter","spring","summer","autumn"); else -> error("Неизвестное расписание") }
                    requireView(table.keys == periods.toSet() && table.values.all { id -> scenes.any { it.id == id && it.collection == c.id } }, "Неполное расписание")
                }
            }
            val featured = json.optJSONObject("wallpaper_of_day")?.optString("item_id")?.takeIf { it.isNotBlank() }
            requireView(featured == null || scenes.any { it.id == featured }, "В каталоге отсутствуют обои дня")
            return Catalogue(collections, scenes, featured,json.optJSONArray("downloads")?.objects() ?: emptyList())
        }
        private fun schedules(json: JSONObject?): Map<String, Map<String,String>> = json?.keys()?.asSequence()?.associateWith { mode ->
            val table = json.getJSONObject(mode); table.keys().asSequence().associateWith { table.getString(it) }
        } ?: emptyMap()
        fun compose(packs: List<JSONObject>): Catalogue? {
            val collections=JSONArray(); val items=JSONArray()
            packs.sortedBy { it.getString("id") }.filter { it.optBoolean("enabled",true) }.forEach { p ->
                val id=p.getString("id"); requireView(p.getInt("schema")==1 && packId.matches(id), "Неверный пакет")
                val prefix="collections/$id/"; val schedule=JSONObject()
                p.optJSONObject("schedule")?.let { s -> s.keys().forEach { mode ->
                    val table=JSONObject(); s.getJSONObject(mode).let { t -> t.keys().forEach { period -> table.put(period,id+"--"+t.getString(period)) } }; schedule.put(mode,table)
                } }
                collections.put(JSONObject().put("id",id).put("title",p.getString("title")).put("schedule",schedule))
                p.getJSONArray("items").objects().forEach { original ->
                    val item=JSONObject(original.toString()); val local=item.getString("id")
                    requireView(packId.matches(local), "Неверный ID вида")
                    item.put("id", "$id--$local").put("collection", id)
                    val preview=item.getString("preview"); requireView(Regex("previews/[a-z0-9-]+\\.jpg").matches(preview),"Неверное превью пакета"); item.put("preview",prefix+preview)
                    item.getJSONArray("files").objects().forEach { f -> val path=f.getString("url"); requireView(Regex("files/[a-z0-9-]+\\.jpg").matches(path),"Неверный файл пакета"); f.put("url",prefix+path) }
                    items.put(item)
                }
            }
            if (collections.length()==0) return null
            return parse(JSONObject().put("schema",3).put("collections",collections).put("items",items))
        }
    }
}
