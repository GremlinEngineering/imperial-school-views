.class public final synthetic Lru/oopssre/imperialschool/viewstv/ThemeGallery$$ExternalSyntheticLambda1;
.super Ljava/lang/Object;
.source "D8$$SyntheticClass"

# interfaces
.implements Ljava/lang/Runnable;


# instance fields
.field public final synthetic f$0:Lru/oopssre/imperialschool/viewstv/TvScene;

.field public final synthetic f$1:Lru/oopssre/imperialschool/viewstv/Protocol$Theme;


# direct methods
.method public synthetic constructor <init>(Lru/oopssre/imperialschool/viewstv/TvScene;Lru/oopssre/imperialschool/viewstv/Protocol$Theme;)V
    .locals 0

    .line 0
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    iput-object p1, p0, Lru/oopssre/imperialschool/viewstv/ThemeGallery$$ExternalSyntheticLambda1;->f$0:Lru/oopssre/imperialschool/viewstv/TvScene;

    iput-object p2, p0, Lru/oopssre/imperialschool/viewstv/ThemeGallery$$ExternalSyntheticLambda1;->f$1:Lru/oopssre/imperialschool/viewstv/Protocol$Theme;

    return-void
.end method


# virtual methods
.method public final run()V
    .locals 2

    .line 0
    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/ThemeGallery$$ExternalSyntheticLambda1;->f$0:Lru/oopssre/imperialschool/viewstv/TvScene;

    iget-object v1, p0, Lru/oopssre/imperialschool/viewstv/ThemeGallery$$ExternalSyntheticLambda1;->f$1:Lru/oopssre/imperialschool/viewstv/Protocol$Theme;

    invoke-static {v0, v1}, Lru/oopssre/imperialschool/viewstv/ThemeGallery;->lambda$new$0(Lru/oopssre/imperialschool/viewstv/TvScene;Lru/oopssre/imperialschool/viewstv/Protocol$Theme;)V

    return-void
.end method
