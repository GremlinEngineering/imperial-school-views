.class final Lru/oopssre/imperialschool/viewstv/ThemeStations;
.super Ljava/lang/Object;
.source "ThemeStations.java"


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lru/oopssre/imperialschool/viewstv/ThemeStations$Station;
    }
.end annotation


# instance fields
.field private final prefs:Landroid/content/SharedPreferences;

.field private final themes:Ljava/util/Map;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/Map<",
            "Ljava/lang/String;",
            "Ljava/util/Map<",
            "Ljava/lang/String;",
            "Lru/oopssre/imperialschool/viewstv/ThemeStations$Station;",
            ">;>;"
        }
    .end annotation
.end field


# direct methods
.method constructor <init>(Landroid/content/res/AssetManager;Landroid/content/SharedPreferences;)V
    .locals 1

    .line 34
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 31
    new-instance v0, Ljava/util/LinkedHashMap;

    invoke-direct {v0}, Ljava/util/LinkedHashMap;-><init>()V

    iput-object v0, p0, Lru/oopssre/imperialschool/viewstv/ThemeStations;->themes:Ljava/util/Map;

    .line 35
    iput-object p2, p0, Lru/oopssre/imperialschool/viewstv/ThemeStations;->prefs:Landroid/content/SharedPreferences;

    .line 36
    const-string p2, "theme-stations.json"

    const/4 v0, 0x0

    invoke-direct {p0, p1, p2, v0}, Lru/oopssre/imperialschool/viewstv/ThemeStations;->load(Landroid/content/res/AssetManager;Ljava/lang/String;Z)V

    .line 37
    const-string p2, "personal-theme-stations.json"

    const/4 v0, 0x1

    invoke-direct {p0, p1, p2, v0}, Lru/oopssre/imperialschool/viewstv/ThemeStations;->load(Landroid/content/res/AssetManager;Ljava/lang/String;Z)V

    return-void
.end method

.method static synthetic lambda$load$0(Ljava/lang/String;)Ljava/util/Map;
    .locals 0

    .line 48
    new-instance p0, Ljava/util/LinkedHashMap;

    invoke-direct {p0}, Ljava/util/LinkedHashMap;-><init>()V

    return-object p0
.end method

.method private legacy(Ljava/lang/String;I)Lru/oopssre/imperialschool/viewstv/ThemeStations$Station;
    .locals 9

    .line 77
    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/ThemeStations;->prefs:Landroid/content/SharedPreferences;

    new-instance v1, Ljava/lang/StringBuilder;

    const-string v2, "radio_selected_app_"

    invoke-direct {v1, v2}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v1, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    const/4 v2, 0x0

    invoke-interface {v0, v1, v2}, Landroid/content/SharedPreferences;->getInt(Ljava/lang/String;I)I

    move-result v0

    const/4 v1, 0x0

    if-eq v0, p2, :cond_1

    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/ThemeStations;->prefs:Landroid/content/SharedPreferences;

    new-instance v3, Ljava/lang/StringBuilder;

    const-string v4, "radio_selected_saver_"

    invoke-direct {v3, v4}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v3, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p1

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    .line 78
    invoke-interface {v0, p1, v2}, Landroid/content/SharedPreferences;->getInt(Ljava/lang/String;I)I

    move-result p1

    if-ne p1, p2, :cond_0

    goto :goto_0

    :cond_0
    return-object v1

    .line 80
    :cond_1
    :goto_0
    iget-object p1, p0, Lru/oopssre/imperialschool/viewstv/ThemeStations;->prefs:Landroid/content/SharedPreferences;

    new-instance v0, Ljava/lang/StringBuilder;

    const-string v2, "radio_url_"

    invoke-direct {v0, v2}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v0, p2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    const-string v2, ""

    invoke-interface {p1, v0, v2}, Landroid/content/SharedPreferences;->getString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v6

    .line 81
    invoke-static {v6}, Lru/oopssre/imperialschool/viewstv/ThemeStations;->validUrl(Ljava/lang/String;)Z

    move-result p1

    if-nez p1, :cond_2

    return-object v1

    .line 82
    :cond_2
    new-instance v3, Lru/oopssre/imperialschool/viewstv/ThemeStations$Station;

    new-instance p1, Ljava/lang/StringBuilder;

    const-string v0, "local-"

    invoke-direct {p1, v0}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {p1, p2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object p1

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v4

    iget-object p1, p0, Lru/oopssre/imperialschool/viewstv/ThemeStations;->prefs:Landroid/content/SharedPreferences;

    new-instance v0, Ljava/lang/StringBuilder;

    const-string v1, "radio_name_"

    invoke-direct {v0, v1}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v0, p2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    new-instance v1, Ljava/lang/StringBuilder;

    const-string v2, "\u0421\u0442\u0430\u043d\u0446\u0438\u044f "

    invoke-direct {v1, v2}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v1, p2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object p2

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p2

    invoke-interface {p1, v0, p2}, Landroid/content/SharedPreferences;->getString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v5

    const-string v7, ""

    const/4 v8, 0x1

    invoke-direct/range {v3 .. v8}, Lru/oopssre/imperialschool/viewstv/ThemeStations$Station;-><init>(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Z)V

    return-object v3
.end method

.method private load(Landroid/content/res/AssetManager;Ljava/lang/String;Z)V
    .locals 12

    .line 41
    :try_start_0
    invoke-virtual {p1, p2}, Landroid/content/res/AssetManager;->open(Ljava/lang/String;)Ljava/io/InputStream;

    move-result-object p1
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    .line 42
    :try_start_1
    new-instance p2, Lorg/json/JSONObject;

    new-instance v0, Ljava/lang/String;

    const-wide/32 v1, 0x8000

    invoke-static {p1, v1, v2}, Lru/oopssre/imperialschool/viewstv/CacheStore;->bounded(Ljava/io/InputStream;J)[B

    move-result-object v1

    sget-object v2, Ljava/nio/charset/StandardCharsets;->UTF_8:Ljava/nio/charset/Charset;

    invoke-direct {v0, v1, v2}, Ljava/lang/String;-><init>([BLjava/nio/charset/Charset;)V

    invoke-direct {p2, v0}, Lorg/json/JSONObject;-><init>(Ljava/lang/String;)V

    .line 43
    invoke-virtual {p2}, Lorg/json/JSONObject;->keys()Ljava/util/Iterator;

    move-result-object v0

    .line 44
    :cond_0
    :goto_0
    invoke-interface {v0}, Ljava/util/Iterator;->hasNext()Z

    move-result v1

    if-eqz v1, :cond_5

    .line 45
    invoke-interface {v0}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Ljava/lang/String;

    .line 46
    invoke-virtual {p2, v1}, Lorg/json/JSONObject;->optJSONArray(Ljava/lang/String;)Lorg/json/JSONArray;

    move-result-object v2

    .line 47
    const-string v3, "[a-z0-9][a-z0-9_-]{0,79}"

    invoke-virtual {v1, v3}, Ljava/lang/String;->matches(Ljava/lang/String;)Z

    move-result v3

    if-eqz v3, :cond_0

    if-nez v2, :cond_1

    goto :goto_0

    .line 48
    :cond_1
    iget-object v3, p0, Lru/oopssre/imperialschool/viewstv/ThemeStations;->themes:Ljava/util/Map;

    new-instance v4, Lru/oopssre/imperialschool/viewstv/ThemeStations$$ExternalSyntheticLambda0;

    invoke-direct {v4}, Lru/oopssre/imperialschool/viewstv/ThemeStations$$ExternalSyntheticLambda0;-><init>()V

    invoke-interface {v3, v1, v4}, Ljava/util/Map;->computeIfAbsent(Ljava/lang/Object;Ljava/util/function/Function;)Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Ljava/util/Map;

    const/4 v3, 0x0

    .line 49
    :goto_1
    invoke-virtual {v2}, Lorg/json/JSONArray;->length()I

    move-result v4

    const/16 v5, 0x10

    invoke-static {v4, v5}, Ljava/lang/Math;->min(II)I

    move-result v4

    if-ge v3, v4, :cond_0

    .line 50
    invoke-virtual {v2, v3}, Lorg/json/JSONArray;->optJSONObject(I)Lorg/json/JSONObject;

    move-result-object v4

    if-nez v4, :cond_3

    :cond_2
    :goto_2
    move v11, p3

    goto :goto_3

    .line 52
    :cond_3
    const-string v5, "id"

    invoke-virtual {v4, v5}, Lorg/json/JSONObject;->optString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v7

    const-string v5, "title"

    invoke-virtual {v4, v5}, Lorg/json/JSONObject;->optString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v5

    invoke-virtual {v5}, Ljava/lang/String;->trim()Ljava/lang/String;

    move-result-object v8

    .line 53
    const-string v5, "stream_url"

    invoke-virtual {v4, v5}, Lorg/json/JSONObject;->optString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v9

    .line 54
    const-string v5, "credit"

    invoke-virtual {v4, v5}, Lorg/json/JSONObject;->optString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v10

    .line 55
    const-string v4, "[a-z0-9][a-z0-9-]{0,39}"

    invoke-virtual {v7, v4}, Ljava/lang/String;->matches(Ljava/lang/String;)Z

    move-result v4

    if-eqz v4, :cond_2

    const-string v4, "local-"

    invoke-virtual {v7, v4}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z

    move-result v4

    if-nez v4, :cond_2

    .line 56
    invoke-virtual {v8}, Ljava/lang/String;->isEmpty()Z

    move-result v4

    if-nez v4, :cond_2

    invoke-virtual {v8}, Ljava/lang/String;->length()I

    move-result v4

    const/16 v5, 0x50

    if-gt v4, v5, :cond_2

    invoke-virtual {v10}, Ljava/lang/String;->length()I

    move-result v4

    const/16 v5, 0xf0

    if-le v4, v5, :cond_4

    goto :goto_2

    .line 57
    :cond_4
    invoke-static {v9}, Lru/oopssre/imperialschool/viewstv/ThemeStations;->validUrl(Ljava/lang/String;)Z

    move-result v4

    if-eqz v4, :cond_2

    new-instance v6, Lru/oopssre/imperialschool/viewstv/ThemeStations$Station;

    move v11, p3

    invoke-direct/range {v6 .. v11}, Lru/oopssre/imperialschool/viewstv/ThemeStations$Station;-><init>(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Z)V

    invoke-interface {v1, v7, v6}, Ljava/util/Map;->putIfAbsent(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    :goto_3
    add-int/lit8 v3, v3, 0x1

    move p3, v11

    goto :goto_1

    :cond_5
    if-eqz p1, :cond_7

    .line 60
    :try_start_2
    invoke-virtual {p1}, Ljava/io/InputStream;->close()V
    :try_end_2
    .catch Ljava/lang/Exception; {:try_start_2 .. :try_end_2} :catch_0

    return-void

    :catchall_0
    move-exception v0

    move-object p2, v0

    if-eqz p1, :cond_6

    .line 41
    :try_start_3
    invoke-virtual {p1}, Ljava/io/InputStream;->close()V
    :try_end_3
    .catchall {:try_start_3 .. :try_end_3} :catchall_1

    goto :goto_4

    :catchall_1
    move-exception v0

    move-object p1, v0

    :try_start_4
    invoke-virtual {p2, p1}, Ljava/lang/Throwable;->addSuppressed(Ljava/lang/Throwable;)V

    :cond_6
    :goto_4
    throw p2
    :try_end_4
    .catch Ljava/lang/Exception; {:try_start_4 .. :try_end_4} :catch_0

    :catch_0
    :cond_7
    return-void
.end method

.method private static validUrl(Ljava/lang/String;)Z
    .locals 3

    const/4 v0, 0x0

    .line 97
    :try_start_0
    invoke-static {p0}, Ljava/net/URI;->create(Ljava/lang/String;)Ljava/net/URI;

    move-result-object v1

    .line 98
    invoke-virtual {p0}, Ljava/lang/String;->length()I

    move-result p0

    const/16 v2, 0x800

    if-gt p0, v2, :cond_0

    const-string p0, "https"

    invoke-virtual {v1}, Ljava/net/URI;->getScheme()Ljava/lang/String;

    move-result-object v2

    invoke-virtual {p0, v2}, Ljava/lang/String;->equalsIgnoreCase(Ljava/lang/String;)Z

    move-result p0

    if-eqz p0, :cond_0

    .line 99
    invoke-virtual {v1}, Ljava/net/URI;->getHost()Ljava/lang/String;

    move-result-object p0

    if-eqz p0, :cond_0

    invoke-virtual {v1}, Ljava/net/URI;->getUserInfo()Ljava/lang/String;

    move-result-object p0

    if-nez p0, :cond_0

    invoke-virtual {v1}, Ljava/net/URI;->getFragment()Ljava/lang/String;

    move-result-object p0
    :try_end_0
    .catch Ljava/lang/IllegalArgumentException; {:try_start_0 .. :try_end_0} :catch_0

    if-nez p0, :cond_0

    const/4 p0, 0x1

    return p0

    :catch_0
    :cond_0
    return v0
.end method


# virtual methods
.method forTheme(Ljava/lang/String;)Ljava/util/List;
    .locals 4
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/lang/String;",
            ")",
            "Ljava/util/List<",
            "Lru/oopssre/imperialschool/viewstv/ThemeStations$Station;",
            ">;"
        }
    .end annotation

    .line 66
    new-instance v0, Ljava/util/ArrayList;

    invoke-direct {v0}, Ljava/util/ArrayList;-><init>()V

    .line 67
    iget-object v1, p0, Lru/oopssre/imperialschool/viewstv/ThemeStations;->themes:Ljava/util/Map;

    invoke-static {}, Ljava/util/Collections;->emptyMap()Ljava/util/Map;

    move-result-object v2

    invoke-interface {v1, p1, v2}, Ljava/util/Map;->getOrDefault(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object p1

    check-cast p1, Ljava/util/Map;

    .line 68
    iget-object v1, p0, Lru/oopssre/imperialschool/viewstv/ThemeStations;->prefs:Landroid/content/SharedPreferences;

    const-string v2, "personal_mode"

    const/4 v3, 0x0

    invoke-interface {v1, v2, v3}, Landroid/content/SharedPreferences;->getBoolean(Ljava/lang/String;Z)Z

    move-result v1

    .line 69
    invoke-interface {p1}, Ljava/util/Map;->values()Ljava/util/Collection;

    move-result-object p1

    invoke-interface {p1}, Ljava/util/Collection;->iterator()Ljava/util/Iterator;

    move-result-object p1

    :cond_0
    :goto_0
    invoke-interface {p1}, Ljava/util/Iterator;->hasNext()Z

    move-result v2

    if-eqz v2, :cond_2

    invoke-interface {p1}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Lru/oopssre/imperialschool/viewstv/ThemeStations$Station;

    .line 70
    iget-boolean v3, v2, Lru/oopssre/imperialschool/viewstv/ThemeStations$Station;->personalOnly:Z

    if-eqz v3, :cond_1

    if-eqz v1, :cond_0

    :cond_1
    invoke-interface {v0, v2}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    goto :goto_0

    :cond_2
    return-object v0
.end method

.method playable(Ljava/lang/String;Ljava/lang/String;)Lru/oopssre/imperialschool/viewstv/ThemeStations$Station;
    .locals 3

    .line 86
    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/ThemeStations;->prefs:Landroid/content/SharedPreferences;

    const-string v1, "personal_mode"

    const/4 v2, 0x0

    invoke-interface {v0, v1, v2}, Landroid/content/SharedPreferences;->getBoolean(Ljava/lang/String;Z)Z

    move-result v0

    if-eqz v0, :cond_1

    .line 88
    const-string v1, "local-1"

    invoke-virtual {v1, p2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v1

    if-eqz v1, :cond_0

    const/4 p2, 0x1

    invoke-direct {p0, p1, p2}, Lru/oopssre/imperialschool/viewstv/ThemeStations;->legacy(Ljava/lang/String;I)Lru/oopssre/imperialschool/viewstv/ThemeStations$Station;

    move-result-object p1

    return-object p1

    .line 89
    :cond_0
    const-string v1, "local-2"

    invoke-virtual {v1, p2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v1

    if-eqz v1, :cond_1

    const/4 p2, 0x2

    invoke-direct {p0, p1, p2}, Lru/oopssre/imperialschool/viewstv/ThemeStations;->legacy(Ljava/lang/String;I)Lru/oopssre/imperialschool/viewstv/ThemeStations$Station;

    move-result-object p1

    return-object p1

    .line 91
    :cond_1
    iget-object v1, p0, Lru/oopssre/imperialschool/viewstv/ThemeStations;->themes:Ljava/util/Map;

    invoke-static {}, Ljava/util/Collections;->emptyMap()Ljava/util/Map;

    move-result-object v2

    invoke-interface {v1, p1, v2}, Ljava/util/Map;->getOrDefault(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object p1

    check-cast p1, Ljava/util/Map;

    invoke-interface {p1, p2}, Ljava/util/Map;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object p1

    check-cast p1, Lru/oopssre/imperialschool/viewstv/ThemeStations$Station;

    if-eqz p1, :cond_3

    .line 92
    iget-boolean p2, p1, Lru/oopssre/imperialschool/viewstv/ThemeStations$Station;->personalOnly:Z

    if-eqz p2, :cond_2

    if-eqz v0, :cond_3

    :cond_2
    return-object p1

    :cond_3
    const/4 p1, 0x0

    return-object p1
.end method
