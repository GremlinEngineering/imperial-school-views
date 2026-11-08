.class public final synthetic Lru/oopssre/imperialschool/viewstv/AudioPlayback$$ExternalSyntheticLambda9;
.super Ljava/lang/Object;
.source "D8$$SyntheticClass"

# interfaces
.implements Ljava/lang/Runnable;


# instance fields
.field public final synthetic f$0:Lru/oopssre/imperialschool/viewstv/AudioPlayback;

.field public final synthetic f$1:Landroid/media/AudioAttributes;

.field public final synthetic f$2:Lru/oopssre/imperialschool/viewstv/MusicPacks$Track;


# direct methods
.method public synthetic constructor <init>(Lru/oopssre/imperialschool/viewstv/AudioPlayback;Landroid/media/AudioAttributes;Lru/oopssre/imperialschool/viewstv/MusicPacks$Track;)V
    .locals 0

    .line 0
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    iput-object p1, p0, Lru/oopssre/imperialschool/viewstv/AudioPlayback$$ExternalSyntheticLambda9;->f$0:Lru/oopssre/imperialschool/viewstv/AudioPlayback;

    iput-object p2, p0, Lru/oopssre/imperialschool/viewstv/AudioPlayback$$ExternalSyntheticLambda9;->f$1:Landroid/media/AudioAttributes;

    iput-object p3, p0, Lru/oopssre/imperialschool/viewstv/AudioPlayback$$ExternalSyntheticLambda9;->f$2:Lru/oopssre/imperialschool/viewstv/MusicPacks$Track;

    return-void
.end method


# virtual methods
.method public final run()V
    .locals 3

    .line 0
    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/AudioPlayback$$ExternalSyntheticLambda9;->f$0:Lru/oopssre/imperialschool/viewstv/AudioPlayback;

    iget-object v1, p0, Lru/oopssre/imperialschool/viewstv/AudioPlayback$$ExternalSyntheticLambda9;->f$1:Landroid/media/AudioAttributes;

    iget-object v2, p0, Lru/oopssre/imperialschool/viewstv/AudioPlayback$$ExternalSyntheticLambda9;->f$2:Lru/oopssre/imperialschool/viewstv/MusicPacks$Track;

    invoke-virtual {v0, v1, v2}, Lru/oopssre/imperialschool/viewstv/AudioPlayback;->lambda$connect$3$ru-oopssre-imperialschool-viewstv-AudioPlayback(Landroid/media/AudioAttributes;Lru/oopssre/imperialschool/viewstv/MusicPacks$Track;)V

    return-void
.end method
