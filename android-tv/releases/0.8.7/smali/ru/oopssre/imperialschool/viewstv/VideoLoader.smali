.class public final Lru/oopssre/imperialschool/viewstv/VideoLoader;
.super Ljava/lang/Object;
.source "VideoLoader.java"


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lru/oopssre/imperialschool/viewstv/VideoLoader$Loaded;
    }
.end annotation


# instance fields
.field final cache:Lru/oopssre/imperialschool/viewstv/CacheStore;

.field final net:Lru/oopssre/imperialschool/viewstv/HttpTransport;


# direct methods
.method public constructor <init>(Lru/oopssre/imperialschool/viewstv/HttpTransport;Lru/oopssre/imperialschool/viewstv/CacheStore;)V
    .locals 0

    .line 10
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    iput-object p1, p0, Lru/oopssre/imperialschool/viewstv/VideoLoader;->net:Lru/oopssre/imperialschool/viewstv/HttpTransport;

    iput-object p2, p0, Lru/oopssre/imperialschool/viewstv/VideoLoader;->cache:Lru/oopssre/imperialschool/viewstv/CacheStore;

    return-void
.end method


# virtual methods
.method public describe(Lru/oopssre/imperialschool/viewstv/Protocol$Theme;Z)Lru/oopssre/imperialschool/viewstv/VideoInfo;
    .locals 4
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/lang/Exception;
        }
    .end annotation

    .line 17
    iget-object v0, p1, Lru/oopssre/imperialschool/viewstv/Protocol$Theme;->kind:Ljava/lang/String;

    const-string v1, "dynamic"

    invoke-virtual {v0, v1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    const-string v1, "\u0412\u0438\u0434\u0435\u043e 4\u041a \u0434\u043e\u0441\u0442\u0443\u043f\u043d\u043e \u0434\u043b\u044f \u0434\u0438\u043d\u0430\u043c\u0438\u0447\u0435\u0441\u043a\u0438\u0445 \u0442\u0435\u043c"

    invoke-static {v0, v1}, Lru/oopssre/imperialschool/viewstv/Protocol;->require(ZLjava/lang/String;)V

    .line 18
    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/VideoLoader;->net:Lru/oopssre/imperialschool/viewstv/HttpTransport;

    iget-object v1, p1, Lru/oopssre/imperialschool/viewstv/Protocol$Theme;->current:Ljava/lang/String;

    const-string v2, ""

    invoke-virtual {v0, v1, p2, v2}, Lru/oopssre/imperialschool/viewstv/HttpTransport;->json(Ljava/lang/String;ZLjava/lang/String;)Lorg/json/JSONObject;

    move-result-object v0

    invoke-static {v0, p1}, Lru/oopssre/imperialschool/viewstv/Protocol;->publishedVideo(Lorg/json/JSONObject;Lru/oopssre/imperialschool/viewstv/Protocol$Theme;)Lru/oopssre/imperialschool/viewstv/Protocol$Theme;

    move-result-object p1

    .line 19
    iget-object v1, p0, Lru/oopssre/imperialschool/viewstv/VideoLoader;->net:Lru/oopssre/imperialschool/viewstv/HttpTransport;

    invoke-static {v0, p1}, Lru/oopssre/imperialschool/viewstv/Protocol;->statePath(Lorg/json/JSONObject;Lru/oopssre/imperialschool/viewstv/Protocol$Theme;)Ljava/lang/String;

    move-result-object v3

    invoke-virtual {v1, v3, p2, v2}, Lru/oopssre/imperialschool/viewstv/HttpTransport;->json(Ljava/lang/String;ZLjava/lang/String;)Lorg/json/JSONObject;

    move-result-object p2

    .line 20
    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J

    move-result-wide v1

    invoke-static {p2, v0, p1, v1, v2}, Lru/oopssre/imperialschool/viewstv/Protocol;->frame(Lorg/json/JSONObject;Lorg/json/JSONObject;Lru/oopssre/imperialschool/viewstv/Protocol$Theme;J)Lru/oopssre/imperialschool/viewstv/Protocol$Frame;

    move-result-object p1

    invoke-static {p2, p1}, Lru/oopssre/imperialschool/viewstv/VideoInfo;->parse(Lorg/json/JSONObject;Lru/oopssre/imperialschool/viewstv/Protocol$Frame;)Lru/oopssre/imperialschool/viewstv/VideoInfo;

    move-result-object p1

    return-object p1
.end method

.method public load(Lru/oopssre/imperialschool/viewstv/Protocol$Theme;)Lru/oopssre/imperialschool/viewstv/VideoLoader$Loaded;
    .locals 5
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/lang/Exception;
        }
    .end annotation

    const/4 v0, 0x0

    const/4 v1, 0x0

    move v2, v1

    :goto_0
    const/4 v3, 0x2

    if-ge v2, v3, :cond_2

    if-lez v2, :cond_0

    const/4 v0, 0x1

    goto :goto_1

    :cond_0
    move v0, v1

    .line 26
    :goto_1
    :try_start_0
    invoke-virtual {p0, p1, v0}, Lru/oopssre/imperialschool/viewstv/VideoLoader;->describe(Lru/oopssre/imperialschool/viewstv/Protocol$Theme;Z)Lru/oopssre/imperialschool/viewstv/VideoInfo;

    move-result-object v0

    iget-object v3, p0, Lru/oopssre/imperialschool/viewstv/VideoLoader;->cache:Lru/oopssre/imperialschool/viewstv/CacheStore;

    iget-object v4, v0, Lru/oopssre/imperialschool/viewstv/VideoInfo;->sha:Ljava/lang/String;

    invoke-virtual {v3, v4}, Lru/oopssre/imperialschool/viewstv/CacheStore;->pinVideo(Ljava/lang/String;)V
    :try_end_0
    .catch Lru/oopssre/imperialschool/viewstv/Protocol$NotReady; {:try_start_0 .. :try_end_0} :catch_1
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    .line 27
    :try_start_1
    iget-object v3, p0, Lru/oopssre/imperialschool/viewstv/VideoLoader;->net:Lru/oopssre/imperialschool/viewstv/HttpTransport;

    const-string v4, ""

    invoke-virtual {v3, v0, v4}, Lru/oopssre/imperialschool/viewstv/HttpTransport;->video(Lru/oopssre/imperialschool/viewstv/VideoInfo;Ljava/lang/String;)Ljava/io/File;

    move-result-object v3

    new-instance v4, Lru/oopssre/imperialschool/viewstv/VideoLoader$Loaded;

    invoke-direct {v4, p0, v0, v3}, Lru/oopssre/imperialschool/viewstv/VideoLoader$Loaded;-><init>(Lru/oopssre/imperialschool/viewstv/VideoLoader;Lru/oopssre/imperialschool/viewstv/VideoInfo;Ljava/io/File;)V
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    return-object v4

    :catchall_0
    move-exception v3

    .line 28
    :try_start_2
    iget-object v4, p0, Lru/oopssre/imperialschool/viewstv/VideoLoader;->cache:Lru/oopssre/imperialschool/viewstv/CacheStore;

    iget-object v0, v0, Lru/oopssre/imperialschool/viewstv/VideoInfo;->sha:Ljava/lang/String;

    invoke-virtual {v4, v0}, Lru/oopssre/imperialschool/viewstv/CacheStore;->unpinVideo(Ljava/lang/String;)V

    throw v3
    :try_end_2
    .catch Lru/oopssre/imperialschool/viewstv/Protocol$NotReady; {:try_start_2 .. :try_end_2} :catch_1
    .catch Ljava/lang/Exception; {:try_start_2 .. :try_end_2} :catch_0

    :catch_0
    move-exception v0

    .line 30
    invoke-static {}, Ljava/lang/Thread;->currentThread()Ljava/lang/Thread;

    move-result-object v3

    invoke-virtual {v3}, Ljava/lang/Thread;->isInterrupted()Z

    move-result v3

    if-nez v3, :cond_1

    add-int/lit8 v2, v2, 0x1

    goto :goto_0

    :cond_1
    throw v0

    :catch_1
    move-exception p1

    .line 29
    throw p1

    .line 32
    :cond_2
    throw v0
.end method
