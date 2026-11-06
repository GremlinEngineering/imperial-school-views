package ru.oopssre.imperialschool.viewstv;

import android.content.Context;
import android.graphics.*;
import android.view.*;

/** A separately sized Surface keeps 4K image buffers independent of a 1080p TV UI. */
final class WallpaperSurface extends SurfaceView implements SurfaceHolder.Callback {
    Bitmap image;boolean fill;int bufferWidth=3840,bufferHeight=2160,actualWidth,actualHeight;private final Paint paint=new Paint(Paint.ANTI_ALIAS_FLAG|Paint.FILTER_BITMAP_FLAG);
    WallpaperSurface(Context c){super(c);getHolder().addCallback(this);setFocusable(false);setContentDescription("Динамические обои");}
    void size(int w,int h){bufferWidth=w;bufferHeight=h;getHolder().setFixedSize(w,h);}
    void show(Bitmap next){Bitmap old=image;image=next;drawFrame();if(old!=null&&old!=next&&!old.isRecycled())old.recycle();}
    void drawFrame(){if(!getHolder().getSurface().isValid())return;Canvas canvas=null;try{canvas=getHolder().lockCanvas();if(canvas==null)return;canvas.drawColor(Color.BLACK);Bitmap b=image;if(b!=null&&!b.isRecycled()){float scale=fill?Math.max((float)canvas.getWidth()/b.getWidth(),(float)canvas.getHeight()/b.getHeight()):Math.min((float)canvas.getWidth()/b.getWidth(),(float)canvas.getHeight()/b.getHeight());float w=b.getWidth()*scale,h=b.getHeight()*scale;canvas.drawBitmap(b,null,new RectF((canvas.getWidth()-w)/2,(canvas.getHeight()-h)/2,(canvas.getWidth()+w)/2,(canvas.getHeight()+h)/2),paint);}}catch(RuntimeException ignored){}finally{if(canvas!=null)try{getHolder().unlockCanvasAndPost(canvas);}catch(RuntimeException ignored){}}}
    public void surfaceCreated(SurfaceHolder h){drawFrame();}public void surfaceChanged(SurfaceHolder h,int f,int w,int z){actualWidth=w;actualHeight=z;drawFrame();}public void surfaceDestroyed(SurfaceHolder h){actualWidth=0;actualHeight=0;}
    void clear(){Bitmap old=image;image=null;if(old!=null&&!old.isRecycled())old.recycle();}
    static TvDisplay.Mode mode(Display.Mode m){return new TvDisplay.Mode(m.getModeId(),m.getPhysicalWidth(),m.getPhysicalHeight(),m.getRefreshRate());}
    static TvDisplay.Mode bestMode(Display display){Display.Mode[] modes=display.getSupportedModes();TvDisplay.Mode[] choices=new TvDisplay.Mode[modes.length];for(int i=0;i<modes.length;i++)choices[i]=mode(modes[i]);return TvDisplay.choose(mode(display.getMode()),choices);}
    static int[] physicalSize(Display display){try{TvDisplay.Mode m=bestMode(display);return new int[]{Math.min(3840,m.width),Math.min(2160,m.height)};}catch(RuntimeException e){return new int[]{1920,1080};}}
    static int[] configure(Window window,Display display){return configure(window,display,TvDisplay.AUTO);}
    static int[] configure(Window window,Display display,String resolution){
        int[] detected={1920,1080};
        try{
            if(display==null)display=window.getWindowManager().getDefaultDisplay();
            detected=physicalSize(display);
            Display.Mode[] modes=display.getSupportedModes();TvDisplay.Mode[] choices=new TvDisplay.Mode[modes.length];
            for(int i=0;i<modes.length;i++)choices[i]=mode(modes[i]);
            TvDisplay.Mode best=TvDisplay.choose(mode(display.getMode()),choices,resolution);
            WindowManager.LayoutParams a=window.getAttributes();a.preferredDisplayModeId=best.id;window.setAttributes(a);
        }catch(RuntimeException ignored){}
        // Explicit settings override the wallpaper buffer even when firmware reports only a 1080p UI.
        return TvDisplay.targetSize(resolution,detected[0],detected[1]);
    }
}
