.class final Lru/oopssre/imperialschool/viewstv/MusicPacks;
.super Ljava/lang/Object;
.source "MusicPacks.java"


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lru/oopssre/imperialschool/viewstv/MusicPacks$Pack;,
        Lru/oopssre/imperialschool/viewstv/MusicPacks$Track;
    }
.end annotation


# static fields
.field static final MAX_ARCHIVE:I = 0x200000

.field private static final MAX_TOTAL:I = 0x800000

.field private static final MAX_TRACK:I = 0x100000

.field private static final MAX_TRACKS:I = 0x20


# instance fields
.field private final cache:Lru/oopssre/imperialschool/viewstv/CacheStore;

.field private final net:Lru/oopssre/imperialschool/viewstv/HttpTransport;


# direct methods
.method constructor <init>(Lru/oopssre/imperialschool/viewstv/CacheStore;Lru/oopssre/imperialschool/viewstv/HttpTransport;)V
    .locals 0

    .line 39
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    iput-object p1, p0, Lru/oopssre/imperialschool/viewstv/MusicPacks;->cache:Lru/oopssre/imperialschool/viewstv/CacheStore;

    iput-object p2, p0, Lru/oopssre/imperialschool/viewstv/MusicPacks;->net:Lru/oopssre/imperialschool/viewstv/HttpTransport;

    return-void
.end method

.method static read(Ljava/io/File;Ljava/lang/String;Ljava/lang/String;)Lru/oopssre/imperialschool/viewstv/MusicPacks$Pack;
    .locals 11
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/io/IOException;,
            Lorg/json/JSONException;
        }
    .end annotation

    .line 85
    invoke-virtual {p0}, Ljava/io/File;->isFile()Z

    move-result v0

    if-eqz v0, :cond_8

    invoke-virtual {p0}, Ljava/io/File;->length()J

    move-result-wide v0

    const-wide/32 v2, 0x200000

    cmp-long v0, v0, v2

    if-gtz v0, :cond_8

    .line 86
    new-instance v0, Ljava/util/HashMap;

    invoke-direct {v0}, Ljava/util/HashMap;-><init>()V

    .line 88
    new-instance v1, Ljava/util/zip/ZipInputStream;

    new-instance v2, Ljava/io/BufferedInputStream;

    new-instance v3, Ljava/io/FileInputStream;

    invoke-direct {v3, p0}, Ljava/io/FileInputStream;-><init>(Ljava/io/File;)V

    invoke-direct {v2, v3}, Ljava/io/BufferedInputStream;-><init>(Ljava/io/InputStream;)V

    invoke-direct {v1, v2}, Ljava/util/zip/ZipInputStream;-><init>(Ljava/io/InputStream;)V

    const/4 p0, 0x0

    move v2, p0

    .line 89
    :goto_0
    :try_start_0
    invoke-virtual {v1}, Ljava/util/zip/ZipInputStream;->getNextEntry()Ljava/util/zip/ZipEntry;

    move-result-object v3
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    const-string v4, "music.json"

    if-eqz v3, :cond_2

    .line 90
    :try_start_1
    invoke-virtual {v3}, Ljava/util/zip/ZipEntry;->getName()Ljava/lang/String;

    move-result-object v5

    .line 91
    invoke-virtual {v3}, Ljava/util/zip/ZipEntry;->isDirectory()Z

    move-result v3

    if-nez v3, :cond_1

    invoke-interface {v0}, Ljava/util/Map;->size()I

    move-result v3

    const/16 v6, 0x21

    if-ge v3, v6, :cond_1

    invoke-interface {v0, v5}, Ljava/util/Map;->containsKey(Ljava/lang/Object;)Z

    move-result v3

    if-nez v3, :cond_1

    .line 92
    invoke-virtual {v5, v4}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v3

    if-nez v3, :cond_0

    const-string v3, "[a-z0-9_-]{1,80}\\.(vgm|snes-registers)"

    invoke-virtual {v5, v3}, Ljava/lang/String;->matches(Ljava/lang/String;)Z

    move-result v3

    if-eqz v3, :cond_1

    :cond_0
    const/high16 v3, 0x800000

    sub-int/2addr v3, v2

    const/high16 v4, 0x100000

    .line 95
    invoke-static {v4, v3}, Ljava/lang/Math;->min(II)I

    move-result v3

    int-to-long v3, v3

    invoke-static {v1, v3, v4}, Lru/oopssre/imperialschool/viewstv/CacheStore;->bounded(Ljava/io/InputStream;J)[B

    move-result-object v3

    .line 96
    array-length v4, v3

    add-int/2addr v2, v4

    .line 97
    invoke-interface {v0, v5, v3}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 98
    invoke-virtual {v1}, Ljava/util/zip/ZipInputStream;->closeEntry()V

    goto :goto_0

    .line 93
    :cond_1
    new-instance p0, Ljava/io/IOException;

    const-string p1, "\u041d\u0435\u0432\u0435\u0440\u043d\u044b\u0439 \u0441\u043e\u0441\u0442\u0430\u0432 \u043c\u0443\u0437\u044b\u043a\u0430\u043b\u044c\u043d\u043e\u0433\u043e \u043f\u0430\u043a\u0435\u0442\u0430"

    invoke-direct {p0, p1}, Ljava/io/IOException;-><init>(Ljava/lang/String;)V

    throw p0
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    .line 100
    :cond_2
    invoke-virtual {v1}, Ljava/util/zip/ZipInputStream;->close()V

    .line 101
    invoke-interface {v0, v4}, Ljava/util/Map;->remove(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v1

    check-cast v1, [B

    if-eqz v1, :cond_7

    .line 103
    new-instance v2, Lorg/json/JSONObject;

    new-instance v3, Ljava/lang/String;

    sget-object v4, Ljava/nio/charset/StandardCharsets;->UTF_8:Ljava/nio/charset/Charset;

    invoke-direct {v3, v1, v4}, Ljava/lang/String;-><init>([BLjava/nio/charset/Charset;)V

    invoke-direct {v2, v3}, Lorg/json/JSONObject;-><init>(Ljava/lang/String;)V

    .line 104
    const-string v1, "tracks"

    invoke-virtual {v2, v1}, Lorg/json/JSONObject;->getJSONArray(Ljava/lang/String;)Lorg/json/JSONArray;

    move-result-object v1

    .line 105
    const-string v3, "schema"

    invoke-virtual {v2, v3}, Lorg/json/JSONObject;->getInt(Ljava/lang/String;)I

    move-result v3

    const/4 v4, 0x1

    if-ne v3, v4, :cond_6

    const-string v3, "theme"

    invoke-virtual {v2, v3}, Lorg/json/JSONObject;->getString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v2

    invoke-virtual {p1, v2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p1

    if-eqz p1, :cond_6

    invoke-virtual {v1}, Lorg/json/JSONArray;->length()I

    move-result p1

    if-eqz p1, :cond_6

    .line 106
    invoke-virtual {v1}, Lorg/json/JSONArray;->length()I

    move-result p1

    invoke-interface {v0}, Ljava/util/Map;->size()I

    move-result v2

    if-ne p1, v2, :cond_6

    .line 107
    new-instance p1, Ljava/util/ArrayList;

    invoke-direct {p1}, Ljava/util/ArrayList;-><init>()V

    move v2, p0

    .line 108
    :goto_1
    invoke-virtual {v1}, Lorg/json/JSONArray;->length()I

    move-result v3

    if-ge v2, v3, :cond_5

    .line 109
    invoke-virtual {v1, v2}, Lorg/json/JSONArray;->getJSONObject(I)Lorg/json/JSONObject;

    move-result-object v3

    .line 110
    const-string v4, "file"

    invoke-virtual {v3, v4}, Lorg/json/JSONObject;->getString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v4

    const-string v5, "title"

    invoke-virtual {v3, v5}, Lorg/json/JSONObject;->getString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v5

    const-string v6, "credit"

    invoke-virtual {v3, v6}, Lorg/json/JSONObject;->getString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v3

    .line 111
    invoke-interface {v0, v4}, Ljava/util/Map;->remove(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v6

    check-cast v6, [B

    .line 112
    const-string v7, ".snes-registers"

    invoke-virtual {v4, v7}, Ljava/lang/String;->endsWith(Ljava/lang/String;)Z

    move-result v7

    if-eqz v7, :cond_3

    const-string v7, "ISVSNES1"

    goto :goto_2

    :cond_3
    const-string v7, "Vgm "

    :goto_2
    if-eqz v6, :cond_4

    .line 113
    array-length v8, v6

    const/16 v9, 0x40

    if-lt v8, v9, :cond_4

    invoke-virtual {v5}, Ljava/lang/String;->isEmpty()Z

    move-result v8

    if-nez v8, :cond_4

    invoke-virtual {v5}, Ljava/lang/String;->length()I

    move-result v8

    const/16 v9, 0xc8

    if-gt v8, v9, :cond_4

    invoke-virtual {v3}, Ljava/lang/String;->length()I

    move-result v8

    const/16 v9, 0x1000

    if-gt v8, v9, :cond_4

    new-instance v8, Ljava/lang/String;

    .line 114
    invoke-virtual {v7}, Ljava/lang/String;->length()I

    move-result v9

    sget-object v10, Ljava/nio/charset/StandardCharsets;->US_ASCII:Ljava/nio/charset/Charset;

    invoke-direct {v8, v6, p0, v9, v10}, Ljava/lang/String;-><init>([BIILjava/nio/charset/Charset;)V

    invoke-virtual {v7, v8}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v7

    if-eqz v7, :cond_4

    .line 117
    new-instance v7, Lru/oopssre/imperialschool/viewstv/MusicPacks$Track;

    invoke-direct {v7, v4, v5, v3, v6}, Lru/oopssre/imperialschool/viewstv/MusicPacks$Track;-><init>(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;[B)V

    invoke-interface {p1, v7}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    add-int/lit8 v2, v2, 0x1

    goto :goto_1

    .line 115
    :cond_4
    new-instance p0, Ljava/io/IOException;

    const-string p1, "\u041d\u0435\u0432\u0435\u0440\u043d\u044b\u0439 \u0444\u0430\u0439\u043b \u043c\u0435\u043b\u043e\u0434\u0438\u0438"

    invoke-direct {p0, p1}, Ljava/io/IOException;-><init>(Ljava/lang/String;)V

    throw p0

    .line 119
    :cond_5
    new-instance p0, Lru/oopssre/imperialschool/viewstv/MusicPacks$Pack;

    invoke-direct {p0, p2, p1}, Lru/oopssre/imperialschool/viewstv/MusicPacks$Pack;-><init>(Ljava/lang/String;Ljava/util/List;)V

    return-object p0

    .line 106
    :cond_6
    new-instance p0, Ljava/io/IOException;

    const-string p1, "\u041d\u0435\u0432\u0435\u0440\u043d\u043e\u0435 \u043e\u043f\u0438\u0441\u0430\u043d\u0438\u0435 \u043c\u0435\u043b\u043e\u0434\u0438\u0439"

    invoke-direct {p0, p1}, Ljava/io/IOException;-><init>(Ljava/lang/String;)V

    throw p0

    .line 102
    :cond_7
    new-instance p0, Ljava/io/IOException;

    const-string p1, "\u0412 \u0430\u0440\u0445\u0438\u0432\u0435 \u043d\u0435\u0442 \u0441\u043f\u0438\u0441\u043a\u0430 \u043c\u0435\u043b\u043e\u0434\u0438\u0439"

    invoke-direct {p0, p1}, Ljava/io/IOException;-><init>(Ljava/lang/String;)V

    throw p0

    :catchall_0
    move-exception p0

    .line 88
    :try_start_2
    invoke-virtual {v1}, Ljava/util/zip/ZipInputStream;->close()V
    :try_end_2
    .catchall {:try_start_2 .. :try_end_2} :catchall_1

    goto :goto_3

    :catchall_1
    move-exception p1

    invoke-virtual {p0, p1}, Ljava/lang/Throwable;->addSuppressed(Ljava/lang/Throwable;)V

    :goto_3
    throw p0

    .line 85
    :cond_8
    new-instance p0, Ljava/io/IOException;

    const-string p1, "\u041d\u0435\u0442 \u043c\u0443\u0437\u044b\u043a\u0430\u043b\u044c\u043d\u043e\u0433\u043e \u043f\u0430\u043a\u0435\u0442\u0430"

    invoke-direct {p0, p1}, Ljava/io/IOException;-><init>(Ljava/lang/String;)V

    throw p0
.end method

.method private target(Ljava/lang/String;)Ljava/io/File;
    .locals 4

    .line 42
    const-string v0, "[a-z0-9][a-z0-9_-]{0,79}"

    invoke-virtual {p1, v0}, Ljava/lang/String;->matches(Ljava/lang/String;)Z

    move-result v0

    if-eqz v0, :cond_0

    .line 43
    new-instance v0, Ljava/io/File;

    iget-object v1, p0, Lru/oopssre/imperialschool/viewstv/MusicPacks;->cache:Lru/oopssre/imperialschool/viewstv/CacheStore;

    iget-object v1, v1, Lru/oopssre/imperialschool/viewstv/CacheStore;->root:Ljava/io/File;

    new-instance v2, Ljava/lang/StringBuilder;

    const-string v3, "music-"

    invoke-direct {v2, v3}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v2, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p1

    const-string v2, ".zip"

    invoke-virtual {p1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p1

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-direct {v0, v1, p1}, Ljava/io/File;-><init>(Ljava/io/File;Ljava/lang/String;)V

    return-object v0

    .line 42
    :cond_0
    new-instance p1, Ljava/lang/IllegalArgumentException;

    const-string v0, "\u041d\u0435\u0438\u0437\u0432\u0435\u0441\u0442\u043d\u0430\u044f \u0442\u0435\u043c\u0430"

    invoke-direct {p1, v0}, Ljava/lang/IllegalArgumentException;-><init>(Ljava/lang/String;)V

    throw p1
.end method


# virtual methods
.method cached(Ljava/lang/String;)Lru/oopssre/imperialschool/viewstv/MusicPacks$Pack;
    .locals 6

    const/4 v0, 0x0

    .line 48
    :try_start_0
    invoke-direct {p0, p1}, Lru/oopssre/imperialschool/viewstv/MusicPacks;->target(Ljava/lang/String;)Ljava/io/File;

    move-result-object v1

    .line 49
    invoke-virtual {v1}, Ljava/io/File;->isFile()Z

    move-result v2

    if-eqz v2, :cond_0

    invoke-virtual {v1}, Ljava/io/File;->length()J

    move-result-wide v2

    const-wide/32 v4, 0x200000

    cmp-long v2, v2, v4

    if-gtz v2, :cond_0

    invoke-static {v1}, Lru/oopssre/imperialschool/viewstv/CacheStore;->sha(Ljava/io/File;)Ljava/lang/String;

    move-result-object v2

    invoke-static {v1, p1, v2}, Lru/oopssre/imperialschool/viewstv/MusicPacks;->read(Ljava/io/File;Ljava/lang/String;Ljava/lang/String;)Lru/oopssre/imperialschool/viewstv/MusicPacks$Pack;

    move-result-object p1
    :try_end_0
    .catch Ljava/io/IOException; {:try_start_0 .. :try_end_0} :catch_0
    .catch Lorg/json/JSONException; {:try_start_0 .. :try_end_0} :catch_0

    return-object p1

    :catch_0
    :cond_0
    return-object v0
.end method

.method refresh(Ljava/lang/String;Lru/oopssre/imperialschool/viewstv/MusicPacks$Pack;Z)Lru/oopssre/imperialschool/viewstv/MusicPacks$Pack;
    .locals 11
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/io/IOException;,
            Lorg/json/JSONException;
        }
    .end annotation

    .line 56
    new-instance v0, Ljava/lang/StringBuilder;

    const-string v1, "music/"

    invoke-direct {v0, v1}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    const-string v1, "/"

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    .line 57
    iget-object v1, p0, Lru/oopssre/imperialschool/viewstv/MusicPacks;->net:Lru/oopssre/imperialschool/viewstv/HttpTransport;

    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v2, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    const-string v3, "manifest.json"

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    const-string v3, ""

    invoke-virtual {v1, v2, p3, v3}, Lru/oopssre/imperialschool/viewstv/HttpTransport;->json(Ljava/lang/String;ZLjava/lang/String;)Lorg/json/JSONObject;

    move-result-object p3

    .line 58
    const-string v1, "archive"

    invoke-virtual {p3, v1}, Lorg/json/JSONObject;->getJSONObject(Ljava/lang/String;)Lorg/json/JSONObject;

    move-result-object v1

    .line 59
    const-string v2, "sha256"

    invoke-virtual {v1, v2}, Lorg/json/JSONObject;->getString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v2

    .line 60
    const-string v4, "bytes"

    invoke-virtual {v1, v4}, Lorg/json/JSONObject;->getLong(Ljava/lang/String;)J

    move-result-wide v7

    .line 61
    const-string v1, "schema"

    invoke-virtual {p3, v1}, Lorg/json/JSONObject;->getInt(Ljava/lang/String;)I

    move-result v1

    const/4 v4, 0x1

    if-ne v1, v4, :cond_2

    const-string v1, "theme"

    invoke-virtual {p3, v1}, Lorg/json/JSONObject;->getString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object p3

    invoke-virtual {p1, p3}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p3

    if-eqz p3, :cond_2

    .line 62
    invoke-static {v2}, Lru/oopssre/imperialschool/viewstv/Protocol;->hash(Ljava/lang/String;)Z

    move-result p3

    if-eqz p3, :cond_2

    const-wide/16 v5, 0x0

    cmp-long p3, v7, v5

    if-lez p3, :cond_2

    const-wide/32 v5, 0x200000

    cmp-long p3, v7, v5

    if-gtz p3, :cond_2

    .line 65
    invoke-direct {p0, p1}, Lru/oopssre/imperialschool/viewstv/MusicPacks;->target(Ljava/lang/String;)Ljava/io/File;

    move-result-object p3

    if-eqz p2, :cond_0

    .line 66
    iget-object v1, p2, Lru/oopssre/imperialschool/viewstv/MusicPacks$Pack;->sha:Ljava/lang/String;

    invoke-virtual {v1, v2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v1

    if-eqz v1, :cond_0

    invoke-virtual {p3}, Ljava/io/File;->length()J

    move-result-wide v5

    cmp-long v1, v5, v7

    if-nez v1, :cond_0

    return-object p2

    .line 67
    :cond_0
    iget-object p2, p0, Lru/oopssre/imperialschool/viewstv/MusicPacks;->cache:Lru/oopssre/imperialschool/viewstv/CacheStore;

    invoke-virtual {p2, v7, v8, v3}, Lru/oopssre/imperialschool/viewstv/CacheStore;->reserve(JLjava/lang/String;)V

    .line 68
    iget-object p2, p0, Lru/oopssre/imperialschool/viewstv/MusicPacks;->cache:Lru/oopssre/imperialschool/viewstv/CacheStore;

    iget-object p2, p2, Lru/oopssre/imperialschool/viewstv/CacheStore;->root:Ljava/io/File;

    const-string v1, "music-"

    const-string v3, ".part"

    invoke-static {v1, v3, p2}, Ljava/io/File;->createTempFile(Ljava/lang/String;Ljava/lang/String;Ljava/io/File;)Ljava/io/File;

    move-result-object v6

    .line 71
    :try_start_0
    new-instance p2, Ljava/lang/StringBuilder;

    invoke-direct {p2}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {p2, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p2

    invoke-virtual {p2, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p2

    const-string v0, ".zip"

    invoke-virtual {p2, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p2

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v5

    const-wide/32 v9, 0x200000

    invoke-static/range {v5 .. v10}, Lru/oopssre/imperialschool/viewstv/HttpTransport;->download(Ljava/lang/String;Ljava/io/File;JJ)V
    :try_end_0
    .catch Lru/oopssre/imperialschool/viewstv/HttpTransport$HttpFailure; {:try_start_0 .. :try_end_0} :catch_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 75
    :try_start_1
    invoke-static {v6}, Lru/oopssre/imperialschool/viewstv/CacheStore;->sha(Ljava/io/File;)Ljava/lang/String;

    move-result-object p2

    invoke-virtual {v2, p2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p2

    if-eqz p2, :cond_1

    .line 76
    invoke-static {v6, p1, v2}, Lru/oopssre/imperialschool/viewstv/MusicPacks;->read(Ljava/io/File;Ljava/lang/String;Ljava/lang/String;)Lru/oopssre/imperialschool/viewstv/MusicPacks$Pack;

    move-result-object p1

    .line 77
    invoke-virtual {v6}, Ljava/io/File;->toPath()Ljava/nio/file/Path;

    move-result-object p2

    invoke-virtual {p3}, Ljava/io/File;->toPath()Ljava/nio/file/Path;

    move-result-object p3

    const/4 v0, 0x2

    new-array v0, v0, [Ljava/nio/file/CopyOption;

    sget-object v1, Ljava/nio/file/StandardCopyOption;->ATOMIC_MOVE:Ljava/nio/file/StandardCopyOption;

    const/4 v2, 0x0

    aput-object v1, v0, v2

    sget-object v1, Ljava/nio/file/StandardCopyOption;->REPLACE_EXISTING:Ljava/nio/file/StandardCopyOption;

    aput-object v1, v0, v4

    invoke-static {p2, p3, v0}, Ljava/nio/file/Files;->move(Ljava/nio/file/Path;Ljava/nio/file/Path;[Ljava/nio/file/CopyOption;)Ljava/nio/file/Path;
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    .line 80
    invoke-virtual {v6}, Ljava/io/File;->delete()Z

    return-object p1

    .line 75
    :cond_1
    :try_start_2
    new-instance p1, Ljava/io/IOException;

    const-string p2, "\u041c\u0443\u0437\u044b\u043a\u0430\u043b\u044c\u043d\u044b\u0439 \u043f\u0430\u043a\u0435\u0442 \u043f\u043e\u0432\u0440\u0435\u0436\u0434\u0451\u043d"

    invoke-direct {p1, p2}, Ljava/io/IOException;-><init>(Ljava/lang/String;)V

    throw p1

    :catchall_0
    move-exception v0

    move-object p1, v0

    goto :goto_0

    :catch_0
    move-exception v0

    move-object p1, v0

    .line 73
    new-instance p2, Ljava/io/IOException;

    const-string p3, "\u041c\u0443\u0437\u044b\u043a\u0430\u043b\u044c\u043d\u044b\u0439 \u043f\u0430\u043a\u0435\u0442 \u043d\u0435\u0434\u043e\u0441\u0442\u0443\u043f\u0435\u043d"

    invoke-direct {p2, p3, p1}, Ljava/io/IOException;-><init>(Ljava/lang/String;Ljava/lang/Throwable;)V

    throw p2
    :try_end_2
    .catchall {:try_start_2 .. :try_end_2} :catchall_0

    .line 80
    :goto_0
    invoke-virtual {v6}, Ljava/io/File;->delete()Z

    .line 81
    throw p1

    .line 63
    :cond_2
    new-instance p1, Ljava/io/IOException;

    const-string p2, "\u041d\u0435\u0432\u0435\u0440\u043d\u043e\u0435 \u043e\u043f\u0438\u0441\u0430\u043d\u0438\u0435 \u043c\u0443\u0437\u044b\u043a\u0430\u043b\u044c\u043d\u043e\u0433\u043e \u043f\u0430\u043a\u0435\u0442\u0430"

    invoke-direct {p1, p2}, Ljava/io/IOException;-><init>(Ljava/lang/String;)V

    throw p1
.end method
