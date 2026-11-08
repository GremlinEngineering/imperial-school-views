.class public final Lru/oopssre/imperialschool/viewstv/Protocol$Frame;
.super Ljava/lang/Object;
.source "Protocol.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lru/oopssre/imperialschool/viewstv/Protocol;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x19
    name = "Frame"
.end annotation


# instance fields
.field public final at:J

.field public final bytes:J

.field public final device:Ljava/lang/String;

.field public final format:Ljava/lang/String;

.field public final height:I

.field public kind:Ljava/lang/String;

.field public refreshAt:J

.field public final sha:Ljava/lang/String;

.field public sourceId:Ljava/lang/String;

.field public final stateId:Ljava/lang/String;

.field public final theme:Ljava/lang/String;

.field public final title:Ljava/lang/String;

.field public final until:J

.field public final url:Ljava/lang/String;

.field public final width:I


# direct methods
.method constructor <init>(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;IIJJJ)V
    .locals 1

    .line 91
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 90
    const-string v0, "dynamic"

    iput-object v0, p0, Lru/oopssre/imperialschool/viewstv/Protocol$Frame;->kind:Ljava/lang/String;

    const-string v0, "real"

    iput-object v0, p0, Lru/oopssre/imperialschool/viewstv/Protocol$Frame;->sourceId:Ljava/lang/String;

    .line 91
    iput-object p1, p0, Lru/oopssre/imperialschool/viewstv/Protocol$Frame;->theme:Ljava/lang/String;

    iput-object p2, p0, Lru/oopssre/imperialschool/viewstv/Protocol$Frame;->device:Ljava/lang/String;

    iput-object p3, p0, Lru/oopssre/imperialschool/viewstv/Protocol$Frame;->title:Ljava/lang/String;

    iput-object p4, p0, Lru/oopssre/imperialschool/viewstv/Protocol$Frame;->url:Ljava/lang/String;

    invoke-static {p4}, Lru/oopssre/imperialschool/viewstv/ImageFormat;->fromURL(Ljava/lang/String;)Ljava/lang/String;

    move-result-object p1

    iput-object p1, p0, Lru/oopssre/imperialschool/viewstv/Protocol$Frame;->format:Ljava/lang/String;

    iput-object p5, p0, Lru/oopssre/imperialschool/viewstv/Protocol$Frame;->sha:Ljava/lang/String;

    iput-object p6, p0, Lru/oopssre/imperialschool/viewstv/Protocol$Frame;->stateId:Ljava/lang/String;

    iput p7, p0, Lru/oopssre/imperialschool/viewstv/Protocol$Frame;->width:I

    iput p8, p0, Lru/oopssre/imperialschool/viewstv/Protocol$Frame;->height:I

    iput-wide p9, p0, Lru/oopssre/imperialschool/viewstv/Protocol$Frame;->bytes:J

    iput-wide p11, p0, Lru/oopssre/imperialschool/viewstv/Protocol$Frame;->at:J

    iput-wide p13, p0, Lru/oopssre/imperialschool/viewstv/Protocol$Frame;->until:J

    iput-wide p13, p0, Lru/oopssre/imperialschool/viewstv/Protocol$Frame;->refreshAt:J

    return-void
.end method


# virtual methods
.method public json()Lorg/json/JSONObject;
    .locals 4
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Lorg/json/JSONException;
        }
    .end annotation

    .line 93
    new-instance v0, Lorg/json/JSONObject;

    invoke-direct {v0}, Lorg/json/JSONObject;-><init>()V

    const-string v1, "theme"

    iget-object v2, p0, Lru/oopssre/imperialschool/viewstv/Protocol$Frame;->theme:Ljava/lang/String;

    invoke-virtual {v0, v1, v2}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;

    move-result-object v0

    const-string v1, "device"

    iget-object v2, p0, Lru/oopssre/imperialschool/viewstv/Protocol$Frame;->device:Ljava/lang/String;

    invoke-virtual {v0, v1, v2}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;

    move-result-object v0

    const-string v1, "title"

    iget-object v2, p0, Lru/oopssre/imperialschool/viewstv/Protocol$Frame;->title:Ljava/lang/String;

    invoke-virtual {v0, v1, v2}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;

    move-result-object v0

    const-string v1, "url"

    iget-object v2, p0, Lru/oopssre/imperialschool/viewstv/Protocol$Frame;->url:Ljava/lang/String;

    invoke-virtual {v0, v1, v2}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;

    move-result-object v0

    const-string v1, "format"

    iget-object v2, p0, Lru/oopssre/imperialschool/viewstv/Protocol$Frame;->format:Ljava/lang/String;

    invoke-virtual {v0, v1, v2}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;

    move-result-object v0

    const-string v1, "sha"

    iget-object v2, p0, Lru/oopssre/imperialschool/viewstv/Protocol$Frame;->sha:Ljava/lang/String;

    invoke-virtual {v0, v1, v2}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;

    move-result-object v0

    const-string v1, "state"

    iget-object v2, p0, Lru/oopssre/imperialschool/viewstv/Protocol$Frame;->stateId:Ljava/lang/String;

    invoke-virtual {v0, v1, v2}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;

    move-result-object v0

    const-string v1, "width"

    iget v2, p0, Lru/oopssre/imperialschool/viewstv/Protocol$Frame;->width:I

    invoke-virtual {v0, v1, v2}, Lorg/json/JSONObject;->put(Ljava/lang/String;I)Lorg/json/JSONObject;

    move-result-object v0

    const-string v1, "height"

    iget v2, p0, Lru/oopssre/imperialschool/viewstv/Protocol$Frame;->height:I

    invoke-virtual {v0, v1, v2}, Lorg/json/JSONObject;->put(Ljava/lang/String;I)Lorg/json/JSONObject;

    move-result-object v0

    const-string v1, "bytes"

    iget-wide v2, p0, Lru/oopssre/imperialschool/viewstv/Protocol$Frame;->bytes:J

    invoke-virtual {v0, v1, v2, v3}, Lorg/json/JSONObject;->put(Ljava/lang/String;J)Lorg/json/JSONObject;

    move-result-object v0

    const-string v1, "at"

    iget-wide v2, p0, Lru/oopssre/imperialschool/viewstv/Protocol$Frame;->at:J

    invoke-virtual {v0, v1, v2, v3}, Lorg/json/JSONObject;->put(Ljava/lang/String;J)Lorg/json/JSONObject;

    move-result-object v0

    const-string v1, "until"

    iget-wide v2, p0, Lru/oopssre/imperialschool/viewstv/Protocol$Frame;->until:J

    invoke-virtual {v0, v1, v2, v3}, Lorg/json/JSONObject;->put(Ljava/lang/String;J)Lorg/json/JSONObject;

    move-result-object v0

    const-string v1, "kind"

    iget-object v2, p0, Lru/oopssre/imperialschool/viewstv/Protocol$Frame;->kind:Ljava/lang/String;

    invoke-virtual {v0, v1, v2}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;

    move-result-object v0

    const-string v1, "source_id"

    iget-object v2, p0, Lru/oopssre/imperialschool/viewstv/Protocol$Frame;->sourceId:Ljava/lang/String;

    invoke-virtual {v0, v1, v2}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;

    move-result-object v0

    const-string v1, "refresh_at"

    iget-wide v2, p0, Lru/oopssre/imperialschool/viewstv/Protocol$Frame;->refreshAt:J

    invoke-virtual {v0, v1, v2, v3}, Lorg/json/JSONObject;->put(Ljava/lang/String;J)Lorg/json/JSONObject;

    move-result-object v0

    return-object v0
.end method

.method public nextDelay(J)J
    .locals 2

    .line 94
    iget-wide v0, p0, Lru/oopssre/imperialschool/viewstv/Protocol$Frame;->refreshAt:J

    sub-long/2addr v0, p1

    const-wide/32 p1, 0x36ee80

    invoke-static {p1, p2, v0, v1}, Ljava/lang/Math;->min(JJ)J

    move-result-wide p1

    const-wide/32 v0, 0xea60

    invoke-static {v0, v1, p1, p2}, Ljava/lang/Math;->max(JJ)J

    move-result-wide p1

    return-wide p1
.end method

.method public scope()Ljava/lang/String;
    .locals 2

    .line 92
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    iget-object v1, p0, Lru/oopssre/imperialschool/viewstv/Protocol$Frame;->theme:Ljava/lang/String;

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    const-string v1, "/"

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    iget-object v1, p0, Lru/oopssre/imperialschool/viewstv/Protocol$Frame;->device:Ljava/lang/String;

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    return-object v0
.end method

.method public stale(J)Z
    .locals 2

    .line 96
    invoke-virtual {p0}, Lru/oopssre/imperialschool/viewstv/Protocol$Frame;->staleAfter()J

    move-result-wide v0

    cmp-long p1, p1, v0

    if-ltz p1, :cond_0

    const/4 p1, 0x1

    return p1

    :cond_0
    const/4 p1, 0x0

    return p1
.end method

.method public staleAfter()J
    .locals 8

    .line 95
    iget-wide v0, p0, Lru/oopssre/imperialschool/viewstv/Protocol$Frame;->until:J

    iget-wide v2, p0, Lru/oopssre/imperialschool/viewstv/Protocol$Frame;->at:J

    sub-long v2, v0, v2

    const-wide v4, 0x7fffffffffffffffL

    sub-long v6, v4, v2

    cmp-long v6, v0, v6

    if-lez v6, :cond_0

    return-wide v4

    :cond_0
    add-long/2addr v0, v2

    return-wide v0
.end method
