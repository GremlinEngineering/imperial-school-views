.class final Lru/oopssre/imperialschool/viewstv/VideoSurface$Clip;
.super Ljava/lang/Object;
.source "VideoSurface.java"

# interfaces
.implements Ljava/lang/AutoCloseable;


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lru/oopssre/imperialschool/viewstv/VideoSurface;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x18
    name = "Clip"
.end annotation


# instance fields
.field final cache:Lru/oopssre/imperialschool/viewstv/CacheStore;

.field final closed:Ljava/util/concurrent/atomic/AtomicBoolean;

.field final duration:J

.field final extractor:Landroid/media/MediaExtractor;

.field final file:Ljava/io/File;

.field final format:Landroid/media/MediaFormat;

.field final info:Lru/oopssre/imperialschool/viewstv/VideoInfo;


# direct methods
.method constructor <init>(Lru/oopssre/imperialschool/viewstv/VideoInfo;Ljava/io/File;Landroid/media/MediaExtractor;Landroid/media/MediaFormat;Lru/oopssre/imperialschool/viewstv/CacheStore;)V
    .locals 1

    .line 19
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 18
    new-instance v0, Ljava/util/concurrent/atomic/AtomicBoolean;

    invoke-direct {v0}, Ljava/util/concurrent/atomic/AtomicBoolean;-><init>()V

    iput-object v0, p0, Lru/oopssre/imperialschool/viewstv/VideoSurface$Clip;->closed:Ljava/util/concurrent/atomic/AtomicBoolean;

    .line 19
    iput-object p1, p0, Lru/oopssre/imperialschool/viewstv/VideoSurface$Clip;->info:Lru/oopssre/imperialschool/viewstv/VideoInfo;

    iput-object p2, p0, Lru/oopssre/imperialschool/viewstv/VideoSurface$Clip;->file:Ljava/io/File;

    iput-object p3, p0, Lru/oopssre/imperialschool/viewstv/VideoSurface$Clip;->extractor:Landroid/media/MediaExtractor;

    iput-object p4, p0, Lru/oopssre/imperialschool/viewstv/VideoSurface$Clip;->format:Landroid/media/MediaFormat;

    iput-object p5, p0, Lru/oopssre/imperialschool/viewstv/VideoSurface$Clip;->cache:Lru/oopssre/imperialschool/viewstv/CacheStore;

    const-string p1, "durationUs"

    invoke-virtual {p4, p1}, Landroid/media/MediaFormat;->getLong(Ljava/lang/String;)J

    move-result-wide p1

    iput-wide p1, p0, Lru/oopssre/imperialschool/viewstv/VideoSurface$Clip;->duration:J

    return-void
.end method


# virtual methods
.method public close()V
    .locals 3

    .line 21
    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/VideoSurface$Clip;->closed:Ljava/util/concurrent/atomic/AtomicBoolean;

    const/4 v1, 0x0

    const/4 v2, 0x1

    invoke-virtual {v0, v1, v2}, Ljava/util/concurrent/atomic/AtomicBoolean;->compareAndSet(ZZ)Z

    move-result v0

    if-eqz v0, :cond_0

    :try_start_0
    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/VideoSurface$Clip;->extractor:Landroid/media/MediaExtractor;

    invoke-virtual {v0}, Landroid/media/MediaExtractor;->release()V
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/VideoSurface$Clip;->cache:Lru/oopssre/imperialschool/viewstv/CacheStore;

    iget-object v1, p0, Lru/oopssre/imperialschool/viewstv/VideoSurface$Clip;->info:Lru/oopssre/imperialschool/viewstv/VideoInfo;

    iget-object v1, v1, Lru/oopssre/imperialschool/viewstv/VideoInfo;->sha:Ljava/lang/String;

    invoke-virtual {v0, v1}, Lru/oopssre/imperialschool/viewstv/CacheStore;->unpinVideo(Ljava/lang/String;)V

    return-void

    :catchall_0
    move-exception v0

    iget-object v1, p0, Lru/oopssre/imperialschool/viewstv/VideoSurface$Clip;->cache:Lru/oopssre/imperialschool/viewstv/CacheStore;

    iget-object v2, p0, Lru/oopssre/imperialschool/viewstv/VideoSurface$Clip;->info:Lru/oopssre/imperialschool/viewstv/VideoInfo;

    iget-object v2, v2, Lru/oopssre/imperialschool/viewstv/VideoInfo;->sha:Ljava/lang/String;

    invoke-virtual {v1, v2}, Lru/oopssre/imperialschool/viewstv/CacheStore;->unpinVideo(Ljava/lang/String;)V

    throw v0

    :cond_0
    return-void
.end method

.method rewind()V
    .locals 4
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/io/IOException;
        }
    .end annotation

    .line 20
    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/VideoSurface$Clip;->extractor:Landroid/media/MediaExtractor;

    const/4 v1, 0x2

    const-wide/16 v2, 0x0

    invoke-virtual {v0, v2, v3, v1}, Landroid/media/MediaExtractor;->seekTo(JI)V

    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/VideoSurface$Clip;->extractor:Landroid/media/MediaExtractor;

    invoke-virtual {v0}, Landroid/media/MediaExtractor;->getSampleFlags()I

    move-result v0

    and-int/lit8 v0, v0, 0x1

    if-eqz v0, :cond_0

    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/VideoSurface$Clip;->extractor:Landroid/media/MediaExtractor;

    invoke-virtual {v0}, Landroid/media/MediaExtractor;->getSampleTime()J

    move-result-wide v0

    cmp-long v0, v0, v2

    if-nez v0, :cond_0

    return-void

    :cond_0
    new-instance v0, Ljava/io/IOException;

    const-string v1, "\u0412\u0438\u0434\u0435\u043e \u0434\u043e\u043b\u0436\u043d\u043e \u043d\u0430\u0447\u0438\u043d\u0430\u0442\u044c\u0441\u044f \u0441 \u043a\u043b\u044e\u0447\u0435\u0432\u043e\u0433\u043e \u043a\u0430\u0434\u0440\u0430 \u043d\u0430 \u043e\u0442\u043c\u0435\u0442\u043a\u0435 0"

    invoke-direct {v0, v1}, Ljava/io/IOException;-><init>(Ljava/lang/String;)V

    throw v0
.end method
