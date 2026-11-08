.class final Lru/oopssre/imperialschool/viewstv/RadioPlayback;
.super Ljava/lang/Object;
.source "RadioPlayback.java"


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lru/oopssre/imperialschool/viewstv/RadioPlayback$Session;
    }
.end annotation


# static fields
.field private static final TAG:Ljava/lang/String; = "ImperialTvRadio"


# instance fields
.field private final context:Landroid/content/Context;

.field private current:Lru/oopssre/imperialschool/viewstv/RadioPlayback$Session;

.field private engine:Landroidx/media3/exoplayer/ExoPlayer;

.field private final listener:Lru/oopssre/imperialschool/viewstv/ScenePlayback$Listener;

.field private final main:Landroid/os/Handler;

.field private sequence:J

.field private thread:Landroid/os/HandlerThread;

.field private worker:Landroid/os/Handler;


# direct methods
.method constructor <init>(Landroid/content/Context;Landroid/os/Handler;Lru/oopssre/imperialschool/viewstv/ScenePlayback$Listener;)V
    .locals 0

    .line 30
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 31
    iput-object p1, p0, Lru/oopssre/imperialschool/viewstv/RadioPlayback;->context:Landroid/content/Context;

    .line 32
    iput-object p2, p0, Lru/oopssre/imperialschool/viewstv/RadioPlayback;->main:Landroid/os/Handler;

    .line 33
    iput-object p3, p0, Lru/oopssre/imperialschool/viewstv/RadioPlayback;->listener:Lru/oopssre/imperialschool/viewstv/ScenePlayback$Listener;

    return-void
.end method

.method static synthetic access$000(Lru/oopssre/imperialschool/viewstv/RadioPlayback;)Lru/oopssre/imperialschool/viewstv/RadioPlayback$Session;
    .locals 0

    .line 19
    iget-object p0, p0, Lru/oopssre/imperialschool/viewstv/RadioPlayback;->current:Lru/oopssre/imperialschool/viewstv/RadioPlayback$Session;

    return-object p0
.end method

.method static synthetic access$002(Lru/oopssre/imperialschool/viewstv/RadioPlayback;Lru/oopssre/imperialschool/viewstv/RadioPlayback$Session;)Lru/oopssre/imperialschool/viewstv/RadioPlayback$Session;
    .locals 0

    .line 19
    iput-object p1, p0, Lru/oopssre/imperialschool/viewstv/RadioPlayback;->current:Lru/oopssre/imperialschool/viewstv/RadioPlayback$Session;

    return-object p1
.end method

.method static synthetic access$100(Lru/oopssre/imperialschool/viewstv/RadioPlayback;)Landroid/os/Handler;
    .locals 0

    .line 19
    iget-object p0, p0, Lru/oopssre/imperialschool/viewstv/RadioPlayback;->worker:Landroid/os/Handler;

    return-object p0
.end method

.method static synthetic access$200(Lru/oopssre/imperialschool/viewstv/RadioPlayback;)Landroid/os/Handler;
    .locals 0

    .line 19
    iget-object p0, p0, Lru/oopssre/imperialschool/viewstv/RadioPlayback;->main:Landroid/os/Handler;

    return-object p0
.end method

.method static synthetic access$300(Lru/oopssre/imperialschool/viewstv/RadioPlayback;)Lru/oopssre/imperialschool/viewstv/ScenePlayback$Listener;
    .locals 0

    .line 19
    iget-object p0, p0, Lru/oopssre/imperialschool/viewstv/RadioPlayback;->listener:Lru/oopssre/imperialschool/viewstv/ScenePlayback$Listener;

    return-object p0
.end method

.method static synthetic access$400(Lru/oopssre/imperialschool/viewstv/RadioPlayback;)Landroidx/media3/exoplayer/ExoPlayer;
    .locals 0

    .line 19
    iget-object p0, p0, Lru/oopssre/imperialschool/viewstv/RadioPlayback;->engine:Landroidx/media3/exoplayer/ExoPlayer;

    return-object p0
.end method

.method private createEngine()V
    .locals 6

    .line 61
    new-instance v0, Landroidx/media3/datasource/DefaultHttpDataSource$Factory;

    invoke-direct {v0}, Landroidx/media3/datasource/DefaultHttpDataSource$Factory;-><init>()V

    const-string v1, "ImperialSchoolViewsTV/0.8.7"

    .line 62
    invoke-virtual {v0, v1}, Landroidx/media3/datasource/DefaultHttpDataSource$Factory;->setUserAgent(Ljava/lang/String;)Landroidx/media3/datasource/DefaultHttpDataSource$Factory;

    move-result-object v0

    const/16 v1, 0x1f40

    .line 63
    invoke-virtual {v0, v1}, Landroidx/media3/datasource/DefaultHttpDataSource$Factory;->setConnectTimeoutMs(I)Landroidx/media3/datasource/DefaultHttpDataSource$Factory;

    move-result-object v0

    const/16 v1, 0x2710

    .line 64
    invoke-virtual {v0, v1}, Landroidx/media3/datasource/DefaultHttpDataSource$Factory;->setReadTimeoutMs(I)Landroidx/media3/datasource/DefaultHttpDataSource$Factory;

    move-result-object v0

    .line 65
    new-instance v1, Landroidx/media3/exoplayer/ExoPlayer$Builder;

    iget-object v2, p0, Lru/oopssre/imperialschool/viewstv/RadioPlayback;->context:Landroid/content/Context;

    invoke-direct {v1, v2}, Landroidx/media3/exoplayer/ExoPlayer$Builder;-><init>(Landroid/content/Context;)V

    iget-object v2, p0, Lru/oopssre/imperialschool/viewstv/RadioPlayback;->worker:Landroid/os/Handler;

    .line 66
    invoke-virtual {v2}, Landroid/os/Handler;->getLooper()Landroid/os/Looper;

    move-result-object v2

    invoke-virtual {v1, v2}, Landroidx/media3/exoplayer/ExoPlayer$Builder;->setLooper(Landroid/os/Looper;)Landroidx/media3/exoplayer/ExoPlayer$Builder;

    move-result-object v1

    new-instance v2, Landroidx/media3/exoplayer/source/DefaultMediaSourceFactory;

    new-instance v3, Landroidx/media3/datasource/DefaultDataSource$Factory;

    iget-object v4, p0, Lru/oopssre/imperialschool/viewstv/RadioPlayback;->context:Landroid/content/Context;

    invoke-direct {v3, v4, v0}, Landroidx/media3/datasource/DefaultDataSource$Factory;-><init>(Landroid/content/Context;Landroidx/media3/datasource/DataSource$Factory;)V

    invoke-direct {v2, v3}, Landroidx/media3/exoplayer/source/DefaultMediaSourceFactory;-><init>(Landroidx/media3/datasource/DataSource$Factory;)V

    .line 67
    invoke-virtual {v1, v2}, Landroidx/media3/exoplayer/ExoPlayer$Builder;->setMediaSourceFactory(Landroidx/media3/exoplayer/source/MediaSource$Factory;)Landroidx/media3/exoplayer/ExoPlayer$Builder;

    move-result-object v0

    new-instance v1, Landroidx/media3/common/AudioAttributes$Builder;

    invoke-direct {v1}, Landroidx/media3/common/AudioAttributes$Builder;-><init>()V

    const/4 v2, 0x1

    .line 68
    invoke-virtual {v1, v2}, Landroidx/media3/common/AudioAttributes$Builder;->setUsage(I)Landroidx/media3/common/AudioAttributes$Builder;

    move-result-object v1

    const/4 v3, 0x2

    .line 69
    invoke-virtual {v1, v3}, Landroidx/media3/common/AudioAttributes$Builder;->setContentType(I)Landroidx/media3/common/AudioAttributes$Builder;

    move-result-object v1

    invoke-virtual {v1}, Landroidx/media3/common/AudioAttributes$Builder;->build()Landroidx/media3/common/AudioAttributes;

    move-result-object v1

    const/4 v4, 0x0

    .line 68
    invoke-virtual {v0, v1, v4}, Landroidx/media3/exoplayer/ExoPlayer$Builder;->setAudioAttributes(Landroidx/media3/common/AudioAttributes;Z)Landroidx/media3/exoplayer/ExoPlayer$Builder;

    move-result-object v0

    const-wide/16 v4, 0x3e8

    .line 70
    invoke-virtual {v0, v4, v5}, Landroidx/media3/exoplayer/ExoPlayer$Builder;->setReleaseTimeoutMs(J)Landroidx/media3/exoplayer/ExoPlayer$Builder;

    move-result-object v0

    .line 71
    invoke-virtual {v0}, Landroidx/media3/exoplayer/ExoPlayer$Builder;->build()Landroidx/media3/exoplayer/ExoPlayer;

    move-result-object v0

    iput-object v0, p0, Lru/oopssre/imperialschool/viewstv/RadioPlayback;->engine:Landroidx/media3/exoplayer/ExoPlayer;

    .line 72
    invoke-interface {v0}, Landroidx/media3/exoplayer/ExoPlayer;->getTrackSelectionParameters()Landroidx/media3/common/TrackSelectionParameters;

    move-result-object v1

    invoke-virtual {v1}, Landroidx/media3/common/TrackSelectionParameters;->buildUpon()Landroidx/media3/common/TrackSelectionParameters$Builder;

    move-result-object v1

    .line 73
    invoke-virtual {v1, v3, v2}, Landroidx/media3/common/TrackSelectionParameters$Builder;->setTrackTypeDisabled(IZ)Landroidx/media3/common/TrackSelectionParameters$Builder;

    move-result-object v1

    const/4 v3, 0x3

    .line 74
    invoke-virtual {v1, v3, v2}, Landroidx/media3/common/TrackSelectionParameters$Builder;->setTrackTypeDisabled(IZ)Landroidx/media3/common/TrackSelectionParameters$Builder;

    move-result-object v1

    .line 75
    invoke-virtual {v1}, Landroidx/media3/common/TrackSelectionParameters$Builder;->build()Landroidx/media3/common/TrackSelectionParameters;

    move-result-object v1

    .line 72
    invoke-interface {v0, v1}, Landroidx/media3/exoplayer/ExoPlayer;->setTrackSelectionParameters(Landroidx/media3/common/TrackSelectionParameters;)V

    .line 76
    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/RadioPlayback;->engine:Landroidx/media3/exoplayer/ExoPlayer;

    new-instance v1, Lru/oopssre/imperialschool/viewstv/RadioPlayback$1;

    invoke-direct {v1, p0}, Lru/oopssre/imperialschool/viewstv/RadioPlayback$1;-><init>(Lru/oopssre/imperialschool/viewstv/RadioPlayback;)V

    invoke-interface {v0, v1}, Landroidx/media3/exoplayer/ExoPlayer;->addListener(Landroidx/media3/common/Player$Listener;)V

    return-void
.end method


# virtual methods
.method destroy()V
    .locals 2

    .line 86
    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/RadioPlayback;->worker:Landroid/os/Handler;

    if-nez v0, :cond_0

    return-void

    .line 87
    :cond_0
    new-instance v1, Lru/oopssre/imperialschool/viewstv/RadioPlayback$$ExternalSyntheticLambda0;

    invoke-direct {v1, p0}, Lru/oopssre/imperialschool/viewstv/RadioPlayback$$ExternalSyntheticLambda0;-><init>(Lru/oopssre/imperialschool/viewstv/RadioPlayback;)V

    invoke-virtual {v0, v1}, Landroid/os/Handler;->post(Ljava/lang/Runnable;)Z

    return-void
.end method

.method synthetic lambda$destroy$1$ru-oopssre-imperialschool-viewstv-RadioPlayback()V
    .locals 4

    .line 0
    const/4 v0, 0x0

    .line 88
    iput-object v0, p0, Lru/oopssre/imperialschool/viewstv/RadioPlayback;->current:Lru/oopssre/imperialschool/viewstv/RadioPlayback$Session;

    .line 90
    :try_start_0
    iget-object v1, p0, Lru/oopssre/imperialschool/viewstv/RadioPlayback;->engine:Landroidx/media3/exoplayer/ExoPlayer;

    if-eqz v1, :cond_0

    invoke-interface {v1}, Landroidx/media3/exoplayer/ExoPlayer;->release()V
    :try_end_0
    .catch Ljava/lang/RuntimeException; {:try_start_0 .. :try_end_0} :catch_1
    .catch Ljava/lang/LinkageError; {:try_start_0 .. :try_end_0} :catch_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 94
    :cond_0
    :goto_0
    iput-object v0, p0, Lru/oopssre/imperialschool/viewstv/RadioPlayback;->engine:Landroidx/media3/exoplayer/ExoPlayer;

    .line 95
    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/RadioPlayback;->thread:Landroid/os/HandlerThread;

    invoke-virtual {v0}, Landroid/os/HandlerThread;->quitSafely()Z

    return-void

    :catchall_0
    move-exception v1

    goto :goto_2

    :catch_0
    move-exception v1

    goto :goto_1

    :catch_1
    move-exception v1

    .line 92
    :goto_1
    :try_start_1
    const-string v2, "ImperialTvRadio"

    const-string v3, "Could not release radio player"

    invoke-static {v2, v3, v1}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    goto :goto_0

    .line 94
    :goto_2
    iput-object v0, p0, Lru/oopssre/imperialschool/viewstv/RadioPlayback;->engine:Landroidx/media3/exoplayer/ExoPlayer;

    .line 95
    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/RadioPlayback;->thread:Landroid/os/HandlerThread;

    invoke-virtual {v0}, Landroid/os/HandlerThread;->quitSafely()Z

    .line 96
    throw v1
.end method

.method synthetic lambda$open$0$ru-oopssre-imperialschool-viewstv-RadioPlayback(Lru/oopssre/imperialschool/viewstv/RadioPlayback$Session;Ljava/lang/String;)V
    .locals 3

    .line 44
    iget-boolean v0, p1, Lru/oopssre/imperialschool/viewstv/RadioPlayback$Session;->closed:Z

    if-eqz v0, :cond_0

    return-void

    .line 46
    :cond_0
    :try_start_0
    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/RadioPlayback;->engine:Landroidx/media3/exoplayer/ExoPlayer;

    if-nez v0, :cond_1

    invoke-direct {p0}, Lru/oopssre/imperialschool/viewstv/RadioPlayback;->createEngine()V

    .line 47
    :cond_1
    iput-object p1, p0, Lru/oopssre/imperialschool/viewstv/RadioPlayback;->current:Lru/oopssre/imperialschool/viewstv/RadioPlayback$Session;

    .line 48
    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/RadioPlayback;->engine:Landroidx/media3/exoplayer/ExoPlayer;

    invoke-interface {v0}, Landroidx/media3/exoplayer/ExoPlayer;->pause()V

    .line 49
    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/RadioPlayback;->engine:Landroidx/media3/exoplayer/ExoPlayer;

    const/4 v1, 0x0

    invoke-interface {v0, v1}, Landroidx/media3/exoplayer/ExoPlayer;->setVolume(F)V

    .line 50
    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/RadioPlayback;->engine:Landroidx/media3/exoplayer/ExoPlayer;

    new-instance v1, Landroidx/media3/common/MediaItem$Builder;

    invoke-direct {v1}, Landroidx/media3/common/MediaItem$Builder;-><init>()V

    iget-object v2, p1, Lru/oopssre/imperialschool/viewstv/RadioPlayback$Session;->id:Ljava/lang/String;

    invoke-virtual {v1, v2}, Landroidx/media3/common/MediaItem$Builder;->setMediaId(Ljava/lang/String;)Landroidx/media3/common/MediaItem$Builder;

    move-result-object v1

    invoke-virtual {v1, p2}, Landroidx/media3/common/MediaItem$Builder;->setUri(Ljava/lang/String;)Landroidx/media3/common/MediaItem$Builder;

    move-result-object p2

    invoke-virtual {p2}, Landroidx/media3/common/MediaItem$Builder;->build()Landroidx/media3/common/MediaItem;

    move-result-object p2

    invoke-interface {v0, p2}, Landroidx/media3/exoplayer/ExoPlayer;->setMediaItem(Landroidx/media3/common/MediaItem;)V

    .line 51
    iget-object p2, p0, Lru/oopssre/imperialschool/viewstv/RadioPlayback;->engine:Landroidx/media3/exoplayer/ExoPlayer;

    invoke-interface {p2}, Landroidx/media3/exoplayer/ExoPlayer;->prepare()V
    :try_end_0
    .catch Ljava/lang/RuntimeException; {:try_start_0 .. :try_end_0} :catch_1
    .catch Ljava/lang/LinkageError; {:try_start_0 .. :try_end_0} :catch_0

    return-void

    :catch_0
    move-exception p2

    goto :goto_0

    :catch_1
    move-exception p2

    .line 53
    :goto_0
    invoke-virtual {p1, p2}, Lru/oopssre/imperialschool/viewstv/RadioPlayback$Session;->fail(Ljava/lang/Throwable;)V

    return-void
.end method

.method open(Ljava/lang/String;)Lru/oopssre/imperialschool/viewstv/ScenePlayback;
    .locals 5

    .line 37
    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/RadioPlayback;->worker:Landroid/os/Handler;

    if-nez v0, :cond_0

    .line 38
    new-instance v0, Landroid/os/HandlerThread;

    const-string v1, "imperial-tv-radio"

    invoke-direct {v0, v1}, Landroid/os/HandlerThread;-><init>(Ljava/lang/String;)V

    iput-object v0, p0, Lru/oopssre/imperialschool/viewstv/RadioPlayback;->thread:Landroid/os/HandlerThread;

    .line 39
    invoke-virtual {v0}, Landroid/os/HandlerThread;->start()V

    .line 40
    new-instance v0, Landroid/os/Handler;

    iget-object v1, p0, Lru/oopssre/imperialschool/viewstv/RadioPlayback;->thread:Landroid/os/HandlerThread;

    invoke-virtual {v1}, Landroid/os/HandlerThread;->getLooper()Landroid/os/Looper;

    move-result-object v1

    invoke-direct {v0, v1}, Landroid/os/Handler;-><init>(Landroid/os/Looper;)V

    iput-object v0, p0, Lru/oopssre/imperialschool/viewstv/RadioPlayback;->worker:Landroid/os/Handler;

    .line 42
    :cond_0
    new-instance v0, Lru/oopssre/imperialschool/viewstv/RadioPlayback$Session;

    iget-wide v1, p0, Lru/oopssre/imperialschool/viewstv/RadioPlayback;->sequence:J

    const-wide/16 v3, 0x1

    add-long/2addr v1, v3

    iput-wide v1, p0, Lru/oopssre/imperialschool/viewstv/RadioPlayback;->sequence:J

    invoke-static {v1, v2}, Ljava/lang/Long;->toString(J)Ljava/lang/String;

    move-result-object v1

    invoke-direct {v0, p0, v1}, Lru/oopssre/imperialschool/viewstv/RadioPlayback$Session;-><init>(Lru/oopssre/imperialschool/viewstv/RadioPlayback;Ljava/lang/String;)V

    .line 43
    iget-object v1, p0, Lru/oopssre/imperialschool/viewstv/RadioPlayback;->worker:Landroid/os/Handler;

    new-instance v2, Lru/oopssre/imperialschool/viewstv/RadioPlayback$$ExternalSyntheticLambda1;

    invoke-direct {v2, p0, v0, p1}, Lru/oopssre/imperialschool/viewstv/RadioPlayback$$ExternalSyntheticLambda1;-><init>(Lru/oopssre/imperialschool/viewstv/RadioPlayback;Lru/oopssre/imperialschool/viewstv/RadioPlayback$Session;Ljava/lang/String;)V

    invoke-virtual {v1, v2}, Landroid/os/Handler;->post(Ljava/lang/Runnable;)Z

    return-object v0
.end method
