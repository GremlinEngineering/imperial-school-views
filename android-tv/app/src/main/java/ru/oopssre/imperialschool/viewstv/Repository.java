package ru.oopssre.imperialschool.viewstv;

import android.content.*;
import android.graphics.*;
import java.io.*;
import java.nio.charset.StandardCharsets;
import java.util.*;
import org.json.*;

final class Repository {
    final Context context;final CacheStore cache;final HttpTransport net;final SharedPreferences prefs;volatile int[] screen={1920,1080};
    Repository(Context c){context=c.getApplicationContext();cache=new CacheStore(context.getCacheDir());net=new HttpTransport(cache);prefs=context.getSharedPreferences("tv",0);if(!prefs.contains("video_output"))prefs.edit().putBoolean("video_output",prefs.getBoolean("video_output_test",false)).remove("video_output_test").apply();try{screen=WallpaperSurface.physicalSize(((android.view.WindowManager)context.getSystemService(Context.WINDOW_SERVICE)).getDefaultDisplay());}catch(RuntimeException ignored){}}
    boolean videoPreferred(){return prefs.getBoolean("video_output",false);}
    boolean videoEnabled(){return PlaybackPolicy.useVideo(videoPreferred(),selected().kind);}
    void displaySize(int w,int h){screen=new int[]{w,h};}
    String resolution(){return TvDisplay.resolution(prefs.getString("resolution",TvDisplay.AUTO));}
    void resolution(String mode){prefs.edit().putString("resolution",TvDisplay.resolution(mode)).apply();}
    Protocol.Theme tv(Protocol.Theme t){if(PlaybackPolicy.useVideo(videoPreferred(),t.kind))return Protocol.videoProfile(t);int[] current=screen,size=TvDisplay.targetSize(resolution(),current[0],current[1]);return Protocol.forDisplay(t,size[0],size[1]);}
    List<Protocol.Theme> themes(){try{List<Protocol.Theme> rows=Protocol.catalogue(new JSONObject(new String(CacheStore.read(new File(cache.root,"catalogue.json"),5*1024*1024),StandardCharsets.UTF_8)));List<Protocol.Theme> selected=new ArrayList<>();for(Protocol.Theme t:rows)selected.add(tv(t));return selected;}catch(Exception e){try{return Collections.singletonList(tv(Protocol.defaultTheme()));}catch(Exception impossible){throw new IllegalStateException(impossible);}}}
    Protocol.Theme selected(){String id=prefs.getString("theme",Protocol.DEFAULT_ID);for(Protocol.Theme t:themes())if(t.id.equals(id))return t;try{JSONObject saved=new JSONObject(prefs.getString("descriptor",Protocol.defaultTheme().descriptor.toString()));if(saved.optString("type").equals("dynamic"))return tv(Protocol.theme(saved));if(saved.optString("type").equals("weather"))return Sources.theme(saved,new JSONObject());return new Protocol.Theme(saved.getString("id"),saved.getString("title"),"plain","",prefs.getInt("plain_width",3840),prefs.getInt("plain_height",2160),saved);}catch(Exception e){try{return tv(Protocol.defaultTheme());}catch(Exception impossible){throw new IllegalStateException(impossible);}}}
    void choose(Protocol.Theme t){prefs.edit().putString("theme",t.id).putString("descriptor",t.descriptor.toString()).putInt("plain_width",t.width).putInt("plain_height",t.height).apply();}
    boolean fill(){return prefs.getBoolean("fill",false);}void fill(boolean b){prefs.edit().putBoolean("fill",b).apply();}
    void refreshCatalogue(String pinned)throws Exception {File file=new File(cache.root,"catalogue.json");if(file.isFile()&&System.currentTimeMillis()-file.lastModified()<900000)return;JSONObject json=net.json("manifest-v3.json",false,pinned);Protocol.catalogue(json);byte[] bytes=json.toString().getBytes(StandardCharsets.UTF_8);cache.reserve(bytes.length,pinned);CacheStore.atomic(file,bytes);}
    String weatherSource(){return prefs.getString("weather_source","real");}
    String simpleMode(){return prefs.getString("simple_mode_"+selected().id,"auto");}
    Protocol.Frame cached(Protocol.Theme theme){Protocol.Frame f=cache.cached(theme);if(f==null&&Protocol.tvScene(theme)&&resolution().equals(TvDisplay.AUTO))f=cache.cached(Protocol.alternateTV(theme));return f!=null&&(!theme.kind.equals("weather")||f.sourceId.equals(weatherSource()))?f:null;}
    Protocol.Frame finish(Protocol.Frame frame,String pinned)throws Exception {File file=net.image(frame,pinned);BitmapFactory.Options o=new BitmapFactory.Options();o.inJustDecodeBounds=true;BitmapFactory.decodeFile(file.getPath(),o);Protocol.require(o.outWidth==frame.width&&o.outHeight==frame.height,"Размер изображения не совпал с описанием");cache.save(frame);return frame;}
    Protocol.Frame refresh(Protocol.Theme theme,String pinned)throws Exception {
        if(!theme.kind.equals("dynamic")&&!theme.kind.equals("weather")){refreshCatalogue(pinned);JSONObject catalogue=new JSONObject(new String(CacheStore.read(new File(cache.root,"catalogue.json"),5*1024*1024),StandardCharsets.UTF_8));return finish(Sources.ordinary(catalogue,theme,simpleMode(),System.currentTimeMillis()),pinned);}
        if(theme.kind.equals("weather")){JSONObject source=Sources.source(theme,weatherSource());Exception error=null;for(int attempt=0;attempt<2;attempt++){try{JSONObject current=net.json(source.getString("current_url"),attempt>0,pinned),forecast=net.json(source.getJSONObject("forecasts").getString(theme.device),attempt>0,pinned);return finish(Sources.weather(current,forecast,theme,weatherSource(),System.currentTimeMillis()),pinned);}catch(Exception e){error=e;}}throw error;}

        Exception last=null;
        for(int attempt=0;attempt<2;attempt++){try{
            JSONObject top=net.json(theme.current,attempt>0,pinned);Protocol.Theme published=Protocol.publishedTheme(top,theme,resolution().equals(TvDisplay.AUTO));String path=Protocol.statePath(top,published);JSONObject state=net.json(path,attempt>0,pinned);Protocol.Frame frame=Protocol.frame(state,top,published,System.currentTimeMillis());
            return finish(frame,pinned);
        }catch(Exception e){last=e;if(e instanceof HttpTransport.HttpFailure)throw e;}}
        throw last;
    }
    Bitmap decode(Protocol.Frame frame,int targetWidth,int targetHeight)throws IOException {File file=cache.image(frame);if(!cache.valid(frame))throw new IOException("Кеш кадра повреждён");BitmapFactory.Options o=new BitmapFactory.Options();o.inPreferredConfig=Bitmap.Config.ARGB_8888;int sample=1;while((long)(frame.width/sample)*(frame.height/sample)>12000000)sample*=2;while(frame.width/(sample*2)>=targetWidth&&frame.height/(sample*2)>=targetHeight)sample*=2;
        for(int attempt=0;attempt<4;attempt++){o.inSampleSize=sample;try{Bitmap b=BitmapFactory.decodeFile(file.getPath(),o);if(b==null)throw new IOException("Изображение не открывается");return b;}catch(OutOfMemoryError e){if(!resolution().equals(TvDisplay.AUTO))throw new IOException("Не хватило памяти для выбранного разрешения · "+TvDisplay.label(resolution()),e);sample*=2;}}
        throw new IOException("Телевизору не хватило памяти на кадр");
    }
}
