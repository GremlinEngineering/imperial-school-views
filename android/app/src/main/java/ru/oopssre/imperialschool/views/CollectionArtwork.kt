package ru.oopssre.imperialschool.views

import android.graphics.BitmapFactory
import org.json.JSONObject
import java.io.File
import java.security.MessageDigest

/** Gallery thumbnails never trigger full collection downloads. */
internal object CollectionArtwork {
    fun sample(file: File,edge: Int): Int {
        val info=BitmapFactory.Options().apply{inJustDecodeBounds=true};BitmapFactory.decodeFile(file.path,info)
        var sample=1;while(maxOf(info.outWidth,info.outHeight)/sample>edge)sample*=2
        return sample
    }
    fun file(repo: Repository,data: Catalogue,c: Collection,s: Selection): File? {
        if(c.dynamic!=null){
            val selected=s.copy(collection=c.id,weatherFormat="auto")
            val state=Dynamic.cached(repo,c.dynamic,selected) ?: return null
            return Dynamic.path(repo,Dynamic.image(state,c.dynamic,selected)).takeIf{it.isFile}
        }
        if(c.weather!=null){
            val sample=JSONObject(repo.context.assets.open("preview-samples/index.json").bufferedReader().use{it.readText()})
                .getJSONArray("samples").objects().firstOrNull{it.optString("collection_id")==c.id} ?: return null
            val name=sample.getString("file");requireView(Regex("[a-z0-9-]+\\.(?:png|jpg)").matches(name),"Неверное превью")
            val dest=File(repo.context.cacheDir,"collection-previews/$name")
            if(!dest.isFile)Net.atomic(dest,repo.context.assets.open("preview-samples/$name").use{it.readBytes()})
            return dest
        }
        val scene=try{data.choose(c.id,c.modes().first())}catch(e: Exception){data.scenes.firstOrNull{it.collection==c.id && it.files.any{f->f.height>f.width}}} ?: return null
        if(!repo.online(s))return File(repo.root,scene.phone().url).takeIf{it.isFile}
        val key=MessageDigest.getInstance("SHA-256").digest(scene.preview.toByteArray()).joinToString(""){"%02x".format(it)}
        val file=File(repo.context.cacheDir,"collection-previews/$key.jpg")
        if(!file.isFile)Net.atomic(file,Net.get(SITE+scene.preview,5000000))
        return file
    }
}
