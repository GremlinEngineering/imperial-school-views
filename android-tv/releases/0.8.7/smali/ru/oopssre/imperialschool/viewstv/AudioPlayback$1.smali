.class Lru/oopssre/imperialschool/viewstv/AudioPlayback$1;
.super Ljava/lang/Object;
.source "AudioPlayback.java"

# interfaces
.implements Ljava/lang/Runnable;


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lru/oopssre/imperialschool/viewstv/AudioPlayback;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic this$0:Lru/oopssre/imperialschool/viewstv/AudioPlayback;


# direct methods
.method constructor <init>(Lru/oopssre/imperialschool/viewstv/AudioPlayback;)V
    .locals 0
    .annotation system Ldalvik/annotation/MethodParameters;
        accessFlags = {
            0x8010
        }
        names = {
            null
        }
    .end annotation

    .line 27
    iput-object p1, p0, Lru/oopssre/imperialschool/viewstv/AudioPlayback$1;->this$0:Lru/oopssre/imperialschool/viewstv/AudioPlayback;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public run()V
    .locals 3

    .line 29
    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/AudioPlayback$1;->this$0:Lru/oopssre/imperialschool/viewstv/AudioPlayback;

    invoke-static {v0}, Lru/oopssre/imperialschool/viewstv/AudioPlayback;->access$000(Lru/oopssre/imperialschool/viewstv/AudioPlayback;)Z

    move-result v0

    if-nez v0, :cond_1

    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/AudioPlayback$1;->this$0:Lru/oopssre/imperialschool/viewstv/AudioPlayback;

    invoke-static {v0}, Lru/oopssre/imperialschool/viewstv/AudioPlayback;->access$100(Lru/oopssre/imperialschool/viewstv/AudioPlayback;)Z

    move-result v0

    if-nez v0, :cond_0

    goto :goto_0

    .line 30
    :cond_0
    :try_start_0
    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/AudioPlayback$1;->this$0:Lru/oopssre/imperialschool/viewstv/AudioPlayback;

    invoke-static {v0}, Lru/oopssre/imperialschool/viewstv/AudioPlayback;->access$300(Lru/oopssre/imperialschool/viewstv/AudioPlayback;)Landroid/media/MediaPlayer;

    move-result-object v1

    invoke-virtual {v1}, Landroid/media/MediaPlayer;->getCurrentPosition()I

    move-result v1

    invoke-static {v0, v1}, Lru/oopssre/imperialschool/viewstv/AudioPlayback;->access$202(Lru/oopssre/imperialschool/viewstv/AudioPlayback;I)I
    :try_end_0
    .catch Ljava/lang/IllegalStateException; {:try_start_0 .. :try_end_0} :catch_0

    .line 32
    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/AudioPlayback$1;->this$0:Lru/oopssre/imperialschool/viewstv/AudioPlayback;

    invoke-static {v0}, Lru/oopssre/imperialschool/viewstv/AudioPlayback;->access$400(Lru/oopssre/imperialschool/viewstv/AudioPlayback;)Landroid/os/Handler;

    move-result-object v0

    const-wide/16 v1, 0x3e8

    invoke-virtual {v0, p0, v1, v2}, Landroid/os/Handler;->postDelayed(Ljava/lang/Runnable;J)Z

    :catch_0
    :cond_1
    :goto_0
    return-void
.end method
