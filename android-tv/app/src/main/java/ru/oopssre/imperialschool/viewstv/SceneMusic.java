package ru.oopssre.imperialschool.viewstv;

import android.content.Context;
import android.content.SharedPreferences;
import android.content.res.AssetFileDescriptor;
import android.media.AudioAttributes;
import android.media.AudioFocusRequest;
import android.media.AudioManager;
import android.media.MediaPlayer;
import android.os.Handler;
import android.os.Looper;

/** Scene-owned playback for both bundled collections; no background service. */
final class SceneMusic {
    interface Listener { void changed(); }
    private static SceneMusic owner;
    final Context context;final SharedPreferences prefs;final Listener listener;final boolean screensaver;
    final Handler main=new Handler(Looper.getMainLooper());final AudioManager audio;
    final AudioAttributes attributes=new AudioAttributes.Builder().setUsage(AudioAttributes.USAGE_MEDIA).setContentType(AudioAttributes.CONTENT_TYPE_MUSIC).build();
    final AudioFocusRequest focus;
    MediaPlayer player;boolean allowed,prepared,focused,focusPaused,blocked,destroyed;
    Soundtracks.Pack pack=Soundtracks.ORBITAL;
    int index,position,failures;float gain;String state="Выключена";
    final Runnable fade=new Runnable(){public void run(){if(player==null||!prepared)return;gain=Math.min(level()/100f,gain+.0125f);applyVolume();if(gain<level()/100f)main.postDelayed(this,60);}};
    SceneMusic(Context c,SharedPreferences p,boolean saver,Listener l){screensaver=saver;context=c.getApplicationContext();prefs=p;listener=l;audio=(AudioManager)context.getSystemService(Context.AUDIO_SERVICE);loadPosition();focus=new AudioFocusRequest.Builder(AudioManager.AUDIOFOCUS_GAIN).setAudioAttributes(attributes).setWillPauseWhenDucked(true).setOnAudioFocusChangeListener(this::focusChanged,main).build();}
    static String enabledKey(boolean saver){return saver?"music_screensaver_enabled":"music_app_enabled";}
    boolean isEnabled(boolean saver){return prefs.getBoolean(enabledKey(saver),!saver&&prefs.getBoolean("orbital_music",true));}
    boolean enabled(){return isEnabled(screensaver);}
    int level(){return Math.max(0,Math.min(100,prefs.getInt("music_volume",20)));}
    String title(){return pack==null?"":pack.titles[index];}
    String trackKey(){return "music_track_"+pack.id;}
    String positionKey(){return "music_position_"+pack.id;}
    void loadPosition(){if(pack==null){index=position=0;return;}boolean legacy=pack==Soundtracks.ORBITAL;index=Math.floorMod(prefs.getInt(trackKey(),legacy?prefs.getInt("music_track",0):0),pack.files.length);position=Math.max(0,prefs.getInt(positionKey(),legacy?prefs.getInt("music_position",0):0));}
    void changed(){listener.changed();}
    void scene(boolean visible,String theme){Soundtracks.Pack selected=Soundtracks.forTheme(theme);if(selected!=pack){release(true);abandon();pack=selected;loadPosition();failures=0;blocked=false;allowed=false;}boolean next=visible&&pack!=null;if(next==allowed)return;allowed=next;blocked=false;if(allowed)ensure();else{release(true);abandon();state="Пауза";changed();}}
    void enabled(boolean value){enabled(screensaver,value);}
    void enabled(boolean saver,boolean value){prefs.edit().putBoolean(enabledKey(saver),value).apply();if(saver!=screensaver){changed();return;}blocked=false;failures=0;if(value)ensure();else{release(true);abandon();state="Выключена";changed();}}
    void volume(int value){prefs.edit().putInt("music_volume",Math.max(0,Math.min(100,value))).apply();main.removeCallbacks(fade);gain=level()/100f;applyVolume();changed();}
    void next(){select(index+1);}
    void previous(){select(index-1);}
    private void select(int value){if(pack==null)return;release(false);index=Math.floorMod(value,pack.files.length);position=0;failures=0;blocked=false;save();ensure();changed();}
    private void save(){if(pack!=null)prefs.edit().putInt(trackKey(),index).putInt(positionKey(),position).apply();}
    private void ensure(){
        if(destroyed||pack==null||!allowed||!enabled()||blocked){if(!enabled())state="Выключена";changed();return;}
        if(owner!=null&&owner!=this){owner.blocked=true;owner.release(true);owner.abandon();owner.state="Пауза";owner.changed();}owner=this;
        if(!focused){try{focused=audio.requestAudioFocus(focus)==AudioManager.AUDIOFOCUS_REQUEST_GRANTED;}catch(RuntimeException e){focused=false;}if(!focused){state="Звук занят другим приложением";changed();return;}}
        if(player!=null){if(prepared){player.start();state="Играет";ramp();changed();}return;}
        state="Подготовка трека…";changed();
        MediaPlayer next=new MediaPlayer();player=next;prepared=false;
        try{
            next.setAudioAttributes(attributes);
            // A local provider is deliberately isolated here for the later move to site caching.
            try(AssetFileDescriptor file=context.getAssets().openFd(pack.files[index])){next.setDataSource(file.getFileDescriptor(),file.getStartOffset(),file.getLength());}
            next.setVolume(0,0);
            next.setOnPreparedListener(p->{if(player!=p||destroyed)return;prepared=true;failures=0;if(position>0&&position<p.getDuration()-1000)p.seekTo(position);if(allowed&&enabled()&&focused&&!blocked){p.start();state="Играет";ramp();}else state="Пауза";changed();});
            next.setOnCompletionListener(p->{if(player!=p)return;release(false);index=(index+1)%pack.files.length;position=0;save();ensure();});
            next.setOnErrorListener((p,what,extra)->{if(player==p)failed();return true;});
            next.prepareAsync();
        }catch(Exception e){failed();}
    }
    private void failed(){release(false);position=0;failures++;if(failures<pack.files.length){index=(index+1)%pack.files.length;save();main.postDelayed(()->ensure(),400);}else{blocked=true;state="Не удалось открыть музыку";abandon();changed();}}
    private void ramp(){main.removeCallbacks(fade);gain=0;applyVolume();main.post(fade);}
    private void applyVolume(){if(player!=null&&prepared)try{player.setVolume(gain,gain);}catch(IllegalStateException ignored){}}
    private void release(boolean remember){main.removeCallbacks(fade);MediaPlayer old=player;player=null;if(old!=null){if(remember&&prepared)try{position=old.getCurrentPosition();save();}catch(IllegalStateException ignored){}prepared=false;old.setOnPreparedListener(null);old.setOnCompletionListener(null);old.setOnErrorListener(null);old.release();}if(owner==this)owner=null;}
    private void abandon(){if(focused)try{audio.abandonAudioFocusRequest(focus);}catch(RuntimeException ignored){}focused=false;focusPaused=false;}
    void focusChanged(int value){
        if(destroyed)return;
        if(value==AudioManager.AUDIOFOCUS_GAIN){focused=true;if(focusPaused&&allowed&&enabled()&&!blocked){focusPaused=false;ensure();}}
        else if(value==AudioManager.AUDIOFOCUS_LOSS_TRANSIENT||value==AudioManager.AUDIOFOCUS_LOSS_TRANSIENT_CAN_DUCK){main.removeCallbacks(fade);if(player!=null&&prepared)try{player.pause();}catch(IllegalStateException ignored){}focused=false;focusPaused=true;state="Пауза — другой звук";changed();}
        else if(value==AudioManager.AUDIOFOCUS_LOSS){blocked=true;release(true);abandon();state="Пауза — другое приложение";changed();}
    }
    void destroy(){destroyed=true;allowed=false;release(true);abandon();main.removeCallbacksAndMessages(null);}
}
