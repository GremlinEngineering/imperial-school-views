.class public final Lru/oopssre/imperialschool/viewstv/HttpTransport;
.super Ljava/lang/Object;
.source "HttpTransport.java"


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lru/oopssre/imperialschool/viewstv/HttpTransport$HttpFailure;
    }
.end annotation


# instance fields
.field final cache:Lru/oopssre/imperialschool/viewstv/CacheStore;


# direct methods
.method public static synthetic $r8$lambda$j-up7tewrnlbWwuTORbAT_7hFYM(Ljava/io/File;)J
    .locals 2

    invoke-virtual {p0}, Ljava/io/File;->lastModified()J

    move-result-wide v0

    return-wide v0
.end method

.method public constructor <init>(Lru/oopssre/imperialschool/viewstv/CacheStore;)V
    .locals 0

    .line 14
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    iput-object p1, p0, Lru/oopssre/imperialschool/viewstv/HttpTransport;->cache:Lru/oopssre/imperialschool/viewstv/CacheStore;

    return-void
.end method

.method static connect(Ljava/net/URI;Z)Ljava/net/HttpURLConnection;
    .locals 2
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/io/IOException;
        }
    .end annotation

    .line 16
    invoke-static {p0}, Lru/oopssre/imperialschool/viewstv/ProxyRouting;->openHttp(Ljava/net/URI;)Ljava/net/HttpURLConnection;

    move-result-object p0

    const/16 v0, 0x1f40

    invoke-virtual {p0, v0}, Ljava/net/HttpURLConnection;->setConnectTimeout(I)V

    const/16 v0, 0x2ee0

    invoke-virtual {p0, v0}, Ljava/net/HttpURLConnection;->setReadTimeout(I)V

    const/4 v0, 0x0

    invoke-virtual {p0, v0}, Ljava/net/HttpURLConnection;->setInstanceFollowRedirects(Z)V

    invoke-virtual {p0, v0}, Ljava/net/HttpURLConnection;->setUseCaches(Z)V

    const-string v0, "User-Agent"

    const-string v1, "ImperialSchoolViewsTV/0.8.7"

    invoke-virtual {p0, v0, v1}, Ljava/net/HttpURLConnection;->setRequestProperty(Ljava/lang/String;Ljava/lang/String;)V

    if-eqz p1, :cond_0

    const-string v0, "br, gzip"

    goto :goto_0

    :cond_0
    const-string v0, "identity"

    :goto_0
    const-string v1, "Accept-Encoding"

    invoke-virtual {p0, v1, v0}, Ljava/net/HttpURLConnection;->setRequestProperty(Ljava/lang/String;Ljava/lang/String;)V

    if-eqz p1, :cond_1

    const-string p1, "Accept"

    const-string v0, "application/json"

    invoke-virtual {p0, p1, v0}, Ljava/net/HttpURLConnection;->setRequestProperty(Ljava/lang/String;Ljava/lang/String;)V

    :cond_1
    return-object p0
.end method

.method public static download(Ljava/lang/String;Ljava/io/File;JJ)V
    .locals 12
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/io/IOException;
        }
    .end annotation

    .line 56
    invoke-static {p0}, Lru/oopssre/imperialschool/viewstv/Protocol;->url(Ljava/lang/String;)Ljava/net/URI;

    move-result-object p0

    const/4 v0, 0x0

    move v1, v0

    :goto_0
    const/4 v2, 0x4

    if-ge v1, v2, :cond_c

    .line 57
    invoke-static {p0, v0}, Lru/oopssre/imperialschool/viewstv/HttpTransport;->connect(Ljava/net/URI;Z)Ljava/net/HttpURLConnection;

    move-result-object v2

    .line 58
    :try_start_0
    invoke-virtual {v2}, Ljava/net/HttpURLConnection;->getResponseCode()I

    move-result v3

    const/16 v4, 0x12c

    if-lt v3, v4, :cond_1

    const/16 v4, 0x190

    if-ge v3, v4, :cond_1

    const-string v3, "Location"

    invoke-virtual {v2, v3}, Ljava/net/HttpURLConnection;->getHeaderField(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v3

    if-eqz v3, :cond_0

    invoke-virtual {p0, v3}, Ljava/net/URI;->resolve(Ljava/lang/String;)Ljava/net/URI;

    move-result-object p0

    invoke-virtual {p0}, Ljava/net/URI;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-static {p0}, Lru/oopssre/imperialschool/viewstv/Protocol;->url(Ljava/lang/String;)Ljava/net/URI;

    move-result-object p0
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_4

    .line 61
    invoke-virtual {v2}, Ljava/net/HttpURLConnection;->disconnect()V

    add-int/lit8 v1, v1, 0x1

    goto :goto_0

    .line 58
    :cond_0
    :try_start_1
    new-instance p0, Ljava/io/IOException;

    const-string p1, "\u041d\u0435\u0442 \u0430\u0434\u0440\u0435\u0441\u0430 \u043f\u0435\u0440\u0435\u043d\u0430\u043f\u0440\u0430\u0432\u043b\u0435\u043d\u0438\u044f"

    invoke-direct {p0, p1}, Ljava/io/IOException;-><init>(Ljava/lang/String;)V

    throw p0

    :cond_1
    const/16 p0, 0xc8

    if-ne v3, p0, :cond_b

    .line 59
    invoke-virtual {v2}, Ljava/net/HttpURLConnection;->getContentLengthLong()J

    move-result-wide v3

    cmp-long p0, v3, p4

    if-gtz p0, :cond_a

    const-wide/16 v5, 0x0

    cmp-long p0, v3, v5

    if-ltz p0, :cond_2

    cmp-long p0, v3, p2

    if-nez p0, :cond_a

    .line 60
    :cond_2
    invoke-static {}, Ljava/lang/System;->nanoTime()J

    move-result-wide v3

    invoke-virtual {v2}, Ljava/net/HttpURLConnection;->getInputStream()Ljava/io/InputStream;

    move-result-object p0
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_4

    :try_start_2
    new-instance v1, Ljava/io/FileOutputStream;

    invoke-direct {v1, p1}, Ljava/io/FileOutputStream;-><init>(Ljava/io/File;)V
    :try_end_2
    .catchall {:try_start_2 .. :try_end_2} :catchall_2

    const p1, 0x8000

    :try_start_3
    new-array p1, p1, [B

    :goto_1
    invoke-virtual {p0, p1}, Ljava/io/InputStream;->read([B)I

    move-result v7

    const/4 v8, -0x1

    if-eq v7, v8, :cond_6

    invoke-static {}, Ljava/lang/Thread;->currentThread()Ljava/lang/Thread;

    move-result-object v8

    invoke-virtual {v8}, Ljava/lang/Thread;->isInterrupted()Z

    move-result v8

    if-nez v8, :cond_5

    invoke-static {}, Ljava/lang/System;->nanoTime()J

    move-result-wide v8

    sub-long/2addr v8, v3

    const-wide v10, 0x1bf08eb000L

    cmp-long v8, v8, v10

    if-gtz v8, :cond_4

    int-to-long v8, v7

    add-long/2addr v5, v8

    cmp-long v8, v5, p4

    if-gtz v8, :cond_3

    cmp-long v8, v5, p2

    if-gtz v8, :cond_3

    invoke-virtual {v1, p1, v0, v7}, Ljava/io/FileOutputStream;->write([BII)V

    goto :goto_1

    :cond_3
    new-instance p1, Ljava/io/IOException;

    const-string v0, "\u0424\u0430\u0439\u043b \u0441\u043b\u0438\u0448\u043a\u043e\u043c \u0431\u043e\u043b\u044c\u0448\u043e\u0439"

    invoke-direct {p1, v0}, Ljava/io/IOException;-><init>(Ljava/lang/String;)V

    throw p1

    :cond_4
    new-instance p1, Ljava/io/IOException;

    const-string v0, "\u0417\u0430\u0433\u0440\u0443\u0437\u043a\u0430 \u0437\u0430\u043d\u044f\u043b\u0430 \u0441\u043b\u0438\u0448\u043a\u043e\u043c \u043c\u043d\u043e\u0433\u043e \u0432\u0440\u0435\u043c\u0435\u043d\u0438"

    invoke-direct {p1, v0}, Ljava/io/IOException;-><init>(Ljava/lang/String;)V

    throw p1

    :cond_5
    new-instance p1, Ljava/io/InterruptedIOException;

    invoke-direct {p1}, Ljava/io/InterruptedIOException;-><init>()V

    throw p1

    :cond_6
    invoke-virtual {v1}, Ljava/io/FileOutputStream;->getFD()Ljava/io/FileDescriptor;

    move-result-object p1

    invoke-virtual {p1}, Ljava/io/FileDescriptor;->sync()V
    :try_end_3
    .catchall {:try_start_3 .. :try_end_3} :catchall_0

    :try_start_4
    invoke-virtual {v1}, Ljava/io/FileOutputStream;->close()V
    :try_end_4
    .catchall {:try_start_4 .. :try_end_4} :catchall_2

    if-eqz p0, :cond_7

    :try_start_5
    invoke-virtual {p0}, Ljava/io/InputStream;->close()V
    :try_end_5
    .catchall {:try_start_5 .. :try_end_5} :catchall_4

    :cond_7
    cmp-long p0, v5, p2

    if-nez p0, :cond_8

    .line 61
    invoke-virtual {v2}, Ljava/net/HttpURLConnection;->disconnect()V

    return-void

    .line 60
    :cond_8
    :try_start_6
    new-instance p0, Ljava/io/IOException;

    const-string p1, "\u0424\u0430\u0439\u043b \u0437\u0430\u0433\u0440\u0443\u0436\u0435\u043d \u043d\u0435 \u043f\u043e\u043b\u043d\u043e\u0441\u0442\u044c\u044e"

    invoke-direct {p0, p1}, Ljava/io/IOException;-><init>(Ljava/lang/String;)V

    throw p0
    :try_end_6
    .catchall {:try_start_6 .. :try_end_6} :catchall_4

    :catchall_0
    move-exception v0

    move-object p1, v0

    :try_start_7
    invoke-virtual {v1}, Ljava/io/FileOutputStream;->close()V
    :try_end_7
    .catchall {:try_start_7 .. :try_end_7} :catchall_1

    goto :goto_2

    :catchall_1
    move-exception v0

    :try_start_8
    invoke-virtual {p1, v0}, Ljava/lang/Throwable;->addSuppressed(Ljava/lang/Throwable;)V

    :goto_2
    throw p1
    :try_end_8
    .catchall {:try_start_8 .. :try_end_8} :catchall_2

    :catchall_2
    move-exception v0

    move-object p1, v0

    if-eqz p0, :cond_9

    :try_start_9
    invoke-virtual {p0}, Ljava/io/InputStream;->close()V
    :try_end_9
    .catchall {:try_start_9 .. :try_end_9} :catchall_3

    goto :goto_3

    :catchall_3
    move-exception v0

    move-object p0, v0

    :try_start_a
    invoke-virtual {p1, p0}, Ljava/lang/Throwable;->addSuppressed(Ljava/lang/Throwable;)V

    :cond_9
    :goto_3
    throw p1

    .line 59
    :cond_a
    new-instance p0, Ljava/io/IOException;

    const-string p1, "\u041d\u0435\u0432\u0435\u0440\u043d\u044b\u0439 \u0440\u0430\u0437\u043c\u0435\u0440 \u0444\u0430\u0439\u043b\u0430"

    invoke-direct {p0, p1}, Ljava/io/IOException;-><init>(Ljava/lang/String;)V

    throw p0

    :cond_b
    new-instance p0, Lru/oopssre/imperialschool/viewstv/HttpTransport$HttpFailure;

    invoke-direct {p0, v3}, Lru/oopssre/imperialschool/viewstv/HttpTransport$HttpFailure;-><init>(I)V

    throw p0
    :try_end_a
    .catchall {:try_start_a .. :try_end_a} :catchall_4

    :catchall_4
    move-exception v0

    move-object p0, v0

    .line 61
    invoke-virtual {v2}, Ljava/net/HttpURLConnection;->disconnect()V

    throw p0

    :cond_c
    new-instance p0, Ljava/io/IOException;

    const-string p1, "\u0421\u043b\u0438\u0448\u043a\u043e\u043c \u043c\u043d\u043e\u0433\u043e \u043f\u0435\u0440\u0435\u043d\u0430\u043f\u0440\u0430\u0432\u043b\u0435\u043d\u0438\u0439"

    invoke-direct {p0, p1}, Ljava/io/IOException;-><init>(Ljava/lang/String;)V

    throw p0
.end method


# virtual methods
.method public image(Lru/oopssre/imperialschool/viewstv/Protocol$Frame;Ljava/lang/String;)Ljava/io/File;
    .locals 9
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/io/IOException;
        }
    .end annotation

    .line 40
    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/HttpTransport;->cache:Lru/oopssre/imperialschool/viewstv/CacheStore;

    invoke-virtual {v0, p1}, Lru/oopssre/imperialschool/viewstv/CacheStore;->image(Lru/oopssre/imperialschool/viewstv/Protocol$Frame;)Ljava/io/File;

    move-result-object v0

    iget-object v1, p0, Lru/oopssre/imperialschool/viewstv/HttpTransport;->cache:Lru/oopssre/imperialschool/viewstv/CacheStore;

    invoke-virtual {v1, p1}, Lru/oopssre/imperialschool/viewstv/CacheStore;->valid(Lru/oopssre/imperialschool/viewstv/Protocol$Frame;)Z

    move-result v1

    if-eqz v1, :cond_0

    return-object v0

    :cond_0
    iget-object v1, p0, Lru/oopssre/imperialschool/viewstv/HttpTransport;->cache:Lru/oopssre/imperialschool/viewstv/CacheStore;

    iget-wide v2, p1, Lru/oopssre/imperialschool/viewstv/Protocol$Frame;->bytes:J

    invoke-virtual {v1, v2, v3, p2}, Lru/oopssre/imperialschool/viewstv/CacheStore;->reserve(JLjava/lang/String;)V

    .line 41
    iget-object p2, p0, Lru/oopssre/imperialschool/viewstv/HttpTransport;->cache:Lru/oopssre/imperialschool/viewstv/CacheStore;

    iget-object p2, p2, Lru/oopssre/imperialschool/viewstv/CacheStore;->images:Ljava/io/File;

    const-string v1, "frame-"

    const-string v2, ".part"

    invoke-static {v1, v2, p2}, Ljava/io/File;->createTempFile(Ljava/lang/String;Ljava/lang/String;Ljava/io/File;)Ljava/io/File;

    move-result-object v4

    .line 42
    :try_start_0
    iget-object v3, p1, Lru/oopssre/imperialschool/viewstv/Protocol$Frame;->url:Ljava/lang/String;

    iget-wide v5, p1, Lru/oopssre/imperialschool/viewstv/Protocol$Frame;->bytes:J

    const-wide/32 v7, 0x2000000

    invoke-static/range {v3 .. v8}, Lru/oopssre/imperialschool/viewstv/HttpTransport;->download(Ljava/lang/String;Ljava/io/File;JJ)V

    .line 43
    invoke-virtual {v4}, Ljava/io/File;->length()J

    move-result-wide v1

    iget-wide v5, p1, Lru/oopssre/imperialschool/viewstv/Protocol$Frame;->bytes:J

    cmp-long p2, v1, v5

    if-nez p2, :cond_1

    invoke-static {v4}, Lru/oopssre/imperialschool/viewstv/CacheStore;->sha(Ljava/io/File;)Ljava/lang/String;

    move-result-object p2

    iget-object v1, p1, Lru/oopssre/imperialschool/viewstv/Protocol$Frame;->sha:Ljava/lang/String;

    invoke-virtual {p2, v1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p2

    if-eqz p2, :cond_1

    iget-object p1, p1, Lru/oopssre/imperialschool/viewstv/Protocol$Frame;->format:Ljava/lang/String;

    invoke-static {v4, p1}, Lru/oopssre/imperialschool/viewstv/ImageFormat;->signature(Ljava/io/File;Ljava/lang/String;)Z

    move-result p1

    if-eqz p1, :cond_1

    .line 44
    invoke-virtual {v4}, Ljava/io/File;->toPath()Ljava/nio/file/Path;

    move-result-object p1

    invoke-virtual {v0}, Ljava/io/File;->toPath()Ljava/nio/file/Path;

    move-result-object p2

    const/4 v1, 0x2

    new-array v1, v1, [Ljava/nio/file/CopyOption;

    sget-object v2, Ljava/nio/file/StandardCopyOption;->ATOMIC_MOVE:Ljava/nio/file/StandardCopyOption;

    const/4 v3, 0x0

    aput-object v2, v1, v3

    sget-object v2, Ljava/nio/file/StandardCopyOption;->REPLACE_EXISTING:Ljava/nio/file/StandardCopyOption;

    const/4 v3, 0x1

    aput-object v2, v1, v3

    invoke-static {p1, p2, v1}, Ljava/nio/file/Files;->move(Ljava/nio/file/Path;Ljava/nio/file/Path;[Ljava/nio/file/CopyOption;)Ljava/nio/file/Path;
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 45
    invoke-virtual {v4}, Ljava/io/File;->delete()Z

    return-object v0

    .line 43
    :cond_1
    :try_start_1
    new-instance p1, Ljava/io/IOException;

    const-string p2, "\u041a\u0430\u0434\u0440 \u0438\u0437\u043c\u0435\u043d\u0438\u043b\u0441\u044f \u043f\u0440\u0438 \u0437\u0430\u0433\u0440\u0443\u0437\u043a\u0435 \u0438\u043b\u0438 \u043f\u043e\u0432\u0440\u0435\u0436\u0434\u0451\u043d"

    invoke-direct {p1, p2}, Ljava/io/IOException;-><init>(Ljava/lang/String;)V

    throw p1
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    :catchall_0
    move-exception v0

    move-object p1, v0

    .line 45
    invoke-virtual {v4}, Ljava/io/File;->delete()Z

    throw p1
.end method

.method public json(Ljava/lang/String;ZLjava/lang/String;)Lorg/json/JSONObject;
    .locals 17
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/io/IOException;,
            Lorg/json/JSONException;
        }
    .end annotation

    move-object/from16 v1, p0

    .line 18
    const-string v0, ""

    invoke-static/range {p1 .. p1}, Lru/oopssre/imperialschool/viewstv/Protocol;->url(Ljava/lang/String;)Ljava/net/URI;

    move-result-object v2

    invoke-virtual {v2}, Ljava/net/URI;->toString()Ljava/lang/String;

    move-result-object v3

    sget-object v4, Ljava/nio/charset/StandardCharsets;->UTF_8:Ljava/nio/charset/Charset;

    invoke-virtual {v3, v4}, Ljava/lang/String;->getBytes(Ljava/nio/charset/Charset;)[B

    move-result-object v3

    invoke-static {v3}, Lru/oopssre/imperialschool/viewstv/CacheStore;->hash([B)Ljava/lang/String;

    move-result-object v3

    new-instance v4, Ljava/io/File;

    iget-object v5, v1, Lru/oopssre/imperialschool/viewstv/HttpTransport;->cache:Lru/oopssre/imperialschool/viewstv/CacheStore;

    iget-object v5, v5, Lru/oopssre/imperialschool/viewstv/CacheStore;->json:Ljava/io/File;

    new-instance v6, Ljava/lang/StringBuilder;

    invoke-direct {v6}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v6, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v6

    const-string v7, ".body"

    invoke-virtual {v6, v7}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v6

    invoke-virtual {v6}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v6

    invoke-direct {v4, v5, v6}, Ljava/io/File;-><init>(Ljava/io/File;Ljava/lang/String;)V

    new-instance v5, Ljava/io/File;

    iget-object v6, v1, Lru/oopssre/imperialschool/viewstv/HttpTransport;->cache:Lru/oopssre/imperialschool/viewstv/CacheStore;

    iget-object v6, v6, Lru/oopssre/imperialschool/viewstv/CacheStore;->json:Ljava/io/File;

    new-instance v7, Ljava/lang/StringBuilder;

    invoke-direct {v7}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v7, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v7

    const-string v8, ".meta"

    invoke-virtual {v7, v8}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v7

    invoke-virtual {v7}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v7

    invoke-direct {v5, v6, v7}, Ljava/io/File;-><init>(Ljava/io/File;Ljava/lang/String;)V

    :try_start_0
    new-instance v6, Lorg/json/JSONObject;

    new-instance v7, Ljava/lang/String;

    const-wide/16 v8, 0x2710

    invoke-static {v5, v8, v9}, Lru/oopssre/imperialschool/viewstv/CacheStore;->read(Ljava/io/File;J)[B

    move-result-object v8

    sget-object v9, Ljava/nio/charset/StandardCharsets;->UTF_8:Ljava/nio/charset/Charset;

    invoke-direct {v7, v8, v9}, Ljava/lang/String;-><init>([BLjava/nio/charset/Charset;)V

    invoke-direct {v6, v7}, Lorg/json/JSONObject;-><init>(Ljava/lang/String;)V
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    goto :goto_0

    :catch_0
    const/4 v6, 0x0

    :goto_0
    const/4 v8, 0x0

    :goto_1
    const/4 v9, 0x4

    if-ge v8, v9, :cond_12

    const/4 v9, 0x1

    .line 20
    invoke-static {v2, v9}, Lru/oopssre/imperialschool/viewstv/HttpTransport;->connect(Ljava/net/URI;Z)Ljava/net/HttpURLConnection;

    move-result-object v10

    .line 21
    const-string v11, "modified"

    const-string v12, "etag"

    if-nez p2, :cond_1

    if-eqz v6, :cond_1

    invoke-virtual {v4}, Ljava/io/File;->isFile()Z

    move-result v13

    if-eqz v13, :cond_1

    invoke-virtual {v6, v12}, Lorg/json/JSONObject;->optString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v13

    invoke-virtual {v13}, Ljava/lang/String;->isEmpty()Z

    move-result v14

    if-nez v14, :cond_0

    const-string v14, "If-None-Match"

    invoke-virtual {v10, v14, v13}, Ljava/net/HttpURLConnection;->setRequestProperty(Ljava/lang/String;Ljava/lang/String;)V

    :cond_0
    invoke-virtual {v6, v11}, Lorg/json/JSONObject;->optString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v13

    invoke-virtual {v13}, Ljava/lang/String;->isEmpty()Z

    move-result v14

    if-nez v14, :cond_1

    const-string v14, "If-Modified-Since"

    invoke-virtual {v10, v14, v13}, Ljava/net/HttpURLConnection;->setRequestProperty(Ljava/lang/String;Ljava/lang/String;)V

    :cond_1
    if-eqz p2, :cond_2

    .line 22
    const-string v13, "Cache-Control"

    const-string v14, "no-cache"

    invoke-virtual {v10, v13, v14}, Ljava/net/HttpURLConnection;->setRequestProperty(Ljava/lang/String;Ljava/lang/String;)V

    .line 24
    :cond_2
    :try_start_1
    invoke-virtual {v10}, Ljava/net/HttpURLConnection;->getResponseCode()I

    move-result v13

    const/16 v14, 0x130

    move v15, v8

    const-wide/32 v7, 0x500000

    if-ne v13, v14, :cond_3

    new-instance v0, Lorg/json/JSONObject;

    new-instance v2, Ljava/lang/String;

    invoke-static {v4, v7, v8}, Lru/oopssre/imperialschool/viewstv/CacheStore;->read(Ljava/io/File;J)[B

    move-result-object v3

    sget-object v5, Ljava/nio/charset/StandardCharsets;->UTF_8:Ljava/nio/charset/Charset;

    invoke-direct {v2, v3, v5}, Ljava/lang/String;-><init>([BLjava/nio/charset/Charset;)V

    invoke-direct {v0, v2}, Lorg/json/JSONObject;-><init>(Ljava/lang/String;)V

    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J

    move-result-wide v2

    invoke-virtual {v4, v2, v3}, Ljava/io/File;->setLastModified(J)Z
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_4

    .line 35
    invoke-virtual {v10}, Ljava/net/HttpURLConnection;->disconnect()V

    return-object v0

    :cond_3
    const/16 v14, 0x12c

    if-lt v13, v14, :cond_5

    const/16 v14, 0x190

    if-ge v13, v14, :cond_5

    .line 25
    :try_start_2
    const-string v7, "Location"

    invoke-virtual {v10, v7}, Ljava/net/HttpURLConnection;->getHeaderField(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v7

    if-eqz v7, :cond_4

    invoke-virtual {v2, v7}, Ljava/net/URI;->resolve(Ljava/lang/String;)Ljava/net/URI;

    move-result-object v2

    invoke-virtual {v2}, Ljava/net/URI;->toString()Ljava/lang/String;

    move-result-object v2

    invoke-static {v2}, Lru/oopssre/imperialschool/viewstv/Protocol;->url(Ljava/lang/String;)Ljava/net/URI;

    move-result-object v2
    :try_end_2
    .catchall {:try_start_2 .. :try_end_2} :catchall_4

    .line 35
    invoke-virtual {v10}, Ljava/net/HttpURLConnection;->disconnect()V

    add-int/lit8 v8, v15, 0x1

    goto/16 :goto_1

    .line 25
    :cond_4
    :try_start_3
    new-instance v0, Ljava/io/IOException;

    const-string v2, "\u041d\u0435\u0442 \u0430\u0434\u0440\u0435\u0441\u0430 \u043f\u0435\u0440\u0435\u043d\u0430\u043f\u0440\u0430\u0432\u043b\u0435\u043d\u0438\u044f"

    invoke-direct {v0, v2}, Ljava/io/IOException;-><init>(Ljava/lang/String;)V

    throw v0

    :cond_5
    const/16 v6, 0xc8

    if-ne v13, v6, :cond_11

    .line 27
    invoke-virtual {v10}, Ljava/net/HttpURLConnection;->getContentLengthLong()J

    move-result-wide v13

    cmp-long v6, v13, v7

    if-gtz v6, :cond_10

    .line 28
    invoke-virtual {v10}, Ljava/net/HttpURLConnection;->getInputStream()Ljava/io/InputStream;

    move-result-object v6
    :try_end_3
    .catchall {:try_start_3 .. :try_end_3} :catchall_4

    :try_start_4
    invoke-static {v6, v7, v8}, Lru/oopssre/imperialschool/viewstv/CacheStore;->bounded(Ljava/io/InputStream;J)[B

    move-result-object v13
    :try_end_4
    .catchall {:try_start_4 .. :try_end_4} :catchall_2

    if-eqz v6, :cond_6

    :try_start_5
    invoke-virtual {v6}, Ljava/io/InputStream;->close()V

    .line 29
    :cond_6
    const-string v6, "Content-Encoding"

    invoke-virtual {v10, v6}, Ljava/net/HttpURLConnection;->getHeaderField(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v6

    new-instance v14, Ljava/util/ArrayList;

    invoke-direct {v14}, Ljava/util/ArrayList;-><init>()V

    if-eqz v6, :cond_8

    const-string v15, ","

    invoke-virtual {v6, v15}, Ljava/lang/String;->split(Ljava/lang/String;)[Ljava/lang/String;

    move-result-object v6

    array-length v15, v6

    const/4 v9, 0x0

    :goto_2
    if-ge v9, v15, :cond_8

    aget-object v16, v6, v9

    invoke-virtual/range {v16 .. v16}, Ljava/lang/String;->trim()Ljava/lang/String;

    move-result-object v7

    sget-object v8, Ljava/util/Locale;->ROOT:Ljava/util/Locale;

    invoke-virtual {v7, v8}, Ljava/lang/String;->toLowerCase(Ljava/util/Locale;)Ljava/lang/String;

    move-result-object v7

    invoke-virtual {v7}, Ljava/lang/String;->isEmpty()Z

    move-result v8

    if-nez v8, :cond_7

    const-string v8, "identity"

    invoke-virtual {v7, v8}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v8

    if-nez v8, :cond_7

    invoke-interface {v14, v7}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    :cond_7
    add-int/lit8 v9, v9, 0x1

    const-wide/32 v7, 0x500000

    goto :goto_2

    .line 30
    :cond_8
    invoke-interface {v14}, Ljava/util/List;->size()I

    move-result v6
    :try_end_5
    .catchall {:try_start_5 .. :try_end_5} :catchall_4

    const/4 v7, 0x2

    const-string v8, "\u041d\u0435\u0438\u0437\u0432\u0435\u0441\u0442\u043d\u043e\u0435 \u0441\u0436\u0430\u0442\u0438\u0435 \u043e\u043f\u0438\u0441\u0430\u043d\u0438\u044f"

    if-gt v6, v7, :cond_e

    :try_start_6
    invoke-virtual {v2}, Ljava/net/URI;->getPath()Ljava/lang/String;

    move-result-object v2

    const-string v6, ".json.br"

    invoke-virtual {v2, v6}, Ljava/lang/String;->endsWith(Ljava/lang/String;)Z

    move-result v2
    :try_end_6
    .catchall {:try_start_6 .. :try_end_6} :catchall_4

    const-string v6, "br"

    if-eqz v2, :cond_9

    :try_start_7
    invoke-interface {v14, v6}, Ljava/util/List;->contains(Ljava/lang/Object;)Z

    move-result v2

    if-nez v2, :cond_9

    const/4 v7, 0x1

    goto :goto_3

    :cond_9
    const/4 v7, 0x0

    :goto_3
    invoke-static {v14}, Ljava/util/Collections;->reverse(Ljava/util/List;)V

    if-eqz v7, :cond_a

    invoke-interface {v14, v6}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    .line 31
    :cond_a
    invoke-interface {v14}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object v2

    :goto_4
    invoke-interface {v2}, Ljava/util/Iterator;->hasNext()Z

    move-result v7

    if-eqz v7, :cond_d

    invoke-interface {v2}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v7

    check-cast v7, Ljava/lang/String;

    invoke-virtual {v7, v6}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v9

    if-eqz v9, :cond_b

    new-instance v7, Lorg/brotli/dec/BrotliInputStream;

    new-instance v9, Ljava/io/ByteArrayInputStream;

    invoke-direct {v9, v13}, Ljava/io/ByteArrayInputStream;-><init>([B)V

    invoke-direct {v7, v9}, Lorg/brotli/dec/BrotliInputStream;-><init>(Ljava/io/InputStream;)V

    :goto_5
    const-wide/32 v13, 0x500000

    goto :goto_6

    :cond_b
    const-string v9, "gzip"

    invoke-virtual {v7, v9}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v7

    if-eqz v7, :cond_c

    new-instance v7, Ljava/util/zip/GZIPInputStream;

    new-instance v9, Ljava/io/ByteArrayInputStream;

    invoke-direct {v9, v13}, Ljava/io/ByteArrayInputStream;-><init>([B)V

    invoke-direct {v7, v9}, Ljava/util/zip/GZIPInputStream;-><init>(Ljava/io/InputStream;)V
    :try_end_7
    .catchall {:try_start_7 .. :try_end_7} :catchall_4

    goto :goto_5

    :goto_6
    :try_start_8
    invoke-static {v7, v13, v14}, Lru/oopssre/imperialschool/viewstv/CacheStore;->bounded(Ljava/io/InputStream;J)[B

    move-result-object v9
    :try_end_8
    .catchall {:try_start_8 .. :try_end_8} :catchall_0

    :try_start_9
    invoke-virtual {v7}, Ljava/io/InputStream;->close()V
    :try_end_9
    .catchall {:try_start_9 .. :try_end_9} :catchall_4

    move-object v13, v9

    goto :goto_4

    :catchall_0
    move-exception v0

    move-object v2, v0

    :try_start_a
    invoke-virtual {v7}, Ljava/io/InputStream;->close()V
    :try_end_a
    .catchall {:try_start_a .. :try_end_a} :catchall_1

    goto :goto_7

    :catchall_1
    move-exception v0

    :try_start_b
    invoke-virtual {v2, v0}, Ljava/lang/Throwable;->addSuppressed(Ljava/lang/Throwable;)V

    :goto_7
    throw v2

    :cond_c
    new-instance v0, Ljava/io/IOException;

    invoke-direct {v0, v8}, Ljava/io/IOException;-><init>(Ljava/lang/String;)V

    throw v0

    .line 32
    :cond_d
    new-instance v2, Lorg/json/JSONObject;

    new-instance v6, Ljava/lang/String;

    sget-object v7, Ljava/nio/charset/StandardCharsets;->UTF_8:Ljava/nio/charset/Charset;

    invoke-direct {v6, v13, v7}, Ljava/lang/String;-><init>([BLjava/nio/charset/Charset;)V

    invoke-direct {v2, v6}, Lorg/json/JSONObject;-><init>(Ljava/lang/String;)V

    .line 33
    invoke-virtual {v1, v3}, Lru/oopssre/imperialschool/viewstv/HttpTransport;->pruneJson(Ljava/lang/String;)V

    iget-object v3, v1, Lru/oopssre/imperialschool/viewstv/HttpTransport;->cache:Lru/oopssre/imperialschool/viewstv/CacheStore;

    array-length v6, v13

    add-int/lit16 v6, v6, 0x2710

    int-to-long v6, v6

    move-object/from16 v8, p3

    invoke-virtual {v3, v6, v7, v8}, Lru/oopssre/imperialschool/viewstv/CacheStore;->reserve(JLjava/lang/String;)V

    invoke-static {v4, v13}, Lru/oopssre/imperialschool/viewstv/CacheStore;->atomic(Ljava/io/File;[B)V

    .line 34
    new-instance v3, Lorg/json/JSONObject;

    invoke-direct {v3}, Lorg/json/JSONObject;-><init>()V

    const-string v4, "ETag"

    invoke-virtual {v10, v4}, Ljava/net/HttpURLConnection;->getHeaderField(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v4

    invoke-static {v4, v0}, Ljava/util/Objects;->toString(Ljava/lang/Object;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v4

    invoke-virtual {v3, v12, v4}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;

    move-result-object v3

    const-string v4, "Last-Modified"

    invoke-virtual {v10, v4}, Ljava/net/HttpURLConnection;->getHeaderField(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v4

    invoke-static {v4, v0}, Ljava/util/Objects;->toString(Ljava/lang/Object;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    invoke-virtual {v3, v11, v0}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;

    move-result-object v0

    invoke-virtual {v0}, Lorg/json/JSONObject;->toString()Ljava/lang/String;

    move-result-object v0

    sget-object v3, Ljava/nio/charset/StandardCharsets;->UTF_8:Ljava/nio/charset/Charset;

    invoke-virtual {v0, v3}, Ljava/lang/String;->getBytes(Ljava/nio/charset/Charset;)[B

    move-result-object v0

    invoke-static {v5, v0}, Lru/oopssre/imperialschool/viewstv/CacheStore;->atomic(Ljava/io/File;[B)V
    :try_end_b
    .catchall {:try_start_b .. :try_end_b} :catchall_4

    .line 35
    invoke-virtual {v10}, Ljava/net/HttpURLConnection;->disconnect()V

    return-object v2

    .line 30
    :cond_e
    :try_start_c
    new-instance v0, Ljava/io/IOException;

    invoke-direct {v0, v8}, Ljava/io/IOException;-><init>(Ljava/lang/String;)V

    throw v0
    :try_end_c
    .catchall {:try_start_c .. :try_end_c} :catchall_4

    :catchall_2
    move-exception v0

    move-object v2, v0

    if-eqz v6, :cond_f

    .line 28
    :try_start_d
    invoke-virtual {v6}, Ljava/io/InputStream;->close()V
    :try_end_d
    .catchall {:try_start_d .. :try_end_d} :catchall_3

    goto :goto_8

    :catchall_3
    move-exception v0

    :try_start_e
    invoke-virtual {v2, v0}, Ljava/lang/Throwable;->addSuppressed(Ljava/lang/Throwable;)V

    :cond_f
    :goto_8
    throw v2

    .line 27
    :cond_10
    new-instance v0, Ljava/io/IOException;

    const-string v2, "\u041e\u043f\u0438\u0441\u0430\u043d\u0438\u0435 \u0441\u043b\u0438\u0448\u043a\u043e\u043c \u0431\u043e\u043b\u044c\u0448\u043e\u0435"

    invoke-direct {v0, v2}, Ljava/io/IOException;-><init>(Ljava/lang/String;)V

    throw v0

    .line 26
    :cond_11
    new-instance v0, Lru/oopssre/imperialschool/viewstv/HttpTransport$HttpFailure;

    invoke-direct {v0, v13}, Lru/oopssre/imperialschool/viewstv/HttpTransport$HttpFailure;-><init>(I)V

    throw v0
    :try_end_e
    .catchall {:try_start_e .. :try_end_e} :catchall_4

    :catchall_4
    move-exception v0

    .line 35
    invoke-virtual {v10}, Ljava/net/HttpURLConnection;->disconnect()V

    throw v0

    .line 36
    :cond_12
    new-instance v0, Ljava/io/IOException;

    const-string v2, "\u0421\u043b\u0438\u0448\u043a\u043e\u043c \u043c\u043d\u043e\u0433\u043e \u043f\u0435\u0440\u0435\u043d\u0430\u043f\u0440\u0430\u0432\u043b\u0435\u043d\u0438\u0439"

    invoke-direct {v0, v2}, Ljava/io/IOException;-><init>(Ljava/lang/String;)V

    throw v0
.end method

.method pruneJson(Ljava/lang/String;)V
    .locals 7

    .line 38
    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/HttpTransport;->cache:Lru/oopssre/imperialschool/viewstv/CacheStore;

    iget-object v0, v0, Lru/oopssre/imperialschool/viewstv/CacheStore;->json:Ljava/io/File;

    invoke-virtual {v0}, Ljava/io/File;->listFiles()[Ljava/io/File;

    move-result-object v0

    if-nez v0, :cond_0

    goto :goto_2

    :cond_0
    new-instance v1, Ljava/util/ArrayList;

    invoke-static {v0}, Ljava/util/Arrays;->asList([Ljava/lang/Object;)Ljava/util/List;

    move-result-object v0

    invoke-direct {v1, v0}, Ljava/util/ArrayList;-><init>(Ljava/util/Collection;)V

    new-instance v0, Lru/oopssre/imperialschool/viewstv/HttpTransport$$ExternalSyntheticLambda0;

    invoke-direct {v0}, Lru/oopssre/imperialschool/viewstv/HttpTransport$$ExternalSyntheticLambda0;-><init>()V

    invoke-static {v0}, Ljava/util/Comparator;->comparingLong(Ljava/util/function/ToLongFunction;)Ljava/util/Comparator;

    move-result-object v0

    invoke-interface {v1, v0}, Ljava/util/List;->sort(Ljava/util/Comparator;)V

    invoke-interface {v1}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object v0

    const-wide/16 v2, 0x0

    :goto_0
    invoke-interface {v0}, Ljava/util/Iterator;->hasNext()Z

    move-result v4

    if-eqz v4, :cond_1

    invoke-interface {v0}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v4

    check-cast v4, Ljava/io/File;

    invoke-virtual {v4}, Ljava/io/File;->length()J

    move-result-wide v4

    add-long/2addr v2, v4

    goto :goto_0

    :cond_1
    invoke-interface {v1}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object v0

    :cond_2
    :goto_1
    invoke-interface {v0}, Ljava/util/Iterator;->hasNext()Z

    move-result v4

    if-eqz v4, :cond_5

    invoke-interface {v0}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v4

    check-cast v4, Ljava/io/File;

    const-wide/32 v5, 0x200000

    cmp-long v5, v2, v5

    if-gez v5, :cond_3

    invoke-interface {v1}, Ljava/util/List;->size()I

    move-result v5

    const/16 v6, 0x64

    if-ge v5, v6, :cond_3

    goto :goto_2

    :cond_3
    invoke-virtual {v4}, Ljava/io/File;->getName()Ljava/lang/String;

    move-result-object v5

    invoke-virtual {v5, p1}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z

    move-result v5

    if-eqz v5, :cond_4

    goto :goto_1

    :cond_4
    invoke-virtual {v4}, Ljava/io/File;->length()J

    move-result-wide v5

    invoke-virtual {v4}, Ljava/io/File;->delete()Z

    move-result v4

    if-eqz v4, :cond_2

    sub-long/2addr v2, v5

    goto :goto_1

    :cond_5
    :goto_2
    return-void
.end method

.method public video(Lru/oopssre/imperialschool/viewstv/VideoInfo;Ljava/lang/String;)Ljava/io/File;
    .locals 9
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/io/IOException;
        }
    .end annotation

    .line 48
    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/HttpTransport;->cache:Lru/oopssre/imperialschool/viewstv/CacheStore;

    iget-object v1, p1, Lru/oopssre/imperialschool/viewstv/VideoInfo;->sha:Ljava/lang/String;

    invoke-virtual {v0, v1}, Lru/oopssre/imperialschool/viewstv/CacheStore;->video(Ljava/lang/String;)Ljava/io/File;

    move-result-object v0

    iget-object v1, p0, Lru/oopssre/imperialschool/viewstv/HttpTransport;->cache:Lru/oopssre/imperialschool/viewstv/CacheStore;

    invoke-virtual {v1, p1}, Lru/oopssre/imperialschool/viewstv/CacheStore;->valid(Lru/oopssre/imperialschool/viewstv/VideoInfo;)Z

    move-result v1

    if-eqz v1, :cond_0

    return-object v0

    :cond_0
    iget-object v1, p0, Lru/oopssre/imperialschool/viewstv/HttpTransport;->cache:Lru/oopssre/imperialschool/viewstv/CacheStore;

    iget-wide v2, p1, Lru/oopssre/imperialschool/viewstv/VideoInfo;->bytes:J

    invoke-virtual {v1, v2, v3, p2}, Lru/oopssre/imperialschool/viewstv/CacheStore;->reserve(JLjava/lang/String;)V

    .line 49
    iget-object p2, p0, Lru/oopssre/imperialschool/viewstv/HttpTransport;->cache:Lru/oopssre/imperialschool/viewstv/CacheStore;

    iget-object p2, p2, Lru/oopssre/imperialschool/viewstv/CacheStore;->videos:Ljava/io/File;

    const-string v1, "video-"

    const-string v2, ".part"

    invoke-static {v1, v2, p2}, Ljava/io/File;->createTempFile(Ljava/lang/String;Ljava/lang/String;Ljava/io/File;)Ljava/io/File;

    move-result-object v4

    .line 50
    :try_start_0
    iget-object v3, p1, Lru/oopssre/imperialschool/viewstv/VideoInfo;->url:Ljava/lang/String;

    iget-wide v5, p1, Lru/oopssre/imperialschool/viewstv/VideoInfo;->bytes:J

    const-wide/32 v7, 0x2000000

    invoke-static/range {v3 .. v8}, Lru/oopssre/imperialschool/viewstv/HttpTransport;->download(Ljava/lang/String;Ljava/io/File;JJ)V

    .line 51
    invoke-virtual {v4}, Ljava/io/File;->length()J

    move-result-wide v1

    iget-wide v5, p1, Lru/oopssre/imperialschool/viewstv/VideoInfo;->bytes:J

    cmp-long p2, v1, v5

    if-nez p2, :cond_1

    invoke-static {v4}, Lru/oopssre/imperialschool/viewstv/CacheStore;->sha(Ljava/io/File;)Ljava/lang/String;

    move-result-object p2

    iget-object p1, p1, Lru/oopssre/imperialschool/viewstv/VideoInfo;->sha:Ljava/lang/String;

    invoke-virtual {p2, p1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p1

    if-eqz p1, :cond_1

    .line 52
    invoke-virtual {v4}, Ljava/io/File;->toPath()Ljava/nio/file/Path;

    move-result-object p1

    invoke-virtual {v0}, Ljava/io/File;->toPath()Ljava/nio/file/Path;

    move-result-object p2

    const/4 v1, 0x2

    new-array v1, v1, [Ljava/nio/file/CopyOption;

    sget-object v2, Ljava/nio/file/StandardCopyOption;->ATOMIC_MOVE:Ljava/nio/file/StandardCopyOption;

    const/4 v3, 0x0

    aput-object v2, v1, v3

    sget-object v2, Ljava/nio/file/StandardCopyOption;->REPLACE_EXISTING:Ljava/nio/file/StandardCopyOption;

    const/4 v3, 0x1

    aput-object v2, v1, v3

    invoke-static {p1, p2, v1}, Ljava/nio/file/Files;->move(Ljava/nio/file/Path;Ljava/nio/file/Path;[Ljava/nio/file/CopyOption;)Ljava/nio/file/Path;
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 53
    invoke-virtual {v4}, Ljava/io/File;->delete()Z

    return-object v0

    .line 51
    :cond_1
    :try_start_1
    new-instance p1, Ljava/io/IOException;

    const-string p2, "\u0412\u0438\u0434\u0435\u043e \u0438\u0437\u043c\u0435\u043d\u0438\u043b\u043e\u0441\u044c \u043f\u0440\u0438 \u0437\u0430\u0433\u0440\u0443\u0437\u043a\u0435 \u0438\u043b\u0438 \u043f\u043e\u0432\u0440\u0435\u0436\u0434\u0435\u043d\u043e"

    invoke-direct {p1, p2}, Ljava/io/IOException;-><init>(Ljava/lang/String;)V

    throw p1
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    :catchall_0
    move-exception v0

    move-object p1, v0

    .line 53
    invoke-virtual {v4}, Ljava/io/File;->delete()Z

    throw p1
.end method
