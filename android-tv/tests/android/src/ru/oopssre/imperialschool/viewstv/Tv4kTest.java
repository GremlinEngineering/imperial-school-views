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
public class Tv4kTest extends Instrumentation {
    int checks;String validationCA;
    void ok(boolean value,String label){checks++;if(!value)throw new AssertionError(label);}
    Object field(Object value,String name)throws Exception {Field f=value.getClass().getDeclaredField(name);f.setAccessible(true);return f.get(value);}
    Object call(Object value,String name,Object... args)throws Exception {
        for(Method m:value.getClass().getDeclaredMethods())if(m.getName().equals(name)&&m.getParameterTypes().length==args.length){m.setAccessible(true);try{return m.invoke(value,args);}catch(InvocationTargetException e){throw (Exception)e.getCause();}}
        throw new NoSuchMethodException(name);
    }
    void profile(Object theme,String id)throws Exception {
        ok(id.equals(field(theme,"id")),id+" selected");
        ok("desktop_3840x2160".equals(field(theme,"device")),id+" exact selected device");
        ok((Integer)field(theme,"width")==3840&&(Integer)field(theme,"height")==2160,id+" exact selected geometry");
    }
    JSONObject descriptor(String id,String device,int height)throws Exception {
        return new JSONObject().put("id",id).put("type","dynamic").put("title",id)
            .put("current_url","dynamic/"+id+"/current.json")
            .put("formats",new JSONObject().put(device,new JSONObject().put("width",3840).put("height",height)));
    }
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
        ok("0.3.1".equals(installed.versionName)&&installed.versionCode==4,"installed release 0.3.1 build4");
        prefs.edit().clear().putBoolean("music_app_enabled",false).putBoolean("music_screensaver_enabled",true).putInt("music_volume",35).commit();
        File root=new File(c.getCacheDir(),"imperial-tv");root.mkdirs();File catalogue=new File(root,"catalogue.json");
        try(InputStream in=getContext().getAssets().open("catalogue.json");FileOutputStream out=new FileOutputStream(catalogue)){byte[] b=new byte[32768];for(int n;(n=in.read(b))!=-1;)out.write(b,0,n);}
        Class<?> repository=Class.forName(c.getPackageName()+".Repository",true,c.getClassLoader());Constructor<?> constructor=repository.getDeclaredConstructor(Context.class);constructor.setAccessible(true);Object repo=constructor.newInstance(c);
        prefs.edit().putString("theme","orbital-port").putString("descriptor",descriptor("orbital-port","desktop_16x9",2160).toString()).commit();
        Object orbital=call(repo,"selected");profile(orbital,"orbital-port");
        prefs.edit().putString("theme","sunken-teahouse").putString("descriptor",descriptor("sunken-teahouse","desktop_3840x2400",2400).toString()).commit();
        Object tea=call(repo,"selected");profile(tea,"sunken-teahouse");
        File backup=new File(root,"catalogue-test-backup.json");ok(catalogue.renameTo(backup),"hide catalogue to test saved descriptor");
        profile(call(repo,"selected"),"sunken-teahouse");ok(backup.renameTo(catalogue),"restore older catalogue");
        ok(!prefs.getBoolean("music_app_enabled",true)&&prefs.getBoolean("music_screensaver_enabled",false)&&prefs.getInt("music_volume",0)==35,"sound settings survive profile migration");
        step("TV profile migration passed; fetching live orbital frame");
        Object frame=call(repo,"refresh",orbital,"");
        ok("desktop_3840x2160".equals(field(frame,"device")),"live orbital frame uses TV device");
        ok((Integer)field(frame,"width")==3840&&(Integer)field(frame,"height")==2160,"live orbital image is 4K");
        ok(((String)field(frame,"url")).contains("/desktop_3840x2160/current.jpg"),"live orbital JPEG follows exact TV endpoint");
        Bitmap bitmap=(Bitmap)call(repo,"decode",frame,1920,1080);ok(bitmap.getWidth()==1920&&bitmap.getHeight()==1080,"Android decoder displays full 16:9 frame on 1080 TV buffer");bitmap.recycle();
        Object cached=call(repo,"cached",orbital);ok(cached!=null&&field(frame,"sha").equals(field(cached,"sha")),"orbital 4K frame is reusable from cache");
        step("Live orbital frame downloaded, verified and decoded; checking tea TV readiness");
        boolean waiting=false;
        try{
            Object teaFrame=call(repo,"refresh",tea,"");
            ok("desktop_3840x2160".equals(field(teaFrame,"device")),"tea frame uses the TV 4K profile");
            ok((Integer)field(teaFrame,"width")==3840&&(Integer)field(teaFrame,"height")==2160,"tea frame preserves TV 4K geometry");
            Bitmap teaBitmap=(Bitmap)call(repo,"decode",teaFrame,1920,1080);ok(teaBitmap.getWidth()==1920&&teaBitmap.getHeight()==1080,"Android decodes the published TV tea scene");teaBitmap.recycle();
        }catch(Exception e){waiting=e.getMessage()!=null&&e.getMessage().contains("ещё не опубликован");ok(waiting,"unpublished TV tea waits without substituting a different profile");}
        Object cachedTea=call(repo,"cached",tea);ok(cachedTea==null||"desktop_3840x2160".equals(field(cachedTea,"device")),"tea cache cannot return a different device");
        call(repo,"choose",tea);profile(call(repo,"selected"),"sunken-teahouse");
        result.putString("stream","PASS "+checks+" TV 4K checks: upgrade, both exact devices, live orbital JPEG/cache/decode, tea readiness and saved selection; tea_waiting="+waiting);finish(Activity.RESULT_OK,result);
    }catch(Throwable e){result.putString("stream",e.toString()+"\n"+android.util.Log.getStackTraceString(e));finish(Activity.RESULT_CANCELED,result);}}
}
