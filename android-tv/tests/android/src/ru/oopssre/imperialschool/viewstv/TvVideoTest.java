package ru.oopssre.imperialschool.viewstv;
import android.app.*;import android.content.*;import android.media.MediaPlayer;import android.os.*;import java.lang.reflect.*;import java.io.*;import java.security.*;import org.json.*;

/** Device-only: production prepared-cache API, with two separate real HEVC fixture files. */
public final class TvVideoTest extends Instrumentation {
    Activity activity;int checks;ClassLoader loader;String pkg;Object scene,video,cache;
    void ok(boolean v,String label){checks++;if(!v)throw new AssertionError(label);}
    Object field(Object o,String name)throws Exception{Field f=o.getClass().getDeclaredField(name);f.setAccessible(true);return f.get(o);}
    Object call(Object o,String name,Object... args)throws Exception{for(Method m:o.getClass().getDeclaredMethods())if(m.getName().equals(name)&&m.getParameterTypes().length==args.length){m.setAccessible(true);return m.invoke(o,args);}throw new NoSuchMethodException(name);}
    Object stat(String cls,String name,Object... args)throws Exception{Class<?> type=Class.forName(pkg+"."+cls,true,loader);for(Method m:type.getDeclaredMethods())if(m.getName().equals(name)&&m.getParameterTypes().length==args.length){m.setAccessible(true);return m.invoke(null,args);}throw new NoSuchMethodException(name);}
    void mainCall(Object o,String name,Object... args){runOnMainSync(()->{try{call(o,name,args);}catch(Exception e){throw new RuntimeException(e);}});waitForIdleSync();}
    String hash(byte[] b)throws Exception{byte[] d=MessageDigest.getInstance("SHA-256").digest(b);StringBuilder s=new StringBuilder();for(byte v:d)s.append(String.format(java.util.Locale.ROOT,"%02x",v&255));return s.toString();}
    Object prepare(String tag)throws Exception{
        ByteArrayOutputStream data=new ByteArrayOutputStream();try(InputStream in=getContext().getAssets().open("video/"+tag+".mp4")){byte[] b=new byte[32768];for(int n;(n=in.read(b))!=-1;)data.write(b,0,n);}byte[] bytes=data.toByteArray();String sha=hash(bytes),image=hash(new byte[]{1}),state=hash(new byte[]{2});File file=(File)call(cache,"video",sha);try(FileOutputStream out=new FileOutputStream(file)){out.write(bytes);}
        String prefix="dynamic/orbital-port/devices/desktop_3840x2160/";long now=System.currentTimeMillis();
        JSONObject frame=new JSONObject().put("theme","orbital-port").put("device","desktop_3840x2160").put("title","Fixture "+tag).put("url",prefix+"current.jpg").put("sha",image).put("state",state).put("width",3840).put("height",2160).put("bytes",1).put("at",now).put("until",now+3600000);
        JSONObject media=new JSONObject().put("url",prefix+"video/"+sha+".mp4").put("format","mp4").put("codec","hevc").put("profile","main").put("pixel_format","yuv420p").put("width",3840).put("height",2160).put("fps",24).put("duration_ms",4000).put("audio",false).put("bytes",bytes.length).put("sha256",sha).put("source_image_sha256",image);
        Object info=stat("VideoInfo","saved",new JSONObject().put("frame",frame).put("video",media));return stat("VideoSurface","prepare",info,file,cache);
    }
    void waitSwitches(long count)throws Exception{long end=SystemClock.uptimeMillis()+10000;while(SystemClock.uptimeMillis()<end&&(Long)field(video,"switches")<count){Thread.sleep(100);waitForIdleSync();}ok((Long)field(video,"switches")>=count,"prepared file reached decoder output "+count);}
    public void onCreate(Bundle args){super.onCreate(args);start();}
    public void onStart(){Bundle result=new Bundle();try{
        Context c=getTargetContext();pkg=c.getPackageName();loader=c.getClassLoader();android.content.pm.PackageInfo installed=c.getPackageManager().getPackageInfo(pkg,0);ok("0.6.0".equals(installed.versionName)&&installed.versionCode==11,"installed production-video release");
        c.getSharedPreferences("tv",0).edit().putString("theme","orbital-port").putBoolean("video_output",true).putBoolean("music_app_enabled",true).putBoolean("music_screensaver_enabled",false).commit();
        activity=startActivitySync(new Intent(Intent.ACTION_MAIN).setClassName(pkg,pkg+".MainActivity").addFlags(Intent.FLAG_ACTIVITY_NEW_TASK));waitForIdleSync();scene=field(activity,"scene");video=field(scene,"video");cache=field(field(scene,"repo"),"cache");
        mainCall(field(scene,"videoController"),"stop");mainCall(video,"reset");mainCall(video,"start");mainCall(video,"offer",prepare("A"));
        long end=SystemClock.uptimeMillis()+25000;while(SystemClock.uptimeMillis()<end&&(!(Boolean)field(video,"playing")||field(field(scene,"music"),"player")==null)){Thread.sleep(100);waitForIdleSync();}
        ok((Boolean)field(video,"playing"),"cached A plays: "+field(video,"state"));Object music=field(scene,"music");MediaPlayer audio=(MediaPlayer)field(music,"player");ok(audio!=null&&audio.isPlaying(),"separate music plays");int at=audio.getCurrentPosition(),duration=audio.getDuration();
        mainCall(video,"offer",prepare("B"));waitSwitches(1);ok(((String)field(field(field(video,"displayed"),"frame"),"title")).equals("Fixture B"),"B replaces A");mainCall(video,"offer",prepare("A"));waitSwitches(2);
        ok((Integer)field(video,"decoderStarts")==1,"same decoder retained across compatible files");ok((Integer)field(video,"decodedWidth")==3840&&(Integer)field(video,"decodedHeight")==2160,"decoder stays 4K");ok((Integer)field(video,"actualWidth")==3840&&(Integer)field(video,"actualHeight")==2160,"Surface stays 4K");
        if(at+15000<duration)ok(field(music,"player")==audio&&audio.getCurrentPosition()>at,"video changes do not replace or rewind music");
        mainCall(video,"stop");ok(!(Boolean)field(video,"playing"),"stop releases playback");runOnMainSync(()->activity.finish());waitForIdleSync();
        result.putString("stream","PASS "+checks+" physical hardware checks; inspect transitions visually too");finish(Activity.RESULT_OK,result);
    }catch(Throwable e){if(activity!=null)runOnMainSync(()->activity.finish());result.putString("stream",android.util.Log.getStackTraceString(e));finish(Activity.RESULT_CANCELED,result);}}
}
