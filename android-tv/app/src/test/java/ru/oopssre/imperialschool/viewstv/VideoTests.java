package ru.oopssre.imperialschool.viewstv;

import java.io.*;
import java.net.*;
import java.nio.charset.StandardCharsets;
import java.nio.file.*;
import java.time.Instant;
import java.util.*;
import org.json.*;

/** Exercises the actual loader/transport with an in-process HTTPS handler; no public server. */
public final class VideoTests {
    static int checks;interface Work{void run()throws Exception;}
    static void ok(boolean b,String label){checks++;if(!b)throw new AssertionError(label);}
    static void bad(Work w,String label)throws Exception {checks++;try{w.run();}catch(IllegalArgumentException|JSONException|IOException e){return;}throw new AssertionError(label);}
    static JSONObject copy(JSONObject j)throws Exception{return new JSONObject(j.toString());}
    static String hash(char c){char[] a=new char[64];Arrays.fill(a,c);return new String(a);}
    static byte[] bytes(String s){return s.getBytes(StandardCharsets.UTF_8);}
    static final String THEME="future-dynamic-theme",DEVICE=Protocol.DEFAULT_DEVICE;
    static String prefix(){return "dynamic/"+THEME+"/devices/"+DEVICE+"/";}
    static JSONObject stateTemplate,top;
    static JSONObject video(byte[] payload,String image)throws Exception {String sha=CacheStore.hash(payload);return new JSONObject().put("url",prefix()+"video/"+sha+".mp4").put("format","mp4").put("codec","hevc").put("profile","main").put("pixel_format","yuv420p").put("width",3840).put("height",2160).put("fps",24).put("duration_ms",4000).put("audio",false).put("bytes",payload.length).put("sha256",sha).put("source_image_sha256",image);}
    static JSONObject state(byte[] payload,long ago)throws Exception {JSONObject s=copy(stateTemplate);String at=Instant.now().minusSeconds(ago).toString();s.put("at",at).put("valid_until",Instant.parse(at).plusSeconds(3600).toString());s.getJSONObject("inputs").put("at",at);s.put("video",video(payload,s.getJSONObject("image").getString("sha256")));return s;}
    interface Router {Response request(URL u,Map<String,String> headers)throws Exception;}
    static Router router;
    static final class Response {int status;byte[] body;String etag;boolean interrupt;Response(int s,byte[] b){status=s;body=b;}}
    static Response json(JSONObject j,String etag)throws Exception {Response r=new Response(200,bytes(j.toString()));r.etag=etag;return r;}
    static final class Fake extends HttpURLConnection {
        final Map<String,String> headers=new HashMap<>();Response response;
        Fake(URL u){super(u);}
        public void setRequestProperty(String k,String v){headers.put(k,v);}
        Response r()throws IOException {if(response==null)try{response=router.request(url,headers);}catch(Exception e){throw new IOException(e);}return response;}
        public int getResponseCode()throws IOException{return r().status;}
        public long getContentLengthLong(){try{return r().body.length;}catch(Exception e){return -1;}}
        public String getHeaderField(String k){try{return k.equalsIgnoreCase("ETag")?r().etag:null;}catch(Exception e){return null;}}
        public InputStream getInputStream()throws IOException {Response r=r();if(!r.interrupt)return new ByteArrayInputStream(r.body);return new InputStream(){final ByteArrayInputStream source=new ByteArrayInputStream(r.body);boolean once;public int read()throws IOException{if(once)throw new IOException("interrupted transfer");once=true;return source.read();}public int read(byte[] b,int off,int len)throws IOException{if(once)throw new IOException("interrupted transfer");once=true;return source.read(b,off,Math.min(2,len));}};}
        public void connect(){}public void disconnect(){}public boolean usingProxy(){return false;}
    }
    public static void main(String[] args)throws Exception {
        URL.setURLStreamHandlerFactory(s->s.equals("https")?new URLStreamHandler(){protected URLConnection openConnection(URL u){return new Fake(u);}}:null);
        Path fixtures=Paths.get(args[0]);stateTemplate=new JSONObject(Files.readString(fixtures.resolve("orbital-state.json")));
        stateTemplate.put("theme_id",THEME);stateTemplate.getJSONObject("recipe").put("theme_id",THEME);stateTemplate.getJSONObject("image").put("url",prefix()+"current.jpg");
        top=new JSONObject().put("schema",1).put("type","dynamic").put("collection_id",THEME).put("formats",new JSONObject().put(DEVICE,new JSONObject().put("width",3840).put("height",2160))).put("format_status",new JSONObject().put(DEVICE,new JSONObject().put("status","ready"))).put("states",new JSONObject().put(DEVICE,prefix()+"current.json")).put("files",new JSONObject().put(DEVICE,stateTemplate.getJSONObject("image")));
        JSONObject descriptor=new JSONObject().put("type","dynamic").put("id",THEME).put("title","Unknown future theme").put("current_url","dynamic/"+THEME+"/current.json").put("formats",top.getJSONObject("formats"));
        Protocol.Theme theme=Protocol.theme(descriptor),selected=Protocol.publishedVideo(top,theme);
        ok(selected.device.equals(DEVICE)&&selected.width==3840&&selected.height==2160,"unknown theme selected by standard profile");
        JSONObject noProfile=copy(top);noProfile.getJSONObject("formats").remove(DEVICE);bad(()->Protocol.publishedVideo(noProfile,theme),"missing profile stays pending");
        JSONObject wrong=copy(top);wrong.getJSONObject("formats").getJSONObject(DEVICE).put("height",2400);bad(()->Protocol.publishedVideo(wrong,theme),"wrong 4K geometry rejected");
        byte[] a=bytes("fake complete compressed media A"),b=bytes("fake complete compressed media B");JSONObject s=state(a,7200);
        Protocol.Frame f=Protocol.frame(s,top,selected,System.currentTimeMillis());VideoInfo v=VideoInfo.parse(s,f);
        ok(v.sha.equals(CacheStore.hash(a))&&VideoInfo.saved(v.json()).sameMedia(v),"video metadata/cache roundtrip");
        JSONObject changed=copy(s);changed.getJSONObject("video").put("source_image_sha256",hash('d'));bad(()->VideoInfo.parse(changed,f),"video must belong to current JPEG");
        for(String[] change:new String[][]{{"url","https://evil.example/a.mp4"},{"codec","avc"},{"profile","main10"},{"pixel_format","yuv420p10le"},{"sha256",hash('e')}}){JSONObject q=copy(s);q.getJSONObject("video").put(change[0],change[1]);bad(()->VideoInfo.parse(q,f),"reject unsupported or foreign video "+change[0]);}
        for(Object audio:new Object[]{true,0,"false"}){JSONObject q=copy(s);q.getJSONObject("video").put("audio",audio);bad(()->VideoInfo.parse(q,f),"audio must be boolean false");}
        JSONObject huge=copy(s);huge.getJSONObject("video").put("bytes",VideoInfo.MAX_BYTES+1);bad(()->VideoInfo.parse(huge,f),"bounded video size");
        JSONObject fractional=copy(s);fractional.getJSONObject("video").put("fps",24.5);bad(()->VideoInfo.parse(fractional,f),"fractional fps rejected");
        JSONObject absent=copy(s);absent.remove("video");bad(()->VideoInfo.parse(absent,f),"optional video may be pending");ok(Protocol.frame(absent,top,selected,System.currentTimeMillis()).sha.equals(f.sha),"JPEG remains valid without video");
        JSONObject invalidVideo=copy(s);invalidVideo.getJSONObject("video").put("codec","broken");ok(Protocol.frame(invalidVideo,top,selected,System.currentTimeMillis()).sha.equals(f.sha),"JPEG parser independent of optional bad video");
        ok(!f.stale(f.at+7199999)&&f.stale(f.at+7200000),"one-hour frame becomes stale after exactly two hours");
        Set<Long> delays=new HashSet<>();for(int i=0;i<256;i++){long d=VideoPolicy.nextDelay();if(d<600000||d>1200000)throw new AssertionError("poll outside 10-20 minutes");delays.add(d);}ok(delays.size()>1,"poll intervals random per request");ok(VideoPolicy.retryDelay(1)==60000&&VideoPolicy.retryDelay(2)==120000&&VideoPolicy.retryDelay(8)==300000,"existing bounded retry cadence");
        Path dir=Files.createTempDirectory("tv-video-test-");CacheStore cache=new CacheStore(dir.toFile());VideoLoader loader=new VideoLoader(new HttpTransport(cache),cache);
        JSONObject old=state(a,7200),fresh=state(b,3600);int[] counts={0,0,0};
        router=(url,h)->{String path=url.getPath();if(path.endsWith(".mp4")){counts[0]++;if(counts[0]==1)return new Response(404,new byte[0]);return new Response(200,b);}counts[1]++;if(counts[0]>0&&"no-cache".equals(h.get("Cache-Control")))counts[2]++;return json(path.equals("/assets/arcade/views/dynamic/"+THEME+"/current.json")?top:counts[0]==0?old:fresh,"v2");};
        VideoInfo loaded;try(VideoLoader.Loaded result=loader.load(theme)){loaded=result.info;ok(Arrays.equals(Files.readAllBytes(result.file.toPath()),b),"retry downloaded complete new media");cache.saveVideo(loaded);}
        ok(counts[0]==2&&counts[1]==4&&counts[2]==2,"404 causes fresh top and state JSON, then new MP4 URL");
        int before=counts[0];router=(url,h)->{if(url.getPath().endsWith(".mp4")){counts[0]++;return new Response(200,b);}if("v2".equals(h.get("If-None-Match")))return new Response(304,new byte[0]);return json(url.getPath().endsWith("/devices/"+DEVICE+"/current.json")?fresh:top,"v2");};
        try(VideoLoader.Loaded same=loader.load(theme)){ok(same.info.sameMedia(loaded),"same media identified after conditional metadata request");}ok(counts[0]==before,"same SHA does not download MP4 again");
        JSONObject newer=state(b,30);router=(url,h)->json(url.getPath().endsWith("/devices/"+DEVICE+"/current.json")?newer:top,"v3");
        try(VideoLoader.Loaded same=loader.load(theme)){ok(same.info.sameMedia(loaded)&&same.info.frame.at>loaded.frame.at,"fresh timestamps accepted without new media");}
        JSONObject badState=state(a,30);byte[] broken=a.clone();broken[0]^=1;int[] retries={0};router=(url,h)->{if(url.getPath().endsWith(".mp4")){retries[0]++;return new Response(200,broken);}return json(url.getPath().endsWith("/devices/"+DEVICE+"/current.json")?badState:top,"bad");};
        bad(()->loader.load(theme),"wrong SHA rejected after retry");ok(retries[0]==2&&!cache.video(CacheStore.hash(a)).exists(),"corrupt file never replaces complete cache media");ok(cache.cachedVideo(theme).sameMedia(loaded),"last successful snapshot retained on failure");
        router=(url,h)->{if(url.getPath().endsWith(".mp4")){Response r=new Response(200,a);r.interrupt=true;return r;}return json(url.getPath().endsWith("/devices/"+DEVICE+"/current.json")?badState:top,"interrupted");};
        bad(()->loader.load(theme),"interrupted download rejected");ok(Arrays.stream(cache.videos.listFiles()).noneMatch(x->x.getName().endsWith(".part")),"partial downloads removed");
        router=(url,h)->url.getPath().endsWith(".mp4")?new Response(200,a):json(url.getPath().endsWith("/devices/"+DEVICE+"/current.json")?badState:top,"complete");try(VideoLoader.Loaded complete=loader.load(theme)){ok(Arrays.equals(Files.readAllBytes(complete.file.toPath()),a),"retry restarts complete media from byte zero");}
        String p=hash('1'),q=hash('2'),r=hash('3');cache.pinVideo(p);cache.pinVideo(p);cache.pinVideo(q);
        for(String sha:new String[]{p,q,r})try(RandomAccessFile file=new RandomAccessFile(cache.video(sha),"rw")){file.setLength(20L*1024*1024);}
        cache.unpinVideo(p);cache.reserve(8L*1024*1024,"");ok(cache.video(p).exists()&&cache.video(q).exists()&&!cache.video(r).exists(),"active and prepared media protected by reference-counted pins");ok(cache.root.getUsableSpace()>=8L*1024*1024,"actual disk reservation leaves active media intact");cache.unpinVideo(p);cache.unpinVideo(q);
        try(java.util.stream.Stream<Path> walk=Files.walk(dir)){walk.sorted(Comparator.reverseOrder()).forEach(path->{try{Files.delete(path);}catch(Exception ignored){}});}
        System.out.println("PASSED "+checks+" video checks: generic profile, metadata, random polling, two-hour freshness, fresh-JSON retry, cache integrity and pins");
    }
}
