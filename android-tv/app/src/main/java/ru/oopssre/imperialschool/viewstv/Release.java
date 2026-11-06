package ru.oopssre.imperialschool.viewstv;

import org.json.*;

/** Existing Android release envelope, isolated at android-tv-release.json for the TV app. */
public final class Release {
    public final String version,url,sha;public final long build,bytes;
    private Release(String v,String u,String s,long b,long n){version=v;url=u;sha=s;build=b;bytes=n;}
    public static Release parse(JSONObject envelope,String app)throws JSONException {
        Protocol.require(envelope.getInt("schema")==1&&envelope.getString("app_id").equals(app)&&envelope.getString("platform").equals("android"),"Релиз предназначен для другого приложения");
        Protocol.require(envelope.has("release"),"Нет поля release");if(envelope.isNull("release"))return null;JSONObject r=envelope.getJSONObject("release");String v=r.getString("version"),u=r.getString("url"),s=r.getString("sha256");long b=Protocol.integer(r,"build",1,Integer.MAX_VALUE),n=Protocol.integer(r,"bytes",1,Protocol.MAX_IMAGE);
        Protocol.require(u.startsWith(Protocol.BASE+"downloads/"),"Неверный адрес APK");java.net.URI uri=Protocol.url(u);String path=uri.getPath(),prefix="/assets/arcade/views/downloads/";Protocol.require(path.startsWith(prefix)&&path.substring(prefix.length()).matches("[a-zA-Z0-9][a-zA-Z0-9._-]*\\.apk"),"Неверный адрес APK");
        Protocol.require(v.matches("[0-9]+\\.[0-9]+\\.[0-9]+")&&Protocol.hash(s)&&b>0&&b<=Integer.MAX_VALUE&&n>0&&n<=Protocol.MAX_IMAGE,"Неверное описание релиза");return new Release(v,u,s,b,n);
    }
}
