package ru.oopssre.imperialschool.viewstv;

import org.json.*;
import java.nio.file.*;
import java.nio.charset.StandardCharsets;
import java.io.*;
import java.util.*;

/** Regressions for PNG identity, mixed publications, visible collection kinds and disposable cache. */
public final class RegressionTests {
    static int checks;
    interface Work {void run()throws Exception;}
    static void ok(boolean test,String name){checks++;if(!test)throw new AssertionError(name);}
    static void bad(Work work,String name)throws Exception {checks++;try{work.run();}catch(IllegalArgumentException|JSONException expected){return;}throw new AssertionError(name);}
    static JSONObject copy(JSONObject j)throws JSONException {return new JSONObject(j.toString());}
    static JSONObject json(Path p)throws Exception {return new JSONObject(new String(Files.readAllBytes(p),StandardCharsets.UTF_8));}
    public static void main(String[] args)throws Exception {
        Path resources=Paths.get(args[0]);Protocol.Theme theme=Protocol.defaultTheme();
        JSONObject originalTop=json(resources.resolve("orbital-top.json")),originalState=json(resources.resolve("orbital-state.json"));long now=Protocol.time(originalState.getString("at"))+1000;
        Protocol.Frame jpg=Protocol.frame(originalState,originalTop,theme,now);
        JSONObject legacy=jpg.json();legacy.remove("format");ok(Protocol.savedFrame(legacy).format.equals("jpg"),"previous JPEG cache remains readable");
        String pngSHA=String.join("",Collections.nCopies(64,"c"));
        JSONObject state=copy(originalState),top=copy(originalTop),image=state.getJSONObject("image");
        image.put("format","png").put("url",theme.prefix()+"current.png").put("sha256",pngSHA).put("bytes",7345123);
        state.put("compatibility_image",copy(originalState.getJSONObject("image")));
        top.getJSONObject("files").put(theme.device,copy(image).put("compatibility_image",copy(originalState.getJSONObject("image"))));
        Protocol.Frame png=Protocol.frame(state,top,theme,now);
        ok(png.format.equals("png")&&png.sha.equals(pngSHA)&&png.url.endsWith(".png"),"PNG master uses its own metadata");
        ok(Protocol.savedFrame(png.json()).format.equals("png"),"PNG persists through snapshot restart");
        bad(()->Protocol.frame(state,originalTop,theme,now),"previous JPEG top cannot validate a new PNG state");
        JSONObject mismatch=copy(state);mismatch.getJSONObject("image").put("url",theme.prefix()+"current.jpg");bad(()->Protocol.frame(mismatch,top,theme,now),"PNG metadata cannot point at JPEG URL");
        JSONObject mismatchTop=copy(top);mismatchTop.getJSONObject("files").getJSONObject(theme.device).put("bytes",1);bad(()->Protocol.frame(state,mismatchTop,theme,now),"inconsistent PNG sizes are retried");
        JSONObject mismatchDimensions=copy(top);mismatchDimensions.getJSONObject("files").getJSONObject(theme.device).put("width",1920);bad(()->Protocol.frame(state,mismatchDimensions,theme,now),"inconsistent PNG dimensions are retried");
        JSONObject renamed=png.json().put("format","jpg");bad(()->Protocol.savedFrame(renamed),"cached encoding mismatch is rejected");
        JSONObject gif=copy(state);gif.getJSONObject("image").put("format","gif");bad(()->Protocol.frame(gif,top,theme,now),"unsupported encodings are rejected");
        ok(ImageFormat.canonical("jpeg").equals("jpg")&&ImageFormat.canonical("PNG").equals("png"),"legacy JPEG spelling and PNG normalization");
        JSONObject video=new JSONObject().put("url",theme.prefix()+"video/"+pngSHA+".mp4").put("sha256",pngSHA).put("bytes",1000).put("format","mp4").put("codec","hevc").put("profile","main").put("pixel_format","yuv420p").put("duration_ms",4000).put("fps",24).put("width",3840).put("height",2160).put("audio",false).put("source_image_sha256",pngSHA);
        JSONObject withVideo=copy(state).put("video",video);ok(VideoInfo.parse(withVideo,png).frame.format.equals("png"),"4K MP4 is linked to the PNG source digest");
        JSONObject wrongVideo=copy(withVideo);wrongVideo.getJSONObject("video").put("source_image_sha256",jpg.sha);bad(()->VideoInfo.parse(wrongVideo,png),"JPEG alternative digest cannot validate PNG-derived MP4");
        List<Protocol.Theme> before=Protocol.catalogue(json(resources.resolve("live-manifest-v3.json")));
        JSONObject broken=json(resources.resolve("live-manifest-v3.json"));broken.getJSONArray("collections").put(new JSONObject().put("id","broken").put("title","Broken").put("type","weather"));broken.getJSONArray("collections").put("not an object");
        List<Protocol.Theme> after=Protocol.catalogue(broken);ok(before.size()==after.size(),"one malformed collection does not hide all other collections");
        for(String kind:new String[]{"dynamic","weather","plain"})ok(after.stream().anyMatch(t->t.kind.equals(kind)),"catalogue retains "+kind);
        ok(PlaybackPolicy.useVideo(true,"dynamic"),"preferred video is used for dynamic scenes");
        ok(!PlaybackPolicy.useVideo(true,"weather")&&!PlaybackPolicy.useVideo(true,"plain"),"video preference does not block weather and ordinary pictures");
        ok(!PlaybackPolicy.useVideo(false,"dynamic")&&PlaybackPolicy.useVideo(true,"dynamic"),"returning to dynamic preserves the video preference");
        ok(Sources.pictureURL("collections/art/files/frame.png","art"),"ordinary PNG URL accepted");
        ok(Sources.pictureURL("collections/art/files/frame.jpg","art"),"ordinary JPEG URL retained");
        ok(!Sources.pictureURL("collections/art/files/frame.gif","art"),"ordinary unsupported URL rejected");
        JSONObject file=copy(image).put("url","collections/art/files/frame.png");Protocol.Theme plain=new Protocol.Theme("art","Art","plain","",3840,2160,new JSONObject().put("type","plain"));
        ok(Sources.pictureFrame(file,plain,"Art",now,now+3600000).format.equals("png"),"ordinary PNG frame accepted");
        JSONObject weatherCatalogue=json(resources.resolve("live-manifest-v3.json"));Protocol.Theme weather=Protocol.catalogue(weatherCatalogue).stream().filter(t->t.id.equals("chip-n-dale-weather")).findFirst().get();
        JSONObject current=json(resources.resolve("weather-real.json")),forecast=json(resources.resolve("forecast-real.json"));long weatherNow=Protocol.time(forecast.getString("generated_at"))+1000;
        JSONArray intervals=forecast.getJSONArray("intervals");for(int i=0;i<intervals.length();i++){JSONObject f=intervals.getJSONObject(i).optJSONObject("file");if(f!=null){f.put("format","png");f.put("url",f.getString("url").replaceAll("\\.jpg$",".png"));}}
        ok(Sources.weather(current,forecast,weather,"real",weatherNow).format.equals("png"),"weather PNG accepted under its existing forecast contract");
        JSONObject actualCatalogue=json(resources.resolve("catalogue-20261106.json"));List<Protocol.Theme> actualChoices=Protocol.catalogue(actualCatalogue);
        ok(actualChoices.size()==9,"current published catalogue exposes all nine TV collections");
        for(Protocol.Theme actual:actualChoices){
            if(actual.kind.equals("weather")){
                JSONObject currentWeather=json(resources.resolve(actual.id+"-current.json")),forecastWeather=json(resources.resolve(actual.id+"-forecast.json"));
                long at=Protocol.time(forecastWeather.getString("generated_at"))+1000;
                ok(Sources.weather(currentWeather,forecastWeather,actual,"real",at).kind.equals("weather"),"published weather contract: "+actual.id);
            }else if(actual.kind.equals("plain")){
                long at=Protocol.time("2026-11-06T16:02:00+03:00");ok(Sources.ordinary(actualCatalogue,actual,"auto",at).kind.equals("plain"),"published ordinary schedule: "+actual.id);
            }
        }
        JSONObject actualState=json(resources.resolve("live-orbital-state.json")),actualTop=json(resources.resolve("live-orbital-top.json"));
        ok(Protocol.frame(actualState,actualTop,theme,Protocol.time(actualState.getString("at"))+1000).width==3840,"current server image publication remains compatible");
        Path temp=Files.createTempDirectory("tv-png-cache-");try{
            File appCache=temp.resolve("cache").toFile();CacheStore cache=new CacheStore(appCache);
            byte[] bytes=Files.readAllBytes(resources.resolve("png-regression.png"));String digest=CacheStore.hash(bytes);
            Protocol.Frame small=new Protocol.Frame("art","plain","Art","collections/art/files/frame.png",digest,pngSHA,8,8,bytes.length,now,now+3600000);small.kind="plain";
            CacheStore.atomic(cache.image(small),bytes);cache.save(small);
            ok(cache.image(small).getName().endsWith(".png")&&ImageFormat.signature(cache.image(small),"png"),"PNG stays PNG in private cache");
            ok(!ImageFormat.signature(cache.image(small),"jpg"),"JPEG declaration rejects PNG file signature");
            Protocol.Theme cachedTheme=new Protocol.Theme("art","Art","plain","",8,8,new JSONObject().put("type","plain"));ok(cache.cached(cachedTheme)!=null&&cache.valid(small),"PNG cache restored with digest verification");
            String other=String.join("",Collections.nCopies(64,"e"));File wrong=temp.resolve("wrong.png").toFile();Files.write(wrong.toPath(),new byte[]{(byte)255,(byte)216,(byte)255,0,0,0,0,0});ok(!ImageFormat.signature(wrong,"png"),"renamed JPEG cannot pass PNG header check");
            File update=temp.resolve("cache/tv-update/update.apk").toFile();update.getParentFile().mkdirs();Files.write(update.toPath(),new byte[1024]);Path preferences=temp.resolve("shared_prefs/tv.xml");Files.createDirectories(preferences.getParent());Files.write(preferences,"unchanged preferences".getBytes(StandardCharsets.UTF_8));
            ok(CacheStore.directoryBytes(appCache)==cache.bytes()+1024,"app cache total includes wallpaper metadata and update APK");
            cache.pinVideo(other);boolean refused=false;try{CacheStore.clearDirectory(appCache);}catch(IOException expected){refused=true;}finally{cache.unpinVideo(other);}ok(refused&&cache.valid(small),"active video pins prevent unsafe deletion");
            CacheStore.clearDirectory(appCache);ok(appCache.isDirectory()&&CacheStore.directoryBytes(appCache)==0,"clear removes pictures, JSON, partials and update files");
            ok(new String(Files.readAllBytes(preferences),StandardCharsets.UTF_8).equals("unchanged preferences"),"clear preserves preferences outside app cache");
            cache.recreate();ok(cache.images.isDirectory()&&cache.json.isDirectory()&&cache.videos.isDirectory(),"cache directories are ready for the next download");
            ok(cache.cached(cachedTheme)==null,"cleared snapshots do not masquerade as current images");
            File pinned=cache.image(small),evict=cache.image(other);try(RandomAccessFile a=new RandomAccessFile(pinned,"rw");RandomAccessFile b=new RandomAccessFile(evict,"rw")){a.setLength(20L*1024*1024);b.setLength(20L*1024*1024);}cache.reserve(32L*1024*1024,digest);ok(pinned.isFile()&&!evict.exists(),"current PNG is protected during normal cache eviction");
        }finally{CacheStore.clearDirectory(temp.toFile());Files.delete(temp);}
        System.out.println("PASSED "+checks+" PNG / catalogue / output / cache-clear regression checks");
    }
}
