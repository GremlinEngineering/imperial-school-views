.class public final synthetic Lru/oopssre/imperialschool/viewstv/SceneMusic$$ExternalSyntheticLambda8;
.super Ljava/lang/Object;
.source "D8$$SyntheticClass"

# interfaces
.implements Ljava/lang/Runnable;


# instance fields
.field public final synthetic f$0:Lru/oopssre/imperialschool/viewstv/SceneMusic;

.field public final synthetic f$1:J

.field public final synthetic f$2:Lru/oopssre/imperialschool/viewstv/MusicPacks$Pack;


# direct methods
.method public synthetic constructor <init>(Lru/oopssre/imperialschool/viewstv/SceneMusic;JLru/oopssre/imperialschool/viewstv/MusicPacks$Pack;)V
    .locals 0

    .line 0
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    iput-object p1, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic$$ExternalSyntheticLambda8;->f$0:Lru/oopssre/imperialschool/viewstv/SceneMusic;

    iput-wide p2, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic$$ExternalSyntheticLambda8;->f$1:J

    iput-object p4, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic$$ExternalSyntheticLambda8;->f$2:Lru/oopssre/imperialschool/viewstv/MusicPacks$Pack;

    return-void
.end method


# virtual methods
.method public final run()V
    .locals 4

    .line 0
    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic$$ExternalSyntheticLambda8;->f$0:Lru/oopssre/imperialschool/viewstv/SceneMusic;

    iget-wide v1, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic$$ExternalSyntheticLambda8;->f$1:J

    iget-object v3, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic$$ExternalSyntheticLambda8;->f$2:Lru/oopssre/imperialschool/viewstv/MusicPacks$Pack;

    invoke-virtual {v0, v1, v2, v3}, Lru/oopssre/imperialschool/viewstv/SceneMusic;->lambda$loadPack$3$ru-oopssre-imperialschool-viewstv-SceneMusic(JLru/oopssre/imperialschool/viewstv/MusicPacks$Pack;)V

    return-void
.end method
