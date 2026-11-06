package ru.oopssre.imperialschool.viewstv;

import android.content.Context;
import android.media.*;
import android.os.*;
import android.view.*;
import java.io.*;
import java.nio.ByteBuffer;
import java.util.Arrays;
import java.util.concurrent.*;
import java.util.concurrent.atomic.*;

/** Hardware HEVC output. Complete, checked cache files are prepared before offering them. */
final class VideoSurface extends SurfaceView implements SurfaceHolder.Callback {
    interface Listener {void changed();}
    static final class Clip implements AutoCloseable {
        final VideoInfo info;final File file;final MediaExtractor extractor;final MediaFormat format;
        final CacheStore cache;final long duration;final AtomicBoolean closed=new AtomicBoolean();
        Clip(VideoInfo i,File f,MediaExtractor e,MediaFormat m,CacheStore c){info=i;file=f;extractor=e;format=m;cache=c;duration=m.getLong(MediaFormat.KEY_DURATION);}
        void rewind()throws IOException {extractor.seekTo(0,MediaExtractor.SEEK_TO_CLOSEST_SYNC);if((extractor.getSampleFlags()&MediaExtractor.SAMPLE_FLAG_SYNC)==0||extractor.getSampleTime()!=0)throw new IOException("Видео должно начинаться с ключевого кадра на отметке 0");}
        public void close(){if(closed.compareAndSet(false,true)){try{extractor.release();}finally{cache.unpinVideo(info.sha);}}}
    }
    static Clip prepare(VideoInfo info,File file,CacheStore cache)throws Exception {
        cache.pinVideo(info.sha);MediaExtractor extractor=new MediaExtractor();boolean ready=false;
        try{
            extractor.setDataSource(file.getPath());int track=-1;MediaFormat format=null;
            for(int i=0;i<extractor.getTrackCount();i++){
                MediaFormat f=extractor.getTrackFormat(i);String type=f.getString(MediaFormat.KEY_MIME);
                if(type!=null&&type.startsWith("audio/"))throw new IOException("В MP4 обнаружена аудиодорожка");
                if(type!=null&&type.startsWith("video/")){if(track>=0||!type.equals("video/hevc"))throw new IOException("Нужна одна HEVC-видеодорожка");track=i;format=f;}
            }
            if(track<0||format.getInteger(MediaFormat.KEY_WIDTH)!=3840||format.getInteger(MediaFormat.KEY_HEIGHT)!=2160)throw new IOException("Фактический размер видео не равен 3840×2160");
            if(format.containsKey(MediaFormat.KEY_PROFILE)&&format.getInteger(MediaFormat.KEY_PROFILE)!=MediaCodecInfo.CodecProfileLevel.HEVCProfileMain)throw new IOException("Нужен 8-битный профиль HEVC Main");
            if(!format.containsKey(MediaFormat.KEY_DURATION)||Math.abs(format.getLong(MediaFormat.KEY_DURATION)-info.durationMs*1000L)>Math.max(5000L,1000000L/info.fps))throw new IOException("Длительность MP4 не совпала с JSON");
            if(format.containsKey(MediaFormat.KEY_FRAME_RATE)){float fps;try{fps=format.getInteger(MediaFormat.KEY_FRAME_RATE);}catch(ClassCastException e){fps=format.getFloat(MediaFormat.KEY_FRAME_RATE);}if(Math.abs(fps-info.fps)>.1f)throw new IOException("Частота кадров MP4 не совпала с JSON");}
            extractor.selectTrack(track);Clip clip=new Clip(info,file,extractor,format,cache);clip.rewind();ready=true;return clip;
        }finally{if(!ready){extractor.release();cache.unpinVideo(info.sha);}}
    }
    final Listener listener;final Handler main=new Handler(Looper.getMainLooper());
    final ExecutorService worker=Executors.newSingleThreadExecutor();final AtomicReference<Clip> pending=new AtomicReference<>();
    private Future<?> job;private AtomicReference<Clip> launch=new AtomicReference<>();private volatile boolean wanted,disposed;private volatile long generation;
    volatile boolean playing,fill,running;volatile VideoInfo displayed;
    volatile String state="Ожидание опубликованного видео…",codecName="",decoderKind="";
    volatile int decodedWidth,decodedHeight,actualWidth,actualHeight,decoderStarts,inputLimit;
    volatile long loops,renderedFrames,switches,failures;
    VideoSurface(Context c,Listener l){super(c);listener=l;setFocusable(false);setContentDescription("Динамические видеообои 4К");getHolder().setFixedSize(3840,2160);getHolder().addCallback(this);}
    static void configureWindow(Window w){try{TvDisplay.Mode best=WallpaperSurface.bestMode(w.getWindowManager().getDefaultDisplay());int requested=TvDisplay.is4k(best.width,best.height)?best.id:0;WindowManager.LayoutParams a=w.getAttributes();if(a.preferredDisplayModeId!=requested){a.preferredDisplayModeId=requested;w.setAttributes(a);}}catch(RuntimeException ignored){}}
    void start(){if(disposed)return;wanted=true;begin();}
    boolean wanted(){return wanted;}
    void offer(Clip clip){if(disposed||!wanted){clip.close();return;}Clip old=pending.getAndSet(clip);if(old!=null)old.close();begin();}
    void updateInfo(VideoInfo info){if(displayed!=null&&info.sameMedia(displayed)){displayed=info;listener.changed();}}
    void stop(){wanted=false;generation++;playing=false;running=false;if(job!=null)job.cancel(true);job=null;Clip queued=launch.getAndSet(null);if(queued!=null)queued.close();Clip old=pending.getAndSet(null);if(old!=null)old.close();}
    void reset(){stop();displayed=null;decodedWidth=decodedHeight=0;state="Ожидание опубликованного видео…";}
    void destroy(){disposed=true;stop();worker.shutdownNow();main.removeCallbacksAndMessages(null);}
    private boolean current(long token){return wanted&&!disposed&&token==generation&&!Thread.currentThread().isInterrupted();}
    private void changed(long token){main.post(()->{if(current(token))listener.changed();});}
    private void begin(){if(!wanted||disposed||!getHolder().getSurface().isValid()||getVisibility()!=VISIBLE||pending.get()==null||job!=null&&!job.isDone())return;
        Clip first=pending.getAndSet(null);if(first==null)return;long token=++generation;running=true;decoderStarts=0;loops=renderedFrames=switches=0;
        AtomicReference<Clip> ticket=new AtomicReference<>(first);launch=ticket;Surface target=getHolder().getSurface();
        job=worker.submit(()->{Clip owned=ticket.getAndSet(null);if(owned!=null)decode(owned,target,token);});}
    public void surfaceCreated(SurfaceHolder h){begin();listener.changed();}
    public void surfaceChanged(SurfaceHolder h,int format,int w,int z){actualWidth=w;actualHeight=z;listener.changed();begin();}
    public void surfaceDestroyed(SurfaceHolder h){actualWidth=actualHeight=0;generation++;playing=false;running=false;if(job!=null)job.cancel(true);job=null;Clip queued=launch.getAndSet(null);if(queued!=null)queued.close();}
    private static boolean hardware(MediaCodecInfo info){if(Build.VERSION.SDK_INT>=29)return info.isHardwareAccelerated();String n=info.getName().toLowerCase(java.util.Locale.ROOT);return !n.startsWith("omx.google.")&&!n.startsWith("c2.android.")&&!n.startsWith("omx.ffmpeg.");}
    private MediaCodec decoder(Clip clip,Surface target)throws IOException {
        Exception last=null;for(MediaCodecInfo info:new MediaCodecList(MediaCodecList.REGULAR_CODECS).getCodecInfos()){
            if(info.isEncoder()||!hardware(info))continue;boolean supported=false;for(String t:info.getSupportedTypes())if(t.equalsIgnoreCase("video/hevc"))supported=true;if(!supported)continue;
            MediaCodec candidate=null;try{
                MediaCodecInfo.VideoCapabilities caps=info.getCapabilitiesForType("video/hevc").getVideoCapabilities();if(caps==null||!caps.areSizeAndRateSupported(3840,2160,clip.info.fps))continue;
                // A later static key frame may compress less well than the current one.
                inputLimit=Math.max(4*1024*1024,clip.format.containsKey(MediaFormat.KEY_MAX_INPUT_SIZE)?clip.format.getInteger(MediaFormat.KEY_MAX_INPUT_SIZE):(int)clip.info.bytes);
                clip.format.setInteger(MediaFormat.KEY_MAX_INPUT_SIZE,inputLimit);
                candidate=MediaCodec.createByCodecName(info.getName());candidate.configure(clip.format,target,null,0);candidate.start();codecName=info.getName();decoderKind=Build.VERSION.SDK_INT>=29?"Аппаратный (данные Android)":"Вендорный (аппаратный флаг API недоступен)";decoderStarts++;return candidate;
            }catch(Exception e){last=e;if(candidate!=null)try{candidate.release();}catch(RuntimeException ignored){}}
        }throw new IOException("Нет аппаратного HEVC-декодера для 3840×2160 / "+clip.info.fps+(last==null?"":": "+last.getMessage()));
    }
    private static byte[] config(MediaFormat f,String key){if(!f.containsKey(key))return new byte[0];ByteBuffer b=f.getByteBuffer(key).duplicate();byte[] v=new byte[b.remaining()];b.get(v);return v;}
    private static boolean compatible(Clip a,Clip b){if(a.info.fps!=b.info.fps)return false;for(String k:new String[]{"csd-0","csd-1","csd-2"})if(!Arrays.equals(config(a.format,k),config(b.format,k)))return false;return true;}
    private static void release(MediaCodec c){if(c!=null){try{c.stop();}catch(RuntimeException ignored){}try{c.release();}catch(RuntimeException ignored){}}}
    private void waitUntil(long at,long token)throws InterruptedException {while(current(token)){long delay=at-System.nanoTime();if(delay<=0)return;TimeUnit.NANOSECONDS.sleep(Math.min(delay,20000000L));}throw new InterruptedException();}
    private void decode(Clip first,Surface target,long token){Clip clip=first,retired=null;MediaCodec codec=null;boolean fault=false;
        try{
            if(!current(token))return;codec=decoder(clip,target);boolean inputEnd=false,lastFill=!fill,announce=true;
            long clock=0,lastInput=0,lastProgress=System.nanoTime();MediaCodec.BufferInfo out=new MediaCodec.BufferInfo();
            while(current(token)){
                if(lastFill!=fill){lastFill=fill;codec.setVideoScalingMode(fill?MediaCodec.VIDEO_SCALING_MODE_SCALE_TO_FIT_WITH_CROPPING:MediaCodec.VIDEO_SCALING_MODE_SCALE_TO_FIT);}
                if(!inputEnd){int index=codec.dequeueInputBuffer(10000);if(index>=0){ByteBuffer input=codec.getInputBuffer(index);if(input==null)throw new IOException("Нет входного буфера декодера");input.clear();int size=clip.extractor.readSampleData(input,0);
                    if(size<0){codec.queueInputBuffer(index,0,0,lastInput+1000000L/clip.info.fps,MediaCodec.BUFFER_FLAG_END_OF_STREAM);inputEnd=true;}
                    else{lastInput=clip.extractor.getSampleTime();codec.queueInputBuffer(index,0,size,lastInput,0);clip.extractor.advance();}}}
                int index=codec.dequeueOutputBuffer(out,10000);
                if(index==MediaCodec.INFO_OUTPUT_FORMAT_CHANGED){MediaFormat f=codec.getOutputFormat();decodedWidth=f.containsKey("crop-right")&&f.containsKey("crop-left")?f.getInteger("crop-right")-f.getInteger("crop-left")+1:f.getInteger(MediaFormat.KEY_WIDTH);decodedHeight=f.containsKey("crop-bottom")&&f.containsKey("crop-top")?f.getInteger("crop-bottom")-f.getInteger("crop-top")+1:f.getInteger(MediaFormat.KEY_HEIGHT);if(decodedWidth!=3840||decodedHeight!=2160)throw new IOException("Декодер выдал размер меньше 4К");changed(token);}
                else if(index>=0){lastProgress=System.nanoTime();boolean render=out.size>0;if(render){if(clock==0)clock=System.nanoTime()-out.presentationTimeUs*1000L;waitUntil(clock+out.presentationTimeUs*1000L,token);}codec.releaseOutputBuffer(index,render);
                    if(render){renderedFrames++;if(announce){announce=false;VideoInfo shown=clip.info;main.post(()->{if(current(token)){if(displayed!=null&&!shown.sameMedia(displayed))switches++;displayed=shown;playing=true;state="Видео · "+shown.frame.title;listener.changed();}});if(retired!=null){retired.close();retired=null;}}}
                    if((out.flags&MediaCodec.BUFFER_FLAG_END_OF_STREAM)!=0){if(clock!=0)waitUntil(clock+clip.duration*1000L,token);if(!current(token))break;loops++;
                        Clip next=pending.getAndSet(null);
                        if(next!=null&&next.info.sameMedia(clip.info)){VideoInfo latest=next.info;next.close();main.post(()->{if(current(token))updateInfo(latest);});next=null;}
                        if(next!=null){next.rewind();int required=next.format.containsKey(MediaFormat.KEY_MAX_INPUT_SIZE)?next.format.getInteger(MediaFormat.KEY_MAX_INPUT_SIZE):(int)next.info.bytes;boolean same=compatible(clip,next)&&required<=inputLimit;retired=clip;clip=next;
                            if(same)codec.flush();else{release(codec);codec=null;codec=decoder(clip,target);lastFill=!fill;}
                            announce=true;
                        }else{clip.rewind();codec.flush();}
                        inputEnd=false;clock=0;lastInput=0;lastProgress=System.nanoTime();changed(token);
                    }
                }
                if(System.nanoTime()-lastProgress>15000000000L)throw new IOException("Декодер не выдаёт кадры более 15 секунд");
            }
        }catch(InterruptedException ignored){Thread.currentThread().interrupt();}
        catch(Exception e){if(current(token)){fault=true;state="Ошибка видео: "+(e.getMessage()==null?e.getClass().getSimpleName():e.getMessage());}}
        finally{release(codec);clip.close();if(retired!=null)retired.close();if(token==generation){running=false;if(fault)failures++;}if(fault)changed(token);}
    }
    String diagnostics(){VideoInfo v=displayed;return "Источник: серверный MP4 в кеше\n"+(v==null?"Готовый ролик ещё не показан":v.frame.title+"\nПрофиль: "+v.frame.device+"\nФайл: 3840 × 2160 · HEVC · "+v.fps+" кадра/с\nРазмер: "+v.bytes+" байт")+"\nСостояние: "+state+"\nДекодер: "+codecName+"\nТип: "+decoderKind+"\nРазмер декодера: "+decodedWidth+" × "+decodedHeight+"\nSurface фактически: "+actualWidth+" × "+actualHeight+"\nПоказано кадров: "+renderedFrames+"\nПовторов: "+loops+"\nСмен ролика: "+switches+"\nЗапусков декодера: "+decoderStarts+"\nМузыка: отдельный проигрыватель";}
}
