.class final Lru/oopssre/imperialschool/viewstv/Updater;
.super Ljava/lang/Object;
.source "Updater.java"


# static fields
.field static final FEED:Ljava/lang/String; = "android-tv-release.json"


# instance fields
.field final apk:Ljava/io/File;

.field final folder:Ljava/io/File;

.field final record:Ljava/io/File;

.field final repo:Lru/oopssre/imperialschool/viewstv/Repository;


# direct methods
.method constructor <init>(Lru/oopssre/imperialschool/viewstv/Repository;)V
    .locals 2

    .line 15
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    iput-object p1, p0, Lru/oopssre/imperialschool/viewstv/Updater;->repo:Lru/oopssre/imperialschool/viewstv/Repository;

    new-instance v0, Ljava/io/File;

    iget-object p1, p1, Lru/oopssre/imperialschool/viewstv/Repository;->context:Landroid/content/Context;

    invoke-virtual {p1}, Landroid/content/Context;->getCacheDir()Ljava/io/File;

    move-result-object p1

    const-string v1, "tv-update"

    invoke-direct {v0, p1, v1}, Ljava/io/File;-><init>(Ljava/io/File;Ljava/lang/String;)V

    iput-object v0, p0, Lru/oopssre/imperialschool/viewstv/Updater;->folder:Ljava/io/File;

    invoke-virtual {v0}, Ljava/io/File;->mkdirs()Z

    new-instance p1, Ljava/io/File;

    const-string v1, "update.apk"

    invoke-direct {p1, v0, v1}, Ljava/io/File;-><init>(Ljava/io/File;Ljava/lang/String;)V

    iput-object p1, p0, Lru/oopssre/imperialschool/viewstv/Updater;->apk:Ljava/io/File;

    new-instance p1, Ljava/io/File;

    const-string v1, "release.json"

    invoke-direct {p1, v0, v1}, Ljava/io/File;-><init>(Ljava/io/File;Ljava/lang/String;)V

    iput-object p1, p0, Lru/oopssre/imperialschool/viewstv/Updater;->record:Ljava/io/File;

    return-void
.end method

.method private static signatures([Landroid/content/pm/Signature;)Ljava/util/Set;
    .locals 4
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "([",
            "Landroid/content/pm/Signature;",
            ")",
            "Ljava/util/Set<",
            "Ljava/lang/String;",
            ">;"
        }
    .end annotation

    .line 32
    new-instance v0, Ljava/util/HashSet;

    invoke-direct {v0}, Ljava/util/HashSet;-><init>()V

    if-eqz p0, :cond_0

    array-length v1, p0

    const/4 v2, 0x0

    :goto_0
    if-ge v2, v1, :cond_0

    aget-object v3, p0, v2

    invoke-virtual {v3}, Landroid/content/pm/Signature;->toByteArray()[B

    move-result-object v3

    invoke-static {v3}, Lru/oopssre/imperialschool/viewstv/CacheStore;->hash([B)Ljava/lang/String;

    move-result-object v3

    invoke-interface {v0, v3}, Ljava/util/Set;->add(Ljava/lang/Object;)Z

    add-int/lit8 v2, v2, 0x1

    goto :goto_0

    :cond_0
    return-object v0
.end method

.method private validateApk(Lru/oopssre/imperialschool/viewstv/Release;Ljava/io/File;)V
    .locals 8
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/lang/Exception;
        }
    .end annotation

    .line 24
    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/Updater;->repo:Lru/oopssre/imperialschool/viewstv/Repository;

    iget-object v0, v0, Lru/oopssre/imperialschool/viewstv/Repository;->context:Landroid/content/Context;

    invoke-virtual {v0}, Landroid/content/Context;->getPackageManager()Landroid/content/pm/PackageManager;

    move-result-object v0

    sget v1, Landroid/os/Build$VERSION;->SDK_INT:I

    const/16 v2, 0x1c

    if-lt v1, v2, :cond_0

    const/high16 v1, 0x8000000

    goto :goto_0

    :cond_0
    const/16 v1, 0x40

    .line 25
    :goto_0
    invoke-virtual {p2}, Ljava/io/File;->getPath()Ljava/lang/String;

    move-result-object p2

    invoke-virtual {v0, p2, v1}, Landroid/content/pm/PackageManager;->getPackageArchiveInfo(Ljava/lang/String;I)Landroid/content/pm/PackageInfo;

    move-result-object p2

    iget-object v3, p0, Lru/oopssre/imperialschool/viewstv/Updater;->repo:Lru/oopssre/imperialschool/viewstv/Repository;

    iget-object v3, v3, Lru/oopssre/imperialschool/viewstv/Repository;->context:Landroid/content/Context;

    invoke-virtual {v3}, Landroid/content/Context;->getPackageName()Ljava/lang/String;

    move-result-object v3

    invoke-virtual {v0, v3, v1}, Landroid/content/pm/PackageManager;->getPackageInfo(Ljava/lang/String;I)Landroid/content/pm/PackageInfo;

    move-result-object v0

    const/4 v1, 0x1

    const/4 v3, 0x0

    if-eqz p2, :cond_1

    .line 26
    iget-object v4, p0, Lru/oopssre/imperialschool/viewstv/Updater;->repo:Lru/oopssre/imperialschool/viewstv/Repository;

    iget-object v4, v4, Lru/oopssre/imperialschool/viewstv/Repository;->context:Landroid/content/Context;

    invoke-virtual {v4}, Landroid/content/Context;->getPackageName()Ljava/lang/String;

    move-result-object v4

    iget-object v5, p2, Landroid/content/pm/PackageInfo;->packageName:Ljava/lang/String;

    invoke-virtual {v4, v5}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v4

    if-eqz v4, :cond_1

    move v4, v1

    goto :goto_1

    :cond_1
    move v4, v3

    :goto_1
    const-string v5, "APK \u043f\u0440\u0435\u0434\u043d\u0430\u0437\u043d\u0430\u0447\u0435\u043d \u0434\u043b\u044f \u0434\u0440\u0443\u0433\u043e\u0433\u043e \u043f\u0440\u0438\u043b\u043e\u0436\u0435\u043d\u0438\u044f"

    invoke-static {v4, v5}, Lru/oopssre/imperialschool/viewstv/Protocol;->require(ZLjava/lang/String;)V

    .line 27
    sget v4, Landroid/os/Build$VERSION;->SDK_INT:I

    if-lt v4, v2, :cond_2

    invoke-virtual {p2}, Landroid/content/pm/PackageInfo;->getLongVersionCode()J

    move-result-wide v4

    goto :goto_2

    :cond_2
    iget v4, p2, Landroid/content/pm/PackageInfo;->versionCode:I

    int-to-long v4, v4

    :goto_2
    iget-wide v6, p1, Lru/oopssre/imperialschool/viewstv/Release;->build:J

    cmp-long v6, v4, v6

    if-nez v6, :cond_3

    invoke-virtual {p0}, Lru/oopssre/imperialschool/viewstv/Updater;->installed()J

    move-result-wide v6

    cmp-long v4, v4, v6

    if-lez v4, :cond_3

    iget-object p1, p1, Lru/oopssre/imperialschool/viewstv/Release;->version:Ljava/lang/String;

    iget-object v4, p2, Landroid/content/pm/PackageInfo;->versionName:Ljava/lang/String;

    invoke-virtual {p1, v4}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p1

    if-eqz p1, :cond_3

    move p1, v1

    goto :goto_3

    :cond_3
    move p1, v3

    :goto_3
    const-string v4, "\u041d\u0435\u0432\u0435\u0440\u043d\u0430\u044f \u0432\u0435\u0440\u0441\u0438\u044f APK"

    invoke-static {p1, v4}, Lru/oopssre/imperialschool/viewstv/Protocol;->require(ZLjava/lang/String;)V

    .line 28
    sget p1, Landroid/os/Build$VERSION;->SDK_INT:I

    if-lt p1, v2, :cond_4

    iget-object p1, v0, Landroid/content/pm/PackageInfo;->signingInfo:Landroid/content/pm/SigningInfo;

    invoke-virtual {p1}, Landroid/content/pm/SigningInfo;->getApkContentsSigners()[Landroid/content/pm/Signature;

    move-result-object p1

    goto :goto_4

    :cond_4
    iget-object p1, v0, Landroid/content/pm/PackageInfo;->signatures:[Landroid/content/pm/Signature;

    .line 29
    :goto_4
    sget v0, Landroid/os/Build$VERSION;->SDK_INT:I

    if-lt v0, v2, :cond_5

    iget-object p2, p2, Landroid/content/pm/PackageInfo;->signingInfo:Landroid/content/pm/SigningInfo;

    invoke-virtual {p2}, Landroid/content/pm/SigningInfo;->getApkContentsSigners()[Landroid/content/pm/Signature;

    move-result-object p2

    goto :goto_5

    :cond_5
    iget-object p2, p2, Landroid/content/pm/PackageInfo;->signatures:[Landroid/content/pm/Signature;

    .line 30
    :goto_5
    invoke-static {p1}, Lru/oopssre/imperialschool/viewstv/Updater;->signatures([Landroid/content/pm/Signature;)Ljava/util/Set;

    move-result-object p1

    invoke-static {p2}, Lru/oopssre/imperialschool/viewstv/Updater;->signatures([Landroid/content/pm/Signature;)Ljava/util/Set;

    move-result-object p2

    invoke-interface {p1}, Ljava/util/Set;->isEmpty()Z

    move-result v0

    if-nez v0, :cond_6

    invoke-virtual {p1, p2}, Ljava/lang/Object;->equals(Ljava/lang/Object;)Z

    move-result p1

    if-eqz p1, :cond_6

    goto :goto_6

    :cond_6
    move v1, v3

    :goto_6
    const-string p1, "\u041f\u043e\u0434\u043f\u0438\u0441\u044c APK \u043d\u0435 \u0441\u043e\u0432\u043f\u0430\u0434\u0430\u0435\u0442 \u0441 \u0443\u0441\u0442\u0430\u043d\u043e\u0432\u043b\u0435\u043d\u043d\u044b\u043c \u043f\u0440\u0438\u043b\u043e\u0436\u0435\u043d\u0438\u0435\u043c"

    invoke-static {v1, p1}, Lru/oopssre/imperialschool/viewstv/Protocol;->require(ZLjava/lang/String;)V

    return-void
.end method


# virtual methods
.method check(Ljava/lang/String;)Lru/oopssre/imperialschool/viewstv/Release;
    .locals 10
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/lang/Exception;
        }
    .end annotation

    .line 19
    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/Updater;->repo:Lru/oopssre/imperialschool/viewstv/Repository;

    iget-object v0, v0, Lru/oopssre/imperialschool/viewstv/Repository;->net:Lru/oopssre/imperialschool/viewstv/HttpTransport;

    const-string v1, "android-tv-release.json"

    const/4 v2, 0x1

    invoke-virtual {v0, v1, v2, p1}, Lru/oopssre/imperialschool/viewstv/HttpTransport;->json(Ljava/lang/String;ZLjava/lang/String;)Lorg/json/JSONObject;

    move-result-object p1

    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/Updater;->repo:Lru/oopssre/imperialschool/viewstv/Repository;

    iget-object v0, v0, Lru/oopssre/imperialschool/viewstv/Repository;->context:Landroid/content/Context;

    invoke-virtual {v0}, Landroid/content/Context;->getPackageName()Ljava/lang/String;

    move-result-object v0

    invoke-static {p1, v0}, Lru/oopssre/imperialschool/viewstv/Release;->parse(Lorg/json/JSONObject;Ljava/lang/String;)Lru/oopssre/imperialschool/viewstv/Release;

    move-result-object v0

    if-eqz v0, :cond_3

    iget-wide v3, v0, Lru/oopssre/imperialschool/viewstv/Release;->build:J

    invoke-virtual {p0}, Lru/oopssre/imperialschool/viewstv/Updater;->installed()J

    move-result-wide v5

    cmp-long v1, v3, v5

    if-gtz v1, :cond_0

    goto/16 :goto_1

    .line 20
    :cond_0
    invoke-virtual {p0}, Lru/oopssre/imperialschool/viewstv/Updater;->ready()Lru/oopssre/imperialschool/viewstv/Release;

    move-result-object v1

    if-eqz v1, :cond_1

    iget-object v3, v1, Lru/oopssre/imperialschool/viewstv/Release;->sha:Ljava/lang/String;

    iget-object v4, v0, Lru/oopssre/imperialschool/viewstv/Release;->sha:Ljava/lang/String;

    invoke-virtual {v3, v4}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v3

    if-eqz v3, :cond_1

    return-object v1

    .line 21
    :cond_1
    new-instance v5, Ljava/io/File;

    iget-object v1, p0, Lru/oopssre/imperialschool/viewstv/Updater;->folder:Ljava/io/File;

    const-string v3, "update.part"

    invoke-direct {v5, v1, v3}, Ljava/io/File;-><init>(Ljava/io/File;Ljava/lang/String;)V

    :try_start_0
    iget-object v4, v0, Lru/oopssre/imperialschool/viewstv/Release;->url:Ljava/lang/String;

    iget-wide v6, v0, Lru/oopssre/imperialschool/viewstv/Release;->bytes:J

    const-wide/32 v8, 0x2000000

    invoke-static/range {v4 .. v9}, Lru/oopssre/imperialschool/viewstv/HttpTransport;->download(Ljava/lang/String;Ljava/io/File;JJ)V

    invoke-virtual {v5}, Ljava/io/File;->length()J

    move-result-wide v3

    iget-wide v6, v0, Lru/oopssre/imperialschool/viewstv/Release;->bytes:J

    cmp-long v1, v3, v6

    const/4 v3, 0x0

    if-nez v1, :cond_2

    invoke-static {v5}, Lru/oopssre/imperialschool/viewstv/CacheStore;->sha(Ljava/io/File;)Ljava/lang/String;

    move-result-object v1

    iget-object v4, v0, Lru/oopssre/imperialschool/viewstv/Release;->sha:Ljava/lang/String;

    invoke-virtual {v1, v4}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v1

    if-eqz v1, :cond_2

    move v1, v2

    goto :goto_0

    :cond_2
    move v1, v3

    :goto_0
    const-string v4, "APK \u0437\u0430\u0433\u0440\u0443\u0436\u0435\u043d \u0441 \u043e\u0448\u0438\u0431\u043a\u043e\u0439"

    invoke-static {v1, v4}, Lru/oopssre/imperialschool/viewstv/Protocol;->require(ZLjava/lang/String;)V

    invoke-direct {p0, v0, v5}, Lru/oopssre/imperialschool/viewstv/Updater;->validateApk(Lru/oopssre/imperialschool/viewstv/Release;Ljava/io/File;)V

    invoke-virtual {v5}, Ljava/io/File;->toPath()Ljava/nio/file/Path;

    move-result-object v1

    iget-object v4, p0, Lru/oopssre/imperialschool/viewstv/Updater;->apk:Ljava/io/File;

    invoke-virtual {v4}, Ljava/io/File;->toPath()Ljava/nio/file/Path;

    move-result-object v4

    const/4 v6, 0x2

    new-array v6, v6, [Ljava/nio/file/CopyOption;

    sget-object v7, Ljava/nio/file/StandardCopyOption;->ATOMIC_MOVE:Ljava/nio/file/StandardCopyOption;

    aput-object v7, v6, v3

    sget-object v3, Ljava/nio/file/StandardCopyOption;->REPLACE_EXISTING:Ljava/nio/file/StandardCopyOption;

    aput-object v3, v6, v2

    invoke-static {v1, v4, v6}, Ljava/nio/file/Files;->move(Ljava/nio/file/Path;Ljava/nio/file/Path;[Ljava/nio/file/CopyOption;)Ljava/nio/file/Path;

    iget-object v1, p0, Lru/oopssre/imperialschool/viewstv/Updater;->record:Ljava/io/File;

    invoke-virtual {p1}, Lorg/json/JSONObject;->toString()Ljava/lang/String;

    move-result-object p1

    sget-object v2, Ljava/nio/charset/StandardCharsets;->UTF_8:Ljava/nio/charset/Charset;

    invoke-virtual {p1, v2}, Ljava/lang/String;->getBytes(Ljava/nio/charset/Charset;)[B

    move-result-object p1

    invoke-static {v1, p1}, Lru/oopssre/imperialschool/viewstv/CacheStore;->atomic(Ljava/io/File;[B)V
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    invoke-virtual {v5}, Ljava/io/File;->delete()Z

    return-object v0

    :catchall_0
    move-exception v0

    move-object p1, v0

    invoke-virtual {v5}, Ljava/io/File;->delete()Z

    throw p1

    :cond_3
    :goto_1
    const/4 p1, 0x0

    return-object p1
.end method

.method installed()J
    .locals 3
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Landroid/content/pm/PackageManager$NameNotFoundException;
        }
    .end annotation

    .line 16
    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/Updater;->repo:Lru/oopssre/imperialschool/viewstv/Repository;

    iget-object v0, v0, Lru/oopssre/imperialschool/viewstv/Repository;->context:Landroid/content/Context;

    invoke-virtual {v0}, Landroid/content/Context;->getPackageManager()Landroid/content/pm/PackageManager;

    move-result-object v0

    iget-object v1, p0, Lru/oopssre/imperialschool/viewstv/Updater;->repo:Lru/oopssre/imperialschool/viewstv/Repository;

    iget-object v1, v1, Lru/oopssre/imperialschool/viewstv/Repository;->context:Landroid/content/Context;

    invoke-virtual {v1}, Landroid/content/Context;->getPackageName()Ljava/lang/String;

    move-result-object v1

    const/4 v2, 0x0

    invoke-virtual {v0, v1, v2}, Landroid/content/pm/PackageManager;->getPackageInfo(Ljava/lang/String;I)Landroid/content/pm/PackageInfo;

    move-result-object v0

    sget v1, Landroid/os/Build$VERSION;->SDK_INT:I

    const/16 v2, 0x1c

    if-lt v1, v2, :cond_0

    invoke-virtual {v0}, Landroid/content/pm/PackageInfo;->getLongVersionCode()J

    move-result-wide v0

    return-wide v0

    :cond_0
    iget v0, v0, Landroid/content/pm/PackageInfo;->versionCode:I

    int-to-long v0, v0

    return-wide v0
.end method

.method installer()Landroid/content/Intent;
    .locals 3

    .line 33
    new-instance v0, Ljava/lang/StringBuilder;

    const-string v1, "content://"

    invoke-direct {v0, v1}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    iget-object v1, p0, Lru/oopssre/imperialschool/viewstv/Updater;->repo:Lru/oopssre/imperialschool/viewstv/Repository;

    iget-object v1, v1, Lru/oopssre/imperialschool/viewstv/Repository;->context:Landroid/content/Context;

    invoke-virtual {v1}, Landroid/content/Context;->getPackageName()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    const-string v1, ".updates/update.apk"

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-static {v0}, Landroid/net/Uri;->parse(Ljava/lang/String;)Landroid/net/Uri;

    move-result-object v0

    new-instance v1, Landroid/content/Intent;

    const-string v2, "android.intent.action.VIEW"

    invoke-direct {v1, v2}, Landroid/content/Intent;-><init>(Ljava/lang/String;)V

    const-string v2, "application/vnd.android.package-archive"

    invoke-virtual {v1, v0, v2}, Landroid/content/Intent;->setDataAndType(Landroid/net/Uri;Ljava/lang/String;)Landroid/content/Intent;

    move-result-object v1

    const v2, 0x10000001

    invoke-virtual {v1, v2}, Landroid/content/Intent;->addFlags(I)Landroid/content/Intent;

    move-result-object v1

    const-string v2, "APK"

    invoke-static {v2, v0}, Landroid/content/ClipData;->newRawUri(Ljava/lang/CharSequence;Landroid/net/Uri;)Landroid/content/ClipData;

    move-result-object v0

    invoke-virtual {v1, v0}, Landroid/content/Intent;->setClipData(Landroid/content/ClipData;)V

    return-object v1
.end method

.method ready()Lru/oopssre/imperialschool/viewstv/Release;
    .locals 5

    .line 17
    :try_start_0
    new-instance v0, Lorg/json/JSONObject;

    new-instance v1, Ljava/lang/String;

    iget-object v2, p0, Lru/oopssre/imperialschool/viewstv/Updater;->record:Ljava/io/File;

    const-wide/32 v3, 0x186a0

    invoke-static {v2, v3, v4}, Lru/oopssre/imperialschool/viewstv/CacheStore;->read(Ljava/io/File;J)[B

    move-result-object v2

    sget-object v3, Ljava/nio/charset/StandardCharsets;->UTF_8:Ljava/nio/charset/Charset;

    invoke-direct {v1, v2, v3}, Ljava/lang/String;-><init>([BLjava/nio/charset/Charset;)V

    invoke-direct {v0, v1}, Lorg/json/JSONObject;-><init>(Ljava/lang/String;)V

    iget-object v1, p0, Lru/oopssre/imperialschool/viewstv/Updater;->repo:Lru/oopssre/imperialschool/viewstv/Repository;

    iget-object v1, v1, Lru/oopssre/imperialschool/viewstv/Repository;->context:Landroid/content/Context;

    invoke-virtual {v1}, Landroid/content/Context;->getPackageName()Ljava/lang/String;

    move-result-object v1

    invoke-static {v0, v1}, Lru/oopssre/imperialschool/viewstv/Release;->parse(Lorg/json/JSONObject;Ljava/lang/String;)Lru/oopssre/imperialschool/viewstv/Release;

    move-result-object v0

    if-eqz v0, :cond_0

    iget-wide v1, v0, Lru/oopssre/imperialschool/viewstv/Release;->build:J

    invoke-virtual {p0}, Lru/oopssre/imperialschool/viewstv/Updater;->installed()J

    move-result-wide v3

    cmp-long v1, v1, v3

    if-lez v1, :cond_0

    iget-object v1, p0, Lru/oopssre/imperialschool/viewstv/Updater;->apk:Ljava/io/File;

    invoke-virtual {v1}, Ljava/io/File;->length()J

    move-result-wide v1

    iget-wide v3, v0, Lru/oopssre/imperialschool/viewstv/Release;->bytes:J

    cmp-long v1, v1, v3

    if-nez v1, :cond_0

    iget-object v1, p0, Lru/oopssre/imperialschool/viewstv/Updater;->apk:Ljava/io/File;

    invoke-static {v1}, Lru/oopssre/imperialschool/viewstv/CacheStore;->sha(Ljava/io/File;)Ljava/lang/String;

    move-result-object v1

    iget-object v2, v0, Lru/oopssre/imperialschool/viewstv/Release;->sha:Ljava/lang/String;

    invoke-virtual {v1, v2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v1

    if-eqz v1, :cond_0

    iget-object v1, p0, Lru/oopssre/imperialschool/viewstv/Updater;->apk:Ljava/io/File;

    invoke-direct {p0, v0, v1}, Lru/oopssre/imperialschool/viewstv/Updater;->validateApk(Lru/oopssre/imperialschool/viewstv/Release;Ljava/io/File;)V
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    return-object v0

    :catch_0
    :cond_0
    const/4 v0, 0x0

    return-object v0
.end method
