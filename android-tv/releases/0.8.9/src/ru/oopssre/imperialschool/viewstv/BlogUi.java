package ru.oopssre.imperialschool.viewstv;

import android.content.Context;
import android.content.res.ColorStateList;
import android.graphics.Canvas;
import android.graphics.Paint;
import android.graphics.Typeface;
import android.text.SpannableString;
import android.text.Spanned;
import android.text.style.ForegroundColorSpan;
import android.graphics.drawable.GradientDrawable;
import android.graphics.drawable.StateListDrawable;
import android.view.Gravity;
import android.view.KeyEvent;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.FrameLayout;
import android.widget.LinearLayout;
import android.widget.Space;
import android.widget.TextView;
import java.util.ArrayList;
import java.util.List;

final class BlogUi {
    private static final String LIGHT = "blog_light_theme";
    private static final String APP = "Виды Школы Империи";
    private static final Typeface MONO = Typeface.create("monospace", Typeface.NORMAL);
    private static final Typeface SERIF = Typeface.create("serif", Typeface.BOLD);
    private static final int MATCH = ViewGroup.LayoutParams.MATCH_PARENT;
    private static final int WRAP = ViewGroup.LayoutParams.WRAP_CONTENT;
    private static final Palette EVENING = new Palette(0xff101813, 0xff17221a, 0xffd5e3cf,
            0xff91ad91, 0xff38523c, 0xffcfa460, 0xff263225);
    private static final Palette DAY = new Palette(0xfff3efe6, 0xfffffdf8, 0xff292720,
            0xff756e61, 0xffd6cdc0, 0xffaf6f29, 0xfff5e7d5);

    private static final class Palette {
        final int paper, panel, ink, dim, edge, accent, focus;
        Palette(int paper, int panel, int ink, int dim, int edge, int accent, int focus) {
            this.paper=paper;
            this.panel=panel;
            this.ink=ink;
            this.dim=dim;
            this.edge=edge;
            this.accent=accent;
            this.focus=focus;
        }
    }

    private static final class Page {
        Meter meter;
        TextView radioName;
        TextView radioStatus;
        TextView radioLegend;
        final List<Button> stations = new ArrayList<>();
    }

    private static Palette palette(TvScene scene) {
        return scene.repo != null && scene.repo.prefs.getBoolean(LIGHT, false) ? DAY : EVENING;
    }

    private static GradientDrawable frame(TvScene scene, int fill, int border, int width) {
        GradientDrawable shape = new GradientDrawable();
        shape.setColor(fill);
        shape.setCornerRadius(scene.dp(2));
        shape.setStroke(scene.dp(width), border);
        return shape;
    }

    static void text(TvScene scene, TextView text) {
        text.setTypeface(MONO);
        text.setTextColor(palette(scene).ink);
    }

    static void heading(TvScene scene, TextView text) {
        text.setTypeface(SERIF);
        text.setTextColor(palette(scene).ink);
        text.setTextSize("menu".equals(scene.page) ? 31 : 33);
    }

    static void section(TvScene scene, TextView text) {
        text.setTypeface(SERIF);
        text.setTextColor(palette(scene).dim);
        text.setTextSize(18);
    }

    static void button(TvScene scene, Button button) {
        Palette p = palette(scene);
        StateListDrawable background = new StateListDrawable();
        background.addState(new int[]{-android.R.attr.state_enabled}, frame(scene,p.paper,p.edge,1));
        background.addState(new int[]{android.R.attr.state_focused}, frame(scene,p.focus,p.accent,2));
        background.addState(new int[]{android.R.attr.state_pressed}, frame(scene,p.focus,p.accent,2));
        background.addState(new int[]{android.R.attr.state_selected}, frame(scene,p.focus,p.edge,1));
        background.addState(new int[0], frame(scene,p.panel,p.edge,1));
        button.setBackgroundTintList(null);
        button.setBackground(background);
        button.setTextColor(new ColorStateList(
                new int[][]{new int[]{-android.R.attr.state_enabled},new int[0]},
                new int[]{p.dim,p.ink}));
        button.setTypeface(Typeface.create(MONO,Typeface.BOLD));
        button.setTextSize(17);
        button.setMinHeight(scene.dp(44));
        button.setPadding(scene.dp(13),scene.dp(7),scene.dp(13),scene.dp(7));
        button.setGravity(Gravity.START | Gravity.CENTER_VERTICAL);
        button.setStateListAnimator(null);
    }

    static String page(TvScene scene, String title) {
        Palette p = palette(scene);
        FrameLayout.LayoutParams layout = (FrameLayout.LayoutParams) scene.panel.getLayoutParams();
        int width = scene.context.getResources().getDisplayMetrics().widthPixels;
        int inset = Math.min(scene.dp(40), width/22);
        boolean menu = "menu".equals(scene.page);
        layout.gravity = Gravity.TOP | Gravity.LEFT;
        layout.width = menu ? Math.min(scene.dp(390), Math.max(scene.dp(260), width*34/100)) : MATCH;
        layout.height = MATCH;
        if (menu) layout.setMargins(inset,scene.dp(34),inset,scene.dp(34));
        else layout.setMargins(0,0,0,0);
        scene.panel.setLayoutParams(layout);
        if (menu) scene.panel.setBackground(frame(scene,p.paper,p.edge,1));
        else scene.panel.setBackgroundColor(p.paper);
        int horizontal=menu?scene.dp(20):Math.min(scene.dp(40),width/22);
        scene.content.setPadding(horizontal,scene.dp(18),horizontal,scene.dp(14));
        scene.content.setTag(null);
        scene.hint.setTextColor(p.ink);
        scene.hint.setBackground(frame(scene,p.paper,p.edge,1));
        if (menu) return "Виды Школы\nИмперии";
        return "themes".equals(scene.page) ? APP : title;
    }

    static boolean back(TvScene scene) {
        if (!"appearance".equals(scene.page)) return false;
        scene.settingsMenu();
        return true;
    }

    static void finish(TvScene scene) {
        if (scene.content.getTag() instanceof Page) return;
        Page page = new Page();
        scene.content.setTag(page);
        switch (scene.page) {
            case "menu": home(scene); break;
            case "themes": gallery(scene); break;
            case "settings": settings(scene); break;
            case "screen":
            case "appearance": settingsDetail(scene); break;
            case "music": music(scene,page); break;
            default: break;
        }
    }

    private static LinearLayout column(Context context) {
        LinearLayout column = new LinearLayout(context);
        column.setOrientation(LinearLayout.VERTICAL);
        return column;
    }

    private static TextView label(TvScene scene,String value,int size,boolean title) {
        TextView label = scene.text(value,size);
        if (title) label.setTypeface(SERIF);
        return label;
    }

    private static TextView dim(TvScene scene, String value, int size) {
        TextView text = label(scene,value,size,false);
        text.setTextColor(palette(scene).dim);
        return text;
    }

    private static void rule(TvScene scene, LinearLayout where) {
        View line = new View(scene.context);
        line.setBackgroundColor(palette(scene).edge);
        LinearLayout.LayoutParams lp = new LinearLayout.LayoutParams(MATCH,scene.dp(1));
        lp.topMargin = scene.dp(9);
        lp.bottomMargin = scene.dp(9);
        where.addView(line,lp);
    }

    private static void footer(TvScene scene, String value) {
        rule(scene,scene.content);
        scene.content.addView(dim(scene,value,14));
    }

    private static void home(TvScene scene) {
        if (!(scene.content.getChildAt(1) instanceof TextView) || scene.content.getChildAt(1) instanceof Button) return;
        TextView status=(TextView)scene.content.getChildAt(1);
        scene.content.removeView(status);
        scene.content.addView(new Space(scene.context),new LinearLayout.LayoutParams(MATCH,0,1));
        rule(scene,scene.content);
        scene.content.addView(dim(scene,"На экране",14));
        status.setPadding(0,scene.dp(3),0,0);
        status.setTextColor(palette(scene).ink);
        scene.content.addView(status);
    }

    private static void gallery(TvScene scene) {
        ThemeGallery gallery = scene.gallery;
        if (gallery == null || !(gallery.list.getParent() instanceof LinearLayout)) return;
        LinearLayout columns = (LinearLayout) gallery.list.getParent();
        LinearLayout left = (LinearLayout) gallery.image.getParent();
        LinearLayout.LayoutParams leftSize = (LinearLayout.LayoutParams) left.getLayoutParams();
        leftSize.weight = 1.65f;
        left.setLayoutParams(leftSize);
        LinearLayout.LayoutParams listSize = (LinearLayout.LayoutParams) gallery.list.getLayoutParams();
        columns.removeView(gallery.list);
        LinearLayout right = column(scene.context);
        right.addView(label(scene,"Коллекции",24,true));
        rule(scene,right);
        right.addView(gallery.list,new LinearLayout.LayoutParams(MATCH,0,1));
        TextView legend = dim(scene,"●  Сейчас на экране",13);
        legend.setPadding(0,scene.dp(7),0,0);
        right.addView(legend);
        columns.addView(right,listSize);
        int height = scene.context.getResources().getDisplayMetrics().heightPixels;
        int width = scene.context.getResources().getDisplayMetrics().widthPixels;
        ViewGroup.LayoutParams size = columns.getLayoutParams();
        size.height = Math.max(scene.dp(220),height-scene.dp(158));
        columns.setLayoutParams(size);
        ViewGroup.LayoutParams picture = gallery.image.getLayoutParams();
        picture.height = Math.min((int)(width*.32f),Math.max(scene.dp(120),size.height-scene.dp(117)));
        gallery.image.setLayoutParams(picture);
        gallery.image.setBackground(frame(scene,0xff0d1410,palette(scene).edge,1));
        gallery.title.setTypeface(SERIF);
        gallery.title.setTextColor(palette(scene).ink);
        gallery.title.setTextSize(25);
        gallery.description.setTextColor(palette(scene).dim);
        gallery.state.setTextColor(palette(scene).dim);
        recolorGallery(scene,gallery.list);
        footer(scene,"↑ ↓  Предпросмотр     ОК  Применить     Назад  К меню");
    }

    private static void recolorGallery(TvScene scene, View view) {
        if (view instanceof Button) {
            Button button=(Button)view;
            String title=button.getText().toString();
            if (title.startsWith("✓ ")) {
                button.setText(marked(scene,title.substring(2)));
                button.setContentDescription("Сейчас на экране. "+title.substring(2));
            }
        } else if (view instanceof TextView) {
            TextView heading=(TextView)view;
            section(scene,heading);
            if (heading.getText().toString().equals("Живые сцены")) heading.setText("Динамические обои");
        } else if (view instanceof ViewGroup) {
            ViewGroup group=(ViewGroup)view;
            for (int i=0;i<group.getChildCount();i++) recolorGallery(scene,group.getChildAt(i));
        }
    }

    private static CharSequence marked(TvScene scene,CharSequence title) {
        SpannableString value=new SpannableString("●  "+title);
        value.setSpan(new ForegroundColorSpan(palette(scene).accent),0,1,Spanned.SPAN_EXCLUSIVE_EXCLUSIVE);
        return value;
    }

    private static LinearLayout split(TvScene scene,LinearLayout left,LinearLayout right,
                                      float leftWeight,float rightWeight) {
        LinearLayout row = new LinearLayout(scene.context);
        row.setOrientation(LinearLayout.HORIZONTAL);
        row.setBaselineAligned(false);
        LinearLayout.LayoutParams leftSize = new LinearLayout.LayoutParams(0,WRAP,leftWeight);
        leftSize.rightMargin=scene.dp(24);
        row.addView(left,leftSize);
        row.addView(right,new LinearLayout.LayoutParams(0,WRAP,rightWeight));
        scene.content.addView(row,new LinearLayout.LayoutParams(MATCH,WRAP));
        return row;
    }

    private static List<View> takeBody(TvScene scene) {
        List<View> body = new ArrayList<>();
        while (scene.content.getChildCount() > 1) {
            View view = scene.content.getChildAt(1);
            scene.content.removeViewAt(1);
            body.add(view);
        }
        return body;
    }

    private static void add(TvScene scene,LinearLayout column, View view) {
        LinearLayout.LayoutParams lp = scene.buttonLayout();
        lp.bottomMargin=scene.dp(6);
        column.addView(view,lp);
    }

    private static Button nav(TvScene scene,String key,String title,Runnable action) {
        Button row = scene.makeButton(key,title,action);
        row.setId(View.generateViewId());
        row.setOnKeyListener((view,code,event) -> {
            if (code!=KeyEvent.KEYCODE_DPAD_RIGHT) return false;
            if (event.getAction()==KeyEvent.ACTION_DOWN && event.getRepeatCount()==0) row.performClick();
            return true;
        });
        return row;
    }

    private static Button appearanceButton(TvScene scene) {
        return nav(scene,"blog-appearance","Оформление",() -> appearance(scene));
    }

    private static void settings(TvScene scene) {
        List<View> body = takeBody(scene);
        LinearLayout left = column(scene.context);
        LinearLayout right = column(scene.context);
        add(scene,right,label(scene,"Показ изображения",25,true));
        rule(scene,right);
        Protocol.Theme current = scene.repo.selected();
        if (current != null && "dynamic".equals(current.kind)) {
            summary(scene,right,"Динамические обои",scene.videoEnabled()?"Видео 4К":"Изображение");
        }
        String resolution = scene.repo.resolution();
        if ("auto".equalsIgnoreCase(resolution)) resolution = "Авто";
        summary(scene,right,"Разрешение",resolution);
        summary(scene,right,"Размещение",scene.repo.fill()?"Заполнить экран":"Вписать целиком");
        for (View item : body) {
            add(scene,left,item);
            if (item instanceof Button) {
                Button row = (Button)item;
                row.setOnKeyListener((view,code,event) -> {
                    if (code!=KeyEvent.KEYCODE_DPAD_RIGHT) return false;
                    if (event.getAction()==KeyEvent.ACTION_DOWN && event.getRepeatCount()==0) row.performClick();
                    return true;
                });
            }
            if (left.getChildCount()==1) add(scene,left,appearanceButton(scene));
        }
        split(scene,left,right,1,1.9f);
        footer(scene,"↑ ↓  Раздел     →  К параметрам     Назад  К меню");
    }

    private static void summary(TvScene scene,LinearLayout column,String title,String value) {
        LinearLayout row = new LinearLayout(scene.context);
        row.setGravity(Gravity.CENTER_VERTICAL);
        row.setMinimumHeight(scene.dp(46));
        row.addView(dim(scene,title,16),new LinearLayout.LayoutParams(0,WRAP,1));
        row.addView(label(scene,value,16,false));
        column.addView(row);
        rule(scene,column);
    }

    private static void settingsDetail(TvScene scene) {
        List<View> body = takeBody(scene);
        LinearLayout left = column(scene.context);
        LinearLayout right = column(scene.context);
        add(scene,right,label(scene,"screen".equals(scene.page)?"Показ изображения":"Оформление",25,true));
        rule(scene,right);
        Button first = null;
        for (View item : body) {
            add(scene,right,item);
            if (first==null && item instanceof Button && item.isEnabled()) first=(Button)item;
        }
        Button firstControl=first;
        Button picture=nav(scene,"blog-picture","Показ изображения",() -> {
            if ("screen".equals(scene.page) && firstControl!=null) firstControl.requestFocus();
            else scene.screenMenu();
        });
        Button theme=nav(scene,"blog-appearance","Оформление",() -> {
            if ("appearance".equals(scene.page) && firstControl!=null) firstControl.requestFocus();
            else appearance(scene);
        });
        boolean screen="screen".equals(scene.page);
        picture.setSelected(screen);
        theme.setSelected(!screen);
        for (Button row : new Button[]{picture,theme,
                nav(scene,"blog-dream","Системная заставка",scene::systemSettings),
                nav(scene,"blog-proxy","Прокси",scene::proxyMenu),
                nav(scene,"blog-cache","Хранилище",scene::cacheMenu),
                nav(scene,"blog-personal","Личный режим",scene::personalMenu),
                nav(scene,"blog-about","О приложении",scene::info)}) add(scene,left,row);
        Button active = screen ? picture : theme;
        for (View item : body) if (item instanceof Button) item.setNextFocusLeftId(active.getId());
        if (firstControl!=null && !scene.focusMemory.containsKey(scene.page)
                && firstControl.getTag() instanceof String) {
            scene.focusMemory.put(scene.page,(String)firstControl.getTag());
        }
        split(scene,left,right,1,1.9f);
        footer(scene,"↑ ↓  Параметр     ←  К разделам     Назад  К настройкам");
    }

    private static void appearance(TvScene scene) {
        scene.beginPage("appearance","Настройки");
        boolean light = palette(scene)==DAY;
        scene.button("blog-tone-night",(light?"":"●  ")+"Вечерняя тема",() -> changeTheme(scene,false));
        scene.button("blog-tone-day",(light?"●  ":"")+"Светлая тема",() -> changeTheme(scene,true));
        scene.focusFirst(light?"blog-tone-day":"blog-tone-night");
    }

    private static void changeTheme(TvScene scene, boolean light) {
        scene.repo.prefs.edit().putBoolean(LIGHT,light).apply();
        appearance(scene);
    }

    private static void music(TvScene scene,Page page) {
        List<View> body = takeBody(scene);
        LinearLayout left = column(scene.context);
        LinearLayout right = column(scene.context);
        left.setBackground(frame(scene,palette(scene).panel,palette(scene).edge,1));
        left.setPadding(scene.dp(16),scene.dp(12),scene.dp(16),scene.dp(11));
        page.radioStatus = dim(scene,"",16);
        left.addView(page.radioStatus);
        page.radioName = label(scene,"",30,true);
        left.addView(page.radioName);
        for (View item : body) if (item==scene.musicDetails) add(scene,left,item);
        if (scene.volumeControl!=null) {
            add(scene,left,scene.volumeControl);
            page.meter = new Meter(scene);
            left.addView(page.meter,new LinearLayout.LayoutParams(MATCH,scene.dp(12)));
            add(scene,left,dim(scene,"От текущей громкости телевизора",14));
        }
        if (scene.musicToggle!=null) add(scene,left,scene.musicToggle);
        if (scene.musicSaverToggle!=null) add(scene,left,scene.musicSaverToggle);

        List<ThemeStations.Station> stations=scene.music.stations.forTheme(scene.musicTheme());
        if (!stations.isEmpty()) {
            right.addView(label(scene,"Станции темы",25,true));
            rule(scene,right);
            for (ThemeStations.Station station : stations) {
                Button button=scene.makeButton("blog-station:"+station.id,station.title,() -> {
                    if (scene.music.playStation(station.id)) {
                        // Rebuild using the existing source-specific controls and return to volume.
                        scene.musicMenu();
                        scene.focusMemory.put("music","volume");
                        scene.focusFirst("volume");
                    }
                });
                button.setContentDescription(station.title);
                button.setId(View.generateViewId());
                add(scene,right,button);
                page.stations.add(button);
            }
            page.radioLegend = dim(scene,"",13);
            add(scene,right,page.radioLegend);
        }
        for (View item : body) {
            if (item==scene.musicDetails || item==scene.musicToggle || item==scene.musicSaverToggle || item==scene.volumeControl) continue;
            if (!stations.isEmpty() && item instanceof Button
                    && "Станции темы".contentEquals(((Button)item).getText())) continue;
            add(scene,right,item);
        }
        split(scene,left,right,1.5f,1);
        footer(scene,"← →  Громкость на шкале     ОК  Выбрать     Назад  К меню");
        refreshMusic(scene);
    }

    static void refreshMusic(TvScene scene) {
        if (!"music".equals(scene.page) || !(scene.content.getTag() instanceof Page)) return;
        Page page=(Page)scene.content.getTag();
        boolean enabled=scene.music.enabled();
        boolean radio=scene.music.radio();
        boolean playing=enabled && radio && "Играет".equals(scene.music.state);
        if (page.radioName!=null) {
            page.radioName.setText(radio?scene.music.stationName:"Музыка темы");
            page.radioStatus.setText(!enabled?"Звук выключен":playing?"▶  Прямой эфир":scene.music.state);
        }
        if (page.meter!=null) {
            page.meter.level=scene.music.level();
            page.meter.enabled=enabled;
            page.meter.invalidate();
        }
        if (page.radioLegend!=null) page.radioLegend.setText(playing?"●  Сейчас звучит":"●  Выбрана станция");
        String selected=scene.music.selectedStation();
        for (Button station : page.stations) {
            boolean chosen=radio && ("blog-station:"+selected).equals(station.getTag());
            CharSequence title=station.getContentDescription();
            station.setText(chosen?marked(scene,title):title);
        }
        if (scene.musicDetails!=null && radio) {
            // The two-line heading supplies the radio station and status.
            scene.musicDetails.setVisibility(View.GONE);
        }
    }

    private static final class Meter extends View {
        private final TvScene scene;
        private final Paint paint=new Paint();
        int level;
        boolean enabled;
        Meter(TvScene scene) {
            super(scene.context);
            this.scene=scene;
            setImportantForAccessibility(IMPORTANT_FOR_ACCESSIBILITY_NO);
        }
        @Override protected void onDraw(Canvas canvas) {
            Palette p=palette(scene);
            int count=20;
            float step=getWidth()/(float)count;
            float gap=Math.min(scene.dp(4),step*.25f);
            int lit=Math.round(level*count/100f);
            for (int i=0;i<count;i++) {
                paint.setColor(i>=lit?p.edge:enabled?p.accent:p.dim);
                canvas.drawRect(i*step,0,(i+1)*step-gap,getHeight(),paint);
            }
        }
    }

    private BlogUi() {}
}
