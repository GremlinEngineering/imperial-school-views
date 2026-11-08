.class Lru/oopssre/imperialschool/viewstv/SceneMusic$1;
.super Ljava/lang/Object;
.source "SceneMusic.java"

# interfaces
.implements Ljava/lang/Runnable;


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lru/oopssre/imperialschool/viewstv/SceneMusic;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic this$0:Lru/oopssre/imperialschool/viewstv/SceneMusic;


# direct methods
.method constructor <init>(Lru/oopssre/imperialschool/viewstv/SceneMusic;)V
    .locals 0
    .annotation system Ldalvik/annotation/MethodParameters;
        accessFlags = {
            0x8010
        }
        names = {
            null
        }
    .end annotation

    .line 51
    iput-object p1, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic$1;->this$0:Lru/oopssre/imperialschool/viewstv/SceneMusic;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public run()V
    .locals 5

    .line 51
    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic$1;->this$0:Lru/oopssre/imperialschool/viewstv/SceneMusic;

    iget-object v0, v0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->playerState:Lru/oopssre/imperialschool/viewstv/SceneMusic$PlayerState;

    sget-object v1, Lru/oopssre/imperialschool/viewstv/SceneMusic$PlayerState;->PLAYING:Lru/oopssre/imperialschool/viewstv/SceneMusic$PlayerState;

    if-eq v0, v1, :cond_0

    goto :goto_0

    :cond_0
    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic$1;->this$0:Lru/oopssre/imperialschool/viewstv/SceneMusic;

    invoke-virtual {v0}, Lru/oopssre/imperialschool/viewstv/SceneMusic;->level()I

    move-result v1

    int-to-float v1, v1

    const/high16 v2, 0x42c80000    # 100.0f

    div-float/2addr v1, v2

    iget-object v3, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic$1;->this$0:Lru/oopssre/imperialschool/viewstv/SceneMusic;

    iget v3, v3, Lru/oopssre/imperialschool/viewstv/SceneMusic;->gain:F

    const v4, 0x3c4ccccd    # 0.0125f

    add-float/2addr v3, v4

    invoke-static {v1, v3}, Ljava/lang/Math;->min(FF)F

    move-result v1

    iput v1, v0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->gain:F

    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic$1;->this$0:Lru/oopssre/imperialschool/viewstv/SceneMusic;

    invoke-static {v0}, Lru/oopssre/imperialschool/viewstv/SceneMusic;->access$000(Lru/oopssre/imperialschool/viewstv/SceneMusic;)V

    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic$1;->this$0:Lru/oopssre/imperialschool/viewstv/SceneMusic;

    iget v0, v0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->gain:F

    iget-object v1, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic$1;->this$0:Lru/oopssre/imperialschool/viewstv/SceneMusic;

    invoke-virtual {v1}, Lru/oopssre/imperialschool/viewstv/SceneMusic;->level()I

    move-result v1

    int-to-float v1, v1

    div-float/2addr v1, v2

    cmpg-float v0, v0, v1

    if-gez v0, :cond_1

    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/SceneMusic$1;->this$0:Lru/oopssre/imperialschool/viewstv/SceneMusic;

    iget-object v0, v0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->main:Landroid/os/Handler;

    const-wide/16 v1, 0x3c

    invoke-virtual {v0, p0, v1, v2}, Landroid/os/Handler;->postDelayed(Ljava/lang/Runnable;J)Z

    :cond_1
    :goto_0
    return-void
.end method
