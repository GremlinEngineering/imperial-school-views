.class public final synthetic Lru/oopssre/imperialschool/viewstv/RadioPlayback$Session$$ExternalSyntheticLambda3;
.super Ljava/lang/Object;
.source "D8$$SyntheticClass"

# interfaces
.implements Ljava/lang/Runnable;


# instance fields
.field public final synthetic f$0:Lru/oopssre/imperialschool/viewstv/RadioPlayback$Session;

.field public final synthetic f$1:F


# direct methods
.method public synthetic constructor <init>(Lru/oopssre/imperialschool/viewstv/RadioPlayback$Session;F)V
    .locals 0

    .line 0
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    iput-object p1, p0, Lru/oopssre/imperialschool/viewstv/RadioPlayback$Session$$ExternalSyntheticLambda3;->f$0:Lru/oopssre/imperialschool/viewstv/RadioPlayback$Session;

    iput p2, p0, Lru/oopssre/imperialschool/viewstv/RadioPlayback$Session$$ExternalSyntheticLambda3;->f$1:F

    return-void
.end method


# virtual methods
.method public final run()V
    .locals 2

    .line 0
    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/RadioPlayback$Session$$ExternalSyntheticLambda3;->f$0:Lru/oopssre/imperialschool/viewstv/RadioPlayback$Session;

    iget v1, p0, Lru/oopssre/imperialschool/viewstv/RadioPlayback$Session$$ExternalSyntheticLambda3;->f$1:F

    invoke-virtual {v0, v1}, Lru/oopssre/imperialschool/viewstv/RadioPlayback$Session;->lambda$volume$2$ru-oopssre-imperialschool-viewstv-RadioPlayback$Session(F)V

    return-void
.end method
