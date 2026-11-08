.class final Lru/oopssre/imperialschool/viewstv/VideoSurface;
.super Landroid/view/SurfaceView;
.source "VideoSurface.java"

# interfaces
.implements Landroid/view/SurfaceHolder$Callback;


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lru/oopssre/imperialschool/viewstv/VideoSurface$Clip;,
        Lru/oopssre/imperialschool/viewstv/VideoSurface$Listener;
    }
.end annotation


# instance fields
.field volatile actualHeight:I

.field volatile actualWidth:I

.field volatile codecName:Ljava/lang/String;

.field volatile decodedHeight:I

.field volatile decodedWidth:I

.field volatile decoderKind:Ljava/lang/String;

.field volatile decoderStarts:I

.field volatile displayed:Lru/oopssre/imperialschool/viewstv/VideoInfo;

.field private volatile disposed:Z

.field volatile failures:J

.field volatile fill:Z

.field private volatile generation:J

.field volatile inputLimit:I

.field private job:Ljava/util/concurrent/Future;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/concurrent/Future<",
            "*>;"
        }
    .end annotation
.end field

.field private launch:Ljava/util/concurrent/atomic/AtomicReference;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/concurrent/atomic/AtomicReference<",
            "Lru/oopssre/imperialschool/viewstv/VideoSurface$Clip;",
            ">;"
        }
    .end annotation
.end field

.field final listener:Lru/oopssre/imperialschool/viewstv/VideoSurface$Listener;

.field volatile loops:J

.field final main:Landroid/os/Handler;

.field final pending:Ljava/util/concurrent/atomic/AtomicReference;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/concurrent/atomic/AtomicReference<",
            "Lru/oopssre/imperialschool/viewstv/VideoSurface$Clip;",
            ">;"
        }
    .end annotation
.end field

.field volatile playing:Z

.field volatile renderedFrames:J

.field volatile running:Z

.field volatile state:Ljava/lang/String;

.field volatile switches:J

.field private volatile wanted:Z

.field final worker:Ljava/util/concurrent/ExecutorService;


# direct methods
.method constructor <init>(Landroid/content/Context;Lru/oopssre/imperialschool/viewstv/VideoSurface$Listener;)V
    .locals 1

    .line 46
    invoke-direct {p0, p1}, Landroid/view/SurfaceView;-><init>(Landroid/content/Context;)V

    .line 39
    new-instance p1, Landroid/os/Handler;

    invoke-static {}, Landroid/os/Looper;->getMainLooper()Landroid/os/Looper;

    move-result-object v0

    invoke-direct {p1, v0}, Landroid/os/Handler;-><init>(Landroid/os/Looper;)V

    iput-object p1, p0, Lru/oopssre/imperialschool/viewstv/VideoSurface;->main:Landroid/os/Handler;

    .line 40
    invoke-static {}, Ljava/util/concurrent/Executors;->newSingleThreadExecutor()Ljava/util/concurrent/ExecutorService;

    move-result-object p1

    iput-object p1, p0, Lru/oopssre/imperialschool/viewstv/VideoSurface;->worker:Ljava/util/concurrent/ExecutorService;

    new-instance p1, Ljava/util/concurrent/atomic/AtomicReference;

    invoke-direct {p1}, Ljava/util/concurrent/atomic/AtomicReference;-><init>()V

    iput-object p1, p0, Lru/oopssre/imperialschool/viewstv/VideoSurface;->pending:Ljava/util/concurrent/atomic/AtomicReference;

    .line 41
    new-instance p1, Ljava/util/concurrent/atomic/AtomicReference;

    invoke-direct {p1}, Ljava/util/concurrent/atomic/AtomicReference;-><init>()V

    iput-object p1, p0, Lru/oopssre/imperialschool/viewstv/VideoSurface;->launch:Ljava/util/concurrent/atomic/AtomicReference;

    .line 43
    const-string p1, "\u041e\u0436\u0438\u0434\u0430\u043d\u0438\u0435 \u043e\u043f\u0443\u0431\u043b\u0438\u043a\u043e\u0432\u0430\u043d\u043d\u043e\u0433\u043e \u0432\u0438\u0434\u0435\u043e\u2026"

    iput-object p1, p0, Lru/oopssre/imperialschool/viewstv/VideoSurface;->state:Ljava/lang/String;

    const-string p1, ""

    iput-object p1, p0, Lru/oopssre/imperialschool/viewstv/VideoSurface;->codecName:Ljava/lang/String;

    iput-object p1, p0, Lru/oopssre/imperialschool/viewstv/VideoSurface;->decoderKind:Ljava/lang/String;

    .line 46
    iput-object p2, p0, Lru/oopssre/imperialschool/viewstv/VideoSurface;->listener:Lru/oopssre/imperialschool/viewstv/VideoSurface$Listener;

    const/4 p1, 0x0

    invoke-virtual {p0, p1}, Lru/oopssre/imperialschool/viewstv/VideoSurface;->setFocusable(Z)V

    const-string p1, "\u0414\u0438\u043d\u0430\u043c\u0438\u0447\u0435\u0441\u043a\u0438\u0435 \u0432\u0438\u0434\u0435\u043e\u043e\u0431\u043e\u0438 4\u041a"

    invoke-virtual {p0, p1}, Lru/oopssre/imperialschool/viewstv/VideoSurface;->setContentDescription(Ljava/lang/CharSequence;)V

    invoke-virtual {p0}, Lru/oopssre/imperialschool/viewstv/VideoSurface;->getHolder()Landroid/view/SurfaceHolder;

    move-result-object p1

    const/16 p2, 0xf00

    const/16 v0, 0x870

    invoke-interface {p1, p2, v0}, Landroid/view/SurfaceHolder;->setFixedSize(II)V

    invoke-virtual {p0}, Lru/oopssre/imperialschool/viewstv/VideoSurface;->getHolder()Landroid/view/SurfaceHolder;

    move-result-object p1

    invoke-interface {p1, p0}, Landroid/view/SurfaceHolder;->addCallback(Landroid/view/SurfaceHolder$Callback;)V

    return-void
.end method

.method private begin()V
    .locals 11

    .line 57
    iget-boolean v0, p0, Lru/oopssre/imperialschool/viewstv/VideoSurface;->wanted:Z

    if-eqz v0, :cond_2

    iget-boolean v0, p0, Lru/oopssre/imperialschool/viewstv/VideoSurface;->disposed:Z

    if-nez v0, :cond_2

    invoke-virtual {p0}, Lru/oopssre/imperialschool/viewstv/VideoSurface;->getHolder()Landroid/view/SurfaceHolder;

    move-result-object v0

    invoke-interface {v0}, Landroid/view/SurfaceHolder;->getSurface()Landroid/view/Surface;

    move-result-object v0

    invoke-virtual {v0}, Landroid/view/Surface;->isValid()Z

    move-result v0

    if-eqz v0, :cond_2

    invoke-virtual {p0}, Lru/oopssre/imperialschool/viewstv/VideoSurface;->getVisibility()I

    move-result v0

    if-nez v0, :cond_2

    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/VideoSurface;->pending:Ljava/util/concurrent/atomic/AtomicReference;

    invoke-virtual {v0}, Ljava/util/concurrent/atomic/AtomicReference;->get()Ljava/lang/Object;

    move-result-object v0

    if-eqz v0, :cond_2

    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/VideoSurface;->job:Ljava/util/concurrent/Future;

    if-eqz v0, :cond_0

    invoke-interface {v0}, Ljava/util/concurrent/Future;->isDone()Z

    move-result v0

    if-nez v0, :cond_0

    goto :goto_0

    .line 58
    :cond_0
    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/VideoSurface;->pending:Ljava/util/concurrent/atomic/AtomicReference;

    const/4 v1, 0x0

    invoke-virtual {v0, v1}, Ljava/util/concurrent/atomic/AtomicReference;->getAndSet(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Lru/oopssre/imperialschool/viewstv/VideoSurface$Clip;

    if-nez v0, :cond_1

    goto :goto_0

    :cond_1
    iget-wide v1, p0, Lru/oopssre/imperialschool/viewstv/VideoSurface;->generation:J

    const-wide/16 v3, 0x1

    add-long v9, v1, v3

    iput-wide v9, p0, Lru/oopssre/imperialschool/viewstv/VideoSurface;->generation:J

    const/4 v1, 0x1

    iput-boolean v1, p0, Lru/oopssre/imperialschool/viewstv/VideoSurface;->running:Z

    const/4 v1, 0x0

    iput v1, p0, Lru/oopssre/imperialschool/viewstv/VideoSurface;->decoderStarts:I

    const-wide/16 v1, 0x0

    iput-wide v1, p0, Lru/oopssre/imperialschool/viewstv/VideoSurface;->switches:J

    iput-wide v1, p0, Lru/oopssre/imperialschool/viewstv/VideoSurface;->renderedFrames:J

    iput-wide v1, p0, Lru/oopssre/imperialschool/viewstv/VideoSurface;->loops:J

    .line 59
    new-instance v7, Ljava/util/concurrent/atomic/AtomicReference;

    invoke-direct {v7, v0}, Ljava/util/concurrent/atomic/AtomicReference;-><init>(Ljava/lang/Object;)V

    iput-object v7, p0, Lru/oopssre/imperialschool/viewstv/VideoSurface;->launch:Ljava/util/concurrent/atomic/AtomicReference;

    invoke-virtual {p0}, Lru/oopssre/imperialschool/viewstv/VideoSurface;->getHolder()Landroid/view/SurfaceHolder;

    move-result-object v0

    invoke-interface {v0}, Landroid/view/SurfaceHolder;->getSurface()Landroid/view/Surface;

    move-result-object v8

    .line 60
    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/VideoSurface;->worker:Ljava/util/concurrent/ExecutorService;

    new-instance v5, Lru/oopssre/imperialschool/viewstv/VideoSurface$$ExternalSyntheticLambda1;

    move-object v6, p0

    invoke-direct/range {v5 .. v10}, Lru/oopssre/imperialschool/viewstv/VideoSurface$$ExternalSyntheticLambda1;-><init>(Lru/oopssre/imperialschool/viewstv/VideoSurface;Ljava/util/concurrent/atomic/AtomicReference;Landroid/view/Surface;J)V

    invoke-interface {v0, v5}, Ljava/util/concurrent/ExecutorService;->submit(Ljava/lang/Runnable;)Ljava/util/concurrent/Future;

    move-result-object v0

    iput-object v0, v6, Lru/oopssre/imperialschool/viewstv/VideoSurface;->job:Ljava/util/concurrent/Future;

    return-void

    :cond_2
    :goto_0
    move-object v6, p0

    return-void
.end method

.method private changed(J)V
    .locals 2

    .line 56
    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/VideoSurface;->main:Landroid/os/Handler;

    new-instance v1, Lru/oopssre/imperialschool/viewstv/VideoSurface$$ExternalSyntheticLambda0;

    invoke-direct {v1, p0, p1, p2}, Lru/oopssre/imperialschool/viewstv/VideoSurface$$ExternalSyntheticLambda0;-><init>(Lru/oopssre/imperialschool/viewstv/VideoSurface;J)V

    invoke-virtual {v0, v1}, Landroid/os/Handler;->post(Ljava/lang/Runnable;)Z

    return-void
.end method

.method private static compatible(Lru/oopssre/imperialschool/viewstv/VideoSurface$Clip;Lru/oopssre/imperialschool/viewstv/VideoSurface$Clip;)Z
    .locals 8

    .line 89
    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/VideoSurface$Clip;->info:Lru/oopssre/imperialschool/viewstv/VideoInfo;

    iget v0, v0, Lru/oopssre/imperialschool/viewstv/VideoInfo;->fps:I

    iget-object v1, p1, Lru/oopssre/imperialschool/viewstv/VideoSurface$Clip;->info:Lru/oopssre/imperialschool/viewstv/VideoInfo;

    iget v1, v1, Lru/oopssre/imperialschool/viewstv/VideoInfo;->fps:I

    const/4 v2, 0x0

    if-eq v0, v1, :cond_0

    return v2

    :cond_0
    const/4 v0, 0x3

    new-array v1, v0, [Ljava/lang/String;

    const-string v3, "csd-0"

    aput-object v3, v1, v2

    const-string v3, "csd-1"

    const/4 v4, 0x1

    aput-object v3, v1, v4

    const/4 v3, 0x2

    const-string v5, "csd-2"

    aput-object v5, v1, v3

    move v3, v2

    :goto_0
    if-ge v3, v0, :cond_2

    aget-object v5, v1, v3

    iget-object v6, p0, Lru/oopssre/imperialschool/viewstv/VideoSurface$Clip;->format:Landroid/media/MediaFormat;

    invoke-static {v6, v5}, Lru/oopssre/imperialschool/viewstv/VideoSurface;->config(Landroid/media/MediaFormat;Ljava/lang/String;)[B

    move-result-object v6

    iget-object v7, p1, Lru/oopssre/imperialschool/viewstv/VideoSurface$Clip;->format:Landroid/media/MediaFormat;

    invoke-static {v7, v5}, Lru/oopssre/imperialschool/viewstv/VideoSurface;->config(Landroid/media/MediaFormat;Ljava/lang/String;)[B

    move-result-object v5

    invoke-static {v6, v5}, Ljava/util/Arrays;->equals([B[B)Z

    move-result v5

    if-nez v5, :cond_1

    return v2

    :cond_1
    add-int/lit8 v3, v3, 0x1

    goto :goto_0

    :cond_2
    return v4
.end method

.method private static config(Landroid/media/MediaFormat;Ljava/lang/String;)[B
    .locals 1

    .line 88
    invoke-virtual {p0, p1}, Landroid/media/MediaFormat;->containsKey(Ljava/lang/String;)Z

    move-result v0

    if-nez v0, :cond_0

    const/4 p0, 0x0

    new-array p0, p0, [B

    return-object p0

    :cond_0
    invoke-virtual {p0, p1}, Landroid/media/MediaFormat;->getByteBuffer(Ljava/lang/String;)Ljava/nio/ByteBuffer;

    move-result-object p0

    invoke-virtual {p0}, Ljava/nio/ByteBuffer;->duplicate()Ljava/nio/ByteBuffer;

    move-result-object p0

    invoke-virtual {p0}, Ljava/nio/ByteBuffer;->remaining()I

    move-result p1

    new-array p1, p1, [B

    invoke-virtual {p0, p1}, Ljava/nio/ByteBuffer;->get([B)Ljava/nio/ByteBuffer;

    return-object p1
.end method

.method static configureWindow(Landroid/view/Window;)V
    .locals 3

    .line 47
    :try_start_0
    invoke-virtual {p0}, Landroid/view/Window;->getWindowManager()Landroid/view/WindowManager;

    move-result-object v0

    invoke-interface {v0}, Landroid/view/WindowManager;->getDefaultDisplay()Landroid/view/Display;

    move-result-object v0

    invoke-static {v0}, Lru/oopssre/imperialschool/viewstv/WallpaperSurface;->bestMode(Landroid/view/Display;)Lru/oopssre/imperialschool/viewstv/TvDisplay$Mode;

    move-result-object v0

    iget v1, v0, Lru/oopssre/imperialschool/viewstv/TvDisplay$Mode;->width:I

    iget v2, v0, Lru/oopssre/imperialschool/viewstv/TvDisplay$Mode;->height:I

    invoke-static {v1, v2}, Lru/oopssre/imperialschool/viewstv/TvDisplay;->is4k(II)Z

    move-result v1

    if-eqz v1, :cond_0

    iget v0, v0, Lru/oopssre/imperialschool/viewstv/TvDisplay$Mode;->id:I

    goto :goto_0

    :cond_0
    const/4 v0, 0x0

    :goto_0
    invoke-virtual {p0}, Landroid/view/Window;->getAttributes()Landroid/view/WindowManager$LayoutParams;

    move-result-object v1

    iget v2, v1, Landroid/view/WindowManager$LayoutParams;->preferredDisplayModeId:I

    if-eq v2, v0, :cond_1

    iput v0, v1, Landroid/view/WindowManager$LayoutParams;->preferredDisplayModeId:I

    invoke-virtual {p0, v1}, Landroid/view/Window;->setAttributes(Landroid/view/WindowManager$LayoutParams;)V
    :try_end_0
    .catch Ljava/lang/RuntimeException; {:try_start_0 .. :try_end_0} :catch_0

    :catch_0
    :cond_1
    return-void
.end method

.method private current(J)Z
    .locals 2

    .line 55
    iget-boolean v0, p0, Lru/oopssre/imperialschool/viewstv/VideoSurface;->wanted:Z

    if-eqz v0, :cond_0

    iget-boolean v0, p0, Lru/oopssre/imperialschool/viewstv/VideoSurface;->disposed:Z

    if-nez v0, :cond_0

    iget-wide v0, p0, Lru/oopssre/imperialschool/viewstv/VideoSurface;->generation:J

    cmp-long p1, p1, v0

    if-nez p1, :cond_0

    invoke-static {}, Ljava/lang/Thread;->currentThread()Ljava/lang/Thread;

    move-result-object p1

    invoke-virtual {p1}, Ljava/lang/Thread;->isInterrupted()Z

    move-result p1

    if-nez p1, :cond_0

    const/4 p1, 0x1

    return p1

    :cond_0
    const/4 p1, 0x0

    return p1
.end method

.method private decode(Lru/oopssre/imperialschool/viewstv/VideoSurface$Clip;Landroid/view/Surface;J)V
    .locals 36

    move-object/from16 v1, p0

    move-wide/from16 v2, p3

    .line 92
    const-string v0, "max-input-size"

    const-string v4, "crop-top"

    const-string v5, "crop-bottom"

    const-string v6, "crop-left"

    const-string v7, "crop-right"

    const/4 v10, 0x1

    const/4 v11, 0x0

    const/4 v12, 0x0

    .line 94
    :try_start_0
    invoke-direct {v1, v2, v3}, Lru/oopssre/imperialschool/viewstv/VideoSurface;->current(J)Z

    move-result v13
    :try_end_0
    .catch Ljava/lang/InterruptedException; {:try_start_0 .. :try_end_0} :catch_13
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_12
    .catchall {:try_start_0 .. :try_end_0} :catchall_a

    if-nez v13, :cond_0

    .line 119
    invoke-static {v11}, Lru/oopssre/imperialschool/viewstv/VideoSurface;->release(Landroid/media/MediaCodec;)V

    invoke-virtual/range {p1 .. p1}, Lru/oopssre/imperialschool/viewstv/VideoSurface$Clip;->close()V

    iget-wide v4, v1, Lru/oopssre/imperialschool/viewstv/VideoSurface;->generation:J

    cmp-long v0, v2, v4

    if-nez v0, :cond_1e

    iput-boolean v12, v1, Lru/oopssre/imperialschool/viewstv/VideoSurface;->running:Z

    return-void

    .line 94
    :cond_0
    :try_start_1
    invoke-direct/range {p0 .. p2}, Lru/oopssre/imperialschool/viewstv/VideoSurface;->decoder(Lru/oopssre/imperialschool/viewstv/VideoSurface$Clip;Landroid/view/Surface;)Landroid/media/MediaCodec;

    move-result-object v13
    :try_end_1
    .catch Ljava/lang/InterruptedException; {:try_start_1 .. :try_end_1} :catch_13
    .catch Ljava/lang/Exception; {:try_start_1 .. :try_end_1} :catch_12
    .catchall {:try_start_1 .. :try_end_1} :catchall_a

    :try_start_2
    iget-boolean v14, v1, Lru/oopssre/imperialschool/viewstv/VideoSurface;->fill:Z

    xor-int/2addr v14, v10

    .line 95
    invoke-static {}, Ljava/lang/System;->nanoTime()J

    move-result-wide v15
    :try_end_2
    .catch Ljava/lang/InterruptedException; {:try_start_2 .. :try_end_2} :catch_10
    .catch Ljava/lang/Exception; {:try_start_2 .. :try_end_2} :catch_f
    .catchall {:try_start_2 .. :try_end_2} :catchall_9

    const-wide/16 v17, 0x1

    :try_start_3
    new-instance v8, Landroid/media/MediaCodec$BufferInfo;

    invoke-direct {v8}, Landroid/media/MediaCodec$BufferInfo;-><init>()V
    :try_end_3
    .catch Ljava/lang/InterruptedException; {:try_start_3 .. :try_end_3} :catch_11
    .catch Ljava/lang/Exception; {:try_start_3 .. :try_end_3} :catch_e
    .catchall {:try_start_3 .. :try_end_3} :catchall_8

    const-wide/16 v19, 0x0

    move-object/from16 v9, p1

    move/from16 v31, v10

    move-object/from16 v34, v11

    move/from16 v28, v12

    move-wide/from16 v29, v19

    move-wide/from16 v32, v29

    .line 96
    :goto_0
    :try_start_4
    invoke-direct {v1, v2, v3}, Lru/oopssre/imperialschool/viewstv/VideoSurface;->current(J)Z

    move-result v21
    :try_end_4
    .catch Ljava/lang/InterruptedException; {:try_start_4 .. :try_end_4} :catch_d
    .catch Ljava/lang/Exception; {:try_start_4 .. :try_end_4} :catch_c
    .catchall {:try_start_4 .. :try_end_4} :catchall_7

    if-eqz v21, :cond_17

    move/from16 v35, v10

    .line 97
    :try_start_5
    iget-boolean v10, v1, Lru/oopssre/imperialschool/viewstv/VideoSurface;->fill:Z
    :try_end_5
    .catch Ljava/lang/InterruptedException; {:try_start_5 .. :try_end_5} :catch_d
    .catch Ljava/lang/Exception; {:try_start_5 .. :try_end_5} :catch_b
    .catchall {:try_start_5 .. :try_end_5} :catchall_7

    if-eq v14, v10, :cond_2

    :try_start_6
    iget-boolean v14, v1, Lru/oopssre/imperialschool/viewstv/VideoSurface;->fill:Z

    iget-boolean v10, v1, Lru/oopssre/imperialschool/viewstv/VideoSurface;->fill:Z

    if-eqz v10, :cond_1

    const/4 v10, 0x2

    goto :goto_1

    :cond_1
    move/from16 v10, v35

    :goto_1
    invoke-virtual {v13, v10}, Landroid/media/MediaCodec;->setVideoScalingMode(I)V
    :try_end_6
    .catch Ljava/lang/InterruptedException; {:try_start_6 .. :try_end_6} :catch_d
    .catch Ljava/lang/Exception; {:try_start_6 .. :try_end_6} :catch_b
    .catchall {:try_start_6 .. :try_end_6} :catchall_0

    goto :goto_2

    :catchall_0
    move-exception v0

    move/from16 v35, v12

    goto/16 :goto_1a

    :cond_2
    :goto_2
    const-wide/16 v11, 0x2710

    if-nez v28, :cond_5

    .line 98
    :try_start_7
    invoke-virtual {v13, v11, v12}, Landroid/media/MediaCodec;->dequeueInputBuffer(J)I

    move-result v10

    if-ltz v10, :cond_5

    invoke-virtual {v13, v10}, Landroid/media/MediaCodec;->getInputBuffer(I)Ljava/nio/ByteBuffer;

    move-result-object v11

    if-eqz v11, :cond_4

    invoke-virtual {v11}, Ljava/nio/ByteBuffer;->clear()Ljava/nio/Buffer;

    iget-object v12, v9, Lru/oopssre/imperialschool/viewstv/VideoSurface$Clip;->extractor:Landroid/media/MediaExtractor;

    move/from16 v22, v10

    const/4 v10, 0x0

    invoke-virtual {v12, v11, v10}, Landroid/media/MediaExtractor;->readSampleData(Ljava/nio/ByteBuffer;I)I

    move-result v24
    :try_end_7
    .catch Ljava/lang/InterruptedException; {:try_start_7 .. :try_end_7} :catch_d
    .catch Ljava/lang/Exception; {:try_start_7 .. :try_end_7} :catch_b
    .catchall {:try_start_7 .. :try_end_7} :catchall_7

    if-gez v24, :cond_3

    .line 99
    :try_start_8
    iget-object v11, v9, Lru/oopssre/imperialschool/viewstv/VideoSurface$Clip;->info:Lru/oopssre/imperialschool/viewstv/VideoInfo;

    iget v11, v11, Lru/oopssre/imperialschool/viewstv/VideoInfo;->fps:I

    int-to-long v11, v11

    const-wide/32 v23, 0xf4240

    div-long v23, v23, v11
    :try_end_8
    .catch Ljava/lang/InterruptedException; {:try_start_8 .. :try_end_8} :catch_1
    .catch Ljava/lang/Exception; {:try_start_8 .. :try_end_8} :catch_0
    .catchall {:try_start_8 .. :try_end_8} :catchall_2

    add-long v25, v29, v23

    const/16 v27, 0x4

    const/16 v23, 0x0

    const/16 v24, 0x0

    move-object/from16 v21, v13

    :try_start_9
    invoke-virtual/range {v21 .. v27}, Landroid/media/MediaCodec;->queueInputBuffer(IIIJI)V
    :try_end_9
    .catch Ljava/lang/InterruptedException; {:try_start_9 .. :try_end_9} :catch_2
    .catch Ljava/lang/Exception; {:try_start_9 .. :try_end_9} :catch_3
    .catchall {:try_start_9 .. :try_end_9} :catchall_1

    move-object/from16 v13, v21

    move/from16 v28, v35

    goto :goto_4

    :catchall_1
    move-exception v0

    goto :goto_3

    :catchall_2
    move-exception v0

    move-object/from16 v21, v13

    :goto_3
    move-object/from16 v11, v21

    goto/16 :goto_16

    :catch_0
    move-exception v0

    move-object/from16 v21, v13

    goto/16 :goto_11

    :catch_1
    move-object/from16 v21, v13

    :catch_2
    move-object/from16 v11, v21

    goto/16 :goto_1e

    :cond_3
    move-object/from16 v21, v13

    .line 100
    :try_start_a
    iget-object v11, v9, Lru/oopssre/imperialschool/viewstv/VideoSurface$Clip;->extractor:Landroid/media/MediaExtractor;

    invoke-virtual {v11}, Landroid/media/MediaExtractor;->getSampleTime()J

    move-result-wide v25

    const/16 v23, 0x0

    const/16 v27, 0x0

    invoke-virtual/range {v21 .. v27}, Landroid/media/MediaCodec;->queueInputBuffer(IIIJI)V
    :try_end_a
    .catch Ljava/lang/InterruptedException; {:try_start_a .. :try_end_a} :catch_4
    .catch Ljava/lang/Exception; {:try_start_a .. :try_end_a} :catch_3
    .catchall {:try_start_a .. :try_end_a} :catchall_3

    move-object/from16 v13, v21

    :try_start_b
    iget-object v11, v9, Lru/oopssre/imperialschool/viewstv/VideoSurface$Clip;->extractor:Landroid/media/MediaExtractor;

    invoke-virtual {v11}, Landroid/media/MediaExtractor;->advance()Z

    move-wide/from16 v29, v25

    goto :goto_4

    :catchall_3
    move-exception v0

    move-object/from16 v13, v21

    goto/16 :goto_1c

    :catch_3
    move-exception v0

    move-object/from16 v13, v21

    goto/16 :goto_11

    :catch_4
    move-object/from16 v13, v21

    goto/16 :goto_12

    .line 98
    :cond_4
    new-instance v0, Ljava/io/IOException;

    const-string v4, "\u041d\u0435\u0442 \u0432\u0445\u043e\u0434\u043d\u043e\u0433\u043e \u0431\u0443\u0444\u0435\u0440\u0430 \u0434\u0435\u043a\u043e\u0434\u0435\u0440\u0430"

    invoke-direct {v0, v4}, Ljava/io/IOException;-><init>(Ljava/lang/String;)V

    throw v0

    :cond_5
    :goto_4
    const-wide/16 v11, 0x2710

    .line 101
    invoke-virtual {v13, v8, v11, v12}, Landroid/media/MediaCodec;->dequeueOutputBuffer(Landroid/media/MediaCodec$BufferInfo;J)I

    move-result v11

    const/4 v12, -0x2

    if-ne v11, v12, :cond_9

    .line 102
    invoke-virtual {v13}, Landroid/media/MediaCodec;->getOutputFormat()Landroid/media/MediaFormat;

    move-result-object v11

    invoke-virtual {v11, v7}, Landroid/media/MediaFormat;->containsKey(Ljava/lang/String;)Z

    move-result v12

    if-eqz v12, :cond_6

    invoke-virtual {v11, v6}, Landroid/media/MediaFormat;->containsKey(Ljava/lang/String;)Z

    move-result v12

    if-eqz v12, :cond_6

    invoke-virtual {v11, v7}, Landroid/media/MediaFormat;->getInteger(Ljava/lang/String;)I

    move-result v12

    invoke-virtual {v11, v6}, Landroid/media/MediaFormat;->getInteger(Ljava/lang/String;)I

    move-result v21

    sub-int v12, v12, v21

    add-int/lit8 v12, v12, 0x1

    goto :goto_5

    :cond_6
    const-string v12, "width"

    invoke-virtual {v11, v12}, Landroid/media/MediaFormat;->getInteger(Ljava/lang/String;)I

    move-result v12

    :goto_5
    iput v12, v1, Lru/oopssre/imperialschool/viewstv/VideoSurface;->decodedWidth:I

    invoke-virtual {v11, v5}, Landroid/media/MediaFormat;->containsKey(Ljava/lang/String;)Z

    move-result v12

    if-eqz v12, :cond_7

    invoke-virtual {v11, v4}, Landroid/media/MediaFormat;->containsKey(Ljava/lang/String;)Z

    move-result v12

    if-eqz v12, :cond_7

    invoke-virtual {v11, v5}, Landroid/media/MediaFormat;->getInteger(Ljava/lang/String;)I

    move-result v12

    invoke-virtual {v11, v4}, Landroid/media/MediaFormat;->getInteger(Ljava/lang/String;)I

    move-result v11

    sub-int/2addr v12, v11

    add-int/lit8 v12, v12, 0x1

    goto :goto_6

    :cond_7
    const-string v12, "height"

    invoke-virtual {v11, v12}, Landroid/media/MediaFormat;->getInteger(Ljava/lang/String;)I

    move-result v12

    :goto_6
    iput v12, v1, Lru/oopssre/imperialschool/viewstv/VideoSurface;->decodedHeight:I

    iget v11, v1, Lru/oopssre/imperialschool/viewstv/VideoSurface;->decodedWidth:I

    const/16 v12, 0xf00

    if-ne v11, v12, :cond_8

    iget v11, v1, Lru/oopssre/imperialschool/viewstv/VideoSurface;->decodedHeight:I

    const/16 v12, 0x870

    if-ne v11, v12, :cond_8

    invoke-direct {v1, v2, v3}, Lru/oopssre/imperialschool/viewstv/VideoSurface;->changed(J)V

    goto/16 :goto_e

    :cond_8
    new-instance v0, Ljava/io/IOException;

    const-string v4, "\u0414\u0435\u043a\u043e\u0434\u0435\u0440 \u0432\u044b\u0434\u0430\u043b \u0440\u0430\u0437\u043c\u0435\u0440 \u043c\u0435\u043d\u044c\u0448\u0435 4\u041a"

    invoke-direct {v0, v4}, Ljava/io/IOException;-><init>(Ljava/lang/String;)V

    throw v0

    :cond_9
    if-ltz v11, :cond_15

    .line 103
    invoke-static {}, Ljava/lang/System;->nanoTime()J

    move-result-wide v15

    iget v12, v8, Landroid/media/MediaCodec$BufferInfo;->size:I

    if-lez v12, :cond_a

    move/from16 v12, v35

    goto :goto_7

    :cond_a
    const/4 v12, 0x0

    :goto_7
    const-wide/16 v21, 0x3e8

    if-eqz v12, :cond_c

    cmp-long v23, v32, v19

    if-nez v23, :cond_b

    invoke-static {}, Ljava/lang/System;->nanoTime()J

    move-result-wide v23

    move/from16 v25, v11

    iget-wide v10, v8, Landroid/media/MediaCodec$BufferInfo;->presentationTimeUs:J

    mul-long v10, v10, v21

    sub-long v32, v23, v10

    goto :goto_8

    :cond_b
    move/from16 v25, v11

    :goto_8
    iget-wide v10, v8, Landroid/media/MediaCodec$BufferInfo;->presentationTimeUs:J

    mul-long v10, v10, v21

    add-long v10, v32, v10

    invoke-direct {v1, v10, v11, v2, v3}, Lru/oopssre/imperialschool/viewstv/VideoSurface;->waitUntil(JJ)V

    move/from16 v10, v25

    goto :goto_9

    :cond_c
    move v10, v11

    :goto_9
    invoke-virtual {v13, v10, v12}, Landroid/media/MediaCodec;->releaseOutputBuffer(IZ)V

    if-eqz v12, :cond_e

    .line 104
    iget-wide v10, v1, Lru/oopssre/imperialschool/viewstv/VideoSurface;->renderedFrames:J

    add-long v10, v10, v17

    iput-wide v10, v1, Lru/oopssre/imperialschool/viewstv/VideoSurface;->renderedFrames:J

    if-eqz v31, :cond_e

    iget-object v10, v9, Lru/oopssre/imperialschool/viewstv/VideoSurface$Clip;->info:Lru/oopssre/imperialschool/viewstv/VideoInfo;

    iget-object v11, v1, Lru/oopssre/imperialschool/viewstv/VideoSurface;->main:Landroid/os/Handler;

    new-instance v12, Lru/oopssre/imperialschool/viewstv/VideoSurface$$ExternalSyntheticLambda2;

    invoke-direct {v12, v1, v2, v3, v10}, Lru/oopssre/imperialschool/viewstv/VideoSurface$$ExternalSyntheticLambda2;-><init>(Lru/oopssre/imperialschool/viewstv/VideoSurface;JLru/oopssre/imperialschool/viewstv/VideoInfo;)V

    invoke-virtual {v11, v12}, Landroid/os/Handler;->post(Ljava/lang/Runnable;)Z

    if-eqz v34, :cond_d

    invoke-virtual/range {v34 .. v34}, Lru/oopssre/imperialschool/viewstv/VideoSurface$Clip;->close()V

    const/16 v31, 0x0

    const/16 v34, 0x0

    goto :goto_a

    :cond_d
    const/16 v31, 0x0

    .line 105
    :cond_e
    :goto_a
    iget v10, v8, Landroid/media/MediaCodec$BufferInfo;->flags:I

    and-int/lit8 v10, v10, 0x4

    if-eqz v10, :cond_15

    cmp-long v10, v32, v19

    if-eqz v10, :cond_f

    iget-wide v10, v9, Lru/oopssre/imperialschool/viewstv/VideoSurface$Clip;->duration:J

    mul-long v10, v10, v21

    add-long v10, v32, v10

    invoke-direct {v1, v10, v11, v2, v3}, Lru/oopssre/imperialschool/viewstv/VideoSurface;->waitUntil(JJ)V

    :cond_f
    invoke-direct {v1, v2, v3}, Lru/oopssre/imperialschool/viewstv/VideoSurface;->current(J)Z

    move-result v10

    if-nez v10, :cond_10

    goto/16 :goto_10

    :cond_10
    iget-wide v10, v1, Lru/oopssre/imperialschool/viewstv/VideoSurface;->loops:J

    add-long v10, v10, v17

    iput-wide v10, v1, Lru/oopssre/imperialschool/viewstv/VideoSurface;->loops:J

    .line 106
    iget-object v10, v1, Lru/oopssre/imperialschool/viewstv/VideoSurface;->pending:Ljava/util/concurrent/atomic/AtomicReference;

    const/4 v11, 0x0

    invoke-virtual {v10, v11}, Ljava/util/concurrent/atomic/AtomicReference;->getAndSet(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v10

    check-cast v10, Lru/oopssre/imperialschool/viewstv/VideoSurface$Clip;

    if-eqz v10, :cond_11

    .line 107
    iget-object v12, v10, Lru/oopssre/imperialschool/viewstv/VideoSurface$Clip;->info:Lru/oopssre/imperialschool/viewstv/VideoInfo;

    iget-object v15, v9, Lru/oopssre/imperialschool/viewstv/VideoSurface$Clip;->info:Lru/oopssre/imperialschool/viewstv/VideoInfo;

    invoke-virtual {v12, v15}, Lru/oopssre/imperialschool/viewstv/VideoInfo;->sameMedia(Lru/oopssre/imperialschool/viewstv/VideoInfo;)Z

    move-result v12

    if-eqz v12, :cond_11

    iget-object v12, v10, Lru/oopssre/imperialschool/viewstv/VideoSurface$Clip;->info:Lru/oopssre/imperialschool/viewstv/VideoInfo;

    invoke-virtual {v10}, Lru/oopssre/imperialschool/viewstv/VideoSurface$Clip;->close()V

    iget-object v10, v1, Lru/oopssre/imperialschool/viewstv/VideoSurface;->main:Landroid/os/Handler;

    new-instance v15, Lru/oopssre/imperialschool/viewstv/VideoSurface$$ExternalSyntheticLambda3;

    invoke-direct {v15, v1, v2, v3, v12}, Lru/oopssre/imperialschool/viewstv/VideoSurface$$ExternalSyntheticLambda3;-><init>(Lru/oopssre/imperialschool/viewstv/VideoSurface;JLru/oopssre/imperialschool/viewstv/VideoInfo;)V

    invoke-virtual {v10, v15}, Landroid/os/Handler;->post(Ljava/lang/Runnable;)Z

    move-object v10, v11

    :cond_11
    if-eqz v10, :cond_14

    .line 108
    invoke-virtual {v10}, Lru/oopssre/imperialschool/viewstv/VideoSurface$Clip;->rewind()V

    iget-object v12, v10, Lru/oopssre/imperialschool/viewstv/VideoSurface$Clip;->format:Landroid/media/MediaFormat;

    invoke-virtual {v12, v0}, Landroid/media/MediaFormat;->containsKey(Ljava/lang/String;)Z

    move-result v12

    if-eqz v12, :cond_12

    iget-object v12, v10, Lru/oopssre/imperialschool/viewstv/VideoSurface$Clip;->format:Landroid/media/MediaFormat;

    invoke-virtual {v12, v0}, Landroid/media/MediaFormat;->getInteger(Ljava/lang/String;)I

    move-result v12

    goto :goto_b

    :cond_12
    iget-object v12, v10, Lru/oopssre/imperialschool/viewstv/VideoSurface$Clip;->info:Lru/oopssre/imperialschool/viewstv/VideoInfo;

    iget-wide v11, v12, Lru/oopssre/imperialschool/viewstv/VideoInfo;->bytes:J

    long-to-int v12, v11

    :goto_b
    invoke-static {v9, v10}, Lru/oopssre/imperialschool/viewstv/VideoSurface;->compatible(Lru/oopssre/imperialschool/viewstv/VideoSurface$Clip;Lru/oopssre/imperialschool/viewstv/VideoSurface$Clip;)Z

    move-result v11

    if-eqz v11, :cond_13

    iget v11, v1, Lru/oopssre/imperialschool/viewstv/VideoSurface;->inputLimit:I
    :try_end_b
    .catch Ljava/lang/InterruptedException; {:try_start_b .. :try_end_b} :catch_d
    .catch Ljava/lang/Exception; {:try_start_b .. :try_end_b} :catch_b
    .catchall {:try_start_b .. :try_end_b} :catchall_7

    if-gt v12, v11, :cond_13

    .line 109
    :try_start_c
    invoke-virtual {v13}, Landroid/media/MediaCodec;->flush()V

    move-object/from16 v11, p2

    goto :goto_c

    :cond_13
    invoke-static {v13}, Lru/oopssre/imperialschool/viewstv/VideoSurface;->release(Landroid/media/MediaCodec;)V
    :try_end_c
    .catch Ljava/lang/InterruptedException; {:try_start_c .. :try_end_c} :catch_a
    .catch Ljava/lang/Exception; {:try_start_c .. :try_end_c} :catch_9
    .catchall {:try_start_c .. :try_end_c} :catchall_6

    move-object/from16 v11, p2

    :try_start_d
    invoke-direct {v1, v10, v11}, Lru/oopssre/imperialschool/viewstv/VideoSurface;->decoder(Lru/oopssre/imperialschool/viewstv/VideoSurface$Clip;Landroid/view/Surface;)Landroid/media/MediaCodec;

    move-result-object v12
    :try_end_d
    .catch Ljava/lang/InterruptedException; {:try_start_d .. :try_end_d} :catch_8
    .catch Ljava/lang/Exception; {:try_start_d .. :try_end_d} :catch_7
    .catchall {:try_start_d .. :try_end_d} :catchall_5

    :try_start_e
    iget-boolean v13, v1, Lru/oopssre/imperialschool/viewstv/VideoSurface;->fill:Z
    :try_end_e
    .catch Ljava/lang/InterruptedException; {:try_start_e .. :try_end_e} :catch_6
    .catch Ljava/lang/Exception; {:try_start_e .. :try_end_e} :catch_5
    .catchall {:try_start_e .. :try_end_e} :catchall_4

    xor-int/lit8 v13, v13, 0x1

    move v14, v13

    move-object v13, v12

    :goto_c
    move-object/from16 v34, v9

    move-object v9, v10

    move/from16 v31, v35

    goto :goto_d

    :catchall_4
    move-exception v0

    move-object/from16 v34, v9

    move-object v9, v10

    move-object v11, v12

    goto/16 :goto_16

    :catch_5
    move-exception v0

    move-object v11, v9

    move-object v9, v10

    move-object v13, v12

    goto/16 :goto_18

    :catch_6
    move-object/from16 v34, v9

    move-object v9, v10

    move-object v11, v12

    goto/16 :goto_1e

    :catchall_5
    move-exception v0

    move-object/from16 v34, v9

    move-object v9, v10

    const/4 v11, 0x0

    goto/16 :goto_16

    :catch_7
    move-exception v0

    move-object v11, v9

    move-object v9, v10

    goto/16 :goto_17

    :catch_8
    move-object/from16 v34, v9

    move-object v9, v10

    const/4 v11, 0x0

    goto/16 :goto_1e

    :catchall_6
    move-exception v0

    move-object/from16 v34, v9

    move-object v9, v10

    goto/16 :goto_1c

    :catch_9
    move-exception v0

    move-object v11, v9

    move-object v9, v10

    goto/16 :goto_18

    :catch_a
    move-object/from16 v34, v9

    move-object v9, v10

    goto :goto_12

    :cond_14
    move-object/from16 v11, p2

    .line 111
    :try_start_f
    invoke-virtual {v9}, Lru/oopssre/imperialschool/viewstv/VideoSurface$Clip;->rewind()V

    invoke-virtual {v13}, Landroid/media/MediaCodec;->flush()V

    .line 112
    :goto_d
    invoke-static {}, Ljava/lang/System;->nanoTime()J

    move-result-wide v15

    invoke-direct {v1, v2, v3}, Lru/oopssre/imperialschool/viewstv/VideoSurface;->changed(J)V

    move-wide/from16 v29, v19

    move-wide/from16 v32, v29

    const/16 v28, 0x0

    goto :goto_f

    :cond_15
    :goto_e
    move-object/from16 v11, p2

    .line 115
    :goto_f
    invoke-static {}, Ljava/lang/System;->nanoTime()J

    move-result-wide v21

    sub-long v21, v21, v15

    const-wide v23, 0x37e11d600L

    cmp-long v10, v21, v23

    if-gtz v10, :cond_16

    move/from16 v10, v35

    const/4 v11, 0x0

    const/4 v12, 0x0

    goto/16 :goto_0

    :cond_16
    new-instance v0, Ljava/io/IOException;

    const-string v4, "\u0414\u0435\u043a\u043e\u0434\u0435\u0440 \u043d\u0435 \u0432\u044b\u0434\u0430\u0451\u0442 \u043a\u0430\u0434\u0440\u044b \u0431\u043e\u043b\u0435\u0435 15 \u0441\u0435\u043a\u0443\u043d\u0434"

    invoke-direct {v0, v4}, Ljava/io/IOException;-><init>(Ljava/lang/String;)V

    throw v0
    :try_end_f
    .catch Ljava/lang/InterruptedException; {:try_start_f .. :try_end_f} :catch_d
    .catch Ljava/lang/Exception; {:try_start_f .. :try_end_f} :catch_b
    .catchall {:try_start_f .. :try_end_f} :catchall_7

    :catch_b
    move-exception v0

    goto :goto_11

    .line 119
    :cond_17
    :goto_10
    invoke-static {v13}, Lru/oopssre/imperialschool/viewstv/VideoSurface;->release(Landroid/media/MediaCodec;)V

    invoke-virtual {v9}, Lru/oopssre/imperialschool/viewstv/VideoSurface$Clip;->close()V

    if-eqz v34, :cond_18

    invoke-virtual/range {v34 .. v34}, Lru/oopssre/imperialschool/viewstv/VideoSurface$Clip;->close()V

    :cond_18
    iget-wide v4, v1, Lru/oopssre/imperialschool/viewstv/VideoSurface;->generation:J

    cmp-long v0, v2, v4

    if-nez v0, :cond_1e

    const/4 v10, 0x0

    iput-boolean v10, v1, Lru/oopssre/imperialschool/viewstv/VideoSurface;->running:Z

    return-void

    :catchall_7
    move-exception v0

    goto/16 :goto_1c

    :catch_c
    move-exception v0

    move/from16 v35, v10

    :goto_11
    move-object/from16 v11, v34

    goto :goto_18

    :catch_d
    :goto_12
    move-object v11, v13

    goto/16 :goto_1e

    :catchall_8
    move-exception v0

    goto :goto_13

    :catch_e
    move-exception v0

    move/from16 v35, v10

    goto :goto_14

    :catchall_9
    move-exception v0

    const-wide/16 v17, 0x1

    :goto_13
    move-object/from16 v9, p1

    move-object v11, v13

    goto :goto_15

    :catch_f
    move-exception v0

    move/from16 v35, v10

    const-wide/16 v17, 0x1

    :goto_14
    move-object/from16 v9, p1

    const/4 v11, 0x0

    goto :goto_18

    :catch_10
    const-wide/16 v17, 0x1

    :catch_11
    move-object/from16 v9, p1

    move-object v11, v13

    goto/16 :goto_1d

    :catchall_a
    move-exception v0

    const-wide/16 v17, 0x1

    move-object/from16 v9, p1

    const/4 v11, 0x0

    :goto_15
    const/16 v34, 0x0

    :goto_16
    const/16 v35, 0x0

    goto/16 :goto_20

    :catch_12
    move-exception v0

    move/from16 v35, v10

    const-wide/16 v17, 0x1

    move-object/from16 v9, p1

    const/4 v11, 0x0

    :goto_17
    const/4 v13, 0x0

    .line 118
    :goto_18
    :try_start_10
    invoke-direct {v1, v2, v3}, Lru/oopssre/imperialschool/viewstv/VideoSurface;->current(J)Z

    move-result v4
    :try_end_10
    .catchall {:try_start_10 .. :try_end_10} :catchall_c

    if-eqz v4, :cond_1a

    :try_start_11
    new-instance v4, Ljava/lang/StringBuilder;

    invoke-direct {v4}, Ljava/lang/StringBuilder;-><init>()V

    const-string v5, "\u041e\u0448\u0438\u0431\u043a\u0430 \u0432\u0438\u0434\u0435\u043e: "

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v4

    invoke-virtual {v0}, Ljava/lang/Exception;->getMessage()Ljava/lang/String;

    move-result-object v5

    if-nez v5, :cond_19

    invoke-virtual {v0}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/Class;->getSimpleName()Ljava/lang/String;

    move-result-object v0

    goto :goto_19

    :cond_19
    invoke-virtual {v0}, Ljava/lang/Exception;->getMessage()Ljava/lang/String;

    move-result-object v0

    :goto_19
    invoke-virtual {v4, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    iput-object v0, v1, Lru/oopssre/imperialschool/viewstv/VideoSurface;->state:Ljava/lang/String;
    :try_end_11
    .catchall {:try_start_11 .. :try_end_11} :catchall_b

    goto :goto_1b

    :catchall_b
    move-exception v0

    move-object/from16 v34, v11

    :goto_1a
    move-object v11, v13

    goto :goto_20

    :cond_1a
    const/16 v35, 0x0

    .line 119
    :goto_1b
    invoke-static {v13}, Lru/oopssre/imperialschool/viewstv/VideoSurface;->release(Landroid/media/MediaCodec;)V

    invoke-virtual {v9}, Lru/oopssre/imperialschool/viewstv/VideoSurface$Clip;->close()V

    if-eqz v11, :cond_1b

    invoke-virtual {v11}, Lru/oopssre/imperialschool/viewstv/VideoSurface$Clip;->close()V

    :cond_1b
    iget-wide v4, v1, Lru/oopssre/imperialschool/viewstv/VideoSurface;->generation:J

    cmp-long v0, v2, v4

    if-nez v0, :cond_1c

    const/4 v10, 0x0

    iput-boolean v10, v1, Lru/oopssre/imperialschool/viewstv/VideoSurface;->running:Z

    if-eqz v35, :cond_1c

    iget-wide v4, v1, Lru/oopssre/imperialschool/viewstv/VideoSurface;->failures:J

    add-long v4, v4, v17

    iput-wide v4, v1, Lru/oopssre/imperialschool/viewstv/VideoSurface;->failures:J

    :cond_1c
    if-eqz v35, :cond_1e

    invoke-direct {v1, v2, v3}, Lru/oopssre/imperialschool/viewstv/VideoSurface;->changed(J)V

    goto :goto_1f

    :catchall_c
    move-exception v0

    move-object/from16 v34, v11

    :goto_1c
    move-object v11, v13

    goto :goto_16

    :catch_13
    const-wide/16 v17, 0x1

    move-object/from16 v9, p1

    const/4 v11, 0x0

    :goto_1d
    const/16 v34, 0x0

    .line 117
    :goto_1e
    :try_start_12
    invoke-static {}, Ljava/lang/Thread;->currentThread()Ljava/lang/Thread;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/Thread;->interrupt()V
    :try_end_12
    .catchall {:try_start_12 .. :try_end_12} :catchall_d

    .line 119
    invoke-static {v11}, Lru/oopssre/imperialschool/viewstv/VideoSurface;->release(Landroid/media/MediaCodec;)V

    invoke-virtual {v9}, Lru/oopssre/imperialschool/viewstv/VideoSurface$Clip;->close()V

    if-eqz v34, :cond_1d

    invoke-virtual/range {v34 .. v34}, Lru/oopssre/imperialschool/viewstv/VideoSurface$Clip;->close()V

    :cond_1d
    iget-wide v4, v1, Lru/oopssre/imperialschool/viewstv/VideoSurface;->generation:J

    cmp-long v0, v2, v4

    if-nez v0, :cond_1e

    const/4 v10, 0x0

    iput-boolean v10, v1, Lru/oopssre/imperialschool/viewstv/VideoSurface;->running:Z

    :cond_1e
    :goto_1f
    return-void

    :catchall_d
    move-exception v0

    goto/16 :goto_16

    :goto_20
    invoke-static {v11}, Lru/oopssre/imperialschool/viewstv/VideoSurface;->release(Landroid/media/MediaCodec;)V

    invoke-virtual {v9}, Lru/oopssre/imperialschool/viewstv/VideoSurface$Clip;->close()V

    if-eqz v34, :cond_1f

    invoke-virtual/range {v34 .. v34}, Lru/oopssre/imperialschool/viewstv/VideoSurface$Clip;->close()V

    :cond_1f
    iget-wide v4, v1, Lru/oopssre/imperialschool/viewstv/VideoSurface;->generation:J

    cmp-long v4, v2, v4

    if-nez v4, :cond_20

    const/4 v10, 0x0

    iput-boolean v10, v1, Lru/oopssre/imperialschool/viewstv/VideoSurface;->running:Z

    if-eqz v35, :cond_20

    iget-wide v4, v1, Lru/oopssre/imperialschool/viewstv/VideoSurface;->failures:J

    add-long v4, v4, v17

    iput-wide v4, v1, Lru/oopssre/imperialschool/viewstv/VideoSurface;->failures:J

    :cond_20
    if-eqz v35, :cond_21

    invoke-direct {v1, v2, v3}, Lru/oopssre/imperialschool/viewstv/VideoSurface;->changed(J)V

    :cond_21
    throw v0
.end method

.method private decoder(Lru/oopssre/imperialschool/viewstv/VideoSurface$Clip;Landroid/view/Surface;)Landroid/media/MediaCodec;
    .locals 17
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/io/IOException;
        }
    .end annotation

    move-object/from16 v1, p0

    move-object/from16 v2, p1

    .line 77
    const-string v3, "max-input-size"

    new-instance v0, Landroid/media/MediaCodecList;

    const/4 v4, 0x0

    invoke-direct {v0, v4}, Landroid/media/MediaCodecList;-><init>(I)V

    invoke-virtual {v0}, Landroid/media/MediaCodecList;->getCodecInfos()[Landroid/media/MediaCodecInfo;

    move-result-object v5

    array-length v6, v5

    const/4 v7, 0x0

    move v8, v4

    move-object v0, v7

    :goto_0
    if-ge v8, v6, :cond_9

    aget-object v9, v5, v8

    .line 78
    invoke-virtual {v9}, Landroid/media/MediaCodecInfo;->isEncoder()Z

    move-result v10

    if-nez v10, :cond_7

    invoke-static {v9}, Lru/oopssre/imperialschool/viewstv/VideoSurface;->hardware(Landroid/media/MediaCodecInfo;)Z

    move-result v10

    if-nez v10, :cond_0

    goto/16 :goto_4

    :cond_0
    invoke-virtual {v9}, Landroid/media/MediaCodecInfo;->getSupportedTypes()[Ljava/lang/String;

    move-result-object v10

    array-length v11, v10

    move v12, v4

    move v13, v12

    :goto_1
    const-string v14, "video/hevc"

    const/16 v16, 0x1

    if-ge v12, v11, :cond_2

    aget-object v15, v10, v12

    invoke-virtual {v15, v14}, Ljava/lang/String;->equalsIgnoreCase(Ljava/lang/String;)Z

    move-result v14

    if-eqz v14, :cond_1

    move/from16 v13, v16

    :cond_1
    add-int/lit8 v12, v12, 0x1

    goto :goto_1

    :cond_2
    if-nez v13, :cond_3

    goto/16 :goto_4

    .line 80
    :cond_3
    :try_start_0
    invoke-virtual {v9, v14}, Landroid/media/MediaCodecInfo;->getCapabilitiesForType(Ljava/lang/String;)Landroid/media/MediaCodecInfo$CodecCapabilities;

    move-result-object v10

    invoke-virtual {v10}, Landroid/media/MediaCodecInfo$CodecCapabilities;->getVideoCapabilities()Landroid/media/MediaCodecInfo$VideoCapabilities;

    move-result-object v10

    if-eqz v10, :cond_7

    iget-object v11, v2, Lru/oopssre/imperialschool/viewstv/VideoSurface$Clip;->info:Lru/oopssre/imperialschool/viewstv/VideoInfo;

    iget v11, v11, Lru/oopssre/imperialschool/viewstv/VideoInfo;->fps:I

    int-to-double v11, v11

    const/16 v13, 0xf00

    const/16 v14, 0x870

    invoke-virtual {v10, v13, v14, v11, v12}, Landroid/media/MediaCodecInfo$VideoCapabilities;->areSizeAndRateSupported(IID)Z

    move-result v10

    if-nez v10, :cond_4

    goto :goto_4

    .line 82
    :cond_4
    iget-object v0, v2, Lru/oopssre/imperialschool/viewstv/VideoSurface$Clip;->format:Landroid/media/MediaFormat;

    invoke-virtual {v0, v3}, Landroid/media/MediaFormat;->containsKey(Ljava/lang/String;)Z

    move-result v0

    if-eqz v0, :cond_5

    iget-object v0, v2, Lru/oopssre/imperialschool/viewstv/VideoSurface$Clip;->format:Landroid/media/MediaFormat;

    invoke-virtual {v0, v3}, Landroid/media/MediaFormat;->getInteger(Ljava/lang/String;)I

    move-result v0

    goto :goto_2

    :cond_5
    iget-object v0, v2, Lru/oopssre/imperialschool/viewstv/VideoSurface$Clip;->info:Lru/oopssre/imperialschool/viewstv/VideoInfo;

    iget-wide v10, v0, Lru/oopssre/imperialschool/viewstv/VideoInfo;->bytes:J

    long-to-int v0, v10

    :goto_2
    const/high16 v10, 0x400000

    invoke-static {v10, v0}, Ljava/lang/Math;->max(II)I

    move-result v0

    iput v0, v1, Lru/oopssre/imperialschool/viewstv/VideoSurface;->inputLimit:I

    .line 83
    iget-object v0, v2, Lru/oopssre/imperialschool/viewstv/VideoSurface$Clip;->format:Landroid/media/MediaFormat;

    iget v10, v1, Lru/oopssre/imperialschool/viewstv/VideoSurface;->inputLimit:I

    invoke-virtual {v0, v3, v10}, Landroid/media/MediaFormat;->setInteger(Ljava/lang/String;I)V

    .line 84
    invoke-virtual {v9}, Landroid/media/MediaCodecInfo;->getName()Ljava/lang/String;

    move-result-object v0

    invoke-static {v0}, Landroid/media/MediaCodec;->createByCodecName(Ljava/lang/String;)Landroid/media/MediaCodec;

    move-result-object v10
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_2

    :try_start_1
    iget-object v0, v2, Lru/oopssre/imperialschool/viewstv/VideoSurface$Clip;->format:Landroid/media/MediaFormat;
    :try_end_1
    .catch Ljava/lang/Exception; {:try_start_1 .. :try_end_1} :catch_1

    move-object/from16 v11, p2

    :try_start_2
    invoke-virtual {v10, v0, v11, v7, v4}, Landroid/media/MediaCodec;->configure(Landroid/media/MediaFormat;Landroid/view/Surface;Landroid/media/MediaCrypto;I)V

    invoke-virtual {v10}, Landroid/media/MediaCodec;->start()V

    invoke-virtual {v9}, Landroid/media/MediaCodecInfo;->getName()Ljava/lang/String;

    move-result-object v0

    iput-object v0, v1, Lru/oopssre/imperialschool/viewstv/VideoSurface;->codecName:Ljava/lang/String;

    sget v0, Landroid/os/Build$VERSION;->SDK_INT:I

    const/16 v9, 0x1d

    if-lt v0, v9, :cond_6

    const-string v0, "\u0410\u043f\u043f\u0430\u0440\u0430\u0442\u043d\u044b\u0439 (\u0434\u0430\u043d\u043d\u044b\u0435 Android)"

    goto :goto_3

    :cond_6
    const-string v0, "\u0412\u0435\u043d\u0434\u043e\u0440\u043d\u044b\u0439 (\u0430\u043f\u043f\u0430\u0440\u0430\u0442\u043d\u044b\u0439 \u0444\u043b\u0430\u0433 API \u043d\u0435\u0434\u043e\u0441\u0442\u0443\u043f\u0435\u043d)"

    :goto_3
    iput-object v0, v1, Lru/oopssre/imperialschool/viewstv/VideoSurface;->decoderKind:Ljava/lang/String;

    iget v0, v1, Lru/oopssre/imperialschool/viewstv/VideoSurface;->decoderStarts:I

    add-int/lit8 v0, v0, 0x1

    iput v0, v1, Lru/oopssre/imperialschool/viewstv/VideoSurface;->decoderStarts:I
    :try_end_2
    .catch Ljava/lang/Exception; {:try_start_2 .. :try_end_2} :catch_0

    return-object v10

    :catch_0
    move-exception v0

    goto :goto_5

    :catch_1
    move-exception v0

    move-object/from16 v11, p2

    goto :goto_5

    :cond_7
    :goto_4
    move-object/from16 v11, p2

    goto :goto_6

    :catch_2
    move-exception v0

    move-object/from16 v11, p2

    move-object v10, v7

    :goto_5
    if-eqz v10, :cond_8

    .line 85
    :try_start_3
    invoke-virtual {v10}, Landroid/media/MediaCodec;->release()V
    :try_end_3
    .catch Ljava/lang/RuntimeException; {:try_start_3 .. :try_end_3} :catch_3

    :catch_3
    :cond_8
    :goto_6
    add-int/lit8 v8, v8, 0x1

    goto/16 :goto_0

    .line 86
    :cond_9
    new-instance v3, Ljava/io/IOException;

    new-instance v4, Ljava/lang/StringBuilder;

    const-string v5, "\u041d\u0435\u0442 \u0430\u043f\u043f\u0430\u0440\u0430\u0442\u043d\u043e\u0433\u043e HEVC-\u0434\u0435\u043a\u043e\u0434\u0435\u0440\u0430 \u0434\u043b\u044f 3840\u00d72160 / "

    invoke-direct {v4, v5}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    iget-object v2, v2, Lru/oopssre/imperialschool/viewstv/VideoSurface$Clip;->info:Lru/oopssre/imperialschool/viewstv/VideoInfo;

    iget v2, v2, Lru/oopssre/imperialschool/viewstv/VideoInfo;->fps:I

    invoke-virtual {v4, v2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v2

    if-nez v0, :cond_a

    const-string v0, ""

    goto :goto_7

    :cond_a
    new-instance v4, Ljava/lang/StringBuilder;

    const-string v5, ": "

    invoke-direct {v4, v5}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v0}, Ljava/lang/Exception;->getMessage()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {v4, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    :goto_7
    invoke-virtual {v2, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-direct {v3, v0}, Ljava/io/IOException;-><init>(Ljava/lang/String;)V

    throw v3
.end method

.method private static hardware(Landroid/media/MediaCodecInfo;)Z
    .locals 2

    .line 64
    sget v0, Landroid/os/Build$VERSION;->SDK_INT:I

    const/16 v1, 0x1d

    if-lt v0, v1, :cond_0

    invoke-virtual {p0}, Landroid/media/MediaCodecInfo;->isHardwareAccelerated()Z

    move-result p0

    return p0

    :cond_0
    invoke-virtual {p0}, Landroid/media/MediaCodecInfo;->getName()Ljava/lang/String;

    move-result-object p0

    sget-object v0, Ljava/util/Locale;->ROOT:Ljava/util/Locale;

    invoke-virtual {p0, v0}, Ljava/lang/String;->toLowerCase(Ljava/util/Locale;)Ljava/lang/String;

    move-result-object p0

    const-string v0, "omx.google."

    invoke-virtual {p0, v0}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z

    move-result v0

    if-nez v0, :cond_1

    const-string v0, "c2.android."

    invoke-virtual {p0, v0}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z

    move-result v0

    if-nez v0, :cond_1

    const-string v0, "omx.ffmpeg."

    invoke-virtual {p0, v0}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z

    move-result p0

    if-nez p0, :cond_1

    const/4 p0, 0x1

    return p0

    :cond_1
    const/4 p0, 0x0

    return p0
.end method

.method static prepare(Lru/oopssre/imperialschool/viewstv/VideoInfo;Ljava/io/File;Lru/oopssre/imperialschool/viewstv/CacheStore;)Lru/oopssre/imperialschool/viewstv/VideoSurface$Clip;
    .locals 11
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/lang/Exception;
        }
    .end annotation

    .line 24
    const-string v0, "durationUs"

    const-string v1, "profile"

    const-string v2, "frame-rate"

    iget-object v3, p0, Lru/oopssre/imperialschool/viewstv/VideoInfo;->sha:Ljava/lang/String;

    invoke-virtual {p2, v3}, Lru/oopssre/imperialschool/viewstv/CacheStore;->pinVideo(Ljava/lang/String;)V

    new-instance v7, Landroid/media/MediaExtractor;

    invoke-direct {v7}, Landroid/media/MediaExtractor;-><init>()V

    .line 26
    :try_start_0
    invoke-virtual {p1}, Ljava/io/File;->getPath()Ljava/lang/String;

    move-result-object v3

    invoke-virtual {v7, v3}, Landroid/media/MediaExtractor;->setDataSource(Ljava/lang/String;)V

    const/4 v3, -0x1

    const/4 v4, 0x0

    const/4 v5, 0x0

    move-object v8, v4

    .line 27
    :goto_0
    invoke-virtual {v7}, Landroid/media/MediaExtractor;->getTrackCount()I

    move-result v4
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_2

    if-ge v5, v4, :cond_4

    .line 28
    :try_start_1
    invoke-virtual {v7, v5}, Landroid/media/MediaExtractor;->getTrackFormat(I)Landroid/media/MediaFormat;

    move-result-object v4

    const-string v6, "mime"

    invoke-virtual {v4, v6}, Landroid/media/MediaFormat;->getString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v6

    if-eqz v6, :cond_1

    .line 29
    const-string v9, "audio/"

    invoke-virtual {v6, v9}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z

    move-result v9

    if-nez v9, :cond_0

    goto :goto_1

    :cond_0
    new-instance p1, Ljava/io/IOException;

    const-string v0, "\u0412 MP4 \u043e\u0431\u043d\u0430\u0440\u0443\u0436\u0435\u043d\u0430 \u0430\u0443\u0434\u0438\u043e\u0434\u043e\u0440\u043e\u0436\u043a\u0430"

    invoke-direct {p1, v0}, Ljava/io/IOException;-><init>(Ljava/lang/String;)V

    throw p1

    :cond_1
    :goto_1
    if-eqz v6, :cond_3

    .line 30
    const-string v9, "video/"

    invoke-virtual {v6, v9}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z

    move-result v9

    if-eqz v9, :cond_3

    if-gez v3, :cond_2

    const-string v3, "video/hevc"

    invoke-virtual {v6, v3}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v3

    if-eqz v3, :cond_2

    move-object v8, v4

    move v3, v5

    goto :goto_2

    :cond_2
    new-instance p1, Ljava/io/IOException;

    const-string v0, "\u041d\u0443\u0436\u043d\u0430 \u043e\u0434\u043d\u0430 HEVC-\u0432\u0438\u0434\u0435\u043e\u0434\u043e\u0440\u043e\u0436\u043a\u0430"

    invoke-direct {p1, v0}, Ljava/io/IOException;-><init>(Ljava/lang/String;)V

    throw p1
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    :cond_3
    :goto_2
    add-int/lit8 v5, v5, 0x1

    goto :goto_0

    :catchall_0
    move-exception v0

    move-object p1, v0

    move-object v5, p0

    move-object v9, p2

    goto/16 :goto_7

    :cond_4
    if-ltz v3, :cond_a

    .line 32
    :try_start_2
    const-string v4, "width"

    invoke-virtual {v8, v4}, Landroid/media/MediaFormat;->getInteger(Ljava/lang/String;)I

    move-result v4

    const/16 v5, 0xf00

    if-ne v4, v5, :cond_a

    const-string v4, "height"

    invoke-virtual {v8, v4}, Landroid/media/MediaFormat;->getInteger(Ljava/lang/String;)I

    move-result v4

    const/16 v5, 0x870

    if-ne v4, v5, :cond_a

    .line 33
    invoke-virtual {v8, v1}, Landroid/media/MediaFormat;->containsKey(Ljava/lang/String;)Z

    move-result v4
    :try_end_2
    .catchall {:try_start_2 .. :try_end_2} :catchall_2

    if-eqz v4, :cond_6

    :try_start_3
    invoke-virtual {v8, v1}, Landroid/media/MediaFormat;->getInteger(Ljava/lang/String;)I

    move-result v1

    const/4 v4, 0x1

    if-ne v1, v4, :cond_5

    goto :goto_3

    :cond_5
    new-instance p1, Ljava/io/IOException;

    const-string v0, "\u041d\u0443\u0436\u0435\u043d 8-\u0431\u0438\u0442\u043d\u044b\u0439 \u043f\u0440\u043e\u0444\u0438\u043b\u044c HEVC Main"

    invoke-direct {p1, v0}, Ljava/io/IOException;-><init>(Ljava/lang/String;)V

    throw p1
    :try_end_3
    .catchall {:try_start_3 .. :try_end_3} :catchall_0

    .line 34
    :cond_6
    :goto_3
    :try_start_4
    invoke-virtual {v8, v0}, Landroid/media/MediaFormat;->containsKey(Ljava/lang/String;)Z

    move-result v1

    if-eqz v1, :cond_9

    invoke-virtual {v8, v0}, Landroid/media/MediaFormat;->getLong(Ljava/lang/String;)J

    move-result-wide v0

    iget-wide v4, p0, Lru/oopssre/imperialschool/viewstv/VideoInfo;->durationMs:J

    const-wide/16 v9, 0x3e8

    mul-long/2addr v4, v9

    sub-long/2addr v0, v4

    invoke-static {v0, v1}, Ljava/lang/Math;->abs(J)J

    move-result-wide v0

    iget v4, p0, Lru/oopssre/imperialschool/viewstv/VideoInfo;->fps:I

    int-to-long v4, v4

    const-wide/32 v9, 0xf4240

    div-long/2addr v9, v4

    const-wide/16 v4, 0x1388

    invoke-static {v4, v5, v9, v10}, Ljava/lang/Math;->max(JJ)J

    move-result-wide v4

    cmp-long v0, v0, v4

    if-gtz v0, :cond_9

    .line 35
    invoke-virtual {v8, v2}, Landroid/media/MediaFormat;->containsKey(Ljava/lang/String;)Z

    move-result v0
    :try_end_4
    .catchall {:try_start_4 .. :try_end_4} :catchall_2

    if-eqz v0, :cond_8

    :try_start_5
    invoke-virtual {v8, v2}, Landroid/media/MediaFormat;->getInteger(Ljava/lang/String;)I

    move-result v0
    :try_end_5
    .catch Ljava/lang/ClassCastException; {:try_start_5 .. :try_end_5} :catch_0
    .catchall {:try_start_5 .. :try_end_5} :catchall_0

    int-to-float v0, v0

    goto :goto_4

    :catch_0
    :try_start_6
    invoke-virtual {v8, v2}, Landroid/media/MediaFormat;->getFloat(Ljava/lang/String;)F

    move-result v0

    :goto_4
    iget v1, p0, Lru/oopssre/imperialschool/viewstv/VideoInfo;->fps:I

    int-to-float v1, v1

    sub-float/2addr v0, v1

    invoke-static {v0}, Ljava/lang/Math;->abs(F)F

    move-result v0

    const v1, 0x3dcccccd    # 0.1f

    cmpl-float v0, v0, v1

    if-gtz v0, :cond_7

    goto :goto_5

    :cond_7
    new-instance p1, Ljava/io/IOException;

    const-string v0, "\u0427\u0430\u0441\u0442\u043e\u0442\u0430 \u043a\u0430\u0434\u0440\u043e\u0432 MP4 \u043d\u0435 \u0441\u043e\u0432\u043f\u0430\u043b\u0430 \u0441 JSON"

    invoke-direct {p1, v0}, Ljava/io/IOException;-><init>(Ljava/lang/String;)V

    throw p1
    :try_end_6
    .catchall {:try_start_6 .. :try_end_6} :catchall_0

    .line 36
    :cond_8
    :goto_5
    :try_start_7
    invoke-virtual {v7, v3}, Landroid/media/MediaExtractor;->selectTrack(I)V

    new-instance v4, Lru/oopssre/imperialschool/viewstv/VideoSurface$Clip;
    :try_end_7
    .catchall {:try_start_7 .. :try_end_7} :catchall_2

    move-object v5, p0

    move-object v6, p1

    move-object v9, p2

    :try_start_8
    invoke-direct/range {v4 .. v9}, Lru/oopssre/imperialschool/viewstv/VideoSurface$Clip;-><init>(Lru/oopssre/imperialschool/viewstv/VideoInfo;Ljava/io/File;Landroid/media/MediaExtractor;Landroid/media/MediaFormat;Lru/oopssre/imperialschool/viewstv/CacheStore;)V

    invoke-virtual {v4}, Lru/oopssre/imperialschool/viewstv/VideoSurface$Clip;->rewind()V

    return-object v4

    :cond_9
    move-object v5, p0

    move-object v9, p2

    .line 34
    new-instance p0, Ljava/io/IOException;

    const-string p1, "\u0414\u043b\u0438\u0442\u0435\u043b\u044c\u043d\u043e\u0441\u0442\u044c MP4 \u043d\u0435 \u0441\u043e\u0432\u043f\u0430\u043b\u0430 \u0441 JSON"

    invoke-direct {p0, p1}, Ljava/io/IOException;-><init>(Ljava/lang/String;)V

    throw p0

    :cond_a
    move-object v5, p0

    move-object v9, p2

    .line 32
    new-instance p0, Ljava/io/IOException;

    const-string p1, "\u0424\u0430\u043a\u0442\u0438\u0447\u0435\u0441\u043a\u0438\u0439 \u0440\u0430\u0437\u043c\u0435\u0440 \u0432\u0438\u0434\u0435\u043e \u043d\u0435 \u0440\u0430\u0432\u0435\u043d 3840\u00d72160"

    invoke-direct {p0, p1}, Ljava/io/IOException;-><init>(Ljava/lang/String;)V

    throw p0
    :try_end_8
    .catchall {:try_start_8 .. :try_end_8} :catchall_1

    :catchall_1
    move-exception v0

    goto :goto_6

    :catchall_2
    move-exception v0

    move-object v5, p0

    move-object v9, p2

    :goto_6
    move-object p1, v0

    .line 37
    :goto_7
    invoke-virtual {v7}, Landroid/media/MediaExtractor;->release()V

    iget-object p0, v5, Lru/oopssre/imperialschool/viewstv/VideoInfo;->sha:Ljava/lang/String;

    invoke-virtual {v9, p0}, Lru/oopssre/imperialschool/viewstv/CacheStore;->unpinVideo(Ljava/lang/String;)V

    throw p1
.end method

.method private static release(Landroid/media/MediaCodec;)V
    .locals 0

    if-eqz p0, :cond_0

    .line 90
    :try_start_0
    invoke-virtual {p0}, Landroid/media/MediaCodec;->stop()V
    :try_end_0
    .catch Ljava/lang/RuntimeException; {:try_start_0 .. :try_end_0} :catch_0

    :catch_0
    :try_start_1
    invoke-virtual {p0}, Landroid/media/MediaCodec;->release()V
    :try_end_1
    .catch Ljava/lang/RuntimeException; {:try_start_1 .. :try_end_1} :catch_1

    :catch_1
    :cond_0
    return-void
.end method

.method static supports(Lru/oopssre/imperialschool/viewstv/VideoInfo;)Z
    .locals 13

    .line 66
    new-instance v0, Landroid/media/MediaCodecList;

    const/4 v1, 0x0

    invoke-direct {v0, v1}, Landroid/media/MediaCodecList;-><init>(I)V

    invoke-virtual {v0}, Landroid/media/MediaCodecList;->getCodecInfos()[Landroid/media/MediaCodecInfo;

    move-result-object v0

    array-length v2, v0

    move v3, v1

    :goto_0
    if-ge v3, v2, :cond_3

    aget-object v4, v0, v3

    .line 67
    invoke-virtual {v4}, Landroid/media/MediaCodecInfo;->isEncoder()Z

    move-result v5

    if-nez v5, :cond_2

    invoke-static {v4}, Lru/oopssre/imperialschool/viewstv/VideoSurface;->hardware(Landroid/media/MediaCodecInfo;)Z

    move-result v5

    if-nez v5, :cond_0

    goto :goto_2

    .line 68
    :cond_0
    invoke-virtual {v4}, Landroid/media/MediaCodecInfo;->getSupportedTypes()[Ljava/lang/String;

    move-result-object v5

    array-length v6, v5

    move v7, v1

    :goto_1
    if-ge v7, v6, :cond_2

    aget-object v8, v5, v7

    const-string v9, "video/hevc"

    invoke-virtual {v8, v9}, Ljava/lang/String;->equalsIgnoreCase(Ljava/lang/String;)Z

    move-result v9

    if-eqz v9, :cond_1

    .line 69
    :try_start_0
    invoke-virtual {v4, v8}, Landroid/media/MediaCodecInfo;->getCapabilitiesForType(Ljava/lang/String;)Landroid/media/MediaCodecInfo$CodecCapabilities;

    move-result-object v8

    invoke-virtual {v8}, Landroid/media/MediaCodecInfo$CodecCapabilities;->getVideoCapabilities()Landroid/media/MediaCodecInfo$VideoCapabilities;

    move-result-object v8

    if-eqz v8, :cond_1

    .line 70
    iget v9, p0, Lru/oopssre/imperialschool/viewstv/VideoInfo;->fps:I

    int-to-double v9, v9

    const/16 v11, 0xf00

    const/16 v12, 0x870

    invoke-virtual {v8, v11, v12, v9, v10}, Landroid/media/MediaCodecInfo$VideoCapabilities;->areSizeAndRateSupported(IID)Z

    move-result v8
    :try_end_0
    .catch Ljava/lang/RuntimeException; {:try_start_0 .. :try_end_0} :catch_0

    if-eqz v8, :cond_1

    const/4 p0, 0x1

    return p0

    :catch_0
    :cond_1
    add-int/lit8 v7, v7, 0x1

    goto :goto_1

    :cond_2
    :goto_2
    add-int/lit8 v3, v3, 0x1

    goto :goto_0

    :cond_3
    return v1
.end method

.method private waitUntil(JJ)V
    .locals 5
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/lang/InterruptedException;
        }
    .end annotation

    .line 91
    :goto_0
    invoke-direct {p0, p3, p4}, Lru/oopssre/imperialschool/viewstv/VideoSurface;->current(J)Z

    move-result v0

    if-eqz v0, :cond_1

    invoke-static {}, Ljava/lang/System;->nanoTime()J

    move-result-wide v0

    sub-long v0, p1, v0

    const-wide/16 v2, 0x0

    cmp-long v2, v0, v2

    if-gtz v2, :cond_0

    return-void

    :cond_0
    sget-object v2, Ljava/util/concurrent/TimeUnit;->NANOSECONDS:Ljava/util/concurrent/TimeUnit;

    const-wide/32 v3, 0x1312d00

    invoke-static {v0, v1, v3, v4}, Ljava/lang/Math;->min(JJ)J

    move-result-wide v0

    invoke-virtual {v2, v0, v1}, Ljava/util/concurrent/TimeUnit;->sleep(J)V

    goto :goto_0

    :cond_1
    new-instance p1, Ljava/lang/InterruptedException;

    invoke-direct {p1}, Ljava/lang/InterruptedException;-><init>()V

    throw p1
.end method


# virtual methods
.method destroy()V
    .locals 2

    const/4 v0, 0x1

    .line 54
    iput-boolean v0, p0, Lru/oopssre/imperialschool/viewstv/VideoSurface;->disposed:Z

    invoke-virtual {p0}, Lru/oopssre/imperialschool/viewstv/VideoSurface;->stop()V

    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/VideoSurface;->worker:Ljava/util/concurrent/ExecutorService;

    invoke-interface {v0}, Ljava/util/concurrent/ExecutorService;->shutdownNow()Ljava/util/List;

    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/VideoSurface;->main:Landroid/os/Handler;

    const/4 v1, 0x0

    invoke-virtual {v0, v1}, Landroid/os/Handler;->removeCallbacksAndMessages(Ljava/lang/Object;)V

    return-void
.end method

.method diagnostics()Ljava/lang/String;
    .locals 5

    .line 121
    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/VideoSurface;->displayed:Lru/oopssre/imperialschool/viewstv/VideoInfo;

    new-instance v1, Ljava/lang/StringBuilder;

    const-string v2, "\u0418\u0441\u0442\u043e\u0447\u043d\u0438\u043a: \u0441\u0435\u0440\u0432\u0435\u0440\u043d\u044b\u0439 MP4 \u0432 \u043a\u0435\u0448\u0435\n"

    invoke-direct {v1, v2}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    if-nez v0, :cond_0

    const-string v0, "\u0413\u043e\u0442\u043e\u0432\u044b\u0439 \u0440\u043e\u043b\u0438\u043a \u0435\u0449\u0451 \u043d\u0435 \u043f\u043e\u043a\u0430\u0437\u0430\u043d"

    goto :goto_0

    :cond_0
    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    iget-object v3, v0, Lru/oopssre/imperialschool/viewstv/VideoInfo;->frame:Lru/oopssre/imperialschool/viewstv/Protocol$Frame;

    iget-object v3, v3, Lru/oopssre/imperialschool/viewstv/Protocol$Frame;->title:Ljava/lang/String;

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    const-string v3, "\n\u041f\u0440\u043e\u0444\u0438\u043b\u044c: "

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    iget-object v3, v0, Lru/oopssre/imperialschool/viewstv/VideoInfo;->frame:Lru/oopssre/imperialschool/viewstv/Protocol$Frame;

    iget-object v3, v3, Lru/oopssre/imperialschool/viewstv/Protocol$Frame;->device:Ljava/lang/String;

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    const-string v3, "\n\u0424\u0430\u0439\u043b: 3840 \u00d7 2160 \u00b7 HEVC \u00b7 "

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    iget v3, v0, Lru/oopssre/imperialschool/viewstv/VideoInfo;->fps:I

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v2

    const-string v3, " \u043a\u0430\u0434\u0440\u0430/\u0441\n\u0420\u0430\u0437\u043c\u0435\u0440: "

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    iget-wide v3, v0, Lru/oopssre/imperialschool/viewstv/VideoInfo;->bytes:J

    invoke-virtual {v2, v3, v4}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    move-result-object v0

    const-string v2, " \u0431\u0430\u0439\u0442"

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    :goto_0
    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    const-string v1, "\n\u0421\u043e\u0441\u0442\u043e\u044f\u043d\u0438\u0435: "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    iget-object v1, p0, Lru/oopssre/imperialschool/viewstv/VideoSurface;->state:Ljava/lang/String;

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    const-string v1, "\n\u0414\u0435\u043a\u043e\u0434\u0435\u0440: "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    iget-object v1, p0, Lru/oopssre/imperialschool/viewstv/VideoSurface;->codecName:Ljava/lang/String;

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    const-string v1, "\n\u0422\u0438\u043f: "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    iget-object v1, p0, Lru/oopssre/imperialschool/viewstv/VideoSurface;->decoderKind:Ljava/lang/String;

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    const-string v1, "\n\u0420\u0430\u0437\u043c\u0435\u0440 \u0434\u0435\u043a\u043e\u0434\u0435\u0440\u0430: "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    iget v1, p0, Lru/oopssre/imperialschool/viewstv/VideoSurface;->decodedWidth:I

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v0

    const-string v1, " \u00d7 "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    iget v2, p0, Lru/oopssre/imperialschool/viewstv/VideoSurface;->decodedHeight:I

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v0

    const-string v2, "\nSurface \u0444\u0430\u043a\u0442\u0438\u0447\u0435\u0441\u043a\u0438: "

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    iget v2, p0, Lru/oopssre/imperialschool/viewstv/VideoSurface;->actualWidth:I

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    iget v1, p0, Lru/oopssre/imperialschool/viewstv/VideoSurface;->actualHeight:I

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v0

    const-string v1, "\n\u041f\u043e\u043a\u0430\u0437\u0430\u043d\u043e \u043a\u0430\u0434\u0440\u043e\u0432: "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    iget-wide v1, p0, Lru/oopssre/imperialschool/viewstv/VideoSurface;->renderedFrames:J

    invoke-virtual {v0, v1, v2}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    move-result-object v0

    const-string v1, "\n\u041f\u043e\u0432\u0442\u043e\u0440\u043e\u0432: "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    iget-wide v1, p0, Lru/oopssre/imperialschool/viewstv/VideoSurface;->loops:J

    invoke-virtual {v0, v1, v2}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    move-result-object v0

    const-string v1, "\n\u0421\u043c\u0435\u043d \u0440\u043e\u043b\u0438\u043a\u0430: "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    iget-wide v1, p0, Lru/oopssre/imperialschool/viewstv/VideoSurface;->switches:J

    invoke-virtual {v0, v1, v2}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    move-result-object v0

    const-string v1, "\n\u0417\u0430\u043f\u0443\u0441\u043a\u043e\u0432 \u0434\u0435\u043a\u043e\u0434\u0435\u0440\u0430: "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    iget v1, p0, Lru/oopssre/imperialschool/viewstv/VideoSurface;->decoderStarts:I

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v0

    const-string v1, "\n\u041c\u0443\u0437\u044b\u043a\u0430: \u043e\u0442\u0434\u0435\u043b\u044c\u043d\u044b\u0439 \u043f\u0440\u043e\u0438\u0433\u0440\u044b\u0432\u0430\u0442\u0435\u043b\u044c"

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    return-object v0
.end method

.method synthetic lambda$begin$1$ru-oopssre-imperialschool-viewstv-VideoSurface(Ljava/util/concurrent/atomic/AtomicReference;Landroid/view/Surface;J)V
    .locals 1

    .line 0
    const/4 v0, 0x0

    .line 60
    invoke-virtual {p1, v0}, Ljava/util/concurrent/atomic/AtomicReference;->getAndSet(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object p1

    check-cast p1, Lru/oopssre/imperialschool/viewstv/VideoSurface$Clip;

    if-eqz p1, :cond_0

    invoke-direct {p0, p1, p2, p3, p4}, Lru/oopssre/imperialschool/viewstv/VideoSurface;->decode(Lru/oopssre/imperialschool/viewstv/VideoSurface$Clip;Landroid/view/Surface;J)V

    :cond_0
    return-void
.end method

.method synthetic lambda$changed$0$ru-oopssre-imperialschool-viewstv-VideoSurface(J)V
    .locals 0

    .line 56
    invoke-direct {p0, p1, p2}, Lru/oopssre/imperialschool/viewstv/VideoSurface;->current(J)Z

    move-result p1

    if-eqz p1, :cond_0

    iget-object p1, p0, Lru/oopssre/imperialschool/viewstv/VideoSurface;->listener:Lru/oopssre/imperialschool/viewstv/VideoSurface$Listener;

    invoke-interface {p1}, Lru/oopssre/imperialschool/viewstv/VideoSurface$Listener;->changed()V

    :cond_0
    return-void
.end method

.method synthetic lambda$decode$2$ru-oopssre-imperialschool-viewstv-VideoSurface(JLru/oopssre/imperialschool/viewstv/VideoInfo;)V
    .locals 2

    .line 104
    invoke-direct {p0, p1, p2}, Lru/oopssre/imperialschool/viewstv/VideoSurface;->current(J)Z

    move-result p1

    if-eqz p1, :cond_1

    iget-object p1, p0, Lru/oopssre/imperialschool/viewstv/VideoSurface;->displayed:Lru/oopssre/imperialschool/viewstv/VideoInfo;

    if-eqz p1, :cond_0

    iget-object p1, p0, Lru/oopssre/imperialschool/viewstv/VideoSurface;->displayed:Lru/oopssre/imperialschool/viewstv/VideoInfo;

    invoke-virtual {p3, p1}, Lru/oopssre/imperialschool/viewstv/VideoInfo;->sameMedia(Lru/oopssre/imperialschool/viewstv/VideoInfo;)Z

    move-result p1

    if-nez p1, :cond_0

    iget-wide p1, p0, Lru/oopssre/imperialschool/viewstv/VideoSurface;->switches:J

    const-wide/16 v0, 0x1

    add-long/2addr p1, v0

    iput-wide p1, p0, Lru/oopssre/imperialschool/viewstv/VideoSurface;->switches:J

    :cond_0
    iput-object p3, p0, Lru/oopssre/imperialschool/viewstv/VideoSurface;->displayed:Lru/oopssre/imperialschool/viewstv/VideoInfo;

    const/4 p1, 0x1

    iput-boolean p1, p0, Lru/oopssre/imperialschool/viewstv/VideoSurface;->playing:Z

    new-instance p1, Ljava/lang/StringBuilder;

    const-string p2, "\u0412\u0438\u0434\u0435\u043e \u00b7 "

    invoke-direct {p1, p2}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    iget-object p2, p3, Lru/oopssre/imperialschool/viewstv/VideoInfo;->frame:Lru/oopssre/imperialschool/viewstv/Protocol$Frame;

    iget-object p2, p2, Lru/oopssre/imperialschool/viewstv/Protocol$Frame;->title:Ljava/lang/String;

    invoke-virtual {p1, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p1

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    iput-object p1, p0, Lru/oopssre/imperialschool/viewstv/VideoSurface;->state:Ljava/lang/String;

    iget-object p1, p0, Lru/oopssre/imperialschool/viewstv/VideoSurface;->listener:Lru/oopssre/imperialschool/viewstv/VideoSurface$Listener;

    invoke-interface {p1}, Lru/oopssre/imperialschool/viewstv/VideoSurface$Listener;->changed()V

    :cond_1
    return-void
.end method

.method synthetic lambda$decode$3$ru-oopssre-imperialschool-viewstv-VideoSurface(JLru/oopssre/imperialschool/viewstv/VideoInfo;)V
    .locals 0

    .line 107
    invoke-direct {p0, p1, p2}, Lru/oopssre/imperialschool/viewstv/VideoSurface;->current(J)Z

    move-result p1

    if-eqz p1, :cond_0

    invoke-virtual {p0, p3}, Lru/oopssre/imperialschool/viewstv/VideoSurface;->updateInfo(Lru/oopssre/imperialschool/viewstv/VideoInfo;)V

    :cond_0
    return-void
.end method

.method offer(Lru/oopssre/imperialschool/viewstv/VideoSurface$Clip;)V
    .locals 1

    .line 50
    iget-boolean v0, p0, Lru/oopssre/imperialschool/viewstv/VideoSurface;->disposed:Z

    if-nez v0, :cond_2

    iget-boolean v0, p0, Lru/oopssre/imperialschool/viewstv/VideoSurface;->wanted:Z

    if-nez v0, :cond_0

    goto :goto_0

    :cond_0
    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/VideoSurface;->pending:Ljava/util/concurrent/atomic/AtomicReference;

    invoke-virtual {v0, p1}, Ljava/util/concurrent/atomic/AtomicReference;->getAndSet(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object p1

    check-cast p1, Lru/oopssre/imperialschool/viewstv/VideoSurface$Clip;

    if-eqz p1, :cond_1

    invoke-virtual {p1}, Lru/oopssre/imperialschool/viewstv/VideoSurface$Clip;->close()V

    :cond_1
    invoke-direct {p0}, Lru/oopssre/imperialschool/viewstv/VideoSurface;->begin()V

    return-void

    :cond_2
    :goto_0
    invoke-virtual {p1}, Lru/oopssre/imperialschool/viewstv/VideoSurface$Clip;->close()V

    return-void
.end method

.method reset()V
    .locals 1

    .line 53
    invoke-virtual {p0}, Lru/oopssre/imperialschool/viewstv/VideoSurface;->stop()V

    const/4 v0, 0x0

    iput-object v0, p0, Lru/oopssre/imperialschool/viewstv/VideoSurface;->displayed:Lru/oopssre/imperialschool/viewstv/VideoInfo;

    const/4 v0, 0x0

    iput v0, p0, Lru/oopssre/imperialschool/viewstv/VideoSurface;->decodedHeight:I

    iput v0, p0, Lru/oopssre/imperialschool/viewstv/VideoSurface;->decodedWidth:I

    const-string v0, "\u041e\u0436\u0438\u0434\u0430\u043d\u0438\u0435 \u043e\u043f\u0443\u0431\u043b\u0438\u043a\u043e\u0432\u0430\u043d\u043d\u043e\u0433\u043e \u0432\u0438\u0434\u0435\u043e\u2026"

    iput-object v0, p0, Lru/oopssre/imperialschool/viewstv/VideoSurface;->state:Ljava/lang/String;

    return-void
.end method

.method start()V
    .locals 1

    .line 48
    iget-boolean v0, p0, Lru/oopssre/imperialschool/viewstv/VideoSurface;->disposed:Z

    if-eqz v0, :cond_0

    return-void

    :cond_0
    const/4 v0, 0x1

    iput-boolean v0, p0, Lru/oopssre/imperialschool/viewstv/VideoSurface;->wanted:Z

    invoke-direct {p0}, Lru/oopssre/imperialschool/viewstv/VideoSurface;->begin()V

    return-void
.end method

.method stop()V
    .locals 5

    const/4 v0, 0x0

    .line 52
    iput-boolean v0, p0, Lru/oopssre/imperialschool/viewstv/VideoSurface;->wanted:Z

    iget-wide v1, p0, Lru/oopssre/imperialschool/viewstv/VideoSurface;->generation:J

    const-wide/16 v3, 0x1

    add-long/2addr v1, v3

    iput-wide v1, p0, Lru/oopssre/imperialschool/viewstv/VideoSurface;->generation:J

    iput-boolean v0, p0, Lru/oopssre/imperialschool/viewstv/VideoSurface;->playing:Z

    iput-boolean v0, p0, Lru/oopssre/imperialschool/viewstv/VideoSurface;->running:Z

    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/VideoSurface;->job:Ljava/util/concurrent/Future;

    if-eqz v0, :cond_0

    const/4 v1, 0x1

    invoke-interface {v0, v1}, Ljava/util/concurrent/Future;->cancel(Z)Z

    :cond_0
    const/4 v0, 0x0

    iput-object v0, p0, Lru/oopssre/imperialschool/viewstv/VideoSurface;->job:Ljava/util/concurrent/Future;

    iget-object v1, p0, Lru/oopssre/imperialschool/viewstv/VideoSurface;->launch:Ljava/util/concurrent/atomic/AtomicReference;

    invoke-virtual {v1, v0}, Ljava/util/concurrent/atomic/AtomicReference;->getAndSet(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Lru/oopssre/imperialschool/viewstv/VideoSurface$Clip;

    if-eqz v1, :cond_1

    invoke-virtual {v1}, Lru/oopssre/imperialschool/viewstv/VideoSurface$Clip;->close()V

    :cond_1
    iget-object v1, p0, Lru/oopssre/imperialschool/viewstv/VideoSurface;->pending:Ljava/util/concurrent/atomic/AtomicReference;

    invoke-virtual {v1, v0}, Ljava/util/concurrent/atomic/AtomicReference;->getAndSet(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Lru/oopssre/imperialschool/viewstv/VideoSurface$Clip;

    if-eqz v0, :cond_2

    invoke-virtual {v0}, Lru/oopssre/imperialschool/viewstv/VideoSurface$Clip;->close()V

    :cond_2
    return-void
.end method

.method public surfaceChanged(Landroid/view/SurfaceHolder;III)V
    .locals 0

    .line 62
    iput p3, p0, Lru/oopssre/imperialschool/viewstv/VideoSurface;->actualWidth:I

    iput p4, p0, Lru/oopssre/imperialschool/viewstv/VideoSurface;->actualHeight:I

    iget-object p1, p0, Lru/oopssre/imperialschool/viewstv/VideoSurface;->listener:Lru/oopssre/imperialschool/viewstv/VideoSurface$Listener;

    invoke-interface {p1}, Lru/oopssre/imperialschool/viewstv/VideoSurface$Listener;->changed()V

    invoke-direct {p0}, Lru/oopssre/imperialschool/viewstv/VideoSurface;->begin()V

    return-void
.end method

.method public surfaceCreated(Landroid/view/SurfaceHolder;)V
    .locals 0

    .line 61
    invoke-direct {p0}, Lru/oopssre/imperialschool/viewstv/VideoSurface;->begin()V

    iget-object p1, p0, Lru/oopssre/imperialschool/viewstv/VideoSurface;->listener:Lru/oopssre/imperialschool/viewstv/VideoSurface$Listener;

    invoke-interface {p1}, Lru/oopssre/imperialschool/viewstv/VideoSurface$Listener;->changed()V

    return-void
.end method

.method public surfaceDestroyed(Landroid/view/SurfaceHolder;)V
    .locals 4

    const/4 p1, 0x0

    .line 63
    iput p1, p0, Lru/oopssre/imperialschool/viewstv/VideoSurface;->actualHeight:I

    iput p1, p0, Lru/oopssre/imperialschool/viewstv/VideoSurface;->actualWidth:I

    iget-wide v0, p0, Lru/oopssre/imperialschool/viewstv/VideoSurface;->generation:J

    const-wide/16 v2, 0x1

    add-long/2addr v0, v2

    iput-wide v0, p0, Lru/oopssre/imperialschool/viewstv/VideoSurface;->generation:J

    iput-boolean p1, p0, Lru/oopssre/imperialschool/viewstv/VideoSurface;->playing:Z

    iput-boolean p1, p0, Lru/oopssre/imperialschool/viewstv/VideoSurface;->running:Z

    iget-object p1, p0, Lru/oopssre/imperialschool/viewstv/VideoSurface;->job:Ljava/util/concurrent/Future;

    if-eqz p1, :cond_0

    const/4 v0, 0x1

    invoke-interface {p1, v0}, Ljava/util/concurrent/Future;->cancel(Z)Z

    :cond_0
    const/4 p1, 0x0

    iput-object p1, p0, Lru/oopssre/imperialschool/viewstv/VideoSurface;->job:Ljava/util/concurrent/Future;

    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/VideoSurface;->launch:Ljava/util/concurrent/atomic/AtomicReference;

    invoke-virtual {v0, p1}, Ljava/util/concurrent/atomic/AtomicReference;->getAndSet(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object p1

    check-cast p1, Lru/oopssre/imperialschool/viewstv/VideoSurface$Clip;

    if-eqz p1, :cond_1

    invoke-virtual {p1}, Lru/oopssre/imperialschool/viewstv/VideoSurface$Clip;->close()V

    :cond_1
    return-void
.end method

.method updateInfo(Lru/oopssre/imperialschool/viewstv/VideoInfo;)V
    .locals 1

    .line 51
    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/VideoSurface;->displayed:Lru/oopssre/imperialschool/viewstv/VideoInfo;

    if-eqz v0, :cond_0

    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/VideoSurface;->displayed:Lru/oopssre/imperialschool/viewstv/VideoInfo;

    invoke-virtual {p1, v0}, Lru/oopssre/imperialschool/viewstv/VideoInfo;->sameMedia(Lru/oopssre/imperialschool/viewstv/VideoInfo;)Z

    move-result v0

    if-eqz v0, :cond_0

    iput-object p1, p0, Lru/oopssre/imperialschool/viewstv/VideoSurface;->displayed:Lru/oopssre/imperialschool/viewstv/VideoInfo;

    iget-object p1, p0, Lru/oopssre/imperialschool/viewstv/VideoSurface;->listener:Lru/oopssre/imperialschool/viewstv/VideoSurface$Listener;

    invoke-interface {p1}, Lru/oopssre/imperialschool/viewstv/VideoSurface$Listener;->changed()V

    :cond_0
    return-void
.end method

.method wanted()Z
    .locals 1

    .line 49
    iget-boolean v0, p0, Lru/oopssre/imperialschool/viewstv/VideoSurface;->wanted:Z

    return v0
.end method
