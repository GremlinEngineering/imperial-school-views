package ru.oopssre.imperialschool.viewstv;

import android.app.*;import android.content.*;import android.graphics.*;import android.os.*;import android.view.*;import android.widget.*;
import java.io.*;import java.lang.reflect.*;import java.security.*;import java.util.*;import org.json.*;

/** Disposable emulator/device only: settings and cache are replaced with deterministic fixtures. */
public class TvUiTest extends Instrumentation {
 Activity activity;int checks;
 public void onCreate(Bundle b){super.onCreate(b);start();}
 void ok(boolean value,String name){checks++;if(!value)throw new AssertionError(name);}
 Object field(Object obj,String name)throws Exception{Field f=obj.getClass().getDeclaredField(name);f.setAccessible(true);return f.get(obj);}
 Object scene()throws Exception{return field(activity,"scene");}
 Object call(Object obj,String name,Class<?>[] types,Object... args)throws Exception{Method m=obj.getClass().getDeclaredMethod(name,types);m.setAccessible(true);return m.invoke(obj,args);}
 void mainCall(String name)throws Exception{runOnMainSync(()->{try{call(scene(),name,new Class<?>[]{});}catch(Exception e){throw new RuntimeException(e);}});waitForIdleSync();}
 String page()throws Exception{return (String)field(scene(),"page");}
 boolean panel()throws Exception{return ((View)field(scene(),"panel")).getVisibility()==View.VISIBLE;}
 void inject(KeyEvent event){event.setSource(InputDevice.SOURCE_DPAD);if(!getUiAutomation().injectInputEvent(event,true))throw new AssertionError("Remote event injection failed");}
 void key(int code){long time=SystemClock.uptimeMillis();inject(new KeyEvent(time,time,KeyEvent.ACTION_DOWN,code,0));inject(new KeyEvent(time,SystemClock.uptimeMillis(),KeyEvent.ACTION_UP,code,0));waitForIdleSync();}
 void buttons(View view,List<Button> result){if(view instanceof Button){if(view.isEnabled())result.add((Button)view);return;}if(view instanceof ViewGroup){ViewGroup group=(ViewGroup)view;for(int i=0;i<group.getChildCount();i++)buttons(group.getChildAt(i),result);}}
 List<Button> buttons()throws Exception{List<Button> rows=new ArrayList<>();buttons((View)field(scene(),"content"),rows);return rows;}
 void focus(String prefix)throws Exception{
  List<Button> rows=buttons();int target=-1,current=-1;
  for(int i=0;i<rows.size();i++){String text=rows.get(i).getText().toString().replaceFirst("^✓ ","");if(text.startsWith(prefix))target=i;if(rows.get(i).hasFocus())current=i;}
  if(target<0||current<0)throw new AssertionError("No reachable control "+prefix+"; page="+page()+"; "+contentText());
  int direction=target>current?KeyEvent.KEYCODE_DPAD_DOWN:KeyEvent.KEYCODE_DPAD_UP;
  for(int i=0;i<Math.abs(target-current);i++)key(direction);
  ok(rows.get(target).hasFocus(),"D-pad reaches "+prefix);
 }
 void click(String prefix)throws Exception{focus(prefix);key(KeyEvent.KEYCODE_DPAD_CENTER);Thread.sleep(120);waitForIdleSync();}
 String text(View view){String s=view instanceof TextView?((TextView)view).getText().toString()+"\n":"";if(view instanceof ViewGroup){ViewGroup group=(ViewGroup)view;for(int i=0;i<group.getChildCount();i++)s+=text(group.getChildAt(i));}return s;}
 String contentText()throws Exception{return text((View)field(scene(),"content"));}
 String kind()throws Exception{Object repo=field(scene(),"repo");return (String)field(call(repo,"selected",new Class<?>[]{}),"kind");}
 void screenshot(String name)throws Exception{waitForIdleSync();Bitmap bitmap=getUiAutomation().takeScreenshot();File directory=getTargetContext().getExternalFilesDir("qa-070");directory.mkdirs();File file=new File(directory,name+".png");try(FileOutputStream out=new FileOutputStream(file)){bitmap.compress(Bitmap.CompressFormat.PNG,100,out);}bitmap.recycle();Bundle proof=new Bundle();proof.putString("screenshot_"+name,file.getAbsolutePath());sendStatus(0,proof);}
 byte[] asset(String name)throws Exception{try(InputStream in=getContext().getAssets().open(name);ByteArrayOutputStream out=new ByteArrayOutputStream()){byte[] b=new byte[32768];for(int n;(n=in.read(b))!=-1;)out.write(b,0,n);return out.toByteArray();}}
 String digest(byte[] bytes)throws Exception{StringBuilder s=new StringBuilder();for(byte b:MessageDigest.getInstance("SHA-256").digest(bytes))s.append(String.format(Locale.ROOT,"%02x",b&255));return s.toString();}
 void write(File file,byte[] bytes)throws Exception{file.getParentFile().mkdirs();try(FileOutputStream out=new FileOutputStream(file)){out.write(bytes);}}
 void seed(Context context,String theme,String device,String kind,String file,int w,int h)throws Exception{
  byte[] bytes=asset(file);String sha=digest(bytes);File root=new File(context.getCacheDir(),"imperial-tv");write(new File(root,"images/"+sha+".jpg"),bytes);
  JSONObject frame=new JSONObject().put("theme",theme).put("device",device).put("title",theme).put("kind",kind).put("format","jpg").put("url",kind.equals("dynamic")?"dynamic/"+theme+"/devices/"+device+"/current.jpg":"collections/"+theme+"/files/qa.jpg").put("sha",sha).put("state",sha).put("width",w).put("height",h).put("bytes",bytes.length).put("at",System.currentTimeMillis()).put("until",System.currentTimeMillis()+3600000);
  write(new File(root,"state-"+theme+"-"+device+".json"),frame.toString().getBytes("UTF-8"));
 }
 void waitPreview()throws Exception{long end=SystemClock.uptimeMillis()+20000;while(SystemClock.uptimeMillis()<end){Object gallery=field(scene(),"gallery");if(gallery!=null&&field(gallery,"bitmap")!=null){Thread.sleep(400);waitForIdleSync();if(field(scene(),"gallery")==gallery&&field(gallery,"bitmap")!=null)return;}Thread.sleep(100);}throw new AssertionError("cached preview did not render");}
 void waitFrame(String theme)throws Exception{long end=SystemClock.uptimeMillis()+15000;while(SystemClock.uptimeMillis()<end){Object controller=field(scene(),"controller"),frame=field(controller,"frame");if(frame!=null&&theme.equals(field(frame,"theme"))){Thread.sleep(200);waitForIdleSync();return;}Thread.sleep(100);waitForIdleSync();}throw new AssertionError("Selected scene not displayed: "+theme);}
 public void onStart(){Bundle result=new Bundle();try{
  Context c=getTargetContext();SharedPreferences prefs=c.getSharedPreferences("tv",0);prefs.edit().clear().putBoolean("music_app_enabled",false).putString("resolution","1080p").commit();
  write(new File(c.getCacheDir(),"imperial-tv/catalogue.json"),asset("catalogue.json"));
  seed(c,"orbital-port","desktop_1920x1080","dynamic","fhd-scene.jpg",1920,1080);
  seed(c,"194x-under-the-wing","plain","plain","qa-194x.jpg",3840,2160);
  activity=startActivitySync(new Intent(Intent.ACTION_MAIN).setClassName(c.getPackageName(),c.getPackageName()+".MainActivity").addFlags(Intent.FLAG_ACTIVITY_NEW_TASK));waitForIdleSync();
  runOnMainSync(()->{activity.getWindow().addFlags(WindowManager.LayoutParams.FLAG_TURN_SCREEN_ON|WindowManager.LayoutParams.FLAG_DISMISS_KEYGUARD|WindowManager.LayoutParams.FLAG_SHOW_WHEN_LOCKED);((android.app.KeyguardManager)c.getSystemService(Context.KEYGUARD_SERVICE)).requestDismissKeyguard(activity,null);});
  long focusEnd=SystemClock.uptimeMillis()+30000;while(!activity.hasWindowFocus()&&SystemClock.uptimeMillis()<focusEnd){Thread.sleep(200);waitForIdleSync();}if(!activity.hasWindowFocus())screenshot("startup_blocker");ok(activity.hasWindowFocus(),"app owns input focus before D-pad checks");
  android.content.pm.PackageInfo installed=c.getPackageManager().getPackageInfo(c.getPackageName(),0);ok("0.7.0".equals(installed.versionName)&&installed.versionCode==12,"installed 0.7.0 build 12");ok(!panel(),"launch opens wallpaper");
  key(KeyEvent.KEYCODE_DPAD_CENTER);ok(!panel(),"short OK leaves scene unchanged");
  long down=SystemClock.uptimeMillis();inject(new KeyEvent(down,down,KeyEvent.ACTION_DOWN,KeyEvent.KEYCODE_DPAD_CENTER,0));Thread.sleep(2000);inject(new KeyEvent(down,SystemClock.uptimeMillis(),KeyEvent.ACTION_UP,KeyEvent.KEYCODE_DPAD_CENTER,0));waitForIdleSync();
  ok(panel()&&page().equals("menu"),"held OK opens menu without release click");
  ok(buttons().size()==3&&contentText().contains("Выбрать обои")&&contentText().contains("Музыка")&&contentText().contains("Настройки"),"three primary actions");
  ok(!contentText().contains("Кеш")&&!contentText().contains("Хранилище")&&!contentText().contains("Диагностика")&&!contentText().contains("Обновление приложения"),"maintenance absent from root menu");screenshot("menu_070");
  click("Музыка");String musicText=contentText();ok(!musicText.contains("YM2612")&&!musicText.contains("SNES")&&!musicText.contains("MP3"),"routine music menu has no implementation prose");
  click("Музыка в заставке");ok(prefs.getBoolean("music_screensaver_enabled",false)&&!prefs.getBoolean("music_app_enabled",true),"sound modes remain independent");
  focus("Громкость");int volume=prefs.getInt("music_volume",20);key(KeyEvent.KEYCODE_DPAD_RIGHT);ok(page().equals("music")&&prefs.getInt("music_volume",20)==volume+5,"right changes gain inline");key(KeyEvent.KEYCODE_DPAD_LEFT);ok(prefs.getInt("music_volume",20)==volume,"left reverses gain without a submenu");screenshot("music_070");
  key(KeyEvent.KEYCODE_BACK);ok(page().equals("menu"),"Back from music");ok(((View)field(scene(),"content")).findFocus().getTag().equals("music"),"originating focus restored");
  click("Выбрать обои");ok(contentText().contains("Живые сцены")&&contentText().contains("Погода")&&contentText().contains("Коллекции изображений"),"all three groups visible");
  waitPreview();screenshot("gallery_orbit_070");String selected=prefs.getString("theme","orbital-port");focus("Под крылом");waitPreview();ok(prefs.getString("theme","orbital-port").equals(selected),"focus previews without applying");screenshot("gallery_art_070");
  key(KeyEvent.KEYCODE_HOME);Thread.sleep(800);waitForIdleSync();c.startActivity(new Intent(Intent.ACTION_MAIN).setClassName(c.getPackageName(),c.getPackageName()+".MainActivity").addFlags(Intent.FLAG_ACTIVITY_NEW_TASK));Thread.sleep(800);waitForIdleSync();
  ok(page().equals("themes")&&((View)field(scene(),"content")).findFocus().getTag().equals("theme:194x-under-the-wing"),"picker focus survives Home and return");
  waitPreview();
  key(KeyEvent.KEYCODE_DPAD_CENTER);Thread.sleep(150);waitForIdleSync();ok(!panel()&&kind().equals("plain"),"OK applies collection and shows scene");waitFrame("194x-under-the-wing");ok(true,"selected collection actually reaches renderer from cache");screenshot("scene_art_070");
  mainCall("openSettings");ok(buttons().size()==2&&!contentText().contains("Музыка"),"no dead music action for a collection without audio");
  click("Выбрать обои");click("Параметры текущих обоев");ok(page().equals("collection")&&contentText().contains("Смена изображений"),"collection parameters beside collection picker");click("Смена изображений");key(KeyEvent.KEYCODE_BACK);ok(page().equals("collection"),"Back from schedule to collection");key(KeyEvent.KEYCODE_BACK);ok(page().equals("themes"),"Back from collection to picker");key(KeyEvent.KEYCODE_BACK);
  click("Настройки");ok(contentText().contains("Хранилище")&&!contentText().contains("Обновление приложения"),"maintenance hierarchy");screenshot("settings_070");
  click("О приложении");ok(contentText().contains("Timon_Crazy")&&contentText().contains("0.7.0"),"author and installed version");click("Исходный код");ok(contentText().contains("github.com/GremlinEngineering/imperial-school-views"),"repository accessible from TV");screenshot("github_qr_070");key(KeyEvent.KEYCODE_BACK);ok(page().equals("info"),"Back from QR to About");
  click("Музыка и авторы");click("Штраус");ok(page().equals("credits_detail"),"credits open one composition at a time");screenshot("credits_070");click("Полные сведения и источники");key(KeyEvent.KEYCODE_BACK);ok(page().equals("credits_detail"),"Back from sources retains the composition");key(KeyEvent.KEYCODE_BACK);ok(page().equals("music_credits"),"Back from composition");key(KeyEvent.KEYCODE_BACK);key(KeyEvent.KEYCODE_BACK);
  prefs.edit().putString("qa_preference","keep").commit();File marker=new File(c.getCacheDir(),"tv-update/qa-marker.tmp");write(marker,new byte[1024]);
  Object repository=field(scene(),"repo"),theme=call(repository,"selected",new Class<?>[]{});ok(call(repository,"cached",new Class<?>[]{theme.getClass()},theme)!=null,"selected image remains available in the latest-snapshot cache");
  click("Хранилище");ok(contentText().contains("МиБ")&&!contentText().contains("из 64")&&contentText().contains("автоматически"),"honest storage units and retention copy");screenshot("storage_070");click("Очистить кеш");
  long end=SystemClock.uptimeMillis()+45000;while((Boolean)field(scene(),"cacheBusy")&&SystemClock.uptimeMillis()<end){Thread.sleep(100);waitForIdleSync();}
  ok(!(Boolean)field(scene(),"cacheBusy")&&contentText().contains("Кеш очищен"),"cleanup drains preview, download and decoder queues");ok(!marker.exists()&&"keep".equals(prefs.getString("qa_preference",""))&&prefs.getBoolean("music_screensaver_enabled",false),"cleanup preserves selection and sound settings");
  key(KeyEvent.KEYCODE_BACK);ok(page().equals("settings"),"Back from storage");key(KeyEvent.KEYCODE_BACK);ok(page().equals("menu"),"Back from settings");key(KeyEvent.KEYCODE_BACK);ok(!panel(),"Back closes menu to wallpaper");
  result.putString("stream","PASS "+checks+" Android UI, D-pad, preview and storage checks; emulator uses seeded image fixtures, not hardware HEVC.");finish(Activity.RESULT_OK,result);
 }catch(Throwable error){try{screenshot("failure");}catch(Exception ignored){}result.putString("stream",android.util.Log.getStackTraceString(error));finish(Activity.RESULT_CANCELED,result);}}
}
