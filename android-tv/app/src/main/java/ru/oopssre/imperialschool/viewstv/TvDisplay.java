package ru.oopssre.imperialschool.viewstv;

/** Physical output modes, independent of the logical Android TV UI size. */
public final class TvDisplay {
    public static final String AUTO="auto", UHD="4k", FULL_HD="1080p";
    public static String resolution(String value){return UHD.equals(value)?UHD:FULL_HD.equals(value)?FULL_HD:AUTO;}
    public static String label(String value){String mode=resolution(value);return UHD.equals(mode)?"4К · 3840×2160":FULL_HD.equals(mode)?"Full HD · 1920×1080":"Авто";}
    public static int[] targetSize(String value,int width,int height){
        String mode=resolution(value);
        if(UHD.equals(mode))return new int[]{3840,2160};
        if(FULL_HD.equals(mode))return new int[]{1920,1080};
        return new int[]{Math.max(1,Math.min(3840,width)),Math.max(1,Math.min(2160,height))};
    }
    public static final class Mode {
        public final int id,width,height;public final float hz;
        public Mode(int id,int width,int height,float hz){this.id=id;this.width=width;this.height=height;this.hz=hz;}
    }
    public static Mode choose(Mode current,Mode[] supported){
        return choose(current,supported,AUTO);
    }
    public static Mode choose(Mode current,Mode[] supported,String resolution){
        Mode best=null;
        for(Mode m:supported){
            if(m.width<m.height||m.width<=0||m.height<=0||m.width>3840||m.height>2160)continue;
            if(FULL_HD.equals(resolution(resolution))&&(m.width>1920||m.height>1080))continue;
            long area=(long)m.width*m.height,bestArea=best==null?0:(long)best.width*best.height;
            if(best==null||area>bestArea||area==bestArea&&Math.abs(m.hz-current.hz)<Math.abs(best.hz-current.hz))best=m;
        }
        return best==null?current:best;
    }
    public static boolean is4k(int width,int height){return width>=3840&&height>=2160;}
}
