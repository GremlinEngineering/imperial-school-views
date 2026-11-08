.class Lru/oopssre/imperialschool/viewstv/TvScene$1;
.super Ljava/lang/Object;
.source "TvScene.java"

# interfaces
.implements Landroid/hardware/display/DisplayManager$DisplayListener;


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lru/oopssre/imperialschool/viewstv/TvScene;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic this$0:Lru/oopssre/imperialschool/viewstv/TvScene;


# direct methods
.method constructor <init>(Lru/oopssre/imperialschool/viewstv/TvScene;)V
    .locals 0
    .annotation system Ldalvik/annotation/MethodParameters;
        accessFlags = {
            0x8010
        }
        names = {
            null
        }
    .end annotation

    .line 37
    iput-object p1, p0, Lru/oopssre/imperialschool/viewstv/TvScene$1;->this$0:Lru/oopssre/imperialschool/viewstv/TvScene;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public onDisplayAdded(I)V
    .locals 1

    .line 38
    iget-object p1, p0, Lru/oopssre/imperialschool/viewstv/TvScene$1;->this$0:Lru/oopssre/imperialschool/viewstv/TvScene;

    iget-boolean p1, p1, Lru/oopssre/imperialschool/viewstv/TvScene;->active:Z

    if-eqz p1, :cond_0

    iget-object p1, p0, Lru/oopssre/imperialschool/viewstv/TvScene$1;->this$0:Lru/oopssre/imperialschool/viewstv/TvScene;

    const/4 v0, 0x1

    invoke-virtual {p1, v0}, Lru/oopssre/imperialschool/viewstv/TvScene;->refreshResolution(Z)V

    :cond_0
    return-void
.end method

.method public onDisplayChanged(I)V
    .locals 1

    .line 40
    iget-object p1, p0, Lru/oopssre/imperialschool/viewstv/TvScene$1;->this$0:Lru/oopssre/imperialschool/viewstv/TvScene;

    iget-boolean p1, p1, Lru/oopssre/imperialschool/viewstv/TvScene;->active:Z

    if-eqz p1, :cond_0

    iget-object p1, p0, Lru/oopssre/imperialschool/viewstv/TvScene$1;->this$0:Lru/oopssre/imperialschool/viewstv/TvScene;

    const/4 v0, 0x1

    invoke-virtual {p1, v0}, Lru/oopssre/imperialschool/viewstv/TvScene;->refreshResolution(Z)V

    :cond_0
    return-void
.end method

.method public onDisplayRemoved(I)V
    .locals 1

    .line 39
    iget-object p1, p0, Lru/oopssre/imperialschool/viewstv/TvScene$1;->this$0:Lru/oopssre/imperialschool/viewstv/TvScene;

    iget-boolean p1, p1, Lru/oopssre/imperialschool/viewstv/TvScene;->active:Z

    if-eqz p1, :cond_0

    iget-object p1, p0, Lru/oopssre/imperialschool/viewstv/TvScene$1;->this$0:Lru/oopssre/imperialschool/viewstv/TvScene;

    const/4 v0, 0x1

    invoke-virtual {p1, v0}, Lru/oopssre/imperialschool/viewstv/TvScene;->refreshResolution(Z)V

    :cond_0
    return-void
.end method
