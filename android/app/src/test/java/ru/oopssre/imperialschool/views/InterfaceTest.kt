package ru.oopssre.imperialschool.views

import android.app.Application
import android.graphics.Bitmap
import android.graphics.Canvas
import android.view.View
import android.widget.Button
import android.widget.Spinner
import android.widget.TextView
import org.json.JSONObject
import org.junit.Assert.*
import org.junit.Test
import org.junit.runner.RunWith
import org.robolectric.Robolectric
import org.robolectric.RobolectricTestRunner
import org.robolectric.RuntimeEnvironment
import org.robolectric.annotation.Config
import org.robolectric.annotation.GraphicsMode
import org.robolectric.annotation.LooperMode
import java.io.File

@RunWith(RobolectricTestRunner::class)
@Config(sdk=[34],qualifiers="w360dp-h800dp-xhdpi")
@GraphicsMode(GraphicsMode.Mode.NATIVE)
@LooperMode(LooperMode.Mode.PAUSED)
class InterfaceTest {
    private val city="""{"name":"Берлин","latitude":52.52,"longitude":13.4,"timezone":"Europe/Berlin"}"""
    private fun repo()=Repository(RuntimeEnvironment.getApplication())
    private fun data()=Catalogue.parse(JSONObject(javaClass.getResource("/published-catalogue.json")!!.readText()))
    private fun set(a: MainActivity,name: String,v: Any){a.javaClass.getDeclaredField(name).apply{isAccessible=true}.set(a,v)}
    private fun <T> get(a: MainActivity,name: String): T {@Suppress("UNCHECKED_CAST") return a.javaClass.getDeclaredField(name).apply{isAccessible=true}.get(a) as T}
    private fun call(a: MainActivity,name: String,vararg args: Any){a.javaClass.declaredMethods.first{it.name==name}.apply{isAccessible=true}.invoke(a,*args)}
    @Test fun dailyChoiceSwitchesFromOpenMeteoToServerAndHidesZipControls() {
        val controller=setup();val a=controller.get()
        try {
            val d=data();val c=d.collections.first{it.weather!=null && Weather.formats(it.weather).isNotEmpty()}
            set(a,"catalogue",d);set(a,"draft",Selection(source="weather",collection=c.id,mode="weather",weatherSource="open-meteo",weatherCity=city));set(a,"busy",false);call(a,"render")
            val chooser=get<Spinner>(a,"collection");val index=(0 until chooser.count).first{chooser.getItemAtPosition(it).toString().startsWith("Погода дня")}
            chooser.setSelection(index,false)
            chooser.onItemSelectedListener!!.onItemSelected(chooser,null,index,index.toLong())
            val selected=get<Selection>(a,"draft")
            assertEquals(DailyWeather.ID,selected.collection);assertEquals("game-world",selected.weatherSource);assertEquals("images",selected.weatherDelivery)
            assertEquals(2,get<Spinner>(a,"weatherSource").count)
            assertFalse(get<Spinner>(a,"weatherDelivery").isEnabled)
            for(field in listOf("zipCard","zipSummary","downloadAction"))assertEquals("Control $field must be hidden",View.GONE,get<View>(a,field).visibility)
            for(field in listOf("cityButton","locationButton"))assertEquals("Location entry $field must remain visible",View.VISIBLE,get<View>(a,field).visibility)
            assertTrue(get<Button>(a,"apply").isEnabled)
        } finally {controller.destroy()}
    }
    @Test fun dailyFrameUsesItsActualCollectionAndVerifiedJpegForWallpaper() {
        val r=repo();val now=System.currentTimeMillis()
        val bitmap=Bitmap.createBitmap(640,1280,Bitmap.Config.ARGB_8888)
        val bytes=java.io.ByteArrayOutputStream().also{bitmap.compress(Bitmap.CompressFormat.JPEG,90,it)}.toByteArray();bitmap.recycle()
        val hash=java.security.MessageDigest.getInstance("SHA-256").digest(bytes).joinToString(""){"%02x".format(it)}
        val f=JSONObject().put("format","jpeg").put("rendition","phone").put("width",640).put("height",1280).put("bytes",bytes.size).put("sha256",hash).put("url","collections/server-chosen/files/autumn-day-clear-phone.jpg")
        val p=JSONObject().put("schema",1).put("document_type","weather-of-day").put("type","weather").put("collection_id","server-chosen").put("title","Выбор сервера").put("source_id","real").put("selection_date","2026-10-31").put("status","ready").put("location_revision","r").put("timezone","Europe/Moscow")
            .put("valid_from",java.time.Instant.ofEpochMilli(now-60000).toString()).put("valid_until",java.time.Instant.ofEpochMilli(now+3600000).toString()).put("refresh_after",java.time.Instant.ofEpochMilli(now+3600000).toString())
            .put("formats",JSONObject().put("phone",JSONObject().put("width",640).put("height",1280))).put("files",JSONObject().put("phone",f))
        Net.atomic(File(r.root,"catalogue.json"),javaClass.getResource("/published-catalogue.json")!!.readBytes())
        Net.atomic(File(r.root,"weather-daily/real.json"),JSONObject().put("checked_at",now).put("current",p).toString().toByteArray())
        Net.atomic(File(r.root,"weather-images/$hash.jpg"),bytes)
        r.save(Selection(source="weather",collection=DailyWeather.ID,weatherSource="real",weatherDelivery="images",target="home",mode="weather"))
        androidx.work.WorkManager.initialize(r.context,androidx.work.Configuration.Builder().setExecutor{ }.setTaskExecutor{ }.build())
        FrameEngine.run(r.context,"home",true)
        assertEquals(hash,r.text("hash_1"));assertTrue(r.text("status_home").startsWith("Обои установлены:"))
        assertFalse(r.text("status_home").contains(DailyWeather.ID));assertTrue(r.text("status_home").contains("Выбор сервера"))
    }
    @Test fun locationButtonIsVisibleForBothServerSourcesAndRequestsPermissionDirectly() {
        val controller=setup();val a=controller.get()
        try {
            val d=data();val c=d.collections.first{it.weather!=null && Weather.formats(it.weather).isNotEmpty()}
            for(source in listOf("real","game-world")){
                set(a,"catalogue",d);set(a,"draft",Selection(source="weather",collection=c.id,mode="weather",weatherSource=source,target="lock"));set(a,"busy",false);call(a,"render")
                assertEquals(View.VISIBLE,get<Button>(a,"cityButton").visibility);assertEquals(View.VISIBLE,get<Button>(a,"locationButton").visibility)
                get<Button>(a,"locationButton").performClick()
                assertEquals("open-meteo",get<Selection>(a,"draft").weatherSource)
                assertEquals(c.id,get<Selection>(a,"draft").collection);assertEquals("lock",get<Selection>(a,"draft").target)
                val request=org.robolectric.Shadows.shadowOf(a).lastRequestedPermission
                assertEquals(21,request.requestCode)
                assertTrue(request.requestedPermissions.contains(android.Manifest.permission.ACCESS_COARSE_LOCATION))
                call(a,"cancelLocation")
            }
        }finally{controller.destroy()}
    }
    @Test fun manualCityButtonSwitchesServerSourceAndOpensCitySearch() {
        val controller=setup();val a=controller.get()
        try {
            val d=data();val c=d.collections.first{it.weather!=null && Weather.formats(it.weather).isNotEmpty()}
            set(a,"catalogue",d);set(a,"draft",Selection(source="weather",collection=c.id,mode="weather",weatherSource="real"));set(a,"busy",false);call(a,"render")
            get<Button>(a,"cityButton").performClick()
            assertEquals("open-meteo",get<Selection>(a,"draft").weatherSource)
            val dialog=org.robolectric.shadows.ShadowAlertDialog.getLatestAlertDialog()
            assertTrue(dialog.isShowing);assertEquals("Open-Meteo · поиск города",org.robolectric.Shadows.shadowOf(dialog).title.toString())
            dialog.dismiss()
        }finally{controller.destroy()}
    }
    @Test fun dailyLocationButtonAsksForACollectionThenRequestsLocation() {
        val controller=setup();val a=controller.get()
        try {
            val d=data();set(a,"catalogue",d);set(a,"draft",Selection(source="weather",collection=DailyWeather.ID,mode="weather",weatherSource="real"));set(a,"busy",false);call(a,"render")
            get<Button>(a,"locationButton").performClick()
            assertEquals(DailyWeather.ID,get<Selection>(a,"draft").collection)
            val dialog=org.robolectric.shadows.ShadowAlertDialog.getLatestAlertDialog()
            assertEquals("Выберите коллекцию для Open-Meteo",org.robolectric.Shadows.shadowOf(dialog).title.toString())
            val list=dialog.listView;list.performItemClick(list.getChildAt(0),0,0)
            assertEquals("open-meteo",get<Selection>(a,"draft").weatherSource)
            assertNotEquals(DailyWeather.ID,get<Selection>(a,"draft").collection)
            assertEquals(21,org.robolectric.Shadows.shadowOf(a).lastRequestedPermission.requestCode)
            dialog.dismiss()
        }finally{controller.destroy()}
    }
    @Test fun manualCityAndDeviceLocationAreBothVisibleAndLateFixCannotChangeAnotherScreen() {
        val controller=setup();val a=controller.get()
        try {
            val selected=Selection(source="weather",collection=data().collections.first{it.weather!=null && Weather.formats(it.weather).isNotEmpty()}.id,mode="weather",weatherSource="open-meteo",weatherCity=city,target="home")
            set(a,"catalogue",data());set(a,"draft",selected);set(a,"busy",false);call(a,"render")
            assertEquals(View.VISIBLE,get<Button>(a,"cityButton").visibility)
            assertEquals(View.VISIBLE,get<Button>(a,"locationButton").visibility)
            assertTrue(get<Button>(a,"cityButton").text.contains("вручную"))
            val token=get<Int>(a,"citySearchGeneration")
            set(a,"draft",selected.copy(target="lock"))
            call(a,"completeLocation",selected,token,JSONObject(city).put("origin","device"))
            assertFalse(LocalWeather.deviceLocation(get(a,"draft")))
            set(a,"draft",selected)
            call(a,"completeLocation",selected,token,JSONObject(city).put("origin","device"))
            assertTrue(LocalWeather.deviceLocation(get(a,"draft")))
            repo().save(get(a,"draft"))
            assertTrue(LocalWeather.deviceLocation(repo().settings("home")))
        } finally {controller.destroy()}
    }
    private fun setup(): org.robolectric.android.controller.ActivityController<MainActivity> {
        val r=repo();r.save(Selection(source="local",collection="missing",target="home"))
        return Robolectric.buildActivity(MainActivity::class.java).create()
    }
    @Test fun realRepositorySavesOpenMeteoAndKeepsLockProfile() {
        val r=repo();r.save(Selection(source="weather",weatherSource="game-world",target="lock",collection="test"))
        r.save(Selection(source="weather",weatherSource="open-meteo",weatherCity=city,target="home",collection="test"))
        assertEquals(city,r.settings("home").weatherCity)
        assertEquals("game-world",r.settings("lock").weatherSource)
        assertThrows(IllegalArgumentException::class.java){r.save(r.settings("home").copy(weatherCity=""))}
    }
    @Test fun missingCityDisablesApplyAndShowsReason() {
        val controller=setup();val a=controller.get()
        try {
            val d=data();val c=d.collections.first{it.weather!=null}
            set(a,"draft",Selection(source="weather",collection=c.id,mode="weather",weatherSource="open-meteo",target="home"))
            set(a,"catalogue",d);set(a,"busy",false);call(a,"render");call(a,"loadPreview")
            assertFalse(get<Button>(a,"apply").isEnabled)
            assertEquals(View.VISIBLE,get<Button>(a,"cityButton").visibility)
            assertTrue(get<TextView>(a,"caption").text.contains("Выберите город"))
            assertEquals(3,get<Spinner>(a,"weatherSource").adapter.count)
        }finally{controller.destroy()}
    }
    @Test fun applyButtonActuallyPersistsSelectedCity() {
        val controller=setup();val a=controller.get()
        try {
            val d=data();val c=d.collections.first{it.weather!=null}
            set(a,"draft",Selection(source="weather",collection=c.id,mode="weather",weatherSource="open-meteo",weatherCity=city,target="home"))
            set(a,"catalogue",d);set(a,"busy",false);call(a,"render")
            assertTrue(get<Button>(a,"apply").isEnabled);get<Button>(a,"apply").performClick()
            val r=repo();val until=System.currentTimeMillis()+5000
            while(r.settings("home").weatherSource!="open-meteo" && System.currentTimeMillis()<until)Thread.sleep(10)
            assertEquals("open-meteo",r.settings("home").weatherSource);assertEquals(city,r.settings("home").weatherCity)
        }finally{controller.destroy()}
    }
    @Test fun bothArchiveTypesAllowMobileAndWifi() {
        val request=DownloadRequests.allowNetworks(android.app.DownloadManager.Request(android.net.Uri.parse("https://games.oopssre.ru/file.zip")))
        val shadow=org.robolectric.shadow.api.Shadow.extract<org.robolectric.shadows.ShadowDownloadManager.ShadowRequest>(request)
        assertTrue(shadow.allowedOverMetered);assertTrue(shadow.allowedOverRoaming)
        assertTrue(shadow.allowedNetworkTypes and android.app.DownloadManager.Request.NETWORK_WIFI!=0)
        assertTrue(shadow.allowedNetworkTypes and android.app.DownloadManager.Request.NETWORK_MOBILE!=0)
    }
    @Test fun networkSelectorIsVisibleAndPersistsChoice() {
        val controller=setup();val a=controller.get()
        try {
            val d=data();val c=d.collections.first{it.weather!=null}
            set(a,"draft",Selection(source="weather",collection=c.id,mode="weather",weatherSource="real"))
            set(a,"catalogue",d);set(a,"busy",false);call(a,"render")
            val select=get<Spinner>(a,"downloadNetwork")
            assertEquals(View.VISIBLE,get<View>(a,"zipCard").visibility)
            assertEquals("Только Wi-Fi",select.adapter.getItem(0))
            assertEquals("Wi-Fi и мобильная сеть",select.adapter.getItem(1))
            select.setSelection(0,false);select.onItemSelectedListener!!.onItemSelected(select,null,0,0)
            assertEquals("wifi",DownloadRequests.policy(repo()))
            val request=DownloadRequests.allowNetworks(android.app.DownloadManager.Request(android.net.Uri.parse("https://games.oopssre.ru/file.zip")),"wifi")
            val shadow=org.robolectric.shadow.api.Shadow.extract<org.robolectric.shadows.ShadowDownloadManager.ShadowRequest>(request)
            assertFalse(shadow.allowedOverMetered)
            assertEquals(android.app.DownloadManager.Request.NETWORK_WIFI,shadow.allowedNetworkTypes)
        }finally{controller.destroy()}
    }
    @Test fun zipProgressIsVisibleInCardAndFixedFooter() {
        val controller=setup();val a=controller.get()
        try {
            call(a,"showZipStatus",JSONObject().put("stage","downloading").put("transfer_status",2).put("received",50*1048576).put("total",100*1048576))
            val text=get<TextView>(a,"downloadState").text.toString()
            assertTrue(text.contains("50%"));assertTrue(text.contains("МБ"))
            assertEquals(text,get<TextView>(a,"zipSummary").text.toString())
        }finally{controller.destroy()}
    }
    @Test fun zipStatusDoesNotDependOnCityOrForecast() {
        val controller=setup();val a=controller.get()
        try {
            val d=data();val c=d.collections.first{it.weather!=null};val weather=c.weather!!
            val selected=Selection(source="weather",collection=c.id,mode="weather",weatherSource="open-meteo")
            val descriptor=Weather.descriptor(d,weather,"phone");val r=repo()
            r.put("zip_descriptor_"+c.id+"_phone",descriptor.toString())
            Net.atomic(File(r.root,"downloads/"+descriptor.getString("sha256")+".json"),JSONObject().put("stage","verifying").put("version",descriptor.getString("version")).toString().toByteArray())
            set(a,"draft",selected);set(a,"catalogue",d);set(a,"busy",false);call(a,"render");call(a,"pollWeather")
            assertTrue(get<TextView>(a,"zipSummary").text.contains("проверяю архив"))
            assertEquals(View.VISIBLE,get<android.widget.ProgressBar>(a,"progress").visibility)
        }finally{controller.destroy()}
    }
    @Test fun busyScreenCannotChangeTargetOrInvalidateCatalog() {
        val controller=setup();val a=controller.get()
        try {
            set(a,"catalogue",data());set(a,"busy",true);call(a,"render")
            assertFalse(get<Spinner>(a,"target").isEnabled)
            assertFalse(get<Button>(a,"weatherTab").isEnabled)
            val before=get<Int>(a,"generation");call(a,"pollWeather");call(a,"loadPreview")
            assertEquals(before,get<Int>(a,"generation"))
        }finally{controller.destroy()}
    }
    @Test fun noDataReasonIsVisibleAndCancellationCanBeRetried() {
        val controller=setup();val a=controller.get()
        try {
            call(a,"showNoData","Недостаточно свободного места")
            assertEquals("Недостаточно свободного места",get<TextView>(a,"caption").text.toString())
            set(a,"busy",false);call(a,"showDownloadAction","cancelled",true)
            assertTrue(get<Button>(a,"downloadAction").isEnabled)
            assertTrue(get<Button>(a,"downloadAction").text.contains("Повторить"))
        }finally{controller.destroy()}
    }
    @Test fun renderOrdinaryServerWorldAndCityScreens() {
        val controller=setup();val a=controller.get()
        try {
            val d=data();set(a,"catalogue",d);set(a,"busy",false)
            val c=d.collections.first{it.weather!=null}
            val normal=d.collections.first{it.weather==null}
            val states=listOf(
                "ordinary" to Selection(source="online",collection=normal.id,mode=normal.modes().first()),
                "server" to Selection(source="weather",collection=c.id,mode="weather",weatherSource="real"),
                "world" to Selection(source="weather",collection=c.id,mode="weather",weatherSource="game-world"),
                "city" to Selection(source="weather",collection=c.id,mode="weather",weatherSource="open-meteo",weatherCity=city),
                "geo" to Selection(source="weather",collection=c.id,mode="weather",weatherSource="open-meteo",weatherCity=JSONObject(city).put("name","Моё местоположение").put("origin","device").toString()),
                "daily" to Selection(source="weather",collection=DailyWeather.ID,mode="weather",weatherSource="real",weatherDelivery="images"),
                "daily-world" to Selection(source="weather",collection=DailyWeather.ID,mode="weather",weatherSource="game-world",weatherDelivery="images")
            )
            val folder=File(if(RuntimeEnvironment.getFontScale()>1f)"build/ui-review-large" else "build/ui-review").apply{mkdirs()}
            val w=(a.resources.configuration.screenWidthDp*a.resources.displayMetrics.density).toInt()
            val h=(a.resources.configuration.screenHeightDp*a.resources.displayMetrics.density).toInt()
            for((name,s) in states) {
                set(a,"draft",s);call(a,"render")
                val root=a.window.decorView
                root.measure(View.MeasureSpec.makeMeasureSpec(w,View.MeasureSpec.EXACTLY),View.MeasureSpec.makeMeasureSpec(h,View.MeasureSpec.EXACTLY));root.layout(0,0,w,h)
                val b=Bitmap.createBitmap(w,h,Bitmap.Config.ARGB_8888);root.draw(Canvas(b))
                File(folder,"$name.png").outputStream().use{b.compress(Bitmap.CompressFormat.PNG,100,it)};b.recycle()
                val page=get<android.widget.ScrollView>(a,"page");page.scrollTo(0,page.getChildAt(0).height)
                val bottom=Bitmap.createBitmap(w,h,Bitmap.Config.ARGB_8888);root.draw(Canvas(bottom))
                File(folder,"$name-bottom.png").outputStream().use{bottom.compress(Bitmap.CompressFormat.PNG,100,it)};bottom.recycle()
                page.scrollTo(0,get<View>(a,"zipCard").top)
                val card=Bitmap.createBitmap(w,h,Bitmap.Config.ARGB_8888);root.draw(Canvas(card))
                File(folder,"$name-zip.png").outputStream().use{card.compress(Bitmap.CompressFormat.PNG,100,it)};card.recycle()
                if(name!="ordinary"){
                    page.scrollTo(0,get<View>(a,"weatherBox").top)
                    val location=Bitmap.createBitmap(w,h,Bitmap.Config.ARGB_8888);root.draw(Canvas(location))
                    File(folder,"$name-location.png").outputStream().use{location.compress(Bitmap.CompressFormat.PNG,100,it)};location.recycle()
                    listOf("cityButton","locationButton").forEach{field->val button=get<Button>(a,field);assertTrue("Location button clips",button.height>=button.layout.height+button.compoundPaddingTop+button.compoundPaddingBottom)}
                }
                page.scrollTo(0,0)
                assertTrue(get<Button>(a,"apply").isEnabled)
                listOf("apply","refresh","pause").forEach{field->val button=get<Button>(a,field);assertTrue("Button $field clips text",button.height>=button.layout.height+button.compoundPaddingTop+button.compoundPaddingBottom)}
                if(name=="server")assertEquals("Погода с сервера",get<Spinner>(a,"weatherSource").selectedItem.toString())
            }
        }finally{controller.destroy()}
    }
    @Test @Config(qualifiers="w320dp-h640dp-night-xhdpi") fun smallDarkScreenWithLargeFont() {
        RuntimeEnvironment.setFontScale(1.5f)
        renderOrdinaryServerWorldAndCityScreens()
    }
    @Test fun ordinaryZipUsesHashEvenWhenCatalogueByteCountIsWrong() {
        val r=repo();val id="test-archive"
        val bitmap=Bitmap.createBitmap(640,1280,Bitmap.Config.ARGB_8888)
        val bytes=java.io.ByteArrayOutputStream().also{bitmap.compress(Bitmap.CompressFormat.JPEG,90,it)}.toByteArray();bitmap.recycle()
        val imageHash=java.security.MessageDigest.getInstance("SHA-256").digest(bytes).joinToString(""){"%02x".format(it)}
        val image=JSONObject().put("url","files/image.jpg").put("width",640).put("height",1280).put("bytes",bytes.size).put("sha256",imageHash)
        val item=JSONObject().put("id","view").put("title","Test").put("preview","previews/image.jpg").put("files",org.json.JSONArray().put(image))
        val pack=JSONObject().put("schema",1).put("id",id).put("title","Test").put("items",org.json.JSONArray().put(item))
        val archive=File(r.root,"sample.zip")
        java.util.zip.ZipOutputStream(archive.outputStream()).use{z->
            mapOf("manifest.json" to pack.toString().toByteArray(),"files/image.jpg" to bytes,"previews/image.jpg" to bytes).forEach{(name,b)->z.putNextEntry(java.util.zip.ZipEntry(name));z.write(b);z.closeEntry()}
        }
        val job=JSONObject().put("collection",id).put("stage","downloaded").put("download_id",123).put("path",archive.path).put("bytes",1).put("sha256",Net.sha(archive))
        Net.atomic(File(r.root,"collection-downloads/$id.json"),job.toString().toByteArray())
        CollectionDownloads.unpack(r,id){false}
        assertTrue(File(r.root,"collections/$id/manifest.json").isFile)
        assertEquals("ready",CollectionDownloads.progress(r,id).getString("stage"))
    }
    @Test fun actionableErrorsDistinguishSpaceNetworkAndArchiveMismatch() {
        assertTrue(UiErrors.message(java.net.UnknownHostException()).contains("интернет"))
        assertTrue(UiErrors.download(1006).contains("свободного места"))
        assertTrue(UiErrors.download(404).contains("HTTP 404"))
    }
}
