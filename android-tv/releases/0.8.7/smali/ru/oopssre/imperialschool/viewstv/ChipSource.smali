.class final Lru/oopssre/imperialschool/viewstv/ChipSource;
.super Landroid/media/MediaDataSource;
.source "ChipSource.java"


# static fields
.field private static final BLOCK:I = 0x800


# instance fields
.field private cached:I

.field private final frames:I

.field private handle:J

.field private final header:[B

.field private final pcm:[B

.field private final size:J


# direct methods
.method static constructor <clinit>()V
    .locals 1

    .line 12
    const-string v0, "tvchip"

    invoke-static {v0}, Ljava/lang/System;->loadLibrary(Ljava/lang/String;)V

    return-void
.end method

.method constructor <init>([BZ)V
    .locals 5
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/io/IOException;
        }
    .end annotation

    .line 20
    invoke-direct {p0}, Landroid/media/MediaDataSource;-><init>()V

    const/16 v0, 0x2000

    .line 17
    new-array v0, v0, [B

    iput-object v0, p0, Lru/oopssre/imperialschool/viewstv/ChipSource;->pcm:[B

    const/4 v0, -0x1

    .line 18
    iput v0, p0, Lru/oopssre/imperialschool/viewstv/ChipSource;->cached:I

    .line 21
    invoke-static {p1, p2}, Lru/oopssre/imperialschool/viewstv/ChipSource;->open([BZ)J

    move-result-wide p1

    iput-wide p1, p0, Lru/oopssre/imperialschool/viewstv/ChipSource;->handle:J

    const-wide/16 v0, 0x0

    cmp-long v0, p1, v0

    if-eqz v0, :cond_0

    .line 23
    invoke-static {p1, p2}, Lru/oopssre/imperialschool/viewstv/ChipSource;->info(J)J

    move-result-wide p1

    const/16 v0, 0x20

    ushr-long v0, p1, v0

    long-to-int v0, v0

    long-to-int p1, p1

    .line 25
    iput p1, p0, Lru/oopssre/imperialschool/viewstv/ChipSource;->frames:I

    const/4 p2, 0x4

    mul-int/2addr p1, p2

    const-wide/16 v1, 0x2c

    int-to-long v3, p1

    add-long/2addr v3, v1

    .line 27
    iput-wide v3, p0, Lru/oopssre/imperialschool/viewstv/ChipSource;->size:J

    const/16 v1, 0x2c

    .line 28
    invoke-static {v1}, Ljava/nio/ByteBuffer;->allocate(I)Ljava/nio/ByteBuffer;

    move-result-object v1

    sget-object v2, Ljava/nio/ByteOrder;->LITTLE_ENDIAN:Ljava/nio/ByteOrder;

    invoke-virtual {v1, v2}, Ljava/nio/ByteBuffer;->order(Ljava/nio/ByteOrder;)Ljava/nio/ByteBuffer;

    move-result-object v1

    const-string v2, "RIFF"

    .line 29
    invoke-static {v2}, Lru/oopssre/imperialschool/viewstv/ChipSource;->ascii(Ljava/lang/String;)[B

    move-result-object v2

    invoke-virtual {v1, v2}, Ljava/nio/ByteBuffer;->put([B)Ljava/nio/ByteBuffer;

    move-result-object v1

    add-int/lit8 v2, p1, 0x24

    invoke-virtual {v1, v2}, Ljava/nio/ByteBuffer;->putInt(I)Ljava/nio/ByteBuffer;

    move-result-object v1

    const-string v2, "WAVEfmt "

    invoke-static {v2}, Lru/oopssre/imperialschool/viewstv/ChipSource;->ascii(Ljava/lang/String;)[B

    move-result-object v2

    invoke-virtual {v1, v2}, Ljava/nio/ByteBuffer;->put([B)Ljava/nio/ByteBuffer;

    move-result-object v1

    const/16 v2, 0x10

    invoke-virtual {v1, v2}, Ljava/nio/ByteBuffer;->putInt(I)Ljava/nio/ByteBuffer;

    move-result-object v1

    const/4 v3, 0x1

    .line 30
    invoke-virtual {v1, v3}, Ljava/nio/ByteBuffer;->putShort(S)Ljava/nio/ByteBuffer;

    move-result-object v1

    const/4 v3, 0x2

    invoke-virtual {v1, v3}, Ljava/nio/ByteBuffer;->putShort(S)Ljava/nio/ByteBuffer;

    move-result-object v1

    invoke-virtual {v1, v0}, Ljava/nio/ByteBuffer;->putInt(I)Ljava/nio/ByteBuffer;

    move-result-object v1

    mul-int/2addr v0, p2

    invoke-virtual {v1, v0}, Ljava/nio/ByteBuffer;->putInt(I)Ljava/nio/ByteBuffer;

    move-result-object v0

    .line 31
    invoke-virtual {v0, p2}, Ljava/nio/ByteBuffer;->putShort(S)Ljava/nio/ByteBuffer;

    move-result-object p2

    invoke-virtual {p2, v2}, Ljava/nio/ByteBuffer;->putShort(S)Ljava/nio/ByteBuffer;

    move-result-object p2

    const-string v0, "data"

    invoke-static {v0}, Lru/oopssre/imperialschool/viewstv/ChipSource;->ascii(Ljava/lang/String;)[B

    move-result-object v0

    invoke-virtual {p2, v0}, Ljava/nio/ByteBuffer;->put([B)Ljava/nio/ByteBuffer;

    move-result-object p2

    invoke-virtual {p2, p1}, Ljava/nio/ByteBuffer;->putInt(I)Ljava/nio/ByteBuffer;

    move-result-object p1

    invoke-virtual {p1}, Ljava/nio/ByteBuffer;->array()[B

    move-result-object p1

    iput-object p1, p0, Lru/oopssre/imperialschool/viewstv/ChipSource;->header:[B

    return-void

    .line 22
    :cond_0
    new-instance p1, Ljava/io/IOException;

    const-string p2, "\u041d\u0435\u0438\u0437\u0432\u0435\u0441\u0442\u043d\u044b\u0439 \u0444\u043e\u0440\u043c\u0430\u0442 \u0447\u0438\u043f\u0442\u044e\u043d\u0430"

    invoke-direct {p1, p2}, Ljava/io/IOException;-><init>(Ljava/lang/String;)V

    throw p1
.end method

.method private static ascii(Ljava/lang/String;)[B
    .locals 1

    .line 34
    sget-object v0, Ljava/nio/charset/StandardCharsets;->US_ASCII:Ljava/nio/charset/Charset;

    invoke-virtual {p0, v0}, Ljava/lang/String;->getBytes(Ljava/nio/charset/Charset;)[B

    move-result-object p0

    return-object p0
.end method

.method private static native dispose(J)V
.end method

.method private static native info(J)J
.end method

.method private static native open([BZ)J
.end method

.method private static native render(JII[B)Z
.end method


# virtual methods
.method public declared-synchronized close()V
    .locals 5

    monitor-enter p0

    .line 69
    :try_start_0
    iget-wide v0, p0, Lru/oopssre/imperialschool/viewstv/ChipSource;->handle:J

    const-wide/16 v2, 0x0

    cmp-long v4, v0, v2

    if-eqz v4, :cond_0

    invoke-static {v0, v1}, Lru/oopssre/imperialschool/viewstv/ChipSource;->dispose(J)V

    .line 70
    :cond_0
    iput-wide v2, p0, Lru/oopssre/imperialschool/viewstv/ChipSource;->handle:J
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 71
    monitor-exit p0

    return-void

    :catchall_0
    move-exception v0

    :try_start_1
    monitor-exit p0
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    throw v0
.end method

.method public getSize()J
    .locals 2

    .line 66
    iget-wide v0, p0, Lru/oopssre/imperialschool/viewstv/ChipSource;->size:J

    return-wide v0
.end method

.method public declared-synchronized readAt(J[BII)I
    .locals 7
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/io/IOException;
        }
    .end annotation

    monitor-enter p0

    if-nez p5, :cond_0

    .line 37
    monitor-exit p0

    const/4 p1, 0x0

    return p1

    .line 38
    :cond_0
    :try_start_0
    iget-wide v0, p0, Lru/oopssre/imperialschool/viewstv/ChipSource;->handle:J

    const-wide/16 v2, 0x0

    cmp-long v0, v0, v2

    if-eqz v0, :cond_6

    iget-wide v0, p0, Lru/oopssre/imperialschool/viewstv/ChipSource;->size:J

    cmp-long v2, p1, v0

    if-ltz v2, :cond_1

    goto :goto_3

    :cond_1
    int-to-long v2, p5

    sub-long/2addr v0, p1

    .line 39
    invoke-static {v2, v3, v0, v1}, Ljava/lang/Math;->min(JJ)J

    move-result-wide v0

    long-to-int p5, v0

    .line 41
    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/ChipSource;->header:[B

    array-length v1, v0

    int-to-long v1, v1

    cmp-long v1, p1, v1

    if-gez v1, :cond_2

    int-to-long v1, p5

    .line 42
    array-length v0, v0

    int-to-long v3, v0

    sub-long/2addr v3, p1

    invoke-static {v1, v2, v3, v4}, Ljava/lang/Math;->min(JJ)J

    move-result-wide v0

    long-to-int v0, v0

    .line 43
    iget-object v1, p0, Lru/oopssre/imperialschool/viewstv/ChipSource;->header:[B

    long-to-int v2, p1

    invoke-static {v1, v2, p3, p4, v0}, Ljava/lang/System;->arraycopy(Ljava/lang/Object;ILjava/lang/Object;II)V

    add-int/2addr p4, v0

    sub-int v1, p5, v0

    int-to-long v2, v0

    :goto_0
    add-long/2addr p1, v2

    goto :goto_1

    :cond_2
    move v1, p5

    :goto_1
    if-lez v1, :cond_5

    .line 49
    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/ChipSource;->header:[B

    array-length v0, v0

    int-to-long v2, v0

    sub-long v2, p1, v2

    long-to-int v0, v2

    .line 50
    iget-object v2, p0, Lru/oopssre/imperialschool/viewstv/ChipSource;->pcm:[B

    array-length v2, v2

    div-int v2, v0, v2

    const/16 v3, 0x800

    mul-int/2addr v2, v3

    .line 51
    iget v4, p0, Lru/oopssre/imperialschool/viewstv/ChipSource;->frames:I

    sub-int/2addr v4, v2

    invoke-static {v3, v4}, Ljava/lang/Math;->min(II)I

    move-result v3

    .line 52
    iget v4, p0, Lru/oopssre/imperialschool/viewstv/ChipSource;->cached:I

    if-eq v4, v2, :cond_4

    .line 53
    iget-wide v4, p0, Lru/oopssre/imperialschool/viewstv/ChipSource;->handle:J

    iget-object v6, p0, Lru/oopssre/imperialschool/viewstv/ChipSource;->pcm:[B

    invoke-static {v4, v5, v2, v3, v6}, Lru/oopssre/imperialschool/viewstv/ChipSource;->render(JII[B)Z

    move-result v4

    if-eqz v4, :cond_3

    .line 54
    iput v2, p0, Lru/oopssre/imperialschool/viewstv/ChipSource;->cached:I

    goto :goto_2

    .line 53
    :cond_3
    new-instance p1, Ljava/io/IOException;

    const-string p2, "\u041e\u0448\u0438\u0431\u043a\u0430 \u0447\u0438\u043f\u0442\u044e\u043d\u0430"

    invoke-direct {p1, p2}, Ljava/io/IOException;-><init>(Ljava/lang/String;)V

    throw p1

    .line 56
    :cond_4
    :goto_2
    iget-object v2, p0, Lru/oopssre/imperialschool/viewstv/ChipSource;->pcm:[B

    array-length v2, v2

    rem-int/2addr v0, v2

    mul-int/lit8 v3, v3, 0x4

    sub-int/2addr v3, v0

    .line 57
    invoke-static {v1, v3}, Ljava/lang/Math;->min(II)I

    move-result v2

    .line 58
    iget-object v3, p0, Lru/oopssre/imperialschool/viewstv/ChipSource;->pcm:[B

    invoke-static {v3, v0, p3, p4, v2}, Ljava/lang/System;->arraycopy(Ljava/lang/Object;ILjava/lang/Object;II)V
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    add-int/2addr p4, v2

    sub-int/2addr v1, v2

    int-to-long v2, v2

    goto :goto_0

    .line 63
    :cond_5
    monitor-exit p0

    return p5

    .line 38
    :cond_6
    :goto_3
    monitor-exit p0

    const/4 p1, -0x1

    return p1

    :catchall_0
    move-exception p1

    :try_start_1
    monitor-exit p0
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    throw p1
.end method
