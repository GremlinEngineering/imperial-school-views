.class public final Lru/oopssre/imperialschool/viewstv/Release;
.super Ljava/lang/Object;
.source "Release.java"


# instance fields
.field public final build:J

.field public final bytes:J

.field public final sha:Ljava/lang/String;

.field public final url:Ljava/lang/String;

.field public final version:Ljava/lang/String;


# direct methods
.method private constructor <init>(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;JJ)V
    .locals 0

    .line 8
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    iput-object p1, p0, Lru/oopssre/imperialschool/viewstv/Release;->version:Ljava/lang/String;

    iput-object p2, p0, Lru/oopssre/imperialschool/viewstv/Release;->url:Ljava/lang/String;

    iput-object p3, p0, Lru/oopssre/imperialschool/viewstv/Release;->sha:Ljava/lang/String;

    iput-wide p4, p0, Lru/oopssre/imperialschool/viewstv/Release;->build:J

    iput-wide p6, p0, Lru/oopssre/imperialschool/viewstv/Release;->bytes:J

    return-void
.end method

.method public static parse(Lorg/json/JSONObject;Ljava/lang/String;)Lru/oopssre/imperialschool/viewstv/Release;
    .locals 12
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Lorg/json/JSONException;
        }
    .end annotation

    .line 10
    const-string v0, "schema"

    invoke-virtual {p0, v0}, Lorg/json/JSONObject;->getInt(Ljava/lang/String;)I

    move-result v0

    const/4 v1, 0x0

    const/4 v2, 0x1

    if-ne v0, v2, :cond_0

    const-string v0, "app_id"

    invoke-virtual {p0, v0}, Lorg/json/JSONObject;->getString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    invoke-virtual {v0, p1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p1

    if-eqz p1, :cond_0

    const-string p1, "platform"

    invoke-virtual {p0, p1}, Lorg/json/JSONObject;->getString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object p1

    const-string v0, "android"

    invoke-virtual {p1, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p1

    if-eqz p1, :cond_0

    move p1, v2

    goto :goto_0

    :cond_0
    move p1, v1

    :goto_0
    const-string v0, "\u0420\u0435\u043b\u0438\u0437 \u043f\u0440\u0435\u0434\u043d\u0430\u0437\u043d\u0430\u0447\u0435\u043d \u0434\u043b\u044f \u0434\u0440\u0443\u0433\u043e\u0433\u043e \u043f\u0440\u0438\u043b\u043e\u0436\u0435\u043d\u0438\u044f"

    invoke-static {p1, v0}, Lru/oopssre/imperialschool/viewstv/Protocol;->require(ZLjava/lang/String;)V

    .line 11
    const-string p1, "release"

    invoke-virtual {p0, p1}, Lorg/json/JSONObject;->has(Ljava/lang/String;)Z

    move-result v0

    const-string v3, "\u041d\u0435\u0442 \u043f\u043e\u043b\u044f release"

    invoke-static {v0, v3}, Lru/oopssre/imperialschool/viewstv/Protocol;->require(ZLjava/lang/String;)V

    invoke-virtual {p0, p1}, Lorg/json/JSONObject;->isNull(Ljava/lang/String;)Z

    move-result v0

    if-eqz v0, :cond_1

    const/4 p0, 0x0

    return-object p0

    :cond_1
    invoke-virtual {p0, p1}, Lorg/json/JSONObject;->getJSONObject(Ljava/lang/String;)Lorg/json/JSONObject;

    move-result-object v3

    const-string p0, "version"

    invoke-virtual {v3, p0}, Lorg/json/JSONObject;->getString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object p0

    const-string p1, "url"

    invoke-virtual {v3, p1}, Lorg/json/JSONObject;->getString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object p1

    const-string v0, "sha256"

    invoke-virtual {v3, v0}, Lorg/json/JSONObject;->getString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    const-wide/16 v5, 0x1

    const-wide/32 v7, 0x7fffffff

    const-string v4, "build"

    invoke-static/range {v3 .. v8}, Lru/oopssre/imperialschool/viewstv/Protocol;->integer(Lorg/json/JSONObject;Ljava/lang/String;JJ)J

    move-result-wide v9

    const-wide/32 v7, 0x2000000

    const-string v4, "bytes"

    invoke-static/range {v3 .. v8}, Lru/oopssre/imperialschool/viewstv/Protocol;->integer(Lorg/json/JSONObject;Ljava/lang/String;JJ)J

    move-result-wide v3

    .line 12
    const-string v5, "https://games.oopssre.ru/assets/arcade/views/downloads/"

    invoke-virtual {p1, v5}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z

    move-result v5

    const-string v6, "\u041d\u0435\u0432\u0435\u0440\u043d\u044b\u0439 \u0430\u0434\u0440\u0435\u0441 APK"

    invoke-static {v5, v6}, Lru/oopssre/imperialschool/viewstv/Protocol;->require(ZLjava/lang/String;)V

    invoke-static {p1}, Lru/oopssre/imperialschool/viewstv/Protocol;->url(Ljava/lang/String;)Ljava/net/URI;

    move-result-object v5

    invoke-virtual {v5}, Ljava/net/URI;->getPath()Ljava/lang/String;

    move-result-object v5

    const-string v7, "/assets/arcade/views/downloads/"

    invoke-virtual {v5, v7}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z

    move-result v8

    if-eqz v8, :cond_2

    invoke-virtual {v7}, Ljava/lang/String;->length()I

    move-result v7

    invoke-virtual {v5, v7}, Ljava/lang/String;->substring(I)Ljava/lang/String;

    move-result-object v5

    const-string v7, "[a-zA-Z0-9][a-zA-Z0-9._-]*\\.apk"

    invoke-virtual {v5, v7}, Ljava/lang/String;->matches(Ljava/lang/String;)Z

    move-result v5

    if-eqz v5, :cond_2

    move v5, v2

    goto :goto_1

    :cond_2
    move v5, v1

    :goto_1
    invoke-static {v5, v6}, Lru/oopssre/imperialschool/viewstv/Protocol;->require(ZLjava/lang/String;)V

    .line 13
    const-string v5, "[0-9]+\\.[0-9]+\\.[0-9]+"

    invoke-virtual {p0, v5}, Ljava/lang/String;->matches(Ljava/lang/String;)Z

    move-result v5

    if-eqz v5, :cond_3

    invoke-static {v0}, Lru/oopssre/imperialschool/viewstv/Protocol;->hash(Ljava/lang/String;)Z

    move-result v5

    if-eqz v5, :cond_3

    const-wide/16 v5, 0x0

    cmp-long v7, v9, v5

    if-lez v7, :cond_3

    const-wide/32 v7, 0x7fffffff

    cmp-long v7, v9, v7

    if-gtz v7, :cond_3

    cmp-long v5, v3, v5

    if-lez v5, :cond_3

    const-wide/32 v5, 0x2000000

    cmp-long v5, v3, v5

    if-gtz v5, :cond_3

    move v1, v2

    :cond_3
    const-string v2, "\u041d\u0435\u0432\u0435\u0440\u043d\u043e\u0435 \u043e\u043f\u0438\u0441\u0430\u043d\u0438\u0435 \u0440\u0435\u043b\u0438\u0437\u0430"

    invoke-static {v1, v2}, Lru/oopssre/imperialschool/viewstv/Protocol;->require(ZLjava/lang/String;)V

    move-wide v8, v9

    move-wide v10, v3

    new-instance v4, Lru/oopssre/imperialschool/viewstv/Release;

    move-object v5, p0

    move-object v6, p1

    move-object v7, v0

    invoke-direct/range {v4 .. v11}, Lru/oopssre/imperialschool/viewstv/Release;-><init>(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;JJ)V

    return-object v4
.end method
