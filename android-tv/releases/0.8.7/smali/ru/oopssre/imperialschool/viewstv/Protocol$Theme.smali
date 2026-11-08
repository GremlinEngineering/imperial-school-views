.class public final Lru/oopssre/imperialschool/viewstv/Protocol$Theme;
.super Ljava/lang/Object;
.source "Protocol.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lru/oopssre/imperialschool/viewstv/Protocol;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x19
    name = "Theme"
.end annotation


# instance fields
.field public final current:Ljava/lang/String;

.field public final descriptor:Lorg/json/JSONObject;

.field public final device:Ljava/lang/String;

.field public final height:I

.field public final id:Ljava/lang/String;

.field public final kind:Ljava/lang/String;

.field public final title:Ljava/lang/String;

.field public final width:I


# direct methods
.method constructor <init>(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;IILorg/json/JSONObject;)V
    .locals 0

    .line 27
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    iput-object p1, p0, Lru/oopssre/imperialschool/viewstv/Protocol$Theme;->id:Ljava/lang/String;

    iput-object p2, p0, Lru/oopssre/imperialschool/viewstv/Protocol$Theme;->title:Ljava/lang/String;

    iput-object p3, p0, Lru/oopssre/imperialschool/viewstv/Protocol$Theme;->device:Ljava/lang/String;

    iput-object p4, p0, Lru/oopssre/imperialschool/viewstv/Protocol$Theme;->current:Ljava/lang/String;

    iput p5, p0, Lru/oopssre/imperialschool/viewstv/Protocol$Theme;->width:I

    iput p6, p0, Lru/oopssre/imperialschool/viewstv/Protocol$Theme;->height:I

    iput-object p7, p0, Lru/oopssre/imperialschool/viewstv/Protocol$Theme;->descriptor:Lorg/json/JSONObject;

    const-string p1, "type"

    const-string p2, "plain"

    invoke-virtual {p7, p1, p2}, Lorg/json/JSONObject;->optString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object p1

    iput-object p1, p0, Lru/oopssre/imperialschool/viewstv/Protocol$Theme;->kind:Ljava/lang/String;

    return-void
.end method


# virtual methods
.method public prefix()Ljava/lang/String;
    .locals 2

    .line 28
    new-instance v0, Ljava/lang/StringBuilder;

    const-string v1, "dynamic/"

    invoke-direct {v0, v1}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    iget-object v1, p0, Lru/oopssre/imperialschool/viewstv/Protocol$Theme;->id:Ljava/lang/String;

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    const-string v1, "/devices/"

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    iget-object v1, p0, Lru/oopssre/imperialschool/viewstv/Protocol$Theme;->device:Ljava/lang/String;

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    const-string v1, "/"

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    return-object v0
.end method
