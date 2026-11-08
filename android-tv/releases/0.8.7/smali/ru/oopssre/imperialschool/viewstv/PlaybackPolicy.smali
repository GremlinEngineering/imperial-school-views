.class public final Lru/oopssre/imperialschool/viewstv/PlaybackPolicy;
.super Ljava/lang/Object;
.source "PlaybackPolicy.java"


# direct methods
.method public constructor <init>()V
    .locals 0

    .line 4
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method public static useVideo(ZLjava/lang/String;)Z
    .locals 0

    if-eqz p0, :cond_0

    .line 5
    const-string p0, "dynamic"

    invoke-virtual {p0, p1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p0

    if-eqz p0, :cond_0

    const/4 p0, 0x1

    return p0

    :cond_0
    const/4 p0, 0x0

    return p0
.end method
