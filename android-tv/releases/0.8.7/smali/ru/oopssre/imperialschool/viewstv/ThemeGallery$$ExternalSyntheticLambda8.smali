.class public final synthetic Lru/oopssre/imperialschool/viewstv/ThemeGallery$$ExternalSyntheticLambda8;
.super Ljava/lang/Object;
.source "D8$$SyntheticClass"

# interfaces
.implements Ljava/lang/Runnable;


# instance fields
.field public final synthetic f$0:Lru/oopssre/imperialschool/viewstv/ThemeGallery;

.field public final synthetic f$1:J

.field public final synthetic f$2:Landroid/graphics/Bitmap;

.field public final synthetic f$3:Lru/oopssre/imperialschool/viewstv/Protocol$Theme;


# direct methods
.method public synthetic constructor <init>(Lru/oopssre/imperialschool/viewstv/ThemeGallery;JLandroid/graphics/Bitmap;Lru/oopssre/imperialschool/viewstv/Protocol$Theme;)V
    .locals 0

    .line 0
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    iput-object p1, p0, Lru/oopssre/imperialschool/viewstv/ThemeGallery$$ExternalSyntheticLambda8;->f$0:Lru/oopssre/imperialschool/viewstv/ThemeGallery;

    iput-wide p2, p0, Lru/oopssre/imperialschool/viewstv/ThemeGallery$$ExternalSyntheticLambda8;->f$1:J

    iput-object p4, p0, Lru/oopssre/imperialschool/viewstv/ThemeGallery$$ExternalSyntheticLambda8;->f$2:Landroid/graphics/Bitmap;

    iput-object p5, p0, Lru/oopssre/imperialschool/viewstv/ThemeGallery$$ExternalSyntheticLambda8;->f$3:Lru/oopssre/imperialschool/viewstv/Protocol$Theme;

    return-void
.end method


# virtual methods
.method public final run()V
    .locals 5

    .line 0
    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/ThemeGallery$$ExternalSyntheticLambda8;->f$0:Lru/oopssre/imperialschool/viewstv/ThemeGallery;

    iget-wide v1, p0, Lru/oopssre/imperialschool/viewstv/ThemeGallery$$ExternalSyntheticLambda8;->f$1:J

    iget-object v3, p0, Lru/oopssre/imperialschool/viewstv/ThemeGallery$$ExternalSyntheticLambda8;->f$2:Landroid/graphics/Bitmap;

    iget-object v4, p0, Lru/oopssre/imperialschool/viewstv/ThemeGallery$$ExternalSyntheticLambda8;->f$3:Lru/oopssre/imperialschool/viewstv/Protocol$Theme;

    invoke-virtual {v0, v1, v2, v3, v4}, Lru/oopssre/imperialschool/viewstv/ThemeGallery;->lambda$publish$6$ru-oopssre-imperialschool-viewstv-ThemeGallery(JLandroid/graphics/Bitmap;Lru/oopssre/imperialschool/viewstv/Protocol$Theme;)V

    return-void
.end method
