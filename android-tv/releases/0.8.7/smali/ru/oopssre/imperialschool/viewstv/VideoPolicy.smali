.class public final Lru/oopssre/imperialschool/viewstv/VideoPolicy;
.super Ljava/lang/Object;
.source "VideoPolicy.java"


# direct methods
.method public constructor <init>()V
    .locals 0

    .line 6
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method public static nextDelay()J
    .locals 5

    .line 7
    invoke-static {}, Ljava/util/concurrent/ThreadLocalRandom;->current()Ljava/util/concurrent/ThreadLocalRandom;

    move-result-object v0

    const-wide/32 v1, 0x927c0

    const-wide/32 v3, 0x124f81

    invoke-virtual {v0, v1, v2, v3, v4}, Ljava/util/concurrent/ThreadLocalRandom;->nextLong(JJ)J

    move-result-wide v0

    return-wide v0
.end method

.method public static retryDelay(I)J
    .locals 4

    add-int/lit8 p0, p0, -0x1

    const/4 v0, 0x0

    .line 8
    invoke-static {v0, p0}, Ljava/lang/Math;->max(II)I

    move-result p0

    const/4 v0, 0x3

    invoke-static {v0, p0}, Ljava/lang/Math;->min(II)I

    move-result p0

    const-wide/16 v0, 0x1

    shl-long/2addr v0, p0

    const-wide/32 v2, 0xea60

    mul-long/2addr v0, v2

    const-wide/32 v2, 0x493e0

    invoke-static {v2, v3, v0, v1}, Ljava/lang/Math;->min(JJ)J

    move-result-wide v0

    return-wide v0
.end method
