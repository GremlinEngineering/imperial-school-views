package ru.oopssre.imperialschool.viewstv;

import android.app.Activity;
import android.content.*;
import android.os.*;
import android.view.*;

public final class MainActivity extends Activity implements TvScene.Host {
    TvScene scene;
    @Override public void onCreate(Bundle state){super.onCreate(state);getWindow().addFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON|WindowManager.LayoutParams.FLAG_FULLSCREEN);getWindow().getDecorView().setSystemUiVisibility(View.SYSTEM_UI_FLAG_IMMERSIVE_STICKY|View.SYSTEM_UI_FLAG_FULLSCREEN|View.SYSTEM_UI_FLAG_HIDE_NAVIGATION|View.SYSTEM_UI_FLAG_LAYOUT_FULLSCREEN|View.SYSTEM_UI_FLAG_LAYOUT_HIDE_NAVIGATION|View.SYSTEM_UI_FLAG_LAYOUT_STABLE);scene=new TvScene(this);setContentView(scene.root);}
    @Override protected void onStart(){super.onStart();scene.start();}
    @Override protected void onResume(){super.onResume();if(scene!=null&&scene.active){scene.resumePlayback();}}
    @Override protected void onPause(){if(scene!=null){scene.pausePlayback();}super.onPause();}
    @Override protected void onStop(){scene.stop();super.onStop();}
    @Override protected void onDestroy(){scene.destroy();super.onDestroy();}
    @Override public boolean dispatchKeyEvent(KeyEvent e){return scene!=null&&scene.handle(e)||super.dispatchKeyEvent(e);}
    @Override public void onBackPressed(){if(scene!=null)scene.back();else super.onBackPressed();}
    public android.content.Context context(){return this;}public Window window(){return getWindow();}public void leave(){finish();}public void launch(Intent i){startActivity(i);}
}
