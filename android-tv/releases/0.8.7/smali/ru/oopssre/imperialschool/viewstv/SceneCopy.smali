.class public final Lru/oopssre/imperialschool/viewstv/SceneCopy;
.super Ljava/lang/Object;
.source "SceneCopy.java"


# direct methods
.method private constructor <init>()V
    .locals 0

    .line 5
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method public static parent(Ljava/lang/String;)Ljava/lang/String;
    .locals 7

    .line 23
    invoke-virtual {p0}, Ljava/lang/String;->hashCode()I

    invoke-virtual {p0}, Ljava/lang/String;->hashCode()I

    move-result v0

    const-string v1, "music_credits"

    const-string v2, "personal"

    const-string v3, "info"

    const-string v4, "screen"

    const-string v5, "collection"

    const/4 v6, -0x1

    sparse-switch v0, :sswitch_data_0

    goto/16 :goto_0

    :sswitch_0
    const-string v0, "stations"

    invoke-virtual {p0, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p0

    if-nez p0, :cond_0

    goto/16 :goto_0

    :cond_0
    const/16 v6, 0x12

    goto/16 :goto_0

    :sswitch_1
    const-string v0, "personal_stations"

    invoke-virtual {p0, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p0

    if-nez p0, :cond_1

    goto/16 :goto_0

    :cond_1
    const/16 v6, 0x11

    goto/16 :goto_0

    :sswitch_2
    const-string v0, "weather"

    invoke-virtual {p0, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p0

    if-nez p0, :cond_2

    goto/16 :goto_0

    :cond_2
    const/16 v6, 0x10

    goto/16 :goto_0

    :sswitch_3
    invoke-virtual {p0, v1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p0

    if-nez p0, :cond_3

    goto/16 :goto_0

    :cond_3
    const/16 v6, 0xf

    goto/16 :goto_0

    :sswitch_4
    const-string v0, "credits_detail"

    invoke-virtual {p0, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p0

    if-nez p0, :cond_4

    goto/16 :goto_0

    :cond_4
    const/16 v6, 0xe

    goto/16 :goto_0

    :sswitch_5
    invoke-virtual {p0, v2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p0

    if-nez p0, :cond_5

    goto/16 :goto_0

    :cond_5
    const/16 v6, 0xd

    goto/16 :goto_0

    :sswitch_6
    const-string v0, "scale"

    invoke-virtual {p0, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p0

    if-nez p0, :cond_6

    goto/16 :goto_0

    :cond_6
    const/16 v6, 0xc

    goto/16 :goto_0

    :sswitch_7
    const-string v0, "proxy"

    invoke-virtual {p0, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p0

    if-nez p0, :cond_7

    goto/16 :goto_0

    :cond_7
    const/16 v6, 0xb

    goto/16 :goto_0

    :sswitch_8
    const-string v0, "cache"

    invoke-virtual {p0, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p0

    if-nez p0, :cond_8

    goto/16 :goto_0

    :cond_8
    const/16 v6, 0xa

    goto/16 :goto_0

    :sswitch_9
    const-string v0, "mode"

    invoke-virtual {p0, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p0

    if-nez p0, :cond_9

    goto/16 :goto_0

    :cond_9
    const/16 v6, 0x9

    goto/16 :goto_0

    :sswitch_a
    invoke-virtual {p0, v3}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p0

    if-nez p0, :cond_a

    goto/16 :goto_0

    :cond_a
    const/16 v6, 0x8

    goto :goto_0

    :sswitch_b
    const-string v0, "updates"

    invoke-virtual {p0, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p0

    if-nez p0, :cond_b

    goto :goto_0

    :cond_b
    const/4 v6, 0x7

    goto :goto_0

    :sswitch_c
    const-string v0, "project"

    invoke-virtual {p0, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p0

    if-nez p0, :cond_c

    goto :goto_0

    :cond_c
    const/4 v6, 0x6

    goto :goto_0

    :sswitch_d
    const-string v0, "diagnostics"

    invoke-virtual {p0, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p0

    if-nez p0, :cond_d

    goto :goto_0

    :cond_d
    const/4 v6, 0x5

    goto :goto_0

    :sswitch_e
    const-string v0, "volume"

    invoke-virtual {p0, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p0

    if-nez p0, :cond_e

    goto :goto_0

    :cond_e
    const/4 v6, 0x4

    goto :goto_0

    :sswitch_f
    invoke-virtual {p0, v4}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p0

    if-nez p0, :cond_f

    goto :goto_0

    :cond_f
    const/4 v6, 0x3

    goto :goto_0

    :sswitch_10
    const-string v0, "output"

    invoke-virtual {p0, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p0

    if-nez p0, :cond_10

    goto :goto_0

    :cond_10
    const/4 v6, 0x2

    goto :goto_0

    :sswitch_11
    const-string v0, "resolution"

    invoke-virtual {p0, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p0

    if-nez p0, :cond_11

    goto :goto_0

    :cond_11
    const/4 v6, 0x1

    goto :goto_0

    :sswitch_12
    invoke-virtual {p0, v5}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p0

    if-nez p0, :cond_12

    goto :goto_0

    :cond_12
    const/4 v6, 0x0

    :goto_0
    packed-switch v6, :pswitch_data_0

    .line 33
    const-string p0, "menu"

    return-object p0

    :pswitch_0
    return-object v2

    :pswitch_1
    return-object v1

    :pswitch_2
    return-object v5

    :pswitch_3
    return-object v3

    .line 29
    :pswitch_4
    const-string p0, "music"

    return-object p0

    .line 25
    :pswitch_5
    const-string p0, "settings"

    return-object p0

    :pswitch_6
    return-object v4

    .line 26
    :pswitch_7
    const-string p0, "themes"

    return-object p0

    nop

    :sswitch_data_0
    .sparse-switch
        -0x67ca5162 -> :sswitch_12
        -0x5f5e8754 -> :sswitch_11
        -0x3beee6ff -> :sswitch_10
        -0x361a3f94 -> :sswitch_f
        -0x305518e6 -> :sswitch_e
        -0x2c216654 -> :sswitch_d
        -0x126fb4e7 -> :sswitch_c
        -0xdf91f36 -> :sswitch_b
        0x3164ae -> :sswitch_a
        0x3339a3 -> :sswitch_9
        0x5a0af82 -> :sswitch_8
        0x65fca6e -> :sswitch_7
        0x683094a -> :sswitch_6
        0x1a6a2640 -> :sswitch_5
        0x1eacdf96 -> :sswitch_4
        0x472c5480 -> :sswitch_3
        0x48ec37f4 -> :sswitch_2
        0x49f638de -> :sswitch_1
        0x4e9425bf -> :sswitch_0
    .end sparse-switch

    :pswitch_data_0
    .packed-switch 0x0
        :pswitch_7
        :pswitch_6
        :pswitch_6
        :pswitch_5
        :pswitch_4
        :pswitch_3
        :pswitch_3
        :pswitch_3
        :pswitch_5
        :pswitch_2
        :pswitch_5
        :pswitch_5
        :pswitch_6
        :pswitch_5
        :pswitch_1
        :pswitch_3
        :pswitch_2
        :pswitch_0
        :pswitch_4
    .end packed-switch
.end method

.method public static waiting(Ljava/lang/String;)Ljava/lang/String;
    .locals 2

    .line 7
    const-string v0, "\u0417\u0430\u0433\u0440\u0443\u0436\u0430\u044e \u043e\u0431\u043e\u0438\u2026"

    if-nez p0, :cond_0

    return-object v0

    .line 8
    :cond_0
    const-string v1, "\u041d\u0435\u0434\u043e\u0441\u0442\u0430\u0442\u043e\u0447\u043d\u043e \u043c\u0435\u0441\u0442\u0430"

    invoke-virtual {p0, v1}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z

    move-result v1

    if-nez v1, :cond_a

    const-string v1, "No space left"

    invoke-virtual {p0, v1}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z

    move-result v1

    if-eqz v1, :cond_1

    goto :goto_3

    .line 10
    :cond_1
    const-string v1, "\u041d\u0435\u0442 \u0430\u043f\u043f\u0430\u0440\u0430\u0442\u043d\u043e\u0433\u043e"

    invoke-virtual {p0, v1}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z

    move-result v1

    if-eqz v1, :cond_2

    .line 11
    const-string p0, "\u042d\u0442\u043e\u0442 \u0442\u0435\u043b\u0435\u0432\u0438\u0437\u043e\u0440 \u043d\u0435 \u043f\u043e\u0434\u0434\u0435\u0440\u0436\u0438\u0432\u0430\u0435\u0442 \u0432\u0438\u0434\u0435\u043e 4\u041a. \u0412\u044b\u0431\u0435\u0440\u0438\u0442\u0435 \u0438\u0437\u043e\u0431\u0440\u0430\u0436\u0435\u043d\u0438\u0435 \u0432 \u043d\u0430\u0441\u0442\u0440\u043e\u0439\u043a\u0430\u0445 \u043f\u043e\u043a\u0430\u0437\u0430."

    return-object p0

    .line 12
    :cond_2
    const-string v1, "\u0412\u0438\u0434\u0435\u043e \u0434\u043b\u044f \u0442\u0435\u043a\u0443\u0449\u0435\u0433\u043e \u043a\u0430\u0434\u0440\u0430"

    invoke-virtual {p0, v1}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z

    move-result v1

    if-nez v1, :cond_9

    const-string v1, "4\u041a-\u0432\u0438\u0434\u0435\u043e"

    invoke-virtual {p0, v1}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z

    move-result v1

    if-eqz v1, :cond_3

    goto :goto_2

    .line 14
    :cond_3
    const-string v1, "\u043d\u0435 \u043e\u043f\u0443\u0431\u043b\u0438\u043a\u043e\u0432\u0430\u043d"

    invoke-virtual {p0, v1}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z

    move-result v1

    if-nez v1, :cond_8

    const-string v1, "\u0435\u0449\u0451 \u043d\u0435 \u0433\u043e\u0442\u043e\u0432"

    invoke-virtual {p0, v1}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z

    move-result v1

    if-eqz v1, :cond_4

    goto :goto_1

    .line 16
    :cond_4
    const-string v1, "\u043f\u0430\u043c\u044f\u0442\u0438"

    invoke-virtual {p0, v1}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z

    move-result v1

    if-eqz v1, :cond_5

    .line 17
    const-string p0, "\u041d\u0435 \u0443\u0434\u0430\u043b\u043e\u0441\u044c \u043e\u0442\u043a\u0440\u044b\u0442\u044c \u0438\u0437\u043e\u0431\u0440\u0430\u0436\u0435\u043d\u0438\u0435. \u0412\u044b\u0431\u0435\u0440\u0438\u0442\u0435 \u043c\u0435\u043d\u044c\u0448\u0435\u0435 \u0440\u0430\u0437\u0440\u0435\u0448\u0435\u043d\u0438\u0435 \u0432 \u043d\u0430\u0441\u0442\u0440\u043e\u0439\u043a\u0430\u0445 \u043f\u043e\u043a\u0430\u0437\u0430."

    return-object p0

    .line 18
    :cond_5
    const-string v1, "\u041e\u0448\u0438\u0431\u043a\u0430"

    invoke-virtual {p0, v1}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z

    move-result v1

    if-nez v1, :cond_7

    const-string v1, "\u043d\u0435 \u043f\u043e\u043b\u0443\u0447\u0435\u043d\u043e"

    invoke-virtual {p0, v1}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z

    move-result v1

    if-nez v1, :cond_7

    const-string v1, "\u041d\u0435\u0442 \u0441\u0432\u044f\u0437\u0438"

    invoke-virtual {p0, v1}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z

    move-result v1

    if-nez v1, :cond_7

    const-string v1, "\u041d\u0435\u0442 \u043a\u0430\u0434\u0440\u0430"

    invoke-virtual {p0, v1}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z

    move-result p0

    if-eqz p0, :cond_6

    goto :goto_0

    :cond_6
    return-object v0

    .line 19
    :cond_7
    :goto_0
    const-string p0, "\u041d\u0435 \u0443\u0434\u0430\u043b\u043e\u0441\u044c \u0437\u0430\u0433\u0440\u0443\u0437\u0438\u0442\u044c \u043e\u0431\u043e\u0438. \u041f\u043e\u0432\u0442\u043e\u0440\u044e \u043f\u043e\u043f\u044b\u0442\u043a\u0443."

    return-object p0

    .line 15
    :cond_8
    :goto_1
    const-string p0, "\u042d\u0442\u0430 \u0441\u0446\u0435\u043d\u0430 \u0435\u0449\u0451 \u043d\u0435 \u0433\u043e\u0442\u043e\u0432\u0430. \u041f\u0440\u043e\u0432\u0435\u0440\u044e \u043f\u043e\u0437\u0436\u0435."

    return-object p0

    .line 13
    :cond_9
    :goto_2
    const-string p0, "\u0412\u0438\u0434\u0435\u043e \u044d\u0442\u043e\u0439 \u0441\u0446\u0435\u043d\u044b \u0435\u0449\u0451 \u043d\u0435 \u0433\u043e\u0442\u043e\u0432\u043e. \u0418\u0437\u043e\u0431\u0440\u0430\u0436\u0435\u043d\u0438\u0435 \u0434\u043e\u0441\u0442\u0443\u043f\u043d\u043e \u0432 \u043d\u0430\u0441\u0442\u0440\u043e\u0439\u043a\u0430\u0445 \u043f\u043e\u043a\u0430\u0437\u0430."

    return-object p0

    .line 9
    :cond_a
    :goto_3
    const-string p0, "\u041d\u0430 \u0442\u0435\u043b\u0435\u0432\u0438\u0437\u043e\u0440\u0435 \u043d\u0435 \u0445\u0432\u0430\u0442\u0430\u0435\u0442 \u0441\u0432\u043e\u0431\u043e\u0434\u043d\u043e\u0433\u043e \u043c\u0435\u0441\u0442\u0430. \u041e\u0442\u043a\u0440\u043e\u0439\u0442\u0435 \u041d\u0430\u0441\u0442\u0440\u043e\u0439\u043a\u0438 \u2192 \u0425\u0440\u0430\u043d\u0438\u043b\u0438\u0449\u0435."

    return-object p0
.end method
