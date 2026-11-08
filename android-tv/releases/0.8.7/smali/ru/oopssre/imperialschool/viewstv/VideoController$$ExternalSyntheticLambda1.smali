.class public final synthetic Lru/oopssre/imperialschool/viewstv/VideoController$$ExternalSyntheticLambda1;
.super Ljava/lang/Object;
.source "D8$$SyntheticClass"

# interfaces
.implements Ljava/lang/Runnable;


# instance fields
.field public final synthetic f$0:Lru/oopssre/imperialschool/viewstv/VideoController;

.field public final synthetic f$1:J

.field public final synthetic f$2:Ljava/lang/String;

.field public final synthetic f$3:J


# direct methods
.method public synthetic constructor <init>(Lru/oopssre/imperialschool/viewstv/VideoController;JLjava/lang/String;J)V
    .locals 0

    .line 0
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    iput-object p1, p0, Lru/oopssre/imperialschool/viewstv/VideoController$$ExternalSyntheticLambda1;->f$0:Lru/oopssre/imperialschool/viewstv/VideoController;

    iput-wide p2, p0, Lru/oopssre/imperialschool/viewstv/VideoController$$ExternalSyntheticLambda1;->f$1:J

    iput-object p4, p0, Lru/oopssre/imperialschool/viewstv/VideoController$$ExternalSyntheticLambda1;->f$2:Ljava/lang/String;

    iput-wide p5, p0, Lru/oopssre/imperialschool/viewstv/VideoController$$ExternalSyntheticLambda1;->f$3:J

    return-void
.end method


# virtual methods
.method public final run()V
    .locals 6

    .line 0
    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/VideoController$$ExternalSyntheticLambda1;->f$0:Lru/oopssre/imperialschool/viewstv/VideoController;

    iget-wide v1, p0, Lru/oopssre/imperialschool/viewstv/VideoController$$ExternalSyntheticLambda1;->f$1:J

    iget-object v3, p0, Lru/oopssre/imperialschool/viewstv/VideoController$$ExternalSyntheticLambda1;->f$2:Ljava/lang/String;

    iget-wide v4, p0, Lru/oopssre/imperialschool/viewstv/VideoController$$ExternalSyntheticLambda1;->f$3:J

    invoke-virtual/range {v0 .. v5}, Lru/oopssre/imperialschool/viewstv/VideoController;->lambda$refresh$5$ru-oopssre-imperialschool-viewstv-VideoController(JLjava/lang/String;J)V

    return-void
.end method
