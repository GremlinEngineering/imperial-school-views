.class public final Lru/oopssre/imperialschool/viewstv/VideoInfo;
.super Ljava/lang/Object;
.source "VideoInfo.java"


# static fields
.field public static final MAX_BYTES:J = 0x2000000L


# instance fields
.field public final bytes:J

.field public final durationMs:J

.field public final fps:I

.field public final frame:Lru/oopssre/imperialschool/viewstv/Protocol$Frame;

.field public final sha:Ljava/lang/String;

.field public final url:Ljava/lang/String;

.field private final value:Lorg/json/JSONObject;


# direct methods
.method private constructor <init>(Lru/oopssre/imperialschool/viewstv/Protocol$Frame;Lorg/json/JSONObject;)V
    .locals 11
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Lorg/json/JSONException;
        }
    .end annotation

    .line 13
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 14
    iput-object p1, p0, Lru/oopssre/imperialschool/viewstv/VideoInfo;->frame:Lru/oopssre/imperialschool/viewstv/Protocol$Frame;

    new-instance v0, Lorg/json/JSONObject;

    invoke-virtual {p2}, Lorg/json/JSONObject;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-direct {v0, v1}, Lorg/json/JSONObject;-><init>(Ljava/lang/String;)V

    iput-object v0, p0, Lru/oopssre/imperialschool/viewstv/VideoInfo;->value:Lorg/json/JSONObject;

    const-string v0, "url"

    invoke-virtual {p2, v0}, Lorg/json/JSONObject;->getString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    iput-object v0, p0, Lru/oopssre/imperialschool/viewstv/VideoInfo;->url:Ljava/lang/String;

    const-string v1, "sha256"

    invoke-virtual {p2, v1}, Lorg/json/JSONObject;->getString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v1

    iput-object v1, p0, Lru/oopssre/imperialschool/viewstv/VideoInfo;->sha:Ljava/lang/String;

    const-wide/16 v4, 0x1

    const-wide/32 v6, 0x2000000

    .line 15
    const-string v3, "bytes"

    move-object v2, p2

    invoke-static/range {v2 .. v7}, Lru/oopssre/imperialschool/viewstv/Protocol;->integer(Lorg/json/JSONObject;Ljava/lang/String;JJ)J

    move-result-wide v3

    move-object v5, v2

    iput-wide v3, p0, Lru/oopssre/imperialschool/viewstv/VideoInfo;->bytes:J

    const-wide/16 v7, 0x1

    const-wide/32 v9, 0x1d4c0

    const-string v6, "duration_ms"

    invoke-static/range {v5 .. v10}, Lru/oopssre/imperialschool/viewstv/Protocol;->integer(Lorg/json/JSONObject;Ljava/lang/String;JJ)J

    move-result-wide v2

    iput-wide v2, p0, Lru/oopssre/imperialschool/viewstv/VideoInfo;->durationMs:J

    const-wide/16 v9, 0x3c

    const-string v6, "fps"

    invoke-static/range {v5 .. v10}, Lru/oopssre/imperialschool/viewstv/Protocol;->integer(Lorg/json/JSONObject;Ljava/lang/String;JJ)J

    move-result-wide v2

    long-to-int p2, v2

    iput p2, p0, Lru/oopssre/imperialschool/viewstv/VideoInfo;->fps:I

    .line 16
    iget-object p2, p1, Lru/oopssre/imperialschool/viewstv/Protocol$Frame;->kind:Ljava/lang/String;

    const-string v2, "dynamic"

    invoke-virtual {p2, v2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p2

    const/4 v2, 0x1

    const/4 v3, 0x0

    if-eqz p2, :cond_0

    iget-object p2, p1, Lru/oopssre/imperialschool/viewstv/Protocol$Frame;->device:Ljava/lang/String;

    const-string v4, "desktop_3840x2160"

    invoke-virtual {p2, v4}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p2

    if-eqz p2, :cond_0

    iget p2, p1, Lru/oopssre/imperialschool/viewstv/Protocol$Frame;->width:I

    const/16 v4, 0xf00

    if-ne p2, v4, :cond_0

    iget p2, p1, Lru/oopssre/imperialschool/viewstv/Protocol$Frame;->height:I

    const/16 v4, 0x870

    if-ne p2, v4, :cond_0

    move p2, v2

    goto :goto_0

    :cond_0
    move p2, v3

    :goto_0
    const-string v4, "\u0412\u0438\u0434\u0435\u043e \u043e\u0442\u043d\u043e\u0441\u0438\u0442\u0441\u044f \u043a \u0434\u0440\u0443\u0433\u043e\u043c\u0443 \u043f\u0440\u043e\u0444\u0438\u043b\u044e"

    invoke-static {p2, v4}, Lru/oopssre/imperialschool/viewstv/Protocol;->require(ZLjava/lang/String;)V

    .line 17
    invoke-static {v1}, Lru/oopssre/imperialschool/viewstv/Protocol;->hash(Ljava/lang/String;)Z

    move-result p2

    if-eqz p2, :cond_1

    const-string p2, "source_image_sha256"

    invoke-virtual {v5, p2}, Lorg/json/JSONObject;->getString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object p2

    iget-object v4, p1, Lru/oopssre/imperialschool/viewstv/Protocol$Frame;->sha:Ljava/lang/String;

    invoke-virtual {p2, v4}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p2

    if-eqz p2, :cond_1

    move p2, v2

    goto :goto_1

    :cond_1
    move p2, v3

    :goto_1
    const-string v4, "\u0412\u0438\u0434\u0435\u043e \u043d\u0435 \u0441\u043e\u043e\u0442\u0432\u0435\u0442\u0441\u0442\u0432\u0443\u0435\u0442 \u0438\u0441\u0445\u043e\u0434\u043d\u043e\u043c\u0443 \u0438\u0437\u043e\u0431\u0440\u0430\u0436\u0435\u043d\u0438\u044e \u043a\u0430\u0434\u0440\u0430"

    invoke-static {p2, v4}, Lru/oopssre/imperialschool/viewstv/Protocol;->require(ZLjava/lang/String;)V

    .line 18
    new-instance p2, Ljava/lang/StringBuilder;

    const-string v4, "dynamic/"

    invoke-direct {p2, v4}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    iget-object v4, p1, Lru/oopssre/imperialschool/viewstv/Protocol$Frame;->theme:Ljava/lang/String;

    invoke-virtual {p2, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p2

    const-string v4, "/devices/"

    invoke-virtual {p2, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p2

    iget-object p1, p1, Lru/oopssre/imperialschool/viewstv/Protocol$Frame;->device:Ljava/lang/String;

    invoke-virtual {p2, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p1

    const-string p2, "/video/"

    invoke-virtual {p1, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p1

    invoke-virtual {p1, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p1

    const-string p2, ".mp4"

    invoke-virtual {p1, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p1

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    .line 19
    invoke-static {v0}, Lru/oopssre/imperialschool/viewstv/Protocol;->url(Ljava/lang/String;)Ljava/net/URI;

    move-result-object p2

    invoke-static {p1}, Lru/oopssre/imperialschool/viewstv/Protocol;->url(Ljava/lang/String;)Ljava/net/URI;

    move-result-object p1

    invoke-virtual {p2, p1}, Ljava/net/URI;->equals(Ljava/lang/Object;)Z

    move-result p1

    const-string p2, "\u041d\u0435\u0432\u0435\u0440\u043d\u044b\u0439 \u0430\u0434\u0440\u0435\u0441 MP4"

    invoke-static {p1, p2}, Lru/oopssre/imperialschool/viewstv/Protocol;->require(ZLjava/lang/String;)V

    .line 20
    const-string p1, "format"

    invoke-virtual {v5, p1}, Lorg/json/JSONObject;->getString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object p1

    const-string p2, "mp4"

    invoke-virtual {p1, p2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p1

    if-eqz p1, :cond_2

    const-string p1, "codec"

    invoke-virtual {v5, p1}, Lorg/json/JSONObject;->getString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object p1

    const-string p2, "hevc"

    invoke-virtual {p1, p2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p1

    if-eqz p1, :cond_2

    const-string p1, "profile"

    invoke-virtual {v5, p1}, Lorg/json/JSONObject;->getString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object p1

    const-string p2, "main"

    invoke-virtual {p1, p2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p1

    if-eqz p1, :cond_2

    const-string p1, "pixel_format"

    invoke-virtual {v5, p1}, Lorg/json/JSONObject;->getString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object p1

    const-string p2, "yuv420p"

    invoke-virtual {p1, p2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p1

    if-eqz p1, :cond_2

    move p1, v2

    goto :goto_2

    :cond_2
    move p1, v3

    :goto_2
    const-string p2, "\u041d\u0435\u043f\u043e\u0434\u0434\u0435\u0440\u0436\u0438\u0432\u0430\u0435\u043c\u044b\u0439 \u0444\u043e\u0440\u043c\u0430\u0442 \u0432\u0438\u0434\u0435\u043e"

    invoke-static {p1, p2}, Lru/oopssre/imperialschool/viewstv/Protocol;->require(ZLjava/lang/String;)V

    const-wide/16 v7, 0xf00

    const-wide/16 v9, 0xf00

    .line 21
    const-string v6, "width"

    invoke-static/range {v5 .. v10}, Lru/oopssre/imperialschool/viewstv/Protocol;->integer(Lorg/json/JSONObject;Ljava/lang/String;JJ)J

    move-result-wide p1

    const-wide/16 v0, 0xf00

    cmp-long p1, p1, v0

    if-nez p1, :cond_3

    const-wide/16 v7, 0x870

    const-wide/16 v9, 0x870

    const-string v6, "height"

    invoke-static/range {v5 .. v10}, Lru/oopssre/imperialschool/viewstv/Protocol;->integer(Lorg/json/JSONObject;Ljava/lang/String;JJ)J

    move-result-wide p1

    const-wide/16 v0, 0x870

    cmp-long p1, p1, v0

    if-nez p1, :cond_3

    move p1, v2

    goto :goto_3

    :cond_3
    move p1, v3

    :goto_3
    const-string p2, "\u041d\u0435\u0432\u0435\u0440\u043d\u044b\u0439 \u0440\u0430\u0437\u043c\u0435\u0440 \u0432\u0438\u0434\u0435\u043e"

    invoke-static {p1, p2}, Lru/oopssre/imperialschool/viewstv/Protocol;->require(ZLjava/lang/String;)V

    .line 22
    const-string p1, "audio"

    invoke-virtual {v5, p1}, Lorg/json/JSONObject;->get(Ljava/lang/String;)Ljava/lang/Object;

    move-result-object p2

    instance-of p2, p2, Ljava/lang/Boolean;

    if-eqz p2, :cond_4

    invoke-virtual {v5, p1}, Lorg/json/JSONObject;->getBoolean(Ljava/lang/String;)Z

    move-result p1

    if-nez p1, :cond_4

    goto :goto_4

    :cond_4
    move v2, v3

    :goto_4
    const-string p1, "\u0420\u043e\u043b\u0438\u043a \u0434\u043e\u043b\u0436\u0435\u043d \u0431\u044b\u0442\u044c \u0431\u0435\u0437 \u0430\u0443\u0434\u0438\u043e\u0434\u043e\u0440\u043e\u0436\u043a\u0438"

    invoke-static {v2, p1}, Lru/oopssre/imperialschool/viewstv/Protocol;->require(ZLjava/lang/String;)V

    return-void
.end method

.method public static parse(Lorg/json/JSONObject;Lru/oopssre/imperialschool/viewstv/Protocol$Frame;)Lru/oopssre/imperialschool/viewstv/VideoInfo;
    .locals 1
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Lorg/json/JSONException;
        }
    .end annotation

    .line 25
    const-string v0, "video"

    invoke-virtual {p0, v0}, Lorg/json/JSONObject;->optJSONObject(Ljava/lang/String;)Lorg/json/JSONObject;

    move-result-object p0

    if-eqz p0, :cond_0

    new-instance v0, Lru/oopssre/imperialschool/viewstv/VideoInfo;

    invoke-direct {v0, p1, p0}, Lru/oopssre/imperialschool/viewstv/VideoInfo;-><init>(Lru/oopssre/imperialschool/viewstv/Protocol$Frame;Lorg/json/JSONObject;)V

    return-object v0

    :cond_0
    new-instance p0, Lru/oopssre/imperialschool/viewstv/Protocol$NotReady;

    const-string p1, "\u0412\u0438\u0434\u0435\u043e \u0434\u043b\u044f \u0442\u0435\u043a\u0443\u0449\u0435\u0433\u043e \u043a\u0430\u0434\u0440\u0430 \u0435\u0449\u0451 \u043d\u0435 \u043e\u043f\u0443\u0431\u043b\u0438\u043a\u043e\u0432\u0430\u043d\u043e"

    invoke-direct {p0, p1}, Lru/oopssre/imperialschool/viewstv/Protocol$NotReady;-><init>(Ljava/lang/String;)V

    throw p0
.end method

.method public static saved(Lorg/json/JSONObject;)Lru/oopssre/imperialschool/viewstv/VideoInfo;
    .locals 3
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Lorg/json/JSONException;
        }
    .end annotation

    .line 28
    new-instance v0, Lru/oopssre/imperialschool/viewstv/VideoInfo;

    const-string v1, "frame"

    invoke-virtual {p0, v1}, Lorg/json/JSONObject;->getJSONObject(Ljava/lang/String;)Lorg/json/JSONObject;

    move-result-object v1

    invoke-static {v1}, Lru/oopssre/imperialschool/viewstv/Protocol;->savedFrame(Lorg/json/JSONObject;)Lru/oopssre/imperialschool/viewstv/Protocol$Frame;

    move-result-object v1

    const-string v2, "video"

    invoke-virtual {p0, v2}, Lorg/json/JSONObject;->getJSONObject(Ljava/lang/String;)Lorg/json/JSONObject;

    move-result-object p0

    invoke-direct {v0, v1, p0}, Lru/oopssre/imperialschool/viewstv/VideoInfo;-><init>(Lru/oopssre/imperialschool/viewstv/Protocol$Frame;Lorg/json/JSONObject;)V

    return-object v0
.end method


# virtual methods
.method public json()Lorg/json/JSONObject;
    .locals 3
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Lorg/json/JSONException;
        }
    .end annotation

    .line 27
    new-instance v0, Lorg/json/JSONObject;

    invoke-direct {v0}, Lorg/json/JSONObject;-><init>()V

    iget-object v1, p0, Lru/oopssre/imperialschool/viewstv/VideoInfo;->frame:Lru/oopssre/imperialschool/viewstv/Protocol$Frame;

    invoke-virtual {v1}, Lru/oopssre/imperialschool/viewstv/Protocol$Frame;->json()Lorg/json/JSONObject;

    move-result-object v1

    const-string v2, "frame"

    invoke-virtual {v0, v2, v1}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;

    move-result-object v0

    new-instance v1, Lorg/json/JSONObject;

    iget-object v2, p0, Lru/oopssre/imperialschool/viewstv/VideoInfo;->value:Lorg/json/JSONObject;

    invoke-virtual {v2}, Lorg/json/JSONObject;->toString()Ljava/lang/String;

    move-result-object v2

    invoke-direct {v1, v2}, Lorg/json/JSONObject;-><init>(Ljava/lang/String;)V

    const-string v2, "video"

    invoke-virtual {v0, v2, v1}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;

    move-result-object v0

    return-object v0
.end method

.method public sameMedia(Lru/oopssre/imperialschool/viewstv/VideoInfo;)Z
    .locals 2

    if-eqz p1, :cond_0

    .line 29
    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/VideoInfo;->frame:Lru/oopssre/imperialschool/viewstv/Protocol$Frame;

    invoke-virtual {v0}, Lru/oopssre/imperialschool/viewstv/Protocol$Frame;->scope()Ljava/lang/String;

    move-result-object v0

    iget-object v1, p1, Lru/oopssre/imperialschool/viewstv/VideoInfo;->frame:Lru/oopssre/imperialschool/viewstv/Protocol$Frame;

    invoke-virtual {v1}, Lru/oopssre/imperialschool/viewstv/Protocol$Frame;->scope()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_0

    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/VideoInfo;->sha:Ljava/lang/String;

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
