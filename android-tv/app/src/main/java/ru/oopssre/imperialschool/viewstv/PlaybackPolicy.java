package ru.oopssre.imperialschool.viewstv;

/** Video is a preferred output for dynamic themes, never a catalogue filter. */
public final class PlaybackPolicy {
    public static boolean useVideo(boolean preferred,String kind){return preferred&&"dynamic".equals(kind);}
}
