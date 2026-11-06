package ru.oopssre.imperialschool.views.test;
import android.app.*;import android.content.*;import android.graphics.*;import android.graphics.drawable.*;import android.os.*;import android.view.*;import android.view.accessibility.*;import android.widget.*;
import java.io.*;import java.lang.reflect.*;import java.security.*;import java.util.*;import org.json.*;
/** Disposable emulator only. Replaces app settings with local fixture collections. */
public class PhoneUiTest extends Instrumentation {
 Activity activity;int checks;boolean seedOnly,requireUpgrade;
 public void onCreate(Bundle b){super.onCreate(b);seedOnly="seed".equals(b.getString("mode"));requireUpgrade="verify-upgrade".equals(b.getString("mode"));start();}
 Object field(String name)throws Exception{Field f=activity.getClass().getDeclaredField(name);f.setAccessible(true);return f.get(activity);}
 void ok(boolean value,String name){checks++;if(!value)throw new AssertionError(name);}
 void call(String name)throws Exception{runOnMainSync(()->{try{Method m=activity.getClass().getDeclaredMethod(name);m.setAccessible(true);m.invoke(activity);}catch(Exception e){throw new RuntimeException(e);}});waitForIdleSync();}
 boolean sameProfile(String a,String b)throws Exception{JSONObject x=new JSONObject(a),y=new JSONObject(b);if(x.length()!=y.length())return false;for(Iterator<String> i=x.keys();i.hasNext();){String k=i.next();if(!String.valueOf(x.opt(k)).equals(String.valueOf(y.opt(k))))return false;}return true;}
 void press(String field)throws Exception{runOnMainSync(()->{try{((View)field(field)).performClick();}catch(Exception e){throw new RuntimeException(e);}});waitForIdleSync();}
 boolean inMain(String name)throws Exception{View v=(View)field(name);View root=activity.getWindow().getDecorView();while(v!=null){if(v==root)return true;v=v.getParent() instanceof View?(View)v.getParent():null;}return false;}
 void click(String label)throws Exception{
  long end=SystemClock.uptimeMillis()+10000;
  while(SystemClock.uptimeMillis()<end){AccessibilityNodeInfo root=getUiAutomation().getRootInActiveWindow();if(root!=null)for(AccessibilityNodeInfo n:root.findAccessibilityNodeInfosByText(label)){
    if(n.getText()!=null&&label.equalsIgnoreCase(n.getText().toString())){while(n!=null&&!n.isClickable())n=n.getParent();if(n!=null&&n.performAction(AccessibilityNodeInfo.ACTION_CLICK)){waitForIdleSync();Thread.sleep(200);return;}}
  }Thread.sleep(100);}
  throw new AssertionError("No clickable text: "+label);
 }
 boolean hasText(String label){AccessibilityNodeInfo root=getUiAutomation().getRootInActiveWindow();return root!=null&&!root.findAccessibilityNodeInfosByText(label).isEmpty();}
 void ready()throws Exception{long end=SystemClock.uptimeMillis()+20000;while(SystemClock.uptimeMillis()<end){if(!(Boolean)field("busy")&&(Boolean)field("hasPreviewFrame")&&((ImageView)field("preview")).getDrawable()!=null){waitForIdleSync();return;}Thread.sleep(100);}throw new AssertionError("Local image did not render");}
 void shot(String name)throws Exception{waitForIdleSync();Bitmap image=getUiAutomation().takeScreenshot();File out=new File(getTargetContext().getExternalFilesDir("qa-140"),name+".png");out.getParentFile().mkdirs();try(FileOutputStream f=new FileOutputStream(out)){image.compress(Bitmap.CompressFormat.PNG,100,f);}image.recycle();}
 void write(File f,byte[] bytes)throws Exception{f.getParentFile().mkdirs();try(FileOutputStream out=new FileOutputStream(f)){out.write(bytes);}}
 String hash(byte[] bytes)throws Exception{StringBuilder s=new StringBuilder();for(byte b:MessageDigest.getInstance("SHA-256").digest(bytes))s.append(String.format(Locale.ROOT,"%02x",b&255));return s.toString();}
 void seed(Context c,String id,String title,boolean portrait,byte[] bytes,int width,int height)throws Exception{
  File dir=new File(c.getFilesDir(),"views/collections/"+id);JSONObject file=new JSONObject().put("url","files/image.jpg").put("width",portrait?width:height).put("height",portrait?height:width).put("bytes",bytes.length).put("sha256",hash(bytes));
  JSONArray items=new JSONArray();for(String state:new String[]{"morning","evening"})items.put(new JSONObject().put("id",state).put("title","Полярный горизонт").put("preview","previews/image.jpg").put("files",new JSONArray().put(file)));
  JSONObject pack=new JSONObject().put("schema",1).put("id",id).put("title",title).put("items",items);
  write(new File(dir,"manifest.json"),pack.toString().getBytes("UTF-8"));write(new File(dir,"files/image.jpg"),bytes);write(new File(dir,"previews/image.jpg"),bytes);
 }
 JSONObject selection(String id,String target)throws Exception{return new JSONObject().put("source","local").put("collection",id).put("mode","daily").put("target",target).put("paused",true).put("notify_collections",false).put("notify_app",false).put("weather_source","game-world").put("weather_delivery","zip").put("weather_format","auto").put("revision",target+"-before").put("weather_city","");}
 public void onStart(){Bundle out=new Bundle();try{
  Context c=getTargetContext();if(requireUpgrade){SharedPreferences before=c.getSharedPreferences("views",0);ok("preserved".equals(before.getString("qa_upgrade_marker","")),"update preserved app preferences");ok("qa-first".equals(new JSONObject(before.getString("profile_home","{}")).optString("collection")),"update preserved selected home collection");ok("qa-second".equals(new JSONObject(before.getString("profile_lock","{}")).optString("collection")),"update preserved independent lock collection");}
  byte[] bytes;try(InputStream in=getContext().getAssets().open("fixture.jpg");ByteArrayOutputStream b=new ByteArrayOutputStream()){byte[] buf=new byte[32768];for(int n;(n=in.read(buf))!=-1;)b.write(buf,0,n);bytes=b.toByteArray();}
  BitmapFactory.Options info=new BitmapFactory.Options();info.inJustDecodeBounds=true;BitmapFactory.decodeByteArray(bytes,0,bytes.length,info);ok(info.outHeight>info.outWidth,"fixture is a phone image");
  seed(c,"qa-first","Под крылом — целый мир",true,bytes,info.outWidth,info.outHeight);seed(c,"qa-second","Четыре сезона",true,bytes,info.outWidth,info.outHeight);seed(c,"qa-desktop","Только для компьютера",false,bytes,info.outWidth,info.outHeight);
  SharedPreferences prefs=c.getSharedPreferences("views",0);prefs.edit().clear().putString("weather_api","1.7").putBoolean("profiles_migrated",true).putBoolean("configured",true).putString("editing_target","home").putString("profile_home",selection("qa-first","home").toString()).putString("profile_lock",selection("qa-second","lock").toString()).commit();
  if(seedOnly){prefs.edit().putString("qa_upgrade_marker","preserved").commit();out.putString("stream","SEEDED "+c.getPackageManager().getPackageInfo(c.getPackageName(),0).versionName);finish(Activity.RESULT_OK,out);return;}
  activity=startActivitySync(new Intent(Intent.ACTION_MAIN).setClassName(c.getPackageName(),c.getPackageName()+".MainActivity").addFlags(Intent.FLAG_ACTIVITY_NEW_TASK));waitForIdleSync();
  runOnMainSync(()->{activity.getWindow().addFlags(WindowManager.LayoutParams.FLAG_TURN_SCREEN_ON|WindowManager.LayoutParams.FLAG_DISMISS_KEYGUARD|WindowManager.LayoutParams.FLAG_SHOW_WHEN_LOCKED);((KeyguardManager)c.getSystemService(Context.KEYGUARD_SERVICE)).requestDismissKeyguard(activity,null);});
  ready();ok("1.4.0".equals(c.getPackageManager().getPackageInfo(c.getPackageName(),0).versionName),"release 1.4.0 installed");
  ok(c.getPackageManager().getApplicationIcon(c.getPackageName()) instanceof AdaptiveIconDrawable,"native adaptive launcher icon installed");
  ok(!inMain("target")&&!inMain("downloadNetwork")&&!inMain("notifyCollections")&&!inMain("weatherDelivery"),"secondary controls absent from main hierarchy");
  ok(inMain("preview")&&inMain("collection")&&inMain("apply"),"main exposes image selection and application");
  String draft=field("draft").toString(),home=prefs.getString("profile_home",null),lock=prefs.getString("profile_lock",null);shot("main");
  press("apply");ok(hasText("Куда установить обои?")&&hasText("Главный экран")&&hasText("Экран блокировки")&&hasText("Оба экрана"),"destination chosen at application time");shot("destination");click("Отмена");
  ok(sameProfile(home,prefs.getString("profile_home",null))&&lock.equals(prefs.getString("profile_lock",null))&&draft.equals(field("draft").toString()),"cancelling keeps both profiles and draft");
  press("collection");ok(!hasText("Только для компьютера")&&hasText("Четыре сезона"),"visual gallery excludes desktop-only collection");shot("gallery");click("Назад · Коллекции");
  call("showSettings");ok(hasText("Скачивание коллекций")&&hasText("Новые обои для телефона"),"settings available in secondary panel");shot("settings");click("Готово");
  call("showInstalled");runOnMainSync(()->{try{Spinner t=(Spinner)field("target");t.setSelection(1);}catch(Exception e){throw new RuntimeException(e);}});waitForIdleSync();
  ok(draft.equals(field("draft").toString()),"installed-screen selection does not replace preview draft");shot("installed");click("Готово");
  press("apply");click("Экран блокировки");long end=SystemClock.uptimeMillis()+20000;
  while(SystemClock.uptimeMillis()<end&&!"qa-first".equals(new JSONObject(prefs.getString("profile_lock","{}")).optString("collection")))Thread.sleep(100);
  ok(sameProfile(home,prefs.getString("profile_home",null)),"applying to lock preserves home profile");
  JSONObject applied=new JSONObject(prefs.getString("profile_lock","{}"));ok("qa-first".equals(applied.optString("collection"))&&"lock".equals(applied.optString("target")),"preview collection applied to chosen screen");
  ok(!prefs.getBoolean("profiles_linked",true),"independent screens remain independent");
  ready();call("showInstalled");press("pause");Thread.sleep(500);waitForIdleSync();
  ok(sameProfile(home,prefs.getString("profile_home",null)),"pause never replaces home selection");click("Готово");
  press("viewSaved");long viewerEnd=SystemClock.uptimeMillis()+15000;while(!hasText("Полярный горизонт")&&SystemClock.uptimeMillis()<viewerEnd){Thread.sleep(100);waitForIdleSync();}ok(hasText("Полярный горизонт"),"offline viewer opens saved images");shot("viewer");
  out.putString("stream","PASS "+checks+" native Android checks; local image fixtures, no physical phone tested.");finish(Activity.RESULT_OK,out);
 }catch(Throwable e){try{shot("failure");}catch(Exception ignored){}out.putString("stream",android.util.Log.getStackTraceString(e));finish(Activity.RESULT_CANCELED,out);}}
}
