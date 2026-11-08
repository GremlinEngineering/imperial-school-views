.class final Lru/oopssre/imperialschool/viewstv/ProxyRouting$Route;
.super Ljava/lang/Object;
.source "ProxyRouting.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lru/oopssre/imperialschool/viewstv/ProxyRouting;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x1a
    name = "Route"
.end annotation


# instance fields
.field final options:Lru/oopssre/imperialschool/viewstv/ProxyOptions;

.field final tunnel:Lru/oopssre/imperialschool/viewstv/ProxyTunnel;


# direct methods
.method constructor <init>(Lru/oopssre/imperialschool/viewstv/ProxyOptions;Lru/oopssre/imperialschool/viewstv/ProxyTunnel;)V
    .locals 0

    .line 20
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 21
    iput-object p1, p0, Lru/oopssre/imperialschool/viewstv/ProxyRouting$Route;->options:Lru/oopssre/imperialschool/viewstv/ProxyOptions;

    .line 22
    iput-object p2, p0, Lru/oopssre/imperialschool/viewstv/ProxyRouting$Route;->tunnel:Lru/oopssre/imperialschool/viewstv/ProxyTunnel;

    return-void
.end method
