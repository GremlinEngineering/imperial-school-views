.class final Lru/oopssre/imperialschool/viewstv/MusicPacks$Track;
.super Ljava/lang/Object;
.source "MusicPacks.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lru/oopssre/imperialschool/viewstv/MusicPacks;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x18
    name = "Track"
.end annotation


# instance fields
.field final credit:Ljava/lang/String;

.field final data:[B

.field final file:Ljava/lang/String;

.field final title:Ljava/lang/String;


# direct methods
.method constructor <init>(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;[B)V
    .locals 0

    .line 21
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 22
    iput-object p1, p0, Lru/oopssre/imperialschool/viewstv/MusicPacks$Track;->file:Ljava/lang/String;

    iput-object p2, p0, Lru/oopssre/imperialschool/viewstv/MusicPacks$Track;->title:Ljava/lang/String;

    iput-object p3, p0, Lru/oopssre/imperialschool/viewstv/MusicPacks$Track;->credit:Ljava/lang/String;

    iput-object p4, p0, Lru/oopssre/imperialschool/viewstv/MusicPacks$Track;->data:[B

    return-void
.end method


# virtual methods
.method snes()Z
    .locals 2

    .line 24
    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/MusicPacks$Track;->file:Ljava/lang/String;

    const-string v1, ".snes-registers"

    invoke-virtual {v0, v1}, Ljava/lang/String;->endsWith(Ljava/lang/String;)Z

    move-result v0

    return v0
.end method
