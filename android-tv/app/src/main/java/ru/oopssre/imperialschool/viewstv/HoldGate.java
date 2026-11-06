package ru.oopssre.imperialschool.viewstv;

/** Consumes the complete opening key sequence, including repeats and its final UP. */
public final class HoldGate {
    public static final long HOLD_MS=1000;
    private boolean pressed,opened;private long down;
    public boolean pressed(){return pressed;}
    public void down(long now){if(!pressed){pressed=true;opened=false;down=now;}}
    public boolean trigger(long now){if(pressed&&!opened&&now-down>=HOLD_MS){opened=true;return true;}return false;}
    public void release(){pressed=false;opened=false;}
}
