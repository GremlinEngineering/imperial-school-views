.class final Lru/oopssre/imperialschool/viewstv/MusicPacks$Pack;
.super Ljava/lang/Object;
.source "MusicPacks.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lru/oopssre/imperialschool/viewstv/MusicPacks;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x18
    name = "Pack"
.end annotation


# instance fields
.field final sha:Ljava/lang/String;

.field final tracks:Ljava/util/List;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/List<",
            "Lru/oopssre/imperialschool/viewstv/MusicPacks$Track;",
            ">;"
        }
    .end annotation
.end field


# direct methods
.method constructor <init>(Ljava/lang/String;Ljava/util/List;)V
    .locals 0
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/lang/String;",
            "Ljava/util/List<",
            "Lru/oopssre/imperialschool/viewstv/MusicPacks$Track;",
            ">;)V"
        }
    .end annotation

    .line 30
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 31
    iput-object p1, p0, Lru/oopssre/imperialschool/viewstv/MusicPacks$Pack;->sha:Ljava/lang/String;

    .line 32
    invoke-static {p2}, Ljava/util/Collections;->unmodifiableList(Ljava/util/List;)Ljava/util/List;

    move-result-object p1

    iput-object p1, p0, Lru/oopssre/imperialschool/viewstv/MusicPacks$Pack;->tracks:Ljava/util/List;

    return-void
.end method
