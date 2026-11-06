package ru.oopssre.imperialschool.viewstv;

import java.io.*;
import java.util.concurrent.atomic.AtomicBoolean;
import org.json.*;

/** The same metadata and checked-download transaction is used by all dynamic themes. */
public final class VideoLoader {
    final HttpTransport net;final CacheStore cache;
    public VideoLoader(HttpTransport n,CacheStore c){net=n;cache=c;}
    public final class Loaded implements AutoCloseable {
        public final VideoInfo info;public final File file;private final AtomicBoolean closed=new AtomicBoolean();
        Loaded(VideoInfo v,File f){info=v;file=f;}
        public void close(){if(closed.compareAndSet(false,true))cache.unpinVideo(info.sha);}
    }
    public VideoInfo describe(Protocol.Theme theme,boolean force)throws Exception {
        Protocol.require(theme.kind.equals("dynamic"),"Видео 4К доступно для динамических тем");
        JSONObject top=net.json(theme.current,force,"");Protocol.Theme profile=Protocol.publishedVideo(top,theme);
        JSONObject state=net.json(Protocol.statePath(top,profile),force,"");
        return VideoInfo.parse(state,Protocol.frame(state,top,profile,System.currentTimeMillis()));
    }
    public Loaded load(Protocol.Theme theme)throws Exception {
        Exception last=null;
        for(int attempt=0;attempt<2;attempt++){
            try{
                VideoInfo info=describe(theme,attempt>0);cache.pinVideo(info.sha);boolean success=false;
                try{File file=net.video(info,"");Loaded loaded=new Loaded(info,file);success=true;return loaded;}
                finally{if(!success)cache.unpinVideo(info.sha);}
            }catch(Protocol.NotReady pending){throw pending;}
            catch(Exception e){if(Thread.currentThread().isInterrupted())throw e;last=e;}
        }
        throw last;
    }
}
