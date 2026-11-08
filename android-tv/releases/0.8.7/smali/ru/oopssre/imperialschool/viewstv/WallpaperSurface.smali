.class final Lru/oopssre/imperialschool/viewstv/WallpaperSurface;
.super Landroid/view/SurfaceView;
.source "WallpaperSurface.java"

# interfaces
.implements Landroid/view/SurfaceHolder$Callback;


# instance fields
.field actualHeight:I

.field actualWidth:I

.field bufferHeight:I

.field bufferWidth:I

.field fill:Z

.field image:Landroid/graphics/Bitmap;

.field private final paint:Landroid/graphics/Paint;


# direct methods
.method constructor <init>(Landroid/content/Context;)V
    .locals 1

    .line 10
    invoke-direct {p0, p1}, Landroid/view/SurfaceView;-><init>(Landroid/content/Context;)V

    const/16 p1, 0xf00

    .line 9
    iput p1, p0, Lru/oopssre/imperialschool/viewstv/WallpaperSurface;->bufferWidth:I

    const/16 p1, 0x870

    iput p1, p0, Lru/oopssre/imperialschool/viewstv/WallpaperSurface;->bufferHeight:I

    new-instance p1, Landroid/graphics/Paint;

    const/4 v0, 0x3

    invoke-direct {p1, v0}, Landroid/graphics/Paint;-><init>(I)V

    iput-object p1, p0, Lru/oopssre/imperialschool/viewstv/WallpaperSurface;->paint:Landroid/graphics/Paint;

    .line 10
    invoke-virtual {p0}, Lru/oopssre/imperialschool/viewstv/WallpaperSurface;->getHolder()Landroid/view/SurfaceHolder;

    move-result-object p1

    invoke-interface {p1, p0}, Landroid/view/SurfaceHolder;->addCallback(Landroid/view/SurfaceHolder$Callback;)V

    const/4 p1, 0x0

    invoke-virtual {p0, p1}, Lru/oopssre/imperialschool/viewstv/WallpaperSurface;->setFocusable(Z)V

    const-string p1, "\u0414\u0438\u043d\u0430\u043c\u0438\u0447\u0435\u0441\u043a\u0438\u0435 \u043e\u0431\u043e\u0438"

    invoke-virtual {p0, p1}, Lru/oopssre/imperialschool/viewstv/WallpaperSurface;->setContentDescription(Ljava/lang/CharSequence;)V

    return-void
.end method

.method static bestMode(Landroid/view/Display;)Lru/oopssre/imperialschool/viewstv/TvDisplay$Mode;
    .locals 4

    .line 17
    invoke-virtual {p0}, Landroid/view/Display;->getSupportedModes()[Landroid/view/Display$Mode;

    move-result-object v0

    array-length v1, v0

    new-array v1, v1, [Lru/oopssre/imperialschool/viewstv/TvDisplay$Mode;

    const/4 v2, 0x0

    :goto_0
    array-length v3, v0

    if-ge v2, v3, :cond_0

    aget-object v3, v0, v2

    invoke-static {v3}, Lru/oopssre/imperialschool/viewstv/WallpaperSurface;->mode(Landroid/view/Display$Mode;)Lru/oopssre/imperialschool/viewstv/TvDisplay$Mode;

    move-result-object v3

    aput-object v3, v1, v2

    add-int/lit8 v2, v2, 0x1

    goto :goto_0

    :cond_0
    invoke-virtual {p0}, Landroid/view/Display;->getMode()Landroid/view/Display$Mode;

    move-result-object p0

    invoke-static {p0}, Lru/oopssre/imperialschool/viewstv/WallpaperSurface;->mode(Landroid/view/Display$Mode;)Lru/oopssre/imperialschool/viewstv/TvDisplay$Mode;

    move-result-object p0

    invoke-static {p0, v1}, Lru/oopssre/imperialschool/viewstv/TvDisplay;->choose(Lru/oopssre/imperialschool/viewstv/TvDisplay$Mode;[Lru/oopssre/imperialschool/viewstv/TvDisplay$Mode;)Lru/oopssre/imperialschool/viewstv/TvDisplay$Mode;

    move-result-object p0

    return-object p0
.end method

.method static configure(Landroid/view/Window;Landroid/view/Display;)[I
    .locals 1

    .line 19
    const-string v0, "auto"

    invoke-static {p0, p1, v0}, Lru/oopssre/imperialschool/viewstv/WallpaperSurface;->configure(Landroid/view/Window;Landroid/view/Display;Ljava/lang/String;)[I

    move-result-object p0

    return-object p0
.end method

.method static configure(Landroid/view/Window;Landroid/view/Display;Ljava/lang/String;)[I
    .locals 7

    const/4 v0, 0x2

    .line 21
    new-array v0, v0, [I

    const/16 v1, 0x780

    const/4 v2, 0x0

    aput v1, v0, v2

    const/16 v1, 0x438

    const/4 v3, 0x1

    aput v1, v0, v3

    if-nez p1, :cond_0

    .line 23
    :try_start_0
    invoke-virtual {p0}, Landroid/view/Window;->getWindowManager()Landroid/view/WindowManager;

    move-result-object p1

    invoke-interface {p1}, Landroid/view/WindowManager;->getDefaultDisplay()Landroid/view/Display;

    move-result-object p1

    .line 24
    :cond_0
    invoke-static {p1}, Lru/oopssre/imperialschool/viewstv/WallpaperSurface;->physicalSize(Landroid/view/Display;)[I

    move-result-object v0

    .line 25
    invoke-virtual {p1}, Landroid/view/Display;->getSupportedModes()[Landroid/view/Display$Mode;

    move-result-object v1

    array-length v4, v1

    new-array v4, v4, [Lru/oopssre/imperialschool/viewstv/TvDisplay$Mode;

    move v5, v2

    .line 26
    :goto_0
    array-length v6, v1

    if-ge v5, v6, :cond_1

    aget-object v6, v1, v5

    invoke-static {v6}, Lru/oopssre/imperialschool/viewstv/WallpaperSurface;->mode(Landroid/view/Display$Mode;)Lru/oopssre/imperialschool/viewstv/TvDisplay$Mode;

    move-result-object v6

    aput-object v6, v4, v5

    add-int/lit8 v5, v5, 0x1

    goto :goto_0

    .line 27
    :cond_1
    invoke-virtual {p1}, Landroid/view/Display;->getMode()Landroid/view/Display$Mode;

    move-result-object p1

    invoke-static {p1}, Lru/oopssre/imperialschool/viewstv/WallpaperSurface;->mode(Landroid/view/Display$Mode;)Lru/oopssre/imperialschool/viewstv/TvDisplay$Mode;

    move-result-object p1

    invoke-static {p1, v4, p2}, Lru/oopssre/imperialschool/viewstv/TvDisplay;->choose(Lru/oopssre/imperialschool/viewstv/TvDisplay$Mode;[Lru/oopssre/imperialschool/viewstv/TvDisplay$Mode;Ljava/lang/String;)Lru/oopssre/imperialschool/viewstv/TvDisplay$Mode;

    move-result-object p1

    .line 28
    invoke-virtual {p0}, Landroid/view/Window;->getAttributes()Landroid/view/WindowManager$LayoutParams;

    move-result-object v1

    iget p1, p1, Lru/oopssre/imperialschool/viewstv/TvDisplay$Mode;->id:I

    iput p1, v1, Landroid/view/WindowManager$LayoutParams;->preferredDisplayModeId:I

    invoke-virtual {p0, v1}, Landroid/view/Window;->setAttributes(Landroid/view/WindowManager$LayoutParams;)V
    :try_end_0
    .catch Ljava/lang/RuntimeException; {:try_start_0 .. :try_end_0} :catch_0

    .line 31
    :catch_0
    aget p0, v0, v2

    aget p1, v0, v3

    invoke-static {p2, p0, p1}, Lru/oopssre/imperialschool/viewstv/TvDisplay;->targetSize(Ljava/lang/String;II)[I

    move-result-object p0

    return-object p0
.end method

.method static mode(Landroid/view/Display$Mode;)Lru/oopssre/imperialschool/viewstv/TvDisplay$Mode;
    .locals 4

    .line 16
    new-instance v0, Lru/oopssre/imperialschool/viewstv/TvDisplay$Mode;

    invoke-virtual {p0}, Landroid/view/Display$Mode;->getModeId()I

    move-result v1

    invoke-virtual {p0}, Landroid/view/Display$Mode;->getPhysicalWidth()I

    move-result v2

    invoke-virtual {p0}, Landroid/view/Display$Mode;->getPhysicalHeight()I

    move-result v3

    invoke-virtual {p0}, Landroid/view/Display$Mode;->getRefreshRate()F

    move-result p0

    invoke-direct {v0, v1, v2, v3, p0}, Lru/oopssre/imperialschool/viewstv/TvDisplay$Mode;-><init>(IIIF)V

    return-object v0
.end method

.method static physicalSize(Landroid/view/Display;)[I
    .locals 2

    .line 18
    :try_start_0
    invoke-static {p0}, Lru/oopssre/imperialschool/viewstv/WallpaperSurface;->bestMode(Landroid/view/Display;)Lru/oopssre/imperialschool/viewstv/TvDisplay$Mode;

    move-result-object p0

    iget v0, p0, Lru/oopssre/imperialschool/viewstv/TvDisplay$Mode;->width:I

    const/16 v1, 0xf00

    invoke-static {v1, v0}, Ljava/lang/Math;->min(II)I

    move-result v0

    iget p0, p0, Lru/oopssre/imperialschool/viewstv/TvDisplay$Mode;->height:I

    const/16 v1, 0x870

    invoke-static {v1, p0}, Ljava/lang/Math;->min(II)I

    move-result p0

    filled-new-array {v0, p0}, [I

    move-result-object p0
    :try_end_0
    .catch Ljava/lang/RuntimeException; {:try_start_0 .. :try_end_0} :catch_0

    return-object p0

    :catch_0
    const/16 p0, 0x780

    const/16 v0, 0x438

    filled-new-array {p0, v0}, [I

    move-result-object p0

    return-object p0
.end method


# virtual methods
.method clear()V
    .locals 2

    .line 15
    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/WallpaperSurface;->image:Landroid/graphics/Bitmap;

    const/4 v1, 0x0

    iput-object v1, p0, Lru/oopssre/imperialschool/viewstv/WallpaperSurface;->image:Landroid/graphics/Bitmap;

    if-eqz v0, :cond_0

    invoke-virtual {v0}, Landroid/graphics/Bitmap;->isRecycled()Z

    move-result v1

    if-nez v1, :cond_0

    invoke-virtual {v0}, Landroid/graphics/Bitmap;->recycle()V

    :cond_0
    return-void
.end method

.method drawFrame()V
    .locals 11

    .line 13
    invoke-virtual {p0}, Lru/oopssre/imperialschool/viewstv/WallpaperSurface;->getHolder()Landroid/view/SurfaceHolder;

    move-result-object v0

    invoke-interface {v0}, Landroid/view/SurfaceHolder;->getSurface()Landroid/view/Surface;

    move-result-object v0

    invoke-virtual {v0}, Landroid/view/Surface;->isValid()Z

    move-result v0

    if-nez v0, :cond_0

    goto/16 :goto_4

    :cond_0
    const/4 v0, 0x0

    :try_start_0
    invoke-virtual {p0}, Lru/oopssre/imperialschool/viewstv/WallpaperSurface;->getHolder()Landroid/view/SurfaceHolder;

    move-result-object v1

    invoke-interface {v1}, Landroid/view/SurfaceHolder;->lockCanvas()Landroid/graphics/Canvas;

    move-result-object v1
    :try_end_0
    .catch Ljava/lang/RuntimeException; {:try_start_0 .. :try_end_0} :catch_2
    .catchall {:try_start_0 .. :try_end_0} :catchall_1

    if-nez v1, :cond_1

    if-eqz v1, :cond_5

    :goto_0
    :try_start_1
    invoke-virtual {p0}, Lru/oopssre/imperialschool/viewstv/WallpaperSurface;->getHolder()Landroid/view/SurfaceHolder;

    move-result-object v0

    invoke-interface {v0, v1}, Landroid/view/SurfaceHolder;->unlockCanvasAndPost(Landroid/graphics/Canvas;)V
    :try_end_1
    .catch Ljava/lang/RuntimeException; {:try_start_1 .. :try_end_1} :catch_3

    return-void

    :cond_1
    const/high16 v2, -0x1000000

    :try_start_2
    invoke-virtual {v1, v2}, Landroid/graphics/Canvas;->drawColor(I)V

    iget-object v2, p0, Lru/oopssre/imperialschool/viewstv/WallpaperSurface;->image:Landroid/graphics/Bitmap;

    if-eqz v2, :cond_3

    invoke-virtual {v2}, Landroid/graphics/Bitmap;->isRecycled()Z

    move-result v3

    if-nez v3, :cond_3

    iget-boolean v3, p0, Lru/oopssre/imperialschool/viewstv/WallpaperSurface;->fill:Z

    if-eqz v3, :cond_2

    invoke-virtual {v1}, Landroid/graphics/Canvas;->getWidth()I

    move-result v3

    int-to-float v3, v3

    invoke-virtual {v2}, Landroid/graphics/Bitmap;->getWidth()I

    move-result v4

    int-to-float v4, v4

    div-float/2addr v3, v4

    invoke-virtual {v1}, Landroid/graphics/Canvas;->getHeight()I

    move-result v4

    int-to-float v4, v4

    invoke-virtual {v2}, Landroid/graphics/Bitmap;->getHeight()I

    move-result v5

    int-to-float v5, v5

    div-float/2addr v4, v5

    invoke-static {v3, v4}, Ljava/lang/Math;->max(FF)F

    move-result v3

    goto :goto_1

    :cond_2
    invoke-virtual {v1}, Landroid/graphics/Canvas;->getWidth()I

    move-result v3

    int-to-float v3, v3

    invoke-virtual {v2}, Landroid/graphics/Bitmap;->getWidth()I

    move-result v4

    int-to-float v4, v4

    div-float/2addr v3, v4

    invoke-virtual {v1}, Landroid/graphics/Canvas;->getHeight()I

    move-result v4

    int-to-float v4, v4

    invoke-virtual {v2}, Landroid/graphics/Bitmap;->getHeight()I

    move-result v5

    int-to-float v5, v5

    div-float/2addr v4, v5

    invoke-static {v3, v4}, Ljava/lang/Math;->min(FF)F

    move-result v3

    :goto_1
    invoke-virtual {v2}, Landroid/graphics/Bitmap;->getWidth()I

    move-result v4

    int-to-float v4, v4

    mul-float/2addr v4, v3

    invoke-virtual {v2}, Landroid/graphics/Bitmap;->getHeight()I

    move-result v5

    int-to-float v5, v5

    mul-float/2addr v5, v3

    new-instance v3, Landroid/graphics/RectF;

    invoke-virtual {v1}, Landroid/graphics/Canvas;->getWidth()I

    move-result v6

    int-to-float v6, v6

    sub-float/2addr v6, v4

    const/high16 v7, 0x40000000    # 2.0f

    div-float/2addr v6, v7

    invoke-virtual {v1}, Landroid/graphics/Canvas;->getHeight()I

    move-result v8

    int-to-float v8, v8

    sub-float/2addr v8, v5

    div-float/2addr v8, v7

    invoke-virtual {v1}, Landroid/graphics/Canvas;->getWidth()I

    move-result v9

    int-to-float v9, v9

    add-float/2addr v9, v4

    div-float/2addr v9, v7

    invoke-virtual {v1}, Landroid/graphics/Canvas;->getHeight()I

    move-result v4

    int-to-float v4, v4

    add-float/2addr v4, v5

    div-float/2addr v4, v7

    invoke-direct {v3, v6, v8, v9, v4}, Landroid/graphics/RectF;-><init>(FFFF)V

    iget-object v4, p0, Lru/oopssre/imperialschool/viewstv/WallpaperSurface;->paint:Landroid/graphics/Paint;

    invoke-virtual {v1, v2, v0, v3, v4}, Landroid/graphics/Canvas;->drawBitmap(Landroid/graphics/Bitmap;Landroid/graphics/Rect;Landroid/graphics/RectF;Landroid/graphics/Paint;)V
    :try_end_2
    .catch Ljava/lang/RuntimeException; {:try_start_2 .. :try_end_2} :catch_0
    .catchall {:try_start_2 .. :try_end_2} :catchall_0

    :cond_3
    if-eqz v1, :cond_5

    goto/16 :goto_0

    :catchall_0
    move-exception v0

    goto :goto_2

    :catch_0
    move-object v0, v1

    goto :goto_3

    :catchall_1
    move-exception v1

    move-object v10, v1

    move-object v1, v0

    move-object v0, v10

    :goto_2
    if-eqz v1, :cond_4

    :try_start_3
    invoke-virtual {p0}, Lru/oopssre/imperialschool/viewstv/WallpaperSurface;->getHolder()Landroid/view/SurfaceHolder;

    move-result-object v2

    invoke-interface {v2, v1}, Landroid/view/SurfaceHolder;->unlockCanvasAndPost(Landroid/graphics/Canvas;)V
    :try_end_3
    .catch Ljava/lang/RuntimeException; {:try_start_3 .. :try_end_3} :catch_1

    :catch_1
    :cond_4
    throw v0

    :catch_2
    :goto_3
    if-eqz v0, :cond_5

    :try_start_4
    invoke-virtual {p0}, Lru/oopssre/imperialschool/viewstv/WallpaperSurface;->getHolder()Landroid/view/SurfaceHolder;

    move-result-object v1

    invoke-interface {v1, v0}, Landroid/view/SurfaceHolder;->unlockCanvasAndPost(Landroid/graphics/Canvas;)V
    :try_end_4
    .catch Ljava/lang/RuntimeException; {:try_start_4 .. :try_end_4} :catch_3

    :catch_3
    :cond_5
    :goto_4
    return-void
.end method

.method show(Landroid/graphics/Bitmap;)V
    .locals 1

    .line 12
    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/WallpaperSurface;->image:Landroid/graphics/Bitmap;

    iput-object p1, p0, Lru/oopssre/imperialschool/viewstv/WallpaperSurface;->image:Landroid/graphics/Bitmap;

    invoke-virtual {p0}, Lru/oopssre/imperialschool/viewstv/WallpaperSurface;->drawFrame()V

    if-eqz v0, :cond_0

    if-eq v0, p1, :cond_0

    invoke-virtual {v0}, Landroid/graphics/Bitmap;->isRecycled()Z

    move-result p1

    if-nez p1, :cond_0

    invoke-virtual {v0}, Landroid/graphics/Bitmap;->recycle()V

    :cond_0
    return-void
.end method

.method size(II)V
    .locals 1

    .line 11
    iput p1, p0, Lru/oopssre/imperialschool/viewstv/WallpaperSurface;->bufferWidth:I

    iput p2, p0, Lru/oopssre/imperialschool/viewstv/WallpaperSurface;->bufferHeight:I

    invoke-virtual {p0}, Lru/oopssre/imperialschool/viewstv/WallpaperSurface;->getHolder()Landroid/view/SurfaceHolder;

    move-result-object v0

    invoke-interface {v0, p1, p2}, Landroid/view/SurfaceHolder;->setFixedSize(II)V

    return-void
.end method

.method public surfaceChanged(Landroid/view/SurfaceHolder;III)V
    .locals 0

    .line 14
    iput p3, p0, Lru/oopssre/imperialschool/viewstv/WallpaperSurface;->actualWidth:I

    iput p4, p0, Lru/oopssre/imperialschool/viewstv/WallpaperSurface;->actualHeight:I

    invoke-virtual {p0}, Lru/oopssre/imperialschool/viewstv/WallpaperSurface;->drawFrame()V

    return-void
.end method

.method public surfaceCreated(Landroid/view/SurfaceHolder;)V
    .locals 0

    .line 14
    invoke-virtual {p0}, Lru/oopssre/imperialschool/viewstv/WallpaperSurface;->drawFrame()V

    return-void
.end method

.method public surfaceDestroyed(Landroid/view/SurfaceHolder;)V
    .locals 0

    const/4 p1, 0x0

    .line 14
    iput p1, p0, Lru/oopssre/imperialschool/viewstv/WallpaperSurface;->actualWidth:I

    iput p1, p0, Lru/oopssre/imperialschool/viewstv/WallpaperSurface;->actualHeight:I

    return-void
.end method
