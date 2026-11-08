.class public final Lru/oopssre/imperialschool/viewstv/Protocol;
.super Ljava/lang/Object;
.source "Protocol.java"


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lru/oopssre/imperialschool/viewstv/Protocol$Theme;,
        Lru/oopssre/imperialschool/viewstv/Protocol$NotReady;,
        Lru/oopssre/imperialschool/viewstv/Protocol$Frame;
    }
.end annotation


# static fields
.field public static final BASE:Ljava/lang/String; = "https://games.oopssre.ru/assets/arcade/views/"

.field public static final DEFAULT_DEVICE:Ljava/lang/String; = "desktop_3840x2160"

.field public static final DEFAULT_ID:Ljava/lang/String; = "orbital-port"

.field public static final FULL_HD_DEVICE:Ljava/lang/String; = "desktop_1920x1080"

.field public static final MAX_IMAGE:J = 0x2000000L


# direct methods
.method public constructor <init>()V
    .locals 0

    .line 9
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method public static alternateTV(Lru/oopssre/imperialschool/viewstv/Protocol$Theme;)Lru/oopssre/imperialschool/viewstv/Protocol$Theme;
    .locals 2

    .line 66
    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/Protocol$Theme;->device:Ljava/lang/String;

    const-string v1, "desktop_3840x2160"

    invoke-virtual {v0, v1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_0

    const-string v1, "desktop_1920x1080"

    :cond_0
    invoke-static {p0, v1}, Lru/oopssre/imperialschool/viewstv/Protocol;->tvProfile(Lru/oopssre/imperialschool/viewstv/Protocol$Theme;Ljava/lang/String;)Lru/oopssre/imperialschool/viewstv/Protocol$Theme;

    move-result-object p0

    return-object p0
.end method

.method public static catalogue(Lorg/json/JSONObject;)Ljava/util/List;
    .locals 6
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Lorg/json/JSONObject;",
            ")",
            "Ljava/util/List<",
            "Lru/oopssre/imperialschool/viewstv/Protocol$Theme;",
            ">;"
        }
    .end annotation

    .annotation system Ldalvik/annotation/Throws;
        value = {
            Lorg/json/JSONException;
        }
    .end annotation

    .line 48
    const-string v0, "schema"

    invoke-virtual {p0, v0}, Lorg/json/JSONObject;->getInt(Ljava/lang/String;)I

    move-result v0

    const/4 v1, 0x3

    const/4 v2, 0x1

    const/4 v3, 0x0

    if-ne v0, v1, :cond_0

    move v0, v2

    goto :goto_0

    :cond_0
    move v0, v3

    :goto_0
    const-string v1, "\u041d\u0435\u043f\u043e\u0434\u0434\u0435\u0440\u0436\u0438\u0432\u0430\u0435\u043c\u044b\u0439 \u043a\u0430\u0442\u0430\u043b\u043e\u0433 \u043e\u0431\u043e\u0435\u0432"

    invoke-static {v0, v1}, Lru/oopssre/imperialschool/viewstv/Protocol;->require(ZLjava/lang/String;)V

    const-string v0, "collections"

    invoke-virtual {p0, v0}, Lorg/json/JSONObject;->getJSONArray(Ljava/lang/String;)Lorg/json/JSONArray;

    move-result-object v0

    invoke-virtual {v0}, Lorg/json/JSONArray;->length()I

    move-result v1

    const/16 v4, 0x1f4

    if-gt v1, v4, :cond_1

    goto :goto_1

    :cond_1
    move v2, v3

    :goto_1
    const-string v1, "\u0421\u043b\u0438\u0448\u043a\u043e\u043c \u0431\u043e\u043b\u044c\u0448\u043e\u0439 \u043a\u0430\u0442\u0430\u043b\u043e\u0433"

    invoke-static {v2, v1}, Lru/oopssre/imperialschool/viewstv/Protocol;->require(ZLjava/lang/String;)V

    .line 49
    new-instance v1, Ljava/util/LinkedHashMap;

    invoke-direct {v1}, Ljava/util/LinkedHashMap;-><init>()V

    invoke-static {}, Lru/oopssre/imperialschool/viewstv/Protocol;->defaultTheme()Lru/oopssre/imperialschool/viewstv/Protocol$Theme;

    move-result-object v2

    iget-object v4, v2, Lru/oopssre/imperialschool/viewstv/Protocol$Theme;->id:Ljava/lang/String;

    invoke-virtual {v1, v4, v2}, Ljava/util/LinkedHashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 50
    :goto_2
    invoke-virtual {v0}, Lorg/json/JSONArray;->length()I

    move-result v2

    if-ge v3, v2, :cond_4

    invoke-virtual {v0, v3}, Lorg/json/JSONArray;->optJSONObject(I)Lorg/json/JSONObject;

    move-result-object v2

    if-nez v2, :cond_2

    goto :goto_4

    :cond_2
    :try_start_0
    const-string v4, "type"

    invoke-virtual {v2, v4}, Lorg/json/JSONObject;->optString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v4

    const-string v5, "dynamic"

    invoke-virtual {v4, v5}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v4

    if-eqz v4, :cond_3

    invoke-static {v2}, Lru/oopssre/imperialschool/viewstv/Protocol;->theme(Lorg/json/JSONObject;)Lru/oopssre/imperialschool/viewstv/Protocol$Theme;

    move-result-object v2

    goto :goto_3

    :cond_3
    invoke-static {v2, p0}, Lru/oopssre/imperialschool/viewstv/Sources;->theme(Lorg/json/JSONObject;Lorg/json/JSONObject;)Lru/oopssre/imperialschool/viewstv/Protocol$Theme;

    move-result-object v2

    :goto_3
    iget-object v4, v2, Lru/oopssre/imperialschool/viewstv/Protocol$Theme;->id:Ljava/lang/String;

    invoke-virtual {v1, v4, v2}, Ljava/util/LinkedHashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;
    :try_end_0
    .catch Ljava/lang/IllegalArgumentException; {:try_start_0 .. :try_end_0} :catch_0
    .catch Lorg/json/JSONException; {:try_start_0 .. :try_end_0} :catch_0

    :catch_0
    :goto_4
    add-int/lit8 v3, v3, 0x1

    goto :goto_2

    .line 51
    :cond_4
    new-instance p0, Ljava/util/ArrayList;

    invoke-virtual {v1}, Ljava/util/LinkedHashMap;->values()Ljava/util/Collection;

    move-result-object v0

    invoke-direct {p0, v0}, Ljava/util/ArrayList;-><init>(Ljava/util/Collection;)V

    return-object p0
.end method

.method public static defaultTheme()Lru/oopssre/imperialschool/viewstv/Protocol$Theme;
    .locals 5
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Lorg/json/JSONException;
        }
    .end annotation

    .line 31
    new-instance v0, Lorg/json/JSONObject;

    invoke-direct {v0}, Lorg/json/JSONObject;-><init>()V

    const-string v1, "id"

    const-string v2, "orbital-port"

    invoke-virtual {v0, v1, v2}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;

    move-result-object v0

    const-string v1, "type"

    const-string v2, "dynamic"

    invoke-virtual {v0, v1, v2}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;

    move-result-object v0

    const-string v1, "title"

    const-string v2, "\u041e\u0440\u0431\u0438\u0442\u0430\u043b\u044c\u043d\u044b\u0439 \u043f\u043e\u0440\u0442"

    invoke-virtual {v0, v1, v2}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;

    move-result-object v0

    const-string v1, "current_url"

    const-string v2, "dynamic/orbital-port/current.json"

    invoke-virtual {v0, v1, v2}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;

    move-result-object v0

    new-instance v1, Lorg/json/JSONObject;

    invoke-direct {v1}, Lorg/json/JSONObject;-><init>()V

    new-instance v2, Lorg/json/JSONObject;

    invoke-direct {v2}, Lorg/json/JSONObject;-><init>()V

    const-string v3, "width"

    const/16 v4, 0xf00

    invoke-virtual {v2, v3, v4}, Lorg/json/JSONObject;->put(Ljava/lang/String;I)Lorg/json/JSONObject;

    move-result-object v2

    const-string v3, "height"

    const/16 v4, 0x870

    invoke-virtual {v2, v3, v4}, Lorg/json/JSONObject;->put(Ljava/lang/String;I)Lorg/json/JSONObject;

    move-result-object v2

    const-string v3, "desktop_3840x2160"

    invoke-virtual {v1, v3, v2}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;

    move-result-object v1

    const-string v2, "formats"

    invoke-virtual {v0, v2, v1}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;

    move-result-object v0

    invoke-static {v0}, Lru/oopssre/imperialschool/viewstv/Protocol;->theme(Lorg/json/JSONObject;)Lru/oopssre/imperialschool/viewstv/Protocol$Theme;

    move-result-object v0

    return-object v0
.end method

.method static endpoint(Ljava/lang/String;Ljava/lang/String;)Z
    .locals 2

    .line 23
    invoke-static {p0}, Lru/oopssre/imperialschool/viewstv/Protocol;->url(Ljava/lang/String;)Ljava/net/URI;

    move-result-object v0

    invoke-static {p1}, Lru/oopssre/imperialschool/viewstv/Protocol;->url(Ljava/lang/String;)Ljava/net/URI;

    move-result-object v1

    invoke-virtual {v0, v1}, Ljava/net/URI;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-nez v0, :cond_1

    const-string v0, ".json"

    invoke-virtual {p1, v0}, Ljava/lang/String;->endsWith(Ljava/lang/String;)Z

    move-result v0

    if-eqz v0, :cond_0

    invoke-static {p0}, Lru/oopssre/imperialschool/viewstv/Protocol;->url(Ljava/lang/String;)Ljava/net/URI;

    move-result-object p0

    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p1

    const-string v0, ".br"

    invoke-virtual {p1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p1

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-static {p1}, Lru/oopssre/imperialschool/viewstv/Protocol;->url(Ljava/lang/String;)Ljava/net/URI;

    move-result-object p1

    invoke-virtual {p0, p1}, Ljava/net/URI;->equals(Ljava/lang/Object;)Z

    move-result p0

    if-eqz p0, :cond_0

    goto :goto_0

    :cond_0
    const/4 p0, 0x0

    return p0

    :cond_1
    :goto_0
    const/4 p0, 0x1

    return p0
.end method

.method public static forDisplay(Lru/oopssre/imperialschool/viewstv/Protocol$Theme;II)Lru/oopssre/imperialschool/viewstv/Protocol$Theme;
    .locals 1

    .line 65
    invoke-static {p0}, Lru/oopssre/imperialschool/viewstv/Protocol;->tvScene(Lru/oopssre/imperialschool/viewstv/Protocol$Theme;)Z

    move-result v0

    if-eqz v0, :cond_1

    invoke-static {p1, p2}, Lru/oopssre/imperialschool/viewstv/TvDisplay;->is4k(II)Z

    move-result p1

    if-eqz p1, :cond_0

    const-string p1, "desktop_3840x2160"

    goto :goto_0

    :cond_0
    const-string p1, "desktop_1920x1080"

    :goto_0
    invoke-static {p0, p1}, Lru/oopssre/imperialschool/viewstv/Protocol;->tvProfile(Lru/oopssre/imperialschool/viewstv/Protocol$Theme;Ljava/lang/String;)Lru/oopssre/imperialschool/viewstv/Protocol$Theme;

    move-result-object p0

    :cond_1
    return-object p0
.end method

.method public static frame(Lorg/json/JSONObject;Lorg/json/JSONObject;Lru/oopssre/imperialschool/viewstv/Protocol$Theme;J)Lru/oopssre/imperialschool/viewstv/Protocol$Frame;
    .locals 35
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Lorg/json/JSONException;
        }
    .end annotation

    move-object/from16 v0, p0

    move-object/from16 v1, p2

    .line 103
    const-string v2, "schema"

    invoke-virtual {v0, v2}, Lorg/json/JSONObject;->getInt(Ljava/lang/String;)I

    move-result v2

    const-string v3, "id"

    const-string v4, "theme_id"

    const-string v5, "device"

    const/4 v6, 0x0

    const/4 v7, 0x1

    if-ne v2, v7, :cond_0

    const-string v2, "type"

    invoke-virtual {v0, v2}, Lorg/json/JSONObject;->getString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v2

    const-string v8, "dynamic-state"

    invoke-virtual {v2, v8}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v2

    if-eqz v2, :cond_0

    invoke-virtual {v0, v4}, Lorg/json/JSONObject;->getString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v2

    iget-object v8, v1, Lru/oopssre/imperialschool/viewstv/Protocol$Theme;->id:Ljava/lang/String;

    invoke-virtual {v2, v8}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v2

    if-eqz v2, :cond_0

    invoke-virtual {v0, v5}, Lorg/json/JSONObject;->getString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v2

    iget-object v8, v1, Lru/oopssre/imperialschool/viewstv/Protocol$Theme;->device:Ljava/lang/String;

    invoke-virtual {v2, v8}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v2

    if-eqz v2, :cond_0

    invoke-virtual {v0, v3}, Lorg/json/JSONObject;->getString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v2

    invoke-static {v2}, Lru/oopssre/imperialschool/viewstv/Protocol;->hash(Ljava/lang/String;)Z

    move-result v2

    if-eqz v2, :cond_0

    move v2, v7

    goto :goto_0

    :cond_0
    move v2, v6

    :goto_0
    const-string v8, "\u041a\u0430\u0434\u0440 \u043e\u0442\u043d\u043e\u0441\u0438\u0442\u0441\u044f \u043a \u0434\u0440\u0443\u0433\u043e\u0439 \u0442\u0435\u043c\u0435 \u0438\u043b\u0438 \u0443\u0441\u0442\u0440\u043e\u0439\u0441\u0442\u0432\u0443"

    invoke-static {v2, v8}, Lru/oopssre/imperialschool/viewstv/Protocol;->require(ZLjava/lang/String;)V

    .line 104
    const-string v2, "inputs"

    invoke-virtual {v0, v2}, Lorg/json/JSONObject;->getJSONObject(Ljava/lang/String;)Lorg/json/JSONObject;

    move-result-object v2

    const-string v8, "recipe"

    invoke-virtual {v0, v8}, Lorg/json/JSONObject;->getJSONObject(Ljava/lang/String;)Lorg/json/JSONObject;

    move-result-object v8

    const-string v9, "image"

    invoke-virtual {v0, v9}, Lorg/json/JSONObject;->getJSONObject(Ljava/lang/String;)Lorg/json/JSONObject;

    move-result-object v10

    const-string v9, "schema_version"

    invoke-virtual {v2, v9}, Lorg/json/JSONObject;->optString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v11

    invoke-virtual {v0, v9, v11}, Lorg/json/JSONObject;->optString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v11

    .line 105
    const-string v12, "0.1"

    invoke-virtual {v11, v12}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v12

    const-string v13, "0.2"

    if-nez v12, :cond_1

    invoke-virtual {v11, v13}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v12

    if-eqz v12, :cond_2

    :cond_1
    invoke-virtual {v2, v9}, Lorg/json/JSONObject;->getString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v12

    invoke-virtual {v12, v11}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v12

    if-eqz v12, :cond_2

    invoke-virtual {v8, v9}, Lorg/json/JSONObject;->getString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v9

    invoke-virtual {v9, v11}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v9

    if-eqz v9, :cond_2

    invoke-virtual {v2, v5}, Lorg/json/JSONObject;->getString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v9

    iget-object v12, v1, Lru/oopssre/imperialschool/viewstv/Protocol$Theme;->device:Ljava/lang/String;

    invoke-virtual {v9, v12}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v9

    if-eqz v9, :cond_2

    invoke-virtual {v8, v5}, Lorg/json/JSONObject;->getString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v5

    iget-object v9, v1, Lru/oopssre/imperialschool/viewstv/Protocol$Theme;->device:Ljava/lang/String;

    invoke-virtual {v5, v9}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v5

    if-eqz v5, :cond_2

    invoke-virtual {v8, v4}, Lorg/json/JSONObject;->getString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v4

    iget-object v5, v1, Lru/oopssre/imperialschool/viewstv/Protocol$Theme;->id:Ljava/lang/String;

    invoke-virtual {v4, v5}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v4

    if-eqz v4, :cond_2

    move v4, v7

    goto :goto_1

    :cond_2
    move v4, v6

    :goto_1
    const-string v5, "\u041d\u0435\u043f\u043e\u0434\u0434\u0435\u0440\u0436\u0438\u0432\u0430\u0435\u043c\u043e\u0435 \u0441\u043e\u0441\u0442\u043e\u044f\u043d\u0438\u0435"

    invoke-static {v4, v5}, Lru/oopssre/imperialschool/viewstv/Protocol;->require(ZLjava/lang/String;)V

    .line 106
    const-string v4, "at"

    invoke-virtual {v0, v4}, Lorg/json/JSONObject;->getString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v5

    invoke-static {v5}, Lru/oopssre/imperialschool/viewstv/Protocol;->time(Ljava/lang/String;)J

    move-result-wide v25

    const-string v5, "valid_until"

    invoke-virtual {v0, v5}, Lorg/json/JSONObject;->getString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v5

    invoke-static {v5}, Lru/oopssre/imperialschool/viewstv/Protocol;->time(Ljava/lang/String;)J

    move-result-wide v27

    invoke-virtual {v2, v4}, Lorg/json/JSONObject;->getString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v4

    invoke-static {v4}, Lru/oopssre/imperialschool/viewstv/Protocol;->time(Ljava/lang/String;)J

    move-result-wide v4

    cmp-long v4, v25, v4

    if-nez v4, :cond_3

    cmp-long v4, v27, v25

    if-lez v4, :cond_3

    const-wide/32 v4, 0x1d4c0

    add-long v4, p3, v4

    cmp-long v4, v25, v4

    if-gtz v4, :cond_3

    move v4, v7

    goto :goto_2

    :cond_3
    move v4, v6

    :goto_2
    const-string v5, "\u041d\u0435\u0432\u0435\u0440\u043d\u043e\u0435 \u0432\u0440\u0435\u043c\u044f \u043a\u0430\u0434\u0440\u0430"

    invoke-static {v4, v5}, Lru/oopssre/imperialschool/viewstv/Protocol;->require(ZLjava/lang/String;)V

    .line 107
    const-string v4, "width"

    invoke-virtual {v8, v4}, Lorg/json/JSONObject;->getInt(Ljava/lang/String;)I

    move-result v5

    iget v9, v1, Lru/oopssre/imperialschool/viewstv/Protocol$Theme;->width:I

    const-string v12, "height"

    if-ne v5, v9, :cond_4

    invoke-virtual {v8, v12}, Lorg/json/JSONObject;->getInt(Ljava/lang/String;)I

    move-result v5

    iget v9, v1, Lru/oopssre/imperialschool/viewstv/Protocol$Theme;->height:I

    if-ne v5, v9, :cond_4

    const-string v5, "layers"

    invoke-virtual {v8, v5}, Lorg/json/JSONObject;->getJSONArray(Ljava/lang/String;)Lorg/json/JSONArray;

    move-result-object v5

    invoke-virtual {v5}, Lorg/json/JSONArray;->length()I

    move-result v5

    const/16 v8, 0x3e8

    if-gt v5, v8, :cond_4

    const-string v5, "active"

    invoke-virtual {v2, v5}, Lorg/json/JSONObject;->getJSONArray(Ljava/lang/String;)Lorg/json/JSONArray;

    move-result-object v5

    invoke-virtual {v5}, Lorg/json/JSONArray;->length()I

    move-result v5

    const/16 v8, 0x64

    if-gt v5, v8, :cond_4

    move v5, v7

    goto :goto_3

    :cond_4
    move v5, v6

    :goto_3
    const-string v8, "\u041d\u0435\u0432\u0435\u0440\u043d\u043e\u0435 \u043e\u043f\u0438\u0441\u0430\u043d\u0438\u0435 \u043a\u0430\u0434\u0440\u0430"

    invoke-static {v5, v8}, Lru/oopssre/imperialschool/viewstv/Protocol;->require(ZLjava/lang/String;)V

    .line 108
    invoke-virtual {v11, v13}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v5

    if-eqz v5, :cond_7

    const-string v5, "life"

    invoke-virtual {v0, v5}, Lorg/json/JSONObject;->getJSONObject(Ljava/lang/String;)Lorg/json/JSONObject;

    move-result-object v5

    const-string v8, "derived"

    invoke-virtual {v2, v8}, Lorg/json/JSONObject;->getJSONObject(Ljava/lang/String;)Lorg/json/JSONObject;

    move-result-object v2

    const-string v8, "timezone"

    invoke-virtual {v5, v8}, Lorg/json/JSONObject;->getString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v8

    invoke-static {v8}, Ljava/time/ZoneId;->of(Ljava/lang/String;)Ljava/time/ZoneId;

    const-string v8, "life_slot"

    invoke-virtual {v2, v8}, Lorg/json/JSONObject;->has(Ljava/lang/String;)Z

    move-result v9

    const-string v11, "\u041d\u0435\u0442 \u0431\u044b\u0442\u043e\u0432\u043e\u0433\u043e \u0441\u043e\u0441\u0442\u043e\u044f\u043d\u0438\u044f"

    invoke-static {v9, v11}, Lru/oopssre/imperialschool/viewstv/Protocol;->require(ZLjava/lang/String;)V

    invoke-virtual {v2, v8}, Lorg/json/JSONObject;->isNull(Ljava/lang/String;)Z

    move-result v9

    if-nez v9, :cond_6

    invoke-virtual {v2, v8}, Lorg/json/JSONObject;->get(Ljava/lang/String;)Ljava/lang/Object;

    move-result-object v2

    instance-of v8, v2, Ljava/lang/Number;

    const-string v9, "\u041d\u0435\u0432\u0435\u0440\u043d\u044b\u0439 \u0431\u044b\u0442\u043e\u0432\u043e\u0439 \u0447\u0430\u0441"

    invoke-static {v8, v9}, Lru/oopssre/imperialschool/viewstv/Protocol;->require(ZLjava/lang/String;)V

    check-cast v2, Ljava/lang/Number;

    invoke-virtual {v2}, Ljava/lang/Number;->doubleValue()D

    move-result-wide v13

    invoke-static {v13, v14}, Ljava/lang/Double;->isFinite(D)Z

    move-result v2

    if-eqz v2, :cond_5

    const-wide/16 v15, 0x0

    cmpl-double v2, v13, v15

    if-ltz v2, :cond_5

    const-wide/high16 v15, 0x4037000000000000L    # 23.0

    cmpg-double v2, v13, v15

    if-gtz v2, :cond_5

    invoke-static {v13, v14}, Ljava/lang/Math;->floor(D)D

    move-result-wide v15

    cmpl-double v2, v13, v15

    if-nez v2, :cond_5

    move v2, v7

    goto :goto_4

    :cond_5
    move v2, v6

    :goto_4
    invoke-static {v2, v9}, Lru/oopssre/imperialschool/viewstv/Protocol;->require(ZLjava/lang/String;)V

    :cond_6
    const/4 v2, 0x4

    new-array v2, v2, [Ljava/lang/String;

    const-string v8, "first_build"

    aput-object v8, v2, v6

    const-string v8, "base_changed"

    aput-object v8, v2, v7

    const/4 v8, 0x2

    const-string v9, "hour_blocked"

    aput-object v9, v2, v8

    const/4 v8, 0x3

    const-string v9, "stable_base"

    aput-object v9, v2, v8

    invoke-static {v2}, Ljava/util/Arrays;->asList([Ljava/lang/Object;)Ljava/util/List;

    move-result-object v2

    const-string v8, "reason"

    invoke-virtual {v5, v8}, Lorg/json/JSONObject;->getString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v5

    invoke-interface {v2, v5}, Ljava/util/List;->contains(Ljava/lang/Object;)Z

    move-result v2

    const-string v5, "\u041d\u0435\u0432\u0435\u0440\u043d\u043e\u0435 \u0431\u044b\u0442\u043e\u0432\u043e\u0435 \u0441\u043e\u0441\u0442\u043e\u044f\u043d\u0438\u0435"

    invoke-static {v2, v5}, Lru/oopssre/imperialschool/viewstv/Protocol;->require(ZLjava/lang/String;)V

    .line 109
    :cond_7
    const-string v2, "url"

    invoke-virtual {v10, v2}, Lorg/json/JSONObject;->getString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v5

    const-string v8, "sha256"

    invoke-virtual {v10, v8}, Lorg/json/JSONObject;->getString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v9

    const-string v11, "format"

    invoke-virtual {v10, v11}, Lorg/json/JSONObject;->getString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v13

    invoke-static {v13}, Lru/oopssre/imperialschool/viewstv/ImageFormat;->canonical(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v13

    move-object v15, v12

    move-object v14, v13

    const-wide/16 v12, 0x1

    move-object/from16 v16, v14

    move-object/from16 v17, v15

    const-wide/32 v14, 0x2000000

    move-object/from16 v18, v11

    const-string v11, "bytes"

    move-object/from16 v6, v16

    move-object/from16 v0, v17

    move-object/from16 v7, v18

    invoke-static/range {v10 .. v15}, Lru/oopssre/imperialschool/viewstv/Protocol;->integer(Lorg/json/JSONObject;Ljava/lang/String;JJ)J

    move-result-wide v23

    new-instance v11, Ljava/lang/StringBuilder;

    invoke-direct {v11}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v1}, Lru/oopssre/imperialschool/viewstv/Protocol$Theme;->prefix()Ljava/lang/String;

    move-result-object v12

    invoke-virtual {v11, v12}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v11

    const-string v12, "current."

    invoke-virtual {v11, v12}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v11

    invoke-virtual {v11, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v11

    invoke-virtual {v11}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v11

    invoke-static {v5, v11}, Lru/oopssre/imperialschool/viewstv/Protocol;->endpoint(Ljava/lang/String;Ljava/lang/String;)Z

    move-result v11

    if-eqz v11, :cond_8

    invoke-static {v5}, Lru/oopssre/imperialschool/viewstv/ImageFormat;->fromURL(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v11

    invoke-virtual {v11, v6}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v11

    if-eqz v11, :cond_8

    invoke-static {v9}, Lru/oopssre/imperialschool/viewstv/Protocol;->hash(Ljava/lang/String;)Z

    move-result v11

    if-eqz v11, :cond_8

    invoke-virtual {v10, v4}, Lorg/json/JSONObject;->getInt(Ljava/lang/String;)I

    move-result v11

    iget v13, v1, Lru/oopssre/imperialschool/viewstv/Protocol$Theme;->width:I

    if-ne v11, v13, :cond_8

    invoke-virtual {v10, v0}, Lorg/json/JSONObject;->getInt(Ljava/lang/String;)I

    move-result v10

    iget v11, v1, Lru/oopssre/imperialschool/viewstv/Protocol$Theme;->height:I

    if-ne v10, v11, :cond_8

    const/4 v10, 0x1

    goto :goto_5

    :cond_8
    const/4 v10, 0x0

    :goto_5
    const-string v11, "\u041d\u0435\u0432\u0435\u0440\u043d\u043e\u0435 \u0438\u0437\u043e\u0431\u0440\u0430\u0436\u0435\u043d\u0438\u0435 \u043a\u0430\u0434\u0440\u0430"

    invoke-static {v10, v11}, Lru/oopssre/imperialschool/viewstv/Protocol;->require(ZLjava/lang/String;)V

    .line 110
    const-string v10, "files"

    move-object/from16 v11, p1

    invoke-virtual {v11, v10}, Lorg/json/JSONObject;->getJSONObject(Ljava/lang/String;)Lorg/json/JSONObject;

    move-result-object v10

    iget-object v11, v1, Lru/oopssre/imperialschool/viewstv/Protocol$Theme;->device:Ljava/lang/String;

    invoke-virtual {v10, v11}, Lorg/json/JSONObject;->getJSONObject(Ljava/lang/String;)Lorg/json/JSONObject;

    move-result-object v10

    .line 111
    invoke-virtual {v10, v8}, Lorg/json/JSONObject;->getString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v8

    invoke-virtual {v8, v9}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v8

    if-eqz v8, :cond_9

    invoke-virtual {v10, v7}, Lorg/json/JSONObject;->getString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v7

    invoke-static {v7}, Lru/oopssre/imperialschool/viewstv/ImageFormat;->canonical(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v7

    invoke-virtual {v7, v6}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v7

    if-eqz v7, :cond_9

    invoke-virtual {v10, v2}, Lorg/json/JSONObject;->getString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v2

    new-instance v7, Ljava/lang/StringBuilder;

    invoke-direct {v7}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v1}, Lru/oopssre/imperialschool/viewstv/Protocol$Theme;->prefix()Ljava/lang/String;

    move-result-object v8

    invoke-virtual {v7, v8}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v7

    invoke-virtual {v7, v12}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v7

    invoke-virtual {v7, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v6

    invoke-virtual {v6}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v6

    invoke-static {v2, v6}, Lru/oopssre/imperialschool/viewstv/Protocol;->endpoint(Ljava/lang/String;Ljava/lang/String;)Z

    move-result v2

    if-eqz v2, :cond_9

    const-wide/16 v31, 0x1

    const-wide/32 v33, 0x2000000

    const-string v30, "bytes"

    move-object/from16 v29, v10

    invoke-static/range {v29 .. v34}, Lru/oopssre/imperialschool/viewstv/Protocol;->integer(Lorg/json/JSONObject;Ljava/lang/String;JJ)J

    move-result-wide v6

    move-object/from16 v2, v29

    cmp-long v6, v6, v23

    if-nez v6, :cond_9

    invoke-virtual {v2, v4}, Lorg/json/JSONObject;->getInt(Ljava/lang/String;)I

    move-result v4

    iget v6, v1, Lru/oopssre/imperialschool/viewstv/Protocol$Theme;->width:I

    if-ne v4, v6, :cond_9

    invoke-virtual {v2, v0}, Lorg/json/JSONObject;->getInt(Ljava/lang/String;)I

    move-result v0

    iget v2, v1, Lru/oopssre/imperialschool/viewstv/Protocol$Theme;->height:I

    if-ne v0, v2, :cond_9

    const/4 v6, 0x1

    goto :goto_6

    :cond_9
    const/4 v6, 0x0

    :goto_6
    const-string v0, "\u0421\u0435\u0440\u0432\u0435\u0440 \u043e\u0431\u043d\u043e\u0432\u043b\u044f\u0435\u0442 \u043a\u0430\u0434\u0440: \u043e\u043f\u0438\u0441\u0430\u043d\u0438\u0435 \u0435\u0449\u0451 \u043d\u0435 \u0441\u0438\u043d\u0445\u0440\u043e\u043d\u0438\u0437\u0438\u0440\u043e\u0432\u0430\u043d\u043e"

    invoke-static {v6, v0}, Lru/oopssre/imperialschool/viewstv/Protocol;->require(ZLjava/lang/String;)V

    .line 112
    new-instance v14, Lru/oopssre/imperialschool/viewstv/Protocol$Frame;

    iget-object v15, v1, Lru/oopssre/imperialschool/viewstv/Protocol$Theme;->id:Ljava/lang/String;

    iget-object v0, v1, Lru/oopssre/imperialschool/viewstv/Protocol$Theme;->device:Ljava/lang/String;

    iget-object v2, v1, Lru/oopssre/imperialschool/viewstv/Protocol$Theme;->title:Ljava/lang/String;

    move-object/from16 v4, p0

    invoke-virtual {v4, v3}, Lorg/json/JSONObject;->getString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v20

    iget v3, v1, Lru/oopssre/imperialschool/viewstv/Protocol$Theme;->width:I

    iget v1, v1, Lru/oopssre/imperialschool/viewstv/Protocol$Theme;->height:I

    move-object/from16 v16, v0

    move/from16 v22, v1

    move-object/from16 v17, v2

    move/from16 v21, v3

    move-object/from16 v18, v5

    move-object/from16 v19, v9

    invoke-direct/range {v14 .. v28}, Lru/oopssre/imperialschool/viewstv/Protocol$Frame;-><init>(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;IIJJJ)V

    return-object v14
.end method

.method static hash(Ljava/lang/String;)Z
    .locals 1

    .line 17
    const-string v0, "[a-f0-9]{64}"

    invoke-virtual {p0, v0}, Ljava/lang/String;->matches(Ljava/lang/String;)Z

    move-result p0

    return p0
.end method

.method static id(Ljava/lang/String;)Z
    .locals 1

    .line 16
    const-string v0, "[a-z][a-z0-9_-]{0,79}"

    invoke-virtual {p0, v0}, Ljava/lang/String;->matches(Ljava/lang/String;)Z

    move-result p0

    return p0
.end method

.method static integer(Lorg/json/JSONObject;Ljava/lang/String;JJ)J
    .locals 5
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Lorg/json/JSONException;
        }
    .end annotation

    .line 88
    invoke-virtual {p0, p1}, Lorg/json/JSONObject;->get(Ljava/lang/String;)Ljava/lang/Object;

    move-result-object p0

    instance-of v0, p0, Ljava/lang/Number;

    new-instance v1, Ljava/lang/StringBuilder;

    const-string v2, "\u041d\u0435\u0432\u0435\u0440\u043d\u043e\u0435 \u0447\u0438\u0441\u043b\u043e: "

    invoke-direct {v1, v2}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v1, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-static {v0, v1}, Lru/oopssre/imperialschool/viewstv/Protocol;->require(ZLjava/lang/String;)V

    check-cast p0, Ljava/lang/Number;

    invoke-virtual {p0}, Ljava/lang/Number;->doubleValue()D

    move-result-wide v0

    invoke-static {v0, v1}, Ljava/lang/Double;->isFinite(D)Z

    move-result v3

    if-eqz v3, :cond_0

    invoke-static {v0, v1}, Ljava/lang/Math;->floor(D)D

    move-result-wide v3

    cmpl-double v3, v0, v3

    if-nez v3, :cond_0

    long-to-double p2, p2

    cmpl-double p2, v0, p2

    if-ltz p2, :cond_0

    long-to-double p2, p4

    cmpg-double p2, v0, p2

    if-gtz p2, :cond_0

    const/4 p2, 0x1

    goto :goto_0

    :cond_0
    const/4 p2, 0x0

    :goto_0
    new-instance p3, Ljava/lang/StringBuilder;

    invoke-direct {p3, v2}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {p3, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p1

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-static {p2, p1}, Lru/oopssre/imperialschool/viewstv/Protocol;->require(ZLjava/lang/String;)V

    invoke-virtual {p0}, Ljava/lang/Number;->longValue()J

    move-result-wide p0

    return-wide p0
.end method

.method public static publishedTheme(Lorg/json/JSONObject;Lru/oopssre/imperialschool/viewstv/Protocol$Theme;)Lru/oopssre/imperialschool/viewstv/Protocol$Theme;
    .locals 1
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Lorg/json/JSONException;
        }
    .end annotation

    const/4 v0, 0x1

    .line 68
    invoke-static {p0, p1, v0}, Lru/oopssre/imperialschool/viewstv/Protocol;->publishedTheme(Lorg/json/JSONObject;Lru/oopssre/imperialschool/viewstv/Protocol$Theme;Z)Lru/oopssre/imperialschool/viewstv/Protocol$Theme;

    move-result-object p0

    return-object p0
.end method

.method public static publishedTheme(Lorg/json/JSONObject;Lru/oopssre/imperialschool/viewstv/Protocol$Theme;Z)Lru/oopssre/imperialschool/viewstv/Protocol$Theme;
    .locals 7
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Lorg/json/JSONException;
        }
    .end annotation

    .line 71
    const-string v0, "schema"

    invoke-virtual {p0, v0}, Lorg/json/JSONObject;->getInt(Ljava/lang/String;)I

    move-result v0

    const/4 v1, 0x0

    const/4 v2, 0x1

    if-ne v0, v2, :cond_0

    const-string v0, "type"

    invoke-virtual {p0, v0}, Lorg/json/JSONObject;->getString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    const-string v3, "dynamic"

    invoke-virtual {v0, v3}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_0

    const-string v0, "collection_id"

    invoke-virtual {p0, v0}, Lorg/json/JSONObject;->getString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    iget-object v3, p1, Lru/oopssre/imperialschool/viewstv/Protocol$Theme;->id:Ljava/lang/String;

    invoke-virtual {v0, v3}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_0

    move v0, v2

    goto :goto_0

    :cond_0
    move v0, v1

    :goto_0
    const-string v3, "\u041f\u0443\u0431\u043b\u0438\u043a\u0430\u0446\u0438\u044f \u043e\u0442\u043d\u043e\u0441\u0438\u0442\u0441\u044f \u043a \u0434\u0440\u0443\u0433\u043e\u0439 \u0442\u0435\u043c\u0435"

    invoke-static {v0, v3}, Lru/oopssre/imperialschool/viewstv/Protocol;->require(ZLjava/lang/String;)V

    .line 72
    invoke-static {p1}, Lru/oopssre/imperialschool/viewstv/Protocol;->tvScene(Lru/oopssre/imperialschool/viewstv/Protocol$Theme;)Z

    move-result v0

    if-nez v0, :cond_1

    goto :goto_4

    :cond_1
    if-eqz p2, :cond_2

    const/4 p2, 0x2

    .line 73
    new-array p2, p2, [Lru/oopssre/imperialschool/viewstv/Protocol$Theme;

    aput-object p1, p2, v1

    invoke-static {p1}, Lru/oopssre/imperialschool/viewstv/Protocol;->alternateTV(Lru/oopssre/imperialschool/viewstv/Protocol$Theme;)Lru/oopssre/imperialschool/viewstv/Protocol$Theme;

    move-result-object v0

    aput-object v0, p2, v2

    goto :goto_1

    :cond_2
    new-array p2, v2, [Lru/oopssre/imperialschool/viewstv/Protocol$Theme;

    aput-object p1, p2, v1

    :goto_1
    array-length v0, p2

    move v3, v1

    :goto_2
    if-ge v3, v0, :cond_6

    aget-object v4, p2, v3

    .line 74
    const-string v5, "format_status"

    invoke-virtual {p0, v5}, Lorg/json/JSONObject;->getJSONObject(Ljava/lang/String;)Lorg/json/JSONObject;

    move-result-object v5

    iget-object v6, v4, Lru/oopssre/imperialschool/viewstv/Protocol$Theme;->device:Ljava/lang/String;

    invoke-virtual {v5, v6}, Lorg/json/JSONObject;->optJSONObject(Ljava/lang/String;)Lorg/json/JSONObject;

    move-result-object v5

    if-eqz v5, :cond_5

    .line 75
    const-string v6, "status"

    invoke-virtual {v5, v6}, Lorg/json/JSONObject;->optString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v5

    const-string v6, "ready"

    invoke-virtual {v5, v6}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v5

    if-nez v5, :cond_3

    goto :goto_3

    .line 76
    :cond_3
    const-string p1, "formats"

    invoke-virtual {p0, p1}, Lorg/json/JSONObject;->getJSONObject(Ljava/lang/String;)Lorg/json/JSONObject;

    move-result-object p0

    iget-object p1, v4, Lru/oopssre/imperialschool/viewstv/Protocol$Theme;->device:Ljava/lang/String;

    invoke-virtual {p0, p1}, Lorg/json/JSONObject;->getJSONObject(Ljava/lang/String;)Lorg/json/JSONObject;

    move-result-object p0

    .line 77
    const-string p1, "width"

    invoke-virtual {p0, p1}, Lorg/json/JSONObject;->getInt(Ljava/lang/String;)I

    move-result p1

    iget p2, v4, Lru/oopssre/imperialschool/viewstv/Protocol$Theme;->width:I

    if-ne p1, p2, :cond_4

    const-string p1, "height"

    invoke-virtual {p0, p1}, Lorg/json/JSONObject;->getInt(Ljava/lang/String;)I

    move-result p0

    iget p1, v4, Lru/oopssre/imperialschool/viewstv/Protocol$Theme;->height:I

    if-ne p0, p1, :cond_4

    move v1, v2

    :cond_4
    const-string p0, "\u041d\u0435\u0432\u0435\u0440\u043d\u044b\u0439 \u0440\u0430\u0437\u043c\u0435\u0440 TV-\u043f\u0443\u0431\u043b\u0438\u043a\u0430\u0446\u0438\u0438"

    invoke-static {v1, p0}, Lru/oopssre/imperialschool/viewstv/Protocol;->require(ZLjava/lang/String;)V

    return-object v4

    :cond_5
    :goto_3
    add-int/lit8 v3, v3, 0x1

    goto :goto_2

    :cond_6
    :goto_4
    return-object p1
.end method

.method public static publishedVideo(Lorg/json/JSONObject;Lru/oopssre/imperialschool/viewstv/Protocol$Theme;)Lru/oopssre/imperialschool/viewstv/Protocol$Theme;
    .locals 5
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Lorg/json/JSONException;
        }
    .end annotation

    .line 58
    invoke-static {p1}, Lru/oopssre/imperialschool/viewstv/Protocol;->videoProfile(Lru/oopssre/imperialschool/viewstv/Protocol$Theme;)Lru/oopssre/imperialschool/viewstv/Protocol$Theme;

    move-result-object p1

    .line 59
    const-string v0, "schema"

    invoke-virtual {p0, v0}, Lorg/json/JSONObject;->getInt(Ljava/lang/String;)I

    move-result v0

    const/4 v1, 0x0

    const/4 v2, 0x1

    if-ne v0, v2, :cond_0

    const-string v0, "type"

    invoke-virtual {p0, v0}, Lorg/json/JSONObject;->getString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    const-string v3, "dynamic"

    invoke-virtual {v0, v3}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_0

    const-string v0, "collection_id"

    invoke-virtual {p0, v0}, Lorg/json/JSONObject;->getString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    iget-object v3, p1, Lru/oopssre/imperialschool/viewstv/Protocol$Theme;->id:Ljava/lang/String;

    invoke-virtual {v0, v3}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_0

    move v0, v2

    goto :goto_0

    :cond_0
    move v0, v1

    :goto_0
    const-string v3, "\u041f\u0443\u0431\u043b\u0438\u043a\u0430\u0446\u0438\u044f \u043e\u0442\u043d\u043e\u0441\u0438\u0442\u0441\u044f \u043a \u0434\u0440\u0443\u0433\u043e\u0439 \u0442\u0435\u043c\u0435"

    invoke-static {v0, v3}, Lru/oopssre/imperialschool/viewstv/Protocol;->require(ZLjava/lang/String;)V

    .line 60
    const-string v0, "formats"

    invoke-virtual {p0, v0}, Lorg/json/JSONObject;->getJSONObject(Ljava/lang/String;)Lorg/json/JSONObject;

    move-result-object v0

    iget-object v3, p1, Lru/oopssre/imperialschool/viewstv/Protocol$Theme;->device:Ljava/lang/String;

    invoke-virtual {v0, v3}, Lorg/json/JSONObject;->optJSONObject(Ljava/lang/String;)Lorg/json/JSONObject;

    move-result-object v0

    if-eqz v0, :cond_2

    .line 62
    const-string v3, "width"

    invoke-virtual {v0, v3}, Lorg/json/JSONObject;->getInt(Ljava/lang/String;)I

    move-result v3

    const/16 v4, 0xf00

    if-ne v3, v4, :cond_1

    const-string v3, "height"

    invoke-virtual {v0, v3}, Lorg/json/JSONObject;->getInt(Ljava/lang/String;)I

    move-result v0

    const/16 v3, 0x870

    if-ne v0, v3, :cond_1

    move v1, v2

    :cond_1
    const-string v0, "\u041d\u0435\u0432\u0435\u0440\u043d\u044b\u0439 \u0440\u0430\u0437\u043c\u0435\u0440 \u043f\u0440\u043e\u0444\u0438\u043b\u044f desktop_3840x2160"

    invoke-static {v1, v0}, Lru/oopssre/imperialschool/viewstv/Protocol;->require(ZLjava/lang/String;)V

    .line 63
    invoke-static {p0, p1}, Lru/oopssre/imperialschool/viewstv/Protocol;->statePath(Lorg/json/JSONObject;Lru/oopssre/imperialschool/viewstv/Protocol$Theme;)Ljava/lang/String;

    return-object p1

    .line 61
    :cond_2
    new-instance p0, Lru/oopssre/imperialschool/viewstv/Protocol$NotReady;

    const-string p1, "\u0412\u0438\u0434\u0435\u043e 4\u041a \u0434\u043b\u044f \u044d\u0442\u043e\u0439 \u0442\u0435\u043c\u044b \u0435\u0449\u0451 \u043d\u0435 \u043e\u043f\u0443\u0431\u043b\u0438\u043a\u043e\u0432\u0430\u043d\u043e"

    invoke-direct {p0, p1}, Lru/oopssre/imperialschool/viewstv/Protocol$NotReady;-><init>(Ljava/lang/String;)V

    throw p0
.end method

.method public static require(ZLjava/lang/String;)V
    .locals 0

    if-eqz p0, :cond_0

    return-void

    .line 14
    :cond_0
    new-instance p0, Ljava/lang/IllegalArgumentException;

    invoke-direct {p0, p1}, Ljava/lang/IllegalArgumentException;-><init>(Ljava/lang/String;)V

    throw p0
.end method

.method public static savedFrame(Lorg/json/JSONObject;)Lru/oopssre/imperialschool/viewstv/Protocol$Frame;
    .locals 17
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Lorg/json/JSONException;
        }
    .end annotation

    move-object/from16 v0, p0

    .line 99
    const-string v1, "theme"

    invoke-virtual {v0, v1}, Lorg/json/JSONObject;->getString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v3

    const-string v1, "device"

    invoke-virtual {v0, v1}, Lorg/json/JSONObject;->getString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v4

    const-string v1, "sha"

    invoke-virtual {v0, v1}, Lorg/json/JSONObject;->getString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v7

    const-string v1, "state"

    invoke-virtual {v0, v1}, Lorg/json/JSONObject;->getString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v8

    const-string v1, "[a-z0-9][a-z0-9_-]{0,79}"

    invoke-virtual {v3, v1}, Ljava/lang/String;->matches(Ljava/lang/String;)Z

    move-result v1

    const/4 v2, 0x1

    const/4 v5, 0x0

    if-eqz v1, :cond_0

    invoke-static {v4}, Lru/oopssre/imperialschool/viewstv/Protocol;->id(Ljava/lang/String;)Z

    move-result v1

    if-eqz v1, :cond_0

    invoke-static {v7}, Lru/oopssre/imperialschool/viewstv/Protocol;->hash(Ljava/lang/String;)Z

    move-result v1

    if-eqz v1, :cond_0

    invoke-static {v8}, Lru/oopssre/imperialschool/viewstv/Protocol;->hash(Ljava/lang/String;)Z

    move-result v1

    if-eqz v1, :cond_0

    move v1, v2

    goto :goto_0

    :cond_0
    move v1, v5

    :goto_0
    const-string v6, "\u041f\u043e\u0432\u0440\u0435\u0436\u0434\u0451\u043d \u043a\u0435\u0448 \u043a\u0430\u0434\u0440\u0430"

    invoke-static {v1, v6}, Lru/oopssre/imperialschool/viewstv/Protocol;->require(ZLjava/lang/String;)V

    const-string v1, "url"

    invoke-virtual {v0, v1}, Lorg/json/JSONObject;->getString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v6

    const-string v1, "kind"

    const-string v9, "dynamic"

    invoke-virtual {v0, v1, v9}, Lorg/json/JSONObject;->optString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v1

    invoke-static {v6}, Lru/oopssre/imperialschool/viewstv/ImageFormat;->fromURL(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v10

    const-string v11, "format"

    invoke-virtual {v0, v11, v10}, Lorg/json/JSONObject;->optString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v11

    invoke-static {v11}, Lru/oopssre/imperialschool/viewstv/ImageFormat;->canonical(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v11

    invoke-virtual {v11, v10}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v11

    const-string v12, "\u041d\u0435\u0432\u0435\u0440\u043d\u044b\u0439 \u0444\u043e\u0440\u043c\u0430\u0442 \u043a\u0435\u0448\u0430"

    invoke-static {v11, v12}, Lru/oopssre/imperialschool/viewstv/Protocol;->require(ZLjava/lang/String;)V

    const/4 v11, 0x3

    new-array v11, v11, [Ljava/lang/String;

    aput-object v9, v11, v5

    const-string v5, "weather"

    aput-object v5, v11, v2

    const/4 v2, 0x2

    const-string v5, "plain"

    aput-object v5, v11, v2

    invoke-static {v11}, Ljava/util/Arrays;->asList([Ljava/lang/Object;)Ljava/util/List;

    move-result-object v2

    invoke-interface {v2, v1}, Ljava/util/List;->contains(Ljava/lang/Object;)Z

    move-result v2

    const-string v5, "\u041d\u0435\u0432\u0435\u0440\u043d\u044b\u0439 \u0442\u0438\u043f \u043a\u0435\u0448\u0430"

    invoke-static {v2, v5}, Lru/oopssre/imperialschool/viewstv/Protocol;->require(ZLjava/lang/String;)V

    invoke-virtual {v1, v9}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v2

    if-eqz v2, :cond_1

    new-instance v2, Ljava/lang/StringBuilder;

    const-string v5, "dynamic/"

    invoke-direct {v2, v5}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    const-string v5, "/devices/"

    invoke-virtual {v2, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {v2, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    const-string v5, "/current."

    invoke-virtual {v2, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {v2, v10}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    invoke-static {v6, v2}, Lru/oopssre/imperialschool/viewstv/Protocol;->endpoint(Ljava/lang/String;Ljava/lang/String;)Z

    move-result v2

    goto :goto_1

    :cond_1
    invoke-static {v6, v3}, Lru/oopssre/imperialschool/viewstv/Sources;->pictureURL(Ljava/lang/String;Ljava/lang/String;)Z

    move-result v2

    :goto_1
    const-string v5, "\u041d\u0435\u0432\u0435\u0440\u043d\u044b\u0439 \u0430\u0434\u0440\u0435\u0441 \u043a\u0435\u0448\u0430"

    invoke-static {v2, v5}, Lru/oopssre/imperialschool/viewstv/Protocol;->require(ZLjava/lang/String;)V

    .line 100
    new-instance v2, Lru/oopssre/imperialschool/viewstv/Protocol$Frame;

    const-string v5, "title"

    invoke-virtual {v0, v5}, Lorg/json/JSONObject;->getString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v5

    const-string v9, "width"

    invoke-virtual {v0, v9}, Lorg/json/JSONObject;->getInt(Ljava/lang/String;)I

    move-result v9

    const-string v10, "height"

    invoke-virtual {v0, v10}, Lorg/json/JSONObject;->getInt(Ljava/lang/String;)I

    move-result v10

    const-string v11, "bytes"

    invoke-virtual {v0, v11}, Lorg/json/JSONObject;->getLong(Ljava/lang/String;)J

    move-result-wide v11

    const-string v13, "at"

    invoke-virtual {v0, v13}, Lorg/json/JSONObject;->getLong(Ljava/lang/String;)J

    move-result-wide v13

    const-string v15, "until"

    invoke-virtual {v0, v15}, Lorg/json/JSONObject;->getLong(Ljava/lang/String;)J

    move-result-wide v15

    invoke-direct/range {v2 .. v16}, Lru/oopssre/imperialschool/viewstv/Protocol$Frame;-><init>(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;IIJJJ)V

    iput-object v1, v2, Lru/oopssre/imperialschool/viewstv/Protocol$Frame;->kind:Ljava/lang/String;

    const-string v1, "source_id"

    const-string v3, "real"

    invoke-virtual {v0, v1, v3}, Lorg/json/JSONObject;->optString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v1

    iput-object v1, v2, Lru/oopssre/imperialschool/viewstv/Protocol$Frame;->sourceId:Ljava/lang/String;

    const-string v1, "refresh_at"

    iget-wide v3, v2, Lru/oopssre/imperialschool/viewstv/Protocol$Frame;->until:J

    invoke-virtual {v0, v1, v3, v4}, Lorg/json/JSONObject;->optLong(Ljava/lang/String;J)J

    move-result-wide v0

    iput-wide v0, v2, Lru/oopssre/imperialschool/viewstv/Protocol$Frame;->refreshAt:J

    return-object v2
.end method

.method public static statePath(Lorg/json/JSONObject;Lru/oopssre/imperialschool/viewstv/Protocol$Theme;)Ljava/lang/String;
    .locals 3
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Lorg/json/JSONException;
        }
    .end annotation

    .line 83
    const-string v0, "schema"

    invoke-virtual {p0, v0}, Lorg/json/JSONObject;->getInt(Ljava/lang/String;)I

    move-result v0

    const/4 v1, 0x1

    if-ne v0, v1, :cond_0

    const-string v0, "type"

    invoke-virtual {p0, v0}, Lorg/json/JSONObject;->getString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    const-string v2, "dynamic"

    invoke-virtual {v0, v2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_0

    const-string v0, "collection_id"

    invoke-virtual {p0, v0}, Lorg/json/JSONObject;->getString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    iget-object v2, p1, Lru/oopssre/imperialschool/viewstv/Protocol$Theme;->id:Ljava/lang/String;

    invoke-virtual {v0, v2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_0

    goto :goto_0

    :cond_0
    const/4 v1, 0x0

    :goto_0
    const-string v0, "\u041f\u0443\u0431\u043b\u0438\u043a\u0430\u0446\u0438\u044f \u043e\u0442\u043d\u043e\u0441\u0438\u0442\u0441\u044f \u043a \u0434\u0440\u0443\u0433\u043e\u0439 \u0442\u0435\u043c\u0435"

    invoke-static {v1, v0}, Lru/oopssre/imperialschool/viewstv/Protocol;->require(ZLjava/lang/String;)V

    .line 84
    const-string v0, "format_status"

    invoke-virtual {p0, v0}, Lorg/json/JSONObject;->getJSONObject(Ljava/lang/String;)Lorg/json/JSONObject;

    move-result-object v0

    iget-object v1, p1, Lru/oopssre/imperialschool/viewstv/Protocol$Theme;->device:Ljava/lang/String;

    invoke-virtual {v0, v1}, Lorg/json/JSONObject;->optJSONObject(Ljava/lang/String;)Lorg/json/JSONObject;

    move-result-object v0

    if-eqz v0, :cond_1

    .line 85
    const-string v1, "status"

    invoke-virtual {v0, v1}, Lorg/json/JSONObject;->optString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    const-string v1, "ready"

    invoke-virtual {v0, v1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_1

    .line 86
    const-string v0, "states"

    invoke-virtual {p0, v0}, Lorg/json/JSONObject;->getJSONObject(Ljava/lang/String;)Lorg/json/JSONObject;

    move-result-object p0

    iget-object v0, p1, Lru/oopssre/imperialschool/viewstv/Protocol$Theme;->device:Ljava/lang/String;

    invoke-virtual {p0, v0}, Lorg/json/JSONObject;->getString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object p0

    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {p1}, Lru/oopssre/imperialschool/viewstv/Protocol$Theme;->prefix()Ljava/lang/String;

    move-result-object p1

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p1

    const-string v0, "current.json"

    invoke-virtual {p1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p1

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-static {p0, p1}, Lru/oopssre/imperialschool/viewstv/Protocol;->endpoint(Ljava/lang/String;Ljava/lang/String;)Z

    move-result p1

    const-string v0, "\u041d\u0435\u0432\u0435\u0440\u043d\u044b\u0439 \u0430\u0434\u0440\u0435\u0441 \u0442\u0435\u043a\u0443\u0449\u0435\u0433\u043e \u043a\u0430\u0434\u0440\u0430"

    invoke-static {p1, v0}, Lru/oopssre/imperialschool/viewstv/Protocol;->require(ZLjava/lang/String;)V

    return-object p0

    .line 85
    :cond_1
    new-instance p0, Lru/oopssre/imperialschool/viewstv/Protocol$NotReady;

    const-string p1, "\u041a\u0430\u0434\u0440 \u0434\u043b\u044f \u0442\u0435\u043b\u0435\u0432\u0438\u0437\u043e\u0440\u0430 \u0435\u0449\u0451 \u043d\u0435 \u043e\u043f\u0443\u0431\u043b\u0438\u043a\u043e\u0432\u0430\u043d"

    invoke-direct {p0, p1}, Lru/oopssre/imperialschool/viewstv/Protocol$NotReady;-><init>(Ljava/lang/String;)V

    throw p0
.end method

.method public static theme(Lorg/json/JSONObject;)Lru/oopssre/imperialschool/viewstv/Protocol$Theme;
    .locals 22
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Lorg/json/JSONException;
        }
    .end annotation

    move-object/from16 v7, p0

    .line 34
    const-string v0, "id"

    invoke-virtual {v7, v0}, Lorg/json/JSONObject;->getString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v1

    const-string v0, "title"

    invoke-virtual {v7, v0}, Lorg/json/JSONObject;->getString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v2

    const-string v0, "current_url"

    invoke-virtual {v7, v0}, Lorg/json/JSONObject;->getString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v4

    .line 35
    invoke-static {v1}, Lru/oopssre/imperialschool/viewstv/Protocol;->id(Ljava/lang/String;)Z

    move-result v0

    const/4 v5, 0x0

    if-eqz v0, :cond_0

    const-string v0, "type"

    invoke-virtual {v7, v0}, Lorg/json/JSONObject;->getString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    const-string v6, "dynamic"

    invoke-virtual {v0, v6}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_0

    invoke-virtual {v2}, Ljava/lang/String;->length()I

    move-result v0

    if-lez v0, :cond_0

    invoke-virtual {v2}, Ljava/lang/String;->length()I

    move-result v0

    const/16 v6, 0x12c

    if-gt v0, v6, :cond_0

    const/4 v0, 0x1

    goto :goto_0

    :cond_0
    move v0, v5

    :goto_0
    const-string v6, "\u041d\u0435\u0432\u0435\u0440\u043d\u0430\u044f \u0442\u0435\u043c\u0430"

    invoke-static {v0, v6}, Lru/oopssre/imperialschool/viewstv/Protocol;->require(ZLjava/lang/String;)V

    .line 36
    new-instance v0, Ljava/lang/StringBuilder;

    const-string v6, "dynamic/"

    invoke-direct {v0, v6}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    const-string v6, "/current.json"

    invoke-virtual {v0, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-static {v4, v0}, Lru/oopssre/imperialschool/viewstv/Protocol;->endpoint(Ljava/lang/String;Ljava/lang/String;)Z

    move-result v0

    const-string v6, "\u041d\u0435\u0432\u0435\u0440\u043d\u0430\u044f \u043f\u0443\u0431\u043b\u0438\u043a\u0430\u0446\u0438\u044f \u0442\u0435\u043c\u044b"

    invoke-static {v0, v6}, Lru/oopssre/imperialschool/viewstv/Protocol;->require(ZLjava/lang/String;)V

    .line 38
    const-string v0, "orbital-port"

    invoke-virtual {v1, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-nez v0, :cond_8

    const-string v0, "sunken-teahouse"

    invoke-virtual {v1, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_1

    goto/16 :goto_6

    .line 39
    :cond_1
    const-string v0, "formats"

    invoke-virtual {v7, v0}, Lorg/json/JSONObject;->getJSONObject(Ljava/lang/String;)Lorg/json/JSONObject;

    move-result-object v0

    invoke-virtual {v0}, Lorg/json/JSONObject;->length()I

    move-result v6

    if-lez v6, :cond_2

    invoke-virtual {v0}, Lorg/json/JSONObject;->length()I

    move-result v6

    const/16 v8, 0x14

    if-gt v6, v8, :cond_2

    const/4 v6, 0x1

    goto :goto_1

    :cond_2
    move v6, v5

    :goto_1
    const-string v8, "\u041d\u0435\u0442 \u0444\u043e\u0440\u043c\u0430\u0442\u043e\u0432 \u0442\u0435\u043c\u044b"

    invoke-static {v6, v8}, Lru/oopssre/imperialschool/viewstv/Protocol;->require(ZLjava/lang/String;)V

    .line 41
    invoke-virtual {v0}, Lorg/json/JSONObject;->keys()Ljava/util/Iterator;

    move-result-object v6

    const/4 v8, 0x0

    const-wide v9, 0x7fefffffffffffffL    # Double.MAX_VALUE

    move v12, v5

    move-object v11, v6

    move v6, v12

    :goto_2
    invoke-interface {v11}, Ljava/util/Iterator;->hasNext()Z

    move-result v13

    if-eqz v13, :cond_6

    invoke-interface {v11}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v13

    check-cast v13, Ljava/lang/String;

    invoke-virtual {v0, v13}, Lorg/json/JSONObject;->getJSONObject(Ljava/lang/String;)Lorg/json/JSONObject;

    move-result-object v14

    const-string v15, "width"

    invoke-virtual {v14, v15}, Lorg/json/JSONObject;->getInt(Ljava/lang/String;)I

    move-result v15

    const-string v3, "height"

    invoke-virtual {v14, v3}, Lorg/json/JSONObject;->getInt(Ljava/lang/String;)I

    move-result v3

    invoke-static {v13}, Lru/oopssre/imperialschool/viewstv/Protocol;->id(Ljava/lang/String;)Z

    move-result v14

    if-eqz v14, :cond_3

    if-lez v15, :cond_3

    if-lez v3, :cond_3

    const/16 v14, 0x4000

    if-gt v15, v14, :cond_3

    if-gt v3, v14, :cond_3

    const/4 v14, 0x1

    goto :goto_3

    :cond_3
    move v14, v12

    :goto_3
    const-string v12, "\u041d\u0435\u0432\u0435\u0440\u043d\u044b\u0439 \u0444\u043e\u0440\u043c\u0430\u0442"

    invoke-static {v14, v12}, Lru/oopssre/imperialschool/viewstv/Protocol;->require(ZLjava/lang/String;)V

    if-ge v15, v3, :cond_4

    :goto_4
    const/4 v12, 0x0

    goto :goto_2

    :cond_4
    move-object v14, v0

    move-object v12, v1

    int-to-double v0, v15

    move-wide/from16 v16, v0

    int-to-double v0, v3

    div-double v18, v16, v0

    const-wide v20, 0x3ffc71c71c71c71cL    # 1.7777777777777777

    div-double v18, v18, v20

    .line 42
    invoke-static/range {v18 .. v19}, Ljava/lang/Math;->log(D)D

    move-result-wide v18

    invoke-static/range {v18 .. v19}, Ljava/lang/Math;->abs(D)D

    move-result-wide v18

    const-wide/high16 v20, 0x4059000000000000L    # 100.0

    mul-double v18, v18, v20

    mul-double v0, v0, v16

    const-wide v16, 0x415fa40000000000L    # 8294400.0

    div-double v0, v0, v16

    invoke-static {v0, v1}, Ljava/lang/Math;->log(D)D

    move-result-wide v0

    invoke-static {v0, v1}, Ljava/lang/Math;->abs(D)D

    move-result-wide v0

    add-double v18, v18, v0

    cmpg-double v0, v18, v9

    if-gez v0, :cond_5

    move v6, v3

    move-object v8, v13

    move v5, v15

    move-wide/from16 v9, v18

    :cond_5
    move-object v1, v12

    move-object v0, v14

    goto :goto_4

    :cond_6
    move-object v12, v1

    if-eqz v8, :cond_7

    const/4 v3, 0x1

    goto :goto_5

    :cond_7
    const/4 v3, 0x0

    .line 45
    :goto_5
    const-string v0, "\u0412 \u0442\u0435\u043c\u0435 \u043d\u0435\u0442 \u043f\u043e\u0434\u0445\u043e\u0434\u044f\u0449\u0435\u0433\u043e \u0442\u0435\u043b\u0435\u0432\u0438\u0437\u0438\u043e\u043d\u043d\u043e\u0433\u043e \u0444\u043e\u0440\u043c\u0430\u0442\u0430"

    invoke-static {v3, v0}, Lru/oopssre/imperialschool/viewstv/Protocol;->require(ZLjava/lang/String;)V

    new-instance v0, Lru/oopssre/imperialschool/viewstv/Protocol$Theme;

    move-object v3, v8

    move-object v1, v12

    invoke-direct/range {v0 .. v7}, Lru/oopssre/imperialschool/viewstv/Protocol$Theme;-><init>(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;IILorg/json/JSONObject;)V

    return-object v0

    .line 38
    :cond_8
    :goto_6
    new-instance v0, Lru/oopssre/imperialschool/viewstv/Protocol$Theme;

    const/16 v5, 0xf00

    const/16 v6, 0x870

    const-string v3, "desktop_3840x2160"

    move-object/from16 v7, p0

    invoke-direct/range {v0 .. v7}, Lru/oopssre/imperialschool/viewstv/Protocol$Theme;-><init>(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;IILorg/json/JSONObject;)V

    return-object v0
.end method

.method public static time(Ljava/lang/String;)J
    .locals 2

    .line 24
    invoke-static {p0}, Ljava/time/OffsetDateTime;->parse(Ljava/lang/CharSequence;)Ljava/time/OffsetDateTime;

    move-result-object p0

    invoke-virtual {p0}, Ljava/time/OffsetDateTime;->toInstant()Ljava/time/Instant;

    move-result-object p0

    invoke-virtual {p0}, Ljava/time/Instant;->toEpochMilli()J

    move-result-wide v0

    return-wide v0
.end method

.method static tvProfile(Lru/oopssre/imperialschool/viewstv/Protocol$Theme;Ljava/lang/String;)Lru/oopssre/imperialschool/viewstv/Protocol$Theme;
    .locals 11

    .line 54
    const-string v0, "desktop_3840x2160"

    invoke-virtual {p1, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-nez v0, :cond_1

    const-string v1, "desktop_1920x1080"

    invoke-virtual {p1, v1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v1

    if-eqz v1, :cond_0

    goto :goto_0

    :cond_0
    const/4 v1, 0x0

    goto :goto_1

    :cond_1
    :goto_0
    const/4 v1, 0x1

    :goto_1
    const-string v2, "\u041d\u0435\u0432\u0435\u0440\u043d\u044b\u0439 TV-\u043f\u0440\u043e\u0444\u0438\u043b\u044c"

    invoke-static {v1, v2}, Lru/oopssre/imperialschool/viewstv/Protocol;->require(ZLjava/lang/String;)V

    new-instance v3, Lru/oopssre/imperialschool/viewstv/Protocol$Theme;

    iget-object v4, p0, Lru/oopssre/imperialschool/viewstv/Protocol$Theme;->id:Ljava/lang/String;

    iget-object v5, p0, Lru/oopssre/imperialschool/viewstv/Protocol$Theme;->title:Ljava/lang/String;

    iget-object v7, p0, Lru/oopssre/imperialschool/viewstv/Protocol$Theme;->current:Ljava/lang/String;

    if-eqz v0, :cond_2

    const/16 v1, 0xf00

    goto :goto_2

    :cond_2
    const/16 v1, 0x780

    :goto_2
    move v8, v1

    if-eqz v0, :cond_3

    const/16 v0, 0x870

    goto :goto_3

    :cond_3
    const/16 v0, 0x438

    :goto_3
    move v9, v0

    iget-object v10, p0, Lru/oopssre/imperialschool/viewstv/Protocol$Theme;->descriptor:Lorg/json/JSONObject;

    move-object v6, p1

    invoke-direct/range {v3 .. v10}, Lru/oopssre/imperialschool/viewstv/Protocol$Theme;-><init>(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;IILorg/json/JSONObject;)V

    return-object v3
.end method

.method public static tvScene(Lru/oopssre/imperialschool/viewstv/Protocol$Theme;)Z
    .locals 2

    .line 53
    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/Protocol$Theme;->kind:Ljava/lang/String;

    const-string v1, "dynamic"

    invoke-virtual {v0, v1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_1

    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/Protocol$Theme;->id:Ljava/lang/String;

    const-string v1, "orbital-port"

    invoke-virtual {v0, v1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-nez v0, :cond_0

    iget-object p0, p0, Lru/oopssre/imperialschool/viewstv/Protocol$Theme;->id:Ljava/lang/String;

    const-string v0, "sunken-teahouse"

    invoke-virtual {p0, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p0

    if-eqz p0, :cond_1

    :cond_0
    const/4 p0, 0x1

    return p0

    :cond_1
    const/4 p0, 0x0

    return p0
.end method

.method public static url(Ljava/lang/String;)Ljava/net/URI;
    .locals 4

    .line 19
    invoke-static {p0}, Ljava/net/URI;->create(Ljava/lang/String;)Ljava/net/URI;

    move-result-object v0

    const-string v1, "\\"

    invoke-virtual {p0, v1}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z

    move-result v1

    const/4 v2, 0x1

    const/4 v3, 0x0

    if-nez v1, :cond_0

    const-string v1, "%"

    invoke-virtual {p0, v1}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z

    move-result v1

    if-nez v1, :cond_0

    const-string v1, ".."

    invoke-virtual {p0, v1}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z

    move-result p0

    if-nez p0, :cond_0

    move p0, v2

    goto :goto_0

    :cond_0
    move p0, v3

    :goto_0
    const-string v1, "\u041d\u0435\u0432\u0435\u0440\u043d\u044b\u0439 \u043f\u0443\u0442\u044c \u0441\u0435\u0440\u0432\u0435\u0440\u0430"

    invoke-static {p0, v1}, Lru/oopssre/imperialschool/viewstv/Protocol;->require(ZLjava/lang/String;)V

    .line 20
    const-string p0, "https://games.oopssre.ru/assets/arcade/views/"

    invoke-static {p0}, Ljava/net/URI;->create(Ljava/lang/String;)Ljava/net/URI;

    move-result-object p0

    invoke-virtual {p0, v0}, Ljava/net/URI;->resolve(Ljava/net/URI;)Ljava/net/URI;

    move-result-object p0

    .line 21
    const-string v0, "https"

    invoke-virtual {p0}, Ljava/net/URI;->getScheme()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_2

    const-string v0, "games.oopssre.ru"

    invoke-virtual {p0}, Ljava/net/URI;->getHost()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_2

    invoke-virtual {p0}, Ljava/net/URI;->getPort()I

    move-result v0

    const/4 v1, -0x1

    if-eq v0, v1, :cond_1

    invoke-virtual {p0}, Ljava/net/URI;->getPort()I

    move-result v0

    const/16 v1, 0x1bb

    if-ne v0, v1, :cond_2

    :cond_1
    invoke-virtual {p0}, Ljava/net/URI;->getUserInfo()Ljava/lang/String;

    move-result-object v0

    if-nez v0, :cond_2

    invoke-virtual {p0}, Ljava/net/URI;->getFragment()Ljava/lang/String;

    move-result-object v0

    if-nez v0, :cond_2

    invoke-virtual {p0}, Ljava/net/URI;->getQuery()Ljava/lang/String;

    move-result-object v0

    if-nez v0, :cond_2

    invoke-virtual {p0}, Ljava/net/URI;->getPath()Ljava/lang/String;

    move-result-object v0

    const-string v1, "/assets/arcade/views/"

    invoke-virtual {v0, v1}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z

    move-result v0

    if-eqz v0, :cond_2

    goto :goto_1

    :cond_2
    move v2, v3

    :goto_1
    const-string v0, "\u041d\u0435\u0432\u0435\u0440\u043d\u044b\u0439 \u0430\u0434\u0440\u0435\u0441 \u0441\u0435\u0440\u0432\u0435\u0440\u0430"

    invoke-static {v2, v0}, Lru/oopssre/imperialschool/viewstv/Protocol;->require(ZLjava/lang/String;)V

    return-object p0
.end method

.method public static videoProfile(Lru/oopssre/imperialschool/viewstv/Protocol$Theme;)Lru/oopssre/imperialschool/viewstv/Protocol$Theme;
    .locals 2

    .line 56
    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/Protocol$Theme;->kind:Ljava/lang/String;

    const-string v1, "dynamic"

    invoke-virtual {v0, v1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    const-string v1, "\u0412\u0438\u0434\u0435\u043e 4\u041a \u0434\u043e\u0441\u0442\u0443\u043f\u043d\u043e \u0434\u043b\u044f \u0434\u0438\u043d\u0430\u043c\u0438\u0447\u0435\u0441\u043a\u0438\u0445 \u0442\u0435\u043c"

    invoke-static {v0, v1}, Lru/oopssre/imperialschool/viewstv/Protocol;->require(ZLjava/lang/String;)V

    const-string v0, "desktop_3840x2160"

    invoke-static {p0, v0}, Lru/oopssre/imperialschool/viewstv/Protocol;->tvProfile(Lru/oopssre/imperialschool/viewstv/Protocol$Theme;Ljava/lang/String;)Lru/oopssre/imperialschool/viewstv/Protocol$Theme;

    move-result-object p0

    return-object p0
.end method
