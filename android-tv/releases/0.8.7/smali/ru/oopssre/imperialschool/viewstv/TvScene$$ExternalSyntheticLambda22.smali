.class public final synthetic Lru/oopssre/imperialschool/viewstv/TvScene$$ExternalSyntheticLambda22;
.super Ljava/lang/Object;
.source "D8$$SyntheticClass"

# interfaces
.implements Lru/oopssre/imperialschool/viewstv/SceneMusic$Listener;


# instance fields
.field public final synthetic f$0:Lru/oopssre/imperialschool/viewstv/TvScene;


# direct methods
.method public synthetic constructor <init>(Lru/oopssre/imperialschool/viewstv/TvScene;)V
    .locals 0

    .line 0
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    iput-object p1, p0, Lru/oopssre/imperialschool/viewstv/TvScene$$ExternalSyntheticLambda22;->f$0:Lru/oopssre/imperialschool/viewstv/TvScene;

    return-void
.end method


# virtual methods
.method public final changed()V
    .locals 1

    .line 0
    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/TvScene$$ExternalSyntheticLambda22;->f$0:Lru/oopssre/imperialschool/viewstv/TvScene;

    invoke-virtual {v0}, Lru/oopssre/imperialschool/viewstv/TvScene;->musicChanged()V

    return-void
.end method
