package ru.oopssre.imperialschool.viewstv;

import android.app.*;
import android.content.*;
import android.graphics.Bitmap;
import android.os.*;
import android.view.*;
import java.io.*;
import java.lang.reflect.*;
import org.json.*;

/** Focused upgrade and live publication checks for the two TV 4K scenes. */
public class TvAutoTest extends Instrumentation {
    int checks;String validationCA;String expectedDevice="desktop_3840x2160";
    void ok(boolean value,String label){checks++;if(!value)throw new AssertionError(label);}
    Object field(Object value,String name)throws Exception {Field f=value.getClass().getDeclaredField(name);f.setAccessible(true);return f.get(value);}
    Object call(Object value,String name,Object... args)throws Exception {
        for(Method m:value.getClass().getDeclaredMethods())if(m.getName().equals(name)&&m.getParameterTypes().length==args.length){m.setAccessible(true);try{return m.invoke(value,args);}catch(InvocationTargetException e){throw (Exception)e.getCause();}}
        throw new NoSuchMethodException(name);
    }
    void profile(Object theme,String id)throws Exception {
        ok(id.equals(field(theme,"id")),id+" selected");
        ok(expectedDevice.equals(field(theme,"device")),id+" exact selected device");
        ok((Integer)field(theme,"width")== (expectedDevice.equals("desktop_3840x2160")?3840:1920)&&(Integer)field(theme,"height")== (expectedDevice.equals("desktop_3840x2160")?2160:1080),id+" exact selected geometry");
    }
    JSONObject descriptor(String id,String device,int height)throws Exception {
        return new JSONObject().put("id",id).put("type","dynamic").put("title",id)
            .put("current_url","dynamic/"+id+"/current.json")
            .put("formats",new JSONObject().put(device,new JSONObject().put("width",3840).put("height",height)));
    }
    JSONObject asset(String name)throws Exception {try(InputStream in=getContext().getAssets().open(name)){ByteArrayOutputStream out=new ByteArrayOutputStream();byte[] bytes=new byte[32768];for(int n;(n=in.read(bytes))!=-1;)out.write(bytes,0,n);return new JSONObject(out.toString("UTF-8"));}}
    void step(String text){Bundle b=new Bundle();b.putString("stream",text);sendStatus(0,b);}
    public void onCreate(Bundle b){super.onCreate(b);validationCA=b==null?null:b.getString("validation_ca_asset");start();}
    public void onStart(){Bundle result=new Bundle();try{
        // Optional CA for the managed validation proxy, confined to this test process.
        // Production APK trust settings and hostname verification are unchanged.
        if(validationCA!=null){
            java.security.KeyStore store=java.security.KeyStore.getInstance(java.security.KeyStore.getDefaultType());store.load(null,null);
            try(InputStream in=getContext().getAssets().open(validationCA)){
                int i=0;for(java.security.cert.Certificate cert:java.security.cert.CertificateFactory.getInstance("X.509").generateCertificates(in))store.setCertificateEntry("validation-"+(i++),cert);
            }
            javax.net.ssl.TrustManagerFactory tm=javax.net.ssl.TrustManagerFactory.getInstance(javax.net.ssl.TrustManagerFactory.getDefaultAlgorithm());tm.init(store);
            javax.net.ssl.SSLContext ssl=javax.net.ssl.SSLContext.getInstance("TLS");ssl.init(null,tm.getTrustManagers(),null);
            javax.net.ssl.HttpsURLConnection.setDefaultSSLSocketFactory(ssl.getSocketFactory());
        }
        Context c=getTargetContext();SharedPreferences prefs=c.getSharedPreferences("tv",0);
        android.content.pm.PackageInfo installed=c.getPackageManager().getPackageInfo(c.getPackageName(),0);
        ok("0.6.0".equals(installed.versionName)&&installed.versionCode==11,"installed release 0.6.0 build11");
        prefs.edit().clear().putBoolean("music_app_enabled",false).putBoolean("music_screensaver_enabled",true).putInt("music_volume",35).commit();
        File root=new File(c.getCacheDir(),"imperial-tv");root.mkdirs();File catalogue=new File(root,"catalogue.json");
        try(InputStream in=getContext().getAssets().open("catalogue.json");FileOutputStream out=new FileOutputStream(catalogue)){byte[] b=new byte[32768];for(int n;(n=in.read(b))!=-1;)out.write(b,0,n);}
        Class<?> repository=Class.forName(c.getPackageName()+".Repository",true,c.getClassLoader());Constructor<?> constructor=repository.getDeclaredConstructor(Context.class);constructor.setAccessible(true);Object repo=constructor.newInstance(c);
        Object auto=call(repo,"selected");ok("desktop_1920x1080".equals(field(auto,"device")),"actual 1080p emulator display selects Full HD without manual settings");
        call(repo,"displaySize",3840,2160);
        prefs.edit().putString("theme","orbital-port").putString("descriptor",descriptor("orbital-port","desktop_16x9",2160).toString()).commit();
        Object orbital=call(repo,"selected");profile(orbital,"orbital-port");
        prefs.edit().putString("theme","sunken-teahouse").putString("descriptor",descriptor("sunken-teahouse","desktop_3840x2400",2400).toString()).commit();
        Object tea=call(repo,"selected");profile(tea,"sunken-teahouse");
        File backup=new File(root,"catalogue-test-backup.json");ok(catalogue.renameTo(backup),"hide catalogue to test saved descriptor");
        profile(call(repo,"selected"),"sunken-teahouse");ok(backup.renameTo(catalogue),"restore older catalogue");
        ok(!prefs.getBoolean("music_app_enabled",true)&&prefs.getBoolean("music_screensaver_enabled",false)&&prefs.getInt("music_volume",0)==35,"sound settings survive profile migration");
        call(repo,"displaySize",1920,1080);expectedDevice="desktop_1920x1080";
        prefs.edit().putString("theme","orbital-port").commit();orbital=call(repo,"selected");profile(orbital,"orbital-port");
        prefs.edit().putString("theme","sunken-teahouse").commit();tea=call(repo,"selected");profile(tea,"sunken-teahouse");
        step("Physical Full HD detection and both display profiles passed; fetching live orbital frame");
        Object frame=call(repo,"refresh",orbital,"");
        ok("desktop_3840x2160".equals(field(frame,"device"))||"desktop_1920x1080".equals(field(frame,"device")),"live orbital frame uses one published TV device");
        ok((Integer)field(frame,"width")*9==(Integer)field(frame,"height")*16,"live orbital image preserves 16:9");
        ok(((String)field(frame,"url")).contains("/"+field(frame,"device")+"/current.jpg"),"live orbital JPEG follows exact TV endpoint");
        Bitmap bitmap=(Bitmap)call(repo,"decode",frame,1920,1080);ok(bitmap.getWidth()==1920&&bitmap.getHeight()==1080,"Android decoder displays full 16:9 frame on 1080 TV buffer");bitmap.recycle();
        Object cached=call(repo,"cached",orbital);ok(cached!=null&&field(frame,"sha").equals(field(cached,"sha")),"orbital 4K frame is reusable from cache");
        step("Live orbital frame downloaded, verified and decoded; checking tea TV readiness");
        boolean waiting=false;
        try{
            Object teaFrame=call(repo,"refresh",tea,"");
            ok("desktop_3840x2160".equals(field(teaFrame,"device"))||"desktop_1920x1080".equals(field(teaFrame,"device")),"tea frame uses a published TV profile");
            ok((Integer)field(teaFrame,"width")*9==(Integer)field(teaFrame,"height")*16,"tea frame preserves 16:9");
            Bitmap teaBitmap=(Bitmap)call(repo,"decode",teaFrame,1920,1080);ok(teaBitmap.getWidth()==1920&&teaBitmap.getHeight()==1080,"Android decodes the published TV tea scene");teaBitmap.recycle();
        }catch(Exception e){waiting=e.getMessage()!=null&&e.getMessage().contains("ещё не опубликован");ok(waiting,"unpublished TV tea waits without substituting a different profile");}
        Object cachedTea=call(repo,"cached",tea);ok(cachedTea==null||"desktop_3840x2160".equals(field(cachedTea,"device"))||"desktop_1920x1080".equals(field(cachedTea,"device")),"tea cache cannot return a different device");
        JSONObject fhdState=asset("fhd-state.json"),fhdTop=asset("fhd-top.json");
        Class<?> protocol=Class.forName(c.getPackageName()+".Protocol",true,c.getClassLoader());Method parse=protocol.getMethod("frame",JSONObject.class,JSONObject.class,orbital.getClass(),long.class);
        Object fhd=parse.invoke(null,fhdState,fhdTop,orbital,System.currentTimeMillis());Object cache=field(repo,"cache");File target=(File)call(cache,"image",field(fhd,"sha"));
        try(InputStream in=getContext().getAssets().open("fhd-scene.jpg");FileOutputStream out=new FileOutputStream(target)){byte[] bytes=new byte[32768];for(int n;(n=in.read(bytes))!=-1;)out.write(bytes,0,n);}
        call(repo,"finish",fhd,"");Bitmap fhdBitmap=(Bitmap)call(repo,"decode",fhd,1920,1080);ok(fhdBitmap.getWidth()==1920&&fhdBitmap.getHeight()==1080,"exported Full HD artwork decodes natively as 1920x1080");fhdBitmap.recycle();
        Object preferredCache=call(repo,"cached",orbital);ok(preferredCache!=null&&"desktop_1920x1080".equals(field(preferredCache,"device")),"Full HD cache is preferred over the available fallback 4K cache");
        call(repo,"choose",tea);profile(call(repo,"selected"),"sunken-teahouse");
        result.putString("stream","PASS "+checks+" TV auto-resolution checks: upgrade, both exact devices, live orbital JPEG/cache/decode, tea readiness and saved selection; tea_waiting="+waiting);finish(Activity.RESULT_OK,result);
    }catch(Throwable e){result.putString("stream",e.toString()+"\n"+android.util.Log.getStackTraceString(e));finish(Activity.RESULT_CANCELED,result);}}
}
