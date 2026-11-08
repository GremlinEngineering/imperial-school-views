.class public final Lru/oopssre/imperialschool/viewstv/CacheStore;
.super Ljava/lang/Object;
.source "CacheStore.java"


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lru/oopssre/imperialschool/viewstv/CacheStore$SpaceException;
    }
.end annotation


# static fields
.field private static final LOCK:Ljava/lang/Object;

.field private static final MEDIA_PINS:Ljava/util/Map;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/Map<",
            "Ljava/lang/String;",
            "Ljava/lang/Integer;",
            ">;"
        }
    .end annotation
.end field


# instance fields
.field public final images:Ljava/io/File;

.field public final json:Ljava/io/File;

.field public final root:Ljava/io/File;

.field public final videos:Ljava/io/File;


# direct methods
.method public static synthetic $r8$lambda$j-up7tewrnlbWwuTORbAT_7hFYM(Ljava/io/File;)J
    .locals 2

    invoke-virtual {p0}, Ljava/io/File;->lastModified()J

    move-result-wide v0

    return-wide v0
.end method

.method static constructor <clinit>()V
    .locals 1

    .line 16
    new-instance v0, Ljava/lang/Object;

    invoke-direct {v0}, Ljava/lang/Object;-><init>()V

    sput-object v0, Lru/oopssre/imperialschool/viewstv/CacheStore;->LOCK:Ljava/lang/Object;

    .line 17
    new-instance v0, Ljava/util/HashMap;

    invoke-direct {v0}, Ljava/util/HashMap;-><init>()V

    sput-object v0, Lru/oopssre/imperialschool/viewstv/CacheStore;->MEDIA_PINS:Ljava/util/Map;

    return-void
.end method

.method public constructor <init>(Ljava/io/File;)V
    .locals 4

    .line 19
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    new-instance v0, Ljava/io/File;

    const-string v1, "imperial-tv"

    invoke-direct {v0, p1, v1}, Ljava/io/File;-><init>(Ljava/io/File;Ljava/lang/String;)V

    iput-object v0, p0, Lru/oopssre/imperialschool/viewstv/CacheStore;->root:Ljava/io/File;

    new-instance p1, Ljava/io/File;

    const-string v1, "images"

    invoke-direct {p1, v0, v1}, Ljava/io/File;-><init>(Ljava/io/File;Ljava/lang/String;)V

    iput-object p1, p0, Lru/oopssre/imperialschool/viewstv/CacheStore;->images:Ljava/io/File;

    new-instance v1, Ljava/io/File;

    const-string v2, "videos"

    invoke-direct {v1, v0, v2}, Ljava/io/File;-><init>(Ljava/io/File;Ljava/lang/String;)V

    iput-object v1, p0, Lru/oopssre/imperialschool/viewstv/CacheStore;->videos:Ljava/io/File;

    new-instance v2, Ljava/io/File;

    const-string v3, "json"

    invoke-direct {v2, v0, v3}, Ljava/io/File;-><init>(Ljava/io/File;Ljava/lang/String;)V

    iput-object v2, p0, Lru/oopssre/imperialschool/viewstv/CacheStore;->json:Ljava/io/File;

    invoke-virtual {p1}, Ljava/io/File;->mkdirs()Z

    invoke-virtual {v1}, Ljava/io/File;->mkdirs()Z

    invoke-virtual {v2}, Ljava/io/File;->mkdirs()Z

    invoke-virtual {p0}, Lru/oopssre/imperialschool/viewstv/CacheStore;->cleanupParts()V

    return-void
.end method

.method public static atomic(Ljava/io/File;[B)V
    .locals 4
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/io/IOException;
        }
    .end annotation

    .line 31
    invoke-virtual {p0}, Ljava/io/File;->getParentFile()Ljava/io/File;

    move-result-object v0

    invoke-virtual {v0}, Ljava/io/File;->mkdirs()Z

    const-string v0, ".part"

    invoke-virtual {p0}, Ljava/io/File;->getParentFile()Ljava/io/File;

    move-result-object v1

    const-string v2, "pending-"

    invoke-static {v2, v0, v1}, Ljava/io/File;->createTempFile(Ljava/lang/String;Ljava/lang/String;Ljava/io/File;)Ljava/io/File;

    move-result-object v0

    :try_start_0
    new-instance v1, Ljava/io/FileOutputStream;

    invoke-direct {v1, v0}, Ljava/io/FileOutputStream;-><init>(Ljava/io/File;)V
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_2

    :try_start_1
    invoke-virtual {v1, p1}, Ljava/io/FileOutputStream;->write([B)V

    invoke-virtual {v1}, Ljava/io/FileOutputStream;->getFD()Ljava/io/FileDescriptor;

    move-result-object p1

    invoke-virtual {p1}, Ljava/io/FileDescriptor;->sync()V
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    :try_start_2
    invoke-virtual {v1}, Ljava/io/FileOutputStream;->close()V

    invoke-virtual {v0}, Ljava/io/File;->toPath()Ljava/nio/file/Path;

    move-result-object p1

    invoke-virtual {p0}, Ljava/io/File;->toPath()Ljava/nio/file/Path;

    move-result-object p0

    const/4 v1, 0x2

    new-array v1, v1, [Ljava/nio/file/CopyOption;

    sget-object v2, Ljava/nio/file/StandardCopyOption;->ATOMIC_MOVE:Ljava/nio/file/StandardCopyOption;

    const/4 v3, 0x0

    aput-object v2, v1, v3

    sget-object v2, Ljava/nio/file/StandardCopyOption;->REPLACE_EXISTING:Ljava/nio/file/StandardCopyOption;

    const/4 v3, 0x1

    aput-object v2, v1, v3

    invoke-static {p1, p0, v1}, Ljava/nio/file/Files;->move(Ljava/nio/file/Path;Ljava/nio/file/Path;[Ljava/nio/file/CopyOption;)Ljava/nio/file/Path;
    :try_end_2
    .catchall {:try_start_2 .. :try_end_2} :catchall_2

    invoke-virtual {v0}, Ljava/io/File;->delete()Z

    return-void

    :catchall_0
    move-exception p0

    :try_start_3
    invoke-virtual {v1}, Ljava/io/FileOutputStream;->close()V
    :try_end_3
    .catchall {:try_start_3 .. :try_end_3} :catchall_1

    goto :goto_0

    :catchall_1
    move-exception p1

    :try_start_4
    invoke-virtual {p0, p1}, Ljava/lang/Throwable;->addSuppressed(Ljava/lang/Throwable;)V

    :goto_0
    throw p0
    :try_end_4
    .catchall {:try_start_4 .. :try_end_4} :catchall_2

    :catchall_2
    move-exception p0

    invoke-virtual {v0}, Ljava/io/File;->delete()Z

    throw p0
.end method

.method static bounded(Ljava/io/InputStream;J)[B
    .locals 7
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/io/IOException;
        }
    .end annotation

    .line 32
    new-instance v0, Ljava/io/ByteArrayOutputStream;

    invoke-direct {v0}, Ljava/io/ByteArrayOutputStream;-><init>()V

    const v1, 0x8000

    new-array v1, v1, [B

    const-wide/16 v2, 0x0

    :goto_0
    invoke-virtual {p0, v1}, Ljava/io/InputStream;->read([B)I

    move-result v4

    const/4 v5, -0x1

    if-eq v4, v5, :cond_2

    invoke-static {}, Ljava/lang/Thread;->currentThread()Ljava/lang/Thread;

    move-result-object v5

    invoke-virtual {v5}, Ljava/lang/Thread;->isInterrupted()Z

    move-result v5

    if-nez v5, :cond_1

    int-to-long v5, v4

    add-long/2addr v2, v5

    cmp-long v5, v2, p1

    if-gtz v5, :cond_0

    const/4 v5, 0x0

    invoke-virtual {v0, v1, v5, v4}, Ljava/io/ByteArrayOutputStream;->write([BII)V

    goto :goto_0

    :cond_0
    new-instance p0, Ljava/io/IOException;

    const-string p1, "\u041e\u0442\u0432\u0435\u0442 \u0441\u0435\u0440\u0432\u0435\u0440\u0430 \u0441\u043b\u0438\u0448\u043a\u043e\u043c \u0431\u043e\u043b\u044c\u0448\u043e\u0439"

    invoke-direct {p0, p1}, Ljava/io/IOException;-><init>(Ljava/lang/String;)V

    throw p0

    :cond_1
    new-instance p0, Ljava/io/InterruptedIOException;

    invoke-direct {p0}, Ljava/io/InterruptedIOException;-><init>()V

    throw p0

    :cond_2
    invoke-virtual {v0}, Ljava/io/ByteArrayOutputStream;->toByteArray()[B

    move-result-object p0

    return-object p0
.end method

.method public static clearDirectory(Ljava/io/File;)V
    .locals 2
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/io/IOException;
        }
    .end annotation

    .line 86
    sget-object v0, Lru/oopssre/imperialschool/viewstv/CacheStore;->LOCK:Ljava/lang/Object;

    monitor-enter v0

    .line 87
    :try_start_0
    sget-object v1, Lru/oopssre/imperialschool/viewstv/CacheStore;->MEDIA_PINS:Ljava/util/Map;

    invoke-interface {v1}, Ljava/util/Map;->isEmpty()Z

    move-result v1

    if-eqz v1, :cond_1

    .line 88
    invoke-virtual {p0}, Ljava/io/File;->isDirectory()Z

    move-result v1

    if-nez v1, :cond_0

    monitor-exit v0

    return-void

    .line 89
    :cond_0
    invoke-virtual {p0}, Ljava/io/File;->toPath()Ljava/nio/file/Path;

    move-result-object p0

    .line 90
    new-instance v1, Lru/oopssre/imperialschool/viewstv/CacheStore$1;

    invoke-direct {v1, p0}, Lru/oopssre/imperialschool/viewstv/CacheStore$1;-><init>(Ljava/nio/file/Path;)V

    invoke-static {p0, v1}, Ljava/nio/file/Files;->walkFileTree(Ljava/nio/file/Path;Ljava/nio/file/FileVisitor;)Ljava/nio/file/Path;

    .line 94
    monitor-exit v0

    return-void

    .line 87
    :cond_1
    new-instance p0, Ljava/io/IOException;

    const-string v1, "\u041a\u0435\u0448 \u0435\u0449\u0451 \u0438\u0441\u043f\u043e\u043b\u044c\u0437\u0443\u0435\u0442\u0441\u044f. \u041f\u043e\u0432\u0442\u043e\u0440\u0438\u0442\u0435 \u043e\u0447\u0438\u0441\u0442\u043a\u0443."

    invoke-direct {p0, v1}, Ljava/io/IOException;-><init>(Ljava/lang/String;)V

    throw p0

    :catchall_0
    move-exception p0

    .line 94
    monitor-exit v0
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    throw p0
.end method

.method public static directoryBytes(Ljava/io/File;)J
    .locals 6

    .line 79
    invoke-virtual {p0}, Ljava/io/File;->exists()Z

    move-result v0

    const-wide/16 v1, 0x0

    if-nez v0, :cond_0

    return-wide v1

    .line 80
    :cond_0
    invoke-virtual {p0}, Ljava/io/File;->toPath()Ljava/nio/file/Path;

    move-result-object v0

    invoke-static {v0}, Ljava/nio/file/Files;->isSymbolicLink(Ljava/nio/file/Path;)Z

    move-result v0

    if-eqz v0, :cond_1

    return-wide v1

    .line 81
    :cond_1
    invoke-virtual {p0}, Ljava/io/File;->isFile()Z

    move-result v0

    if-eqz v0, :cond_2

    invoke-virtual {p0}, Ljava/io/File;->length()J

    move-result-wide v0

    return-wide v0

    .line 82
    :cond_2
    invoke-virtual {p0}, Ljava/io/File;->listFiles()[Ljava/io/File;

    move-result-object p0

    if-eqz p0, :cond_3

    array-length v0, p0

    const/4 v3, 0x0

    :goto_0
    if-ge v3, v0, :cond_3

    aget-object v4, p0, v3

    invoke-static {v4}, Lru/oopssre/imperialschool/viewstv/CacheStore;->directoryBytes(Ljava/io/File;)J

    move-result-wide v4

    add-long/2addr v1, v4

    add-int/lit8 v3, v3, 0x1

    goto :goto_0

    :cond_3
    return-wide v1
.end method

.method static hash([B)Ljava/lang/String;
    .locals 1

    .line 28
    :try_start_0
    const-string v0, "SHA-256"

    invoke-static {v0}, Ljava/security/MessageDigest;->getInstance(Ljava/lang/String;)Ljava/security/MessageDigest;

    move-result-object v0

    invoke-virtual {v0, p0}, Ljava/security/MessageDigest;->digest([B)[B

    move-result-object p0

    invoke-static {p0}, Lru/oopssre/imperialschool/viewstv/CacheStore;->hex([B)Ljava/lang/String;

    move-result-object p0
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    return-object p0

    :catch_0
    move-exception p0

    new-instance v0, Ljava/lang/IllegalStateException;

    invoke-direct {v0, p0}, Ljava/lang/IllegalStateException;-><init>(Ljava/lang/Throwable;)V

    throw v0
.end method

.method static hex([B)Ljava/lang/String;
    .locals 6

    .line 29
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    array-length v1, p0

    const/4 v2, 0x0

    :goto_0
    if-ge v2, v1, :cond_0

    aget-byte v3, p0, v2

    sget-object v4, Ljava/util/Locale;->ROOT:Ljava/util/Locale;

    and-int/lit16 v3, v3, 0xff

    invoke-static {v3}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v3

    filled-new-array {v3}, [Ljava/lang/Object;

    move-result-object v3

    const-string v5, "%02x"

    invoke-static {v4, v5, v3}, Ljava/lang/String;->format(Ljava/util/Locale;Ljava/lang/String;[Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v3

    invoke-virtual {v0, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    add-int/lit8 v2, v2, 0x1

    goto :goto_0

    :cond_0
    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method

.method public static read(Ljava/io/File;J)[B
    .locals 2
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/io/IOException;
        }
    .end annotation

    .line 33
    invoke-virtual {p0}, Ljava/io/File;->isFile()Z

    move-result v0

    if-eqz v0, :cond_0

    invoke-virtual {p0}, Ljava/io/File;->length()J

    move-result-wide v0

    cmp-long v0, v0, p1

    if-gtz v0, :cond_0

    new-instance v0, Ljava/io/FileInputStream;

    invoke-direct {v0, p0}, Ljava/io/FileInputStream;-><init>(Ljava/io/File;)V

    :try_start_0
    invoke-static {v0, p1, p2}, Lru/oopssre/imperialschool/viewstv/CacheStore;->bounded(Ljava/io/InputStream;J)[B

    move-result-object p0
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    invoke-virtual {v0}, Ljava/io/InputStream;->close()V

    return-object p0

    :catchall_0
    move-exception p0

    :try_start_1
    invoke-virtual {v0}, Ljava/io/InputStream;->close()V
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_1

    goto :goto_0

    :catchall_1
    move-exception p1

    invoke-virtual {p0, p1}, Ljava/lang/Throwable;->addSuppressed(Ljava/lang/Throwable;)V

    :goto_0
    throw p0

    :cond_0
    new-instance p0, Ljava/io/IOException;

    const-string p1, "\u041d\u0435\u0442 \u0438\u0441\u043f\u0440\u0430\u0432\u043d\u043e\u0433\u043e \u043a\u0435\u0448\u0430"

    invoke-direct {p0, p1}, Ljava/io/IOException;-><init>(Ljava/lang/String;)V

    throw p0
.end method

.method public static sha(Ljava/io/File;)Ljava/lang/String;
    .locals 4
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/io/IOException;
        }
    .end annotation

    .line 30
    :try_start_0
    const-string v0, "SHA-256"

    invoke-static {v0}, Ljava/security/MessageDigest;->getInstance(Ljava/lang/String;)Ljava/security/MessageDigest;

    move-result-object v0

    new-instance v1, Ljava/io/FileInputStream;

    invoke-direct {v1, p0}, Ljava/io/FileInputStream;-><init>(Ljava/io/File;)V
    :try_end_0
    .catch Ljava/security/NoSuchAlgorithmException; {:try_start_0 .. :try_end_0} :catch_0

    const/high16 p0, 0x10000

    :try_start_1
    new-array p0, p0, [B

    :goto_0
    invoke-virtual {v1, p0}, Ljava/io/InputStream;->read([B)I

    move-result v2

    const/4 v3, -0x1

    if-eq v2, v3, :cond_0

    const/4 v3, 0x0

    invoke-virtual {v0, p0, v3, v2}, Ljava/security/MessageDigest;->update([BII)V
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    goto :goto_0

    :cond_0
    :try_start_2
    invoke-virtual {v1}, Ljava/io/InputStream;->close()V

    invoke-virtual {v0}, Ljava/security/MessageDigest;->digest()[B

    move-result-object p0

    invoke-static {p0}, Lru/oopssre/imperialschool/viewstv/CacheStore;->hex([B)Ljava/lang/String;

    move-result-object p0
    :try_end_2
    .catch Ljava/security/NoSuchAlgorithmException; {:try_start_2 .. :try_end_2} :catch_0

    return-object p0

    :catchall_0
    move-exception p0

    :try_start_3
    invoke-virtual {v1}, Ljava/io/InputStream;->close()V
    :try_end_3
    .catchall {:try_start_3 .. :try_end_3} :catchall_1

    goto :goto_1

    :catchall_1
    move-exception v0

    :try_start_4
    invoke-virtual {p0, v0}, Ljava/lang/Throwable;->addSuppressed(Ljava/lang/Throwable;)V

    :goto_1
    throw p0
    :try_end_4
    .catch Ljava/security/NoSuchAlgorithmException; {:try_start_4 .. :try_end_4} :catch_0

    :catch_0
    move-exception p0

    new-instance v0, Ljava/io/IOException;

    invoke-direct {v0, p0}, Ljava/io/IOException;-><init>(Ljava/lang/Throwable;)V

    throw v0
.end method


# virtual methods
.method public bytes()J
    .locals 12

    .line 40
    sget-object v0, Lru/oopssre/imperialschool/viewstv/CacheStore;->LOCK:Ljava/lang/Object;

    monitor-enter v0

    const/4 v1, 0x4

    :try_start_0
    new-array v2, v1, [Ljava/io/File;

    iget-object v3, p0, Lru/oopssre/imperialschool/viewstv/CacheStore;->root:Ljava/io/File;

    const/4 v4, 0x0

    aput-object v3, v2, v4

    iget-object v3, p0, Lru/oopssre/imperialschool/viewstv/CacheStore;->images:Ljava/io/File;

    const/4 v5, 0x1

    aput-object v3, v2, v5

    iget-object v3, p0, Lru/oopssre/imperialschool/viewstv/CacheStore;->videos:Ljava/io/File;

    const/4 v5, 0x2

    aput-object v3, v2, v5

    iget-object v3, p0, Lru/oopssre/imperialschool/viewstv/CacheStore;->json:Ljava/io/File;

    const/4 v5, 0x3

    aput-object v3, v2, v5

    const-wide/16 v5, 0x0

    move v3, v4

    :goto_0
    if-ge v3, v1, :cond_2

    aget-object v7, v2, v3

    invoke-virtual {v7}, Ljava/io/File;->listFiles()[Ljava/io/File;

    move-result-object v7

    if-eqz v7, :cond_1

    array-length v8, v7

    move v9, v4

    :goto_1
    if-ge v9, v8, :cond_1

    aget-object v10, v7, v9

    invoke-virtual {v10}, Ljava/io/File;->isFile()Z

    move-result v11

    if-eqz v11, :cond_0

    invoke-virtual {v10}, Ljava/io/File;->length()J

    move-result-wide v10

    add-long/2addr v5, v10

    :cond_0
    add-int/lit8 v9, v9, 0x1

    goto :goto_1

    :cond_1
    add-int/lit8 v3, v3, 0x1

    goto :goto_0

    :cond_2
    monitor-exit v0

    return-wide v5

    :catchall_0
    move-exception v1

    monitor-exit v0
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    throw v1
.end method

.method public cached(Lru/oopssre/imperialschool/viewstv/Protocol$Theme;)Lru/oopssre/imperialschool/viewstv/Protocol$Frame;
    .locals 6

    .line 37
    sget-object v0, Lru/oopssre/imperialschool/viewstv/CacheStore;->LOCK:Ljava/lang/Object;

    monitor-enter v0

    :try_start_0
    new-instance v1, Lorg/json/JSONObject;

    new-instance v2, Ljava/lang/String;

    iget-object v3, p1, Lru/oopssre/imperialschool/viewstv/Protocol$Theme;->id:Ljava/lang/String;

    iget-object v4, p1, Lru/oopssre/imperialschool/viewstv/Protocol$Theme;->device:Ljava/lang/String;

    invoke-virtual {p0, v3, v4}, Lru/oopssre/imperialschool/viewstv/CacheStore;->snapshot(Ljava/lang/String;Ljava/lang/String;)Ljava/io/File;

    move-result-object v3

    const-wide/32 v4, 0x186a0

    invoke-static {v3, v4, v5}, Lru/oopssre/imperialschool/viewstv/CacheStore;->read(Ljava/io/File;J)[B

    move-result-object v3

    sget-object v4, Ljava/nio/charset/StandardCharsets;->UTF_8:Ljava/nio/charset/Charset;

    invoke-direct {v2, v3, v4}, Ljava/lang/String;-><init>([BLjava/nio/charset/Charset;)V

    invoke-direct {v1, v2}, Lorg/json/JSONObject;-><init>(Ljava/lang/String;)V

    invoke-static {v1}, Lru/oopssre/imperialschool/viewstv/Protocol;->savedFrame(Lorg/json/JSONObject;)Lru/oopssre/imperialschool/viewstv/Protocol$Frame;

    move-result-object v1

    iget-object v2, v1, Lru/oopssre/imperialschool/viewstv/Protocol$Frame;->theme:Ljava/lang/String;

    iget-object v3, p1, Lru/oopssre/imperialschool/viewstv/Protocol$Theme;->id:Ljava/lang/String;

    invoke-virtual {v2, v3}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v2

    if-eqz v2, :cond_0

    iget-object v2, v1, Lru/oopssre/imperialschool/viewstv/Protocol$Frame;->device:Ljava/lang/String;

    iget-object p1, p1, Lru/oopssre/imperialschool/viewstv/Protocol$Theme;->device:Ljava/lang/String;

    invoke-virtual {v2, p1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p1

    if-eqz p1, :cond_0

    invoke-virtual {p0, v1}, Lru/oopssre/imperialschool/viewstv/CacheStore;->valid(Lru/oopssre/imperialschool/viewstv/Protocol$Frame;)Z

    move-result p1

    if-eqz p1, :cond_0

    invoke-virtual {p0, v1}, Lru/oopssre/imperialschool/viewstv/CacheStore;->image(Lru/oopssre/imperialschool/viewstv/Protocol$Frame;)Ljava/io/File;

    move-result-object p1

    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J

    move-result-wide v2

    invoke-virtual {p1, v2, v3}, Ljava/io/File;->setLastModified(J)Z
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    :try_start_1
    monitor-exit v0

    return-object v1

    :catchall_0
    move-exception p1

    goto :goto_0

    :catch_0
    :cond_0
    monitor-exit v0

    const/4 p1, 0x0

    return-object p1

    :goto_0
    monitor-exit v0
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    throw p1
.end method

.method public cachedVideo(Lru/oopssre/imperialschool/viewstv/Protocol$Theme;)Lru/oopssre/imperialschool/viewstv/VideoInfo;
    .locals 8

    const-string v0, "-desktop_3840x2160.json"

    const-string v1, "video-state-"

    .line 27
    sget-object v2, Lru/oopssre/imperialschool/viewstv/CacheStore;->LOCK:Ljava/lang/Object;

    monitor-enter v2

    :try_start_0
    new-instance v3, Lorg/json/JSONObject;

    new-instance v4, Ljava/lang/String;

    new-instance v5, Ljava/io/File;

    iget-object v6, p0, Lru/oopssre/imperialschool/viewstv/CacheStore;->root:Ljava/io/File;

    new-instance v7, Ljava/lang/StringBuilder;

    invoke-direct {v7, v1}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    iget-object v1, p1, Lru/oopssre/imperialschool/viewstv/Protocol$Theme;->id:Ljava/lang/String;

    invoke-virtual {v7, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-direct {v5, v6, v0}, Ljava/io/File;-><init>(Ljava/io/File;Ljava/lang/String;)V

    const-wide/32 v0, 0x186a0

    invoke-static {v5, v0, v1}, Lru/oopssre/imperialschool/viewstv/CacheStore;->read(Ljava/io/File;J)[B

    move-result-object v0

    sget-object v1, Ljava/nio/charset/StandardCharsets;->UTF_8:Ljava/nio/charset/Charset;

    invoke-direct {v4, v0, v1}, Ljava/lang/String;-><init>([BLjava/nio/charset/Charset;)V

    invoke-direct {v3, v4}, Lorg/json/JSONObject;-><init>(Ljava/lang/String;)V

    invoke-static {v3}, Lru/oopssre/imperialschool/viewstv/VideoInfo;->saved(Lorg/json/JSONObject;)Lru/oopssre/imperialschool/viewstv/VideoInfo;

    move-result-object v0

    iget-object v1, v0, Lru/oopssre/imperialschool/viewstv/VideoInfo;->frame:Lru/oopssre/imperialschool/viewstv/Protocol$Frame;

    iget-object v1, v1, Lru/oopssre/imperialschool/viewstv/Protocol$Frame;->theme:Ljava/lang/String;

    iget-object p1, p1, Lru/oopssre/imperialschool/viewstv/Protocol$Theme;->id:Ljava/lang/String;

    invoke-virtual {v1, p1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p1

    if-eqz p1, :cond_0

    invoke-virtual {p0, v0}, Lru/oopssre/imperialschool/viewstv/CacheStore;->valid(Lru/oopssre/imperialschool/viewstv/VideoInfo;)Z

    move-result p1

    if-eqz p1, :cond_0

    iget-object p1, v0, Lru/oopssre/imperialschool/viewstv/VideoInfo;->sha:Ljava/lang/String;

    invoke-virtual {p0, p1}, Lru/oopssre/imperialschool/viewstv/CacheStore;->video(Ljava/lang/String;)Ljava/io/File;

    move-result-object p1

    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J

    move-result-wide v3

    invoke-virtual {p1, v3, v4}, Ljava/io/File;->setLastModified(J)Z
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    :try_start_1
    monitor-exit v2

    return-object v0

    :catchall_0
    move-exception p1

    goto :goto_0

    :catch_0
    :cond_0
    monitor-exit v2

    const/4 p1, 0x0

    return-object p1

    :goto_0
    monitor-exit v2
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    throw p1
.end method

.method cleanupParts()V
    .locals 15

    .line 97
    sget-object v0, Lru/oopssre/imperialschool/viewstv/CacheStore;->LOCK:Ljava/lang/Object;

    monitor-enter v0

    const/4 v1, 0x4

    :try_start_0
    new-array v2, v1, [Ljava/io/File;

    iget-object v3, p0, Lru/oopssre/imperialschool/viewstv/CacheStore;->root:Ljava/io/File;

    const/4 v4, 0x0

    aput-object v3, v2, v4

    iget-object v3, p0, Lru/oopssre/imperialschool/viewstv/CacheStore;->images:Ljava/io/File;

    const/4 v5, 0x1

    aput-object v3, v2, v5

    iget-object v3, p0, Lru/oopssre/imperialschool/viewstv/CacheStore;->videos:Ljava/io/File;

    const/4 v5, 0x2

    aput-object v3, v2, v5

    iget-object v3, p0, Lru/oopssre/imperialschool/viewstv/CacheStore;->json:Ljava/io/File;

    const/4 v5, 0x3

    aput-object v3, v2, v5

    move v3, v4

    :goto_0
    if-ge v3, v1, :cond_2

    aget-object v5, v2, v3

    invoke-virtual {v5}, Ljava/io/File;->listFiles()[Ljava/io/File;

    move-result-object v5

    if-eqz v5, :cond_1

    array-length v6, v5

    move v7, v4

    :goto_1
    if-ge v7, v6, :cond_1

    aget-object v8, v5, v7

    invoke-virtual {v8}, Ljava/io/File;->getName()Ljava/lang/String;

    move-result-object v9

    const-string v10, ".part"

    invoke-virtual {v9, v10}, Ljava/lang/String;->endsWith(Ljava/lang/String;)Z

    move-result v9

    if-eqz v9, :cond_0

    invoke-virtual {v8}, Ljava/io/File;->lastModified()J

    move-result-wide v9

    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J

    move-result-wide v11

    const-wide/32 v13, 0x36ee80

    sub-long/2addr v11, v13

    cmp-long v9, v9, v11

    if-gez v9, :cond_0

    invoke-virtual {v8}, Ljava/io/File;->delete()Z

    :cond_0
    add-int/lit8 v7, v7, 0x1

    goto :goto_1

    :cond_1
    add-int/lit8 v3, v3, 0x1

    goto :goto_0

    :cond_2
    monitor-exit v0

    return-void

    :catchall_0
    move-exception v1

    monitor-exit v0
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    throw v1
.end method

.method public image(Ljava/lang/String;)Ljava/io/File;
    .locals 3

    .line 34
    invoke-static {p1}, Lru/oopssre/imperialschool/viewstv/Protocol;->hash(Ljava/lang/String;)Z

    move-result v0

    const-string v1, "\u041d\u0435\u0432\u0435\u0440\u043d\u044b\u0439 \u0445\u0435\u0448"

    invoke-static {v0, v1}, Lru/oopssre/imperialschool/viewstv/Protocol;->require(ZLjava/lang/String;)V

    new-instance v0, Ljava/io/File;

    iget-object v1, p0, Lru/oopssre/imperialschool/viewstv/CacheStore;->images:Ljava/io/File;

    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v2, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p1

    const-string v2, ".jpg"

    invoke-virtual {p1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p1

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-direct {v0, v1, p1}, Ljava/io/File;-><init>(Ljava/io/File;Ljava/lang/String;)V

    return-object v0
.end method

.method public image(Lru/oopssre/imperialschool/viewstv/Protocol$Frame;)Ljava/io/File;
    .locals 4

    .line 35
    new-instance v0, Ljava/io/File;

    iget-object v1, p0, Lru/oopssre/imperialschool/viewstv/CacheStore;->images:Ljava/io/File;

    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    iget-object v3, p1, Lru/oopssre/imperialschool/viewstv/Protocol$Frame;->sha:Ljava/lang/String;

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    const-string v3, "."

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    iget-object p1, p1, Lru/oopssre/imperialschool/viewstv/Protocol$Frame;->format:Ljava/lang/String;

    invoke-virtual {v2, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p1

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-direct {v0, v1, p1}, Ljava/io/File;-><init>(Ljava/io/File;Ljava/lang/String;)V

    return-object v0
.end method

.method public pinImage(Ljava/lang/String;)V
    .locals 11

    .line 23
    sget-object v0, Lru/oopssre/imperialschool/viewstv/CacheStore;->LOCK:Ljava/lang/Object;

    monitor-enter v0

    const/4 v1, 0x2

    :try_start_0
    new-array v2, v1, [Ljava/lang/String;

    const-string v3, "jpg"

    const/4 v4, 0x0

    aput-object v3, v2, v4

    const-string v3, "png"

    const/4 v5, 0x1

    aput-object v3, v2, v5

    move v3, v4

    :goto_0
    if-ge v3, v1, :cond_0

    aget-object v6, v2, v3

    new-instance v7, Ljava/io/File;

    iget-object v8, p0, Lru/oopssre/imperialschool/viewstv/CacheStore;->images:Ljava/io/File;

    new-instance v9, Ljava/lang/StringBuilder;

    invoke-direct {v9}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v9, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v9

    const-string v10, "."

    invoke-virtual {v9, v10}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v9

    invoke-virtual {v9, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v6

    invoke-virtual {v6}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v6

    invoke-direct {v7, v8, v6}, Ljava/io/File;-><init>(Ljava/io/File;Ljava/lang/String;)V

    invoke-virtual {v7}, Ljava/io/File;->getAbsolutePath()Ljava/lang/String;

    move-result-object v6

    sget-object v7, Lru/oopssre/imperialschool/viewstv/CacheStore;->MEDIA_PINS:Ljava/util/Map;

    invoke-static {v4}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v8

    invoke-interface {v7, v6, v8}, Ljava/util/Map;->getOrDefault(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v8

    check-cast v8, Ljava/lang/Integer;

    invoke-virtual {v8}, Ljava/lang/Integer;->intValue()I

    move-result v8

    add-int/2addr v8, v5

    invoke-static {v8}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v8

    invoke-interface {v7, v6, v8}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    add-int/lit8 v3, v3, 0x1

    goto :goto_0

    :cond_0
    monitor-exit v0

    return-void

    :catchall_0
    move-exception p1

    monitor-exit v0
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    throw p1
.end method

.method public pinVideo(Ljava/lang/String;)V
    .locals 3

    .line 21
    sget-object v0, Lru/oopssre/imperialschool/viewstv/CacheStore;->LOCK:Ljava/lang/Object;

    monitor-enter v0

    :try_start_0
    invoke-virtual {p0, p1}, Lru/oopssre/imperialschool/viewstv/CacheStore;->video(Ljava/lang/String;)Ljava/io/File;

    move-result-object p1

    invoke-virtual {p1}, Ljava/io/File;->getAbsolutePath()Ljava/lang/String;

    move-result-object p1

    sget-object v1, Lru/oopssre/imperialschool/viewstv/CacheStore;->MEDIA_PINS:Ljava/util/Map;

    const/4 v2, 0x0

    invoke-static {v2}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v2

    invoke-interface {v1, p1, v2}, Ljava/util/Map;->getOrDefault(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Ljava/lang/Integer;

    invoke-virtual {v2}, Ljava/lang/Integer;->intValue()I

    move-result v2

    add-int/lit8 v2, v2, 0x1

    invoke-static {v2}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v2

    invoke-interface {v1, p1, v2}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    monitor-exit v0

    return-void

    :catchall_0
    move-exception p1

    monitor-exit v0
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    throw p1
.end method

.method protectedMedia(Ljava/io/File;Ljava/lang/String;)Z
    .locals 3

    .line 75
    invoke-virtual {p1}, Ljava/io/File;->getName()Ljava/lang/String;

    move-result-object v0

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v1, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    const-string v2, ".jpg"

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-nez v0, :cond_1

    invoke-virtual {p1}, Ljava/io/File;->getName()Ljava/lang/String;

    move-result-object v0

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v1, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p2

    const-string v1, ".png"

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p2

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p2

    invoke-virtual {v0, p2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p2

    if-nez p2, :cond_1

    sget-object p2, Lru/oopssre/imperialschool/viewstv/CacheStore;->MEDIA_PINS:Ljava/util/Map;

    .line 76
    invoke-virtual {p1}, Ljava/io/File;->getAbsolutePath()Ljava/lang/String;

    move-result-object v0

    invoke-interface {p2, v0}, Ljava/util/Map;->containsKey(Ljava/lang/Object;)Z

    move-result p2

    if-nez p2, :cond_1

    invoke-virtual {p1}, Ljava/io/File;->getName()Ljava/lang/String;

    move-result-object p1

    const-string p2, ".part"

    invoke-virtual {p1, p2}, Ljava/lang/String;->endsWith(Ljava/lang/String;)Z

    move-result p1

    if-eqz p1, :cond_0

    goto :goto_0

    :cond_0
    const/4 p1, 0x0

    return p1

    :cond_1
    :goto_0
    const/4 p1, 0x1

    return p1
.end method

.method public recreate()V
    .locals 1

    .line 96
    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/CacheStore;->images:Ljava/io/File;

    invoke-virtual {v0}, Ljava/io/File;->mkdirs()Z

    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/CacheStore;->videos:Ljava/io/File;

    invoke-virtual {v0}, Ljava/io/File;->mkdirs()Z

    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/CacheStore;->json:Ljava/io/File;

    invoke-virtual {v0}, Ljava/io/File;->mkdirs()Z

    return-void
.end method

.method public reserve(JLjava/lang/String;)V
    .locals 9
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/io/IOException;
        }
    .end annotation

    .line 56
    sget-object v0, Lru/oopssre/imperialschool/viewstv/CacheStore;->LOCK:Ljava/lang/Object;

    monitor-enter v0

    const-wide/16 v1, 0x0

    cmp-long v1, p1, v1

    if-ltz v1, :cond_8

    .line 58
    :try_start_0
    invoke-virtual {p0}, Lru/oopssre/imperialschool/viewstv/CacheStore;->retainedMedia()Ljava/util/Set;

    move-result-object v1

    .line 59
    new-instance v2, Ljava/util/ArrayList;

    invoke-direct {v2}, Ljava/util/ArrayList;-><init>()V

    const/4 v3, 0x2

    .line 60
    new-array v4, v3, [Ljava/io/File;

    iget-object v5, p0, Lru/oopssre/imperialschool/viewstv/CacheStore;->images:Ljava/io/File;

    const/4 v6, 0x0

    aput-object v5, v4, v6

    iget-object v5, p0, Lru/oopssre/imperialschool/viewstv/CacheStore;->videos:Ljava/io/File;

    const/4 v7, 0x1

    aput-object v5, v4, v7

    move v5, v6

    :goto_0
    if-ge v5, v3, :cond_0

    aget-object v7, v4, v5

    invoke-virtual {v7}, Ljava/io/File;->listFiles()[Ljava/io/File;

    move-result-object v7

    invoke-static {v7}, Ljava/util/Optional;->ofNullable(Ljava/lang/Object;)Ljava/util/Optional;

    move-result-object v7

    new-array v8, v6, [Ljava/io/File;

    invoke-virtual {v7, v8}, Ljava/util/Optional;->orElse(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v7

    check-cast v7, [Ljava/io/File;

    invoke-static {v7}, Ljava/util/Arrays;->asList([Ljava/lang/Object;)Ljava/util/List;

    move-result-object v7

    invoke-interface {v2, v7}, Ljava/util/List;->addAll(Ljava/util/Collection;)Z

    add-int/lit8 v5, v5, 0x1

    goto :goto_0

    .line 61
    :cond_0
    new-instance v3, Lru/oopssre/imperialschool/viewstv/CacheStore$$ExternalSyntheticLambda0;

    invoke-direct {v3}, Lru/oopssre/imperialschool/viewstv/CacheStore$$ExternalSyntheticLambda0;-><init>()V

    invoke-static {v3}, Ljava/util/Comparator;->comparingLong(Ljava/util/function/ToLongFunction;)Ljava/util/Comparator;

    move-result-object v3

    invoke-interface {v2, v3}, Ljava/util/List;->sort(Ljava/util/Comparator;)V

    .line 62
    invoke-interface {v2}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object v3

    :cond_1
    :goto_1
    invoke-interface {v3}, Ljava/util/Iterator;->hasNext()Z

    move-result v4

    if-eqz v4, :cond_3

    invoke-interface {v3}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v4

    check-cast v4, Ljava/io/File;

    .line 63
    invoke-virtual {p0, v4, p3}, Lru/oopssre/imperialschool/viewstv/CacheStore;->protectedMedia(Ljava/io/File;Ljava/lang/String;)Z

    move-result v5

    if-eqz v5, :cond_2

    goto :goto_1

    .line 64
    :cond_2
    invoke-virtual {v4}, Ljava/io/File;->getName()Ljava/lang/String;

    move-result-object v5

    invoke-interface {v1, v5}, Ljava/util/Set;->contains(Ljava/lang/Object;)Z

    move-result v5

    if-nez v5, :cond_1

    invoke-virtual {v4}, Ljava/io/File;->delete()Z

    goto :goto_1

    .line 67
    :cond_3
    invoke-interface {v2}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object v1

    :cond_4
    :goto_2
    invoke-interface {v1}, Ljava/util/Iterator;->hasNext()Z

    move-result v2

    if-eqz v2, :cond_6

    invoke-interface {v1}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Ljava/io/File;

    .line 68
    iget-object v3, p0, Lru/oopssre/imperialschool/viewstv/CacheStore;->root:Ljava/io/File;

    invoke-virtual {v3}, Ljava/io/File;->getUsableSpace()J

    move-result-wide v3

    cmp-long v3, v3, p1

    if-ltz v3, :cond_5

    goto :goto_3

    .line 69
    :cond_5
    invoke-virtual {p0, v2, p3}, Lru/oopssre/imperialschool/viewstv/CacheStore;->protectedMedia(Ljava/io/File;Ljava/lang/String;)Z

    move-result v3

    if-nez v3, :cond_4

    invoke-virtual {v2}, Ljava/io/File;->delete()Z

    goto :goto_2

    .line 71
    :cond_6
    :goto_3
    iget-object p3, p0, Lru/oopssre/imperialschool/viewstv/CacheStore;->root:Ljava/io/File;

    invoke-virtual {p3}, Ljava/io/File;->getUsableSpace()J

    move-result-wide v1

    cmp-long p1, v1, p1

    if-ltz p1, :cond_7

    .line 72
    monitor-exit v0

    return-void

    .line 71
    :cond_7
    new-instance p1, Lru/oopssre/imperialschool/viewstv/CacheStore$SpaceException;

    invoke-direct {p1}, Lru/oopssre/imperialschool/viewstv/CacheStore$SpaceException;-><init>()V

    throw p1

    :catchall_0
    move-exception p1

    goto :goto_4

    .line 57
    :cond_8
    new-instance p1, Ljava/lang/IllegalArgumentException;

    const-string p2, "Negative reservation"

    invoke-direct {p1, p2}, Ljava/lang/IllegalArgumentException;-><init>(Ljava/lang/String;)V

    throw p1

    .line 72
    :goto_4
    monitor-exit v0
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    throw p1
.end method

.method retainedMedia()Ljava/util/Set;
    .locals 11
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "()",
            "Ljava/util/Set<",
            "Ljava/lang/String;",
            ">;"
        }
    .end annotation

    .line 42
    new-instance v0, Ljava/util/HashSet;

    invoke-direct {v0}, Ljava/util/HashSet;-><init>()V

    .line 43
    iget-object v1, p0, Lru/oopssre/imperialschool/viewstv/CacheStore;->root:Ljava/io/File;

    invoke-virtual {v1}, Ljava/io/File;->listFiles()[Ljava/io/File;

    move-result-object v1

    if-eqz v1, :cond_2

    .line 44
    array-length v2, v1

    const/4 v3, 0x0

    :goto_0
    if-ge v3, v2, :cond_2

    aget-object v4, v1, v3

    .line 45
    invoke-virtual {v4}, Ljava/io/File;->getName()Ljava/lang/String;

    move-result-object v5

    .line 46
    const-string v6, "state-"

    invoke-virtual {v5, v6}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z

    move-result v6

    const-string v7, "video-state-"

    if-nez v6, :cond_0

    invoke-virtual {v5, v7}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z

    move-result v6

    if-nez v6, :cond_0

    goto :goto_1

    .line 48
    :cond_0
    :try_start_0
    new-instance v6, Lorg/json/JSONObject;

    new-instance v8, Ljava/lang/String;

    const-wide/32 v9, 0x186a0

    invoke-static {v4, v9, v10}, Lru/oopssre/imperialschool/viewstv/CacheStore;->read(Ljava/io/File;J)[B

    move-result-object v4

    sget-object v9, Ljava/nio/charset/StandardCharsets;->UTF_8:Ljava/nio/charset/Charset;

    invoke-direct {v8, v4, v9}, Ljava/lang/String;-><init>([BLjava/nio/charset/Charset;)V

    invoke-direct {v6, v8}, Lorg/json/JSONObject;-><init>(Ljava/lang/String;)V

    .line 49
    invoke-virtual {v5, v7}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z

    move-result v4

    if-eqz v4, :cond_1

    invoke-static {v6}, Lru/oopssre/imperialschool/viewstv/VideoInfo;->saved(Lorg/json/JSONObject;)Lru/oopssre/imperialschool/viewstv/VideoInfo;

    move-result-object v4

    iget-object v4, v4, Lru/oopssre/imperialschool/viewstv/VideoInfo;->sha:Ljava/lang/String;

    invoke-virtual {p0, v4}, Lru/oopssre/imperialschool/viewstv/CacheStore;->video(Ljava/lang/String;)Ljava/io/File;

    move-result-object v4

    invoke-virtual {v4}, Ljava/io/File;->getName()Ljava/lang/String;

    move-result-object v4

    invoke-interface {v0, v4}, Ljava/util/Set;->add(Ljava/lang/Object;)Z

    goto :goto_1

    .line 50
    :cond_1
    invoke-static {v6}, Lru/oopssre/imperialschool/viewstv/Protocol;->savedFrame(Lorg/json/JSONObject;)Lru/oopssre/imperialschool/viewstv/Protocol$Frame;

    move-result-object v4

    invoke-virtual {p0, v4}, Lru/oopssre/imperialschool/viewstv/CacheStore;->image(Lru/oopssre/imperialschool/viewstv/Protocol$Frame;)Ljava/io/File;

    move-result-object v4

    invoke-virtual {v4}, Ljava/io/File;->getName()Ljava/lang/String;

    move-result-object v4

    invoke-interface {v0, v4}, Ljava/util/Set;->add(Ljava/lang/Object;)Z
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    :catch_0
    :goto_1
    add-int/lit8 v3, v3, 0x1

    goto :goto_0

    :cond_2
    return-object v0
.end method

.method public save(Lru/oopssre/imperialschool/viewstv/Protocol$Frame;)V
    .locals 4
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/io/IOException;,
            Lorg/json/JSONException;
        }
    .end annotation

    .line 39
    sget-object v0, Lru/oopssre/imperialschool/viewstv/CacheStore;->LOCK:Ljava/lang/Object;

    monitor-enter v0

    :try_start_0
    iget-object v1, p1, Lru/oopssre/imperialschool/viewstv/Protocol$Frame;->theme:Ljava/lang/String;

    iget-object v2, p1, Lru/oopssre/imperialschool/viewstv/Protocol$Frame;->device:Ljava/lang/String;

    invoke-virtual {p0, v1, v2}, Lru/oopssre/imperialschool/viewstv/CacheStore;->snapshot(Ljava/lang/String;Ljava/lang/String;)Ljava/io/File;

    move-result-object v1

    invoke-virtual {p1}, Lru/oopssre/imperialschool/viewstv/Protocol$Frame;->json()Lorg/json/JSONObject;

    move-result-object v2

    invoke-virtual {v2}, Lorg/json/JSONObject;->toString()Ljava/lang/String;

    move-result-object v2

    sget-object v3, Ljava/nio/charset/StandardCharsets;->UTF_8:Ljava/nio/charset/Charset;

    invoke-virtual {v2, v3}, Ljava/lang/String;->getBytes(Ljava/nio/charset/Charset;)[B

    move-result-object v2

    invoke-static {v1, v2}, Lru/oopssre/imperialschool/viewstv/CacheStore;->atomic(Ljava/io/File;[B)V

    invoke-virtual {p0, p1}, Lru/oopssre/imperialschool/viewstv/CacheStore;->image(Lru/oopssre/imperialschool/viewstv/Protocol$Frame;)Ljava/io/File;

    move-result-object p1

    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J

    move-result-wide v1

    invoke-virtual {p1, v1, v2}, Ljava/io/File;->setLastModified(J)Z

    monitor-exit v0

    return-void

    :catchall_0
    move-exception p1

    monitor-exit v0
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    throw p1
.end method

.method public saveVideo(Lru/oopssre/imperialschool/viewstv/VideoInfo;)V
    .locals 5
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/io/IOException;,
            Lorg/json/JSONException;
        }
    .end annotation

    const-string v0, "video-state-"

    .line 26
    sget-object v1, Lru/oopssre/imperialschool/viewstv/CacheStore;->LOCK:Ljava/lang/Object;

    monitor-enter v1

    :try_start_0
    new-instance v2, Ljava/io/File;

    iget-object v3, p0, Lru/oopssre/imperialschool/viewstv/CacheStore;->root:Ljava/io/File;

    new-instance v4, Ljava/lang/StringBuilder;

    invoke-direct {v4, v0}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    iget-object v0, p1, Lru/oopssre/imperialschool/viewstv/VideoInfo;->frame:Lru/oopssre/imperialschool/viewstv/Protocol$Frame;

    iget-object v0, v0, Lru/oopssre/imperialschool/viewstv/Protocol$Frame;->theme:Ljava/lang/String;

    invoke-virtual {v4, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    const-string v4, "-"

    invoke-virtual {v0, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    iget-object v4, p1, Lru/oopssre/imperialschool/viewstv/VideoInfo;->frame:Lru/oopssre/imperialschool/viewstv/Protocol$Frame;

    iget-object v4, v4, Lru/oopssre/imperialschool/viewstv/Protocol$Frame;->device:Ljava/lang/String;

    invoke-virtual {v0, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    const-string v4, ".json"

    invoke-virtual {v0, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-direct {v2, v3, v0}, Ljava/io/File;-><init>(Ljava/io/File;Ljava/lang/String;)V

    invoke-virtual {p1}, Lru/oopssre/imperialschool/viewstv/VideoInfo;->json()Lorg/json/JSONObject;

    move-result-object v0

    invoke-virtual {v0}, Lorg/json/JSONObject;->toString()Ljava/lang/String;

    move-result-object v0

    sget-object v3, Ljava/nio/charset/StandardCharsets;->UTF_8:Ljava/nio/charset/Charset;

    invoke-virtual {v0, v3}, Ljava/lang/String;->getBytes(Ljava/nio/charset/Charset;)[B

    move-result-object v0

    invoke-static {v2, v0}, Lru/oopssre/imperialschool/viewstv/CacheStore;->atomic(Ljava/io/File;[B)V

    iget-object p1, p1, Lru/oopssre/imperialschool/viewstv/VideoInfo;->sha:Ljava/lang/String;

    invoke-virtual {p0, p1}, Lru/oopssre/imperialschool/viewstv/CacheStore;->video(Ljava/lang/String;)Ljava/io/File;

    move-result-object p1

    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J

    move-result-wide v2

    invoke-virtual {p1, v2, v3}, Ljava/io/File;->setLastModified(J)Z

    monitor-exit v1

    return-void

    :catchall_0
    move-exception p1

    monitor-exit v1
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    throw p1
.end method

.method snapshot(Ljava/lang/String;Ljava/lang/String;)Ljava/io/File;
    .locals 4

    .line 38
    const-string v0, "[a-z0-9][a-z0-9_-]{0,79}"

    invoke-virtual {p1, v0}, Ljava/lang/String;->matches(Ljava/lang/String;)Z

    move-result v0

    if-eqz v0, :cond_0

    invoke-static {p2}, Lru/oopssre/imperialschool/viewstv/Protocol;->id(Ljava/lang/String;)Z

    move-result v0

    if-eqz v0, :cond_0

    const/4 v0, 0x1

    goto :goto_0

    :cond_0
    const/4 v0, 0x0

    :goto_0
    const-string v1, "\u041d\u0435\u0432\u0435\u0440\u043d\u0430\u044f \u043e\u0431\u043b\u0430\u0441\u0442\u044c \u043a\u0435\u0448\u0430"

    invoke-static {v0, v1}, Lru/oopssre/imperialschool/viewstv/Protocol;->require(ZLjava/lang/String;)V

    new-instance v0, Ljava/io/File;

    iget-object v1, p0, Lru/oopssre/imperialschool/viewstv/CacheStore;->root:Ljava/io/File;

    new-instance v2, Ljava/lang/StringBuilder;

    const-string v3, "state-"

    invoke-direct {v2, v3}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v2, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p1

    const-string v2, "-"

    invoke-virtual {p1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p1

    invoke-virtual {p1, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p1

    const-string p2, ".json"

    invoke-virtual {p1, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p1

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-direct {v0, v1, p1}, Ljava/io/File;-><init>(Ljava/io/File;Ljava/lang/String;)V

    return-object v0
.end method

.method public unpinImage(Ljava/lang/String;)V
    .locals 11

    .line 24
    sget-object v0, Lru/oopssre/imperialschool/viewstv/CacheStore;->LOCK:Ljava/lang/Object;

    monitor-enter v0

    const/4 v1, 0x2

    :try_start_0
    new-array v2, v1, [Ljava/lang/String;

    const-string v3, "jpg"

    const/4 v4, 0x0

    aput-object v3, v2, v4

    const-string v3, "png"

    const/4 v5, 0x1

    aput-object v3, v2, v5

    move v3, v4

    :goto_0
    if-ge v3, v1, :cond_1

    aget-object v6, v2, v3

    new-instance v7, Ljava/io/File;

    iget-object v8, p0, Lru/oopssre/imperialschool/viewstv/CacheStore;->images:Ljava/io/File;

    new-instance v9, Ljava/lang/StringBuilder;

    invoke-direct {v9}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v9, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v9

    const-string v10, "."

    invoke-virtual {v9, v10}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v9

    invoke-virtual {v9, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v6

    invoke-virtual {v6}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v6

    invoke-direct {v7, v8, v6}, Ljava/io/File;-><init>(Ljava/io/File;Ljava/lang/String;)V

    invoke-virtual {v7}, Ljava/io/File;->getAbsolutePath()Ljava/lang/String;

    move-result-object v6

    sget-object v7, Lru/oopssre/imperialschool/viewstv/CacheStore;->MEDIA_PINS:Ljava/util/Map;

    invoke-static {v4}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v8

    invoke-interface {v7, v6, v8}, Ljava/util/Map;->getOrDefault(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v8

    check-cast v8, Ljava/lang/Integer;

    invoke-virtual {v8}, Ljava/lang/Integer;->intValue()I

    move-result v8

    if-gt v8, v5, :cond_0

    invoke-interface {v7, v6}, Ljava/util/Map;->remove(Ljava/lang/Object;)Ljava/lang/Object;

    goto :goto_1

    :cond_0
    add-int/lit8 v8, v8, -0x1

    invoke-static {v8}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v8

    invoke-interface {v7, v6, v8}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    :goto_1
    add-int/lit8 v3, v3, 0x1

    goto :goto_0

    :cond_1
    monitor-exit v0

    return-void

    :catchall_0
    move-exception p1

    monitor-exit v0
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    throw p1
.end method

.method public unpinVideo(Ljava/lang/String;)V
    .locals 4

    .line 22
    sget-object v0, Lru/oopssre/imperialschool/viewstv/CacheStore;->LOCK:Ljava/lang/Object;

    monitor-enter v0

    :try_start_0
    invoke-virtual {p0, p1}, Lru/oopssre/imperialschool/viewstv/CacheStore;->video(Ljava/lang/String;)Ljava/io/File;

    move-result-object p1

    invoke-virtual {p1}, Ljava/io/File;->getAbsolutePath()Ljava/lang/String;

    move-result-object p1

    sget-object v1, Lru/oopssre/imperialschool/viewstv/CacheStore;->MEDIA_PINS:Ljava/util/Map;

    const/4 v2, 0x0

    invoke-static {v2}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v2

    invoke-interface {v1, p1, v2}, Ljava/util/Map;->getOrDefault(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Ljava/lang/Integer;

    invoke-virtual {v2}, Ljava/lang/Integer;->intValue()I

    move-result v2

    const/4 v3, 0x1

    if-gt v2, v3, :cond_0

    invoke-interface {v1, p1}, Ljava/util/Map;->remove(Ljava/lang/Object;)Ljava/lang/Object;

    goto :goto_0

    :cond_0
    sub-int/2addr v2, v3

    invoke-static {v2}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v2

    invoke-interface {v1, p1, v2}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    :goto_0
    monitor-exit v0

    return-void

    :catchall_0
    move-exception p1

    monitor-exit v0
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    throw p1
.end method

.method public valid(Lru/oopssre/imperialschool/viewstv/Protocol$Frame;)Z
    .locals 5
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/io/IOException;
        }
    .end annotation

    .line 36
    invoke-virtual {p0, p1}, Lru/oopssre/imperialschool/viewstv/CacheStore;->image(Lru/oopssre/imperialschool/viewstv/Protocol$Frame;)Ljava/io/File;

    move-result-object v0

    invoke-virtual {v0}, Ljava/io/File;->isFile()Z

    move-result v1

    if-eqz v1, :cond_0

    invoke-virtual {v0}, Ljava/io/File;->length()J

    move-result-wide v1

    iget-wide v3, p1, Lru/oopssre/imperialschool/viewstv/Protocol$Frame;->bytes:J

    cmp-long v1, v1, v3

    if-nez v1, :cond_0

    invoke-static {v0}, Lru/oopssre/imperialschool/viewstv/CacheStore;->sha(Ljava/io/File;)Ljava/lang/String;

    move-result-object v0

    iget-object p1, p1, Lru/oopssre/imperialschool/viewstv/Protocol$Frame;->sha:Ljava/lang/String;

    invoke-virtual {v0, p1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p1

    if-eqz p1, :cond_0

    const/4 p1, 0x1

    return p1

    :cond_0
    const/4 p1, 0x0

    return p1
.end method

.method public valid(Lru/oopssre/imperialschool/viewstv/VideoInfo;)Z
    .locals 5
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/io/IOException;
        }
    .end annotation

    .line 25
    iget-object v0, p1, Lru/oopssre/imperialschool/viewstv/VideoInfo;->sha:Ljava/lang/String;

    invoke-virtual {p0, v0}, Lru/oopssre/imperialschool/viewstv/CacheStore;->video(Ljava/lang/String;)Ljava/io/File;

    move-result-object v0

    invoke-virtual {v0}, Ljava/io/File;->isFile()Z

    move-result v1

    if-eqz v1, :cond_0

    invoke-virtual {v0}, Ljava/io/File;->length()J

    move-result-wide v1

    iget-wide v3, p1, Lru/oopssre/imperialschool/viewstv/VideoInfo;->bytes:J

    cmp-long v1, v1, v3

    if-nez v1, :cond_0

    invoke-static {v0}, Lru/oopssre/imperialschool/viewstv/CacheStore;->sha(Ljava/io/File;)Ljava/lang/String;

    move-result-object v0

    iget-object p1, p1, Lru/oopssre/imperialschool/viewstv/VideoInfo;->sha:Ljava/lang/String;

    invoke-virtual {v0, p1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p1

    if-eqz p1, :cond_0

    const/4 p1, 0x1

    return p1

    :cond_0
    const/4 p1, 0x0

    return p1
.end method

.method public video(Ljava/lang/String;)Ljava/io/File;
    .locals 3

    .line 20
    invoke-static {p1}, Lru/oopssre/imperialschool/viewstv/Protocol;->hash(Ljava/lang/String;)Z

    move-result v0

    const-string v1, "\u041d\u0435\u0432\u0435\u0440\u043d\u044b\u0439 \u0445\u0435\u0448 \u0432\u0438\u0434\u0435\u043e"

    invoke-static {v0, v1}, Lru/oopssre/imperialschool/viewstv/Protocol;->require(ZLjava/lang/String;)V

    new-instance v0, Ljava/io/File;

    iget-object v1, p0, Lru/oopssre/imperialschool/viewstv/CacheStore;->videos:Ljava/io/File;

    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v2, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p1

    const-string v2, ".mp4"

    invoke-virtual {p1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p1

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-direct {v0, v1, p1}, Ljava/io/File;-><init>(Ljava/io/File;Ljava/lang/String;)V

    return-object v0
.end method
