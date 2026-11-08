.class final Lru/oopssre/imperialschool/viewstv/ProxyEditor;
.super Ljava/lang/Object;
.source "ProxyEditor.java"


# static fields
.field private static final SAVES:Ljava/util/concurrent/Executor;


# instance fields
.field private final apply:Landroid/widget/Button;

.field private final external:Landroid/widget/CheckBox;

.field private final host:Landroid/widget/EditText;

.field private final login:Landroid/widget/EditText;

.field private final password:Landroid/widget/EditText;

.field private final port:Landroid/widget/EditText;

.field private final protocol:Landroid/widget/Button;

.field private final radio:Landroid/widget/CheckBox;

.field private saveFailed:Z

.field private final saved:Lru/oopssre/imperialschool/viewstv/ProxyOptions;

.field private saving:Z

.field private final scene:Lru/oopssre/imperialschool/viewstv/TvScene;

.field private final status:Landroid/widget/TextView;

.field private type:Lru/oopssre/imperialschool/viewstv/ProxyOptions$Type;


# direct methods
.method public static synthetic $r8$lambda$4FPSwix5PcjaYhDeuXz_o7z7vrY(Lru/oopssre/imperialschool/viewstv/ProxyEditor;)V
    .locals 0

    invoke-direct {p0}, Lru/oopssre/imperialschool/viewstv/ProxyEditor;->save()V

    return-void
.end method

.method public static synthetic $r8$lambda$xbiT3krZ3klG7J8wZhm881obBR4(Lru/oopssre/imperialschool/viewstv/ProxyEditor;)V
    .locals 0

    invoke-direct {p0}, Lru/oopssre/imperialschool/viewstv/ProxyEditor;->chooseType()V

    return-void
.end method

.method static constructor <clinit>()V
    .locals 1

    .line 19
    invoke-static {}, Ljava/util/concurrent/Executors;->newSingleThreadExecutor()Ljava/util/concurrent/ExecutorService;

    move-result-object v0

    sput-object v0, Lru/oopssre/imperialschool/viewstv/ProxyEditor;->SAVES:Ljava/util/concurrent/Executor;

    return-void
.end method

.method constructor <init>(Lru/oopssre/imperialschool/viewstv/TvScene;)V
    .locals 10

    .line 31
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 32
    iput-object p1, p0, Lru/oopssre/imperialschool/viewstv/ProxyEditor;->scene:Lru/oopssre/imperialschool/viewstv/TvScene;

    .line 33
    iget-object v0, p1, Lru/oopssre/imperialschool/viewstv/TvScene;->repo:Lru/oopssre/imperialschool/viewstv/Repository;

    iget-object v0, v0, Lru/oopssre/imperialschool/viewstv/Repository;->proxy:Lru/oopssre/imperialschool/viewstv/ProxyPreferences;

    invoke-virtual {v0}, Lru/oopssre/imperialschool/viewstv/ProxyPreferences;->current()Lru/oopssre/imperialschool/viewstv/ProxyOptions;

    move-result-object v0

    iput-object v0, p0, Lru/oopssre/imperialschool/viewstv/ProxyEditor;->saved:Lru/oopssre/imperialschool/viewstv/ProxyOptions;

    .line 34
    iget-object v1, v0, Lru/oopssre/imperialschool/viewstv/ProxyOptions;->type:Lru/oopssre/imperialschool/viewstv/ProxyOptions$Type;

    iput-object v1, p0, Lru/oopssre/imperialschool/viewstv/ProxyEditor;->type:Lru/oopssre/imperialschool/viewstv/ProxyOptions$Type;

    .line 36
    const-string v1, "proxy"

    const-string v2, "\u041f\u0440\u043e\u043a\u0441\u0438"

    invoke-virtual {p1, v1, v2}, Lru/oopssre/imperialschool/viewstv/TvScene;->beginPage(Ljava/lang/String;Ljava/lang/String;)V

    .line 37
    const-string v1, "\u0420\u0430\u0434\u0438\u043e"

    iget-boolean v2, v0, Lru/oopssre/imperialschool/viewstv/ProxyOptions;->radio:Z

    const-string v3, "proxy_radio"

    invoke-direct {p0, v3, v1, v2}, Lru/oopssre/imperialschool/viewstv/ProxyEditor;->checkbox(Ljava/lang/String;Ljava/lang/String;Z)Landroid/widget/CheckBox;

    move-result-object v1

    iput-object v1, p0, Lru/oopssre/imperialschool/viewstv/ProxyEditor;->radio:Landroid/widget/CheckBox;

    .line 38
    const-string v1, "\u0414\u0440\u0443\u0433\u0438\u0435 \u0432\u043d\u0435\u0448\u043d\u0438\u0435 \u043f\u043e\u0434\u043a\u043b\u044e\u0447\u0435\u043d\u0438\u044f"

    iget-boolean v2, v0, Lru/oopssre/imperialschool/viewstv/ProxyOptions;->external:Z

    const-string v4, "proxy_external"

    invoke-direct {p0, v4, v1, v2}, Lru/oopssre/imperialschool/viewstv/ProxyEditor;->checkbox(Ljava/lang/String;Ljava/lang/String;Z)Landroid/widget/CheckBox;

    move-result-object v1

    iput-object v1, p0, Lru/oopssre/imperialschool/viewstv/ProxyEditor;->external:Landroid/widget/CheckBox;

    .line 39
    const-string v1, "\u0421\u0430\u0439\u0442 \u043f\u0440\u043e\u0435\u043a\u0442\u0430, \u043e\u0431\u043e\u0438, \u043c\u0443\u0437\u044b\u043a\u0430 \u0442\u0435\u043c\u044b \u0438 \u043e\u0431\u043d\u043e\u0432\u043b\u0435\u043d\u0438\u044f \u0438\u0441\u043f\u043e\u043b\u044c\u0437\u0443\u044e\u0442 \u043e\u0431\u044b\u0447\u043d\u043e\u0435 \u043f\u043e\u0434\u043a\u043b\u044e\u0447\u0435\u043d\u0438\u0435."

    invoke-virtual {p1, v1}, Lru/oopssre/imperialschool/viewstv/TvScene;->message(Ljava/lang/String;)V

    .line 40
    invoke-direct {p0}, Lru/oopssre/imperialschool/viewstv/ProxyEditor;->typeLabel()Ljava/lang/String;

    move-result-object v1

    new-instance v2, Lru/oopssre/imperialschool/viewstv/ProxyEditor$$ExternalSyntheticLambda0;

    invoke-direct {v2, p0}, Lru/oopssre/imperialschool/viewstv/ProxyEditor$$ExternalSyntheticLambda0;-><init>(Lru/oopssre/imperialschool/viewstv/ProxyEditor;)V

    const-string v4, "proxy_type"

    invoke-virtual {p1, v4, v1, v2}, Lru/oopssre/imperialschool/viewstv/TvScene;->button(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Runnable;)Landroid/widget/Button;

    move-result-object v1

    iput-object v1, p0, Lru/oopssre/imperialschool/viewstv/ProxyEditor;->protocol:Landroid/widget/Button;

    .line 41
    iget-object v1, v0, Lru/oopssre/imperialschool/viewstv/ProxyOptions;->host:Ljava/lang/String;

    const-string v2, "\u0410\u0434\u0440\u0435\u0441"

    const/16 v4, 0x11

    invoke-direct {p0, v2, v1, v4}, Lru/oopssre/imperialschool/viewstv/ProxyEditor;->field(Ljava/lang/String;Ljava/lang/String;I)Landroid/widget/EditText;

    move-result-object v1

    iput-object v1, p0, Lru/oopssre/imperialschool/viewstv/ProxyEditor;->host:Landroid/widget/EditText;

    .line 42
    iget v2, v0, Lru/oopssre/imperialschool/viewstv/ProxyOptions;->port:I

    const-string v5, ""

    if-nez v2, :cond_0

    move-object v2, v5

    goto :goto_0

    :cond_0
    iget v2, v0, Lru/oopssre/imperialschool/viewstv/ProxyOptions;->port:I

    invoke-static {v2}, Ljava/lang/String;->valueOf(I)Ljava/lang/String;

    move-result-object v2

    :goto_0
    const-string v6, "\u041f\u043e\u0440\u0442"

    const/4 v7, 0x2

    invoke-direct {p0, v6, v2, v7}, Lru/oopssre/imperialschool/viewstv/ProxyEditor;->field(Ljava/lang/String;Ljava/lang/String;I)Landroid/widget/EditText;

    move-result-object v2

    iput-object v2, p0, Lru/oopssre/imperialschool/viewstv/ProxyEditor;->port:Landroid/widget/EditText;

    .line 43
    iget-object v6, v0, Lru/oopssre/imperialschool/viewstv/ProxyOptions;->login:Ljava/lang/String;

    const v8, 0x80001

    const-string v9, "\u041b\u043e\u0433\u0438\u043d"

    invoke-direct {p0, v9, v6, v8}, Lru/oopssre/imperialschool/viewstv/ProxyEditor;->field(Ljava/lang/String;Ljava/lang/String;I)Landroid/widget/EditText;

    move-result-object v6

    iput-object v6, p0, Lru/oopssre/imperialschool/viewstv/ProxyEditor;->login:Landroid/widget/EditText;

    .line 44
    iget-object v0, v0, Lru/oopssre/imperialschool/viewstv/ProxyOptions;->password:Ljava/lang/String;

    const/16 v8, 0x81

    const-string v9, "\u041f\u0430\u0440\u043e\u043b\u044c"

    invoke-direct {p0, v9, v0, v8}, Lru/oopssre/imperialschool/viewstv/ProxyEditor;->field(Ljava/lang/String;Ljava/lang/String;I)Landroid/widget/EditText;

    move-result-object v0

    iput-object v0, p0, Lru/oopssre/imperialschool/viewstv/ProxyEditor;->password:Landroid/widget/EditText;

    const/4 v8, 0x0

    .line 45
    invoke-virtual {v0, v8}, Landroid/widget/EditText;->setSaveEnabled(Z)V

    .line 47
    invoke-virtual {p1, v5, v4}, Lru/oopssre/imperialschool/viewstv/TvScene;->text(Ljava/lang/String;I)Landroid/widget/TextView;

    move-result-object v4

    iput-object v4, p0, Lru/oopssre/imperialschool/viewstv/ProxyEditor;->status:Landroid/widget/TextView;

    const/16 v5, 0xc

    .line 48
    invoke-virtual {p1, v5}, Lru/oopssre/imperialschool/viewstv/TvScene;->dp(I)I

    move-result v9

    invoke-virtual {p1, v5}, Lru/oopssre/imperialschool/viewstv/TvScene;->dp(I)I

    move-result v5

    invoke-virtual {v4, v8, v9, v8, v5}, Landroid/widget/TextView;->setPadding(IIII)V

    .line 49
    iget-object v5, p1, Lru/oopssre/imperialschool/viewstv/TvScene;->content:Landroid/widget/LinearLayout;

    invoke-virtual {v5, v4}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    .line 50
    new-instance v4, Lru/oopssre/imperialschool/viewstv/ProxyEditor$$ExternalSyntheticLambda1;

    invoke-direct {v4, p0}, Lru/oopssre/imperialschool/viewstv/ProxyEditor$$ExternalSyntheticLambda1;-><init>(Lru/oopssre/imperialschool/viewstv/ProxyEditor;)V

    const-string v5, "proxy_apply"

    const-string v9, "\u041f\u0440\u0438\u043c\u0435\u043d\u0438\u0442\u044c"

    invoke-virtual {p1, v5, v9, v4}, Lru/oopssre/imperialschool/viewstv/TvScene;->button(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Runnable;)Landroid/widget/Button;

    move-result-object v4

    iput-object v4, p0, Lru/oopssre/imperialschool/viewstv/ProxyEditor;->apply:Landroid/widget/Button;

    .line 51
    new-instance v4, Lru/oopssre/imperialschool/viewstv/ProxyEditor$1;

    invoke-direct {v4, p0}, Lru/oopssre/imperialschool/viewstv/ProxyEditor$1;-><init>(Lru/oopssre/imperialschool/viewstv/ProxyEditor;)V

    const/4 v5, 0x4

    .line 56
    new-array v9, v5, [Landroid/widget/EditText;

    aput-object v1, v9, v8

    const/4 v1, 0x1

    aput-object v2, v9, v1

    aput-object v6, v9, v7

    const/4 v1, 0x3

    aput-object v0, v9, v1

    :goto_1
    if-ge v8, v5, :cond_1

    aget-object v0, v9, v8

    invoke-virtual {v0, v4}, Landroid/widget/EditText;->addTextChangedListener(Landroid/text/TextWatcher;)V

    add-int/lit8 v8, v8, 0x1

    goto :goto_1

    .line 57
    :cond_1
    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/ProxyEditor;->radio:Landroid/widget/CheckBox;

    new-instance v1, Lru/oopssre/imperialschool/viewstv/ProxyEditor$$ExternalSyntheticLambda2;

    invoke-direct {v1, p0}, Lru/oopssre/imperialschool/viewstv/ProxyEditor$$ExternalSyntheticLambda2;-><init>(Lru/oopssre/imperialschool/viewstv/ProxyEditor;)V

    invoke-virtual {v0, v1}, Landroid/widget/CheckBox;->setOnCheckedChangeListener(Landroid/widget/CompoundButton$OnCheckedChangeListener;)V

    .line 58
    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/ProxyEditor;->external:Landroid/widget/CheckBox;

    new-instance v1, Lru/oopssre/imperialschool/viewstv/ProxyEditor$$ExternalSyntheticLambda3;

    invoke-direct {v1, p0}, Lru/oopssre/imperialschool/viewstv/ProxyEditor$$ExternalSyntheticLambda3;-><init>(Lru/oopssre/imperialschool/viewstv/ProxyEditor;)V

    invoke-virtual {v0, v1}, Landroid/widget/CheckBox;->setOnCheckedChangeListener(Landroid/widget/CompoundButton$OnCheckedChangeListener;)V

    .line 59
    invoke-direct {p0}, Lru/oopssre/imperialschool/viewstv/ProxyEditor;->update()V

    .line 60
    invoke-virtual {p1, v3}, Lru/oopssre/imperialschool/viewstv/TvScene;->focusFirst(Ljava/lang/String;)V

    return-void
.end method

.method static synthetic access$000(Lru/oopssre/imperialschool/viewstv/ProxyEditor;)V
    .locals 0

    .line 18
    invoke-direct {p0}, Lru/oopssre/imperialschool/viewstv/ProxyEditor;->update()V

    return-void
.end method

.method private checkbox(Ljava/lang/String;Ljava/lang/String;Z)Landroid/widget/CheckBox;
    .locals 2

    .line 64
    new-instance v0, Landroid/widget/CheckBox;

    iget-object v1, p0, Lru/oopssre/imperialschool/viewstv/ProxyEditor;->scene:Lru/oopssre/imperialschool/viewstv/TvScene;

    iget-object v1, v1, Lru/oopssre/imperialschool/viewstv/TvScene;->context:Landroid/content/Context;

    invoke-direct {v0, v1}, Landroid/widget/CheckBox;-><init>(Landroid/content/Context;)V

    .line 65
    invoke-virtual {v0, p2}, Landroid/widget/CheckBox;->setText(Ljava/lang/CharSequence;)V

    const/high16 p2, 0x41a00000    # 20.0f

    .line 66
    invoke-virtual {v0, p2}, Landroid/widget/CheckBox;->setTextSize(F)V

    const p2, -0xc1325

    .line 67
    invoke-virtual {v0, p2}, Landroid/widget/CheckBox;->setTextColor(I)V

    .line 68
    invoke-virtual {v0, p3}, Landroid/widget/CheckBox;->setChecked(Z)V

    .line 69
    invoke-virtual {v0, p1}, Landroid/widget/CheckBox;->setTag(Ljava/lang/Object;)V

    .line 70
    iget-object p1, p0, Lru/oopssre/imperialschool/viewstv/ProxyEditor;->scene:Lru/oopssre/imperialschool/viewstv/TvScene;

    iget-object p1, p1, Lru/oopssre/imperialschool/viewstv/TvScene;->content:Landroid/widget/LinearLayout;

    iget-object p2, p0, Lru/oopssre/imperialschool/viewstv/ProxyEditor;->scene:Lru/oopssre/imperialschool/viewstv/TvScene;

    invoke-virtual {p2}, Lru/oopssre/imperialschool/viewstv/TvScene;->buttonLayout()Landroid/widget/LinearLayout$LayoutParams;

    move-result-object p2

    invoke-virtual {p1, v0, p2}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    return-object v0
.end method

.method private chooseType()V
    .locals 5

    .line 92
    invoke-static {}, Lru/oopssre/imperialschool/viewstv/ProxyOptions$Type;->values()[Lru/oopssre/imperialschool/viewstv/ProxyOptions$Type;

    move-result-object v0

    .line 93
    new-instance v1, Landroid/app/AlertDialog$Builder;

    iget-object v2, p0, Lru/oopssre/imperialschool/viewstv/ProxyEditor;->scene:Lru/oopssre/imperialschool/viewstv/TvScene;

    iget-object v2, v2, Lru/oopssre/imperialschool/viewstv/TvScene;->context:Landroid/content/Context;

    invoke-direct {v1, v2}, Landroid/app/AlertDialog$Builder;-><init>(Landroid/content/Context;)V

    const-string v2, "\u0422\u0438\u043f \u043f\u0440\u043e\u043a\u0441\u0438"

    invoke-virtual {v1, v2}, Landroid/app/AlertDialog$Builder;->setTitle(Ljava/lang/CharSequence;)Landroid/app/AlertDialog$Builder;

    move-result-object v1

    const/4 v2, 0x2

    new-array v2, v2, [Ljava/lang/String;

    const/4 v3, 0x0

    const-string v4, "SOCKS5"

    aput-object v4, v2, v3

    const/4 v3, 0x1

    const-string v4, "HTTP"

    aput-object v4, v2, v3

    iget-object v3, p0, Lru/oopssre/imperialschool/viewstv/ProxyEditor;->type:Lru/oopssre/imperialschool/viewstv/ProxyOptions$Type;

    .line 94
    invoke-virtual {v3}, Lru/oopssre/imperialschool/viewstv/ProxyOptions$Type;->ordinal()I

    move-result v3

    new-instance v4, Lru/oopssre/imperialschool/viewstv/ProxyEditor$$ExternalSyntheticLambda5;

    invoke-direct {v4, p0, v0}, Lru/oopssre/imperialschool/viewstv/ProxyEditor$$ExternalSyntheticLambda5;-><init>(Lru/oopssre/imperialschool/viewstv/ProxyEditor;[Lru/oopssre/imperialschool/viewstv/ProxyOptions$Type;)V

    invoke-virtual {v1, v2, v3, v4}, Landroid/app/AlertDialog$Builder;->setSingleChoiceItems([Ljava/lang/CharSequence;ILandroid/content/DialogInterface$OnClickListener;)Landroid/app/AlertDialog$Builder;

    move-result-object v0

    const-string v1, "\u041e\u0442\u043c\u0435\u043d\u0430"

    const/4 v2, 0x0

    .line 99
    invoke-virtual {v0, v1, v2}, Landroid/app/AlertDialog$Builder;->setNegativeButton(Ljava/lang/CharSequence;Landroid/content/DialogInterface$OnClickListener;)Landroid/app/AlertDialog$Builder;

    move-result-object v0

    invoke-virtual {v0}, Landroid/app/AlertDialog$Builder;->show()Landroid/app/AlertDialog;

    return-void
.end method

.method private field(Ljava/lang/String;Ljava/lang/String;I)Landroid/widget/EditText;
    .locals 2

    .line 75
    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/ProxyEditor;->scene:Lru/oopssre/imperialschool/viewstv/TvScene;

    const/16 v1, 0x11

    invoke-virtual {v0, p1, v1}, Lru/oopssre/imperialschool/viewstv/TvScene;->text(Ljava/lang/String;I)Landroid/widget/TextView;

    move-result-object p1

    .line 76
    new-instance v0, Landroid/widget/EditText;

    iget-object v1, p0, Lru/oopssre/imperialschool/viewstv/ProxyEditor;->scene:Lru/oopssre/imperialschool/viewstv/TvScene;

    iget-object v1, v1, Lru/oopssre/imperialschool/viewstv/TvScene;->context:Landroid/content/Context;

    invoke-direct {v0, v1}, Landroid/widget/EditText;-><init>(Landroid/content/Context;)V

    .line 77
    invoke-static {}, Landroid/view/View;->generateViewId()I

    move-result v1

    invoke-virtual {v0, v1}, Landroid/widget/EditText;->setId(I)V

    .line 78
    invoke-virtual {v0}, Landroid/widget/EditText;->getId()I

    move-result v1

    invoke-virtual {p1, v1}, Landroid/widget/TextView;->setLabelFor(I)V

    const v1, -0xc1325

    .line 79
    invoke-virtual {v0, v1}, Landroid/widget/EditText;->setTextColor(I)V

    const/4 v1, 0x1

    .line 80
    invoke-virtual {v0, v1}, Landroid/widget/EditText;->setSingleLine(Z)V

    .line 81
    invoke-virtual {v0, p3}, Landroid/widget/EditText;->setInputType(I)V

    const/high16 p3, 0x1000000

    .line 82
    invoke-virtual {v0, p3}, Landroid/widget/EditText;->setImeOptions(I)V

    .line 83
    invoke-virtual {v0, p2}, Landroid/widget/EditText;->setText(Ljava/lang/CharSequence;)V

    .line 84
    iget-object p2, p0, Lru/oopssre/imperialschool/viewstv/ProxyEditor;->scene:Lru/oopssre/imperialschool/viewstv/TvScene;

    iget-object p2, p2, Lru/oopssre/imperialschool/viewstv/TvScene;->content:Landroid/widget/LinearLayout;

    invoke-virtual {p2, p1}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    .line 85
    iget-object p1, p0, Lru/oopssre/imperialschool/viewstv/ProxyEditor;->scene:Lru/oopssre/imperialschool/viewstv/TvScene;

    iget-object p1, p1, Lru/oopssre/imperialschool/viewstv/TvScene;->content:Landroid/widget/LinearLayout;

    iget-object p2, p0, Lru/oopssre/imperialschool/viewstv/ProxyEditor;->scene:Lru/oopssre/imperialschool/viewstv/TvScene;

    invoke-virtual {p2}, Lru/oopssre/imperialschool/viewstv/TvScene;->buttonLayout()Landroid/widget/LinearLayout$LayoutParams;

    move-result-object p2

    invoke-virtual {p1, v0, p2}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    return-object v0
.end method

.method private options()Lru/oopssre/imperialschool/viewstv/ProxyOptions;
    .locals 9

    .line 104
    :try_start_0
    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/ProxyEditor;->port:Landroid/widget/EditText;

    invoke-virtual {v0}, Landroid/widget/EditText;->getText()Landroid/text/Editable;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/Object;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-static {v0}, Ljava/lang/Integer;->parseInt(Ljava/lang/String;)I

    move-result v0
    :try_end_0
    .catch Ljava/lang/NumberFormatException; {:try_start_0 .. :try_end_0} :catch_0

    goto :goto_0

    .line 105
    :catch_0
    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/ProxyEditor;->port:Landroid/widget/EditText;

    invoke-virtual {v0}, Landroid/widget/EditText;->length()I

    move-result v0

    if-nez v0, :cond_0

    const/4 v0, 0x0

    goto :goto_0

    :cond_0
    const/4 v0, -0x1

    :goto_0
    move v4, v0

    .line 106
    new-instance v1, Lru/oopssre/imperialschool/viewstv/ProxyOptions;

    iget-object v2, p0, Lru/oopssre/imperialschool/viewstv/ProxyEditor;->type:Lru/oopssre/imperialschool/viewstv/ProxyOptions$Type;

    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/ProxyEditor;->host:Landroid/widget/EditText;

    invoke-virtual {v0}, Landroid/widget/EditText;->getText()Landroid/text/Editable;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/Object;->toString()Ljava/lang/String;

    move-result-object v3

    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/ProxyEditor;->login:Landroid/widget/EditText;

    invoke-virtual {v0}, Landroid/widget/EditText;->getText()Landroid/text/Editable;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/Object;->toString()Ljava/lang/String;

    move-result-object v5

    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/ProxyEditor;->password:Landroid/widget/EditText;

    .line 107
    invoke-virtual {v0}, Landroid/widget/EditText;->getText()Landroid/text/Editable;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/Object;->toString()Ljava/lang/String;

    move-result-object v6

    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/ProxyEditor;->radio:Landroid/widget/CheckBox;

    invoke-virtual {v0}, Landroid/widget/CheckBox;->isChecked()Z

    move-result v7

    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/ProxyEditor;->external:Landroid/widget/CheckBox;

    invoke-virtual {v0}, Landroid/widget/CheckBox;->isChecked()Z

    move-result v8

    invoke-direct/range {v1 .. v8}, Lru/oopssre/imperialschool/viewstv/ProxyOptions;-><init>(Lru/oopssre/imperialschool/viewstv/ProxyOptions$Type;Ljava/lang/String;ILjava/lang/String;Ljava/lang/String;ZZ)V

    return-object v1
.end method

.method private save()V
    .locals 3

    .line 127
    invoke-direct {p0}, Lru/oopssre/imperialschool/viewstv/ProxyEditor;->options()Lru/oopssre/imperialschool/viewstv/ProxyOptions;

    move-result-object v0

    .line 128
    iget-boolean v1, p0, Lru/oopssre/imperialschool/viewstv/ProxyEditor;->saving:Z

    if-nez v1, :cond_1

    iget-object v1, p0, Lru/oopssre/imperialschool/viewstv/ProxyEditor;->saved:Lru/oopssre/imperialschool/viewstv/ProxyOptions;

    invoke-virtual {v0, v1}, Lru/oopssre/imperialschool/viewstv/ProxyOptions;->sameSettings(Lru/oopssre/imperialschool/viewstv/ProxyOptions;)Z

    move-result v1

    if-nez v1, :cond_1

    invoke-virtual {v0}, Lru/oopssre/imperialschool/viewstv/ProxyOptions;->error()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v1}, Ljava/lang/String;->isEmpty()Z

    move-result v1

    if-nez v1, :cond_0

    goto :goto_0

    :cond_0
    const/4 v1, 0x1

    .line 129
    iput-boolean v1, p0, Lru/oopssre/imperialschool/viewstv/ProxyEditor;->saving:Z

    const/4 v1, 0x0

    .line 130
    iput-boolean v1, p0, Lru/oopssre/imperialschool/viewstv/ProxyEditor;->saveFailed:Z

    .line 131
    invoke-direct {p0, v1}, Lru/oopssre/imperialschool/viewstv/ProxyEditor;->setFieldsEnabled(Z)V

    .line 132
    invoke-direct {p0}, Lru/oopssre/imperialschool/viewstv/ProxyEditor;->update()V

    .line 133
    sget-object v1, Lru/oopssre/imperialschool/viewstv/ProxyEditor;->SAVES:Ljava/util/concurrent/Executor;

    new-instance v2, Lru/oopssre/imperialschool/viewstv/ProxyEditor$$ExternalSyntheticLambda4;

    invoke-direct {v2, p0, v0}, Lru/oopssre/imperialschool/viewstv/ProxyEditor$$ExternalSyntheticLambda4;-><init>(Lru/oopssre/imperialschool/viewstv/ProxyEditor;Lru/oopssre/imperialschool/viewstv/ProxyOptions;)V

    invoke-interface {v1, v2}, Ljava/util/concurrent/Executor;->execute(Ljava/lang/Runnable;)V

    :cond_1
    :goto_0
    return-void
.end method

.method private setFieldsEnabled(Z)V
    .locals 5

    const/4 v0, 0x7

    .line 123
    new-array v1, v0, [Landroid/view/View;

    iget-object v2, p0, Lru/oopssre/imperialschool/viewstv/ProxyEditor;->radio:Landroid/widget/CheckBox;

    const/4 v3, 0x0

    aput-object v2, v1, v3

    const/4 v2, 0x1

    iget-object v4, p0, Lru/oopssre/imperialschool/viewstv/ProxyEditor;->external:Landroid/widget/CheckBox;

    aput-object v4, v1, v2

    const/4 v2, 0x2

    iget-object v4, p0, Lru/oopssre/imperialschool/viewstv/ProxyEditor;->protocol:Landroid/widget/Button;

    aput-object v4, v1, v2

    const/4 v2, 0x3

    iget-object v4, p0, Lru/oopssre/imperialschool/viewstv/ProxyEditor;->host:Landroid/widget/EditText;

    aput-object v4, v1, v2

    const/4 v2, 0x4

    iget-object v4, p0, Lru/oopssre/imperialschool/viewstv/ProxyEditor;->port:Landroid/widget/EditText;

    aput-object v4, v1, v2

    const/4 v2, 0x5

    iget-object v4, p0, Lru/oopssre/imperialschool/viewstv/ProxyEditor;->login:Landroid/widget/EditText;

    aput-object v4, v1, v2

    const/4 v2, 0x6

    iget-object v4, p0, Lru/oopssre/imperialschool/viewstv/ProxyEditor;->password:Landroid/widget/EditText;

    aput-object v4, v1, v2

    :goto_0
    if-ge v3, v0, :cond_0

    aget-object v2, v1, v3

    invoke-virtual {v2, p1}, Landroid/view/View;->setEnabled(Z)V

    add-int/lit8 v3, v3, 0x1

    goto :goto_0

    :cond_0
    return-void
.end method

.method private typeLabel()Ljava/lang/String;
    .locals 2

    .line 89
    new-instance v0, Ljava/lang/StringBuilder;

    const-string v1, "\u0422\u0438\u043f \u043f\u0440\u043e\u043a\u0441\u0438 \u00b7 "

    invoke-direct {v0, v1}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    iget-object v1, p0, Lru/oopssre/imperialschool/viewstv/ProxyEditor;->type:Lru/oopssre/imperialschool/viewstv/ProxyOptions$Type;

    invoke-virtual {v1}, Lru/oopssre/imperialschool/viewstv/ProxyOptions$Type;->name()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    return-object v0
.end method

.method private update()V
    .locals 5

    .line 111
    invoke-direct {p0}, Lru/oopssre/imperialschool/viewstv/ProxyEditor;->options()Lru/oopssre/imperialschool/viewstv/ProxyOptions;

    move-result-object v0

    .line 112
    invoke-virtual {v0}, Lru/oopssre/imperialschool/viewstv/ProxyOptions;->error()Ljava/lang/String;

    move-result-object v1

    .line 113
    iget-object v2, p0, Lru/oopssre/imperialschool/viewstv/ProxyEditor;->saved:Lru/oopssre/imperialschool/viewstv/ProxyOptions;

    invoke-virtual {v0, v2}, Lru/oopssre/imperialschool/viewstv/ProxyOptions;->sameSettings(Lru/oopssre/imperialschool/viewstv/ProxyOptions;)Z

    move-result v2

    .line 114
    iget-object v3, p0, Lru/oopssre/imperialschool/viewstv/ProxyEditor;->status:Landroid/widget/TextView;

    iget-boolean v4, p0, Lru/oopssre/imperialschool/viewstv/ProxyEditor;->saving:Z

    if-eqz v4, :cond_0

    const-string v0, "\u0421\u043e\u0445\u0440\u0430\u043d\u044f\u044e \u043d\u0430\u0441\u0442\u0440\u043e\u0439\u043a\u0438\u2026"

    goto :goto_0

    :cond_0
    if-nez v2, :cond_1

    .line 115
    invoke-virtual {v1}, Ljava/lang/String;->isEmpty()Z

    move-result v4

    if-nez v4, :cond_1

    move-object v0, v1

    goto :goto_0

    .line 116
    :cond_1
    iget-object v4, p0, Lru/oopssre/imperialschool/viewstv/ProxyEditor;->scene:Lru/oopssre/imperialschool/viewstv/TvScene;

    iget-object v4, v4, Lru/oopssre/imperialschool/viewstv/TvScene;->repo:Lru/oopssre/imperialschool/viewstv/Repository;

    iget-object v4, v4, Lru/oopssre/imperialschool/viewstv/Repository;->proxy:Lru/oopssre/imperialschool/viewstv/ProxyPreferences;

    invoke-virtual {v4}, Lru/oopssre/imperialschool/viewstv/ProxyPreferences;->unreadablePassword()Z

    move-result v4

    if-eqz v4, :cond_2

    iget-object v4, v0, Lru/oopssre/imperialschool/viewstv/ProxyOptions;->password:Ljava/lang/String;

    invoke-virtual {v4}, Ljava/lang/String;->isEmpty()Z

    move-result v4

    if-eqz v4, :cond_2

    const-string v0, "\u0412\u0432\u0435\u0434\u0438\u0442\u0435 \u043f\u0430\u0440\u043e\u043b\u044c \u0435\u0449\u0451 \u0440\u0430\u0437."

    goto :goto_0

    .line 117
    :cond_2
    iget-boolean v4, p0, Lru/oopssre/imperialschool/viewstv/ProxyEditor;->saveFailed:Z

    if-eqz v4, :cond_3

    const-string v0, "\u041d\u0435 \u0443\u0434\u0430\u043b\u043e\u0441\u044c \u0441\u043e\u0445\u0440\u0430\u043d\u0438\u0442\u044c \u043d\u0430\u0441\u0442\u0440\u043e\u0439\u043a\u0438 \u043f\u0440\u043e\u043a\u0441\u0438. \u041f\u043e\u0432\u0442\u043e\u0440\u0438\u0442\u0435 \u043f\u043e\u043f\u044b\u0442\u043a\u0443."

    goto :goto_0

    .line 118
    :cond_3
    invoke-virtual {v0}, Lru/oopssre/imperialschool/viewstv/ProxyOptions;->enabled()Z

    move-result v0

    if-eqz v0, :cond_4

    const-string v0, "\u0412\u043a\u043b\u044e\u0447\u0435\u043d\u043e \u0434\u043b\u044f \u0432\u044b\u0431\u0440\u0430\u043d\u043d\u044b\u0445 \u043f\u043e\u0434\u043a\u043b\u044e\u0447\u0435\u043d\u0438\u0439"

    goto :goto_0

    :cond_4
    const-string v0, "\u041f\u0440\u043e\u043a\u0441\u0438 \u0432\u044b\u043a\u043b\u044e\u0447\u0435\u043d"

    .line 114
    :goto_0
    invoke-virtual {v3, v0}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    .line 119
    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/ProxyEditor;->apply:Landroid/widget/Button;

    iget-boolean v3, p0, Lru/oopssre/imperialschool/viewstv/ProxyEditor;->saving:Z

    if-nez v3, :cond_5

    if-nez v2, :cond_5

    invoke-virtual {v1}, Ljava/lang/String;->isEmpty()Z

    move-result v1

    if-eqz v1, :cond_5

    const/4 v1, 0x1

    goto :goto_1

    :cond_5
    const/4 v1, 0x0

    :goto_1
    invoke-virtual {v0, v1}, Landroid/widget/Button;->setEnabled(Z)V

    return-void
.end method


# virtual methods
.method synthetic lambda$chooseType$2$ru-oopssre-imperialschool-viewstv-ProxyEditor([Lru/oopssre/imperialschool/viewstv/ProxyOptions$Type;Landroid/content/DialogInterface;I)V
    .locals 0

    .line 95
    aget-object p1, p1, p3

    iput-object p1, p0, Lru/oopssre/imperialschool/viewstv/ProxyEditor;->type:Lru/oopssre/imperialschool/viewstv/ProxyOptions$Type;

    .line 96
    iget-object p1, p0, Lru/oopssre/imperialschool/viewstv/ProxyEditor;->protocol:Landroid/widget/Button;

    invoke-direct {p0}, Lru/oopssre/imperialschool/viewstv/ProxyEditor;->typeLabel()Ljava/lang/String;

    move-result-object p3

    invoke-virtual {p1, p3}, Landroid/widget/Button;->setText(Ljava/lang/CharSequence;)V

    .line 97
    invoke-interface {p2}, Landroid/content/DialogInterface;->dismiss()V

    .line 98
    invoke-direct {p0}, Lru/oopssre/imperialschool/viewstv/ProxyEditor;->update()V

    return-void
.end method

.method synthetic lambda$new$0$ru-oopssre-imperialschool-viewstv-ProxyEditor(Landroid/widget/CompoundButton;Z)V
    .locals 0

    .line 57
    invoke-direct {p0}, Lru/oopssre/imperialschool/viewstv/ProxyEditor;->update()V

    return-void
.end method

.method synthetic lambda$new$1$ru-oopssre-imperialschool-viewstv-ProxyEditor(Landroid/widget/CompoundButton;Z)V
    .locals 0

    .line 58
    invoke-direct {p0}, Lru/oopssre/imperialschool/viewstv/ProxyEditor;->update()V

    return-void
.end method

.method synthetic lambda$save$3$ru-oopssre-imperialschool-viewstv-ProxyEditor(ZLru/oopssre/imperialschool/viewstv/ProxyOptions;)V
    .locals 2

    .line 139
    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/ProxyEditor;->scene:Lru/oopssre/imperialschool/viewstv/TvScene;

    iget-boolean v0, v0, Lru/oopssre/imperialschool/viewstv/TvScene;->destroyed:Z

    if-eqz v0, :cond_0

    goto :goto_0

    :cond_0
    if-eqz p1, :cond_2

    .line 140
    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/ProxyEditor;->saved:Lru/oopssre/imperialschool/viewstv/ProxyOptions;

    iget-boolean v0, v0, Lru/oopssre/imperialschool/viewstv/ProxyOptions;->radio:Z

    iget-boolean v1, p2, Lru/oopssre/imperialschool/viewstv/ProxyOptions;->radio:Z

    if-ne v0, v1, :cond_1

    iget-boolean v0, p2, Lru/oopssre/imperialschool/viewstv/ProxyOptions;->radio:Z

    if-eqz v0, :cond_2

    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/ProxyEditor;->saved:Lru/oopssre/imperialschool/viewstv/ProxyOptions;

    invoke-virtual {p2, v0}, Lru/oopssre/imperialschool/viewstv/ProxyOptions;->sameServer(Lru/oopssre/imperialschool/viewstv/ProxyOptions;)Z

    move-result p2

    if-nez p2, :cond_2

    .line 141
    :cond_1
    iget-object p2, p0, Lru/oopssre/imperialschool/viewstv/ProxyEditor;->scene:Lru/oopssre/imperialschool/viewstv/TvScene;

    iget-object p2, p2, Lru/oopssre/imperialschool/viewstv/TvScene;->music:Lru/oopssre/imperialschool/viewstv/SceneMusic;

    invoke-virtual {p2}, Lru/oopssre/imperialschool/viewstv/SceneMusic;->proxyChanged()V

    .line 142
    :cond_2
    iget-object p2, p0, Lru/oopssre/imperialschool/viewstv/ProxyEditor;->scene:Lru/oopssre/imperialschool/viewstv/TvScene;

    iget-object p2, p2, Lru/oopssre/imperialschool/viewstv/TvScene;->page:Ljava/lang/String;

    const-string v0, "proxy"

    invoke-virtual {p2, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p2

    if-eqz p2, :cond_4

    iget-object p2, p0, Lru/oopssre/imperialschool/viewstv/ProxyEditor;->scene:Lru/oopssre/imperialschool/viewstv/TvScene;

    iget-object p2, p2, Lru/oopssre/imperialschool/viewstv/TvScene;->panel:Landroid/widget/ScrollView;

    invoke-virtual {p2}, Landroid/widget/ScrollView;->getVisibility()I

    move-result p2

    if-nez p2, :cond_4

    iget-object p2, p0, Lru/oopssre/imperialschool/viewstv/ProxyEditor;->apply:Landroid/widget/Button;

    .line 143
    invoke-virtual {p2}, Landroid/widget/Button;->getParent()Landroid/view/ViewParent;

    move-result-object p2

    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/ProxyEditor;->scene:Lru/oopssre/imperialschool/viewstv/TvScene;

    iget-object v0, v0, Lru/oopssre/imperialschool/viewstv/TvScene;->content:Landroid/widget/LinearLayout;

    if-ne p2, v0, :cond_4

    if-eqz p1, :cond_3

    .line 144
    new-instance p1, Lru/oopssre/imperialschool/viewstv/ProxyEditor;

    iget-object p2, p0, Lru/oopssre/imperialschool/viewstv/ProxyEditor;->scene:Lru/oopssre/imperialschool/viewstv/TvScene;

    invoke-direct {p1, p2}, Lru/oopssre/imperialschool/viewstv/ProxyEditor;-><init>(Lru/oopssre/imperialschool/viewstv/TvScene;)V

    return-void

    :cond_3
    const/4 p1, 0x0

    .line 146
    iput-boolean p1, p0, Lru/oopssre/imperialschool/viewstv/ProxyEditor;->saving:Z

    const/4 p1, 0x1

    .line 147
    iput-boolean p1, p0, Lru/oopssre/imperialschool/viewstv/ProxyEditor;->saveFailed:Z

    .line 148
    invoke-direct {p0, p1}, Lru/oopssre/imperialschool/viewstv/ProxyEditor;->setFieldsEnabled(Z)V

    .line 149
    invoke-direct {p0}, Lru/oopssre/imperialschool/viewstv/ProxyEditor;->update()V

    :cond_4
    :goto_0
    return-void
.end method

.method synthetic lambda$save$4$ru-oopssre-imperialschool-viewstv-ProxyEditor(Lru/oopssre/imperialschool/viewstv/ProxyOptions;)V
    .locals 3

    .line 135
    :try_start_0
    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/ProxyEditor;->scene:Lru/oopssre/imperialschool/viewstv/TvScene;

    iget-object v0, v0, Lru/oopssre/imperialschool/viewstv/TvScene;->repo:Lru/oopssre/imperialschool/viewstv/Repository;

    iget-object v0, v0, Lru/oopssre/imperialschool/viewstv/Repository;->proxy:Lru/oopssre/imperialschool/viewstv/ProxyPreferences;

    invoke-virtual {v0, p1}, Lru/oopssre/imperialschool/viewstv/ProxyPreferences;->save(Lru/oopssre/imperialschool/viewstv/ProxyOptions;)V
    :try_end_0
    .catch Ljava/io/IOException; {:try_start_0 .. :try_end_0} :catch_0
    .catch Ljava/security/GeneralSecurityException; {:try_start_0 .. :try_end_0} :catch_0
    .catch Ljava/lang/RuntimeException; {:try_start_0 .. :try_end_0} :catch_0

    const/4 v0, 0x1

    goto :goto_0

    :catch_0
    const/4 v0, 0x0

    .line 138
    :goto_0
    iget-object v1, p0, Lru/oopssre/imperialschool/viewstv/ProxyEditor;->scene:Lru/oopssre/imperialschool/viewstv/TvScene;

    iget-object v1, v1, Lru/oopssre/imperialschool/viewstv/TvScene;->handler:Landroid/os/Handler;

    new-instance v2, Lru/oopssre/imperialschool/viewstv/ProxyEditor$$ExternalSyntheticLambda6;

    invoke-direct {v2, p0, v0, p1}, Lru/oopssre/imperialschool/viewstv/ProxyEditor$$ExternalSyntheticLambda6;-><init>(Lru/oopssre/imperialschool/viewstv/ProxyEditor;ZLru/oopssre/imperialschool/viewstv/ProxyOptions;)V

    invoke-virtual {v1, v2}, Landroid/os/Handler;->post(Ljava/lang/Runnable;)Z

    return-void
.end method
