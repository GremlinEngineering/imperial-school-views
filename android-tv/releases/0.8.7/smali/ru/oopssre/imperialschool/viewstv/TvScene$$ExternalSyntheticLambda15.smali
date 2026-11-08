.class public final synthetic Lru/oopssre/imperialschool/viewstv/TvScene$$ExternalSyntheticLambda15;
.super Ljava/lang/Object;
.source "D8$$SyntheticClass"

# interfaces
.implements Ljava/lang/Runnable;


# instance fields
.field public final synthetic f$0:Lru/oopssre/imperialschool/viewstv/TvScene;

.field public final synthetic f$1:J

.field public final synthetic f$2:Lru/oopssre/imperialschool/viewstv/Release;

.field public final synthetic f$3:Ljava/lang/String;


# direct methods
.method public synthetic constructor <init>(Lru/oopssre/imperialschool/viewstv/TvScene;JLru/oopssre/imperialschool/viewstv/Release;Ljava/lang/String;)V
    .locals 0

    .line 0
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    iput-object p1, p0, Lru/oopssre/imperialschool/viewstv/TvScene$$ExternalSyntheticLambda15;->f$0:Lru/oopssre/imperialschool/viewstv/TvScene;

    iput-wide p2, p0, Lru/oopssre/imperialschool/viewstv/TvScene$$ExternalSyntheticLambda15;->f$1:J

    iput-object p4, p0, Lru/oopssre/imperialschool/viewstv/TvScene$$ExternalSyntheticLambda15;->f$2:Lru/oopssre/imperialschool/viewstv/Release;

    iput-object p5, p0, Lru/oopssre/imperialschool/viewstv/TvScene$$ExternalSyntheticLambda15;->f$3:Ljava/lang/String;

    return-void
.end method


# virtual methods
.method public final run()V
    .locals 5

    .line 0
    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/TvScene$$ExternalSyntheticLambda15;->f$0:Lru/oopssre/imperialschool/viewstv/TvScene;

    iget-wide v1, p0, Lru/oopssre/imperialschool/viewstv/TvScene$$ExternalSyntheticLambda15;->f$1:J

    iget-object v3, p0, Lru/oopssre/imperialschool/viewstv/TvScene$$ExternalSyntheticLambda15;->f$2:Lru/oopssre/imperialschool/viewstv/Release;

    iget-object v4, p0, Lru/oopssre/imperialschool/viewstv/TvScene$$ExternalSyntheticLambda15;->f$3:Ljava/lang/String;

    invoke-virtual {v0, v1, v2, v3, v4}, Lru/oopssre/imperialschool/viewstv/TvScene;->lambda$checkUpdate$38$ru-oopssre-imperialschool-viewstv-TvScene(JLru/oopssre/imperialschool/viewstv/Release;Ljava/lang/String;)V

    return-void
.end method
