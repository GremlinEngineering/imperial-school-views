package ru.oopssre.imperialschool.views

import android.app.Application
import android.os.Looper
import android.view.View
import android.widget.*
import org.json.JSONObject
import org.junit.Assert.*
import org.junit.Test
import org.junit.After
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

/** Regression checks for 1.3.6: former audit failures must remain fixed. */
@RunWith(RobolectricTestRunner::class)
@Config(sdk=[34],qualifiers="w360dp-h800dp-xhdpi")
@GraphicsMode(GraphicsMode.Mode.NATIVE)
@LooperMode(LooperMode.Mode.PAUSED)
class UiRegressionTest {
    @After fun releaseWorkManagerDelegate(){androidx.work.impl.WorkManagerImpl.setDelegate(null)}
    private class Queue: AbstractExecutorService() {
        val jobs=java.util.ArrayDeque<Runnable>()
        private var stopped=false
        override fun execute(command: Runnable){jobs.add(command)}
        override fun shutdown(){stopped=true}
        override fun shutdownNow(): MutableList<Runnable>{stopped=true;return jobs.toMutableList().also{jobs.clear()}}
        override fun isShutdown()=stopped
        override fun isTerminated()=stopped
        override fun awaitTermination(timeout: Long,unit: TimeUnit)=stopped
        fun runAll(){while(jobs.isNotEmpty())jobs.removeFirst().run()}
    }
    private val app get()=RuntimeEnvironment.getApplication()
    private fun repo()=Repository(app)
    private fun data()=Catalogue.parse(JSONObject(javaClass.getResource("/published-catalogue.json")!!.readText()))
    private val city="""{"name":"Берлин","latitude":52.52,"longitude":13.4,"timezone":"Europe/Berlin"}"""
    private fun set(a: MainActivity,name: String,v: Any){a.javaClass.getDeclaredField(name).apply{isAccessible=true}.set(a,v)}
    private fun <T> get(a: MainActivity,name: String): T {@Suppress("UNCHECKED_CAST") return a.javaClass.getDeclaredField(name).apply{isAccessible=true}.get(a) as T}
    private fun call(a: MainActivity,name: String,vararg args: Any){a.javaClass.declaredMethods.first{it.name==name}.apply{isAccessible=true}.invoke(a,*args)}
    private fun setup(state: android.os.Bundle?=null): Pair<org.robolectric.android.controller.ActivityController<MainActivity>,Queue> {
        val controller=Robolectric.buildActivity(MainActivity::class.java);val a=controller.get();val queue=Queue()
        get<java.util.concurrent.ExecutorService>(a,"executor").shutdownNow();get<java.util.concurrent.ExecutorService>(a,"network").shutdownNow()
        set(a,"executor",queue);set(a,"network",Queue())
        controller.create(state);queue.jobs.clear()
        try{androidx.work.WorkManager.getInstance(app)}catch(e: IllegalStateException){androidx.work.WorkManager.initialize(app,androidx.work.Configuration.Builder().setExecutor{ }.setTaskExecutor{ }.build())}
        return controller to queue
    }
    private fun render(a: MainActivity,s: Selection){set(a,"catalogue",data());set(a,"draft",s);set(a,"busy",false);call(a,"render")}
    @Test fun localViewerButtonIsUnderCollectionAndLeavesDraftIntact() {
        val(controller,_)=setup();val a=controller.get();val c=data().collections.first{it.weather!=null && Weather.formats(it.weather).isNotEmpty()}
        val s=Selection(source="weather",collection=c.id,mode="weather",weatherSource="open-meteo",weatherCity=city)
        try{
            render(a,s);val b=get<Button>(a,"viewSaved");val selector=get<Spinner>(a,"collection");val parent=b.parent as LinearLayout
            assertTrue(b.isEnabled);assertTrue(parent.indexOfChild(b)==parent.indexOfChild(selector)+1)
            b.performClick();val intent=shadowOf(a).nextStartedActivity
            assertEquals(WallpaperViewerActivity::class.java.name,intent.component!!.className)
            assertEquals(s,Selection.parse(JSONObject(intent.getStringExtra("selection")!!)))
            assertEquals(s,get<Selection>(a,"draft"));assertFalse(repo().installed())
        }finally{controller.destroy()}
    }
    private fun dynamicData(): Catalogue {
        val raw=JSONObject(javaClass.getResource("/published-catalogue.json")!!.readText())
        raw.getJSONArray("collections").put(JSONObject().put("id","dynamic-test").put("title","Динамическая тема").put("type","dynamic").put("current_url","dynamic/dynamic-test/current.json").put("formats",JSONObject().put("phone_1440x3120",JSONObject().put("width",1440).put("height",3120))))
        return Catalogue.parse(raw)
    }
    @Test fun dynamicModeHasOnlyDynamicPhoneCollectionsAndNoWeatherOrZipControls(){
        val(controller,_)=setup();val a=controller.get()
        try{
            set(a,"catalogue",dynamicData());set(a,"draft",Selection(source="dynamic",collection="dynamic-test",mode="dynamic",weatherSource="real",weatherDelivery="images"));set(a,"busy",false);call(a,"render")
            assertEquals(1,get<Spinner>(a,"collection").adapter.count)
            assertEquals(View.GONE,get<View>(a,"weatherBox").visibility);assertEquals(View.GONE,get<View>(a,"zipCard").visibility);assertEquals(View.GONE,get<View>(a,"mode").visibility)
            assertTrue(get<Button>(a,"apply").isEnabled);assertTrue(get<Button>(a,"dynamicTab").isSelected);assertFalse(get<Button>(a,"ordinaryTab").isSelected)
            get<Button>(a,"viewSaved").performClick();assertEquals("dynamic",Selection.parse(JSONObject(shadowOf(a).nextStartedActivity.getStringExtra("selection")!!)).source)
        }finally{controller.destroy()}
    }
    @Test fun absentDynamicThemesHaveAnExplicitEmptyStateAndDoNotBlockOtherSections(){
        val(controller,_)=setup();val a=controller.get()
        try{
            Net.atomic(File(repo().root,"catalogue.json"),javaClass.getResource("/published-catalogue.json")!!.readBytes())
            val network=get<Queue>(a,"network");network.jobs.clear();set(a,"draft",Selection(source="dynamic",mode="dynamic"));call(a,"loadCatalogue",false);network.runAll();shadowOf(Looper.getMainLooper()).idle()
            assertFalse(get<Button>(a,"apply").isEnabled);assertTrue(get<TextView>(a,"caption").text.contains("пока нет динамических"))
            get<Button>(a,"ordinaryTab").performClick();assertEquals("day",get<Selection>(a,"draft").source)
        }finally{controller.destroy()}
    }
    @Test fun projectLinksOpenRepositoryAndIssuesWithoutApplyingSettings(){
        val(controller,_)=setup();val a=controller.get();val before=get<Selection>(a,"draft")
        fun buttons(v: View): List<Button> = if(v is Button)listOf(v) else if(v is android.view.ViewGroup)(0 until v.childCount).flatMap{buttons(v.getChildAt(it))} else emptyList()
        try{
            val all=buttons(a.window.decorView)
            for((label,url) in listOf("Исходный код · GitHub" to "https://github.com/GremlinEngineering/imperial-school-views","Сообщить об ошибке" to "https://github.com/GremlinEngineering/imperial-school-views/issues")){
                val button=all.single{it.text.toString()==label};assertTrue(button.minimumHeight>=48*a.resources.displayMetrics.density)
                button.performClick();val intent=shadowOf(a).nextStartedActivity;assertEquals(android.content.Intent.ACTION_VIEW,intent.action);assertEquals(url,intent.data.toString())
            }
            assertEquals(before,get<Selection>(a,"draft"));assertFalse(repo().installed())
        }finally{controller.destroy()}
    }
    @Test fun stateMatrixChecksEverySourceAgainstEveryTargetAndBusyState() {
        val(controller,_)=setup();val a=controller.get();val d=data();val c=d.collections.first{it.weather!=null && Weather.formats(it.weather).isNotEmpty()};val ordinary=d.collections.first{it.weather==null}
        val modes=listOf(
            Selection(source="day",collection=ordinary.id,mode="featured"),
            Selection(source="online",collection=ordinary.id,mode=ordinary.modes().first()),
            Selection(source="local",collection=ordinary.id,mode=ordinary.modes().first()),
            Selection(source="weather",collection=c.id,mode="weather",weatherSource="real",weatherDelivery="images"),
            Selection(source="weather",collection=c.id,mode="weather",weatherSource="real",weatherDelivery="zip"),
            Selection(source="weather",collection=c.id,mode="weather",weatherSource="game-world",weatherDelivery="images"),
            Selection(source="weather",collection=c.id,mode="weather",weatherSource="game-world",weatherDelivery="zip"),
            Selection(source="weather",collection=c.id,mode="weather",weatherSource="open-meteo"),
            Selection(source="weather",collection=c.id,mode="weather",weatherSource="open-meteo",weatherCity=city),
            Selection(source="weather",collection=c.id,mode="weather",weatherSource="open-meteo",weatherCity=JSONObject(city).put("origin","device").toString()),
            Selection(source="weather",collection=DailyWeather.ID,mode="weather",weatherSource="real"),
            Selection(source="weather",collection=DailyWeather.ID,mode="weather",weatherSource="game-world")
        )
        var count=0
        try{
            for(s in modes)for(target in listOf("home","lock","both"))for(busy in listOf(false,true)){
                set(a,"catalogue",d);set(a,"draft",s.copy(target=target));set(a,"busy",busy);call(a,"render")
                val expected=!busy && (!LocalWeather.active(s) || s.weatherCity.isNotBlank())
                assertEquals("apply $s / $target busy=$busy",expected,get<Button>(a,"apply").isEnabled)
                assertEquals(!busy,get<Spinner>(a,"target").isEnabled)
                if(s.source=="weather"){
                    assertEquals(View.VISIBLE,get<View>(a,"cityButton").visibility);assertEquals(View.VISIBLE,get<View>(a,"locationButton").visibility)
                    assertEquals(!busy,get<Button>(a,"cityButton").isEnabled)
                    if(DailyWeather.active(s)){assertEquals(View.GONE,get<View>(a,"zipCard").visibility);assertFalse(get<Spinner>(a,"weatherDelivery").isEnabled)}
                    if(LocalWeather.active(s))assertFalse(get<Spinner>(a,"weatherDelivery").isEnabled)
                }
                count++
            }
            println("AUDIT_MATRIX_STATES=$count")
        }finally{controller.destroy()}
    }
    @Test fun screenDraftsSurviveSwitchAndActivityRecreation() {
        val(controller,_)=setup();val a=controller.get();val c=data().collections.first{it.weather!=null && Weather.formats(it.weather).isNotEmpty()}
        val paris=Selection(source="weather",collection=c.id,mode="weather",target="home",weatherSource="open-meteo",weatherCity=JSONObject(city).put("name","Париж").toString())
        val tokyo=paris.copy(target="lock",weatherCity=JSONObject(city).put("name","Токио").toString())
        try{
            render(a,paris)
            fun switch(target: String){val chooser=get<Spinner>(a,"target");val index=listOf("home","lock","both").indexOf(target);chooser.setSelection(index,false);chooser.onItemSelectedListener!!.onItemSelected(chooser,null,index,index.toLong())}
            switch("lock");render(a,tokyo);switch("home")
            assertEquals(paris.weatherCity,get<Selection>(a,"draft").weatherCity)
            val state=android.os.Bundle();call(a,"onSaveInstanceState",state)
            val(next,_)=setup(state)
            try{val restored=next.get();assertEquals(paris.weatherCity,get<Selection>(restored,"draft").weatherCity);assertEquals(tokyo.weatherCity,get<Map<String,Selection>>(restored,"drafts").getValue("lock").weatherCity)}finally{next.destroy()}
        }finally{controller.destroy()}
    }
    @Test fun settingsPrecedePreviewAndControlsHaveAccessibleTargetsAndLabels() {
        val(controller,_)=setup();val a=controller.get();val c=data().collections.first{it.weather!=null && Weather.formats(it.weather).isNotEmpty()}
        try{
            render(a,Selection(source="weather",collection=c.id,mode="weather"))
            val root=a.window.decorView;val d=a.resources.displayMetrics.density;val w=(360*d).toInt();val h=(800*d).toInt()
            root.measure(View.MeasureSpec.makeMeasureSpec(w,View.MeasureSpec.EXACTLY),View.MeasureSpec.makeMeasureSpec(h,View.MeasureSpec.EXACTLY));root.layout(0,0,w,h)
            assertTrue(get<View>(a,"collection").top<get<View>(a,"preview").top);assertTrue(get<View>(a,"weatherBox").top<get<View>(a,"preview").top)
            for(field in listOf("cityButton","locationButton","apply","refresh","pause")){val v=get<View>(a,field);assertTrue(field+" height",v.height>=48*d);assertTrue(field+" width",v.width>=48*d);assertTrue(v.background is android.graphics.drawable.RippleDrawable)}
            for(field in listOf("target","weatherSource","weatherDelivery","collection","downloadNetwork"))assertTrue(get<View>(a,field).contentDescription.isNotBlank())
        }finally{controller.destroy()}
    }
    @Test fun brandTextColoursMeetGoogleContrastThresholds() {
        fun contrast(foreground: String,background: String)=androidx.core.graphics.ColorUtils.calculateContrast(android.graphics.Color.parseColor(foreground),android.graphics.Color.parseColor(background))
        for((ink,paper) in listOf("#272635" to "#fbf8ec","#56536b" to "#fbf8ec","#9d3766" to "#f2ead9","#ffffff" to "#9d3766","#f3ecdb" to "#141126","#b9b1ce" to "#211b38","#fbbf55" to "#211b38","#27122b" to "#fbbf55"))assertTrue("$ink / $paper",contrast(ink,paper)>=4.5)
    }
    @Test fun mixedPauseStateOffersPauseForBothAndPreservesBothProfiles() {
        val(controller,queue)=setup();val a=controller.get();val r=repo();val c=data().collections.first{it.weather!=null && Weather.formats(it.weather).isNotEmpty()}
        try{
            r.save(Selection(source="weather",collection=c.id,mode="weather",target="home"));r.save(Selection(source="weather",collection=c.id,mode="weather",target="lock",weatherSource="real"));r.setPaused("home",true)
            render(a,r.settings("both"));assertEquals("Пауза",get<Button>(a,"pause").text.toString())
            get<Button>(a,"pause").performClick();queue.runAll();shadowOf(Looper.getMainLooper()).idle()
            assertTrue(r.settings("home").paused);assertTrue(r.settings("lock").paused);assertEquals("game-world",r.settings("home").weatherSource);assertEquals("real",r.settings("lock").weatherSource)
            assertEquals("Продолжить",get<Button>(a,"pause").text.toString())
        }finally{controller.destroy()}
    }
    @Test fun pausePreservesUnappliedCity() {
        val(controller,queue)=setup();val a=controller.get();val c=data().collections.first{it.weather!=null && Weather.formats(it.weather).isNotEmpty()}
        val saved=Selection(source="weather",collection=c.id,mode="weather",target="home",weatherSource="open-meteo",weatherCity=city)
        try{
            repo().save(saved);val draft=repo().settings("home").copy(weatherCity=JSONObject(city).put("name","Париж").put("latitude",48.85).put("longitude",2.35).put("timezone","Europe/Paris").toString())
            render(a,draft);get<Button>(a,"pause").performClick();queue.runAll();shadowOf(Looper.getMainLooper()).idle()
            assertTrue(repo().settings("home").paused)
            assertEquals("Париж",JSONObject(get<Selection>(a,"draft").weatherCity).getString("name"));assertTrue(get<TextView>(a,"draftLabel").text.contains("не применены"))
            println("FIXED=pause preserves Paris draft while saved Berlin is paused")
        }finally{controller.destroy()}
    }
    @Test fun corruptPackDoesNotHideOtherValidCollections() {
        val r=repo();val good=javaClass.getResource("/published-seasonal-package.json")!!.readText()
        Net.atomic(File(r.root,"collections/seasonal/manifest.json"),good.toByteArray())
        assertTrue(r.local()!!.collections.any{it.id=="seasonal"})
        Net.atomic(File(r.root,"collections/broken/manifest.json"),"{broken".toByteArray())
        assertTrue(r.local()!!.collections.any{it.id=="seasonal"});assertTrue(r.text("local_catalogue_error").contains("broken"))
        println("FIXED=corrupt manifest is isolated; valid seasonal collection readable")
    }
    @Test fun jpegOnlyModeHidesUnusedZipPanel() {
        val(controller,_)=setup();val a=controller.get();val c=data().collections.first{it.weather!=null && Weather.formats(it.weather).isNotEmpty()}
        try{
            render(a,Selection(source="weather",collection=c.id,mode="weather",weatherSource="real",weatherDelivery="images"))
            assertEquals(View.GONE,get<View>(a,"zipCard").visibility)
            assertEquals(View.GONE,get<View>(a,"zipSummary").visibility)
            println("FIXED=JPEG-only mode hides unused ZIP panel")
        }finally{controller.destroy()}
    }
    @Test fun zipUiCoversPersistedStagesForBothNetworkPolicies() {
        val(controller,_)=setup();val a=controller.get();val d=data();val c=d.collections.first{it.weather!=null && Weather.formats(it.weather).isNotEmpty()};val r=repo()
        val descriptor=Weather.descriptor(d,c.weather!!,"phone");val hash=descriptor.getString("sha256")
        try{
            r.put("zip_descriptor_"+c.id+"_phone",descriptor.toString())
            Net.atomic(File(r.root,"weather-packages/$hash.json"),"{}".toByteArray())
            var count=0
            for(policy in listOf("wifi","any"))for(stage in listOf("pending","running","paused","downloaded","verifying","unpacking","ready","error","cancelled","outdated","")){
                r.put("download_network",policy)
                val request=android.app.DownloadManager.Request(android.net.Uri.parse(SITE+"downloads/test.zip"))
                val manager=app.getSystemService(android.app.DownloadManager::class.java);val downloadId=manager.enqueue(request)
                val shadow=org.robolectric.shadow.api.Shadow.extract<org.robolectric.shadows.ShadowDownloadManager.ShadowRequest>(request)
                shadow.status=when(stage){"pending"->android.app.DownloadManager.STATUS_PENDING;"running"->android.app.DownloadManager.STATUS_RUNNING;"paused"->android.app.DownloadManager.STATUS_PAUSED;else->android.app.DownloadManager.STATUS_SUCCESSFUL}
                shadow.totalSize=100;shadow.bytesSoFar=if(stage=="running")50 else 0
                val persisted=if(stage in listOf("pending","running","paused"))"downloading" else stage
                Net.atomic(File(r.root,"downloads/$hash.json"),JSONObject().put("download_id",downloadId).put("stage",persisted).put("archive",descriptor).put("version",descriptor.getString("version")).put("message","Контрольная ошибка").put("completed",2).put("count",10).toString().toByteArray())
                render(a,Selection(source="weather",collection=c.id,mode="weather",weatherSource="real",weatherDelivery="zip"))
                assertEquals(View.VISIBLE,get<Button>(a,"downloadAction").visibility)
                assertEquals(stage !in listOf("downloaded","verifying","unpacking","ready"),get<Button>(a,"downloadAction").isEnabled)
                if(stage=="error")assertTrue(get<TextView>(a,"zipSummary").text.contains("Контрольная ошибка"))
                if(stage=="ready")assertTrue(get<TextView>(a,"zipSummary").text.contains("готов"))
                if(stage=="running")assertTrue(get<TextView>(a,"zipSummary").text.contains("50%"))
                if(stage=="pending")assertTrue(get<TextView>(a,"zipSummary").text.contains("очереди"))
                count++
            }
            println("AUDIT_ZIP_UI_STATES=$count")
        }finally{controller.destroy()}
    }
    @Test fun networkSwitchFailureReachesStatus() {
        val(controller,queue)=setup();val a=controller.get();val c=data().collections.first{it.weather!=null && Weather.formats(it.weather).isNotEmpty()};val r=repo()
        try{
            r.put("download_network","wifi")
            val job=JSONObject().put("stage","downloading").put("network_policy","wifi").put("download_id",99).put("url","downloads/test.zip").put("sha256","a".repeat(64))
            Net.atomic(File(r.root,"collection-downloads/test.json"),job.toString().toByteArray())
            render(a,Selection(source="weather",collection=c.id,mode="weather"))
            val chooser=get<Spinner>(a,"downloadNetwork");chooser.setSelection(1,false);chooser.onItemSelectedListener!!.onItemSelected(chooser,null,1,1)
            queue.runAll();shadowOf(Looper.getMainLooper()).idle()
            assertEquals("any",DownloadRequests.policy(r));assertTrue(r.text("download_migration_error").isNotBlank())
            assertTrue(get<TextView>(a,"status").text.contains("не удалось"))
            assertEquals("wifi",JSONObject(File(r.root,"collection-downloads/test.json").readText()).getString("network_policy"))
            println("FIXED=network migration failure is visible and old request is preserved before metadata validation")
        }finally{controller.destroy()}
    }
    @Test fun refreshExplicitlyTargetsSavedProfileAndKeepsDraft() {
        val(controller,_)=setup();val a=controller.get();val c=data().collections.first{it.weather!=null && Weather.formats(it.weather).isNotEmpty()};val r=repo()
        try{
            r.save(Selection(source="weather",collection=c.id,mode="weather",target="home",weatherSource="open-meteo",weatherCity=city))
            val draft=r.settings("home").copy(weatherCity=JSONObject(city).put("name","Париж").toString());render(a,draft)
            get<Button>(a,"refresh").performClick()
            assertTrue(r.manual(r.settings("home")));assertEquals(city,r.settings("home").weatherCity);assertEquals(draft,get<Selection>(a,"draft"));assertTrue(get<Button>(a,"refresh").text.contains("установленные"));assertTrue(get<TextView>(a,"status").text.contains("форме ещё не применены"))
            println("VERIFIED=Refresh explicitly updates saved profile and preserves draft")
        }finally{controller.destroy()}
    }
    @Test @Config(qualifiers="w320dp-h480dp-night-xhdpi") fun longErrorKeepsSettingsScrollableWithLargeFont() {
        RuntimeEnvironment.setFontScale(2f);val(controller,_)=setup();val a=controller.get()
        try{
            val c=data().collections.first{it.weather!=null && Weather.formats(it.weather).isNotEmpty()};render(a,Selection(source="weather",collection=c.id,mode="weather"))
            call(a,"showStatus","Не удалось скачать пакет. Освободите память и повторите загрузку. ".repeat(8),true)
            val root=a.window.decorView;val density=a.resources.displayMetrics.density;val w=(320*density).toInt();val h=(480*density).toInt()
            root.measure(View.MeasureSpec.makeMeasureSpec(w,View.MeasureSpec.EXACTLY),View.MeasureSpec.makeMeasureSpec(h,View.MeasureSpec.EXACTLY));root.layout(0,0,w,h)
            val page=get<ScrollView>(a,"page")
            assertTrue("Settings viewport must remain available",page.height>h/4)
            assertEquals(2,get<TextView>(a,"status").maxLines)
            get<TextView>(a,"status").performClick();val dialog=org.robolectric.shadows.ShadowAlertDialog.getLatestAlertDialog();assertTrue(dialog.isShowing);dialog.dismiss()
            val image=android.graphics.Bitmap.createBitmap(w,h,android.graphics.Bitmap.Config.ARGB_8888);root.draw(android.graphics.Canvas(image))
            File("build/audit-images").mkdirs();File("build/audit-images/status-200.png").outputStream().use{image.compress(android.graphics.Bitmap.CompressFormat.PNG,100,it)};image.recycle()
            println("FIXED=long status plus font200 leaves scroll viewport height=${page.height}")
        }finally{controller.destroy()}
    }
}
