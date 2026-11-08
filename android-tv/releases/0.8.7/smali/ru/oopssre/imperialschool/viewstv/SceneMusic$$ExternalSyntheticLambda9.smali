.class public final synthetic Lru/oopssre/imperialschool/viewstv/SceneMusic$$ExternalSyntheticLambda9;
.super Ljava/lang/Object;
.source "D8$$SyntheticClass"

# interfaces
.implements Ljava/lang/Runnable;


# instance fields
.field public final synthetic f$0:Lru/oopssre/imperialschool/viewstv/SceneMusic;

.field public final synthetic f$1:J

.field public final synthetic f$2:Ljava/lang/String;

.field public final synthetic f$3:Lru/oopssre/imperialschool/viewstv/MusicPacks$Pack;

.field public final synthetic f$4:J


# direct methods
.method public synthetic constructor <init>(Lru/oopssre/imperialschool/viewstv/SceneMusic;JLjava/lang/String;Lru/oopssre/imperialschool/viewstv/MusicPacks$Pack;J)V
    .locals 0

    .line 0
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    iput-object p1, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic$$ExternalSyntheticLambda9;->f$0:Lru/oopssre/imperialschool/viewstv/SceneMusic;

    iput-wide p2, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic$$ExternalSyntheticLambda9;->f$1:J

    iput-object p4, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic$$ExternalSyntheticLambda9;->f$2:Ljava/lang/String;

    iput-object p5, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic$$ExternalSyntheticLambda9;->f$3:Lru/oopssre/imperialschool/viewstv/MusicPacks$Pack;

    iput-wide p6, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic$$ExternalSyntheticLambda9;->f$4:J

    return-void
.end method


# virtual methods
.method public final run()V
    .locals 7

    .line 0
    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic$$ExternalSyntheticLambda9;->f$0:Lru/oopssre/imperialschool/viewstv/SceneMusic;

    iget-wide v1, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic$$ExternalSyntheticLambda9;->f$1:J

    iget-object v3, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic$$ExternalSyntheticLambda9;->f$2:Ljava/lang/String;

    iget-object v4, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic$$ExternalSyntheticLambda9;->f$3:Lru/oopssre/imperialschool/viewstv/MusicPacks$Pack;

    iget-wide v5, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic$$ExternalSyntheticLambda9;->f$4:J

    invoke-virtual/range {v0 .. v6}, Lru/oopssre/imperialschool/viewstv/SceneMusic;->lambda$loadPack$4$ru-oopssre-imperialschool-viewstv-SceneMusic(JLjava/lang/String;Lru/oopssre/imperialschool/viewstv/MusicPacks$Pack;J)V

    return-void
.end method
