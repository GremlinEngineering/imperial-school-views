.class final Lru/oopssre/imperialschool/viewstv/ProxyRouting;
.super Ljava/net/ProxySelector;
.source "ProxyRouting.java"


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lru/oopssre/imperialschool/viewstv/ProxyRouting$Route;
    }
.end annotation


# static fields
.field private static final INSTANCE:Lru/oopssre/imperialschool/viewstv/ProxyRouting;

.field private static final PROJECT_HOST:Ljava/lang/String;

.field private static final UNAVAILABLE:Ljava/net/Proxy;


# instance fields
.field private installed:Z

.field private volatile route:Lru/oopssre/imperialschool/viewstv/ProxyRouting$Route;

.field private final system:Ljava/net/ProxySelector;


# direct methods
.method static constructor <clinit>()V
    .locals 5

    .line 9
    const-string v0, "https://games.oopssre.ru/assets/arcade/views/"

    invoke-static {v0}, Ljava/net/URI;->create(Ljava/lang/String;)Ljava/net/URI;

    move-result-object v0

    invoke-virtual {v0}, Ljava/net/URI;->getHost()Ljava/lang/String;

    move-result-object v0

    sput-object v0, Lru/oopssre/imperialschool/viewstv/ProxyRouting;->PROJECT_HOST:Ljava/lang/String;

    .line 10
    new-instance v0, Ljava/net/Proxy;

    sget-object v1, Ljava/net/Proxy$Type;->HTTP:Ljava/net/Proxy$Type;

    new-instance v2, Ljava/net/InetSocketAddress;

    const-string v3, "127.0.0.1"

    const/4 v4, 0x0

    invoke-direct {v2, v3, v4}, Ljava/net/InetSocketAddress;-><init>(Ljava/lang/String;I)V

    invoke-direct {v0, v1, v2}, Ljava/net/Proxy;-><init>(Ljava/net/Proxy$Type;Ljava/net/SocketAddress;)V

    sput-object v0, Lru/oopssre/imperialschool/viewstv/ProxyRouting;->UNAVAILABLE:Ljava/net/Proxy;

    .line 11
    new-instance v0, Lru/oopssre/imperialschool/viewstv/ProxyRouting;

    invoke-direct {v0}, Lru/oopssre/imperialschool/viewstv/ProxyRouting;-><init>()V

    sput-object v0, Lru/oopssre/imperialschool/viewstv/ProxyRouting;->INSTANCE:Lru/oopssre/imperialschool/viewstv/ProxyRouting;

    return-void
.end method

.method constructor <init>()V
    .locals 2

    .line 8
    invoke-direct {p0}, Ljava/net/ProxySelector;-><init>()V

    .line 12
    invoke-static {}, Ljava/net/ProxySelector;->getDefault()Ljava/net/ProxySelector;

    move-result-object v0

    iput-object v0, p0, Lru/oopssre/imperialschool/viewstv/ProxyRouting;->system:Ljava/net/ProxySelector;

    .line 13
    new-instance v0, Lru/oopssre/imperialschool/viewstv/ProxyRouting$Route;

    const/4 v1, 0x0

    invoke-direct {v0, v1, v1}, Lru/oopssre/imperialschool/viewstv/ProxyRouting$Route;-><init>(Lru/oopssre/imperialschool/viewstv/ProxyOptions;Lru/oopssre/imperialschool/viewstv/ProxyTunnel;)V

    iput-object v0, p0, Lru/oopssre/imperialschool/viewstv/ProxyRouting;->route:Lru/oopssre/imperialschool/viewstv/ProxyRouting$Route;

    return-void
.end method

.method static synthetic access$000(Lru/oopssre/imperialschool/viewstv/ProxyRouting;)Lru/oopssre/imperialschool/viewstv/ProxyRouting$Route;
    .locals 0

    .line 8
    iget-object p0, p0, Lru/oopssre/imperialschool/viewstv/ProxyRouting;->route:Lru/oopssre/imperialschool/viewstv/ProxyRouting$Route;

    return-object p0
.end method

.method static declared-synchronized apply(Lru/oopssre/imperialschool/viewstv/ProxyOptions;)V
    .locals 5
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/io/IOException;
        }
    .end annotation

    const-class v0, Lru/oopssre/imperialschool/viewstv/ProxyRouting;

    monitor-enter v0

    .line 27
    :try_start_0
    sget-object v1, Lru/oopssre/imperialschool/viewstv/ProxyRouting;->INSTANCE:Lru/oopssre/imperialschool/viewstv/ProxyRouting;

    .line 28
    iget-object v2, v1, Lru/oopssre/imperialschool/viewstv/ProxyRouting;->route:Lru/oopssre/imperialschool/viewstv/ProxyRouting$Route;

    .line 30
    invoke-virtual {p0}, Lru/oopssre/imperialschool/viewstv/ProxyOptions;->enabled()Z

    move-result v3

    if-eqz v3, :cond_1

    .line 31
    iget-object v3, v2, Lru/oopssre/imperialschool/viewstv/ProxyRouting$Route;->tunnel:Lru/oopssre/imperialschool/viewstv/ProxyTunnel;

    if-eqz v3, :cond_0

    iget-object v3, v2, Lru/oopssre/imperialschool/viewstv/ProxyRouting$Route;->options:Lru/oopssre/imperialschool/viewstv/ProxyOptions;

    invoke-virtual {p0, v3}, Lru/oopssre/imperialschool/viewstv/ProxyOptions;->sameServer(Lru/oopssre/imperialschool/viewstv/ProxyOptions;)Z

    move-result v3

    if-eqz v3, :cond_0

    iget-object v3, v2, Lru/oopssre/imperialschool/viewstv/ProxyRouting$Route;->tunnel:Lru/oopssre/imperialschool/viewstv/ProxyTunnel;

    goto :goto_0

    :cond_0
    new-instance v3, Lru/oopssre/imperialschool/viewstv/ProxyTunnel;

    invoke-direct {v3, p0}, Lru/oopssre/imperialschool/viewstv/ProxyTunnel;-><init>(Lru/oopssre/imperialschool/viewstv/ProxyOptions;)V

    .line 32
    :goto_0
    invoke-direct {v1}, Lru/oopssre/imperialschool/viewstv/ProxyRouting;->install()V

    goto :goto_1

    :cond_1
    const/4 v3, 0x0

    .line 34
    :goto_1
    new-instance v4, Lru/oopssre/imperialschool/viewstv/ProxyRouting$Route;

    invoke-direct {v4, p0, v3}, Lru/oopssre/imperialschool/viewstv/ProxyRouting$Route;-><init>(Lru/oopssre/imperialschool/viewstv/ProxyOptions;Lru/oopssre/imperialschool/viewstv/ProxyTunnel;)V

    iput-object v4, v1, Lru/oopssre/imperialschool/viewstv/ProxyRouting;->route:Lru/oopssre/imperialschool/viewstv/ProxyRouting$Route;

    .line 35
    iget-object p0, v2, Lru/oopssre/imperialschool/viewstv/ProxyRouting$Route;->tunnel:Lru/oopssre/imperialschool/viewstv/ProxyTunnel;

    if-eqz p0, :cond_2

    iget-object p0, v2, Lru/oopssre/imperialschool/viewstv/ProxyRouting$Route;->tunnel:Lru/oopssre/imperialschool/viewstv/ProxyTunnel;

    if-eq p0, v3, :cond_2

    iget-object p0, v2, Lru/oopssre/imperialschool/viewstv/ProxyRouting$Route;->tunnel:Lru/oopssre/imperialschool/viewstv/ProxyTunnel;

    invoke-virtual {p0}, Lru/oopssre/imperialschool/viewstv/ProxyTunnel;->close()V
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 36
    :cond_2
    monitor-exit v0

    return-void

    :catchall_0
    move-exception p0

    :try_start_1
    monitor-exit v0
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    throw p0
.end method

.method private install()V
    .locals 1

    .line 44
    iget-boolean v0, p0, Lru/oopssre/imperialschool/viewstv/ProxyRouting;->installed:Z

    if-eqz v0, :cond_0

    return-void

    .line 45
    :cond_0
    new-instance v0, Lru/oopssre/imperialschool/viewstv/ProxyRouting$1;

    invoke-direct {v0, p0}, Lru/oopssre/imperialschool/viewstv/ProxyRouting$1;-><init>(Lru/oopssre/imperialschool/viewstv/ProxyRouting;)V

    invoke-static {v0}, Ljava/net/Authenticator;->setDefault(Ljava/net/Authenticator;)V

    .line 52
    invoke-static {p0}, Ljava/net/ProxySelector;->setDefault(Ljava/net/ProxySelector;)V

    const/4 v0, 0x1

    .line 53
    iput-boolean v0, p0, Lru/oopssre/imperialschool/viewstv/ProxyRouting;->installed:Z

    return-void
.end method

.method private static isExternalHttps(Ljava/net/URI;)Z
    .locals 2

    .line 78
    const-string v0, "https"

    invoke-virtual {p0}, Ljava/net/URI;->getScheme()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Ljava/lang/String;->equalsIgnoreCase(Ljava/lang/String;)Z

    move-result v0

    if-eqz v0, :cond_0

    invoke-virtual {p0}, Ljava/net/URI;->getHost()Ljava/lang/String;

    move-result-object v0

    if-eqz v0, :cond_0

    sget-object v0, Lru/oopssre/imperialschool/viewstv/ProxyRouting;->PROJECT_HOST:Ljava/lang/String;

    .line 79
    invoke-virtual {p0}, Ljava/net/URI;->getHost()Ljava/lang/String;

    move-result-object p0

    invoke-virtual {v0, p0}, Ljava/lang/String;->equalsIgnoreCase(Ljava/lang/String;)Z

    move-result p0

    if-nez p0, :cond_0

    const/4 p0, 0x1

    return p0

    :cond_0
    const/4 p0, 0x0

    return p0
.end method

.method private static localProxy(Lru/oopssre/imperialschool/viewstv/ProxyRouting$Route;)Ljava/net/Proxy;
    .locals 1

    .line 74
    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/ProxyRouting$Route;->tunnel:Lru/oopssre/imperialschool/viewstv/ProxyTunnel;

    if-nez v0, :cond_0

    sget-object p0, Lru/oopssre/imperialschool/viewstv/ProxyRouting;->UNAVAILABLE:Ljava/net/Proxy;

    return-object p0

    :cond_0
    iget-object p0, p0, Lru/oopssre/imperialschool/viewstv/ProxyRouting$Route;->tunnel:Lru/oopssre/imperialschool/viewstv/ProxyTunnel;

    invoke-virtual {p0}, Lru/oopssre/imperialschool/viewstv/ProxyTunnel;->route()Ljava/net/Proxy;

    move-result-object p0

    return-object p0
.end method

.method static openHttp(Ljava/net/URI;)Ljava/net/HttpURLConnection;
    .locals 3
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/io/IOException;
        }
    .end annotation

    .line 66
    sget-object v0, Lru/oopssre/imperialschool/viewstv/ProxyRouting;->PROJECT_HOST:Ljava/lang/String;

    invoke-virtual {p0}, Ljava/net/URI;->getHost()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Ljava/lang/String;->equalsIgnoreCase(Ljava/lang/String;)Z

    move-result v0

    if-eqz v0, :cond_0

    invoke-virtual {p0}, Ljava/net/URI;->toURL()Ljava/net/URL;

    move-result-object p0

    invoke-virtual {p0}, Ljava/net/URL;->openConnection()Ljava/net/URLConnection;

    move-result-object p0

    check-cast p0, Ljava/net/HttpURLConnection;

    return-object p0

    .line 67
    :cond_0
    sget-object v0, Lru/oopssre/imperialschool/viewstv/ProxyRouting;->INSTANCE:Lru/oopssre/imperialschool/viewstv/ProxyRouting;

    iget-object v1, v0, Lru/oopssre/imperialschool/viewstv/ProxyRouting;->route:Lru/oopssre/imperialschool/viewstv/ProxyRouting$Route;

    .line 68
    invoke-static {p0}, Lru/oopssre/imperialschool/viewstv/ProxyRouting;->isExternalHttps(Ljava/net/URI;)Z

    move-result v2

    if-eqz v2, :cond_1

    iget-object v2, v1, Lru/oopssre/imperialschool/viewstv/ProxyRouting$Route;->options:Lru/oopssre/imperialschool/viewstv/ProxyOptions;

    if-eqz v2, :cond_1

    iget-object v2, v1, Lru/oopssre/imperialschool/viewstv/ProxyRouting$Route;->options:Lru/oopssre/imperialschool/viewstv/ProxyOptions;

    iget-boolean v2, v2, Lru/oopssre/imperialschool/viewstv/ProxyOptions;->external:Z

    if-eqz v2, :cond_1

    .line 69
    invoke-static {v1}, Lru/oopssre/imperialschool/viewstv/ProxyRouting;->localProxy(Lru/oopssre/imperialschool/viewstv/ProxyRouting$Route;)Ljava/net/Proxy;

    move-result-object v0

    goto :goto_0

    :cond_1
    invoke-direct {v0, p0}, Lru/oopssre/imperialschool/viewstv/ProxyRouting;->systemRoutes(Ljava/net/URI;)Ljava/util/List;

    move-result-object v0

    const/4 v1, 0x0

    invoke-interface {v0, v1}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Ljava/net/Proxy;

    .line 70
    :goto_0
    invoke-virtual {p0}, Ljava/net/URI;->toURL()Ljava/net/URL;

    move-result-object p0

    invoke-virtual {p0, v0}, Ljava/net/URL;->openConnection(Ljava/net/Proxy;)Ljava/net/URLConnection;

    move-result-object p0

    check-cast p0, Ljava/net/HttpURLConnection;

    return-object p0
.end method

.method private systemRoutes(Ljava/net/URI;)Ljava/util/List;
    .locals 1
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/net/URI;",
            ")",
            "Ljava/util/List<",
            "Ljava/net/Proxy;",
            ">;"
        }
    .end annotation

    .line 83
    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/ProxyRouting;->system:Ljava/net/ProxySelector;

    if-nez v0, :cond_0

    const/4 p1, 0x0

    goto :goto_0

    :cond_0
    invoke-virtual {v0, p1}, Ljava/net/ProxySelector;->select(Ljava/net/URI;)Ljava/util/List;

    move-result-object p1

    :goto_0
    if-eqz p1, :cond_2

    .line 84
    invoke-interface {p1}, Ljava/util/List;->isEmpty()Z

    move-result v0

    if-eqz v0, :cond_1

    goto :goto_1

    :cond_1
    return-object p1

    :cond_2
    :goto_1
    sget-object p1, Ljava/net/Proxy;->NO_PROXY:Ljava/net/Proxy;

    invoke-static {p1}, Ljava/util/Collections;->singletonList(Ljava/lang/Object;)Ljava/util/List;

    move-result-object p1

    return-object p1
.end method

.method static declared-synchronized unavailable(Lru/oopssre/imperialschool/viewstv/ProxyOptions;)V
    .locals 4

    const-class v0, Lru/oopssre/imperialschool/viewstv/ProxyRouting;

    monitor-enter v0

    .line 39
    :try_start_0
    sget-object v1, Lru/oopssre/imperialschool/viewstv/ProxyRouting;->INSTANCE:Lru/oopssre/imperialschool/viewstv/ProxyRouting;

    invoke-direct {v1}, Lru/oopssre/imperialschool/viewstv/ProxyRouting;->install()V

    .line 40
    new-instance v2, Lru/oopssre/imperialschool/viewstv/ProxyRouting$Route;

    const/4 v3, 0x0

    invoke-direct {v2, p0, v3}, Lru/oopssre/imperialschool/viewstv/ProxyRouting$Route;-><init>(Lru/oopssre/imperialschool/viewstv/ProxyOptions;Lru/oopssre/imperialschool/viewstv/ProxyTunnel;)V

    iput-object v2, v1, Lru/oopssre/imperialschool/viewstv/ProxyRouting;->route:Lru/oopssre/imperialschool/viewstv/ProxyRouting$Route;
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 41
    monitor-exit v0

    return-void

    :catchall_0
    move-exception p0

    :try_start_1
    monitor-exit v0
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    throw p0
.end method


# virtual methods
.method public connectFailed(Ljava/net/URI;Ljava/net/SocketAddress;Ljava/io/IOException;)V
    .locals 1

    .line 88
    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/ProxyRouting;->route:Lru/oopssre/imperialschool/viewstv/ProxyRouting$Route;

    .line 89
    invoke-static {v0}, Lru/oopssre/imperialschool/viewstv/ProxyRouting;->localProxy(Lru/oopssre/imperialschool/viewstv/ProxyRouting$Route;)Ljava/net/Proxy;

    move-result-object v0

    invoke-virtual {v0}, Ljava/net/Proxy;->address()Ljava/net/SocketAddress;

    move-result-object v0

    invoke-virtual {v0, p2}, Ljava/lang/Object;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_0

    goto :goto_0

    .line 90
    :cond_0
    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/ProxyRouting;->system:Ljava/net/ProxySelector;

    if-eqz v0, :cond_1

    invoke-virtual {v0, p1, p2, p3}, Ljava/net/ProxySelector;->connectFailed(Ljava/net/URI;Ljava/net/SocketAddress;Ljava/io/IOException;)V

    :cond_1
    :goto_0
    return-void
.end method

.method public select(Ljava/net/URI;)Ljava/util/List;
    .locals 2
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/net/URI;",
            ")",
            "Ljava/util/List<",
            "Ljava/net/Proxy;",
            ">;"
        }
    .end annotation

    .line 58
    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/ProxyRouting;->route:Lru/oopssre/imperialschool/viewstv/ProxyRouting$Route;

    .line 59
    invoke-static {p1}, Lru/oopssre/imperialschool/viewstv/ProxyRouting;->isExternalHttps(Ljava/net/URI;)Z

    move-result v1

    if-eqz v1, :cond_0

    iget-object v1, v0, Lru/oopssre/imperialschool/viewstv/ProxyRouting$Route;->options:Lru/oopssre/imperialschool/viewstv/ProxyOptions;

    if-eqz v1, :cond_0

    iget-object v1, v0, Lru/oopssre/imperialschool/viewstv/ProxyRouting$Route;->options:Lru/oopssre/imperialschool/viewstv/ProxyOptions;

    iget-boolean v1, v1, Lru/oopssre/imperialschool/viewstv/ProxyOptions;->radio:Z

    if-eqz v1, :cond_0

    .line 60
    invoke-static {v0}, Lru/oopssre/imperialschool/viewstv/ProxyRouting;->localProxy(Lru/oopssre/imperialschool/viewstv/ProxyRouting$Route;)Ljava/net/Proxy;

    move-result-object p1

    invoke-static {p1}, Ljava/util/Collections;->singletonList(Ljava/lang/Object;)Ljava/util/List;

    move-result-object p1

    return-object p1

    .line 61
    :cond_0
    invoke-direct {p0, p1}, Lru/oopssre/imperialschool/viewstv/ProxyRouting;->systemRoutes(Ljava/net/URI;)Ljava/util/List;

    move-result-object p1

    return-object p1
.end method
