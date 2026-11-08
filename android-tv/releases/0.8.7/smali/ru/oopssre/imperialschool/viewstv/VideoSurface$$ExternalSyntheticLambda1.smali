.class public final synthetic Lru/oopssre/imperialschool/viewstv/VideoSurface$$ExternalSyntheticLambda1;
.super Ljava/lang/Object;
.source "D8$$SyntheticClass"

# interfaces
.implements Ljava/lang/Runnable;


# instance fields
.field public final synthetic f$0:Lru/oopssre/imperialschool/viewstv/VideoSurface;

.field public final synthetic f$1:Ljava/util/concurrent/atomic/AtomicReference;

.field public final synthetic f$2:Landroid/view/Surface;

.field public final synthetic f$3:J


# direct methods
.method public synthetic constructor <init>(Lru/oopssre/imperialschool/viewstv/VideoSurface;Ljava/util/concurrent/atomic/AtomicReference;Landroid/view/Surface;J)V
    .locals 0

    .line 0
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    iput-object p1, p0, Lru/oopssre/imperialschool/viewstv/VideoSurface$$ExternalSyntheticLambda1;->f$0:Lru/oopssre/imperialschool/viewstv/VideoSurface;

    iput-object p2, p0, Lru/oopssre/imperialschool/viewstv/VideoSurface$$ExternalSyntheticLambda1;->f$1:Ljava/util/concurrent/atomic/AtomicReference;

    iput-object p3, p0, Lru/oopssre/imperialschool/viewstv/VideoSurface$$ExternalSyntheticLambda1;->f$2:Landroid/view/Surface;

    iput-wide p4, p0, Lru/oopssre/imperialschool/viewstv/VideoSurface$$ExternalSyntheticLambda1;->f$3:J

    return-void
.end method


# virtual methods
.method public final run()V
    .locals 5

    .line 0
    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/VideoSurface$$ExternalSyntheticLambda1;->f$0:Lru/oopssre/imperialschool/viewstv/VideoSurface;

    iget-object v1, p0, Lru/oopssre/imperialschool/viewstv/VideoSurface$$ExternalSyntheticLambda1;->f$1:Ljava/util/concurrent/atomic/AtomicReference;

    iget-object v2, p0, Lru/oopssre/imperialschool/viewstv/VideoSurface$$ExternalSyntheticLambda1;->f$2:Landroid/view/Surface;

    iget-wide v3, p0, Lru/oopssre/imperialschool/viewstv/VideoSurface$$ExternalSyntheticLambda1;->f$3:J

    invoke-virtual {v0, v1, v2, v3, v4}, Lru/oopssre/imperialschool/viewstv/VideoSurface;->lambda$begin$1$ru-oopssre-imperialschool-viewstv-VideoSurface(Ljava/util/concurrent/atomic/AtomicReference;Landroid/view/Surface;J)V

    return-void
.end method
