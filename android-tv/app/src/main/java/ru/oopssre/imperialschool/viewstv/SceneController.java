package ru.oopssre.imperialschool.viewstv;

import android.graphics.Bitmap;
import android.os.*;
import java.util.concurrent.*;

final class SceneController {
    interface Listener{void status(String message);void frame(Protocol.Frame frame);void catalogue();}
    final Repository repo;final WallpaperSurface surface;final Listener listener;final Handler main=new Handler(Looper.getMainLooper());final ExecutorService worker=Executors.newSingleThreadExecutor();
    final ExecutorService cacheWorker=Executors.newSingleThreadExecutor();
    private Future<?> job,cacheJob;private long generation;private volatile long networkGeneration=-1;private boolean active;private volatile String displayed="";private volatile int[] renderedTarget={0,0};private int failures;volatile Protocol.Frame frame;
    private final Runnable poll=()->refresh(false);
    SceneController(Repository r,WallpaperSurface s,Listener l){repo=r;surface=s;listener=l;}
    void start(){if(active)return;active=true;refresh(true);}
    void stop(){active=false;generation++;main.removeCallbacks(poll);if(job!=null)job.cancel(true);if(cacheJob!=null)cacheJob.cancel(true);}
    void reset(){stop();frame=null;displayed="";renderedTarget=new int[]{0,0};}
    void destroy(){stop();worker.shutdownNow();cacheWorker.shutdownNow();surface.clear();}
    void refresh(boolean showCache){if(!active)return;generation++;long token=generation;main.removeCallbacks(poll);if(job!=null)job.cancel(true);if(cacheJob!=null)cacheJob.cancel(true);
        if(showCache)cacheJob=cacheWorker.submit(()->{try{Protocol.Frame cached=repo.cached(repo.selected());if(cached!=null)publish(cached,token,true);}catch(Exception ignored){}});
        job=worker.submit(()->{
        Protocol.Theme theme=repo.selected();long delay=60000;
        try{
            Protocol.Frame next=repo.refresh(theme,displayed);publish(next,token,false);failures=0;delay=next.nextDelay(System.currentTimeMillis());
        }catch(Exception e){if(Thread.currentThread().isInterrupted())return;failures++;delay=Math.min(300000,60000L*(1L<<Math.min(3,failures-1)));String message=e.getMessage();main.post(()->{if(active&&token==generation)listener.status((frame==null?"Нет кадра: ":"Сохранён последний кадр. ")+(message==null?"Нет связи с сервером":message));});}
        try{if(!Thread.currentThread().isInterrupted()){repo.refreshCatalogue(displayed);main.post(()->{if(active&&token==generation)listener.catalogue();});}}catch(Exception ignored){}
        long wait=delay;main.post(()->{if(active&&token==generation)main.postDelayed(poll,wait);});
    });}
    private void publish(Protocol.Frame candidate,long token,boolean cached)throws Exception {
        if(Thread.currentThread().isInterrupted())return;
        int width=surface.bufferWidth,height=surface.bufferHeight;int[] previousTarget=renderedTarget;
        if(candidate.sha.equals(displayed)&&previousTarget[0]==width&&previousTarget[1]==height){main.post(()->{if(active&&token==generation&&(!cached||networkGeneration!=token)){if(!cached)networkGeneration=token;frame=candidate;listener.frame(candidate);}});return;}
        Bitmap bitmap=repo.decode(candidate,width,height);
        main.post(()->{if(!active||token!=generation||cached&&networkGeneration==token){bitmap.recycle();return;}if(!cached)networkGeneration=token;surface.show(bitmap);frame=candidate;renderedTarget=new int[]{width,height};displayed=candidate.sha;listener.frame(candidate);});
    }
}
