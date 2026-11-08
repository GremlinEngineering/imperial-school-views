.class final Lru/oopssre/imperialschool/viewstv/TvScene;
.super Ljava/lang/Object;
.source "TvScene.java"

# interfaces
.implements Lru/oopssre/imperialschool/viewstv/SceneController$Listener;


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lru/oopssre/imperialschool/viewstv/TvScene$Host;
    }
.end annotation


# instance fields
.field active:Z

.field private exitBackUntil:J

.field cacheBusy:Z

.field cacheDetails:Landroid/widget/TextView;

.field cacheStatus:Ljava/lang/String;

.field capabilityGeneration:J

.field capabilityJob:Ljava/util/concurrent/Future;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/concurrent/Future<",
            "*>;"
        }
    .end annotation
.end field

.field content:Landroid/widget/LinearLayout;

.field final context:Landroid/content/Context;

.field final controller:Lru/oopssre/imperialschool/viewstv/SceneController;

.field creditDetail:Ljava/lang/String;

.field destroyed:Z

.field details:Landroid/widget/TextView;

.field detectedSize:[I

.field diagnosticDetails:Landroid/widget/TextView;

.field final displayListener:Landroid/hardware/display/DisplayManager$DisplayListener;

.field displayManager:Landroid/hardware/display/DisplayManager;

.field final focusMemory:Ljava/util/Map;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/Map<",
            "Ljava/lang/String;",
            "Ljava/lang/String;",
            ">;"
        }
    .end annotation
.end field

.field gallery:Lru/oopssre/imperialschool/viewstv/ThemeGallery;

.field final handler:Landroid/os/Handler;

.field final held:Ljava/lang/Runnable;

.field hint:Landroid/widget/TextView;

.field final hold:Lru/oopssre/imperialschool/viewstv/HoldGate;

.field final host:Lru/oopssre/imperialschool/viewstv/TvScene$Host;

.field final music:Lru/oopssre/imperialschool/viewstv/SceneMusic;

.field musicCheck:Landroid/widget/Button;

.field musicCheckDetails:Landroid/widget/TextView;

.field musicDetails:Landroid/widget/TextView;

.field musicSaverToggle:Landroid/widget/Button;

.field musicToggle:Landroid/widget/Button;

.field nextTrack:Landroid/widget/Button;

.field page:Ljava/lang/String;

.field panel:Landroid/widget/ScrollView;

.field pendingInstall:Z

.field placeholder:Landroid/widget/TextView;

.field final previewWorker:Ljava/util/concurrent/ExecutorService;

.field previousTrack:Landroid/widget/Button;

.field projectCode:Z

.field projectReturn:Ljava/lang/String;

.field ready:Lru/oopssre/imperialschool/viewstv/Release;

.field final repo:Lru/oopssre/imperialschool/viewstv/Repository;

.field final root:Landroid/widget/FrameLayout;

.field final scrollMemory:Ljava/util/Map;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/Map<",
            "Ljava/lang/String;",
            "Ljava/lang/Integer;",
            ">;"
        }
    .end annotation
.end field

.field status:Ljava/lang/String;

.field final surface:Lru/oopssre/imperialschool/viewstv/WallpaperSurface;

.field updateBusy:Z

.field updateGeneration:J

.field updateJob:Ljava/util/concurrent/Future;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/concurrent/Future<",
            "*>;"
        }
    .end annotation
.end field

.field updateStatus:Ljava/lang/String;

.field final updateWorker:Ljava/util/concurrent/ExecutorService;

.field final updater:Lru/oopssre/imperialschool/viewstv/Updater;

.field final video:Lru/oopssre/imperialschool/viewstv/VideoSurface;

.field final videoController:Lru/oopssre/imperialschool/viewstv/VideoController;

.field volumeControl:Landroid/widget/Button;


# direct methods
.method constructor <init>(Lru/oopssre/imperialschool/viewstv/TvScene$Host;)V
    .locals 14

    .line 42
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 22
    new-instance v0, Landroid/os/Handler;

    invoke-static {}, Landroid/os/Looper;->getMainLooper()Landroid/os/Looper;

    move-result-object v1

    invoke-direct {v0, v1}, Landroid/os/Handler;-><init>(Landroid/os/Looper;)V

    iput-object v0, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->handler:Landroid/os/Handler;

    new-instance v0, Lru/oopssre/imperialschool/viewstv/HoldGate;

    invoke-direct {v0}, Lru/oopssre/imperialschool/viewstv/HoldGate;-><init>()V

    iput-object v0, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->hold:Lru/oopssre/imperialschool/viewstv/HoldGate;

    .line 23
    invoke-static {}, Ljava/util/concurrent/Executors;->newSingleThreadExecutor()Ljava/util/concurrent/ExecutorService;

    move-result-object v0

    iput-object v0, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->updateWorker:Ljava/util/concurrent/ExecutorService;

    .line 24
    invoke-static {}, Ljava/util/concurrent/Executors;->newSingleThreadExecutor()Ljava/util/concurrent/ExecutorService;

    move-result-object v0

    iput-object v0, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->previewWorker:Ljava/util/concurrent/ExecutorService;

    .line 25
    new-instance v0, Ljava/util/HashMap;

    invoke-direct {v0}, Ljava/util/HashMap;-><init>()V

    iput-object v0, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->focusMemory:Ljava/util/Map;

    new-instance v0, Ljava/util/HashMap;

    invoke-direct {v0}, Ljava/util/HashMap;-><init>()V

    iput-object v0, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->scrollMemory:Ljava/util/Map;

    .line 31
    const-string v0, ""

    iput-object v0, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->creditDetail:Ljava/lang/String;

    const-string v1, "info"

    iput-object v1, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->projectReturn:Ljava/lang/String;

    .line 33
    const-string v1, "\u0421\u043e\u0435\u0434\u0438\u043d\u044f\u044e\u0441\u044c \u0441 \u0441\u0435\u0440\u0432\u0435\u0440\u043e\u043c\u2026"

    iput-object v1, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->status:Ljava/lang/String;

    const-string v1, "menu"

    iput-object v1, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->page:Ljava/lang/String;

    iput-object v0, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->updateStatus:Ljava/lang/String;

    iput-object v0, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->cacheStatus:Ljava/lang/String;

    .line 35
    new-instance v0, Lru/oopssre/imperialschool/viewstv/TvScene$$ExternalSyntheticLambda0;

    invoke-direct {v0, p0}, Lru/oopssre/imperialschool/viewstv/TvScene$$ExternalSyntheticLambda0;-><init>(Lru/oopssre/imperialschool/viewstv/TvScene;)V

    iput-object v0, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->held:Ljava/lang/Runnable;

    const/16 v0, 0x780

    const/16 v1, 0x438

    .line 36
    filled-new-array {v0, v1}, [I

    move-result-object v0

    iput-object v0, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->detectedSize:[I

    .line 37
    new-instance v0, Lru/oopssre/imperialschool/viewstv/TvScene$1;

    invoke-direct {v0, p0}, Lru/oopssre/imperialschool/viewstv/TvScene$1;-><init>(Lru/oopssre/imperialschool/viewstv/TvScene;)V

    iput-object v0, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->displayListener:Landroid/hardware/display/DisplayManager$DisplayListener;

    .line 43
    iput-object p1, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->host:Lru/oopssre/imperialschool/viewstv/TvScene$Host;

    invoke-interface {p1}, Lru/oopssre/imperialschool/viewstv/TvScene$Host;->context()Landroid/content/Context;

    move-result-object v0

    iput-object v0, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->context:Landroid/content/Context;

    new-instance v1, Lru/oopssre/imperialschool/viewstv/Repository;

    invoke-direct {v1, v0}, Lru/oopssre/imperialschool/viewstv/Repository;-><init>(Landroid/content/Context;)V

    iput-object v1, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->repo:Lru/oopssre/imperialschool/viewstv/Repository;

    new-instance v2, Lru/oopssre/imperialschool/viewstv/Updater;

    invoke-direct {v2, v1}, Lru/oopssre/imperialschool/viewstv/Updater;-><init>(Lru/oopssre/imperialschool/viewstv/Repository;)V

    iput-object v2, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->updater:Lru/oopssre/imperialschool/viewstv/Updater;

    .line 44
    new-instance v2, Landroid/widget/FrameLayout;

    invoke-direct {v2, v0}, Landroid/widget/FrameLayout;-><init>(Landroid/content/Context;)V

    iput-object v2, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->root:Landroid/widget/FrameLayout;

    const/high16 v3, -0x1000000

    invoke-virtual {v2, v3}, Landroid/widget/FrameLayout;->setBackgroundColor(I)V

    .line 45
    invoke-interface {p1}, Lru/oopssre/imperialschool/viewstv/TvScene$Host;->window()Landroid/view/Window;

    move-result-object v3

    invoke-virtual {v3}, Landroid/view/Window;->getWindowManager()Landroid/view/WindowManager;

    move-result-object v3

    invoke-interface {v3}, Landroid/view/WindowManager;->getDefaultDisplay()Landroid/view/Display;

    move-result-object v3

    invoke-static {v3}, Lru/oopssre/imperialschool/viewstv/WallpaperSurface;->physicalSize(Landroid/view/Display;)[I

    move-result-object v3

    iput-object v3, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->detectedSize:[I

    .line 46
    invoke-virtual {p0}, Lru/oopssre/imperialschool/viewstv/TvScene;->configuredSize()[I

    move-result-object v3

    new-instance v4, Lru/oopssre/imperialschool/viewstv/WallpaperSurface;

    invoke-direct {v4, v0}, Lru/oopssre/imperialschool/viewstv/WallpaperSurface;-><init>(Landroid/content/Context;)V

    iput-object v4, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->surface:Lru/oopssre/imperialschool/viewstv/WallpaperSurface;

    const/4 v5, 0x0

    aget v6, v3, v5

    const/4 v7, 0x1

    aget v8, v3, v7

    invoke-virtual {v4, v6, v8}, Lru/oopssre/imperialschool/viewstv/WallpaperSurface;->size(II)V

    .line 47
    aget v6, v3, v5

    aget v3, v3, v7

    invoke-virtual {v1, v6, v3}, Lru/oopssre/imperialschool/viewstv/Repository;->displaySize(II)V

    invoke-virtual {v1}, Lru/oopssre/imperialschool/viewstv/Repository;->fill()Z

    move-result v3

    iput-boolean v3, v4, Lru/oopssre/imperialschool/viewstv/WallpaperSurface;->fill:Z

    new-instance v3, Landroid/widget/FrameLayout$LayoutParams;

    const/4 v6, -0x1

    invoke-direct {v3, v6, v6}, Landroid/widget/FrameLayout$LayoutParams;-><init>(II)V

    invoke-virtual {v2, v4, v3}, Landroid/widget/FrameLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    .line 48
    new-instance v3, Lru/oopssre/imperialschool/viewstv/VideoSurface;

    new-instance v8, Lru/oopssre/imperialschool/viewstv/TvScene$$ExternalSyntheticLambda11;

    invoke-direct {v8, p0}, Lru/oopssre/imperialschool/viewstv/TvScene$$ExternalSyntheticLambda11;-><init>(Lru/oopssre/imperialschool/viewstv/TvScene;)V

    invoke-direct {v3, v0, v8}, Lru/oopssre/imperialschool/viewstv/VideoSurface;-><init>(Landroid/content/Context;Lru/oopssre/imperialschool/viewstv/VideoSurface$Listener;)V

    iput-object v3, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->video:Lru/oopssre/imperialschool/viewstv/VideoSurface;

    iget-object v8, v1, Lru/oopssre/imperialschool/viewstv/Repository;->prefs:Landroid/content/SharedPreferences;

    const-string v9, "video_fill"

    invoke-interface {v8, v9, v7}, Landroid/content/SharedPreferences;->getBoolean(Ljava/lang/String;Z)Z

    move-result v8

    iput-boolean v8, v3, Lru/oopssre/imperialschool/viewstv/VideoSurface;->fill:Z

    .line 49
    invoke-virtual {p0}, Lru/oopssre/imperialschool/viewstv/TvScene;->videoEnabled()Z

    move-result v8

    const/16 v9, 0x8

    if-eqz v8, :cond_0

    move v8, v5

    goto :goto_0

    :cond_0
    move v8, v9

    :goto_0
    invoke-virtual {v3, v8}, Lru/oopssre/imperialschool/viewstv/VideoSurface;->setVisibility(I)V

    invoke-virtual {p0}, Lru/oopssre/imperialschool/viewstv/TvScene;->videoEnabled()Z

    move-result v8

    if-eqz v8, :cond_1

    move v8, v9

    goto :goto_1

    :cond_1
    move v8, v5

    :goto_1
    invoke-virtual {v4, v8}, Lru/oopssre/imperialschool/viewstv/WallpaperSurface;->setVisibility(I)V

    .line 50
    new-instance v8, Landroid/widget/FrameLayout$LayoutParams;

    invoke-direct {v8, v6, v6}, Landroid/widget/FrameLayout$LayoutParams;-><init>(II)V

    invoke-virtual {v2, v3, v8}, Landroid/widget/FrameLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    .line 51
    new-instance v8, Ljava/lang/StringBuilder;

    invoke-direct {v8}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v1}, Lru/oopssre/imperialschool/viewstv/Repository;->selected()Lru/oopssre/imperialschool/viewstv/Protocol$Theme;

    move-result-object v10

    invoke-static {v10}, Lru/oopssre/imperialschool/viewstv/ThemeText;->title(Lru/oopssre/imperialschool/viewstv/Protocol$Theme;)Ljava/lang/String;

    move-result-object v10

    invoke-virtual {v8, v10}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v8

    const-string v10, "\n\u0417\u0430\u0433\u0440\u0443\u0436\u0430\u044e \u043e\u0431\u043e\u0438\u2026"

    invoke-virtual {v8, v10}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v8

    invoke-virtual {v8}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v8

    const/16 v10, 0x17

    invoke-virtual {p0, v8, v10}, Lru/oopssre/imperialschool/viewstv/TvScene;->text(Ljava/lang/String;I)Landroid/widget/TextView;

    move-result-object v8

    iput-object v8, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->placeholder:Landroid/widget/TextView;

    const/16 v10, 0x11

    invoke-virtual {v8, v10}, Landroid/widget/TextView;->setGravity(I)V

    iget-object v8, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->placeholder:Landroid/widget/TextView;

    const v11, -0x33f5f6e9    # -3.618518E7f

    invoke-virtual {v8, v11}, Landroid/widget/TextView;->setBackgroundColor(I)V

    .line 52
    iget-object v8, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->placeholder:Landroid/widget/TextView;

    const/16 v11, 0x30

    invoke-virtual {p0, v11}, Lru/oopssre/imperialschool/viewstv/TvScene;->dp(I)I

    move-result v12

    invoke-virtual {p0, v11}, Lru/oopssre/imperialschool/viewstv/TvScene;->dp(I)I

    move-result v13

    invoke-virtual {v8, v12, v5, v13, v5}, Landroid/widget/TextView;->setPadding(IIII)V

    iget-object v5, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->placeholder:Landroid/widget/TextView;

    new-instance v8, Landroid/widget/FrameLayout$LayoutParams;

    invoke-direct {v8, v6, v6}, Landroid/widget/FrameLayout$LayoutParams;-><init>(II)V

    invoke-virtual {v2, v5, v8}, Landroid/widget/FrameLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    .line 53
    const-string v5, "\u0423\u0434\u0435\u0440\u0436\u0438\u0432\u0430\u0439\u0442\u0435 OK \u2014 \u043c\u0435\u043d\u044e"

    const/16 v8, 0x12

    invoke-virtual {p0, v5, v8}, Lru/oopssre/imperialschool/viewstv/TvScene;->text(Ljava/lang/String;I)Landroid/widget/TextView;

    move-result-object v5

    iput-object v5, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->hint:Landroid/widget/TextView;

    invoke-virtual {v5, v10}, Landroid/widget/TextView;->setGravity(I)V

    iget-object v5, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->hint:Landroid/widget/TextView;

    invoke-virtual {p0, v8}, Lru/oopssre/imperialschool/viewstv/TvScene;->dp(I)I

    move-result v10

    const/16 v12, 0xa

    invoke-virtual {p0, v12}, Lru/oopssre/imperialschool/viewstv/TvScene;->dp(I)I

    move-result v13

    invoke-virtual {p0, v8}, Lru/oopssre/imperialschool/viewstv/TvScene;->dp(I)I

    move-result v8

    invoke-virtual {p0, v12}, Lru/oopssre/imperialschool/viewstv/TvScene;->dp(I)I

    move-result v12

    invoke-virtual {v5, v10, v13, v8, v12}, Landroid/widget/TextView;->setPadding(IIII)V

    iget-object v5, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->hint:Landroid/widget/TextView;

    const v8, -0xddee4c8

    invoke-virtual {v5, v8}, Landroid/widget/TextView;->setBackgroundColor(I)V

    .line 54
    new-instance v5, Landroid/widget/FrameLayout$LayoutParams;

    const/16 v8, 0x51

    const/4 v10, -0x2

    invoke-direct {v5, v10, v10, v8}, Landroid/widget/FrameLayout$LayoutParams;-><init>(III)V

    const/16 v8, 0x20

    invoke-virtual {p0, v8}, Lru/oopssre/imperialschool/viewstv/TvScene;->dp(I)I

    move-result v8

    iput v8, v5, Landroid/widget/FrameLayout$LayoutParams;->bottomMargin:I

    iget-object v8, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->hint:Landroid/widget/TextView;

    invoke-virtual {v2, v8, v5}, Landroid/widget/FrameLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    .line 55
    new-instance v5, Landroid/widget/ScrollView;

    invoke-direct {v5, v0}, Landroid/widget/ScrollView;-><init>(Landroid/content/Context;)V

    iput-object v5, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->panel:Landroid/widget/ScrollView;

    invoke-virtual {v5, v7}, Landroid/widget/ScrollView;->setFillViewport(Z)V

    iget-object v5, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->panel:Landroid/widget/ScrollView;

    const v8, -0xebeeda

    invoke-virtual {v5, v8}, Landroid/widget/ScrollView;->setBackgroundColor(I)V

    iget-object v5, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->panel:Landroid/widget/ScrollView;

    invoke-virtual {v5, v9}, Landroid/widget/ScrollView;->setVisibility(I)V

    .line 56
    new-instance v5, Landroid/widget/FrameLayout$LayoutParams;

    const/16 v8, 0x1e0

    invoke-virtual {p0, v8}, Lru/oopssre/imperialschool/viewstv/TvScene;->dp(I)I

    move-result v8

    invoke-virtual {v0}, Landroid/content/Context;->getResources()Landroid/content/res/Resources;

    move-result-object v9

    invoke-virtual {v9}, Landroid/content/res/Resources;->getDisplayMetrics()Landroid/util/DisplayMetrics;

    move-result-object v9

    iget v9, v9, Landroid/util/DisplayMetrics;->widthPixels:I

    mul-int/lit8 v9, v9, 0x3

    const/4 v12, 0x5

    div-int/2addr v9, v12

    invoke-static {v8, v9}, Ljava/lang/Math;->min(II)I

    move-result v8

    invoke-direct {v5, v8, v6, v12}, Landroid/widget/FrameLayout$LayoutParams;-><init>(III)V

    invoke-virtual {p0, v11}, Lru/oopssre/imperialschool/viewstv/TvScene;->dp(I)I

    move-result v8

    iput v8, v5, Landroid/widget/FrameLayout$LayoutParams;->rightMargin:I

    const/16 v8, 0x1b

    invoke-virtual {p0, v8}, Lru/oopssre/imperialschool/viewstv/TvScene;->dp(I)I

    move-result v9

    iput v9, v5, Landroid/widget/FrameLayout$LayoutParams;->topMargin:I

    invoke-virtual {p0, v8}, Lru/oopssre/imperialschool/viewstv/TvScene;->dp(I)I

    move-result v8

    iput v8, v5, Landroid/widget/FrameLayout$LayoutParams;->bottomMargin:I

    iget-object v8, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->panel:Landroid/widget/ScrollView;

    invoke-virtual {v2, v8, v5}, Landroid/widget/FrameLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    .line 57
    new-instance v2, Landroid/widget/LinearLayout;

    invoke-direct {v2, v0}, Landroid/widget/LinearLayout;-><init>(Landroid/content/Context;)V

    iput-object v2, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->content:Landroid/widget/LinearLayout;

    invoke-virtual {v2, v7}, Landroid/widget/LinearLayout;->setOrientation(I)V

    iget-object v2, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->content:Landroid/widget/LinearLayout;

    const/16 v5, 0x1c

    invoke-virtual {p0, v5}, Lru/oopssre/imperialschool/viewstv/TvScene;->dp(I)I

    move-result v7

    const/16 v8, 0x18

    invoke-virtual {p0, v8}, Lru/oopssre/imperialschool/viewstv/TvScene;->dp(I)I

    move-result v9

    invoke-virtual {p0, v5}, Lru/oopssre/imperialschool/viewstv/TvScene;->dp(I)I

    move-result v5

    invoke-virtual {p0, v8}, Lru/oopssre/imperialschool/viewstv/TvScene;->dp(I)I

    move-result v8

    invoke-virtual {v2, v7, v9, v5, v8}, Landroid/widget/LinearLayout;->setPadding(IIII)V

    iget-object v2, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->panel:Landroid/widget/ScrollView;

    iget-object v5, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->content:Landroid/widget/LinearLayout;

    new-instance v7, Landroid/widget/FrameLayout$LayoutParams;

    invoke-direct {v7, v6, v10}, Landroid/widget/FrameLayout$LayoutParams;-><init>(II)V

    invoke-virtual {v2, v5, v7}, Landroid/widget/ScrollView;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    .line 58
    new-instance v2, Lru/oopssre/imperialschool/viewstv/SceneController;

    invoke-direct {v2, v1, v4, p0}, Lru/oopssre/imperialschool/viewstv/SceneController;-><init>(Lru/oopssre/imperialschool/viewstv/Repository;Lru/oopssre/imperialschool/viewstv/WallpaperSurface;Lru/oopssre/imperialschool/viewstv/SceneController$Listener;)V

    iput-object v2, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->controller:Lru/oopssre/imperialschool/viewstv/SceneController;

    .line 59
    new-instance v2, Lru/oopssre/imperialschool/viewstv/SceneMusic;

    invoke-interface {p1}, Lru/oopssre/imperialschool/viewstv/TvScene$Host;->context()Landroid/content/Context;

    move-result-object p1

    instance-of p1, p1, Landroid/service/dreams/DreamService;

    new-instance v4, Lru/oopssre/imperialschool/viewstv/TvScene$$ExternalSyntheticLambda22;

    invoke-direct {v4, p0}, Lru/oopssre/imperialschool/viewstv/TvScene$$ExternalSyntheticLambda22;-><init>(Lru/oopssre/imperialschool/viewstv/TvScene;)V

    invoke-direct {v2, v0, v1, p1, v4}, Lru/oopssre/imperialschool/viewstv/SceneMusic;-><init>(Landroid/content/Context;Lru/oopssre/imperialschool/viewstv/Repository;ZLru/oopssre/imperialschool/viewstv/SceneMusic$Listener;)V

    iput-object v2, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->music:Lru/oopssre/imperialschool/viewstv/SceneMusic;

    .line 60
    new-instance p1, Lru/oopssre/imperialschool/viewstv/VideoController;

    new-instance v0, Lru/oopssre/imperialschool/viewstv/TvScene$2;

    invoke-direct {v0, p0}, Lru/oopssre/imperialschool/viewstv/TvScene$2;-><init>(Lru/oopssre/imperialschool/viewstv/TvScene;)V

    invoke-direct {p1, v1, v3, v0}, Lru/oopssre/imperialschool/viewstv/VideoController;-><init>(Lru/oopssre/imperialschool/viewstv/Repository;Lru/oopssre/imperialschool/viewstv/VideoSurface;Lru/oopssre/imperialschool/viewstv/VideoController$Listener;)V

    iput-object p1, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->videoController:Lru/oopssre/imperialschool/viewstv/VideoController;

    return-void
.end method

.method static synthetic lambda$clearCache$29()V
    .locals 0

    return-void
.end method

.method static synthetic lambda$clearCache$30()V
    .locals 0

    return-void
.end method

.method static synthetic lambda$clearCache$31()V
    .locals 0

    return-void
.end method

.method static synthetic lambda$clearCache$32()V
    .locals 0

    return-void
.end method

.method static synthetic lambda$clearCache$33()V
    .locals 0

    return-void
.end method

.method static synthetic lambda$makeButton$1(Ljava/lang/Runnable;Landroid/view/View;)V
    .locals 0

    .line 71
    invoke-interface {p0}, Ljava/lang/Runnable;->run()V

    return-void
.end method


# virtual methods
.method activeScroll()Landroid/widget/ScrollView;
    .locals 1

    .line 76
    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->gallery:Lru/oopssre/imperialschool/viewstv/ThemeGallery;

    if-nez v0, :cond_0

    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->panel:Landroid/widget/ScrollView;

    return-object v0

    :cond_0
    iget-object v0, v0, Lru/oopssre/imperialschool/viewstv/ThemeGallery;->list:Landroid/widget/ScrollView;

    return-object v0
.end method

.method back()V
    .locals 2

    .line 134
    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->panel:Landroid/widget/ScrollView;

    invoke-virtual {v0}, Landroid/widget/ScrollView;->getVisibility()I

    move-result v0

    if-eqz v0, :cond_0

    invoke-direct {p0}, Lru/oopssre/imperialschool/viewstv/TvScene;->backFromScene()V

    return-void

    .line 135
    :cond_0
    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->page:Ljava/lang/String;

    const-string v1, "menu"

    invoke-virtual {v0, v1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_1

    invoke-virtual {p0}, Lru/oopssre/imperialschool/viewstv/TvScene;->closeSettings()V

    return-void

    .line 136
    :cond_1
    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->page:Ljava/lang/String;

    const-string v1, "project"

    invoke-virtual {v0, v1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_2

    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->projectReturn:Ljava/lang/String;

    const-string v1, "credits_detail"

    invoke-virtual {v0, v1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_2

    invoke-virtual {p0}, Lru/oopssre/imperialschool/viewstv/TvScene;->creditsDetail()V

    return-void

    .line 137
    :cond_2
    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->page:Ljava/lang/String;

    invoke-static {v0}, Lru/oopssre/imperialschool/viewstv/SceneCopy;->parent(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p0, v0}, Lru/oopssre/imperialschool/viewstv/TvScene;->showPage(Ljava/lang/String;)V

    return-void
.end method

.method background(IZ)Landroid/graphics/drawable/GradientDrawable;
    .locals 1

    .line 64
    new-instance v0, Landroid/graphics/drawable/GradientDrawable;

    invoke-direct {v0}, Landroid/graphics/drawable/GradientDrawable;-><init>()V

    invoke-virtual {v0, p1}, Landroid/graphics/drawable/GradientDrawable;->setColor(I)V

    const/16 p1, 0x9

    invoke-virtual {p0, p1}, Lru/oopssre/imperialschool/viewstv/TvScene;->dp(I)I

    move-result p1

    int-to-float p1, p1

    invoke-virtual {v0, p1}, Landroid/graphics/drawable/GradientDrawable;->setCornerRadius(F)V

    if-eqz p2, :cond_0

    const/4 p1, 0x3

    invoke-virtual {p0, p1}, Lru/oopssre/imperialschool/viewstv/TvScene;->dp(I)I

    move-result p1

    const p2, -0x440ab

    invoke-virtual {v0, p1, p2}, Landroid/graphics/drawable/GradientDrawable;->setStroke(II)V

    :cond_0
    return-object v0
.end method

.method beginPage(Ljava/lang/String;Ljava/lang/String;)V
    .locals 6

    .line 79
    invoke-virtual {p0}, Lru/oopssre/imperialschool/viewstv/TvScene;->rememberFocus()V

    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->gallery:Lru/oopssre/imperialschool/viewstv/ThemeGallery;

    const/4 v1, 0x0

    if-eqz v0, :cond_0

    invoke-virtual {v0}, Lru/oopssre/imperialschool/viewstv/ThemeGallery;->close()V

    iput-object v1, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->gallery:Lru/oopssre/imperialschool/viewstv/ThemeGallery;

    .line 80
    :cond_0
    iget-wide v2, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->capabilityGeneration:J

    const-wide/16 v4, 0x1

    add-long/2addr v2, v4

    iput-wide v2, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->capabilityGeneration:J

    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->capabilityJob:Ljava/util/concurrent/Future;

    if-eqz v0, :cond_1

    const/4 v2, 0x1

    invoke-interface {v0, v2}, Ljava/util/concurrent/Future;->cancel(Z)Z

    .line 81
    :cond_1
    iput-object p1, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->page:Ljava/lang/String;

    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->content:Landroid/widget/LinearLayout;

    invoke-virtual {v0}, Landroid/widget/LinearLayout;->removeAllViews()V

    iput-object v1, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->musicCheckDetails:Landroid/widget/TextView;

    iput-object v1, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->cacheDetails:Landroid/widget/TextView;

    iput-object v1, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->diagnosticDetails:Landroid/widget/TextView;

    iput-object v1, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->musicDetails:Landroid/widget/TextView;

    iput-object v1, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->details:Landroid/widget/TextView;

    iput-object v1, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->musicCheck:Landroid/widget/Button;

    iput-object v1, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->volumeControl:Landroid/widget/Button;

    .line 82
    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->panel:Landroid/widget/ScrollView;

    invoke-virtual {v0}, Landroid/widget/ScrollView;->getLayoutParams()Landroid/view/ViewGroup$LayoutParams;

    move-result-object v0

    check-cast v0, Landroid/widget/FrameLayout$LayoutParams;

    const-string v1, "themes"

    invoke-virtual {p1, v1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p1

    if-eqz p1, :cond_2

    const/16 p1, 0x360

    goto :goto_0

    :cond_2
    const/16 p1, 0x1e0

    :goto_0
    invoke-virtual {p0, p1}, Lru/oopssre/imperialschool/viewstv/TvScene;->dp(I)I

    move-result p1

    iget-object v1, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->context:Landroid/content/Context;

    invoke-virtual {v1}, Landroid/content/Context;->getResources()Landroid/content/res/Resources;

    move-result-object v1

    invoke-virtual {v1}, Landroid/content/res/Resources;->getDisplayMetrics()Landroid/util/DisplayMetrics;

    move-result-object v1

    iget v1, v1, Landroid/util/DisplayMetrics;->widthPixels:I

    const/16 v2, 0x60

    invoke-virtual {p0, v2}, Lru/oopssre/imperialschool/viewstv/TvScene;->dp(I)I

    move-result v2

    sub-int/2addr v1, v2

    invoke-static {p1, v1}, Ljava/lang/Math;->min(II)I

    move-result p1

    iput p1, v0, Landroid/widget/FrameLayout$LayoutParams;->width:I

    iget-object p1, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->panel:Landroid/widget/ScrollView;

    invoke-virtual {p1, v0}, Landroid/widget/ScrollView;->setLayoutParams(Landroid/view/ViewGroup$LayoutParams;)V

    .line 83
    invoke-virtual {p0, p2}, Lru/oopssre/imperialschool/viewstv/TvScene;->heading(Ljava/lang/String;)V

    return-void
.end method

.method button(Ljava/lang/String;Ljava/lang/Runnable;)Landroid/widget/Button;
    .locals 1

    .line 73
    invoke-virtual {p0, p1}, Lru/oopssre/imperialschool/viewstv/TvScene;->focusKey(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p0, v0, p1, p2}, Lru/oopssre/imperialschool/viewstv/TvScene;->button(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Runnable;)Landroid/widget/Button;

    move-result-object p1

    return-object p1
.end method

.method button(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Runnable;)Landroid/widget/Button;
    .locals 0

    .line 74
    invoke-virtual {p0, p1, p2, p3}, Lru/oopssre/imperialschool/viewstv/TvScene;->makeButton(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Runnable;)Landroid/widget/Button;

    move-result-object p1

    iget-object p2, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->content:Landroid/widget/LinearLayout;

    invoke-virtual {p0}, Lru/oopssre/imperialschool/viewstv/TvScene;->buttonLayout()Landroid/widget/LinearLayout$LayoutParams;

    move-result-object p3

    invoke-virtual {p2, p1, p3}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    return-object p1
.end method

.method buttonLayout()Landroid/widget/LinearLayout$LayoutParams;
    .locals 3

    .line 65
    new-instance v0, Landroid/widget/LinearLayout$LayoutParams;

    const/4 v1, -0x1

    const/4 v2, -0x2

    invoke-direct {v0, v1, v2}, Landroid/widget/LinearLayout$LayoutParams;-><init>(II)V

    const/16 v1, 0x9

    invoke-virtual {p0, v1}, Lru/oopssre/imperialschool/viewstv/TvScene;->dp(I)I

    move-result v1

    iput v1, v0, Landroid/widget/LinearLayout$LayoutParams;->bottomMargin:I

    return-object v0
.end method

.method cacheMenu()V
    .locals 3

    .line 278
    const-string v0, "cache"

    const-string v1, "\u0425\u0440\u0430\u043d\u0438\u043b\u0438\u0449\u0435"

    invoke-virtual {p0, v0, v1}, Lru/oopssre/imperialschool/viewstv/TvScene;->beginPage(Ljava/lang/String;Ljava/lang/String;)V

    invoke-virtual {p0}, Lru/oopssre/imperialschool/viewstv/TvScene;->cacheText()Ljava/lang/String;

    move-result-object v0

    const/16 v1, 0x14

    invoke-virtual {p0, v0, v1}, Lru/oopssre/imperialschool/viewstv/TvScene;->text(Ljava/lang/String;I)Landroid/widget/TextView;

    move-result-object v0

    iput-object v0, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->cacheDetails:Landroid/widget/TextView;

    const/4 v2, 0x0

    invoke-virtual {p0, v1}, Lru/oopssre/imperialschool/viewstv/TvScene;->dp(I)I

    move-result v1

    invoke-virtual {v0, v2, v2, v2, v1}, Landroid/widget/TextView;->setPadding(IIII)V

    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->content:Landroid/widget/LinearLayout;

    iget-object v1, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->cacheDetails:Landroid/widget/TextView;

    invoke-virtual {v0, v1}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    iget-boolean v0, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->cacheBusy:Z

    if-eqz v0, :cond_0

    const-string v0, "\u041e\u0447\u0438\u0449\u0430\u044e \u043a\u0435\u0448\u2026"

    goto :goto_0

    :cond_0
    const-string v0, "\u041e\u0447\u0438\u0441\u0442\u0438\u0442\u044c \u043a\u0435\u0448"

    :goto_0
    new-instance v1, Lru/oopssre/imperialschool/viewstv/TvScene$$ExternalSyntheticLambda34;

    invoke-direct {v1, p0}, Lru/oopssre/imperialschool/viewstv/TvScene$$ExternalSyntheticLambda34;-><init>(Lru/oopssre/imperialschool/viewstv/TvScene;)V

    invoke-virtual {p0, v0, v1}, Lru/oopssre/imperialschool/viewstv/TvScene;->button(Ljava/lang/String;Ljava/lang/Runnable;)Landroid/widget/Button;

    move-result-object v0

    iget-boolean v1, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->cacheBusy:Z

    xor-int/lit8 v1, v1, 0x1

    invoke-virtual {v0, v1}, Landroid/widget/Button;->setEnabled(Z)V

    const-string v0, "\u0423\u0441\u0442\u0430\u0440\u0435\u0432\u0448\u0438\u0435 \u0444\u0430\u0439\u043b\u044b \u0443\u0434\u0430\u043b\u044f\u044e\u0442\u0441\u044f \u0430\u0432\u0442\u043e\u043c\u0430\u0442\u0438\u0447\u0435\u0441\u043a\u0438. \u041e\u0447\u0438\u0441\u0442\u043a\u0430 \u0441\u043e\u0445\u0440\u0430\u043d\u0438\u0442 \u043d\u0430\u0441\u0442\u0440\u043e\u0439\u043a\u0438 \u0438 \u0437\u0430\u0433\u0440\u0443\u0437\u0438\u0442 \u0442\u0435\u043a\u0443\u0449\u0438\u0435 \u043e\u0431\u043e\u0438 \u0437\u0430\u043d\u043e\u0432\u043e."

    invoke-virtual {p0, v0}, Lru/oopssre/imperialschool/viewstv/TvScene;->message(Ljava/lang/String;)V

    invoke-virtual {p0}, Lru/oopssre/imperialschool/viewstv/TvScene;->focusFirst()V

    return-void
.end method

.method cacheText()Ljava/lang/String;
    .locals 3

    .line 277
    new-instance v0, Ljava/lang/StringBuilder;

    const-string v1, "\u0412\u0441\u0435\u0433\u043e: "

    invoke-direct {v0, v1}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    iget-object v1, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->context:Landroid/content/Context;

    invoke-virtual {v1}, Landroid/content/Context;->getCacheDir()Ljava/io/File;

    move-result-object v1

    invoke-static {v1}, Lru/oopssre/imperialschool/viewstv/CacheStore;->directoryBytes(Ljava/io/File;)J

    move-result-wide v1

    invoke-virtual {p0, v1, v2}, Lru/oopssre/imperialschool/viewstv/TvScene;->mb(J)Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    const-string v1, "\n\u041e\u0431\u043e\u0438 \u0438 \u043f\u0440\u0435\u0432\u044c\u044e: "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    iget-object v1, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->repo:Lru/oopssre/imperialschool/viewstv/Repository;

    iget-object v1, v1, Lru/oopssre/imperialschool/viewstv/Repository;->cache:Lru/oopssre/imperialschool/viewstv/CacheStore;

    invoke-virtual {v1}, Lru/oopssre/imperialschool/viewstv/CacheStore;->bytes()J

    move-result-wide v1

    invoke-virtual {p0, v1, v2}, Lru/oopssre/imperialschool/viewstv/TvScene;->mb(J)Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    const-string v1, "\n\u0424\u0430\u0439\u043b \u043e\u0431\u043d\u043e\u0432\u043b\u0435\u043d\u0438\u044f: "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    iget-object v1, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->updater:Lru/oopssre/imperialschool/viewstv/Updater;

    iget-object v1, v1, Lru/oopssre/imperialschool/viewstv/Updater;->folder:Ljava/io/File;

    invoke-static {v1}, Lru/oopssre/imperialschool/viewstv/CacheStore;->directoryBytes(Ljava/io/File;)J

    move-result-wide v1

    invoke-virtual {p0, v1, v2}, Lru/oopssre/imperialschool/viewstv/TvScene;->mb(J)Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    iget-object v1, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->cacheStatus:Ljava/lang/String;

    invoke-virtual {v1}, Ljava/lang/String;->isEmpty()Z

    move-result v1

    if-eqz v1, :cond_0

    const-string v1, ""

    goto :goto_0

    :cond_0
    new-instance v1, Ljava/lang/StringBuilder;

    const-string v2, "\n\n"

    invoke-direct {v1, v2}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    iget-object v2, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->cacheStatus:Ljava/lang/String;

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    :goto_0
    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    return-object v0
.end method

.method public catalogue()V
    .locals 2

    .line 303
    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->page:Ljava/lang/String;

    const-string v1, "themes"

    invoke-virtual {v0, v1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_0

    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->panel:Landroid/widget/ScrollView;

    invoke-virtual {v0}, Landroid/widget/ScrollView;->getVisibility()I

    move-result v0

    if-nez v0, :cond_0

    iget-boolean v0, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->cacheBusy:Z

    if-nez v0, :cond_0

    invoke-virtual {p0}, Lru/oopssre/imperialschool/viewstv/TvScene;->themeList()V

    :cond_0
    invoke-virtual {p0}, Lru/oopssre/imperialschool/viewstv/TvScene;->refreshDetails()V

    return-void
.end method

.method checkUpdate()V
    .locals 4

    .line 305
    iget-wide v0, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->updateGeneration:J

    const-wide/16 v2, 0x1

    add-long/2addr v0, v2

    iput-wide v0, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->updateGeneration:J

    const/4 v2, 0x1

    iput-boolean v2, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->updateBusy:Z

    const-string v2, "\u041f\u0440\u043e\u0432\u0435\u0440\u044f\u044e \u043e\u0431\u043d\u043e\u0432\u043b\u0435\u043d\u0438\u0435\u2026"

    iput-object v2, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->updateStatus:Ljava/lang/String;

    invoke-virtual {p0}, Lru/oopssre/imperialschool/viewstv/TvScene;->updatesMenu()V

    iget-object v2, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->updateWorker:Ljava/util/concurrent/ExecutorService;

    new-instance v3, Lru/oopssre/imperialschool/viewstv/TvScene$$ExternalSyntheticLambda33;

    invoke-direct {v3, p0, v0, v1}, Lru/oopssre/imperialschool/viewstv/TvScene$$ExternalSyntheticLambda33;-><init>(Lru/oopssre/imperialschool/viewstv/TvScene;J)V

    invoke-interface {v2, v3}, Ljava/util/concurrent/ExecutorService;->submit(Ljava/lang/Runnable;)Ljava/util/concurrent/Future;

    move-result-object v0

    iput-object v0, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->updateJob:Ljava/util/concurrent/Future;

    return-void
.end method

.method chooseTheme(Lru/oopssre/imperialschool/viewstv/Protocol$Theme;)V
    .locals 2

    .line 111
    iget-boolean v0, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->cacheBusy:Z

    if-eqz v0, :cond_0

    return-void

    .line 112
    :cond_0
    iget-object v0, p1, Lru/oopssre/imperialschool/viewstv/Protocol$Theme;->id:Ljava/lang/String;

    iget-object v1, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->repo:Lru/oopssre/imperialschool/viewstv/Repository;

    invoke-virtual {v1}, Lru/oopssre/imperialschool/viewstv/Repository;->selected()Lru/oopssre/imperialschool/viewstv/Protocol$Theme;

    move-result-object v1

    iget-object v1, v1, Lru/oopssre/imperialschool/viewstv/Protocol$Theme;->id:Ljava/lang/String;

    invoke-virtual {v0, v1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-nez v0, :cond_1

    .line 113
    invoke-virtual {p0}, Lru/oopssre/imperialschool/viewstv/TvScene;->resetPlayback()V

    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->repo:Lru/oopssre/imperialschool/viewstv/Repository;

    invoke-virtual {v0, p1}, Lru/oopssre/imperialschool/viewstv/Repository;->choose(Lru/oopssre/imperialschool/viewstv/Protocol$Theme;)V

    const/4 v0, 0x0

    invoke-virtual {p0, v0}, Lru/oopssre/imperialschool/viewstv/TvScene;->refreshResolution(Z)V

    .line 114
    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->placeholder:Landroid/widget/TextView;

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    invoke-static {p1}, Lru/oopssre/imperialschool/viewstv/ThemeText;->title(Lru/oopssre/imperialschool/viewstv/Protocol$Theme;)Ljava/lang/String;

    move-result-object p1

    invoke-virtual {v1, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p1

    const-string v1, "\n\u0417\u0430\u0433\u0440\u0443\u0436\u0430\u044e \u043e\u0431\u043e\u0438\u2026"

    invoke-virtual {p1, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p1

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-virtual {v0, p1}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    iget-boolean p1, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->active:Z

    if-eqz p1, :cond_1

    invoke-virtual {p0}, Lru/oopssre/imperialschool/viewstv/TvScene;->resumePlayback()V

    .line 116
    :cond_1
    invoke-virtual {p0}, Lru/oopssre/imperialschool/viewstv/TvScene;->closeSettings()V

    return-void
.end method

.method clearCache()V
    .locals 10

    .line 279
    iget-boolean v0, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->cacheBusy:Z

    if-eqz v0, :cond_0

    return-void

    :cond_0
    const/4 v0, 0x1

    iput-boolean v0, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->cacheBusy:Z

    invoke-virtual {p0}, Lru/oopssre/imperialschool/viewstv/TvScene;->pausePlayback()V

    invoke-virtual {p0}, Lru/oopssre/imperialschool/viewstv/TvScene;->resetPlayback()V

    iget-wide v1, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->updateGeneration:J

    const-wide/16 v3, 0x1

    add-long/2addr v1, v3

    iput-wide v1, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->updateGeneration:J

    iget-object v1, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->updateJob:Ljava/util/concurrent/Future;

    if-eqz v1, :cond_1

    invoke-interface {v1, v0}, Ljava/util/concurrent/Future;->cancel(Z)Z

    :cond_1
    const/4 v0, 0x0

    iput-boolean v0, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->updateBusy:Z

    const/4 v0, 0x0

    iput-object v0, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->ready:Lru/oopssre/imperialschool/viewstv/Release;

    const-string v0, ""

    iput-object v0, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->updateStatus:Ljava/lang/String;

    const-string v0, "\u041e\u0447\u0438\u0449\u0430\u044e \u043a\u0435\u0448\u2026"

    iput-object v0, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->cacheStatus:Ljava/lang/String;

    invoke-virtual {p0}, Lru/oopssre/imperialschool/viewstv/TvScene;->cacheMenu()V

    .line 280
    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->controller:Lru/oopssre/imperialschool/viewstv/SceneController;

    iget-object v0, v0, Lru/oopssre/imperialschool/viewstv/SceneController;->worker:Ljava/util/concurrent/ExecutorService;

    new-instance v1, Lru/oopssre/imperialschool/viewstv/TvScene$$ExternalSyntheticLambda44;

    invoke-direct {v1}, Lru/oopssre/imperialschool/viewstv/TvScene$$ExternalSyntheticLambda44;-><init>()V

    invoke-interface {v0, v1}, Ljava/util/concurrent/ExecutorService;->submit(Ljava/lang/Runnable;)Ljava/util/concurrent/Future;

    move-result-object v4

    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->controller:Lru/oopssre/imperialschool/viewstv/SceneController;

    iget-object v0, v0, Lru/oopssre/imperialschool/viewstv/SceneController;->cacheWorker:Ljava/util/concurrent/ExecutorService;

    new-instance v1, Lru/oopssre/imperialschool/viewstv/TvScene$$ExternalSyntheticLambda55;

    invoke-direct {v1}, Lru/oopssre/imperialschool/viewstv/TvScene$$ExternalSyntheticLambda55;-><init>()V

    invoke-interface {v0, v1}, Ljava/util/concurrent/ExecutorService;->submit(Ljava/lang/Runnable;)Ljava/util/concurrent/Future;

    move-result-object v5

    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->videoController:Lru/oopssre/imperialschool/viewstv/VideoController;

    iget-object v0, v0, Lru/oopssre/imperialschool/viewstv/VideoController;->worker:Ljava/util/concurrent/ExecutorService;

    new-instance v1, Lru/oopssre/imperialschool/viewstv/TvScene$$ExternalSyntheticLambda60;

    invoke-direct {v1}, Lru/oopssre/imperialschool/viewstv/TvScene$$ExternalSyntheticLambda60;-><init>()V

    invoke-interface {v0, v1}, Ljava/util/concurrent/ExecutorService;->submit(Ljava/lang/Runnable;)Ljava/util/concurrent/Future;

    move-result-object v6

    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->video:Lru/oopssre/imperialschool/viewstv/VideoSurface;

    iget-object v0, v0, Lru/oopssre/imperialschool/viewstv/VideoSurface;->worker:Ljava/util/concurrent/ExecutorService;

    new-instance v1, Lru/oopssre/imperialschool/viewstv/TvScene$$ExternalSyntheticLambda61;

    invoke-direct {v1}, Lru/oopssre/imperialschool/viewstv/TvScene$$ExternalSyntheticLambda61;-><init>()V

    invoke-interface {v0, v1}, Ljava/util/concurrent/ExecutorService;->submit(Ljava/lang/Runnable;)Ljava/util/concurrent/Future;

    move-result-object v7

    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->previewWorker:Ljava/util/concurrent/ExecutorService;

    new-instance v1, Lru/oopssre/imperialschool/viewstv/TvScene$$ExternalSyntheticLambda62;

    invoke-direct {v1}, Lru/oopssre/imperialschool/viewstv/TvScene$$ExternalSyntheticLambda62;-><init>()V

    invoke-interface {v0, v1}, Ljava/util/concurrent/ExecutorService;->submit(Ljava/lang/Runnable;)Ljava/util/concurrent/Future;

    move-result-object v8

    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->music:Lru/oopssre/imperialschool/viewstv/SceneMusic;

    invoke-virtual {v0}, Lru/oopssre/imperialschool/viewstv/SceneMusic;->idle()Ljava/util/concurrent/Future;

    move-result-object v9

    .line 281
    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->updateWorker:Ljava/util/concurrent/ExecutorService;

    new-instance v2, Lru/oopssre/imperialschool/viewstv/TvScene$$ExternalSyntheticLambda63;

    move-object v3, p0

    invoke-direct/range {v2 .. v9}, Lru/oopssre/imperialschool/viewstv/TvScene$$ExternalSyntheticLambda63;-><init>(Lru/oopssre/imperialschool/viewstv/TvScene;Ljava/util/concurrent/Future;Ljava/util/concurrent/Future;Ljava/util/concurrent/Future;Ljava/util/concurrent/Future;Ljava/util/concurrent/Future;Ljava/util/concurrent/Future;)V

    invoke-interface {v0, v2}, Ljava/util/concurrent/ExecutorService;->submit(Ljava/lang/Runnable;)Ljava/util/concurrent/Future;

    return-void
.end method

.method closeSettings()V
    .locals 4

    invoke-direct {p0}, Lru/oopssre/imperialschool/viewstv/TvScene;->resetExitBack()V

    .line 158
    invoke-virtual {p0}, Lru/oopssre/imperialschool/viewstv/TvScene;->rememberFocus()V

    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->gallery:Lru/oopssre/imperialschool/viewstv/ThemeGallery;

    if-eqz v0, :cond_0

    invoke-virtual {v0}, Lru/oopssre/imperialschool/viewstv/ThemeGallery;->close()V

    const/4 v0, 0x0

    iput-object v0, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->gallery:Lru/oopssre/imperialschool/viewstv/ThemeGallery;

    :cond_0
    iget-wide v0, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->capabilityGeneration:J

    const-wide/16 v2, 0x1

    add-long/2addr v0, v2

    iput-wide v0, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->capabilityGeneration:J

    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->capabilityJob:Ljava/util/concurrent/Future;

    if-eqz v0, :cond_1

    const/4 v1, 0x1

    invoke-interface {v0, v1}, Ljava/util/concurrent/Future;->cancel(Z)Z

    :cond_1
    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->panel:Landroid/widget/ScrollView;

    const/16 v1, 0x8

    invoke-virtual {v0, v1}, Landroid/widget/ScrollView;->setVisibility(I)V

    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->placeholder:Landroid/widget/TextView;

    invoke-virtual {p0}, Lru/oopssre/imperialschool/viewstv/TvScene;->videoEnabled()Z

    move-result v2

    const/4 v3, 0x0

    if-eqz v2, :cond_2

    iget-object v2, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->video:Lru/oopssre/imperialschool/viewstv/VideoSurface;

    iget-boolean v2, v2, Lru/oopssre/imperialschool/viewstv/VideoSurface;->playing:Z

    if-eqz v2, :cond_3

    goto :goto_0

    :cond_2
    iget-object v2, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->controller:Lru/oopssre/imperialschool/viewstv/SceneController;

    iget-object v2, v2, Lru/oopssre/imperialschool/viewstv/SceneController;->frame:Lru/oopssre/imperialschool/viewstv/Protocol$Frame;

    if-nez v2, :cond_4

    :cond_3
    move v1, v3

    :cond_4
    :goto_0
    invoke-virtual {v0, v1}, Landroid/widget/TextView;->setVisibility(I)V

    const-string v0, "menu"

    iput-object v0, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->page:Ljava/lang/String;

    return-void
.end method

.method collectButtons(Landroid/view/View;Ljava/util/List;)V
    .locals 2
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Landroid/view/View;",
            "Ljava/util/List<",
            "Landroid/widget/Button;",
            ">;)V"
        }
    .end annotation

    .line 85
    instance-of v0, p1, Landroid/widget/Button;

    if-eqz v0, :cond_0

    invoke-virtual {p1}, Landroid/view/View;->isEnabled()Z

    move-result v0

    if-eqz v0, :cond_1

    check-cast p1, Landroid/widget/Button;

    invoke-interface {p2, p1}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    return-void

    :cond_0
    instance-of v0, p1, Landroid/view/ViewGroup;

    if-eqz v0, :cond_1

    check-cast p1, Landroid/view/ViewGroup;

    const/4 v0, 0x0

    :goto_0
    invoke-virtual {p1}, Landroid/view/ViewGroup;->getChildCount()I

    move-result v1

    if-ge v0, v1, :cond_1

    invoke-virtual {p1, v0}, Landroid/view/ViewGroup;->getChildAt(I)Landroid/view/View;

    move-result-object v1

    invoke-virtual {p0, v1, p2}, Lru/oopssre/imperialschool/viewstv/TvScene;->collectButtons(Landroid/view/View;Ljava/util/List;)V

    add-int/lit8 v0, v0, 0x1

    goto :goto_0

    :cond_1
    return-void
.end method

.method collectionMenu()V
    .locals 2

    .line 161
    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->repo:Lru/oopssre/imperialschool/viewstv/Repository;

    invoke-virtual {v0}, Lru/oopssre/imperialschool/viewstv/Repository;->selected()Lru/oopssre/imperialschool/viewstv/Protocol$Theme;

    move-result-object v0

    invoke-static {v0}, Lru/oopssre/imperialschool/viewstv/ThemeText;->title(Lru/oopssre/imperialschool/viewstv/Protocol$Theme;)Ljava/lang/String;

    move-result-object v0

    const-string v1, "collection"

    invoke-virtual {p0, v1, v0}, Lru/oopssre/imperialschool/viewstv/TvScene;->beginPage(Ljava/lang/String;Ljava/lang/String;)V

    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->repo:Lru/oopssre/imperialschool/viewstv/Repository;

    invoke-virtual {v0}, Lru/oopssre/imperialschool/viewstv/Repository;->selected()Lru/oopssre/imperialschool/viewstv/Protocol$Theme;

    move-result-object v0

    invoke-static {v0}, Lru/oopssre/imperialschool/viewstv/ThemeText;->description(Lru/oopssre/imperialschool/viewstv/Protocol$Theme;)Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p0, v0}, Lru/oopssre/imperialschool/viewstv/TvScene;->message(Ljava/lang/String;)V

    .line 162
    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->repo:Lru/oopssre/imperialschool/viewstv/Repository;

    invoke-virtual {v0}, Lru/oopssre/imperialschool/viewstv/Repository;->selected()Lru/oopssre/imperialschool/viewstv/Protocol$Theme;

    move-result-object v0

    iget-object v0, v0, Lru/oopssre/imperialschool/viewstv/Protocol$Theme;->kind:Ljava/lang/String;

    const-string v1, "weather"

    invoke-virtual {v0, v1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_1

    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->repo:Lru/oopssre/imperialschool/viewstv/Repository;

    invoke-virtual {v0}, Lru/oopssre/imperialschool/viewstv/Repository;->weatherSource()Ljava/lang/String;

    move-result-object v0

    const-string v1, "real"

    invoke-virtual {v0, v1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_0

    const-string v0, "\u041f\u043e\u0433\u043e\u0434\u0430 \u0421\u0442\u043e\u043b\u0438\u0446\u044b \u0418\u043c\u043f\u0435\u0440\u0438\u0438"

    goto :goto_0

    :cond_0
    const-string v0, "\u0418\u0433\u0440\u043e\u0432\u043e\u0439 \u043c\u0438\u0440"

    :goto_0
    const-string v1, "\u0418\u0441\u0442\u043e\u0447\u043d\u0438\u043a \u043f\u043e\u0433\u043e\u0434\u044b \u00b7 "

    invoke-virtual {v1, v0}, Ljava/lang/String;->concat(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    new-instance v1, Lru/oopssre/imperialschool/viewstv/TvScene$$ExternalSyntheticLambda1;

    invoke-direct {v1, p0}, Lru/oopssre/imperialschool/viewstv/TvScene$$ExternalSyntheticLambda1;-><init>(Lru/oopssre/imperialschool/viewstv/TvScene;)V

    invoke-virtual {p0, v0, v1}, Lru/oopssre/imperialschool/viewstv/TvScene;->button(Ljava/lang/String;Ljava/lang/Runnable;)Landroid/widget/Button;

    goto :goto_1

    .line 163
    :cond_1
    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->repo:Lru/oopssre/imperialschool/viewstv/Repository;

    invoke-virtual {v0}, Lru/oopssre/imperialschool/viewstv/Repository;->selected()Lru/oopssre/imperialschool/viewstv/Protocol$Theme;

    move-result-object v0

    iget-object v0, v0, Lru/oopssre/imperialschool/viewstv/Protocol$Theme;->kind:Ljava/lang/String;

    const-string v1, "dynamic"

    invoke-virtual {v0, v1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-nez v0, :cond_2

    new-instance v0, Lru/oopssre/imperialschool/viewstv/TvScene$$ExternalSyntheticLambda2;

    invoke-direct {v0, p0}, Lru/oopssre/imperialschool/viewstv/TvScene$$ExternalSyntheticLambda2;-><init>(Lru/oopssre/imperialschool/viewstv/TvScene;)V

    const-string v1, "\u0421\u043c\u0435\u043d\u0430 \u0438\u0437\u043e\u0431\u0440\u0430\u0436\u0435\u043d\u0438\u0439"

    invoke-virtual {p0, v1, v0}, Lru/oopssre/imperialschool/viewstv/TvScene;->button(Ljava/lang/String;Ljava/lang/Runnable;)Landroid/widget/Button;

    .line 164
    :cond_2
    :goto_1
    invoke-virtual {p0}, Lru/oopssre/imperialschool/viewstv/TvScene;->focusFirst()V

    return-void
.end method

.method configuredSize()[I
    .locals 3

    .line 98
    invoke-virtual {p0}, Lru/oopssre/imperialschool/viewstv/TvScene;->videoEnabled()Z

    move-result v0

    if-eqz v0, :cond_0

    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->host:Lru/oopssre/imperialschool/viewstv/TvScene$Host;

    invoke-interface {v0}, Lru/oopssre/imperialschool/viewstv/TvScene$Host;->window()Landroid/view/Window;

    move-result-object v0

    invoke-static {v0}, Lru/oopssre/imperialschool/viewstv/VideoSurface;->configureWindow(Landroid/view/Window;)V

    const/16 v0, 0xf00

    const/16 v1, 0x870

    filled-new-array {v0, v1}, [I

    move-result-object v0

    return-object v0

    :cond_0
    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->host:Lru/oopssre/imperialschool/viewstv/TvScene$Host;

    invoke-interface {v0}, Lru/oopssre/imperialschool/viewstv/TvScene$Host;->window()Landroid/view/Window;

    move-result-object v0

    iget-object v1, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->host:Lru/oopssre/imperialschool/viewstv/TvScene$Host;

    invoke-interface {v1}, Lru/oopssre/imperialschool/viewstv/TvScene$Host;->window()Landroid/view/Window;

    move-result-object v1

    invoke-virtual {v1}, Landroid/view/Window;->getDecorView()Landroid/view/View;

    move-result-object v1

    invoke-virtual {v1}, Landroid/view/View;->getDisplay()Landroid/view/Display;

    move-result-object v1

    iget-object v2, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->repo:Lru/oopssre/imperialschool/viewstv/Repository;

    invoke-virtual {v2}, Lru/oopssre/imperialschool/viewstv/Repository;->resolution()Ljava/lang/String;

    move-result-object v2

    invoke-static {v0, v1, v2}, Lru/oopssre/imperialschool/viewstv/WallpaperSurface;->configure(Landroid/view/Window;Landroid/view/Display;Ljava/lang/String;)[I

    move-result-object v0

    return-object v0
.end method

.method creditsDetail()V
    .locals 2

    .line 275
    const-string v0, "credits_detail"

    const-string v1, "\u041e \u043a\u043e\u043c\u043f\u043e\u0437\u0438\u0446\u0438\u0438"

    invoke-virtual {p0, v0, v1}, Lru/oopssre/imperialschool/viewstv/TvScene;->beginPage(Ljava/lang/String;Ljava/lang/String;)V

    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->creditDetail:Ljava/lang/String;

    invoke-virtual {p0, v0}, Lru/oopssre/imperialschool/viewstv/TvScene;->message(Ljava/lang/String;)V

    invoke-virtual {p0}, Lru/oopssre/imperialschool/viewstv/TvScene;->focusFirst()V

    return-void
.end method

.method date(J)Ljava/lang/String;
    .locals 2

    const/4 v0, 0x3

    .line 299
    invoke-static {v0, v0}, Ljava/text/DateFormat;->getDateTimeInstance(II)Ljava/text/DateFormat;

    move-result-object v0

    new-instance v1, Ljava/util/Date;

    invoke-direct {v1, p1, p2}, Ljava/util/Date;-><init>(J)V

    invoke-virtual {v0, v1}, Ljava/text/DateFormat;->format(Ljava/util/Date;)Ljava/lang/String;

    move-result-object p1

    return-object p1
.end method

.method destroy()V
    .locals 2

    const/4 v0, 0x1

    .line 125
    iput-boolean v0, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->destroyed:Z

    invoke-virtual {p0}, Lru/oopssre/imperialschool/viewstv/TvScene;->stop()V

    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->handler:Landroid/os/Handler;

    const/4 v1, 0x0

    invoke-virtual {v0, v1}, Landroid/os/Handler;->removeCallbacksAndMessages(Ljava/lang/Object;)V

    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->controller:Lru/oopssre/imperialschool/viewstv/SceneController;

    invoke-virtual {v0}, Lru/oopssre/imperialschool/viewstv/SceneController;->destroy()V

    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->videoController:Lru/oopssre/imperialschool/viewstv/VideoController;

    invoke-virtual {v0}, Lru/oopssre/imperialschool/viewstv/VideoController;->destroy()V

    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->video:Lru/oopssre/imperialschool/viewstv/VideoSurface;

    invoke-virtual {v0}, Lru/oopssre/imperialschool/viewstv/VideoSurface;->destroy()V

    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->music:Lru/oopssre/imperialschool/viewstv/SceneMusic;

    invoke-virtual {v0}, Lru/oopssre/imperialschool/viewstv/SceneMusic;->destroy()V

    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->updateWorker:Ljava/util/concurrent/ExecutorService;

    invoke-interface {v0}, Ljava/util/concurrent/ExecutorService;->shutdownNow()Ljava/util/List;

    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->previewWorker:Ljava/util/concurrent/ExecutorService;

    invoke-interface {v0}, Ljava/util/concurrent/ExecutorService;->shutdownNow()Ljava/util/List;

    return-void
.end method

.method diagnostics()V
    .locals 3

    .line 285
    const-string v0, "diagnostics"

    const-string v1, "\u0414\u0438\u0430\u0433\u043d\u043e\u0441\u0442\u0438\u043a\u0430"

    invoke-virtual {p0, v0, v1}, Lru/oopssre/imperialschool/viewstv/TvScene;->beginPage(Ljava/lang/String;Ljava/lang/String;)V

    .line 286
    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->music:Lru/oopssre/imperialschool/viewstv/SceneMusic;

    invoke-static {v0}, Ljava/util/Objects;->requireNonNull(Ljava/lang/Object;)Ljava/lang/Object;

    new-instance v1, Lru/oopssre/imperialschool/viewstv/TvScene$$ExternalSyntheticLambda3;

    invoke-direct {v1, v0}, Lru/oopssre/imperialschool/viewstv/TvScene$$ExternalSyntheticLambda3;-><init>(Lru/oopssre/imperialschool/viewstv/SceneMusic;)V

    const-string v0, "\u041f\u0440\u043e\u0432\u0435\u0440\u0438\u0442\u044c \u043c\u0443\u0437\u044b\u043a\u0443 \u0442\u0435\u043c\u044b"

    invoke-virtual {p0, v0, v1}, Lru/oopssre/imperialschool/viewstv/TvScene;->button(Ljava/lang/String;Ljava/lang/Runnable;)Landroid/widget/Button;

    move-result-object v0

    iput-object v0, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->musicCheck:Landroid/widget/Button;

    .line 287
    const-string v0, ""

    const/16 v1, 0x12

    invoke-virtual {p0, v0, v1}, Lru/oopssre/imperialschool/viewstv/TvScene;->text(Ljava/lang/String;I)Landroid/widget/TextView;

    move-result-object v0

    iput-object v0, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->musicCheckDetails:Landroid/widget/TextView;

    iget-object v1, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->content:Landroid/widget/LinearLayout;

    invoke-virtual {p0}, Lru/oopssre/imperialschool/viewstv/TvScene;->buttonLayout()Landroid/widget/LinearLayout$LayoutParams;

    move-result-object v2

    invoke-virtual {v1, v0, v2}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    .line 288
    new-instance v0, Lru/oopssre/imperialschool/viewstv/TvScene$$ExternalSyntheticLambda4;

    invoke-direct {v0, p0}, Lru/oopssre/imperialschool/viewstv/TvScene$$ExternalSyntheticLambda4;-><init>(Lru/oopssre/imperialschool/viewstv/TvScene;)V

    const-string v1, "\u041f\u0440\u043e\u0432\u0435\u0440\u0438\u0442\u044c \u043e\u0431\u043d\u043e\u0432\u043b\u0435\u043d\u0438\u0435 \u043e\u0431\u043e\u0435\u0432"

    invoke-virtual {p0, v1, v0}, Lru/oopssre/imperialschool/viewstv/TvScene;->button(Ljava/lang/String;Ljava/lang/Runnable;)Landroid/widget/Button;

    .line 289
    invoke-virtual {p0}, Lru/oopssre/imperialschool/viewstv/TvScene;->diagnosticsText()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p0, v0}, Lru/oopssre/imperialschool/viewstv/TvScene;->technical(Ljava/lang/String;)Landroid/widget/TextView;

    move-result-object v0

    iput-object v0, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->diagnosticDetails:Landroid/widget/TextView;

    invoke-virtual {p0}, Lru/oopssre/imperialschool/viewstv/TvScene;->musicChanged()V

    invoke-virtual {p0}, Lru/oopssre/imperialschool/viewstv/TvScene;->focusFirst()V

    return-void
.end method

.method diagnosticsText()Ljava/lang/String;
    .locals 11

    .line 292
    invoke-virtual {p0}, Lru/oopssre/imperialschool/viewstv/TvScene;->videoEnabled()Z

    move-result v0

    const-string v1, "\u041a\u0430\u0434\u0440 \u0430\u043a\u0442\u0443\u0430\u043b\u0435\u043d"

    const-string v2, "\n\u0410\u043a\u0442\u0443\u0430\u043b\u0435\u043d \u0434\u043e: "

    const-string v3, "\n\u0421\u043e\u0431\u0440\u0430\u043d: "

    const/4 v4, 0x1

    const/4 v5, 0x0

    const-string v6, "\n\u041e\u043f\u0440\u0435\u0434\u0435\u043b\u0435\u043d\u043e Android: "

    const-string v7, "\n"

    const-string v8, " \u00d7 "

    if-eqz v0, :cond_3

    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->video:Lru/oopssre/imperialschool/viewstv/VideoSurface;

    iget-object v0, v0, Lru/oopssre/imperialschool/viewstv/VideoSurface;->displayed:Lru/oopssre/imperialschool/viewstv/VideoInfo;

    new-instance v9, Ljava/lang/StringBuilder;

    const-string v10, "\u0420\u0435\u0436\u0438\u043c: \u0432\u0438\u0434\u0435\u043e 4\u041a\n\u0412\u044b\u0431\u0440\u0430\u043d\u043e: "

    invoke-direct {v9, v10}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    iget-object v10, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->repo:Lru/oopssre/imperialschool/viewstv/Repository;

    invoke-virtual {v10}, Lru/oopssre/imperialschool/viewstv/Repository;->selected()Lru/oopssre/imperialschool/viewstv/Protocol$Theme;

    move-result-object v10

    iget-object v10, v10, Lru/oopssre/imperialschool/viewstv/Protocol$Theme;->title:Ljava/lang/String;

    invoke-virtual {v9, v10}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v9

    invoke-virtual {v9, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v6

    iget-object v9, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->detectedSize:[I

    aget v5, v9, v5

    invoke-virtual {v6, v5}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v5

    invoke-virtual {v5, v8}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v5

    iget-object v6, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->detectedSize:[I

    aget v4, v6, v4

    invoke-virtual {v5, v4}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v4

    invoke-virtual {v4, v7}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v4

    iget-object v5, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->video:Lru/oopssre/imperialschool/viewstv/VideoSurface;

    invoke-virtual {v5}, Lru/oopssre/imperialschool/viewstv/VideoSurface;->diagnostics()Ljava/lang/String;

    move-result-object v5

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v4

    if-nez v0, :cond_0

    const-string v0, ""

    goto :goto_0

    :cond_0
    new-instance v5, Ljava/lang/StringBuilder;

    invoke-direct {v5, v3}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    iget-object v3, v0, Lru/oopssre/imperialschool/viewstv/VideoInfo;->frame:Lru/oopssre/imperialschool/viewstv/Protocol$Frame;

    iget-wide v8, v3, Lru/oopssre/imperialschool/viewstv/Protocol$Frame;->at:J

    invoke-virtual {p0, v8, v9}, Lru/oopssre/imperialschool/viewstv/TvScene;->date(J)Ljava/lang/String;

    move-result-object v3

    invoke-virtual {v5, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v3

    invoke-virtual {v3, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    iget-object v3, v0, Lru/oopssre/imperialschool/viewstv/VideoInfo;->frame:Lru/oopssre/imperialschool/viewstv/Protocol$Frame;

    iget-wide v5, v3, Lru/oopssre/imperialschool/viewstv/Protocol$Frame;->until:J

    invoke-virtual {p0, v5, v6}, Lru/oopssre/imperialschool/viewstv/TvScene;->date(J)Ljava/lang/String;

    move-result-object v3

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    const-string v3, "\n\u041e\u0442\u043c\u0435\u0442\u043a\u0430 \u043f\u0440\u043e\u0441\u0440\u043e\u0447\u043a\u0438 \u043f\u043e\u0441\u043b\u0435: "

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    iget-object v3, v0, Lru/oopssre/imperialschool/viewstv/VideoInfo;->frame:Lru/oopssre/imperialschool/viewstv/Protocol$Frame;

    invoke-virtual {v3}, Lru/oopssre/imperialschool/viewstv/Protocol$Frame;->staleAfter()J

    move-result-wide v5

    invoke-virtual {p0, v5, v6}, Lru/oopssre/imperialschool/viewstv/TvScene;->date(J)Ljava/lang/String;

    move-result-object v3

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {v2, v7}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    iget-object v0, v0, Lru/oopssre/imperialschool/viewstv/VideoInfo;->frame:Lru/oopssre/imperialschool/viewstv/Protocol$Frame;

    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J

    move-result-wide v5

    invoke-virtual {v0, v5, v6}, Lru/oopssre/imperialschool/viewstv/Protocol$Frame;->stale(J)Z

    move-result v0

    if-eqz v0, :cond_1

    const-string v1, "\u0414\u0430\u043d\u043d\u044b\u0435 \u043a\u0430\u0434\u0440\u0430 \u043f\u0440\u043e\u0441\u0440\u043e\u0447\u0435\u043d\u044b"

    :cond_1
    invoke-virtual {v2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    :goto_0
    invoke-virtual {v4, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    const-string v1, "\n\u041f\u0440\u043e\u0432\u0435\u0440\u043a\u0430 \u043f\u0443\u0431\u043b\u0438\u043a\u0430\u0446\u0438\u0438: "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    iget-object v1, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->videoController:Lru/oopssre/imperialschool/viewstv/VideoController;

    iget-object v1, v1, Lru/oopssre/imperialschool/viewstv/VideoController;->status:Ljava/lang/String;

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    const-string v1, "\n\u0421\u043b\u0435\u0434\u0443\u044e\u0449\u0430\u044f \u043f\u0440\u043e\u0432\u0435\u0440\u043a\u0430: "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    iget-object v1, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->videoController:Lru/oopssre/imperialschool/viewstv/VideoController;

    iget-wide v1, v1, Lru/oopssre/imperialschool/viewstv/VideoController;->nextCheckAt:J

    const-wide/16 v3, 0x0

    cmp-long v1, v1, v3

    if-lez v1, :cond_2

    iget-object v1, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->videoController:Lru/oopssre/imperialschool/viewstv/VideoController;

    iget-wide v1, v1, Lru/oopssre/imperialschool/viewstv/VideoController;->nextCheckAt:J

    invoke-virtual {p0, v1, v2}, Lru/oopssre/imperialschool/viewstv/TvScene;->date(J)Ljava/lang/String;

    move-result-object v1

    goto :goto_1

    :cond_2
    const-string v1, "\u0441\u0435\u0439\u0447\u0430\u0441"

    :goto_1
    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    const-string v1, "\n\u041a\u0435\u0448: "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    iget-object v1, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->context:Landroid/content/Context;

    invoke-virtual {v1}, Landroid/content/Context;->getCacheDir()Ljava/io/File;

    move-result-object v1

    invoke-static {v1}, Lru/oopssre/imperialschool/viewstv/CacheStore;->directoryBytes(Ljava/io/File;)J

    move-result-wide v1

    invoke-virtual {p0, v1, v2}, Lru/oopssre/imperialschool/viewstv/TvScene;->mb(J)Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    return-object v0

    .line 293
    :cond_3
    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->controller:Lru/oopssre/imperialschool/viewstv/SceneController;

    iget-object v0, v0, Lru/oopssre/imperialschool/viewstv/SceneController;->frame:Lru/oopssre/imperialschool/viewstv/Protocol$Frame;

    new-instance v9, Ljava/lang/StringBuilder;

    const-string v10, "\u041a\u043e\u043b\u043b\u0435\u043a\u0446\u0438\u044f: "

    invoke-direct {v9, v10}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    iget-object v10, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->repo:Lru/oopssre/imperialschool/viewstv/Repository;

    invoke-virtual {v10}, Lru/oopssre/imperialschool/viewstv/Repository;->selected()Lru/oopssre/imperialschool/viewstv/Protocol$Theme;

    move-result-object v10

    iget-object v10, v10, Lru/oopssre/imperialschool/viewstv/Protocol$Theme;->title:Ljava/lang/String;

    invoke-virtual {v9, v10}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v9

    const-string v10, "\n\u0420\u0435\u0436\u0438\u043c: "

    invoke-virtual {v9, v10}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v9

    iget-object v10, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->repo:Lru/oopssre/imperialschool/viewstv/Repository;

    invoke-virtual {v10}, Lru/oopssre/imperialschool/viewstv/Repository;->resolution()Ljava/lang/String;

    move-result-object v10

    invoke-static {v10}, Lru/oopssre/imperialschool/viewstv/TvDisplay;->label(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v10

    invoke-virtual {v9, v10}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v9

    invoke-virtual {v9, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v6

    iget-object v9, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->detectedSize:[I

    aget v5, v9, v5

    invoke-virtual {v6, v5}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v5

    invoke-virtual {v5, v8}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v5

    iget-object v6, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->detectedSize:[I

    aget v4, v6, v4

    invoke-virtual {v5, v4}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v4

    const-string v5, "\n\u0417\u0430\u043f\u0440\u043e\u0448\u0435\u043d\u043d\u044b\u0439 \u043f\u0440\u043e\u0444\u0438\u043b\u044c: "

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v4

    iget-object v5, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->repo:Lru/oopssre/imperialschool/viewstv/Repository;

    invoke-virtual {v5}, Lru/oopssre/imperialschool/viewstv/Repository;->selected()Lru/oopssre/imperialschool/viewstv/Protocol$Theme;

    move-result-object v5

    iget-object v5, v5, Lru/oopssre/imperialschool/viewstv/Protocol$Theme;->device:Ljava/lang/String;

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v4

    const-string v5, "\n\u0411\u0443\u0444\u0435\u0440 \u0437\u0430\u043f\u0440\u043e\u0448\u0435\u043d: "

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v4

    iget-object v5, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->surface:Lru/oopssre/imperialschool/viewstv/WallpaperSurface;

    iget v5, v5, Lru/oopssre/imperialschool/viewstv/WallpaperSurface;->bufferWidth:I

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v4

    invoke-virtual {v4, v8}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v4

    iget-object v5, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->surface:Lru/oopssre/imperialschool/viewstv/WallpaperSurface;

    iget v5, v5, Lru/oopssre/imperialschool/viewstv/WallpaperSurface;->bufferHeight:I

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v4

    const-string v5, "\n\u0411\u0443\u0444\u0435\u0440 \u0444\u0430\u043a\u0442\u0438\u0447\u0435\u0441\u043a\u0438: "

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v4

    iget-object v5, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->surface:Lru/oopssre/imperialschool/viewstv/WallpaperSurface;

    iget v5, v5, Lru/oopssre/imperialschool/viewstv/WallpaperSurface;->actualWidth:I

    if-lez v5, :cond_4

    new-instance v5, Ljava/lang/StringBuilder;

    invoke-direct {v5}, Ljava/lang/StringBuilder;-><init>()V

    iget-object v6, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->surface:Lru/oopssre/imperialschool/viewstv/WallpaperSurface;

    iget v6, v6, Lru/oopssre/imperialschool/viewstv/WallpaperSurface;->actualWidth:I

    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v5

    invoke-virtual {v5, v8}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v5

    iget-object v6, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->surface:Lru/oopssre/imperialschool/viewstv/WallpaperSurface;

    iget v6, v6, Lru/oopssre/imperialschool/viewstv/WallpaperSurface;->actualHeight:I

    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v5

    invoke-virtual {v5}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v5

    goto :goto_2

    :cond_4
    const-string v5, "\u0435\u0449\u0451 \u043d\u0435 \u0441\u043e\u0437\u0434\u0430\u043d"

    :goto_2
    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v4

    invoke-virtual {v4}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v4

    .line 294
    iget-object v5, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->surface:Lru/oopssre/imperialschool/viewstv/WallpaperSurface;

    iget-object v5, v5, Lru/oopssre/imperialschool/viewstv/WallpaperSurface;->image:Landroid/graphics/Bitmap;

    if-eqz v5, :cond_5

    iget-object v5, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->surface:Lru/oopssre/imperialschool/viewstv/WallpaperSurface;

    iget-object v5, v5, Lru/oopssre/imperialschool/viewstv/WallpaperSurface;->image:Landroid/graphics/Bitmap;

    invoke-virtual {v5}, Landroid/graphics/Bitmap;->isRecycled()Z

    move-result v5

    if-nez v5, :cond_5

    new-instance v5, Ljava/lang/StringBuilder;

    invoke-direct {v5}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v5, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v4

    const-string v5, "\n\u0418\u0437\u043e\u0431\u0440\u0430\u0436\u0435\u043d\u0438\u0435 \u0432 \u043f\u0430\u043c\u044f\u0442\u0438: "

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v4

    iget-object v5, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->surface:Lru/oopssre/imperialschool/viewstv/WallpaperSurface;

    iget-object v5, v5, Lru/oopssre/imperialschool/viewstv/WallpaperSurface;->image:Landroid/graphics/Bitmap;

    invoke-virtual {v5}, Landroid/graphics/Bitmap;->getWidth()I

    move-result v5

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v4

    invoke-virtual {v4, v8}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v4

    iget-object v5, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->surface:Lru/oopssre/imperialschool/viewstv/WallpaperSurface;

    iget-object v5, v5, Lru/oopssre/imperialschool/viewstv/WallpaperSurface;->image:Landroid/graphics/Bitmap;

    invoke-virtual {v5}, Landroid/graphics/Bitmap;->getHeight()I

    move-result v5

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v4

    invoke-virtual {v4}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v4

    :cond_5
    new-instance v5, Ljava/lang/StringBuilder;

    invoke-direct {v5}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v5, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v4

    const-string v5, "\n\n"

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v4

    iget-object v5, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->status:Ljava/lang/String;

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v4

    invoke-virtual {v4}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v4

    if-eqz v0, :cond_7

    .line 295
    new-instance v5, Ljava/lang/StringBuilder;

    invoke-direct {v5}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v5, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v4

    const-string v5, "\n\n\u041f\u043e\u043a\u0430\u0437\u0430\u043d\u043d\u044b\u0439 \u043f\u0440\u043e\u0444\u0438\u043b\u044c: "

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v4

    iget-object v5, v0, Lru/oopssre/imperialschool/viewstv/Protocol$Frame;->device:Ljava/lang/String;

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v4

    const-string v5, "\n\u0424\u0430\u0439\u043b: "

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v4

    iget-object v5, v0, Lru/oopssre/imperialschool/viewstv/Protocol$Frame;->format:Ljava/lang/String;

    sget-object v6, Ljava/util/Locale;->ROOT:Ljava/util/Locale;

    invoke-virtual {v5, v6}, Ljava/lang/String;->toUpperCase(Ljava/util/Locale;)Ljava/lang/String;

    move-result-object v5

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v4

    const-string v5, " \u00b7 "

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v4

    iget v5, v0, Lru/oopssre/imperialschool/viewstv/Protocol$Frame;->width:I

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v4

    invoke-virtual {v4, v8}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v4

    iget v5, v0, Lru/oopssre/imperialschool/viewstv/Protocol$Frame;->height:I

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v4

    invoke-virtual {v4, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v3

    iget-wide v4, v0, Lru/oopssre/imperialschool/viewstv/Protocol$Frame;->at:J

    invoke-virtual {p0, v4, v5}, Lru/oopssre/imperialschool/viewstv/TvScene;->date(J)Ljava/lang/String;

    move-result-object v4

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v3

    invoke-virtual {v3, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    iget-wide v3, v0, Lru/oopssre/imperialschool/viewstv/Protocol$Frame;->until:J

    invoke-virtual {p0, v3, v4}, Lru/oopssre/imperialschool/viewstv/TvScene;->date(J)Ljava/lang/String;

    move-result-object v3

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {v2, v7}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J

    move-result-wide v3

    invoke-virtual {v0, v3, v4}, Lru/oopssre/imperialschool/viewstv/Protocol$Frame;->stale(J)Z

    move-result v0

    if-eqz v0, :cond_6

    const-string v1, "\u041f\u043e\u043a\u0430\u0437\u0430\u043d \u043f\u043e\u0441\u043b\u0435\u0434\u043d\u0438\u0439 \u043a\u0430\u0434\u0440; \u043e\u0431\u043d\u043e\u0432\u043b\u0435\u043d\u0438\u0435 \u0437\u0430\u0434\u0435\u0440\u0436\u0438\u0432\u0430\u0435\u0442\u0441\u044f"

    :cond_6
    invoke-virtual {v2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v4

    .line 296
    :cond_7
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v0, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    const-string v1, "\n\n\u041a\u0435\u0448: "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    iget-object v1, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->context:Landroid/content/Context;

    invoke-virtual {v1}, Landroid/content/Context;->getCacheDir()Ljava/io/File;

    move-result-object v1

    invoke-static {v1}, Lru/oopssre/imperialschool/viewstv/CacheStore;->directoryBytes(Ljava/io/File;)J

    move-result-wide v1

    invoke-virtual {p0, v1, v2}, Lru/oopssre/imperialschool/viewstv/TvScene;->mb(J)Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    return-object v0
.end method

.method dp(I)I
    .locals 1

    int-to-float p1, p1

    .line 62
    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->context:Landroid/content/Context;

    invoke-virtual {v0}, Landroid/content/Context;->getResources()Landroid/content/res/Resources;

    move-result-object v0

    invoke-virtual {v0}, Landroid/content/res/Resources;->getDisplayMetrics()Landroid/util/DisplayMetrics;

    move-result-object v0

    iget v0, v0, Landroid/util/DisplayMetrics;->density:F

    mul-float/2addr p1, v0

    invoke-static {p1}, Ljava/lang/Math;->round(F)I

    move-result p1

    return p1
.end method

.method enterPersonalCode()V
    .locals 4

    .line 249
    new-instance v0, Landroid/widget/EditText;

    iget-object v1, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->context:Landroid/content/Context;

    invoke-direct {v0, v1}, Landroid/widget/EditText;-><init>(Landroid/content/Context;)V

    .line 250
    invoke-virtual {v0}, Landroid/widget/EditText;->setSingleLine()V

    const/16 v1, 0x12

    invoke-virtual {v0, v1}, Landroid/widget/EditText;->setInputType(I)V

    .line 251
    new-instance v1, Landroid/app/AlertDialog$Builder;

    iget-object v2, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->context:Landroid/content/Context;

    invoke-direct {v1, v2}, Landroid/app/AlertDialog$Builder;-><init>(Landroid/content/Context;)V

    const-string v2, "\u041a\u043e\u0434 \u043b\u0438\u0447\u043d\u043e\u0433\u043e \u0440\u0435\u0436\u0438\u043c\u0430"

    invoke-virtual {v1, v2}, Landroid/app/AlertDialog$Builder;->setTitle(Ljava/lang/CharSequence;)Landroid/app/AlertDialog$Builder;

    move-result-object v1

    invoke-virtual {v1, v0}, Landroid/app/AlertDialog$Builder;->setView(Landroid/view/View;)Landroid/app/AlertDialog$Builder;

    move-result-object v1

    const-string v2, "\u041e\u0442\u043c\u0435\u043d\u0430"

    const/4 v3, 0x0

    .line 252
    invoke-virtual {v1, v2, v3}, Landroid/app/AlertDialog$Builder;->setNegativeButton(Ljava/lang/CharSequence;Landroid/content/DialogInterface$OnClickListener;)Landroid/app/AlertDialog$Builder;

    move-result-object v1

    new-instance v2, Lru/oopssre/imperialschool/viewstv/TvScene$$ExternalSyntheticLambda21;

    invoke-direct {v2, p0, v0}, Lru/oopssre/imperialschool/viewstv/TvScene$$ExternalSyntheticLambda21;-><init>(Lru/oopssre/imperialschool/viewstv/TvScene;Landroid/widget/EditText;)V

    const-string v0, "\u0412\u043a\u043b\u044e\u0447\u0438\u0442\u044c"

    invoke-virtual {v1, v0, v2}, Landroid/app/AlertDialog$Builder;->setPositiveButton(Ljava/lang/CharSequence;Landroid/content/DialogInterface$OnClickListener;)Landroid/app/AlertDialog$Builder;

    move-result-object v0

    .line 256
    invoke-virtual {v0}, Landroid/app/AlertDialog$Builder;->show()Landroid/app/AlertDialog;

    return-void
.end method

.method focusFirst()V
    .locals 1

    const/4 v0, 0x0

    .line 86
    invoke-virtual {p0, v0}, Lru/oopssre/imperialschool/viewstv/TvScene;->focusFirst(Ljava/lang/String;)V

    return-void
.end method

.method focusFirst(Ljava/lang/String;)V
    .locals 3

    .line 87
    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->page:Ljava/lang/String;

    iget-object v1, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->focusMemory:Ljava/util/Map;

    invoke-interface {v1, v0}, Ljava/util/Map;->containsKey(Ljava/lang/Object;)Z

    move-result v1

    if-eqz v1, :cond_0

    iget-object p1, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->focusMemory:Ljava/util/Map;

    iget-object v1, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->page:Ljava/lang/String;

    invoke-interface {p1, v1}, Ljava/util/Map;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object p1

    check-cast p1, Ljava/lang/String;

    .line 88
    :cond_0
    iget-object v1, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->panel:Landroid/widget/ScrollView;

    new-instance v2, Lru/oopssre/imperialschool/viewstv/TvScene$$ExternalSyntheticLambda17;

    invoke-direct {v2, p0, v0, p1}, Lru/oopssre/imperialschool/viewstv/TvScene$$ExternalSyntheticLambda17;-><init>(Lru/oopssre/imperialschool/viewstv/TvScene;Ljava/lang/String;Ljava/lang/String;)V

    invoke-virtual {v1, v2}, Landroid/widget/ScrollView;->post(Ljava/lang/Runnable;)Z

    return-void
.end method

.method focusKey(Ljava/lang/String;)Ljava/lang/String;
    .locals 2

    .line 75
    const-string v0, "\u2713 "

    invoke-virtual {p1, v0}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z

    move-result v0

    if-eqz v0, :cond_0

    const/4 v0, 0x2

    invoke-virtual {p1, v0}, Ljava/lang/String;->substring(I)Ljava/lang/String;

    move-result-object p1

    :cond_0
    const-string v0, " \u00b7 "

    invoke-virtual {p1, v0}, Ljava/lang/String;->indexOf(Ljava/lang/String;)I

    move-result v0

    if-ltz v0, :cond_1

    const/4 v1, 0x0

    invoke-virtual {p1, v1, v0}, Ljava/lang/String;->substring(II)Ljava/lang/String;

    move-result-object p1

    :cond_1
    return-object p1
.end method

.method public frame(Lru/oopssre/imperialschool/viewstv/Protocol$Frame;)V
    .locals 3

    .line 302
    invoke-virtual {p0}, Lru/oopssre/imperialschool/viewstv/TvScene;->videoEnabled()Z

    move-result v0

    if-eqz v0, :cond_0

    return-void

    :cond_0
    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->placeholder:Landroid/widget/TextView;

    const/16 v1, 0x8

    invoke-virtual {v0, v1}, Landroid/widget/TextView;->setVisibility(I)V

    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J

    move-result-wide v0

    invoke-virtual {p1, v0, v1}, Lru/oopssre/imperialschool/viewstv/Protocol$Frame;->stale(J)Z

    move-result v0

    if-eqz v0, :cond_1

    const-string p1, "\u041e\u0431\u043d\u043e\u0432\u043b\u0435\u043d\u0438\u0435 \u0437\u0430\u0434\u0435\u0440\u0436\u0438\u0432\u0430\u0435\u0442\u0441\u044f"

    goto :goto_0

    :cond_1
    new-instance v0, Ljava/lang/StringBuilder;

    const-string v1, "\u041e\u0431\u043e\u0438 \u043e\u0431\u043d\u043e\u0432\u043b\u0435\u043d\u044b \u00b7 "

    invoke-direct {v0, v1}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    iget-wide v1, p1, Lru/oopssre/imperialschool/viewstv/Protocol$Frame;->at:J

    invoke-virtual {p0, v1, v2}, Lru/oopssre/imperialschool/viewstv/TvScene;->date(J)Ljava/lang/String;

    move-result-object p1

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p1

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    :goto_0
    iput-object p1, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->status:Ljava/lang/String;

    invoke-virtual {p0}, Lru/oopssre/imperialschool/viewstv/TvScene;->refreshDetails()V

    invoke-virtual {p0}, Lru/oopssre/imperialschool/viewstv/TvScene;->refreshDiagnostics()V

    return-void
.end method

.method handle(Landroid/view/KeyEvent;)Z
    .locals 8

    .line 126
    invoke-virtual {p1}, Landroid/view/KeyEvent;->getKeyCode()I

    move-result v0

    const/4 v1, 0x4
    if-eq v0, v1, :keep_back_gate
    const/16 v1, 0x6f
    if-eq v0, v1, :keep_back_gate
    invoke-virtual {p1}, Landroid/view/KeyEvent;->getAction()I
    move-result v1
    if-nez v1, :keep_back_gate
    invoke-direct {p0}, Lru/oopssre/imperialschool/viewstv/TvScene;->resetExitBack()V

    :keep_back_gate
    .line 127
    invoke-virtual {p0}, Lru/oopssre/imperialschool/viewstv/TvScene;->musicAvailable()Z

    move-result v1

    const/4 v2, 0x0

    const/4 v3, 0x1

    if-eqz v1, :cond_6

    const/16 v1, 0x58

    const/16 v4, 0x57

    const/16 v5, 0x7e

    const/16 v6, 0x55

    if-eq v0, v6, :cond_0

    if-eq v0, v5, :cond_0

    const/16 v7, 0x7f

    if-eq v0, v7, :cond_0

    if-eq v0, v4, :cond_0

    if-ne v0, v1, :cond_6

    :cond_0
    iget-boolean v7, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->cacheBusy:Z

    if-nez v7, :cond_5

    invoke-virtual {p1}, Landroid/view/KeyEvent;->getAction()I

    move-result v7

    if-nez v7, :cond_5

    invoke-virtual {p1}, Landroid/view/KeyEvent;->getRepeatCount()I

    move-result p1

    if-nez p1, :cond_5

    iget-object p1, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->music:Lru/oopssre/imperialschool/viewstv/SceneMusic;

    if-ne v0, v4, :cond_1

    invoke-virtual {p1}, Lru/oopssre/imperialschool/viewstv/SceneMusic;->next()V

    goto :goto_0

    :cond_1
    if-ne v0, v1, :cond_2

    invoke-virtual {p1}, Lru/oopssre/imperialschool/viewstv/SceneMusic;->previous()V

    goto :goto_0

    :cond_2
    if-eq v0, v5, :cond_3

    if-ne v0, v6, :cond_4

    invoke-virtual {p1}, Lru/oopssre/imperialschool/viewstv/SceneMusic;->enabled()Z

    move-result v0

    if-nez v0, :cond_4

    :cond_3
    move v2, v3

    :cond_4
    invoke-virtual {p1, v2}, Lru/oopssre/imperialschool/viewstv/SceneMusic;->enabled(Z)V

    :cond_5
    :goto_0
    return v3

    :cond_6
    const/16 v1, 0x17

    if-eq v0, v1, :cond_8

    const/16 v1, 0x42

    if-eq v0, v1, :cond_8

    const/16 v1, 0xa0

    if-ne v0, v1, :cond_7

    goto :goto_1

    :cond_7
    move v1, v2

    goto :goto_2

    :cond_8
    :goto_1
    move v1, v3

    :goto_2
    if-eqz v1, :cond_a

    .line 129
    iget-object v4, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->hold:Lru/oopssre/imperialschool/viewstv/HoldGate;

    invoke-virtual {v4}, Lru/oopssre/imperialschool/viewstv/HoldGate;->pressed()Z

    move-result v4

    if-eqz v4, :cond_a

    invoke-virtual {p1}, Landroid/view/KeyEvent;->getAction()I

    move-result p1

    if-ne p1, v3, :cond_9

    iget-object p1, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->handler:Landroid/os/Handler;

    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->held:Ljava/lang/Runnable;

    invoke-virtual {p1, v0}, Landroid/os/Handler;->removeCallbacks(Ljava/lang/Runnable;)V

    iget-object p1, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->hold:Lru/oopssre/imperialschool/viewstv/HoldGate;

    invoke-virtual {p1}, Lru/oopssre/imperialschool/viewstv/HoldGate;->release()V

    :cond_9
    return v3

    :cond_a
    if-eqz v1, :cond_c

    .line 130
    iget-object v1, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->panel:Landroid/widget/ScrollView;

    invoke-virtual {v1}, Landroid/widget/ScrollView;->getVisibility()I

    move-result v1

    if-eqz v1, :cond_c

    invoke-virtual {p1}, Landroid/view/KeyEvent;->getAction()I

    move-result v0

    if-nez v0, :cond_b

    invoke-virtual {p1}, Landroid/view/KeyEvent;->getRepeatCount()I

    move-result p1

    if-nez p1, :cond_b

    iget-object p1, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->hold:Lru/oopssre/imperialschool/viewstv/HoldGate;

    invoke-static {}, Landroid/os/SystemClock;->uptimeMillis()J

    move-result-wide v0

    invoke-virtual {p1, v0, v1}, Lru/oopssre/imperialschool/viewstv/HoldGate;->down(J)V

    iget-object p1, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->handler:Landroid/os/Handler;

    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->held:Ljava/lang/Runnable;

    const-wide/16 v1, 0x3e8

    invoke-virtual {p1, v0, v1, v2}, Landroid/os/Handler;->postDelayed(Ljava/lang/Runnable;J)Z

    :cond_b
    return v3

    :cond_c
    const/4 v1, 0x4

    if-eq v0, v1, :cond_e

    const/16 v1, 0x6f

    if-ne v0, v1, :cond_d

    goto :goto_3

    :cond_d
    return v2

    .line 131
    :cond_e
    :goto_3
    invoke-virtual {p1}, Landroid/view/KeyEvent;->getAction()I

    move-result v0

    if-nez v0, :cond_f

    invoke-virtual {p1}, Landroid/view/KeyEvent;->getRepeatCount()I

    move-result p1

    if-nez p1, :cond_f

    invoke-virtual {p0}, Lru/oopssre/imperialschool/viewstv/TvScene;->back()V

    :cond_f
    return v3
.end method

.method heading(Ljava/lang/String;)V
    .locals 2

    const/16 v0, 0x1a

    .line 92
    invoke-virtual {p0, p1, v0}, Lru/oopssre/imperialschool/viewstv/TvScene;->text(Ljava/lang/String;I)Landroid/widget/TextView;

    move-result-object p1

    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->context:Landroid/content/Context;

    invoke-virtual {v0}, Landroid/content/Context;->getResources()Landroid/content/res/Resources;

    move-result-object v0

    sget v1, Lru/oopssre/imperialschool/viewstv/R$font;->oswald_semibold:I

    invoke-virtual {v0, v1}, Landroid/content/res/Resources;->getFont(I)Landroid/graphics/Typeface;

    move-result-object v0

    invoke-virtual {p1, v0}, Landroid/widget/TextView;->setTypeface(Landroid/graphics/Typeface;)V

    const/16 v0, 0x12

    invoke-virtual {p0, v0}, Lru/oopssre/imperialschool/viewstv/TvScene;->dp(I)I

    move-result v0

    const/4 v1, 0x0

    invoke-virtual {p1, v1, v1, v1, v0}, Landroid/widget/TextView;->setPadding(IIII)V

    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->content:Landroid/widget/LinearLayout;

    invoke-virtual {v0, p1}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    return-void
.end method

.method imagePin()Ljava/lang/String;
    .locals 1

    .line 101
    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->controller:Lru/oopssre/imperialschool/viewstv/SceneController;

    iget-object v0, v0, Lru/oopssre/imperialschool/viewstv/SceneController;->frame:Lru/oopssre/imperialschool/viewstv/Protocol$Frame;

    if-nez v0, :cond_0

    const-string v0, ""

    return-object v0

    :cond_0
    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->controller:Lru/oopssre/imperialschool/viewstv/SceneController;

    iget-object v0, v0, Lru/oopssre/imperialschool/viewstv/SceneController;->frame:Lru/oopssre/imperialschool/viewstv/Protocol$Frame;

    iget-object v0, v0, Lru/oopssre/imperialschool/viewstv/Protocol$Frame;->sha:Ljava/lang/String;

    return-object v0
.end method

.method info()V
    .locals 5

    .line 191
    const-string v0, "info"

    const-string v1, "\u041e \u043f\u0440\u0438\u043b\u043e\u0436\u0435\u043d\u0438\u0438"

    invoke-virtual {p0, v0, v1}, Lru/oopssre/imperialschool/viewstv/TvScene;->beginPage(Ljava/lang/String;Ljava/lang/String;)V

    const-string v0, "0.8.7"

    :try_start_0
    iget-object v1, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->context:Landroid/content/Context;

    invoke-virtual {v1}, Landroid/content/Context;->getPackageManager()Landroid/content/pm/PackageManager;

    move-result-object v1

    iget-object v2, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->context:Landroid/content/Context;

    invoke-virtual {v2}, Landroid/content/Context;->getPackageName()Ljava/lang/String;

    move-result-object v2

    const/4 v3, 0x0

    invoke-virtual {v1, v2, v3}, Landroid/content/pm/PackageManager;->getPackageInfo(Ljava/lang/String;I)Landroid/content/pm/PackageInfo;

    move-result-object v1

    iget-object v0, v1, Landroid/content/pm/PackageInfo;->versionName:Ljava/lang/String;

    sget v2, Landroid/os/Build$VERSION;->SDK_INT:I

    const/16 v3, 0x1c

    if-lt v2, v3, :cond_0

    invoke-virtual {v1}, Landroid/content/pm/PackageInfo;->getLongVersionCode()J

    move-result-wide v1

    goto :goto_0

    :cond_0
    iget v1, v1, Landroid/content/pm/PackageInfo;->versionCode:I
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    int-to-long v1, v1

    goto :goto_0

    :catch_0
    const-wide/16 v1, 0x14

    .line 192
    :goto_0
    new-instance v3, Ljava/lang/StringBuilder;

    const-string v4, "\u0412\u0438\u0434\u044b \u0428\u043a\u043e\u043b\u044b \u0418\u043c\u043f\u0435\u0440\u0438\u0438 TV\n\u0412\u0435\u0440\u0441\u0438\u044f "

    invoke-direct {v3, v4}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v3, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    const-string v3, " \u00b7 \u0441\u0431\u043e\u0440\u043a\u0430 "

    invoke-virtual {v0, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0, v1, v2}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    move-result-object v0

    const-string v1, "\n\n\u0414\u043c\u0438\u0442\u0440\u0438\u0439 \u041c\u0430\u043b\u044b\u0445\u0438\u043d aka Timon_Crazy"

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p0, v0}, Lru/oopssre/imperialschool/viewstv/TvScene;->message(Ljava/lang/String;)V

    .line 193
    new-instance v0, Lru/oopssre/imperialschool/viewstv/TvScene$$ExternalSyntheticLambda8;

    invoke-direct {v0, p0}, Lru/oopssre/imperialschool/viewstv/TvScene$$ExternalSyntheticLambda8;-><init>(Lru/oopssre/imperialschool/viewstv/TvScene;)V

    const-string v1, "\u0421\u0430\u0439\u0442 \u043f\u0440\u043e\u0435\u043a\u0442\u0430"

    invoke-virtual {p0, v1, v0}, Lru/oopssre/imperialschool/viewstv/TvScene;->button(Ljava/lang/String;Ljava/lang/Runnable;)Landroid/widget/Button;

    new-instance v0, Lru/oopssre/imperialschool/viewstv/TvScene$$ExternalSyntheticLambda9;

    invoke-direct {v0, p0}, Lru/oopssre/imperialschool/viewstv/TvScene$$ExternalSyntheticLambda9;-><init>(Lru/oopssre/imperialschool/viewstv/TvScene;)V

    const-string v1, "\u0418\u0441\u0445\u043e\u0434\u043d\u044b\u0439 \u043a\u043e\u0434"

    invoke-virtual {p0, v1, v0}, Lru/oopssre/imperialschool/viewstv/TvScene;->button(Ljava/lang/String;Ljava/lang/Runnable;)Landroid/widget/Button;

    .line 194
    new-instance v0, Lru/oopssre/imperialschool/viewstv/TvScene$$ExternalSyntheticLambda10;

    invoke-direct {v0, p0}, Lru/oopssre/imperialschool/viewstv/TvScene$$ExternalSyntheticLambda10;-><init>(Lru/oopssre/imperialschool/viewstv/TvScene;)V

    const-string v1, "\u041e\u0431\u043d\u043e\u0432\u043b\u0435\u043d\u0438\u0435 \u043f\u0440\u0438\u043b\u043e\u0436\u0435\u043d\u0438\u044f"

    invoke-virtual {p0, v1, v0}, Lru/oopssre/imperialschool/viewstv/TvScene;->button(Ljava/lang/String;Ljava/lang/Runnable;)Landroid/widget/Button;

    new-instance v0, Lru/oopssre/imperialschool/viewstv/TvScene$$ExternalSyntheticLambda12;

    invoke-direct {v0, p0}, Lru/oopssre/imperialschool/viewstv/TvScene$$ExternalSyntheticLambda12;-><init>(Lru/oopssre/imperialschool/viewstv/TvScene;)V

    const-string v1, "\u041c\u0443\u0437\u044b\u043a\u0430 \u0438 \u0430\u0432\u0442\u043e\u0440\u044b"

    invoke-virtual {p0, v1, v0}, Lru/oopssre/imperialschool/viewstv/TvScene;->button(Ljava/lang/String;Ljava/lang/Runnable;)Landroid/widget/Button;

    new-instance v0, Lru/oopssre/imperialschool/viewstv/TvScene$$ExternalSyntheticLambda13;

    invoke-direct {v0, p0}, Lru/oopssre/imperialschool/viewstv/TvScene$$ExternalSyntheticLambda13;-><init>(Lru/oopssre/imperialschool/viewstv/TvScene;)V

    const-string v1, "\u0414\u0438\u0430\u0433\u043d\u043e\u0441\u0442\u0438\u043a\u0430"

    invoke-virtual {p0, v1, v0}, Lru/oopssre/imperialschool/viewstv/TvScene;->button(Ljava/lang/String;Ljava/lang/Runnable;)Landroid/widget/Button;

    invoke-virtual {p0}, Lru/oopssre/imperialschool/viewstv/TvScene;->focusFirst()V

    return-void
.end method

.method install()V
    .locals 5

    const-string v0, "package:"

    .line 306
    :try_start_0
    iget-object v1, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->updater:Lru/oopssre/imperialschool/viewstv/Updater;

    invoke-virtual {v1}, Lru/oopssre/imperialschool/viewstv/Updater;->ready()Lru/oopssre/imperialschool/viewstv/Release;

    move-result-object v1

    if-nez v1, :cond_0

    const/4 v0, 0x0

    iput-object v0, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->ready:Lru/oopssre/imperialschool/viewstv/Release;

    const-string v0, "\u041f\u0440\u043e\u0432\u0435\u0440\u044c\u0442\u0435 \u043e\u0431\u043d\u043e\u0432\u043b\u0435\u043d\u0438\u0435 \u0435\u0449\u0451 \u0440\u0430\u0437"

    iput-object v0, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->updateStatus:Ljava/lang/String;

    invoke-virtual {p0}, Lru/oopssre/imperialschool/viewstv/TvScene;->updatesMenu()V

    return-void

    :cond_0
    iget-object v1, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->context:Landroid/content/Context;

    invoke-virtual {v1}, Landroid/content/Context;->getPackageManager()Landroid/content/pm/PackageManager;

    move-result-object v1

    invoke-virtual {v1}, Landroid/content/pm/PackageManager;->canRequestPackageInstalls()Z

    move-result v1

    if-nez v1, :cond_1

    const/4 v1, 0x1

    iput-boolean v1, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->pendingInstall:Z

    iget-object v1, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->host:Lru/oopssre/imperialschool/viewstv/TvScene$Host;

    new-instance v2, Landroid/content/Intent;

    const-string v3, "android.settings.MANAGE_UNKNOWN_APP_SOURCES"

    new-instance v4, Ljava/lang/StringBuilder;

    invoke-direct {v4, v0}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->context:Landroid/content/Context;

    invoke-virtual {v0}, Landroid/content/Context;->getPackageName()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {v4, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-static {v0}, Landroid/net/Uri;->parse(Ljava/lang/String;)Landroid/net/Uri;

    move-result-object v0

    invoke-direct {v2, v3, v0}, Landroid/content/Intent;-><init>(Ljava/lang/String;Landroid/net/Uri;)V

    const/high16 v0, 0x10000000

    invoke-virtual {v2, v0}, Landroid/content/Intent;->addFlags(I)Landroid/content/Intent;

    move-result-object v0

    invoke-interface {v1, v0}, Lru/oopssre/imperialschool/viewstv/TvScene$Host;->launch(Landroid/content/Intent;)V

    return-void

    :cond_1
    const/4 v0, 0x0

    iput-boolean v0, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->pendingInstall:Z

    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->host:Lru/oopssre/imperialschool/viewstv/TvScene$Host;

    iget-object v1, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->updater:Lru/oopssre/imperialschool/viewstv/Updater;

    invoke-virtual {v1}, Lru/oopssre/imperialschool/viewstv/Updater;->installer()Landroid/content/Intent;

    move-result-object v1

    invoke-interface {v0, v1}, Lru/oopssre/imperialschool/viewstv/TvScene$Host;->launch(Landroid/content/Intent;)V
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    return-void

    :catch_0
    const-string v0, "\u041d\u0435 \u0443\u0434\u0430\u043b\u043e\u0441\u044c \u043e\u0442\u043a\u0440\u044b\u0442\u044c \u0443\u0441\u0442\u0430\u043d\u043e\u0432\u0449\u0438\u043a"

    iput-object v0, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->updateStatus:Ljava/lang/String;

    invoke-virtual {p0}, Lru/oopssre/imperialschool/viewstv/TvScene;->refreshDetails()V

    return-void
.end method

.method synthetic lambda$checkUpdate$38$ru-oopssre-imperialschool-viewstv-TvScene(JLru/oopssre/imperialschool/viewstv/Release;Ljava/lang/String;)V
    .locals 2

    .line 305
    iget-boolean v0, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->destroyed:Z

    if-nez v0, :cond_1

    iget-wide v0, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->updateGeneration:J

    cmp-long p1, p1, v0

    if-eqz p1, :cond_0

    goto :goto_0

    :cond_0
    const/4 p1, 0x0

    iput-boolean p1, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->updateBusy:Z

    iput-object p3, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->ready:Lru/oopssre/imperialschool/viewstv/Release;

    iput-object p4, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->updateStatus:Ljava/lang/String;

    iget-boolean p1, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->active:Z

    if-eqz p1, :cond_1

    iget-object p1, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->page:Ljava/lang/String;

    const-string p2, "updates"

    invoke-virtual {p1, p2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p1

    if-eqz p1, :cond_1

    iget-object p1, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->panel:Landroid/widget/ScrollView;

    invoke-virtual {p1}, Landroid/widget/ScrollView;->getVisibility()I

    move-result p1

    if-nez p1, :cond_1

    invoke-virtual {p0}, Lru/oopssre/imperialschool/viewstv/TvScene;->updatesMenu()V

    :cond_1
    :goto_0
    return-void
.end method

.method synthetic lambda$checkUpdate$39$ru-oopssre-imperialschool-viewstv-TvScene(J)V
    .locals 8

    .line 0
    const/4 v1, 0x0

    .line 305
    :try_start_0
    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->updater:Lru/oopssre/imperialschool/viewstv/Updater;

    iget-object v2, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->controller:Lru/oopssre/imperialschool/viewstv/SceneController;

    iget-object v2, v2, Lru/oopssre/imperialschool/viewstv/SceneController;->frame:Lru/oopssre/imperialschool/viewstv/Protocol$Frame;

    if-nez v2, :cond_0

    const-string v2, ""

    goto :goto_0

    :cond_0
    iget-object v2, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->controller:Lru/oopssre/imperialschool/viewstv/SceneController;

    iget-object v2, v2, Lru/oopssre/imperialschool/viewstv/SceneController;->frame:Lru/oopssre/imperialschool/viewstv/Protocol$Frame;

    iget-object v2, v2, Lru/oopssre/imperialschool/viewstv/Protocol$Frame;->sha:Ljava/lang/String;

    :goto_0
    invoke-virtual {v0, v2}, Lru/oopssre/imperialschool/viewstv/Updater;->check(Ljava/lang/String;)Lru/oopssre/imperialschool/viewstv/Release;

    move-result-object v1

    if-nez v1, :cond_1

    const-string v0, "\u0423\u0441\u0442\u0430\u043d\u043e\u0432\u043b\u0435\u043d\u0430 \u043f\u043e\u0441\u043b\u0435\u0434\u043d\u044f\u044f \u0432\u0435\u0440\u0441\u0438\u044f"

    goto :goto_1

    :cond_1
    const-string v0, "\u041e\u0431\u043d\u043e\u0432\u043b\u0435\u043d\u0438\u0435 \u0433\u043e\u0442\u043e\u0432\u043e \u043a \u0443\u0441\u0442\u0430\u043d\u043e\u0432\u043a\u0435"
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    goto :goto_1

    :catch_0
    move-exception v0

    instance-of v2, v0, Lru/oopssre/imperialschool/viewstv/HttpTransport$HttpFailure;

    if-eqz v2, :cond_2

    check-cast v0, Lru/oopssre/imperialschool/viewstv/HttpTransport$HttpFailure;

    iget v0, v0, Lru/oopssre/imperialschool/viewstv/HttpTransport$HttpFailure;->status:I

    const/16 v2, 0x194

    if-ne v0, v2, :cond_2

    const-string v0, "\u041e\u0431\u043d\u043e\u0432\u043b\u0435\u043d\u0438\u0435 \u043f\u043e\u043a\u0430 \u043d\u0435 \u043e\u043f\u0443\u0431\u043b\u0438\u043a\u043e\u0432\u0430\u043d\u043e"

    goto :goto_1

    :cond_2
    const-string v0, "\u041d\u0435 \u0443\u0434\u0430\u043b\u043e\u0441\u044c \u043f\u043e\u043b\u0443\u0447\u0438\u0442\u044c \u043e\u0431\u043d\u043e\u0432\u043b\u0435\u043d\u0438\u0435. \u041f\u043e\u0432\u0442\u043e\u0440\u0438\u0442\u0435 \u043f\u043e\u0437\u0436\u0435."

    :goto_1
    move-object v7, v0

    move-object v6, v1

    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->handler:Landroid/os/Handler;

    new-instance v2, Lru/oopssre/imperialschool/viewstv/TvScene$$ExternalSyntheticLambda15;

    move-object v3, p0

    move-wide v4, p1

    invoke-direct/range {v2 .. v7}, Lru/oopssre/imperialschool/viewstv/TvScene$$ExternalSyntheticLambda15;-><init>(Lru/oopssre/imperialschool/viewstv/TvScene;JLru/oopssre/imperialschool/viewstv/Release;Ljava/lang/String;)V

    invoke-virtual {v0, v2}, Landroid/os/Handler;->post(Ljava/lang/Runnable;)Z

    return-void
.end method

.method synthetic lambda$clearCache$34$ru-oopssre-imperialschool-viewstv-TvScene(Ljava/lang/String;)V
    .locals 2

    .line 282
    iget-boolean v0, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->destroyed:Z

    if-eqz v0, :cond_0

    return-void

    :cond_0
    const/4 v0, 0x0

    iput-boolean v0, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->cacheBusy:Z

    const-string v1, "\u041a\u0435\u0448 \u043e\u0447\u0438\u0449\u0435\u043d"

    invoke-virtual {v1, p1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v1

    if-eqz v1, :cond_1

    iget-object v1, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->music:Lru/oopssre/imperialschool/viewstv/SceneMusic;

    invoke-virtual {v1}, Lru/oopssre/imperialschool/viewstv/SceneMusic;->cacheCleared()V

    :cond_1
    iput-object p1, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->cacheStatus:Ljava/lang/String;

    iget-boolean p1, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->active:Z

    if-eqz p1, :cond_2

    invoke-virtual {p0, v0}, Lru/oopssre/imperialschool/viewstv/TvScene;->refreshResolution(Z)V

    invoke-virtual {p0}, Lru/oopssre/imperialschool/viewstv/TvScene;->resumePlayback()V

    :cond_2
    iget-object p1, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->page:Ljava/lang/String;

    const-string v0, "cache"

    invoke-virtual {p1, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p1

    if-eqz p1, :cond_3

    iget-object p1, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->panel:Landroid/widget/ScrollView;

    invoke-virtual {p1}, Landroid/widget/ScrollView;->getVisibility()I

    move-result p1

    if-nez p1, :cond_3

    invoke-virtual {p0}, Lru/oopssre/imperialschool/viewstv/TvScene;->cacheMenu()V

    return-void

    :cond_3
    invoke-virtual {p0}, Lru/oopssre/imperialschool/viewstv/TvScene;->refreshDetails()V

    return-void
.end method

.method synthetic lambda$clearCache$35$ru-oopssre-imperialschool-viewstv-TvScene(Ljava/util/concurrent/Future;Ljava/util/concurrent/Future;Ljava/util/concurrent/Future;Ljava/util/concurrent/Future;Ljava/util/concurrent/Future;Ljava/util/concurrent/Future;)V
    .locals 3

    .line 281
    :try_start_0
    sget-object v0, Ljava/util/concurrent/TimeUnit;->SECONDS:Ljava/util/concurrent/TimeUnit;

    const-wide/16 v1, 0x1e

    invoke-interface {p1, v1, v2, v0}, Ljava/util/concurrent/Future;->get(JLjava/util/concurrent/TimeUnit;)Ljava/lang/Object;

    sget-object p1, Ljava/util/concurrent/TimeUnit;->SECONDS:Ljava/util/concurrent/TimeUnit;

    invoke-interface {p2, v1, v2, p1}, Ljava/util/concurrent/Future;->get(JLjava/util/concurrent/TimeUnit;)Ljava/lang/Object;

    sget-object p1, Ljava/util/concurrent/TimeUnit;->SECONDS:Ljava/util/concurrent/TimeUnit;

    invoke-interface {p3, v1, v2, p1}, Ljava/util/concurrent/Future;->get(JLjava/util/concurrent/TimeUnit;)Ljava/lang/Object;

    sget-object p1, Ljava/util/concurrent/TimeUnit;->SECONDS:Ljava/util/concurrent/TimeUnit;

    invoke-interface {p4, v1, v2, p1}, Ljava/util/concurrent/Future;->get(JLjava/util/concurrent/TimeUnit;)Ljava/lang/Object;

    sget-object p1, Ljava/util/concurrent/TimeUnit;->SECONDS:Ljava/util/concurrent/TimeUnit;

    invoke-interface {p5, v1, v2, p1}, Ljava/util/concurrent/Future;->get(JLjava/util/concurrent/TimeUnit;)Ljava/lang/Object;

    sget-object p1, Ljava/util/concurrent/TimeUnit;->SECONDS:Ljava/util/concurrent/TimeUnit;

    invoke-interface {p6, v1, v2, p1}, Ljava/util/concurrent/Future;->get(JLjava/util/concurrent/TimeUnit;)Ljava/lang/Object;

    iget-object p1, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->context:Landroid/content/Context;

    invoke-virtual {p1}, Landroid/content/Context;->getCacheDir()Ljava/io/File;

    move-result-object p1

    invoke-static {p1}, Lru/oopssre/imperialschool/viewstv/CacheStore;->clearDirectory(Ljava/io/File;)V

    const-string p1, "\u041a\u0435\u0448 \u043e\u0447\u0438\u0449\u0435\u043d"
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    goto :goto_0

    :catch_0
    const-string p1, "\u041d\u0435 \u0443\u0434\u0430\u043b\u043e\u0441\u044c \u043e\u0447\u0438\u0441\u0442\u0438\u0442\u044c \u043a\u0435\u0448. \u041f\u043e\u0432\u0442\u043e\u0440\u0438\u0442\u0435 \u043f\u043e\u043f\u044b\u0442\u043a\u0443."

    .line 282
    :goto_0
    iget-object p2, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->repo:Lru/oopssre/imperialschool/viewstv/Repository;

    iget-object p2, p2, Lru/oopssre/imperialschool/viewstv/Repository;->cache:Lru/oopssre/imperialschool/viewstv/CacheStore;

    invoke-virtual {p2}, Lru/oopssre/imperialschool/viewstv/CacheStore;->recreate()V

    iget-object p2, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->updater:Lru/oopssre/imperialschool/viewstv/Updater;

    iget-object p2, p2, Lru/oopssre/imperialschool/viewstv/Updater;->folder:Ljava/io/File;

    invoke-virtual {p2}, Ljava/io/File;->mkdirs()Z

    iget-object p2, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->handler:Landroid/os/Handler;

    new-instance p3, Lru/oopssre/imperialschool/viewstv/TvScene$$ExternalSyntheticLambda16;

    invoke-direct {p3, p0, p1}, Lru/oopssre/imperialschool/viewstv/TvScene$$ExternalSyntheticLambda16;-><init>(Lru/oopssre/imperialschool/viewstv/TvScene;Ljava/lang/String;)V

    invoke-virtual {p2, p3}, Landroid/os/Handler;->post(Ljava/lang/Runnable;)Z

    return-void
.end method

.method synthetic lambda$diagnostics$36$ru-oopssre-imperialschool-viewstv-TvScene()V
    .locals 2

    .line 288
    invoke-virtual {p0}, Lru/oopssre/imperialschool/viewstv/TvScene;->videoEnabled()Z

    move-result v0

    const/4 v1, 0x0

    if-eqz v0, :cond_0

    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->videoController:Lru/oopssre/imperialschool/viewstv/VideoController;

    invoke-virtual {v0, v1}, Lru/oopssre/imperialschool/viewstv/VideoController;->refresh(Z)V

    return-void

    :cond_0
    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->controller:Lru/oopssre/imperialschool/viewstv/SceneController;

    invoke-virtual {v0, v1}, Lru/oopssre/imperialschool/viewstv/SceneController;->refresh(Z)V

    return-void
.end method

.method synthetic lambda$enterPersonalCode$26$ru-oopssre-imperialschool-viewstv-TvScene(Landroid/widget/EditText;Landroid/content/DialogInterface;I)V
    .locals 0

    .line 253
    const-string p2, "__PERSONAL_MODE_CODE_FROM_BASE_APK__"

    invoke-virtual {p1}, Landroid/widget/EditText;->getText()Landroid/text/Editable;

    move-result-object p1

    invoke-virtual {p2, p1}, Ljava/lang/String;->contentEquals(Ljava/lang/CharSequence;)Z

    move-result p1

    if-eqz p1, :cond_0

    .line 254
    iget-object p1, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->repo:Lru/oopssre/imperialschool/viewstv/Repository;

    iget-object p1, p1, Lru/oopssre/imperialschool/viewstv/Repository;->prefs:Landroid/content/SharedPreferences;

    invoke-interface {p1}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object p1

    const-string p2, "personal_mode"

    const/4 p3, 0x1

    invoke-interface {p1, p2, p3}, Landroid/content/SharedPreferences$Editor;->putBoolean(Ljava/lang/String;Z)Landroid/content/SharedPreferences$Editor;

    move-result-object p1

    invoke-interface {p1}, Landroid/content/SharedPreferences$Editor;->apply()V

    invoke-virtual {p0}, Lru/oopssre/imperialschool/viewstv/TvScene;->personalMenu()V

    return-void

    .line 255
    :cond_0
    iget-object p1, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->context:Landroid/content/Context;

    const-string p2, "\u041d\u0435\u0432\u0435\u0440\u043d\u044b\u0439 \u043a\u043e\u0434"

    const/4 p3, 0x0

    invoke-static {p1, p2, p3}, Landroid/widget/Toast;->makeText(Landroid/content/Context;Ljava/lang/CharSequence;I)Landroid/widget/Toast;

    move-result-object p1

    invoke-virtual {p1}, Landroid/widget/Toast;->show()V

    return-void
.end method

.method synthetic lambda$focusFirst$2$ru-oopssre-imperialschool-viewstv-TvScene(Ljava/lang/String;Ljava/lang/String;)V
    .locals 5

    .line 88
    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->page:Ljava/lang/String;

    invoke-virtual {v0, p1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-nez v0, :cond_0

    goto :goto_1

    :cond_0
    new-instance v0, Ljava/util/ArrayList;

    invoke-direct {v0}, Ljava/util/ArrayList;-><init>()V

    iget-object v1, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->content:Landroid/widget/LinearLayout;

    invoke-virtual {p0, v1, v0}, Lru/oopssre/imperialschool/viewstv/TvScene;->collectButtons(Landroid/view/View;Ljava/util/List;)V

    invoke-interface {v0}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object v0

    const/4 v1, 0x0

    :cond_1
    invoke-interface {v0}, Ljava/util/Iterator;->hasNext()Z

    move-result v2

    const/4 v3, 0x0

    if-eqz v2, :cond_3

    invoke-interface {v0}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Landroid/widget/Button;

    if-nez v1, :cond_2

    move-object v1, v2

    :cond_2
    if-eqz p2, :cond_1

    invoke-virtual {v2}, Landroid/widget/Button;->getTag()Ljava/lang/Object;

    move-result-object v4

    invoke-virtual {p2, v4}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v4

    if-eqz v4, :cond_1

    const/4 v0, 0x1

    move-object v1, v2

    goto :goto_0

    :cond_3
    move v0, v3

    :goto_0
    if-eqz v1, :cond_4

    .line 89
    invoke-virtual {v1}, Landroid/view/View;->requestFocus()Z

    :cond_4
    iget-object v1, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->scrollMemory:Ljava/util/Map;

    invoke-interface {v1, p1}, Ljava/util/Map;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object p1

    check-cast p1, Ljava/lang/Integer;

    if-eqz p1, :cond_5

    if-eqz v0, :cond_5

    invoke-virtual {p0}, Lru/oopssre/imperialschool/viewstv/TvScene;->activeScroll()Landroid/widget/ScrollView;

    move-result-object p2

    invoke-virtual {p1}, Ljava/lang/Integer;->intValue()I

    move-result p1

    invoke-virtual {p2, v3, p1}, Landroid/widget/ScrollView;->scrollTo(II)V

    return-void

    :cond_5
    if-eqz p2, :cond_7

    if-nez v0, :cond_6

    goto :goto_2

    :cond_6
    :goto_1
    return-void

    :cond_7
    :goto_2
    invoke-virtual {p0}, Lru/oopssre/imperialschool/viewstv/TvScene;->activeScroll()Landroid/widget/ScrollView;

    move-result-object p1

    invoke-virtual {p1, v3, v3}, Landroid/widget/ScrollView;->scrollTo(II)V

    return-void
.end method

.method synthetic lambda$info$15$ru-oopssre-imperialschool-viewstv-TvScene()V
    .locals 1

    .line 0
    const/4 v0, 0x0

    .line 193
    invoke-virtual {p0, v0}, Lru/oopssre/imperialschool/viewstv/TvScene;->projectLink(Z)V

    return-void
.end method

.method synthetic lambda$info$16$ru-oopssre-imperialschool-viewstv-TvScene()V
    .locals 1

    .line 0
    const/4 v0, 0x1

    .line 193
    invoke-virtual {p0, v0}, Lru/oopssre/imperialschool/viewstv/TvScene;->projectLink(Z)V

    return-void
.end method

.method synthetic lambda$modeList$7$ru-oopssre-imperialschool-viewstv-TvScene(Ljava/lang/String;)V
    .locals 3

    .line 169
    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->repo:Lru/oopssre/imperialschool/viewstv/Repository;

    invoke-virtual {v0}, Lru/oopssre/imperialschool/viewstv/Repository;->simpleMode()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p1, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-nez v0, :cond_0

    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->repo:Lru/oopssre/imperialschool/viewstv/Repository;

    iget-object v0, v0, Lru/oopssre/imperialschool/viewstv/Repository;->prefs:Landroid/content/SharedPreferences;

    invoke-interface {v0}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object v0

    new-instance v1, Ljava/lang/StringBuilder;

    const-string v2, "simple_mode_"

    invoke-direct {v1, v2}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    iget-object v2, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->repo:Lru/oopssre/imperialschool/viewstv/Repository;

    invoke-virtual {v2}, Lru/oopssre/imperialschool/viewstv/Repository;->selected()Lru/oopssre/imperialschool/viewstv/Protocol$Theme;

    move-result-object v2

    iget-object v2, v2, Lru/oopssre/imperialschool/viewstv/Protocol$Theme;->id:Ljava/lang/String;

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-interface {v0, v1, p1}, Landroid/content/SharedPreferences$Editor;->putString(Ljava/lang/String;Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    move-result-object p1

    invoke-interface {p1}, Landroid/content/SharedPreferences$Editor;->apply()V

    iget-object p1, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->controller:Lru/oopssre/imperialschool/viewstv/SceneController;

    const/4 v0, 0x1

    invoke-virtual {p1, v0}, Lru/oopssre/imperialschool/viewstv/SceneController;->refresh(Z)V

    :cond_0
    invoke-virtual {p0}, Lru/oopssre/imperialschool/viewstv/TvScene;->collectionMenu()V

    return-void
.end method

.method synthetic lambda$musicCredits$28$ru-oopssre-imperialschool-viewstv-TvScene(Lru/oopssre/imperialschool/viewstv/MusicPacks$Track;)V
    .locals 0

    .line 271
    iget-object p1, p1, Lru/oopssre/imperialschool/viewstv/MusicPacks$Track;->credit:Ljava/lang/String;

    iput-object p1, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->creditDetail:Ljava/lang/String;

    invoke-virtual {p0}, Lru/oopssre/imperialschool/viewstv/TvScene;->creditsDetail()V

    return-void
.end method

.method synthetic lambda$musicMenu$18$ru-oopssre-imperialschool-viewstv-TvScene()V
    .locals 3

    .line 218
    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->music:Lru/oopssre/imperialschool/viewstv/SceneMusic;

    const/4 v1, 0x0

    invoke-virtual {v0, v1}, Lru/oopssre/imperialschool/viewstv/SceneMusic;->isEnabled(Z)Z

    move-result v2

    xor-int/lit8 v2, v2, 0x1

    invoke-virtual {v0, v1, v2}, Lru/oopssre/imperialschool/viewstv/SceneMusic;->enabled(ZZ)V

    return-void
.end method

.method synthetic lambda$musicMenu$19$ru-oopssre-imperialschool-viewstv-TvScene()V
    .locals 3

    .line 219
    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->music:Lru/oopssre/imperialschool/viewstv/SceneMusic;

    const/4 v1, 0x1

    invoke-virtual {v0, v1}, Lru/oopssre/imperialschool/viewstv/SceneMusic;->isEnabled(Z)Z

    move-result v2

    xor-int/2addr v2, v1

    invoke-virtual {v0, v1, v2}, Lru/oopssre/imperialschool/viewstv/SceneMusic;->enabled(ZZ)V

    return-void
.end method

.method synthetic lambda$musicMenu$20$ru-oopssre-imperialschool-viewstv-TvScene()V
    .locals 3

    .line 220
    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->music:Lru/oopssre/imperialschool/viewstv/SceneMusic;

    invoke-virtual {v0}, Lru/oopssre/imperialschool/viewstv/SceneMusic;->level()I

    move-result v1

    add-int/lit8 v1, v1, 0xa

    const/16 v2, 0x64

    invoke-static {v2, v1}, Ljava/lang/Math;->min(II)I

    move-result v1

    invoke-virtual {v0, v1}, Lru/oopssre/imperialschool/viewstv/SceneMusic;->volume(I)V

    return-void
.end method

.method synthetic lambda$musicMenu$21$ru-oopssre-imperialschool-viewstv-TvScene(Landroid/view/View;ILandroid/view/KeyEvent;)Z
    .locals 2

    .line 0
    const/16 p1, 0x15

    const/4 v0, 0x0

    const/16 v1, 0x16

    if-eq p2, p1, :cond_0

    if-eq p2, v1, :cond_0

    return v0

    .line 221
    :cond_0
    invoke-virtual {p3}, Landroid/view/KeyEvent;->getAction()I

    move-result p1

    if-nez p1, :cond_2

    iget-object p1, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->music:Lru/oopssre/imperialschool/viewstv/SceneMusic;

    invoke-virtual {p1}, Lru/oopssre/imperialschool/viewstv/SceneMusic;->level()I

    move-result p3

    if-ne p2, v1, :cond_1

    const/4 p2, 0x5

    goto :goto_0

    :cond_1
    const/4 p2, -0x5

    :goto_0
    add-int/2addr p3, p2

    const/16 p2, 0x64

    invoke-static {p2, p3}, Ljava/lang/Math;->min(II)I

    move-result p2

    invoke-static {v0, p2}, Ljava/lang/Math;->max(II)I

    move-result p2

    invoke-virtual {p1, p2}, Lru/oopssre/imperialschool/viewstv/SceneMusic;->volume(I)V

    :cond_2
    const/4 p1, 0x1

    return p1
.end method

.method synthetic lambda$musicMenu$22$ru-oopssre-imperialschool-viewstv-TvScene()V
    .locals 1

    .line 0
    const/4 v0, 0x0

    .line 231
    invoke-virtual {p0, v0}, Lru/oopssre/imperialschool/viewstv/TvScene;->stationsMenu(Z)V

    return-void
.end method

.method synthetic lambda$musicMenu$23$ru-oopssre-imperialschool-viewstv-TvScene()V
    .locals 1

    .line 232
    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->music:Lru/oopssre/imperialschool/viewstv/SceneMusic;

    invoke-virtual {v0}, Lru/oopssre/imperialschool/viewstv/SceneMusic;->chipMusic()V

    invoke-virtual {p0}, Lru/oopssre/imperialschool/viewstv/TvScene;->musicMenu()V

    return-void
.end method

.method synthetic lambda$new$0$ru-oopssre-imperialschool-viewstv-TvScene()V
    .locals 3

    .line 35
    iget-boolean v0, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->active:Z

    if-eqz v0, :cond_0

    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->hold:Lru/oopssre/imperialschool/viewstv/HoldGate;

    invoke-static {}, Landroid/os/SystemClock;->uptimeMillis()J

    move-result-wide v1

    invoke-virtual {v0, v1, v2}, Lru/oopssre/imperialschool/viewstv/HoldGate;->trigger(J)Z

    move-result v0

    if-eqz v0, :cond_0

    invoke-virtual {p0}, Lru/oopssre/imperialschool/viewstv/TvScene;->openSettings()V

    :cond_0
    return-void
.end method

.method synthetic lambda$outputList$10$ru-oopssre-imperialschool-viewstv-TvScene()V
    .locals 1

    .line 0
    const/4 v0, 0x1

    .line 177
    invoke-virtual {p0, v0}, Lru/oopssre/imperialschool/viewstv/TvScene;->videoOutput(Z)V

    return-void
.end method

.method synthetic lambda$outputList$11$ru-oopssre-imperialschool-viewstv-TvScene(JLandroid/widget/Button;ZLandroid/widget/TextView;Ljava/lang/String;)V
    .locals 2

    .line 186
    iget-boolean v0, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->active:Z

    if-eqz v0, :cond_2

    iget-wide v0, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->capabilityGeneration:J

    cmp-long p1, p1, v0

    if-nez p1, :cond_2

    iget-object p1, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->page:Ljava/lang/String;

    const-string p2, "output"

    invoke-virtual {p1, p2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p1

    if-nez p1, :cond_0

    goto :goto_1

    :cond_0
    if-eqz p4, :cond_1

    iget-boolean p1, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->cacheBusy:Z

    if-nez p1, :cond_1

    const/4 p1, 0x1

    goto :goto_0

    :cond_1
    const/4 p1, 0x0

    :goto_0
    invoke-virtual {p3, p1}, Landroid/widget/Button;->setEnabled(Z)V

    invoke-virtual {p5, p6}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    :cond_2
    :goto_1
    return-void
.end method

.method synthetic lambda$outputList$12$ru-oopssre-imperialschool-viewstv-TvScene(Lru/oopssre/imperialschool/viewstv/Protocol$Theme;JLandroid/widget/Button;Landroid/widget/TextView;)V
    .locals 9

    .line 0
    const/4 v0, 0x0

    .line 182
    :try_start_0
    new-instance v1, Lru/oopssre/imperialschool/viewstv/VideoLoader;

    iget-object v2, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->repo:Lru/oopssre/imperialschool/viewstv/Repository;

    iget-object v2, v2, Lru/oopssre/imperialschool/viewstv/Repository;->net:Lru/oopssre/imperialschool/viewstv/HttpTransport;

    iget-object v3, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->repo:Lru/oopssre/imperialschool/viewstv/Repository;

    iget-object v3, v3, Lru/oopssre/imperialschool/viewstv/Repository;->cache:Lru/oopssre/imperialschool/viewstv/CacheStore;

    invoke-direct {v1, v2, v3}, Lru/oopssre/imperialschool/viewstv/VideoLoader;-><init>(Lru/oopssre/imperialschool/viewstv/HttpTransport;Lru/oopssre/imperialschool/viewstv/CacheStore;)V

    invoke-virtual {v1, p1, v0}, Lru/oopssre/imperialschool/viewstv/VideoLoader;->describe(Lru/oopssre/imperialschool/viewstv/Protocol$Theme;Z)Lru/oopssre/imperialschool/viewstv/VideoInfo;

    move-result-object p1

    invoke-static {p1}, Lru/oopssre/imperialschool/viewstv/VideoSurface;->supports(Lru/oopssre/imperialschool/viewstv/VideoInfo;)Z

    move-result v0

    if-eqz v0, :cond_0

    const-string p1, "\u0412\u0438\u0434\u0435\u043e \u044d\u0442\u043e\u0439 \u0441\u0446\u0435\u043d\u044b \u0433\u043e\u0442\u043e\u0432\u043e."

    goto :goto_0

    :cond_0
    const-string p1, "\u042d\u0442\u043e\u0442 \u0442\u0435\u043b\u0435\u0432\u0438\u0437\u043e\u0440 \u043d\u0435 \u043f\u043e\u0434\u0434\u0435\u0440\u0436\u0438\u0432\u0430\u0435\u0442 \u0432\u0438\u0434\u0435\u043e 4\u041a."
    :try_end_0
    .catch Lru/oopssre/imperialschool/viewstv/Protocol$NotReady; {:try_start_0 .. :try_end_0} :catch_1
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    goto :goto_0

    .line 184
    :catch_0
    const-string p1, "\u041d\u0435 \u0443\u0434\u0430\u043b\u043e\u0441\u044c \u043f\u0440\u043e\u0432\u0435\u0440\u0438\u0442\u044c \u0432\u0438\u0434\u0435\u043e. \u041f\u043e\u043f\u0440\u043e\u0431\u0443\u0439\u0442\u0435 \u043e\u0442\u043a\u0440\u044b\u0442\u044c \u044d\u0442\u043e\u0442 \u0440\u0430\u0437\u0434\u0435\u043b \u043f\u043e\u0437\u0436\u0435."

    goto :goto_0

    :catch_1
    const-string p1, "\u0412\u0438\u0434\u0435\u043e \u044d\u0442\u043e\u0439 \u0441\u0446\u0435\u043d\u044b \u0435\u0449\u0451 \u043d\u0435 \u0433\u043e\u0442\u043e\u0432\u043e. \u0418\u0437\u043e\u0431\u0440\u0430\u0436\u0435\u043d\u0438\u0435 \u0434\u043e\u0441\u0442\u0443\u043f\u043d\u043e."

    :goto_0
    move-object v8, p1

    move v6, v0

    .line 186
    iget-object p1, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->handler:Landroid/os/Handler;

    new-instance v1, Lru/oopssre/imperialschool/viewstv/TvScene$$ExternalSyntheticLambda18;

    move-object v2, p0

    move-wide v3, p2

    move-object v5, p4

    move-object v7, p5

    invoke-direct/range {v1 .. v8}, Lru/oopssre/imperialschool/viewstv/TvScene$$ExternalSyntheticLambda18;-><init>(Lru/oopssre/imperialschool/viewstv/TvScene;JLandroid/widget/Button;ZLandroid/widget/TextView;Ljava/lang/String;)V

    invoke-virtual {p1, v1}, Landroid/os/Handler;->post(Ljava/lang/Runnable;)Z

    return-void
.end method

.method synthetic lambda$outputList$9$ru-oopssre-imperialschool-viewstv-TvScene()V
    .locals 1

    .line 0
    const/4 v0, 0x0

    .line 176
    invoke-virtual {p0, v0}, Lru/oopssre/imperialschool/viewstv/TvScene;->videoOutput(Z)V

    return-void
.end method

.method synthetic lambda$personalMenu$24$ru-oopssre-imperialschool-viewstv-TvScene()V
    .locals 1

    .line 0
    const/4 v0, 0x1

    .line 238
    invoke-virtual {p0, v0}, Lru/oopssre/imperialschool/viewstv/TvScene;->stationsMenu(Z)V

    return-void
.end method

.method synthetic lambda$personalMenu$25$ru-oopssre-imperialschool-viewstv-TvScene()V
    .locals 3

    .line 241
    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->repo:Lru/oopssre/imperialschool/viewstv/Repository;

    iget-object v0, v0, Lru/oopssre/imperialschool/viewstv/Repository;->prefs:Landroid/content/SharedPreferences;

    invoke-interface {v0}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object v0

    const-string v1, "personal_mode"

    const/4 v2, 0x0

    invoke-interface {v0, v1, v2}, Landroid/content/SharedPreferences$Editor;->putBoolean(Ljava/lang/String;Z)Landroid/content/SharedPreferences$Editor;

    move-result-object v0

    invoke-interface {v0}, Landroid/content/SharedPreferences$Editor;->apply()V

    .line 242
    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->music:Lru/oopssre/imperialschool/viewstv/SceneMusic;

    invoke-virtual {v0}, Lru/oopssre/imperialschool/viewstv/SceneMusic;->radio()Z

    move-result v0

    if-eqz v0, :cond_0

    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->music:Lru/oopssre/imperialschool/viewstv/SceneMusic;

    iget-object v0, v0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->stations:Lru/oopssre/imperialschool/viewstv/ThemeStations;

    invoke-virtual {p0}, Lru/oopssre/imperialschool/viewstv/TvScene;->musicTheme()Ljava/lang/String;

    move-result-object v1

    iget-object v2, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->music:Lru/oopssre/imperialschool/viewstv/SceneMusic;

    invoke-virtual {v2}, Lru/oopssre/imperialschool/viewstv/SceneMusic;->selectedStation()Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v0, v1, v2}, Lru/oopssre/imperialschool/viewstv/ThemeStations;->playable(Ljava/lang/String;Ljava/lang/String;)Lru/oopssre/imperialschool/viewstv/ThemeStations$Station;

    move-result-object v0

    if-nez v0, :cond_0

    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->music:Lru/oopssre/imperialschool/viewstv/SceneMusic;

    invoke-virtual {v0}, Lru/oopssre/imperialschool/viewstv/SceneMusic;->chipMusic()V

    .line 243
    :cond_0
    invoke-virtual {p0}, Lru/oopssre/imperialschool/viewstv/TvScene;->personalMenu()V

    return-void
.end method

.method synthetic lambda$projectLink$17$ru-oopssre-imperialschool-viewstv-TvScene(Ljava/lang/String;)V
    .locals 3

    .line 200
    :try_start_0
    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->host:Lru/oopssre/imperialschool/viewstv/TvScene$Host;

    new-instance v1, Landroid/content/Intent;

    const-string v2, "android.intent.action.VIEW"

    invoke-static {p1}, Landroid/net/Uri;->parse(Ljava/lang/String;)Landroid/net/Uri;

    move-result-object p1

    invoke-direct {v1, v2, p1}, Landroid/content/Intent;-><init>(Ljava/lang/String;Landroid/net/Uri;)V

    const/high16 p1, 0x10000000

    invoke-virtual {v1, p1}, Landroid/content/Intent;->addFlags(I)Landroid/content/Intent;

    move-result-object p1

    invoke-interface {v0, p1}, Lru/oopssre/imperialschool/viewstv/TvScene$Host;->launch(Landroid/content/Intent;)V
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    return-void

    :catch_0
    iget-object p1, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->context:Landroid/content/Context;

    const-string v0, "\u041d\u0430 \u0442\u0435\u043b\u0435\u0432\u0438\u0437\u043e\u0440\u0435 \u043d\u0435\u0442 \u043f\u0440\u0438\u043b\u043e\u0436\u0435\u043d\u0438\u044f \u0434\u043b\u044f \u043e\u0442\u043a\u0440\u044b\u0442\u0438\u044f \u0441\u0441\u044b\u043b\u043a\u0438. \u0418\u0441\u043f\u043e\u043b\u044c\u0437\u0443\u0439\u0442\u0435 QR-\u043a\u043e\u0434."

    const/4 v1, 0x1

    invoke-static {p1, v0, v1}, Landroid/widget/Toast;->makeText(Landroid/content/Context;Ljava/lang/CharSequence;I)Landroid/widget/Toast;

    move-result-object p1

    invoke-virtual {p1}, Landroid/widget/Toast;->show()V

    return-void
.end method

.method synthetic lambda$resolutionList$14$ru-oopssre-imperialschool-viewstv-TvScene(Ljava/lang/String;)V
    .locals 1

    .line 190
    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->repo:Lru/oopssre/imperialschool/viewstv/Repository;

    invoke-virtual {v0}, Lru/oopssre/imperialschool/viewstv/Repository;->resolution()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p1, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-nez v0, :cond_0

    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->repo:Lru/oopssre/imperialschool/viewstv/Repository;

    invoke-virtual {v0, p1}, Lru/oopssre/imperialschool/viewstv/Repository;->resolution(Ljava/lang/String;)V

    const/4 p1, 0x0

    invoke-virtual {p0, p1}, Lru/oopssre/imperialschool/viewstv/TvScene;->refreshResolution(Z)V

    iget-object p1, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->controller:Lru/oopssre/imperialschool/viewstv/SceneController;

    const/4 v0, 0x1

    invoke-virtual {p1, v0}, Lru/oopssre/imperialschool/viewstv/SceneController;->refresh(Z)V

    :cond_0
    invoke-virtual {p0}, Lru/oopssre/imperialschool/viewstv/TvScene;->screenMenu()V

    return-void
.end method

.method synthetic lambda$scaleList$13$ru-oopssre-imperialschool-viewstv-TvScene(Z)V
    .locals 2

    .line 189
    invoke-virtual {p0}, Lru/oopssre/imperialschool/viewstv/TvScene;->videoEnabled()Z

    move-result v0

    if-eqz v0, :cond_0

    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->repo:Lru/oopssre/imperialschool/viewstv/Repository;

    iget-object v0, v0, Lru/oopssre/imperialschool/viewstv/Repository;->prefs:Landroid/content/SharedPreferences;

    invoke-interface {v0}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object v0

    const-string v1, "video_fill"

    invoke-interface {v0, v1, p1}, Landroid/content/SharedPreferences$Editor;->putBoolean(Ljava/lang/String;Z)Landroid/content/SharedPreferences$Editor;

    move-result-object v0

    invoke-interface {v0}, Landroid/content/SharedPreferences$Editor;->apply()V

    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->video:Lru/oopssre/imperialschool/viewstv/VideoSurface;

    iput-boolean p1, v0, Lru/oopssre/imperialschool/viewstv/VideoSurface;->fill:Z

    goto :goto_0

    :cond_0
    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->repo:Lru/oopssre/imperialschool/viewstv/Repository;

    invoke-virtual {v0, p1}, Lru/oopssre/imperialschool/viewstv/Repository;->fill(Z)V

    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->surface:Lru/oopssre/imperialschool/viewstv/WallpaperSurface;

    iput-boolean p1, v0, Lru/oopssre/imperialschool/viewstv/WallpaperSurface;->fill:Z

    iget-object p1, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->surface:Lru/oopssre/imperialschool/viewstv/WallpaperSurface;

    invoke-virtual {p1}, Lru/oopssre/imperialschool/viewstv/WallpaperSurface;->drawFrame()V

    :goto_0
    invoke-virtual {p0}, Lru/oopssre/imperialschool/viewstv/TvScene;->screenMenu()V

    return-void
.end method

.method synthetic lambda$screenMenu$8$ru-oopssre-imperialschool-viewstv-TvScene()V
    .locals 3

    .line 174
    invoke-virtual {p0}, Lru/oopssre/imperialschool/viewstv/TvScene;->videoEnabled()Z

    move-result v0

    const/4 v1, 0x0

    if-eqz v0, :cond_0

    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->videoController:Lru/oopssre/imperialschool/viewstv/VideoController;

    invoke-virtual {v0, v1}, Lru/oopssre/imperialschool/viewstv/VideoController;->refresh(Z)V

    goto :goto_0

    :cond_0
    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->controller:Lru/oopssre/imperialschool/viewstv/SceneController;

    invoke-virtual {v0, v1}, Lru/oopssre/imperialschool/viewstv/SceneController;->refresh(Z)V

    :goto_0
    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->context:Landroid/content/Context;

    const-string v2, "\u041f\u0440\u043e\u0432\u0435\u0440\u044f\u044e \u043e\u0431\u043d\u043e\u0432\u043b\u0435\u043d\u0438\u0435 \u043e\u0431\u043e\u0435\u0432"

    invoke-static {v0, v2, v1}, Landroid/widget/Toast;->makeText(Landroid/content/Context;Ljava/lang/CharSequence;I)Landroid/widget/Toast;

    move-result-object v0

    invoke-virtual {v0}, Landroid/widget/Toast;->show()V

    return-void
.end method

.method synthetic lambda$start$3$ru-oopssre-imperialschool-viewstv-TvScene(JLru/oopssre/imperialschool/viewstv/Release;)V
    .locals 2

    .line 122
    iget-boolean v0, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->destroyed:Z

    if-nez v0, :cond_0

    iget-wide v0, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->updateGeneration:J

    cmp-long p1, p1, v0

    if-nez p1, :cond_0

    iput-object p3, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->ready:Lru/oopssre/imperialschool/viewstv/Release;

    iget-boolean p1, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->active:Z

    if-eqz p1, :cond_0

    iget-object p1, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->page:Ljava/lang/String;

    const-string p2, "updates"

    invoke-virtual {p1, p2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p1

    if-eqz p1, :cond_0

    iget-object p1, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->panel:Landroid/widget/ScrollView;

    invoke-virtual {p1}, Landroid/widget/ScrollView;->getVisibility()I

    move-result p1

    if-nez p1, :cond_0

    invoke-virtual {p0}, Lru/oopssre/imperialschool/viewstv/TvScene;->updatesMenu()V

    :cond_0
    return-void
.end method

.method synthetic lambda$start$4$ru-oopssre-imperialschool-viewstv-TvScene(J)V
    .locals 3

    .line 122
    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->updater:Lru/oopssre/imperialschool/viewstv/Updater;

    invoke-virtual {v0}, Lru/oopssre/imperialschool/viewstv/Updater;->ready()Lru/oopssre/imperialschool/viewstv/Release;

    move-result-object v0

    iget-object v1, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->handler:Landroid/os/Handler;

    new-instance v2, Lru/oopssre/imperialschool/viewstv/TvScene$$ExternalSyntheticLambda5;

    invoke-direct {v2, p0, p1, p2, v0}, Lru/oopssre/imperialschool/viewstv/TvScene$$ExternalSyntheticLambda5;-><init>(Lru/oopssre/imperialschool/viewstv/TvScene;JLru/oopssre/imperialschool/viewstv/Release;)V

    invoke-virtual {v1, v2}, Landroid/os/Handler;->post(Ljava/lang/Runnable;)Z

    return-void
.end method

.method synthetic lambda$start$5$ru-oopssre-imperialschool-viewstv-TvScene()V
    .locals 2

    .line 123
    iget-boolean v0, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->active:Z

    if-eqz v0, :cond_0

    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->hint:Landroid/widget/TextView;

    const/16 v1, 0x8

    invoke-virtual {v0, v1}, Landroid/widget/TextView;->setVisibility(I)V

    :cond_0
    return-void
.end method

.method synthetic lambda$stationsMenu$27$ru-oopssre-imperialschool-viewstv-TvScene(Lru/oopssre/imperialschool/viewstv/ThemeStations$Station;)V
    .locals 1

    .line 262
    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->music:Lru/oopssre/imperialschool/viewstv/SceneMusic;

    iget-object p1, p1, Lru/oopssre/imperialschool/viewstv/ThemeStations$Station;->id:Ljava/lang/String;

    invoke-virtual {v0, p1}, Lru/oopssre/imperialschool/viewstv/SceneMusic;->playStation(Ljava/lang/String;)Z

    move-result p1

    if-eqz p1, :cond_0

    invoke-direct {p0}, Lru/oopssre/imperialschool/viewstv/TvScene;->showStationVolume()V

    :cond_0
    return-void
.end method

.method synthetic lambda$updatesMenu$37$ru-oopssre-imperialschool-viewstv-TvScene()V
    .locals 1

    .line 304
    iget-boolean v0, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->updateBusy:Z

    if-nez v0, :cond_1

    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->ready:Lru/oopssre/imperialschool/viewstv/Release;

    if-nez v0, :cond_0

    invoke-virtual {p0}, Lru/oopssre/imperialschool/viewstv/TvScene;->checkUpdate()V

    return-void

    :cond_0
    invoke-virtual {p0}, Lru/oopssre/imperialschool/viewstv/TvScene;->install()V

    :cond_1
    return-void
.end method

.method synthetic lambda$weatherList$6$ru-oopssre-imperialschool-viewstv-TvScene(Ljava/lang/String;)V
    .locals 2

    .line 166
    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->repo:Lru/oopssre/imperialschool/viewstv/Repository;

    invoke-virtual {v0}, Lru/oopssre/imperialschool/viewstv/Repository;->weatherSource()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p1, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-nez v0, :cond_0

    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->repo:Lru/oopssre/imperialschool/viewstv/Repository;

    iget-object v0, v0, Lru/oopssre/imperialschool/viewstv/Repository;->prefs:Landroid/content/SharedPreferences;

    invoke-interface {v0}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object v0

    const-string v1, "weather_source"

    invoke-interface {v0, v1, p1}, Landroid/content/SharedPreferences$Editor;->putString(Ljava/lang/String;Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    move-result-object p1

    invoke-interface {p1}, Landroid/content/SharedPreferences$Editor;->apply()V

    iget-object p1, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->controller:Lru/oopssre/imperialschool/viewstv/SceneController;

    const/4 v0, 0x1

    invoke-virtual {p1, v0}, Lru/oopssre/imperialschool/viewstv/SceneController;->refresh(Z)V

    :cond_0
    invoke-virtual {p0}, Lru/oopssre/imperialschool/viewstv/TvScene;->collectionMenu()V

    return-void
.end method

.method makeButton(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Runnable;)Landroid/widget/Button;
    .locals 8

    .line 67
    new-instance v0, Landroid/widget/Button;

    iget-object v1, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->context:Landroid/content/Context;

    invoke-direct {v0, v1}, Landroid/widget/Button;-><init>(Landroid/content/Context;)V

    invoke-virtual {v0, p2}, Landroid/widget/Button;->setText(Ljava/lang/CharSequence;)V

    invoke-virtual {v0, p1}, Landroid/widget/Button;->setTag(Ljava/lang/Object;)V

    const/4 p1, 0x0

    invoke-virtual {v0, p1}, Landroid/widget/Button;->setAllCaps(Z)V

    const/high16 p2, 0x41a00000    # 20.0f

    invoke-virtual {v0, p2}, Landroid/widget/Button;->setTextSize(F)V

    .line 68
    new-instance p2, Landroid/content/res/ColorStateList;

    const v1, -0x101009e

    filled-new-array {v1}, [I

    move-result-object v2

    const v3, 0x101009c

    filled-new-array {v3}, [I

    move-result-object v4

    const v5, 0x10100a7

    filled-new-array {v5}, [I

    move-result-object v6

    new-array v7, p1, [I

    filled-new-array {v2, v4, v6, v7}, [[I

    move-result-object v2

    const v4, -0xd8edd5

    const v6, -0xc1325

    const v7, -0x7e8772

    filled-new-array {v7, v4, v4, v6}, [I

    move-result-object v4

    invoke-direct {p2, v2, v4}, Landroid/content/res/ColorStateList;-><init>([[I[I)V

    invoke-virtual {v0, p2}, Landroid/widget/Button;->setTextColor(Landroid/content/res/ColorStateList;)V

    const/16 p2, 0x13

    .line 69
    invoke-virtual {v0, p2}, Landroid/widget/Button;->setGravity(I)V

    const/16 p2, 0x10

    invoke-virtual {p0, p2}, Lru/oopssre/imperialschool/viewstv/TvScene;->dp(I)I

    move-result v2

    const/16 v4, 0xa

    invoke-virtual {p0, v4}, Lru/oopssre/imperialschool/viewstv/TvScene;->dp(I)I

    move-result v6

    invoke-virtual {p0, p2}, Lru/oopssre/imperialschool/viewstv/TvScene;->dp(I)I

    move-result p2

    invoke-virtual {p0, v4}, Lru/oopssre/imperialschool/viewstv/TvScene;->dp(I)I

    move-result v4

    invoke-virtual {v0, v2, v6, p2, v4}, Landroid/widget/Button;->setPadding(IIII)V

    const/16 p2, 0x38

    invoke-virtual {p0, p2}, Lru/oopssre/imperialschool/viewstv/TvScene;->dp(I)I

    move-result p2

    invoke-virtual {v0, p2}, Landroid/widget/Button;->setMinHeight(I)V

    const/4 p2, 0x1

    invoke-virtual {v0, p2}, Landroid/widget/Button;->setFocusable(Z)V

    invoke-virtual {v0, p2}, Landroid/widget/Button;->setFocusableInTouchMode(Z)V

    .line 70
    new-instance v2, Landroid/graphics/drawable/StateListDrawable;

    invoke-direct {v2}, Landroid/graphics/drawable/StateListDrawable;-><init>()V

    filled-new-array {v1}, [I

    move-result-object v1

    const v4, -0xe6e9d6

    invoke-virtual {p0, v4, p1}, Lru/oopssre/imperialschool/viewstv/TvScene;->background(IZ)Landroid/graphics/drawable/GradientDrawable;

    move-result-object v4

    invoke-virtual {v2, v1, v4}, Landroid/graphics/drawable/StateListDrawable;->addState([ILandroid/graphics/drawable/Drawable;)V

    filled-new-array {v3}, [I

    move-result-object v1

    const v3, -0x440ab

    invoke-virtual {p0, v3, p2}, Lru/oopssre/imperialschool/viewstv/TvScene;->background(IZ)Landroid/graphics/drawable/GradientDrawable;

    move-result-object v4

    invoke-virtual {v2, v1, v4}, Landroid/graphics/drawable/StateListDrawable;->addState([ILandroid/graphics/drawable/Drawable;)V

    filled-new-array {v5}, [I

    move-result-object v1

    invoke-virtual {p0, v3, p2}, Lru/oopssre/imperialschool/viewstv/TvScene;->background(IZ)Landroid/graphics/drawable/GradientDrawable;

    move-result-object v3

    invoke-virtual {v2, v1, v3}, Landroid/graphics/drawable/StateListDrawable;->addState([ILandroid/graphics/drawable/Drawable;)V

    new-array v1, p1, [I

    const v3, -0xdee4c8

    invoke-virtual {p0, v3, p1}, Lru/oopssre/imperialschool/viewstv/TvScene;->background(IZ)Landroid/graphics/drawable/GradientDrawable;

    move-result-object p1

    invoke-virtual {v2, v1, p1}, Landroid/graphics/drawable/StateListDrawable;->addState([ILandroid/graphics/drawable/Drawable;)V

    invoke-virtual {v0, v2}, Landroid/widget/Button;->setBackground(Landroid/graphics/drawable/Drawable;)V

    .line 71
    iget-boolean p1, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->cacheBusy:Z

    xor-int/2addr p1, p2

    invoke-virtual {v0, p1}, Landroid/widget/Button;->setEnabled(Z)V

    new-instance p1, Lru/oopssre/imperialschool/viewstv/TvScene$$ExternalSyntheticLambda7;

    invoke-direct {p1, p3}, Lru/oopssre/imperialschool/viewstv/TvScene$$ExternalSyntheticLambda7;-><init>(Ljava/lang/Runnable;)V

    invoke-virtual {v0, p1}, Landroid/widget/Button;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    return-object v0
.end method

.method mb(J)Ljava/lang/String;
    .locals 3

    .line 276
    invoke-static {}, Ljava/util/Locale;->getDefault()Ljava/util/Locale;

    move-result-object v0

    long-to-double p1, p1

    const-wide/high16 v1, 0x4130000000000000L    # 1048576.0

    div-double/2addr p1, v1

    invoke-static {p1, p2}, Ljava/lang/Double;->valueOf(D)Ljava/lang/Double;

    move-result-object p1

    filled-new-array {p1}, [Ljava/lang/Object;

    move-result-object p1

    const-string p2, "%.1f \u041c\u0438\u0411"

    invoke-static {v0, p2, p1}, Ljava/lang/String;->format(Ljava/util/Locale;Ljava/lang/String;[Ljava/lang/Object;)Ljava/lang/String;

    move-result-object p1

    return-object p1
.end method

.method message(Ljava/lang/String;)V
    .locals 3

    const/16 v0, 0x12

    .line 94
    invoke-virtual {p0, p1, v0}, Lru/oopssre/imperialschool/viewstv/TvScene;->text(Ljava/lang/String;I)Landroid/widget/TextView;

    move-result-object p1

    const/16 v0, 0x8

    invoke-virtual {p0, v0}, Lru/oopssre/imperialschool/viewstv/TvScene;->dp(I)I

    move-result v0

    const/16 v1, 0x14

    invoke-virtual {p0, v1}, Lru/oopssre/imperialschool/viewstv/TvScene;->dp(I)I

    move-result v1

    const/4 v2, 0x0

    invoke-virtual {p1, v2, v0, v2, v1}, Landroid/widget/TextView;->setPadding(IIII)V

    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->content:Landroid/widget/LinearLayout;

    invoke-virtual {v0, p1}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    return-void
.end method

.method modeList()V
    .locals 10

    .line 167
    const-string v0, "mode"

    const-string v1, "\u0421\u043c\u0435\u043d\u0430 \u0438\u0437\u043e\u0431\u0440\u0430\u0436\u0435\u043d\u0438\u0439"

    invoke-virtual {p0, v0, v1}, Lru/oopssre/imperialschool/viewstv/TvScene;->beginPage(Ljava/lang/String;Ljava/lang/String;)V

    const/4 v0, 0x4

    new-array v1, v0, [Ljava/lang/String;

    const/4 v2, 0x0

    const-string v3, "auto"

    aput-object v3, v1, v2

    const/4 v4, 0x1

    const-string v5, "daily"

    aput-object v5, v1, v4

    const/4 v4, 0x2

    const-string v6, "monthly"

    aput-object v6, v1, v4

    const/4 v4, 0x3

    const-string v7, "seasonal"

    aput-object v7, v1, v4

    :goto_0
    if-ge v2, v0, :cond_7

    aget-object v4, v1, v2

    iget-object v8, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->repo:Lru/oopssre/imperialschool/viewstv/Repository;

    invoke-virtual {v8}, Lru/oopssre/imperialschool/viewstv/Repository;->selected()Lru/oopssre/imperialschool/viewstv/Protocol$Theme;

    move-result-object v8

    iget-object v8, v8, Lru/oopssre/imperialschool/viewstv/Protocol$Theme;->descriptor:Lorg/json/JSONObject;

    const-string v9, "schedule"

    invoke-virtual {v8, v9}, Lorg/json/JSONObject;->optJSONObject(Ljava/lang/String;)Lorg/json/JSONObject;

    move-result-object v8

    invoke-virtual {v4, v6}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v9

    if-nez v9, :cond_0

    invoke-virtual {v4, v7}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v9

    if-eqz v9, :cond_1

    :cond_0
    if-eqz v8, :cond_6

    invoke-virtual {v8, v4}, Lorg/json/JSONObject;->has(Ljava/lang/String;)Z

    move-result v8

    if-nez v8, :cond_1

    goto :goto_3

    .line 168
    :cond_1
    invoke-virtual {v4, v3}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v8

    if-eqz v8, :cond_2

    const-string v8, "\u041f\u043e \u0440\u0430\u0441\u043f\u0438\u0441\u0430\u043d\u0438\u044e \u043a\u043e\u043b\u043b\u0435\u043a\u0446\u0438\u0438"

    goto :goto_1

    :cond_2
    invoke-virtual {v4, v5}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v8

    if-eqz v8, :cond_3

    const-string v8, "\u041a\u0430\u0436\u0434\u044b\u0439 \u0434\u0435\u043d\u044c"

    goto :goto_1

    :cond_3
    invoke-virtual {v4, v6}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v8

    if-eqz v8, :cond_4

    const-string v8, "\u041f\u043e \u043c\u0435\u0441\u044f\u0446\u0430\u043c"

    goto :goto_1

    :cond_4
    const-string v8, "\u041f\u043e \u0441\u0435\u0437\u043e\u043d\u0430\u043c"

    .line 169
    :goto_1
    iget-object v9, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->repo:Lru/oopssre/imperialschool/viewstv/Repository;

    invoke-virtual {v9}, Lru/oopssre/imperialschool/viewstv/Repository;->simpleMode()Ljava/lang/String;

    move-result-object v9

    invoke-virtual {v4, v9}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v9

    if-eqz v9, :cond_5

    const-string v9, "\u2713 "

    goto :goto_2

    :cond_5
    const-string v9, ""

    :goto_2
    invoke-virtual {v9, v8}, Ljava/lang/String;->concat(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v8

    new-instance v9, Lru/oopssre/imperialschool/viewstv/TvScene$$ExternalSyntheticLambda23;

    invoke-direct {v9, p0, v4}, Lru/oopssre/imperialschool/viewstv/TvScene$$ExternalSyntheticLambda23;-><init>(Lru/oopssre/imperialschool/viewstv/TvScene;Ljava/lang/String;)V

    invoke-virtual {p0, v4, v8, v9}, Lru/oopssre/imperialschool/viewstv/TvScene;->button(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Runnable;)Landroid/widget/Button;

    :cond_6
    :goto_3
    add-int/lit8 v2, v2, 0x1

    goto :goto_0

    :cond_7
    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->repo:Lru/oopssre/imperialschool/viewstv/Repository;

    invoke-virtual {v0}, Lru/oopssre/imperialschool/viewstv/Repository;->simpleMode()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p0, v0}, Lru/oopssre/imperialschool/viewstv/TvScene;->focusFirst(Ljava/lang/String;)V

    return-void
.end method

.method musicAvailable()Z
    .locals 2

    .line 203
    const-string v0, "orbital-port"

    invoke-virtual {p0}, Lru/oopssre/imperialschool/viewstv/TvScene;->musicTheme()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-nez v0, :cond_1

    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->music:Lru/oopssre/imperialschool/viewstv/SceneMusic;

    invoke-virtual {v0}, Lru/oopssre/imperialschool/viewstv/SceneMusic;->hasTracks()Z

    move-result v0

    if-nez v0, :cond_1

    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->music:Lru/oopssre/imperialschool/viewstv/SceneMusic;

    iget-object v0, v0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->stations:Lru/oopssre/imperialschool/viewstv/ThemeStations;

    invoke-virtual {p0}, Lru/oopssre/imperialschool/viewstv/TvScene;->musicTheme()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Lru/oopssre/imperialschool/viewstv/ThemeStations;->forTheme(Ljava/lang/String;)Ljava/util/List;

    move-result-object v0

    invoke-interface {v0}, Ljava/util/List;->isEmpty()Z

    move-result v0

    if-nez v0, :cond_0

    goto :goto_0

    :cond_0
    const/4 v0, 0x0

    return v0

    :cond_1
    :goto_0
    const/4 v0, 0x1

    return v0
.end method

.method musicChanged()V
    .locals 7

    .line 205
    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->musicCheckDetails:Landroid/widget/TextView;

    if-eqz v0, :cond_0

    iget-object v1, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->music:Lru/oopssre/imperialschool/viewstv/SceneMusic;

    invoke-virtual {v1}, Lru/oopssre/imperialschool/viewstv/SceneMusic;->musicCheckStatus()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    .line 206
    :cond_0
    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->musicCheck:Landroid/widget/Button;

    const/4 v1, 0x1

    const/4 v2, 0x0

    if-eqz v0, :cond_2

    iget-boolean v3, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->cacheBusy:Z

    if-nez v3, :cond_1

    iget-object v3, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->music:Lru/oopssre/imperialschool/viewstv/SceneMusic;

    iget-boolean v3, v3, Lru/oopssre/imperialschool/viewstv/SceneMusic;->loading:Z

    if-nez v3, :cond_1

    move v3, v1

    goto :goto_0

    :cond_1
    move v3, v2

    :goto_0
    invoke-virtual {v0, v3}, Landroid/widget/Button;->setEnabled(Z)V

    .line 207
    :cond_2
    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->page:Ljava/lang/String;

    const-string v3, "music"

    invoke-virtual {v0, v3}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_d

    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->musicDetails:Landroid/widget/TextView;

    if-nez v0, :cond_3

    goto/16 :goto_6

    .line 208
    :cond_3
    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->music:Lru/oopssre/imperialschool/viewstv/SceneMusic;

    invoke-virtual {v0}, Lru/oopssre/imperialschool/viewstv/SceneMusic;->title()Ljava/lang/String;

    move-result-object v0

    .line 209
    iget-object v3, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->musicDetails:Landroid/widget/TextView;

    new-instance v4, Ljava/lang/StringBuilder;

    invoke-direct {v4}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v0}, Ljava/lang/String;->isEmpty()Z

    move-result v5

    const-string v6, "\n"

    if-eqz v5, :cond_4

    const-string v0, ""

    goto :goto_1

    :cond_4
    new-instance v5, Ljava/lang/StringBuilder;

    invoke-direct {v5}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v5, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    :goto_1
    invoke-virtual {v4, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    iget-object v4, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->music:Lru/oopssre/imperialschool/viewstv/SceneMusic;

    iget-object v4, v4, Lru/oopssre/imperialschool/viewstv/SceneMusic;->state:Ljava/lang/String;

    invoke-virtual {v0, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    iget-object v4, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->music:Lru/oopssre/imperialschool/viewstv/SceneMusic;

    invoke-virtual {v4}, Lru/oopssre/imperialschool/viewstv/SceneMusic;->musicCheckStatus()Ljava/lang/String;

    move-result-object v4

    invoke-virtual {v0, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {v3, v0}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    .line 210
    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->musicToggle:Landroid/widget/Button;

    const-string v3, "\u0412\u043a\u043b\u044e\u0447\u0435\u043d\u0430"

    const-string v4, "\u0412\u044b\u043a\u043b\u044e\u0447\u0435\u043d\u0430"

    if-eqz v0, :cond_6

    iget-object v5, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->music:Lru/oopssre/imperialschool/viewstv/SceneMusic;

    invoke-virtual {v5, v2}, Lru/oopssre/imperialschool/viewstv/SceneMusic;->isEnabled(Z)Z

    move-result v5

    if-eqz v5, :cond_5

    move-object v5, v3

    goto :goto_2

    :cond_5
    move-object v5, v4

    :goto_2
    const-string v6, "\u041c\u0443\u0437\u044b\u043a\u0430 \u0432 \u043f\u0440\u0438\u043b\u043e\u0436\u0435\u043d\u0438\u0438 \u00b7 "

    invoke-virtual {v6, v5}, Ljava/lang/String;->concat(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v5

    invoke-virtual {v0, v5}, Landroid/widget/Button;->setText(Ljava/lang/CharSequence;)V

    .line 211
    :cond_6
    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->musicSaverToggle:Landroid/widget/Button;

    if-eqz v0, :cond_8

    iget-object v5, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->music:Lru/oopssre/imperialschool/viewstv/SceneMusic;

    invoke-virtual {v5, v1}, Lru/oopssre/imperialschool/viewstv/SceneMusic;->isEnabled(Z)Z

    move-result v5

    if-eqz v5, :cond_7

    goto :goto_3

    :cond_7
    move-object v3, v4

    :goto_3
    const-string v4, "\u041c\u0443\u0437\u044b\u043a\u0430 \u0432 \u0437\u0430\u0441\u0442\u0430\u0432\u043a\u0435 \u00b7 "

    invoke-virtual {v4, v3}, Ljava/lang/String;->concat(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v3

    invoke-virtual {v0, v3}, Landroid/widget/Button;->setText(Ljava/lang/CharSequence;)V

    .line 212
    :cond_8
    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->volumeControl:Landroid/widget/Button;

    if-eqz v0, :cond_9

    new-instance v3, Ljava/lang/StringBuilder;

    const-string v4, "\u0413\u0440\u043e\u043c\u043a\u043e\u0441\u0442\u044c \u00b7 "

    invoke-direct {v3, v4}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    iget-object v4, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->music:Lru/oopssre/imperialschool/viewstv/SceneMusic;

    invoke-virtual {v4}, Lru/oopssre/imperialschool/viewstv/SceneMusic;->level()I

    move-result v4

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v3

    const-string v4, "%   \u2039  \u203a"

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v3

    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v3

    invoke-virtual {v0, v3}, Landroid/widget/Button;->setText(Ljava/lang/CharSequence;)V

    .line 213
    :cond_9
    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->previousTrack:Landroid/widget/Button;

    if-eqz v0, :cond_b

    iget-boolean v3, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->cacheBusy:Z

    if-nez v3, :cond_a

    iget-object v3, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->music:Lru/oopssre/imperialschool/viewstv/SceneMusic;

    invoke-virtual {v3}, Lru/oopssre/imperialschool/viewstv/SceneMusic;->canChangeTrack()Z

    move-result v3

    if-eqz v3, :cond_a

    move v3, v1

    goto :goto_4

    :cond_a
    move v3, v2

    :goto_4
    invoke-virtual {v0, v3}, Landroid/widget/Button;->setEnabled(Z)V

    .line 214
    :cond_b
    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->nextTrack:Landroid/widget/Button;

    if-eqz v0, :cond_d

    iget-boolean v3, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->cacheBusy:Z

    if-nez v3, :cond_c

    iget-object v3, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->music:Lru/oopssre/imperialschool/viewstv/SceneMusic;

    invoke-virtual {v3}, Lru/oopssre/imperialschool/viewstv/SceneMusic;->canChangeTrack()Z

    move-result v3

    if-eqz v3, :cond_c

    goto :goto_5

    :cond_c
    move v1, v2

    :goto_5
    invoke-virtual {v0, v1}, Landroid/widget/Button;->setEnabled(Z)V

    :cond_d
    :goto_6
    return-void
.end method

.method musicCredits()V
    .locals 5

    .line 268
    const-string v0, "music_credits"

    const-string v1, "\u041c\u0443\u0437\u044b\u043a\u0430 \u0438 \u0430\u0432\u0442\u043e\u0440\u044b"

    invoke-virtual {p0, v0, v1}, Lru/oopssre/imperialschool/viewstv/TvScene;->beginPage(Ljava/lang/String;Ljava/lang/String;)V

    .line 269
    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->music:Lru/oopssre/imperialschool/viewstv/SceneMusic;

    iget-object v0, v0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->pack:Lru/oopssre/imperialschool/viewstv/MusicPacks$Pack;

    if-nez v0, :cond_0

    const-string v0, "\u0414\u043b\u044f \u0442\u0435\u043a\u0443\u0449\u0435\u0439 \u0442\u0435\u043c\u044b \u043c\u0443\u0437\u044b\u043a\u0430 \u043f\u043e\u043a\u0430 \u043d\u0435\u0434\u043e\u0441\u0442\u0443\u043f\u043d\u0430."

    invoke-virtual {p0, v0}, Lru/oopssre/imperialschool/viewstv/TvScene;->message(Ljava/lang/String;)V

    goto :goto_1

    .line 270
    :cond_0
    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->music:Lru/oopssre/imperialschool/viewstv/SceneMusic;

    iget-object v0, v0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->pack:Lru/oopssre/imperialschool/viewstv/MusicPacks$Pack;

    iget-object v0, v0, Lru/oopssre/imperialschool/viewstv/MusicPacks$Pack;->tracks:Ljava/util/List;

    invoke-interface {v0}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object v0

    :goto_0
    invoke-interface {v0}, Ljava/util/Iterator;->hasNext()Z

    move-result v1

    if-eqz v1, :cond_1

    invoke-interface {v0}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Lru/oopssre/imperialschool/viewstv/MusicPacks$Track;

    .line 271
    iget-object v2, v1, Lru/oopssre/imperialschool/viewstv/MusicPacks$Track;->file:Ljava/lang/String;

    iget-object v3, v1, Lru/oopssre/imperialschool/viewstv/MusicPacks$Track;->title:Ljava/lang/String;

    new-instance v4, Lru/oopssre/imperialschool/viewstv/TvScene$$ExternalSyntheticLambda19;

    invoke-direct {v4, p0, v1}, Lru/oopssre/imperialschool/viewstv/TvScene$$ExternalSyntheticLambda19;-><init>(Lru/oopssre/imperialschool/viewstv/TvScene;Lru/oopssre/imperialschool/viewstv/MusicPacks$Track;)V

    invoke-virtual {p0, v2, v3, v4}, Lru/oopssre/imperialschool/viewstv/TvScene;->button(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Runnable;)Landroid/widget/Button;

    goto :goto_0

    .line 273
    :cond_1
    :goto_1
    invoke-virtual {p0}, Lru/oopssre/imperialschool/viewstv/TvScene;->focusFirst()V

    return-void
.end method

.method musicMenu()V
    .locals 8

    .line 217
    const-string v0, "music"

    const-string v1, "\u041c\u0443\u0437\u044b\u043a\u0430"

    invoke-virtual {p0, v0, v1}, Lru/oopssre/imperialschool/viewstv/TvScene;->beginPage(Ljava/lang/String;Ljava/lang/String;)V

    const-string v0, ""

    const/16 v1, 0x14

    invoke-virtual {p0, v0, v1}, Lru/oopssre/imperialschool/viewstv/TvScene;->text(Ljava/lang/String;I)Landroid/widget/TextView;

    move-result-object v0

    iput-object v0, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->musicDetails:Landroid/widget/TextView;

    invoke-virtual {p0, v1}, Lru/oopssre/imperialschool/viewstv/TvScene;->dp(I)I

    move-result v1

    const/4 v2, 0x0

    invoke-virtual {v0, v2, v2, v2, v1}, Landroid/widget/TextView;->setPadding(IIII)V

    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->content:Landroid/widget/LinearLayout;

    iget-object v1, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->musicDetails:Landroid/widget/TextView;

    invoke-virtual {v0, v1}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    .line 218
    new-instance v0, Lru/oopssre/imperialschool/viewstv/TvScene$$ExternalSyntheticLambda24;

    invoke-direct {v0, p0}, Lru/oopssre/imperialschool/viewstv/TvScene$$ExternalSyntheticLambda24;-><init>(Lru/oopssre/imperialschool/viewstv/TvScene;)V

    const-string v1, "app-sound"

    const-string v3, "\u041c\u0443\u0437\u044b\u043a\u0430 \u0432 \u043f\u0440\u0438\u043b\u043e\u0436\u0435\u043d\u0438\u0438"

    invoke-virtual {p0, v1, v3, v0}, Lru/oopssre/imperialschool/viewstv/TvScene;->button(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Runnable;)Landroid/widget/Button;

    move-result-object v0

    iput-object v0, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->musicToggle:Landroid/widget/Button;

    .line 219
    new-instance v0, Lru/oopssre/imperialschool/viewstv/TvScene$$ExternalSyntheticLambda25;

    invoke-direct {v0, p0}, Lru/oopssre/imperialschool/viewstv/TvScene$$ExternalSyntheticLambda25;-><init>(Lru/oopssre/imperialschool/viewstv/TvScene;)V

    const-string v1, "saver-sound"

    const-string v3, "\u041c\u0443\u0437\u044b\u043a\u0430 \u0432 \u0437\u0430\u0441\u0442\u0430\u0432\u043a\u0435"

    invoke-virtual {p0, v1, v3, v0}, Lru/oopssre/imperialschool/viewstv/TvScene;->button(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Runnable;)Landroid/widget/Button;

    move-result-object v0

    iput-object v0, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->musicSaverToggle:Landroid/widget/Button;

    .line 220
    new-instance v0, Lru/oopssre/imperialschool/viewstv/TvScene$$ExternalSyntheticLambda26;

    invoke-direct {v0, p0}, Lru/oopssre/imperialschool/viewstv/TvScene$$ExternalSyntheticLambda26;-><init>(Lru/oopssre/imperialschool/viewstv/TvScene;)V

    const-string v1, "volume"

    const-string v3, "\u0413\u0440\u043e\u043c\u043a\u043e\u0441\u0442\u044c"

    invoke-virtual {p0, v1, v3, v0}, Lru/oopssre/imperialschool/viewstv/TvScene;->button(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Runnable;)Landroid/widget/Button;

    move-result-object v0

    iput-object v0, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->volumeControl:Landroid/widget/Button;

    .line 221
    new-instance v1, Lru/oopssre/imperialschool/viewstv/TvScene$$ExternalSyntheticLambda27;

    invoke-direct {v1, p0}, Lru/oopssre/imperialschool/viewstv/TvScene$$ExternalSyntheticLambda27;-><init>(Lru/oopssre/imperialschool/viewstv/TvScene;)V

    invoke-virtual {v0, v1}, Landroid/widget/Button;->setOnKeyListener(Landroid/view/View$OnKeyListener;)V

    .line 222
    new-instance v0, Landroid/widget/LinearLayout;

    iget-object v1, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->context:Landroid/content/Context;

    invoke-direct {v0, v1}, Landroid/widget/LinearLayout;-><init>(Landroid/content/Context;)V

    .line 223
    new-instance v1, Landroid/widget/LinearLayout$LayoutParams;

    const/4 v3, -0x2

    const/high16 v4, 0x3f800000    # 1.0f

    invoke-direct {v1, v2, v3, v4}, Landroid/widget/LinearLayout$LayoutParams;-><init>(IIF)V

    const/16 v5, 0xa

    invoke-virtual {p0, v5}, Lru/oopssre/imperialschool/viewstv/TvScene;->dp(I)I

    move-result v5

    iput v5, v1, Landroid/widget/LinearLayout$LayoutParams;->rightMargin:I

    .line 224
    iget-object v5, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->music:Lru/oopssre/imperialschool/viewstv/SceneMusic;

    invoke-static {v5}, Ljava/util/Objects;->requireNonNull(Ljava/lang/Object;)Ljava/lang/Object;

    new-instance v6, Lru/oopssre/imperialschool/viewstv/TvScene$$ExternalSyntheticLambda28;

    invoke-direct {v6, v5}, Lru/oopssre/imperialschool/viewstv/TvScene$$ExternalSyntheticLambda28;-><init>(Lru/oopssre/imperialschool/viewstv/SceneMusic;)V

    const-string v5, "previous"

    const-string v7, "\u041f\u0440\u0435\u0434\u044b\u0434\u0443\u0449\u0438\u0439"

    invoke-virtual {p0, v5, v7, v6}, Lru/oopssre/imperialschool/viewstv/TvScene;->makeButton(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Runnable;)Landroid/widget/Button;

    move-result-object v5

    iput-object v5, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->previousTrack:Landroid/widget/Button;

    .line 225
    iget-object v5, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->music:Lru/oopssre/imperialschool/viewstv/SceneMusic;

    invoke-static {v5}, Ljava/util/Objects;->requireNonNull(Ljava/lang/Object;)Ljava/lang/Object;

    new-instance v6, Lru/oopssre/imperialschool/viewstv/TvScene$$ExternalSyntheticLambda29;

    invoke-direct {v6, v5}, Lru/oopssre/imperialschool/viewstv/TvScene$$ExternalSyntheticLambda29;-><init>(Lru/oopssre/imperialschool/viewstv/SceneMusic;)V

    const-string v5, "next"

    const-string v7, "\u0421\u043b\u0435\u0434\u0443\u044e\u0449\u0438\u0439"

    invoke-virtual {p0, v5, v7, v6}, Lru/oopssre/imperialschool/viewstv/TvScene;->makeButton(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Runnable;)Landroid/widget/Button;

    move-result-object v5

    iput-object v5, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->nextTrack:Landroid/widget/Button;

    .line 226
    iget-object v5, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->previousTrack:Landroid/widget/Button;

    invoke-static {}, Landroid/view/View;->generateViewId()I

    move-result v6

    invoke-virtual {v5, v6}, Landroid/widget/Button;->setId(I)V

    iget-object v5, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->nextTrack:Landroid/widget/Button;

    invoke-static {}, Landroid/view/View;->generateViewId()I

    move-result v6

    invoke-virtual {v5, v6}, Landroid/widget/Button;->setId(I)V

    .line 227
    iget-object v5, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->previousTrack:Landroid/widget/Button;

    iget-object v6, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->nextTrack:Landroid/widget/Button;

    invoke-virtual {v6}, Landroid/widget/Button;->getId()I

    move-result v6

    invoke-virtual {v5, v6}, Landroid/widget/Button;->setNextFocusRightId(I)V

    iget-object v5, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->nextTrack:Landroid/widget/Button;

    iget-object v6, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->previousTrack:Landroid/widget/Button;

    invoke-virtual {v6}, Landroid/widget/Button;->getId()I

    move-result v6

    invoke-virtual {v5, v6}, Landroid/widget/Button;->setNextFocusLeftId(I)V

    .line 228
    iget-object v5, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->previousTrack:Landroid/widget/Button;

    invoke-virtual {v0, v5, v1}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    .line 229
    iget-object v1, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->nextTrack:Landroid/widget/Button;

    new-instance v5, Landroid/widget/LinearLayout$LayoutParams;

    invoke-direct {v5, v2, v3, v4}, Landroid/widget/LinearLayout$LayoutParams;-><init>(IIF)V

    invoke-virtual {v0, v1, v5}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    .line 230
    iget-object v1, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->content:Landroid/widget/LinearLayout;

    invoke-virtual {p0}, Lru/oopssre/imperialschool/viewstv/TvScene;->buttonLayout()Landroid/widget/LinearLayout$LayoutParams;

    move-result-object v2

    invoke-virtual {v1, v0, v2}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    .line 231
    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->music:Lru/oopssre/imperialschool/viewstv/SceneMusic;

    iget-object v0, v0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->stations:Lru/oopssre/imperialschool/viewstv/ThemeStations;

    invoke-virtual {p0}, Lru/oopssre/imperialschool/viewstv/TvScene;->musicTheme()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Lru/oopssre/imperialschool/viewstv/ThemeStations;->forTheme(Ljava/lang/String;)Ljava/util/List;

    move-result-object v0

    invoke-interface {v0}, Ljava/util/List;->isEmpty()Z

    move-result v0

    if-nez v0, :cond_0

    new-instance v0, Lru/oopssre/imperialschool/viewstv/TvScene$$ExternalSyntheticLambda30;

    invoke-direct {v0, p0}, Lru/oopssre/imperialschool/viewstv/TvScene$$ExternalSyntheticLambda30;-><init>(Lru/oopssre/imperialschool/viewstv/TvScene;)V

    const-string v1, "\u0421\u0442\u0430\u043d\u0446\u0438\u0438 \u0442\u0435\u043c\u044b"

    invoke-virtual {p0, v1, v0}, Lru/oopssre/imperialschool/viewstv/TvScene;->button(Ljava/lang/String;Ljava/lang/Runnable;)Landroid/widget/Button;

    .line 232
    :cond_0
    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->music:Lru/oopssre/imperialschool/viewstv/SceneMusic;

    invoke-virtual {v0}, Lru/oopssre/imperialschool/viewstv/SceneMusic;->radio()Z

    move-result v0

    if-eqz v0, :cond_1

    new-instance v0, Lru/oopssre/imperialschool/viewstv/TvScene$$ExternalSyntheticLambda31;

    invoke-direct {v0, p0}, Lru/oopssre/imperialschool/viewstv/TvScene$$ExternalSyntheticLambda31;-><init>(Lru/oopssre/imperialschool/viewstv/TvScene;)V

    const-string v1, "\u041c\u0443\u0437\u044b\u043a\u0430 \u0442\u0435\u043c\u044b"

    invoke-virtual {p0, v1, v0}, Lru/oopssre/imperialschool/viewstv/TvScene;->button(Ljava/lang/String;Ljava/lang/Runnable;)Landroid/widget/Button;

    .line 233
    :cond_1
    invoke-virtual {p0}, Lru/oopssre/imperialschool/viewstv/TvScene;->musicChanged()V

    invoke-virtual {p0}, Lru/oopssre/imperialschool/viewstv/TvScene;->focusFirst()V

    return-void
.end method

.method musicTheme()Ljava/lang/String;
    .locals 1

    .line 97
    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->repo:Lru/oopssre/imperialschool/viewstv/Repository;

    invoke-virtual {v0}, Lru/oopssre/imperialschool/viewstv/Repository;->selected()Lru/oopssre/imperialschool/viewstv/Protocol$Theme;

    move-result-object v0

    iget-object v0, v0, Lru/oopssre/imperialschool/viewstv/Protocol$Theme;->id:Ljava/lang/String;

    return-object v0
.end method

.method openSettings()V
    .locals 3

    invoke-direct {p0}, Lru/oopssre/imperialschool/viewstv/TvScene;->resetExitBack()V

    .line 150
    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->placeholder:Landroid/widget/TextView;

    const/16 v1, 0x8

    invoke-virtual {v0, v1}, Landroid/widget/TextView;->setVisibility(I)V

    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->panel:Landroid/widget/ScrollView;

    const/4 v2, 0x0

    invoke-virtual {v0, v2}, Landroid/widget/ScrollView;->setVisibility(I)V

    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->hint:Landroid/widget/TextView;

    invoke-virtual {v0, v1}, Landroid/widget/TextView;->setVisibility(I)V

    .line 151
    const-string v0, "menu"

    const-string v1, "\u0412\u0438\u0434\u044b \u0428\u043a\u043e\u043b\u044b \u0418\u043c\u043f\u0435\u0440\u0438\u0438"

    invoke-virtual {p0, v0, v1}, Lru/oopssre/imperialschool/viewstv/TvScene;->beginPage(Ljava/lang/String;Ljava/lang/String;)V

    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->repo:Lru/oopssre/imperialschool/viewstv/Repository;

    invoke-virtual {v0}, Lru/oopssre/imperialschool/viewstv/Repository;->selected()Lru/oopssre/imperialschool/viewstv/Protocol$Theme;

    move-result-object v0

    invoke-static {v0}, Lru/oopssre/imperialschool/viewstv/ThemeText;->title(Lru/oopssre/imperialschool/viewstv/Protocol$Theme;)Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p0, v0}, Lru/oopssre/imperialschool/viewstv/TvScene;->message(Ljava/lang/String;)V

    .line 152
    new-instance v0, Lru/oopssre/imperialschool/viewstv/TvScene$$ExternalSyntheticLambda35;

    invoke-direct {v0, p0}, Lru/oopssre/imperialschool/viewstv/TvScene$$ExternalSyntheticLambda35;-><init>(Lru/oopssre/imperialschool/viewstv/TvScene;)V

    const-string v1, "themes"

    const-string v2, "\u0412\u044b\u0431\u0440\u0430\u0442\u044c \u043e\u0431\u043e\u0438"

    invoke-virtual {p0, v1, v2, v0}, Lru/oopssre/imperialschool/viewstv/TvScene;->button(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Runnable;)Landroid/widget/Button;

    .line 153
    invoke-virtual {p0}, Lru/oopssre/imperialschool/viewstv/TvScene;->musicAvailable()Z

    move-result v0

    if-eqz v0, :cond_0

    new-instance v0, Lru/oopssre/imperialschool/viewstv/TvScene$$ExternalSyntheticLambda36;

    invoke-direct {v0, p0}, Lru/oopssre/imperialschool/viewstv/TvScene$$ExternalSyntheticLambda36;-><init>(Lru/oopssre/imperialschool/viewstv/TvScene;)V

    const-string v1, "music"

    const-string v2, "\u041c\u0443\u0437\u044b\u043a\u0430"

    invoke-virtual {p0, v1, v2, v0}, Lru/oopssre/imperialschool/viewstv/TvScene;->button(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Runnable;)Landroid/widget/Button;

    .line 154
    :cond_0
    new-instance v0, Lru/oopssre/imperialschool/viewstv/TvScene$$ExternalSyntheticLambda37;

    invoke-direct {v0, p0}, Lru/oopssre/imperialschool/viewstv/TvScene$$ExternalSyntheticLambda37;-><init>(Lru/oopssre/imperialschool/viewstv/TvScene;)V

    const-string v1, "settings"

    const-string v2, "\u041d\u0430\u0441\u0442\u0440\u043e\u0439\u043a\u0438"

    invoke-virtual {p0, v1, v2, v0}, Lru/oopssre/imperialschool/viewstv/TvScene;->button(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Runnable;)Landroid/widget/Button;

    invoke-virtual {p0}, Lru/oopssre/imperialschool/viewstv/TvScene;->focusFirst()V

    return-void
.end method

.method outputList()V
    .locals 12

    .line 176
    const-string v0, "output"

    const-string v1, "\u0421\u043f\u043e\u0441\u043e\u0431 \u043f\u043e\u043a\u0430\u0437\u0430"

    invoke-virtual {p0, v0, v1}, Lru/oopssre/imperialschool/viewstv/TvScene;->beginPage(Ljava/lang/String;Ljava/lang/String;)V

    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->repo:Lru/oopssre/imperialschool/viewstv/Repository;

    invoke-virtual {v0}, Lru/oopssre/imperialschool/viewstv/Repository;->videoPreferred()Z

    move-result v0

    const-string v1, "\u2713 "

    const-string v2, ""

    if-nez v0, :cond_0

    move-object v0, v1

    goto :goto_0

    :cond_0
    move-object v0, v2

    :goto_0
    const-string v3, "\u0418\u0437\u043e\u0431\u0440\u0430\u0436\u0435\u043d\u0438\u0435"

    invoke-virtual {v0, v3}, Ljava/lang/String;->concat(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    new-instance v3, Lru/oopssre/imperialschool/viewstv/TvScene$$ExternalSyntheticLambda39;

    invoke-direct {v3, p0}, Lru/oopssre/imperialschool/viewstv/TvScene$$ExternalSyntheticLambda39;-><init>(Lru/oopssre/imperialschool/viewstv/TvScene;)V

    const-string v4, "image"

    invoke-virtual {p0, v4, v0, v3}, Lru/oopssre/imperialschool/viewstv/TvScene;->button(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Runnable;)Landroid/widget/Button;

    .line 177
    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->repo:Lru/oopssre/imperialschool/viewstv/Repository;

    invoke-virtual {v0}, Lru/oopssre/imperialschool/viewstv/Repository;->videoPreferred()Z

    move-result v0

    if-eqz v0, :cond_1

    goto :goto_1

    :cond_1
    move-object v1, v2

    :goto_1
    const-string v0, "\u0412\u0438\u0434\u0435\u043e 4\u041a"

    invoke-virtual {v1, v0}, Ljava/lang/String;->concat(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    new-instance v1, Lru/oopssre/imperialschool/viewstv/TvScene$$ExternalSyntheticLambda40;

    invoke-direct {v1, p0}, Lru/oopssre/imperialschool/viewstv/TvScene$$ExternalSyntheticLambda40;-><init>(Lru/oopssre/imperialschool/viewstv/TvScene;)V

    const-string v2, "video"

    invoke-virtual {p0, v2, v0, v1}, Lru/oopssre/imperialschool/viewstv/TvScene;->button(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Runnable;)Landroid/widget/Button;

    move-result-object v10

    const/4 v0, 0x0

    invoke-virtual {v10, v0}, Landroid/widget/Button;->setEnabled(Z)V

    .line 178
    const-string v1, "\u041f\u0440\u043e\u0432\u0435\u0440\u044f\u044e \u0434\u043e\u0441\u0442\u0443\u043f\u043d\u043e\u0441\u0442\u044c \u0432\u0438\u0434\u0435\u043e\u2026"

    const/16 v3, 0x12

    invoke-virtual {p0, v1, v3}, Lru/oopssre/imperialschool/viewstv/TvScene;->text(Ljava/lang/String;I)Landroid/widget/TextView;

    move-result-object v11

    const/16 v1, 0xc

    invoke-virtual {p0, v1}, Lru/oopssre/imperialschool/viewstv/TvScene;->dp(I)I

    move-result v1

    invoke-virtual {v11, v0, v1, v0, v0}, Landroid/widget/TextView;->setPadding(IIII)V

    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->content:Landroid/widget/LinearLayout;

    invoke-virtual {v0, v11}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->repo:Lru/oopssre/imperialschool/viewstv/Repository;

    invoke-virtual {v0}, Lru/oopssre/imperialschool/viewstv/Repository;->videoPreferred()Z

    move-result v0

    if-eqz v0, :cond_2

    move-object v4, v2

    :cond_2
    invoke-virtual {p0, v4}, Lru/oopssre/imperialschool/viewstv/TvScene;->focusFirst(Ljava/lang/String;)V

    .line 179
    iget-wide v8, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->capabilityGeneration:J

    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->repo:Lru/oopssre/imperialschool/viewstv/Repository;

    invoke-virtual {v0}, Lru/oopssre/imperialschool/viewstv/Repository;->selected()Lru/oopssre/imperialschool/viewstv/Protocol$Theme;

    move-result-object v7

    .line 180
    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->updateWorker:Ljava/util/concurrent/ExecutorService;

    new-instance v5, Lru/oopssre/imperialschool/viewstv/TvScene$$ExternalSyntheticLambda41;

    move-object v6, p0

    invoke-direct/range {v5 .. v11}, Lru/oopssre/imperialschool/viewstv/TvScene$$ExternalSyntheticLambda41;-><init>(Lru/oopssre/imperialschool/viewstv/TvScene;Lru/oopssre/imperialschool/viewstv/Protocol$Theme;JLandroid/widget/Button;Landroid/widget/TextView;)V

    invoke-interface {v0, v5}, Ljava/util/concurrent/ExecutorService;->submit(Ljava/lang/Runnable;)Ljava/util/concurrent/Future;

    move-result-object v0

    iput-object v0, v6, Lru/oopssre/imperialschool/viewstv/TvScene;->capabilityJob:Ljava/util/concurrent/Future;

    return-void
.end method

.method pausePlayback()V
    .locals 3

    invoke-direct {p0}, Lru/oopssre/imperialschool/viewstv/TvScene;->resetExitBack()V

    .line 119
    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->music:Lru/oopssre/imperialschool/viewstv/SceneMusic;

    const/4 v1, 0x0

    invoke-virtual {p0}, Lru/oopssre/imperialschool/viewstv/TvScene;->musicTheme()Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v0, v1, v2}, Lru/oopssre/imperialschool/viewstv/SceneMusic;->scene(ZLjava/lang/String;)V

    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->controller:Lru/oopssre/imperialschool/viewstv/SceneController;

    invoke-virtual {v0}, Lru/oopssre/imperialschool/viewstv/SceneController;->stop()V

    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->videoController:Lru/oopssre/imperialschool/viewstv/VideoController;

    invoke-virtual {v0}, Lru/oopssre/imperialschool/viewstv/VideoController;->stop()V

    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->video:Lru/oopssre/imperialschool/viewstv/VideoSurface;

    invoke-virtual {v0}, Lru/oopssre/imperialschool/viewstv/VideoSurface;->stop()V

    return-void
.end method

.method personal()Z
    .locals 3

    .line 202
    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->repo:Lru/oopssre/imperialschool/viewstv/Repository;

    iget-object v0, v0, Lru/oopssre/imperialschool/viewstv/Repository;->prefs:Landroid/content/SharedPreferences;

    const-string v1, "personal_mode"

    const/4 v2, 0x0

    invoke-interface {v0, v1, v2}, Landroid/content/SharedPreferences;->getBoolean(Ljava/lang/String;Z)Z

    move-result v0

    return v0
.end method

.method personalMenu()V
    .locals 2

    .line 236
    const-string v0, "personal"

    const-string v1, "\u041b\u0438\u0447\u043d\u044b\u0439 \u0440\u0435\u0436\u0438\u043c"

    invoke-virtual {p0, v0, v1}, Lru/oopssre/imperialschool/viewstv/TvScene;->beginPage(Ljava/lang/String;Ljava/lang/String;)V

    .line 237
    invoke-virtual {p0}, Lru/oopssre/imperialschool/viewstv/TvScene;->personal()Z

    move-result v0

    if-eqz v0, :cond_1

    .line 238
    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->music:Lru/oopssre/imperialschool/viewstv/SceneMusic;

    iget-object v0, v0, Lru/oopssre/imperialschool/viewstv/SceneMusic;->stations:Lru/oopssre/imperialschool/viewstv/ThemeStations;

    invoke-virtual {p0}, Lru/oopssre/imperialschool/viewstv/TvScene;->musicTheme()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Lru/oopssre/imperialschool/viewstv/ThemeStations;->forTheme(Ljava/lang/String;)Ljava/util/List;

    move-result-object v0

    invoke-interface {v0}, Ljava/util/List;->isEmpty()Z

    move-result v0

    if-nez v0, :cond_0

    new-instance v0, Lru/oopssre/imperialschool/viewstv/TvScene$$ExternalSyntheticLambda57;

    invoke-direct {v0, p0}, Lru/oopssre/imperialschool/viewstv/TvScene$$ExternalSyntheticLambda57;-><init>(Lru/oopssre/imperialschool/viewstv/TvScene;)V

    const-string v1, "\u0421\u0442\u0430\u043d\u0446\u0438\u0438 \u0442\u0435\u043c\u044b"

    invoke-virtual {p0, v1, v0}, Lru/oopssre/imperialschool/viewstv/TvScene;->button(Ljava/lang/String;Ljava/lang/Runnable;)Landroid/widget/Button;

    goto :goto_0

    .line 239
    :cond_0
    const-string v0, "\u0423 \u044d\u0442\u043e\u0439 \u0442\u0435\u043c\u044b \u043f\u043e\u043a\u0430 \u043d\u0435\u0442 \u0441\u0442\u0430\u043d\u0446\u0438\u0439."

    invoke-virtual {p0, v0}, Lru/oopssre/imperialschool/viewstv/TvScene;->message(Ljava/lang/String;)V

    .line 240
    :goto_0
    new-instance v0, Lru/oopssre/imperialschool/viewstv/TvScene$$ExternalSyntheticLambda58;

    invoke-direct {v0, p0}, Lru/oopssre/imperialschool/viewstv/TvScene$$ExternalSyntheticLambda58;-><init>(Lru/oopssre/imperialschool/viewstv/TvScene;)V

    const-string v1, "\u0412\u044b\u043a\u043b\u044e\u0447\u0438\u0442\u044c \u043b\u0438\u0447\u043d\u044b\u0439 \u0440\u0435\u0436\u0438\u043c"

    invoke-virtual {p0, v1, v0}, Lru/oopssre/imperialschool/viewstv/TvScene;->button(Ljava/lang/String;Ljava/lang/Runnable;)Landroid/widget/Button;

    goto :goto_1

    .line 245
    :cond_1
    new-instance v0, Lru/oopssre/imperialschool/viewstv/TvScene$$ExternalSyntheticLambda59;

    invoke-direct {v0, p0}, Lru/oopssre/imperialschool/viewstv/TvScene$$ExternalSyntheticLambda59;-><init>(Lru/oopssre/imperialschool/viewstv/TvScene;)V

    const-string v1, "\u0412\u0432\u0435\u0441\u0442\u0438 \u043a\u043e\u0434"

    invoke-virtual {p0, v1, v0}, Lru/oopssre/imperialschool/viewstv/TvScene;->button(Ljava/lang/String;Ljava/lang/Runnable;)Landroid/widget/Button;

    .line 246
    :goto_1
    invoke-virtual {p0}, Lru/oopssre/imperialschool/viewstv/TvScene;->focusFirst()V

    return-void
.end method

.method projectLink(Z)V
    .locals 4

    .line 196
    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->page:Ljava/lang/String;

    const-string v1, "credits_detail"

    invoke-virtual {v0, v1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_0

    goto :goto_0

    :cond_0
    const-string v1, "info"

    :goto_0
    iput-object v1, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->projectReturn:Ljava/lang/String;

    iput-boolean p1, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->projectCode:Z

    if-eqz p1, :cond_1

    const-string v0, "\u0418\u0441\u0445\u043e\u0434\u043d\u044b\u0439 \u043a\u043e\u0434"

    goto :goto_1

    :cond_1
    const-string v0, "\u0421\u0430\u0439\u0442 \u043f\u0440\u043e\u0435\u043a\u0442\u0430"

    :goto_1
    const-string v1, "project"

    invoke-virtual {p0, v1, v0}, Lru/oopssre/imperialschool/viewstv/TvScene;->beginPage(Ljava/lang/String;Ljava/lang/String;)V

    if-eqz p1, :cond_2

    const-string v0, "https://github.com/GremlinEngineering/imperial-school-views"

    goto :goto_2

    :cond_2
    const-string v0, "https://games.oopssre.ru/gremlin.html#views"

    .line 197
    :goto_2
    const-string v1, "\u041e\u0442\u043a\u0440\u043e\u0439\u0442\u0435 \u0441\u0441\u044b\u043b\u043a\u0443 \u043d\u0430 \u0442\u0435\u043b\u0435\u0444\u043e\u043d\u0435 \u0438\u043b\u0438 \u043a\u043e\u043c\u043f\u044c\u044e\u0442\u0435\u0440\u0435."

    invoke-virtual {p0, v1}, Lru/oopssre/imperialschool/viewstv/TvScene;->message(Ljava/lang/String;)V

    .line 198
    new-instance v1, Lru/oopssre/imperialschool/viewstv/QrView;

    iget-object v2, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->context:Landroid/content/Context;

    invoke-direct {v1, v2, p1}, Lru/oopssre/imperialschool/viewstv/QrView;-><init>(Landroid/content/Context;Z)V

    new-instance p1, Landroid/widget/LinearLayout$LayoutParams;

    const/16 v2, 0xc4

    invoke-virtual {p0, v2}, Lru/oopssre/imperialschool/viewstv/TvScene;->dp(I)I

    move-result v3

    invoke-virtual {p0, v2}, Lru/oopssre/imperialschool/viewstv/TvScene;->dp(I)I

    move-result v2

    invoke-direct {p1, v3, v2}, Landroid/widget/LinearLayout$LayoutParams;-><init>(II)V

    const/16 v2, 0x10

    invoke-virtual {p0, v2}, Lru/oopssre/imperialschool/viewstv/TvScene;->dp(I)I

    move-result v3

    iput v3, p1, Landroid/widget/LinearLayout$LayoutParams;->bottomMargin:I

    iget-object v3, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->content:Landroid/widget/LinearLayout;

    invoke-virtual {v3, v1, p1}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    const/16 p1, 0x12

    .line 199
    invoke-virtual {p0, v0, p1}, Lru/oopssre/imperialschool/viewstv/TvScene;->text(Ljava/lang/String;I)Landroid/widget/TextView;

    move-result-object p1

    const/4 v1, 0x0

    invoke-virtual {p1, v1}, Landroid/widget/TextView;->setTextIsSelectable(Z)V

    invoke-virtual {p0, v2}, Lru/oopssre/imperialschool/viewstv/TvScene;->dp(I)I

    move-result v2

    invoke-virtual {p1, v1, v1, v1, v2}, Landroid/widget/TextView;->setPadding(IIII)V

    iget-object v1, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->content:Landroid/widget/LinearLayout;

    invoke-virtual {v1, p1}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    .line 200
    new-instance p1, Lru/oopssre/imperialschool/viewstv/TvScene$$ExternalSyntheticLambda20;

    invoke-direct {p1, p0, v0}, Lru/oopssre/imperialschool/viewstv/TvScene$$ExternalSyntheticLambda20;-><init>(Lru/oopssre/imperialschool/viewstv/TvScene;Ljava/lang/String;)V

    const-string v0, "\u041e\u0442\u043a\u0440\u044b\u0442\u044c \u043d\u0430 \u0442\u0435\u043b\u0435\u0432\u0438\u0437\u043e\u0440\u0435"

    invoke-virtual {p0, v0, p1}, Lru/oopssre/imperialschool/viewstv/TvScene;->button(Ljava/lang/String;Ljava/lang/Runnable;)Landroid/widget/Button;

    invoke-virtual {p0}, Lru/oopssre/imperialschool/viewstv/TvScene;->focusFirst()V

    return-void
.end method

.method proxyMenu()V
    .locals 1

    .line 157
    new-instance v0, Lru/oopssre/imperialschool/viewstv/ProxyEditor;

    invoke-direct {v0, p0}, Lru/oopssre/imperialschool/viewstv/ProxyEditor;-><init>(Lru/oopssre/imperialschool/viewstv/TvScene;)V

    return-void
.end method

.method refreshDetails()V
    .locals 2

    .line 159
    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->page:Ljava/lang/String;

    const-string v1, "updates"

    invoke-virtual {v0, v1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_0

    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->details:Landroid/widget/TextView;

    if-eqz v0, :cond_0

    iget-object v1, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->updateStatus:Ljava/lang/String;

    invoke-virtual {v0, v1}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    :cond_0
    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->cacheDetails:Landroid/widget/TextView;

    if-eqz v0, :cond_1

    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->page:Ljava/lang/String;

    const-string v1, "cache"

    invoke-virtual {v0, v1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_1

    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->cacheDetails:Landroid/widget/TextView;

    invoke-virtual {p0}, Lru/oopssre/imperialschool/viewstv/TvScene;->cacheText()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    :cond_1
    return-void
.end method

.method refreshDiagnostics()V
    .locals 2

    .line 298
    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->page:Ljava/lang/String;

    const-string v1, "diagnostics"

    invoke-virtual {v0, v1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_0

    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->panel:Landroid/widget/ScrollView;

    invoke-virtual {v0}, Landroid/widget/ScrollView;->getVisibility()I

    move-result v0

    if-nez v0, :cond_0

    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->diagnosticDetails:Landroid/widget/TextView;

    if-eqz v0, :cond_0

    invoke-virtual {p0}, Lru/oopssre/imperialschool/viewstv/TvScene;->diagnosticsText()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    :cond_0
    return-void
.end method

.method refreshResolution(Z)V
    .locals 7

    .line 120
    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->host:Lru/oopssre/imperialschool/viewstv/TvScene$Host;

    invoke-interface {v0}, Lru/oopssre/imperialschool/viewstv/TvScene$Host;->window()Landroid/view/Window;

    move-result-object v0

    invoke-virtual {v0}, Landroid/view/Window;->getWindowManager()Landroid/view/WindowManager;

    move-result-object v0

    invoke-interface {v0}, Landroid/view/WindowManager;->getDefaultDisplay()Landroid/view/Display;

    move-result-object v0

    invoke-static {v0}, Lru/oopssre/imperialschool/viewstv/WallpaperSurface;->physicalSize(Landroid/view/Display;)[I

    move-result-object v0

    iput-object v0, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->detectedSize:[I

    invoke-virtual {p0}, Lru/oopssre/imperialschool/viewstv/TvScene;->configuredSize()[I

    move-result-object v0

    const/4 v1, 0x0

    aget v2, v0, v1

    iget-object v3, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->surface:Lru/oopssre/imperialschool/viewstv/WallpaperSurface;

    iget v3, v3, Lru/oopssre/imperialschool/viewstv/WallpaperSurface;->bufferWidth:I

    const/4 v4, 0x1

    if-ne v2, v3, :cond_1

    aget v2, v0, v4

    iget-object v3, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->surface:Lru/oopssre/imperialschool/viewstv/WallpaperSurface;

    iget v3, v3, Lru/oopssre/imperialschool/viewstv/WallpaperSurface;->bufferHeight:I

    if-eq v2, v3, :cond_0

    goto :goto_0

    :cond_0
    move v2, v1

    goto :goto_1

    :cond_1
    :goto_0
    move v2, v4

    :goto_1
    iget-object v3, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->repo:Lru/oopssre/imperialschool/viewstv/Repository;

    aget v5, v0, v1

    aget v6, v0, v4

    invoke-virtual {v3, v5, v6}, Lru/oopssre/imperialschool/viewstv/Repository;->displaySize(II)V

    if-eqz v2, :cond_2

    iget-object v2, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->surface:Lru/oopssre/imperialschool/viewstv/WallpaperSurface;

    aget v1, v0, v1

    aget v0, v0, v4

    invoke-virtual {v2, v1, v0}, Lru/oopssre/imperialschool/viewstv/WallpaperSurface;->size(II)V

    if-eqz p1, :cond_2

    invoke-virtual {p0}, Lru/oopssre/imperialschool/viewstv/TvScene;->videoEnabled()Z

    move-result p1

    if-nez p1, :cond_2

    iget-boolean p1, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->cacheBusy:Z

    if-nez p1, :cond_2

    iget-object p1, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->controller:Lru/oopssre/imperialschool/viewstv/SceneController;

    invoke-virtual {p1, v4}, Lru/oopssre/imperialschool/viewstv/SceneController;->refresh(Z)V

    :cond_2
    return-void
.end method

.method rememberFocus()V
    .locals 3

    .line 77
    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->content:Landroid/widget/LinearLayout;

    invoke-virtual {v0}, Landroid/widget/LinearLayout;->findFocus()Landroid/view/View;

    move-result-object v0

    if-eqz v0, :cond_0

    invoke-virtual {v0}, Landroid/view/View;->getTag()Ljava/lang/Object;

    move-result-object v1

    instance-of v1, v1, Ljava/lang/String;

    if-eqz v1, :cond_0

    iget-object v1, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->focusMemory:Ljava/util/Map;

    iget-object v2, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->page:Ljava/lang/String;

    invoke-virtual {v0}, Landroid/view/View;->getTag()Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Ljava/lang/String;

    invoke-interface {v1, v2, v0}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->scrollMemory:Ljava/util/Map;

    iget-object v1, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->page:Ljava/lang/String;

    invoke-virtual {p0}, Lru/oopssre/imperialschool/viewstv/TvScene;->activeScroll()Landroid/widget/ScrollView;

    move-result-object v2

    invoke-virtual {v2}, Landroid/widget/ScrollView;->getScrollY()I

    move-result v2

    invoke-static {v2}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v2

    invoke-interface {v0, v1, v2}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    :cond_0
    return-void
.end method

.method resetPlayback()V
    .locals 1

    .line 104
    const-string v0, "\u0417\u0430\u0433\u0440\u0443\u0436\u0430\u044e \u043e\u0431\u043e\u0438\u2026"

    iput-object v0, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->status:Ljava/lang/String;

    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->controller:Lru/oopssre/imperialschool/viewstv/SceneController;

    invoke-virtual {v0}, Lru/oopssre/imperialschool/viewstv/SceneController;->reset()V

    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->videoController:Lru/oopssre/imperialschool/viewstv/VideoController;

    invoke-virtual {v0}, Lru/oopssre/imperialschool/viewstv/VideoController;->reset()V

    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->video:Lru/oopssre/imperialschool/viewstv/VideoSurface;

    invoke-virtual {v0}, Lru/oopssre/imperialschool/viewstv/VideoSurface;->reset()V

    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->surface:Lru/oopssre/imperialschool/viewstv/WallpaperSurface;

    invoke-virtual {v0}, Lru/oopssre/imperialschool/viewstv/WallpaperSurface;->clear()V

    return-void
.end method

.method resolutionList()V
    .locals 6

    .line 190
    const-string v0, "resolution"

    const-string v1, "\u0420\u0430\u0437\u0440\u0435\u0448\u0435\u043d\u0438\u0435 \u0438\u0437\u043e\u0431\u0440\u0430\u0436\u0435\u043d\u0438\u044f"

    invoke-virtual {p0, v0, v1}, Lru/oopssre/imperialschool/viewstv/TvScene;->beginPage(Ljava/lang/String;Ljava/lang/String;)V

    const/4 v0, 0x3

    new-array v1, v0, [Ljava/lang/String;

    const-string v2, "auto"

    const/4 v3, 0x0

    aput-object v2, v1, v3

    const/4 v2, 0x1

    const-string v4, "4k"

    aput-object v4, v1, v2

    const/4 v2, 0x2

    const-string v4, "1080p"

    aput-object v4, v1, v2

    :goto_0
    if-ge v3, v0, :cond_1

    aget-object v2, v1, v3

    new-instance v4, Ljava/lang/StringBuilder;

    invoke-direct {v4}, Ljava/lang/StringBuilder;-><init>()V

    iget-object v5, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->repo:Lru/oopssre/imperialschool/viewstv/Repository;

    invoke-virtual {v5}, Lru/oopssre/imperialschool/viewstv/Repository;->resolution()Ljava/lang/String;

    move-result-object v5

    invoke-virtual {v2, v5}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v5

    if-eqz v5, :cond_0

    const-string v5, "\u2713 "

    goto :goto_1

    :cond_0
    const-string v5, ""

    :goto_1
    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v4

    invoke-static {v2}, Lru/oopssre/imperialschool/viewstv/TvDisplay;->label(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v5

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v4

    invoke-virtual {v4}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v4

    new-instance v5, Lru/oopssre/imperialschool/viewstv/TvScene$$ExternalSyntheticLambda51;

    invoke-direct {v5, p0, v2}, Lru/oopssre/imperialschool/viewstv/TvScene$$ExternalSyntheticLambda51;-><init>(Lru/oopssre/imperialschool/viewstv/TvScene;Ljava/lang/String;)V

    invoke-virtual {p0, v2, v4, v5}, Lru/oopssre/imperialschool/viewstv/TvScene;->button(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Runnable;)Landroid/widget/Button;

    add-int/lit8 v3, v3, 0x1

    goto :goto_0

    :cond_1
    const-string v0, "\u0415\u0441\u043b\u0438 4\u041a-\u0442\u0435\u043b\u0435\u0432\u0438\u0437\u043e\u0440 \u043e\u043f\u0440\u0435\u0434\u0435\u043b\u044f\u0435\u0442\u0441\u044f \u043a\u0430\u043a Full HD, \u0432\u044b\u0431\u0435\u0440\u0438\u0442\u0435 4\u041a \u0432\u0440\u0443\u0447\u043d\u0443\u044e."

    invoke-virtual {p0, v0}, Lru/oopssre/imperialschool/viewstv/TvScene;->message(Ljava/lang/String;)V

    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->repo:Lru/oopssre/imperialschool/viewstv/Repository;

    invoke-virtual {v0}, Lru/oopssre/imperialschool/viewstv/Repository;->resolution()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p0, v0}, Lru/oopssre/imperialschool/viewstv/TvScene;->focusFirst(Ljava/lang/String;)V

    return-void
.end method

.method resumePlayback()V
    .locals 5

    .line 118
    iget-boolean v0, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->cacheBusy:Z

    if-eqz v0, :cond_0

    return-void

    :cond_0
    invoke-virtual {p0}, Lru/oopssre/imperialschool/viewstv/TvScene;->videoEnabled()Z

    move-result v0

    iget-object v1, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->surface:Lru/oopssre/imperialschool/viewstv/WallpaperSurface;

    const/16 v2, 0x8

    const/4 v3, 0x0

    if-eqz v0, :cond_1

    move v4, v2

    goto :goto_0

    :cond_1
    move v4, v3

    :goto_0
    invoke-virtual {v1, v4}, Lru/oopssre/imperialschool/viewstv/WallpaperSurface;->setVisibility(I)V

    iget-object v1, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->video:Lru/oopssre/imperialschool/viewstv/VideoSurface;

    if-eqz v0, :cond_2

    move v2, v3

    :cond_2
    invoke-virtual {v1, v2}, Lru/oopssre/imperialschool/viewstv/VideoSurface;->setVisibility(I)V

    iget-object v1, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->music:Lru/oopssre/imperialschool/viewstv/SceneMusic;

    const/4 v2, 0x1

    invoke-virtual {p0}, Lru/oopssre/imperialschool/viewstv/TvScene;->musicTheme()Ljava/lang/String;

    move-result-object v3

    invoke-virtual {v1, v2, v3}, Lru/oopssre/imperialschool/viewstv/SceneMusic;->scene(ZLjava/lang/String;)V

    if-eqz v0, :cond_3

    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->controller:Lru/oopssre/imperialschool/viewstv/SceneController;

    invoke-virtual {v0}, Lru/oopssre/imperialschool/viewstv/SceneController;->stop()V

    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->video:Lru/oopssre/imperialschool/viewstv/VideoSurface;

    invoke-virtual {v0}, Lru/oopssre/imperialschool/viewstv/VideoSurface;->start()V

    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->videoController:Lru/oopssre/imperialschool/viewstv/VideoController;

    invoke-virtual {v0}, Lru/oopssre/imperialschool/viewstv/VideoController;->start()V

    return-void

    :cond_3
    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->videoController:Lru/oopssre/imperialschool/viewstv/VideoController;

    invoke-virtual {v0}, Lru/oopssre/imperialschool/viewstv/VideoController;->stop()V

    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->video:Lru/oopssre/imperialschool/viewstv/VideoSurface;

    invoke-virtual {v0}, Lru/oopssre/imperialschool/viewstv/VideoSurface;->stop()V

    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->controller:Lru/oopssre/imperialschool/viewstv/SceneController;

    invoke-virtual {v0}, Lru/oopssre/imperialschool/viewstv/SceneController;->start()V

    return-void
.end method

.method scaleList()V
    .locals 8

    .line 189
    const-string v0, "scale"

    const-string v1, "\u0420\u0430\u0437\u043c\u0435\u0449\u0435\u043d\u0438\u0435"

    invoke-virtual {p0, v0, v1}, Lru/oopssre/imperialschool/viewstv/TvScene;->beginPage(Ljava/lang/String;Ljava/lang/String;)V

    invoke-virtual {p0}, Lru/oopssre/imperialschool/viewstv/TvScene;->videoEnabled()Z

    move-result v0

    if-eqz v0, :cond_0

    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->video:Lru/oopssre/imperialschool/viewstv/VideoSurface;

    iget-boolean v0, v0, Lru/oopssre/imperialschool/viewstv/VideoSurface;->fill:Z

    goto :goto_0

    :cond_0
    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->repo:Lru/oopssre/imperialschool/viewstv/Repository;

    invoke-virtual {v0}, Lru/oopssre/imperialschool/viewstv/Repository;->fill()Z

    move-result v0

    :goto_0
    const/4 v1, 0x2

    new-array v2, v1, [Z

    fill-array-data v2, :array_0

    const/4 v3, 0x0

    :goto_1
    const-string v4, "fill"

    const-string v5, "fit"

    if-ge v3, v1, :cond_4

    aget-boolean v6, v2, v3

    if-eqz v6, :cond_1

    goto :goto_2

    :cond_1
    move-object v4, v5

    :goto_2
    if-ne v6, v0, :cond_2

    const-string v5, "\u2713 "

    goto :goto_3

    :cond_2
    const-string v5, ""

    :goto_3
    if-eqz v6, :cond_3

    const-string v7, "\u0417\u0430\u043f\u043e\u043b\u043d\u0438\u0442\u044c \u044d\u043a\u0440\u0430\u043d"

    goto :goto_4

    :cond_3
    const-string v7, "\u0412\u043f\u0438\u0441\u0430\u0442\u044c \u0446\u0435\u043b\u0438\u043a\u043e\u043c"

    :goto_4
    invoke-virtual {v5, v7}, Ljava/lang/String;->concat(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v5

    new-instance v7, Lru/oopssre/imperialschool/viewstv/TvScene$$ExternalSyntheticLambda14;

    invoke-direct {v7, p0, v6}, Lru/oopssre/imperialschool/viewstv/TvScene$$ExternalSyntheticLambda14;-><init>(Lru/oopssre/imperialschool/viewstv/TvScene;Z)V

    invoke-virtual {p0, v4, v5, v7}, Lru/oopssre/imperialschool/viewstv/TvScene;->button(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Runnable;)Landroid/widget/Button;

    add-int/lit8 v3, v3, 0x1

    goto :goto_1

    :cond_4
    const-string v1, "\u041f\u0440\u0438 \u0437\u0430\u043f\u043e\u043b\u043d\u0435\u043d\u0438\u0438 \u044d\u043a\u0440\u0430\u043d\u0430 \u043a\u0440\u0430\u044f \u043c\u043e\u0433\u0443\u0442 \u0431\u044b\u0442\u044c \u043e\u0431\u0440\u0435\u0437\u0430\u043d\u044b."

    invoke-virtual {p0, v1}, Lru/oopssre/imperialschool/viewstv/TvScene;->message(Ljava/lang/String;)V

    if-eqz v0, :cond_5

    goto :goto_5

    :cond_5
    move-object v4, v5

    :goto_5
    invoke-virtual {p0, v4}, Lru/oopssre/imperialschool/viewstv/TvScene;->focusFirst(Ljava/lang/String;)V

    return-void

    nop

    :array_0
    .array-data 1
        0x0t
        0x1t
    .end array-data
.end method

.method screenMenu()V
    .locals 3

    .line 171
    const-string v0, "screen"

    const-string v1, "\u041f\u043e\u043a\u0430\u0437 \u0438\u0437\u043e\u0431\u0440\u0430\u0436\u0435\u043d\u0438\u044f"

    invoke-virtual {p0, v0, v1}, Lru/oopssre/imperialschool/viewstv/TvScene;->beginPage(Ljava/lang/String;Ljava/lang/String;)V

    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->repo:Lru/oopssre/imperialschool/viewstv/Repository;

    invoke-virtual {v0}, Lru/oopssre/imperialschool/viewstv/Repository;->selected()Lru/oopssre/imperialschool/viewstv/Protocol$Theme;

    move-result-object v0

    iget-object v0, v0, Lru/oopssre/imperialschool/viewstv/Protocol$Theme;->kind:Ljava/lang/String;

    const-string v1, "dynamic"

    invoke-virtual {v0, v1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_1

    invoke-virtual {p0}, Lru/oopssre/imperialschool/viewstv/TvScene;->videoEnabled()Z

    move-result v0

    if-eqz v0, :cond_0

    const-string v0, "\u0412\u0438\u0434\u0435\u043e 4\u041a"

    goto :goto_0

    :cond_0
    const-string v0, "\u0418\u0437\u043e\u0431\u0440\u0430\u0436\u0435\u043d\u0438\u0435"

    :goto_0
    const-string v1, "\u0421\u043f\u043e\u0441\u043e\u0431 \u043f\u043e\u043a\u0430\u0437\u0430 \u00b7 "

    invoke-virtual {v1, v0}, Ljava/lang/String;->concat(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    new-instance v1, Lru/oopssre/imperialschool/viewstv/TvScene$$ExternalSyntheticLambda52;

    invoke-direct {v1, p0}, Lru/oopssre/imperialschool/viewstv/TvScene$$ExternalSyntheticLambda52;-><init>(Lru/oopssre/imperialschool/viewstv/TvScene;)V

    const-string v2, "output"

    invoke-virtual {p0, v2, v0, v1}, Lru/oopssre/imperialschool/viewstv/TvScene;->button(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Runnable;)Landroid/widget/Button;

    .line 172
    :cond_1
    invoke-virtual {p0}, Lru/oopssre/imperialschool/viewstv/TvScene;->videoEnabled()Z

    move-result v0

    if-nez v0, :cond_2

    new-instance v0, Ljava/lang/StringBuilder;

    const-string v1, "\u0420\u0430\u0437\u0440\u0435\u0448\u0435\u043d\u0438\u0435 \u00b7 "

    invoke-direct {v0, v1}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    iget-object v1, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->repo:Lru/oopssre/imperialschool/viewstv/Repository;

    invoke-virtual {v1}, Lru/oopssre/imperialschool/viewstv/Repository;->resolution()Ljava/lang/String;

    move-result-object v1

    invoke-static {v1}, Lru/oopssre/imperialschool/viewstv/TvDisplay;->label(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    new-instance v1, Lru/oopssre/imperialschool/viewstv/TvScene$$ExternalSyntheticLambda53;

    invoke-direct {v1, p0}, Lru/oopssre/imperialschool/viewstv/TvScene$$ExternalSyntheticLambda53;-><init>(Lru/oopssre/imperialschool/viewstv/TvScene;)V

    invoke-virtual {p0, v0, v1}, Lru/oopssre/imperialschool/viewstv/TvScene;->button(Ljava/lang/String;Ljava/lang/Runnable;)Landroid/widget/Button;

    .line 173
    :cond_2
    invoke-virtual {p0}, Lru/oopssre/imperialschool/viewstv/TvScene;->videoEnabled()Z

    move-result v0

    if-eqz v0, :cond_3

    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->video:Lru/oopssre/imperialschool/viewstv/VideoSurface;

    iget-boolean v0, v0, Lru/oopssre/imperialschool/viewstv/VideoSurface;->fill:Z

    if-eqz v0, :cond_4

    goto :goto_1

    :cond_3
    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->repo:Lru/oopssre/imperialschool/viewstv/Repository;

    invoke-virtual {v0}, Lru/oopssre/imperialschool/viewstv/Repository;->fill()Z

    move-result v0

    if-eqz v0, :cond_4

    :goto_1
    const-string v0, "\u0417\u0430\u043f\u043e\u043b\u043d\u0438\u0442\u044c \u044d\u043a\u0440\u0430\u043d"

    goto :goto_2

    :cond_4
    const-string v0, "\u0412\u043f\u0438\u0441\u0430\u0442\u044c \u0446\u0435\u043b\u0438\u043a\u043e\u043c"

    :goto_2
    const-string v1, "\u0420\u0430\u0437\u043c\u0435\u0449\u0435\u043d\u0438\u0435 \u00b7 "

    invoke-virtual {v1, v0}, Ljava/lang/String;->concat(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    new-instance v1, Lru/oopssre/imperialschool/viewstv/TvScene$$ExternalSyntheticLambda54;

    invoke-direct {v1, p0}, Lru/oopssre/imperialschool/viewstv/TvScene$$ExternalSyntheticLambda54;-><init>(Lru/oopssre/imperialschool/viewstv/TvScene;)V

    invoke-virtual {p0, v0, v1}, Lru/oopssre/imperialschool/viewstv/TvScene;->button(Ljava/lang/String;Ljava/lang/Runnable;)Landroid/widget/Button;

    .line 174
    new-instance v0, Lru/oopssre/imperialschool/viewstv/TvScene$$ExternalSyntheticLambda56;

    invoke-direct {v0, p0}, Lru/oopssre/imperialschool/viewstv/TvScene$$ExternalSyntheticLambda56;-><init>(Lru/oopssre/imperialschool/viewstv/TvScene;)V

    const-string v1, "\u041f\u0440\u043e\u0432\u0435\u0440\u0438\u0442\u044c \u043e\u0431\u043d\u043e\u0432\u043b\u0435\u043d\u0438\u0435 \u043e\u0431\u043e\u0435\u0432"

    invoke-virtual {p0, v1, v0}, Lru/oopssre/imperialschool/viewstv/TvScene;->button(Ljava/lang/String;Ljava/lang/Runnable;)Landroid/widget/Button;

    invoke-virtual {p0}, Lru/oopssre/imperialschool/viewstv/TvScene;->focusFirst()V

    return-void
.end method

.method sectionHeading(Ljava/lang/String;)V
    .locals 3

    const/16 v0, 0x15

    .line 93
    invoke-virtual {p0, p1, v0}, Lru/oopssre/imperialschool/viewstv/TvScene;->text(Ljava/lang/String;I)Landroid/widget/TextView;

    move-result-object p1

    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->context:Landroid/content/Context;

    invoke-virtual {v0}, Landroid/content/Context;->getResources()Landroid/content/res/Resources;

    move-result-object v0

    sget v1, Lru/oopssre/imperialschool/viewstv/R$font;->oswald_semibold:I

    invoke-virtual {v0, v1}, Landroid/content/res/Resources;->getFont(I)Landroid/graphics/Typeface;

    move-result-object v0

    invoke-virtual {p1, v0}, Landroid/widget/TextView;->setTypeface(Landroid/graphics/Typeface;)V

    const/16 v0, 0x8

    invoke-virtual {p0, v0}, Lru/oopssre/imperialschool/viewstv/TvScene;->dp(I)I

    move-result v0

    const/16 v1, 0x10

    invoke-virtual {p0, v1}, Lru/oopssre/imperialschool/viewstv/TvScene;->dp(I)I

    move-result v1

    const/4 v2, 0x0

    invoke-virtual {p1, v2, v0, v2, v1}, Landroid/widget/TextView;->setPadding(IIII)V

    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->content:Landroid/widget/LinearLayout;

    invoke-virtual {v0, p1}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    return-void
.end method

.method settingsMenu()V
    .locals 2

    .line 156
    const-string v0, "settings"

    const-string v1, "\u041d\u0430\u0441\u0442\u0440\u043e\u0439\u043a\u0438"

    invoke-virtual {p0, v0, v1}, Lru/oopssre/imperialschool/viewstv/TvScene;->beginPage(Ljava/lang/String;Ljava/lang/String;)V

    new-instance v0, Lru/oopssre/imperialschool/viewstv/TvScene$$ExternalSyntheticLambda42;

    invoke-direct {v0, p0}, Lru/oopssre/imperialschool/viewstv/TvScene$$ExternalSyntheticLambda42;-><init>(Lru/oopssre/imperialschool/viewstv/TvScene;)V

    const-string v1, "\u041f\u043e\u043a\u0430\u0437 \u0438\u0437\u043e\u0431\u0440\u0430\u0436\u0435\u043d\u0438\u044f"

    invoke-virtual {p0, v1, v0}, Lru/oopssre/imperialschool/viewstv/TvScene;->button(Ljava/lang/String;Ljava/lang/Runnable;)Landroid/widget/Button;

    new-instance v0, Lru/oopssre/imperialschool/viewstv/TvScene$$ExternalSyntheticLambda43;

    invoke-direct {v0, p0}, Lru/oopssre/imperialschool/viewstv/TvScene$$ExternalSyntheticLambda43;-><init>(Lru/oopssre/imperialschool/viewstv/TvScene;)V

    const-string v1, "\u0421\u0438\u0441\u0442\u0435\u043c\u043d\u0430\u044f \u0437\u0430\u0441\u0442\u0430\u0432\u043a\u0430"

    invoke-virtual {p0, v1, v0}, Lru/oopssre/imperialschool/viewstv/TvScene;->button(Ljava/lang/String;Ljava/lang/Runnable;)Landroid/widget/Button;

    new-instance v0, Lru/oopssre/imperialschool/viewstv/TvScene$$ExternalSyntheticLambda45;

    invoke-direct {v0, p0}, Lru/oopssre/imperialschool/viewstv/TvScene$$ExternalSyntheticLambda45;-><init>(Lru/oopssre/imperialschool/viewstv/TvScene;)V

    const-string v1, "\u0425\u0440\u0430\u043d\u0438\u043b\u0438\u0449\u0435"

    invoke-virtual {p0, v1, v0}, Lru/oopssre/imperialschool/viewstv/TvScene;->button(Ljava/lang/String;Ljava/lang/Runnable;)Landroid/widget/Button;

    new-instance v0, Lru/oopssre/imperialschool/viewstv/TvScene$$ExternalSyntheticLambda46;

    invoke-direct {v0, p0}, Lru/oopssre/imperialschool/viewstv/TvScene$$ExternalSyntheticLambda46;-><init>(Lru/oopssre/imperialschool/viewstv/TvScene;)V

    const-string v1, "\u041f\u0440\u043e\u043a\u0441\u0438"

    invoke-virtual {p0, v1, v0}, Lru/oopssre/imperialschool/viewstv/TvScene;->button(Ljava/lang/String;Ljava/lang/Runnable;)Landroid/widget/Button;

    new-instance v0, Lru/oopssre/imperialschool/viewstv/TvScene$$ExternalSyntheticLambda47;

    invoke-direct {v0, p0}, Lru/oopssre/imperialschool/viewstv/TvScene$$ExternalSyntheticLambda47;-><init>(Lru/oopssre/imperialschool/viewstv/TvScene;)V

    const-string v1, "\u041b\u0438\u0447\u043d\u044b\u0439 \u0440\u0435\u0436\u0438\u043c"

    invoke-virtual {p0, v1, v0}, Lru/oopssre/imperialschool/viewstv/TvScene;->button(Ljava/lang/String;Ljava/lang/Runnable;)Landroid/widget/Button;

    new-instance v0, Lru/oopssre/imperialschool/viewstv/TvScene$$ExternalSyntheticLambda48;

    invoke-direct {v0, p0}, Lru/oopssre/imperialschool/viewstv/TvScene$$ExternalSyntheticLambda48;-><init>(Lru/oopssre/imperialschool/viewstv/TvScene;)V

    const-string v1, "\u041e \u043f\u0440\u0438\u043b\u043e\u0436\u0435\u043d\u0438\u0438"

    invoke-virtual {p0, v1, v0}, Lru/oopssre/imperialschool/viewstv/TvScene;->button(Ljava/lang/String;Ljava/lang/Runnable;)Landroid/widget/Button;

    invoke-virtual {p0}, Lru/oopssre/imperialschool/viewstv/TvScene;->focusFirst()V

    return-void
.end method

.method showPage(Ljava/lang/String;)V
    .locals 3

    .line 140
    invoke-virtual {p1}, Ljava/lang/String;->hashCode()I

    invoke-virtual {p1}, Ljava/lang/String;->hashCode()I

    move-result v0

    const/4 v1, 0x0

    const/4 v2, -0x1

    sparse-switch v0, :sswitch_data_0

    goto/16 :goto_0

    :sswitch_0
    const-string v0, "settings"

    invoke-virtual {p1, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p1

    if-nez p1, :cond_0

    goto/16 :goto_0

    :cond_0
    const/16 v2, 0x9

    goto/16 :goto_0

    :sswitch_1
    const-string v0, "stations"

    invoke-virtual {p1, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p1

    if-nez p1, :cond_1

    goto/16 :goto_0

    :cond_1
    const/16 v2, 0x8

    goto/16 :goto_0

    :sswitch_2
    const-string v0, "music_credits"

    invoke-virtual {p1, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p1

    if-nez p1, :cond_2

    goto :goto_0

    :cond_2
    const/4 v2, 0x7

    goto :goto_0

    :sswitch_3
    const-string v0, "personal"

    invoke-virtual {p1, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p1

    if-nez p1, :cond_3

    goto :goto_0

    :cond_3
    const/4 v2, 0x6

    goto :goto_0

    :sswitch_4
    const-string v0, "proxy"

    invoke-virtual {p1, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p1

    if-nez p1, :cond_4

    goto :goto_0

    :cond_4
    const/4 v2, 0x5

    goto :goto_0

    :sswitch_5
    const-string v0, "music"

    invoke-virtual {p1, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p1

    if-nez p1, :cond_5

    goto :goto_0

    :cond_5
    const/4 v2, 0x4

    goto :goto_0

    :sswitch_6
    const-string v0, "info"

    invoke-virtual {p1, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p1

    if-nez p1, :cond_6

    goto :goto_0

    :cond_6
    const/4 v2, 0x3

    goto :goto_0

    :sswitch_7
    const-string v0, "themes"

    invoke-virtual {p1, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p1

    if-nez p1, :cond_7

    goto :goto_0

    :cond_7
    const/4 v2, 0x2

    goto :goto_0

    :sswitch_8
    const-string v0, "screen"

    invoke-virtual {p1, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p1

    if-nez p1, :cond_8

    goto :goto_0

    :cond_8
    const/4 v2, 0x1

    goto :goto_0

    :sswitch_9
    const-string v0, "collection"

    invoke-virtual {p1, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p1

    if-nez p1, :cond_9

    goto :goto_0

    :cond_9
    move v2, v1

    :goto_0
    packed-switch v2, :pswitch_data_0

    .line 146
    invoke-virtual {p0}, Lru/oopssre/imperialschool/viewstv/TvScene;->openSettings()V

    return-void

    .line 141
    :pswitch_0
    invoke-virtual {p0}, Lru/oopssre/imperialschool/viewstv/TvScene;->settingsMenu()V

    return-void

    .line 145
    :pswitch_1
    invoke-virtual {p0, v1}, Lru/oopssre/imperialschool/viewstv/TvScene;->stationsMenu(Z)V

    return-void

    .line 144
    :pswitch_2
    invoke-virtual {p0}, Lru/oopssre/imperialschool/viewstv/TvScene;->musicCredits()V

    return-void

    .line 145
    :pswitch_3
    invoke-virtual {p0}, Lru/oopssre/imperialschool/viewstv/TvScene;->personalMenu()V

    return-void

    .line 141
    :pswitch_4
    invoke-virtual {p0}, Lru/oopssre/imperialschool/viewstv/TvScene;->proxyMenu()V

    return-void

    .line 143
    :pswitch_5
    invoke-virtual {p0}, Lru/oopssre/imperialschool/viewstv/TvScene;->musicMenu()V

    return-void

    :pswitch_6
    invoke-virtual {p0}, Lru/oopssre/imperialschool/viewstv/TvScene;->info()V

    return-void

    .line 141
    :pswitch_7
    invoke-virtual {p0}, Lru/oopssre/imperialschool/viewstv/TvScene;->themeList()V

    return-void

    .line 142
    :pswitch_8
    invoke-virtual {p0}, Lru/oopssre/imperialschool/viewstv/TvScene;->screenMenu()V

    return-void

    :pswitch_9
    invoke-virtual {p0}, Lru/oopssre/imperialschool/viewstv/TvScene;->collectionMenu()V

    return-void

    :sswitch_data_0
    .sparse-switch
        -0x67ca5162 -> :sswitch_9
        -0x361a3f94 -> :sswitch_8
        -0x3424bc36 -> :sswitch_7
        0x3164ae -> :sswitch_6
        0x636ee25 -> :sswitch_5
        0x65fca6e -> :sswitch_4
        0x1a6a2640 -> :sswitch_3
        0x472c5480 -> :sswitch_2
        0x4e9425bf -> :sswitch_1
        0x5582bc23 -> :sswitch_0
    .end sparse-switch

    :pswitch_data_0
    .packed-switch 0x0
        :pswitch_9
        :pswitch_8
        :pswitch_7
        :pswitch_6
        :pswitch_5
        :pswitch_4
        :pswitch_3
        :pswitch_2
        :pswitch_1
        :pswitch_0
    .end packed-switch
.end method

.method start()V
    .locals 5

    .line 121
    iget-boolean v0, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->active:Z

    if-eqz v0, :cond_0

    goto :goto_0

    :cond_0
    const/4 v0, 0x1

    iput-boolean v0, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->active:Z

    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->panel:Landroid/widget/ScrollView;

    invoke-virtual {v0}, Landroid/widget/ScrollView;->getVisibility()I

    move-result v0

    if-nez v0, :cond_1

    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->page:Ljava/lang/String;

    const-string v1, "themes"

    invoke-virtual {v0, v1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_1

    invoke-virtual {p0}, Lru/oopssre/imperialschool/viewstv/TvScene;->themeList()V

    :cond_1
    const/4 v0, 0x0

    invoke-virtual {p0, v0}, Lru/oopssre/imperialschool/viewstv/TvScene;->refreshResolution(Z)V

    iget-object v1, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->context:Landroid/content/Context;

    const-string v2, "display"

    invoke-virtual {v1, v2}, Landroid/content/Context;->getSystemService(Ljava/lang/String;)Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Landroid/hardware/display/DisplayManager;

    iput-object v1, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->displayManager:Landroid/hardware/display/DisplayManager;

    if-eqz v1, :cond_2

    iget-object v2, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->displayListener:Landroid/hardware/display/DisplayManager$DisplayListener;

    iget-object v3, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->handler:Landroid/os/Handler;

    invoke-virtual {v1, v2, v3}, Landroid/hardware/display/DisplayManager;->registerDisplayListener(Landroid/hardware/display/DisplayManager$DisplayListener;Landroid/os/Handler;)V

    :cond_2
    invoke-direct {p0}, Lru/oopssre/imperialschool/viewstv/TvScene;->openMenuUntilFrame()V

    invoke-virtual {p0}, Lru/oopssre/imperialschool/viewstv/TvScene;->resumePlayback()V

    iget-wide v1, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->updateGeneration:J

    const-wide/16 v3, 0x1

    add-long/2addr v1, v3

    iput-wide v1, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->updateGeneration:J

    .line 122
    iget-object v3, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->updateWorker:Ljava/util/concurrent/ExecutorService;

    new-instance v4, Lru/oopssre/imperialschool/viewstv/TvScene$$ExternalSyntheticLambda49;

    invoke-direct {v4, p0, v1, v2}, Lru/oopssre/imperialschool/viewstv/TvScene$$ExternalSyntheticLambda49;-><init>(Lru/oopssre/imperialschool/viewstv/TvScene;J)V

    invoke-interface {v3, v4}, Ljava/util/concurrent/ExecutorService;->submit(Ljava/lang/Runnable;)Ljava/util/concurrent/Future;

    .line 123
    iget-object v1, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->handler:Landroid/os/Handler;

    new-instance v2, Lru/oopssre/imperialschool/viewstv/TvScene$$ExternalSyntheticLambda50;

    invoke-direct {v2, p0}, Lru/oopssre/imperialschool/viewstv/TvScene$$ExternalSyntheticLambda50;-><init>(Lru/oopssre/imperialschool/viewstv/TvScene;)V

    const-wide/16 v3, 0x1f40

    invoke-virtual {v1, v2, v3, v4}, Landroid/os/Handler;->postDelayed(Ljava/lang/Runnable;J)Z

    iget-boolean v1, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->pendingInstall:Z

    if-eqz v1, :cond_3

    iget-object v1, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->context:Landroid/content/Context;

    invoke-virtual {v1}, Landroid/content/Context;->getPackageManager()Landroid/content/pm/PackageManager;

    move-result-object v1

    invoke-virtual {v1}, Landroid/content/pm/PackageManager;->canRequestPackageInstalls()Z

    move-result v1

    if-eqz v1, :cond_3

    iput-boolean v0, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->pendingInstall:Z

    invoke-virtual {p0}, Lru/oopssre/imperialschool/viewstv/TvScene;->install()V

    :cond_3
    :goto_0
    return-void
.end method

.method stationsMenu(Z)V
    .locals 4

    if-eqz p1, :cond_0

    .line 259
    const-string p1, "personal_stations"

    goto :goto_0

    :cond_0
    const-string p1, "stations"

    :goto_0
    const-string v0, "\u0421\u0442\u0430\u043d\u0446\u0438\u0438 \u0442\u0435\u043c\u044b"

    invoke-virtual {p0, p1, v0}, Lru/oopssre/imperialschool/viewstv/TvScene;->beginPage(Ljava/lang/String;Ljava/lang/String;)V

    .line 260
    iget-object p1, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->repo:Lru/oopssre/imperialschool/viewstv/Repository;

    invoke-virtual {p1}, Lru/oopssre/imperialschool/viewstv/Repository;->selected()Lru/oopssre/imperialschool/viewstv/Protocol$Theme;

    move-result-object p1

    invoke-static {p1}, Lru/oopssre/imperialschool/viewstv/ThemeText;->title(Lru/oopssre/imperialschool/viewstv/Protocol$Theme;)Ljava/lang/String;

    move-result-object p1

    invoke-virtual {p0, p1}, Lru/oopssre/imperialschool/viewstv/TvScene;->message(Ljava/lang/String;)V

    .line 261
    iget-object p1, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->music:Lru/oopssre/imperialschool/viewstv/SceneMusic;

    iget-object p1, p1, Lru/oopssre/imperialschool/viewstv/SceneMusic;->stations:Lru/oopssre/imperialschool/viewstv/ThemeStations;

    invoke-virtual {p0}, Lru/oopssre/imperialschool/viewstv/TvScene;->musicTheme()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p1, v0}, Lru/oopssre/imperialschool/viewstv/ThemeStations;->forTheme(Ljava/lang/String;)Ljava/util/List;

    move-result-object p1

    invoke-interface {p1}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object p1

    :cond_1
    :goto_1
    invoke-interface {p1}, Ljava/util/Iterator;->hasNext()Z

    move-result v0

    if-eqz v0, :cond_2

    invoke-interface {p1}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Lru/oopssre/imperialschool/viewstv/ThemeStations$Station;

    .line 262
    iget-object v1, v0, Lru/oopssre/imperialschool/viewstv/ThemeStations$Station;->id:Ljava/lang/String;

    iget-object v2, v0, Lru/oopssre/imperialschool/viewstv/ThemeStations$Station;->title:Ljava/lang/String;

    new-instance v3, Lru/oopssre/imperialschool/viewstv/TvScene$$ExternalSyntheticLambda38;

    invoke-direct {v3, p0, v0}, Lru/oopssre/imperialschool/viewstv/TvScene$$ExternalSyntheticLambda38;-><init>(Lru/oopssre/imperialschool/viewstv/TvScene;Lru/oopssre/imperialschool/viewstv/ThemeStations$Station;)V

    invoke-virtual {p0, v1, v2, v3}, Lru/oopssre/imperialschool/viewstv/TvScene;->button(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Runnable;)Landroid/widget/Button;

    .line 263
    iget-object v1, v0, Lru/oopssre/imperialschool/viewstv/ThemeStations$Station;->credit:Ljava/lang/String;

    invoke-virtual {v1}, Ljava/lang/String;->isEmpty()Z

    move-result v1

    if-nez v1, :cond_1

    iget-object v0, v0, Lru/oopssre/imperialschool/viewstv/ThemeStations$Station;->credit:Ljava/lang/String;

    invoke-virtual {p0, v0}, Lru/oopssre/imperialschool/viewstv/TvScene;->message(Ljava/lang/String;)V

    goto :goto_1

    .line 265
    :cond_2
    invoke-virtual {p0}, Lru/oopssre/imperialschool/viewstv/TvScene;->focusFirst()V

    return-void
.end method

.method public status(Ljava/lang/String;)V
    .locals 3

    .line 301
    invoke-virtual {p0}, Lru/oopssre/imperialschool/viewstv/TvScene;->videoEnabled()Z

    move-result v0

    if-eqz v0, :cond_0

    goto :goto_0

    :cond_0
    iput-object p1, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->status:Ljava/lang/String;

    invoke-virtual {p0}, Lru/oopssre/imperialschool/viewstv/TvScene;->refreshDetails()V

    invoke-virtual {p0}, Lru/oopssre/imperialschool/viewstv/TvScene;->refreshDiagnostics()V

    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->controller:Lru/oopssre/imperialschool/viewstv/SceneController;

    iget-object v0, v0, Lru/oopssre/imperialschool/viewstv/SceneController;->frame:Lru/oopssre/imperialschool/viewstv/Protocol$Frame;

    if-nez v0, :cond_1

    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->placeholder:Landroid/widget/TextView;

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    iget-object v2, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->repo:Lru/oopssre/imperialschool/viewstv/Repository;

    invoke-virtual {v2}, Lru/oopssre/imperialschool/viewstv/Repository;->selected()Lru/oopssre/imperialschool/viewstv/Protocol$Theme;

    move-result-object v2

    invoke-static {v2}, Lru/oopssre/imperialschool/viewstv/ThemeText;->title(Lru/oopssre/imperialschool/viewstv/Protocol$Theme;)Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    const-string v2, "\n\n"

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {p0, p1}, Lru/oopssre/imperialschool/viewstv/TvScene;->waitingText(Ljava/lang/String;)Ljava/lang/String;

    move-result-object p1

    invoke-virtual {v1, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p1

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-virtual {v0, p1}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    :cond_1
    :goto_0
    return-void
.end method

.method stop()V
    .locals 5

    invoke-direct {p0}, Lru/oopssre/imperialschool/viewstv/TvScene;->resetExitBack()V

    const/4 v0, 0x0

    .line 124
    iput-boolean v0, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->active:Z

    iget-object v1, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->displayManager:Landroid/hardware/display/DisplayManager;

    if-eqz v1, :cond_0

    iget-object v2, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->displayListener:Landroid/hardware/display/DisplayManager$DisplayListener;

    invoke-virtual {v1, v2}, Landroid/hardware/display/DisplayManager;->unregisterDisplayListener(Landroid/hardware/display/DisplayManager$DisplayListener;)V

    :cond_0
    iget-object v1, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->music:Lru/oopssre/imperialschool/viewstv/SceneMusic;

    invoke-virtual {p0}, Lru/oopssre/imperialschool/viewstv/TvScene;->musicTheme()Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v1, v0, v2}, Lru/oopssre/imperialschool/viewstv/SceneMusic;->scene(ZLjava/lang/String;)V

    iget-wide v1, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->updateGeneration:J

    const-wide/16 v3, 0x1

    add-long/2addr v1, v3

    iput-wide v1, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->updateGeneration:J

    iget-object v1, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->hold:Lru/oopssre/imperialschool/viewstv/HoldGate;

    invoke-virtual {v1}, Lru/oopssre/imperialschool/viewstv/HoldGate;->release()V

    iget-object v1, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->handler:Landroid/os/Handler;

    iget-object v2, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->held:Ljava/lang/Runnable;

    invoke-virtual {v1, v2}, Landroid/os/Handler;->removeCallbacks(Ljava/lang/Runnable;)V

    iget-object v1, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->gallery:Lru/oopssre/imperialschool/viewstv/ThemeGallery;

    if-eqz v1, :cond_1

    invoke-virtual {p0}, Lru/oopssre/imperialschool/viewstv/TvScene;->rememberFocus()V

    iget-object v1, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->gallery:Lru/oopssre/imperialschool/viewstv/ThemeGallery;

    invoke-virtual {v1}, Lru/oopssre/imperialschool/viewstv/ThemeGallery;->close()V

    :cond_1
    iget-wide v1, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->capabilityGeneration:J

    add-long/2addr v1, v3

    iput-wide v1, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->capabilityGeneration:J

    iget-object v1, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->capabilityJob:Ljava/util/concurrent/Future;

    const/4 v2, 0x1

    if-eqz v1, :cond_2

    invoke-interface {v1, v2}, Ljava/util/concurrent/Future;->cancel(Z)Z

    :cond_2
    iget-object v1, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->controller:Lru/oopssre/imperialschool/viewstv/SceneController;

    invoke-virtual {v1}, Lru/oopssre/imperialschool/viewstv/SceneController;->stop()V

    iget-object v1, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->videoController:Lru/oopssre/imperialschool/viewstv/VideoController;

    invoke-virtual {v1}, Lru/oopssre/imperialschool/viewstv/VideoController;->stop()V

    iget-object v1, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->video:Lru/oopssre/imperialschool/viewstv/VideoSurface;

    invoke-virtual {v1}, Lru/oopssre/imperialschool/viewstv/VideoSurface;->stop()V

    iget-object v1, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->updateJob:Ljava/util/concurrent/Future;

    if-eqz v1, :cond_3

    invoke-interface {v1, v2}, Ljava/util/concurrent/Future;->cancel(Z)Z

    :cond_3
    iput-boolean v0, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->updateBusy:Z

    return-void
.end method

.method systemSettings()V
    .locals 3

    .line 300
    :try_start_0
    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->host:Lru/oopssre/imperialschool/viewstv/TvScene$Host;

    new-instance v1, Landroid/content/Intent;

    const-string v2, "android.settings.DREAM_SETTINGS"

    invoke-direct {v1, v2}, Landroid/content/Intent;-><init>(Ljava/lang/String;)V

    const/high16 v2, 0x10000000

    invoke-virtual {v1, v2}, Landroid/content/Intent;->addFlags(I)Landroid/content/Intent;

    move-result-object v1

    invoke-interface {v0, v1}, Lru/oopssre/imperialschool/viewstv/TvScene$Host;->launch(Landroid/content/Intent;)V
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    return-void

    :catch_0
    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->context:Landroid/content/Context;

    const-string v1, "\u041c\u0435\u043d\u044e \u0437\u0430\u0441\u0442\u0430\u0432\u043a\u0438 \u043d\u0435\u0434\u043e\u0441\u0442\u0443\u043f\u043d\u043e \u043d\u0430 \u044d\u0442\u043e\u043c \u0442\u0435\u043b\u0435\u0432\u0438\u0437\u043e\u0440\u0435"

    const/4 v2, 0x1

    invoke-static {v0, v1, v2}, Landroid/widget/Toast;->makeText(Landroid/content/Context;Ljava/lang/CharSequence;I)Landroid/widget/Toast;

    move-result-object v0

    invoke-virtual {v0}, Landroid/widget/Toast;->show()V

    return-void
.end method

.method technical(Ljava/lang/String;)Landroid/widget/TextView;
    .locals 3

    const/16 v0, 0x10

    .line 95
    invoke-virtual {p0, p1, v0}, Lru/oopssre/imperialschool/viewstv/TvScene;->text(Ljava/lang/String;I)Landroid/widget/TextView;

    move-result-object p1

    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->context:Landroid/content/Context;

    invoke-virtual {v0}, Landroid/content/Context;->getResources()Landroid/content/res/Resources;

    move-result-object v0

    sget v1, Lru/oopssre/imperialschool/viewstv/R$font;->ptmono:I

    invoke-virtual {v0, v1}, Landroid/content/res/Resources;->getFont(I)Landroid/graphics/Typeface;

    move-result-object v0

    invoke-virtual {p1, v0}, Landroid/widget/TextView;->setTypeface(Landroid/graphics/Typeface;)V

    const v0, -0x464e32

    invoke-virtual {p1, v0}, Landroid/widget/TextView;->setTextColor(I)V

    const/16 v0, 0x8

    invoke-virtual {p0, v0}, Lru/oopssre/imperialschool/viewstv/TvScene;->dp(I)I

    move-result v0

    const/16 v1, 0x14

    invoke-virtual {p0, v1}, Lru/oopssre/imperialschool/viewstv/TvScene;->dp(I)I

    move-result v1

    const/4 v2, 0x0

    invoke-virtual {p1, v2, v0, v2, v1}, Landroid/widget/TextView;->setPadding(IIII)V

    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->content:Landroid/widget/LinearLayout;

    invoke-virtual {v0, p1}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    return-object p1
.end method

.method text(Ljava/lang/String;I)Landroid/widget/TextView;
    .locals 2

    .line 63
    new-instance v0, Landroid/widget/TextView;

    iget-object v1, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->context:Landroid/content/Context;

    invoke-direct {v0, v1}, Landroid/widget/TextView;-><init>(Landroid/content/Context;)V

    invoke-virtual {v0, p1}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    int-to-float p1, p2

    invoke-virtual {v0, p1}, Landroid/widget/TextView;->setTextSize(F)V

    const p1, -0xc1325

    invoke-virtual {v0, p1}, Landroid/widget/TextView;->setTextColor(I)V

    const/4 p1, 0x3

    invoke-virtual {p0, p1}, Lru/oopssre/imperialschool/viewstv/TvScene;->dp(I)I

    move-result p1

    int-to-float p1, p1

    const/high16 p2, 0x3f800000    # 1.0f

    invoke-virtual {v0, p1, p2}, Landroid/widget/TextView;->setLineSpacing(FF)V

    return-object v0
.end method

.method themeList()V
    .locals 2

    .line 160
    const-string v0, "themes"

    const-string v1, "\u0412\u044b\u0431\u043e\u0440 \u043e\u0431\u043e\u0435\u0432"

    invoke-virtual {p0, v0, v1}, Lru/oopssre/imperialschool/viewstv/TvScene;->beginPage(Ljava/lang/String;Ljava/lang/String;)V

    new-instance v0, Lru/oopssre/imperialschool/viewstv/ThemeGallery;

    iget-object v1, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->repo:Lru/oopssre/imperialschool/viewstv/Repository;

    invoke-virtual {v1}, Lru/oopssre/imperialschool/viewstv/Repository;->themes()Ljava/util/List;

    move-result-object v1

    invoke-direct {v0, p0, v1}, Lru/oopssre/imperialschool/viewstv/ThemeGallery;-><init>(Lru/oopssre/imperialschool/viewstv/TvScene;Ljava/util/List;)V

    iput-object v0, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->gallery:Lru/oopssre/imperialschool/viewstv/ThemeGallery;

    new-instance v0, Ljava/lang/StringBuilder;

    const-string v1, "theme:"

    invoke-direct {v0, v1}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    iget-object v1, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->repo:Lru/oopssre/imperialschool/viewstv/Repository;

    invoke-virtual {v1}, Lru/oopssre/imperialschool/viewstv/Repository;->selected()Lru/oopssre/imperialschool/viewstv/Protocol$Theme;

    move-result-object v1

    iget-object v1, v1, Lru/oopssre/imperialschool/viewstv/Protocol$Theme;->id:Ljava/lang/String;

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p0, v0}, Lru/oopssre/imperialschool/viewstv/TvScene;->focusFirst(Ljava/lang/String;)V

    return-void
.end method

.method updatesMenu()V
    .locals 4

    .line 304
    const-string v0, "updates"

    const-string v1, "\u041e\u0431\u043d\u043e\u0432\u043b\u0435\u043d\u0438\u0435 \u043f\u0440\u0438\u043b\u043e\u0436\u0435\u043d\u0438\u044f"

    invoke-virtual {p0, v0, v1}, Lru/oopssre/imperialschool/viewstv/TvScene;->beginPage(Ljava/lang/String;Ljava/lang/String;)V

    const-string v0, "\u0423\u0441\u0442\u0430\u043d\u043e\u0432\u043b\u0435\u043d\u0430 \u0432\u0435\u0440\u0441\u0438\u044f 0.8.7"

    invoke-virtual {p0, v0}, Lru/oopssre/imperialschool/viewstv/TvScene;->message(Ljava/lang/String;)V

    iget-boolean v0, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->updateBusy:Z

    if-eqz v0, :cond_0

    const-string v0, "\u0417\u0430\u0433\u0440\u0443\u0436\u0430\u044e \u043e\u0431\u043d\u043e\u0432\u043b\u0435\u043d\u0438\u0435\u2026"

    goto :goto_0

    :cond_0
    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->ready:Lru/oopssre/imperialschool/viewstv/Release;

    if-nez v0, :cond_1

    const-string v0, "\u041f\u0440\u043e\u0432\u0435\u0440\u0438\u0442\u044c \u043e\u0431\u043d\u043e\u0432\u043b\u0435\u043d\u0438\u0435"

    goto :goto_0

    :cond_1
    new-instance v0, Ljava/lang/StringBuilder;

    const-string v1, "\u0423\u0441\u0442\u0430\u043d\u043e\u0432\u0438\u0442\u044c \u0432\u0435\u0440\u0441\u0438\u044e "

    invoke-direct {v0, v1}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    iget-object v1, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->ready:Lru/oopssre/imperialschool/viewstv/Release;

    iget-object v1, v1, Lru/oopssre/imperialschool/viewstv/Release;->version:Ljava/lang/String;

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    :goto_0
    new-instance v1, Lru/oopssre/imperialschool/viewstv/TvScene$$ExternalSyntheticLambda32;

    invoke-direct {v1, p0}, Lru/oopssre/imperialschool/viewstv/TvScene$$ExternalSyntheticLambda32;-><init>(Lru/oopssre/imperialschool/viewstv/TvScene;)V

    invoke-virtual {p0, v0, v1}, Lru/oopssre/imperialschool/viewstv/TvScene;->button(Ljava/lang/String;Ljava/lang/Runnable;)Landroid/widget/Button;

    move-result-object v0

    iget-boolean v1, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->updateBusy:Z

    const/4 v2, 0x0

    if-nez v1, :cond_2

    iget-boolean v1, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->cacheBusy:Z

    if-nez v1, :cond_2

    const/4 v1, 0x1

    goto :goto_1

    :cond_2
    move v1, v2

    :goto_1
    invoke-virtual {v0, v1}, Landroid/widget/Button;->setEnabled(Z)V

    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->updateStatus:Ljava/lang/String;

    const/16 v1, 0x12

    invoke-virtual {p0, v0, v1}, Lru/oopssre/imperialschool/viewstv/TvScene;->text(Ljava/lang/String;I)Landroid/widget/TextView;

    move-result-object v0

    iput-object v0, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->details:Landroid/widget/TextView;

    const/16 v1, 0x8

    invoke-virtual {p0, v1}, Lru/oopssre/imperialschool/viewstv/TvScene;->dp(I)I

    move-result v1

    const/16 v3, 0x10

    invoke-virtual {p0, v3}, Lru/oopssre/imperialschool/viewstv/TvScene;->dp(I)I

    move-result v3

    invoke-virtual {v0, v2, v1, v2, v3}, Landroid/widget/TextView;->setPadding(IIII)V

    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->content:Landroid/widget/LinearLayout;

    iget-object v1, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->details:Landroid/widget/TextView;

    invoke-virtual {v0, v1}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    invoke-virtual {p0}, Lru/oopssre/imperialschool/viewstv/TvScene;->focusFirst()V

    return-void
.end method

.method videoChanged()V
    .locals 1

    .line 99
    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->videoController:Lru/oopssre/imperialschool/viewstv/VideoController;

    if-eqz v0, :cond_0

    invoke-virtual {v0}, Lru/oopssre/imperialschool/viewstv/VideoController;->surfaceChanged()V

    :cond_0
    invoke-virtual {p0}, Lru/oopssre/imperialschool/viewstv/TvScene;->videoStatusChanged()V

    return-void
.end method

.method videoEnabled()Z
    .locals 1

    .line 96
    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->repo:Lru/oopssre/imperialschool/viewstv/Repository;

    invoke-virtual {v0}, Lru/oopssre/imperialschool/viewstv/Repository;->videoEnabled()Z

    move-result v0

    return v0
.end method

.method videoOutput(Z)V
    .locals 2

    .line 106
    iget-boolean v0, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->cacheBusy:Z

    if-eqz v0, :cond_0

    return-void

    .line 107
    :cond_0
    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->repo:Lru/oopssre/imperialschool/viewstv/Repository;

    invoke-virtual {v0}, Lru/oopssre/imperialschool/viewstv/Repository;->videoPreferred()Z

    move-result v0

    if-eq p1, v0, :cond_1

    invoke-virtual {p0}, Lru/oopssre/imperialschool/viewstv/TvScene;->resetPlayback()V

    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->repo:Lru/oopssre/imperialschool/viewstv/Repository;

    iget-object v0, v0, Lru/oopssre/imperialschool/viewstv/Repository;->prefs:Landroid/content/SharedPreferences;

    invoke-interface {v0}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object v0

    const-string v1, "video_output"

    invoke-interface {v0, v1, p1}, Landroid/content/SharedPreferences$Editor;->putBoolean(Ljava/lang/String;Z)Landroid/content/SharedPreferences$Editor;

    move-result-object p1

    invoke-interface {p1}, Landroid/content/SharedPreferences$Editor;->apply()V

    const/4 p1, 0x0

    invoke-virtual {p0, p1}, Lru/oopssre/imperialschool/viewstv/TvScene;->refreshResolution(Z)V

    iget-boolean p1, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->active:Z

    if-eqz p1, :cond_1

    invoke-virtual {p0}, Lru/oopssre/imperialschool/viewstv/TvScene;->resumePlayback()V

    .line 108
    :cond_1
    invoke-virtual {p0}, Lru/oopssre/imperialschool/viewstv/TvScene;->screenMenu()V

    return-void
.end method

.method videoStatusChanged()V
    .locals 5

    .line 102
    invoke-virtual {p0}, Lru/oopssre/imperialschool/viewstv/TvScene;->videoEnabled()Z

    move-result v0

    if-eqz v0, :cond_6

    iget-boolean v0, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->destroyed:Z

    if-eqz v0, :cond_0

    goto/16 :goto_3

    :cond_0
    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->video:Lru/oopssre/imperialschool/viewstv/VideoSurface;

    iget-object v0, v0, Lru/oopssre/imperialschool/viewstv/VideoSurface;->displayed:Lru/oopssre/imperialschool/viewstv/VideoInfo;

    if-nez v0, :cond_1

    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->videoController:Lru/oopssre/imperialschool/viewstv/VideoController;

    iget-object v0, v0, Lru/oopssre/imperialschool/viewstv/VideoController;->status:Ljava/lang/String;

    goto :goto_0

    :cond_1
    iget-object v1, v0, Lru/oopssre/imperialschool/viewstv/VideoInfo;->frame:Lru/oopssre/imperialschool/viewstv/Protocol$Frame;

    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J

    move-result-wide v2

    invoke-virtual {v1, v2, v3}, Lru/oopssre/imperialschool/viewstv/Protocol$Frame;->stale(J)Z

    move-result v1

    if-eqz v1, :cond_2

    const-string v0, "\u041e\u0431\u043d\u043e\u0432\u043b\u0435\u043d\u0438\u0435 \u0437\u0430\u0434\u0435\u0440\u0436\u0438\u0432\u0430\u0435\u0442\u0441\u044f"

    goto :goto_0

    :cond_2
    new-instance v1, Ljava/lang/StringBuilder;

    const-string v2, "\u0412\u0438\u0434\u0435\u043e \u00b7 "

    invoke-direct {v1, v2}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    iget-object v0, v0, Lru/oopssre/imperialschool/viewstv/VideoInfo;->frame:Lru/oopssre/imperialschool/viewstv/Protocol$Frame;

    iget-object v0, v0, Lru/oopssre/imperialschool/viewstv/Protocol$Frame;->title:Ljava/lang/String;

    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    :goto_0
    iput-object v0, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->status:Ljava/lang/String;

    invoke-virtual {p0}, Lru/oopssre/imperialschool/viewstv/TvScene;->refreshDetails()V

    invoke-virtual {p0}, Lru/oopssre/imperialschool/viewstv/TvScene;->refreshDiagnostics()V

    .line 103
    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->video:Lru/oopssre/imperialschool/viewstv/VideoSurface;

    iget-boolean v0, v0, Lru/oopssre/imperialschool/viewstv/VideoSurface;->playing:Z

    const/16 v1, 0x8

    if-eqz v0, :cond_3

    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->placeholder:Landroid/widget/TextView;

    invoke-virtual {v0, v1}, Landroid/widget/TextView;->setVisibility(I)V

    return-void

    :cond_3
    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->placeholder:Landroid/widget/TextView;

    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    iget-object v3, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->repo:Lru/oopssre/imperialschool/viewstv/Repository;

    invoke-virtual {v3}, Lru/oopssre/imperialschool/viewstv/Repository;->selected()Lru/oopssre/imperialschool/viewstv/Protocol$Theme;

    move-result-object v3

    invoke-static {v3}, Lru/oopssre/imperialschool/viewstv/ThemeText;->title(Lru/oopssre/imperialschool/viewstv/Protocol$Theme;)Ljava/lang/String;

    move-result-object v3

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    const-string v3, "\n\n"

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    iget-object v3, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->video:Lru/oopssre/imperialschool/viewstv/VideoSurface;

    iget-object v3, v3, Lru/oopssre/imperialschool/viewstv/VideoSurface;->state:Ljava/lang/String;

    const-string v4, "\u041e\u0448\u0438\u0431\u043a\u0430 \u0432\u0438\u0434\u0435\u043e"

    invoke-virtual {v3, v4}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z

    move-result v3

    if-eqz v3, :cond_4

    iget-object v3, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->video:Lru/oopssre/imperialschool/viewstv/VideoSurface;

    iget-object v3, v3, Lru/oopssre/imperialschool/viewstv/VideoSurface;->state:Ljava/lang/String;

    goto :goto_1

    :cond_4
    iget-object v3, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->videoController:Lru/oopssre/imperialschool/viewstv/VideoController;

    iget-object v3, v3, Lru/oopssre/imperialschool/viewstv/VideoController;->status:Ljava/lang/String;

    :goto_1
    invoke-virtual {p0, v3}, Lru/oopssre/imperialschool/viewstv/TvScene;->waitingText(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v3

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v0, v2}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->placeholder:Landroid/widget/TextView;

    iget-object v2, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->panel:Landroid/widget/ScrollView;

    invoke-virtual {v2}, Landroid/widget/ScrollView;->getVisibility()I

    move-result v2

    if-nez v2, :cond_5

    goto :goto_2

    :cond_5
    const/4 v1, 0x0

    :goto_2
    invoke-virtual {v0, v1}, Landroid/widget/TextView;->setVisibility(I)V

    :cond_6
    :goto_3
    return-void
.end method

.method waitingText(Ljava/lang/String;)Ljava/lang/String;
    .locals 0

    .line 100
    invoke-static {p1}, Lru/oopssre/imperialschool/viewstv/SceneCopy;->waiting(Ljava/lang/String;)Ljava/lang/String;

    move-result-object p1

    return-object p1
.end method

.method weatherList()V
    .locals 9

    .line 166
    const-string v0, "weather"

    const-string v1, "\u0418\u0441\u0442\u043e\u0447\u043d\u0438\u043a \u043f\u043e\u0433\u043e\u0434\u044b"

    invoke-virtual {p0, v0, v1}, Lru/oopssre/imperialschool/viewstv/TvScene;->beginPage(Ljava/lang/String;Ljava/lang/String;)V

    const/4 v0, 0x2

    new-array v1, v0, [Ljava/lang/String;

    const/4 v2, 0x0

    const-string v3, "real"

    aput-object v3, v1, v2

    const/4 v4, 0x1

    const-string v5, "game-world"

    aput-object v5, v1, v4

    :goto_0
    const-string v4, "\u041f\u043e\u0433\u043e\u0434\u0430 \u0421\u0442\u043e\u043b\u0438\u0446\u044b \u0418\u043c\u043f\u0435\u0440\u0438\u0438"

    const-string v5, "\u0418\u0433\u0440\u043e\u0432\u043e\u0439 \u043c\u0438\u0440"

    if-ge v2, v0, :cond_2

    aget-object v6, v1, v2

    :try_start_0
    iget-object v7, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->repo:Lru/oopssre/imperialschool/viewstv/Repository;

    invoke-virtual {v7}, Lru/oopssre/imperialschool/viewstv/Repository;->selected()Lru/oopssre/imperialschool/viewstv/Protocol$Theme;

    move-result-object v7

    invoke-static {v7, v6}, Lru/oopssre/imperialschool/viewstv/Sources;->source(Lru/oopssre/imperialschool/viewstv/Protocol$Theme;Ljava/lang/String;)Lorg/json/JSONObject;
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    iget-object v7, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->repo:Lru/oopssre/imperialschool/viewstv/Repository;

    invoke-virtual {v7}, Lru/oopssre/imperialschool/viewstv/Repository;->weatherSource()Ljava/lang/String;

    move-result-object v7

    invoke-virtual {v6, v7}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v7

    if-eqz v7, :cond_0

    const-string v7, "\u2713 "

    goto :goto_1

    :cond_0
    const-string v7, ""

    :goto_1
    invoke-virtual {v6, v3}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v8

    if-eqz v8, :cond_1

    goto :goto_2

    :cond_1
    move-object v4, v5

    :goto_2
    invoke-virtual {v7, v4}, Ljava/lang/String;->concat(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v4

    new-instance v5, Lru/oopssre/imperialschool/viewstv/TvScene$$ExternalSyntheticLambda6;

    invoke-direct {v5, p0, v6}, Lru/oopssre/imperialschool/viewstv/TvScene$$ExternalSyntheticLambda6;-><init>(Lru/oopssre/imperialschool/viewstv/TvScene;Ljava/lang/String;)V

    invoke-virtual {p0, v4, v5}, Lru/oopssre/imperialschool/viewstv/TvScene;->button(Ljava/lang/String;Ljava/lang/Runnable;)Landroid/widget/Button;

    :catch_0
    add-int/lit8 v2, v2, 0x1

    goto :goto_0

    :cond_2
    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->repo:Lru/oopssre/imperialschool/viewstv/Repository;

    invoke-virtual {v0}, Lru/oopssre/imperialschool/viewstv/Repository;->weatherSource()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {v0, v3}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_3

    goto :goto_3

    :cond_3
    move-object v4, v5

    :goto_3
    invoke-virtual {p0, v4}, Lru/oopssre/imperialschool/viewstv/TvScene;->focusFirst(Ljava/lang/String;)V

    return-void
.end method

.method private resetExitBack()V
    .locals 2

    const-wide/16 v0, 0x0
    iput-wide v0, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->exitBackUntil:J
    return-void
.end method

.method private backFromScene()V
    .locals 6

    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->host:Lru/oopssre/imperialschool/viewstv/TvScene$Host;
    instance-of v5, v0, Lru/oopssre/imperialschool/viewstv/WallpaperDream;
    if-nez v5, :exit

    invoke-static {}, Landroid/os/SystemClock;->uptimeMillis()J
    move-result-wide v1
    iget-wide v3, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->exitBackUntil:J
    cmp-long v5, v1, v3
    if-ltz v5, :exit

    const-wide/16 v3, 0x7d0
    add-long/2addr v1, v3
    iput-wide v1, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->exitBackUntil:J
    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->context:Landroid/content/Context;
    const-string v1, "Нажмите «Назад» ещё раз для выхода"
    const/4 v2, 0x0
    invoke-static {v0, v1, v2}, Landroid/widget/Toast;->makeText(Landroid/content/Context;Ljava/lang/CharSequence;I)Landroid/widget/Toast;
    move-result-object v0
    invoke-virtual {v0}, Landroid/widget/Toast;->show()V
    return-void

    :exit
    invoke-direct {p0}, Lru/oopssre/imperialschool/viewstv/TvScene;->resetExitBack()V
    invoke-interface {v0}, Lru/oopssre/imperialschool/viewstv/TvScene$Host;->leave()V
    return-void
.end method

.method private openMenuUntilFrame()V
    .locals 2

    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->host:Lru/oopssre/imperialschool/viewstv/TvScene$Host;
    instance-of v0, v0, Lru/oopssre/imperialschool/viewstv/WallpaperDream;
    if-nez v0, :done

    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->panel:Landroid/widget/ScrollView;
    invoke-virtual {v0}, Landroid/widget/ScrollView;->getVisibility()I
    move-result v0
    if-eqz v0, :done

    invoke-virtual {p0}, Lru/oopssre/imperialschool/viewstv/TvScene;->videoEnabled()Z
    move-result v0
    if-eqz v0, :image

    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->video:Lru/oopssre/imperialschool/viewstv/VideoSurface;
    iget-boolean v0, v0, Lru/oopssre/imperialschool/viewstv/VideoSurface;->playing:Z
    if-nez v0, :done
    goto :open

    :image
    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->controller:Lru/oopssre/imperialschool/viewstv/SceneController;
    iget-object v0, v0, Lru/oopssre/imperialschool/viewstv/SceneController;->frame:Lru/oopssre/imperialschool/viewstv/Protocol$Frame;
    if-nez v0, :done

    :open
    invoke-virtual {p0}, Lru/oopssre/imperialschool/viewstv/TvScene;->openSettings()V
    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->placeholder:Landroid/widget/TextView;
    const/4 v1, 0x0
    invoke-virtual {v0, v1}, Landroid/widget/TextView;->setVisibility(I)V

    :done
    return-void
.end method

.method private showStationVolume()V
    .locals 3

    const-string v0, "music"
    const-string v1, "volume"
    iget-object v2, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->focusMemory:Ljava/util/Map;
    invoke-interface {v2, v0, v1}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;
    iget-object v2, p0, Lru/oopssre/imperialschool/viewstv/TvScene;->scrollMemory:Ljava/util/Map;
    invoke-interface {v2, v0}, Ljava/util/Map;->remove(Ljava/lang/Object;)Ljava/lang/Object;
    invoke-virtual {p0}, Lru/oopssre/imperialschool/viewstv/TvScene;->musicMenu()V
    return-void
.end method
