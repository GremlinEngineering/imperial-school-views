package ru.oopssre.imperialschool.viewstv;

import java.io.*;
import java.util.Locale;

/** Encoding identity stays separate from dimensions and the video source digest. */
public final class ImageFormat {
    public static String canonical(String value) {
        String v=value.toLowerCase(Locale.ROOT);
        if(v.equals("png"))return "png";
        if(v.equals("jpg")||v.equals("jpeg"))return "jpg";
        throw new IllegalArgumentException("Неподдерживаемый формат изображения");
    }
    public static String fromURL(String value) {
        String path=Protocol.url(value).getPath().toLowerCase(Locale.ROOT);
        if(path.endsWith(".png"))return "png";
        if(path.endsWith(".jpg")||path.endsWith(".jpeg"))return "jpg";
        throw new IllegalArgumentException("Неверное расширение изображения");
    }
    public static boolean signature(File file,String format)throws IOException {
        byte[] b=new byte[8];int size=0;
        try(InputStream in=new FileInputStream(file)){while(size<b.length){int n=in.read(b,size,b.length-size);if(n<0)break;size+=n;}}
        if(canonical(format).equals("jpg"))return size>=3&&(b[0]&255)==255&&(b[1]&255)==216&&(b[2]&255)==255;
        return size==8&&(b[0]&255)==137&&b[1]==80&&b[2]==78&&b[3]==71&&b[4]==13&&b[5]==10&&b[6]==26&&b[7]==10;
    }
}
