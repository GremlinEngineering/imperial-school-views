.class Lru/oopssre/imperialschool/viewstv/ProxyRouting$1;
.super Ljava/net/Authenticator;
.source "ProxyRouting.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lru/oopssre/imperialschool/viewstv/ProxyRouting;->install()V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic this$0:Lru/oopssre/imperialschool/viewstv/ProxyRouting;


# direct methods
.method constructor <init>(Lru/oopssre/imperialschool/viewstv/ProxyRouting;)V
    .locals 0
    .annotation system Ldalvik/annotation/MethodParameters;
        accessFlags = {
            0x8010
        }
        names = {
            null
        }
    .end annotation

    .line 45
    iput-object p1, p0, Lru/oopssre/imperialschool/viewstv/ProxyRouting$1;->this$0:Lru/oopssre/imperialschool/viewstv/ProxyRouting;

    invoke-direct {p0}, Ljava/net/Authenticator;-><init>()V

    return-void
.end method


# virtual methods
.method protected getPasswordAuthentication()Ljava/net/PasswordAuthentication;
    .locals 3

    .line 47
    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/ProxyRouting$1;->this$0:Lru/oopssre/imperialschool/viewstv/ProxyRouting;

    invoke-static {v0}, Lru/oopssre/imperialschool/viewstv/ProxyRouting;->access$000(Lru/oopssre/imperialschool/viewstv/ProxyRouting;)Lru/oopssre/imperialschool/viewstv/ProxyRouting$Route;

    move-result-object v0

    iget-object v0, v0, Lru/oopssre/imperialschool/viewstv/ProxyRouting$Route;->tunnel:Lru/oopssre/imperialschool/viewstv/ProxyTunnel;

    if-eqz v0, :cond_0

    .line 48
    invoke-virtual {p0}, Lru/oopssre/imperialschool/viewstv/ProxyRouting$1;->getRequestorType()Ljava/net/Authenticator$RequestorType;

    move-result-object v1

    sget-object v2, Ljava/net/Authenticator$RequestorType;->PROXY:Ljava/net/Authenticator$RequestorType;

    if-ne v1, v2, :cond_0

    .line 49
    invoke-virtual {p0}, Lru/oopssre/imperialschool/viewstv/ProxyRouting$1;->getRequestingSite()Ljava/net/InetAddress;

    move-result-object v1

    invoke-virtual {p0}, Lru/oopssre/imperialschool/viewstv/ProxyRouting$1;->getRequestingPort()I

    move-result v2

    invoke-virtual {v0, v1, v2}, Lru/oopssre/imperialschool/viewstv/ProxyTunnel;->credentials(Ljava/net/InetAddress;I)Ljava/net/PasswordAuthentication;

    move-result-object v0

    return-object v0

    :cond_0
    const/4 v0, 0x0

    return-object v0
.end method
