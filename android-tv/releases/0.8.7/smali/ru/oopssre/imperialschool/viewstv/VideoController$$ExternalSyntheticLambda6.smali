.class public final synthetic Lru/oopssre/imperialschool/viewstv/VideoController$$ExternalSyntheticLambda6;
.super Ljava/lang/Object;
.source "D8$$SyntheticClass"

# interfaces
.implements Ljava/lang/Runnable;


# instance fields
.field public final synthetic f$0:Lru/oopssre/imperialschool/viewstv/VideoController;

.field public final synthetic f$1:Lru/oopssre/imperialschool/viewstv/VideoSurface$Clip;

.field public final synthetic f$2:J


# direct methods
.method public synthetic constructor <init>(Lru/oopssre/imperialschool/viewstv/VideoController;Lru/oopssre/imperialschool/viewstv/VideoSurface$Clip;J)V
    .locals 0

    .line 0
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    iput-object p1, p0, Lru/oopssre/imperialschool/viewstv/VideoController$$ExternalSyntheticLambda6;->f$0:Lru/oopssre/imperialschool/viewstv/VideoController;

    iput-object p2, p0, Lru/oopssre/imperialschool/viewstv/VideoController$$ExternalSyntheticLambda6;->f$1:Lru/oopssre/imperialschool/viewstv/VideoSurface$Clip;

    iput-wide p3, p0, Lru/oopssre/imperialschool/viewstv/VideoController$$ExternalSyntheticLambda6;->f$2:J

    return-void
.end method


# virtual methods
.method public final run()V
    .locals 4

    .line 0
    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/VideoController$$ExternalSyntheticLambda6;->f$0:Lru/oopssre/imperialschool/viewstv/VideoController;

    iget-object v1, p0, Lru/oopssre/imperialschool/viewstv/VideoController$$ExternalSyntheticLambda6;->f$1:Lru/oopssre/imperialschool/viewstv/VideoSurface$Clip;

    iget-wide v2, p0, Lru/oopssre/imperialschool/viewstv/VideoController$$ExternalSyntheticLambda6;->f$2:J

    invoke-virtual {v0, v1, v2, v3}, Lru/oopssre/imperialschool/viewstv/VideoController;->lambda$offer$3$ru-oopssre-imperialschool-viewstv-VideoController(Lru/oopssre/imperialschool/viewstv/VideoSurface$Clip;J)V

    return-void
.end method
