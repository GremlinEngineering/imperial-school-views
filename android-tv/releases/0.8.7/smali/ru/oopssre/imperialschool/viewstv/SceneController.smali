.class final Lru/oopssre/imperialschool/viewstv/SceneController;
.super Ljava/lang/Object;
.source "SceneController.java"


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lru/oopssre/imperialschool/viewstv/SceneController$Listener;
    }
.end annotation


# instance fields
.field private active:Z

.field private cacheJob:Ljava/util/concurrent/Future;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/concurrent/Future<",
            "*>;"
        }
    .end annotation
.end field

.field final cacheWorker:Ljava/util/concurrent/ExecutorService;

.field private volatile displayed:Ljava/lang/String;

.field private failures:I

.field volatile frame:Lru/oopssre/imperialschool/viewstv/Protocol$Frame;

.field private generation:J

.field private job:Ljava/util/concurrent/Future;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/concurrent/Future<",
            "*>;"
        }
    .end annotation
.end field

.field final listener:Lru/oopssre/imperialschool/viewstv/SceneController$Listener;

.field final main:Landroid/os/Handler;

.field private volatile networkGeneration:J

.field private final poll:Ljava/lang/Runnable;

.field private volatile renderedTarget:[I

.field final repo:Lru/oopssre/imperialschool/viewstv/Repository;

.field final surface:Lru/oopssre/imperialschool/viewstv/WallpaperSurface;

.field final worker:Ljava/util/concurrent/ExecutorService;


# direct methods
.method constructor <init>(Lru/oopssre/imperialschool/viewstv/Repository;Lru/oopssre/imperialschool/viewstv/WallpaperSurface;Lru/oopssre/imperialschool/viewstv/SceneController$Listener;)V
    .locals 2

    .line 13
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 9
    new-instance v0, Landroid/os/Handler;

    invoke-static {}, Landroid/os/Looper;->getMainLooper()Landroid/os/Looper;

    move-result-object v1

    invoke-direct {v0, v1}, Landroid/os/Handler;-><init>(Landroid/os/Looper;)V

    iput-object v0, p0, Lru/oopssre/imperialschool/viewstv/SceneController;->main:Landroid/os/Handler;

    invoke-static {}, Ljava/util/concurrent/Executors;->newSingleThreadExecutor()Ljava/util/concurrent/ExecutorService;

    move-result-object v0

    iput-object v0, p0, Lru/oopssre/imperialschool/viewstv/SceneController;->worker:Ljava/util/concurrent/ExecutorService;

    .line 10
    invoke-static {}, Ljava/util/concurrent/Executors;->newSingleThreadExecutor()Ljava/util/concurrent/ExecutorService;

    move-result-object v0

    iput-object v0, p0, Lru/oopssre/imperialschool/viewstv/SceneController;->cacheWorker:Ljava/util/concurrent/ExecutorService;

    const-wide/16 v0, -0x1

    .line 11
    iput-wide v0, p0, Lru/oopssre/imperialschool/viewstv/SceneController;->networkGeneration:J

    const-string v0, ""

    iput-object v0, p0, Lru/oopssre/imperialschool/viewstv/SceneController;->displayed:Ljava/lang/String;

    const/4 v0, 0x0

    filled-new-array {v0, v0}, [I

    move-result-object v0

    iput-object v0, p0, Lru/oopssre/imperialschool/viewstv/SceneController;->renderedTarget:[I

    .line 12
    new-instance v0, Lru/oopssre/imperialschool/viewstv/SceneController$$ExternalSyntheticLambda5;

    invoke-direct {v0, p0}, Lru/oopssre/imperialschool/viewstv/SceneController$$ExternalSyntheticLambda5;-><init>(Lru/oopssre/imperialschool/viewstv/SceneController;)V

    iput-object v0, p0, Lru/oopssre/imperialschool/viewstv/SceneController;->poll:Ljava/lang/Runnable;

    .line 13
    iput-object p1, p0, Lru/oopssre/imperialschool/viewstv/SceneController;->repo:Lru/oopssre/imperialschool/viewstv/Repository;

    iput-object p2, p0, Lru/oopssre/imperialschool/viewstv/SceneController;->surface:Lru/oopssre/imperialschool/viewstv/WallpaperSurface;

    iput-object p3, p0, Lru/oopssre/imperialschool/viewstv/SceneController;->listener:Lru/oopssre/imperialschool/viewstv/SceneController$Listener;

    return-void
.end method

.method private publish(Lru/oopssre/imperialschool/viewstv/Protocol$Frame;JZ)V
    .locals 10
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/lang/Exception;
        }
    .end annotation

    .line 29
    invoke-static {}, Ljava/lang/Thread;->currentThread()Ljava/lang/Thread;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/Thread;->isInterrupted()Z

    move-result v0

    if-eqz v0, :cond_0

    return-void

    .line 30
    :cond_0
    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/SceneController;->surface:Lru/oopssre/imperialschool/viewstv/WallpaperSurface;

    iget v8, v0, Lru/oopssre/imperialschool/viewstv/WallpaperSurface;->bufferWidth:I

    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/SceneController;->surface:Lru/oopssre/imperialschool/viewstv/WallpaperSurface;

    iget v9, v0, Lru/oopssre/imperialschool/viewstv/WallpaperSurface;->bufferHeight:I

    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/SceneController;->renderedTarget:[I

    .line 31
    iget-object v1, p1, Lru/oopssre/imperialschool/viewstv/Protocol$Frame;->sha:Ljava/lang/String;

    iget-object v2, p0, Lru/oopssre/imperialschool/viewstv/SceneController;->displayed:Ljava/lang/String;

    invoke-virtual {v1, v2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v1

    if-eqz v1, :cond_1

    const/4 v1, 0x0

    aget v1, v0, v1

    if-ne v1, v8, :cond_1

    const/4 v1, 0x1

    aget v0, v0, v1

    if-ne v0, v9, :cond_1

    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/SceneController;->main:Landroid/os/Handler;

    new-instance v1, Lru/oopssre/imperialschool/viewstv/SceneController$$ExternalSyntheticLambda0;

    move-object v2, p0

    move-object v6, p1

    move-wide v3, p2

    move v5, p4

    invoke-direct/range {v1 .. v6}, Lru/oopssre/imperialschool/viewstv/SceneController$$ExternalSyntheticLambda0;-><init>(Lru/oopssre/imperialschool/viewstv/SceneController;JZLru/oopssre/imperialschool/viewstv/Protocol$Frame;)V

    invoke-virtual {v0, v1}, Landroid/os/Handler;->post(Ljava/lang/Runnable;)Z

    return-void

    :cond_1
    move-object v2, p0

    move-object v6, p1

    move-wide v3, p2

    move v5, p4

    .line 32
    iget-object p1, v2, Lru/oopssre/imperialschool/viewstv/SceneController;->repo:Lru/oopssre/imperialschool/viewstv/Repository;

    invoke-virtual {p1, v6, v8, v9}, Lru/oopssre/imperialschool/viewstv/Repository;->decode(Lru/oopssre/imperialschool/viewstv/Protocol$Frame;II)Landroid/graphics/Bitmap;

    move-result-object p1

    .line 33
    iget-object p2, v2, Lru/oopssre/imperialschool/viewstv/SceneController;->main:Landroid/os/Handler;

    new-instance v1, Lru/oopssre/imperialschool/viewstv/SceneController$$ExternalSyntheticLambda1;

    move-object v7, v6

    move-object v6, p1

    invoke-direct/range {v1 .. v9}, Lru/oopssre/imperialschool/viewstv/SceneController$$ExternalSyntheticLambda1;-><init>(Lru/oopssre/imperialschool/viewstv/SceneController;JZLandroid/graphics/Bitmap;Lru/oopssre/imperialschool/viewstv/Protocol$Frame;II)V

    invoke-virtual {p2, v1}, Landroid/os/Handler;->post(Ljava/lang/Runnable;)Z

    return-void
.end method


# virtual methods
.method destroy()V
    .locals 1

    .line 17
    invoke-virtual {p0}, Lru/oopssre/imperialschool/viewstv/SceneController;->stop()V

    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/SceneController;->worker:Ljava/util/concurrent/ExecutorService;

    invoke-interface {v0}, Ljava/util/concurrent/ExecutorService;->shutdownNow()Ljava/util/List;

    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/SceneController;->cacheWorker:Ljava/util/concurrent/ExecutorService;

    invoke-interface {v0}, Ljava/util/concurrent/ExecutorService;->shutdownNow()Ljava/util/List;

    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/SceneController;->surface:Lru/oopssre/imperialschool/viewstv/WallpaperSurface;

    invoke-virtual {v0}, Lru/oopssre/imperialschool/viewstv/WallpaperSurface;->clear()V

    return-void
.end method

.method synthetic lambda$new$0$ru-oopssre-imperialschool-viewstv-SceneController()V
    .locals 1

    .line 0
    const/4 v0, 0x0

    .line 12
    invoke-virtual {p0, v0}, Lru/oopssre/imperialschool/viewstv/SceneController;->refresh(Z)V

    return-void
.end method

.method synthetic lambda$publish$6$ru-oopssre-imperialschool-viewstv-SceneController(JZLru/oopssre/imperialschool/viewstv/Protocol$Frame;)V
    .locals 2

    .line 31
    iget-boolean v0, p0, Lru/oopssre/imperialschool/viewstv/SceneController;->active:Z

    if-eqz v0, :cond_2

    iget-wide v0, p0, Lru/oopssre/imperialschool/viewstv/SceneController;->generation:J

    cmp-long v0, p1, v0

    if-nez v0, :cond_2

    if-eqz p3, :cond_0

    iget-wide v0, p0, Lru/oopssre/imperialschool/viewstv/SceneController;->networkGeneration:J

    cmp-long v0, v0, p1

    if-eqz v0, :cond_2

    :cond_0
    if-nez p3, :cond_1

    iput-wide p1, p0, Lru/oopssre/imperialschool/viewstv/SceneController;->networkGeneration:J

    :cond_1
    iput-object p4, p0, Lru/oopssre/imperialschool/viewstv/SceneController;->frame:Lru/oopssre/imperialschool/viewstv/Protocol$Frame;

    iget-object p1, p0, Lru/oopssre/imperialschool/viewstv/SceneController;->listener:Lru/oopssre/imperialschool/viewstv/SceneController$Listener;

    invoke-interface {p1, p4}, Lru/oopssre/imperialschool/viewstv/SceneController$Listener;->frame(Lru/oopssre/imperialschool/viewstv/Protocol$Frame;)V

    :cond_2
    return-void
.end method

.method synthetic lambda$publish$7$ru-oopssre-imperialschool-viewstv-SceneController(JZLandroid/graphics/Bitmap;Lru/oopssre/imperialschool/viewstv/Protocol$Frame;II)V
    .locals 2

    .line 33
    iget-boolean v0, p0, Lru/oopssre/imperialschool/viewstv/SceneController;->active:Z

    if-eqz v0, :cond_2

    iget-wide v0, p0, Lru/oopssre/imperialschool/viewstv/SceneController;->generation:J

    cmp-long v0, p1, v0

    if-nez v0, :cond_2

    if-eqz p3, :cond_0

    iget-wide v0, p0, Lru/oopssre/imperialschool/viewstv/SceneController;->networkGeneration:J

    cmp-long v0, v0, p1

    if-nez v0, :cond_0

    goto :goto_0

    :cond_0
    if-nez p3, :cond_1

    iput-wide p1, p0, Lru/oopssre/imperialschool/viewstv/SceneController;->networkGeneration:J

    :cond_1
    iget-object p1, p0, Lru/oopssre/imperialschool/viewstv/SceneController;->surface:Lru/oopssre/imperialschool/viewstv/WallpaperSurface;

    invoke-virtual {p1, p4}, Lru/oopssre/imperialschool/viewstv/WallpaperSurface;->show(Landroid/graphics/Bitmap;)V

    iput-object p5, p0, Lru/oopssre/imperialschool/viewstv/SceneController;->frame:Lru/oopssre/imperialschool/viewstv/Protocol$Frame;

    filled-new-array {p6, p7}, [I

    move-result-object p1

    iput-object p1, p0, Lru/oopssre/imperialschool/viewstv/SceneController;->renderedTarget:[I

    iget-object p1, p5, Lru/oopssre/imperialschool/viewstv/Protocol$Frame;->sha:Ljava/lang/String;

    iput-object p1, p0, Lru/oopssre/imperialschool/viewstv/SceneController;->displayed:Ljava/lang/String;

    iget-object p1, p0, Lru/oopssre/imperialschool/viewstv/SceneController;->listener:Lru/oopssre/imperialschool/viewstv/SceneController$Listener;

    invoke-interface {p1, p5}, Lru/oopssre/imperialschool/viewstv/SceneController$Listener;->frame(Lru/oopssre/imperialschool/viewstv/Protocol$Frame;)V

    return-void

    :cond_2
    :goto_0
    invoke-virtual {p4}, Landroid/graphics/Bitmap;->recycle()V

    return-void
.end method

.method synthetic lambda$refresh$1$ru-oopssre-imperialschool-viewstv-SceneController(J)V
    .locals 2

    .line 19
    :try_start_0
    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/SceneController;->repo:Lru/oopssre/imperialschool/viewstv/Repository;

    invoke-virtual {v0}, Lru/oopssre/imperialschool/viewstv/Repository;->selected()Lru/oopssre/imperialschool/viewstv/Protocol$Theme;

    move-result-object v1

    invoke-virtual {v0, v1}, Lru/oopssre/imperialschool/viewstv/Repository;->cached(Lru/oopssre/imperialschool/viewstv/Protocol$Theme;)Lru/oopssre/imperialschool/viewstv/Protocol$Frame;

    move-result-object v0

    if-eqz v0, :cond_0

    const/4 v1, 0x1

    invoke-direct {p0, v0, p1, p2, v1}, Lru/oopssre/imperialschool/viewstv/SceneController;->publish(Lru/oopssre/imperialschool/viewstv/Protocol$Frame;JZ)V
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    :catch_0
    :cond_0
    return-void
.end method

.method synthetic lambda$refresh$2$ru-oopssre-imperialschool-viewstv-SceneController(JLjava/lang/String;)V
    .locals 2

    .line 24
    iget-boolean v0, p0, Lru/oopssre/imperialschool/viewstv/SceneController;->active:Z

    if-eqz v0, :cond_2

    iget-wide v0, p0, Lru/oopssre/imperialschool/viewstv/SceneController;->generation:J

    cmp-long p1, p1, v0

    if-nez p1, :cond_2

    iget-object p1, p0, Lru/oopssre/imperialschool/viewstv/SceneController;->listener:Lru/oopssre/imperialschool/viewstv/SceneController$Listener;

    new-instance p2, Ljava/lang/StringBuilder;

    invoke-direct {p2}, Ljava/lang/StringBuilder;-><init>()V

    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/SceneController;->frame:Lru/oopssre/imperialschool/viewstv/Protocol$Frame;

    if-nez v0, :cond_0

    const-string v0, "\u041d\u0435\u0442 \u043a\u0430\u0434\u0440\u0430: "

    goto :goto_0

    :cond_0
    const-string v0, "\u0421\u043e\u0445\u0440\u0430\u043d\u0451\u043d \u043f\u043e\u0441\u043b\u0435\u0434\u043d\u0438\u0439 \u043a\u0430\u0434\u0440. "

    :goto_0
    invoke-virtual {p2, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p2

    if-nez p3, :cond_1

    const-string p3, "\u041d\u0435\u0442 \u0441\u0432\u044f\u0437\u0438 \u0441 \u0441\u0435\u0440\u0432\u0435\u0440\u043e\u043c"

    :cond_1
    invoke-virtual {p2, p3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p2

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p2

    invoke-interface {p1, p2}, Lru/oopssre/imperialschool/viewstv/SceneController$Listener;->status(Ljava/lang/String;)V

    :cond_2
    return-void
.end method

.method synthetic lambda$refresh$3$ru-oopssre-imperialschool-viewstv-SceneController(J)V
    .locals 2

    .line 25
    iget-boolean v0, p0, Lru/oopssre/imperialschool/viewstv/SceneController;->active:Z

    if-eqz v0, :cond_0

    iget-wide v0, p0, Lru/oopssre/imperialschool/viewstv/SceneController;->generation:J

    cmp-long p1, p1, v0

    if-nez p1, :cond_0

    iget-object p1, p0, Lru/oopssre/imperialschool/viewstv/SceneController;->listener:Lru/oopssre/imperialschool/viewstv/SceneController$Listener;

    invoke-interface {p1}, Lru/oopssre/imperialschool/viewstv/SceneController$Listener;->catalogue()V

    :cond_0
    return-void
.end method

.method synthetic lambda$refresh$4$ru-oopssre-imperialschool-viewstv-SceneController(JJ)V
    .locals 2

    .line 26
    iget-boolean v0, p0, Lru/oopssre/imperialschool/viewstv/SceneController;->active:Z

    if-eqz v0, :cond_0

    iget-wide v0, p0, Lru/oopssre/imperialschool/viewstv/SceneController;->generation:J

    cmp-long p1, p1, v0

    if-nez p1, :cond_0

    iget-object p1, p0, Lru/oopssre/imperialschool/viewstv/SceneController;->main:Landroid/os/Handler;

    iget-object p2, p0, Lru/oopssre/imperialschool/viewstv/SceneController;->poll:Ljava/lang/Runnable;

    invoke-virtual {p1, p2, p3, p4}, Landroid/os/Handler;->postDelayed(Ljava/lang/Runnable;J)Z

    :cond_0
    return-void
.end method

.method synthetic lambda$refresh$5$ru-oopssre-imperialschool-viewstv-SceneController(J)V
    .locals 11

    .line 21
    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/SceneController;->repo:Lru/oopssre/imperialschool/viewstv/Repository;

    invoke-virtual {v0}, Lru/oopssre/imperialschool/viewstv/Repository;->selected()Lru/oopssre/imperialschool/viewstv/Protocol$Theme;

    move-result-object v0

    .line 23
    :try_start_0
    iget-object v1, p0, Lru/oopssre/imperialschool/viewstv/SceneController;->repo:Lru/oopssre/imperialschool/viewstv/Repository;

    iget-object v2, p0, Lru/oopssre/imperialschool/viewstv/SceneController;->displayed:Ljava/lang/String;

    invoke-virtual {v1, v0, v2}, Lru/oopssre/imperialschool/viewstv/Repository;->refresh(Lru/oopssre/imperialschool/viewstv/Protocol$Theme;Ljava/lang/String;)Lru/oopssre/imperialschool/viewstv/Protocol$Frame;

    move-result-object v0

    const/4 v1, 0x0

    invoke-direct {p0, v0, p1, p2, v1}, Lru/oopssre/imperialschool/viewstv/SceneController;->publish(Lru/oopssre/imperialschool/viewstv/Protocol$Frame;JZ)V

    iput v1, p0, Lru/oopssre/imperialschool/viewstv/SceneController;->failures:I

    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J

    move-result-wide v1

    invoke-virtual {v0, v1, v2}, Lru/oopssre/imperialschool/viewstv/Protocol$Frame;->nextDelay(J)J

    move-result-wide v0
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    move-wide v9, v0

    goto :goto_0

    :catch_0
    move-exception v0

    .line 24
    invoke-static {}, Ljava/lang/Thread;->currentThread()Ljava/lang/Thread;

    move-result-object v1

    invoke-virtual {v1}, Ljava/lang/Thread;->isInterrupted()Z

    move-result v1

    if-eqz v1, :cond_0

    return-void

    :cond_0
    iget v1, p0, Lru/oopssre/imperialschool/viewstv/SceneController;->failures:I

    add-int/lit8 v2, v1, 0x1

    iput v2, p0, Lru/oopssre/imperialschool/viewstv/SceneController;->failures:I

    const/4 v2, 0x3

    invoke-static {v2, v1}, Ljava/lang/Math;->min(II)I

    move-result v1

    const-wide/16 v2, 0x1

    shl-long v1, v2, v1

    const-wide/32 v3, 0xea60

    mul-long/2addr v1, v3

    const-wide/32 v3, 0x493e0

    invoke-static {v3, v4, v1, v2}, Ljava/lang/Math;->min(JJ)J

    move-result-wide v1

    invoke-virtual {v0}, Ljava/lang/Exception;->getMessage()Ljava/lang/String;

    move-result-object v0

    iget-object v3, p0, Lru/oopssre/imperialschool/viewstv/SceneController;->main:Landroid/os/Handler;

    new-instance v4, Lru/oopssre/imperialschool/viewstv/SceneController$$ExternalSyntheticLambda2;

    invoke-direct {v4, p0, p1, p2, v0}, Lru/oopssre/imperialschool/viewstv/SceneController$$ExternalSyntheticLambda2;-><init>(Lru/oopssre/imperialschool/viewstv/SceneController;JLjava/lang/String;)V

    invoke-virtual {v3, v4}, Landroid/os/Handler;->post(Ljava/lang/Runnable;)Z

    move-wide v9, v1

    .line 25
    :goto_0
    :try_start_1
    invoke-static {}, Ljava/lang/Thread;->currentThread()Ljava/lang/Thread;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/Thread;->isInterrupted()Z

    move-result v0

    if-nez v0, :cond_1

    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/SceneController;->repo:Lru/oopssre/imperialschool/viewstv/Repository;

    iget-object v1, p0, Lru/oopssre/imperialschool/viewstv/SceneController;->displayed:Ljava/lang/String;

    invoke-virtual {v0, v1}, Lru/oopssre/imperialschool/viewstv/Repository;->refreshCatalogue(Ljava/lang/String;)V

    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/SceneController;->main:Landroid/os/Handler;

    new-instance v1, Lru/oopssre/imperialschool/viewstv/SceneController$$ExternalSyntheticLambda3;

    invoke-direct {v1, p0, p1, p2}, Lru/oopssre/imperialschool/viewstv/SceneController$$ExternalSyntheticLambda3;-><init>(Lru/oopssre/imperialschool/viewstv/SceneController;J)V

    invoke-virtual {v0, v1}, Landroid/os/Handler;->post(Ljava/lang/Runnable;)Z
    :try_end_1
    .catch Ljava/lang/Exception; {:try_start_1 .. :try_end_1} :catch_1

    .line 26
    :catch_1
    :cond_1
    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/SceneController;->main:Landroid/os/Handler;

    new-instance v5, Lru/oopssre/imperialschool/viewstv/SceneController$$ExternalSyntheticLambda4;

    move-object v6, p0

    move-wide v7, p1

    invoke-direct/range {v5 .. v10}, Lru/oopssre/imperialschool/viewstv/SceneController$$ExternalSyntheticLambda4;-><init>(Lru/oopssre/imperialschool/viewstv/SceneController;JJ)V

    invoke-virtual {v0, v5}, Landroid/os/Handler;->post(Ljava/lang/Runnable;)Z

    return-void
.end method

.method refresh(Z)V
    .locals 4

    .line 18
    iget-boolean v0, p0, Lru/oopssre/imperialschool/viewstv/SceneController;->active:Z

    if-nez v0, :cond_0

    return-void

    :cond_0
    iget-wide v0, p0, Lru/oopssre/imperialschool/viewstv/SceneController;->generation:J

    const-wide/16 v2, 0x1

    add-long/2addr v0, v2

    iput-wide v0, p0, Lru/oopssre/imperialschool/viewstv/SceneController;->generation:J

    iget-object v2, p0, Lru/oopssre/imperialschool/viewstv/SceneController;->main:Landroid/os/Handler;

    iget-object v3, p0, Lru/oopssre/imperialschool/viewstv/SceneController;->poll:Ljava/lang/Runnable;

    invoke-virtual {v2, v3}, Landroid/os/Handler;->removeCallbacks(Ljava/lang/Runnable;)V

    iget-object v2, p0, Lru/oopssre/imperialschool/viewstv/SceneController;->job:Ljava/util/concurrent/Future;

    const/4 v3, 0x1

    if-eqz v2, :cond_1

    invoke-interface {v2, v3}, Ljava/util/concurrent/Future;->cancel(Z)Z

    :cond_1
    iget-object v2, p0, Lru/oopssre/imperialschool/viewstv/SceneController;->cacheJob:Ljava/util/concurrent/Future;

    if-eqz v2, :cond_2

    invoke-interface {v2, v3}, Ljava/util/concurrent/Future;->cancel(Z)Z

    :cond_2
    if-eqz p1, :cond_3

    .line 19
    iget-object p1, p0, Lru/oopssre/imperialschool/viewstv/SceneController;->cacheWorker:Ljava/util/concurrent/ExecutorService;

    new-instance v2, Lru/oopssre/imperialschool/viewstv/SceneController$$ExternalSyntheticLambda6;

    invoke-direct {v2, p0, v0, v1}, Lru/oopssre/imperialschool/viewstv/SceneController$$ExternalSyntheticLambda6;-><init>(Lru/oopssre/imperialschool/viewstv/SceneController;J)V

    invoke-interface {p1, v2}, Ljava/util/concurrent/ExecutorService;->submit(Ljava/lang/Runnable;)Ljava/util/concurrent/Future;

    move-result-object p1

    iput-object p1, p0, Lru/oopssre/imperialschool/viewstv/SceneController;->cacheJob:Ljava/util/concurrent/Future;

    .line 20
    :cond_3
    iget-object p1, p0, Lru/oopssre/imperialschool/viewstv/SceneController;->worker:Ljava/util/concurrent/ExecutorService;

    new-instance v2, Lru/oopssre/imperialschool/viewstv/SceneController$$ExternalSyntheticLambda7;

    invoke-direct {v2, p0, v0, v1}, Lru/oopssre/imperialschool/viewstv/SceneController$$ExternalSyntheticLambda7;-><init>(Lru/oopssre/imperialschool/viewstv/SceneController;J)V

    invoke-interface {p1, v2}, Ljava/util/concurrent/ExecutorService;->submit(Ljava/lang/Runnable;)Ljava/util/concurrent/Future;

    move-result-object p1

    iput-object p1, p0, Lru/oopssre/imperialschool/viewstv/SceneController;->job:Ljava/util/concurrent/Future;

    return-void
.end method

.method reset()V
    .locals 1

    .line 16
    invoke-virtual {p0}, Lru/oopssre/imperialschool/viewstv/SceneController;->stop()V

    const/4 v0, 0x0

    iput-object v0, p0, Lru/oopssre/imperialschool/viewstv/SceneController;->frame:Lru/oopssre/imperialschool/viewstv/Protocol$Frame;

    const-string v0, ""

    iput-object v0, p0, Lru/oopssre/imperialschool/viewstv/SceneController;->displayed:Ljava/lang/String;

    const/4 v0, 0x0

    filled-new-array {v0, v0}, [I

    move-result-object v0

    iput-object v0, p0, Lru/oopssre/imperialschool/viewstv/SceneController;->renderedTarget:[I

    return-void
.end method

.method start()V
    .locals 1

    .line 14
    iget-boolean v0, p0, Lru/oopssre/imperialschool/viewstv/SceneController;->active:Z

    if-eqz v0, :cond_0

    return-void

    :cond_0
    const/4 v0, 0x1

    iput-boolean v0, p0, Lru/oopssre/imperialschool/viewstv/SceneController;->active:Z

    invoke-virtual {p0, v0}, Lru/oopssre/imperialschool/viewstv/SceneController;->refresh(Z)V

    return-void
.end method

.method stop()V
    .locals 4

    const/4 v0, 0x0

    .line 15
    iput-boolean v0, p0, Lru/oopssre/imperialschool/viewstv/SceneController;->active:Z

    iget-wide v0, p0, Lru/oopssre/imperialschool/viewstv/SceneController;->generation:J

    const-wide/16 v2, 0x1

    add-long/2addr v0, v2

    iput-wide v0, p0, Lru/oopssre/imperialschool/viewstv/SceneController;->generation:J

    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/SceneController;->main:Landroid/os/Handler;

    iget-object v1, p0, Lru/oopssre/imperialschool/viewstv/SceneController;->poll:Ljava/lang/Runnable;

    invoke-virtual {v0, v1}, Landroid/os/Handler;->removeCallbacks(Ljava/lang/Runnable;)V

    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/SceneController;->job:Ljava/util/concurrent/Future;

    const/4 v1, 0x1

    if-eqz v0, :cond_0

    invoke-interface {v0, v1}, Ljava/util/concurrent/Future;->cancel(Z)Z

    :cond_0
    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/SceneController;->cacheJob:Ljava/util/concurrent/Future;

    if-eqz v0, :cond_1

    invoke-interface {v0, v1}, Ljava/util/concurrent/Future;->cancel(Z)Z

    :cond_1
    return-void
.end method
