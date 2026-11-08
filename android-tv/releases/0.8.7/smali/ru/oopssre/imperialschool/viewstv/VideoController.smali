.class final Lru/oopssre/imperialschool/viewstv/VideoController;
.super Ljava/lang/Object;
.source "VideoController.java"


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lru/oopssre/imperialschool/viewstv/VideoController$Listener;
    }
.end annotation


# instance fields
.field private volatile active:Z

.field private failures:I

.field volatile frame:Lru/oopssre/imperialschool/viewstv/VideoInfo;

.field private volatile generation:J

.field private job:Ljava/util/concurrent/Future;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/concurrent/Future<",
            "*>;"
        }
    .end annotation
.end field

.field final listener:Lru/oopssre/imperialschool/viewstv/VideoController$Listener;

.field final loader:Lru/oopssre/imperialschool/viewstv/VideoLoader;

.field volatile loading:Z

.field final main:Landroid/os/Handler;

.field volatile nextCheckAt:J

.field private observedFailures:J

.field final poll:Ljava/lang/Runnable;

.field private final prepared:Ljava/util/Set;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/Set<",
            "Lru/oopssre/imperialschool/viewstv/VideoSurface$Clip;",
            ">;"
        }
    .end annotation
.end field

.field final repo:Lru/oopssre/imperialschool/viewstv/Repository;

.field final retry:Ljava/lang/Runnable;

.field volatile status:Ljava/lang/String;

.field private stored:Ljava/lang/String;

.field final video:Lru/oopssre/imperialschool/viewstv/VideoSurface;

.field final worker:Ljava/util/concurrent/ExecutorService;


# direct methods
.method constructor <init>(Lru/oopssre/imperialschool/viewstv/Repository;Lru/oopssre/imperialschool/viewstv/VideoSurface;Lru/oopssre/imperialschool/viewstv/VideoController$Listener;)V
    .locals 2

    .line 19
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 12
    new-instance v0, Landroid/os/Handler;

    invoke-static {}, Landroid/os/Looper;->getMainLooper()Landroid/os/Looper;

    move-result-object v1

    invoke-direct {v0, v1}, Landroid/os/Handler;-><init>(Landroid/os/Looper;)V

    iput-object v0, p0, Lru/oopssre/imperialschool/viewstv/VideoController;->main:Landroid/os/Handler;

    invoke-static {}, Ljava/util/concurrent/Executors;->newSingleThreadExecutor()Ljava/util/concurrent/ExecutorService;

    move-result-object v0

    iput-object v0, p0, Lru/oopssre/imperialschool/viewstv/VideoController;->worker:Ljava/util/concurrent/ExecutorService;

    .line 13
    const-string v0, ""

    iput-object v0, p0, Lru/oopssre/imperialschool/viewstv/VideoController;->stored:Ljava/lang/String;

    .line 15
    new-instance v0, Ljava/util/HashSet;

    invoke-direct {v0}, Ljava/util/HashSet;-><init>()V

    iput-object v0, p0, Lru/oopssre/imperialschool/viewstv/VideoController;->prepared:Ljava/util/Set;

    .line 16
    const-string v0, "\u041e\u0436\u0438\u0434\u0430\u043d\u0438\u0435 \u043e\u043f\u0443\u0431\u043b\u0438\u043a\u043e\u0432\u0430\u043d\u043d\u043e\u0433\u043e \u0432\u0438\u0434\u0435\u043e\u2026"

    iput-object v0, p0, Lru/oopssre/imperialschool/viewstv/VideoController;->status:Ljava/lang/String;

    .line 17
    new-instance v0, Lru/oopssre/imperialschool/viewstv/VideoController$$ExternalSyntheticLambda3;

    invoke-direct {v0, p0}, Lru/oopssre/imperialschool/viewstv/VideoController$$ExternalSyntheticLambda3;-><init>(Lru/oopssre/imperialschool/viewstv/VideoController;)V

    iput-object v0, p0, Lru/oopssre/imperialschool/viewstv/VideoController;->poll:Ljava/lang/Runnable;

    .line 18
    new-instance v0, Lru/oopssre/imperialschool/viewstv/VideoController$$ExternalSyntheticLambda4;

    invoke-direct {v0, p0}, Lru/oopssre/imperialschool/viewstv/VideoController$$ExternalSyntheticLambda4;-><init>(Lru/oopssre/imperialschool/viewstv/VideoController;)V

    iput-object v0, p0, Lru/oopssre/imperialschool/viewstv/VideoController;->retry:Ljava/lang/Runnable;

    .line 19
    iput-object p1, p0, Lru/oopssre/imperialschool/viewstv/VideoController;->repo:Lru/oopssre/imperialschool/viewstv/Repository;

    iput-object p2, p0, Lru/oopssre/imperialschool/viewstv/VideoController;->video:Lru/oopssre/imperialschool/viewstv/VideoSurface;

    iput-object p3, p0, Lru/oopssre/imperialschool/viewstv/VideoController;->listener:Lru/oopssre/imperialschool/viewstv/VideoController$Listener;

    new-instance p2, Lru/oopssre/imperialschool/viewstv/VideoLoader;

    iget-object p3, p1, Lru/oopssre/imperialschool/viewstv/Repository;->net:Lru/oopssre/imperialschool/viewstv/HttpTransport;

    iget-object p1, p1, Lru/oopssre/imperialschool/viewstv/Repository;->cache:Lru/oopssre/imperialschool/viewstv/CacheStore;

    invoke-direct {p2, p3, p1}, Lru/oopssre/imperialschool/viewstv/VideoLoader;-><init>(Lru/oopssre/imperialschool/viewstv/HttpTransport;Lru/oopssre/imperialschool/viewstv/CacheStore;)V

    iput-object p2, p0, Lru/oopssre/imperialschool/viewstv/VideoController;->loader:Lru/oopssre/imperialschool/viewstv/VideoLoader;

    return-void
.end method

.method private current(J)Z
    .locals 2

    .line 24
    iget-boolean v0, p0, Lru/oopssre/imperialschool/viewstv/VideoController;->active:Z

    if-eqz v0, :cond_0

    iget-wide v0, p0, Lru/oopssre/imperialschool/viewstv/VideoController;->generation:J

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

.method private offer(Lru/oopssre/imperialschool/viewstv/VideoInfo;Ljava/io/File;J)V
    .locals 1
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/lang/Exception;
        }
    .end annotation

    .line 26
    invoke-direct {p0, p3, p4}, Lru/oopssre/imperialschool/viewstv/VideoController;->current(J)Z

    move-result v0

    if-nez v0, :cond_0

    return-void

    .line 27
    :cond_0
    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/VideoController;->video:Lru/oopssre/imperialschool/viewstv/VideoSurface;

    iget-object v0, v0, Lru/oopssre/imperialschool/viewstv/VideoSurface;->displayed:Lru/oopssre/imperialschool/viewstv/VideoInfo;

    invoke-virtual {p1, v0}, Lru/oopssre/imperialschool/viewstv/VideoInfo;->sameMedia(Lru/oopssre/imperialschool/viewstv/VideoInfo;)Z

    move-result v0

    if-eqz v0, :cond_1

    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/VideoController;->video:Lru/oopssre/imperialschool/viewstv/VideoSurface;

    iget-boolean v0, v0, Lru/oopssre/imperialschool/viewstv/VideoSurface;->running:Z

    if-eqz v0, :cond_1

    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/VideoController;->repo:Lru/oopssre/imperialschool/viewstv/Repository;

    iget-object v0, v0, Lru/oopssre/imperialschool/viewstv/Repository;->cache:Lru/oopssre/imperialschool/viewstv/CacheStore;

    invoke-virtual {v0, p1}, Lru/oopssre/imperialschool/viewstv/CacheStore;->valid(Lru/oopssre/imperialschool/viewstv/VideoInfo;)Z

    move-result v0

    if-eqz v0, :cond_1

    .line 28
    iget-object p2, p0, Lru/oopssre/imperialschool/viewstv/VideoController;->main:Landroid/os/Handler;

    new-instance v0, Lru/oopssre/imperialschool/viewstv/VideoController$$ExternalSyntheticLambda5;

    invoke-direct {v0, p0, p3, p4, p1}, Lru/oopssre/imperialschool/viewstv/VideoController$$ExternalSyntheticLambda5;-><init>(Lru/oopssre/imperialschool/viewstv/VideoController;JLru/oopssre/imperialschool/viewstv/VideoInfo;)V

    invoke-virtual {p2, v0}, Landroid/os/Handler;->post(Ljava/lang/Runnable;)Z

    return-void

    .line 30
    :cond_1
    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/VideoController;->repo:Lru/oopssre/imperialschool/viewstv/Repository;

    iget-object v0, v0, Lru/oopssre/imperialschool/viewstv/Repository;->cache:Lru/oopssre/imperialschool/viewstv/CacheStore;

    invoke-static {p1, p2, v0}, Lru/oopssre/imperialschool/viewstv/VideoSurface;->prepare(Lru/oopssre/imperialschool/viewstv/VideoInfo;Ljava/io/File;Lru/oopssre/imperialschool/viewstv/CacheStore;)Lru/oopssre/imperialschool/viewstv/VideoSurface$Clip;

    move-result-object p1

    .line 31
    iget-object p2, p0, Lru/oopssre/imperialschool/viewstv/VideoController;->prepared:Ljava/util/Set;

    monitor-enter p2

    :try_start_0
    invoke-direct {p0, p3, p4}, Lru/oopssre/imperialschool/viewstv/VideoController;->current(J)Z

    move-result v0

    if-nez v0, :cond_2

    invoke-virtual {p1}, Lru/oopssre/imperialschool/viewstv/VideoSurface$Clip;->close()V

    monitor-exit p2

    return-void

    :cond_2
    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/VideoController;->prepared:Ljava/util/Set;

    invoke-interface {v0, p1}, Ljava/util/Set;->add(Ljava/lang/Object;)Z

    monitor-exit p2
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 32
    iget-object p2, p0, Lru/oopssre/imperialschool/viewstv/VideoController;->main:Landroid/os/Handler;

    new-instance v0, Lru/oopssre/imperialschool/viewstv/VideoController$$ExternalSyntheticLambda6;

    invoke-direct {v0, p0, p1, p3, p4}, Lru/oopssre/imperialschool/viewstv/VideoController$$ExternalSyntheticLambda6;-><init>(Lru/oopssre/imperialschool/viewstv/VideoController;Lru/oopssre/imperialschool/viewstv/VideoSurface$Clip;J)V

    invoke-virtual {p2, v0}, Landroid/os/Handler;->post(Ljava/lang/Runnable;)Z

    return-void

    :catchall_0
    move-exception p1

    .line 31
    :try_start_1
    monitor-exit p2
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    throw p1
.end method


# virtual methods
.method destroy()V
    .locals 2

    .line 23
    invoke-virtual {p0}, Lru/oopssre/imperialschool/viewstv/VideoController;->stop()V

    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/VideoController;->worker:Ljava/util/concurrent/ExecutorService;

    invoke-interface {v0}, Ljava/util/concurrent/ExecutorService;->shutdownNow()Ljava/util/List;

    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/VideoController;->main:Landroid/os/Handler;

    const/4 v1, 0x0

    invoke-virtual {v0, v1}, Landroid/os/Handler;->removeCallbacksAndMessages(Ljava/lang/Object;)V

    return-void
.end method

.method synthetic lambda$new$0$ru-oopssre-imperialschool-viewstv-VideoController()V
    .locals 1

    .line 0
    const/4 v0, 0x0

    .line 17
    invoke-virtual {p0, v0}, Lru/oopssre/imperialschool/viewstv/VideoController;->refresh(Z)V

    return-void
.end method

.method synthetic lambda$new$1$ru-oopssre-imperialschool-viewstv-VideoController()V
    .locals 1

    .line 0
    const/4 v0, 0x1

    .line 18
    invoke-virtual {p0, v0}, Lru/oopssre/imperialschool/viewstv/VideoController;->refresh(Z)V

    return-void
.end method

.method synthetic lambda$offer$2$ru-oopssre-imperialschool-viewstv-VideoController(JLru/oopssre/imperialschool/viewstv/VideoInfo;)V
    .locals 0

    .line 28
    invoke-direct {p0, p1, p2}, Lru/oopssre/imperialschool/viewstv/VideoController;->current(J)Z

    move-result p1

    if-eqz p1, :cond_0

    iget-object p1, p0, Lru/oopssre/imperialschool/viewstv/VideoController;->video:Lru/oopssre/imperialschool/viewstv/VideoSurface;

    invoke-virtual {p1, p3}, Lru/oopssre/imperialschool/viewstv/VideoSurface;->updateInfo(Lru/oopssre/imperialschool/viewstv/VideoInfo;)V

    :cond_0
    return-void
.end method

.method synthetic lambda$offer$3$ru-oopssre-imperialschool-viewstv-VideoController(Lru/oopssre/imperialschool/viewstv/VideoSurface$Clip;J)V
    .locals 2

    .line 32
    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/VideoController;->prepared:Ljava/util/Set;

    monitor-enter v0

    :try_start_0
    iget-object v1, p0, Lru/oopssre/imperialschool/viewstv/VideoController;->prepared:Ljava/util/Set;

    invoke-interface {v1, p1}, Ljava/util/Set;->remove(Ljava/lang/Object;)Z

    monitor-exit v0
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    invoke-direct {p0, p2, p3}, Lru/oopssre/imperialschool/viewstv/VideoController;->current(J)Z

    move-result p2

    if-eqz p2, :cond_0

    iget-object p2, p0, Lru/oopssre/imperialschool/viewstv/VideoController;->video:Lru/oopssre/imperialschool/viewstv/VideoSurface;

    invoke-virtual {p2, p1}, Lru/oopssre/imperialschool/viewstv/VideoSurface;->offer(Lru/oopssre/imperialschool/viewstv/VideoSurface$Clip;)V

    return-void

    :cond_0
    invoke-virtual {p1}, Lru/oopssre/imperialschool/viewstv/VideoSurface$Clip;->close()V

    return-void

    :catchall_0
    move-exception p1

    :try_start_1
    monitor-exit v0
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    throw p1
.end method

.method synthetic lambda$refresh$4$ru-oopssre-imperialschool-viewstv-VideoController(J)V
    .locals 0

    .line 43
    invoke-direct {p0, p1, p2}, Lru/oopssre/imperialschool/viewstv/VideoController;->current(J)Z

    move-result p1

    if-eqz p1, :cond_0

    iget-object p1, p0, Lru/oopssre/imperialschool/viewstv/VideoController;->listener:Lru/oopssre/imperialschool/viewstv/VideoController$Listener;

    invoke-interface {p1}, Lru/oopssre/imperialschool/viewstv/VideoController$Listener;->catalogue()V

    :cond_0
    return-void
.end method

.method synthetic lambda$refresh$5$ru-oopssre-imperialschool-viewstv-VideoController(JLjava/lang/String;J)V
    .locals 0

    .line 45
    invoke-direct {p0, p1, p2}, Lru/oopssre/imperialschool/viewstv/VideoController;->current(J)Z

    move-result p1

    if-eqz p1, :cond_0

    const/4 p1, 0x0

    iput-boolean p1, p0, Lru/oopssre/imperialschool/viewstv/VideoController;->loading:Z

    iput-object p3, p0, Lru/oopssre/imperialschool/viewstv/VideoController;->status:Ljava/lang/String;

    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J

    move-result-wide p1

    add-long/2addr p1, p4

    iput-wide p1, p0, Lru/oopssre/imperialschool/viewstv/VideoController;->nextCheckAt:J

    iget-object p1, p0, Lru/oopssre/imperialschool/viewstv/VideoController;->main:Landroid/os/Handler;

    iget-object p2, p0, Lru/oopssre/imperialschool/viewstv/VideoController;->poll:Ljava/lang/Runnable;

    invoke-virtual {p1, p2, p4, p5}, Landroid/os/Handler;->postDelayed(Ljava/lang/Runnable;J)Z

    iget-object p1, p0, Lru/oopssre/imperialschool/viewstv/VideoController;->listener:Lru/oopssre/imperialschool/viewstv/VideoController$Listener;

    invoke-interface {p1}, Lru/oopssre/imperialschool/viewstv/VideoController$Listener;->changed()V

    :cond_0
    return-void
.end method

.method synthetic lambda$refresh$6$ru-oopssre-imperialschool-viewstv-VideoController(ZJ)V
    .locals 10

    .line 36
    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/VideoController;->repo:Lru/oopssre/imperialschool/viewstv/Repository;

    invoke-virtual {v0}, Lru/oopssre/imperialschool/viewstv/Repository;->selected()Lru/oopssre/imperialschool/viewstv/Protocol$Theme;

    move-result-object v0

    invoke-static {}, Lru/oopssre/imperialschool/viewstv/VideoPolicy;->nextDelay()J

    move-result-wide v1

    const/4 v3, 0x0

    if-eqz p1, :cond_0

    .line 38
    :try_start_0
    iget-object p1, p0, Lru/oopssre/imperialschool/viewstv/VideoController;->repo:Lru/oopssre/imperialschool/viewstv/Repository;

    iget-object p1, p1, Lru/oopssre/imperialschool/viewstv/Repository;->cache:Lru/oopssre/imperialschool/viewstv/CacheStore;

    invoke-virtual {p1, v0}, Lru/oopssre/imperialschool/viewstv/CacheStore;->cachedVideo(Lru/oopssre/imperialschool/viewstv/Protocol$Theme;)Lru/oopssre/imperialschool/viewstv/VideoInfo;

    move-result-object p1
    :try_end_0
    .catch Lru/oopssre/imperialschool/viewstv/Protocol$NotReady; {:try_start_0 .. :try_end_0} :catch_2
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_1

    if-eqz p1, :cond_0

    :try_start_1
    iget-object v4, p0, Lru/oopssre/imperialschool/viewstv/VideoController;->repo:Lru/oopssre/imperialschool/viewstv/Repository;

    iget-object v4, v4, Lru/oopssre/imperialschool/viewstv/Repository;->cache:Lru/oopssre/imperialschool/viewstv/CacheStore;

    iget-object v5, p1, Lru/oopssre/imperialschool/viewstv/VideoInfo;->sha:Ljava/lang/String;

    invoke-virtual {v4, v5}, Lru/oopssre/imperialschool/viewstv/CacheStore;->video(Ljava/lang/String;)Ljava/io/File;

    move-result-object v4

    invoke-direct {p0, p1, v4, p2, p3}, Lru/oopssre/imperialschool/viewstv/VideoController;->offer(Lru/oopssre/imperialschool/viewstv/VideoInfo;Ljava/io/File;J)V
    :try_end_1
    .catch Ljava/lang/Exception; {:try_start_1 .. :try_end_1} :catch_0
    .catch Lru/oopssre/imperialschool/viewstv/Protocol$NotReady; {:try_start_1 .. :try_end_1} :catch_2

    goto :goto_0

    :catch_0
    :try_start_2
    invoke-static {}, Ljava/lang/Thread;->currentThread()Ljava/lang/Thread;

    move-result-object p1

    invoke-virtual {p1}, Ljava/lang/Thread;->isInterrupted()Z

    move-result p1

    if-eqz p1, :cond_0

    goto :goto_2

    .line 39
    :cond_0
    :goto_0
    iget-object p1, p0, Lru/oopssre/imperialschool/viewstv/VideoController;->loader:Lru/oopssre/imperialschool/viewstv/VideoLoader;

    invoke-virtual {p1, v0}, Lru/oopssre/imperialschool/viewstv/VideoLoader;->load(Lru/oopssre/imperialschool/viewstv/Protocol$Theme;)Lru/oopssre/imperialschool/viewstv/VideoLoader$Loaded;

    move-result-object p1
    :try_end_2
    .catch Lru/oopssre/imperialschool/viewstv/Protocol$NotReady; {:try_start_2 .. :try_end_2} :catch_2
    .catch Ljava/lang/Exception; {:try_start_2 .. :try_end_2} :catch_1

    :try_start_3
    iget-object v0, p1, Lru/oopssre/imperialschool/viewstv/VideoLoader$Loaded;->info:Lru/oopssre/imperialschool/viewstv/VideoInfo;

    iget-object v4, p1, Lru/oopssre/imperialschool/viewstv/VideoLoader$Loaded;->file:Ljava/io/File;

    invoke-direct {p0, v0, v4, p2, p3}, Lru/oopssre/imperialschool/viewstv/VideoController;->offer(Lru/oopssre/imperialschool/viewstv/VideoInfo;Ljava/io/File;J)V
    :try_end_3
    .catchall {:try_start_3 .. :try_end_3} :catchall_0

    if-eqz p1, :cond_1

    :try_start_4
    invoke-virtual {p1}, Lru/oopssre/imperialschool/viewstv/VideoLoader$Loaded;->close()V

    .line 40
    :cond_1
    iput v3, p0, Lru/oopssre/imperialschool/viewstv/VideoController;->failures:I

    const-string p1, "\u041f\u0443\u0431\u043b\u0438\u043a\u0430\u0446\u0438\u044f \u043f\u0440\u043e\u0432\u0435\u0440\u0435\u043d\u0430"
    :try_end_4
    .catch Lru/oopssre/imperialschool/viewstv/Protocol$NotReady; {:try_start_4 .. :try_end_4} :catch_2
    .catch Ljava/lang/Exception; {:try_start_4 .. :try_end_4} :catch_1

    goto :goto_5

    :catchall_0
    move-exception v0

    move-object v4, v0

    if-eqz p1, :cond_2

    .line 39
    :try_start_5
    invoke-virtual {p1}, Lru/oopssre/imperialschool/viewstv/VideoLoader$Loaded;->close()V
    :try_end_5
    .catchall {:try_start_5 .. :try_end_5} :catchall_1

    goto :goto_1

    :catchall_1
    move-exception v0

    move-object p1, v0

    :try_start_6
    invoke-virtual {v4, p1}, Ljava/lang/Throwable;->addSuppressed(Ljava/lang/Throwable;)V

    :cond_2
    :goto_1
    throw v4
    :try_end_6
    .catch Lru/oopssre/imperialschool/viewstv/Protocol$NotReady; {:try_start_6 .. :try_end_6} :catch_2
    .catch Ljava/lang/Exception; {:try_start_6 .. :try_end_6} :catch_1

    :catch_1
    move-exception v0

    move-object p1, v0

    .line 42
    invoke-static {}, Ljava/lang/Thread;->currentThread()Ljava/lang/Thread;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/Thread;->isInterrupted()Z

    move-result v0

    if-eqz v0, :cond_3

    :goto_2
    return-void

    :cond_3
    iget v0, p0, Lru/oopssre/imperialschool/viewstv/VideoController;->failures:I

    add-int/lit8 v0, v0, 0x1

    iput v0, p0, Lru/oopssre/imperialschool/viewstv/VideoController;->failures:I

    invoke-static {v0}, Lru/oopssre/imperialschool/viewstv/VideoPolicy;->retryDelay(I)J

    move-result-wide v1

    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    iget-object v3, p0, Lru/oopssre/imperialschool/viewstv/VideoController;->frame:Lru/oopssre/imperialschool/viewstv/VideoInfo;

    if-nez v3, :cond_4

    const-string v3, "\u0412\u0438\u0434\u0435\u043e \u043d\u0435 \u043f\u043e\u043b\u0443\u0447\u0435\u043d\u043e: "

    goto :goto_3

    :cond_4
    const-string v3, "\u041f\u0440\u043e\u0434\u043e\u043b\u0436\u0430\u0435\u0442\u0441\u044f \u043f\u043e\u043a\u0430\u0437 \u0438\u0437 \u043a\u0435\u0448\u0430. "

    :goto_3
    invoke-virtual {v0, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {p1}, Ljava/lang/Exception;->getMessage()Ljava/lang/String;

    move-result-object v3

    if-nez v3, :cond_5

    const-string p1, "\u041d\u0435\u0442 \u0441\u0432\u044f\u0437\u0438"

    goto :goto_4

    :cond_5
    invoke-virtual {p1}, Ljava/lang/Exception;->getMessage()Ljava/lang/String;

    move-result-object p1

    :goto_4
    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p1

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    goto :goto_5

    :catch_2
    move-exception v0

    move-object p1, v0

    .line 41
    iput v3, p0, Lru/oopssre/imperialschool/viewstv/VideoController;->failures:I

    invoke-virtual {p1}, Lru/oopssre/imperialschool/viewstv/Protocol$NotReady;->getMessage()Ljava/lang/String;

    move-result-object p1

    :goto_5
    move-object v7, p1

    move-wide v8, v1

    .line 43
    :try_start_7
    invoke-direct {p0, p2, p3}, Lru/oopssre/imperialschool/viewstv/VideoController;->current(J)Z

    move-result p1

    if-eqz p1, :cond_6

    iget-object p1, p0, Lru/oopssre/imperialschool/viewstv/VideoController;->repo:Lru/oopssre/imperialschool/viewstv/Repository;

    const-string v0, ""

    invoke-virtual {p1, v0}, Lru/oopssre/imperialschool/viewstv/Repository;->refreshCatalogue(Ljava/lang/String;)V

    iget-object p1, p0, Lru/oopssre/imperialschool/viewstv/VideoController;->main:Landroid/os/Handler;

    new-instance v0, Lru/oopssre/imperialschool/viewstv/VideoController$$ExternalSyntheticLambda0;

    invoke-direct {v0, p0, p2, p3}, Lru/oopssre/imperialschool/viewstv/VideoController$$ExternalSyntheticLambda0;-><init>(Lru/oopssre/imperialschool/viewstv/VideoController;J)V

    invoke-virtual {p1, v0}, Landroid/os/Handler;->post(Ljava/lang/Runnable;)Z
    :try_end_7
    .catch Ljava/lang/Exception; {:try_start_7 .. :try_end_7} :catch_3

    .line 45
    :catch_3
    :cond_6
    iget-object p1, p0, Lru/oopssre/imperialschool/viewstv/VideoController;->main:Landroid/os/Handler;

    new-instance v3, Lru/oopssre/imperialschool/viewstv/VideoController$$ExternalSyntheticLambda1;

    move-object v4, p0

    move-wide v5, p2

    invoke-direct/range {v3 .. v9}, Lru/oopssre/imperialschool/viewstv/VideoController$$ExternalSyntheticLambda1;-><init>(Lru/oopssre/imperialschool/viewstv/VideoController;JLjava/lang/String;J)V

    invoke-virtual {p1, v3}, Landroid/os/Handler;->post(Ljava/lang/Runnable;)Z

    return-void
.end method

.method synthetic lambda$surfaceChanged$7$ru-oopssre-imperialschool-viewstv-VideoController(Lru/oopssre/imperialschool/viewstv/VideoInfo;)V
    .locals 1

    .line 52
    :try_start_0
    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/VideoController;->repo:Lru/oopssre/imperialschool/viewstv/Repository;

    iget-object v0, v0, Lru/oopssre/imperialschool/viewstv/Repository;->cache:Lru/oopssre/imperialschool/viewstv/CacheStore;

    invoke-virtual {v0, p1}, Lru/oopssre/imperialschool/viewstv/CacheStore;->saveVideo(Lru/oopssre/imperialschool/viewstv/VideoInfo;)V
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    :catch_0
    return-void
.end method

.method refresh(Z)V
    .locals 4

    .line 34
    iget-boolean v0, p0, Lru/oopssre/imperialschool/viewstv/VideoController;->active:Z

    if-nez v0, :cond_0

    return-void

    :cond_0
    iget-wide v0, p0, Lru/oopssre/imperialschool/viewstv/VideoController;->generation:J

    const-wide/16 v2, 0x1

    add-long/2addr v0, v2

    iput-wide v0, p0, Lru/oopssre/imperialschool/viewstv/VideoController;->generation:J

    iget-object v2, p0, Lru/oopssre/imperialschool/viewstv/VideoController;->main:Landroid/os/Handler;

    iget-object v3, p0, Lru/oopssre/imperialschool/viewstv/VideoController;->poll:Ljava/lang/Runnable;

    invoke-virtual {v2, v3}, Landroid/os/Handler;->removeCallbacks(Ljava/lang/Runnable;)V

    iget-object v2, p0, Lru/oopssre/imperialschool/viewstv/VideoController;->main:Landroid/os/Handler;

    iget-object v3, p0, Lru/oopssre/imperialschool/viewstv/VideoController;->retry:Ljava/lang/Runnable;

    invoke-virtual {v2, v3}, Landroid/os/Handler;->removeCallbacks(Ljava/lang/Runnable;)V

    iget-object v2, p0, Lru/oopssre/imperialschool/viewstv/VideoController;->job:Ljava/util/concurrent/Future;

    const/4 v3, 0x1

    if-eqz v2, :cond_1

    invoke-interface {v2, v3}, Ljava/util/concurrent/Future;->cancel(Z)Z

    :cond_1
    iput-boolean v3, p0, Lru/oopssre/imperialschool/viewstv/VideoController;->loading:Z

    .line 35
    iget-object v2, p0, Lru/oopssre/imperialschool/viewstv/VideoController;->worker:Ljava/util/concurrent/ExecutorService;

    new-instance v3, Lru/oopssre/imperialschool/viewstv/VideoController$$ExternalSyntheticLambda2;

    invoke-direct {v3, p0, p1, v0, v1}, Lru/oopssre/imperialschool/viewstv/VideoController$$ExternalSyntheticLambda2;-><init>(Lru/oopssre/imperialschool/viewstv/VideoController;ZJ)V

    invoke-interface {v2, v3}, Ljava/util/concurrent/ExecutorService;->submit(Ljava/lang/Runnable;)Ljava/util/concurrent/Future;

    move-result-object p1

    iput-object p1, p0, Lru/oopssre/imperialschool/viewstv/VideoController;->job:Ljava/util/concurrent/Future;

    return-void
.end method

.method reset()V
    .locals 2

    .line 22
    invoke-virtual {p0}, Lru/oopssre/imperialschool/viewstv/VideoController;->stop()V

    const/4 v0, 0x0

    iput-object v0, p0, Lru/oopssre/imperialschool/viewstv/VideoController;->frame:Lru/oopssre/imperialschool/viewstv/VideoInfo;

    const-string v0, ""

    iput-object v0, p0, Lru/oopssre/imperialschool/viewstv/VideoController;->stored:Ljava/lang/String;

    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/VideoController;->video:Lru/oopssre/imperialschool/viewstv/VideoSurface;

    iget-wide v0, v0, Lru/oopssre/imperialschool/viewstv/VideoSurface;->failures:J

    iput-wide v0, p0, Lru/oopssre/imperialschool/viewstv/VideoController;->observedFailures:J

    const-string v0, "\u041e\u0436\u0438\u0434\u0430\u043d\u0438\u0435 \u043e\u043f\u0443\u0431\u043b\u0438\u043a\u043e\u0432\u0430\u043d\u043d\u043e\u0433\u043e \u0432\u0438\u0434\u0435\u043e\u2026"

    iput-object v0, p0, Lru/oopssre/imperialschool/viewstv/VideoController;->status:Ljava/lang/String;

    return-void
.end method

.method start()V
    .locals 1

    .line 20
    iget-boolean v0, p0, Lru/oopssre/imperialschool/viewstv/VideoController;->active:Z

    if-eqz v0, :cond_0

    return-void

    :cond_0
    const/4 v0, 0x1

    iput-boolean v0, p0, Lru/oopssre/imperialschool/viewstv/VideoController;->active:Z

    invoke-virtual {p0, v0}, Lru/oopssre/imperialschool/viewstv/VideoController;->refresh(Z)V

    return-void
.end method

.method stop()V
    .locals 5

    const/4 v0, 0x0

    .line 21
    iput-boolean v0, p0, Lru/oopssre/imperialschool/viewstv/VideoController;->active:Z

    iget-wide v1, p0, Lru/oopssre/imperialschool/viewstv/VideoController;->generation:J

    const-wide/16 v3, 0x1

    add-long/2addr v1, v3

    iput-wide v1, p0, Lru/oopssre/imperialschool/viewstv/VideoController;->generation:J

    iput-boolean v0, p0, Lru/oopssre/imperialschool/viewstv/VideoController;->loading:Z

    const-wide/16 v0, 0x0

    iput-wide v0, p0, Lru/oopssre/imperialschool/viewstv/VideoController;->nextCheckAt:J

    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/VideoController;->main:Landroid/os/Handler;

    iget-object v1, p0, Lru/oopssre/imperialschool/viewstv/VideoController;->poll:Ljava/lang/Runnable;

    invoke-virtual {v0, v1}, Landroid/os/Handler;->removeCallbacks(Ljava/lang/Runnable;)V

    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/VideoController;->main:Landroid/os/Handler;

    iget-object v1, p0, Lru/oopssre/imperialschool/viewstv/VideoController;->retry:Ljava/lang/Runnable;

    invoke-virtual {v0, v1}, Landroid/os/Handler;->removeCallbacks(Ljava/lang/Runnable;)V

    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/VideoController;->job:Ljava/util/concurrent/Future;

    if-eqz v0, :cond_0

    const/4 v1, 0x1

    invoke-interface {v0, v1}, Ljava/util/concurrent/Future;->cancel(Z)Z

    :cond_0
    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/VideoController;->prepared:Ljava/util/Set;

    monitor-enter v0

    :try_start_0
    iget-object v1, p0, Lru/oopssre/imperialschool/viewstv/VideoController;->prepared:Ljava/util/Set;

    invoke-interface {v1}, Ljava/util/Set;->iterator()Ljava/util/Iterator;

    move-result-object v1

    :goto_0
    invoke-interface {v1}, Ljava/util/Iterator;->hasNext()Z

    move-result v2

    if-eqz v2, :cond_1

    invoke-interface {v1}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Lru/oopssre/imperialschool/viewstv/VideoSurface$Clip;

    invoke-virtual {v2}, Lru/oopssre/imperialschool/viewstv/VideoSurface$Clip;->close()V

    goto :goto_0

    :cond_1
    iget-object v1, p0, Lru/oopssre/imperialschool/viewstv/VideoController;->prepared:Ljava/util/Set;

    invoke-interface {v1}, Ljava/util/Set;->clear()V

    monitor-exit v0

    return-void

    :catchall_0
    move-exception v1

    monitor-exit v0
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    throw v1
.end method

.method surfaceChanged()V
    .locals 4

    .line 48
    iget-boolean v0, p0, Lru/oopssre/imperialschool/viewstv/VideoController;->active:Z

    if-nez v0, :cond_0

    goto/16 :goto_0

    .line 49
    :cond_0
    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/VideoController;->video:Lru/oopssre/imperialschool/viewstv/VideoSurface;

    iget-object v0, v0, Lru/oopssre/imperialschool/viewstv/VideoSurface;->displayed:Lru/oopssre/imperialschool/viewstv/VideoInfo;

    if-eqz v0, :cond_1

    .line 50
    iget-object v1, v0, Lru/oopssre/imperialschool/viewstv/VideoInfo;->frame:Lru/oopssre/imperialschool/viewstv/Protocol$Frame;

    iget-object v1, v1, Lru/oopssre/imperialschool/viewstv/Protocol$Frame;->theme:Ljava/lang/String;

    iget-object v2, p0, Lru/oopssre/imperialschool/viewstv/VideoController;->repo:Lru/oopssre/imperialschool/viewstv/Repository;

    invoke-virtual {v2}, Lru/oopssre/imperialschool/viewstv/Repository;->selected()Lru/oopssre/imperialschool/viewstv/Protocol$Theme;

    move-result-object v2

    iget-object v2, v2, Lru/oopssre/imperialschool/viewstv/Protocol$Theme;->id:Ljava/lang/String;

    invoke-virtual {v1, v2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v1

    if-eqz v1, :cond_1

    .line 51
    iput-object v0, p0, Lru/oopssre/imperialschool/viewstv/VideoController;->frame:Lru/oopssre/imperialschool/viewstv/VideoInfo;

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    iget-object v2, v0, Lru/oopssre/imperialschool/viewstv/VideoInfo;->frame:Lru/oopssre/imperialschool/viewstv/Protocol$Frame;

    iget-object v2, v2, Lru/oopssre/imperialschool/viewstv/Protocol$Frame;->stateId:Ljava/lang/String;

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    const-string v2, "/"

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    iget-object v2, v0, Lru/oopssre/imperialschool/viewstv/VideoInfo;->sha:Ljava/lang/String;

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    .line 52
    iget-object v2, p0, Lru/oopssre/imperialschool/viewstv/VideoController;->stored:Ljava/lang/String;

    invoke-virtual {v1, v2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v2

    if-nez v2, :cond_1

    iput-object v1, p0, Lru/oopssre/imperialschool/viewstv/VideoController;->stored:Ljava/lang/String;

    iget-object v1, p0, Lru/oopssre/imperialschool/viewstv/VideoController;->worker:Ljava/util/concurrent/ExecutorService;

    new-instance v2, Lru/oopssre/imperialschool/viewstv/VideoController$$ExternalSyntheticLambda7;

    invoke-direct {v2, p0, v0}, Lru/oopssre/imperialschool/viewstv/VideoController$$ExternalSyntheticLambda7;-><init>(Lru/oopssre/imperialschool/viewstv/VideoController;Lru/oopssre/imperialschool/viewstv/VideoInfo;)V

    invoke-interface {v1, v2}, Ljava/util/concurrent/ExecutorService;->submit(Ljava/lang/Runnable;)Ljava/util/concurrent/Future;

    .line 54
    :cond_1
    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/VideoController;->video:Lru/oopssre/imperialschool/viewstv/VideoSurface;

    iget-wide v0, v0, Lru/oopssre/imperialschool/viewstv/VideoSurface;->failures:J

    iget-wide v2, p0, Lru/oopssre/imperialschool/viewstv/VideoController;->observedFailures:J

    cmp-long v0, v0, v2

    const/4 v1, 0x1

    if-eqz v0, :cond_2

    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/VideoController;->video:Lru/oopssre/imperialschool/viewstv/VideoSurface;

    iget-wide v2, v0, Lru/oopssre/imperialschool/viewstv/VideoSurface;->failures:J

    iput-wide v2, p0, Lru/oopssre/imperialschool/viewstv/VideoController;->observedFailures:J

    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/VideoController;->main:Landroid/os/Handler;

    iget-object v2, p0, Lru/oopssre/imperialschool/viewstv/VideoController;->poll:Ljava/lang/Runnable;

    invoke-virtual {v0, v2}, Landroid/os/Handler;->removeCallbacks(Ljava/lang/Runnable;)V

    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/VideoController;->main:Landroid/os/Handler;

    iget-object v2, p0, Lru/oopssre/imperialschool/viewstv/VideoController;->retry:Ljava/lang/Runnable;

    invoke-virtual {v0, v2}, Landroid/os/Handler;->removeCallbacks(Ljava/lang/Runnable;)V

    iget v0, p0, Lru/oopssre/imperialschool/viewstv/VideoController;->failures:I

    add-int/2addr v0, v1

    iput v0, p0, Lru/oopssre/imperialschool/viewstv/VideoController;->failures:I

    invoke-static {v0}, Lru/oopssre/imperialschool/viewstv/VideoPolicy;->retryDelay(I)J

    move-result-wide v0

    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J

    move-result-wide v2

    add-long/2addr v2, v0

    iput-wide v2, p0, Lru/oopssre/imperialschool/viewstv/VideoController;->nextCheckAt:J

    iget-object v2, p0, Lru/oopssre/imperialschool/viewstv/VideoController;->main:Landroid/os/Handler;

    iget-object v3, p0, Lru/oopssre/imperialschool/viewstv/VideoController;->retry:Ljava/lang/Runnable;

    invoke-virtual {v2, v3, v0, v1}, Landroid/os/Handler;->postDelayed(Ljava/lang/Runnable;J)Z

    return-void

    .line 55
    :cond_2
    iget-boolean v0, p0, Lru/oopssre/imperialschool/viewstv/VideoController;->loading:Z

    if-nez v0, :cond_3

    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/VideoController;->video:Lru/oopssre/imperialschool/viewstv/VideoSurface;

    iget-boolean v0, v0, Lru/oopssre/imperialschool/viewstv/VideoSurface;->running:Z

    if-nez v0, :cond_3

    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/VideoController;->video:Lru/oopssre/imperialschool/viewstv/VideoSurface;

    invoke-virtual {v0}, Lru/oopssre/imperialschool/viewstv/VideoSurface;->wanted()Z

    move-result v0

    if-eqz v0, :cond_3

    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/VideoController;->video:Lru/oopssre/imperialschool/viewstv/VideoSurface;

    invoke-virtual {v0}, Lru/oopssre/imperialschool/viewstv/VideoSurface;->getHolder()Landroid/view/SurfaceHolder;

    move-result-object v0

    invoke-interface {v0}, Landroid/view/SurfaceHolder;->getSurface()Landroid/view/Surface;

    move-result-object v0

    invoke-virtual {v0}, Landroid/view/Surface;->isValid()Z

    move-result v0

    if-eqz v0, :cond_3

    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/VideoController;->video:Lru/oopssre/imperialschool/viewstv/VideoSurface;

    iget-object v0, v0, Lru/oopssre/imperialschool/viewstv/VideoSurface;->pending:Ljava/util/concurrent/atomic/AtomicReference;

    invoke-virtual {v0}, Ljava/util/concurrent/atomic/AtomicReference;->get()Ljava/lang/Object;

    move-result-object v0

    if-nez v0, :cond_3

    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/VideoController;->frame:Lru/oopssre/imperialschool/viewstv/VideoInfo;

    if-eqz v0, :cond_3

    invoke-virtual {p0, v1}, Lru/oopssre/imperialschool/viewstv/VideoController;->refresh(Z)V

    :cond_3
    :goto_0
    return-void
.end method
