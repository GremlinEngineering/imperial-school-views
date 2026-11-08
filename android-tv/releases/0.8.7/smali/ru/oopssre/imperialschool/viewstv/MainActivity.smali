.class public final Lru/oopssre/imperialschool/viewstv/MainActivity;
.super Landroid/app/Activity;
.source "MainActivity.java"

# interfaces
.implements Lru/oopssre/imperialschool/viewstv/TvScene$Host;


# instance fields
.field scene:Lru/oopssre/imperialschool/viewstv/TvScene;


# direct methods
.method public constructor <init>()V
    .locals 0

    .line 8
    invoke-direct {p0}, Landroid/app/Activity;-><init>()V

    return-void
.end method


# virtual methods
.method public context()Landroid/content/Context;
    .locals 0

    return-object p0
.end method

.method public dispatchKeyEvent(Landroid/view/KeyEvent;)Z
    .locals 1

    .line 16
    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/MainActivity;->scene:Lru/oopssre/imperialschool/viewstv/TvScene;

    if-eqz v0, :cond_0

    invoke-virtual {v0, p1}, Lru/oopssre/imperialschool/viewstv/TvScene;->handle(Landroid/view/KeyEvent;)Z

    move-result v0

    if-nez v0, :cond_1

    :cond_0
    invoke-super {p0, p1}, Landroid/app/Activity;->dispatchKeyEvent(Landroid/view/KeyEvent;)Z

    move-result p1

    if-eqz p1, :cond_2

    :cond_1
    const/4 p1, 0x1

    return p1

    :cond_2
    const/4 p1, 0x0

    return p1
.end method

.method public launch(Landroid/content/Intent;)V
    .locals 0

    .line 18
    invoke-virtual {p0, p1}, Lru/oopssre/imperialschool/viewstv/MainActivity;->startActivity(Landroid/content/Intent;)V

    return-void
.end method

.method public leave()V
    .locals 0

    .line 18
    invoke-virtual {p0}, Lru/oopssre/imperialschool/viewstv/MainActivity;->finish()V

    return-void
.end method

.method public onBackPressed()V
    .locals 1

    .line 17
    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/MainActivity;->scene:Lru/oopssre/imperialschool/viewstv/TvScene;

    if-eqz v0, :cond_0

    invoke-virtual {v0}, Lru/oopssre/imperialschool/viewstv/TvScene;->back()V

    return-void

    :cond_0
    invoke-super {p0}, Landroid/app/Activity;->onBackPressed()V

    return-void
.end method

.method public onCreate(Landroid/os/Bundle;)V
    .locals 1

    .line 10
    invoke-super {p0, p1}, Landroid/app/Activity;->onCreate(Landroid/os/Bundle;)V

    invoke-virtual {p0}, Lru/oopssre/imperialschool/viewstv/MainActivity;->getWindow()Landroid/view/Window;

    move-result-object p1

    const/16 v0, 0x480

    invoke-virtual {p1, v0}, Landroid/view/Window;->addFlags(I)V

    invoke-virtual {p0}, Lru/oopssre/imperialschool/viewstv/MainActivity;->getWindow()Landroid/view/Window;

    move-result-object p1

    invoke-virtual {p1}, Landroid/view/Window;->getDecorView()Landroid/view/View;

    move-result-object p1

    const/16 v0, 0x1706

    invoke-virtual {p1, v0}, Landroid/view/View;->setSystemUiVisibility(I)V

    new-instance p1, Lru/oopssre/imperialschool/viewstv/TvScene;

    invoke-direct {p1, p0}, Lru/oopssre/imperialschool/viewstv/TvScene;-><init>(Lru/oopssre/imperialschool/viewstv/TvScene$Host;)V

    iput-object p1, p0, Lru/oopssre/imperialschool/viewstv/MainActivity;->scene:Lru/oopssre/imperialschool/viewstv/TvScene;

    iget-object p1, p1, Lru/oopssre/imperialschool/viewstv/TvScene;->root:Landroid/widget/FrameLayout;

    invoke-virtual {p0, p1}, Lru/oopssre/imperialschool/viewstv/MainActivity;->setContentView(Landroid/view/View;)V

    return-void
.end method

.method protected onDestroy()V
    .locals 1

    .line 15
    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/MainActivity;->scene:Lru/oopssre/imperialschool/viewstv/TvScene;

    invoke-virtual {v0}, Lru/oopssre/imperialschool/viewstv/TvScene;->destroy()V

    invoke-super {p0}, Landroid/app/Activity;->onDestroy()V

    return-void
.end method

.method protected onPause()V
    .locals 1

    .line 13
    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/MainActivity;->scene:Lru/oopssre/imperialschool/viewstv/TvScene;

    if-eqz v0, :cond_0

    invoke-virtual {v0}, Lru/oopssre/imperialschool/viewstv/TvScene;->pausePlayback()V

    :cond_0
    invoke-super {p0}, Landroid/app/Activity;->onPause()V

    return-void
.end method

.method protected onResume()V
    .locals 1

    .line 12
    invoke-super {p0}, Landroid/app/Activity;->onResume()V

    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/MainActivity;->scene:Lru/oopssre/imperialschool/viewstv/TvScene;

    if-eqz v0, :cond_0

    iget-boolean v0, v0, Lru/oopssre/imperialschool/viewstv/TvScene;->active:Z

    if-eqz v0, :cond_0

    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/MainActivity;->scene:Lru/oopssre/imperialschool/viewstv/TvScene;

    invoke-virtual {v0}, Lru/oopssre/imperialschool/viewstv/TvScene;->resumePlayback()V

    :cond_0
    return-void
.end method

.method protected onStart()V
    .locals 1

    .line 11
    invoke-super {p0}, Landroid/app/Activity;->onStart()V

    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/MainActivity;->scene:Lru/oopssre/imperialschool/viewstv/TvScene;

    invoke-virtual {v0}, Lru/oopssre/imperialschool/viewstv/TvScene;->start()V

    return-void
.end method

.method protected onStop()V
    .locals 1

    .line 14
    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/MainActivity;->scene:Lru/oopssre/imperialschool/viewstv/TvScene;

    invoke-virtual {v0}, Lru/oopssre/imperialschool/viewstv/TvScene;->stop()V

    invoke-super {p0}, Landroid/app/Activity;->onStop()V

    return-void
.end method

.method public window()Landroid/view/Window;
    .locals 1

    .line 18
    invoke-virtual {p0}, Lru/oopssre/imperialschool/viewstv/MainActivity;->getWindow()Landroid/view/Window;

    move-result-object v0

    return-object v0
.end method
