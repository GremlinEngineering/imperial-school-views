.class public final Lru/oopssre/imperialschool/viewstv/ThemeText;
.super Ljava/lang/Object;
.source "ThemeText.java"


# direct methods
.method private constructor <init>()V
    .locals 0

    .line 4
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method public static description(Lru/oopssre/imperialschool/viewstv/Protocol$Theme;)Ljava/lang/String;
    .locals 4

    .line 16
    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/Protocol$Theme;->descriptor:Lorg/json/JSONObject;

    const-string v1, "description"

    const-string v2, ""

    invoke-virtual {v0, v1, v2}, Lorg/json/JSONObject;->optString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/String;->trim()Ljava/lang/String;

    move-result-object v0

    .line 17
    invoke-virtual {v0}, Ljava/lang/String;->isEmpty()Z

    move-result v1

    if-nez v1, :cond_3

    .line 18
    const-string p0, ". "

    invoke-virtual {v0, p0}, Ljava/lang/String;->indexOf(Ljava/lang/String;)I

    move-result p0

    const/4 v1, 0x0

    const/16 v2, 0xdc

    if-ltz p0, :cond_0

    if-ge p0, v2, :cond_0

    add-int/lit8 p0, p0, 0x1

    .line 19
    invoke-virtual {v0, v1, p0}, Ljava/lang/String;->substring(II)Ljava/lang/String;

    move-result-object p0

    return-object p0

    .line 20
    :cond_0
    invoke-virtual {v0}, Ljava/lang/String;->length()I

    move-result p0

    if-gt p0, v2, :cond_1

    return-object v0

    :cond_1
    const/16 p0, 0x20

    const/16 v2, 0xd2

    .line 21
    invoke-virtual {v0, p0, v2}, Ljava/lang/String;->lastIndexOf(II)I

    move-result p0

    .line 22
    new-instance v3, Ljava/lang/StringBuilder;

    invoke-direct {v3}, Ljava/lang/StringBuilder;-><init>()V

    if-lez p0, :cond_2

    move v2, p0

    :cond_2
    invoke-virtual {v0, v1, v2}, Ljava/lang/String;->substring(II)Ljava/lang/String;

    move-result-object p0

    invoke-virtual {v3, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p0

    const-string v0, "\u2026"

    invoke-virtual {p0, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p0

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    return-object p0

    .line 24
    :cond_3
    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/Protocol$Theme;->kind:Ljava/lang/String;

    const-string v1, "dynamic"

    invoke-virtual {v0, v1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_4

    const-string p0, "\u0421\u0446\u0435\u043d\u0430 \u043c\u0435\u043d\u044f\u0435\u0442\u0441\u044f \u0432\u043c\u0435\u0441\u0442\u0435 \u0441\u043e \u0432\u0440\u0435\u043c\u0435\u043d\u0435\u043c, \u043f\u043e\u0433\u043e\u0434\u043e\u0439 \u0438 \u0441\u043e\u0431\u044b\u0442\u0438\u044f\u043c\u0438 \u043c\u0438\u0440\u0430."

    return-object p0

    .line 25
    :cond_4
    iget-object p0, p0, Lru/oopssre/imperialschool/viewstv/Protocol$Theme;->kind:Ljava/lang/String;

    const-string v0, "weather"

    invoke-virtual {p0, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p0

    if-eqz p0, :cond_5

    const-string p0, "\u0412\u0440\u0435\u043c\u044f \u0441\u0443\u0442\u043e\u043a, \u0432\u0440\u0435\u043c\u0435\u043d\u0430 \u0433\u043e\u0434\u0430 \u0438 \u043f\u043e\u0433\u043e\u0434\u0430 \u043c\u0435\u043d\u044f\u044e\u0442 \u0437\u043d\u0430\u043a\u043e\u043c\u0443\u044e \u0441\u0446\u0435\u043d\u0443."

    return-object p0

    .line 26
    :cond_5
    const-string p0, "\u0418\u0437\u043e\u0431\u0440\u0430\u0436\u0435\u043d\u0438\u044f \u0441\u043c\u0435\u043d\u044f\u044e\u0442\u0441\u044f \u043f\u043e \u0440\u0430\u0441\u043f\u0438\u0441\u0430\u043d\u0438\u044e \u043a\u043e\u043b\u043b\u0435\u043a\u0446\u0438\u0438."

    return-object p0
.end method

.method public static group(Ljava/lang/String;)Ljava/lang/String;
    .locals 1

    .line 13
    const-string v0, "dynamic"

    invoke-virtual {p0, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_0

    const-string p0, "\u0416\u0438\u0432\u044b\u0435 \u0441\u0446\u0435\u043d\u044b"

    return-object p0

    :cond_0
    const-string v0, "weather"

    invoke-virtual {p0, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p0

    if-eqz p0, :cond_1

    const-string p0, "\u041f\u043e\u0433\u043e\u0434\u0430"

    return-object p0

    :cond_1
    const-string p0, "\u041a\u043e\u043b\u043b\u0435\u043a\u0446\u0438\u0438 \u0438\u0437\u043e\u0431\u0440\u0430\u0436\u0435\u043d\u0438\u0439"

    return-object p0
.end method

.method public static title(Lru/oopssre/imperialschool/viewstv/Protocol$Theme;)Ljava/lang/String;
    .locals 3

    .line 6
    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/Protocol$Theme;->descriptor:Lorg/json/JSONObject;

    const-string v1, "title_en"

    const-string v2, ""

    invoke-virtual {v0, v1, v2}, Lorg/json/JSONObject;->optString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    .line 7
    new-instance v1, Ljava/lang/StringBuilder;

    const-string v2, " \u00b7 "

    invoke-direct {v1, v2}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    .line 8
    invoke-virtual {v0}, Ljava/lang/String;->isEmpty()Z

    move-result v0

    if-nez v0, :cond_0

    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/Protocol$Theme;->title:Ljava/lang/String;

    invoke-virtual {v0, v1}, Ljava/lang/String;->endsWith(Ljava/lang/String;)Z

    move-result v0

    if-eqz v0, :cond_0

    .line 9
    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/Protocol$Theme;->title:Ljava/lang/String;

    iget-object p0, p0, Lru/oopssre/imperialschool/viewstv/Protocol$Theme;->title:Ljava/lang/String;

    invoke-virtual {p0}, Ljava/lang/String;->length()I

    move-result p0

    invoke-virtual {v1}, Ljava/lang/String;->length()I

    move-result v1

    sub-int/2addr p0, v1

    const/4 v1, 0x0

    invoke-virtual {v0, v1, p0}, Ljava/lang/String;->substring(II)Ljava/lang/String;

    move-result-object p0

    goto :goto_0

    :cond_0
    iget-object p0, p0, Lru/oopssre/imperialschool/viewstv/Protocol$Theme;->title:Ljava/lang/String;

    .line 10
    :goto_0
    const-string v0, " / "

    const-string v1, "\u00a0/\u00a0"

    invoke-virtual {p0, v0, v1}, Ljava/lang/String;->replace(Ljava/lang/CharSequence;Ljava/lang/CharSequence;)Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method
