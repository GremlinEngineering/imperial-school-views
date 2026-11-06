package ru.oopssre.imperialschool.viewstv;

import android.content.*;
import android.content.pm.*;
import android.os.Build;
import java.io.*;
import java.nio.charset.StandardCharsets;
import java.nio.file.*;
import java.util.*;
import org.json.*;

final class Updater {
    static final String FEED="android-tv-release.json";
    final Repository repo;final File folder,apk,record;
    Updater(Repository r){repo=r;folder=new File(r.context.getCacheDir(),"tv-update");folder.mkdirs();apk=new File(folder,"update.apk");record=new File(folder,"release.json");}
    long installed()throws PackageManager.NameNotFoundException {PackageInfo p=repo.context.getPackageManager().getPackageInfo(repo.context.getPackageName(),0);return Build.VERSION.SDK_INT>=28?p.getLongVersionCode():p.versionCode;}
    Release ready(){try{Release r=Release.parse(new JSONObject(new String(CacheStore.read(record,100000),StandardCharsets.UTF_8)),repo.context.getPackageName());if(r!=null&&r.build>installed()&&apk.length()==r.bytes&&CacheStore.sha(apk).equals(r.sha)){validateApk(r,apk);return r;}}catch(Exception ignored){}return null;}
    Release check(String pinned)throws Exception {
        JSONObject envelope=repo.net.json(FEED,true,pinned);Release next=Release.parse(envelope,repo.context.getPackageName());if(next==null||next.build<=installed())return null;
        Release old=ready();if(old!=null&&old.sha.equals(next.sha))return old;
        File part=new File(folder,"update.part");try{HttpTransport.download(next.url,part,next.bytes,Protocol.MAX_IMAGE);Protocol.require(part.length()==next.bytes&&CacheStore.sha(part).equals(next.sha),"APK загружен с ошибкой");validateApk(next,part);Files.move(part.toPath(),apk.toPath(),StandardCopyOption.ATOMIC_MOVE,StandardCopyOption.REPLACE_EXISTING);CacheStore.atomic(record,envelope.toString().getBytes(StandardCharsets.UTF_8));return next;}finally{part.delete();}
    }
    @SuppressWarnings("deprecation") private void validateApk(Release expected,File file)throws Exception {
        PackageManager pm=repo.context.getPackageManager();int flags=Build.VERSION.SDK_INT>=28?PackageManager.GET_SIGNING_CERTIFICATES:PackageManager.GET_SIGNATURES;
        PackageInfo next=pm.getPackageArchiveInfo(file.getPath(),flags),current=pm.getPackageInfo(repo.context.getPackageName(),flags);
        Protocol.require(next!=null&&repo.context.getPackageName().equals(next.packageName),"APK предназначен для другого приложения");
        long code=Build.VERSION.SDK_INT>=28?next.getLongVersionCode():next.versionCode;Protocol.require(code==expected.build&&code>installed()&&expected.version.equals(next.versionName),"Неверная версия APK");
        android.content.pm.Signature[] a=Build.VERSION.SDK_INT>=28?current.signingInfo.getApkContentsSigners():current.signatures;
        android.content.pm.Signature[] b=Build.VERSION.SDK_INT>=28?next.signingInfo.getApkContentsSigners():next.signatures;
        Set<String> old=signatures(a),fresh=signatures(b);Protocol.require(!old.isEmpty()&&old.equals(fresh),"Подпись APK не совпадает с установленным приложением");
    }
    private static Set<String> signatures(android.content.pm.Signature[] rows){Set<String> result=new HashSet<>();if(rows!=null)for(android.content.pm.Signature row:rows)result.add(CacheStore.hash(row.toByteArray()));return result;}
    Intent installer(){android.net.Uri uri=android.net.Uri.parse("content://"+repo.context.getPackageName()+".updates/update.apk");Intent i=new Intent(Intent.ACTION_VIEW).setDataAndType(uri,"application/vnd.android.package-archive").addFlags(Intent.FLAG_ACTIVITY_NEW_TASK|Intent.FLAG_GRANT_READ_URI_PERMISSION);i.setClipData(ClipData.newRawUri("APK",uri));return i;}
}
