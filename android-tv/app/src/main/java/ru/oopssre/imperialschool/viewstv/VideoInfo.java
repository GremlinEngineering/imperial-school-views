package ru.oopssre.imperialschool.viewstv;

import org.json.*;

/** Optional video rendition of a published dynamic frame. No theme-specific decisions. */
public final class VideoInfo {
    public static final long MAX_BYTES=32L*1024*1024;
    public final Protocol.Frame frame;
    public final String url,sha;
    public final long bytes,durationMs;
    public final int fps;
    private final JSONObject value;
    private VideoInfo(Protocol.Frame f,JSONObject v)throws JSONException {
        frame=f;value=new JSONObject(v.toString());url=v.getString("url");sha=v.getString("sha256");
        bytes=Protocol.integer(v,"bytes",1,MAX_BYTES);durationMs=Protocol.integer(v,"duration_ms",1,120000);fps=(int)Protocol.integer(v,"fps",1,60);
        Protocol.require(f.kind.equals("dynamic")&&f.device.equals(Protocol.DEFAULT_DEVICE)&&f.width==3840&&f.height==2160,"Видео относится к другому профилю");
        Protocol.require(Protocol.hash(sha)&&v.getString("source_image_sha256").equals(f.sha),"Видео не соответствует исходному изображению кадра");
        String expected="dynamic/"+f.theme+"/devices/"+f.device+"/video/"+sha+".mp4";
        Protocol.require(Protocol.url(url).equals(Protocol.url(expected)),"Неверный адрес MP4");
        Protocol.require(v.getString("format").equals("mp4")&&v.getString("codec").equals("hevc")&&v.getString("profile").equals("main")&&v.getString("pixel_format").equals("yuv420p"),"Неподдерживаемый формат видео");
        Protocol.require(Protocol.integer(v,"width",3840,3840)==3840&&Protocol.integer(v,"height",2160,2160)==2160,"Неверный размер видео");
        Protocol.require(v.get("audio") instanceof Boolean&&!v.getBoolean("audio"),"Ролик должен быть без аудиодорожки");
    }
    public static VideoInfo parse(JSONObject state,Protocol.Frame f)throws JSONException {
        JSONObject v=state.optJSONObject("video");if(v==null)throw new Protocol.NotReady("Видео для текущего кадра ещё не опубликовано");return new VideoInfo(f,v);
    }
    public JSONObject json()throws JSONException{return new JSONObject().put("frame",frame.json()).put("video",new JSONObject(value.toString()));}
    public static VideoInfo saved(JSONObject j)throws JSONException{return new VideoInfo(Protocol.savedFrame(j.getJSONObject("frame")),j.getJSONObject("video"));}
    public boolean sameMedia(VideoInfo other){return other!=null&&frame.scope().equals(other.frame.scope())&&sha.equals(other.sha);}
}
