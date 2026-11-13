package ru.oopssre.imperialschool.viewstv;

import android.content.Context;
import android.content.SharedPreferences;
import android.widget.Button;
import android.widget.FrameLayout;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.ScrollView;
import android.widget.TextView;
import java.util.List;
import java.util.Map;

// Compile-time signatures of the 0.8.8 classes. These classes are never packaged.
class TvScene {
    Context context;
    Repository repo;
    FrameLayout root;
    ScrollView panel;
    LinearLayout content;
    TextView hint, details, musicDetails;
    ThemeGallery gallery;
    SceneMusic music;
    String page;
    Map<String,String> focusMemory;
    Button musicToggle, musicSaverToggle, volumeControl;
    native int dp(int value);
    native TextView text(String text,int size);
    native Button makeButton(String key,String title,Runnable action);
    native Button button(String key,String title,Runnable action);
    native LinearLayout.LayoutParams buttonLayout();
    native boolean videoEnabled();
    native String musicTheme();
    native void beginPage(String page,String title);
    native void focusFirst(String key);
    native void settingsMenu();
    native void screenMenu();
    native void systemSettings();
    native void proxyMenu();
    native void cacheMenu();
    native void personalMenu();
    native void info();
    native void musicMenu();
}
class ThemeGallery {
    ImageView image;
    ScrollView list;
    TextView title, description, state;
}
class Repository {
    SharedPreferences prefs;
    native Protocol.Theme selected();
    native String resolution();
    native boolean fill();
}
class Protocol {
    static class Theme { String kind; }
}
class SceneMusic {
    String state, stationName;
    ThemeStations stations;
    native boolean enabled();
    native boolean radio();
    native int level();
    native String selectedStation();
    native boolean playStation(String id);
}
class ThemeStations {
    static class Station { String id,title; }
    native List<Station> forTheme(String theme);
}
