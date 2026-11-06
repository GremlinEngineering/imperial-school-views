package ru.oopssre.imperialschool.viewstv;

import org.json.*;
import java.net.URI;
import java.time.*;
import java.util.*;

/** Published server protocol only: no local weather, layer composition or archive downloads. */
public final class Protocol {
    public static final String BASE="https://games.oopssre.ru/assets/arcade/views/";
    public static final String DEFAULT_ID="orbital-port", DEFAULT_DEVICE="desktop_3840x2160";
    public static final String FULL_HD_DEVICE="desktop_1920x1080";
    public static final long MAX_IMAGE=32L*1024*1024;
    public static void require(boolean yes,String message){if(!yes)throw new IllegalArgumentException(message);}
    public static final class NotReady extends IllegalArgumentException {public NotReady(String message){super(message);}}
    static boolean id(String s){return s.matches("[a-z][a-z0-9_-]{0,79}");}
    static boolean hash(String s){return s.matches("[a-f0-9]{64}");}
    public static URI url(String path){
        URI p=URI.create(path);require(!path.contains("\\")&&!path.contains("%")&&!path.contains(".."),"Неверный путь сервера");
        URI u=URI.create(BASE).resolve(p);
        require("https".equals(u.getScheme())&&"games.oopssre.ru".equals(u.getHost())&&(u.getPort()==-1||u.getPort()==443)&&u.getUserInfo()==null&&u.getFragment()==null&&u.getQuery()==null&&u.getPath().startsWith("/assets/arcade/views/"),"Неверный адрес сервера");return u;
    }
    static boolean endpoint(String actual,String expected){return url(actual).equals(url(expected))||expected.endsWith(".json")&&url(actual).equals(url(expected+".br"));}
    public static long time(String s){return OffsetDateTime.parse(s).toInstant().toEpochMilli();}
    public static final class Theme {
        public final String id,title,device,current,kind;public final int width,height;public final JSONObject descriptor;
        Theme(String i,String t,String d,String c,int w,int h,JSONObject source){id=i;title=t;device=d;current=c;width=w;height=h;descriptor=source;kind=source.optString("type","plain");}
        public String prefix(){return "dynamic/"+id+"/devices/"+device+"/";}
    }
    public static Theme defaultTheme() throws JSONException {
        JSONObject c=new JSONObject().put("id",DEFAULT_ID).put("type","dynamic").put("title","Орбитальная станция ТВ").put("current_url","dynamic/"+DEFAULT_ID+"/current.json").put("formats",new JSONObject().put(DEFAULT_DEVICE,new JSONObject().put("width",3840).put("height",2160)));return theme(c);
    }
    public static Theme theme(JSONObject c) throws JSONException {
        String id=c.getString("id"),title=c.getString("title"),current=c.getString("current_url");
        require(id(id)&&c.getString("type").equals("dynamic")&&title.length()>0&&title.length()<=300,"Неверная тема");
        require(endpoint(current,"dynamic/"+id+"/current.json"),"Неверная публикация темы");
        // Explicit TV choices remain stable with an older cached catalogue or saved descriptor.
        if(id.equals(DEFAULT_ID)||id.equals("sunken-teahouse"))return new Theme(id,title,DEFAULT_DEVICE,current,3840,2160,c);
        JSONObject formats=c.getJSONObject("formats");require(formats.length()>0&&formats.length()<=20,"Нет форматов темы");
        String best=null;double score=Double.MAX_VALUE;int w=0,h=0;
        for(Iterator<String> it=formats.keys();it.hasNext();){String d=it.next();JSONObject f=formats.getJSONObject(d);int fw=f.getInt("width"),fh=f.getInt("height");require(id(d)&&fw>0&&fh>0&&fw<=16384&&fh<=16384,"Неверный формат");if(fw<fh)continue;
            double s=Math.abs(Math.log((double)fw/fh/(16.0/9.0)))*100+Math.abs(Math.log((double)fw*fh/(3840.0*2160)));
            if(s<score){score=s;best=d;w=fw;h=fh;}
        }
        require(best!=null,"В теме нет подходящего телевизионного формата");return new Theme(id,title,best,current,w,h,c);
    }
    public static List<Theme> catalogue(JSONObject p) throws JSONException {
        require(p.getInt("schema")==3,"Неподдерживаемый каталог обоев");JSONArray rows=p.getJSONArray("collections");require(rows.length()<=500,"Слишком большой каталог");
        LinkedHashMap<String,Theme> result=new LinkedHashMap<>();Theme def=defaultTheme();result.put(def.id,def);
        for(int i=0;i<rows.length();i++){JSONObject c=rows.optJSONObject(i);if(c==null)continue;try{Theme t=c.optString("type").equals("dynamic")?theme(c):Sources.theme(c,p);result.put(t.id,t);}catch(IllegalArgumentException|JSONException e){/* One unavailable or phone-only collection must not hide the others. */}}
        return new ArrayList<>(result.values());
    }
    public static boolean tvScene(Theme t){return t.kind.equals("dynamic")&&(t.id.equals(DEFAULT_ID)||t.id.equals("sunken-teahouse"));}
    static Theme tvProfile(Theme t,String device){boolean uhd=device.equals(DEFAULT_DEVICE);require(uhd||device.equals(FULL_HD_DEVICE),"Неверный TV-профиль");return new Theme(t.id,t.title,device,t.current,uhd?3840:1920,uhd?2160:1080,t.descriptor);}
    /** A protocol profile, not a collection-name whitelist. Publication is checked against the live JSON. */
    public static Theme videoProfile(Theme t){require(t.kind.equals("dynamic"),"Видео 4К доступно для динамических тем");return tvProfile(t,DEFAULT_DEVICE);}
    public static Theme publishedVideo(JSONObject top,Theme requested)throws JSONException {
        Theme t=videoProfile(requested);
        require(top.getInt("schema")==1&&top.getString("type").equals("dynamic")&&top.getString("collection_id").equals(t.id),"Публикация относится к другой теме");
        JSONObject f=top.getJSONObject("formats").optJSONObject(t.device);
        if(f==null)throw new NotReady("Видео 4К для этой темы ещё не опубликовано");
        require(f.getInt("width")==3840&&f.getInt("height")==2160,"Неверный размер профиля desktop_3840x2160");
        statePath(top,t);return t;
    }
    public static Theme forDisplay(Theme t,int width,int height){return tvScene(t)?tvProfile(t,TvDisplay.is4k(width,height)?DEFAULT_DEVICE:FULL_HD_DEVICE):t;}
    public static Theme alternateTV(Theme t){return tvProfile(t,t.device.equals(DEFAULT_DEVICE)?FULL_HD_DEVICE:DEFAULT_DEVICE);}
    public static Theme publishedTheme(JSONObject top,Theme preferred)throws JSONException {
        return publishedTheme(top,preferred,true);
    }
    public static Theme publishedTheme(JSONObject top,Theme preferred,boolean allowAlternate)throws JSONException {
        require(top.getInt("schema")==1&&top.getString("type").equals("dynamic")&&top.getString("collection_id").equals(preferred.id),"Публикация относится к другой теме");
        if(!tvScene(preferred))return preferred;
        for(Theme candidate:allowAlternate?new Theme[]{preferred,alternateTV(preferred)}:new Theme[]{preferred}){
            JSONObject status=top.getJSONObject("format_status").optJSONObject(candidate.device);
            if(status==null||!status.optString("status").equals("ready"))continue;
            JSONObject format=top.getJSONObject("formats").getJSONObject(candidate.device);
            require(format.getInt("width")==candidate.width&&format.getInt("height")==candidate.height,"Неверный размер TV-публикации");
            return candidate;
        }
        return preferred;
    }
    public static String statePath(JSONObject top,Theme t) throws JSONException {
        require(top.getInt("schema")==1&&top.getString("type").equals("dynamic")&&top.getString("collection_id").equals(t.id),"Публикация относится к другой теме");
        JSONObject status=top.getJSONObject("format_status").optJSONObject(t.device);
        if(status==null||!status.optString("status").equals("ready"))throw new NotReady("Кадр для телевизора ещё не опубликован");
        String path=top.getJSONObject("states").getString(t.device);require(endpoint(path,t.prefix()+"current.json"),"Неверный адрес текущего кадра");return path;
    }
    static long integer(JSONObject j,String key,long min,long max)throws JSONException {Object raw=j.get(key);require(raw instanceof Number,"Неверное число: "+key);double n=((Number)raw).doubleValue();require(Double.isFinite(n)&&n==Math.floor(n)&&n>=min&&n<=max,"Неверное число: "+key);return ((Number)raw).longValue();}
    public static final class Frame {
        public final String theme,device,title,url,sha,stateId;public String kind="dynamic",sourceId="real";public long refreshAt;public final int width,height;public final long bytes,at,until;public final String format;
        Frame(String t,String d,String label,String u,String s,String state,int w,int h,long n,long a,long v){theme=t;device=d;title=label;url=u;format=ImageFormat.fromURL(u);sha=s;stateId=state;width=w;height=h;bytes=n;at=a;until=v;refreshAt=v;}
        public String scope(){return theme+"/"+device;}
        public JSONObject json() throws JSONException {return new JSONObject().put("theme",theme).put("device",device).put("title",title).put("url",url).put("format",format).put("sha",sha).put("state",stateId).put("width",width).put("height",height).put("bytes",bytes).put("at",at).put("until",until).put("kind",kind).put("source_id",sourceId).put("refresh_at",refreshAt);}
        public long nextDelay(long now){return Math.max(60000,Math.min(3600000,refreshAt-now));}
        public long staleAfter(){long ttl=until-at;return until>Long.MAX_VALUE-ttl?Long.MAX_VALUE:until+ttl;}
        public boolean stale(long now){return now>=staleAfter();}
    }
    public static Frame savedFrame(JSONObject j) throws JSONException {
        String t=j.getString("theme"),d=j.getString("device"),sha=j.getString("sha"),state=j.getString("state");require(t.matches("[a-z0-9][a-z0-9_-]{0,79}")&&id(d)&&hash(sha)&&hash(state),"Повреждён кеш кадра");String u=j.getString("url");String kind=j.optString("kind","dynamic");String format=ImageFormat.fromURL(u);require(ImageFormat.canonical(j.optString("format",format)).equals(format),"Неверный формат кеша");require(Arrays.asList("dynamic","weather","plain").contains(kind),"Неверный тип кеша");require(kind.equals("dynamic")?endpoint(u,"dynamic/"+t+"/devices/"+d+"/current."+format):Sources.pictureURL(u,t),"Неверный адрес кеша");
        Frame f=new Frame(t,d,j.getString("title"),u,sha,state,j.getInt("width"),j.getInt("height"),j.getLong("bytes"),j.getLong("at"),j.getLong("until"));f.kind=kind;f.sourceId=j.optString("source_id","real");f.refreshAt=j.optLong("refresh_at",f.until);return f;
    }
    public static Frame frame(JSONObject p,JSONObject top,Theme t,long now) throws JSONException {
        require(p.getInt("schema")==1&&p.getString("type").equals("dynamic-state")&&p.getString("theme_id").equals(t.id)&&p.getString("device").equals(t.device)&&hash(p.getString("id")),"Кадр относится к другой теме или устройству");
        JSONObject in=p.getJSONObject("inputs"),r=p.getJSONObject("recipe"),f=p.getJSONObject("image");String v=p.optString("schema_version",in.optString("schema_version"));
        require((v.equals("0.1")||v.equals("0.2"))&&in.getString("schema_version").equals(v)&&r.getString("schema_version").equals(v)&&in.getString("device").equals(t.device)&&r.getString("device").equals(t.device)&&r.getString("theme_id").equals(t.id),"Неподдерживаемое состояние");
        long at=time(p.getString("at")),until=time(p.getString("valid_until"));require(at==time(in.getString("at"))&&until>at&&at<=now+120000,"Неверное время кадра");
        require(r.getInt("width")==t.width&&r.getInt("height")==t.height&&r.getJSONArray("layers").length()<=1000&&in.getJSONArray("active").length()<=100,"Неверное описание кадра");
        if(v.equals("0.2")){JSONObject life=p.getJSONObject("life"),derived=in.getJSONObject("derived");ZoneId.of(life.getString("timezone"));require(derived.has("life_slot"),"Нет бытового состояния");if(!derived.isNull("life_slot")){Object slot=derived.get("life_slot");require(slot instanceof Number,"Неверный бытовой час");double n=((Number)slot).doubleValue();require(Double.isFinite(n)&&n>=0&&n<=23&&n==Math.floor(n),"Неверный бытовой час");}require(Arrays.asList("first_build","base_changed","hour_blocked","stable_base").contains(life.getString("reason")),"Неверное бытовое состояние");}
        String path=f.getString("url"),sha=f.getString("sha256"),format=ImageFormat.canonical(f.getString("format"));long size=integer(f,"bytes",1,MAX_IMAGE);require(endpoint(path,t.prefix()+"current."+format)&&ImageFormat.fromURL(path).equals(format)&&hash(sha)&&f.getInt("width")==t.width&&f.getInt("height")==t.height,"Неверное изображение кадра");
        JSONObject published=top.getJSONObject("files").getJSONObject(t.device);
        require(published.getString("sha256").equals(sha)&&ImageFormat.canonical(published.getString("format")).equals(format)&&endpoint(published.getString("url"),t.prefix()+"current."+format)&&integer(published,"bytes",1,MAX_IMAGE)==size&&published.getInt("width")==t.width&&published.getInt("height")==t.height,"Сервер обновляет кадр: описание ещё не синхронизировано");
        return new Frame(t.id,t.device,t.title,path,sha,p.getString("id"),t.width,t.height,size,at,until);
    }
}
