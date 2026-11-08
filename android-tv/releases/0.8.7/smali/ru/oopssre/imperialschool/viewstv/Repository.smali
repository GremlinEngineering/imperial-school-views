.class final Lru/oopssre/imperialschool/viewstv/Repository;
.super Ljava/lang/Object;
.source "Repository.java"


# instance fields
.field final cache:Lru/oopssre/imperialschool/viewstv/CacheStore;

.field final context:Landroid/content/Context;

.field final net:Lru/oopssre/imperialschool/viewstv/HttpTransport;

.field final prefs:Landroid/content/SharedPreferences;

.field final proxy:Lru/oopssre/imperialschool/viewstv/ProxyPreferences;

.field volatile screen:[I


# direct methods
.method constructor <init>(Landroid/content/Context;)V
    .locals 5

    .line 12
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    const/16 v0, 0x780

    const/16 v1, 0x438

    .line 11
    filled-new-array {v0, v1}, [I

    move-result-object v0

    iput-object v0, p0, Lru/oopssre/imperialschool/viewstv/Repository;->screen:[I

    .line 12
    invoke-virtual {p1}, Landroid/content/Context;->getApplicationContext()Landroid/content/Context;

    move-result-object p1

    iput-object p1, p0, Lru/oopssre/imperialschool/viewstv/Repository;->context:Landroid/content/Context;

    invoke-static {p1}, Lru/oopssre/imperialschool/viewstv/ProxyPreferences;->get(Landroid/content/Context;)Lru/oopssre/imperialschool/viewstv/ProxyPreferences;

    move-result-object v0

    iput-object v0, p0, Lru/oopssre/imperialschool/viewstv/Repository;->proxy:Lru/oopssre/imperialschool/viewstv/ProxyPreferences;

    new-instance v0, Lru/oopssre/imperialschool/viewstv/CacheStore;

    invoke-virtual {p1}, Landroid/content/Context;->getCacheDir()Ljava/io/File;

    move-result-object v1

    invoke-direct {v0, v1}, Lru/oopssre/imperialschool/viewstv/CacheStore;-><init>(Ljava/io/File;)V

    iput-object v0, p0, Lru/oopssre/imperialschool/viewstv/Repository;->cache:Lru/oopssre/imperialschool/viewstv/CacheStore;

    new-instance v1, Lru/oopssre/imperialschool/viewstv/HttpTransport;

    invoke-direct {v1, v0}, Lru/oopssre/imperialschool/viewstv/HttpTransport;-><init>(Lru/oopssre/imperialschool/viewstv/CacheStore;)V

    iput-object v1, p0, Lru/oopssre/imperialschool/viewstv/Repository;->net:Lru/oopssre/imperialschool/viewstv/HttpTransport;

    const-string v0, "tv"

    const/4 v1, 0x0

    invoke-virtual {p1, v0, v1}, Landroid/content/Context;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;

    move-result-object v0

    iput-object v0, p0, Lru/oopssre/imperialschool/viewstv/Repository;->prefs:Landroid/content/SharedPreferences;

    const-string v2, "video_output"

    invoke-interface {v0, v2}, Landroid/content/SharedPreferences;->contains(Ljava/lang/String;)Z

    move-result v3

    if-nez v3, :cond_0

    invoke-interface {v0}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object v3

    const-string v4, "video_output_test"

    invoke-interface {v0, v4, v1}, Landroid/content/SharedPreferences;->getBoolean(Ljava/lang/String;Z)Z

    move-result v0

    invoke-interface {v3, v2, v0}, Landroid/content/SharedPreferences$Editor;->putBoolean(Ljava/lang/String;Z)Landroid/content/SharedPreferences$Editor;

    move-result-object v0

    invoke-interface {v0, v4}, Landroid/content/SharedPreferences$Editor;->remove(Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    move-result-object v0

    invoke-interface {v0}, Landroid/content/SharedPreferences$Editor;->apply()V

    :cond_0
    :try_start_0
    const-string v0, "window"

    invoke-virtual {p1, v0}, Landroid/content/Context;->getSystemService(Ljava/lang/String;)Ljava/lang/Object;

    move-result-object p1

    check-cast p1, Landroid/view/WindowManager;

    invoke-interface {p1}, Landroid/view/WindowManager;->getDefaultDisplay()Landroid/view/Display;

    move-result-object p1

    invoke-static {p1}, Lru/oopssre/imperialschool/viewstv/WallpaperSurface;->physicalSize(Landroid/view/Display;)[I

    move-result-object p1

    iput-object p1, p0, Lru/oopssre/imperialschool/viewstv/Repository;->screen:[I
    :try_end_0
    .catch Ljava/lang/RuntimeException; {:try_start_0 .. :try_end_0} :catch_0

    :catch_0
    return-void
.end method


# virtual methods
.method cached(Lru/oopssre/imperialschool/viewstv/Protocol$Theme;)Lru/oopssre/imperialschool/viewstv/Protocol$Frame;
    .locals 3

    .line 27
    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/Repository;->cache:Lru/oopssre/imperialschool/viewstv/CacheStore;

    invoke-virtual {v0, p1}, Lru/oopssre/imperialschool/viewstv/CacheStore;->cached(Lru/oopssre/imperialschool/viewstv/Protocol$Theme;)Lru/oopssre/imperialschool/viewstv/Protocol$Frame;

    move-result-object v0

    if-nez v0, :cond_0

    invoke-static {p1}, Lru/oopssre/imperialschool/viewstv/Protocol;->tvScene(Lru/oopssre/imperialschool/viewstv/Protocol$Theme;)Z

    move-result v1

    if-eqz v1, :cond_0

    invoke-virtual {p0}, Lru/oopssre/imperialschool/viewstv/Repository;->resolution()Ljava/lang/String;

    move-result-object v1

    const-string v2, "auto"

    invoke-virtual {v1, v2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v1

    if-eqz v1, :cond_0

    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/Repository;->cache:Lru/oopssre/imperialschool/viewstv/CacheStore;

    invoke-static {p1}, Lru/oopssre/imperialschool/viewstv/Protocol;->alternateTV(Lru/oopssre/imperialschool/viewstv/Protocol$Theme;)Lru/oopssre/imperialschool/viewstv/Protocol$Theme;

    move-result-object v1

    invoke-virtual {v0, v1}, Lru/oopssre/imperialschool/viewstv/CacheStore;->cached(Lru/oopssre/imperialschool/viewstv/Protocol$Theme;)Lru/oopssre/imperialschool/viewstv/Protocol$Frame;

    move-result-object v0

    :cond_0
    if-eqz v0, :cond_2

    iget-object p1, p1, Lru/oopssre/imperialschool/viewstv/Protocol$Theme;->kind:Ljava/lang/String;

    const-string v1, "weather"

    invoke-virtual {p1, v1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p1

    if-eqz p1, :cond_1

    iget-object p1, v0, Lru/oopssre/imperialschool/viewstv/Protocol$Frame;->sourceId:Ljava/lang/String;

    invoke-virtual {p0}, Lru/oopssre/imperialschool/viewstv/Repository;->weatherSource()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {p1, v1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p1

    if-eqz p1, :cond_2

    :cond_1
    return-object v0

    :cond_2
    const/4 p1, 0x0

    return-object p1
.end method

.method choose(Lru/oopssre/imperialschool/viewstv/Protocol$Theme;)V
    .locals 3

    .line 21
    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/Repository;->prefs:Landroid/content/SharedPreferences;

    invoke-interface {v0}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object v0

    const-string v1, "theme"

    iget-object v2, p1, Lru/oopssre/imperialschool/viewstv/Protocol$Theme;->id:Ljava/lang/String;

    invoke-interface {v0, v1, v2}, Landroid/content/SharedPreferences$Editor;->putString(Ljava/lang/String;Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    move-result-object v0

    iget-object v1, p1, Lru/oopssre/imperialschool/viewstv/Protocol$Theme;->descriptor:Lorg/json/JSONObject;

    invoke-virtual {v1}, Lorg/json/JSONObject;->toString()Ljava/lang/String;

    move-result-object v1

    const-string v2, "descriptor"

    invoke-interface {v0, v2, v1}, Landroid/content/SharedPreferences$Editor;->putString(Ljava/lang/String;Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    move-result-object v0

    const-string v1, "plain_width"

    iget v2, p1, Lru/oopssre/imperialschool/viewstv/Protocol$Theme;->width:I

    invoke-interface {v0, v1, v2}, Landroid/content/SharedPreferences$Editor;->putInt(Ljava/lang/String;I)Landroid/content/SharedPreferences$Editor;

    move-result-object v0

    const-string v1, "plain_height"

    iget p1, p1, Lru/oopssre/imperialschool/viewstv/Protocol$Theme;->height:I

    invoke-interface {v0, v1, p1}, Landroid/content/SharedPreferences$Editor;->putInt(Ljava/lang/String;I)Landroid/content/SharedPreferences$Editor;

    move-result-object p1

    invoke-interface {p1}, Landroid/content/SharedPreferences$Editor;->apply()V

    return-void
.end method

.method decode(Lru/oopssre/imperialschool/viewstv/Protocol$Frame;II)Landroid/graphics/Bitmap;
    .locals 2
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/io/IOException;
        }
    .end annotation

    .line 44
    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/Repository;->cache:Lru/oopssre/imperialschool/viewstv/CacheStore;

    iget-object v1, p1, Lru/oopssre/imperialschool/viewstv/Protocol$Frame;->sha:Ljava/lang/String;

    invoke-virtual {v0, v1}, Lru/oopssre/imperialschool/viewstv/CacheStore;->pinImage(Ljava/lang/String;)V

    :try_start_0
    invoke-virtual {p0, p1, p2, p3}, Lru/oopssre/imperialschool/viewstv/Repository;->decodePinned(Lru/oopssre/imperialschool/viewstv/Protocol$Frame;II)Landroid/graphics/Bitmap;

    move-result-object p2
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    iget-object p3, p0, Lru/oopssre/imperialschool/viewstv/Repository;->cache:Lru/oopssre/imperialschool/viewstv/CacheStore;

    iget-object p1, p1, Lru/oopssre/imperialschool/viewstv/Protocol$Frame;->sha:Ljava/lang/String;

    invoke-virtual {p3, p1}, Lru/oopssre/imperialschool/viewstv/CacheStore;->unpinImage(Ljava/lang/String;)V

    return-object p2

    :catchall_0
    move-exception p2

    iget-object p3, p0, Lru/oopssre/imperialschool/viewstv/Repository;->cache:Lru/oopssre/imperialschool/viewstv/CacheStore;

    iget-object p1, p1, Lru/oopssre/imperialschool/viewstv/Protocol$Frame;->sha:Ljava/lang/String;

    invoke-virtual {p3, p1}, Lru/oopssre/imperialschool/viewstv/CacheStore;->unpinImage(Ljava/lang/String;)V

    throw p2
.end method

.method decodePinned(Lru/oopssre/imperialschool/viewstv/Protocol$Frame;II)Landroid/graphics/Bitmap;
    .locals 7
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/io/IOException;
        }
    .end annotation

    .line 45
    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/Repository;->cache:Lru/oopssre/imperialschool/viewstv/CacheStore;

    invoke-virtual {v0, p1}, Lru/oopssre/imperialschool/viewstv/CacheStore;->image(Lru/oopssre/imperialschool/viewstv/Protocol$Frame;)Ljava/io/File;

    move-result-object v0

    iget-object v1, p0, Lru/oopssre/imperialschool/viewstv/Repository;->cache:Lru/oopssre/imperialschool/viewstv/CacheStore;

    invoke-virtual {v1, p1}, Lru/oopssre/imperialschool/viewstv/CacheStore;->valid(Lru/oopssre/imperialschool/viewstv/Protocol$Frame;)Z

    move-result v1

    if-eqz v1, :cond_5

    new-instance v1, Landroid/graphics/BitmapFactory$Options;

    invoke-direct {v1}, Landroid/graphics/BitmapFactory$Options;-><init>()V

    sget-object v2, Landroid/graphics/Bitmap$Config;->ARGB_8888:Landroid/graphics/Bitmap$Config;

    iput-object v2, v1, Landroid/graphics/BitmapFactory$Options;->inPreferredConfig:Landroid/graphics/Bitmap$Config;

    const/4 v2, 0x1

    :goto_0
    iget v3, p1, Lru/oopssre/imperialschool/viewstv/Protocol$Frame;->width:I

    div-int/2addr v3, v2

    int-to-long v3, v3

    iget v5, p1, Lru/oopssre/imperialschool/viewstv/Protocol$Frame;->height:I

    div-int/2addr v5, v2

    int-to-long v5, v5

    mul-long/2addr v3, v5

    const-wide/32 v5, 0xb71b00

    cmp-long v3, v3, v5

    if-lez v3, :cond_0

    mul-int/lit8 v2, v2, 0x2

    goto :goto_0

    :cond_0
    :goto_1
    iget v3, p1, Lru/oopssre/imperialschool/viewstv/Protocol$Frame;->width:I

    mul-int/lit8 v4, v2, 0x2

    div-int/2addr v3, v4

    if-lt v3, p2, :cond_1

    iget v3, p1, Lru/oopssre/imperialschool/viewstv/Protocol$Frame;->height:I

    div-int/2addr v3, v4

    if-lt v3, p3, :cond_1

    move v2, v4

    goto :goto_1

    :cond_1
    const/4 p1, 0x0

    :goto_2
    const/4 p2, 0x4

    if-ge p1, p2, :cond_4

    .line 46
    iput v2, v1, Landroid/graphics/BitmapFactory$Options;->inSampleSize:I

    :try_start_0
    invoke-virtual {v0}, Ljava/io/File;->getPath()Ljava/lang/String;

    move-result-object p2

    invoke-static {p2, v1}, Landroid/graphics/BitmapFactory;->decodeFile(Ljava/lang/String;Landroid/graphics/BitmapFactory$Options;)Landroid/graphics/Bitmap;

    move-result-object p2

    if-eqz p2, :cond_2

    return-object p2

    :cond_2
    new-instance p2, Ljava/io/IOException;

    const-string p3, "\u0418\u0437\u043e\u0431\u0440\u0430\u0436\u0435\u043d\u0438\u0435 \u043d\u0435 \u043e\u0442\u043a\u0440\u044b\u0432\u0430\u0435\u0442\u0441\u044f"

    invoke-direct {p2, p3}, Ljava/io/IOException;-><init>(Ljava/lang/String;)V

    throw p2
    :try_end_0
    .catch Ljava/lang/OutOfMemoryError; {:try_start_0 .. :try_end_0} :catch_0

    :catch_0
    move-exception p2

    invoke-virtual {p0}, Lru/oopssre/imperialschool/viewstv/Repository;->resolution()Ljava/lang/String;

    move-result-object p3

    const-string v3, "auto"

    invoke-virtual {p3, v3}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p3

    if-eqz p3, :cond_3

    mul-int/lit8 v2, v2, 0x2

    add-int/lit8 p1, p1, 0x1

    goto :goto_2

    :cond_3
    new-instance p1, Ljava/io/IOException;

    new-instance p3, Ljava/lang/StringBuilder;

    const-string v0, "\u041d\u0435 \u0445\u0432\u0430\u0442\u0438\u043b\u043e \u043f\u0430\u043c\u044f\u0442\u0438 \u0434\u043b\u044f \u0432\u044b\u0431\u0440\u0430\u043d\u043d\u043e\u0433\u043e \u0440\u0430\u0437\u0440\u0435\u0448\u0435\u043d\u0438\u044f \u00b7 "

    invoke-direct {p3, v0}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {p0}, Lru/oopssre/imperialschool/viewstv/Repository;->resolution()Ljava/lang/String;

    move-result-object v0

    invoke-static {v0}, Lru/oopssre/imperialschool/viewstv/TvDisplay;->label(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p3, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p3

    invoke-virtual {p3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p3

    invoke-direct {p1, p3, p2}, Ljava/io/IOException;-><init>(Ljava/lang/String;Ljava/lang/Throwable;)V

    throw p1

    .line 47
    :cond_4
    new-instance p1, Ljava/io/IOException;

    const-string p2, "\u0422\u0435\u043b\u0435\u0432\u0438\u0437\u043e\u0440\u0443 \u043d\u0435 \u0445\u0432\u0430\u0442\u0438\u043b\u043e \u043f\u0430\u043c\u044f\u0442\u0438 \u043d\u0430 \u043a\u0430\u0434\u0440"

    invoke-direct {p1, p2}, Ljava/io/IOException;-><init>(Ljava/lang/String;)V

    throw p1

    .line 45
    :cond_5
    new-instance p1, Ljava/io/IOException;

    const-string p2, "\u041a\u0435\u0448 \u043a\u0430\u0434\u0440\u0430 \u043f\u043e\u0432\u0440\u0435\u0436\u0434\u0451\u043d"

    invoke-direct {p1, p2}, Ljava/io/IOException;-><init>(Ljava/lang/String;)V

    throw p1
.end method

.method displaySize(II)V
    .locals 0

    .line 15
    filled-new-array {p1, p2}, [I

    move-result-object p1

    iput-object p1, p0, Lru/oopssre/imperialschool/viewstv/Repository;->screen:[I

    return-void
.end method

.method fill(Z)V
    .locals 2

    .line 22
    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/Repository;->prefs:Landroid/content/SharedPreferences;

    invoke-interface {v0}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object v0

    const-string v1, "fill"

    invoke-interface {v0, v1, p1}, Landroid/content/SharedPreferences$Editor;->putBoolean(Ljava/lang/String;Z)Landroid/content/SharedPreferences$Editor;

    move-result-object p1

    invoke-interface {p1}, Landroid/content/SharedPreferences$Editor;->apply()V

    return-void
.end method

.method fill()Z
    .locals 3

    .line 22
    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/Repository;->prefs:Landroid/content/SharedPreferences;

    const-string v1, "fill"

    const/4 v2, 0x0

    invoke-interface {v0, v1, v2}, Landroid/content/SharedPreferences;->getBoolean(Ljava/lang/String;Z)Z

    move-result v0

    return v0
.end method

.method finish(Lru/oopssre/imperialschool/viewstv/Protocol$Frame;Ljava/lang/String;)Lru/oopssre/imperialschool/viewstv/Protocol$Frame;
    .locals 3
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/lang/Exception;
        }
    .end annotation

    .line 29
    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/Repository;->cache:Lru/oopssre/imperialschool/viewstv/CacheStore;

    iget-object v1, p1, Lru/oopssre/imperialschool/viewstv/Protocol$Frame;->sha:Ljava/lang/String;

    invoke-virtual {v0, v1}, Lru/oopssre/imperialschool/viewstv/CacheStore;->pinImage(Ljava/lang/String;)V

    .line 30
    :try_start_0
    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/Repository;->net:Lru/oopssre/imperialschool/viewstv/HttpTransport;

    invoke-virtual {v0, p1, p2}, Lru/oopssre/imperialschool/viewstv/HttpTransport;->image(Lru/oopssre/imperialschool/viewstv/Protocol$Frame;Ljava/lang/String;)Ljava/io/File;

    move-result-object p2

    new-instance v0, Landroid/graphics/BitmapFactory$Options;

    invoke-direct {v0}, Landroid/graphics/BitmapFactory$Options;-><init>()V

    const/4 v1, 0x1

    iput-boolean v1, v0, Landroid/graphics/BitmapFactory$Options;->inJustDecodeBounds:Z

    invoke-virtual {p2}, Ljava/io/File;->getPath()Ljava/lang/String;

    move-result-object p2

    invoke-static {p2, v0}, Landroid/graphics/BitmapFactory;->decodeFile(Ljava/lang/String;Landroid/graphics/BitmapFactory$Options;)Landroid/graphics/Bitmap;

    iget p2, v0, Landroid/graphics/BitmapFactory$Options;->outWidth:I

    iget v2, p1, Lru/oopssre/imperialschool/viewstv/Protocol$Frame;->width:I

    if-ne p2, v2, :cond_0

    iget p2, v0, Landroid/graphics/BitmapFactory$Options;->outHeight:I

    iget v0, p1, Lru/oopssre/imperialschool/viewstv/Protocol$Frame;->height:I

    if-ne p2, v0, :cond_0

    goto :goto_0

    :cond_0
    const/4 v1, 0x0

    :goto_0
    const-string p2, "\u0420\u0430\u0437\u043c\u0435\u0440 \u0438\u0437\u043e\u0431\u0440\u0430\u0436\u0435\u043d\u0438\u044f \u043d\u0435 \u0441\u043e\u0432\u043f\u0430\u043b \u0441 \u043e\u043f\u0438\u0441\u0430\u043d\u0438\u0435\u043c"

    invoke-static {v1, p2}, Lru/oopssre/imperialschool/viewstv/Protocol;->require(ZLjava/lang/String;)V

    iget-object p2, p0, Lru/oopssre/imperialschool/viewstv/Repository;->cache:Lru/oopssre/imperialschool/viewstv/CacheStore;

    invoke-virtual {p2, p1}, Lru/oopssre/imperialschool/viewstv/CacheStore;->save(Lru/oopssre/imperialschool/viewstv/Protocol$Frame;)V
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 31
    iget-object p2, p0, Lru/oopssre/imperialschool/viewstv/Repository;->cache:Lru/oopssre/imperialschool/viewstv/CacheStore;

    iget-object v0, p1, Lru/oopssre/imperialschool/viewstv/Protocol$Frame;->sha:Ljava/lang/String;

    invoke-virtual {p2, v0}, Lru/oopssre/imperialschool/viewstv/CacheStore;->unpinImage(Ljava/lang/String;)V

    return-object p1

    :catchall_0
    move-exception p2

    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/Repository;->cache:Lru/oopssre/imperialschool/viewstv/CacheStore;

    iget-object p1, p1, Lru/oopssre/imperialschool/viewstv/Protocol$Frame;->sha:Ljava/lang/String;

    invoke-virtual {v0, p1}, Lru/oopssre/imperialschool/viewstv/CacheStore;->unpinImage(Ljava/lang/String;)V

    throw p2
.end method

.method refresh(Lru/oopssre/imperialschool/viewstv/Protocol$Theme;Ljava/lang/String;)Lru/oopssre/imperialschool/viewstv/Protocol$Frame;
    .locals 13
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/lang/Exception;
        }
    .end annotation

    move-object v7, p2

    .line 34
    iget-object v0, p1, Lru/oopssre/imperialschool/viewstv/Protocol$Theme;->kind:Ljava/lang/String;

    const-string v1, "dynamic"

    invoke-virtual {v0, v1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    const-string v1, "weather"

    if-nez v0, :cond_0

    iget-object v0, p1, Lru/oopssre/imperialschool/viewstv/Protocol$Theme;->kind:Ljava/lang/String;

    invoke-virtual {v0, v1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-nez v0, :cond_0

    invoke-virtual {p0, p2}, Lru/oopssre/imperialschool/viewstv/Repository;->refreshCatalogue(Ljava/lang/String;)V

    new-instance v0, Lorg/json/JSONObject;

    new-instance v1, Ljava/lang/String;

    new-instance v2, Ljava/io/File;

    iget-object v4, p0, Lru/oopssre/imperialschool/viewstv/Repository;->cache:Lru/oopssre/imperialschool/viewstv/CacheStore;

    iget-object v4, v4, Lru/oopssre/imperialschool/viewstv/CacheStore;->root:Ljava/io/File;

    const-string v5, "catalogue.json"

    invoke-direct {v2, v4, v5}, Ljava/io/File;-><init>(Ljava/io/File;Ljava/lang/String;)V

    const-wide/32 v4, 0x500000

    invoke-static {v2, v4, v5}, Lru/oopssre/imperialschool/viewstv/CacheStore;->read(Ljava/io/File;J)[B

    move-result-object v2

    sget-object v4, Ljava/nio/charset/StandardCharsets;->UTF_8:Ljava/nio/charset/Charset;

    invoke-direct {v1, v2, v4}, Ljava/lang/String;-><init>([BLjava/nio/charset/Charset;)V

    invoke-direct {v0, v1}, Lorg/json/JSONObject;-><init>(Ljava/lang/String;)V

    invoke-virtual/range {p0 .. p1}, Lru/oopssre/imperialschool/viewstv/Repository;->simpleMode(Lru/oopssre/imperialschool/viewstv/Protocol$Theme;)Ljava/lang/String;

    move-result-object v1

    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J

    move-result-wide v4

    invoke-static {v0, p1, v1, v4, v5}, Lru/oopssre/imperialschool/viewstv/Sources;->ordinary(Lorg/json/JSONObject;Lru/oopssre/imperialschool/viewstv/Protocol$Theme;Ljava/lang/String;J)Lru/oopssre/imperialschool/viewstv/Protocol$Frame;

    move-result-object v0

    invoke-virtual {p0, v0, p2}, Lru/oopssre/imperialschool/viewstv/Repository;->finish(Lru/oopssre/imperialschool/viewstv/Protocol$Frame;Ljava/lang/String;)Lru/oopssre/imperialschool/viewstv/Protocol$Frame;

    move-result-object v0

    return-object v0

    .line 35
    :cond_0
    iget-object v0, p1, Lru/oopssre/imperialschool/viewstv/Protocol$Theme;->kind:Ljava/lang/String;

    invoke-virtual {v0, v1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    const/4 v8, 0x2

    const/4 v1, 0x0

    const/4 v9, 0x1

    const/4 v10, 0x0

    if-eqz v0, :cond_4

    invoke-virtual {p0}, Lru/oopssre/imperialschool/viewstv/Repository;->weatherSource()Ljava/lang/String;

    move-result-object v0

    invoke-static {p1, v0}, Lru/oopssre/imperialschool/viewstv/Sources;->source(Lru/oopssre/imperialschool/viewstv/Protocol$Theme;Ljava/lang/String;)Lorg/json/JSONObject;

    move-result-object v11

    move v12, v10

    :goto_0
    if-ge v12, v8, :cond_3

    :try_start_0
    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/Repository;->net:Lru/oopssre/imperialschool/viewstv/HttpTransport;

    const-string v1, "current_url"

    invoke-virtual {v11, v1}, Lorg/json/JSONObject;->getString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v1

    if-lez v12, :cond_1

    move v2, v9

    goto :goto_1

    :cond_1
    move v2, v10

    :goto_1
    invoke-virtual {v0, v1, v2, p2}, Lru/oopssre/imperialschool/viewstv/HttpTransport;->json(Ljava/lang/String;ZLjava/lang/String;)Lorg/json/JSONObject;

    move-result-object v1

    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/Repository;->net:Lru/oopssre/imperialschool/viewstv/HttpTransport;

    const-string v2, "forecasts"

    invoke-virtual {v11, v2}, Lorg/json/JSONObject;->getJSONObject(Ljava/lang/String;)Lorg/json/JSONObject;

    move-result-object v2

    iget-object v4, p1, Lru/oopssre/imperialschool/viewstv/Protocol$Theme;->device:Ljava/lang/String;

    invoke-virtual {v2, v4}, Lorg/json/JSONObject;->getString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v2

    if-lez v12, :cond_2

    move v4, v9

    goto :goto_2

    :cond_2
    move v4, v10

    :goto_2
    invoke-virtual {v0, v2, v4, p2}, Lru/oopssre/imperialschool/viewstv/HttpTransport;->json(Ljava/lang/String;ZLjava/lang/String;)Lorg/json/JSONObject;

    move-result-object v2

    invoke-virtual {p0}, Lru/oopssre/imperialschool/viewstv/Repository;->weatherSource()Ljava/lang/String;

    move-result-object v4

    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J

    move-result-wide v5

    move-object v3, p1

    invoke-static/range {v1 .. v6}, Lru/oopssre/imperialschool/viewstv/Sources;->weather(Lorg/json/JSONObject;Lorg/json/JSONObject;Lru/oopssre/imperialschool/viewstv/Protocol$Theme;Ljava/lang/String;J)Lru/oopssre/imperialschool/viewstv/Protocol$Frame;

    move-result-object v0

    invoke-virtual {p0, v0, p2}, Lru/oopssre/imperialschool/viewstv/Repository;->finish(Lru/oopssre/imperialschool/viewstv/Protocol$Frame;Ljava/lang/String;)Lru/oopssre/imperialschool/viewstv/Protocol$Frame;

    move-result-object v0
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    return-object v0

    :catch_0
    move-exception v0

    move-object v1, v0

    add-int/lit8 v12, v12, 0x1

    goto :goto_0

    :cond_3
    throw v1

    :cond_4
    move v2, v10

    :goto_3
    if-ge v2, v8, :cond_8

    .line 39
    :try_start_1
    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/Repository;->net:Lru/oopssre/imperialschool/viewstv/HttpTransport;

    iget-object v1, p1, Lru/oopssre/imperialschool/viewstv/Protocol$Theme;->current:Ljava/lang/String;

    if-lez v2, :cond_5

    move v4, v9

    goto :goto_4

    :cond_5
    move v4, v10

    :goto_4
    invoke-virtual {v0, v1, v4, p2}, Lru/oopssre/imperialschool/viewstv/HttpTransport;->json(Ljava/lang/String;ZLjava/lang/String;)Lorg/json/JSONObject;

    move-result-object v0

    invoke-virtual {p0}, Lru/oopssre/imperialschool/viewstv/Repository;->resolution()Ljava/lang/String;

    move-result-object v1

    const-string v4, "auto"

    invoke-virtual {v1, v4}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v1

    invoke-static {v0, p1, v1}, Lru/oopssre/imperialschool/viewstv/Protocol;->publishedTheme(Lorg/json/JSONObject;Lru/oopssre/imperialschool/viewstv/Protocol$Theme;Z)Lru/oopssre/imperialschool/viewstv/Protocol$Theme;

    move-result-object v1

    invoke-static {v0, v1}, Lru/oopssre/imperialschool/viewstv/Protocol;->statePath(Lorg/json/JSONObject;Lru/oopssre/imperialschool/viewstv/Protocol$Theme;)Ljava/lang/String;

    move-result-object v4

    iget-object v5, p0, Lru/oopssre/imperialschool/viewstv/Repository;->net:Lru/oopssre/imperialschool/viewstv/HttpTransport;

    if-lez v2, :cond_6

    move v6, v9

    goto :goto_5

    :cond_6
    move v6, v10

    :goto_5
    invoke-virtual {v5, v4, v6, p2}, Lru/oopssre/imperialschool/viewstv/HttpTransport;->json(Ljava/lang/String;ZLjava/lang/String;)Lorg/json/JSONObject;

    move-result-object v4

    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J

    move-result-wide v5

    invoke-static {v4, v0, v1, v5, v6}, Lru/oopssre/imperialschool/viewstv/Protocol;->frame(Lorg/json/JSONObject;Lorg/json/JSONObject;Lru/oopssre/imperialschool/viewstv/Protocol$Theme;J)Lru/oopssre/imperialschool/viewstv/Protocol$Frame;

    move-result-object v0

    .line 40
    invoke-virtual {p0, v0, p2}, Lru/oopssre/imperialschool/viewstv/Repository;->finish(Lru/oopssre/imperialschool/viewstv/Protocol$Frame;Ljava/lang/String;)Lru/oopssre/imperialschool/viewstv/Protocol$Frame;

    move-result-object v0
    :try_end_1
    .catch Ljava/lang/Exception; {:try_start_1 .. :try_end_1} :catch_1

    return-object v0

    :catch_1
    move-exception v0

    move-object v1, v0

    .line 41
    nop

    instance-of v0, v1, Lru/oopssre/imperialschool/viewstv/HttpTransport$HttpFailure;

    if-nez v0, :cond_7

    add-int/lit8 v2, v2, 0x1

    goto :goto_3

    :cond_7
    throw v1

    .line 42
    :cond_8
    throw v1
.end method

.method refreshCatalogue(Ljava/lang/String;)V
    .locals 5
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/lang/Exception;
        }
    .end annotation

    .line 23
    new-instance v0, Ljava/io/File;

    iget-object v1, p0, Lru/oopssre/imperialschool/viewstv/Repository;->cache:Lru/oopssre/imperialschool/viewstv/CacheStore;

    iget-object v1, v1, Lru/oopssre/imperialschool/viewstv/CacheStore;->root:Ljava/io/File;

    const-string v2, "catalogue.json"

    invoke-direct {v0, v1, v2}, Ljava/io/File;-><init>(Ljava/io/File;Ljava/lang/String;)V

    invoke-virtual {v0}, Ljava/io/File;->isFile()Z

    move-result v1

    if-eqz v1, :cond_0

    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J

    move-result-wide v1

    invoke-virtual {v0}, Ljava/io/File;->lastModified()J

    move-result-wide v3

    sub-long/2addr v1, v3

    const-wide/32 v3, 0xdbba0

    cmp-long v1, v1, v3

    if-gez v1, :cond_0

    return-void

    :cond_0
    iget-object v1, p0, Lru/oopssre/imperialschool/viewstv/Repository;->net:Lru/oopssre/imperialschool/viewstv/HttpTransport;

    const-string v2, "manifest-v3.json"

    const/4 v3, 0x0

    invoke-virtual {v1, v2, v3, p1}, Lru/oopssre/imperialschool/viewstv/HttpTransport;->json(Ljava/lang/String;ZLjava/lang/String;)Lorg/json/JSONObject;

    move-result-object v1

    invoke-static {v1}, Lru/oopssre/imperialschool/viewstv/Protocol;->catalogue(Lorg/json/JSONObject;)Ljava/util/List;

    invoke-virtual {v1}, Lorg/json/JSONObject;->toString()Ljava/lang/String;

    move-result-object v1

    sget-object v2, Ljava/nio/charset/StandardCharsets;->UTF_8:Ljava/nio/charset/Charset;

    invoke-virtual {v1, v2}, Ljava/lang/String;->getBytes(Ljava/nio/charset/Charset;)[B

    move-result-object v1

    iget-object v2, p0, Lru/oopssre/imperialschool/viewstv/Repository;->cache:Lru/oopssre/imperialschool/viewstv/CacheStore;

    array-length v3, v1

    int-to-long v3, v3

    invoke-virtual {v2, v3, v4, p1}, Lru/oopssre/imperialschool/viewstv/CacheStore;->reserve(JLjava/lang/String;)V

    invoke-static {v0, v1}, Lru/oopssre/imperialschool/viewstv/CacheStore;->atomic(Ljava/io/File;[B)V

    return-void
.end method

.method resolution()Ljava/lang/String;
    .locals 3

    .line 16
    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/Repository;->prefs:Landroid/content/SharedPreferences;

    const-string v1, "resolution"

    const-string v2, "auto"

    invoke-interface {v0, v1, v2}, Landroid/content/SharedPreferences;->getString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    invoke-static {v0}, Lru/oopssre/imperialschool/viewstv/TvDisplay;->resolution(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    return-object v0
.end method

.method resolution(Ljava/lang/String;)V
    .locals 2

    .line 17
    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/Repository;->prefs:Landroid/content/SharedPreferences;

    invoke-interface {v0}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object v0

    const-string v1, "resolution"

    invoke-static {p1}, Lru/oopssre/imperialschool/viewstv/TvDisplay;->resolution(Ljava/lang/String;)Ljava/lang/String;

    move-result-object p1

    invoke-interface {v0, v1, p1}, Landroid/content/SharedPreferences$Editor;->putString(Ljava/lang/String;Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    move-result-object p1

    invoke-interface {p1}, Landroid/content/SharedPreferences$Editor;->apply()V

    return-void
.end method

.method selected()Lru/oopssre/imperialschool/viewstv/Protocol$Theme;
    .locals 13

    .line 20
    const-string v0, "type"

    iget-object v1, p0, Lru/oopssre/imperialschool/viewstv/Repository;->prefs:Landroid/content/SharedPreferences;

    const-string v2, "theme"

    const-string v3, "orbital-port"

    invoke-interface {v1, v2, v3}, Landroid/content/SharedPreferences;->getString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v1

    invoke-virtual {p0}, Lru/oopssre/imperialschool/viewstv/Repository;->themes()Ljava/util/List;

    move-result-object v2

    invoke-interface {v2}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object v2

    :cond_0
    invoke-interface {v2}, Ljava/util/Iterator;->hasNext()Z

    move-result v3

    if-eqz v3, :cond_1

    invoke-interface {v2}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v3

    check-cast v3, Lru/oopssre/imperialschool/viewstv/Protocol$Theme;

    iget-object v4, v3, Lru/oopssre/imperialschool/viewstv/Protocol$Theme;->id:Ljava/lang/String;

    invoke-virtual {v4, v1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v4

    if-eqz v4, :cond_0

    return-object v3

    :cond_1
    :try_start_0
    new-instance v12, Lorg/json/JSONObject;

    iget-object v1, p0, Lru/oopssre/imperialschool/viewstv/Repository;->prefs:Landroid/content/SharedPreferences;

    const-string v2, "descriptor"

    invoke-static {}, Lru/oopssre/imperialschool/viewstv/Protocol;->defaultTheme()Lru/oopssre/imperialschool/viewstv/Protocol$Theme;

    move-result-object v3

    iget-object v3, v3, Lru/oopssre/imperialschool/viewstv/Protocol$Theme;->descriptor:Lorg/json/JSONObject;

    invoke-virtual {v3}, Lorg/json/JSONObject;->toString()Ljava/lang/String;

    move-result-object v3

    invoke-interface {v1, v2, v3}, Landroid/content/SharedPreferences;->getString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v1

    invoke-direct {v12, v1}, Lorg/json/JSONObject;-><init>(Ljava/lang/String;)V

    invoke-virtual {v12, v0}, Lorg/json/JSONObject;->optString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v1

    const-string v2, "dynamic"

    invoke-virtual {v1, v2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v1

    if-eqz v1, :cond_2

    invoke-static {v12}, Lru/oopssre/imperialschool/viewstv/Protocol;->theme(Lorg/json/JSONObject;)Lru/oopssre/imperialschool/viewstv/Protocol$Theme;

    move-result-object v0

    invoke-virtual {p0, v0}, Lru/oopssre/imperialschool/viewstv/Repository;->tv(Lru/oopssre/imperialschool/viewstv/Protocol$Theme;)Lru/oopssre/imperialschool/viewstv/Protocol$Theme;

    move-result-object v0

    return-object v0

    :cond_2
    invoke-virtual {v12, v0}, Lorg/json/JSONObject;->optString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    const-string v1, "weather"

    invoke-virtual {v0, v1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_3

    new-instance v0, Lorg/json/JSONObject;

    invoke-direct {v0}, Lorg/json/JSONObject;-><init>()V

    invoke-static {v12, v0}, Lru/oopssre/imperialschool/viewstv/Sources;->theme(Lorg/json/JSONObject;Lorg/json/JSONObject;)Lru/oopssre/imperialschool/viewstv/Protocol$Theme;

    move-result-object v0

    return-object v0

    :cond_3
    new-instance v5, Lru/oopssre/imperialschool/viewstv/Protocol$Theme;

    const-string v0, "id"

    invoke-virtual {v12, v0}, Lorg/json/JSONObject;->getString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v6

    const-string v0, "title"

    invoke-virtual {v12, v0}, Lorg/json/JSONObject;->getString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v7

    const-string v8, "plain"

    const-string v9, ""

    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/Repository;->prefs:Landroid/content/SharedPreferences;

    const-string v1, "plain_width"

    const/16 v2, 0xf00

    invoke-interface {v0, v1, v2}, Landroid/content/SharedPreferences;->getInt(Ljava/lang/String;I)I

    move-result v10

    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/Repository;->prefs:Landroid/content/SharedPreferences;

    const-string v1, "plain_height"

    const/16 v2, 0x870

    invoke-interface {v0, v1, v2}, Landroid/content/SharedPreferences;->getInt(Ljava/lang/String;I)I

    move-result v11

    invoke-direct/range {v5 .. v12}, Lru/oopssre/imperialschool/viewstv/Protocol$Theme;-><init>(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;IILorg/json/JSONObject;)V
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    return-object v5

    :catch_0
    :try_start_1
    invoke-static {}, Lru/oopssre/imperialschool/viewstv/Protocol;->defaultTheme()Lru/oopssre/imperialschool/viewstv/Protocol$Theme;

    move-result-object v0

    invoke-virtual {p0, v0}, Lru/oopssre/imperialschool/viewstv/Repository;->tv(Lru/oopssre/imperialschool/viewstv/Protocol$Theme;)Lru/oopssre/imperialschool/viewstv/Protocol$Theme;

    move-result-object v0
    :try_end_1
    .catch Ljava/lang/Exception; {:try_start_1 .. :try_end_1} :catch_1

    return-object v0

    :catch_1
    move-exception v0

    new-instance v1, Ljava/lang/IllegalStateException;

    invoke-direct {v1, v0}, Ljava/lang/IllegalStateException;-><init>(Ljava/lang/Throwable;)V

    throw v1
.end method

.method simpleMode()Ljava/lang/String;
    .locals 1

    .line 25
    invoke-virtual {p0}, Lru/oopssre/imperialschool/viewstv/Repository;->selected()Lru/oopssre/imperialschool/viewstv/Protocol$Theme;

    move-result-object v0

    invoke-virtual {p0, v0}, Lru/oopssre/imperialschool/viewstv/Repository;->simpleMode(Lru/oopssre/imperialschool/viewstv/Protocol$Theme;)Ljava/lang/String;

    move-result-object v0

    return-object v0
.end method

.method simpleMode(Lru/oopssre/imperialschool/viewstv/Protocol$Theme;)Ljava/lang/String;
    .locals 3

    .line 26
    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/Repository;->prefs:Landroid/content/SharedPreferences;

    new-instance v1, Ljava/lang/StringBuilder;

    const-string v2, "simple_mode_"

    invoke-direct {v1, v2}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    iget-object p1, p1, Lru/oopssre/imperialschool/viewstv/Protocol$Theme;->id:Ljava/lang/String;

    invoke-virtual {v1, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p1

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    const-string v1, "auto"

    invoke-interface {v0, p1, v1}, Landroid/content/SharedPreferences;->getString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object p1

    return-object p1
.end method

.method themes()Ljava/util/List;
    .locals 5
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "()",
            "Ljava/util/List<",
            "Lru/oopssre/imperialschool/viewstv/Protocol$Theme;",
            ">;"
        }
    .end annotation

    .line 19
    :try_start_0
    new-instance v0, Lorg/json/JSONObject;

    new-instance v1, Ljava/lang/String;

    new-instance v2, Ljava/io/File;

    iget-object v3, p0, Lru/oopssre/imperialschool/viewstv/Repository;->cache:Lru/oopssre/imperialschool/viewstv/CacheStore;

    iget-object v3, v3, Lru/oopssre/imperialschool/viewstv/CacheStore;->root:Ljava/io/File;

    const-string v4, "catalogue.json"

    invoke-direct {v2, v3, v4}, Ljava/io/File;-><init>(Ljava/io/File;Ljava/lang/String;)V

    const-wide/32 v3, 0x500000

    invoke-static {v2, v3, v4}, Lru/oopssre/imperialschool/viewstv/CacheStore;->read(Ljava/io/File;J)[B

    move-result-object v2

    sget-object v3, Ljava/nio/charset/StandardCharsets;->UTF_8:Ljava/nio/charset/Charset;

    invoke-direct {v1, v2, v3}, Ljava/lang/String;-><init>([BLjava/nio/charset/Charset;)V

    invoke-direct {v0, v1}, Lorg/json/JSONObject;-><init>(Ljava/lang/String;)V

    invoke-static {v0}, Lru/oopssre/imperialschool/viewstv/Protocol;->catalogue(Lorg/json/JSONObject;)Ljava/util/List;

    move-result-object v0

    new-instance v1, Ljava/util/ArrayList;

    invoke-direct {v1}, Ljava/util/ArrayList;-><init>()V

    invoke-interface {v0}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object v0

    :goto_0
    invoke-interface {v0}, Ljava/util/Iterator;->hasNext()Z

    move-result v2

    if-eqz v2, :cond_0

    invoke-interface {v0}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Lru/oopssre/imperialschool/viewstv/Protocol$Theme;

    invoke-virtual {p0, v2}, Lru/oopssre/imperialschool/viewstv/Repository;->tv(Lru/oopssre/imperialschool/viewstv/Protocol$Theme;)Lru/oopssre/imperialschool/viewstv/Protocol$Theme;

    move-result-object v2

    invoke-interface {v1, v2}, Ljava/util/List;->add(Ljava/lang/Object;)Z
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    goto :goto_0

    :cond_0
    return-object v1

    :catch_0
    :try_start_1
    invoke-static {}, Lru/oopssre/imperialschool/viewstv/Protocol;->defaultTheme()Lru/oopssre/imperialschool/viewstv/Protocol$Theme;

    move-result-object v0

    invoke-virtual {p0, v0}, Lru/oopssre/imperialschool/viewstv/Repository;->tv(Lru/oopssre/imperialschool/viewstv/Protocol$Theme;)Lru/oopssre/imperialschool/viewstv/Protocol$Theme;

    move-result-object v0

    invoke-static {v0}, Ljava/util/Collections;->singletonList(Ljava/lang/Object;)Ljava/util/List;

    move-result-object v0
    :try_end_1
    .catch Ljava/lang/Exception; {:try_start_1 .. :try_end_1} :catch_1

    return-object v0

    :catch_1
    move-exception v0

    new-instance v1, Ljava/lang/IllegalStateException;

    invoke-direct {v1, v0}, Ljava/lang/IllegalStateException;-><init>(Ljava/lang/Throwable;)V

    throw v1
.end method

.method tv(Lru/oopssre/imperialschool/viewstv/Protocol$Theme;)Lru/oopssre/imperialschool/viewstv/Protocol$Theme;
    .locals 5

    .line 18
    invoke-virtual {p0}, Lru/oopssre/imperialschool/viewstv/Repository;->videoPreferred()Z

    move-result v0

    iget-object v1, p1, Lru/oopssre/imperialschool/viewstv/Protocol$Theme;->kind:Ljava/lang/String;

    invoke-static {v0, v1}, Lru/oopssre/imperialschool/viewstv/PlaybackPolicy;->useVideo(ZLjava/lang/String;)Z

    move-result v0

    if-eqz v0, :cond_0

    invoke-static {p1}, Lru/oopssre/imperialschool/viewstv/Protocol;->videoProfile(Lru/oopssre/imperialschool/viewstv/Protocol$Theme;)Lru/oopssre/imperialschool/viewstv/Protocol$Theme;

    move-result-object p1

    return-object p1

    :cond_0
    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/Repository;->screen:[I

    invoke-virtual {p0}, Lru/oopssre/imperialschool/viewstv/Repository;->resolution()Ljava/lang/String;

    move-result-object v1

    const/4 v2, 0x0

    aget v3, v0, v2

    const/4 v4, 0x1

    aget v0, v0, v4

    invoke-static {v1, v3, v0}, Lru/oopssre/imperialschool/viewstv/TvDisplay;->targetSize(Ljava/lang/String;II)[I

    move-result-object v0

    aget v1, v0, v2

    aget v0, v0, v4

    invoke-static {p1, v1, v0}, Lru/oopssre/imperialschool/viewstv/Protocol;->forDisplay(Lru/oopssre/imperialschool/viewstv/Protocol$Theme;II)Lru/oopssre/imperialschool/viewstv/Protocol$Theme;

    move-result-object p1

    return-object p1
.end method

.method videoEnabled()Z
    .locals 2

    .line 14
    invoke-virtual {p0}, Lru/oopssre/imperialschool/viewstv/Repository;->videoPreferred()Z

    move-result v0

    invoke-virtual {p0}, Lru/oopssre/imperialschool/viewstv/Repository;->selected()Lru/oopssre/imperialschool/viewstv/Protocol$Theme;

    move-result-object v1

    iget-object v1, v1, Lru/oopssre/imperialschool/viewstv/Protocol$Theme;->kind:Ljava/lang/String;

    invoke-static {v0, v1}, Lru/oopssre/imperialschool/viewstv/PlaybackPolicy;->useVideo(ZLjava/lang/String;)Z

    move-result v0

    return v0
.end method

.method videoPreferred()Z
    .locals 3

    .line 13
    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/Repository;->prefs:Landroid/content/SharedPreferences;

    const-string v1, "video_output"

    const/4 v2, 0x0

    invoke-interface {v0, v1, v2}, Landroid/content/SharedPreferences;->getBoolean(Ljava/lang/String;Z)Z

    move-result v0

    return v0
.end method

.method weatherSource()Ljava/lang/String;
    .locals 3

    .line 24
    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/Repository;->prefs:Landroid/content/SharedPreferences;

    const-string v1, "weather_source"

    const-string v2, "real"

    invoke-interface {v0, v1, v2}, Landroid/content/SharedPreferences;->getString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    return-object v0
.end method
