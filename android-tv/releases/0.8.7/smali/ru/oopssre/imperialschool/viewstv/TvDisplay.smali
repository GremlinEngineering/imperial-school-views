.class public final Lru/oopssre/imperialschool/viewstv/TvDisplay;
.super Ljava/lang/Object;
.source "TvDisplay.java"


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lru/oopssre/imperialschool/viewstv/TvDisplay$Mode;
    }
.end annotation


# static fields
.field public static final AUTO:Ljava/lang/String; = "auto"

.field public static final FULL_HD:Ljava/lang/String; = "1080p"

.field public static final UHD:Ljava/lang/String; = "4k"


# direct methods
.method public constructor <init>()V
    .locals 0

    .line 4
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method public static choose(Lru/oopssre/imperialschool/viewstv/TvDisplay$Mode;[Lru/oopssre/imperialschool/viewstv/TvDisplay$Mode;)Lru/oopssre/imperialschool/viewstv/TvDisplay$Mode;
    .locals 1

    .line 19
    const-string v0, "auto"

    invoke-static {p0, p1, v0}, Lru/oopssre/imperialschool/viewstv/TvDisplay;->choose(Lru/oopssre/imperialschool/viewstv/TvDisplay$Mode;[Lru/oopssre/imperialschool/viewstv/TvDisplay$Mode;Ljava/lang/String;)Lru/oopssre/imperialschool/viewstv/TvDisplay$Mode;

    move-result-object p0

    return-object p0
.end method

.method public static choose(Lru/oopssre/imperialschool/viewstv/TvDisplay$Mode;[Lru/oopssre/imperialschool/viewstv/TvDisplay$Mode;Ljava/lang/String;)Lru/oopssre/imperialschool/viewstv/TvDisplay$Mode;
    .locals 10

    .line 23
    array-length v0, p1

    const/4 v1, 0x0

    const/4 v2, 0x0

    :goto_0
    if-ge v2, v0, :cond_5

    aget-object v3, p1, v2

    .line 24
    iget v4, v3, Lru/oopssre/imperialschool/viewstv/TvDisplay$Mode;->width:I

    iget v5, v3, Lru/oopssre/imperialschool/viewstv/TvDisplay$Mode;->height:I

    if-lt v4, v5, :cond_4

    iget v4, v3, Lru/oopssre/imperialschool/viewstv/TvDisplay$Mode;->width:I

    if-lez v4, :cond_4

    iget v4, v3, Lru/oopssre/imperialschool/viewstv/TvDisplay$Mode;->height:I

    if-lez v4, :cond_4

    iget v4, v3, Lru/oopssre/imperialschool/viewstv/TvDisplay$Mode;->width:I

    const/16 v5, 0xf00

    if-gt v4, v5, :cond_4

    iget v4, v3, Lru/oopssre/imperialschool/viewstv/TvDisplay$Mode;->height:I

    const/16 v5, 0x870

    if-le v4, v5, :cond_0

    goto :goto_2

    .line 25
    :cond_0
    const-string v4, "1080p"

    invoke-static {p2}, Lru/oopssre/imperialschool/viewstv/TvDisplay;->resolution(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v5

    invoke-virtual {v4, v5}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v4

    if-eqz v4, :cond_1

    iget v4, v3, Lru/oopssre/imperialschool/viewstv/TvDisplay$Mode;->width:I

    const/16 v5, 0x780

    if-gt v4, v5, :cond_4

    iget v4, v3, Lru/oopssre/imperialschool/viewstv/TvDisplay$Mode;->height:I

    const/16 v5, 0x438

    if-le v4, v5, :cond_1

    goto :goto_2

    .line 26
    :cond_1
    iget v4, v3, Lru/oopssre/imperialschool/viewstv/TvDisplay$Mode;->width:I

    int-to-long v4, v4

    iget v6, v3, Lru/oopssre/imperialschool/viewstv/TvDisplay$Mode;->height:I

    int-to-long v6, v6

    mul-long/2addr v4, v6

    if-nez v1, :cond_2

    const-wide/16 v6, 0x0

    goto :goto_1

    :cond_2
    iget v6, v1, Lru/oopssre/imperialschool/viewstv/TvDisplay$Mode;->width:I

    int-to-long v6, v6

    iget v8, v1, Lru/oopssre/imperialschool/viewstv/TvDisplay$Mode;->height:I

    int-to-long v8, v8

    mul-long/2addr v6, v8

    :goto_1
    if-eqz v1, :cond_3

    cmp-long v4, v4, v6

    if-gtz v4, :cond_3

    if-nez v4, :cond_4

    .line 27
    iget v4, v3, Lru/oopssre/imperialschool/viewstv/TvDisplay$Mode;->hz:F

    iget v5, p0, Lru/oopssre/imperialschool/viewstv/TvDisplay$Mode;->hz:F

    sub-float/2addr v4, v5

    invoke-static {v4}, Ljava/lang/Math;->abs(F)F

    move-result v4

    iget v5, v1, Lru/oopssre/imperialschool/viewstv/TvDisplay$Mode;->hz:F

    iget v6, p0, Lru/oopssre/imperialschool/viewstv/TvDisplay$Mode;->hz:F

    sub-float/2addr v5, v6

    invoke-static {v5}, Ljava/lang/Math;->abs(F)F

    move-result v5

    cmpg-float v4, v4, v5

    if-gez v4, :cond_4

    :cond_3
    move-object v1, v3

    :cond_4
    :goto_2
    add-int/lit8 v2, v2, 0x1

    goto :goto_0

    :cond_5
    if-nez v1, :cond_6

    return-object p0

    :cond_6
    return-object v1
.end method

.method public static is4k(II)Z
    .locals 1

    const/16 v0, 0xf00

    if-lt p0, v0, :cond_0

    const/16 p0, 0x870

    if-lt p1, p0, :cond_0

    const/4 p0, 0x1

    return p0

    :cond_0
    const/4 p0, 0x0

    return p0
.end method

.method public static label(Ljava/lang/String;)Ljava/lang/String;
    .locals 1

    .line 7
    invoke-static {p0}, Lru/oopssre/imperialschool/viewstv/TvDisplay;->resolution(Ljava/lang/String;)Ljava/lang/String;

    move-result-object p0

    const-string v0, "4k"

    invoke-virtual {v0, p0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_0

    const-string p0, "4\u041a \u00b7 3840\u00d72160"

    return-object p0

    :cond_0
    const-string v0, "1080p"

    invoke-virtual {v0, p0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p0

    if-eqz p0, :cond_1

    const-string p0, "Full HD \u00b7 1920\u00d71080"

    return-object p0

    :cond_1
    const-string p0, "\u0410\u0432\u0442\u043e"

    return-object p0
.end method

.method public static resolution(Ljava/lang/String;)Ljava/lang/String;
    .locals 2

    .line 6
    const-string v0, "4k"

    invoke-virtual {v0, p0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v1

    if-eqz v1, :cond_0

    return-object v0

    :cond_0
    const-string v0, "1080p"

    invoke-virtual {v0, p0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p0

    if-eqz p0, :cond_1

    return-object v0

    :cond_1
    const-string p0, "auto"

    return-object p0
.end method

.method public static targetSize(Ljava/lang/String;II)[I
    .locals 3

    .line 9
    invoke-static {p0}, Lru/oopssre/imperialschool/viewstv/TvDisplay;->resolution(Ljava/lang/String;)Ljava/lang/String;

    move-result-object p0

    .line 10
    const-string v0, "4k"

    invoke-virtual {v0, p0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    const/16 v1, 0x870

    const/16 v2, 0xf00

    if-eqz v0, :cond_0

    filled-new-array {v2, v1}, [I

    move-result-object p0

    return-object p0

    .line 11
    :cond_0
    const-string v0, "1080p"

    invoke-virtual {v0, p0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p0

    if-eqz p0, :cond_1

    const/16 p0, 0x780

    const/16 p1, 0x438

    filled-new-array {p0, p1}, [I

    move-result-object p0

    return-object p0

    .line 12
    :cond_1
    invoke-static {v2, p1}, Ljava/lang/Math;->min(II)I

    move-result p0

    const/4 p1, 0x1

    invoke-static {p1, p0}, Ljava/lang/Math;->max(II)I

    move-result p0

    invoke-static {v1, p2}, Ljava/lang/Math;->min(II)I

    move-result p2

    invoke-static {p1, p2}, Ljava/lang/Math;->max(II)I

    move-result p1

    filled-new-array {p0, p1}, [I

    move-result-object p0

    return-object p0
.end method
