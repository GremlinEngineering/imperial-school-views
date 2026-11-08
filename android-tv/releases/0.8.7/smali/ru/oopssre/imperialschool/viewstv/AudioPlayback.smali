.class final Lru/oopssre/imperialschool/viewstv/AudioPlayback;
.super Ljava/lang/Object;
.source "AudioPlayback.java"

# interfaces
.implements Lru/oopssre/imperialschool/viewstv/ScenePlayback;


# static fields
.field private static final SLOTS:Ljava/util/concurrent/Semaphore;

.field private static final TAG:Ljava/lang/String; = "ImperialTvAudio"


# instance fields
.field private chip:Lru/oopssre/imperialschool/viewstv/ChipSource;

.field private volatile closed:Z

.field private final listener:Lru/oopssre/imperialschool/viewstv/ScenePlayback$Listener;

.field private final main:Landroid/os/Handler;

.field private player:Landroid/media/MediaPlayer;

.field private playing:Z

.field private volatile position:I

.field private final samplePosition:Ljava/lang/Runnable;

.field private thread:Landroid/os/HandlerThread;

.field private worker:Landroid/os/Handler;


# direct methods
.method static constructor <clinit>()V
    .locals 2

    .line 17
    new-instance v0, Ljava/util/concurrent/Semaphore;

    const/4 v1, 0x3

    invoke-direct {v0, v1}, Ljava/util/concurrent/Semaphore;-><init>(I)V

    sput-object v0, Lru/oopssre/imperialschool/viewstv/AudioPlayback;->SLOTS:Ljava/util/concurrent/Semaphore;

    return-void
.end method

.method constructor <init>(Landroid/os/Handler;Lru/oopssre/imperialschool/viewstv/ScenePlayback$Listener;)V
    .locals 1

    .line 36
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 27
    new-instance v0, Lru/oopssre/imperialschool/viewstv/AudioPlayback$1;

    invoke-direct {v0, p0}, Lru/oopssre/imperialschool/viewstv/AudioPlayback$1;-><init>(Lru/oopssre/imperialschool/viewstv/AudioPlayback;)V

    iput-object v0, p0, Lru/oopssre/imperialschool/viewstv/AudioPlayback;->samplePosition:Ljava/lang/Runnable;

    .line 37
    iput-object p1, p0, Lru/oopssre/imperialschool/viewstv/AudioPlayback;->main:Landroid/os/Handler;

    .line 38
    iput-object p2, p0, Lru/oopssre/imperialschool/viewstv/AudioPlayback;->listener:Lru/oopssre/imperialschool/viewstv/ScenePlayback$Listener;

    return-void
.end method

.method static synthetic access$000(Lru/oopssre/imperialschool/viewstv/AudioPlayback;)Z
    .locals 0

    .line 13
    iget-boolean p0, p0, Lru/oopssre/imperialschool/viewstv/AudioPlayback;->closed:Z

    return p0
.end method

.method static synthetic access$100(Lru/oopssre/imperialschool/viewstv/AudioPlayback;)Z
    .locals 0

    .line 13
    iget-boolean p0, p0, Lru/oopssre/imperialschool/viewstv/AudioPlayback;->playing:Z

    return p0
.end method

.method static synthetic access$202(Lru/oopssre/imperialschool/viewstv/AudioPlayback;I)I
    .locals 0

    .line 13
    iput p1, p0, Lru/oopssre/imperialschool/viewstv/AudioPlayback;->position:I

    return p1
.end method

.method static synthetic access$300(Lru/oopssre/imperialschool/viewstv/AudioPlayback;)Landroid/media/MediaPlayer;
    .locals 0

    .line 13
    iget-object p0, p0, Lru/oopssre/imperialschool/viewstv/AudioPlayback;->player:Landroid/media/MediaPlayer;

    return-object p0
.end method

.method static synthetic access$400(Lru/oopssre/imperialschool/viewstv/AudioPlayback;)Landroid/os/Handler;
    .locals 0

    .line 13
    iget-object p0, p0, Lru/oopssre/imperialschool/viewstv/AudioPlayback;->worker:Landroid/os/Handler;

    return-object p0
.end method

.method private command(Ljava/util/function/Consumer;)V
    .locals 2
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/util/function/Consumer<",
            "Landroid/media/MediaPlayer;",
            ">;)V"
        }
    .end annotation

    .line 103
    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/AudioPlayback;->worker:Landroid/os/Handler;

    new-instance v1, Lru/oopssre/imperialschool/viewstv/AudioPlayback$$ExternalSyntheticLambda8;

    invoke-direct {v1, p0, p1}, Lru/oopssre/imperialschool/viewstv/AudioPlayback$$ExternalSyntheticLambda8;-><init>(Lru/oopssre/imperialschool/viewstv/AudioPlayback;Ljava/util/function/Consumer;)V

    invoke-virtual {v0, v1}, Landroid/os/Handler;->post(Ljava/lang/Runnable;)Z

    return-void
.end method

.method private emit(Lru/oopssre/imperialschool/viewstv/ScenePlayback$Event;)V
    .locals 2

    const-wide/16 v0, 0x0

    .line 115
    invoke-direct {p0, p1, v0, v1}, Lru/oopssre/imperialschool/viewstv/AudioPlayback;->emit(Lru/oopssre/imperialschool/viewstv/ScenePlayback$Event;J)V

    return-void
.end method

.method private emit(Lru/oopssre/imperialschool/viewstv/ScenePlayback$Event;J)V
    .locals 2

    .line 118
    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/AudioPlayback;->main:Landroid/os/Handler;

    new-instance v1, Lru/oopssre/imperialschool/viewstv/AudioPlayback$$ExternalSyntheticLambda2;

    invoke-direct {v1, p0, p1, p2, p3}, Lru/oopssre/imperialschool/viewstv/AudioPlayback$$ExternalSyntheticLambda2;-><init>(Lru/oopssre/imperialschool/viewstv/AudioPlayback;Lru/oopssre/imperialschool/viewstv/ScenePlayback$Event;J)V

    invoke-virtual {v0, v1}, Landroid/os/Handler;->post(Ljava/lang/Runnable;)Z

    return-void
.end method

.method private failed(Ljava/lang/Throwable;)V
    .locals 2

    .line 111
    const-string v0, "ImperialTvAudio"

    const-string v1, "Audio playback failed"

    invoke-static {v0, v1, p1}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I

    .line 112
    sget-object p1, Lru/oopssre/imperialschool/viewstv/ScenePlayback$Event;->FAILED:Lru/oopssre/imperialschool/viewstv/ScenePlayback$Event;

    invoke-direct {p0, p1}, Lru/oopssre/imperialschool/viewstv/AudioPlayback;->emit(Lru/oopssre/imperialschool/viewstv/ScenePlayback$Event;)V

    return-void
.end method

.method static synthetic lambda$volume$6(FLandroid/media/MediaPlayer;)V
    .locals 0

    .line 99
    invoke-virtual {p1, p0, p0}, Landroid/media/MediaPlayer;->setVolume(FF)V

    return-void
.end method


# virtual methods
.method public close()V
    .locals 2

    .line 122
    iget-boolean v0, p0, Lru/oopssre/imperialschool/viewstv/AudioPlayback;->closed:Z

    if-eqz v0, :cond_0

    goto :goto_0

    :cond_0
    const/4 v0, 0x1

    .line 123
    iput-boolean v0, p0, Lru/oopssre/imperialschool/viewstv/AudioPlayback;->closed:Z

    .line 124
    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/AudioPlayback;->worker:Landroid/os/Handler;

    if-nez v0, :cond_1

    :goto_0
    return-void

    :cond_1
    const/4 v1, 0x0

    .line 125
    invoke-virtual {v0, v1}, Landroid/os/Handler;->removeCallbacksAndMessages(Ljava/lang/Object;)V

    .line 126
    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/AudioPlayback;->worker:Landroid/os/Handler;

    new-instance v1, Lru/oopssre/imperialschool/viewstv/AudioPlayback$$ExternalSyntheticLambda3;

    invoke-direct {v1, p0}, Lru/oopssre/imperialschool/viewstv/AudioPlayback$$ExternalSyntheticLambda3;-><init>(Lru/oopssre/imperialschool/viewstv/AudioPlayback;)V

    invoke-virtual {v0, v1}, Landroid/os/Handler;->post(Ljava/lang/Runnable;)Z

    return-void
.end method

.method connect(Lru/oopssre/imperialschool/viewstv/MusicPacks$Track;ILandroid/media/AudioAttributes;)Z
    .locals 1

    .line 42
    sget-object v0, Lru/oopssre/imperialschool/viewstv/AudioPlayback;->SLOTS:Ljava/util/concurrent/Semaphore;

    invoke-virtual {v0}, Ljava/util/concurrent/Semaphore;->tryAcquire()Z

    move-result v0

    if-nez v0, :cond_0

    const/4 p1, 0x0

    return p1

    .line 43
    :cond_0
    iput p2, p0, Lru/oopssre/imperialschool/viewstv/AudioPlayback;->position:I

    .line 44
    new-instance p2, Landroid/os/HandlerThread;

    const-string v0, "imperial-tv-audio"

    invoke-direct {p2, v0}, Landroid/os/HandlerThread;-><init>(Ljava/lang/String;)V

    iput-object p2, p0, Lru/oopssre/imperialschool/viewstv/AudioPlayback;->thread:Landroid/os/HandlerThread;

    .line 45
    invoke-virtual {p2}, Landroid/os/HandlerThread;->start()V

    .line 46
    new-instance p2, Landroid/os/Handler;

    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/AudioPlayback;->thread:Landroid/os/HandlerThread;

    invoke-virtual {v0}, Landroid/os/HandlerThread;->getLooper()Landroid/os/Looper;

    move-result-object v0

    invoke-direct {p2, v0}, Landroid/os/Handler;-><init>(Landroid/os/Looper;)V

    iput-object p2, p0, Lru/oopssre/imperialschool/viewstv/AudioPlayback;->worker:Landroid/os/Handler;

    .line 47
    new-instance v0, Lru/oopssre/imperialschool/viewstv/AudioPlayback$$ExternalSyntheticLambda9;

    invoke-direct {v0, p0, p3, p1}, Lru/oopssre/imperialschool/viewstv/AudioPlayback$$ExternalSyntheticLambda9;-><init>(Lru/oopssre/imperialschool/viewstv/AudioPlayback;Landroid/media/AudioAttributes;Lru/oopssre/imperialschool/viewstv/MusicPacks$Track;)V

    invoke-virtual {p2, v0}, Landroid/os/Handler;->post(Ljava/lang/Runnable;)Z

    const/4 p1, 0x1

    return p1
.end method

.method synthetic lambda$close$9$ru-oopssre-imperialschool-viewstv-AudioPlayback()V
    .locals 5

    .line 128
    const-string v0, "Chip source release failed"

    const-string v1, "ImperialTvAudio"

    const/4 v2, 0x0

    :try_start_0
    iget-object v3, p0, Lru/oopssre/imperialschool/viewstv/AudioPlayback;->player:Landroid/media/MediaPlayer;
    :try_end_0
    .catch Ljava/lang/RuntimeException; {:try_start_0 .. :try_end_0} :catch_3
    .catch Ljava/lang/LinkageError; {:try_start_0 .. :try_end_0} :catch_2
    .catchall {:try_start_0 .. :try_end_0} :catchall_2

    if-eqz v3, :cond_1

    .line 129
    :try_start_1
    iget-boolean v4, p0, Lru/oopssre/imperialschool/viewstv/AudioPlayback;->playing:Z

    if-eqz v4, :cond_0

    const/4 v4, 0x0

    invoke-virtual {v3, v4, v4}, Landroid/media/MediaPlayer;->setVolume(FF)V
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    .line 130
    :cond_0
    :try_start_2
    iget-object v3, p0, Lru/oopssre/imperialschool/viewstv/AudioPlayback;->player:Landroid/media/MediaPlayer;

    invoke-virtual {v3}, Landroid/media/MediaPlayer;->release()V

    goto :goto_0

    :catchall_0
    move-exception v3

    iget-object v4, p0, Lru/oopssre/imperialschool/viewstv/AudioPlayback;->player:Landroid/media/MediaPlayer;

    invoke-virtual {v4}, Landroid/media/MediaPlayer;->release()V

    throw v3
    :try_end_2
    .catch Ljava/lang/RuntimeException; {:try_start_2 .. :try_end_2} :catch_3
    .catch Ljava/lang/LinkageError; {:try_start_2 .. :try_end_2} :catch_2
    .catchall {:try_start_2 .. :try_end_2} :catchall_2

    .line 134
    :cond_1
    :goto_0
    iput-object v2, p0, Lru/oopssre/imperialschool/viewstv/AudioPlayback;->player:Landroid/media/MediaPlayer;

    .line 135
    :try_start_3
    iget-object v2, p0, Lru/oopssre/imperialschool/viewstv/AudioPlayback;->chip:Lru/oopssre/imperialschool/viewstv/ChipSource;

    if-eqz v2, :cond_2

    invoke-virtual {v2}, Lru/oopssre/imperialschool/viewstv/ChipSource;->close()V
    :try_end_3
    .catch Ljava/lang/RuntimeException; {:try_start_3 .. :try_end_3} :catch_1
    .catch Ljava/lang/LinkageError; {:try_start_3 .. :try_end_3} :catch_0
    .catchall {:try_start_3 .. :try_end_3} :catchall_1

    .line 137
    :cond_2
    :goto_1
    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/AudioPlayback;->thread:Landroid/os/HandlerThread;

    invoke-virtual {v0}, Landroid/os/HandlerThread;->quitSafely()Z

    sget-object v0, Lru/oopssre/imperialschool/viewstv/AudioPlayback;->SLOTS:Ljava/util/concurrent/Semaphore;

    invoke-virtual {v0}, Ljava/util/concurrent/Semaphore;->release()V

    goto :goto_6

    :catchall_1
    move-exception v0

    goto :goto_3

    :catch_0
    move-exception v2

    goto :goto_2

    :catch_1
    move-exception v2

    .line 136
    :goto_2
    :try_start_4
    invoke-static {v1, v0, v2}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I
    :try_end_4
    .catchall {:try_start_4 .. :try_end_4} :catchall_1

    goto :goto_1

    .line 137
    :goto_3
    iget-object v1, p0, Lru/oopssre/imperialschool/viewstv/AudioPlayback;->thread:Landroid/os/HandlerThread;

    invoke-virtual {v1}, Landroid/os/HandlerThread;->quitSafely()Z

    sget-object v1, Lru/oopssre/imperialschool/viewstv/AudioPlayback;->SLOTS:Ljava/util/concurrent/Semaphore;

    invoke-virtual {v1}, Ljava/util/concurrent/Semaphore;->release()V

    throw v0

    :catchall_2
    move-exception v3

    goto :goto_8

    :catch_2
    move-exception v3

    goto :goto_4

    :catch_3
    move-exception v3

    .line 132
    :goto_4
    :try_start_5
    const-string v4, "Audio release failed"

    invoke-static {v1, v4, v3}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I
    :try_end_5
    .catchall {:try_start_5 .. :try_end_5} :catchall_2

    .line 134
    iput-object v2, p0, Lru/oopssre/imperialschool/viewstv/AudioPlayback;->player:Landroid/media/MediaPlayer;

    .line 135
    :try_start_6
    iget-object v2, p0, Lru/oopssre/imperialschool/viewstv/AudioPlayback;->chip:Lru/oopssre/imperialschool/viewstv/ChipSource;

    if-eqz v2, :cond_2

    invoke-virtual {v2}, Lru/oopssre/imperialschool/viewstv/ChipSource;->close()V
    :try_end_6
    .catch Ljava/lang/RuntimeException; {:try_start_6 .. :try_end_6} :catch_5
    .catch Ljava/lang/LinkageError; {:try_start_6 .. :try_end_6} :catch_4
    .catchall {:try_start_6 .. :try_end_6} :catchall_3

    goto :goto_1

    :catchall_3
    move-exception v0

    goto :goto_7

    :catch_4
    move-exception v2

    goto :goto_5

    :catch_5
    move-exception v2

    .line 136
    :goto_5
    :try_start_7
    invoke-static {v1, v0, v2}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I
    :try_end_7
    .catchall {:try_start_7 .. :try_end_7} :catchall_3

    goto :goto_1

    :goto_6
    return-void

    .line 137
    :goto_7
    iget-object v1, p0, Lru/oopssre/imperialschool/viewstv/AudioPlayback;->thread:Landroid/os/HandlerThread;

    invoke-virtual {v1}, Landroid/os/HandlerThread;->quitSafely()Z

    sget-object v1, Lru/oopssre/imperialschool/viewstv/AudioPlayback;->SLOTS:Ljava/util/concurrent/Semaphore;

    invoke-virtual {v1}, Ljava/util/concurrent/Semaphore;->release()V

    throw v0

    .line 134
    :goto_8
    iput-object v2, p0, Lru/oopssre/imperialschool/viewstv/AudioPlayback;->player:Landroid/media/MediaPlayer;

    .line 135
    :try_start_8
    iget-object v2, p0, Lru/oopssre/imperialschool/viewstv/AudioPlayback;->chip:Lru/oopssre/imperialschool/viewstv/ChipSource;

    if-eqz v2, :cond_3

    invoke-virtual {v2}, Lru/oopssre/imperialschool/viewstv/ChipSource;->close()V
    :try_end_8
    .catch Ljava/lang/RuntimeException; {:try_start_8 .. :try_end_8} :catch_7
    .catch Ljava/lang/LinkageError; {:try_start_8 .. :try_end_8} :catch_6
    .catchall {:try_start_8 .. :try_end_8} :catchall_4

    .line 137
    :cond_3
    :goto_9
    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/AudioPlayback;->thread:Landroid/os/HandlerThread;

    invoke-virtual {v0}, Landroid/os/HandlerThread;->quitSafely()Z

    sget-object v0, Lru/oopssre/imperialschool/viewstv/AudioPlayback;->SLOTS:Ljava/util/concurrent/Semaphore;

    invoke-virtual {v0}, Ljava/util/concurrent/Semaphore;->release()V

    goto :goto_b

    :catchall_4
    move-exception v0

    goto :goto_c

    :catch_6
    move-exception v2

    goto :goto_a

    :catch_7
    move-exception v2

    .line 136
    :goto_a
    :try_start_9
    invoke-static {v1, v0, v2}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I
    :try_end_9
    .catchall {:try_start_9 .. :try_end_9} :catchall_4

    goto :goto_9

    .line 138
    :goto_b
    throw v3

    .line 137
    :goto_c
    iget-object v1, p0, Lru/oopssre/imperialschool/viewstv/AudioPlayback;->thread:Landroid/os/HandlerThread;

    invoke-virtual {v1}, Landroid/os/HandlerThread;->quitSafely()Z

    sget-object v1, Lru/oopssre/imperialschool/viewstv/AudioPlayback;->SLOTS:Ljava/util/concurrent/Semaphore;

    invoke-virtual {v1}, Ljava/util/concurrent/Semaphore;->release()V

    throw v0
.end method

.method synthetic lambda$command$7$ru-oopssre-imperialschool-viewstv-AudioPlayback(Ljava/util/function/Consumer;)V
    .locals 1

    .line 104
    iget-boolean v0, p0, Lru/oopssre/imperialschool/viewstv/AudioPlayback;->closed:Z

    if-nez v0, :cond_1

    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/AudioPlayback;->player:Landroid/media/MediaPlayer;

    if-nez v0, :cond_0

    goto :goto_1

    .line 105
    :cond_0
    :try_start_0
    invoke-interface {p1, v0}, Ljava/util/function/Consumer;->accept(Ljava/lang/Object;)V
    :try_end_0
    .catch Ljava/lang/RuntimeException; {:try_start_0 .. :try_end_0} :catch_1
    .catch Ljava/lang/LinkageError; {:try_start_0 .. :try_end_0} :catch_0

    return-void

    :catch_0
    move-exception p1

    goto :goto_0

    :catch_1
    move-exception p1

    .line 106
    :goto_0
    invoke-direct {p0, p1}, Lru/oopssre/imperialschool/viewstv/AudioPlayback;->failed(Ljava/lang/Throwable;)V

    :cond_1
    :goto_1
    return-void
.end method

.method synthetic lambda$connect$0$ru-oopssre-imperialschool-viewstv-AudioPlayback(Landroid/media/MediaPlayer;)V
    .locals 2

    .line 53
    iget-boolean v0, p0, Lru/oopssre/imperialschool/viewstv/AudioPlayback;->closed:Z

    if-eqz v0, :cond_0

    return-void

    .line 55
    :cond_0
    :try_start_0
    iget v0, p0, Lru/oopssre/imperialschool/viewstv/AudioPlayback;->position:I

    if-lez v0, :cond_1

    iget v0, p0, Lru/oopssre/imperialschool/viewstv/AudioPlayback;->position:I

    invoke-virtual {p1}, Landroid/media/MediaPlayer;->getDuration()I

    move-result v1

    add-int/lit16 v1, v1, -0x3e8

    if-ge v0, v1, :cond_1

    iget v0, p0, Lru/oopssre/imperialschool/viewstv/AudioPlayback;->position:I

    invoke-virtual {p1, v0}, Landroid/media/MediaPlayer;->seekTo(I)V

    .line 56
    :cond_1
    sget-object p1, Lru/oopssre/imperialschool/viewstv/ScenePlayback$Event;->PREPARED:Lru/oopssre/imperialschool/viewstv/ScenePlayback$Event;

    invoke-direct {p0, p1}, Lru/oopssre/imperialschool/viewstv/AudioPlayback;->emit(Lru/oopssre/imperialschool/viewstv/ScenePlayback$Event;)V
    :try_end_0
    .catch Ljava/lang/RuntimeException; {:try_start_0 .. :try_end_0} :catch_1
    .catch Ljava/lang/LinkageError; {:try_start_0 .. :try_end_0} :catch_0

    return-void

    :catch_0
    move-exception p1

    goto :goto_0

    :catch_1
    move-exception p1

    .line 57
    :goto_0
    invoke-direct {p0, p1}, Lru/oopssre/imperialschool/viewstv/AudioPlayback;->failed(Ljava/lang/Throwable;)V

    return-void
.end method

.method synthetic lambda$connect$1$ru-oopssre-imperialschool-viewstv-AudioPlayback(Landroid/media/MediaPlayer;)V
    .locals 0

    .line 59
    sget-object p1, Lru/oopssre/imperialschool/viewstv/ScenePlayback$Event;->COMPLETED:Lru/oopssre/imperialschool/viewstv/ScenePlayback$Event;

    invoke-direct {p0, p1}, Lru/oopssre/imperialschool/viewstv/AudioPlayback;->emit(Lru/oopssre/imperialschool/viewstv/ScenePlayback$Event;)V

    return-void
.end method

.method synthetic lambda$connect$2$ru-oopssre-imperialschool-viewstv-AudioPlayback(Landroid/media/MediaPlayer;II)Z
    .locals 1

    .line 61
    new-instance p1, Ljava/lang/StringBuilder;

    const-string v0, "MediaPlayer error "

    invoke-direct {p1, v0}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {p1, p2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object p1

    const-string p2, "/"

    invoke-virtual {p1, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p1

    invoke-virtual {p1, p3}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object p1

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    const-string p2, "ImperialTvAudio"

    invoke-static {p2, p1}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;)I

    .line 62
    sget-object p1, Lru/oopssre/imperialschool/viewstv/ScenePlayback$Event;->FAILED:Lru/oopssre/imperialschool/viewstv/ScenePlayback$Event;

    invoke-direct {p0, p1}, Lru/oopssre/imperialschool/viewstv/AudioPlayback;->emit(Lru/oopssre/imperialschool/viewstv/ScenePlayback$Event;)V

    const/4 p1, 0x1

    return p1
.end method

.method synthetic lambda$connect$3$ru-oopssre-imperialschool-viewstv-AudioPlayback(Landroid/media/AudioAttributes;Lru/oopssre/imperialschool/viewstv/MusicPacks$Track;)V
    .locals 1

    .line 48
    iget-boolean v0, p0, Lru/oopssre/imperialschool/viewstv/AudioPlayback;->closed:Z

    if-eqz v0, :cond_0

    goto :goto_0

    .line 50
    :cond_0
    :try_start_0
    new-instance v0, Landroid/media/MediaPlayer;

    invoke-direct {v0}, Landroid/media/MediaPlayer;-><init>()V

    iput-object v0, p0, Lru/oopssre/imperialschool/viewstv/AudioPlayback;->player:Landroid/media/MediaPlayer;

    .line 51
    invoke-virtual {v0, p1}, Landroid/media/MediaPlayer;->setAudioAttributes(Landroid/media/AudioAttributes;)V

    .line 52
    iget-object p1, p0, Lru/oopssre/imperialschool/viewstv/AudioPlayback;->player:Landroid/media/MediaPlayer;

    new-instance v0, Lru/oopssre/imperialschool/viewstv/AudioPlayback$$ExternalSyntheticLambda5;

    invoke-direct {v0, p0}, Lru/oopssre/imperialschool/viewstv/AudioPlayback$$ExternalSyntheticLambda5;-><init>(Lru/oopssre/imperialschool/viewstv/AudioPlayback;)V

    invoke-virtual {p1, v0}, Landroid/media/MediaPlayer;->setOnPreparedListener(Landroid/media/MediaPlayer$OnPreparedListener;)V

    .line 59
    iget-object p1, p0, Lru/oopssre/imperialschool/viewstv/AudioPlayback;->player:Landroid/media/MediaPlayer;

    new-instance v0, Lru/oopssre/imperialschool/viewstv/AudioPlayback$$ExternalSyntheticLambda6;

    invoke-direct {v0, p0}, Lru/oopssre/imperialschool/viewstv/AudioPlayback$$ExternalSyntheticLambda6;-><init>(Lru/oopssre/imperialschool/viewstv/AudioPlayback;)V

    invoke-virtual {p1, v0}, Landroid/media/MediaPlayer;->setOnCompletionListener(Landroid/media/MediaPlayer$OnCompletionListener;)V

    .line 60
    iget-object p1, p0, Lru/oopssre/imperialschool/viewstv/AudioPlayback;->player:Landroid/media/MediaPlayer;

    new-instance v0, Lru/oopssre/imperialschool/viewstv/AudioPlayback$$ExternalSyntheticLambda7;

    invoke-direct {v0, p0}, Lru/oopssre/imperialschool/viewstv/AudioPlayback$$ExternalSyntheticLambda7;-><init>(Lru/oopssre/imperialschool/viewstv/AudioPlayback;)V

    invoke-virtual {p1, v0}, Landroid/media/MediaPlayer;->setOnErrorListener(Landroid/media/MediaPlayer$OnErrorListener;)V

    .line 65
    iget-boolean p1, p0, Lru/oopssre/imperialschool/viewstv/AudioPlayback;->closed:Z

    if-eqz p1, :cond_1

    goto :goto_0

    .line 66
    :cond_1
    new-instance p1, Lru/oopssre/imperialschool/viewstv/ChipSource;

    iget-object v0, p2, Lru/oopssre/imperialschool/viewstv/MusicPacks$Track;->data:[B

    invoke-virtual {p2}, Lru/oopssre/imperialschool/viewstv/MusicPacks$Track;->snes()Z

    move-result p2

    invoke-direct {p1, v0, p2}, Lru/oopssre/imperialschool/viewstv/ChipSource;-><init>([BZ)V

    iput-object p1, p0, Lru/oopssre/imperialschool/viewstv/AudioPlayback;->chip:Lru/oopssre/imperialschool/viewstv/ChipSource;

    .line 67
    iget-object p2, p0, Lru/oopssre/imperialschool/viewstv/AudioPlayback;->player:Landroid/media/MediaPlayer;

    invoke-virtual {p2, p1}, Landroid/media/MediaPlayer;->setDataSource(Landroid/media/MediaDataSource;)V

    .line 68
    iget-boolean p1, p0, Lru/oopssre/imperialschool/viewstv/AudioPlayback;->closed:Z

    if-eqz p1, :cond_2

    :goto_0
    return-void

    .line 69
    :cond_2
    iget-object p1, p0, Lru/oopssre/imperialschool/viewstv/AudioPlayback;->player:Landroid/media/MediaPlayer;

    const/4 p2, 0x0

    invoke-virtual {p1, p2, p2}, Landroid/media/MediaPlayer;->setVolume(FF)V

    .line 70
    iget-object p1, p0, Lru/oopssre/imperialschool/viewstv/AudioPlayback;->player:Landroid/media/MediaPlayer;

    invoke-virtual {p1}, Landroid/media/MediaPlayer;->prepareAsync()V
    :try_end_0
    .catch Ljava/io/IOException; {:try_start_0 .. :try_end_0} :catch_2
    .catch Ljava/lang/RuntimeException; {:try_start_0 .. :try_end_0} :catch_1
    .catch Ljava/lang/LinkageError; {:try_start_0 .. :try_end_0} :catch_0

    return-void

    :catch_0
    move-exception p1

    goto :goto_1

    :catch_1
    move-exception p1

    goto :goto_1

    :catch_2
    move-exception p1

    .line 72
    :goto_1
    invoke-direct {p0, p1}, Lru/oopssre/imperialschool/viewstv/AudioPlayback;->failed(Ljava/lang/Throwable;)V

    return-void
.end method

.method synthetic lambda$emit$8$ru-oopssre-imperialschool-viewstv-AudioPlayback(Lru/oopssre/imperialschool/viewstv/ScenePlayback$Event;J)V
    .locals 1

    .line 118
    iget-boolean v0, p0, Lru/oopssre/imperialschool/viewstv/AudioPlayback;->closed:Z

    if-nez v0, :cond_0

    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/AudioPlayback;->listener:Lru/oopssre/imperialschool/viewstv/ScenePlayback$Listener;

    invoke-interface {v0, p0, p1, p2, p3}, Lru/oopssre/imperialschool/viewstv/ScenePlayback$Listener;->event(Lru/oopssre/imperialschool/viewstv/ScenePlayback;Lru/oopssre/imperialschool/viewstv/ScenePlayback$Event;J)V

    :cond_0
    return-void
.end method

.method synthetic lambda$pause$5$ru-oopssre-imperialschool-viewstv-AudioPlayback(Landroid/media/MediaPlayer;)V
    .locals 1

    .line 92
    iget-boolean v0, p0, Lru/oopssre/imperialschool/viewstv/AudioPlayback;->playing:Z

    if-nez v0, :cond_0

    return-void

    .line 93
    :cond_0
    invoke-virtual {p1}, Landroid/media/MediaPlayer;->pause()V

    const/4 p1, 0x0

    .line 94
    iput-boolean p1, p0, Lru/oopssre/imperialschool/viewstv/AudioPlayback;->playing:Z

    .line 95
    iget-object p1, p0, Lru/oopssre/imperialschool/viewstv/AudioPlayback;->worker:Landroid/os/Handler;

    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/AudioPlayback;->samplePosition:Ljava/lang/Runnable;

    invoke-virtual {p1, v0}, Landroid/os/Handler;->removeCallbacks(Ljava/lang/Runnable;)V

    return-void
.end method

.method synthetic lambda$play$4$ru-oopssre-imperialschool-viewstv-AudioPlayback(JLandroid/media/MediaPlayer;)V
    .locals 1

    .line 80
    iget-boolean v0, p0, Lru/oopssre/imperialschool/viewstv/AudioPlayback;->playing:Z

    if-nez v0, :cond_0

    const/4 v0, 0x0

    .line 81
    invoke-virtual {p3, v0, v0}, Landroid/media/MediaPlayer;->setVolume(FF)V

    .line 82
    invoke-virtual {p3}, Landroid/media/MediaPlayer;->start()V

    const/4 p3, 0x1

    .line 83
    iput-boolean p3, p0, Lru/oopssre/imperialschool/viewstv/AudioPlayback;->playing:Z

    .line 84
    iget-object p3, p0, Lru/oopssre/imperialschool/viewstv/AudioPlayback;->worker:Landroid/os/Handler;

    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/AudioPlayback;->samplePosition:Ljava/lang/Runnable;

    invoke-virtual {p3, v0}, Landroid/os/Handler;->post(Ljava/lang/Runnable;)Z

    .line 86
    :cond_0
    sget-object p3, Lru/oopssre/imperialschool/viewstv/ScenePlayback$Event;->STARTED:Lru/oopssre/imperialschool/viewstv/ScenePlayback$Event;

    invoke-direct {p0, p3, p1, p2}, Lru/oopssre/imperialschool/viewstv/AudioPlayback;->emit(Lru/oopssre/imperialschool/viewstv/ScenePlayback$Event;J)V

    return-void
.end method

.method public pause()V
    .locals 1

    .line 91
    new-instance v0, Lru/oopssre/imperialschool/viewstv/AudioPlayback$$ExternalSyntheticLambda4;

    invoke-direct {v0, p0}, Lru/oopssre/imperialschool/viewstv/AudioPlayback$$ExternalSyntheticLambda4;-><init>(Lru/oopssre/imperialschool/viewstv/AudioPlayback;)V

    invoke-direct {p0, v0}, Lru/oopssre/imperialschool/viewstv/AudioPlayback;->command(Ljava/util/function/Consumer;)V

    return-void
.end method

.method public play(J)V
    .locals 1

    .line 79
    new-instance v0, Lru/oopssre/imperialschool/viewstv/AudioPlayback$$ExternalSyntheticLambda0;

    invoke-direct {v0, p0, p1, p2}, Lru/oopssre/imperialschool/viewstv/AudioPlayback$$ExternalSyntheticLambda0;-><init>(Lru/oopssre/imperialschool/viewstv/AudioPlayback;J)V

    invoke-direct {p0, v0}, Lru/oopssre/imperialschool/viewstv/AudioPlayback;->command(Ljava/util/function/Consumer;)V

    return-void
.end method

.method public position()I
    .locals 1

    .line 100
    iget v0, p0, Lru/oopssre/imperialschool/viewstv/AudioPlayback;->position:I

    return v0
.end method

.method public volume(F)V
    .locals 1

    .line 99
    new-instance v0, Lru/oopssre/imperialschool/viewstv/AudioPlayback$$ExternalSyntheticLambda1;

    invoke-direct {v0, p1}, Lru/oopssre/imperialschool/viewstv/AudioPlayback$$ExternalSyntheticLambda1;-><init>(F)V

    invoke-direct {p0, v0}, Lru/oopssre/imperialschool/viewstv/AudioPlayback;->command(Ljava/util/function/Consumer;)V

    return-void
.end method
