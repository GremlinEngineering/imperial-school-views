package ru.oopssre.imperialschool.views

import android.app.WallpaperManager
import android.content.Intent
import android.graphics.Bitmap
import android.os.Bundle
import android.os.Looper
import android.view.View
import android.widget.*
import org.json.JSONArray
import org.json.JSONObject
import org.junit.Assert.*
import org.junit.Test
import org.junit.runner.RunWith
import org.robolectric.Robolectric
import org.robolectric.RobolectricTestRunner
import org.robolectric.RuntimeEnvironment
import org.robolectric.Shadows.shadowOf
import org.robolectric.annotation.Config
import org.robolectric.annotation.GraphicsMode
import org.robolectric.annotation.LooperMode
import java.io.File
import java.util.concurrent.AbstractExecutorService
import java.util.concurrent.TimeUnit

@RunWith(RobolectricTestRunner::class)
@Config(sdk=[34],qualifiers="w360dp-h800dp-xhdpi")
@GraphicsMode(GraphicsMode.Mode.NATIVE)
@LooperMode(LooperMode.Mode.PAUSED)
class SavedWallpapersTest {
    private val app get()=RuntimeEnvironment.getApplication()
    private val repo get()=Repository(app)
    private fun catalogue(): Catalogue {
        val raw=javaClass.getResource("/published-catalogue.json")!!.readText()
        Net.atomic(File(repo.root,"catalogue.json"),raw.toByteArray());return Catalogue.parse(JSONObject(raw))
    }
    private fun selection(): Selection {val c=catalogue().collections.first{it.weather!=null && Weather.formats(it.weather).isNotEmpty()};return Selection(source="weather",collection=c.id,mode="weather",weatherDelivery="zip")}
    private fun image(color: Int,width: Int=40,height: Int=80): ImageFile {
        val f=File(repo.root,"fixture.jpg");val b=Bitmap.createBitmap(width,height,Bitmap.Config.ARGB_8888);b.eraseColor(color);f.outputStream().use{b.compress(Bitmap.CompressFormat.JPEG,90,it)};b.recycle()
        val spec=ImageFile("files/frame-phone.jpg",width,height,f.length(),Net.sha(f));f.copyTo(repo.weatherPath(spec).apply{parentFile!!.mkdirs()},true);f.delete();return spec
    }
    private fun variant(f: ImageFile,state: String,moon: String="none")=JSONObject().put("url",f.url).put("width",f.width).put("height",f.height).put("bytes",f.bytes).put("sha256",f.sha256).put("state_id",state).put("moon_phase",moon)
    private fun pack(s: Selection,vararg rows: JSONObject){
        val c=catalogue().collections.first{it.id==s.collection}.weather!!
        Net.atomic(File(repo.root,"weather-packages/"+"a".repeat(64)+".json"),JSONObject().put("id",s.collection).put("format",Weather.format(c,s)).put("client_api","1.7").put("variants",JSONArray(rows.toList())).toString().toByteArray())
    }
    @Test fun groupsSharedImageWithoutInventingCrossRuleFilterMatches(){
        val s=selection();val f=image(android.graphics.Color.RED)
        pack(s,variant(f,"autumn-night-severe-thunderstorm","full_moon"),variant(f,"winter-day-clear"))
        val item=SavedWallpapers.load(repo,s).items.single()
        assertEquals(2,item.conditions.size)
        assertTrue(item.conditions.first().label().contains("Сильная гроза"));assertTrue(item.conditions.first().label().contains("Полнолуние"))
        assertTrue(WallpaperFilter(season="autumn",time="night").accepts(item))
        assertFalse(WallpaperFilter(season="winter",time="night").accepts(item))
        assertFalse(item.conditions.last().label().contains("Новолуние"))
    }
    @Test fun onlySavedFilesOfSelectedCollectionAndPhoneFormatAreListed(){
        val s=selection();val f=image(android.graphics.Color.RED);val missing=variant(f,"summer-day-clear").put("sha256","b".repeat(64))
        pack(s,variant(f,"winter-day-clear"),missing)
        val other=File(repo.root,"weather-packages/other.json")
        other.writeText(JSONObject().put("id","other").put("format","phone").put("client_api","1.7").put("variants",JSONArray().put(variant(f,"summer-night-rain"))).toString())
        File(repo.root,"weather-packages/broken.json").writeText("{")
        val list=SavedWallpapers.load(repo,s)
        assertEquals(1,list.items.size);assertEquals(1,list.items.single().conditions.size);assertTrue(list.warning.isNotBlank())
    }
    @Test fun jpegModeReadsCachedForecastAndDoesNotNeedAnArchive(){
        val s=selection().copy(weatherDelivery="images");val f=image(android.graphics.Color.RED);val c=catalogue().collections.first{it.id==s.collection}.weather!!
        val row=JSONObject().put("season","spring").put("time_of_day","dawn").put("weather","fog").put("moon_phase","none").put("file",variant(f,"spring-dawn-fog"))
        repo.storePair(c,s,JSONObject(),JSONObject().put("collection_id",s.collection).put("format",Weather.format(c,s)).put("intervals",JSONArray().put(row)))
        val item=SavedWallpapers.load(repo,s).items.single()
        assertEquals("Весна · Рассвет · Туман · Без лунного слоя",item.conditions.single().label())
        assertFalse(File(repo.root,"downloads").exists())
    }
    @Test fun noCachedImagesIsAnEmptyListWithoutDownloads(){val s=selection();assertTrue(SavedWallpapers.load(repo,s).items.isEmpty());assertFalse(File(repo.root,"downloads").exists())}
    @Test fun currentBadgeRequiresWallpaperManagerConfirmation(){
        val s=selection();val f=image(android.graphics.Color.RED);pack(s,variant(f,"winter-day-clear"))
        repo.put("hash_1",f.sha256);repo.putNumber("wallpaper_1",98765)
        assertTrue(SavedWallpapers.load(repo,s).items.single().installed.isEmpty())
    }
    @Test fun ordinaryCollectionIncludesOnlyAlreadyCachedPictures(){
        val f=image(android.graphics.Color.RED,640,1280)
        val item=JSONObject().put("id","one").put("collection","ordinary").put("title","Вид").put("preview","previews/one.jpg").put("files",JSONArray().put(variant(f,"")))
        val collection=JSONObject().put("id","ordinary").put("title","Обычная коллекция")
        Net.atomic(File(repo.root,"catalogue.json"),JSONObject().put("schema",3).put("collections",JSONArray().put(collection)).put("items",JSONArray().put(item)).toString().toByteArray())
        val path=File(repo.root,"online/"+f.sha256+".jpg").apply{parentFile!!.mkdirs()};repo.weatherPath(f).copyTo(path)
        val s=Selection(source="online",collection="ordinary",mode="daily")
        assertEquals("Вид",SavedWallpapers.load(repo,s).items.single().title)
        path.delete();assertTrue(SavedWallpapers.load(repo,s).items.isEmpty())
    }
    @Test fun dailyWeatherReadsTheCachedPhoneFileWithoutForecastOrZip(){
        val s=Selection(source="weather",collection=DailyWeather.ID,mode="weather",weatherSource="real")
        val f=image(android.graphics.Color.RED)
        val p=JSONObject(javaClass.getResource("/published-daily-real.json")!!.readText())
        p.getJSONObject("formats").getJSONObject("phone").put("width",f.width).put("height",f.height)
        p.getJSONObject("files").getJSONObject("phone").put("width",f.width).put("height",f.height).put("bytes",f.bytes).put("sha256",f.sha256)
        Net.atomic(File(repo.root,"weather-daily/real.json"),JSONObject().put("current",p).toString().toByteArray())
        assertEquals(f.sha256,SavedWallpapers.load(repo,s).items.single().image.sha256)
        assertFalse(File(repo.root,"downloads").exists())
    }
    private class Queue: AbstractExecutorService(){
        val jobs=java.util.ArrayDeque<Runnable>();private var stopped=false
        override fun execute(command: Runnable){jobs.add(command)}
        override fun shutdown(){stopped=true};override fun shutdownNow(): MutableList<Runnable>{stopped=true;return jobs.toMutableList().also{jobs.clear()}}
        override fun isShutdown()=stopped;override fun isTerminated()=stopped;override fun awaitTermination(timeout: Long,unit: TimeUnit)=stopped
        fun runAll(){while(jobs.isNotEmpty())jobs.removeFirst().run()}
    }
    private fun <T> field(a: WallpaperViewerActivity,name: String): T { @Suppress("UNCHECKED_CAST") return a.javaClass.getDeclaredField(name).apply{isAccessible=true}.get(a) as T }
    private fun viewer(s: Selection,state: Bundle?=null): Pair<org.robolectric.android.controller.ActivityController<WallpaperViewerActivity>,Queue>{
        val c=Robolectric.buildActivity(WallpaperViewerActivity::class.java,Intent(app,WallpaperViewerActivity::class.java).putExtra("selection",s.json().toString()))
        val a=c.get();field<java.util.concurrent.ExecutorService>(a,"executor").shutdownNow();val q=Queue();a.javaClass.getDeclaredField("executor").apply{isAccessible=true}.set(a,q)
        c.create(state).start().resume().visible();q.runAll();shadowOf(Looper.getMainLooper()).idle();q.runAll();shadowOf(Looper.getMainLooper()).idle();return c to q
    }
    @Test fun viewerEmptyStateAndCorruptFileAllowReturnToSettings(){
        val s=selection();val(c,_)=viewer(s)
        assertTrue(field<TextView>(c.get(),"caption").text.contains("Нет скачанных"));assertFalse(field<Button>(c.get(),"next").isEnabled);c.destroy()
        val f=image(android.graphics.Color.RED);pack(s,variant(f,"winter-day-clear"));val bytes=repo.weatherPath(f).readBytes();bytes[0]=(bytes[0].toInt() xor 1).toByte();repo.weatherPath(f).writeBytes(bytes)
        val(b,_)=viewer(s);assertTrue(field<TextView>(b.get(),"caption").text.contains("повреждён"));assertFalse(b.get().isFinishing);b.destroy()
    }
    @Test fun viewerNavigationFullScreenDetailsAndRecreationKeepSelectedImage(){
        val s=selection();val f=image(android.graphics.Color.RED);val g=image(android.graphics.Color.BLUE);pack(s,variant(f,"winter-day-clear"),variant(g,"autumn-night-rain","full_moon"))
        val(c,q)=viewer(s);val a=c.get()
        assertEquals("1 / 2",field<TextView>(a,"count").text.toString());field<Button>(a,"next").performClick();q.runAll();shadowOf(Looper.getMainLooper()).idle()
        assertEquals("2 / 2",field<TextView>(a,"count").text.toString());assertTrue(field<TextView>(a,"caption").text.contains("Полнолуние"))
        field<Button>(a,"details").performClick();assertTrue(shadowOf(org.robolectric.shadows.ShadowAlertDialog.getLatestAlertDialog()).message.contains("autumn-night-rain"));org.robolectric.shadows.ShadowAlertDialog.getLatestAlertDialog().dismiss()
        field<Button>(a,"fullscreen").performClick();assertEquals(View.GONE,field<View>(a,"header").visibility);a.onBackPressed();assertEquals(View.VISIBLE,field<View>(a,"header").visibility)
        val state=Bundle();c.saveInstanceState(state);c.destroy();val(restored,_)=viewer(s,state);assertEquals("2 / 2",field<TextView>(restored.get(),"count").text.toString());restored.destroy()
    }
    @Test fun filtersWithNoMatchesCanBeResetFromTheViewer(){
        val s=selection();val f=image(android.graphics.Color.RED);pack(s,variant(f,"winter-day-clear"),variant(f,"autumn-night-rain"))
        val(c,q)=viewer(s);val a=c.get();field<Button>(a,"filters").performClick()
        val dialog=org.robolectric.shadows.ShadowAlertDialog.getLatestAlertDialog()
        fun spinners(v: View): List<Spinner> = if(v is Spinner)listOf(v) else if(v is android.view.ViewGroup)(0 until v.childCount).flatMap{spinners(v.getChildAt(it))} else emptyList()
        val selectors=spinners(dialog.window!!.decorView)
        selectors[0].setSelection(1);selectors[1].setSelection(2)
        dialog.getButton(android.content.DialogInterface.BUTTON_POSITIVE).performClick();q.runAll();shadowOf(Looper.getMainLooper()).idle()
        assertTrue(field<TextView>(a,"caption").text.contains("Нет кадров"));assertTrue(field<Button>(a,"filters").isEnabled)
        field<Button>(a,"filters").performClick();org.robolectric.shadows.ShadowAlertDialog.getLatestAlertDialog().getButton(android.content.DialogInterface.BUTTON_NEUTRAL).performClick();q.runAll();shadowOf(Looper.getMainLooper()).idle()
        assertEquals("1 / 1",field<TextView>(a,"count").text.toString());c.destroy()
    }
    @Test fun swipeNavigatesWhileZoomedDragKeepsTheFrame(){
        val image=WallpaperImageView(app);image.layout(0,0,720,1440);val b=Bitmap.createBitmap(40,80,Bitmap.Config.ARGB_8888);image.setImageBitmap(b)
        val steps=mutableListOf<Int>();image.onStep={steps.add(it)}
        var t=android.os.SystemClock.uptimeMillis()
        fun event(action: Int,x: Float){val e=android.view.MotionEvent.obtain(t,t+10,action,x,300f,0);image.onTouchEvent(e);e.recycle();t+=30}
        event(0,650f);event(2,100f);event(1,50f);assertEquals(listOf(1),steps)
        t+=1000;event(0,300f);event(1,300f);t+=70;event(0,300f);event(1,300f)
        assertTrue(image.zoomLevel()>1f)
        event(0,650f);event(2,100f);event(1,50f);assertEquals(listOf(1),steps)
        image.setImageDrawable(null);b.recycle()
    }
    @Test fun slideshowAdvancesEveryTwoSecondsLoopsAndStopsWhenControlsReturn(){
        val s=selection();pack(s,variant(image(android.graphics.Color.RED),"winter-day-clear"),variant(image(android.graphics.Color.BLUE),"autumn-night-rain"))
        val(c,q)=viewer(s);val a=c.get();val button=field<Button>(a,"slideshow")
        assertTrue(button.isEnabled);button.performClick();q.runAll();shadowOf(Looper.getMainLooper()).idle()
        assertEquals(View.GONE,field<View>(a,"header").visibility)
        shadowOf(Looper.getMainLooper()).idleFor(java.time.Duration.ofMillis(1000));assertEquals("1 / 2",field<TextView>(a,"count").text.toString())
        shadowOf(Looper.getMainLooper()).idleFor(java.time.Duration.ofMillis(1100));q.runAll();shadowOf(Looper.getMainLooper()).idle();assertEquals("2 / 2",field<TextView>(a,"count").text.toString())
        shadowOf(Looper.getMainLooper()).idleFor(java.time.Duration.ofSeconds(2));q.runAll();shadowOf(Looper.getMainLooper()).idle();assertEquals("1 / 2",field<TextView>(a,"count").text.toString())
        field<WallpaperImageView>(a,"picture").performClick();assertEquals(View.VISIBLE,field<View>(a,"header").visibility)
        shadowOf(Looper.getMainLooper()).idleFor(java.time.Duration.ofSeconds(5));assertEquals("1 / 2",field<TextView>(a,"count").text.toString())
        assertEquals(0,a.window.attributes.flags and android.view.WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON);c.destroy()
    }
    @Test fun slideshowRequiresTwoFramesAndStopsWhenActivityPauses(){
        val s=selection();val red=image(android.graphics.Color.RED);pack(s,variant(red,"winter-day-clear"));val(one,_)=viewer(s);assertFalse(field<Button>(one.get(),"slideshow").isEnabled);one.destroy()
        pack(s,variant(red,"winter-day-clear"),variant(image(android.graphics.Color.BLUE),"autumn-night-rain"));val(c,q)=viewer(s);val a=c.get()
        field<Button>(a,"slideshow").performClick();q.runAll();shadowOf(Looper.getMainLooper()).idle();c.pause()
        shadowOf(Looper.getMainLooper()).idleFor(java.time.Duration.ofSeconds(10));q.runAll();shadowOf(Looper.getMainLooper()).idle()
        assertEquals("1 / 2",field<TextView>(a,"count").text.toString());assertEquals("Слайд-шоу",field<Button>(a,"slideshow").text.toString());assertEquals(0,a.window.attributes.flags and android.view.WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON);c.destroy()
    }
    @Test fun slideshowStopsOnCorruptionInsteadOfContinuingBehindError(){
        val s=selection();val red=image(android.graphics.Color.RED);val blue=image(android.graphics.Color.BLUE);pack(s,variant(red,"winter-day-clear"),variant(blue,"autumn-night-rain"));val(c,q)=viewer(s);val a=c.get()
        field<Button>(a,"slideshow").performClick();q.runAll();shadowOf(Looper.getMainLooper()).idle();repo.weatherPath(blue).delete()
        shadowOf(Looper.getMainLooper()).idleFor(java.time.Duration.ofSeconds(2));q.runAll();shadowOf(Looper.getMainLooper()).idle()
        assertTrue(field<TextView>(a,"caption").text.contains("удалён"));assertEquals(View.VISIBLE,field<View>(a,"header").visibility);assertEquals("Слайд-шоу",field<Button>(a,"slideshow").text.toString());c.destroy()
    }
    @Test fun dynamicSlideshowStartsFromOldestAndMovesTowardNewest(){
        val s=selection();pack(s,variant(image(android.graphics.Color.RED),"winter-day-clear"),variant(image(android.graphics.Color.BLUE),"autumn-night-rain"));val(c,q)=viewer(s);val a=c.get()
        a.javaClass.getDeclaredField("reverseHistory").apply{isAccessible=true}.set(a,true)
        field<Button>(a,"slideshow").performClick();q.runAll();shadowOf(Looper.getMainLooper()).idle();assertEquals("2 / 2",field<TextView>(a,"count").text.toString())
        shadowOf(Looper.getMainLooper()).idleFor(java.time.Duration.ofSeconds(2));q.runAll();shadowOf(Looper.getMainLooper()).idle();assertEquals("1 / 2",field<TextView>(a,"count").text.toString());c.destroy()
    }
    @Test fun viewerAtLargeFontKeepsImageAreaAndScrollableFilters(){
        RuntimeEnvironment.setQualifiers("w360dp-h800dp-xhdpi");val config=android.content.res.Configuration(app.resources.configuration);config.fontScale=2f;app.resources.updateConfiguration(config,app.resources.displayMetrics)
        val s=selection();pack(s,variant(image(android.graphics.Color.RED),"winter-night-clear","new_moon"));val(c,_)=viewer(s);val a=c.get();val decor=a.window.decorView
        decor.measure(View.MeasureSpec.makeMeasureSpec(720,View.MeasureSpec.EXACTLY),View.MeasureSpec.makeMeasureSpec(1600,View.MeasureSpec.EXACTLY));decor.layout(0,0,720,1600)
        val snapshot=Bitmap.createBitmap(720,1600,Bitmap.Config.ARGB_8888);decor.draw(android.graphics.Canvas(snapshot));File("build/viewer-review").mkdirs();File("build/viewer-review/font200.png").outputStream().use{snapshot.compress(Bitmap.CompressFormat.PNG,100,it)};snapshot.recycle()
        assertTrue("image height="+field<View>(a,"picture").height,field<View>(a,"picture").height>200)
        field<Button>(a,"filters").performClick();assertNotNull(org.robolectric.shadows.ShadowAlertDialog.getLatestAlertDialog());org.robolectric.shadows.ShadowAlertDialog.getLatestAlertDialog().dismiss();c.destroy()
    }
}
