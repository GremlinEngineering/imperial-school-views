.class public final Lru/oopssre/imperialschool/viewstv/HoldGate;
.super Ljava/lang/Object;
.source "HoldGate.java"


# static fields
.field public static final HOLD_MS:J = 0x3e8L


# instance fields
.field private down:J

.field private opened:Z

.field private pressed:Z


# direct methods
.method public constructor <init>()V
    .locals 0

    .line 4
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public down(J)V
    .locals 1

    .line 8
    iget-boolean v0, p0, Lru/oopssre/imperialschool/viewstv/HoldGate;->pressed:Z

    if-nez v0, :cond_0

    const/4 v0, 0x1

    iput-boolean v0, p0, Lru/oopssre/imperialschool/viewstv/HoldGate;->pressed:Z

    const/4 v0, 0x0

    iput-boolean v0, p0, Lru/oopssre/imperialschool/viewstv/HoldGate;->opened:Z

    iput-wide p1, p0, Lru/oopssre/imperialschool/viewstv/HoldGate;->down:J

    :cond_0
    return-void
.end method

.method public pressed()Z
    .locals 1

    .line 7
    iget-boolean v0, p0, Lru/oopssre/imperialschool/viewstv/HoldGate;->pressed:Z

    return v0
.end method

.method public release()V
    .locals 1

    const/4 v0, 0x0

    .line 10
    iput-boolean v0, p0, Lru/oopssre/imperialschool/viewstv/HoldGate;->pressed:Z

    iput-boolean v0, p0, Lru/oopssre/imperialschool/viewstv/HoldGate;->opened:Z

    return-void
.end method

.method public trigger(J)Z
    .locals 2

    .line 9
    iget-boolean v0, p0, Lru/oopssre/imperialschool/viewstv/HoldGate;->pressed:Z

    if-eqz v0, :cond_0

    iget-boolean v0, p0, Lru/oopssre/imperialschool/viewstv/HoldGate;->opened:Z

    if-nez v0, :cond_0

    iget-wide v0, p0, Lru/oopssre/imperialschool/viewstv/HoldGate;->down:J

    sub-long/2addr p1, v0

    const-wide/16 v0, 0x3e8

    cmp-long p1, p1, v0

    if-ltz p1, :cond_0

    const/4 p1, 0x1

    iput-boolean p1, p0, Lru/oopssre/imperialschool/viewstv/HoldGate;->opened:Z

    return p1

    :cond_0
    const/4 p1, 0x0

    return p1
.end method
