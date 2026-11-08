.class public final Lru/oopssre/imperialschool/viewstv/ImageFormat;
.super Ljava/lang/Object;
.source "ImageFormat.java"


# direct methods
.method public constructor <init>()V
    .locals 0

    .line 7
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method public static canonical(Ljava/lang/String;)Ljava/lang/String;
    .locals 2

    .line 9
    sget-object v0, Ljava/util/Locale;->ROOT:Ljava/util/Locale;

    invoke-virtual {p0, v0}, Ljava/lang/String;->toLowerCase(Ljava/util/Locale;)Ljava/lang/String;

    move-result-object p0

    .line 10
    const-string v0, "png"

    invoke-virtual {p0, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v1

    if-eqz v1, :cond_0

    return-object v0

    .line 11
    :cond_0
    const-string v0, "jpg"

    invoke-virtual {p0, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v1

    if-nez v1, :cond_2

    const-string v1, "jpeg"

    invoke-virtual {p0, v1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p0

    if-eqz p0, :cond_1

    goto :goto_0

    .line 12
    :cond_1
    new-instance p0, Ljava/lang/IllegalArgumentException;

    const-string v0, "\u041d\u0435\u043f\u043e\u0434\u0434\u0435\u0440\u0436\u0438\u0432\u0430\u0435\u043c\u044b\u0439 \u0444\u043e\u0440\u043c\u0430\u0442 \u0438\u0437\u043e\u0431\u0440\u0430\u0436\u0435\u043d\u0438\u044f"

    invoke-direct {p0, v0}, Ljava/lang/IllegalArgumentException;-><init>(Ljava/lang/String;)V

    throw p0

    :cond_2
    :goto_0
    return-object v0
.end method

.method public static fromURL(Ljava/lang/String;)Ljava/lang/String;
    .locals 1

    .line 15
    invoke-static {p0}, Lru/oopssre/imperialschool/viewstv/Protocol;->url(Ljava/lang/String;)Ljava/net/URI;

    move-result-object p0

    invoke-virtual {p0}, Ljava/net/URI;->getPath()Ljava/lang/String;

    move-result-object p0

    sget-object v0, Ljava/util/Locale;->ROOT:Ljava/util/Locale;

    invoke-virtual {p0, v0}, Ljava/lang/String;->toLowerCase(Ljava/util/Locale;)Ljava/lang/String;

    move-result-object p0

    .line 16
    const-string v0, ".png"

    invoke-virtual {p0, v0}, Ljava/lang/String;->endsWith(Ljava/lang/String;)Z

    move-result v0

    if-eqz v0, :cond_0

    const-string p0, "png"

    return-object p0

    .line 17
    :cond_0
    const-string v0, ".jpg"

    invoke-virtual {p0, v0}, Ljava/lang/String;->endsWith(Ljava/lang/String;)Z

    move-result v0

    if-nez v0, :cond_2

    const-string v0, ".jpeg"

    invoke-virtual {p0, v0}, Ljava/lang/String;->endsWith(Ljava/lang/String;)Z

    move-result p0

    if-eqz p0, :cond_1

    goto :goto_0

    .line 18
    :cond_1
    new-instance p0, Ljava/lang/IllegalArgumentException;

    const-string v0, "\u041d\u0435\u0432\u0435\u0440\u043d\u043e\u0435 \u0440\u0430\u0441\u0448\u0438\u0440\u0435\u043d\u0438\u0435 \u0438\u0437\u043e\u0431\u0440\u0430\u0436\u0435\u043d\u0438\u044f"

    invoke-direct {p0, v0}, Ljava/lang/IllegalArgumentException;-><init>(Ljava/lang/String;)V

    throw p0

    .line 17
    :cond_2
    :goto_0
    const-string p0, "jpg"

    return-object p0
.end method

.method public static signature(Ljava/io/File;Ljava/lang/String;)Z
    .locals 7
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/io/IOException;
        }
    .end annotation

    const/16 v0, 0x8

    .line 21
    new-array v1, v0, [B

    .line 22
    new-instance v2, Ljava/io/FileInputStream;

    invoke-direct {v2, p0}, Ljava/io/FileInputStream;-><init>(Ljava/io/File;)V

    const/4 p0, 0x0

    move v3, p0

    :goto_0
    if-ge v3, v0, :cond_1

    rsub-int/lit8 v4, v3, 0x8

    :try_start_0
    invoke-virtual {v2, v1, v3, v4}, Ljava/io/InputStream;->read([BII)I

    move-result v4
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    if-gez v4, :cond_0

    goto :goto_2

    :cond_0
    add-int/2addr v3, v4

    goto :goto_0

    :catchall_0
    move-exception p0

    :try_start_1
    invoke-virtual {v2}, Ljava/io/InputStream;->close()V
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_1

    goto :goto_1

    :catchall_1
    move-exception p1

    invoke-virtual {p0, p1}, Ljava/lang/Throwable;->addSuppressed(Ljava/lang/Throwable;)V

    :goto_1
    throw p0

    :cond_1
    :goto_2
    invoke-virtual {v2}, Ljava/io/InputStream;->close()V

    .line 23
    invoke-static {p1}, Lru/oopssre/imperialschool/viewstv/ImageFormat;->canonical(Ljava/lang/String;)Ljava/lang/String;

    move-result-object p1

    const-string v2, "jpg"

    invoke-virtual {p1, v2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p1

    const/4 v2, 0x2

    const/4 v4, 0x3

    const/4 v5, 0x1

    const/16 v6, 0xff

    if-eqz p1, :cond_3

    if-lt v3, v4, :cond_2

    aget-byte p1, v1, p0

    and-int/2addr p1, v6

    if-ne p1, v6, :cond_2

    aget-byte p1, v1, v5

    and-int/2addr p1, v6

    const/16 v0, 0xd8

    if-ne p1, v0, :cond_2

    aget-byte p1, v1, v2

    and-int/2addr p1, v6

    if-ne p1, v6, :cond_2

    return v5

    :cond_2
    return p0

    :cond_3
    if-ne v3, v0, :cond_4

    .line 24
    aget-byte p1, v1, p0

    and-int/2addr p1, v6

    const/16 v0, 0x89

    if-ne p1, v0, :cond_4

    aget-byte p1, v1, v5

    const/16 v0, 0x50

    if-ne p1, v0, :cond_4

    aget-byte p1, v1, v2

    const/16 v0, 0x4e

    if-ne p1, v0, :cond_4

    aget-byte p1, v1, v4

    const/16 v0, 0x47

    if-ne p1, v0, :cond_4

    const/4 p1, 0x4

    aget-byte p1, v1, p1

    const/16 v0, 0xd

    if-ne p1, v0, :cond_4

    const/4 p1, 0x5

    aget-byte p1, v1, p1

    const/16 v0, 0xa

    if-ne p1, v0, :cond_4

    const/4 p1, 0x6

    aget-byte p1, v1, p1

    const/16 v2, 0x1a

    if-ne p1, v2, :cond_4

    const/4 p1, 0x7

    aget-byte p1, v1, p1

    if-ne p1, v0, :cond_4

    return v5

    :cond_4
    return p0
.end method
