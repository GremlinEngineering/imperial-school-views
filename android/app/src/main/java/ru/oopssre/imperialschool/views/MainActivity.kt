package ru.oopssre.imperialschool.views

import android.Manifest
import android.app.Activity
import android.content.Intent
import android.content.pm.PackageManager
import android.content.res.Configuration
import android.graphics.BitmapFactory
import android.graphics.Color
import android.graphics.Typeface
import android.graphics.drawable.GradientDrawable
import android.net.Uri
import android.os.Build
import android.os.Bundle
import android.os.Handler
import android.os.Looper
import android.provider.Settings
import org.json.JSONObject
import android.view.Gravity
import android.view.View
import android.view.WindowInsets
import android.widget.*
import java.util.concurrent.Executors

class MainActivity: Activity() {
    private val executor=Executors.newSingleThreadExecutor()
    private val network=Executors.newFixedThreadPool(2)
    private val handler=Handler(Looper.getMainLooper())
    private lateinit var page: ScrollView
    private lateinit var repo: Repository
    private var draft=Selection()
    private val drafts=mutableMapOf<String,Selection>()
    private lateinit var draftLabel: TextView
    private var profilesExpanded=false
    private var fullStatus=""
    private var catalogue: Catalogue?=null
    private var generation=0
    private var citySearchGeneration=0
    private var suppress=false
    private var busy=false
    private var seenStatus=""
    private lateinit var source: Spinner
    private lateinit var collection: Spinner
    private lateinit var mode: Spinner
    private lateinit var target: Spinner
    private lateinit var weatherSource: Spinner
    private lateinit var weatherDelivery: Spinner
    private lateinit var locationButton: Button
    private lateinit var locationInfo: TextView
    private var deviceLocation: DeviceLocation?=null
    private var locationDialog: android.app.AlertDialog?=null
    private var pendingLocation: Selection?=null
    private lateinit var cityButton: Button
    private lateinit var weatherCredit: TextView
    private lateinit var weatherBox: LinearLayout
    private lateinit var downloadAction: Button
    private lateinit var downloadNetwork: Spinner
    private lateinit var zipCard: LinearLayout
    private lateinit var zipSummary: TextView
    private var statusHoldUntil=0L
    private lateinit var progress: ProgressBar
    private lateinit var downloadState: TextView
    private lateinit var caption: TextView
    private lateinit var exactButton: Button
    private var previewSignature=""
    private var catalogueStamp=0L
    private val sourceIds=listOf("day","online","zip","local")
    private lateinit var ordinaryTab: Button
    private lateinit var dynamicTab: Button
    private lateinit var weatherTab: Button
    private lateinit var sectionHelp: TextView
    private lateinit var profilesSummary: TextView
    private lateinit var targetHelp: TextView
    private lateinit var sourceLabel: TextView
    private lateinit var collectionLabel: TextView
    private lateinit var modeLabel: TextView
    private lateinit var stopManaging: Button
    private lateinit var viewSaved: Button
    private lateinit var downloadPack: Button
    private lateinit var sourceAction: Button
    private lateinit var apply: Button
    private lateinit var refresh: Button
    private lateinit var pause: Button
    private lateinit var status: TextView
    private lateinit var title: TextView
    private lateinit var preview: ImageView
    private lateinit var notifyCollections: CheckBox
    private lateinit var notifyApp: CheckBox
    private lateinit var update: Button
    private val dark get()=(resources.configuration.uiMode and Configuration.UI_MODE_NIGHT_MASK)==Configuration.UI_MODE_NIGHT_YES
    private val paper get()=Color.parseColor(if(dark)"#141126" else "#fbf8ec")
    private val ink get()=Color.parseColor(if(dark)"#f3ecdb" else "#272635")
    private val muted get()=Color.parseColor(if(dark)"#b9b1ce" else "#56536b")
    private val accent get()=Color.parseColor(if(dark)"#fbbf55" else "#9d3766")
    private val accentInk get()=Color.parseColor(if(dark)"#27122b" else "#ffffff")
    private val panel get()=Color.parseColor(if(dark)"#211b38" else "#f2ead9")
    private val line get()=Color.parseColor(if(dark)"#514560" else "#c8c2af")
    private fun dp(n: Int)=(n*resources.displayMetrics.density+.5f).toInt()
    private fun face(id: Int): Typeface=resources.getFont(id)
    private fun shape(fill: Int,border: Boolean=false)=GradientDrawable().apply { setColor(fill);cornerRadius=dp(4).toFloat();if(border)setStroke(dp(1),line) }
    private fun controlShape(fill: Int,border: Boolean=false)=android.graphics.drawable.RippleDrawable(android.content.res.ColorStateList.valueOf(android.graphics.Color.argb(45,Color.red(accent),Color.green(accent),Color.blue(accent))),shape(fill,border),shape(Color.WHITE))
    private fun editable(s: Selection)=s.copy(source=if(s.source=="zip")"local" else s.source,paused=false,revision="")
    private fun dirty(): Boolean {
        val profiles=repo.savedProfiles()
        val complete=when(draft.target){"home"->profiles.home!=null;"lock"->profiles.lock!=null;else->profiles.home!=null && profiles.lock!=null && editable(profiles.home.copy(target="both"))==editable(profiles.lock.copy(target="both"))}
        return !complete || editable(draft)!=editable(repo.settings(draft.target))
    }
    private fun savedPaused(target: String): Boolean {
        if(target!="both")return repo.settings(target).paused
        val profiles=repo.savedProfiles();val active=listOfNotNull(profiles.home,profiles.lock)
        return active.isNotEmpty() && active.all{it.paused}
    }
    private fun updateDraftLabel(){
        drafts[draft.target]=draft
        if(::draftLabel.isInitialized){draftLabel.text=if(dirty())"Изменения не применены" else "Настройки сохранены";draftLabel.setTextColor(if(dirty())accent else muted)}
    }
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        repo=Repository(applicationContext);draft=repo.settings()
        savedInstanceState?.getString("selection")?.let{try{draft=Selection.parse(JSONObject(it))}catch(ignored: Exception){}}
        savedInstanceState?.getString("drafts")?.let{try{val saved=JSONObject(it);saved.keys().forEach{key->drafts[key]=Selection.parse(saved.getJSONObject(key))}}catch(ignored: Exception){}}
        profilesExpanded=savedInstanceState?.getBoolean("profiles_expanded",false) ?: false
        buildUI();executor.execute{val result=DownloadRequests.resumeLegacy(repo);if(result.errors.isNotEmpty())runOnUiThread{if(!isDestroyed)showStatus(DownloadRequests.message(DownloadRequests.policy(repo),result))}};loadCatalogue(repo.online(draft));showUpdateIntent()
        network.execute { if(repo.online(draft))try { AppRelease.check(applicationContext,repo);runOnUiThread{if(!isDestroyed)updateLink()} } catch(ignored: Exception){} }
    }
    private fun buildUI() {
        window.statusBarColor=Color.TRANSPARENT;window.navigationBarColor=Color.TRANSPARENT
        @Suppress("DEPRECATION")
        window.decorView.systemUiVisibility=View.SYSTEM_UI_FLAG_LAYOUT_STABLE or View.SYSTEM_UI_FLAG_LAYOUT_FULLSCREEN or View.SYSTEM_UI_FLAG_LAYOUT_HIDE_NAVIGATION or (if(!dark)View.SYSTEM_UI_FLAG_LIGHT_STATUS_BAR or View.SYSTEM_UI_FLAG_LIGHT_NAVIGATION_BAR else 0)
        val scroll=ScrollView(this).apply { setBackgroundColor(paper);isFillViewport=true }
        scroll.setOnApplyWindowInsetsListener { view,insets ->
            if(Build.VERSION.SDK_INT>=30) { val bars=insets.getInsets(WindowInsets.Type.systemBars() or WindowInsets.Type.displayCutout());view.setPadding(bars.left,bars.top,bars.right,bars.bottom) }
            else { @Suppress("DEPRECATION") view.setPadding(insets.systemWindowInsetLeft,insets.systemWindowInsetTop,insets.systemWindowInsetRight,insets.systemWindowInsetBottom) }
            insets
        }
        val body=LinearLayout(this).apply { orientation=LinearLayout.VERTICAL;setPadding(dp(24),dp(20),dp(24),dp(24)) };scroll.addView(body)
        fun text(value: String,size: Float,color: Int=ink,font: Int=0): TextView = TextView(this).apply { text=value;textSize=size;setTextColor(color);typeface=if(font==0)Typeface.create("sans-serif",Typeface.NORMAL) else face(font);includeFontPadding=true;setLineSpacing(dp(3).toFloat(),1f) }
        fun add(view: View,top: Int=0,height: Int=LinearLayout.LayoutParams.WRAP_CONTENT) { if(height>=0 && view is Button)view.minimumHeight=dp(height);body.addView(view,LinearLayout.LayoutParams(-1,if(height>=0 && view !is Button)dp(height) else height.takeIf{it<0} ?: LinearLayout.LayoutParams.WRAP_CONTENT).apply{topMargin=dp(top)}) }
        fun label(value: String,top: Int=16) { add(text(value,12f,muted,R.font.ptmono),top) }
        fun button(value: String,action: ()->Unit): Button=Button(this).apply { text=value;isAllCaps=false;textSize=15f;typeface=Typeface.create("sans-serif",Typeface.NORMAL);setTextColor(accent);background=controlShape(panel,true);minimumHeight=dp(48);minimumWidth=dp(48);setTextColor(android.content.res.ColorStateList(arrayOf(intArrayOf(-android.R.attr.state_enabled),intArrayOf()),intArrayOf(muted,accent)));setPadding(dp(12),dp(8),dp(12),dp(8));setOnClickListener{try{action()}catch(e: Exception){showStatus(UiErrors.message(e))}} }
        fun spinner(): Spinner = Spinner(this).apply { id=View.generateViewId();minimumWidth=dp(48);minimumHeight=dp(48);background=controlShape(panel,true);setPadding(dp(12),0,dp(8),0) }
        val brand=LinearLayout(this).apply { orientation=LinearLayout.HORIZONTAL;gravity=Gravity.CENTER_VERTICAL }
        brand.addView(ImageView(this).apply { setImageResource(if(dark)R.drawable.gamepad_dark else R.drawable.gamepad_light);contentDescription="Школа Империи";scaleType=ImageView.ScaleType.FIT_CENTER },LinearLayout.LayoutParams(dp(48),dp(44)))
        brand.addView(text("ШКОЛА ИМПЕРИИ\nIMPERIAL SCHOOL",10f,accent,R.font.ptmono),LinearLayout.LayoutParams(-1,-2).apply { leftMargin=dp(14) });add(brand)
        add(text("Виды и обои",28f,ink,R.font.oswald_semibold),12)
        add(View(this).apply { setBackgroundColor(accent) },8,2)
        add(text("Обои по погоде, времени суток и вашему выбору.",14f,muted,R.font.literata),10)
        label("Настраиваемый экран")
        target=spinner();add(target,6)
        profilesSummary=text("",12f,muted).apply{minimumHeight=dp(48);isFocusable=true;setOnClickListener{profilesExpanded=!profilesExpanded;render()}};add(profilesSummary,8)
        targetHelp=text("",12f,muted);add(targetHelp,6)
        draftLabel=text("",13f,accent,R.font.ptmono);draftLabel.accessibilityLiveRegion=View.ACCESSIBILITY_LIVE_REGION_POLITE;add(draftLabel,6)
        stopManaging=button("Не менять этот экран") {
            val t=draft.target
            busy=true;render()
            executor.execute { try{repo.stopManaging(t);Schedule.configure(applicationContext);runOnUiThread{if(!isDestroyed){busy=false;if(draft.target==t){draft=draft.copy(paused=false,revision="");seenStatus="";render();showStatus("Автосмена отключена. Текущие обои сохранены.")}}}}catch(e: Exception){runOnUiThread{if(!isDestroyed){busy=false;render();showStatus(UiErrors.message(e))}}} }
        };add(stopManaging,8,48)
        val tabs=LinearLayout(this).apply{orientation=LinearLayout.HORIZONTAL}
        ordinaryTab=button("Обычные обои"){if(draft.source in listOf("weather","dynamic"))switchSource("day")}
        weatherTab=button("Погодные обои"){if(draft.source!="weather")switchSource("weather")}
        tabs.addView(ordinaryTab,LinearLayout.LayoutParams(0,-2,1f))
        tabs.addView(weatherTab,LinearLayout.LayoutParams(0,-2,1f).apply{leftMargin=dp(8)})
        add(tabs,18)
        dynamicTab=button("Динамические обои"){if(draft.source!="dynamic")switchSource("dynamic")};add(dynamicTab,6)
        sectionHelp=text("",13f,muted);add(sectionHelp,10)
        sourceLabel=text("Источник обычных обоев",12f,muted,R.font.ptmono);add(sourceLabel,16)
        source=spinner();add(source,6)
        sourceAction=button("Обновить список") { if(draft.source=="local" || draft.source=="zip")chooseZip() else loadCatalogue(true) };add(sourceAction,10,48)
        collectionLabel=text("Коллекция",12f,muted,R.font.ptmono);add(collectionLabel,16);collection=spinner();add(collection,6)
        viewSaved=button("Посмотреть скачанные обои") {
            startActivity(Intent(this,WallpaperViewerActivity::class.java).putExtra("selection",draft.json().toString()))
        };add(viewSaved,8,48)
        downloadPack=button("Скачать пакет с сайта") { downloadCollection() };add(downloadPack,10,52)
        modeLabel=text("Смена обоев",12f,muted,R.font.ptmono);add(modeLabel,16);mode=spinner();add(mode,6)
        weatherBox=LinearLayout(this).apply{orientation=LinearLayout.VERTICAL}
        weatherBox.addView(text("Источник погоды",12f,muted,R.font.ptmono));weatherSource=spinner();weatherBox.addView(weatherSource,LinearLayout.LayoutParams(-1,-2))
        weatherBox.addView(text("Город или геолокация · Open-Meteo",12f,muted,R.font.ptmono))
        cityButton=button("Выбрать город…"){selectLocalWeather{chooseCity()}};cityButton.minimumHeight=dp(52);weatherBox.addView(cityButton,LinearLayout.LayoutParams(-1,-2))
        locationButton=button("Определить по геолокации…"){selectLocalWeather{chooseLocation()}};locationButton.minimumHeight=dp(52);weatherBox.addView(locationButton,LinearLayout.LayoutParams(-1,-2))
        locationInfo=text("",12f,muted);weatherBox.addView(locationInfo)
        weatherCredit=text("Данные: Open-Meteo · GeoNames",12f,muted,R.font.ptmono).apply{minimumHeight=dp(48);isFocusable=true;setOnClickListener{open("https://open-meteo.com/")}};weatherBox.addView(weatherCredit)
        weatherBox.addView(text("Загрузка кадров",12f,muted,R.font.ptmono));weatherDelivery=spinner();weatherBox.addView(weatherDelivery,LinearLayout.LayoutParams(-1,-2));add(weatherBox,12)
        exactButton=button("Разрешить точную автосмену") {if(Build.VERSION.SDK_INT>=31)try{startActivity(Intent(Settings.ACTION_REQUEST_SCHEDULE_EXACT_ALARM,Uri.parse("package:"+packageName)))}catch(e: Exception){showStatus("Откройте настройки разрешений этого приложения.")}};add(exactButton,10,48)
        notifyCollections=CheckBox(this).apply { text="Сообщать о новых коллекциях";textSize=14f;setTextColor(ink);minimumHeight=dp(48);setOnCheckedChangeListener{_,checked->if(!suppress){draft=draft.copy(notifyCollections=checked);updateDraftLabel()}} };add(notifyCollections,12)
        notifyApp=CheckBox(this).apply { text="Сообщать об обновлениях приложения";textSize=14f;setTextColor(ink);minimumHeight=dp(48);setOnCheckedChangeListener{_,checked->if(!suppress){draft=draft.copy(notifyApp=checked);updateDraftLabel()}} };add(notifyApp)
        preview=ImageView(this).apply { scaleType=ImageView.ScaleType.FIT_CENTER;background=shape(panel,true);contentDescription="Предпросмотр обоев";setPadding(dp(8),dp(8),dp(8),dp(8)) };add(preview,18,300)
        title=text("Выберите коллекцию",23f,ink,R.font.oswald_semibold);add(title,12)
        caption=text("",12f,muted);add(caption,6)
        downloadState=text("",12f,muted);downloadState.accessibilityLiveRegion=View.ACCESSIBILITY_LIVE_REGION_POLITE;add(downloadState,10)
        downloadAction=button("Скачать ZIP коллекции"){archiveAction()};add(downloadAction,8,52)
        progress=ProgressBar(this,null,android.R.attr.progressBarStyleHorizontal).apply{max=100};add(progress,4,6)
        status=text("",13f,muted).apply{maxLines=2;ellipsize=android.text.TextUtils.TruncateAt.END;minimumHeight=dp(48);isFocusable=true;setOnClickListener{if(fullStatus.isNotBlank())android.app.AlertDialog.Builder(this@MainActivity).setTitle("Подробности").setMessage(fullStatus).setPositiveButton("Закрыть",null).show()}};status.accessibilityLiveRegion=View.ACCESSIBILITY_LIVE_REGION_POLITE;add(status,12)
        apply=button("Применить") { applySelection() }.apply { background=controlShape(accent);setTextColor(android.content.res.ColorStateList(arrayOf(intArrayOf(-android.R.attr.state_enabled),intArrayOf()),intArrayOf(if(dark)Color.parseColor("#514560") else Color.parseColor("#dac7cd"),accentInk))) };add(apply,18,52)
        val controls=LinearLayout(this).apply { orientation=if(resources.configuration.fontScale>1.2f)LinearLayout.VERTICAL else LinearLayout.HORIZONTAL;isBaselineAligned=false }
        refresh=button("Обновить установленные обои") { Schedule.refresh(applicationContext,true);Schedule.now(applicationContext,true,draft.target);showStatus("Обновляю сохранённый профиль. "+if(dirty())"Изменения в форме ещё не применены." else "") }
        pause=button("Пауза") {
            val selectedTarget=draft.target
            busy=true;render()
            executor.execute { try{val wasPaused=savedPaused(selectedTarget);repo.setPaused(selectedTarget,!wasPaused);Schedule.configure(applicationContext);if(wasPaused)Schedule.now(applicationContext,true,selectedTarget);runOnUiThread { if(!isDestroyed && draft.target==selectedTarget){busy=false;val savedNow=repo.settings(selectedTarget);draft=draft.copy(paused=savedNow.paused,revision=savedNow.revision);showStatus(if(savedNow.paused)"Смена обоев приостановлена." else "Смена обоев продолжена.");render()} } }catch(e: Exception){runOnUiThread{if(!isDestroyed){busy=false;render();showStatus(UiErrors.message(e))}}} }
        }
        if(controls.orientation==LinearLayout.VERTICAL){controls.addView(refresh,LinearLayout.LayoutParams(-1,-2));controls.addView(pause,LinearLayout.LayoutParams(-1,-2).apply{topMargin=dp(10)})}
        else{controls.addView(refresh,LinearLayout.LayoutParams(0,-2,1f));controls.addView(pause,LinearLayout.LayoutParams(0,-2,1f).apply{leftMargin=dp(10)})};add(controls,10)
        add(View(this).apply { setBackgroundColor(line) },24,1)
        label("О программе",16)
        update=button("Android ${BuildConfig.VERSION_NAME} · Обновления…") {
            val next=AppRelease.available(repo)
            if(next!=null)open(next.getString("url"))
            else { showStatus("Проверяю обновления приложения…");network.execute { try { val result=AppRelease.check(applicationContext,repo,true);runOnUiThread { if(!isDestroyed){showStatus(result);updateLink()} } }catch(e: Exception){runOnUiThread{if(!isDestroyed)showStatus("Не удалось проверить обновления. Попробуйте позже.")}} } }
        };add(update,16,48)
        add(button("Исходный код · GitHub") { open("https://github.com/GremlinEngineering/imperial-school-views") },10,48)
        add(button("Сообщить об ошибке") { open("https://github.com/GremlinEngineering/imperial-school-views/issues") },6,48)
        val links=LinearLayout(this).apply { orientation=LinearLayout.VERTICAL }
        listOf("Зал" to "https://games.oopssre.ru/index.html", "Блог" to "https://oopssre.ru/", "Telegram" to "https://t.me/oopsSRE", "VK" to "https://vk.ru/club238642156").chunked(if(resources.configuration.fontScale>1.2f)2 else 4).forEach { group ->
            val row=LinearLayout(this).apply{orientation=LinearLayout.HORIZONTAL;gravity=Gravity.CENTER;isBaselineAligned=false}
            group.forEach{(name,url)->row.addView(TextView(this).apply { text=name;textSize=12f;typeface=face(R.font.ptmono);setTextColor(accent);gravity=Gravity.CENTER;minimumHeight=dp(48);setOnClickListener{open(url)} },LinearLayout.LayoutParams(0,-2,1f))}
            links.addView(row,LinearLayout.LayoutParams(-1,-2))
        };add(links,8)
        // Wallpaper sections are the first controls, above screen profiles and preview.
        body.removeView(tabs);body.removeView(sectionHelp)
        tabs.minimumHeight=dp(56)
        body.addView(tabs,4,LinearLayout.LayoutParams(-1,-2).apply{topMargin=dp(18)})
        body.removeView(dynamicTab);body.addView(dynamicTab,5,LinearLayout.LayoutParams(-1,-2).apply{topMargin=dp(6)})
        body.addView(sectionHelp,6,LinearLayout.LayoutParams(-1,-2).apply{topMargin=dp(10)})
        listOf(downloadState,progress,downloadAction).forEach{body.removeView(it)}
        zipCard=LinearLayout(this).apply{orientation=LinearLayout.VERTICAL;setPadding(dp(12),dp(12),dp(12),dp(12));background=shape(panel,true)}
        zipCard.addView(text("Сеть для скачивания ZIP",12f,muted,R.font.ptmono))
        downloadNetwork=spinner();zipCard.addView(downloadNetwork,LinearLayout.LayoutParams(-1,-2))
        zipCard.addView(downloadState,LinearLayout.LayoutParams(-1,-2).apply{topMargin=dp(12)})
        zipCard.addView(progress,LinearLayout.LayoutParams(-1,dp(8)).apply{topMargin=dp(8)})
        zipCard.addView(downloadAction,LinearLayout.LayoutParams(-1,-2).apply{topMargin=dp(8)})
        body.addView(zipCard,body.indexOfChild(weatherBox)+1,LinearLayout.LayoutParams(-1,-2).apply{topMargin=dp(10)})
        body.removeView(status);body.removeView(apply)
        val dock=LinearLayout(this).apply{orientation=LinearLayout.VERTICAL;setPadding(dp(24),dp(8),dp(24),dp(12));setBackgroundColor(paper)}
        zipSummary=text("ZIP: загрузка не начата",12f,ink,R.font.ptmono).apply{maxLines=1;minimumHeight=dp(48);isFocusable=true;ellipsize=android.text.TextUtils.TruncateAt.END;accessibilityLiveRegion=View.ACCESSIBILITY_LIVE_REGION_POLITE;setOnClickListener{page.smoothScrollTo(0,zipCard.top)}}
        dock.addView(zipSummary,LinearLayout.LayoutParams(-1,-2).apply{bottomMargin=dp(6)})
        dock.addView(status,LinearLayout.LayoutParams(-1,-2))
        apply.minimumHeight=dp(52)
        dock.addView(apply,LinearLayout.LayoutParams(-1,-2).apply{topMargin=dp(10)})

        val outer=LinearLayout(this).apply{orientation=LinearLayout.VERTICAL;setBackgroundColor(paper)}
        outer.addView(scroll,LinearLayout.LayoutParams(-1,0,1f));outer.addView(dock,LinearLayout.LayoutParams(-1,-2))
        scroll.setOnApplyWindowInsetsListener(null)
        outer.setOnApplyWindowInsetsListener { view,insets ->
            if(Build.VERSION.SDK_INT>=30){val bars=insets.getInsets(WindowInsets.Type.systemBars() or WindowInsets.Type.displayCutout());view.setPadding(bars.left,bars.top,bars.right,bars.bottom)}
            else {@Suppress("DEPRECATION") view.setPadding(insets.systemWindowInsetLeft,insets.systemWindowInsetTop,insets.systemWindowInsetRight,insets.systemWindowInsetBottom)}
            insets
        }
        page=scroll;setContentView(outer);outer.requestApplyInsets()
        setChoices(source,listOf("Обои дня","Коллекции сайта","Импорт ZIP с устройства","Сохранённые пакеты"),sourceIds.indexOf(draft.source).coerceAtLeast(0))
        source.onItemSelectedListener=listener { index ->
            if(!suppress && draft.source!="weather")sourceIds.getOrNull(index)?.let{if(it!=draft.source)switchSource(it)}
        }
        collection.onItemSelectedListener=listener { index -> if(!suppress)collections().getOrNull(index)?.let { if(it.id!=draft.collection){cancelLocation();draft=draft.copy(collection=it.id,mode=if(draft.source=="day")"featured" else it.modes().first());if(DailyWeather.active(draft))draft=draft.copy(weatherSource=if(draft.weatherSource=="open-meteo")"game-world" else draft.weatherSource,weatherDelivery="images",weatherFormat="auto");if(it.weather!=null && draft.weatherSource!="open-meteo" && Weather.sources(it.weather).none{s->s.getString("id")==draft.weatherSource})draft=draft.copy(weatherSource=Weather.sources(it.weather).first().getString("id"));render();loadPreview()} } }
        mode.onItemSelectedListener=listener { index -> if(!suppress) { val next=modes().getOrNull(index);if(next!=null && next!=draft.mode){draft=draft.copy(mode=next);render();loadPreview()} } }
        target.onItemSelectedListener=listener { index -> if(!suppress){val t=listOf("home","lock","both")[index];if(t!=draft.target){cancelLocation();drafts[draft.target]=draft;repo.editTarget(t);draft=drafts[t] ?: repo.settings(t);catalogue=null;generation++;seenStatus="";loadCatalogue(false)}} }
        weatherSource.onItemSelectedListener=listener{index->if(!suppress){val id=weatherSources().getOrNull(index)?.getString("id");if(id!=null && id!=draft.weatherSource){cancelLocation();draft=draft.copy(weatherSource=id,weatherDelivery=if(id=="open-meteo")"zip" else draft.weatherDelivery);previewSignature="";render();loadPreview()}}}
        weatherDelivery.onItemSelectedListener=listener{index->if(!suppress){val delivery=if(index==0)"zip" else "images";if(delivery!=draft.weatherDelivery){draft=draft.copy(weatherDelivery=delivery);render()}}}
        downloadNetwork.onItemSelectedListener=listener{index->if(!suppress){val value=if(index==0)"wifi" else "any";if(value!=DownloadRequests.policy(repo)){
            repo.put("download_network",value)
            executor.execute{val result=DownloadRequests.resumeLegacy(repo);runOnUiThread{if(!isDestroyed){pollWeather();showStatus(DownloadRequests.message(value,result))}}}
        }}}
        render()
    }
    private fun selectLocalWeather(action: ()->Unit) {
        if(busy || draft.source!="weather")return
        cancelLocation()
        val choices=collections().filter{it.id!=DailyWeather.ID && it.weather!=null && Weather.formats(it.weather).isNotEmpty()}
        if(choices.isEmpty()){showStatus("На сайте нет погодной коллекции для телефона. Обновите список наборов.");return}
        fun activate(c: Collection){
            draft=draft.copy(collection=c.id,mode="weather",weatherSource="open-meteo",weatherDelivery="zip",weatherFormat="auto")
            previewSignature="";render();action()
        }
        val current=choices.firstOrNull{it.id==draft.collection}
        if(current!=null){activate(current);return}
        val selected=draft;val token=citySearchGeneration
        android.app.AlertDialog.Builder(this).setTitle("Выберите коллекцию для Open-Meteo")
            .setItems(choices.map{it.title}.toTypedArray()){_,index->
                if(!isDestroyed && token==citySearchGeneration && draft.target==selected.target && draft.source==selected.source && draft.collection==selected.collection)activate(choices[index])
            }.setNegativeButton("Отмена",null).show()
    }
    private fun chooseCity() {
        cancelLocation()
        val input=EditText(this).apply{hint="Название города";setSingleLine(true)}
        android.app.AlertDialog.Builder(this).setTitle("Open-Meteo · поиск города").setView(input)
            .setNegativeButton("Отмена",null).setPositiveButton("Найти"){_,_->
                val query=input.text.toString();val selectedTarget=draft.target;val token=++citySearchGeneration
                showStatus("Ищу город…")
                network.execute {
                    try {
                        val cities=LocalWeather.search(repo,query)
                        runOnUiThread {
                            if(isDestroyed || citySearchGeneration!=token || draft.target!=selectedTarget || !LocalWeather.active(draft))return@runOnUiThread
                            if(cities.isEmpty()){showStatus("Города не найдены");return@runOnUiThread}
                            val labels=cities.map{c->LocalWeather.cityTitle(draft.copy(weatherCity=c.toString()))+" · "+c.getString("timezone")}.toTypedArray()
                            android.app.AlertDialog.Builder(this).setTitle("Выберите город").setItems(labels){_,index->
                                if(citySearchGeneration==token && draft.target==selectedTarget && LocalWeather.active(draft)){
                                    draft=draft.copy(weatherCity=cities[index].toString(),weatherDelivery="zip")
                                    previewSignature="";render();loadPreview();showStatus("Город выбран. Нажмите «Применить».")
                                }
                            }.setNegativeButton("Отмена",null).show()
                        }
                    }catch(e: Exception){runOnUiThread{if(!isDestroyed && citySearchGeneration==token)showStatus(UiErrors.message(e))}}
                }
            }.show()
    }
    private fun cancelLocation() {
        citySearchGeneration++;deviceLocation?.cancel();deviceLocation=null;pendingLocation=null
        locationDialog?.dismiss();locationDialog=null
        if(::locationButton.isInitialized)locationButton.isEnabled=!busy
    }
    private fun currentLocationRequest(selected: Selection,token: Int)=!isDestroyed && citySearchGeneration==token && draft.target==selected.target && LocalWeather.active(draft) && draft.weatherCity==selected.weatherCity
    private fun chooseLocation() {
        cancelLocation();if(!LocalWeather.active(draft))return
        pendingLocation=draft
        if(DeviceLocation.permitted(this))startLocation(draft,citySearchGeneration)
        else requestPermissions(arrayOf(Manifest.permission.ACCESS_COARSE_LOCATION,Manifest.permission.ACCESS_FINE_LOCATION),21)
    }
    override fun onRequestPermissionsResult(requestCode: Int,permissions: Array<out String>,grantResults: IntArray) {
        super.onRequestPermissionsResult(requestCode,permissions,grantResults)
        if(requestCode!=21)return
        val selected=pendingLocation ?: return
        if(!currentLocationRequest(selected,citySearchGeneration)){cancelLocation();return}
        if(DeviceLocation.permitted(this))startLocation(selected,citySearchGeneration)
        else {
            cancelLocation();showStatus("Геолокация не разрешена. Можно выбрать город вручную.")
            android.app.AlertDialog.Builder(this).setTitle("Доступ к местоположению").setMessage("Выберите город вручную или разрешите геолокацию в настройках приложения.")
                .setNegativeButton("Выбрать город"){_,_->chooseCity()}.setPositiveButton("Настройки"){_,_->try{startActivity(Intent(Settings.ACTION_APPLICATION_DETAILS_SETTINGS,Uri.parse("package:"+packageName)))}catch(e: Exception){showStatus("Откройте разрешения приложения в настройках Android.")}}.show()
        }
    }
    private fun startLocation(selected: Selection,token: Int) {
        if(!currentLocationRequest(selected,token))return
        locationButton.isEnabled=false
        locationDialog=android.app.AlertDialog.Builder(this).setTitle("Моё местоположение").setMessage("Определяю координаты…")
            .setNegativeButton("Отмена"){_,_->cancelLocation();showStatus("Определение местоположения отменено.")}.setOnCancelListener{cancelLocation()}.show()
        deviceLocation=DeviceLocation(this)
        deviceLocation!!.start({location->
            if(currentLocationRequest(selected,token)) {
                locationDialog?.setMessage("Определяю часовой пояс по координатам…")
                network.execute {
                    try {
                        val city=LocalWeather.coordinates(location.latitude,location.longitude).put("accuracy",location.accuracy.toDouble()).put("located_at",location.time)
                        runOnUiThread{completeLocation(selected,token,city)}
                    }catch(e: Exception){runOnUiThread{if(currentLocationRequest(selected,token)){cancelLocation();showStatus("Не удалось определить часовой пояс. "+UiErrors.message(e))}}}
                }
            }
        },{message->if(currentLocationRequest(selected,token)){cancelLocation();showStatus(message)}})
    }
    private fun completeLocation(selected: Selection,token: Int,city: JSONObject) {
        if(!currentLocationRequest(selected,token))return
        cancelLocation();draft=draft.copy(weatherCity=city.toString(),weatherDelivery="zip")
        previewSignature="";render();loadPreview();showStatus("Местоположение определено. Нажмите «Применить».")
    }
    private fun switchSource(next: String) {
        cancelLocation()
        draft=draft.copy(source=next,collection="",mode=if(next=="day")"featured" else "")
        if(next=="dynamic")draft=draft.copy(weatherSource="real",weatherDelivery="images",weatherFormat="auto")
        catalogue=null;generation++;previewSignature="";seenStatus="";showStatus("");render()
        if(next=="zip")chooseZip() else loadCatalogue(next!="local")
    }
    private fun screenName(target: String)=when(target){"home"->"главный экран";"lock"->"экран блокировки";else->"оба экрана"}
    private fun profileLabel(s: Selection?): String {
        if(s==null)return "Приложение не меняет обои"
        val name=try{if(DailyWeather.active(s))"Погода дня — выбор сервера" else repo.cachedCatalogue(s)?.collections?.firstOrNull{it.id==s.collection}?.title}catch(e: Exception){null}
        val kind=when(s.source){"weather"->"Погода · "+when(s.weatherSource){"game-world"->"Игровой мир";"open-meteo"->"Open-Meteo · "+LocalWeather.cityTitle(s);else->"Погода с сервера"};"day"->"Обои дня";"local"->"Сохранённый пакет";"dynamic"->"Динамические обои";else->"Коллекция сайта"}
        val mode=when(s.mode){"monthly"->"по месяцам";"seasonal"->"по сезонам";"daily"->"каждый день";else->""}
        return listOf(kind,name,mode.takeIf{it.isNotBlank()},"пауза".takeIf{s.paused}).filterNotNull().joinToString(" · ")
    }
    private fun showZipStatus(job: JSONObject) {
        val message=ZipStatus.describe(job,DownloadRequests.policy(repo))+(job.optString("network_error").takeIf{it.isNotBlank()}?.let{" · Не удалось сменить сеть: "+it} ?: "")
        downloadState.text=message
        zipSummary.text=message
        val visible=draft.source=="online" || draft.source=="weather" && !DailyWeather.active(draft) && (draft.weatherDelivery=="zip" || job.optString("stage").isNotBlank())
        zipCard.visibility=if(visible)View.VISIBLE else View.GONE;zipSummary.visibility=zipCard.visibility
    }
    private fun showDownloadAction(stage: String,weather: Boolean) {
        downloadAction.visibility=if(weather || stage=="downloading")View.VISIBLE else View.GONE
        downloadAction.text=when(stage){"downloading"->"Отменить загрузку ZIP";"downloaded","verifying","unpacking"->"Подготавливаю ZIP…";"ready"->"ZIP скачан";"error","cancelled","outdated"->"Повторить загрузку ZIP";else->"Скачать ZIP коллекции"}
        downloadAction.isEnabled=!busy && stage !in listOf("downloaded","verifying","unpacking","ready")
    }
    private fun archiveAction() {
        val selected=draft;val data=catalogue ?: return
        if(DailyWeather.active(selected))return
        if(selected.source!="weather"){
            executor.execute{try{CollectionDownloads.cancel(repo,selected.collection);runOnUiThread{if(!isDestroyed)pollWeather()}}catch(e: Exception){runOnUiThread{if(!isDestroyed)showStatus(UiErrors.message(e))}}};return
        }
        val c=repo.weatherCollection(data,selected);val stage=Archive.progress(repo,c,selected).optString("stage")
        executor.execute {
            try {
                if(stage=="downloading")Archive.cancel(repo,c,selected)
                else{val d=Weather.descriptor(data,c,Weather.format(c,selected));Archive.ensure(repo,data,c,selected.copy(weatherDelivery="zip"),d.getString("version"),true)}
                runOnUiThread{if(!isDestroyed && draft==selected){pollWeather();showStatus(if(stage=="downloading")"Загрузка отменена. Текущие обои сохранены." else if(DownloadRequests.policy(repo)=="wifi")"ZIP поставлен в очередь · только Wi-Fi." else "ZIP поставлен в очередь · Wi-Fi и мобильная сеть.")}}
            }catch(e: Exception){runOnUiThread{if(!isDestroyed && draft==selected)showStatus(UiErrors.message(e))}}
        }
    }
    private fun downloadCollection(){
        try{
            val data=catalogue ?: error("Дождитесь списка коллекций")
            val archive=CollectionArchive.find(data,draft.collection) ?: error("Сайт пока не опубликовал ZIP этой коллекции")
            val job=CollectionDownloads.progress(repo,archive.collection)
            if(job.optString("stage")=="ready" && job.optString("sha256")==archive.sha256){openSavedCollection(archive.collection);return}
            executor.execute{try{CollectionDownloads.start(repo,archive);runOnUiThread{if(!isDestroyed){render();showStatus(if(DownloadRequests.policy(repo)=="wifi")"ZIP в очереди · только Wi-Fi." else "ZIP в очереди · Wi-Fi и мобильная сеть.")}}}catch(e: Exception){runOnUiThread{if(!isDestroyed)showStatus(UiErrors.message(e))}}}
        }catch(e: Exception){showStatus(UiErrors.message(e))}
    }
    private fun openSavedCollection(id: String){draft=draft.copy(source="local",collection=id,mode=if(draft.mode=="featured")"" else draft.mode);catalogue=null;generation++;loadCatalogue(false);showStatus("Пакет сохранён. Нажмите «Применить», чтобы использовать его без интернета.")}
    private fun listener(action: (Int)->Unit)=object: AdapterView.OnItemSelectedListener {
        override fun onNothingSelected(parent: AdapterView<*>?){}
        override fun onItemSelected(parent: AdapterView<*>?,view: View?,position: Int,id: Long){if(parent?.selectedItemPosition==position)action(position)}
    }
    private fun setChoices(spinner: Spinner,labels: List<String>,index: Int) {
        val names=if(labels.isEmpty())listOf("Нет коллекций") else labels
        val adapter=object: ArrayAdapter<String>(this,android.R.layout.simple_spinner_item,names) {
            override fun getView(position: Int,convertView: View?,parent: android.view.ViewGroup): View = (super.getView(position,convertView,parent) as TextView).apply{setTextColor(ink);textSize=15f;setSingleLine(false);maxLines=3;ellipsize=android.text.TextUtils.TruncateAt.END;setCompoundDrawablesWithIntrinsicBounds(0,0,R.drawable.ic_expand_more,0);compoundDrawablePadding=dp(8)}
            override fun getDropDownView(position: Int,convertView: View?,parent: android.view.ViewGroup): View=(super.getDropDownView(position,convertView,parent) as TextView).apply { setTextColor(ink);setBackgroundColor(panel);setSingleLine(false);minimumHeight=dp(48);textSize=15f;setPadding(dp(16),dp(10),dp(16),dp(10)) }
        }
        adapter.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item);spinner.adapter=adapter;spinner.setSelection(index.coerceIn(0,names.lastIndex),false)
    }
    private fun collections(): List<Collection> {
        val rows=(catalogue?.collections ?: emptyList()).filter{if(draft.source=="weather")it.weather!=null && Weather.formats(it.weather).isNotEmpty() else if(draft.source=="dynamic")it.dynamic!=null && Dynamic.formats(it.dynamic).isNotEmpty() else it.weather==null && it.dynamic==null}
        return if(draft.source=="weather" && catalogue!=null)rows+Collection(DailyWeather.ID,"Погода дня — выбор сервера",emptyMap(),DailyWeather.collection()) else rows
    }
    private fun weatherSources()=collections().firstOrNull{it.id==draft.collection}?.weather?.let{Weather.sources(it)+(if(DailyWeather.active(draft))emptyList() else listOf(JSONObject().put("id","open-meteo").put("title","Open-Meteo · город / геолокация")))} ?: emptyList()
    private fun modes(): List<String> = if(draft.source=="day")listOf("featured") else collections().firstOrNull { it.id==draft.collection }?.modes() ?: emptyList()
    private fun render() {
        if(DailyWeather.active(draft))draft=draft.copy(weatherDelivery="images")
        suppress=true
        setChoices(downloadNetwork,listOf("Только Wi-Fi","Wi-Fi и мобильная сеть"),if(DownloadRequests.policy(repo)=="wifi")0 else 1)
        downloadNetwork.isEnabled=!busy
        zipCard.visibility=if(draft.source=="online" || draft.source=="weather" && !DailyWeather.active(draft) && draft.weatherDelivery=="zip")View.VISIBLE else View.GONE
        zipSummary.visibility=zipCard.visibility
        val rows=collections()
        val weather=draft.source=="weather"
        listOf(ordinaryTab to (!weather && draft.source!="dynamic"),weatherTab to weather,dynamicTab to (draft.source=="dynamic")).forEach{(tab,selected)->tab.isSelected=selected;tab.background=controlShape(if(selected)accent else panel,!selected);tab.setTextColor(if(selected){accentInk}else accent)}
        sectionHelp.text=if(draft.source=="dynamic")"Готовые кадры с сервера · погода, игровые события и бытовые сцены. До получения готового кадра сохраняются текущие обои." else if(DailyWeather.active(draft))"Погода дня · коллекцию выбирает сервер. Кадр обновляется по погоде и времени суток. Загружается только JPEG для телефона." else if(weather)"Погодные обои · кадры меняются по погоде, сезону и времени суток." else "Обычные обои · выбор сайта, расписание коллекции или скачанный пакет."
        sourceLabel.visibility=if(weather || draft.source=="dynamic")View.GONE else View.VISIBLE;source.visibility=sourceLabel.visibility
        modeLabel.visibility=if(weather || draft.source=="dynamic")View.GONE else View.VISIBLE;mode.visibility=modeLabel.visibility
        collectionLabel.text=if(draft.source=="dynamic")"Динамическая тема" else if(weather)"Погодный набор" else "Коллекция"
        val profiles=repo.savedProfiles()
        profilesSummary.text=if(profilesExpanded)"Сохранённые настройки:\nГлавный экран: "+profileLabel(profiles.home)+"\nБлокировка: "+profileLabel(profiles.lock)+"\nСкрыть профили" else "Сохранённые профили · показать"
        targetHelp.text=if(draft.target=="both")"После применения выбранные настройки заменят настройки обоих экранов." else "Настройки применяются только на "+screenName(draft.target)+"."
        stopManaging.text=if(draft.target=="both")"Не менять оба экрана" else "Не менять этот экран"
        val managesTarget=if(draft.target=="home")profiles.home!=null else if(draft.target=="lock")profiles.lock!=null else profiles.home!=null || profiles.lock!=null
        stopManaging.isEnabled=!busy && managesTarget
        apply.text="Применить на "+screenName(draft.target)
        viewSaved.isEnabled=!busy && catalogue!=null
        downloadPack.visibility=if(draft.source=="online")View.VISIBLE else View.GONE
        downloadPack.isEnabled=!busy && try{catalogue?.let{CollectionArchive.find(it,draft.collection)}!=null}catch(e: Exception){false}
        setChoices(collection,if(draft.source=="day")listOf("Выбор сайта") else rows.map{it.title},rows.indexOfFirst{it.id==draft.collection}.coerceAtLeast(0))
        val modes=modes();setChoices(mode,modes.map { when(it){"featured"->"Обои дня";"monthly"->"По месяцам";"seasonal"->"По сезонам";"weather"->"Погода и время суток";"dynamic"->"Готовый кадр с сервера";else->"Каждый день"} },modes.indexOf(draft.mode).coerceAtLeast(0))
        weatherBox.visibility=if(draft.source=="weather")View.VISIBLE else View.GONE
        val sources=weatherSources();setChoices(weatherSource,sources.map{if(it.getString("id")=="real")"Погода с сервера" else it.optString("title",it.getString("id"))},sources.indexOfFirst{it.getString("id")==draft.weatherSource}.coerceAtLeast(0))
        cityButton.visibility=View.VISIBLE
        weatherCredit.visibility=cityButton.visibility
        cityButton.text="Выбрать город вручную…"
        locationButton.visibility=cityButton.visibility;locationInfo.visibility=cityButton.visibility
        locationButton.text=if(LocalWeather.deviceLocation(draft))"Обновить геолокацию…" else "Определить по геолокации…"
        locationButton.isEnabled=!busy && pendingLocation==null
        locationInfo.text=if(!LocalWeather.active(draft))"Эти кнопки включают Open-Meteo для вашего места. "+(if(DailyWeather.active(draft))"Сначала выберите погодную коллекцию в открывшемся списке." else "Можно выбрать город или определить координаты телефона.") else LocalWeather.cityTitle(draft)+(if(LocalWeather.deviceLocation(draft))"\nКоординаты сохранены. Для нового места нажмите «Обновить геолокацию»." else "\nМожно выбрать город или определить местоположение телефона.")
        weatherDelivery.isEnabled=!LocalWeather.active(draft) && !DailyWeather.active(draft)
        setChoices(weatherDelivery,listOf("ZIP с сайта","Отдельные JPEG"),if(draft.weatherDelivery=="zip")0 else 1)
        exactButton.visibility=if(Build.VERSION.SDK_INT>=31 && !Schedule.exact(this))View.VISIBLE else View.GONE
        setChoices(target,listOf("Главный экран","Экран блокировки","Оба экрана одинаково"),listOf("home","lock","both").indexOf(draft.target).coerceAtLeast(0))
        source.setSelection(sourceIds.indexOf(draft.source).coerceAtLeast(0),false)
        notifyCollections.isChecked=draft.notifyCollections;notifyApp.isChecked=draft.notifyApp
        collection.isEnabled=!busy && rows.size>1 && draft.source!="day";mode.isEnabled=!busy && modes.size>1
        sourceAction.text=when(draft.source){"local","zip"->"Импортировать ZIP с устройства…";"weather"->"Обновить погодные наборы";"dynamic"->"Обновить динамические темы";else->"Обновить список"}
        sourceAction.isEnabled=!busy;source.isEnabled=!busy;target.isEnabled=!busy
        ordinaryTab.isEnabled=!busy;weatherTab.isEnabled=!busy;dynamicTab.isEnabled=!busy;weatherSource.isEnabled=!busy
        weatherDelivery.isEnabled=!busy && !LocalWeather.active(draft) && !DailyWeather.active(draft);cityButton.isEnabled=!busy
        notifyCollections.isEnabled=!busy;notifyApp.isEnabled=!busy
        val hasImage=try{draft.source in listOf("weather","dynamic") || catalogue?.choose(draft.collection,draft.mode)?.files?.any{it.height>it.width}==true}catch(e: Exception){false}
        apply.isEnabled=!busy && catalogue!=null && modes.isNotEmpty() && rows.isNotEmpty() && hasImage && (!LocalWeather.active(draft) || try{LocalWeather.city(draft);true}catch(e: Exception){false})
        refresh.isEnabled=!busy && managesTarget;pause.isEnabled=!busy && managesTarget;pause.text=if(savedPaused(draft.target))"Продолжить" else "Пауза"
        target.contentDescription="Настраиваемый экран";source.contentDescription="Источник обычных обоев";collection.contentDescription=collectionLabel.text;mode.contentDescription="Расписание смены обоев";weatherSource.contentDescription="Источник погоды";weatherDelivery.contentDescription="Способ загрузки кадров";downloadNetwork.contentDescription="Сеть для скачивания ZIP"
        updateDraftLabel();suppress=false;updateLink()
        if(!busy)pollWeather()
    }
    private fun showStatus(message: String,hold: Boolean=true) { fullStatus=message;status.text=message;status.visibility=if(message.isBlank())View.GONE else View.VISIBLE;status.contentDescription=message+if(message.isBlank())"" else " Подробнее по нажатию.";if(hold)statusHoldUntil=System.currentTimeMillis()+10000 }
    private fun loadCatalogue(refresh: Boolean) {
        val token=++generation;val selected=draft.copy(source=if(draft.source=="zip")"local" else draft.source)
        busy=true;render();showStatus(if(selected.source=="local")"Открываю сохранённые коллекции…" else "Получаю коллекции…")
        network.execute {
            try {
                val data=repo.catalogue(selected,refresh)
                runOnUiThread {
                    if(isDestroyed || token!=generation)return@runOnUiThread
                    catalogue=data;catalogueStamp=java.io.File(repo.root,"catalogue.json").lastModified();val c=collections().firstOrNull{it.id==draft.collection} ?: collections().firstOrNull();if(c==null){busy=false;render();showNoData(if(draft.source=="dynamic")"На сервере пока нет динамических тем для телефона. Обычные и погодные обои доступны в своих разделах." else "Нет доступных коллекций в этом разделе");showStatus(if(draft.source=="dynamic")"На сервере пока нет динамических тем для телефона." else "Нет доступных коллекций в этом разделе");return@runOnUiThread}
                    val allowed=if(draft.source=="day")listOf("featured") else c.modes()
                    draft=draft.copy(collection=c.id,mode=draft.mode.takeIf{it in allowed} ?: allowed.first())
                    if(c.weather!=null && weatherSources().none{it.getString("id")==draft.weatherSource})draft=draft.copy(weatherSource=weatherSources().first().getString("id"))
                    busy=false;render();showStatus(if(selected.source=="local" && repo.text("local_catalogue_error").isNotBlank())repo.text("local_catalogue_error") else if(repo.online(selected) && repo.text("catalogue_error").isNotBlank())"Используется сохранённый каталог. "+repo.text("catalogue_error") else if(LocalWeather.active(draft) && draft.weatherCity.isBlank())"Выберите город для Open-Meteo." else if(selected.source=="dynamic")"Тема выбрана. Получаю готовый кадр с сервера." else "Коллекция готова. Можно применить обои.");loadPreview()
                }
            } catch(e: Exception) { runOnUiThread { if(!isDestroyed && token==generation){busy=false;render();showStatus(UiErrors.message(e));showNoData(UiErrors.message(e))} } }
        }
    }
    private fun showNoData(reason: String){
        preview.setImageBitmap(assets.open("preview-samples/no-data.png").use{BitmapFactory.decodeStream(it)});caption.text=reason;title.text="Нет данных";caption.contentDescription=reason
    }
    private fun showSeason(c: JSONObject,season: String){
        val index=JSONObject(assets.open("preview-samples/index.json").bufferedReader().use{it.readText()})
        val sample=index.getJSONArray("samples").objects().firstOrNull{it.optString("collection_id")==c.getString("id") && it.optString("season")==season}
        if(sample==null){preview.setImageDrawable(null);caption.text="Загружаю текущий кадр…";return}
        preview.setImageBitmap(assets.open("preview-samples/"+sample.getString("file")).use{BitmapFactory.decodeStream(it)})
        caption.text="Пример сезона · текущий кадр загружается"
    }
    private fun showFile(file: java.io.File,token: Int,description: String){
        val info=BitmapFactory.Options().apply{inJustDecodeBounds=true};BitmapFactory.decodeFile(file.path,info);var sample=1;while(maxOf(info.outWidth,info.outHeight)/sample>1440)sample*=2
        val bitmap=BitmapFactory.decodeFile(file.path,BitmapFactory.Options().apply{inSampleSize=sample}) ?: error("Изображение повреждено")
        runOnUiThread{if(!isDestroyed && token==generation){preview.setImageBitmap(bitmap);caption.text=description}}
    }
    private fun loadPreview() {
        if(busy)return
        val data=catalogue ?: return;val selected=draft.copy(source=if(draft.source=="zip")"local" else draft.source);val token=++generation
        preview.setImageDrawable(null);caption.text="Загружаю превью…"
        try{
            if(selected.source=="dynamic"){
                val c=Dynamic.collection(data,selected);title.text=c.getString("title")
                val state=Dynamic.cached(repo,c,selected)
                val info=Dynamic.message(repo,c,selected)
                if(state==null){showNoData(info);title.text=c.getString("title")}
                else{
                    val f=Dynamic.image(state,c,selected);val file=Dynamic.path(repo,f)
                    network.execute{
                        try{
                            requireView(validImage(file,f),"Сохранённый кадр повреждён или удалён. Получаю его заново.")
                            showFile(file,token,if(Weather.time(state.optString("valid_until"))<=System.currentTimeMillis())"Сохранённый кадр · "+info else Dynamic.details(state)+(if(info!=Dynamic.details(state))"\nОбновление отложено: "+info else ""))
                        }catch(e: Exception){
                            runOnUiThread{if(!isDestroyed && token==generation)showNoData(UiErrors.message(e))}
                            repo.putNumber("dynamic_next_"+Dynamic.scope(c,selected),0)
                            Schedule.dynamic(applicationContext,c,selected)
                        }
                    }
                }
                if(Dynamic.due(repo,c,selected))Schedule.dynamic(applicationContext,c,selected)
                return
            }
            if(selected.source=="weather"){
                if(LocalWeather.active(selected) && selected.weatherCity.isBlank()){showNoData("Выберите город для Open-Meteo");return}
                val c=repo.weatherCollection(data,selected);val frame=repo.resolveWeather(c,selected);title.text=frame.title.ifBlank{c.getString("title")}
                if(frame.status!="ready"){showNoData(Weather.details(frame));title.text=frame.title.ifBlank{c.getString("title")};caption.text="Нет данных · "+Weather.details(frame);Schedule.weather(applicationContext,c,selected,false);return}
                val f=Weather.frameFile(c,selected,frame);val file=repo.weatherPath(f)
                if(!validImage(file,f)){if(LocalWeather.active(selected))LocalWeather.repair(repo,data,c,selected);if(DailyWeather.active(selected))caption.text="Текущий кадр погоды дня загружается…" else showSeason(c,frame.row!!.optString("season"));Schedule.weather(applicationContext,c,selected,false);return}
                network.execute{try{showFile(file,token,Weather.details(frame))}catch(e: Exception){runOnUiThread{if(!isDestroyed && token==generation)showNoData(UiErrors.message(e))}}};return
            }
            val scene=data.choose(selected.collection,selected.mode);title.text=scene.title
            network.execute{try{showFile(repo.image(scene,selected),token,"")}catch(e: Exception){runOnUiThread{if(!isDestroyed && token==generation){showNoData(UiErrors.message(e));showStatus(UiErrors.message(e))}}}}
        }catch(e: Exception){showNoData(UiErrors.message(e));showStatus(UiErrors.message(e))}
    }
    private fun pollWeather(){
        if(busy)return
        downloadAction.visibility=View.GONE
        downloadState.text=""
        downloadState.visibility=if(draft.source in listOf("weather","online"))View.VISIBLE else View.GONE;progress.visibility=View.GONE
        if(draft.source in listOf("weather","online"))showZipStatus(JSONObject())
        if(draft.source=="online"){
            try{
                val job=CollectionDownloads.progress(repo,draft.collection);val stage=job.optString("stage");val received=job.optLong("received");val total=job.optLong("total")
                showZipStatus(job)
                if(stage in listOf("downloading","downloaded","verifying")){progress.visibility=View.VISIBLE;progress.isIndeterminate=stage!="downloading" || total<=0;if(total>0)progress.progress=(received*100/total).toInt().coerceIn(0,100)}
                showDownloadAction(stage,false)
                val currentArchive=catalogue?.let{CollectionArchive.find(it,draft.collection)}
                val sameArchive=currentArchive?.sha256==job.optString("sha256")
                downloadPack.text=when(stage){"ready"->if(sameArchive)"Использовать скачанный пакет" else "Скачать обновлённый пакет";"error"->"Скачать пакет снова";"downloading","downloaded","verifying"->"Пакет загружается…";else->"Скачать пакет с сайта"}
                downloadPack.isEnabled=!busy && stage !in listOf("downloading","downloaded","verifying") && catalogue?.let{CollectionArchive.find(it,draft.collection)}!=null
            }catch(e: Exception){showZipStatus(JSONObject().put("stage","error").put("message",UiErrors.message(e)))}
            return
        }
        if(draft.source=="dynamic"){
            val data=catalogue ?: return
            try{
                val c=Dynamic.collection(data,draft);val p=Dynamic.cached(repo,c,draft)
                val sig=Dynamic.scope(c,draft)+p?.optString("id")+Dynamic.message(repo,c,draft)+(p?.let{Dynamic.path(repo,Dynamic.image(it,c,draft)).lastModified()} ?: 0)
                if(sig!=previewSignature){previewSignature=sig;loadPreview()}
                else if(Dynamic.due(repo,c,draft))Schedule.dynamic(applicationContext,c,draft)
            }catch(e: Exception){caption.text=UiErrors.message(e)}
            return
        }
        if(draft.source!="weather" || catalogue==null)return
        try{
            val c=repo.weatherCollection(catalogue!!,draft)
            if(!DailyWeather.active(draft)){
            val job=Archive.progress(repo,c,draft);val stage=job.optString("stage");val received=job.optLong("received");val total=job.optLong("total")
            showZipStatus(job)
            if(draft.weatherDelivery=="zip")showDownloadAction(stage,true)
            val background=if(LocalWeather.active(draft) && draft.weatherCity.isBlank())"" else repo.text("weather_message_"+weatherScope(c,draft));if(background.isNotBlank() && !downloadState.text.contains(background))downloadState.append("\n"+background)
            if(stage in listOf("downloading","downloaded","verifying","unpacking")){progress.visibility=View.VISIBLE;progress.isIndeterminate=stage!="downloading" || total<=0;if(total>0)progress.progress=(received*100/total).toInt().coerceIn(0,100)}
            }
            try{
            if(LocalWeather.active(draft) && draft.weatherCity.isBlank()){caption.text="Выберите город для Open-Meteo. ZIP можно скачать заранее.";return}
            val frame=repo.resolveWeather(c,draft)
            val sha=frame.row?.optJSONObject("file")?.optString("sha256").orEmpty();val sig=weatherScope(c,draft)+frame.status+frame.title+sha+Weather.details(frame)+(if(sha.isNotBlank())java.io.File(repo.root,"weather-images/"+sha+".jpg").lastModified() else 0)
            if(sig!=previewSignature){previewSignature=sig;loadPreview()}
            }catch(e: Exception){caption.text=UiErrors.message(e)}
        }catch(e: Exception){showZipStatus(JSONObject().put("stage","error").put("message",UiErrors.message(e)))}
    }
    private fun chooseZip() {
        try{startActivityForResult(Intent(Intent.ACTION_OPEN_DOCUMENT).apply { addCategory(Intent.CATEGORY_OPENABLE);type="*/*";putExtra(Intent.EXTRA_MIME_TYPES,arrayOf("application/zip","application/x-zip-compressed","application/octet-stream")) },10)}catch(e: Exception){showStatus("На устройстве нет приложения для выбора ZIP.")}
    }
    @Deprecated("System callback")
    override fun onActivityResult(requestCode: Int,resultCode: Int,data: Intent?) {
        super.onActivityResult(requestCode,resultCode,data)
        if(requestCode!=10)return
        val uri=data?.data
        if(resultCode!=RESULT_OK || uri==null) { if(draft.source=="zip"){draft=draft.copy(source="local");loadCatalogue(false)};return }
        val token=++generation;busy=true;render();showStatus("Импортирую коллекцию…")
        executor.execute {
            try { val id=repo.importZip(uri);runOnUiThread { if(!isDestroyed && token==generation){draft=draft.copy(source="local",collection=id,mode="");busy=false;loadCatalogue(false)} } }
            catch(e: Exception){runOnUiThread { if(!isDestroyed && token==generation){busy=false;render();showStatus(UiErrors.message(e))} }}
        }
    }
    private fun applySelection() {
        try {
            val selected=draft.copy(source=if(draft.source=="zip")"local" else draft.source,paused=false)
            if(selected.source=="dynamic")Dynamic.device(Dynamic.collection(catalogue!!,selected),selected) else if(selected.source=="weather"){val c=repo.weatherCollection(catalogue!!,selected);if(LocalWeather.active(selected))LocalWeather.city(selected) else Weather.source(c,selected.weatherSource);Weather.format(c,selected)}else catalogue!!.choose(selected.collection,selected.mode).phone()
            draft=selected
            if(Build.VERSION.SDK_INT>=33 && (selected.notifyCollections||selected.notifyApp) && checkSelfPermission(Manifest.permission.POST_NOTIFICATIONS)!=PackageManager.PERMISSION_GRANTED)requestPermissions(arrayOf(Manifest.permission.POST_NOTIFICATIONS),20)
            busy=true;render();showStatus("Применяю обои…")
            executor.execute {
                try { repo.save(selected);Schedule.configure(applicationContext,selected);(if(selected.target=="both")listOf("home","lock") else listOf(selected.target)).forEach{repo.status(it,"Применяю обои…")};Schedule.refresh(applicationContext,true);Schedule.now(applicationContext,true,selected.target)
                    runOnUiThread { if(!isDestroyed){draft=repo.settings(selected.target);if(selected.target=="both")drafts.clear();drafts[selected.target]=draft;busy=false;render()} }
                }catch(e: Exception){runOnUiThread { if(!isDestroyed){busy=false;render();showStatus(UiErrors.message(e))} }}
            }
        } catch(e: Exception){showStatus(UiErrors.message(e))}
    }
    private fun updateLink() { if(!::update.isInitialized)return;val r=AppRelease.available(repo);update.text=if(r==null)"Android ${BuildConfig.VERSION_NAME} · Обновления…" else "Доступна ${r.optString("version")} · Скачать" }
    private fun open(url: String) { try { startActivity(Intent(Intent.ACTION_VIEW,Uri.parse(url))) }catch(e: Exception){showStatus("Не удалось открыть ссылку")} }
    private val poll=object: Runnable { override fun run() { if(isDestroyed)return;val saved=repo.settings(draft.target);val same=saved.source==draft.source && saved.collection==draft.collection && saved.mode==draft.mode && saved.weatherSource==draft.weatherSource && saved.weatherCity==draft.weatherCity;val value=if(same)repo.text("status_"+if(draft.target=="both")"home" else draft.target) else "";if(!busy && System.currentTimeMillis()>=statusHoldUntil && value.isNotBlank() && value!=seenStatus){seenStatus=value;showStatus(value,false)};val stamp=java.io.File(repo.root,"catalogue.json").lastModified();if(!busy && repo.online(draft) && stamp>0 && stamp!=catalogueStamp){catalogueStamp=stamp;loadCatalogue(false)};try{pollWeather();updateLink()}catch(e: Exception){showStatus(UiErrors.message(e))};handler.postDelayed(this,1000) } }
    private fun showUpdateIntent(){if(intent.getBooleanExtra("updates",false))update.post { page.smoothScrollTo(0,update.top) }}
    override fun onNewIntent(next: Intent){super.onNewIntent(next);intent=next;showUpdateIntent()}
    override fun onResume(){super.onResume();if(repo.installed()){Schedule.configure(applicationContext);executor.execute{FrameEngine.run(applicationContext)}};handler.post(poll);if(catalogue!=null && !busy)loadCatalogue(false)}
    override fun onPause(){handler.removeCallbacks(poll);super.onPause()}
    override fun onStop(){cancelLocation();super.onStop()}
    override fun onDestroy(){generation++;cancelLocation();executor.shutdownNow();network.shutdownNow();super.onDestroy()}
    override fun onSaveInstanceState(out: Bundle){drafts[draft.target]=draft;out.putString("drafts",JSONObject().also{obj->drafts.forEach{(target,s)->obj.put(target,s.json())}}.toString());out.putBoolean("profiles_expanded",profilesExpanded);out.putString("selection",draft.json().toString());out.putString("source",draft.source);out.putString("collection",draft.collection);out.putString("mode",draft.mode);out.putString("target",draft.target);out.putBoolean("notify_collections",draft.notifyCollections);out.putBoolean("notify_app",draft.notifyApp);super.onSaveInstanceState(out)}
}
