package ru.oopssre.imperialschool.viewstv;

import android.os.*;
import java.io.File;
import java.util.*;
import java.util.concurrent.*;

/** Downloads next media without stopping the currently playing cache file. */
final class VideoController {
    interface Listener {void changed();void catalogue();}
    final Repository repo;final VideoSurface video;final Listener listener;final VideoLoader loader;
    final Handler main=new Handler(Looper.getMainLooper());final ExecutorService worker=Executors.newSingleThreadExecutor();
    private Future<?> job;private volatile long generation;private long observedFailures;private String stored="";private int failures;
    private volatile boolean active;volatile boolean loading;volatile VideoInfo frame;
    private final Set<VideoSurface.Clip> prepared=new HashSet<>();
    volatile String status="Ожидание опубликованного видео…";volatile long nextCheckAt;
    final Runnable poll=()->refresh(false);
    final Runnable retry=()->refresh(true);
    VideoController(Repository r,VideoSurface v,Listener l){repo=r;video=v;listener=l;loader=new VideoLoader(repo.net,repo.cache);}
    void start(){if(active)return;active=true;refresh(true);}
    void stop(){active=false;generation++;loading=false;nextCheckAt=0;main.removeCallbacks(poll);main.removeCallbacks(retry);if(job!=null)job.cancel(true);synchronized(prepared){for(VideoSurface.Clip clip:prepared)clip.close();prepared.clear();}}
    void reset(){stop();frame=null;stored="";observedFailures=video.failures;status="Ожидание опубликованного видео…";}
    void destroy(){stop();worker.shutdownNow();main.removeCallbacksAndMessages(null);}
    private boolean current(long token){return active&&token==generation&&!Thread.currentThread().isInterrupted();}
    private void offer(VideoInfo info,File file,long token)throws Exception {
        if(!current(token))return;
        if(info.sameMedia(video.displayed)&&video.running&&repo.cache.valid(info)){
            main.post(()->{if(current(token))video.updateInfo(info);});return;
        }
        VideoSurface.Clip clip=VideoSurface.prepare(info,file,repo.cache);
        synchronized(prepared){if(!current(token)){clip.close();return;}prepared.add(clip);}
        main.post(()->{synchronized(prepared){prepared.remove(clip);}if(current(token))video.offer(clip);else clip.close();});
    }
    void refresh(boolean showCache){if(!active)return;long token=++generation;main.removeCallbacks(poll);main.removeCallbacks(retry);if(job!=null)job.cancel(true);loading=true;
        job=worker.submit(()->{
            Protocol.Theme selected=repo.selected();long delay=VideoPolicy.nextDelay();String result="";
            try{
                if(showCache){VideoInfo cached=repo.cache.cachedVideo(selected);if(cached!=null)try{offer(cached,repo.cache.video(cached.sha),token);}catch(Exception ignored){if(Thread.currentThread().isInterrupted())return;}}
                try(VideoLoader.Loaded next=loader.load(selected)){offer(next.info,next.file,token);}
                failures=0;result="Публикация проверена";
            }catch(Protocol.NotReady pending){failures=0;result=pending.getMessage();}
            catch(Exception e){if(Thread.currentThread().isInterrupted())return;failures++;delay=VideoPolicy.retryDelay(failures);result=(frame==null?"Видео не получено: ":"Продолжается показ из кеша. ")+(e.getMessage()==null?"Нет связи":e.getMessage());}
            try{if(current(token)){repo.refreshCatalogue("");main.post(()->{if(current(token))listener.catalogue();});}}catch(Exception ignored){}
            final long wait=delay;final String message=result;
            main.post(()->{if(current(token)){loading=false;status=message;nextCheckAt=System.currentTimeMillis()+wait;main.postDelayed(poll,wait);listener.changed();}});
        });
    }
    void surfaceChanged(){if(!active)return;
        VideoInfo shown=video.displayed;
        if(shown!=null&&shown.frame.theme.equals(repo.selected().id)){
            frame=shown;String key=shown.frame.stateId+"/"+shown.sha;
            if(!key.equals(stored)){stored=key;worker.submit(()->{try{repo.cache.saveVideo(shown);}catch(Exception ignored){}});}
        }
        if(video.failures!=observedFailures){observedFailures=video.failures;main.removeCallbacks(poll);main.removeCallbacks(retry);long wait=VideoPolicy.retryDelay(++failures);nextCheckAt=System.currentTimeMillis()+wait;main.postDelayed(retry,wait);}
        else if(!loading&&!video.running&&video.wanted()&&video.getHolder().getSurface().isValid()&&video.pending.get()==null&&frame!=null)refresh(true);
    }
}
