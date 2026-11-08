.class public final synthetic Lru/oopssre/imperialschool/viewstv/SceneController$$ExternalSyntheticLambda0;
.super Ljava/lang/Object;
.source "D8$$SyntheticClass"

# interfaces
.implements Ljava/lang/Runnable;


# instance fields
.field public final synthetic f$0:Lru/oopssre/imperialschool/viewstv/SceneController;

.field public final synthetic f$1:J

.field public final synthetic f$2:Z

.field public final synthetic f$3:Lru/oopssre/imperialschool/viewstv/Protocol$Frame;


# direct methods
.method public synthetic constructor <init>(Lru/oopssre/imperialschool/viewstv/SceneController;JZLru/oopssre/imperialschool/viewstv/Protocol$Frame;)V
    .locals 0

    .line 0
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    iput-object p1, p0, Lru/oopssre/imperialschool/viewstv/SceneController$$ExternalSyntheticLambda0;->f$0:Lru/oopssre/imperialschool/viewstv/SceneController;

    iput-wide p2, p0, Lru/oopssre/imperialschool/viewstv/SceneController$$ExternalSyntheticLambda0;->f$1:J

    iput-boolean p4, p0, Lru/oopssre/imperialschool/viewstv/SceneController$$ExternalSyntheticLambda0;->f$2:Z

    iput-object p5, p0, Lru/oopssre/imperialschool/viewstv/SceneController$$ExternalSyntheticLambda0;->f$3:Lru/oopssre/imperialschool/viewstv/Protocol$Frame;

    return-void
.end method


# virtual methods
.method public final run()V
    .locals 5

    .line 0
    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/SceneController$$ExternalSyntheticLambda0;->f$0:Lru/oopssre/imperialschool/viewstv/SceneController;

    iget-wide v1, p0, Lru/oopssre/imperialschool/viewstv/SceneController$$ExternalSyntheticLambda0;->f$1:J

    iget-boolean v3, p0, Lru/oopssre/imperialschool/viewstv/SceneController$$ExternalSyntheticLambda0;->f$2:Z

    iget-object v4, p0, Lru/oopssre/imperialschool/viewstv/SceneController$$ExternalSyntheticLambda0;->f$3:Lru/oopssre/imperialschool/viewstv/Protocol$Frame;

    invoke-virtual {v0, v1, v2, v3, v4}, Lru/oopssre/imperialschool/viewstv/SceneController;->lambda$publish$6$ru-oopssre-imperialschool-viewstv-SceneController(JZLru/oopssre/imperialschool/viewstv/Protocol$Frame;)V

    return-void
.end method
