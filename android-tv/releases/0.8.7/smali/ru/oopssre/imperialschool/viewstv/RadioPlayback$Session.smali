.class final Lru/oopssre/imperialschool/viewstv/RadioPlayback$Session;
.super Ljava/lang/Object;
.source "RadioPlayback.java"

# interfaces
.implements Lru/oopssre/imperialschool/viewstv/ScenePlayback;


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lru/oopssre/imperialschool/viewstv/RadioPlayback;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x12
    name = "Session"
.end annotation


# instance fields
.field volatile closed:Z

.field final id:Ljava/lang/String;

.field lastState:I

.field operation:J

.field playing:Z

.field prepared:Z

.field reportedOperation:J

.field terminal:Z

.field final synthetic this$0:Lru/oopssre/imperialschool/viewstv/RadioPlayback;


# direct methods
.method constructor <init>(Lru/oopssre/imperialschool/viewstv/RadioPlayback;Ljava/lang/String;)V
    .locals 0
    .annotation system Ldalvik/annotation/MethodParameters;
        accessFlags = {
            0x1010,
            0x0
        }
        names = {
            null,
            null
        }
    .end annotation

    .line 107
    iput-object p1, p0, Lru/oopssre/imperialschool/viewstv/RadioPlayback$Session;->this$0:Lru/oopssre/imperialschool/viewstv/RadioPlayback;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    const/4 p1, 0x1

    .line 104
    iput p1, p0, Lru/oopssre/imperialschool/viewstv/RadioPlayback$Session;->lastState:I

    .line 107
    iput-object p2, p0, Lru/oopssre/imperialschool/viewstv/RadioPlayback$Session;->id:Ljava/lang/String;

    return-void
.end method

.method private command(Ljava/lang/Runnable;)V
    .locals 2

    .line 172
    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/RadioPlayback$Session;->this$0:Lru/oopssre/imperialschool/viewstv/RadioPlayback;

    invoke-static {v0}, Lru/oopssre/imperialschool/viewstv/RadioPlayback;->access$100(Lru/oopssre/imperialschool/viewstv/RadioPlayback;)Landroid/os/Handler;

    move-result-object v0

    new-instance v1, Lru/oopssre/imperialschool/viewstv/RadioPlayback$Session$$ExternalSyntheticLambda0;

    invoke-direct {v1, p0, p1}, Lru/oopssre/imperialschool/viewstv/RadioPlayback$Session$$ExternalSyntheticLambda0;-><init>(Lru/oopssre/imperialschool/viewstv/RadioPlayback$Session;Ljava/lang/Runnable;)V

    invoke-virtual {v0, v1}, Landroid/os/Handler;->post(Ljava/lang/Runnable;)Z

    return-void
.end method

.method private emit(Lru/oopssre/imperialschool/viewstv/ScenePlayback$Event;J)V
    .locals 2

    .line 187
    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/RadioPlayback$Session;->this$0:Lru/oopssre/imperialschool/viewstv/RadioPlayback;

    invoke-static {v0}, Lru/oopssre/imperialschool/viewstv/RadioPlayback;->access$200(Lru/oopssre/imperialschool/viewstv/RadioPlayback;)Landroid/os/Handler;

    move-result-object v0

    new-instance v1, Lru/oopssre/imperialschool/viewstv/RadioPlayback$Session$$ExternalSyntheticLambda4;

    invoke-direct {v1, p0, p1, p2, p3}, Lru/oopssre/imperialschool/viewstv/RadioPlayback$Session$$ExternalSyntheticLambda4;-><init>(Lru/oopssre/imperialschool/viewstv/RadioPlayback$Session;Lru/oopssre/imperialschool/viewstv/ScenePlayback$Event;J)V

    invoke-virtual {v0, v1}, Landroid/os/Handler;->post(Ljava/lang/Runnable;)Z

    return-void
.end method


# virtual methods
.method public close()V
    .locals 2

    .line 156
    iget-boolean v0, p0, Lru/oopssre/imperialschool/viewstv/RadioPlayback$Session;->closed:Z

    if-eqz v0, :cond_0

    return-void

    :cond_0
    const/4 v0, 0x1

    .line 157
    iput-boolean v0, p0, Lru/oopssre/imperialschool/viewstv/RadioPlayback$Session;->closed:Z

    .line 158
    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/RadioPlayback$Session;->this$0:Lru/oopssre/imperialschool/viewstv/RadioPlayback;

    invoke-static {v0}, Lru/oopssre/imperialschool/viewstv/RadioPlayback;->access$100(Lru/oopssre/imperialschool/viewstv/RadioPlayback;)Landroid/os/Handler;

    move-result-object v0

    new-instance v1, Lru/oopssre/imperialschool/viewstv/RadioPlayback$Session$$ExternalSyntheticLambda2;

    invoke-direct {v1, p0}, Lru/oopssre/imperialschool/viewstv/RadioPlayback$Session$$ExternalSyntheticLambda2;-><init>(Lru/oopssre/imperialschool/viewstv/RadioPlayback$Session;)V

    invoke-virtual {v0, v1}, Landroid/os/Handler;->post(Ljava/lang/Runnable;)Z

    return-void
.end method

.method fail(Ljava/lang/Throwable;)V
    .locals 2

    .line 180
    iget-boolean v0, p0, Lru/oopssre/imperialschool/viewstv/RadioPlayback$Session;->closed:Z

    if-nez v0, :cond_1

    iget-boolean v0, p0, Lru/oopssre/imperialschool/viewstv/RadioPlayback$Session;->terminal:Z

    if-eqz v0, :cond_0

    goto :goto_0

    :cond_0
    const/4 v0, 0x1

    .line 181
    iput-boolean v0, p0, Lru/oopssre/imperialschool/viewstv/RadioPlayback$Session;->terminal:Z

    .line 182
    const-string v0, "ImperialTvRadio"

    const-string v1, "Radio playback failed"

    invoke-static {v0, v1, p1}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I

    .line 183
    sget-object p1, Lru/oopssre/imperialschool/viewstv/ScenePlayback$Event;->FAILED:Lru/oopssre/imperialschool/viewstv/ScenePlayback$Event;

    const-wide/16 v0, 0x0

    invoke-direct {p0, p1, v0, v1}, Lru/oopssre/imperialschool/viewstv/RadioPlayback$Session;->emit(Lru/oopssre/imperialschool/viewstv/ScenePlayback$Event;J)V

    :cond_1
    :goto_0
    return-void
.end method

.method synthetic lambda$close$3$ru-oopssre-imperialschool-viewstv-RadioPlayback$Session()V
    .locals 3

    .line 159
    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/RadioPlayback$Session;->this$0:Lru/oopssre/imperialschool/viewstv/RadioPlayback;

    invoke-static {v0}, Lru/oopssre/imperialschool/viewstv/RadioPlayback;->access$000(Lru/oopssre/imperialschool/viewstv/RadioPlayback;)Lru/oopssre/imperialschool/viewstv/RadioPlayback$Session;

    move-result-object v0

    if-eq v0, p0, :cond_0

    return-void

    .line 160
    :cond_0
    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/RadioPlayback$Session;->this$0:Lru/oopssre/imperialschool/viewstv/RadioPlayback;

    const/4 v1, 0x0

    invoke-static {v0, v1}, Lru/oopssre/imperialschool/viewstv/RadioPlayback;->access$002(Lru/oopssre/imperialschool/viewstv/RadioPlayback;Lru/oopssre/imperialschool/viewstv/RadioPlayback$Session;)Lru/oopssre/imperialschool/viewstv/RadioPlayback$Session;

    .line 162
    :try_start_0
    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/RadioPlayback$Session;->this$0:Lru/oopssre/imperialschool/viewstv/RadioPlayback;

    invoke-static {v0}, Lru/oopssre/imperialschool/viewstv/RadioPlayback;->access$400(Lru/oopssre/imperialschool/viewstv/RadioPlayback;)Landroidx/media3/exoplayer/ExoPlayer;

    move-result-object v0

    invoke-interface {v0}, Landroidx/media3/exoplayer/ExoPlayer;->pause()V

    .line 163
    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/RadioPlayback$Session;->this$0:Lru/oopssre/imperialschool/viewstv/RadioPlayback;

    invoke-static {v0}, Lru/oopssre/imperialschool/viewstv/RadioPlayback;->access$400(Lru/oopssre/imperialschool/viewstv/RadioPlayback;)Landroidx/media3/exoplayer/ExoPlayer;

    move-result-object v0

    invoke-interface {v0}, Landroidx/media3/exoplayer/ExoPlayer;->stop()V

    .line 164
    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/RadioPlayback$Session;->this$0:Lru/oopssre/imperialschool/viewstv/RadioPlayback;

    invoke-static {v0}, Lru/oopssre/imperialschool/viewstv/RadioPlayback;->access$400(Lru/oopssre/imperialschool/viewstv/RadioPlayback;)Landroidx/media3/exoplayer/ExoPlayer;

    move-result-object v0

    invoke-interface {v0}, Landroidx/media3/exoplayer/ExoPlayer;->clearMediaItems()V
    :try_end_0
    .catch Ljava/lang/RuntimeException; {:try_start_0 .. :try_end_0} :catch_1
    .catch Ljava/lang/LinkageError; {:try_start_0 .. :try_end_0} :catch_0

    return-void

    :catch_0
    move-exception v0

    goto :goto_0

    :catch_1
    move-exception v0

    .line 166
    :goto_0
    const-string v1, "ImperialTvRadio"

    const-string v2, "Could not stop radio source"

    invoke-static {v1, v2, v0}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I

    return-void
.end method

.method synthetic lambda$command$4$ru-oopssre-imperialschool-viewstv-RadioPlayback$Session(Ljava/lang/Runnable;)V
    .locals 1

    .line 173
    iget-boolean v0, p0, Lru/oopssre/imperialschool/viewstv/RadioPlayback$Session;->closed:Z

    if-nez v0, :cond_1

    iget-boolean v0, p0, Lru/oopssre/imperialschool/viewstv/RadioPlayback$Session;->terminal:Z

    if-nez v0, :cond_1

    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/RadioPlayback$Session;->this$0:Lru/oopssre/imperialschool/viewstv/RadioPlayback;

    invoke-static {v0}, Lru/oopssre/imperialschool/viewstv/RadioPlayback;->access$000(Lru/oopssre/imperialschool/viewstv/RadioPlayback;)Lru/oopssre/imperialschool/viewstv/RadioPlayback$Session;

    move-result-object v0

    if-eq v0, p0, :cond_0

    goto :goto_1

    .line 174
    :cond_0
    :try_start_0
    invoke-interface {p1}, Ljava/lang/Runnable;->run()V
    :try_end_0
    .catch Ljava/lang/RuntimeException; {:try_start_0 .. :try_end_0} :catch_1
    .catch Ljava/lang/LinkageError; {:try_start_0 .. :try_end_0} :catch_0

    return-void

    :catch_0
    move-exception p1

    goto :goto_0

    :catch_1
    move-exception p1

    .line 175
    :goto_0
    invoke-virtual {p0, p1}, Lru/oopssre/imperialschool/viewstv/RadioPlayback$Session;->fail(Ljava/lang/Throwable;)V

    :cond_1
    :goto_1
    return-void
.end method

.method synthetic lambda$emit$5$ru-oopssre-imperialschool-viewstv-RadioPlayback$Session(Lru/oopssre/imperialschool/viewstv/ScenePlayback$Event;J)V
    .locals 1

    .line 187
    iget-boolean v0, p0, Lru/oopssre/imperialschool/viewstv/RadioPlayback$Session;->closed:Z

    if-nez v0, :cond_0

    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/RadioPlayback$Session;->this$0:Lru/oopssre/imperialschool/viewstv/RadioPlayback;

    invoke-static {v0}, Lru/oopssre/imperialschool/viewstv/RadioPlayback;->access$300(Lru/oopssre/imperialschool/viewstv/RadioPlayback;)Lru/oopssre/imperialschool/viewstv/ScenePlayback$Listener;

    move-result-object v0

    invoke-interface {v0, p0, p1, p2, p3}, Lru/oopssre/imperialschool/viewstv/ScenePlayback$Listener;->event(Lru/oopssre/imperialschool/viewstv/ScenePlayback;Lru/oopssre/imperialschool/viewstv/ScenePlayback$Event;J)V

    :cond_0
    return-void
.end method

.method synthetic lambda$pause$1$ru-oopssre-imperialschool-viewstv-RadioPlayback$Session()V
    .locals 1

    .line 147
    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/RadioPlayback$Session;->this$0:Lru/oopssre/imperialschool/viewstv/RadioPlayback;

    invoke-static {v0}, Lru/oopssre/imperialschool/viewstv/RadioPlayback;->access$400(Lru/oopssre/imperialschool/viewstv/RadioPlayback;)Landroidx/media3/exoplayer/ExoPlayer;

    move-result-object v0

    invoke-interface {v0}, Landroidx/media3/exoplayer/ExoPlayer;->pause()V

    .line 148
    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/RadioPlayback$Session;->this$0:Lru/oopssre/imperialschool/viewstv/RadioPlayback;

    invoke-static {v0}, Lru/oopssre/imperialschool/viewstv/RadioPlayback;->access$400(Lru/oopssre/imperialschool/viewstv/RadioPlayback;)Landroidx/media3/exoplayer/ExoPlayer;

    move-result-object v0

    invoke-virtual {p0, v0}, Lru/oopssre/imperialschool/viewstv/RadioPlayback$Session;->report(Landroidx/media3/common/Player;)V

    return-void
.end method

.method synthetic lambda$play$0$ru-oopssre-imperialschool-viewstv-RadioPlayback$Session(J)V
    .locals 0

    .line 138
    iput-wide p1, p0, Lru/oopssre/imperialschool/viewstv/RadioPlayback$Session;->operation:J

    .line 139
    iget-object p1, p0, Lru/oopssre/imperialschool/viewstv/RadioPlayback$Session;->this$0:Lru/oopssre/imperialschool/viewstv/RadioPlayback;

    invoke-static {p1}, Lru/oopssre/imperialschool/viewstv/RadioPlayback;->access$400(Lru/oopssre/imperialschool/viewstv/RadioPlayback;)Landroidx/media3/exoplayer/ExoPlayer;

    move-result-object p1

    const/4 p2, 0x0

    invoke-interface {p1, p2}, Landroidx/media3/exoplayer/ExoPlayer;->setVolume(F)V

    .line 140
    iget-object p1, p0, Lru/oopssre/imperialschool/viewstv/RadioPlayback$Session;->this$0:Lru/oopssre/imperialschool/viewstv/RadioPlayback;

    invoke-static {p1}, Lru/oopssre/imperialschool/viewstv/RadioPlayback;->access$400(Lru/oopssre/imperialschool/viewstv/RadioPlayback;)Landroidx/media3/exoplayer/ExoPlayer;

    move-result-object p1

    invoke-interface {p1}, Landroidx/media3/exoplayer/ExoPlayer;->play()V

    .line 141
    iget-object p1, p0, Lru/oopssre/imperialschool/viewstv/RadioPlayback$Session;->this$0:Lru/oopssre/imperialschool/viewstv/RadioPlayback;

    invoke-static {p1}, Lru/oopssre/imperialschool/viewstv/RadioPlayback;->access$400(Lru/oopssre/imperialschool/viewstv/RadioPlayback;)Landroidx/media3/exoplayer/ExoPlayer;

    move-result-object p1

    invoke-virtual {p0, p1}, Lru/oopssre/imperialschool/viewstv/RadioPlayback$Session;->report(Landroidx/media3/common/Player;)V

    return-void
.end method

.method synthetic lambda$volume$2$ru-oopssre-imperialschool-viewstv-RadioPlayback$Session(F)V
    .locals 1

    .line 152
    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/RadioPlayback$Session;->this$0:Lru/oopssre/imperialschool/viewstv/RadioPlayback;

    invoke-static {v0}, Lru/oopssre/imperialschool/viewstv/RadioPlayback;->access$400(Lru/oopssre/imperialschool/viewstv/RadioPlayback;)Landroidx/media3/exoplayer/ExoPlayer;

    move-result-object v0

    invoke-interface {v0, p1}, Landroidx/media3/exoplayer/ExoPlayer;->setVolume(F)V

    return-void
.end method

.method public pause()V
    .locals 1

    .line 146
    new-instance v0, Lru/oopssre/imperialschool/viewstv/RadioPlayback$Session$$ExternalSyntheticLambda5;

    invoke-direct {v0, p0}, Lru/oopssre/imperialschool/viewstv/RadioPlayback$Session$$ExternalSyntheticLambda5;-><init>(Lru/oopssre/imperialschool/viewstv/RadioPlayback$Session;)V

    invoke-direct {p0, v0}, Lru/oopssre/imperialschool/viewstv/RadioPlayback$Session;->command(Ljava/lang/Runnable;)V

    return-void
.end method

.method public play(J)V
    .locals 1

    .line 137
    new-instance v0, Lru/oopssre/imperialschool/viewstv/RadioPlayback$Session$$ExternalSyntheticLambda1;

    invoke-direct {v0, p0, p1, p2}, Lru/oopssre/imperialschool/viewstv/RadioPlayback$Session$$ExternalSyntheticLambda1;-><init>(Lru/oopssre/imperialschool/viewstv/RadioPlayback$Session;J)V

    invoke-direct {p0, v0}, Lru/oopssre/imperialschool/viewstv/RadioPlayback$Session;->command(Ljava/lang/Runnable;)V

    return-void
.end method

.method public position()I
    .locals 1

    const/4 v0, 0x0

    return v0
.end method

.method report(Landroidx/media3/common/Player;)V
    .locals 6

    .line 110
    iget-boolean v0, p0, Lru/oopssre/imperialschool/viewstv/RadioPlayback$Session;->closed:Z

    if-nez v0, :cond_7

    iget-boolean v0, p0, Lru/oopssre/imperialschool/viewstv/RadioPlayback$Session;->terminal:Z

    if-eqz v0, :cond_0

    goto :goto_0

    .line 111
    :cond_0
    invoke-interface {p1}, Landroidx/media3/common/Player;->getPlayerError()Landroidx/media3/common/PlaybackException;

    move-result-object v0

    if-eqz v0, :cond_1

    .line 112
    invoke-interface {p1}, Landroidx/media3/common/Player;->getPlayerError()Landroidx/media3/common/PlaybackException;

    move-result-object p1

    invoke-virtual {p0, p1}, Lru/oopssre/imperialschool/viewstv/RadioPlayback$Session;->fail(Ljava/lang/Throwable;)V

    return-void

    .line 115
    :cond_1
    invoke-interface {p1}, Landroidx/media3/common/Player;->getPlaybackState()I

    move-result v0

    const/4 v1, 0x4

    const-wide/16 v2, 0x0

    const/4 v4, 0x1

    if-ne v0, v1, :cond_2

    .line 117
    iput-boolean v4, p0, Lru/oopssre/imperialschool/viewstv/RadioPlayback$Session;->terminal:Z

    .line 118
    sget-object p1, Lru/oopssre/imperialschool/viewstv/ScenePlayback$Event;->COMPLETED:Lru/oopssre/imperialschool/viewstv/ScenePlayback$Event;

    invoke-direct {p0, p1, v2, v3}, Lru/oopssre/imperialschool/viewstv/RadioPlayback$Session;->emit(Lru/oopssre/imperialschool/viewstv/ScenePlayback$Event;J)V

    return-void

    :cond_2
    const/4 v1, 0x3

    if-ne v0, v1, :cond_3

    .line 121
    iget-boolean v1, p0, Lru/oopssre/imperialschool/viewstv/RadioPlayback$Session;->prepared:Z

    if-nez v1, :cond_3

    .line 122
    iput-boolean v4, p0, Lru/oopssre/imperialschool/viewstv/RadioPlayback$Session;->prepared:Z

    .line 123
    sget-object v1, Lru/oopssre/imperialschool/viewstv/ScenePlayback$Event;->PREPARED:Lru/oopssre/imperialschool/viewstv/ScenePlayback$Event;

    invoke-direct {p0, v1, v2, v3}, Lru/oopssre/imperialschool/viewstv/RadioPlayback$Session;->emit(Lru/oopssre/imperialschool/viewstv/ScenePlayback$Event;J)V

    .line 125
    :cond_3
    invoke-interface {p1}, Landroidx/media3/common/Player;->isPlaying()Z

    move-result v1

    if-eqz v1, :cond_5

    .line 126
    iget-boolean v2, p0, Lru/oopssre/imperialschool/viewstv/RadioPlayback$Session;->playing:Z

    if-eqz v2, :cond_4

    iget-wide v2, p0, Lru/oopssre/imperialschool/viewstv/RadioPlayback$Session;->reportedOperation:J

    iget-wide v4, p0, Lru/oopssre/imperialschool/viewstv/RadioPlayback$Session;->operation:J

    cmp-long v2, v2, v4

    if-eqz v2, :cond_5

    .line 127
    :cond_4
    iget-wide v2, p0, Lru/oopssre/imperialschool/viewstv/RadioPlayback$Session;->operation:J

    iput-wide v2, p0, Lru/oopssre/imperialschool/viewstv/RadioPlayback$Session;->reportedOperation:J

    .line 128
    sget-object v2, Lru/oopssre/imperialschool/viewstv/ScenePlayback$Event;->STARTED:Lru/oopssre/imperialschool/viewstv/ScenePlayback$Event;

    iget-wide v3, p0, Lru/oopssre/imperialschool/viewstv/RadioPlayback$Session;->operation:J

    invoke-direct {p0, v2, v3, v4}, Lru/oopssre/imperialschool/viewstv/RadioPlayback$Session;->emit(Lru/oopssre/imperialschool/viewstv/ScenePlayback$Event;J)V

    :cond_5
    const/4 v2, 0x2

    if-ne v0, v2, :cond_6

    .line 130
    iget v2, p0, Lru/oopssre/imperialschool/viewstv/RadioPlayback$Session;->lastState:I

    if-eq v2, v0, :cond_6

    iget-boolean v2, p0, Lru/oopssre/imperialschool/viewstv/RadioPlayback$Session;->prepared:Z

    if-eqz v2, :cond_6

    invoke-interface {p1}, Landroidx/media3/common/Player;->getPlayWhenReady()Z

    move-result p1

    if-eqz p1, :cond_6

    .line 131
    sget-object p1, Lru/oopssre/imperialschool/viewstv/ScenePlayback$Event;->BUFFERING:Lru/oopssre/imperialschool/viewstv/ScenePlayback$Event;

    iget-wide v2, p0, Lru/oopssre/imperialschool/viewstv/RadioPlayback$Session;->operation:J

    invoke-direct {p0, p1, v2, v3}, Lru/oopssre/imperialschool/viewstv/RadioPlayback$Session;->emit(Lru/oopssre/imperialschool/viewstv/ScenePlayback$Event;J)V

    .line 132
    :cond_6
    iput-boolean v1, p0, Lru/oopssre/imperialschool/viewstv/RadioPlayback$Session;->playing:Z

    .line 133
    iput v0, p0, Lru/oopssre/imperialschool/viewstv/RadioPlayback$Session;->lastState:I

    :cond_7
    :goto_0
    return-void
.end method

.method public volume(F)V
    .locals 1

    .line 152
    new-instance v0, Lru/oopssre/imperialschool/viewstv/RadioPlayback$Session$$ExternalSyntheticLambda3;

    invoke-direct {v0, p0, p1}, Lru/oopssre/imperialschool/viewstv/RadioPlayback$Session$$ExternalSyntheticLambda3;-><init>(Lru/oopssre/imperialschool/viewstv/RadioPlayback$Session;F)V

    invoke-direct {p0, v0}, Lru/oopssre/imperialschool/viewstv/RadioPlayback$Session;->command(Ljava/lang/Runnable;)V

    return-void
.end method
