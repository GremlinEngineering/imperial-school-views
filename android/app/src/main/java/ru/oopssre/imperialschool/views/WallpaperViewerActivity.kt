package ru.oopssre.imperialschool.views

import android.app.Activity
import android.app.AlertDialog
import android.content.res.Configuration
import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.graphics.Color
import android.os.Build
import android.os.Bundle
import android.view.Gravity
import android.view.View
import android.view.WindowInsets
import android.view.WindowInsetsController
import android.widget.*
import org.json.JSONObject
import java.util.concurrent.Executors

class WallpaperViewerActivity: Activity() {
    private val executor=Executors.newSingleThreadExecutor()
    private var all=emptyList<SavedWallpaper>()
    private var visible=emptyList<SavedWallpaper>()
    private var filter=WallpaperFilter()
    private var index=0
    private var playing=false
    private var reverseHistory=false
    private val slides=android.os.Handler(android.os.Looper.getMainLooper())
    private val advance=object: Runnable {
        override fun run(){
            if(!playing || visible.size<2){stopSlideshow();return}
            index=if(reverseHistory)(index-1+visible.size)%visible.size else (index+1)%visible.size
            showCurrent()
        }
    }
    @Volatile private var token=0
    private var full=false
    private var leaveFullScreenBack: (() -> Unit)?=null
    private var bitmap: Bitmap?=null
    private lateinit var root: LinearLayout
    private lateinit var header: LinearLayout
    private lateinit var footer: LinearLayout
    private lateinit var picture: WallpaperImageView
    private lateinit var heading: TextView
    private lateinit var caption: TextView
    private lateinit var count: TextView
    private lateinit var previous: Button
    private lateinit var next: Button
    private lateinit var details: Button
    private lateinit var filters: Button
    private lateinit var slideshow: Button
    private lateinit var fullscreen: Button
    private val dark get()=resources.configuration.uiMode and Configuration.UI_MODE_NIGHT_MASK==Configuration.UI_MODE_NIGHT_YES
    private val ink get()=Color.parseColor(if(dark)"#f3ecdb" else "#272635")
    private val paper get()=Color.parseColor(if(dark)"#141126" else "#fbf8ec")
    private val accent get()=Color.parseColor(if(dark)"#fbbf55" else "#9d3766")
    private fun dp(n: Int)=(n*resources.displayMetrics.density+.5f).toInt()
    private fun label(value: String,size: Float=14f)=TextView(this).apply{text=value;textSize=size;setTextColor(ink);setPadding(dp(8),dp(4),dp(8),dp(4))}
    private fun button(value: String,action: ()->Unit)=Button(this).apply{
        text=value;isAllCaps=false;minimumHeight=dp(48);minimumWidth=dp(48);textSize=14f;setPadding(dp(12),dp(8),dp(12),dp(8))
        val border=Color.parseColor(if(dark)"#514560" else "#c8c2af")
        val fill=android.graphics.drawable.GradientDrawable().apply{setColor(Color.parseColor(if(dark)"#211b38" else "#f2ead9"));cornerRadius=dp(4).toFloat();setStroke(dp(1),border)}
        background=android.graphics.drawable.RippleDrawable(android.content.res.ColorStateList.valueOf(Color.argb(45,Color.red(accent),Color.green(accent),Color.blue(accent))),fill,null)
        setTextColor(android.content.res.ColorStateList(arrayOf(intArrayOf(-android.R.attr.state_enabled),intArrayOf()),intArrayOf(Color.parseColor(if(dark)"#b9b1ce" else "#56536b"),accent)))
        setOnClickListener{action()}
    }
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        root=LinearLayout(this).apply{orientation=LinearLayout.VERTICAL;setBackgroundColor(paper)}
        root.setOnApplyWindowInsetsListener{v,insets->
            if(Build.VERSION.SDK_INT>=30){val bars=insets.getInsets(WindowInsets.Type.systemBars() or WindowInsets.Type.displayCutout());v.setPadding(bars.left,bars.top,bars.right,bars.bottom)}
            else{@Suppress("DEPRECATION") v.setPadding(insets.systemWindowInsetLeft,insets.systemWindowInsetTop,insets.systemWindowInsetRight,insets.systemWindowInsetBottom)}
            insets
        }
        @Suppress("DEPRECATION")
        window.decorView.systemUiVisibility=View.SYSTEM_UI_FLAG_LAYOUT_STABLE or View.SYSTEM_UI_FLAG_LAYOUT_FULLSCREEN or View.SYSTEM_UI_FLAG_LAYOUT_HIDE_NAVIGATION or if(!dark)View.SYSTEM_UI_FLAG_LIGHT_STATUS_BAR or View.SYSTEM_UI_FLAG_LIGHT_NAVIGATION_BAR else 0
        window.statusBarColor=Color.TRANSPARENT;window.navigationBarColor=Color.TRANSPARENT
        header=LinearLayout(this).apply{orientation=LinearLayout.VERTICAL}
        header.addView(button("Назад к настройкам"){finish()},LinearLayout.LayoutParams(-1,-2))
        heading=label("Скачанные обои",20f).apply{typeface=resources.getFont(R.font.oswald_semibold);maxLines=2;ellipsize=android.text.TextUtils.TruncateAt.END};header.addView(heading)
        val tools=LinearLayout(this).apply{orientation=LinearLayout.HORIZONTAL;isBaselineAligned=false}
        filters=button("Фильтры"){showFilters()};fullscreen=button("На весь экран"){setFull(true)}
        tools.addView(filters,LinearLayout.LayoutParams(0,-2,1f));tools.addView(fullscreen,LinearLayout.LayoutParams(0,-2,1f));header.addView(tools)
        slideshow=button("Слайд-шоу"){if(playing){stopSlideshow();setFull(false)}else startSlideshow()};header.addView(slideshow,LinearLayout.LayoutParams(-1,-2))
        root.addView(header,LinearLayout.LayoutParams(-1,-2))
        picture=WallpaperImageView(this).apply{onStep={step(it)};onTap={setFull(!full)}}
        root.addView(picture,LinearLayout.LayoutParams(-1,0,1f))
        footer=LinearLayout(this).apply{orientation=LinearLayout.VERTICAL}
        caption=label("Открываю сохранённые изображения…").apply{maxLines=3;ellipsize=android.text.TextUtils.TruncateAt.END;accessibilityLiveRegion=View.ACCESSIBILITY_LIVE_REGION_POLITE}
        footer.addView(caption)
        details=button("Условия и сведения"){showDetails()};footer.addView(details,LinearLayout.LayoutParams(-1,-2))
        val nav=LinearLayout(this).apply{orientation=LinearLayout.HORIZONTAL;gravity=Gravity.CENTER_VERTICAL;isBaselineAligned=false}
        previous=button("Назад"){step(-1)};next=button("Далее"){step(1)}
        previous.contentDescription="Предыдущие обои";next.contentDescription="Следующие обои"
        nav.addView(previous,LinearLayout.LayoutParams(0,-2,1f));count=label("").apply{gravity=Gravity.CENTER};nav.addView(count,LinearLayout.LayoutParams(0,-2,1f));nav.addView(next,LinearLayout.LayoutParams(0,-2,1f));footer.addView(nav)
        root.addView(footer,LinearLayout.LayoutParams(-1,-2));setContentView(root);root.requestApplyInsets()
        val savedHash=savedInstanceState?.getString("hash")
        filter=try{WallpaperFilter.parse(JSONObject(savedInstanceState?.getString("filter") ?: "{}"))}catch(e: Exception){WallpaperFilter()}
        setEnabled(false)
        val selection=try{Selection.parse(JSONObject(intent.getStringExtra("selection") ?: "{}"))}catch(e: Exception){caption.text="Не удалось прочитать выбранную тему. Вернитесь к настройкам.";return}
        reverseHistory=selection.source=="dynamic"
        executor.execute{
            try{
                val list=SavedWallpapers.load(Repository(applicationContext),selection)
                runOnUiThread{if(!isDestroyed){
                    heading.text=list.title;all=list.items;applyFilter(savedHash)
                    if(list.warning.isNotBlank())Toast.makeText(this,list.warning,Toast.LENGTH_LONG).show()
                    if(savedInstanceState?.getBoolean("full")==true && visible.isNotEmpty())setFull(true)
                }}
            }catch(e: Exception){runOnUiThread{if(!isDestroyed){caption.text="Не удалось открыть скачанные обои. "+UiErrors.message(e);setEnabled(false)}}}
        }
    }
    private fun setEnabled(ready: Boolean){previous.isEnabled=ready && index>0;next.isEnabled=ready && index<visible.lastIndex;details.isEnabled=ready;fullscreen.isEnabled=ready;filters.isEnabled=all.isNotEmpty();slideshow.isEnabled=ready && visible.size>1}
    private fun applyFilter(hash: String?=null){
        visible=all.filter{filter.accepts(it)};index=visible.indexOfFirst{it.image.sha256==hash}.coerceAtLeast(0)
        filters.text=if(filter==WallpaperFilter())"Фильтры" else "Фильтры · включены"
        showCurrent()
    }
    private fun step(delta: Int){stopSlideshow();if(visible.isEmpty())return;val new=(index+delta).coerceIn(0,visible.lastIndex);if(new!=index){index=new;showCurrent()}}
    private fun showCurrent(){
        slides.removeCallbacks(advance)
        val request=++token;picture.setImageDrawable(null);bitmap=null
        if(visible.isEmpty()){
            count.text="0 / ${all.size}";caption.text=if(all.isEmpty())"Нет скачанных изображений этой темы. Получите кадры в настройках. Просмотрщик работает без сети." else "Нет кадров с такими условиями. Сбросьте фильтры."
            stopSlideshow();setEnabled(false);return
        }
        val item=visible[index];count.text="${index+1} / ${visible.size}";caption.text="Открываю кадр…";setEnabled(true)
        val size=resources.displayMetrics
        val maxWidth=(size.widthPixels*2).coerceIn(1,2048);val maxHeight=(size.heightPixels*2).coerceIn(1,2048)
        executor.execute{
            if(request!=token)return@execute
            var decoded: Bitmap?=null
            try{
                requireView(validImage(item.file,item.image),"Файл повреждён или уже удалён из кеша. Скачайте его заново в настройках.")
                val options=BitmapFactory.Options();var sample=1
                while(item.image.width/sample>maxWidth || item.image.height/sample>maxHeight)sample*=2
                options.inSampleSize=sample;decoded=BitmapFactory.decodeFile(item.file.path,options) ?: error("Не удалось прочитать изображение")
                val ready=decoded
                runOnUiThread{
                    if(isDestroyed || request!=token)ready.recycle()
                    else{bitmap=ready;picture.setImageBitmap(ready);picture.resetZoom();if(playing)slides.postDelayed(advance,2000);caption.text=listOf(item.title,item.conditions.map{it.label()}.distinct().joinToString("\n"),if(item.installed.isEmpty())"" else "Сейчас используется: "+item.installed.joinToString()).filter{it.isNotBlank()}.joinToString("\n")}
                }
            }catch(e: Exception){decoded?.recycle();runOnUiThread{if(!isDestroyed && request==token){stopSlideshow();setFull(false);caption.text=UiErrors.message(e)}}}
            catch(e: OutOfMemoryError){decoded?.recycle();runOnUiThread{if(!isDestroyed && request==token){stopSlideshow();setFull(false);caption.text="Недостаточно памяти для просмотра этого кадра. Закройте другие приложения."}}}
        }
    }
    private fun showDetails(){
        stopSlideshow()
        val item=visible.getOrNull(index) ?: return
        val rules=item.conditions.map{c->c.label()+(if(c.title.isNotBlank() && c.title!=c.label())"\n"+c.title else "")+(if(c.state.isNotBlank())"\nID: "+c.state else "")}.distinct().joinToString("\n\n")
        AlertDialog.Builder(this).setTitle("Условия кадра").setMessage(item.title+"\n\n"+rules+"\n\n${item.image.width} × ${item.image.height} · ${item.image.bytes/1024} КБ\n"+item.file.name+(if(item.installed.isEmpty())"" else "\nСейчас используется: "+item.installed.joinToString())+"\n\nУсловия взяты из сохранённых данных набора. Показаны только сохранённые на устройстве кадры.").setPositiveButton("Закрыть",null).show()
    }
    private fun showFilters(){
        stopSlideshow()
        val body=LinearLayout(this).apply{orientation=LinearLayout.VERTICAL;setPadding(dp(16),dp(8),dp(16),dp(8))}
        fun selector(name: String,values: List<String>,labels: Map<String,String>,selected: String): Pair<Spinner,List<String>> {
            body.addView(label(name));val keys=listOf("")+values.distinct();val spinner=Spinner(this).apply{minimumHeight=dp(48);contentDescription=name;adapter=ArrayAdapter(this@WallpaperViewerActivity,android.R.layout.simple_spinner_dropdown_item,keys.map{if(it.isBlank())"Все" else labels[it] ?: it});setSelection(keys.indexOf(selected).coerceAtLeast(0))};body.addView(spinner,LinearLayout.LayoutParams(-1,-2));return spinner to keys
        }
        val conditions=all.flatMap{it.conditions}
        val season=selector("Сезон",conditions.map{it.season}.filter{it.isNotBlank()},SavedWallpapers.seasons,filter.season)
        val time=selector("Время суток",conditions.map{it.time}.filter{it.isNotBlank()},SavedWallpapers.times,filter.time)
        val weather=selector("Погода",conditions.map{it.weather}.filter{it.isNotBlank()},SavedWallpapers.weather,filter.weather)
        val moon=selector("Луна",conditions.map{it.moon}.filter{it.isNotBlank()},SavedWallpapers.moons,filter.moon)
        val scroll=ScrollView(this).apply{addView(body)}
        AlertDialog.Builder(this).setTitle("Фильтры обоев").setView(scroll).setNegativeButton("Отмена",null).setNeutralButton("Сбросить"){_,_->filter=WallpaperFilter();applyFilter()}.setPositiveButton("Показать"){_,_->
            fun value(p: Pair<Spinner,List<String>>)=p.second[p.first.selectedItemPosition]
            filter=WallpaperFilter(value(season),value(time),value(weather),value(moon));applyFilter()
        }.show()
    }
    private fun startSlideshow(){
        if(visible.size<2)return
        playing=true;slideshow.text="Остановить слайд-шоу"
        window.addFlags(android.view.WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON)
        if(reverseHistory)index=visible.lastIndex
        setFull(true);showCurrent()
    }
    private fun stopSlideshow(){
        playing=false;slides.removeCallbacks(advance)
        if(::slideshow.isInitialized)slideshow.text="Слайд-шоу"
        window.clearFlags(android.view.WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON)
    }
    private fun setFull(value: Boolean){
        if(!value && playing)stopSlideshow()
        if(value && visible.isEmpty())return
        if(Build.VERSION.SDK_INT>=33){
            if(value && leaveFullScreenBack==null){
                val callback=android.window.OnBackInvokedCallback{setFull(false)}
                onBackInvokedDispatcher.registerOnBackInvokedCallback(android.window.OnBackInvokedDispatcher.PRIORITY_DEFAULT,callback)
                leaveFullScreenBack={onBackInvokedDispatcher.unregisterOnBackInvokedCallback(callback)}
            }else if(!value){leaveFullScreenBack?.invoke();leaveFullScreenBack=null}
        }
        full=value;header.visibility=if(full)View.GONE else View.VISIBLE;footer.visibility=header.visibility
        if(Build.VERSION.SDK_INT>=30){window.insetsController?.apply{systemBarsBehavior=WindowInsetsController.BEHAVIOR_SHOW_TRANSIENT_BARS_BY_SWIPE;if(full)hide(WindowInsets.Type.systemBars()) else show(WindowInsets.Type.systemBars())}}
        else{
            @Suppress("DEPRECATION")
            window.decorView.systemUiVisibility=if(full)View.SYSTEM_UI_FLAG_FULLSCREEN or View.SYSTEM_UI_FLAG_HIDE_NAVIGATION or View.SYSTEM_UI_FLAG_IMMERSIVE_STICKY else if(!dark)View.SYSTEM_UI_FLAG_LIGHT_STATUS_BAR or View.SYSTEM_UI_FLAG_LIGHT_NAVIGATION_BAR else 0}
        picture.contentDescription=if(full)"Обои на весь экран. Нажмите, чтобы вернуть управление." else "Обои. Свайп — листать, двойное касание — увеличить, нажатие — полный экран."
        if(full)Toast.makeText(this,"Нажмите на изображение или «Назад», чтобы вернуть управление",Toast.LENGTH_SHORT).show()
    }
    // Android 13+ uses the platform dispatcher above, enabled only in fullscreen.
    // This override remains solely for the Android 8–12 platform back button.
    @android.annotation.SuppressLint("GestureBackNavigation")
    @Deprecated("Legacy back for API 26–32") override fun onBackPressed(){if(full)setFull(false) else super.onBackPressed()}
    override fun onSaveInstanceState(out: Bundle){out.putString("hash",visible.getOrNull(index)?.image?.sha256);out.putString("filter",filter.json().toString());out.putBoolean("full",full);super.onSaveInstanceState(out)}
    override fun onPause(){stopSlideshow();super.onPause()}
    override fun onDestroy(){stopSlideshow();leaveFullScreenBack?.invoke();leaveFullScreenBack=null;token++;executor.shutdownNow();picture.setImageDrawable(null);bitmap=null;super.onDestroy()}
}
