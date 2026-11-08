.class public final synthetic Lru/oopssre/imperialschool/viewstv/SceneMusic$$ExternalSyntheticLambda4;
.super Ljava/lang/Object;
.source "D8$$SyntheticClass"

# interfaces
.implements Landroid/media/AudioManager$OnAudioFocusChangeListener;


# instance fields
.field public final synthetic f$0:Lru/oopssre/imperialschool/viewstv/SceneMusic;


# direct methods
.method public synthetic constructor <init>(Lru/oopssre/imperialschool/viewstv/SceneMusic;)V
    .locals 0

    .line 0
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    iput-object p1, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic$$ExternalSyntheticLambda4;->f$0:Lru/oopssre/imperialschool/viewstv/SceneMusic;

    return-void
.end method


# virtual methods
.method public final onAudioFocusChange(I)V
    .locals 1

    .line 0
    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic$$ExternalSyntheticLambda4;->f$0:Lru/oopssre/imperialschool/viewstv/SceneMusic;

    invoke-virtual {v0, p1}, Lru/oopssre/imperialschool/viewstv/SceneMusic;->focusChanged(I)V

    return-void
.end method
