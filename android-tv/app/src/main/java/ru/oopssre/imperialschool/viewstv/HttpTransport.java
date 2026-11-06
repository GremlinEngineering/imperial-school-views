package ru.oopssre.imperialschool.viewstv;

import java.io.*;
import java.net.*;
import java.nio.charset.StandardCharsets;
import java.nio.file.*;
import java.util.*;
import java.util.zip.GZIPInputStream;
import org.brotli.dec.BrotliInputStream;
import org.json.*;

public final class HttpTransport {
    final CacheStore cache;
    public HttpTransport(CacheStore c){cache=c;}
    public static class HttpFailure extends IOException {public final int status;HttpFailure(int code){super(code==404?"Файл ещё не опубликован на сервере":"Сервер недоступен (HTTP "+code+")");status=code;}}
    static HttpURLConnection connect(URI uri,boolean json)throws IOException {HttpURLConnection c=(HttpURLConnection)uri.toURL().openConnection();c.setConnectTimeout(8000);c.setReadTimeout(12000);c.setInstanceFollowRedirects(false);c.setUseCaches(false);c.setRequestProperty("User-Agent","ImperialSchoolViewsTV/"+BuildInfo.VERSION);c.setRequestProperty("Accept-Encoding",json?"br, gzip":"identity");if(json)c.setRequestProperty("Accept","application/json");return c;}
    public JSONObject json(String path,boolean force,String pinned)throws IOException,JSONException {
        URI uri=Protocol.url(path);String key=CacheStore.hash(uri.toString().getBytes(StandardCharsets.UTF_8));File body=new File(cache.json,key+".body"),meta=new File(cache.json,key+".meta");JSONObject prior=null;try{prior=new JSONObject(new String(CacheStore.read(meta,10000),StandardCharsets.UTF_8));}catch(Exception ignored){}
        for(int attempt=0;attempt<4;attempt++){
            HttpURLConnection c=connect(uri,true);
            if(!force&&prior!=null&&body.isFile()){String etag=prior.optString("etag");if(!etag.isEmpty())c.setRequestProperty("If-None-Match",etag);String modified=prior.optString("modified");if(!modified.isEmpty())c.setRequestProperty("If-Modified-Since",modified);}
            if(force)c.setRequestProperty("Cache-Control","no-cache");
            try{
                int status=c.getResponseCode();if(status==304){JSONObject result=new JSONObject(new String(CacheStore.read(body,5*1024*1024),StandardCharsets.UTF_8));body.setLastModified(System.currentTimeMillis());return result;}
                if(status>=300&&status<400){String location=c.getHeaderField("Location");if(location==null)throw new IOException("Нет адреса перенаправления");uri=Protocol.url(uri.resolve(location).toString());continue;}
                if(status!=200)throw new HttpFailure(status);
                if(c.getContentLengthLong()>5*1024*1024)throw new IOException("Описание слишком большое");
                byte[] bytes;try(InputStream in=c.getInputStream()){bytes=CacheStore.bounded(in,5*1024*1024);}
                String encoding=c.getHeaderField("Content-Encoding");List<String> layers=new ArrayList<>();if(encoding!=null)for(String item:encoding.split(",")){String e=item.trim().toLowerCase(Locale.ROOT);if(!e.isEmpty()&&!e.equals("identity"))layers.add(e);}
                if(layers.size()>2)throw new IOException("Неизвестное сжатие описания");boolean directBr=uri.getPath().endsWith(".json.br")&&!layers.contains("br");Collections.reverse(layers);if(directBr)layers.add("br");
                for(String layer:layers){InputStream decoded;if(layer.equals("br"))decoded=new BrotliInputStream(new ByteArrayInputStream(bytes));else if(layer.equals("gzip"))decoded=new GZIPInputStream(new ByteArrayInputStream(bytes));else throw new IOException("Неизвестное сжатие описания");try(InputStream in=decoded){bytes=CacheStore.bounded(in,5*1024*1024);}}
                JSONObject result=new JSONObject(new String(bytes,StandardCharsets.UTF_8));
                pruneJson(key);cache.reserve(bytes.length+10000,pinned);CacheStore.atomic(body,bytes);
                JSONObject info=new JSONObject().put("etag",Objects.toString(c.getHeaderField("ETag"),"")).put("modified",Objects.toString(c.getHeaderField("Last-Modified"),""));CacheStore.atomic(meta,info.toString().getBytes(StandardCharsets.UTF_8));return result;
            }finally{c.disconnect();}
        }throw new IOException("Слишком много перенаправлений");
    }
    void pruneJson(String keep){File[] fs=cache.json.listFiles();if(fs==null)return;List<File> rows=new ArrayList<>(Arrays.asList(fs));rows.sort(Comparator.comparingLong(File::lastModified));long bytes=0;for(File f:rows)bytes+=f.length();for(File f:rows){if(bytes<2*1024*1024&&rows.size()<100)break;if(f.getName().startsWith(keep))continue;long n=f.length();if(f.delete())bytes-=n;}}
    public File image(Protocol.Frame frame,String pinned)throws IOException {
        File target=cache.image(frame);if(cache.valid(frame))return target;cache.reserve(frame.bytes,pinned);
        File part=File.createTempFile("frame-",".part",cache.images);try{
            download(frame.url,part,frame.bytes,Protocol.MAX_IMAGE);
            if(part.length()!=frame.bytes||!CacheStore.sha(part).equals(frame.sha)||!ImageFormat.signature(part,frame.format))throw new IOException("Кадр изменился при загрузке или повреждён");
            Files.move(part.toPath(),target.toPath(),StandardCopyOption.ATOMIC_MOVE,StandardCopyOption.REPLACE_EXISTING);return target;
        }finally{part.delete();}
    }
    public File video(VideoInfo info,String pinned)throws IOException {
        File target=cache.video(info.sha);if(cache.valid(info))return target;cache.reserve(info.bytes,pinned);
        File part=File.createTempFile("video-",".part",cache.videos);try{
            download(info.url,part,info.bytes,VideoInfo.MAX_BYTES);
            if(part.length()!=info.bytes||!CacheStore.sha(part).equals(info.sha))throw new IOException("Видео изменилось при загрузке или повреждено");
            Files.move(part.toPath(),target.toPath(),StandardCopyOption.ATOMIC_MOVE,StandardCopyOption.REPLACE_EXISTING);return target;
        }finally{part.delete();}
    }
    public static void download(String path,File target,long expected,long max)throws IOException {
        URI uri=Protocol.url(path);
        for(int attempt=0;attempt<4;attempt++){HttpURLConnection c=connect(uri,false);try{
            int status=c.getResponseCode();if(status>=300&&status<400){String location=c.getHeaderField("Location");if(location==null)throw new IOException("Нет адреса перенаправления");uri=Protocol.url(uri.resolve(location).toString());continue;}
            if(status!=200)throw new HttpFailure(status);long length=c.getContentLengthLong();if(length>max||length>=0&&length!=expected)throw new IOException("Неверный размер файла");
            long total=0,start=System.nanoTime();try(InputStream in=c.getInputStream();FileOutputStream out=new FileOutputStream(target)){byte[] b=new byte[32768];for(int n;(n=in.read(b))!=-1;){if(Thread.currentThread().isInterrupted())throw new InterruptedIOException();if(System.nanoTime()-start>120000000000L)throw new IOException("Загрузка заняла слишком много времени");total+=n;if(total>max||total>expected)throw new IOException("Файл слишком большой");out.write(b,0,n);}out.getFD().sync();}if(total!=expected)throw new IOException("Файл загружен не полностью");return;
        }finally{c.disconnect();}}throw new IOException("Слишком много перенаправлений");
    }
}
