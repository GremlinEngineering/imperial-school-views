.class public final synthetic Lru/oopssre/imperialschool/viewstv/ProxyTunnel$$ExternalSyntheticLambda2;
.super Ljava/lang/Object;
.source "D8$$SyntheticClass"

# interfaces
.implements Ljava/lang/Runnable;


# instance fields
.field public final synthetic f$0:Lru/oopssre/imperialschool/viewstv/ProxyTunnel;

.field public final synthetic f$1:Ljava/net/Socket;


# direct methods
.method public synthetic constructor <init>(Lru/oopssre/imperialschool/viewstv/ProxyTunnel;Ljava/net/Socket;)V
    .locals 0

    .line 0
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    iput-object p1, p0, Lru/oopssre/imperialschool/viewstv/ProxyTunnel$$ExternalSyntheticLambda2;->f$0:Lru/oopssre/imperialschool/viewstv/ProxyTunnel;

    iput-object p2, p0, Lru/oopssre/imperialschool/viewstv/ProxyTunnel$$ExternalSyntheticLambda2;->f$1:Ljava/net/Socket;

    return-void
.end method


# virtual methods
.method public final run()V
    .locals 2

    .line 0
    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/ProxyTunnel$$ExternalSyntheticLambda2;->f$0:Lru/oopssre/imperialschool/viewstv/ProxyTunnel;

    iget-object v1, p0, Lru/oopssre/imperialschool/viewstv/ProxyTunnel$$ExternalSyntheticLambda2;->f$1:Ljava/net/Socket;

    invoke-virtual {v0, v1}, Lru/oopssre/imperialschool/viewstv/ProxyTunnel;->lambda$accept$1$ru-oopssre-imperialschool-viewstv-ProxyTunnel(Ljava/net/Socket;)V

    return-void
.end method
