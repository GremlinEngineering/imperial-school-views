.class public final synthetic Lru/oopssre/imperialschool/viewstv/AudioPlayback$$ExternalSyntheticLambda8;
.super Ljava/lang/Object;
.source "D8$$SyntheticClass"

# interfaces
.implements Ljava/lang/Runnable;


# instance fields
.field public final synthetic f$0:Lru/oopssre/imperialschool/viewstv/AudioPlayback;

.field public final synthetic f$1:Ljava/util/function/Consumer;


# direct methods
.method public synthetic constructor <init>(Lru/oopssre/imperialschool/viewstv/AudioPlayback;Ljava/util/function/Consumer;)V
    .locals 0

    .line 0
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    iput-object p1, p0, Lru/oopssre/imperialschool/viewstv/AudioPlayback$$ExternalSyntheticLambda8;->f$0:Lru/oopssre/imperialschool/viewstv/AudioPlayback;

    iput-object p2, p0, Lru/oopssre/imperialschool/viewstv/AudioPlayback$$ExternalSyntheticLambda8;->f$1:Ljava/util/function/Consumer;

    return-void
.end method


# virtual methods
.method public final run()V
    .locals 2

    .line 0
    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/AudioPlayback$$ExternalSyntheticLambda8;->f$0:Lru/oopssre/imperialschool/viewstv/AudioPlayback;

    iget-object v1, p0, Lru/oopssre/imperialschool/viewstv/AudioPlayback$$ExternalSyntheticLambda8;->f$1:Ljava/util/function/Consumer;

    invoke-virtual {v0, v1}, Lru/oopssre/imperialschool/viewstv/AudioPlayback;->lambda$command$7$ru-oopssre-imperialschool-viewstv-AudioPlayback(Ljava/util/function/Consumer;)V

    return-void
.end method
