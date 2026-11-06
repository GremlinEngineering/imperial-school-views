package ru.oopssre.imperialschool.viewstv;

import java.io.*;
import java.nio.file.*;
import java.util.*;
import org.json.*;

/** State graph and storage cases that cannot be covered by screenshots alone. */
public final class DesignTests {
    static int checks;
    static void ok(boolean value,String message){checks++;if(!value)throw new AssertionError(message);}
    static String sha(char c){char[] s=new char[64];Arrays.fill(s,c);return new String(s);}
    public static void main(String[] args)throws Exception {
        Map<String,String> parents=new LinkedHashMap<>();
        parents.put("themes","menu");parents.put("settings","menu");parents.put("music","menu");
        parents.put("screen","settings");parents.put("cache","settings");parents.put("info","settings");
        parents.put("collection","themes");parents.put("weather","collection");parents.put("mode","collection");
        parents.put("resolution","screen");parents.put("scale","screen");parents.put("output","screen");
        parents.put("updates","info");parents.put("diagnostics","info");parents.put("project","info");
        parents.put("music_credits","info");parents.put("credits_detail","music_credits");
        for(Map.Entry<String,String> entry:parents.entrySet()){
            ok(SceneCopy.parent(entry.getKey()).equals(entry.getValue()),"Back from "+entry.getKey());
            Set<String> visited=new HashSet<>();String current=entry.getKey();
            while(!current.equals("menu")){if(!visited.add(current))throw new AssertionError("Navigation cycle: "+entry.getKey());current=SceneCopy.parent(current);}
            ok(visited.size()<=4,"finite Back path from "+entry.getKey());
        }
        ok(SceneCopy.waiting("Нет кадра: Недостаточно места на телевизоре").contains("Хранилище"),"image disk failure offers a useful recovery destination");
        ok(SceneCopy.waiting("Видео не получено: Недостаточно места на телевизоре").contains("Хранилище"),"video disk failure not hidden as a network retry");
        ok(SceneCopy.waiting("Видео для текущего кадра ещё не опубликовано").contains("Видео этой сцены"),"missing clip does not say the entire wallpaper is absent");
        ok(SceneCopy.waiting("Ошибка видео: Нет аппаратного HEVC-декодера").contains("не поддерживает видео"),"hardware failure has an image-mode recovery");
        JSONObject catalogue=new JSONObject(new String(Files.readAllBytes(Paths.get(args[0],"catalogue-20261106.json")),java.nio.charset.StandardCharsets.UTF_8));
        for(Protocol.Theme theme:Protocol.catalogue(catalogue)){
            ok(!ThemeText.description(theme).isEmpty(),"description for "+theme.id);
            ok(ThemeText.description(theme).length()<=221,"concise preview copy for "+theme.id);
        }
        ok(ThemeText.title(Protocol.defaultTheme()).equals("Орбитальный порт"),"initial title agrees with project terminology");
        Protocol.Theme orbital=Protocol.catalogue(catalogue).stream().filter(t->t.id.equals("orbital-port")).findFirst().get();
        ok(ThemeText.title(orbital).equals("Орбитальный порт"),"redundant English subtitle removed using catalogue title_en");
        Path temp=Files.createTempDirectory("tv-retention-");
        try{
            CacheStore cache=new CacheStore(temp.toFile());
            for(int i=0;i<2;i++){
                String hash=sha((char)('a'+i));
                Protocol.Frame frame=new Protocol.Frame("art"+i,"plain","Art","collections/art"+i+"/files/frame.png",hash,hash,3840,2160,Protocol.MAX_IMAGE,1,2);frame.kind="plain";
                try(RandomAccessFile file=new RandomAccessFile(cache.image(frame),"rw")){file.setLength(Protocol.MAX_IMAGE);}
                cache.save(frame);
            }
            ok(cache.bytes()>64L*1024*1024,"two allowed maximum frames plus metadata exceed old 64 MiB cap");
            cache.reserve(Protocol.MAX_IMAGE,"");
            ok(cache.image(sha('a')).exists()==false&&new File(cache.images,sha('a')+".png").isFile()&&new File(cache.images,sha('b')+".png").isFile(),"latest collection snapshots survive incoming maximum-size reservation");
            File orphan=cache.image(sha('c'));Files.write(orphan.toPath(),new byte[]{1});cache.reserve(1,"");ok(!orphan.exists(),"superseded media reclaimed without a manual clear");
            File active=cache.image(sha('d'));Files.write(active.toPath(),new byte[]{1});cache.pinImage(sha('d'));cache.reserve(1,"");ok(active.exists(),"image decode pin survives preview and network reservations");cache.unpinImage(sha('d'));cache.reserve(1,"");ok(!active.exists(),"released orphan image is reclaimable");
            String video=sha('e');Files.write(cache.video(video).toPath(),new byte[]{1});cache.pinVideo(video);cache.reserve(VideoInfo.MAX_BYTES,"");ok(cache.video(video).exists(),"live video remains protected beside retained images");cache.unpinVideo(video);
        }finally{CacheStore.clearDirectory(temp.toFile());Files.delete(temp);}
        System.out.println("PASSED "+checks+" navigation / copy / retention checks");
    }
}
