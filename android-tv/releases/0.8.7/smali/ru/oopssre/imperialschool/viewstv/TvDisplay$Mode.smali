.class public final Lru/oopssre/imperialschool/viewstv/TvDisplay$Mode;
.super Ljava/lang/Object;
.source "TvDisplay.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lru/oopssre/imperialschool/viewstv/TvDisplay;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x19
    name = "Mode"
.end annotation


# instance fields
.field public final height:I

.field public final hz:F

.field public final id:I

.field public final width:I


# direct methods
.method public constructor <init>(IIIF)V
    .locals 0

    .line 16
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    iput p1, p0, Lru/oopssre/imperialschool/viewstv/TvDisplay$Mode;->id:I

    iput p2, p0, Lru/oopssre/imperialschool/viewstv/TvDisplay$Mode;->width:I

    iput p3, p0, Lru/oopssre/imperialschool/viewstv/TvDisplay$Mode;->height:I

    iput p4, p0, Lru/oopssre/imperialschool/viewstv/TvDisplay$Mode;->hz:F

    return-void
.end method
