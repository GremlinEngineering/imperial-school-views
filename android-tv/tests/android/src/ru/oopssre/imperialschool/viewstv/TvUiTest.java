package ru.oopssre.imperialschool.viewstv;

import android.app.*;import android.content.*;import android.graphics.*;import android.os.*;import android.view.*;import android.widget.*;
import java.io.*;import java.lang.reflect.*;import java.security.*;import java.util.*;import org.json.*;

/** Destructive test setup: run only on a disposable Android TV emulator/test device. */
public class TvUiTest extends Instrumentation {
 Activity activity;int checks;
 public void onCreate(Bundle b){super.onCreate(b);start();}
 void ok(boolean v,String name){checks++;if(!v)throw new AssertionError(name);}
 Object field(Object obj,String name)throws Exception {Field f=obj.getClass().getDeclaredField(name);f.setAccessible(true);return f.get(obj);}
 Object scene()throws Exception{return field(activity,"scene");}
 Object call(Object obj,String name,Class<?>[] types,Object... args)throws Exception {Method m=obj.getClass().getDeclaredMethod(name,types);m.setAccessible(true);return m.invoke(obj,args);}
 void mainCall(String name)throws Exception {runOnMainSync(()->{try{call(scene(),name,new Class<?>[]{});}catch(Exception e){throw new RuntimeException(e);}});waitForIdleSync();}
 String page()throws Exception{return (String)field(scene(),"page");}
 boolean panel()throws Exception{return ((View)field(scene(),"panel")).getVisibility()==View.VISIBLE;}
 void key(int code){sendKeyDownUpSync(code);waitForIdleSync();}
 void click(String prefix)throws Exception {
  LinearLayout content=(LinearLayout)field(scene(),"content");List<Button> rows=new ArrayList<>();
  for(int i=0;i<content.getChildCount();i++)if(content.getChildAt(i) instanceof Button&&content.getChildAt(i).isEnabled())rows.add((Button)content.getChildAt(i));
  int target=-1,current=-1;for(int i=0;i<rows.size();i++){String label=rows.get(i).getText().toString().replaceFirst("^✓ ","");if(label.startsWith(prefix))target=i;if(rows.get(i).hasFocus())current=i;}
  if(target<0||current<0)throw new AssertionError("No reachable control: "+prefix);
  int direction=target>current?KeyEvent.KEYCODE_DPAD_DOWN:KeyEvent.KEYCODE_DPAD_UP;
  for(int i=0;i<Math.abs(target-current);i++)key(direction);
  ok(rows.get(target).hasFocus(),"D-pad reaches "+prefix);key(KeyEvent.KEYCODE_DPAD_CENTER);Thread.sleep(80);waitForIdleSync();
 }
 String text(View view){String result=view instanceof TextView?((TextView)view).getText().toString()+"\n":"";if(view instanceof ViewGroup){ViewGroup group=(ViewGroup)view;for(int i=0;i<group.getChildCount();i++)result+=text(group.getChildAt(i));}return result;}
 String contentText()throws Exception{return text((View)field(scene(),"content"));}
 String themeTitle(String id)throws Exception {Object repo=field(scene(),"repo");List<?> rows=(List<?>)call(repo,"themes",new Class<?>[]{});for(Object theme:rows)if(id.equals(field(theme,"id")))return (String)field(theme,"title");throw new AssertionError(id);}
 String kind()throws Exception {Object repo=field(scene(),"repo");return (String)field(call(repo,"selected",new Class<?>[]{}),"kind");}
 void choose(String id)throws Exception {click("Обои ·");click(themeTitle(id));}
 void screenshot(String name)throws Exception {waitForIdleSync();Bitmap bitmap=getUiAutomation().takeScreenshot();ByteArrayOutputStream bytes=new ByteArrayOutputStream();bitmap.compress(Bitmap.CompressFormat.PNG,100,bytes);bitmap.recycle();Bundle proof=new Bundle();proof.putString("proof_"+name,android.util.Base64.encodeToString(bytes.toByteArray(),android.util.Base64.NO_WRAP));sendStatus(0,proof);}
 public void onStart(){Bundle result=new Bundle();try{
  Context c=getTargetContext();SharedPreferences prefs=c.getSharedPreferences("tv",0);prefs.edit().clear().putBoolean("music_app_enabled",false).commit();
  File cache=new File(c.getCacheDir(),"imperial-tv");cache.mkdirs();try(InputStream in=getContext().getAssets().open("catalogue.json");FileOutputStream out=new FileOutputStream(new File(cache,"catalogue.json"))){byte[] b=new byte[32768];for(int n;(n=in.read(b))!=-1;)out.write(b,0,n);}
  activity=startActivitySync(new Intent(Intent.ACTION_MAIN).setClassName(c.getPackageName(),c.getPackageName()+".MainActivity").addFlags(Intent.FLAG_ACTIVITY_NEW_TASK));waitForIdleSync();
  android.content.pm.PackageInfo installed=c.getPackageManager().getPackageInfo(c.getPackageName(),0);ok("0.6.0".equals(installed.versionName)&&installed.versionCode==11,"installed 0.6.0 build 11");ok(!panel(),"launch opens wallpaper");
  key(KeyEvent.KEYCODE_DPAD_CENTER);ok(!panel(),"short OK does not open settings");
  long down=SystemClock.uptimeMillis();sendKeySync(new KeyEvent(down,down,KeyEvent.ACTION_DOWN,KeyEvent.KEYCODE_DPAD_CENTER,0));Thread.sleep(1200);sendKeySync(new KeyEvent(down,SystemClock.uptimeMillis(),KeyEvent.ACTION_UP,KeyEvent.KEYCODE_DPAD_CENTER,0));waitForIdleSync();
  ok(panel()&&page().equals("settings"),"long OK opens settings without accidental click on key release");ok(contentText().contains("Кеш ·"),"cache size visible in settings");screenshot("settings_060");
  click("Музыка");String musicText=contentText();ok(musicText.contains("Звук в приложении")&&musicText.contains("Звук в заставке")&&musicText.contains("Громкость"),"music controls retained");
  ok(!musicText.contains("YM2612")&&!musicText.contains("SNES")&&!musicText.contains("FM-цитата")&&!musicText.contains("MP3")&&!musicText.contains("синтез"),"routine music menu contains no implementation essay");screenshot("music_060");
  click("Звук в заставке");ok(prefs.getBoolean("music_screensaver_enabled",false)&&!prefs.getBoolean("music_app_enabled",true),"app and screensaver sound independent");
  click("Громкость ·");ok(page().equals("volume"),"volume submenu");key(KeyEvent.KEYCODE_BACK);ok(page().equals("music"),"Back returns to music");key(KeyEvent.KEYCODE_BACK);ok(page().equals("settings"),"Back returns to settings");
  ok(((View)field(scene(),"content")).findFocus() instanceof Button&&((Button)((View)field(scene(),"content")).findFocus()).getText().toString().equals("Музыка"),"focus returns to originating music control");
  prefs.edit().putBoolean("video_output",true).commit();mainCall("openSettings");click("Обои ·");String choices=contentText();ok(choices.contains("Динамические")&&choices.contains("Погодные")&&choices.contains("Обычные"),"all categories stay visible in video mode");screenshot("themes_060");
  click(themeTitle("chip-n-dale-weather"));ok(kind().equals("weather")&&!((Boolean)call(scene(),"videoEnabled",new Class<?>[]{}))&&prefs.getBoolean("video_output",false),"weather uses image while video preference remains saved");
  choose("194x-under-the-wing");ok(kind().equals("plain")&&!((Boolean)call(scene(),"videoEnabled",new Class<?>[]{})),"ordinary wallpapers work with saved video preference");
  choose("orbital-port");ok((Boolean)call(scene(),"videoEnabled",new Class<?>[]{}),"return to dynamic restores video output");
  click("О приложении");ok(contentText().contains("Дмитрий Малыхин aka Timon_Crazy")&&contentText().contains("0.6.0"),"installed version and author retained");click("Диагностика");ok(contentText().contains("Surface фактически")&&contentText().contains("Размер декодера"),"technical resolution information remains in diagnostics");key(KeyEvent.KEYCODE_BACK);key(KeyEvent.KEYCODE_BACK);
  // Decode a real PNG through the production Repository, including its checked cache path.
  byte[] png;try(InputStream in=getContext().getAssets().open("png-regression.png");ByteArrayOutputStream out=new ByteArrayOutputStream()){byte[] b=new byte[1024];for(int n;(n=in.read(b))!=-1;)out.write(b,0,n);png=out.toByteArray();}
  StringBuilder digest=new StringBuilder();for(byte b:MessageDigest.getInstance("SHA-256").digest(png))digest.append(String.format(java.util.Locale.ROOT,"%02x",b&255));String sha=digest.toString();
  File image=new File(c.getCacheDir(),"imperial-tv/images/"+sha+".png");image.getParentFile().mkdirs();try(FileOutputStream out=new FileOutputStream(image)){out.write(png);}
  ClassLoader loader=c.getClassLoader();Class<?> protocol=Class.forName(c.getPackageName()+".Protocol",true,loader);JSONObject frame=new JSONObject().put("theme","qa").put("device","plain").put("title","PNG").put("kind","plain").put("format","png").put("url","collections/qa/files/test.png").put("sha",sha).put("state",sha).put("width",8).put("height",8).put("bytes",png.length).put("at",1).put("until",2);
  Object parsed=protocol.getMethod("savedFrame",JSONObject.class).invoke(null,frame),repo=field(scene(),"repo");Bitmap decoded=(Bitmap)call(repo,"decode",new Class<?>[]{parsed.getClass(),int.class,int.class},parsed,8,8);
  ok(decoded.getWidth()==8&&decoded.getHeight()==8,"native Android decoder reads PNG without JPEG conversion");ok(Color.red(decoded.getPixel(3,4))==93&&Color.green(decoded.getPixel(3,4))==124,"native PNG pixels retained");decoded.recycle();
  prefs.edit().putString("qa_preference","keep").commit();File updateMarker=new File(c.getCacheDir(),"tv-update/qa-marker.tmp");updateMarker.getParentFile().mkdirs();try(FileOutputStream out=new FileOutputStream(updateMarker)){out.write(new byte[1024]);}
  click("Кеш ·");ok(contentText().contains("Всего:")&&contentText().contains("из 64 МБ")&&contentText().contains("Обновление приложения:"),"cache counters include wallpaper and installer cache");click("Очистить кеш");
  long end=SystemClock.uptimeMillis()+45000;while((Boolean)field(scene(),"cacheBusy")&&SystemClock.uptimeMillis()<end){Thread.sleep(100);waitForIdleSync();}
  ok(!(Boolean)field(scene(),"cacheBusy")&&contentText().contains("Кеш очищен"),"cache cleanup completes after worker and decoder drain");
  ok(!image.exists()&&!updateMarker.exists(),"PNG and update cache removed");ok("keep".equals(prefs.getString("qa_preference",""))&&prefs.getBoolean("video_output",false)&&prefs.getBoolean("music_screensaver_enabled",false),"cleanup preserves selection and settings");screenshot("cache_060");
  result.putString("stream","PASS "+checks+" UI/navigation/PNG/cache checks on Android; device-specific hardware 4K remains separate");finish(Activity.RESULT_OK,result);
 }catch(Throwable e){result.putString("stream",android.util.Log.getStackTraceString(e));finish(Activity.RESULT_CANCELED,result);}}
}
