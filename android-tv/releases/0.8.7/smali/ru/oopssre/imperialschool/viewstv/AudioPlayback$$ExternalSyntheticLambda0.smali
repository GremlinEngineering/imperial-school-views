.class public final synthetic Lru/oopssre/imperialschool/viewstv/AudioPlayback$$ExternalSyntheticLambda0;
.super Ljava/lang/Object;
.source "D8$$SyntheticClass"

# interfaces
.implements Ljava/util/function/Consumer;


# instance fields
.field public final synthetic f$0:Lru/oopssre/imperialschool/viewstv/AudioPlayback;

.field public final synthetic f$1:J


# direct methods
.method public synthetic constructor <init>(Lru/oopssre/imperialschool/viewstv/AudioPlayback;J)V
    .locals 0

    .line 0
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    iput-object p1, p0, Lru/oopssre/imperialschool/viewstv/AudioPlayback$$ExternalSyntheticLambda0;->f$0:Lru/oopssre/imperialschool/viewstv/AudioPlayback;

    iput-wide p2, p0, Lru/oopssre/imperialschool/viewstv/AudioPlayback$$ExternalSyntheticLambda0;->f$1:J

    return-void
.end method


# virtual methods
.method public final accept(Ljava/lang/Object;)V
    .locals 3

    .line 0
    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/AudioPlayback$$ExternalSyntheticLambda0;->f$0:Lru/oopssre/imperialschool/viewstv/AudioPlayback;

    iget-wide v1, p0, Lru/oopssre/imperialschool/viewstv/AudioPlayback$$ExternalSyntheticLambda0;->f$1:J

    check-cast p1, Landroid/media/MediaPlayer;

    invoke-virtual {v0, v1, v2, p1}, Lru/oopssre/imperialschool/viewstv/AudioPlayback;->lambda$play$4$ru-oopssre-imperialschool-viewstv-AudioPlayback(JLandroid/media/MediaPlayer;)V

    return-void
.end method
