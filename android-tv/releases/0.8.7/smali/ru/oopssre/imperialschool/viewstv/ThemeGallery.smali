.class final Lru/oopssre/imperialschool/viewstv/ThemeGallery;
.super Ljava/lang/Object;
.source "ThemeGallery.java"

# interfaces
.implements Ljava/lang/AutoCloseable;


# instance fields
.field bitmap:Landroid/graphics/Bitmap;

.field cacheJob:Ljava/util/concurrent/Future;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/concurrent/Future<",
            "*>;"
        }
    .end annotation
.end field

.field closed:Z

.field delayed:Ljava/lang/Runnable;

.field final description:Landroid/widget/TextView;

.field generation:J

.field final image:Landroid/widget/ImageView;

.field job:Ljava/util/concurrent/Future;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/concurrent/Future<",
            "*>;"
        }
    .end annotation
.end field

.field final list:Landroid/widget/ScrollView;

.field final main:Landroid/os/Handler;

.field final scene:Lru/oopssre/imperialschool/viewstv/TvScene;

.field final state:Landroid/widget/TextView;

.field final title:Landroid/widget/TextView;

.field final worker:Ljava/util/concurrent/ExecutorService;


# direct methods
.method constructor <init>(Lru/oopssre/imperialschool/viewstv/TvScene;Ljava/util/List;)V
    .locals 19
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Lru/oopssre/imperialschool/viewstv/TvScene;",
            "Ljava/util/List<",
            "Lru/oopssre/imperialschool/viewstv/Protocol$Theme;",
            ">;)V"
        }
    .end annotation

    move-object/from16 v0, p0

    move-object/from16 v1, p1

    .line 25
    invoke-direct {v0}, Ljava/lang/Object;-><init>()V

    .line 17
    new-instance v2, Landroid/os/Handler;

    invoke-static {}, Landroid/os/Looper;->getMainLooper()Landroid/os/Looper;

    move-result-object v3

    invoke-direct {v2, v3}, Landroid/os/Handler;-><init>(Landroid/os/Looper;)V

    iput-object v2, v0, Lru/oopssre/imperialschool/viewstv/ThemeGallery;->main:Landroid/os/Handler;

    .line 26
    iput-object v1, v0, Lru/oopssre/imperialschool/viewstv/ThemeGallery;->scene:Lru/oopssre/imperialschool/viewstv/TvScene;

    iget-object v2, v1, Lru/oopssre/imperialschool/viewstv/TvScene;->previewWorker:Ljava/util/concurrent/ExecutorService;

    iput-object v2, v0, Lru/oopssre/imperialschool/viewstv/ThemeGallery;->worker:Ljava/util/concurrent/ExecutorService;

    .line 27
    new-instance v2, Landroid/widget/LinearLayout;

    iget-object v3, v1, Lru/oopssre/imperialschool/viewstv/TvScene;->context:Landroid/content/Context;

    invoke-direct {v2, v3}, Landroid/widget/LinearLayout;-><init>(Landroid/content/Context;)V

    const/4 v3, 0x0

    .line 28
    invoke-virtual {v2, v3}, Landroid/widget/LinearLayout;->setOrientation(I)V

    const/16 v4, 0x118

    .line 29
    invoke-virtual {v1, v4}, Lru/oopssre/imperialschool/viewstv/TvScene;->dp(I)I

    move-result v4

    iget-object v5, v1, Lru/oopssre/imperialschool/viewstv/TvScene;->context:Landroid/content/Context;

    invoke-virtual {v5}, Landroid/content/Context;->getResources()Landroid/content/res/Resources;

    move-result-object v5

    invoke-virtual {v5}, Landroid/content/res/Resources;->getDisplayMetrics()Landroid/util/DisplayMetrics;

    move-result-object v5

    iget v5, v5, Landroid/util/DisplayMetrics;->heightPixels:I

    const/16 v6, 0xa0

    invoke-virtual {v1, v6}, Lru/oopssre/imperialschool/viewstv/TvScene;->dp(I)I

    move-result v6

    sub-int/2addr v5, v6

    invoke-static {v4, v5}, Ljava/lang/Math;->max(II)I

    move-result v4

    .line 30
    iget-object v5, v1, Lru/oopssre/imperialschool/viewstv/TvScene;->content:Landroid/widget/LinearLayout;

    new-instance v6, Landroid/widget/LinearLayout$LayoutParams;

    const/4 v7, -0x1

    invoke-direct {v6, v7, v4}, Landroid/widget/LinearLayout$LayoutParams;-><init>(II)V

    invoke-virtual {v5, v2, v6}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    .line 31
    new-instance v4, Landroid/widget/LinearLayout;

    iget-object v5, v1, Lru/oopssre/imperialschool/viewstv/TvScene;->context:Landroid/content/Context;

    invoke-direct {v4, v5}, Landroid/widget/LinearLayout;-><init>(Landroid/content/Context;)V

    const/4 v5, 0x1

    .line 32
    invoke-virtual {v4, v5}, Landroid/widget/LinearLayout;->setOrientation(I)V

    .line 33
    new-instance v6, Landroid/widget/LinearLayout$LayoutParams;

    const/high16 v8, 0x3f800000    # 1.0f

    invoke-direct {v6, v3, v7, v8}, Landroid/widget/LinearLayout$LayoutParams;-><init>(IIF)V

    const/16 v9, 0x18

    .line 34
    invoke-virtual {v1, v9}, Lru/oopssre/imperialschool/viewstv/TvScene;->dp(I)I

    move-result v9

    iput v9, v6, Landroid/widget/LinearLayout$LayoutParams;->rightMargin:I

    invoke-virtual {v2, v4, v6}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    .line 35
    new-instance v6, Landroid/widget/ImageView;

    iget-object v9, v1, Lru/oopssre/imperialschool/viewstv/TvScene;->context:Landroid/content/Context;

    invoke-direct {v6, v9}, Landroid/widget/ImageView;-><init>(Landroid/content/Context;)V

    iput-object v6, v0, Lru/oopssre/imperialschool/viewstv/ThemeGallery;->image:Landroid/widget/ImageView;

    sget-object v9, Landroid/widget/ImageView$ScaleType;->FIT_CENTER:Landroid/widget/ImageView$ScaleType;

    invoke-virtual {v6, v9}, Landroid/widget/ImageView;->setScaleType(Landroid/widget/ImageView$ScaleType;)V

    const v9, -0xf5f6e9

    .line 36
    invoke-virtual {v6, v9}, Landroid/widget/ImageView;->setBackgroundColor(I)V

    const-string v9, "\u041f\u0440\u0435\u0434\u043f\u0440\u043e\u0441\u043c\u043e\u0442\u0440 \u043a\u043e\u043b\u043b\u0435\u043a\u0446\u0438\u0438"

    invoke-virtual {v6, v9}, Landroid/widget/ImageView;->setContentDescription(Ljava/lang/CharSequence;)V

    .line 37
    new-instance v9, Landroid/widget/LinearLayout$LayoutParams;

    const/16 v10, 0xb4

    invoke-virtual {v1, v10}, Lru/oopssre/imperialschool/viewstv/TvScene;->dp(I)I

    move-result v10

    invoke-direct {v9, v7, v10}, Landroid/widget/LinearLayout$LayoutParams;-><init>(II)V

    invoke-virtual {v4, v6, v9}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    const/16 v6, 0x17

    .line 38
    const-string v9, ""

    invoke-virtual {v1, v9, v6}, Lru/oopssre/imperialschool/viewstv/TvScene;->text(Ljava/lang/String;I)Landroid/widget/TextView;

    move-result-object v6

    iput-object v6, v0, Lru/oopssre/imperialschool/viewstv/ThemeGallery;->title:Landroid/widget/TextView;

    const/16 v10, 0xe

    invoke-virtual {v1, v10}, Lru/oopssre/imperialschool/viewstv/TvScene;->dp(I)I

    move-result v10

    const/16 v11, 0x8

    invoke-virtual {v1, v11}, Lru/oopssre/imperialschool/viewstv/TvScene;->dp(I)I

    move-result v12

    invoke-virtual {v6, v3, v10, v3, v12}, Landroid/widget/TextView;->setPadding(IIII)V

    const/4 v10, 0x2

    .line 39
    invoke-virtual {v6, v10}, Landroid/widget/TextView;->setMaxLines(I)V

    sget-object v12, Landroid/text/TextUtils$TruncateAt;->END:Landroid/text/TextUtils$TruncateAt;

    invoke-virtual {v6, v12}, Landroid/widget/TextView;->setEllipsize(Landroid/text/TextUtils$TruncateAt;)V

    iget-object v12, v1, Lru/oopssre/imperialschool/viewstv/TvScene;->context:Landroid/content/Context;

    invoke-virtual {v12}, Landroid/content/Context;->getResources()Landroid/content/res/Resources;

    move-result-object v12

    sget v13, Lru/oopssre/imperialschool/viewstv/R$font;->oswald_semibold:I

    invoke-virtual {v12, v13}, Landroid/content/res/Resources;->getFont(I)Landroid/graphics/Typeface;

    move-result-object v12

    invoke-virtual {v6, v12}, Landroid/widget/TextView;->setTypeface(Landroid/graphics/Typeface;)V

    .line 40
    invoke-virtual {v4, v6}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    const/16 v6, 0x12

    .line 41
    invoke-virtual {v1, v9, v6}, Lru/oopssre/imperialschool/viewstv/TvScene;->text(Ljava/lang/String;I)Landroid/widget/TextView;

    move-result-object v12

    iput-object v12, v0, Lru/oopssre/imperialschool/viewstv/ThemeGallery;->description:Landroid/widget/TextView;

    const/4 v13, 0x3

    invoke-virtual {v12, v13}, Landroid/widget/TextView;->setMaxLines(I)V

    .line 42
    sget-object v14, Landroid/text/TextUtils$TruncateAt;->END:Landroid/text/TextUtils$TruncateAt;

    invoke-virtual {v12, v14}, Landroid/widget/TextView;->setEllipsize(Landroid/text/TextUtils$TruncateAt;)V

    invoke-virtual {v4, v12}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    const/16 v12, 0x11

    .line 43
    invoke-virtual {v1, v9, v12}, Lru/oopssre/imperialschool/viewstv/TvScene;->text(Ljava/lang/String;I)Landroid/widget/TextView;

    move-result-object v12

    iput-object v12, v0, Lru/oopssre/imperialschool/viewstv/ThemeGallery;->state:Landroid/widget/TextView;

    const v14, -0x464e32

    invoke-virtual {v12, v14}, Landroid/widget/TextView;->setTextColor(I)V

    const/16 v15, 0xa

    invoke-virtual {v1, v15}, Lru/oopssre/imperialschool/viewstv/TvScene;->dp(I)I

    move-result v15

    invoke-virtual {v12, v3, v15, v3, v3}, Landroid/widget/TextView;->setPadding(IIII)V

    invoke-virtual {v4, v12}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    .line 44
    new-instance v4, Landroid/widget/ScrollView;

    iget-object v12, v1, Lru/oopssre/imperialschool/viewstv/TvScene;->context:Landroid/content/Context;

    invoke-direct {v4, v12}, Landroid/widget/ScrollView;-><init>(Landroid/content/Context;)V

    iput-object v4, v0, Lru/oopssre/imperialschool/viewstv/ThemeGallery;->list:Landroid/widget/ScrollView;

    invoke-virtual {v4, v5}, Landroid/widget/ScrollView;->setFillViewport(Z)V

    invoke-virtual {v4, v5}, Landroid/widget/ScrollView;->setVerticalFadingEdgeEnabled(Z)V

    const/16 v12, 0x10

    invoke-virtual {v1, v12}, Lru/oopssre/imperialschool/viewstv/TvScene;->dp(I)I

    move-result v12

    invoke-virtual {v4, v12}, Landroid/widget/ScrollView;->setFadingEdgeLength(I)V

    .line 45
    new-instance v12, Landroid/widget/LinearLayout$LayoutParams;

    invoke-direct {v12, v3, v7, v8}, Landroid/widget/LinearLayout$LayoutParams;-><init>(IIF)V

    invoke-virtual {v2, v4, v12}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    .line 46
    new-instance v2, Landroid/widget/LinearLayout;

    iget-object v8, v1, Lru/oopssre/imperialschool/viewstv/TvScene;->context:Landroid/content/Context;

    invoke-direct {v2, v8}, Landroid/widget/LinearLayout;-><init>(Landroid/content/Context;)V

    invoke-virtual {v2, v5}, Landroid/widget/LinearLayout;->setOrientation(I)V

    .line 47
    new-instance v8, Landroid/widget/FrameLayout$LayoutParams;

    const/4 v12, -0x2

    invoke-direct {v8, v7, v12}, Landroid/widget/FrameLayout$LayoutParams;-><init>(II)V

    invoke-virtual {v4, v2, v8}, Landroid/widget/ScrollView;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    .line 48
    iget-object v4, v1, Lru/oopssre/imperialschool/viewstv/TvScene;->repo:Lru/oopssre/imperialschool/viewstv/Repository;

    invoke-virtual {v4}, Lru/oopssre/imperialschool/viewstv/Repository;->selected()Lru/oopssre/imperialschool/viewstv/Protocol$Theme;

    move-result-object v4

    iget-object v4, v4, Lru/oopssre/imperialschool/viewstv/Protocol$Theme;->id:Ljava/lang/String;

    .line 49
    new-array v7, v13, [Ljava/lang/String;

    const-string v8, "dynamic"

    aput-object v8, v7, v3

    const-string v12, "weather"

    aput-object v12, v7, v5

    const-string v15, "plain"

    aput-object v15, v7, v10

    move v10, v3

    :goto_0
    if-ge v10, v13, :cond_6

    aget-object v5, v7, v10

    .line 51
    invoke-interface/range {p2 .. p2}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object v16

    move/from16 v17, v3

    :goto_1
    invoke-interface/range {v16 .. v16}, Ljava/util/Iterator;->hasNext()Z

    move-result v18

    if-eqz v18, :cond_5

    invoke-interface/range {v16 .. v16}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v18

    move-object/from16 v13, v18

    check-cast v13, Lru/oopssre/imperialschool/viewstv/Protocol$Theme;

    .line 52
    iget-object v3, v13, Lru/oopssre/imperialschool/viewstv/Protocol$Theme;->kind:Ljava/lang/String;

    invoke-virtual {v3, v8}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v3

    if-eqz v3, :cond_0

    move-object v3, v8

    goto :goto_2

    :cond_0
    iget-object v3, v13, Lru/oopssre/imperialschool/viewstv/Protocol$Theme;->kind:Ljava/lang/String;

    invoke-virtual {v3, v12}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v3

    if-eqz v3, :cond_1

    move-object v3, v12

    goto :goto_2

    :cond_1
    move-object v3, v15

    .line 53
    :goto_2
    invoke-virtual {v3, v5}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v3

    if-nez v3, :cond_2

    const/4 v3, 0x0

    const/4 v13, 0x3

    goto :goto_1

    :cond_2
    if-nez v17, :cond_3

    .line 54
    invoke-static {v5}, Lru/oopssre/imperialschool/viewstv/ThemeText;->group(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v3

    invoke-virtual {v1, v3, v6}, Lru/oopssre/imperialschool/viewstv/TvScene;->text(Ljava/lang/String;I)Landroid/widget/TextView;

    move-result-object v3

    invoke-virtual {v3, v14}, Landroid/widget/TextView;->setTextColor(I)V

    invoke-virtual {v1, v11}, Lru/oopssre/imperialschool/viewstv/TvScene;->dp(I)I

    move-result v6

    const/16 v11, 0xc

    invoke-virtual {v1, v11}, Lru/oopssre/imperialschool/viewstv/TvScene;->dp(I)I

    move-result v11

    const/4 v14, 0x0

    invoke-virtual {v3, v14, v6, v14, v11}, Landroid/widget/TextView;->setPadding(IIII)V

    invoke-virtual {v2, v3}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    const/16 v17, 0x1

    goto :goto_3

    :cond_3
    const/4 v14, 0x0

    .line 55
    :goto_3
    new-instance v3, Ljava/lang/StringBuilder;

    const-string v6, "theme:"

    invoke-direct {v3, v6}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    iget-object v6, v13, Lru/oopssre/imperialschool/viewstv/Protocol$Theme;->id:Ljava/lang/String;

    invoke-virtual {v3, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v3

    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v3

    new-instance v6, Ljava/lang/StringBuilder;

    invoke-direct {v6}, Ljava/lang/StringBuilder;-><init>()V

    iget-object v11, v13, Lru/oopssre/imperialschool/viewstv/Protocol$Theme;->id:Ljava/lang/String;

    invoke-virtual {v11, v4}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v11

    if-eqz v11, :cond_4

    const-string v11, "\u2713 "

    goto :goto_4

    :cond_4
    move-object v11, v9

    :goto_4
    invoke-virtual {v6, v11}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v6

    invoke-static {v13}, Lru/oopssre/imperialschool/viewstv/ThemeText;->title(Lru/oopssre/imperialschool/viewstv/Protocol$Theme;)Ljava/lang/String;

    move-result-object v11

    invoke-virtual {v6, v11}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v6

    invoke-virtual {v6}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v6

    new-instance v11, Lru/oopssre/imperialschool/viewstv/ThemeGallery$$ExternalSyntheticLambda1;

    invoke-direct {v11, v1, v13}, Lru/oopssre/imperialschool/viewstv/ThemeGallery$$ExternalSyntheticLambda1;-><init>(Lru/oopssre/imperialschool/viewstv/TvScene;Lru/oopssre/imperialschool/viewstv/Protocol$Theme;)V

    invoke-virtual {v1, v3, v6, v11}, Lru/oopssre/imperialschool/viewstv/TvScene;->makeButton(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Runnable;)Landroid/widget/Button;

    move-result-object v3

    .line 56
    new-instance v6, Lru/oopssre/imperialschool/viewstv/ThemeGallery$$ExternalSyntheticLambda2;

    invoke-direct {v6, v0, v13}, Lru/oopssre/imperialschool/viewstv/ThemeGallery$$ExternalSyntheticLambda2;-><init>(Lru/oopssre/imperialschool/viewstv/ThemeGallery;Lru/oopssre/imperialschool/viewstv/Protocol$Theme;)V

    invoke-virtual {v3, v6}, Landroid/widget/Button;->setOnFocusChangeListener(Landroid/view/View$OnFocusChangeListener;)V

    .line 57
    invoke-virtual {v1}, Lru/oopssre/imperialschool/viewstv/TvScene;->buttonLayout()Landroid/widget/LinearLayout$LayoutParams;

    move-result-object v6

    invoke-virtual {v2, v3, v6}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    move v3, v14

    const/16 v6, 0x12

    const/16 v11, 0x8

    const/4 v13, 0x3

    const v14, -0x464e32

    goto/16 :goto_1

    :cond_5
    move v14, v3

    add-int/lit8 v10, v10, 0x1

    const/4 v5, 0x1

    const/16 v6, 0x12

    const/16 v11, 0x8

    const/4 v13, 0x3

    const v14, -0x464e32

    goto/16 :goto_0

    .line 60
    :cond_6
    iget-object v3, v1, Lru/oopssre/imperialschool/viewstv/TvScene;->repo:Lru/oopssre/imperialschool/viewstv/Repository;

    invoke-virtual {v3}, Lru/oopssre/imperialschool/viewstv/Repository;->selected()Lru/oopssre/imperialschool/viewstv/Protocol$Theme;

    move-result-object v3

    .line 61
    iget-object v3, v3, Lru/oopssre/imperialschool/viewstv/Protocol$Theme;->kind:Ljava/lang/String;

    invoke-virtual {v3, v8}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v3

    if-nez v3, :cond_7

    .line 62
    invoke-static {v1}, Ljava/util/Objects;->requireNonNull(Ljava/lang/Object;)Ljava/lang/Object;

    new-instance v3, Lru/oopssre/imperialschool/viewstv/ThemeGallery$$ExternalSyntheticLambda3;

    invoke-direct {v3, v1}, Lru/oopssre/imperialschool/viewstv/ThemeGallery$$ExternalSyntheticLambda3;-><init>(Lru/oopssre/imperialschool/viewstv/TvScene;)V

    const-string v4, "collection"

    const-string v5, "\u041f\u0430\u0440\u0430\u043c\u0435\u0442\u0440\u044b \u0442\u0435\u043a\u0443\u0449\u0438\u0445 \u043e\u0431\u043e\u0435\u0432"

    invoke-virtual {v1, v4, v5, v3}, Lru/oopssre/imperialschool/viewstv/TvScene;->makeButton(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Runnable;)Landroid/widget/Button;

    move-result-object v3

    .line 63
    invoke-virtual {v1}, Lru/oopssre/imperialschool/viewstv/TvScene;->buttonLayout()Landroid/widget/LinearLayout$LayoutParams;

    move-result-object v1

    invoke-virtual {v2, v3, v1}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    :cond_7
    return-void
.end method

.method static synthetic lambda$drain$7()V
    .locals 0

    return-void
.end method

.method static synthetic lambda$new$0(Lru/oopssre/imperialschool/viewstv/TvScene;Lru/oopssre/imperialschool/viewstv/Protocol$Theme;)V
    .locals 0

    .line 55
    invoke-virtual {p0, p1}, Lru/oopssre/imperialschool/viewstv/TvScene;->chooseTheme(Lru/oopssre/imperialschool/viewstv/Protocol$Theme;)V

    return-void
.end method


# virtual methods
.method clearBitmap()V
    .locals 2

    .line 99
    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/ThemeGallery;->image:Landroid/widget/ImageView;

    const/4 v1, 0x0

    invoke-virtual {v0, v1}, Landroid/widget/ImageView;->setImageDrawable(Landroid/graphics/drawable/Drawable;)V

    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/ThemeGallery;->bitmap:Landroid/graphics/Bitmap;

    if-eqz v0, :cond_0

    invoke-virtual {v0}, Landroid/graphics/Bitmap;->recycle()V

    iput-object v1, p0, Lru/oopssre/imperialschool/viewstv/ThemeGallery;->bitmap:Landroid/graphics/Bitmap;

    :cond_0
    return-void
.end method

.method public close()V
    .locals 5

    const/4 v0, 0x1

    .line 100
    iput-boolean v0, p0, Lru/oopssre/imperialschool/viewstv/ThemeGallery;->closed:Z

    iget-wide v1, p0, Lru/oopssre/imperialschool/viewstv/ThemeGallery;->generation:J

    const-wide/16 v3, 0x1

    add-long/2addr v1, v3

    iput-wide v1, p0, Lru/oopssre/imperialschool/viewstv/ThemeGallery;->generation:J

    iget-object v1, p0, Lru/oopssre/imperialschool/viewstv/ThemeGallery;->delayed:Ljava/lang/Runnable;

    if-eqz v1, :cond_0

    iget-object v2, p0, Lru/oopssre/imperialschool/viewstv/ThemeGallery;->main:Landroid/os/Handler;

    invoke-virtual {v2, v1}, Landroid/os/Handler;->removeCallbacks(Ljava/lang/Runnable;)V

    :cond_0
    iget-object v1, p0, Lru/oopssre/imperialschool/viewstv/ThemeGallery;->job:Ljava/util/concurrent/Future;

    if-eqz v1, :cond_1

    invoke-interface {v1, v0}, Ljava/util/concurrent/Future;->cancel(Z)Z

    :cond_1
    iget-object v1, p0, Lru/oopssre/imperialschool/viewstv/ThemeGallery;->cacheJob:Ljava/util/concurrent/Future;

    if-eqz v1, :cond_2

    invoke-interface {v1, v0}, Ljava/util/concurrent/Future;->cancel(Z)Z

    :cond_2
    invoke-virtual {p0}, Lru/oopssre/imperialschool/viewstv/ThemeGallery;->clearBitmap()V

    return-void
.end method

.method drain()Ljava/util/concurrent/Future;
    .locals 2
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "()",
            "Ljava/util/concurrent/Future<",
            "*>;"
        }
    .end annotation

    .line 101
    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/ThemeGallery;->delayed:Ljava/lang/Runnable;

    if-eqz v0, :cond_0

    iget-object v1, p0, Lru/oopssre/imperialschool/viewstv/ThemeGallery;->main:Landroid/os/Handler;

    invoke-virtual {v1, v0}, Landroid/os/Handler;->removeCallbacks(Ljava/lang/Runnable;)V

    :cond_0
    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/ThemeGallery;->job:Ljava/util/concurrent/Future;

    if-eqz v0, :cond_1

    const/4 v1, 0x1

    invoke-interface {v0, v1}, Ljava/util/concurrent/Future;->cancel(Z)Z

    :cond_1
    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/ThemeGallery;->worker:Ljava/util/concurrent/ExecutorService;

    new-instance v1, Lru/oopssre/imperialschool/viewstv/ThemeGallery$$ExternalSyntheticLambda0;

    invoke-direct {v1}, Lru/oopssre/imperialschool/viewstv/ThemeGallery$$ExternalSyntheticLambda0;-><init>()V

    invoke-interface {v0, v1}, Ljava/util/concurrent/ExecutorService;->submit(Ljava/lang/Runnable;)Ljava/util/concurrent/Future;

    move-result-object v0

    return-object v0
.end method

.method focus(Lru/oopssre/imperialschool/viewstv/Protocol$Theme;)V
    .locals 4

    .line 67
    iget-boolean v0, p0, Lru/oopssre/imperialschool/viewstv/ThemeGallery;->closed:Z

    if-eqz v0, :cond_0

    return-void

    .line 68
    :cond_0
    iget-wide v0, p0, Lru/oopssre/imperialschool/viewstv/ThemeGallery;->generation:J

    const-wide/16 v2, 0x1

    add-long/2addr v0, v2

    iput-wide v0, p0, Lru/oopssre/imperialschool/viewstv/ThemeGallery;->generation:J

    .line 69
    iget-object v2, p0, Lru/oopssre/imperialschool/viewstv/ThemeGallery;->delayed:Ljava/lang/Runnable;

    if-eqz v2, :cond_1

    iget-object v3, p0, Lru/oopssre/imperialschool/viewstv/ThemeGallery;->main:Landroid/os/Handler;

    invoke-virtual {v3, v2}, Landroid/os/Handler;->removeCallbacks(Ljava/lang/Runnable;)V

    .line 70
    :cond_1
    iget-object v2, p0, Lru/oopssre/imperialschool/viewstv/ThemeGallery;->job:Ljava/util/concurrent/Future;

    const/4 v3, 0x1

    if-eqz v2, :cond_2

    invoke-interface {v2, v3}, Ljava/util/concurrent/Future;->cancel(Z)Z

    :cond_2
    iget-object v2, p0, Lru/oopssre/imperialschool/viewstv/ThemeGallery;->cacheJob:Ljava/util/concurrent/Future;

    if-eqz v2, :cond_3

    invoke-interface {v2, v3}, Ljava/util/concurrent/Future;->cancel(Z)Z

    .line 71
    :cond_3
    iget-object v2, p0, Lru/oopssre/imperialschool/viewstv/ThemeGallery;->title:Landroid/widget/TextView;

    invoke-static {p1}, Lru/oopssre/imperialschool/viewstv/ThemeText;->title(Lru/oopssre/imperialschool/viewstv/Protocol$Theme;)Ljava/lang/String;

    move-result-object v3

    invoke-virtual {v2, v3}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    iget-object v2, p0, Lru/oopssre/imperialschool/viewstv/ThemeGallery;->description:Landroid/widget/TextView;

    invoke-static {p1}, Lru/oopssre/imperialschool/viewstv/ThemeText;->description(Lru/oopssre/imperialschool/viewstv/Protocol$Theme;)Ljava/lang/String;

    move-result-object v3

    invoke-virtual {v2, v3}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    .line 72
    invoke-virtual {p0}, Lru/oopssre/imperialschool/viewstv/ThemeGallery;->clearBitmap()V

    iget-object v2, p0, Lru/oopssre/imperialschool/viewstv/ThemeGallery;->state:Landroid/widget/TextView;

    const-string v3, "\u0417\u0430\u0433\u0440\u0443\u0436\u0430\u044e \u043f\u0440\u0435\u0432\u044c\u044e\u2026"

    invoke-virtual {v2, v3}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    .line 73
    new-instance v2, Lru/oopssre/imperialschool/viewstv/ThemeGallery$$ExternalSyntheticLambda4;

    invoke-direct {v2, p0, v0, v1, p1}, Lru/oopssre/imperialschool/viewstv/ThemeGallery$$ExternalSyntheticLambda4;-><init>(Lru/oopssre/imperialschool/viewstv/ThemeGallery;JLru/oopssre/imperialschool/viewstv/Protocol$Theme;)V

    iput-object v2, p0, Lru/oopssre/imperialschool/viewstv/ThemeGallery;->delayed:Ljava/lang/Runnable;

    .line 74
    iget-object p1, p0, Lru/oopssre/imperialschool/viewstv/ThemeGallery;->main:Landroid/os/Handler;

    const-wide/16 v0, 0x12c

    invoke-virtual {p1, v2, v0, v1}, Landroid/os/Handler;->postDelayed(Ljava/lang/Runnable;J)Z

    return-void
.end method

.method synthetic lambda$focus$2$ru-oopssre-imperialschool-viewstv-ThemeGallery(Lru/oopssre/imperialschool/viewstv/Protocol$Theme;J)V
    .locals 0

    .line 73
    invoke-virtual {p0, p1, p2, p3}, Lru/oopssre/imperialschool/viewstv/ThemeGallery;->loadCached(Lru/oopssre/imperialschool/viewstv/Protocol$Theme;J)V

    return-void
.end method

.method synthetic lambda$focus$3$ru-oopssre-imperialschool-viewstv-ThemeGallery(JLru/oopssre/imperialschool/viewstv/Protocol$Theme;)V
    .locals 2

    .line 73
    iget-boolean v0, p0, Lru/oopssre/imperialschool/viewstv/ThemeGallery;->closed:Z

    if-nez v0, :cond_1

    iget-wide v0, p0, Lru/oopssre/imperialschool/viewstv/ThemeGallery;->generation:J

    cmp-long v0, p1, v0

    if-eqz v0, :cond_0

    goto :goto_0

    :cond_0
    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/ThemeGallery;->scene:Lru/oopssre/imperialschool/viewstv/TvScene;

    iget-object v0, v0, Lru/oopssre/imperialschool/viewstv/TvScene;->controller:Lru/oopssre/imperialschool/viewstv/SceneController;

    iget-object v0, v0, Lru/oopssre/imperialschool/viewstv/SceneController;->cacheWorker:Ljava/util/concurrent/ExecutorService;

    new-instance v1, Lru/oopssre/imperialschool/viewstv/ThemeGallery$$ExternalSyntheticLambda6;

    invoke-direct {v1, p0, p3, p1, p2}, Lru/oopssre/imperialschool/viewstv/ThemeGallery$$ExternalSyntheticLambda6;-><init>(Lru/oopssre/imperialschool/viewstv/ThemeGallery;Lru/oopssre/imperialschool/viewstv/Protocol$Theme;J)V

    invoke-interface {v0, v1}, Ljava/util/concurrent/ExecutorService;->submit(Ljava/lang/Runnable;)Ljava/util/concurrent/Future;

    move-result-object p1

    iput-object p1, p0, Lru/oopssre/imperialschool/viewstv/ThemeGallery;->cacheJob:Ljava/util/concurrent/Future;

    :cond_1
    :goto_0
    return-void
.end method

.method synthetic lambda$loadCached$4$ru-oopssre-imperialschool-viewstv-ThemeGallery(Lru/oopssre/imperialschool/viewstv/Protocol$Theme;J)V
    .locals 0

    .line 81
    invoke-virtual {p0, p1, p2, p3}, Lru/oopssre/imperialschool/viewstv/ThemeGallery;->loadNetwork(Lru/oopssre/imperialschool/viewstv/Protocol$Theme;J)V

    return-void
.end method

.method synthetic lambda$loadCached$5$ru-oopssre-imperialschool-viewstv-ThemeGallery(JLru/oopssre/imperialschool/viewstv/Protocol$Theme;)V
    .locals 2

    .line 81
    iget-boolean v0, p0, Lru/oopssre/imperialschool/viewstv/ThemeGallery;->closed:Z

    if-nez v0, :cond_0

    iget-wide v0, p0, Lru/oopssre/imperialschool/viewstv/ThemeGallery;->generation:J

    cmp-long v0, p1, v0

    if-nez v0, :cond_0

    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/ThemeGallery;->worker:Ljava/util/concurrent/ExecutorService;

    new-instance v1, Lru/oopssre/imperialschool/viewstv/ThemeGallery$$ExternalSyntheticLambda7;

    invoke-direct {v1, p0, p3, p1, p2}, Lru/oopssre/imperialschool/viewstv/ThemeGallery$$ExternalSyntheticLambda7;-><init>(Lru/oopssre/imperialschool/viewstv/ThemeGallery;Lru/oopssre/imperialschool/viewstv/Protocol$Theme;J)V

    invoke-interface {v0, v1}, Ljava/util/concurrent/ExecutorService;->submit(Ljava/lang/Runnable;)Ljava/util/concurrent/Future;

    move-result-object p1

    iput-object p1, p0, Lru/oopssre/imperialschool/viewstv/ThemeGallery;->job:Ljava/util/concurrent/Future;

    :cond_0
    return-void
.end method

.method synthetic lambda$new$1$ru-oopssre-imperialschool-viewstv-ThemeGallery(Lru/oopssre/imperialschool/viewstv/Protocol$Theme;Landroid/view/View;Z)V
    .locals 0

    .line 0
    if-eqz p3, :cond_0

    .line 56
    invoke-virtual {p0, p1}, Lru/oopssre/imperialschool/viewstv/ThemeGallery;->focus(Lru/oopssre/imperialschool/viewstv/Protocol$Theme;)V

    :cond_0
    return-void
.end method

.method synthetic lambda$publish$6$ru-oopssre-imperialschool-viewstv-ThemeGallery(JLandroid/graphics/Bitmap;Lru/oopssre/imperialschool/viewstv/Protocol$Theme;)V
    .locals 2

    .line 94
    iget-boolean v0, p0, Lru/oopssre/imperialschool/viewstv/ThemeGallery;->closed:Z

    if-nez v0, :cond_3

    iget-wide v0, p0, Lru/oopssre/imperialschool/viewstv/ThemeGallery;->generation:J

    cmp-long p1, p1, v0

    if-eqz p1, :cond_0

    goto :goto_1

    :cond_0
    if-eqz p3, :cond_2

    .line 95
    iput-object p3, p0, Lru/oopssre/imperialschool/viewstv/ThemeGallery;->bitmap:Landroid/graphics/Bitmap;

    iget-object p1, p0, Lru/oopssre/imperialschool/viewstv/ThemeGallery;->image:Landroid/widget/ImageView;

    invoke-virtual {p1, p3}, Landroid/widget/ImageView;->setImageBitmap(Landroid/graphics/Bitmap;)V

    iget-object p1, p0, Lru/oopssre/imperialschool/viewstv/ThemeGallery;->state:Landroid/widget/TextView;

    iget-object p2, p4, Lru/oopssre/imperialschool/viewstv/Protocol$Theme;->id:Ljava/lang/String;

    iget-object p3, p0, Lru/oopssre/imperialschool/viewstv/ThemeGallery;->scene:Lru/oopssre/imperialschool/viewstv/TvScene;

    iget-object p3, p3, Lru/oopssre/imperialschool/viewstv/TvScene;->repo:Lru/oopssre/imperialschool/viewstv/Repository;

    invoke-virtual {p3}, Lru/oopssre/imperialschool/viewstv/Repository;->selected()Lru/oopssre/imperialschool/viewstv/Protocol$Theme;

    move-result-object p3

    iget-object p3, p3, Lru/oopssre/imperialschool/viewstv/Protocol$Theme;->id:Ljava/lang/String;

    invoke-virtual {p2, p3}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p2

    if-eqz p2, :cond_1

    const-string p2, "\u0423\u0436\u0435 \u0432\u044b\u0431\u0440\u0430\u043d\u043e \u00b7 OK \u2014 \u0432\u0435\u0440\u043d\u0443\u0442\u044c\u0441\u044f"

    goto :goto_0

    :cond_1
    const-string p2, "OK \u2014 \u043f\u0440\u0438\u043c\u0435\u043d\u0438\u0442\u044c"

    :goto_0
    invoke-virtual {p1, p2}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    return-void

    .line 96
    :cond_2
    iget-object p1, p0, Lru/oopssre/imperialschool/viewstv/ThemeGallery;->state:Landroid/widget/TextView;

    const-string p2, "\u041d\u0435 \u0443\u0434\u0430\u043b\u043e\u0441\u044c \u0437\u0430\u0433\u0440\u0443\u0437\u0438\u0442\u044c \u043f\u0440\u0435\u0432\u044c\u044e. OK \u2014 \u0432\u044b\u0431\u0440\u0430\u0442\u044c \u043a\u043e\u043b\u043b\u0435\u043a\u0446\u0438\u044e."

    invoke-virtual {p1, p2}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    return-void

    :cond_3
    :goto_1
    if-eqz p3, :cond_4

    .line 94
    invoke-virtual {p3}, Landroid/graphics/Bitmap;->recycle()V

    :cond_4
    return-void
.end method

.method loadCached(Lru/oopssre/imperialschool/viewstv/Protocol$Theme;J)V
    .locals 4

    .line 78
    :try_start_0
    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/ThemeGallery;->scene:Lru/oopssre/imperialschool/viewstv/TvScene;

    iget-object v0, v0, Lru/oopssre/imperialschool/viewstv/TvScene;->repo:Lru/oopssre/imperialschool/viewstv/Repository;

    invoke-virtual {v0, p1}, Lru/oopssre/imperialschool/viewstv/Repository;->cached(Lru/oopssre/imperialschool/viewstv/Protocol$Theme;)Lru/oopssre/imperialschool/viewstv/Protocol$Frame;

    move-result-object v0

    if-eqz v0, :cond_0

    .line 79
    iget-object v1, p0, Lru/oopssre/imperialschool/viewstv/ThemeGallery;->scene:Lru/oopssre/imperialschool/viewstv/TvScene;

    iget-object v1, v1, Lru/oopssre/imperialschool/viewstv/TvScene;->repo:Lru/oopssre/imperialschool/viewstv/Repository;

    const/16 v2, 0x2d0

    const/16 v3, 0x195

    invoke-virtual {v1, v0, v2, v3}, Lru/oopssre/imperialschool/viewstv/Repository;->decode(Lru/oopssre/imperialschool/viewstv/Protocol$Frame;II)Landroid/graphics/Bitmap;

    move-result-object v0

    invoke-virtual {p0, p1, p2, p3, v0}, Lru/oopssre/imperialschool/viewstv/ThemeGallery;->publish(Lru/oopssre/imperialschool/viewstv/Protocol$Theme;JLandroid/graphics/Bitmap;)V
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    return-void

    .line 80
    :catch_0
    invoke-static {}, Ljava/lang/Thread;->currentThread()Ljava/lang/Thread;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/Thread;->isInterrupted()Z

    move-result v0

    if-eqz v0, :cond_0

    return-void

    .line 81
    :cond_0
    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/ThemeGallery;->main:Landroid/os/Handler;

    new-instance v1, Lru/oopssre/imperialschool/viewstv/ThemeGallery$$ExternalSyntheticLambda5;

    invoke-direct {v1, p0, p2, p3, p1}, Lru/oopssre/imperialschool/viewstv/ThemeGallery$$ExternalSyntheticLambda5;-><init>(Lru/oopssre/imperialschool/viewstv/ThemeGallery;JLru/oopssre/imperialschool/viewstv/Protocol$Theme;)V

    invoke-virtual {v0, v1}, Landroid/os/Handler;->post(Ljava/lang/Runnable;)Z

    return-void
.end method

.method loadNetwork(Lru/oopssre/imperialschool/viewstv/Protocol$Theme;J)V
    .locals 4

    .line 86
    :try_start_0
    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/ThemeGallery;->scene:Lru/oopssre/imperialschool/viewstv/TvScene;

    iget-object v0, v0, Lru/oopssre/imperialschool/viewstv/TvScene;->repo:Lru/oopssre/imperialschool/viewstv/Repository;

    iget-object v1, p0, Lru/oopssre/imperialschool/viewstv/ThemeGallery;->scene:Lru/oopssre/imperialschool/viewstv/TvScene;

    invoke-virtual {v1}, Lru/oopssre/imperialschool/viewstv/TvScene;->imagePin()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, p1, v1}, Lru/oopssre/imperialschool/viewstv/Repository;->refresh(Lru/oopssre/imperialschool/viewstv/Protocol$Theme;Ljava/lang/String;)Lru/oopssre/imperialschool/viewstv/Protocol$Frame;

    move-result-object v0

    .line 87
    invoke-static {}, Ljava/lang/Thread;->currentThread()Ljava/lang/Thread;

    move-result-object v1

    invoke-virtual {v1}, Ljava/lang/Thread;->isInterrupted()Z

    move-result v1

    if-eqz v1, :cond_0

    goto :goto_0

    .line 88
    :cond_0
    iget-object v1, p0, Lru/oopssre/imperialschool/viewstv/ThemeGallery;->scene:Lru/oopssre/imperialschool/viewstv/TvScene;

    iget-object v1, v1, Lru/oopssre/imperialschool/viewstv/TvScene;->repo:Lru/oopssre/imperialschool/viewstv/Repository;

    const/16 v2, 0x2d0

    const/16 v3, 0x195

    invoke-virtual {v1, v0, v2, v3}, Lru/oopssre/imperialschool/viewstv/Repository;->decode(Lru/oopssre/imperialschool/viewstv/Protocol$Frame;II)Landroid/graphics/Bitmap;

    move-result-object v0
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    goto :goto_1

    .line 89
    :catch_0
    invoke-static {}, Ljava/lang/Thread;->currentThread()Ljava/lang/Thread;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/Thread;->isInterrupted()Z

    move-result v0

    if-eqz v0, :cond_1

    :goto_0
    return-void

    :cond_1
    const/4 v0, 0x0

    .line 90
    :goto_1
    invoke-virtual {p0, p1, p2, p3, v0}, Lru/oopssre/imperialschool/viewstv/ThemeGallery;->publish(Lru/oopssre/imperialschool/viewstv/Protocol$Theme;JLandroid/graphics/Bitmap;)V

    return-void
.end method

.method publish(Lru/oopssre/imperialschool/viewstv/Protocol$Theme;JLandroid/graphics/Bitmap;)V
    .locals 7

    .line 93
    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/ThemeGallery;->main:Landroid/os/Handler;

    new-instance v1, Lru/oopssre/imperialschool/viewstv/ThemeGallery$$ExternalSyntheticLambda8;

    move-object v2, p0

    move-object v6, p1

    move-wide v3, p2

    move-object v5, p4

    invoke-direct/range {v1 .. v6}, Lru/oopssre/imperialschool/viewstv/ThemeGallery$$ExternalSyntheticLambda8;-><init>(Lru/oopssre/imperialschool/viewstv/ThemeGallery;JLandroid/graphics/Bitmap;Lru/oopssre/imperialschool/viewstv/Protocol$Theme;)V

    invoke-virtual {v0, v1}, Landroid/os/Handler;->post(Ljava/lang/Runnable;)Z

    return-void
.end method
