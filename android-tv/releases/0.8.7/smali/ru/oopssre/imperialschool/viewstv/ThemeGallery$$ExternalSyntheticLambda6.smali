.class public final synthetic Lru/oopssre/imperialschool/viewstv/ThemeGallery$$ExternalSyntheticLambda6;
.super Ljava/lang/Object;
.source "D8$$SyntheticClass"

# interfaces
.implements Ljava/lang/Runnable;


# instance fields
.field public final synthetic f$0:Lru/oopssre/imperialschool/viewstv/ThemeGallery;

.field public final synthetic f$1:Lru/oopssre/imperialschool/viewstv/Protocol$Theme;

.field public final synthetic f$2:J


# direct methods
.method public synthetic constructor <init>(Lru/oopssre/imperialschool/viewstv/ThemeGallery;Lru/oopssre/imperialschool/viewstv/Protocol$Theme;J)V
    .locals 0

    .line 0
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    iput-object p1, p0, Lru/oopssre/imperialschool/viewstv/ThemeGallery$$ExternalSyntheticLambda6;->f$0:Lru/oopssre/imperialschool/viewstv/ThemeGallery;

    iput-object p2, p0, Lru/oopssre/imperialschool/viewstv/ThemeGallery$$ExternalSyntheticLambda6;->f$1:Lru/oopssre/imperialschool/viewstv/Protocol$Theme;

    iput-wide p3, p0, Lru/oopssre/imperialschool/viewstv/ThemeGallery$$ExternalSyntheticLambda6;->f$2:J

    return-void
.end method


# virtual methods
.method public final run()V
    .locals 4

    .line 0
    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/ThemeGallery$$ExternalSyntheticLambda6;->f$0:Lru/oopssre/imperialschool/viewstv/ThemeGallery;

    iget-object v1, p0, Lru/oopssre/imperialschool/viewstv/ThemeGallery$$ExternalSyntheticLambda6;->f$1:Lru/oopssre/imperialschool/viewstv/Protocol$Theme;

    iget-wide v2, p0, Lru/oopssre/imperialschool/viewstv/ThemeGallery$$ExternalSyntheticLambda6;->f$2:J

    invoke-virtual {v0, v1, v2, v3}, Lru/oopssre/imperialschool/viewstv/ThemeGallery;->lambda$focus$2$ru-oopssre-imperialschool-viewstv-ThemeGallery(Lru/oopssre/imperialschool/viewstv/Protocol$Theme;J)V

    return-void
.end method
