package ru.oopssre.imperialschool.viewstv;
import org.json.*;
import java.io.*;
import java.nio.file.*;
import java.nio.charset.StandardCharsets;
import java.util.*;

public final class CoreTests {
    static int checks;interface Work{void run()throws Exception;}
    static void ok(boolean value,String label){checks++;if(!value)throw new AssertionError(label);}
    static void bad(Work w,String label)throws Exception {checks++;try{w.run();}catch(IllegalArgumentException|JSONException e){return;}throw new AssertionError(label);}
    static JSONObject read(Path p)throws Exception{return new JSONObject(new String(Files.readAllBytes(p),StandardCharsets.UTF_8));}
    static JSONObject clone(JSONObject p)throws Exception{return new JSONObject(p.toString());}
    public static void main(String[] args)throws Exception {
        Path data=Paths.get(args[0]);Protocol.Theme def=Protocol.defaultTheme();ok(def.id.equals("orbital-port")&&def.device.equals("desktop_3840x2160")&&def.width==3840&&def.height==2160,"default orbital TV");
        JSONObject publishedOrbital=clone(def.descriptor).put("formats",new JSONObject().put("desktop_3840x2160",new JSONObject().put("width",3840).put("height",2160)));ok(Protocol.theme(publishedOrbital).device.equals("desktop_3840x2160"),"published orbital TV profile");
        JSONObject orbitalCatalogue=new JSONObject().put("schema",3).put("collections",new JSONArray().put(publishedOrbital));ok(Protocol.catalogue(orbitalCatalogue).get(0).device.equals("desktop_3840x2160"),"catalogue keeps orbital TV profile");
        List<Protocol.Theme> choices=Protocol.catalogue(read(data.resolve("live-manifest-v3.json")));ok(choices.get(0).id.equals("orbital-port"),"default stays available before publication");Protocol.Theme tea=choices.stream().filter(t->t.id.equals("sunken-teahouse")).findFirst().get();ok(tea.device.equals("desktop_3840x2160")&&tea.width==3840&&tea.height==2160,"teahouse uses the dedicated TV profile even with the older desktop catalogue");
        JSONObject legacyOrbital=clone(def.descriptor).put("formats",new JSONObject().put("desktop_16x9",new JSONObject().put("width",3840).put("height",2160)));ok(Protocol.theme(legacyOrbital).device.equals("desktop_3840x2160"),"old orbital descriptor migrates to exact TV device");
        JSONObject otherDynamic=clone(tea.descriptor).put("id","other-dynamic").put("current_url","dynamic/other-dynamic/current.json");ok(Protocol.theme(otherDynamic).device.equals("desktop_3840x2400"),"unrelated dynamic themes keep their published device selection");
        JSONObject oldTeaTop=read(data.resolve("teahouse-top.json"));bad(()->Protocol.statePath(oldTeaTop,tea),"unpublished TV teahouse waits instead of using a different profile");
        bad(()->Protocol.frame(read(data.resolve("teahouse-state.json")),oldTeaTop,tea,System.currentTimeMillis()),"16:10 teahouse frame cannot replace the TV 4K profile");
        Protocol.url("dynamic/orbital-port/current.json.br");bad(()->Protocol.url("https://evil.example/x.json"),"external host");bad(()->Protocol.url("http://games.oopssre.ru/assets/arcade/views/a.json"),"cleartext");bad(()->Protocol.url("../private.json"),"traversal");bad(()->Protocol.url("dynamic/%2e%2e/private"),"encoded traversal");bad(()->Protocol.url("https://name:pass@games.oopssre.ru/assets/arcade/views/a.json"),"userinfo");
        JSONObject top=read(data.resolve("orbital-top.json")),state=read(data.resolve("orbital-state.json"));ok(Protocol.statePath(top,def).contains(def.device),"published state path");long now=Protocol.time(state.getString("at"))+1000;Protocol.Frame frame=Protocol.frame(state,top,def,now);ok(frame.width==3840&&frame.height==2160,"published frame geometry");ok(Protocol.savedFrame(frame.json()).sha.equals(frame.sha),"snapshot roundtrip");ok(frame.nextDelay(Long.MAX_VALUE/2)==60000,"expired recheck bounded");ok(frame.nextDelay(0)==3600000,"future recheck bounded");
        JSONObject macTop=read(data.resolve("teahouse-mac-top.json")),macState=read(data.resolve("teahouse-mac-state.json"));bad(()->Protocol.frame(macState,macTop,tea,Protocol.time(macState.getString("at"))+1000),"Mac teahouse frame cannot replace the TV 4K profile");
        TvDisplay.Mode hdMode=new TvDisplay.Mode(1,1920,1080,60),uhdMode=new TvDisplay.Mode(2,3840,2160,60),uhd30=new TvDisplay.Mode(3,3840,2160,30);
        ok(TvDisplay.choose(hdMode,new TvDisplay.Mode[]{hdMode}).id==1,"Full HD panel selects Full HD physical mode");
        ok(TvDisplay.choose(hdMode,new TvDisplay.Mode[]{hdMode,uhdMode}).id==2,"4K physical mode wins even with a 1080p UI/current mode");
        ok(TvDisplay.choose(hdMode,new TvDisplay.Mode[]{hdMode,uhd30}).id==3,"4K remains available at a different refresh rate");
        ok(TvDisplay.choose(hdMode,new TvDisplay.Mode[]{uhd30,uhdMode}).id==2,"same-resolution modes prefer current refresh rate");
        ok(TvDisplay.choose(uhdMode,new TvDisplay.Mode[]{hdMode,uhdMode},TvDisplay.FULL_HD).id==1,"manual Full HD can select the available 1080p output on a 4K TV");
        ok(TvDisplay.choose(hdMode,new TvDisplay.Mode[]{hdMode,uhdMode},TvDisplay.UHD).id==2,"manual 4K selects the available 4K output");
        int[] forced4k=TvDisplay.targetSize(TvDisplay.UHD,1920,1080);
        ok(forced4k[0]==3840&&forced4k[1]==2160,"manual 4K requests a native 4K buffer even when firmware only reports 1080p");
        int[] forcedHD=TvDisplay.targetSize(TvDisplay.FULL_HD,3840,2160);
        ok(forcedHD[0]==1920&&forcedHD[1]==1080,"manual Full HD sizes the wallpaper buffer independently of the physical output");
        int[] autoHD=TvDisplay.targetSize(TvDisplay.AUTO,1920,1080),auto4k=TvDisplay.targetSize(TvDisplay.AUTO,3840,2160);
        ok(autoHD[0]==1920&&autoHD[1]==1080&&auto4k[0]==3840&&auto4k[1]==2160,"Auto follows the reported display, without silently forcing 4K");
        ok(TvDisplay.resolution("old-invalid-value").equals(TvDisplay.AUTO),"unknown saved preferences return to Auto");
        Protocol.Theme hdOrbital=Protocol.forDisplay(def,1920,1080),hdTea=Protocol.forDisplay(tea,1920,1080);
        ok(hdOrbital.device.equals("desktop_1920x1080")&&hdOrbital.width==1920&&hdOrbital.height==1080,"orbital Full HD profile follows physical screen");
        ok(hdTea.device.equals("desktop_1920x1080")&&hdTea.width==1920&&hdTea.height==1080,"teahouse Full HD profile follows physical screen");
        ok(Protocol.forDisplay(tea,3840,2160).device.equals("desktop_3840x2160"),"teahouse 4K profile follows physical screen");
        ok(Protocol.forDisplay(def,1280,720).device.equals("desktop_1920x1080"),"HD-ready TV uses Full HD source");
        ok(Protocol.publishedTheme(top,hdOrbital).device.equals("desktop_3840x2160"),"unpublished Full HD temporarily falls back to published 4K");
        JSONObject both=clone(top);both.getJSONObject("formats").put("desktop_1920x1080",new JSONObject().put("width",1920).put("height",1080));both.getJSONObject("format_status").put("desktop_1920x1080",new JSONObject().put("status","ready"));both.getJSONObject("states").put("desktop_1920x1080","dynamic/orbital-port/devices/desktop_1920x1080/current.json");
        ok(Protocol.publishedTheme(both,hdOrbital).device.equals("desktop_1920x1080"),"Full HD is selected as soon as server publishes it, without refreshing catalogue");
        ok(Protocol.publishedTheme(both,def).device.equals("desktop_3840x2160"),"4K TV keeps 4K when both are ready");
        ok(Protocol.publishedTheme(both,def,false).device.equals("desktop_3840x2160"),"manual 4K requests the exact 4K publication when both exist");
        ok(Protocol.publishedTheme(both,hdOrbital,false).device.equals("desktop_1920x1080"),"manual Full HD requests the exact Full HD publication when both exist");
        ok(Protocol.publishedTheme(top,hdOrbital,false).device.equals("desktop_1920x1080"),"manual Full HD is not silently replaced by a ready 4K source");
        bad(()->Protocol.statePath(top,Protocol.publishedTheme(top,hdOrbital,false)),"manual Full HD waits if its publication is absent");
        JSONObject onlyHD=clone(both);onlyHD.getJSONObject("format_status").getJSONObject("desktop_3840x2160").put("status","not_ready");ok(Protocol.publishedTheme(onlyHD,def).device.equals("desktop_1920x1080"),"4K TV can use temporary Full HD publication");
        ok(Protocol.publishedTheme(onlyHD,def,false).device.equals("desktop_3840x2160"),"manual 4K cannot silently choose Full HD");
        bad(()->Protocol.statePath(onlyHD,Protocol.publishedTheme(onlyHD,def,false)),"manual 4K waits while only Full HD is ready");
        JSONObject notReady=clone(both);notReady.getJSONObject("format_status").getJSONObject("desktop_1920x1080").put("status","not_ready");notReady.getJSONObject("format_status").getJSONObject("desktop_3840x2160").put("status","not_ready");Protocol.Theme pending=Protocol.publishedTheme(notReady,hdOrbital);bad(()->Protocol.statePath(notReady,pending),"no ready TV profile stays pending");
        JSONObject wrongGeometry=clone(both);wrongGeometry.getJSONObject("formats").getJSONObject("desktop_1920x1080").put("height",1200);bad(()->Protocol.publishedTheme(wrongGeometry,hdOrbital),"a wrongly sized Full HD publication is rejected");
        JSONObject foreignTop=clone(top).put("collection_id","sunken-teahouse");bad(()->Protocol.publishedTheme(foreignTop,hdOrbital),"another collection cannot act as resolution fallback");
        JSONObject p=clone(state);p.put("device","desktop_3840x2400");bad(()->Protocol.frame(p,top,def,now),"wrong device");
        JSONObject f=clone(state);f.getJSONObject("image").put("url","https://evil.example/frame.jpg");bad(()->Protocol.frame(f,top,def,now),"wrong image endpoint");
        JSONObject compressed=clone(state);compressed.getJSONObject("image").put("url",def.prefix()+"current.jpg.br");bad(()->Protocol.frame(compressed,top,def,now),"image sidecars are not JSON");
        JSONObject corrupt=clone(top);corrupt.getJSONObject("files").getJSONObject(def.device).put("sha256",String.join("",Collections.nCopies(64,"0")));bad(()->Protocol.frame(state,corrupt,def,now),"atomic publication race");
        JSONObject slot=clone(state);slot.getJSONObject("inputs").getJSONObject("derived").put("life_slot",1.5);bad(()->Protocol.frame(slot,top,def,now),"fractional life slot");
        Protocol.Theme weather=choices.stream().filter(t->t.id.equals("chip-n-dale-weather")).findFirst().get();ok(weather.kind.equals("weather")&&weather.device.equals("display"),"weather 16:9 selected");
        JSONObject real=read(data.resolve("weather-real.json")),forecast=read(data.resolve("forecast-real.json"));long weatherNow=Protocol.time(forecast.getString("generated_at"))+1000;
        Protocol.Frame wf=Sources.weather(real,forecast,weather,"real",weatherNow);ok(wf.kind.equals("weather")&&wf.width==3840&&wf.height==2160&&wf.sourceId.equals("real"),"ready weather interval from existing API");ok(Protocol.savedFrame(wf.json()).kind.equals("weather"),"weather cache roundtrip");
        JSONObject changedWorld=clone(forecast);changedWorld.put("location_revision","changed");bad(()->Sources.weather(real,changedWorld,weather,"real",weatherNow),"different source revision rejected");
        JSONObject world=read(data.resolve("weather-world.json")),worldForecast=read(data.resolve("forecast-world.json"));Protocol.Frame worldFrame=Sources.weather(world,worldForecast,weather,"game-world",Protocol.time(worldForecast.getString("generated_at"))+1000);ok(worldFrame.sourceId.equals("game-world")&&!worldFrame.sha.equals(wf.sha),"game-world uses own server interval");
        Protocol.Theme plain=choices.stream().filter(t->t.id.equals("194x-under-the-wing")).findFirst().get();Protocol.Frame plainFrame=Sources.ordinary(read(data.resolve("live-manifest-v3.json")),plain,"monthly",java.time.OffsetDateTime.parse("2026-11-04T12:00:00+03:00").toInstant().toEpochMilli());ok(plainFrame.width==3840&&plainFrame.height==2160&&plainFrame.url.contains("month-11"),"ordinary monthly schedule and TV rendition");ok(Protocol.savedFrame(plainFrame.json()).kind.equals("plain"),"ordinary cache roundtrip permits numeric-start collection id");
        HoldGate gate=new HoldGate();gate.down(100);ok(!gate.trigger(1099),"short OK does not open");gate.release();ok(!gate.trigger(2000),"release cancels");gate.down(3000);gate.down(3500);ok(gate.trigger(4000),"one second opens; repeats do not reset");ok(!gate.trigger(5000),"hold opens only once");ok(gate.pressed(),"opening key remains consumed until UP");gate.release();ok(!gate.pressed(),"UP releases suppression");
        JSONObject release=new JSONObject().put("schema",1).put("app_id","ru.oopssre.imperialschool.viewstv").put("platform","android").put("release",new JSONObject().put("version","0.1.1").put("build",2).put("url",Protocol.BASE+"downloads/tv-0.1.1.apk").put("bytes",123).put("sha256",String.join("",Collections.nCopies(64,"a"))));ok(Release.parse(release,"ru.oopssre.imperialschool.viewstv").build==2,"same release envelope as Android client");
        JSONObject wrong=clone(release);wrong.put("app_id","ru.oopssre.imperialschool.views");bad(()->Release.parse(wrong,"ru.oopssre.imperialschool.viewstv"),"phone APK rejected");
        JSONObject floatBuild=clone(release);floatBuild.getJSONObject("release").put("build",2.5);bad(()->Release.parse(floatBuild,"ru.oopssre.imperialschool.viewstv"),"fractional build rejected");
        JSONObject zip=clone(release);zip.getJSONObject("release").put("url",Protocol.BASE+"downloads/source.zip");bad(()->Release.parse(zip,"ru.oopssre.imperialschool.viewstv"),"archives rejected by updater");
        JSONObject relative=clone(release);relative.getJSONObject("release").put("url","downloads/tv.apk");bad(()->Release.parse(relative,"ru.oopssre.imperialschool.viewstv"),"APK endpoint follows existing absolute-URL contract");
        Path temp=Files.createTempDirectory("tv-cache-test");CacheStore cache=new CacheStore(temp.toFile());String a=String.join("",Collections.nCopies(64,"a")),b=String.join("",Collections.nCopies(64,"b"));try(RandomAccessFile one=new RandomAccessFile(cache.image(a),"rw");RandomAccessFile two=new RandomAccessFile(cache.image(b),"rw")){one.setLength(20L*1024*1024);two.setLength(20L*1024*1024);}cache.reserve(32L*1024*1024,a);ok(cache.image(a).isFile()&&!cache.image(b).exists(),"current image protected during LRU eviction");ok(cache.root.getUsableSpace()>=32L*1024*1024,"actual disk has room for incoming bytes");
        File atomic=temp.resolve("atomic.json").toFile();CacheStore.atomic(atomic,"old".getBytes(StandardCharsets.UTF_8));CacheStore.atomic(atomic,"new".getBytes(StandardCharsets.UTF_8));ok(new String(CacheStore.read(atomic,10),StandardCharsets.UTF_8).equals("new"),"atomic replacement");
        try(java.util.stream.Stream<Path> walk=Files.walk(temp)){walk.sorted(Comparator.reverseOrder()).forEach(x->{try{Files.delete(x);}catch(Exception ignored){}});}
        System.out.println("PASSED "+checks+" core checks: default, protocol, release, long OK, publication race, cache bounds and atomic replacement");
    }
}
