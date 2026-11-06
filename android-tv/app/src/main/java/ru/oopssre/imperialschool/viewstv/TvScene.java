package ru.oopssre.imperialschool.viewstv;

import android.app.*;
import android.content.*;
import android.graphics.Color;
import android.graphics.drawable.*;
import android.net.Uri;
import android.os.*;
import android.provider.Settings;
import android.view.*;
import android.widget.*;
import java.text.*;
import java.util.*;
import java.util.concurrent.*;

/** One remote-operated scene for the Activity and the system screensaver. */
final class TvScene implements SceneController.Listener {
    interface Host {Context context();Window window();void leave();void launch(Intent intent);}
    final Host host;final Context context;final Repository repo;final FrameLayout root;
    final WallpaperSurface surface;final VideoSurface video;final SceneController controller;
    final VideoController videoController;final Updater updater;final SceneMusic music;
    final Handler handler=new Handler(Looper.getMainLooper());final HoldGate hold=new HoldGate();
    final ExecutorService updateWorker=Executors.newSingleThreadExecutor();
    final ExecutorService previewWorker=Executors.newSingleThreadExecutor();
    final Map<String,String> focusMemory=new HashMap<>();final Map<String,Integer> scrollMemory=new HashMap<>();
    TextView placeholder,hint,details,musicDetails,diagnosticDetails,cacheDetails;
    Button musicToggle,musicSaverToggle,volumeControl;
    ThemeGallery gallery;long capabilityGeneration;Future<?> capabilityJob;
    String creditDetail="",projectReturn="info";boolean projectCode;
    ScrollView panel;LinearLayout content;
    String status="Соединяюсь с сервером…",page="menu",updateStatus="",cacheStatus="";
    Release ready;boolean active,destroyed,updateBusy,pendingInstall,cacheBusy;long updateGeneration;Future<?> updateJob;
    final Runnable held=()->{if(active&&hold.trigger(SystemClock.uptimeMillis()))openSettings();};
    android.hardware.display.DisplayManager displayManager;int[] detectedSize={1920,1080};
    final android.hardware.display.DisplayManager.DisplayListener displayListener=new android.hardware.display.DisplayManager.DisplayListener(){
        public void onDisplayAdded(int id){if(active)refreshResolution(true);}
        public void onDisplayRemoved(int id){if(active)refreshResolution(true);}
        public void onDisplayChanged(int id){if(active)refreshResolution(true);}
    };
    TvScene(Host h){
        host=h;context=h.context();repo=new Repository(context);updater=new Updater(repo);
        root=new FrameLayout(context);root.setBackgroundColor(Color.BLACK);
        detectedSize=WallpaperSurface.physicalSize(h.window().getWindowManager().getDefaultDisplay());
        int[] size=configuredSize();surface=new WallpaperSurface(context);surface.size(size[0],size[1]);
        repo.displaySize(size[0],size[1]);surface.fill=repo.fill();root.addView(surface,new FrameLayout.LayoutParams(-1,-1));
        video=new VideoSurface(context,this::videoChanged);video.fill=repo.prefs.getBoolean("video_fill",true);
        video.setVisibility(videoEnabled()?View.VISIBLE:View.GONE);surface.setVisibility(videoEnabled()?View.GONE:View.VISIBLE);
        root.addView(video,new FrameLayout.LayoutParams(-1,-1));
        placeholder=text(ThemeText.title(repo.selected())+"\nЗагружаю обои…",23);placeholder.setGravity(Gravity.CENTER);placeholder.setBackgroundColor(0xcc0a0917);
        placeholder.setPadding(dp(48),0,dp(48),0);root.addView(placeholder,new FrameLayout.LayoutParams(-1,-1));
        hint=text("Удерживайте OK — меню",18);hint.setGravity(Gravity.CENTER);hint.setPadding(dp(18),dp(10),dp(18),dp(10));hint.setBackgroundColor(0xf2211b38);
        FrameLayout.LayoutParams hp=new FrameLayout.LayoutParams(-2,-2,Gravity.BOTTOM|Gravity.CENTER_HORIZONTAL);hp.bottomMargin=dp(32);root.addView(hint,hp);
        panel=new ScrollView(context);panel.setFillViewport(true);panel.setBackgroundColor(0xff141126);panel.setVisibility(View.GONE);
        FrameLayout.LayoutParams pp=new FrameLayout.LayoutParams(Math.min(dp(480),context.getResources().getDisplayMetrics().widthPixels*3/5),-1,Gravity.RIGHT);pp.rightMargin=dp(48);pp.topMargin=dp(27);pp.bottomMargin=dp(27);root.addView(panel,pp);
        content=new LinearLayout(context);content.setOrientation(LinearLayout.VERTICAL);content.setPadding(dp(28),dp(24),dp(28),dp(24));panel.addView(content,new ScrollView.LayoutParams(-1,-2));
        controller=new SceneController(repo,surface,this);
        music=new SceneMusic(context,repo.prefs,host.context() instanceof android.service.dreams.DreamService,this::musicChanged);
        videoController=new VideoController(repo,video,new VideoController.Listener(){public void changed(){videoStatusChanged();}public void catalogue(){TvScene.this.catalogue();}});
    }
    int dp(int n){return Math.round(n*context.getResources().getDisplayMetrics().density);}
    TextView text(String s,int sp){TextView v=new TextView(context);v.setText(s);v.setTextSize(sp);v.setTextColor(0xfff3ecdb);v.setLineSpacing(dp(3),1);return v;}
    GradientDrawable background(int color,boolean focus){GradientDrawable d=new GradientDrawable();d.setColor(color);d.setCornerRadius(dp(9));if(focus)d.setStroke(dp(3),0xfffbbf55);return d;}
    LinearLayout.LayoutParams buttonLayout(){LinearLayout.LayoutParams lp=new LinearLayout.LayoutParams(-1,-2);lp.bottomMargin=dp(9);return lp;}
    Button makeButton(String key,String title,Runnable action){
        Button b=new Button(context);b.setText(title);b.setTag(key);b.setAllCaps(false);b.setTextSize(20);
        b.setTextColor(new android.content.res.ColorStateList(new int[][]{new int[]{-android.R.attr.state_enabled},new int[]{android.R.attr.state_focused},new int[]{android.R.attr.state_pressed},new int[]{}},new int[]{0xff81788e,0xff27122b,0xff27122b,0xfff3ecdb}));
        b.setGravity(Gravity.LEFT|Gravity.CENTER_VERTICAL);b.setPadding(dp(16),dp(10),dp(16),dp(10));b.setMinHeight(dp(56));b.setFocusable(true);b.setFocusableInTouchMode(true);
        StateListDrawable bg=new StateListDrawable();bg.addState(new int[]{-android.R.attr.state_enabled},background(0xff19162a,false));bg.addState(new int[]{android.R.attr.state_focused},background(0xfffbbf55,true));bg.addState(new int[]{android.R.attr.state_pressed},background(0xfffbbf55,true));bg.addState(new int[]{},background(0xff211b38,false));b.setBackground(bg);
        b.setEnabled(!cacheBusy);b.setOnClickListener(v->action.run());return b;
    }
    Button button(String title,Runnable action){return button(focusKey(title),title,action);}
    Button button(String key,String title,Runnable action){Button b=makeButton(key,title,action);content.addView(b,buttonLayout());return b;}
    String focusKey(String title){String key=title.startsWith("✓ ")?title.substring(2):title;int dot=key.indexOf(" · ");return dot>=0?key.substring(0,dot):key;}
    ScrollView activeScroll(){return gallery==null?panel:gallery.list;}
    void rememberFocus(){View focused=content.findFocus();if(focused!=null&&focused.getTag() instanceof String){focusMemory.put(page,(String)focused.getTag());scrollMemory.put(page,activeScroll().getScrollY());}}
    void beginPage(String name,String title){
        rememberFocus();if(gallery!=null){gallery.close();gallery=null;}
        capabilityGeneration++;if(capabilityJob!=null)capabilityJob.cancel(true);
        page=name;content.removeAllViews();details=musicDetails=diagnosticDetails=cacheDetails=null;volumeControl=null;
        FrameLayout.LayoutParams lp=(FrameLayout.LayoutParams)panel.getLayoutParams();lp.width=Math.min(dp(name.equals("themes")?864:480),context.getResources().getDisplayMetrics().widthPixels-dp(96));panel.setLayoutParams(lp);
        heading(title);
    }
    void collectButtons(View view,List<Button> buttons){if(view instanceof Button){if(view.isEnabled())buttons.add((Button)view);return;}if(view instanceof android.view.ViewGroup){android.view.ViewGroup group=(android.view.ViewGroup)view;for(int i=0;i<group.getChildCount();i++)collectButtons(group.getChildAt(i),buttons);}}
    void focusFirst(){focusFirst(null);}
    void focusFirst(String preferred){final String destination=page;final String key=focusMemory.containsKey(page)?focusMemory.get(page):preferred;
        panel.post(()->{if(!page.equals(destination))return;View target=null;boolean matched=false;List<Button> buttons=new ArrayList<>();collectButtons(content,buttons);for(Button child:buttons){if(target==null)target=child;if(key!=null&&key.equals(child.getTag())){target=child;matched=true;break;}}
            if(target!=null)target.requestFocus();Integer scroll=scrollMemory.get(destination);if(scroll!=null&&matched)activeScroll().scrollTo(0,scroll);else if(key==null||!matched)activeScroll().scrollTo(0,0);
        });
    }
    void heading(String title){TextView v=text(title,26);v.setTypeface(context.getResources().getFont(R.font.oswald_semibold));v.setPadding(0,0,0,dp(18));content.addView(v);}
    void sectionHeading(String title){TextView v=text(title,21);v.setTypeface(context.getResources().getFont(R.font.oswald_semibold));v.setPadding(0,dp(8),0,dp(16));content.addView(v);}
    void message(String s){TextView v=text(s,18);v.setPadding(0,dp(8),0,dp(20));content.addView(v);}
    TextView technical(String value){TextView v=text(value,16);v.setTypeface(context.getResources().getFont(R.font.ptmono));v.setTextColor(0xffb9b1ce);v.setPadding(0,dp(8),0,dp(20));content.addView(v);return v;}
    boolean videoEnabled(){return repo.videoEnabled();}
    String musicTheme(){return repo.selected().id;}
    int[] configuredSize(){if(videoEnabled()){VideoSurface.configureWindow(host.window());return new int[]{3840,2160};}return WallpaperSurface.configure(host.window(),host.window().getDecorView().getDisplay(),repo.resolution());}
    void videoChanged(){if(videoController!=null)videoController.surfaceChanged();videoStatusChanged();}
    String waitingText(String value){return SceneCopy.waiting(value);}
    String imagePin(){return controller.frame==null?"":controller.frame.sha;}
    void videoStatusChanged(){if(!videoEnabled()||destroyed)return;VideoInfo shown=video.displayed;status=shown==null?videoController.status:shown.frame.stale(System.currentTimeMillis())?"Обновление задерживается":"Видео · "+shown.frame.title;refreshDetails();refreshDiagnostics();
        if(video.playing)placeholder.setVisibility(View.GONE);else{placeholder.setText(ThemeText.title(repo.selected())+"\n\n"+waitingText(video.state.startsWith("Ошибка видео")?video.state:videoController.status));placeholder.setVisibility(panel.getVisibility()==View.VISIBLE?View.GONE:View.VISIBLE);}}
    void resetPlayback(){status="Загружаю обои…";controller.reset();videoController.reset();video.reset();surface.clear();}
    void videoOutput(boolean enabled){if(cacheBusy)return;resetPlayback();repo.prefs.edit().putBoolean("video_output",enabled).apply();refreshResolution(false);if(active)resumePlayback();screenMenu();}
    void chooseTheme(Protocol.Theme theme){if(cacheBusy)return;resetPlayback();repo.choose(theme);refreshResolution(false);placeholder.setText(ThemeText.title(theme)+"\nЗагружаю обои…");if(active)resumePlayback();closeSettings();}
    void resumePlayback(){if(cacheBusy)return;boolean useVideo=videoEnabled();surface.setVisibility(useVideo?View.GONE:View.VISIBLE);video.setVisibility(useVideo?View.VISIBLE:View.GONE);music.scene(true,musicTheme());if(useVideo){controller.stop();video.start();videoController.start();}else{videoController.stop();video.stop();controller.start();}}
    void pausePlayback(){music.scene(false,musicTheme());controller.stop();videoController.stop();video.stop();}
    void refreshResolution(boolean refresh){detectedSize=WallpaperSurface.physicalSize(host.window().getWindowManager().getDefaultDisplay());int[] size=configuredSize();boolean changed=size[0]!=surface.bufferWidth||size[1]!=surface.bufferHeight;repo.displaySize(size[0],size[1]);if(changed){surface.size(size[0],size[1]);if(refresh&&!videoEnabled()&&!cacheBusy)controller.refresh(true);}}
    void start(){if(active)return;active=true;if(panel.getVisibility()==View.VISIBLE&&page.equals("themes"))themeList();refreshResolution(false);displayManager=(android.hardware.display.DisplayManager)context.getSystemService(Context.DISPLAY_SERVICE);if(displayManager!=null)displayManager.registerDisplayListener(displayListener,handler);resumePlayback();long restore=++updateGeneration;
        updateWorker.submit(()->{Release cached=updater.ready();handler.post(()->{if(!destroyed&&restore==updateGeneration){ready=cached;if(active&&page.equals("updates")&&panel.getVisibility()==View.VISIBLE)updatesMenu();}});});
        handler.postDelayed(()->{if(active)hint.setVisibility(View.GONE);},8000);if(pendingInstall&&context.getPackageManager().canRequestPackageInstalls()){pendingInstall=false;install();}}
    void stop(){active=false;if(displayManager!=null)displayManager.unregisterDisplayListener(displayListener);music.scene(false,musicTheme());updateGeneration++;hold.release();handler.removeCallbacks(held);if(gallery!=null){rememberFocus();gallery.close();}capabilityGeneration++;if(capabilityJob!=null)capabilityJob.cancel(true);controller.stop();videoController.stop();video.stop();if(updateJob!=null)updateJob.cancel(true);updateBusy=false;}
    void destroy(){destroyed=true;stop();handler.removeCallbacksAndMessages(null);controller.destroy();videoController.destroy();video.destroy();music.destroy();updateWorker.shutdownNow();previewWorker.shutdownNow();}
    boolean handle(KeyEvent e){int code=e.getKeyCode();
        if(Soundtracks.available(musicTheme())&&(code==KeyEvent.KEYCODE_MEDIA_PLAY_PAUSE||code==KeyEvent.KEYCODE_MEDIA_PLAY||code==KeyEvent.KEYCODE_MEDIA_PAUSE||code==KeyEvent.KEYCODE_MEDIA_NEXT||code==KeyEvent.KEYCODE_MEDIA_PREVIOUS)){if(!cacheBusy&&e.getAction()==KeyEvent.ACTION_DOWN&&e.getRepeatCount()==0){if(code==KeyEvent.KEYCODE_MEDIA_NEXT)music.next();else if(code==KeyEvent.KEYCODE_MEDIA_PREVIOUS)music.previous();else music.enabled(code==KeyEvent.KEYCODE_MEDIA_PLAY||code==KeyEvent.KEYCODE_MEDIA_PLAY_PAUSE&&!music.enabled());}return true;}
        boolean ok=code==KeyEvent.KEYCODE_DPAD_CENTER||code==KeyEvent.KEYCODE_ENTER||code==KeyEvent.KEYCODE_NUMPAD_ENTER;
        if(ok&&hold.pressed()){if(e.getAction()==KeyEvent.ACTION_UP){handler.removeCallbacks(held);hold.release();}return true;}
        if(ok&&panel.getVisibility()!=View.VISIBLE){if(e.getAction()==KeyEvent.ACTION_DOWN&&e.getRepeatCount()==0){hold.down(SystemClock.uptimeMillis());handler.postDelayed(held,HoldGate.HOLD_MS);}return true;}
        if(code==KeyEvent.KEYCODE_BACK||code==KeyEvent.KEYCODE_ESCAPE){if(e.getAction()==KeyEvent.ACTION_DOWN&&e.getRepeatCount()==0)back();return true;}return false;
    }
    void back(){
        if(panel.getVisibility()!=View.VISIBLE){host.leave();return;}
        if(page.equals("menu")){closeSettings();return;}
        if(page.equals("project")&&projectReturn.equals("credits_detail")){creditsDetail();return;}
        showPage(SceneCopy.parent(page));
    }
    void showPage(String destination){
        switch(destination){
            case "settings":settingsMenu();break;case "themes":themeList();break;
            case "collection":collectionMenu();break;case "screen":screenMenu();break;
            case "music":musicMenu();break;case "info":info();break;
            case "music_credits":musicCredits();break;default:openSettings();
        }
    }
    void openSettings(){
        placeholder.setVisibility(View.GONE);panel.setVisibility(View.VISIBLE);hint.setVisibility(View.GONE);
        beginPage("menu","Виды Школы Империи");message(ThemeText.title(repo.selected()));
        button("themes","Выбрать обои",this::themeList);
        if(Soundtracks.available(musicTheme()))button("music","Музыка",this::musicMenu);
        button("settings","Настройки",this::settingsMenu);focusFirst();
    }
    void settingsMenu(){beginPage("settings","Настройки");button("Показ изображения",this::screenMenu);button("Системная заставка",this::systemSettings);button("Хранилище",this::cacheMenu);button("О приложении",this::info);focusFirst();}
    void closeSettings(){rememberFocus();if(gallery!=null){gallery.close();gallery=null;}capabilityGeneration++;if(capabilityJob!=null)capabilityJob.cancel(true);panel.setVisibility(View.GONE);placeholder.setVisibility(videoEnabled()?(video.playing?View.GONE:View.VISIBLE):(controller.frame==null?View.VISIBLE:View.GONE));page="menu";}
    void refreshDetails(){if(page.equals("updates")&&details!=null)details.setText(updateStatus);if(cacheDetails!=null&&page.equals("cache"))cacheDetails.setText(cacheText());}
    void themeList(){beginPage("themes","Выбор обоев");gallery=new ThemeGallery(this,repo.themes());focusFirst("theme:"+repo.selected().id);}
    void collectionMenu(){beginPage("collection",ThemeText.title(repo.selected()));message(ThemeText.description(repo.selected()));
        if(repo.selected().kind.equals("weather"))button("Источник погоды · "+(repo.weatherSource().equals("real")?"Погода Столицы Империи":"Игровой мир"),this::weatherList);
        else if(!repo.selected().kind.equals("dynamic"))button("Смена изображений",this::modeList);
        focusFirst();
    }
    void weatherList(){beginPage("weather","Источник погоды");for(String source:new String[]{"real","game-world"}){try{Sources.source(repo.selected(),source);}catch(Exception e){continue;}button((source.equals(repo.weatherSource())?"✓ ":"")+(source.equals("real")?"Погода Столицы Империи":"Игровой мир"),()->{repo.prefs.edit().putString("weather_source",source).apply();controller.refresh(true);collectionMenu();});}focusFirst(repo.weatherSource().equals("real")?"Погода Столицы Империи":"Игровой мир");}
    void modeList(){beginPage("mode","Смена изображений");for(String mode:new String[]{"auto","daily","monthly","seasonal"}){org.json.JSONObject schedule=repo.selected().descriptor.optJSONObject("schedule");if((mode.equals("monthly")||mode.equals("seasonal"))&&(schedule==null||!schedule.has(mode)))continue;
        String label=mode.equals("auto")?"По расписанию коллекции":mode.equals("daily")?"Каждый день":mode.equals("monthly")?"По месяцам":"По сезонам";
        button(mode,(mode.equals(repo.simpleMode())?"✓ ":"")+label,()->{repo.prefs.edit().putString("simple_mode_"+repo.selected().id,mode).apply();controller.refresh(true);collectionMenu();});}focusFirst(repo.simpleMode());
    }
    void screenMenu(){beginPage("screen","Показ изображения");if(repo.selected().kind.equals("dynamic"))button("output","Способ показа · "+(videoEnabled()?"Видео 4К":"Изображение"),this::outputList);
        if(!videoEnabled())button("Разрешение · "+TvDisplay.label(repo.resolution()),this::resolutionList);
        button("Размещение · "+((videoEnabled()?video.fill:repo.fill())?"Заполнить экран":"Вписать целиком"),this::scaleList);
        button("Проверить обновление обоев",()->{if(videoEnabled())videoController.refresh(false);else controller.refresh(false);Toast.makeText(context,"Проверяю обновление обоев",Toast.LENGTH_SHORT).show();});focusFirst();}
    void outputList(){
        beginPage("output","Способ показа");button("image",(!repo.videoPreferred()?"✓ ":"")+"Изображение",()->videoOutput(false));
        Button choice=button("video",(repo.videoPreferred()?"✓ ":"")+"Видео 4К",()->videoOutput(true));choice.setEnabled(false);
        TextView availability=text("Проверяю доступность видео…",18);availability.setPadding(0,dp(12),0,0);content.addView(availability);focusFirst(repo.videoPreferred()?"video":"image");
        final long token=capabilityGeneration;Protocol.Theme theme=repo.selected();
        capabilityJob=updateWorker.submit(()->{
            boolean available=false;String note;
            try{VideoInfo v=new VideoLoader(repo.net,repo.cache).describe(theme,false);available=VideoSurface.supports(v);note=available?"Видео этой сцены готово.":"Этот телевизор не поддерживает видео 4К.";}
            catch(Protocol.NotReady e){note="Видео этой сцены ещё не готово. Изображение доступно.";}
            catch(Exception e){note="Не удалось проверить видео. Попробуйте открыть этот раздел позже.";}
            boolean enabled=available;String result=note;
            handler.post(()->{if(!active||token!=capabilityGeneration||!page.equals("output"))return;choice.setEnabled(enabled&&!cacheBusy);availability.setText(result);});
        });
    }
    void scaleList(){beginPage("scale","Размещение");boolean fill=videoEnabled()?video.fill:repo.fill();for(boolean value:new boolean[]{false,true})button(value?"fill":"fit",(value==fill?"✓ ":"")+(value?"Заполнить экран":"Вписать целиком"),()->{if(videoEnabled()){repo.prefs.edit().putBoolean("video_fill",value).apply();video.fill=value;}else{repo.fill(value);surface.fill=value;surface.drawFrame();}screenMenu();});message("При заполнении экрана края могут быть обрезаны.");focusFirst(fill?"fill":"fit");}
    void resolutionList(){beginPage("resolution","Разрешение изображения");for(String mode:new String[]{TvDisplay.AUTO,TvDisplay.UHD,TvDisplay.FULL_HD})button(mode,(mode.equals(repo.resolution())?"✓ ":"")+TvDisplay.label(mode),()->{repo.resolution(mode);refreshResolution(false);controller.refresh(true);screenMenu();});message("Если 4К-телевизор определяется как Full HD, выберите 4К вручную.");focusFirst(repo.resolution());}
    void info(){beginPage("info","О приложении");String installed=BuildInfo.VERSION;long build=BuildInfo.CODE;try{android.content.pm.PackageInfo p=context.getPackageManager().getPackageInfo(context.getPackageName(),0);installed=p.versionName;build=Build.VERSION.SDK_INT>=28?p.getLongVersionCode():p.versionCode;}catch(Exception ignored){}
        message("Виды Школы Империи TV\nВерсия "+installed+" · сборка "+build+"\n\nДмитрий Малыхин aka Timon_Crazy");
        button("Сайт проекта",()->projectLink(false));button("Исходный код",()->projectLink(true));
        button("Обновление приложения",this::updatesMenu);button("Музыка и авторы",this::musicCredits);button("Диагностика",this::diagnostics);focusFirst();
    }
    void projectLink(boolean code){projectReturn=page.equals("credits_detail")?"credits_detail":"info";projectCode=code;beginPage("project",code?"Исходный код":"Сайт проекта");String url=code?"https://github.com/GremlinEngineering/imperial-school-views":"https://games.oopssre.ru/gremlin.html#views";
        message("Откройте ссылку на телефоне или компьютере.");
        QrView qr=new QrView(context,code);LinearLayout.LayoutParams lp=new LinearLayout.LayoutParams(dp(196),dp(196));lp.bottomMargin=dp(16);content.addView(qr,lp);
        TextView address=text(url,18);address.setTextIsSelectable(false);address.setPadding(0,0,0,dp(16));content.addView(address);
        button("Открыть на телевизоре",()->{try{host.launch(new Intent(Intent.ACTION_VIEW,Uri.parse(url)).addFlags(Intent.FLAG_ACTIVITY_NEW_TASK));}catch(Exception e){Toast.makeText(context,"На телевизоре нет приложения для открытия ссылки. Используйте QR-код.",Toast.LENGTH_LONG).show();}});focusFirst();
    }
    void musicChanged(){if(page.equals("music")&&musicDetails!=null){musicDetails.setText(music.title()+"\n"+music.state);if(musicToggle!=null)musicToggle.setText("Музыка в приложении · "+(music.isEnabled(false)?"Включена":"Выключена"));if(musicSaverToggle!=null)musicSaverToggle.setText("Музыка в заставке · "+(music.isEnabled(true)?"Включена":"Выключена"));if(volumeControl!=null)volumeControl.setText("Громкость · "+music.level()+"%   ‹  ›");}}
    void musicMenu(){beginPage("music","Музыка");musicDetails=text(music.title()+"\n"+music.state,20);musicDetails.setPadding(0,0,0,dp(20));content.addView(musicDetails);
        musicToggle=button("app-sound","Музыка в приложении",()->music.enabled(false,!music.isEnabled(false)));
        musicSaverToggle=button("saver-sound","Музыка в заставке",()->music.enabled(true,!music.isEnabled(true)));
        volumeControl=button("volume","Громкость",()->{music.volume(Math.min(100,music.level()+10));});
        volumeControl.setOnKeyListener((v,key,event)->{if(key!=KeyEvent.KEYCODE_DPAD_LEFT&&key!=KeyEvent.KEYCODE_DPAD_RIGHT)return false;if(event.getAction()==KeyEvent.ACTION_DOWN){music.volume(Math.max(0,Math.min(100,music.level()+(key==KeyEvent.KEYCODE_DPAD_RIGHT?5:-5))));}return true;});
        LinearLayout transport=new LinearLayout(context);transport.setOrientation(LinearLayout.HORIZONTAL);
        LinearLayout.LayoutParams previous=new LinearLayout.LayoutParams(0,-2,1);previous.rightMargin=dp(10);
        transport.addView(makeButton("previous","Предыдущий",music::previous),previous);
        transport.addView(makeButton("next","Следующий",music::next),new LinearLayout.LayoutParams(0,-2,1));content.addView(transport,buttonLayout());
        message("Громкость музыки: стрелки влево и вправо. Громкость телевизора задаётся пультом.");musicChanged();focusFirst();
    }
    void musicCredits(){beginPage("music_credits","Музыка и авторы");for(Soundtracks.Pack pack:Soundtracks.ALL){sectionHeading(pack.title);for(int i=0;i<pack.titles.length;i++){final String detail=pack.credits[i];button(pack.id+":"+i,pack.titles[i],()->{creditDetail=detail;creditsDetail();});}}focusFirst();}
    void creditsDetail(){beginPage("credits_detail","О композиции");String[] lines=creditDetail.split("\n");StringBuilder brief=new StringBuilder();for(int i=0;i<Math.min(2,lines.length);i++)brief.append(lines[i]).append('\n');message(brief.toString().trim());button("Полные сведения и источники",()->projectLink(true));focusFirst();}
    String mb(long bytes){return String.format(Locale.getDefault(),"%.1f МиБ",bytes/1048576.0);}
    String cacheText(){return "Всего: "+mb(CacheStore.directoryBytes(context.getCacheDir()))+"\nОбои и превью: "+mb(repo.cache.bytes())+"\nФайл обновления: "+mb(CacheStore.directoryBytes(updater.folder))+(cacheStatus.isEmpty()?"":"\n\n"+cacheStatus);}
    void cacheMenu(){beginPage("cache","Хранилище");cacheDetails=text(cacheText(),20);cacheDetails.setPadding(0,0,0,dp(20));content.addView(cacheDetails);button(cacheBusy?"Очищаю кеш…":"Очистить кеш",this::clearCache).setEnabled(!cacheBusy);message("Устаревшие файлы удаляются автоматически. Очистка сохранит настройки и загрузит текущие обои заново.");focusFirst();}
    void clearCache(){if(cacheBusy)return;cacheBusy=true;pausePlayback();resetPlayback();updateGeneration++;if(updateJob!=null)updateJob.cancel(true);updateBusy=false;ready=null;updateStatus="";cacheStatus="Очищаю кеш…";cacheMenu();
        final Future<?> imageIdle=controller.worker.submit(()->{}),cachedImageIdle=controller.cacheWorker.submit(()->{}),videoIdle=videoController.worker.submit(()->{}),decoderIdle=video.worker.submit(()->{}),previewIdle=previewWorker.submit(()->{});
        updateWorker.submit(()->{String result;try{imageIdle.get(30,TimeUnit.SECONDS);cachedImageIdle.get(30,TimeUnit.SECONDS);videoIdle.get(30,TimeUnit.SECONDS);decoderIdle.get(30,TimeUnit.SECONDS);previewIdle.get(30,TimeUnit.SECONDS);CacheStore.clearDirectory(context.getCacheDir());result="Кеш очищен";}catch(Exception e){result="Не удалось очистить кеш. Повторите попытку.";}
            repo.cache.recreate();updater.folder.mkdirs();String message=result;handler.post(()->{if(destroyed)return;cacheBusy=false;cacheStatus=message;if(active){refreshResolution(false);resumePlayback();}if(page.equals("cache")&&panel.getVisibility()==View.VISIBLE)cacheMenu();else refreshDetails();});
        });}
    void diagnostics(){beginPage("diagnostics","Диагностика");diagnosticDetails=technical(diagnosticsText());button("Проверить обновление обоев",()->{if(videoEnabled())videoController.refresh(false);else controller.refresh(false);});focusFirst();}
    String diagnosticsText(){
        if(videoEnabled()){VideoInfo v=video.displayed;return "Режим: видео 4К\nВыбрано: "+repo.selected().title+"\nОпределено Android: "+detectedSize[0]+" × "+detectedSize[1]+"\n"+video.diagnostics()+(v==null?"":"\nСобран: "+date(v.frame.at)+"\nАктуален до: "+date(v.frame.until)+"\nОтметка просрочки после: "+date(v.frame.staleAfter())+"\n"+(v.frame.stale(System.currentTimeMillis())?"Данные кадра просрочены":"Кадр актуален"))+"\nПроверка публикации: "+videoController.status+"\nСледующая проверка: "+(videoController.nextCheckAt>0?date(videoController.nextCheckAt):"сейчас")+"\nКеш: "+mb(CacheStore.directoryBytes(context.getCacheDir()));}
        Protocol.Frame f=controller.frame;String value="Коллекция: "+repo.selected().title+"\nРежим: "+TvDisplay.label(repo.resolution())+"\nОпределено Android: "+detectedSize[0]+" × "+detectedSize[1]+"\nЗапрошенный профиль: "+repo.selected().device+"\nБуфер запрошен: "+surface.bufferWidth+" × "+surface.bufferHeight+"\nБуфер фактически: "+(surface.actualWidth>0?surface.actualWidth+" × "+surface.actualHeight:"ещё не создан");
        if(surface.image!=null&&!surface.image.isRecycled())value+="\nИзображение в памяти: "+surface.image.getWidth()+" × "+surface.image.getHeight();value+="\n\n"+status;
        if(f!=null)value+="\n\nПоказанный профиль: "+f.device+"\nФайл: "+f.format.toUpperCase(Locale.ROOT)+" · "+f.width+" × "+f.height+"\nСобран: "+date(f.at)+"\nАктуален до: "+date(f.until)+"\n"+(f.stale(System.currentTimeMillis())?"Показан последний кадр; обновление задерживается":"Кадр актуален");
        return value+"\n\nКеш: "+mb(CacheStore.directoryBytes(context.getCacheDir()));
    }
    void refreshDiagnostics(){if(page.equals("diagnostics")&&panel.getVisibility()==View.VISIBLE&&diagnosticDetails!=null)diagnosticDetails.setText(diagnosticsText());}
    String date(long at){return DateFormat.getDateTimeInstance(DateFormat.SHORT,DateFormat.SHORT).format(new Date(at));}
    void systemSettings(){try{host.launch(new Intent(Settings.ACTION_DREAM_SETTINGS).addFlags(Intent.FLAG_ACTIVITY_NEW_TASK));}catch(Exception e){Toast.makeText(context,"Меню заставки недоступно на этом телевизоре",Toast.LENGTH_LONG).show();}}
    public void status(String value){if(videoEnabled())return;status=value;refreshDetails();refreshDiagnostics();if(controller.frame==null)placeholder.setText(ThemeText.title(repo.selected())+"\n\n"+waitingText(value));}
    public void frame(Protocol.Frame frame){if(videoEnabled())return;placeholder.setVisibility(View.GONE);status=frame.stale(System.currentTimeMillis())?"Обновление задерживается":"Обои обновлены · "+date(frame.at);refreshDetails();refreshDiagnostics();}
    public void catalogue(){if(page.equals("themes")&&panel.getVisibility()==View.VISIBLE&&!cacheBusy)themeList();refreshDetails();}
    void updatesMenu(){beginPage("updates","Обновление приложения");message("Установлена версия "+BuildInfo.VERSION);button(updateBusy?"Загружаю обновление…":ready==null?"Проверить обновление":"Установить версию "+ready.version,()->{if(!updateBusy){if(ready==null)checkUpdate();else install();}}).setEnabled(!updateBusy&&!cacheBusy);details=text(updateStatus,18);details.setPadding(0,dp(8),0,dp(16));content.addView(details);focusFirst();}
    void checkUpdate(){long token=++updateGeneration;updateBusy=true;updateStatus="Проверяю обновление…";updatesMenu();updateJob=updateWorker.submit(()->{Release result=null;String message;try{result=updater.check(controller.frame==null?"":controller.frame.sha);message=result==null?"Установлена последняя версия":"Обновление готово к установке";}catch(Exception e){message=e instanceof HttpTransport.HttpFailure&&((HttpTransport.HttpFailure)e).status==404?"Обновление пока не опубликовано":"Не удалось получить обновление. Повторите позже.";}Release next=result;String text=message;handler.post(()->{if(destroyed||token!=updateGeneration)return;updateBusy=false;ready=next;updateStatus=text;if(active&&page.equals("updates")&&panel.getVisibility()==View.VISIBLE)updatesMenu();});});}
    void install(){try{if(updater.ready()==null){ready=null;updateStatus="Проверьте обновление ещё раз";updatesMenu();return;}if(!context.getPackageManager().canRequestPackageInstalls()){pendingInstall=true;host.launch(new Intent(Settings.ACTION_MANAGE_UNKNOWN_APP_SOURCES,Uri.parse("package:"+context.getPackageName())).addFlags(Intent.FLAG_ACTIVITY_NEW_TASK));return;}pendingInstall=false;host.launch(updater.installer());}catch(Exception e){updateStatus="Не удалось открыть установщик";refreshDetails();}}
}
