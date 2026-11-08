.class public final synthetic Lru/oopssre/imperialschool/viewstv/AudioPlayback$$ExternalSyntheticLambda4;
.super Ljava/lang/Object;
.source "D8$$SyntheticClass"

# interfaces
.implements Ljava/util/function/Consumer;


# instance fields
.field public final synthetic f$0:Lru/oopssre/imperialschool/viewstv/AudioPlayback;


# direct methods
.method public synthetic constructor <init>(Lru/oopssre/imperialschool/viewstv/AudioPlayback;)V
    .locals 0

    .line 0
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    iput-object p1, p0, Lru/oopssre/imperialschool/viewstv/AudioPlayback$$ExternalSyntheticLambda4;->f$0:Lru/oopssre/imperialschool/viewstv/AudioPlayback;

    return-void
.end method


# virtual methods
.method public final accept(Ljava/lang/Object;)V
    .locals 1

    .line 0
    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/AudioPlayback$$ExternalSyntheticLambda4;->f$0:Lru/oopssre/imperialschool/viewstv/AudioPlayback;

    check-cast p1, Landroid/media/MediaPlayer;

    invoke-virtual {v0, p1}, Lru/oopssre/imperialschool/viewstv/AudioPlayback;->lambda$pause$5$ru-oopssre-imperialschool-viewstv-AudioPlayback(Landroid/media/MediaPlayer;)V

    return-void
.end method
