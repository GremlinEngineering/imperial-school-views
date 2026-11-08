.class public final synthetic Lru/oopssre/imperialschool/viewstv/VideoController$$ExternalSyntheticLambda5;
.super Ljava/lang/Object;
.source "D8$$SyntheticClass"

# interfaces
.implements Ljava/lang/Runnable;


# instance fields
.field public final synthetic f$0:Lru/oopssre/imperialschool/viewstv/VideoController;

.field public final synthetic f$1:J

.field public final synthetic f$2:Lru/oopssre/imperialschool/viewstv/VideoInfo;


# direct methods
.method public synthetic constructor <init>(Lru/oopssre/imperialschool/viewstv/VideoController;JLru/oopssre/imperialschool/viewstv/VideoInfo;)V
    .locals 0

    .line 0
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    iput-object p1, p0, Lru/oopssre/imperialschool/viewstv/VideoController$$ExternalSyntheticLambda5;->f$0:Lru/oopssre/imperialschool/viewstv/VideoController;

    iput-wide p2, p0, Lru/oopssre/imperialschool/viewstv/VideoController$$ExternalSyntheticLambda5;->f$1:J

    iput-object p4, p0, Lru/oopssre/imperialschool/viewstv/VideoController$$ExternalSyntheticLambda5;->f$2:Lru/oopssre/imperialschool/viewstv/VideoInfo;

    return-void
.end method


# virtual methods
.method public final run()V
    .locals 4

    .line 0
    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/VideoController$$ExternalSyntheticLambda5;->f$0:Lru/oopssre/imperialschool/viewstv/VideoController;

    iget-wide v1, p0, Lru/oopssre/imperialschool/viewstv/VideoController$$ExternalSyntheticLambda5;->f$1:J

    iget-object v3, p0, Lru/oopssre/imperialschool/viewstv/VideoController$$ExternalSyntheticLambda5;->f$2:Lru/oopssre/imperialschool/viewstv/VideoInfo;

    invoke-virtual {v0, v1, v2, v3}, Lru/oopssre/imperialschool/viewstv/VideoController;->lambda$offer$2$ru-oopssre-imperialschool-viewstv-VideoController(JLru/oopssre/imperialschool/viewstv/VideoInfo;)V

    return-void
.end method
