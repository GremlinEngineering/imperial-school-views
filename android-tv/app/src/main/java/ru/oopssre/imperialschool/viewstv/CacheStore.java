package ru.oopssre.imperialschool.viewstv;

import java.io.*;
import java.nio.file.*;
import java.security.*;
import java.util.*;
import org.json.*;

/** Bounded, disposable private cache. There is no collection or ZIP storage. */
public final class CacheStore {
    public static final long MAX_BYTES=64L*1024*1024;
    private static final Object LOCK=new Object();
    private static final Map<String,Integer> VIDEO_PINS=new HashMap<>();
    public final File root,images,videos,json;
    public CacheStore(File parent){root=new File(parent,"imperial-tv");images=new File(root,"images");videos=new File(root,"videos");json=new File(root,"json");images.mkdirs();videos.mkdirs();json.mkdirs();cleanupParts();}
    public File video(String sha){Protocol.require(Protocol.hash(sha),"Неверный хеш видео");return new File(videos,sha+".mp4");}
    public void pinVideo(String sha){synchronized(LOCK){String key=video(sha).getAbsolutePath();VIDEO_PINS.put(key,VIDEO_PINS.getOrDefault(key,0)+1);}}
    public void unpinVideo(String sha){synchronized(LOCK){String key=video(sha).getAbsolutePath();int n=VIDEO_PINS.getOrDefault(key,0);if(n<=1)VIDEO_PINS.remove(key);else VIDEO_PINS.put(key,n-1);}}
    public boolean valid(VideoInfo info)throws IOException {File f=video(info.sha);return f.isFile()&&f.length()==info.bytes&&sha(f).equals(info.sha);}
    public void saveVideo(VideoInfo info)throws IOException,JSONException {synchronized(LOCK){atomic(new File(root,"video-state-"+info.frame.theme+"-"+info.frame.device+".json"),info.json().toString().getBytes(java.nio.charset.StandardCharsets.UTF_8));video(info.sha).setLastModified(System.currentTimeMillis());}}
    public VideoInfo cachedVideo(Protocol.Theme theme){synchronized(LOCK){try{VideoInfo v=VideoInfo.saved(new JSONObject(new String(read(new File(root,"video-state-"+theme.id+"-"+Protocol.DEFAULT_DEVICE+".json"),100000),java.nio.charset.StandardCharsets.UTF_8)));if(v.frame.theme.equals(theme.id)&&valid(v)){video(v.sha).setLastModified(System.currentTimeMillis());return v;}}catch(Exception ignored){}return null;}}
    static String hash(byte[] value){try{return hex(MessageDigest.getInstance("SHA-256").digest(value));}catch(Exception e){throw new IllegalStateException(e);}}
    static String hex(byte[] b){StringBuilder s=new StringBuilder();for(byte v:b)s.append(String.format(java.util.Locale.ROOT,"%02x",v&255));return s.toString();}
    public static String sha(File file)throws IOException {try{MessageDigest d=MessageDigest.getInstance("SHA-256");try(InputStream in=new FileInputStream(file)){byte[] b=new byte[65536];for(int n;(n=in.read(b))!=-1;)d.update(b,0,n);}return hex(d.digest());}catch(NoSuchAlgorithmException e){throw new IOException(e);}}
    public static void atomic(File target,byte[] bytes)throws IOException {target.getParentFile().mkdirs();File part=File.createTempFile("pending-",".part",target.getParentFile());try{try(FileOutputStream out=new FileOutputStream(part)){out.write(bytes);out.getFD().sync();}Files.move(part.toPath(),target.toPath(),StandardCopyOption.ATOMIC_MOVE,StandardCopyOption.REPLACE_EXISTING);}finally{part.delete();}}
    static byte[] bounded(InputStream in,long limit)throws IOException {ByteArrayOutputStream out=new ByteArrayOutputStream();byte[] b=new byte[32768];long size=0;for(int n;(n=in.read(b))!=-1;){if(Thread.currentThread().isInterrupted())throw new InterruptedIOException();size+=n;if(size>limit)throw new IOException("Ответ сервера слишком большой");out.write(b,0,n);}return out.toByteArray();}
    public static byte[] read(File file,long limit)throws IOException {if(!file.isFile()||file.length()>limit)throw new IOException("Нет исправного кеша");try(InputStream in=new FileInputStream(file)){return bounded(in,limit);}}
    public File image(String sha){Protocol.require(Protocol.hash(sha),"Неверный хеш");return new File(images,sha+".jpg");}
    public File image(Protocol.Frame frame){return new File(images,frame.sha+"."+frame.format);}
    public boolean valid(Protocol.Frame frame)throws IOException {File f=image(frame);return f.isFile()&&f.length()==frame.bytes&&sha(f).equals(frame.sha);}
    public Protocol.Frame cached(Protocol.Theme theme){synchronized(LOCK){try{Protocol.Frame f=Protocol.savedFrame(new JSONObject(new String(read(snapshot(theme.id,theme.device),100000),java.nio.charset.StandardCharsets.UTF_8)));if(f.theme.equals(theme.id)&&f.device.equals(theme.device)&&valid(f)){image(f).setLastModified(System.currentTimeMillis());return f;}}catch(Exception ignored){}return null;}}
    File snapshot(String theme,String device){Protocol.require(theme.matches("[a-z0-9][a-z0-9_-]{0,79}")&&Protocol.id(device),"Неверная область кеша");return new File(root,"state-"+theme+"-"+device+".json");}
    public void save(Protocol.Frame f)throws IOException,JSONException {synchronized(LOCK){atomic(snapshot(f.theme,f.device),f.json().toString().getBytes(java.nio.charset.StandardCharsets.UTF_8));image(f).setLastModified(System.currentTimeMillis());}}
    public long bytes(){synchronized(LOCK){long n=0;for(File folder:new File[]{root,images,videos,json}){File[] files=folder.listFiles();if(files!=null)for(File f:files)if(f.isFile())n+=f.length();}return n;}}
    public void reserve(long incoming,String pinned)throws IOException {synchronized(LOCK){long total=bytes();List<File> rows=new ArrayList<>();for(File folder:new File[]{images,videos})rows.addAll(Arrays.asList(Optional.ofNullable(folder.listFiles()).orElse(new File[0])));rows.sort(Comparator.comparingLong(File::lastModified));for(File file:rows){if(total+incoming<=MAX_BYTES)break;if((file.getName().equals(pinned+".jpg")||file.getName().equals(pinned+".png"))||VIDEO_PINS.containsKey(file.getAbsolutePath())||file.getName().endsWith(".part"))continue;long n=file.length();if(file.delete())total-=n;}if(total+incoming>MAX_BYTES)throw new IOException("Недостаточно места в кеше");}}
    public static long directoryBytes(File directory){
        if(!directory.exists())return 0;
        if(Files.isSymbolicLink(directory.toPath()))return 0;
        if(directory.isFile())return directory.length();
        long total=0;File[] rows=directory.listFiles();if(rows!=null)for(File row:rows)total+=directoryBytes(row);return total;
    }
    /** Call after stopping cache users and draining their workers. Preferences are outside this directory. */
    public static void clearDirectory(File directory)throws IOException {
        synchronized(LOCK){
            if(!VIDEO_PINS.isEmpty())throw new IOException("Кеш ещё используется. Повторите очистку.");
            if(!directory.isDirectory())return;
            final Path root=directory.toPath();
            Files.walkFileTree(root,new SimpleFileVisitor<Path>(){
                @Override public FileVisitResult visitFile(Path file,java.nio.file.attribute.BasicFileAttributes attributes)throws IOException {Files.delete(file);return FileVisitResult.CONTINUE;}
                @Override public FileVisitResult postVisitDirectory(Path dir,IOException error)throws IOException {if(error!=null)throw error;if(!dir.equals(root))Files.delete(dir);return FileVisitResult.CONTINUE;}
            });
        }
    }
    public void recreate(){images.mkdirs();videos.mkdirs();json.mkdirs();}
    void cleanupParts(){synchronized(LOCK){for(File folder:new File[]{root,images,videos,json}){File[] files=folder.listFiles();if(files!=null)for(File f:files)if(f.getName().endsWith(".part")&&f.lastModified()<System.currentTimeMillis()-3600000)f.delete();}}}
}
