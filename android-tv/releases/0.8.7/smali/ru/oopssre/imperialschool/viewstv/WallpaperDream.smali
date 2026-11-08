.class public final Lru/oopssre/imperialschool/viewstv/WallpaperDream;
.super Landroid/service/dreams/DreamService;
.source "WallpaperDream.java"

# interfaces
.implements Lru/oopssre/imperialschool/viewstv/TvScene$Host;


# instance fields
.field scene:Lru/oopssre/imperialschool/viewstv/TvScene;


# direct methods
.method public constructor <init>()V
    .locals 0

    .line 7
    invoke-direct {p0}, Landroid/service/dreams/DreamService;-><init>()V

    return-void
.end method


# virtual methods
.method public context()Landroid/content/Context;
    .locals 0

    return-object p0
.end method

.method public dispatchKeyEvent(Landroid/view/KeyEvent;)Z
    .locals 3

    .line 13
    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/WallpaperDream;->scene:Lru/oopssre/imperialschool/viewstv/TvScene;

    const/4 v1, 0x1

    if-eqz v0, :cond_0

    invoke-virtual {v0, p1}, Lru/oopssre/imperialschool/viewstv/TvScene;->handle(Landroid/view/KeyEvent;)Z

    move-result v0

    if-eqz v0, :cond_0

    return v1

    :cond_0
    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/WallpaperDream;->scene:Lru/oopssre/imperialschool/viewstv/TvScene;

    if-eqz v0, :cond_2

    iget-object v0, v0, Lru/oopssre/imperialschool/viewstv/TvScene;->panel:Landroid/widget/ScrollView;

    invoke-virtual {v0}, Landroid/widget/ScrollView;->getVisibility()I

    move-result v0

    if-eqz v0, :cond_2

    invoke-virtual {p1}, Landroid/view/KeyEvent;->getAction()I

    move-result v0

    if-nez v0, :cond_2

    invoke-virtual {p1}, Landroid/view/KeyEvent;->getKeyCode()I

    move-result v0

    const/16 v2, 0x13

    if-eq v0, v2, :cond_1

    invoke-virtual {p1}, Landroid/view/KeyEvent;->getKeyCode()I

    move-result v0

    const/16 v2, 0x14

    if-eq v0, v2, :cond_1

    invoke-virtual {p1}, Landroid/view/KeyEvent;->getKeyCode()I

    move-result v0

    const/16 v2, 0x15

    if-eq v0, v2, :cond_1

    invoke-virtual {p1}, Landroid/view/KeyEvent;->getKeyCode()I

    move-result v0

    const/16 v2, 0x16

    if-ne v0, v2, :cond_2

    :cond_1
    invoke-virtual {p0}, Lru/oopssre/imperialschool/viewstv/WallpaperDream;->finish()V

    return v1

    :cond_2
    invoke-super {p0, p1}, Landroid/service/dreams/DreamService;->dispatchKeyEvent(Landroid/view/KeyEvent;)Z

    move-result p1

    return p1
.end method

.method public launch(Landroid/content/Intent;)V
    .locals 0

    .line 14
    invoke-virtual {p0, p1}, Lru/oopssre/imperialschool/viewstv/WallpaperDream;->startActivity(Landroid/content/Intent;)V

    return-void
.end method

.method public leave()V
    .locals 0

    .line 14
    invoke-virtual {p0}, Lru/oopssre/imperialschool/viewstv/WallpaperDream;->finish()V

    return-void
.end method

.method public onAttachedToWindow()V
    .locals 1

    .line 9
    invoke-super {p0}, Landroid/service/dreams/DreamService;->onAttachedToWindow()V

    const/4 v0, 0x1

    invoke-virtual {p0, v0}, Lru/oopssre/imperialschool/viewstv/WallpaperDream;->setFullscreen(Z)V

    invoke-virtual {p0, v0}, Lru/oopssre/imperialschool/viewstv/WallpaperDream;->setInteractive(Z)V

    invoke-virtual {p0, v0}, Lru/oopssre/imperialschool/viewstv/WallpaperDream;->setScreenBright(Z)V

    new-instance v0, Lru/oopssre/imperialschool/viewstv/TvScene;

    invoke-direct {v0, p0}, Lru/oopssre/imperialschool/viewstv/TvScene;-><init>(Lru/oopssre/imperialschool/viewstv/TvScene$Host;)V

    iput-object v0, p0, Lru/oopssre/imperialschool/viewstv/WallpaperDream;->scene:Lru/oopssre/imperialschool/viewstv/TvScene;

    iget-object v0, v0, Lru/oopssre/imperialschool/viewstv/TvScene;->root:Landroid/widget/FrameLayout;

    invoke-virtual {p0, v0}, Lru/oopssre/imperialschool/viewstv/WallpaperDream;->setContentView(Landroid/view/View;)V

    return-void
.end method

.method public onDetachedFromWindow()V
    .locals 1

    .line 12
    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/WallpaperDream;->scene:Lru/oopssre/imperialschool/viewstv/TvScene;

    if-eqz v0, :cond_0

    invoke-virtual {v0}, Lru/oopssre/imperialschool/viewstv/TvScene;->destroy()V

    const/4 v0, 0x0

    iput-object v0, p0, Lru/oopssre/imperialschool/viewstv/WallpaperDream;->scene:Lru/oopssre/imperialschool/viewstv/TvScene;

    :cond_0
    invoke-super {p0}, Landroid/service/dreams/DreamService;->onDetachedFromWindow()V

    return-void
.end method

.method public onDreamingStarted()V
    .locals 1

    .line 10
    invoke-super {p0}, Landroid/service/dreams/DreamService;->onDreamingStarted()V

    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/WallpaperDream;->scene:Lru/oopssre/imperialschool/viewstv/TvScene;

    if-eqz v0, :cond_0

    invoke-virtual {v0}, Lru/oopssre/imperialschool/viewstv/TvScene;->start()V

    :cond_0
    return-void
.end method

.method public onDreamingStopped()V
    .locals 1

    .line 11
    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/WallpaperDream;->scene:Lru/oopssre/imperialschool/viewstv/TvScene;

    if-eqz v0, :cond_0

    invoke-virtual {v0}, Lru/oopssre/imperialschool/viewstv/TvScene;->stop()V

    :cond_0
    invoke-super {p0}, Landroid/service/dreams/DreamService;->onDreamingStopped()V

    return-void
.end method

.method public window()Landroid/view/Window;
    .locals 1

    .line 14
    invoke-virtual {p0}, Lru/oopssre/imperialschool/viewstv/WallpaperDream;->getWindow()Landroid/view/Window;

    move-result-object v0

    return-object v0
.end method
