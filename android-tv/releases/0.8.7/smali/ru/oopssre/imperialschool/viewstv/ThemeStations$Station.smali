.class final Lru/oopssre/imperialschool/viewstv/ThemeStations$Station;
.super Ljava/lang/Object;
.source "ThemeStations.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lru/oopssre/imperialschool/viewstv/ThemeStations;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x18
    name = "Station"
.end annotation


# instance fields
.field final credit:Ljava/lang/String;

.field final id:Ljava/lang/String;

.field final personalOnly:Z

.field final title:Ljava/lang/String;

.field final url:Ljava/lang/String;


# direct methods
.method constructor <init>(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Z)V
    .locals 0

    .line 22
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 23
    iput-object p1, p0, Lru/oopssre/imperialschool/viewstv/ThemeStations$Station;->id:Ljava/lang/String;

    .line 24
    iput-object p2, p0, Lru/oopssre/imperialschool/viewstv/ThemeStations$Station;->title:Ljava/lang/String;

    .line 25
    iput-object p3, p0, Lru/oopssre/imperialschool/viewstv/ThemeStations$Station;->url:Ljava/lang/String;

    .line 26
    iput-object p4, p0, Lru/oopssre/imperialschool/viewstv/ThemeStations$Station;->credit:Ljava/lang/String;

    .line 27
    iput-boolean p5, p0, Lru/oopssre/imperialschool/viewstv/ThemeStations$Station;->personalOnly:Z

    return-void
.end method
