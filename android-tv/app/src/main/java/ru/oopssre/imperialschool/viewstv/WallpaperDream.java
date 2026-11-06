package ru.oopssre.imperialschool.viewstv;

import android.content.*;
import android.service.dreams.DreamService;
import android.view.*;

public final class WallpaperDream extends DreamService implements TvScene.Host {
    TvScene scene;
    @Override public void onAttachedToWindow(){super.onAttachedToWindow();setFullscreen(true);setInteractive(true);setScreenBright(true);scene=new TvScene(this);setContentView(scene.root);}
    @Override public void onDreamingStarted(){super.onDreamingStarted();if(scene!=null)scene.start();}
    @Override public void onDreamingStopped(){if(scene!=null)scene.stop();super.onDreamingStopped();}
    @Override public void onDetachedFromWindow(){if(scene!=null){scene.destroy();scene=null;}super.onDetachedFromWindow();}
    @Override public boolean dispatchKeyEvent(KeyEvent e){if(scene!=null&&scene.handle(e))return true;if(scene!=null&&scene.panel.getVisibility()!=View.VISIBLE&&e.getAction()==KeyEvent.ACTION_DOWN&&(e.getKeyCode()==KeyEvent.KEYCODE_DPAD_UP||e.getKeyCode()==KeyEvent.KEYCODE_DPAD_DOWN||e.getKeyCode()==KeyEvent.KEYCODE_DPAD_LEFT||e.getKeyCode()==KeyEvent.KEYCODE_DPAD_RIGHT)){finish();return true;}return super.dispatchKeyEvent(e);}
    public android.content.Context context(){return this;}public Window window(){return getWindow();}public void leave(){finish();}public void launch(Intent i){startActivity(i);}
}
