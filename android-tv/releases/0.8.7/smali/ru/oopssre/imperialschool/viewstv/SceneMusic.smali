.class final Lru/oopssre/imperialschool/viewstv/SceneMusic;
.super Ljava/lang/Object;
.source "SceneMusic.java"


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lru/oopssre/imperialschool/viewstv/SceneMusic$PlayerState;,
        Lru/oopssre/imperialschool/viewstv/SceneMusic$Listener;
    }
.end annotation


# static fields
.field private static final PACK_WORKER:Ljava/util/concurrent/ExecutorService;

.field private static final PUBLISH_ZONE:Ljava/time/ZoneId;

.field private static final RADIO_TIMEOUT_MS:J = 0x3a98L

.field private static final TRACK_TIMEOUT_MS:J = 0x7530L

.field private static owner:Lru/oopssre/imperialschool/viewstv/SceneMusic;


# instance fields
.field allowed:Z

.field final attributes:Landroid/media/AudioAttributes;

.field final audio:Landroid/media/AudioManager;

.field blocked:Z

.field private busyRetries:I

.field private checkStatus:Ljava/lang/String;

.field final context:Landroid/content/Context;

.field destroyed:Z

.field final fade:Ljava/lang/Runnable;

.field failures:I

.field final focus:Landroid/media/AudioFocusRequest;

.field focusPaused:Z

.field private focusRegistered:Z

.field focused:Z

.field gain:F

.field private generation:J

.field index:I

.field final listener:Lru/oopssre/imperialschool/viewstv/SceneMusic$Listener;

.field loading:Z

.field final main:Landroid/os/Handler;

.field pack:Lru/oopssre/imperialschool/viewstv/MusicPacks$Pack;

.field private packJob:Ljava/util/concurrent/Future;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/concurrent/Future<",
            "*>;"
        }
    .end annotation
.end field

.field private final packs:Lru/oopssre/imperialschool/viewstv/MusicPacks;

.field private pendingPack:Lru/oopssre/imperialschool/viewstv/MusicPacks$Pack;

.field private playbackGeneration:J

.field private final playbackTimeout:Ljava/lang/Runnable;

.field player:Lru/oopssre/imperialschool/viewstv/ScenePlayback;

.field playerState:Lru/oopssre/imperialschool/viewstv/SceneMusic$PlayerState;

.field position:I

.field final prefs:Landroid/content/SharedPreferences;

.field private final radioPlayer:Lru/oopssre/imperialschool/viewstv/RadioPlayback;

.field private final refresh:Ljava/lang/Runnable;

.field private final retryChip:Ljava/lang/Runnable;

.field final screensaver:Z

.field private startOperation:J

.field state:Ljava/lang/String;

.field station:Ljava/lang/String;

.field stationName:Ljava/lang/String;

.field final stations:Lru/oopssre/imperialschool/viewstv/ThemeStations;

.field theme:Ljava/lang/String;

.field private trackDirection:I


# direct methods
.method public static synthetic $r8$lambda$pfYt0xZtQuOY1oErlplSV3FCLAQ(Lru/oopssre/imperialschool/viewstv/SceneMusic;Lru/oopssre/imperialschool/viewstv/ScenePlayback;Lru/oopssre/imperialschool/viewstv/ScenePlayback$Event;J)V
    .locals 0

    invoke-direct {p0, p1, p2, p3, p4}, Lru/oopssre/imperialschool/viewstv/SceneMusic;->playbackEvent(Lru/oopssre/imperialschool/viewstv/ScenePlayback;Lru/oopssre/imperialschool/viewstv/ScenePlayback$Event;J)V

    return-void
.end method

.method static constructor <clinit>()V
    .locals 1

    .line 37
    invoke-static {}, Ljava/util/concurrent/Executors;->newSingleThreadExecutor()Ljava/util/concurrent/ExecutorService;

    move-result-object v0

    sput-object v0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->PACK_WORKER:Ljava/util/concurrent/ExecutorService;

    .line 40
    const-string v0, "Europe/Moscow"

    invoke-static {v0}, Ljava/time/ZoneId;->of(Ljava/lang/String;)Ljava/time/ZoneId;

    move-result-object v0

    sput-object v0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->PUBLISH_ZONE:Ljava/time/ZoneId;

    return-void
.end method

.method constructor <init>(Landroid/content/Context;Lru/oopssre/imperialschool/viewstv/Repository;ZLru/oopssre/imperialschool/viewstv/SceneMusic$Listener;)V
    .locals 5

    .line 52
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 22
    new-instance v0, Landroid/os/Handler;

    invoke-static {}, Landroid/os/Looper;->getMainLooper()Landroid/os/Looper;

    move-result-object v1

    invoke-direct {v0, v1}, Landroid/os/Handler;-><init>(Landroid/os/Looper;)V

    iput-object v0, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->main:Landroid/os/Handler;

    .line 23
    new-instance v1, Landroid/media/AudioAttributes$Builder;

    invoke-direct {v1}, Landroid/media/AudioAttributes$Builder;-><init>()V

    const/4 v2, 0x1

    invoke-virtual {v1, v2}, Landroid/media/AudioAttributes$Builder;->setUsage(I)Landroid/media/AudioAttributes$Builder;

    move-result-object v1

    const/4 v3, 0x2

    invoke-virtual {v1, v3}, Landroid/media/AudioAttributes$Builder;->setContentType(I)Landroid/media/AudioAttributes$Builder;

    move-result-object v1

    invoke-virtual {v1}, Landroid/media/AudioAttributes$Builder;->build()Landroid/media/AudioAttributes;

    move-result-object v1

    iput-object v1, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->attributes:Landroid/media/AudioAttributes;

    .line 28
    sget-object v3, Lru/oopssre/imperialschool/viewstv/SceneMusic$PlayerState;->IDLE:Lru/oopssre/imperialschool/viewstv/SceneMusic$PlayerState;

    iput-object v3, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->playerState:Lru/oopssre/imperialschool/viewstv/SceneMusic$PlayerState;

    .line 32
    iput v2, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->trackDirection:I

    .line 33
    new-instance v3, Lru/oopssre/imperialschool/viewstv/SceneMusic$$ExternalSyntheticLambda0;

    invoke-direct {v3, p0}, Lru/oopssre/imperialschool/viewstv/SceneMusic$$ExternalSyntheticLambda0;-><init>(Lru/oopssre/imperialschool/viewstv/SceneMusic;)V

    iput-object v3, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->retryChip:Ljava/lang/Runnable;

    .line 34
    new-instance v3, Lru/oopssre/imperialschool/viewstv/SceneMusic$$ExternalSyntheticLambda1;

    invoke-direct {v3, p0}, Lru/oopssre/imperialschool/viewstv/SceneMusic$$ExternalSyntheticLambda1;-><init>(Lru/oopssre/imperialschool/viewstv/SceneMusic;)V

    iput-object v3, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->playbackTimeout:Ljava/lang/Runnable;

    .line 41
    new-instance v3, Lru/oopssre/imperialschool/viewstv/SceneMusic$$ExternalSyntheticLambda2;

    invoke-direct {v3, p0}, Lru/oopssre/imperialschool/viewstv/SceneMusic$$ExternalSyntheticLambda2;-><init>(Lru/oopssre/imperialschool/viewstv/SceneMusic;)V

    iput-object v3, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->refresh:Ljava/lang/Runnable;

    .line 46
    const-string v3, ""

    iput-object v3, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->theme:Ljava/lang/String;

    .line 47
    iput-object v3, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->station:Ljava/lang/String;

    iput-object v3, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->stationName:Ljava/lang/String;

    .line 49
    const-string v3, "\u041f\u0440\u043e\u0432\u0435\u0440\u043a\u0430 \u043c\u0443\u0437\u044b\u043a\u0438 \u0435\u0449\u0451 \u043d\u0435 \u0432\u044b\u043f\u043e\u043b\u043d\u044f\u043b\u0430\u0441\u044c"

    iput-object v3, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->checkStatus:Ljava/lang/String;

    .line 50
    const-string v3, "\u0412\u044b\u043a\u043b\u044e\u0447\u0435\u043d\u0430"

    iput-object v3, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->state:Ljava/lang/String;

    .line 51
    new-instance v3, Lru/oopssre/imperialschool/viewstv/SceneMusic$1;

    invoke-direct {v3, p0}, Lru/oopssre/imperialschool/viewstv/SceneMusic$1;-><init>(Lru/oopssre/imperialschool/viewstv/SceneMusic;)V

    iput-object v3, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->fade:Ljava/lang/Runnable;

    .line 52
    iput-boolean p3, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->screensaver:Z

    invoke-virtual {p1}, Landroid/content/Context;->getApplicationContext()Landroid/content/Context;

    move-result-object p1

    iput-object p1, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->context:Landroid/content/Context;

    iget-object p3, p2, Lru/oopssre/imperialschool/viewstv/Repository;->prefs:Landroid/content/SharedPreferences;

    iput-object p3, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->prefs:Landroid/content/SharedPreferences;

    new-instance v3, Lru/oopssre/imperialschool/viewstv/MusicPacks;

    iget-object v4, p2, Lru/oopssre/imperialschool/viewstv/Repository;->cache:Lru/oopssre/imperialschool/viewstv/CacheStore;

    iget-object p2, p2, Lru/oopssre/imperialschool/viewstv/Repository;->net:Lru/oopssre/imperialschool/viewstv/HttpTransport;

    invoke-direct {v3, v4, p2}, Lru/oopssre/imperialschool/viewstv/MusicPacks;-><init>(Lru/oopssre/imperialschool/viewstv/CacheStore;Lru/oopssre/imperialschool/viewstv/HttpTransport;)V

    iput-object v3, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->packs:Lru/oopssre/imperialschool/viewstv/MusicPacks;

    new-instance p2, Lru/oopssre/imperialschool/viewstv/ThemeStations;

    invoke-virtual {p1}, Landroid/content/Context;->getAssets()Landroid/content/res/AssetManager;

    move-result-object v3

    invoke-direct {p2, v3, p3}, Lru/oopssre/imperialschool/viewstv/ThemeStations;-><init>(Landroid/content/res/AssetManager;Landroid/content/SharedPreferences;)V

    iput-object p2, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->stations:Lru/oopssre/imperialschool/viewstv/ThemeStations;

    iput-object p4, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->listener:Lru/oopssre/imperialschool/viewstv/SceneMusic$Listener;

    new-instance p2, Lru/oopssre/imperialschool/viewstv/RadioPlayback;

    new-instance p3, Lru/oopssre/imperialschool/viewstv/SceneMusic$$ExternalSyntheticLambda3;

    invoke-direct {p3, p0}, Lru/oopssre/imperialschool/viewstv/SceneMusic$$ExternalSyntheticLambda3;-><init>(Lru/oopssre/imperialschool/viewstv/SceneMusic;)V

    invoke-direct {p2, p1, v0, p3}, Lru/oopssre/imperialschool/viewstv/RadioPlayback;-><init>(Landroid/content/Context;Landroid/os/Handler;Lru/oopssre/imperialschool/viewstv/ScenePlayback$Listener;)V

    iput-object p2, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->radioPlayer:Lru/oopssre/imperialschool/viewstv/RadioPlayback;

    const-string p2, "audio"

    invoke-virtual {p1, p2}, Landroid/content/Context;->getSystemService(Ljava/lang/String;)Ljava/lang/Object;

    move-result-object p1

    check-cast p1, Landroid/media/AudioManager;

    iput-object p1, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->audio:Landroid/media/AudioManager;

    new-instance p1, Landroid/media/AudioFocusRequest$Builder;

    invoke-direct {p1, v2}, Landroid/media/AudioFocusRequest$Builder;-><init>(I)V

    invoke-virtual {p1, v1}, Landroid/media/AudioFocusRequest$Builder;->setAudioAttributes(Landroid/media/AudioAttributes;)Landroid/media/AudioFocusRequest$Builder;

    move-result-object p1

    invoke-virtual {p1, v2}, Landroid/media/AudioFocusRequest$Builder;->setWillPauseWhenDucked(Z)Landroid/media/AudioFocusRequest$Builder;

    move-result-object p1

    new-instance p2, Lru/oopssre/imperialschool/viewstv/SceneMusic$$ExternalSyntheticLambda4;

    invoke-direct {p2, p0}, Lru/oopssre/imperialschool/viewstv/SceneMusic$$ExternalSyntheticLambda4;-><init>(Lru/oopssre/imperialschool/viewstv/SceneMusic;)V

    invoke-virtual {p1, p2, v0}, Landroid/media/AudioFocusRequest$Builder;->setOnAudioFocusChangeListener(Landroid/media/AudioManager$OnAudioFocusChangeListener;Landroid/os/Handler;)Landroid/media/AudioFocusRequest$Builder;

    move-result-object p1

    invoke-virtual {p1}, Landroid/media/AudioFocusRequest$Builder;->build()Landroid/media/AudioFocusRequest;

    move-result-object p1

    iput-object p1, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->focus:Landroid/media/AudioFocusRequest;

    return-void
.end method

.method private abandon()V
    .locals 2

    .line 318
    iget-boolean v0, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->focusRegistered:Z

    const/4 v1, 0x0

    .line 319
    iput-boolean v1, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->focusPaused:Z

    iput-boolean v1, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->focused:Z

    iput-boolean v1, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->focusRegistered:Z

    if-eqz v0, :cond_0

    .line 320
    :try_start_0
    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->audio:Landroid/media/AudioManager;

    iget-object v1, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->focus:Landroid/media/AudioFocusRequest;

    invoke-virtual {v0, v1}, Landroid/media/AudioManager;->abandonAudioFocusRequest(Landroid/media/AudioFocusRequest;)I
    :try_end_0
    .catch Ljava/lang/RuntimeException; {:try_start_0 .. :try_end_0} :catch_0

    :catch_0
    :cond_0
    return-void
.end method

.method private acceptPack(JLru/oopssre/imperialschool/viewstv/MusicPacks$Pack;)V
    .locals 2

    .line 150
    iget-wide v0, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->generation:J

    cmp-long p1, p1, v0

    if-nez p1, :cond_4

    iget-boolean p1, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->destroyed:Z

    if-eqz p1, :cond_0

    goto :goto_0

    .line 151
    :cond_0
    iget-object p1, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->pack:Lru/oopssre/imperialschool/viewstv/MusicPacks$Pack;

    if-eqz p1, :cond_1

    iget-object p1, p1, Lru/oopssre/imperialschool/viewstv/MusicPacks$Pack;->sha:Ljava/lang/String;

    iget-object p2, p3, Lru/oopssre/imperialschool/viewstv/MusicPacks$Pack;->sha:Ljava/lang/String;

    invoke-virtual {p1, p2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p1

    if-eqz p1, :cond_1

    const/4 p1, 0x0

    iput-object p1, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->pendingPack:Lru/oopssre/imperialschool/viewstv/MusicPacks$Pack;

    return-void

    .line 152
    :cond_1
    iput-object p3, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->pendingPack:Lru/oopssre/imperialschool/viewstv/MusicPacks$Pack;

    .line 153
    invoke-virtual {p0}, Lru/oopssre/imperialschool/viewstv/SceneMusic;->radio()Z

    move-result p1

    if-nez p1, :cond_2

    iget-object p1, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->player:Lru/oopssre/imperialschool/viewstv/ScenePlayback;

    if-eqz p1, :cond_2

    goto :goto_0

    .line 154
    :cond_2
    invoke-direct {p0}, Lru/oopssre/imperialschool/viewstv/SceneMusic;->applyPendingPack()V

    .line 155
    invoke-virtual {p0}, Lru/oopssre/imperialschool/viewstv/SceneMusic;->radio()Z

    move-result p1

    if-nez p1, :cond_3

    invoke-direct {p0}, Lru/oopssre/imperialschool/viewstv/SceneMusic;->ensure()V

    return-void

    :cond_3
    invoke-virtual {p0}, Lru/oopssre/imperialschool/viewstv/SceneMusic;->changed()V

    :cond_4
    :goto_0
    return-void
.end method

.method static synthetic access$000(Lru/oopssre/imperialschool/viewstv/SceneMusic;)V
    .locals 0

    .line 16
    invoke-direct {p0}, Lru/oopssre/imperialschool/viewstv/SceneMusic;->applyVolume()V

    return-void
.end method

.method private applyPendingPack()V
    .locals 1

    .line 158
    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->pendingPack:Lru/oopssre/imperialschool/viewstv/MusicPacks$Pack;

    if-nez v0, :cond_0

    return-void

    .line 159
    :cond_0
    iput-object v0, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->pack:Lru/oopssre/imperialschool/viewstv/MusicPacks$Pack;

    const/4 v0, 0x0

    iput-object v0, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->pendingPack:Lru/oopssre/imperialschool/viewstv/MusicPacks$Pack;

    invoke-virtual {p0}, Lru/oopssre/imperialschool/viewstv/SceneMusic;->loadPosition()V

    const/4 v0, 0x0

    iput v0, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->failures:I

    return-void
.end method

.method private applyVolume()V
    .locals 2

    .line 306
    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->playerState:Lru/oopssre/imperialschool/viewstv/SceneMusic$PlayerState;

    sget-object v1, Lru/oopssre/imperialschool/viewstv/SceneMusic$PlayerState;->PLAYING:Lru/oopssre/imperialschool/viewstv/SceneMusic$PlayerState;

    if-ne v0, v1, :cond_0

    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->player:Lru/oopssre/imperialschool/viewstv/ScenePlayback;

    iget v1, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->gain:F

    invoke-interface {v0, v1}, Lru/oopssre/imperialschool/viewstv/ScenePlayback;->volume(F)V

    :cond_0
    return-void
.end method

.method private cancelLoad()V
    .locals 4

    .line 162
    iget-wide v0, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->generation:J

    const-wide/16 v2, 0x1

    add-long/2addr v0, v2

    iput-wide v0, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->generation:J

    const/4 v0, 0x0

    iput-boolean v0, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->loading:Z

    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->main:Landroid/os/Handler;

    iget-object v1, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->refresh:Ljava/lang/Runnable;

    invoke-virtual {v0, v1}, Landroid/os/Handler;->removeCallbacks(Ljava/lang/Runnable;)V

    .line 163
    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->packJob:Ljava/util/concurrent/Future;

    if-eqz v0, :cond_0

    const/4 v1, 0x1

    invoke-interface {v0, v1}, Ljava/util/concurrent/Future;->cancel(Z)Z

    :cond_0
    return-void
.end method

.method static enabledKey(Z)Ljava/lang/String;
    .locals 0

    if-eqz p0, :cond_0

    .line 53
    const-string p0, "music_screensaver_enabled"

    return-object p0

    :cond_0
    const-string p0, "music_app_enabled"

    return-object p0
.end method

.method private ensure()V
    .locals 7

    .line 217
    iget-boolean v0, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->destroyed:Z

    if-nez v0, :cond_e

    iget-boolean v0, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->allowed:Z

    if-eqz v0, :cond_e

    invoke-virtual {p0}, Lru/oopssre/imperialschool/viewstv/SceneMusic;->enabled()Z

    move-result v0

    if-eqz v0, :cond_e

    iget-boolean v0, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->blocked:Z

    if-eqz v0, :cond_0

    goto/16 :goto_6

    .line 218
    :cond_0
    invoke-virtual {p0}, Lru/oopssre/imperialschool/viewstv/SceneMusic;->radio()Z

    move-result v0

    if-nez v0, :cond_2

    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->pack:Lru/oopssre/imperialschool/viewstv/MusicPacks$Pack;

    if-nez v0, :cond_2

    iget-boolean v0, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->loading:Z

    if-eqz v0, :cond_1

    const-string v0, "\u0417\u0430\u0433\u0440\u0443\u0436\u0430\u044e \u043c\u0443\u0437\u044b\u043a\u0443\u2026"

    goto :goto_0

    :cond_1
    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->checkStatus:Ljava/lang/String;

    :goto_0
    iput-object v0, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->state:Ljava/lang/String;

    invoke-virtual {p0}, Lru/oopssre/imperialschool/viewstv/SceneMusic;->changed()V

    return-void

    .line 219
    :cond_2
    iget-boolean v0, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->focusPaused:Z

    if-eqz v0, :cond_3

    goto :goto_3

    .line 220
    :cond_3
    sget-object v0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->owner:Lru/oopssre/imperialschool/viewstv/SceneMusic;

    const/4 v1, 0x1

    if-eqz v0, :cond_4

    if-eq v0, p0, :cond_4

    iput-boolean v1, v0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->blocked:Z

    invoke-direct {v0, v1}, Lru/oopssre/imperialschool/viewstv/SceneMusic;->release(Z)V

    sget-object v0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->owner:Lru/oopssre/imperialschool/viewstv/SceneMusic;

    invoke-direct {v0}, Lru/oopssre/imperialschool/viewstv/SceneMusic;->abandon()V

    sget-object v0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->owner:Lru/oopssre/imperialschool/viewstv/SceneMusic;

    const-string v2, "\u041f\u0430\u0443\u0437\u0430"

    iput-object v2, v0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->state:Ljava/lang/String;

    invoke-virtual {v0}, Lru/oopssre/imperialschool/viewstv/SceneMusic;->changed()V

    :cond_4
    sput-object p0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->owner:Lru/oopssre/imperialschool/viewstv/SceneMusic;

    .line 221
    iget-boolean v0, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->focused:Z

    const/4 v2, 0x0

    if-nez v0, :cond_6

    .line 222
    :try_start_0
    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->audio:Landroid/media/AudioManager;

    iget-object v3, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->focus:Landroid/media/AudioFocusRequest;

    invoke-virtual {v0, v3}, Landroid/media/AudioManager;->requestAudioFocus(Landroid/media/AudioFocusRequest;)I

    move-result v0

    if-ne v0, v1, :cond_5

    move v0, v1

    goto :goto_1

    :cond_5
    move v0, v2

    :goto_1
    iput-boolean v0, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->focused:Z
    :try_end_0
    .catch Ljava/lang/RuntimeException; {:try_start_0 .. :try_end_0} :catch_0

    goto :goto_2

    .line 223
    :catch_0
    iput-boolean v2, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->focused:Z

    .line 224
    :goto_2
    iget-boolean v0, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->focused:Z

    iput-boolean v0, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->focusRegistered:Z

    if-nez v0, :cond_6

    .line 225
    const-string v0, "\u0417\u0432\u0443\u043a \u0437\u0430\u043d\u044f\u0442 \u0434\u0440\u0443\u0433\u0438\u043c \u043f\u0440\u0438\u043b\u043e\u0436\u0435\u043d\u0438\u0435\u043c"

    iput-object v0, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->state:Ljava/lang/String;

    invoke-virtual {p0}, Lru/oopssre/imperialschool/viewstv/SceneMusic;->changed()V

    return-void

    .line 227
    :cond_6
    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->player:Lru/oopssre/imperialschool/viewstv/ScenePlayback;

    if-eqz v0, :cond_9

    .line 228
    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->playerState:Lru/oopssre/imperialschool/viewstv/SceneMusic$PlayerState;

    sget-object v1, Lru/oopssre/imperialschool/viewstv/SceneMusic$PlayerState;->READY:Lru/oopssre/imperialschool/viewstv/SceneMusic$PlayerState;

    if-eq v0, v1, :cond_7

    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->playerState:Lru/oopssre/imperialschool/viewstv/SceneMusic$PlayerState;

    sget-object v1, Lru/oopssre/imperialschool/viewstv/SceneMusic$PlayerState;->PAUSED:Lru/oopssre/imperialschool/viewstv/SceneMusic$PlayerState;

    if-ne v0, v1, :cond_8

    :cond_7
    invoke-direct {p0, v2}, Lru/oopssre/imperialschool/viewstv/SceneMusic;->startPlayback(Z)V

    :cond_8
    :goto_3
    return-void

    .line 231
    :cond_9
    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->main:Landroid/os/Handler;

    iget-object v3, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->retryChip:Ljava/lang/Runnable;

    invoke-virtual {v0, v3}, Landroid/os/Handler;->removeCallbacks(Ljava/lang/Runnable;)V

    .line 232
    invoke-virtual {p0}, Lru/oopssre/imperialschool/viewstv/SceneMusic;->radio()Z

    move-result v0

    const-string v3, "\u041f\u043e\u0434\u0433\u043e\u0442\u043e\u0432\u043a\u0430 \u0442\u0440\u0435\u043a\u0430\u2026"

    if-eqz v0, :cond_a

    .line 233
    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->radioPlayer:Lru/oopssre/imperialschool/viewstv/RadioPlayback;

    iget-object v1, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->station:Ljava/lang/String;

    invoke-virtual {v0, v1}, Lru/oopssre/imperialschool/viewstv/RadioPlayback;->open(Ljava/lang/String;)Lru/oopssre/imperialschool/viewstv/ScenePlayback;

    move-result-object v0

    iput-object v0, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->player:Lru/oopssre/imperialschool/viewstv/ScenePlayback;

    goto :goto_5

    .line 235
    :cond_a
    new-instance v0, Lru/oopssre/imperialschool/viewstv/AudioPlayback;

    iget-object v4, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->main:Landroid/os/Handler;

    new-instance v5, Lru/oopssre/imperialschool/viewstv/SceneMusic$$ExternalSyntheticLambda3;

    invoke-direct {v5, p0}, Lru/oopssre/imperialschool/viewstv/SceneMusic$$ExternalSyntheticLambda3;-><init>(Lru/oopssre/imperialschool/viewstv/SceneMusic;)V

    invoke-direct {v0, v4, v5}, Lru/oopssre/imperialschool/viewstv/AudioPlayback;-><init>(Landroid/os/Handler;Lru/oopssre/imperialschool/viewstv/ScenePlayback$Listener;)V

    .line 236
    iget-object v4, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->pack:Lru/oopssre/imperialschool/viewstv/MusicPacks$Pack;

    iget-object v4, v4, Lru/oopssre/imperialschool/viewstv/MusicPacks$Pack;->tracks:Ljava/util/List;

    iget v5, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->index:I

    invoke-interface {v4, v5}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object v4

    check-cast v4, Lru/oopssre/imperialschool/viewstv/MusicPacks$Track;

    iget v5, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->position:I

    iget-object v6, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->attributes:Landroid/media/AudioAttributes;

    invoke-virtual {v0, v4, v5, v6}, Lru/oopssre/imperialschool/viewstv/AudioPlayback;->connect(Lru/oopssre/imperialschool/viewstv/MusicPacks$Track;ILandroid/media/AudioAttributes;)Z

    move-result v4

    if-nez v4, :cond_c

    .line 237
    iget v0, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->busyRetries:I

    add-int/lit8 v2, v0, 0x1

    iput v2, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->busyRetries:I

    const/16 v2, 0xc

    if-ge v0, v2, :cond_b

    .line 238
    iput-object v3, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->state:Ljava/lang/String;

    .line 239
    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->main:Landroid/os/Handler;

    iget-object v1, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->retryChip:Ljava/lang/Runnable;

    const-wide/16 v2, 0xc8

    invoke-virtual {v0, v1, v2, v3}, Landroid/os/Handler;->postDelayed(Ljava/lang/Runnable;J)Z

    goto :goto_4

    .line 241
    :cond_b
    iput-boolean v1, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->blocked:Z

    const-string v0, "\u041f\u043b\u0435\u0435\u0440 \u0437\u0430\u043d\u044f\u0442"

    iput-object v0, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->state:Ljava/lang/String;

    invoke-direct {p0}, Lru/oopssre/imperialschool/viewstv/SceneMusic;->abandon()V

    .line 243
    :goto_4
    invoke-virtual {p0}, Lru/oopssre/imperialschool/viewstv/SceneMusic;->changed()V

    return-void

    .line 245
    :cond_c
    iput-object v0, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->player:Lru/oopssre/imperialschool/viewstv/ScenePlayback;

    .line 247
    :goto_5
    iput v2, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->busyRetries:I

    .line 248
    sget-object v0, Lru/oopssre/imperialschool/viewstv/SceneMusic$PlayerState;->PREPARING:Lru/oopssre/imperialschool/viewstv/SceneMusic$PlayerState;

    iput-object v0, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->playerState:Lru/oopssre/imperialschool/viewstv/SceneMusic$PlayerState;

    .line 249
    invoke-virtual {p0}, Lru/oopssre/imperialschool/viewstv/SceneMusic;->radio()Z

    move-result v0

    if-eqz v0, :cond_d

    const-string v3, "\u041f\u043e\u0434\u043a\u043b\u044e\u0447\u0430\u044e\u0441\u044c \u043a \u0441\u0442\u0430\u043d\u0446\u0438\u0438\u2026"

    :cond_d
    iput-object v3, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->state:Ljava/lang/String;

    .line 250
    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->main:Landroid/os/Handler;

    iget-object v1, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->playbackTimeout:Ljava/lang/Runnable;

    invoke-direct {p0}, Lru/oopssre/imperialschool/viewstv/SceneMusic;->playbackDeadline()J

    move-result-wide v2

    invoke-virtual {v0, v1, v2, v3}, Landroid/os/Handler;->postDelayed(Ljava/lang/Runnable;J)Z

    .line 251
    invoke-virtual {p0}, Lru/oopssre/imperialschool/viewstv/SceneMusic;->changed()V

    return-void

    .line 217
    :cond_e
    :goto_6
    invoke-virtual {p0}, Lru/oopssre/imperialschool/viewstv/SceneMusic;->enabled()Z

    move-result v0

    if-nez v0, :cond_f

    const-string v0, "\u0412\u044b\u043a\u043b\u044e\u0447\u0435\u043d\u0430"

    iput-object v0, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->state:Ljava/lang/String;

    :cond_f
    invoke-virtual {p0}, Lru/oopssre/imperialschool/viewstv/SceneMusic;->changed()V

    return-void
.end method

.method private failed()V
    .locals 4

    .line 296
    invoke-virtual {p0}, Lru/oopssre/imperialschool/viewstv/SceneMusic;->radio()Z

    move-result v0

    if-nez v0, :cond_0

    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->pendingPack:Lru/oopssre/imperialschool/viewstv/MusicPacks$Pack;

    if-eqz v0, :cond_0

    iget v0, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->trackDirection:I

    invoke-direct {p0, v0}, Lru/oopssre/imperialschool/viewstv/SceneMusic;->select(I)V

    return-void

    :cond_0
    const/4 v0, 0x0

    .line 297
    invoke-direct {p0, v0}, Lru/oopssre/imperialschool/viewstv/SceneMusic;->release(Z)V

    .line 298
    invoke-virtual {p0}, Lru/oopssre/imperialschool/viewstv/SceneMusic;->radio()Z

    move-result v1

    const/4 v2, 0x1

    if-eqz v1, :cond_1

    iput-boolean v2, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->blocked:Z

    const-string v0, "\u0421\u0442\u0430\u043d\u0446\u0438\u044f \u043d\u0435\u0434\u043e\u0441\u0442\u0443\u043f\u043d\u0430"

    iput-object v0, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->state:Ljava/lang/String;

    invoke-direct {p0}, Lru/oopssre/imperialschool/viewstv/SceneMusic;->abandon()V

    invoke-virtual {p0}, Lru/oopssre/imperialschool/viewstv/SceneMusic;->changed()V

    return-void

    .line 299
    :cond_1
    iput v0, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->position:I

    iget v0, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->failures:I

    add-int/2addr v0, v2

    iput v0, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->failures:I

    .line 300
    iget-object v1, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->pack:Lru/oopssre/imperialschool/viewstv/MusicPacks$Pack;

    if-eqz v1, :cond_2

    iget-object v1, v1, Lru/oopssre/imperialschool/viewstv/MusicPacks$Pack;->tracks:Ljava/util/List;

    invoke-interface {v1}, Ljava/util/List;->size()I

    move-result v1

    if-ge v0, v1, :cond_2

    .line 301
    iget v0, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->index:I

    iget v1, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->trackDirection:I

    add-int/2addr v0, v1

    iget-object v1, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->pack:Lru/oopssre/imperialschool/viewstv/MusicPacks$Pack;

    iget-object v1, v1, Lru/oopssre/imperialschool/viewstv/MusicPacks$Pack;->tracks:Ljava/util/List;

    invoke-interface {v1}, Ljava/util/List;->size()I

    move-result v1

    invoke-static {v0, v1}, Ljava/lang/Math;->floorMod(II)I

    move-result v0

    iput v0, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->index:I

    invoke-direct {p0}, Lru/oopssre/imperialschool/viewstv/SceneMusic;->save()V

    .line 302
    iget-wide v0, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->playbackGeneration:J

    iget-object v2, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->main:Landroid/os/Handler;

    new-instance v3, Lru/oopssre/imperialschool/viewstv/SceneMusic$$ExternalSyntheticLambda5;

    invoke-direct {v3, p0, v0, v1}, Lru/oopssre/imperialschool/viewstv/SceneMusic$$ExternalSyntheticLambda5;-><init>(Lru/oopssre/imperialschool/viewstv/SceneMusic;J)V

    const-wide/16 v0, 0x190

    invoke-virtual {v2, v3, v0, v1}, Landroid/os/Handler;->postDelayed(Ljava/lang/Runnable;J)Z

    return-void

    .line 303
    :cond_2
    iput-boolean v2, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->blocked:Z

    const-string v0, "\u041d\u0435 \u0443\u0434\u0430\u043b\u043e\u0441\u044c \u043e\u0442\u043a\u0440\u044b\u0442\u044c \u043c\u0443\u0437\u044b\u043a\u0443"

    iput-object v0, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->state:Ljava/lang/String;

    invoke-direct {p0}, Lru/oopssre/imperialschool/viewstv/SceneMusic;->abandon()V

    invoke-virtual {p0}, Lru/oopssre/imperialschool/viewstv/SceneMusic;->changed()V

    return-void
.end method

.method static synthetic lambda$idle$6()V
    .locals 0

    return-void
.end method

.method private legacyStationKey()Ljava/lang/String;
    .locals 2

    .line 169
    new-instance v0, Ljava/lang/StringBuilder;

    const-string v1, "radio_selected_"

    invoke-direct {v0, v1}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-direct {p0}, Lru/oopssre/imperialschool/viewstv/SceneMusic;->stationScope()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    return-object v0
.end method

.method private loadPack(ZZ)V
    .locals 9

    .line 109
    iget-boolean v0, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->allowed:Z

    if-eqz v0, :cond_1

    iget-boolean v0, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->destroyed:Z

    if-nez v0, :cond_1

    iget-boolean v0, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->loading:Z

    if-eqz v0, :cond_0

    goto :goto_0

    .line 110
    :cond_0
    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->main:Landroid/os/Handler;

    iget-object v1, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->refresh:Ljava/lang/Runnable;

    invoke-virtual {v0, v1}, Landroid/os/Handler;->removeCallbacks(Ljava/lang/Runnable;)V

    const/4 v0, 0x1

    .line 111
    iput-boolean v0, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->loading:Z

    .line 112
    iget-object v3, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->theme:Ljava/lang/String;

    .line 113
    new-instance v0, Ljava/lang/StringBuilder;

    const-string v1, "music_checked_"

    invoke-direct {v0, v1}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v0, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v7

    .line 114
    iget-wide v0, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->generation:J

    const-wide/16 v4, 0x1

    add-long v5, v0, v4

    iput-wide v5, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->generation:J

    .line 115
    sget-object v0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->PACK_WORKER:Ljava/util/concurrent/ExecutorService;

    new-instance v1, Lru/oopssre/imperialschool/viewstv/SceneMusic$$ExternalSyntheticLambda7;

    move-object v2, p0

    move v4, p1

    move v8, p2

    invoke-direct/range {v1 .. v8}, Lru/oopssre/imperialschool/viewstv/SceneMusic$$ExternalSyntheticLambda7;-><init>(Lru/oopssre/imperialschool/viewstv/SceneMusic;Ljava/lang/String;ZJLjava/lang/String;Z)V

    invoke-interface {v0, v1}, Ljava/util/concurrent/ExecutorService;->submit(Ljava/lang/Runnable;)Ljava/util/concurrent/Future;

    move-result-object p1

    iput-object p1, v2, Lru/oopssre/imperialschool/viewstv/SceneMusic;->packJob:Ljava/util/concurrent/Future;

    .line 147
    invoke-virtual {p0}, Lru/oopssre/imperialschool/viewstv/SceneMusic;->changed()V

    return-void

    :cond_1
    :goto_0
    move-object v2, p0

    return-void
.end method

.method static musicCheckDue(JJ)Z
    .locals 1

    cmp-long v0, p0, p2

    if-gtz v0, :cond_1

    .line 102
    invoke-static {p2, p3}, Lru/oopssre/imperialschool/viewstv/SceneMusic;->publicationDay(J)Ljava/time/ZonedDateTime;

    move-result-object p2

    invoke-virtual {p2}, Ljava/time/ZonedDateTime;->toInstant()Ljava/time/Instant;

    move-result-object p2

    invoke-virtual {p2}, Ljava/time/Instant;->toEpochMilli()J

    move-result-wide p2

    cmp-long p0, p0, p2

    if-gez p0, :cond_0

    goto :goto_0

    :cond_0
    const/4 p0, 0x0

    return p0

    :cond_1
    :goto_0
    const/4 p0, 0x1

    return p0
.end method

.method static nextMusicCheck(J)J
    .locals 2

    .line 105
    invoke-static {p0, p1}, Lru/oopssre/imperialschool/viewstv/SceneMusic;->publicationDay(J)Ljava/time/ZonedDateTime;

    move-result-object p0

    const-wide/16 v0, 0x1

    invoke-virtual {p0, v0, v1}, Ljava/time/ZonedDateTime;->plusDays(J)Ljava/time/ZonedDateTime;

    move-result-object p0

    invoke-virtual {p0}, Ljava/time/ZonedDateTime;->toInstant()Ljava/time/Instant;

    move-result-object p0

    invoke-virtual {p0}, Ljava/time/Instant;->toEpochMilli()J

    move-result-wide p0

    return-wide p0
.end method

.method private playbackDeadline()J
    .locals 2

    .line 253
    invoke-virtual {p0}, Lru/oopssre/imperialschool/viewstv/SceneMusic;->radio()Z

    move-result v0

    if-eqz v0, :cond_0

    const-wide/16 v0, 0x3a98

    return-wide v0

    :cond_0
    const-wide/16 v0, 0x7530

    return-wide v0
.end method

.method private playbackEvent(Lru/oopssre/imperialschool/viewstv/ScenePlayback;Lru/oopssre/imperialschool/viewstv/ScenePlayback$Event;J)V
    .locals 1

    .line 264
    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->player:Lru/oopssre/imperialschool/viewstv/ScenePlayback;

    if-ne p1, v0, :cond_b

    iget-boolean p1, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->destroyed:Z

    if-eqz p1, :cond_0

    goto/16 :goto_0

    .line 265
    :cond_0
    sget-object p1, Lru/oopssre/imperialschool/viewstv/SceneMusic$2;->$SwitchMap$ru$oopssre$imperialschool$viewstv$ScenePlayback$Event:[I

    invoke-virtual {p2}, Lru/oopssre/imperialschool/viewstv/ScenePlayback$Event;->ordinal()I

    move-result p2

    aget p1, p1, p2

    const/4 p2, 0x1

    if-eq p1, p2, :cond_8

    const/4 v0, 0x2

    if-eq p1, v0, :cond_6

    const/4 v0, 0x3

    if-eq p1, v0, :cond_4

    const/4 p3, 0x4

    if-eq p1, p3, :cond_2

    const/4 p2, 0x5

    if-eq p1, p2, :cond_1

    goto/16 :goto_0

    .line 291
    :cond_1
    invoke-direct {p0}, Lru/oopssre/imperialschool/viewstv/SceneMusic;->failed()V

    return-void

    .line 288
    :cond_2
    invoke-virtual {p0}, Lru/oopssre/imperialschool/viewstv/SceneMusic;->radio()Z

    move-result p1

    if-eqz p1, :cond_3

    invoke-direct {p0}, Lru/oopssre/imperialschool/viewstv/SceneMusic;->failed()V

    return-void

    :cond_3
    invoke-direct {p0, p2}, Lru/oopssre/imperialschool/viewstv/SceneMusic;->select(I)V

    return-void

    .line 281
    :cond_4
    iget-object p1, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->playerState:Lru/oopssre/imperialschool/viewstv/SceneMusic$PlayerState;

    sget-object p2, Lru/oopssre/imperialschool/viewstv/SceneMusic$PlayerState;->PLAYING:Lru/oopssre/imperialschool/viewstv/SceneMusic$PlayerState;

    if-ne p1, p2, :cond_b

    iget-wide p1, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->startOperation:J

    cmp-long p1, p3, p1

    if-eqz p1, :cond_5

    goto/16 :goto_0

    .line 282
    :cond_5
    iget-object p1, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->main:Landroid/os/Handler;

    iget-object p2, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->fade:Ljava/lang/Runnable;

    invoke-virtual {p1, p2}, Landroid/os/Handler;->removeCallbacks(Ljava/lang/Runnable;)V

    .line 283
    sget-object p1, Lru/oopssre/imperialschool/viewstv/SceneMusic$PlayerState;->STARTING:Lru/oopssre/imperialschool/viewstv/SceneMusic$PlayerState;

    iput-object p1, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->playerState:Lru/oopssre/imperialschool/viewstv/SceneMusic$PlayerState;

    const-string p1, "\u0411\u0443\u0444\u0435\u0440\u0438\u0437\u0430\u0446\u0438\u044f\u2026"

    iput-object p1, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->state:Ljava/lang/String;

    .line 284
    iget-object p1, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->main:Landroid/os/Handler;

    iget-object p2, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->playbackTimeout:Ljava/lang/Runnable;

    invoke-direct {p0}, Lru/oopssre/imperialschool/viewstv/SceneMusic;->playbackDeadline()J

    move-result-wide p3

    invoke-virtual {p1, p2, p3, p4}, Landroid/os/Handler;->postDelayed(Ljava/lang/Runnable;J)Z

    .line 285
    invoke-virtual {p0}, Lru/oopssre/imperialschool/viewstv/SceneMusic;->changed()V

    return-void

    .line 276
    :cond_6
    iget-object p1, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->playerState:Lru/oopssre/imperialschool/viewstv/SceneMusic$PlayerState;

    sget-object p2, Lru/oopssre/imperialschool/viewstv/SceneMusic$PlayerState;->STARTING:Lru/oopssre/imperialschool/viewstv/SceneMusic$PlayerState;

    if-ne p1, p2, :cond_b

    iget-wide p1, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->startOperation:J

    cmp-long p1, p3, p1

    if-eqz p1, :cond_7

    goto :goto_0

    .line 277
    :cond_7
    iget-object p1, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->main:Landroid/os/Handler;

    iget-object p2, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->playbackTimeout:Ljava/lang/Runnable;

    invoke-virtual {p1, p2}, Landroid/os/Handler;->removeCallbacks(Ljava/lang/Runnable;)V

    .line 278
    sget-object p1, Lru/oopssre/imperialschool/viewstv/SceneMusic$PlayerState;->PLAYING:Lru/oopssre/imperialschool/viewstv/SceneMusic$PlayerState;

    iput-object p1, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->playerState:Lru/oopssre/imperialschool/viewstv/SceneMusic$PlayerState;

    const-string p1, "\u0418\u0433\u0440\u0430\u0435\u0442"

    iput-object p1, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->state:Ljava/lang/String;

    invoke-direct {p0}, Lru/oopssre/imperialschool/viewstv/SceneMusic;->ramp()V

    invoke-virtual {p0}, Lru/oopssre/imperialschool/viewstv/SceneMusic;->changed()V

    return-void

    .line 267
    :cond_8
    iget-object p1, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->playerState:Lru/oopssre/imperialschool/viewstv/SceneMusic$PlayerState;

    sget-object p3, Lru/oopssre/imperialschool/viewstv/SceneMusic$PlayerState;->PREPARING:Lru/oopssre/imperialschool/viewstv/SceneMusic$PlayerState;

    if-eq p1, p3, :cond_9

    goto :goto_0

    .line 268
    :cond_9
    sget-object p1, Lru/oopssre/imperialschool/viewstv/SceneMusic$PlayerState;->READY:Lru/oopssre/imperialschool/viewstv/SceneMusic$PlayerState;

    iput-object p1, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->playerState:Lru/oopssre/imperialschool/viewstv/SceneMusic$PlayerState;

    .line 269
    iget-boolean p1, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->allowed:Z

    if-eqz p1, :cond_a

    invoke-virtual {p0}, Lru/oopssre/imperialschool/viewstv/SceneMusic;->enabled()Z

    move-result p1

    if-eqz p1, :cond_a

    iget-boolean p1, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->focused:Z

    if-eqz p1, :cond_a

    iget-boolean p1, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->blocked:Z

    if-nez p1, :cond_a

    invoke-direct {p0, p2}, Lru/oopssre/imperialschool/viewstv/SceneMusic;->startPlayback(Z)V

    return-void

    .line 271
    :cond_a
    iget-object p1, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->main:Landroid/os/Handler;

    iget-object p2, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->playbackTimeout:Ljava/lang/Runnable;

    invoke-virtual {p1, p2}, Landroid/os/Handler;->removeCallbacks(Ljava/lang/Runnable;)V

    .line 272
    sget-object p1, Lru/oopssre/imperialschool/viewstv/SceneMusic$PlayerState;->PAUSED:Lru/oopssre/imperialschool/viewstv/SceneMusic$PlayerState;

    iput-object p1, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->playerState:Lru/oopssre/imperialschool/viewstv/SceneMusic$PlayerState;

    const-string p1, "\u041f\u0430\u0443\u0437\u0430"

    iput-object p1, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->state:Ljava/lang/String;

    invoke-virtual {p0}, Lru/oopssre/imperialschool/viewstv/SceneMusic;->changed()V

    :cond_b
    :goto_0
    return-void
.end method

.method private static publicationDay(J)Ljava/time/ZonedDateTime;
    .locals 3

    .line 97
    invoke-static {p0, p1}, Ljava/time/Instant;->ofEpochMilli(J)Ljava/time/Instant;

    move-result-object p0

    sget-object p1, Lru/oopssre/imperialschool/viewstv/SceneMusic;->PUBLISH_ZONE:Ljava/time/ZoneId;

    invoke-virtual {p0, p1}, Ljava/time/Instant;->atZone(Ljava/time/ZoneId;)Ljava/time/ZonedDateTime;

    move-result-object p0

    .line 98
    invoke-virtual {p0}, Ljava/time/ZonedDateTime;->toLocalDate()Ljava/time/LocalDate;

    move-result-object v0

    const/4 v1, 0x7

    const/4 v2, 0x0

    invoke-virtual {v0, v1, v2}, Ljava/time/LocalDate;->atTime(II)Ljava/time/LocalDateTime;

    move-result-object v0

    invoke-virtual {v0, p1}, Ljava/time/LocalDateTime;->atZone(Ljava/time/ZoneId;)Ljava/time/ZonedDateTime;

    move-result-object p1

    .line 99
    invoke-virtual {p0, p1}, Ljava/time/ZonedDateTime;->isBefore(Ljava/time/chrono/ChronoZonedDateTime;)Z

    move-result p0

    if-eqz p0, :cond_0

    const-wide/16 v0, 0x1

    invoke-virtual {p1, v0, v1}, Ljava/time/ZonedDateTime;->minusDays(J)Ljava/time/ZonedDateTime;

    move-result-object p0

    return-object p0

    :cond_0
    return-object p1
.end method

.method private ramp()V
    .locals 2

    .line 305
    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->main:Landroid/os/Handler;

    iget-object v1, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->fade:Ljava/lang/Runnable;

    invoke-virtual {v0, v1}, Landroid/os/Handler;->removeCallbacks(Ljava/lang/Runnable;)V

    const/4 v0, 0x0

    iput v0, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->gain:F

    invoke-direct {p0}, Lru/oopssre/imperialschool/viewstv/SceneMusic;->applyVolume()V

    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->main:Landroid/os/Handler;

    iget-object v1, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->fade:Ljava/lang/Runnable;

    invoke-virtual {v0, v1}, Landroid/os/Handler;->post(Ljava/lang/Runnable;)Z

    return-void
.end method

.method private release(Z)V
    .locals 4

    .line 308
    iget-wide v0, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->playbackGeneration:J

    const-wide/16 v2, 0x1

    add-long/2addr v0, v2

    iput-wide v0, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->playbackGeneration:J

    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->main:Landroid/os/Handler;

    iget-object v1, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->fade:Ljava/lang/Runnable;

    invoke-virtual {v0, v1}, Landroid/os/Handler;->removeCallbacks(Ljava/lang/Runnable;)V

    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->main:Landroid/os/Handler;

    iget-object v1, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->playbackTimeout:Ljava/lang/Runnable;

    invoke-virtual {v0, v1}, Landroid/os/Handler;->removeCallbacks(Ljava/lang/Runnable;)V

    .line 309
    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->main:Landroid/os/Handler;

    iget-object v1, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->retryChip:Ljava/lang/Runnable;

    invoke-virtual {v0, v1}, Landroid/os/Handler;->removeCallbacks(Ljava/lang/Runnable;)V

    const/4 v0, 0x0

    iput v0, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->busyRetries:I

    .line 310
    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->player:Lru/oopssre/imperialschool/viewstv/ScenePlayback;

    const/4 v1, 0x0

    iput-object v1, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->player:Lru/oopssre/imperialschool/viewstv/ScenePlayback;

    sget-object v2, Lru/oopssre/imperialschool/viewstv/SceneMusic$PlayerState;->IDLE:Lru/oopssre/imperialschool/viewstv/SceneMusic$PlayerState;

    iput-object v2, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->playerState:Lru/oopssre/imperialschool/viewstv/SceneMusic$PlayerState;

    if-eqz v0, :cond_1

    if-eqz p1, :cond_0

    .line 312
    invoke-virtual {p0}, Lru/oopssre/imperialschool/viewstv/SceneMusic;->radio()Z

    move-result p1

    if-nez p1, :cond_0

    invoke-interface {v0}, Lru/oopssre/imperialschool/viewstv/ScenePlayback;->position()I

    move-result p1

    iput p1, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->position:I

    invoke-direct {p0}, Lru/oopssre/imperialschool/viewstv/SceneMusic;->save()V

    .line 313
    :cond_0
    invoke-interface {v0}, Lru/oopssre/imperialschool/viewstv/ScenePlayback;->close()V

    .line 315
    :cond_1
    sget-object p1, Lru/oopssre/imperialschool/viewstv/SceneMusic;->owner:Lru/oopssre/imperialschool/viewstv/SceneMusic;

    if-ne p1, p0, :cond_2

    sput-object v1, Lru/oopssre/imperialschool/viewstv/SceneMusic;->owner:Lru/oopssre/imperialschool/viewstv/SceneMusic;

    :cond_2
    return-void
.end method

.method private restoreStation()V
    .locals 3

    .line 176
    const-string v0, ""

    iput-object v0, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->stationName:Ljava/lang/String;

    iput-object v0, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->station:Ljava/lang/String;

    .line 177
    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->stations:Lru/oopssre/imperialschool/viewstv/ThemeStations;

    iget-object v1, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->theme:Ljava/lang/String;

    invoke-virtual {p0}, Lru/oopssre/imperialschool/viewstv/SceneMusic;->selectedStation()Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v0, v1, v2}, Lru/oopssre/imperialschool/viewstv/ThemeStations;->playable(Ljava/lang/String;Ljava/lang/String;)Lru/oopssre/imperialschool/viewstv/ThemeStations$Station;

    move-result-object v0

    if-eqz v0, :cond_0

    .line 178
    iget-object v1, v0, Lru/oopssre/imperialschool/viewstv/ThemeStations$Station;->url:Ljava/lang/String;

    iput-object v1, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->station:Ljava/lang/String;

    iget-object v0, v0, Lru/oopssre/imperialschool/viewstv/ThemeStations$Station;->title:Ljava/lang/String;

    iput-object v0, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->stationName:Ljava/lang/String;

    :cond_0
    return-void
.end method

.method private save()V
    .locals 4

    .line 215
    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->pack:Lru/oopssre/imperialschool/viewstv/MusicPacks$Pack;

    if-eqz v0, :cond_0

    invoke-virtual {p0}, Lru/oopssre/imperialschool/viewstv/SceneMusic;->radio()Z

    move-result v0

    if-nez v0, :cond_0

    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->prefs:Landroid/content/SharedPreferences;

    invoke-interface {v0}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object v0

    invoke-virtual {p0}, Lru/oopssre/imperialschool/viewstv/SceneMusic;->trackKey()Ljava/lang/String;

    move-result-object v1

    iget v2, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->index:I

    invoke-interface {v0, v1, v2}, Landroid/content/SharedPreferences$Editor;->putInt(Ljava/lang/String;I)Landroid/content/SharedPreferences$Editor;

    move-result-object v0

    invoke-virtual {p0}, Lru/oopssre/imperialschool/viewstv/SceneMusic;->positionKey()Ljava/lang/String;

    move-result-object v1

    iget v2, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->position:I

    invoke-interface {v0, v1, v2}, Landroid/content/SharedPreferences$Editor;->putInt(Ljava/lang/String;I)Landroid/content/SharedPreferences$Editor;

    move-result-object v0

    new-instance v1, Ljava/lang/StringBuilder;

    const-string v2, "music_file_"

    invoke-direct {v1, v2}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    iget-object v2, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->theme:Ljava/lang/String;

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    iget-object v2, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->pack:Lru/oopssre/imperialschool/viewstv/MusicPacks$Pack;

    iget-object v2, v2, Lru/oopssre/imperialschool/viewstv/MusicPacks$Pack;->tracks:Ljava/util/List;

    iget v3, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->index:I

    invoke-interface {v2, v3}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Lru/oopssre/imperialschool/viewstv/MusicPacks$Track;

    iget-object v2, v2, Lru/oopssre/imperialschool/viewstv/MusicPacks$Track;->file:Ljava/lang/String;

    invoke-interface {v0, v1, v2}, Landroid/content/SharedPreferences$Editor;->putString(Ljava/lang/String;Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    move-result-object v0

    invoke-interface {v0}, Landroid/content/SharedPreferences$Editor;->apply()V

    :cond_0
    return-void
.end method

.method private select(I)V
    .locals 4

    .line 205
    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->pack:Lru/oopssre/imperialschool/viewstv/MusicPacks$Pack;

    if-eqz v0, :cond_4

    invoke-virtual {p0}, Lru/oopssre/imperialschool/viewstv/SceneMusic;->radio()Z

    move-result v0

    if-eqz v0, :cond_0

    goto :goto_3

    :cond_0
    const/4 v0, 0x0

    .line 206
    invoke-direct {p0, v0}, Lru/oopssre/imperialschool/viewstv/SceneMusic;->release(Z)V

    .line 207
    iget-object v1, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->pendingPack:Lru/oopssre/imperialschool/viewstv/MusicPacks$Pack;

    if-eqz v1, :cond_3

    .line 208
    iget-object v1, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->pack:Lru/oopssre/imperialschool/viewstv/MusicPacks$Pack;

    iget-object v1, v1, Lru/oopssre/imperialschool/viewstv/MusicPacks$Pack;->tracks:Ljava/util/List;

    iget v2, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->index:I

    invoke-interface {v1, v2}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Lru/oopssre/imperialschool/viewstv/MusicPacks$Track;

    iget-object v1, v1, Lru/oopssre/imperialschool/viewstv/MusicPacks$Track;->file:Ljava/lang/String;

    .line 209
    invoke-direct {p0}, Lru/oopssre/imperialschool/viewstv/SceneMusic;->applyPendingPack()V

    if-lez p1, :cond_1

    const/4 v2, -0x1

    goto :goto_0

    :cond_1
    move v2, v0

    .line 210
    :goto_0
    iput v2, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->index:I

    move v2, v0

    .line 211
    :goto_1
    iget-object v3, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->pack:Lru/oopssre/imperialschool/viewstv/MusicPacks$Pack;

    iget-object v3, v3, Lru/oopssre/imperialschool/viewstv/MusicPacks$Pack;->tracks:Ljava/util/List;

    invoke-interface {v3}, Ljava/util/List;->size()I

    move-result v3

    if-ge v2, v3, :cond_3

    iget-object v3, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->pack:Lru/oopssre/imperialschool/viewstv/MusicPacks$Pack;

    iget-object v3, v3, Lru/oopssre/imperialschool/viewstv/MusicPacks$Pack;->tracks:Ljava/util/List;

    invoke-interface {v3, v2}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object v3

    check-cast v3, Lru/oopssre/imperialschool/viewstv/MusicPacks$Track;

    iget-object v3, v3, Lru/oopssre/imperialschool/viewstv/MusicPacks$Track;->file:Ljava/lang/String;

    invoke-virtual {v3, v1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v3

    if-eqz v3, :cond_2

    iput v2, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->index:I

    goto :goto_2

    :cond_2
    add-int/lit8 v2, v2, 0x1

    goto :goto_1

    .line 213
    :cond_3
    :goto_2
    iput p1, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->trackDirection:I

    iget v1, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->index:I

    add-int/2addr v1, p1

    iget-object p1, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->pack:Lru/oopssre/imperialschool/viewstv/MusicPacks$Pack;

    iget-object p1, p1, Lru/oopssre/imperialschool/viewstv/MusicPacks$Pack;->tracks:Ljava/util/List;

    invoke-interface {p1}, Ljava/util/List;->size()I

    move-result p1

    invoke-static {v1, p1}, Ljava/lang/Math;->floorMod(II)I

    move-result p1

    iput p1, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->index:I

    iput v0, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->position:I

    iput v0, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->failures:I

    iput-boolean v0, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->blocked:Z

    invoke-direct {p0}, Lru/oopssre/imperialschool/viewstv/SceneMusic;->save()V

    invoke-direct {p0}, Lru/oopssre/imperialschool/viewstv/SceneMusic;->ensure()V

    invoke-virtual {p0}, Lru/oopssre/imperialschool/viewstv/SceneMusic;->changed()V

    :cond_4
    :goto_3
    return-void
.end method

.method private startPlayback(Z)V
    .locals 4

    .line 255
    sget-object v0, Lru/oopssre/imperialschool/viewstv/SceneMusic$PlayerState;->STARTING:Lru/oopssre/imperialschool/viewstv/SceneMusic$PlayerState;

    iput-object v0, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->playerState:Lru/oopssre/imperialschool/viewstv/SceneMusic$PlayerState;

    if-nez p1, :cond_1

    .line 257
    invoke-virtual {p0}, Lru/oopssre/imperialschool/viewstv/SceneMusic;->radio()Z

    move-result p1

    if-eqz p1, :cond_0

    const-string p1, "\u041f\u043e\u0434\u043a\u043b\u044e\u0447\u0430\u044e\u0441\u044c \u043a \u0441\u0442\u0430\u043d\u0446\u0438\u0438\u2026"

    goto :goto_0

    :cond_0
    const-string p1, "\u041f\u043e\u0434\u0433\u043e\u0442\u043e\u0432\u043a\u0430 \u0442\u0440\u0435\u043a\u0430\u2026"

    :goto_0
    iput-object p1, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->state:Ljava/lang/String;

    .line 258
    iget-object p1, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->main:Landroid/os/Handler;

    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->playbackTimeout:Ljava/lang/Runnable;

    invoke-direct {p0}, Lru/oopssre/imperialschool/viewstv/SceneMusic;->playbackDeadline()J

    move-result-wide v1

    invoke-virtual {p1, v0, v1, v2}, Landroid/os/Handler;->postDelayed(Ljava/lang/Runnable;J)Z

    .line 259
    invoke-virtual {p0}, Lru/oopssre/imperialschool/viewstv/SceneMusic;->changed()V

    .line 261
    :cond_1
    iget-object p1, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->player:Lru/oopssre/imperialschool/viewstv/ScenePlayback;

    iget-wide v0, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->startOperation:J

    const-wide/16 v2, 0x1

    add-long/2addr v0, v2

    iput-wide v0, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->startOperation:J

    invoke-interface {p1, v0, v1}, Lru/oopssre/imperialschool/viewstv/ScenePlayback;->play(J)V

    return-void
.end method

.method private stationKey()Ljava/lang/String;
    .locals 2

    .line 168
    new-instance v0, Ljava/lang/StringBuilder;

    const-string v1, "radio_station_"

    invoke-direct {v0, v1}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-direct {p0}, Lru/oopssre/imperialschool/viewstv/SceneMusic;->stationScope()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    return-object v0
.end method

.method private stationScope()Ljava/lang/String;
    .locals 2

    .line 167
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    iget-boolean v1, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->screensaver:Z

    if-eqz v1, :cond_0

    const-string v1, "saver_"

    goto :goto_0

    :cond_0
    const-string v1, "app_"

    :goto_0
    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    iget-object v1, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->theme:Ljava/lang/String;

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    return-object v0
.end method


# virtual methods
.method cacheCleared()V
    .locals 1

    const/4 v0, 0x0

    .line 166
    iput-object v0, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->pendingPack:Lru/oopssre/imperialschool/viewstv/MusicPacks$Pack;

    iput-object v0, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->pack:Lru/oopssre/imperialschool/viewstv/MusicPacks$Pack;

    invoke-virtual {p0}, Lru/oopssre/imperialschool/viewstv/SceneMusic;->loadPosition()V

    return-void
.end method

.method canChangeTrack()Z
    .locals 2

    .line 59
    invoke-virtual {p0}, Lru/oopssre/imperialschool/viewstv/SceneMusic;->radio()Z

    move-result v0

    if-nez v0, :cond_0

    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->pack:Lru/oopssre/imperialschool/viewstv/MusicPacks$Pack;

    if-eqz v0, :cond_0

    iget-object v0, v0, Lru/oopssre/imperialschool/viewstv/MusicPacks$Pack;->tracks:Ljava/util/List;

    invoke-interface {v0}, Ljava/util/List;->size()I

    move-result v0

    const/4 v1, 0x1

    if-le v0, v1, :cond_0

    return v1

    :cond_0
    const/4 v0, 0x0

    return v0
.end method

.method changed()V
    .locals 1

    .line 78
    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->listener:Lru/oopssre/imperialschool/viewstv/SceneMusic$Listener;

    invoke-interface {v0}, Lru/oopssre/imperialschool/viewstv/SceneMusic$Listener;->changed()V

    return-void
.end method

.method checkMusic()V
    .locals 2

    const/4 v0, 0x0

    const/4 v1, 0x1

    .line 107
    invoke-direct {p0, v0, v1}, Lru/oopssre/imperialschool/viewstv/SceneMusic;->loadPack(ZZ)V

    return-void
.end method

.method chipMusic()V
    .locals 3

    .line 194
    invoke-virtual {p0}, Lru/oopssre/imperialschool/viewstv/SceneMusic;->radio()Z

    move-result v0

    if-nez v0, :cond_0

    return-void

    :cond_0
    const/4 v0, 0x0

    .line 195
    invoke-direct {p0, v0}, Lru/oopssre/imperialschool/viewstv/SceneMusic;->release(Z)V

    invoke-direct {p0}, Lru/oopssre/imperialschool/viewstv/SceneMusic;->abandon()V

    .line 196
    iget-object v1, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->prefs:Landroid/content/SharedPreferences;

    invoke-interface {v1}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object v1

    invoke-direct {p0}, Lru/oopssre/imperialschool/viewstv/SceneMusic;->stationKey()Ljava/lang/String;

    move-result-object v2

    invoke-interface {v1, v2}, Landroid/content/SharedPreferences$Editor;->remove(Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    move-result-object v1

    invoke-direct {p0}, Lru/oopssre/imperialschool/viewstv/SceneMusic;->legacyStationKey()Ljava/lang/String;

    move-result-object v2

    invoke-interface {v1, v2}, Landroid/content/SharedPreferences$Editor;->remove(Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    move-result-object v1

    invoke-interface {v1}, Landroid/content/SharedPreferences$Editor;->apply()V

    .line 197
    const-string v1, ""

    iput-object v1, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->stationName:Ljava/lang/String;

    iput-object v1, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->station:Ljava/lang/String;

    iput-boolean v0, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->blocked:Z

    const/4 v0, 0x1

    iput v0, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->trackDirection:I

    invoke-direct {p0}, Lru/oopssre/imperialschool/viewstv/SceneMusic;->ensure()V

    return-void
.end method

.method destroy()V
    .locals 2

    const/4 v0, 0x1

    .line 345
    iput-boolean v0, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->destroyed:Z

    const/4 v1, 0x0

    iput-boolean v1, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->allowed:Z

    invoke-direct {p0}, Lru/oopssre/imperialschool/viewstv/SceneMusic;->cancelLoad()V

    invoke-direct {p0, v0}, Lru/oopssre/imperialschool/viewstv/SceneMusic;->release(Z)V

    invoke-direct {p0}, Lru/oopssre/imperialschool/viewstv/SceneMusic;->abandon()V

    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->radioPlayer:Lru/oopssre/imperialschool/viewstv/RadioPlayback;

    invoke-virtual {v0}, Lru/oopssre/imperialschool/viewstv/RadioPlayback;->destroy()V

    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->main:Landroid/os/Handler;

    const/4 v1, 0x0

    invoke-virtual {v0, v1}, Landroid/os/Handler;->removeCallbacksAndMessages(Ljava/lang/Object;)V

    return-void
.end method

.method enabled(Z)V
    .locals 1

    .line 199
    iget-boolean v0, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->screensaver:Z

    invoke-virtual {p0, v0, p1}, Lru/oopssre/imperialschool/viewstv/SceneMusic;->enabled(ZZ)V

    return-void
.end method

.method enabled(ZZ)V
    .locals 2

    .line 200
    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->prefs:Landroid/content/SharedPreferences;

    invoke-interface {v0}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object v0

    invoke-static {p1}, Lru/oopssre/imperialschool/viewstv/SceneMusic;->enabledKey(Z)Ljava/lang/String;

    move-result-object v1

    invoke-interface {v0, v1, p2}, Landroid/content/SharedPreferences$Editor;->putBoolean(Ljava/lang/String;Z)Landroid/content/SharedPreferences$Editor;

    move-result-object v0

    invoke-interface {v0}, Landroid/content/SharedPreferences$Editor;->apply()V

    iget-boolean v0, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->screensaver:Z

    if-eq p1, v0, :cond_0

    invoke-virtual {p0}, Lru/oopssre/imperialschool/viewstv/SceneMusic;->changed()V

    return-void

    :cond_0
    const/4 p1, 0x0

    iput-boolean p1, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->blocked:Z

    iput p1, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->failures:I

    if-eqz p2, :cond_1

    invoke-direct {p0}, Lru/oopssre/imperialschool/viewstv/SceneMusic;->ensure()V

    return-void

    :cond_1
    const/4 p1, 0x1

    invoke-direct {p0, p1}, Lru/oopssre/imperialschool/viewstv/SceneMusic;->release(Z)V

    invoke-direct {p0}, Lru/oopssre/imperialschool/viewstv/SceneMusic;->applyPendingPack()V

    invoke-direct {p0}, Lru/oopssre/imperialschool/viewstv/SceneMusic;->abandon()V

    const-string p1, "\u0412\u044b\u043a\u043b\u044e\u0447\u0435\u043d\u0430"

    iput-object p1, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->state:Ljava/lang/String;

    invoke-virtual {p0}, Lru/oopssre/imperialschool/viewstv/SceneMusic;->changed()V

    return-void
.end method

.method enabled()Z
    .locals 1

    .line 55
    iget-boolean v0, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->screensaver:Z

    invoke-virtual {p0, v0}, Lru/oopssre/imperialschool/viewstv/SceneMusic;->isEnabled(Z)Z

    move-result v0

    return v0
.end method

.method focusChanged(I)V
    .locals 3

    .line 323
    iget-boolean v0, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->destroyed:Z

    if-nez v0, :cond_8

    iget-boolean v0, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->focusRegistered:Z

    if-nez v0, :cond_0

    goto/16 :goto_2

    :cond_0
    const/4 v0, 0x0

    const/4 v1, 0x1

    if-ne p1, v1, :cond_3

    .line 325
    iput-boolean v1, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->focused:Z

    .line 326
    iget-boolean p1, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->focusPaused:Z

    if-eqz p1, :cond_8

    iget-boolean p1, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->allowed:Z

    if-eqz p1, :cond_8

    invoke-virtual {p0}, Lru/oopssre/imperialschool/viewstv/SceneMusic;->enabled()Z

    move-result p1

    if-eqz p1, :cond_8

    iget-boolean p1, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->blocked:Z

    if-nez p1, :cond_8

    .line 327
    iput-boolean v0, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->focusPaused:Z

    .line 328
    iget-object p1, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->playerState:Lru/oopssre/imperialschool/viewstv/SceneMusic$PlayerState;

    sget-object v0, Lru/oopssre/imperialschool/viewstv/SceneMusic$PlayerState;->PREPARING:Lru/oopssre/imperialschool/viewstv/SceneMusic$PlayerState;

    if-ne p1, v0, :cond_2

    .line 329
    invoke-virtual {p0}, Lru/oopssre/imperialschool/viewstv/SceneMusic;->radio()Z

    move-result p1

    if-eqz p1, :cond_1

    const-string p1, "\u041f\u043e\u0434\u043a\u043b\u044e\u0447\u0430\u044e\u0441\u044c \u043a \u0441\u0442\u0430\u043d\u0446\u0438\u0438\u2026"

    goto :goto_0

    :cond_1
    const-string p1, "\u041f\u043e\u0434\u0433\u043e\u0442\u043e\u0432\u043a\u0430 \u0442\u0440\u0435\u043a\u0430\u2026"

    :goto_0
    iput-object p1, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->state:Ljava/lang/String;

    .line 330
    iget-object p1, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->main:Landroid/os/Handler;

    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->playbackTimeout:Ljava/lang/Runnable;

    invoke-direct {p0}, Lru/oopssre/imperialschool/viewstv/SceneMusic;->playbackDeadline()J

    move-result-wide v1

    invoke-virtual {p1, v0, v1, v2}, Landroid/os/Handler;->postDelayed(Ljava/lang/Runnable;J)Z

    .line 331
    invoke-virtual {p0}, Lru/oopssre/imperialschool/viewstv/SceneMusic;->changed()V

    return-void

    .line 332
    :cond_2
    invoke-direct {p0}, Lru/oopssre/imperialschool/viewstv/SceneMusic;->ensure()V

    return-void

    :cond_3
    const/4 v2, -0x2

    if-eq p1, v2, :cond_5

    const/4 v2, -0x3

    if-ne p1, v2, :cond_4

    goto :goto_1

    :cond_4
    const/4 v0, -0x1

    if-ne p1, v0, :cond_8

    .line 342
    iput-boolean v1, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->blocked:Z

    invoke-direct {p0, v1}, Lru/oopssre/imperialschool/viewstv/SceneMusic;->release(Z)V

    invoke-direct {p0}, Lru/oopssre/imperialschool/viewstv/SceneMusic;->applyPendingPack()V

    invoke-direct {p0}, Lru/oopssre/imperialschool/viewstv/SceneMusic;->abandon()V

    const-string p1, "\u041f\u0430\u0443\u0437\u0430 \u2014 \u0434\u0440\u0443\u0433\u043e\u0435 \u043f\u0440\u0438\u043b\u043e\u0436\u0435\u043d\u0438\u0435"

    iput-object p1, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->state:Ljava/lang/String;

    invoke-virtual {p0}, Lru/oopssre/imperialschool/viewstv/SceneMusic;->changed()V

    return-void

    .line 335
    :cond_5
    :goto_1
    iget-object p1, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->main:Landroid/os/Handler;

    iget-object v2, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->fade:Ljava/lang/Runnable;

    invoke-virtual {p1, v2}, Landroid/os/Handler;->removeCallbacks(Ljava/lang/Runnable;)V

    iget-object p1, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->main:Landroid/os/Handler;

    iget-object v2, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->playbackTimeout:Ljava/lang/Runnable;

    invoke-virtual {p1, v2}, Landroid/os/Handler;->removeCallbacks(Ljava/lang/Runnable;)V

    .line 336
    iget-object p1, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->playerState:Lru/oopssre/imperialschool/viewstv/SceneMusic$PlayerState;

    sget-object v2, Lru/oopssre/imperialschool/viewstv/SceneMusic$PlayerState;->STARTING:Lru/oopssre/imperialschool/viewstv/SceneMusic$PlayerState;

    if-eq p1, v2, :cond_6

    iget-object p1, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->playerState:Lru/oopssre/imperialschool/viewstv/SceneMusic$PlayerState;

    sget-object v2, Lru/oopssre/imperialschool/viewstv/SceneMusic$PlayerState;->PLAYING:Lru/oopssre/imperialschool/viewstv/SceneMusic$PlayerState;

    if-ne p1, v2, :cond_7

    .line 337
    :cond_6
    sget-object p1, Lru/oopssre/imperialschool/viewstv/SceneMusic$PlayerState;->PAUSED:Lru/oopssre/imperialschool/viewstv/SceneMusic$PlayerState;

    iput-object p1, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->playerState:Lru/oopssre/imperialschool/viewstv/SceneMusic$PlayerState;

    .line 338
    iget-object p1, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->player:Lru/oopssre/imperialschool/viewstv/ScenePlayback;

    invoke-interface {p1}, Lru/oopssre/imperialschool/viewstv/ScenePlayback;->pause()V

    .line 340
    :cond_7
    iput-boolean v0, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->focused:Z

    iput-boolean v1, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->focusPaused:Z

    const-string p1, "\u041f\u0430\u0443\u0437\u0430 \u2014 \u0434\u0440\u0443\u0433\u043e\u0439 \u0437\u0432\u0443\u043a"

    iput-object p1, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->state:Ljava/lang/String;

    invoke-virtual {p0}, Lru/oopssre/imperialschool/viewstv/SceneMusic;->changed()V

    :cond_8
    :goto_2
    return-void
.end method

.method hasTracks()Z
    .locals 1

    .line 58
    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->pack:Lru/oopssre/imperialschool/viewstv/MusicPacks$Pack;

    if-eqz v0, :cond_0

    const/4 v0, 0x1

    return v0

    :cond_0
    const/4 v0, 0x0

    return v0
.end method

.method idle()Ljava/util/concurrent/Future;
    .locals 2
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "()",
            "Ljava/util/concurrent/Future<",
            "*>;"
        }
    .end annotation

    .line 165
    sget-object v0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->PACK_WORKER:Ljava/util/concurrent/ExecutorService;

    new-instance v1, Lru/oopssre/imperialschool/viewstv/SceneMusic$$ExternalSyntheticLambda6;

    invoke-direct {v1}, Lru/oopssre/imperialschool/viewstv/SceneMusic$$ExternalSyntheticLambda6;-><init>()V

    invoke-interface {v0, v1}, Ljava/util/concurrent/ExecutorService;->submit(Ljava/lang/Runnable;)Ljava/util/concurrent/Future;

    move-result-object v0

    return-object v0
.end method

.method isEnabled(Z)Z
    .locals 4

    .line 54
    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->prefs:Landroid/content/SharedPreferences;

    invoke-static {p1}, Lru/oopssre/imperialschool/viewstv/SceneMusic;->enabledKey(Z)Ljava/lang/String;

    move-result-object v1

    if-nez p1, :cond_0

    iget-object p1, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->prefs:Landroid/content/SharedPreferences;

    const-string v2, "orbital_music"

    const/4 v3, 0x1

    invoke-interface {p1, v2, v3}, Landroid/content/SharedPreferences;->getBoolean(Ljava/lang/String;Z)Z

    move-result p1

    if-eqz p1, :cond_0

    goto :goto_0

    :cond_0
    const/4 v3, 0x0

    :goto_0
    invoke-interface {v0, v1, v3}, Landroid/content/SharedPreferences;->getBoolean(Ljava/lang/String;Z)Z

    move-result p1

    return p1
.end method

.method synthetic lambda$failed$7$ru-oopssre-imperialschool-viewstv-SceneMusic(J)V
    .locals 2

    .line 302
    iget-wide v0, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->playbackGeneration:J

    cmp-long p1, p1, v0

    if-nez p1, :cond_0

    invoke-direct {p0}, Lru/oopssre/imperialschool/viewstv/SceneMusic;->ensure()V

    :cond_0
    return-void
.end method

.method synthetic lambda$loadPack$3$ru-oopssre-imperialschool-viewstv-SceneMusic(JLru/oopssre/imperialschool/viewstv/MusicPacks$Pack;)V
    .locals 0

    .line 117
    invoke-direct {p0, p1, p2, p3}, Lru/oopssre/imperialschool/viewstv/SceneMusic;->acceptPack(JLru/oopssre/imperialschool/viewstv/MusicPacks$Pack;)V

    return-void
.end method

.method synthetic lambda$loadPack$4$ru-oopssre-imperialschool-viewstv-SceneMusic(JLjava/lang/String;Lru/oopssre/imperialschool/viewstv/MusicPacks$Pack;J)V
    .locals 2

    .line 138
    iget-wide v0, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->generation:J

    cmp-long v0, p1, v0

    if-nez v0, :cond_3

    iget-boolean v0, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->destroyed:Z

    if-eqz v0, :cond_0

    goto :goto_0

    :cond_0
    const/4 v0, 0x0

    .line 139
    iput-boolean v0, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->loading:Z

    iput-object p3, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->checkStatus:Ljava/lang/String;

    if-eqz p4, :cond_1

    .line 140
    invoke-direct {p0, p1, p2, p4}, Lru/oopssre/imperialschool/viewstv/SceneMusic;->acceptPack(JLru/oopssre/imperialschool/viewstv/MusicPacks$Pack;)V

    .line 141
    :cond_1
    invoke-virtual {p0}, Lru/oopssre/imperialschool/viewstv/SceneMusic;->radio()Z

    move-result p1

    if-nez p1, :cond_2

    iget-object p1, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->pack:Lru/oopssre/imperialschool/viewstv/MusicPacks$Pack;

    if-nez p1, :cond_2

    invoke-virtual {p0}, Lru/oopssre/imperialschool/viewstv/SceneMusic;->enabled()Z

    move-result p1

    if-eqz p1, :cond_2

    iput-object p3, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->state:Ljava/lang/String;

    .line 142
    :cond_2
    invoke-virtual {p0}, Lru/oopssre/imperialschool/viewstv/SceneMusic;->changed()V

    .line 143
    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J

    move-result-wide p1

    .line 144
    iget-object p3, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->main:Landroid/os/Handler;

    iget-object p4, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->refresh:Ljava/lang/Runnable;

    invoke-static {p5, p6}, Lru/oopssre/imperialschool/viewstv/SceneMusic;->nextMusicCheck(J)J

    move-result-wide p5

    sub-long/2addr p5, p1

    const-wide/16 p1, 0x1

    invoke-static {p1, p2, p5, p6}, Ljava/lang/Math;->max(JJ)J

    move-result-wide p1

    invoke-virtual {p3, p4, p1, p2}, Landroid/os/Handler;->postDelayed(Ljava/lang/Runnable;J)Z

    :cond_3
    :goto_0
    return-void
.end method

.method synthetic lambda$loadPack$5$ru-oopssre-imperialschool-viewstv-SceneMusic(Ljava/lang/String;ZJLjava/lang/String;Z)V
    .locals 19

    .line 0
    move-object/from16 v1, p0

    move-object/from16 v0, p1

    move-object/from16 v2, p5

    move/from16 v3, p6

    .line 116
    const-string v4, "\u041d\u0435 \u0443\u0434\u0430\u043b\u043e\u0441\u044c \u043f\u0440\u043e\u0432\u0435\u0440\u0438\u0442\u044c \u043c\u0443\u0437\u044b\u043a\u0443"

    iget-object v5, v1, Lru/oopssre/imperialschool/viewstv/SceneMusic;->packs:Lru/oopssre/imperialschool/viewstv/MusicPacks;

    invoke-virtual {v5, v0}, Lru/oopssre/imperialschool/viewstv/MusicPacks;->cached(Ljava/lang/String;)Lru/oopssre/imperialschool/viewstv/MusicPacks$Pack;

    move-result-object v5

    if-eqz p2, :cond_0

    if-eqz v5, :cond_0

    .line 117
    iget-object v6, v1, Lru/oopssre/imperialschool/viewstv/SceneMusic;->main:Landroid/os/Handler;

    new-instance v7, Lru/oopssre/imperialschool/viewstv/SceneMusic$$ExternalSyntheticLambda8;

    move-wide/from16 v8, p3

    invoke-direct {v7, v1, v8, v9, v5}, Lru/oopssre/imperialschool/viewstv/SceneMusic$$ExternalSyntheticLambda8;-><init>(Lru/oopssre/imperialschool/viewstv/SceneMusic;JLru/oopssre/imperialschool/viewstv/MusicPacks$Pack;)V

    invoke-virtual {v6, v7}, Landroid/os/Handler;->post(Ljava/lang/Runnable;)Z

    goto :goto_0

    :cond_0
    move-wide/from16 v8, p3

    .line 118
    :goto_0
    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J

    move-result-wide v6

    .line 120
    const-string v10, "\u041c\u0443\u0437\u044b\u043a\u0430 \u0435\u0449\u0451 \u043d\u0435 \u043e\u043f\u0443\u0431\u043b\u0438\u043a\u043e\u0432\u0430\u043d\u0430"

    if-nez v5, :cond_1

    move-object v11, v10

    goto :goto_1

    :cond_1
    const-string v11, "\u041f\u0430\u043a\u0435\u0442 \u0443\u0436\u0435 \u0441\u043e\u0445\u0440\u0430\u043d\u0451\u043d"

    .line 121
    :goto_1
    iget-object v12, v1, Lru/oopssre/imperialschool/viewstv/SceneMusic;->prefs:Landroid/content/SharedPreferences;

    const-wide/16 v13, 0x0

    invoke-interface {v12, v2, v13, v14}, Landroid/content/SharedPreferences;->getLong(Ljava/lang/String;J)J

    move-result-wide v15

    if-nez v3, :cond_3

    move-wide/from16 v17, v13

    .line 123
    invoke-static/range {v15 .. v16}, Ljava/lang/Math;->abs(J)J

    move-result-wide v13

    invoke-static {v13, v14, v6, v7}, Lru/oopssre/imperialschool/viewstv/SceneMusic;->musicCheckDue(JJ)Z

    move-result v12

    if-nez v12, :cond_3

    if-nez v5, :cond_2

    cmp-long v12, v15, v17

    if-lez v12, :cond_2

    goto :goto_2

    :cond_2
    move-object v4, v11

    goto :goto_5

    .line 125
    :cond_3
    :goto_2
    :try_start_0
    iget-object v11, v1, Lru/oopssre/imperialschool/viewstv/SceneMusic;->packs:Lru/oopssre/imperialschool/viewstv/MusicPacks;

    invoke-virtual {v11, v0, v5, v3}, Lru/oopssre/imperialschool/viewstv/MusicPacks;->refresh(Ljava/lang/String;Lru/oopssre/imperialschool/viewstv/MusicPacks$Pack;Z)Lru/oopssre/imperialschool/viewstv/MusicPacks$Pack;

    move-result-object v3
    :try_end_0
    .catch Lru/oopssre/imperialschool/viewstv/HttpTransport$HttpFailure; {:try_start_0 .. :try_end_0} :catch_2
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_3

    if-eqz v5, :cond_4

    .line 126
    :try_start_1
    iget-object v0, v5, Lru/oopssre/imperialschool/viewstv/MusicPacks$Pack;->sha:Ljava/lang/String;

    iget-object v5, v3, Lru/oopssre/imperialschool/viewstv/MusicPacks$Pack;->sha:Ljava/lang/String;

    invoke-virtual {v0, v5}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_4

    const-string v0, "\u041c\u0443\u0437\u044b\u043a\u0430 \u0443\u0436\u0435 \u0430\u043a\u0442\u0443\u0430\u043b\u044c\u043d\u0430"

    goto :goto_3

    :cond_4
    const-string v0, "\u041c\u0443\u0437\u044b\u043a\u0430 \u043e\u0431\u043d\u043e\u0432\u043b\u0435\u043d\u0430"

    .line 127
    :goto_3
    iget-object v5, v1, Lru/oopssre/imperialschool/viewstv/SceneMusic;->prefs:Landroid/content/SharedPreferences;

    invoke-interface {v5}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object v5

    invoke-interface {v5, v2, v6, v7}, Landroid/content/SharedPreferences$Editor;->putLong(Ljava/lang/String;J)Landroid/content/SharedPreferences$Editor;

    move-result-object v5

    invoke-interface {v5}, Landroid/content/SharedPreferences$Editor;->apply()V
    :try_end_1
    .catch Lru/oopssre/imperialschool/viewstv/HttpTransport$HttpFailure; {:try_start_1 .. :try_end_1} :catch_1
    .catch Ljava/lang/Exception; {:try_start_1 .. :try_end_1} :catch_0

    move-object v4, v0

    :catch_0
    move-object v5, v3

    goto :goto_5

    :catch_1
    move-exception v0

    move-object v5, v3

    goto :goto_4

    :catch_2
    move-exception v0

    .line 129
    :goto_4
    iget v0, v0, Lru/oopssre/imperialschool/viewstv/HttpTransport$HttpFailure;->status:I

    const/16 v3, 0x194

    if-ne v0, v3, :cond_5

    .line 131
    iget-object v0, v1, Lru/oopssre/imperialschool/viewstv/SceneMusic;->prefs:Landroid/content/SharedPreferences;

    invoke-interface {v0}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object v0

    neg-long v3, v6

    invoke-interface {v0, v2, v3, v4}, Landroid/content/SharedPreferences$Editor;->putLong(Ljava/lang/String;J)Landroid/content/SharedPreferences$Editor;

    move-result-object v0

    invoke-interface {v0}, Landroid/content/SharedPreferences$Editor;->apply()V

    move-object v4, v10

    .line 137
    :catch_3
    :cond_5
    :goto_5
    iget-object v10, v1, Lru/oopssre/imperialschool/viewstv/SceneMusic;->main:Landroid/os/Handler;

    new-instance v0, Lru/oopssre/imperialschool/viewstv/SceneMusic$$ExternalSyntheticLambda9;

    move-wide v2, v8

    invoke-direct/range {v0 .. v7}, Lru/oopssre/imperialschool/viewstv/SceneMusic$$ExternalSyntheticLambda9;-><init>(Lru/oopssre/imperialschool/viewstv/SceneMusic;JLjava/lang/String;Lru/oopssre/imperialschool/viewstv/MusicPacks$Pack;J)V

    invoke-virtual {v10, v0}, Landroid/os/Handler;->post(Ljava/lang/Runnable;)Z

    return-void
.end method

.method synthetic lambda$new$0$ru-oopssre-imperialschool-viewstv-SceneMusic()V
    .locals 0

    .line 33
    invoke-direct {p0}, Lru/oopssre/imperialschool/viewstv/SceneMusic;->ensure()V

    return-void
.end method

.method synthetic lambda$new$1$ru-oopssre-imperialschool-viewstv-SceneMusic()V
    .locals 2

    .line 35
    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->playerState:Lru/oopssre/imperialschool/viewstv/SceneMusic$PlayerState;

    sget-object v1, Lru/oopssre/imperialschool/viewstv/SceneMusic$PlayerState;->PREPARING:Lru/oopssre/imperialschool/viewstv/SceneMusic$PlayerState;

    if-eq v0, v1, :cond_1

    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->playerState:Lru/oopssre/imperialschool/viewstv/SceneMusic$PlayerState;

    sget-object v1, Lru/oopssre/imperialschool/viewstv/SceneMusic$PlayerState;->STARTING:Lru/oopssre/imperialschool/viewstv/SceneMusic$PlayerState;

    if-ne v0, v1, :cond_0

    goto :goto_0

    :cond_0
    return-void

    :cond_1
    :goto_0
    invoke-direct {p0}, Lru/oopssre/imperialschool/viewstv/SceneMusic;->failed()V

    return-void
.end method

.method synthetic lambda$new$2$ru-oopssre-imperialschool-viewstv-SceneMusic()V
    .locals 1

    .line 0
    const/4 v0, 0x0

    .line 41
    invoke-direct {p0, v0, v0}, Lru/oopssre/imperialschool/viewstv/SceneMusic;->loadPack(ZZ)V

    return-void
.end method

.method level()I
    .locals 3

    .line 56
    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->prefs:Landroid/content/SharedPreferences;

    const-string v1, "music_volume"

    const/16 v2, 0x14

    invoke-interface {v0, v1, v2}, Landroid/content/SharedPreferences;->getInt(Ljava/lang/String;I)I

    move-result v0

    const/16 v1, 0x64

    invoke-static {v1, v0}, Ljava/lang/Math;->min(II)I

    move-result v0

    const/4 v1, 0x0

    invoke-static {v1, v0}, Ljava/lang/Math;->max(II)I

    move-result v0

    return v0
.end method

.method loadPosition()V
    .locals 6

    .line 69
    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->pack:Lru/oopssre/imperialschool/viewstv/MusicPacks$Pack;

    const/4 v1, 0x0

    if-nez v0, :cond_0

    iput v1, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->position:I

    iput v1, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->index:I

    return-void

    .line 70
    :cond_0
    const-string v0, "orbital-port"

    iget-object v2, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->theme:Ljava/lang/String;

    invoke-virtual {v0, v2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    .line 71
    iget-object v2, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->prefs:Landroid/content/SharedPreferences;

    invoke-virtual {p0}, Lru/oopssre/imperialschool/viewstv/SceneMusic;->trackKey()Ljava/lang/String;

    move-result-object v3

    if-eqz v0, :cond_1

    iget-object v4, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->prefs:Landroid/content/SharedPreferences;

    const-string v5, "music_track"

    invoke-interface {v4, v5, v1}, Landroid/content/SharedPreferences;->getInt(Ljava/lang/String;I)I

    move-result v4

    goto :goto_0

    :cond_1
    move v4, v1

    :goto_0
    invoke-interface {v2, v3, v4}, Landroid/content/SharedPreferences;->getInt(Ljava/lang/String;I)I

    move-result v2

    .line 72
    iget-object v3, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->prefs:Landroid/content/SharedPreferences;

    new-instance v4, Ljava/lang/StringBuilder;

    const-string v5, "music_file_"

    invoke-direct {v4, v5}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    iget-object v5, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->theme:Ljava/lang/String;

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v4

    invoke-virtual {v4}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v4

    const-string v5, ""

    invoke-interface {v3, v4, v5}, Landroid/content/SharedPreferences;->getString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v3

    .line 73
    invoke-static {v2, v1}, Ljava/lang/Math;->max(II)I

    move-result v4

    iget-object v5, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->pack:Lru/oopssre/imperialschool/viewstv/MusicPacks$Pack;

    iget-object v5, v5, Lru/oopssre/imperialschool/viewstv/MusicPacks$Pack;->tracks:Ljava/util/List;

    invoke-interface {v5}, Ljava/util/List;->size()I

    move-result v5

    add-int/lit8 v5, v5, -0x1

    invoke-static {v4, v5}, Ljava/lang/Math;->min(II)I

    move-result v4

    iput v4, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->index:I

    .line 74
    invoke-virtual {v3}, Ljava/lang/String;->isEmpty()Z

    move-result v4

    if-nez v4, :cond_3

    move v4, v1

    :goto_1
    iget-object v5, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->pack:Lru/oopssre/imperialschool/viewstv/MusicPacks$Pack;

    iget-object v5, v5, Lru/oopssre/imperialschool/viewstv/MusicPacks$Pack;->tracks:Ljava/util/List;

    invoke-interface {v5}, Ljava/util/List;->size()I

    move-result v5

    if-ge v4, v5, :cond_3

    iget-object v5, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->pack:Lru/oopssre/imperialschool/viewstv/MusicPacks$Pack;

    iget-object v5, v5, Lru/oopssre/imperialschool/viewstv/MusicPacks$Pack;->tracks:Ljava/util/List;

    invoke-interface {v5, v4}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object v5

    check-cast v5, Lru/oopssre/imperialschool/viewstv/MusicPacks$Track;

    iget-object v5, v5, Lru/oopssre/imperialschool/viewstv/MusicPacks$Track;->file:Ljava/lang/String;

    invoke-virtual {v5, v3}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v5

    if-eqz v5, :cond_2

    iput v4, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->index:I

    goto :goto_2

    :cond_2
    add-int/lit8 v4, v4, 0x1

    goto :goto_1

    .line 75
    :cond_3
    :goto_2
    invoke-virtual {v3}, Ljava/lang/String;->isEmpty()Z

    move-result v4

    if-eqz v4, :cond_4

    iget v4, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->index:I

    if-ne v2, v4, :cond_7

    :cond_4
    invoke-virtual {v3}, Ljava/lang/String;->isEmpty()Z

    move-result v2

    if-nez v2, :cond_5

    iget-object v2, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->pack:Lru/oopssre/imperialschool/viewstv/MusicPacks$Pack;

    iget-object v2, v2, Lru/oopssre/imperialschool/viewstv/MusicPacks$Pack;->tracks:Ljava/util/List;

    iget v4, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->index:I

    invoke-interface {v2, v4}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Lru/oopssre/imperialschool/viewstv/MusicPacks$Track;

    iget-object v2, v2, Lru/oopssre/imperialschool/viewstv/MusicPacks$Track;->file:Ljava/lang/String;

    invoke-virtual {v2, v3}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v2

    if-nez v2, :cond_5

    goto :goto_4

    .line 76
    :cond_5
    iget-object v2, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->prefs:Landroid/content/SharedPreferences;

    invoke-virtual {p0}, Lru/oopssre/imperialschool/viewstv/SceneMusic;->positionKey()Ljava/lang/String;

    move-result-object v3

    if-eqz v0, :cond_6

    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->prefs:Landroid/content/SharedPreferences;

    const-string v4, "music_position"

    invoke-interface {v0, v4, v1}, Landroid/content/SharedPreferences;->getInt(Ljava/lang/String;I)I

    move-result v0

    goto :goto_3

    :cond_6
    move v0, v1

    :goto_3
    invoke-interface {v2, v3, v0}, Landroid/content/SharedPreferences;->getInt(Ljava/lang/String;I)I

    move-result v0

    invoke-static {v1, v0}, Ljava/lang/Math;->max(II)I

    move-result v1

    :cond_7
    :goto_4
    iput v1, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->position:I

    return-void
.end method

.method musicCheckStatus()Ljava/lang/String;
    .locals 3

    .line 61
    iget-boolean v0, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->loading:Z

    if-eqz v0, :cond_0

    const-string v0, "\u041f\u0440\u043e\u0432\u0435\u0440\u044f\u044e \u043c\u0443\u0437\u044b\u043a\u0443 \u0442\u0435\u043c\u044b\u2026"

    return-object v0

    .line 62
    :cond_0
    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->pendingPack:Lru/oopssre/imperialschool/viewstv/MusicPacks$Pack;

    if-eqz v0, :cond_1

    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    iget-object v1, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->checkStatus:Ljava/lang/String;

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    const-string v1, "\n\u041d\u043e\u0432\u044b\u0439 \u043f\u0430\u043a\u0435\u0442 \u00b7 \u0442\u0440\u0435\u043a\u043e\u0432 "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    iget-object v1, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->pendingPack:Lru/oopssre/imperialschool/viewstv/MusicPacks$Pack;

    iget-object v1, v1, Lru/oopssre/imperialschool/viewstv/MusicPacks$Pack;->tracks:Ljava/util/List;

    invoke-interface {v1}, Ljava/util/List;->size()I

    move-result v1

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v0

    const-string v1, " \u00b7 \u043f\u043e\u0441\u043b\u0435 \u0442\u0435\u043a\u0443\u0449\u0435\u0433\u043e \u0442\u0440\u0435\u043a\u0430"

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    return-object v0

    .line 63
    :cond_1
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    iget-object v1, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->checkStatus:Ljava/lang/String;

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    iget-object v1, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->pack:Lru/oopssre/imperialschool/viewstv/MusicPacks$Pack;

    if-nez v1, :cond_2

    const-string v1, ""

    goto :goto_0

    :cond_2
    new-instance v1, Ljava/lang/StringBuilder;

    const-string v2, " \u00b7 \u0442\u0440\u0435\u043a\u043e\u0432 "

    invoke-direct {v1, v2}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    iget-object v2, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->pack:Lru/oopssre/imperialschool/viewstv/MusicPacks$Pack;

    iget-object v2, v2, Lru/oopssre/imperialschool/viewstv/MusicPacks$Pack;->tracks:Ljava/util/List;

    invoke-interface {v2}, Ljava/util/List;->size()I

    move-result v2

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    :goto_0
    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    return-object v0
.end method

.method next()V
    .locals 1

    .line 202
    invoke-virtual {p0}, Lru/oopssre/imperialschool/viewstv/SceneMusic;->canChangeTrack()Z

    move-result v0

    if-eqz v0, :cond_0

    const/4 v0, 0x1

    invoke-direct {p0, v0}, Lru/oopssre/imperialschool/viewstv/SceneMusic;->select(I)V

    :cond_0
    return-void
.end method

.method playStation(Ljava/lang/String;)Z
    .locals 5

    .line 181
    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->stations:Lru/oopssre/imperialschool/viewstv/ThemeStations;

    iget-object v1, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->theme:Ljava/lang/String;

    invoke-virtual {v0, v1, p1}, Lru/oopssre/imperialschool/viewstv/ThemeStations;->playable(Ljava/lang/String;Ljava/lang/String;)Lru/oopssre/imperialschool/viewstv/ThemeStations$Station;

    move-result-object v0

    const/4 v1, 0x0

    if-nez v0, :cond_0

    return v1

    .line 183
    :cond_0
    iget-object v2, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->player:Lru/oopssre/imperialschool/viewstv/ScenePlayback;

    const/4 v3, 0x1

    if-eqz v2, :cond_1

    invoke-virtual {p0}, Lru/oopssre/imperialschool/viewstv/SceneMusic;->enabled()Z

    move-result v2

    if-eqz v2, :cond_1

    iget-boolean v2, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->blocked:Z

    if-nez v2, :cond_1

    invoke-virtual {p0}, Lru/oopssre/imperialschool/viewstv/SceneMusic;->selectedStation()Ljava/lang/String;

    move-result-object v2

    invoke-virtual {p1, v2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v2

    if-eqz v2, :cond_1

    iget-object v2, v0, Lru/oopssre/imperialschool/viewstv/ThemeStations$Station;->url:Ljava/lang/String;

    iget-object v4, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->station:Ljava/lang/String;

    invoke-virtual {v2, v4}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v2

    if-eqz v2, :cond_1

    return v3

    .line 184
    :cond_1
    invoke-direct {p0, v3}, Lru/oopssre/imperialschool/viewstv/SceneMusic;->release(Z)V

    invoke-direct {p0}, Lru/oopssre/imperialschool/viewstv/SceneMusic;->applyPendingPack()V

    .line 185
    iget-object v2, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->prefs:Landroid/content/SharedPreferences;

    invoke-interface {v2}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object v2

    invoke-direct {p0}, Lru/oopssre/imperialschool/viewstv/SceneMusic;->stationKey()Ljava/lang/String;

    move-result-object v4

    invoke-interface {v2, v4, p1}, Landroid/content/SharedPreferences$Editor;->putString(Ljava/lang/String;Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    move-result-object p1

    invoke-interface {p1}, Landroid/content/SharedPreferences$Editor;->apply()V

    .line 186
    iget-object p1, v0, Lru/oopssre/imperialschool/viewstv/ThemeStations$Station;->url:Ljava/lang/String;

    iput-object p1, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->station:Ljava/lang/String;

    iget-object p1, v0, Lru/oopssre/imperialschool/viewstv/ThemeStations$Station;->title:Ljava/lang/String;

    iput-object p1, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->stationName:Ljava/lang/String;

    .line 187
    iput-boolean v1, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->blocked:Z

    invoke-virtual {p0, v3}, Lru/oopssre/imperialschool/viewstv/SceneMusic;->enabled(Z)V

    return v3
.end method

.method positionKey()Ljava/lang/String;
    .locals 2

    .line 67
    new-instance v0, Ljava/lang/StringBuilder;

    const-string v1, "music_position_"

    invoke-direct {v0, v1}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    iget-object v1, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->theme:Ljava/lang/String;

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    return-object v0
.end method

.method previous()V
    .locals 1

    .line 203
    invoke-virtual {p0}, Lru/oopssre/imperialschool/viewstv/SceneMusic;->canChangeTrack()Z

    move-result v0

    if-eqz v0, :cond_0

    const/4 v0, -0x1

    invoke-direct {p0, v0}, Lru/oopssre/imperialschool/viewstv/SceneMusic;->select(I)V

    :cond_0
    return-void
.end method

.method proxyChanged()V
    .locals 1

    .line 190
    invoke-virtual {p0}, Lru/oopssre/imperialschool/viewstv/SceneMusic;->radio()Z

    move-result v0

    if-nez v0, :cond_0

    return-void

    :cond_0
    const/4 v0, 0x0

    .line 191
    invoke-direct {p0, v0}, Lru/oopssre/imperialschool/viewstv/SceneMusic;->release(Z)V

    iput-boolean v0, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->blocked:Z

    iput v0, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->failures:I

    invoke-direct {p0}, Lru/oopssre/imperialschool/viewstv/SceneMusic;->ensure()V

    return-void
.end method

.method radio()Z
    .locals 1

    .line 65
    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->station:Ljava/lang/String;

    invoke-virtual {v0}, Ljava/lang/String;->isEmpty()Z

    move-result v0

    xor-int/lit8 v0, v0, 0x1

    return v0
.end method

.method scene(ZLjava/lang/String;)V
    .locals 4

    .line 80
    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->theme:Ljava/lang/String;

    invoke-virtual {p2, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    const/4 v1, 0x0

    const/4 v2, 0x1

    if-eqz v0, :cond_0

    if-nez p1, :cond_2

    .line 81
    iget-boolean v3, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->allowed:Z

    if-eqz v3, :cond_2

    .line 82
    :cond_0
    invoke-direct {p0, v2}, Lru/oopssre/imperialschool/viewstv/SceneMusic;->release(Z)V

    invoke-direct {p0}, Lru/oopssre/imperialschool/viewstv/SceneMusic;->abandon()V

    invoke-direct {p0}, Lru/oopssre/imperialschool/viewstv/SceneMusic;->cancelLoad()V

    iput-boolean v1, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->blocked:Z

    if-nez v0, :cond_1

    .line 84
    iput-object p2, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->theme:Ljava/lang/String;

    const/4 p2, 0x0

    iput-object p2, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->pendingPack:Lru/oopssre/imperialschool/viewstv/MusicPacks$Pack;

    iput-object p2, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->pack:Lru/oopssre/imperialschool/viewstv/MusicPacks$Pack;

    iput v1, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->failures:I

    iput v2, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->trackDirection:I

    invoke-virtual {p0}, Lru/oopssre/imperialschool/viewstv/SceneMusic;->loadPosition()V

    const-string p2, ""

    iput-object p2, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->stationName:Ljava/lang/String;

    iput-object p2, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->station:Ljava/lang/String;

    .line 85
    const-string p2, "\u041f\u0440\u043e\u0432\u0435\u0440\u043a\u0430 \u043c\u0443\u0437\u044b\u043a\u0438 \u0435\u0449\u0451 \u043d\u0435 \u0432\u044b\u043f\u043e\u043b\u043d\u044f\u043b\u0430\u0441\u044c"

    iput-object p2, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->checkStatus:Ljava/lang/String;

    goto :goto_0

    .line 86
    :cond_1
    invoke-direct {p0}, Lru/oopssre/imperialschool/viewstv/SceneMusic;->applyPendingPack()V

    .line 87
    :goto_0
    iput-boolean v1, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->allowed:Z

    :cond_2
    if-nez p1, :cond_4

    .line 89
    invoke-virtual {p0}, Lru/oopssre/imperialschool/viewstv/SceneMusic;->enabled()Z

    move-result p1

    if-eqz p1, :cond_3

    const-string p1, "\u041f\u0430\u0443\u0437\u0430"

    goto :goto_1

    :cond_3
    const-string p1, "\u0412\u044b\u043a\u043b\u044e\u0447\u0435\u043d\u0430"

    :goto_1
    iput-object p1, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->state:Ljava/lang/String;

    invoke-virtual {p0}, Lru/oopssre/imperialschool/viewstv/SceneMusic;->changed()V

    return-void

    .line 90
    :cond_4
    iget-boolean p1, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->allowed:Z

    if-eqz p1, :cond_5

    return-void

    .line 91
    :cond_5
    iput-boolean v2, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->allowed:Z

    .line 92
    invoke-direct {p0}, Lru/oopssre/imperialschool/viewstv/SceneMusic;->restoreStation()V

    .line 93
    invoke-direct {p0, v2, v1}, Lru/oopssre/imperialschool/viewstv/SceneMusic;->loadPack(ZZ)V

    .line 94
    invoke-direct {p0}, Lru/oopssre/imperialschool/viewstv/SceneMusic;->ensure()V

    return-void
.end method

.method selectedStation()Ljava/lang/String;
    .locals 4

    .line 171
    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->prefs:Landroid/content/SharedPreferences;

    invoke-direct {p0}, Lru/oopssre/imperialschool/viewstv/SceneMusic;->stationKey()Ljava/lang/String;

    move-result-object v1

    const-string v2, ""

    invoke-interface {v0, v1, v2}, Landroid/content/SharedPreferences;->getString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    .line 172
    iget-object v1, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->prefs:Landroid/content/SharedPreferences;

    invoke-direct {p0}, Lru/oopssre/imperialschool/viewstv/SceneMusic;->legacyStationKey()Ljava/lang/String;

    move-result-object v2

    const/4 v3, 0x0

    invoke-interface {v1, v2, v3}, Landroid/content/SharedPreferences;->getInt(Ljava/lang/String;I)I

    move-result v1

    .line 173
    invoke-virtual {v0}, Ljava/lang/String;->isEmpty()Z

    move-result v2

    if-eqz v2, :cond_0

    if-lez v1, :cond_0

    new-instance v0, Ljava/lang/StringBuilder;

    const-string v2, "local-"

    invoke-direct {v0, v2}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    :cond_0
    return-object v0
.end method

.method title()Ljava/lang/String;
    .locals 2

    .line 57
    invoke-virtual {p0}, Lru/oopssre/imperialschool/viewstv/SceneMusic;->radio()Z

    move-result v0

    if-eqz v0, :cond_0

    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->stationName:Ljava/lang/String;

    return-object v0

    :cond_0
    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->pack:Lru/oopssre/imperialschool/viewstv/MusicPacks$Pack;

    if-nez v0, :cond_1

    const-string v0, ""

    return-object v0

    :cond_1
    iget-object v0, v0, Lru/oopssre/imperialschool/viewstv/MusicPacks$Pack;->tracks:Ljava/util/List;

    iget v1, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->index:I

    invoke-interface {v0, v1}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Lru/oopssre/imperialschool/viewstv/MusicPacks$Track;

    iget-object v0, v0, Lru/oopssre/imperialschool/viewstv/MusicPacks$Track;->title:Ljava/lang/String;

    return-object v0
.end method

.method trackKey()Ljava/lang/String;
    .locals 2

    .line 66
    new-instance v0, Ljava/lang/StringBuilder;

    const-string v1, "music_track_"

    invoke-direct {v0, v1}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    iget-object v1, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->theme:Ljava/lang/String;

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    return-object v0
.end method

.method volume(I)V
    .locals 2

    .line 201
    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->prefs:Landroid/content/SharedPreferences;

    invoke-interface {v0}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object v0

    const/16 v1, 0x64

    invoke-static {v1, p1}, Ljava/lang/Math;->min(II)I

    move-result p1

    const/4 v1, 0x0

    invoke-static {v1, p1}, Ljava/lang/Math;->max(II)I

    move-result p1

    const-string v1, "music_volume"

    invoke-interface {v0, v1, p1}, Landroid/content/SharedPreferences$Editor;->putInt(Ljava/lang/String;I)Landroid/content/SharedPreferences$Editor;

    move-result-object p1

    invoke-interface {p1}, Landroid/content/SharedPreferences$Editor;->apply()V

    iget-object p1, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->main:Landroid/os/Handler;

    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->fade:Ljava/lang/Runnable;

    invoke-virtual {p1, v0}, Landroid/os/Handler;->removeCallbacks(Ljava/lang/Runnable;)V

    invoke-virtual {p0}, Lru/oopssre/imperialschool/viewstv/SceneMusic;->level()I

    move-result p1

    int-to-float p1, p1

    const/high16 v0, 0x42c80000    # 100.0f

    div-float/2addr p1, v0

    iput p1, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->gain:F

    invoke-direct {p0}, Lru/oopssre/imperialschool/viewstv/SceneMusic;->applyVolume()V

    invoke-virtual {p0}, Lru/oopssre/imperialschool/viewstv/SceneMusic;->changed()V

    return-void
.end method
