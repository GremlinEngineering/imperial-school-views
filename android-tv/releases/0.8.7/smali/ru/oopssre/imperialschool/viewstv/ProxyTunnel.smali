.class final Lru/oopssre/imperialschool/viewstv/ProxyTunnel;
.super Ljava/lang/Object;
.source "ProxyTunnel.java"

# interfaces
.implements Ljava/io/Closeable;


# static fields
.field private static final HANDSHAKE_MS:I = 0x1388

.field private static final LOCAL_USER:Ljava/lang/String; = "imperial-tv"

.field static final LOOPBACK:Ljava/lang/String; = "127.0.0.1"

.field private static final MAX_HEADER:I = 0x4000

.field private static final UPSTREAM_IDLE_MS:I = 0x7530


# instance fields
.field private final active:Ljava/util/Set;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/Set<",
            "Ljava/net/Socket;",
            ">;"
        }
    .end annotation
.end field

.field private closed:Z

.field private final localAuthorization:Ljava/lang/String;

.field private final options:Lru/oopssre/imperialschool/viewstv/ProxyOptions;

.field private final server:Ljava/net/ServerSocket;

.field private final slots:Ljava/util/concurrent/Semaphore;

.field private final token:Ljava/lang/String;

.field private final workers:Ljava/util/concurrent/ExecutorService;


# direct methods
.method public static synthetic $r8$lambda$Pw0sxQU9gT_gb2-unB70h0TLUoo(Ljava/net/Socket;)Z
    .locals 0

    invoke-virtual {p0}, Ljava/net/Socket;->isClosed()Z

    move-result p0

    return p0
.end method

.method public static synthetic $r8$lambda$wZoly5d24xCTUlRNAbh4L1xrm3g(Lru/oopssre/imperialschool/viewstv/ProxyTunnel;)V
    .locals 0

    invoke-direct {p0}, Lru/oopssre/imperialschool/viewstv/ProxyTunnel;->accept()V

    return-void
.end method

.method constructor <init>(Lru/oopssre/imperialschool/viewstv/ProxyOptions;)V
    .locals 4
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/io/IOException;
        }
    .end annotation

    .line 35
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 22
    invoke-static {}, Ljava/util/UUID;->randomUUID()Ljava/util/UUID;

    move-result-object v0

    invoke-virtual {v0}, Ljava/util/UUID;->toString()Ljava/lang/String;

    move-result-object v0

    iput-object v0, p0, Lru/oopssre/imperialschool/viewstv/ProxyTunnel;->token:Ljava/lang/String;

    .line 23
    const-string v1, "imperial-tv"

    invoke-static {v1, v0}, Lru/oopssre/imperialschool/viewstv/ProxyTunnel;->basic(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    iput-object v0, p0, Lru/oopssre/imperialschool/viewstv/ProxyTunnel;->localAuthorization:Ljava/lang/String;

    .line 26
    new-instance v0, Ljava/util/concurrent/Semaphore;

    const/16 v1, 0xc

    invoke-direct {v0, v1}, Ljava/util/concurrent/Semaphore;-><init>(I)V

    iput-object v0, p0, Lru/oopssre/imperialschool/viewstv/ProxyTunnel;->slots:Ljava/util/concurrent/Semaphore;

    .line 27
    new-instance v0, Ljava/util/HashSet;

    invoke-direct {v0}, Ljava/util/HashSet;-><init>()V

    iput-object v0, p0, Lru/oopssre/imperialschool/viewstv/ProxyTunnel;->active:Ljava/util/Set;

    .line 28
    new-instance v0, Lru/oopssre/imperialschool/viewstv/ProxyTunnel$$ExternalSyntheticLambda0;

    invoke-direct {v0}, Lru/oopssre/imperialschool/viewstv/ProxyTunnel$$ExternalSyntheticLambda0;-><init>()V

    invoke-static {v0}, Ljava/util/concurrent/Executors;->newCachedThreadPool(Ljava/util/concurrent/ThreadFactory;)Ljava/util/concurrent/ExecutorService;

    move-result-object v0

    iput-object v0, p0, Lru/oopssre/imperialschool/viewstv/ProxyTunnel;->workers:Ljava/util/concurrent/ExecutorService;

    .line 36
    iput-object p1, p0, Lru/oopssre/imperialschool/viewstv/ProxyTunnel;->options:Lru/oopssre/imperialschool/viewstv/ProxyOptions;

    .line 37
    new-instance p1, Ljava/net/ServerSocket;

    const-string v2, "127.0.0.1"

    invoke-static {v2}, Ljava/net/InetAddress;->getByName(Ljava/lang/String;)Ljava/net/InetAddress;

    move-result-object v2

    const/4 v3, 0x0

    invoke-direct {p1, v3, v1, v2}, Ljava/net/ServerSocket;-><init>(IILjava/net/InetAddress;)V

    iput-object p1, p0, Lru/oopssre/imperialschool/viewstv/ProxyTunnel;->server:Ljava/net/ServerSocket;

    .line 38
    new-instance p1, Lru/oopssre/imperialschool/viewstv/ProxyTunnel$$ExternalSyntheticLambda1;

    invoke-direct {p1, p0}, Lru/oopssre/imperialschool/viewstv/ProxyTunnel$$ExternalSyntheticLambda1;-><init>(Lru/oopssre/imperialschool/viewstv/ProxyTunnel;)V

    invoke-interface {v0, p1}, Ljava/util/concurrent/ExecutorService;->execute(Ljava/lang/Runnable;)V

    return-void
.end method

.method private accept()V
    .locals 3

    .line 52
    :goto_0
    :try_start_0
    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/ProxyTunnel;->server:Ljava/net/ServerSocket;

    invoke-virtual {v0}, Ljava/net/ServerSocket;->isClosed()Z

    move-result v0

    if-nez v0, :cond_2

    .line 53
    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/ProxyTunnel;->server:Ljava/net/ServerSocket;

    invoke-virtual {v0}, Ljava/net/ServerSocket;->accept()Ljava/net/Socket;

    move-result-object v0

    .line 54
    iget-object v1, p0, Lru/oopssre/imperialschool/viewstv/ProxyTunnel;->slots:Ljava/util/concurrent/Semaphore;

    invoke-virtual {v1}, Ljava/util/concurrent/Semaphore;->tryAcquire()Z

    move-result v1

    if-nez v1, :cond_0

    .line 55
    invoke-static {v0}, Lru/oopssre/imperialschool/viewstv/ProxyTunnel;->close(Ljava/io/Closeable;)V

    goto :goto_0

    .line 58
    :cond_0
    monitor-enter p0
    :try_end_0
    .catch Ljava/io/IOException; {:try_start_0 .. :try_end_0} :catch_0

    .line 59
    :try_start_1
    iget-boolean v1, p0, Lru/oopssre/imperialschool/viewstv/ProxyTunnel;->closed:Z

    if-eqz v1, :cond_1

    invoke-static {v0}, Lru/oopssre/imperialschool/viewstv/ProxyTunnel;->close(Ljava/io/Closeable;)V

    monitor-exit p0

    return-void

    .line 60
    :cond_1
    iget-object v1, p0, Lru/oopssre/imperialschool/viewstv/ProxyTunnel;->active:Ljava/util/Set;

    invoke-interface {v1, v0}, Ljava/util/Set;->add(Ljava/lang/Object;)Z

    .line 61
    iget-object v1, p0, Lru/oopssre/imperialschool/viewstv/ProxyTunnel;->workers:Ljava/util/concurrent/ExecutorService;

    new-instance v2, Lru/oopssre/imperialschool/viewstv/ProxyTunnel$$ExternalSyntheticLambda2;

    invoke-direct {v2, p0, v0}, Lru/oopssre/imperialschool/viewstv/ProxyTunnel$$ExternalSyntheticLambda2;-><init>(Lru/oopssre/imperialschool/viewstv/ProxyTunnel;Ljava/net/Socket;)V

    invoke-interface {v1, v2}, Ljava/util/concurrent/ExecutorService;->execute(Ljava/lang/Runnable;)V

    .line 62
    monitor-exit p0

    goto :goto_0

    :catchall_0
    move-exception v0

    monitor-exit p0
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    :try_start_2
    throw v0
    :try_end_2
    .catch Ljava/io/IOException; {:try_start_2 .. :try_end_2} :catch_0

    :cond_2
    return-void

    .line 65
    :catch_0
    invoke-virtual {p0}, Lru/oopssre/imperialschool/viewstv/ProxyTunnel;->close()V

    return-void
.end method

.method private static basic(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;
    .locals 3

    .line 193
    new-instance v0, Ljava/lang/StringBuilder;

    const-string v1, "Basic "

    invoke-direct {v0, v1}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-static {}, Ljava/util/Base64;->getEncoder()Ljava/util/Base64$Encoder;

    move-result-object v1

    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v2, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p0

    const-string v2, ":"

    invoke-virtual {p0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p0

    invoke-virtual {p0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p0

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    sget-object p1, Ljava/nio/charset/StandardCharsets;->UTF_8:Ljava/nio/charset/Charset;

    invoke-virtual {p0, p1}, Ljava/lang/String;->getBytes(Ljava/nio/charset/Charset;)[B

    move-result-object p0

    invoke-virtual {v1, p0}, Ljava/util/Base64$Encoder;->encodeToString([B)Ljava/lang/String;

    move-result-object p0

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p0

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method

.method private static close(Ljava/io/Closeable;)V
    .locals 0

    .line 244
    :try_start_0
    invoke-interface {p0}, Ljava/io/Closeable;->close()V
    :try_end_0
    .catch Ljava/io/IOException; {:try_start_0 .. :try_end_0} :catch_0

    :catch_0
    return-void
.end method

.method private static copy(Ljava/io/InputStream;Ljava/io/OutputStream;)V
    .locals 3
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/io/IOException;
        }
    .end annotation

    const/16 v0, 0x4000

    .line 239
    new-array v0, v0, [B

    .line 240
    :goto_0
    invoke-virtual {p0, v0}, Ljava/io/InputStream;->read([B)I

    move-result v1

    const/4 v2, -0x1

    if-eq v1, v2, :cond_0

    const/4 v2, 0x0

    invoke-virtual {p1, v0, v2, v1}, Ljava/io/OutputStream;->write([BII)V

    goto :goto_0

    :cond_0
    return-void
.end method

.method private static field(Ljava/io/DataOutputStream;[B)V
    .locals 2
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/io/IOException;
        }
    .end annotation

    .line 187
    array-length v0, p1

    if-eqz v0, :cond_0

    array-length v0, p1

    const/16 v1, 0xff

    if-gt v0, v1, :cond_0

    .line 188
    array-length v0, p1

    invoke-virtual {p0, v0}, Ljava/io/DataOutputStream;->writeByte(I)V

    .line 189
    invoke-virtual {p0, p1}, Ljava/io/DataOutputStream;->write([B)V

    return-void

    .line 187
    :cond_0
    new-instance p0, Ljava/io/IOException;

    const-string p1, "Invalid SOCKS5 field"

    invoke-direct {p0, p1}, Ljava/io/IOException;-><init>(Ljava/lang/String;)V

    throw p0
.end method

.method private static headers(Ljava/io/InputStream;Z)Ljava/lang/String;
    .locals 8
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/io/IOException;
        }
    .end annotation

    const/4 v0, 0x0

    .line 221
    const-string v1, ""

    .line 222
    :cond_0
    :goto_0
    invoke-static {p0}, Lru/oopssre/imperialschool/viewstv/ProxyTunnel;->line(Ljava/io/InputStream;)Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v2}, Ljava/lang/String;->isEmpty()Z

    move-result v3

    if-nez v3, :cond_2

    .line 223
    invoke-virtual {v2}, Ljava/lang/String;->length()I

    move-result v3

    add-int/lit8 v3, v3, 0x2

    add-int/2addr v0, v3

    const/16 v3, 0x4000

    if-gt v0, v3, :cond_1

    if-eqz p1, :cond_0

    const/4 v6, 0x0

    const/16 v7, 0x14

    const/4 v3, 0x1

    const/4 v4, 0x0

    .line 225
    const-string v5, "Proxy-Authorization:"

    invoke-virtual/range {v2 .. v7}, Ljava/lang/String;->regionMatches(ZILjava/lang/String;II)Z

    move-result v3

    if-eqz v3, :cond_0

    const/16 v1, 0x14

    .line 226
    invoke-virtual {v2, v1}, Ljava/lang/String;->substring(I)Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v1}, Ljava/lang/String;->trim()Ljava/lang/String;

    move-result-object v1

    goto :goto_0

    .line 224
    :cond_1
    new-instance p0, Ljava/io/IOException;

    const-string p1, "Proxy header too large"

    invoke-direct {p0, p1}, Ljava/io/IOException;-><init>(Ljava/lang/String;)V

    throw p0

    :cond_2
    return-object v1
.end method

.method static synthetic lambda$new$0(Ljava/lang/Runnable;)Ljava/lang/Thread;
    .locals 2

    .line 29
    new-instance v0, Ljava/lang/Thread;

    const-string v1, "imperial-tv-proxy"

    invoke-direct {v0, p0, v1}, Ljava/lang/Thread;-><init>(Ljava/lang/Runnable;Ljava/lang/String;)V

    const/4 p0, 0x1

    .line 30
    invoke-virtual {v0, p0}, Ljava/lang/Thread;->setDaemon(Z)V

    return-object v0
.end method

.method static synthetic lambda$serve$2(Ljava/io/InputStream;Ljava/net/Socket;)V
    .locals 0

    .line 122
    invoke-static {p0, p1}, Lru/oopssre/imperialschool/viewstv/ProxyTunnel;->upload(Ljava/io/InputStream;Ljava/net/Socket;)V

    return-void
.end method

.method private static line(Ljava/io/InputStream;)Ljava/lang/String;
    .locals 4
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/io/IOException;
        }
    .end annotation

    .line 206
    new-instance v0, Ljava/io/ByteArrayOutputStream;

    invoke-direct {v0}, Ljava/io/ByteArrayOutputStream;-><init>()V

    .line 207
    :goto_0
    invoke-virtual {p0}, Ljava/io/InputStream;->read()I

    move-result v1

    const/4 v2, -0x1

    if-eq v1, v2, :cond_1

    invoke-virtual {v0}, Ljava/io/ByteArrayOutputStream;->size()I

    move-result v2

    const/16 v3, 0x4000

    if-ge v2, v3, :cond_1

    const/16 v2, 0xa

    if-ne v1, v2, :cond_0

    .line 209
    invoke-virtual {v0}, Ljava/io/ByteArrayOutputStream;->toByteArray()[B

    move-result-object p0

    .line 210
    array-length v0, p0

    if-lez v0, :cond_1

    array-length v0, p0

    add-int/lit8 v0, v0, -0x1

    aget-byte v0, p0, v0

    const/16 v1, 0xd

    if-ne v0, v1, :cond_1

    .line 211
    new-instance v0, Ljava/lang/String;

    array-length v1, p0

    add-int/lit8 v1, v1, -0x1

    sget-object v2, Ljava/nio/charset/StandardCharsets;->US_ASCII:Ljava/nio/charset/Charset;

    const/4 v3, 0x0

    invoke-direct {v0, p0, v3, v1, v2}, Ljava/lang/String;-><init>([BIILjava/nio/charset/Charset;)V

    return-object v0

    .line 214
    :cond_0
    invoke-virtual {v0, v1}, Ljava/io/ByteArrayOutputStream;->write(I)V

    goto :goto_0

    .line 216
    :cond_1
    new-instance p0, Ljava/io/IOException;

    const-string v0, "Invalid proxy header"

    invoke-direct {p0, v0}, Ljava/io/IOException;-><init>(Ljava/lang/String;)V

    throw p0
.end method

.method private openHttp(Ljava/io/InputStream;Ljava/io/OutputStream;Ljava/lang/String;)V
    .locals 4
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/io/IOException;
        }
    .end annotation

    .line 138
    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/ProxyTunnel;->options:Lru/oopssre/imperialschool/viewstv/ProxyOptions;

    iget-object v0, v0, Lru/oopssre/imperialschool/viewstv/ProxyOptions;->login:Ljava/lang/String;

    invoke-virtual {v0}, Ljava/lang/String;->isEmpty()Z

    move-result v0

    const-string v1, "\r\n"

    if-eqz v0, :cond_0

    const-string v0, ""

    goto :goto_0

    .line 139
    :cond_0
    new-instance v0, Ljava/lang/StringBuilder;

    const-string v2, "Proxy-Authorization: "

    invoke-direct {v0, v2}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    iget-object v2, p0, Lru/oopssre/imperialschool/viewstv/ProxyTunnel;->options:Lru/oopssre/imperialschool/viewstv/ProxyOptions;

    iget-object v2, v2, Lru/oopssre/imperialschool/viewstv/ProxyOptions;->login:Ljava/lang/String;

    iget-object v3, p0, Lru/oopssre/imperialschool/viewstv/ProxyTunnel;->options:Lru/oopssre/imperialschool/viewstv/ProxyOptions;

    iget-object v3, v3, Lru/oopssre/imperialschool/viewstv/ProxyOptions;->password:Ljava/lang/String;

    invoke-static {v2, v3}, Lru/oopssre/imperialschool/viewstv/ProxyTunnel;->basic(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    .line 140
    :goto_0
    new-instance v2, Ljava/lang/StringBuilder;

    const-string v3, "CONNECT "

    invoke-direct {v2, v3}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v2, p3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    const-string v3, " HTTP/1.1\r\nHost: "

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {v2, p3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p3

    invoke-virtual {p3, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p3

    invoke-virtual {p3, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p3

    invoke-virtual {p3, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p3

    invoke-virtual {p3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p3

    invoke-static {p2, p3}, Lru/oopssre/imperialschool/viewstv/ProxyTunnel;->write(Ljava/io/OutputStream;Ljava/lang/String;)V

    .line 141
    invoke-static {p1}, Lru/oopssre/imperialschool/viewstv/ProxyTunnel;->line(Ljava/io/InputStream;)Ljava/lang/String;

    move-result-object p2

    const/4 p3, 0x0

    .line 142
    invoke-static {p1, p3}, Lru/oopssre/imperialschool/viewstv/ProxyTunnel;->headers(Ljava/io/InputStream;Z)Ljava/lang/String;

    .line 143
    const-string p1, "HTTP/1\\.[01] 2[0-9]{2}( .*)?"

    invoke-virtual {p2, p1}, Ljava/lang/String;->matches(Ljava/lang/String;)Z

    move-result p1

    if-eqz p1, :cond_1

    return-void

    :cond_1
    new-instance p1, Ljava/io/IOException;

    const-string p2, "HTTP proxy rejected CONNECT"

    invoke-direct {p1, p2}, Ljava/io/IOException;-><init>(Ljava/lang/String;)V

    throw p1
.end method

.method private openSocks(Ljava/io/InputStream;Ljava/io/OutputStream;Ljava/lang/String;I)V
    .locals 7
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/io/IOException;
        }
    .end annotation

    .line 147
    new-instance v0, Ljava/io/DataInputStream;

    invoke-direct {v0, p1}, Ljava/io/DataInputStream;-><init>(Ljava/io/InputStream;)V

    .line 148
    new-instance p1, Ljava/io/DataOutputStream;

    invoke-direct {p1, p2}, Ljava/io/DataOutputStream;-><init>(Ljava/io/OutputStream;)V

    .line 149
    iget-object p2, p0, Lru/oopssre/imperialschool/viewstv/ProxyTunnel;->options:Lru/oopssre/imperialschool/viewstv/ProxyOptions;

    iget-object p2, p2, Lru/oopssre/imperialschool/viewstv/ProxyOptions;->login:Ljava/lang/String;

    invoke-virtual {p2}, Ljava/lang/String;->isEmpty()Z

    move-result p2

    const/4 v1, 0x0

    const/4 v2, 0x2

    if-eqz p2, :cond_0

    move p2, v1

    goto :goto_0

    :cond_0
    move p2, v2

    :goto_0
    int-to-byte v3, p2

    const/4 v4, 0x3

    .line 150
    new-array v5, v4, [B

    const/4 v6, 0x5

    aput-byte v6, v5, v1

    const/4 v1, 0x1

    aput-byte v1, v5, v1

    aput-byte v3, v5, v2

    invoke-virtual {p1, v5}, Ljava/io/DataOutputStream;->write([B)V

    .line 151
    invoke-virtual {p1}, Ljava/io/DataOutputStream;->flush()V

    .line 152
    invoke-virtual {v0}, Ljava/io/DataInputStream;->readUnsignedByte()I

    move-result v3

    if-ne v3, v6, :cond_9

    invoke-virtual {v0}, Ljava/io/DataInputStream;->readUnsignedByte()I

    move-result v3

    if-ne v3, p2, :cond_9

    if-ne p2, v2, :cond_2

    .line 154
    invoke-virtual {p1, v1}, Ljava/io/DataOutputStream;->writeByte(I)V

    .line 155
    iget-object p2, p0, Lru/oopssre/imperialschool/viewstv/ProxyTunnel;->options:Lru/oopssre/imperialschool/viewstv/ProxyOptions;

    iget-object p2, p2, Lru/oopssre/imperialschool/viewstv/ProxyOptions;->login:Ljava/lang/String;

    sget-object v3, Ljava/nio/charset/StandardCharsets;->UTF_8:Ljava/nio/charset/Charset;

    invoke-virtual {p2, v3}, Ljava/lang/String;->getBytes(Ljava/nio/charset/Charset;)[B

    move-result-object p2

    invoke-static {p1, p2}, Lru/oopssre/imperialschool/viewstv/ProxyTunnel;->field(Ljava/io/DataOutputStream;[B)V

    .line 156
    iget-object p2, p0, Lru/oopssre/imperialschool/viewstv/ProxyTunnel;->options:Lru/oopssre/imperialschool/viewstv/ProxyOptions;

    iget-object p2, p2, Lru/oopssre/imperialschool/viewstv/ProxyOptions;->password:Ljava/lang/String;

    sget-object v3, Ljava/nio/charset/StandardCharsets;->UTF_8:Ljava/nio/charset/Charset;

    invoke-virtual {p2, v3}, Ljava/lang/String;->getBytes(Ljava/nio/charset/Charset;)[B

    move-result-object p2

    invoke-static {p1, p2}, Lru/oopssre/imperialschool/viewstv/ProxyTunnel;->field(Ljava/io/DataOutputStream;[B)V

    .line 157
    invoke-virtual {p1}, Ljava/io/DataOutputStream;->flush()V

    .line 158
    invoke-virtual {v0}, Ljava/io/DataInputStream;->readUnsignedByte()I

    move-result p2

    if-ne p2, v1, :cond_1

    invoke-virtual {v0}, Ljava/io/DataInputStream;->readUnsignedByte()I

    move-result p2

    if-nez p2, :cond_1

    goto :goto_1

    :cond_1
    new-instance p1, Ljava/io/IOException;

    const-string p2, "SOCKS5 login rejected"

    invoke-direct {p1, p2}, Ljava/io/IOException;-><init>(Ljava/lang/String;)V

    throw p1

    .line 161
    :cond_2
    :goto_1
    new-array p2, v4, [B

    fill-array-data p2, :array_0

    invoke-virtual {p1, p2}, Ljava/io/DataOutputStream;->write([B)V

    const/16 p2, 0x3a

    .line 162
    invoke-virtual {p3, p2}, Ljava/lang/String;->indexOf(I)I

    move-result p2

    const/16 v3, 0x10

    const/4 v5, 0x4

    if-ltz p2, :cond_4

    .line 163
    invoke-static {p3}, Ljava/net/InetAddress;->getByName(Ljava/lang/String;)Ljava/net/InetAddress;

    move-result-object p2

    invoke-virtual {p2}, Ljava/net/InetAddress;->getAddress()[B

    move-result-object p2

    .line 164
    array-length p3, p2

    if-ne p3, v3, :cond_3

    .line 165
    invoke-virtual {p1, v5}, Ljava/io/DataOutputStream;->writeByte(I)V

    .line 166
    invoke-virtual {p1, p2}, Ljava/io/DataOutputStream;->write([B)V

    goto :goto_2

    .line 164
    :cond_3
    new-instance p1, Ljava/io/IOException;

    const-string p2, "Invalid IPv6 destination"

    invoke-direct {p1, p2}, Ljava/io/IOException;-><init>(Ljava/lang/String;)V

    throw p1

    .line 168
    :cond_4
    invoke-virtual {p1, v4}, Ljava/io/DataOutputStream;->writeByte(I)V

    .line 169
    sget-object p2, Ljava/nio/charset/StandardCharsets;->US_ASCII:Ljava/nio/charset/Charset;

    invoke-virtual {p3, p2}, Ljava/lang/String;->getBytes(Ljava/nio/charset/Charset;)[B

    move-result-object p2

    invoke-static {p1, p2}, Lru/oopssre/imperialschool/viewstv/ProxyTunnel;->field(Ljava/io/DataOutputStream;[B)V

    .line 171
    :goto_2
    invoke-virtual {p1, p4}, Ljava/io/DataOutputStream;->writeShort(I)V

    .line 172
    invoke-virtual {p1}, Ljava/io/DataOutputStream;->flush()V

    .line 173
    invoke-virtual {v0}, Ljava/io/DataInputStream;->readUnsignedByte()I

    move-result p1

    if-ne p1, v6, :cond_8

    invoke-virtual {v0}, Ljava/io/DataInputStream;->readUnsignedByte()I

    move-result p1

    if-nez p1, :cond_8

    invoke-virtual {v0}, Ljava/io/DataInputStream;->readUnsignedByte()I

    move-result p1

    if-nez p1, :cond_8

    .line 175
    invoke-virtual {v0}, Ljava/io/DataInputStream;->readUnsignedByte()I

    move-result p1

    if-eq p1, v1, :cond_7

    if-eq p1, v4, :cond_6

    if-ne p1, v5, :cond_5

    goto :goto_3

    .line 181
    :cond_5
    new-instance p1, Ljava/io/IOException;

    const-string p2, "Invalid SOCKS5 response"

    invoke-direct {p1, p2}, Ljava/io/IOException;-><init>(Ljava/lang/String;)V

    throw p1

    .line 179
    :cond_6
    invoke-virtual {v0}, Ljava/io/DataInputStream;->readUnsignedByte()I

    move-result v3

    goto :goto_3

    :cond_7
    move v3, v5

    :goto_3
    add-int/2addr v3, v2

    .line 183
    new-array p1, v3, [B

    invoke-virtual {v0, p1}, Ljava/io/DataInputStream;->readFully([B)V

    return-void

    .line 174
    :cond_8
    new-instance p1, Ljava/io/IOException;

    const-string p2, "SOCKS5 connection rejected"

    invoke-direct {p1, p2}, Ljava/io/IOException;-><init>(Ljava/lang/String;)V

    throw p1

    .line 152
    :cond_9
    new-instance p1, Ljava/io/IOException;

    const-string p2, "SOCKS5 method rejected"

    invoke-direct {p1, p2}, Ljava/io/IOException;-><init>(Ljava/lang/String;)V

    throw p1

    nop

    :array_0
    .array-data 1
        0x5t
        0x1t
        0x0t
    .end array-data
.end method

.method private static reply(Ljava/io/OutputStream;Ljava/lang/String;Ljava/lang/String;)V
    .locals 2
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/io/IOException;
        }
    .end annotation

    .line 197
    new-instance v0, Ljava/lang/StringBuilder;

    const-string v1, "HTTP/1.1 "

    invoke-direct {v0, v1}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p1

    const-string v0, "\r\n"

    invoke-virtual {p1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p1

    invoke-virtual {p1, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p1

    const-string p2, "Content-Length: 0\r\n\r\n"

    invoke-virtual {p1, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p1

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-static {p0, p1}, Lru/oopssre/imperialschool/viewstv/ProxyTunnel;->write(Ljava/io/OutputStream;Ljava/lang/String;)V

    return-void
.end method

.method private serve(Ljava/net/Socket;)V
    .locals 12

    .line 70
    :try_start_0
    new-instance v0, Ljava/net/Socket;

    invoke-direct {v0}, Ljava/net/Socket;-><init>()V
    :try_end_0
    .catch Ljava/io/IOException; {:try_start_0 .. :try_end_0} :catch_1
    .catch Ljava/lang/IllegalArgumentException; {:try_start_0 .. :try_end_0} :catch_1
    .catchall {:try_start_0 .. :try_end_0} :catchall_b

    const/16 v1, 0x1388

    .line 71
    :try_start_1
    invoke-virtual {p1, v1}, Ljava/net/Socket;->setSoTimeout(I)V

    .line 72
    new-instance v2, Ljava/io/BufferedInputStream;

    invoke-virtual {p1}, Ljava/net/Socket;->getInputStream()Ljava/io/InputStream;

    move-result-object v3

    invoke-direct {v2, v3}, Ljava/io/BufferedInputStream;-><init>(Ljava/io/InputStream;)V

    .line 73
    invoke-virtual {p1}, Ljava/net/Socket;->getOutputStream()Ljava/io/OutputStream;

    move-result-object v3

    const/4 v4, 0x0

    const/4 v5, 0x0

    move v6, v4

    :goto_0
    const/4 v7, 0x2

    const/4 v8, 0x1

    if-ge v6, v7, :cond_5

    .line 76
    invoke-static {v2}, Lru/oopssre/imperialschool/viewstv/ProxyTunnel;->line(Ljava/io/InputStream;)Ljava/lang/String;

    move-result-object v5

    const-string v7, " "

    const/4 v9, -0x1

    invoke-virtual {v5, v7, v9}, Ljava/lang/String;->split(Ljava/lang/String;I)[Ljava/lang/String;

    move-result-object v5

    .line 77
    invoke-static {v2, v8}, Lru/oopssre/imperialschool/viewstv/ProxyTunnel;->headers(Ljava/io/InputStream;Z)Ljava/lang/String;

    move-result-object v7

    .line 78
    array-length v9, v5

    const/4 v10, 0x3

    if-ne v9, v10, :cond_4

    const-string v9, "CONNECT"

    aget-object v10, v5, v4

    invoke-virtual {v9, v10}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v9

    if-nez v9, :cond_0

    goto :goto_3

    .line 82
    :cond_0
    iget-object v9, p0, Lru/oopssre/imperialschool/viewstv/ProxyTunnel;->localAuthorization:Ljava/lang/String;

    sget-object v10, Ljava/nio/charset/StandardCharsets;->US_ASCII:Ljava/nio/charset/Charset;

    invoke-virtual {v9, v10}, Ljava/lang/String;->getBytes(Ljava/nio/charset/Charset;)[B

    move-result-object v9

    sget-object v10, Ljava/nio/charset/StandardCharsets;->US_ASCII:Ljava/nio/charset/Charset;

    .line 83
    invoke-virtual {v7, v10}, Ljava/lang/String;->getBytes(Ljava/nio/charset/Charset;)[B

    move-result-object v7

    .line 82
    invoke-static {v9, v7}, Ljava/security/MessageDigest;->isEqual([B[B)Z

    move-result v7

    if-eqz v7, :cond_1

    goto :goto_4

    .line 85
    :cond_1
    const-string v7, "407 Proxy Authentication Required"

    new-instance v9, Ljava/lang/StringBuilder;

    invoke-direct {v9}, Ljava/lang/StringBuilder;-><init>()V

    const-string v10, "Proxy-Authenticate: Basic realm=\"Imperial TV\"\r\n"

    invoke-virtual {v9, v10}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v9

    if-ne v6, v8, :cond_2

    .line 87
    const-string v10, "Connection: close\r\n"

    goto :goto_1

    :cond_2
    const-string v10, ""

    :goto_1
    invoke-virtual {v9, v10}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v9

    invoke-virtual {v9}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v9

    .line 85
    invoke-static {v3, v7, v9}, Lru/oopssre/imperialschool/viewstv/ProxyTunnel;->reply(Ljava/io/OutputStream;Ljava/lang/String;Ljava/lang/String;)V
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_9

    if-ne v6, v8, :cond_3

    .line 125
    :try_start_2
    invoke-virtual {v0}, Ljava/net/Socket;->close()V
    :try_end_2
    .catch Ljava/io/IOException; {:try_start_2 .. :try_end_2} :catch_1
    .catch Ljava/lang/IllegalArgumentException; {:try_start_2 .. :try_end_2} :catch_1
    .catchall {:try_start_2 .. :try_end_2} :catchall_b

    .line 128
    invoke-static {p1}, Lru/oopssre/imperialschool/viewstv/ProxyTunnel;->close(Ljava/io/Closeable;)V

    .line 129
    monitor-enter p0

    .line 130
    :try_start_3
    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/ProxyTunnel;->active:Ljava/util/Set;

    invoke-interface {v0, p1}, Ljava/util/Set;->remove(Ljava/lang/Object;)Z

    .line 131
    iget-object p1, p0, Lru/oopssre/imperialschool/viewstv/ProxyTunnel;->active:Ljava/util/Set;

    new-instance v0, Lru/oopssre/imperialschool/viewstv/ProxyTunnel$$ExternalSyntheticLambda3;

    invoke-direct {v0}, Lru/oopssre/imperialschool/viewstv/ProxyTunnel$$ExternalSyntheticLambda3;-><init>()V

    invoke-interface {p1, v0}, Ljava/util/Set;->removeIf(Ljava/util/function/Predicate;)Z

    .line 132
    monitor-exit p0
    :try_end_3
    .catchall {:try_start_3 .. :try_end_3} :catchall_0

    .line 133
    :goto_2
    iget-object p1, p0, Lru/oopssre/imperialschool/viewstv/ProxyTunnel;->slots:Ljava/util/concurrent/Semaphore;

    invoke-virtual {p1}, Ljava/util/concurrent/Semaphore;->release()V

    return-void

    :catchall_0
    move-exception p1

    .line 132
    :try_start_4
    monitor-exit p0
    :try_end_4
    .catchall {:try_start_4 .. :try_end_4} :catchall_0

    throw p1

    :cond_3
    add-int/lit8 v6, v6, 0x1

    goto :goto_0

    .line 79
    :cond_4
    :goto_3
    :try_start_5
    const-string v1, "405 Method Not Allowed"

    const-string v2, "Connection: close\r\n"

    invoke-static {v3, v1, v2}, Lru/oopssre/imperialschool/viewstv/ProxyTunnel;->reply(Ljava/io/OutputStream;Ljava/lang/String;Ljava/lang/String;)V
    :try_end_5
    .catchall {:try_start_5 .. :try_end_5} :catchall_9

    .line 125
    :try_start_6
    invoke-virtual {v0}, Ljava/net/Socket;->close()V
    :try_end_6
    .catch Ljava/io/IOException; {:try_start_6 .. :try_end_6} :catch_1
    .catch Ljava/lang/IllegalArgumentException; {:try_start_6 .. :try_end_6} :catch_1
    .catchall {:try_start_6 .. :try_end_6} :catchall_b

    .line 128
    invoke-static {p1}, Lru/oopssre/imperialschool/viewstv/ProxyTunnel;->close(Ljava/io/Closeable;)V

    .line 129
    monitor-enter p0

    .line 130
    :try_start_7
    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/ProxyTunnel;->active:Ljava/util/Set;

    invoke-interface {v0, p1}, Ljava/util/Set;->remove(Ljava/lang/Object;)Z

    .line 131
    iget-object p1, p0, Lru/oopssre/imperialschool/viewstv/ProxyTunnel;->active:Ljava/util/Set;

    new-instance v0, Lru/oopssre/imperialschool/viewstv/ProxyTunnel$$ExternalSyntheticLambda3;

    invoke-direct {v0}, Lru/oopssre/imperialschool/viewstv/ProxyTunnel$$ExternalSyntheticLambda3;-><init>()V

    invoke-interface {p1, v0}, Ljava/util/Set;->removeIf(Ljava/util/function/Predicate;)Z

    .line 132
    monitor-exit p0

    goto :goto_2

    :catchall_1
    move-exception p1

    monitor-exit p0
    :try_end_7
    .catchall {:try_start_7 .. :try_end_7} :catchall_1

    throw p1

    .line 90
    :cond_5
    :goto_4
    :try_start_8
    new-instance v6, Ljava/lang/StringBuilder;

    invoke-direct {v6}, Ljava/lang/StringBuilder;-><init>()V

    const-string v7, "https://"

    invoke-virtual {v6, v7}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v6

    aget-object v7, v5, v8

    invoke-virtual {v6, v7}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v6

    invoke-virtual {v6}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v6

    invoke-static {v6}, Ljava/net/URI;->create(Ljava/lang/String;)Ljava/net/URI;

    move-result-object v6

    .line 91
    invoke-virtual {v6}, Ljava/net/URI;->getHost()Ljava/lang/String;

    move-result-object v7

    .line 92
    invoke-virtual {v6}, Ljava/net/URI;->getPort()I

    move-result v6

    if-eqz v7, :cond_a

    if-lt v6, v8, :cond_a

    const v9, 0xffff

    if-gt v6, v9, :cond_a

    .line 93
    aget-object v9, v5, v8

    invoke-static {v7, v6}, Lru/oopssre/imperialschool/viewstv/ProxyOptions;->authority(Ljava/lang/String;I)Ljava/lang/String;

    move-result-object v10

    invoke-virtual {v9, v10}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v9
    :try_end_8
    .catchall {:try_start_8 .. :try_end_8} :catchall_9

    if-nez v9, :cond_6

    goto/16 :goto_6

    .line 100
    :cond_6
    :try_start_9
    monitor-enter p0
    :try_end_9
    .catch Ljava/io/IOException; {:try_start_9 .. :try_end_9} :catch_0
    .catchall {:try_start_9 .. :try_end_9} :catchall_9

    .line 101
    :try_start_a
    iget-boolean v9, p0, Lru/oopssre/imperialschool/viewstv/ProxyTunnel;->closed:Z

    if-eqz v9, :cond_7

    monitor-exit p0
    :try_end_a
    .catchall {:try_start_a .. :try_end_a} :catchall_6

    .line 125
    :try_start_b
    invoke-virtual {v0}, Ljava/net/Socket;->close()V
    :try_end_b
    .catch Ljava/io/IOException; {:try_start_b .. :try_end_b} :catch_1
    .catch Ljava/lang/IllegalArgumentException; {:try_start_b .. :try_end_b} :catch_1
    .catchall {:try_start_b .. :try_end_b} :catchall_b

    .line 128
    invoke-static {p1}, Lru/oopssre/imperialschool/viewstv/ProxyTunnel;->close(Ljava/io/Closeable;)V

    .line 129
    monitor-enter p0

    .line 130
    :try_start_c
    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/ProxyTunnel;->active:Ljava/util/Set;

    invoke-interface {v0, p1}, Ljava/util/Set;->remove(Ljava/lang/Object;)Z

    .line 131
    iget-object p1, p0, Lru/oopssre/imperialschool/viewstv/ProxyTunnel;->active:Ljava/util/Set;

    new-instance v0, Lru/oopssre/imperialschool/viewstv/ProxyTunnel$$ExternalSyntheticLambda3;

    invoke-direct {v0}, Lru/oopssre/imperialschool/viewstv/ProxyTunnel$$ExternalSyntheticLambda3;-><init>()V

    invoke-interface {p1, v0}, Ljava/util/Set;->removeIf(Ljava/util/function/Predicate;)Z

    .line 132
    monitor-exit p0

    goto/16 :goto_2

    :catchall_2
    move-exception p1

    monitor-exit p0
    :try_end_c
    .catchall {:try_start_c .. :try_end_c} :catchall_2

    throw p1

    .line 102
    :cond_7
    :try_start_d
    iget-object v9, p0, Lru/oopssre/imperialschool/viewstv/ProxyTunnel;->active:Ljava/util/Set;

    invoke-interface {v9, v0}, Ljava/util/Set;->add(Ljava/lang/Object;)Z

    .line 103
    monitor-exit p0
    :try_end_d
    .catchall {:try_start_d .. :try_end_d} :catchall_6

    .line 104
    :try_start_e
    new-instance v9, Ljava/net/InetSocketAddress;

    iget-object v10, p0, Lru/oopssre/imperialschool/viewstv/ProxyTunnel;->options:Lru/oopssre/imperialschool/viewstv/ProxyOptions;

    iget-object v10, v10, Lru/oopssre/imperialschool/viewstv/ProxyOptions;->host:Ljava/lang/String;

    iget-object v11, p0, Lru/oopssre/imperialschool/viewstv/ProxyTunnel;->options:Lru/oopssre/imperialschool/viewstv/ProxyOptions;

    iget v11, v11, Lru/oopssre/imperialschool/viewstv/ProxyOptions;->port:I

    invoke-direct {v9, v10, v11}, Ljava/net/InetSocketAddress;-><init>(Ljava/lang/String;I)V

    invoke-virtual {v0, v9, v1}, Ljava/net/Socket;->connect(Ljava/net/SocketAddress;I)V

    .line 105
    invoke-virtual {v0, v1}, Ljava/net/Socket;->setSoTimeout(I)V

    .line 106
    new-instance v1, Ljava/io/BufferedInputStream;

    invoke-virtual {v0}, Ljava/net/Socket;->getInputStream()Ljava/io/InputStream;

    move-result-object v9

    invoke-direct {v1, v9}, Ljava/io/BufferedInputStream;-><init>(Ljava/io/InputStream;)V

    .line 107
    iget-object v9, p0, Lru/oopssre/imperialschool/viewstv/ProxyTunnel;->options:Lru/oopssre/imperialschool/viewstv/ProxyOptions;

    iget-object v9, v9, Lru/oopssre/imperialschool/viewstv/ProxyOptions;->type:Lru/oopssre/imperialschool/viewstv/ProxyOptions$Type;

    sget-object v10, Lru/oopssre/imperialschool/viewstv/ProxyOptions$Type;->HTTP:Lru/oopssre/imperialschool/viewstv/ProxyOptions$Type;

    if-ne v9, v10, :cond_8

    .line 108
    invoke-virtual {v0}, Ljava/net/Socket;->getOutputStream()Ljava/io/OutputStream;

    move-result-object v6

    aget-object v5, v5, v8

    invoke-direct {p0, v1, v6, v5}, Lru/oopssre/imperialschool/viewstv/ProxyTunnel;->openHttp(Ljava/io/InputStream;Ljava/io/OutputStream;Ljava/lang/String;)V

    goto :goto_5

    .line 110
    :cond_8
    invoke-virtual {v0}, Ljava/net/Socket;->getOutputStream()Ljava/io/OutputStream;

    move-result-object v5

    invoke-direct {p0, v1, v5, v7, v6}, Lru/oopssre/imperialschool/viewstv/ProxyTunnel;->openSocks(Ljava/io/InputStream;Ljava/io/OutputStream;Ljava/lang/String;I)V
    :try_end_e
    .catch Ljava/io/IOException; {:try_start_e .. :try_end_e} :catch_0
    .catchall {:try_start_e .. :try_end_e} :catchall_9

    .line 117
    :goto_5
    :try_start_f
    const-string v5, "200 Connection Established"

    const-string v6, ""

    invoke-static {v3, v5, v6}, Lru/oopssre/imperialschool/viewstv/ProxyTunnel;->reply(Ljava/io/OutputStream;Ljava/lang/String;Ljava/lang/String;)V

    .line 118
    invoke-virtual {p1, v4}, Ljava/net/Socket;->setSoTimeout(I)V

    const/16 v4, 0x7530

    .line 119
    invoke-virtual {v0, v4}, Ljava/net/Socket;->setSoTimeout(I)V

    .line 120
    monitor-enter p0
    :try_end_f
    .catchall {:try_start_f .. :try_end_f} :catchall_9

    .line 121
    :try_start_10
    iget-boolean v4, p0, Lru/oopssre/imperialschool/viewstv/ProxyTunnel;->closed:Z

    if-eqz v4, :cond_9

    monitor-exit p0
    :try_end_10
    .catchall {:try_start_10 .. :try_end_10} :catchall_5

    .line 125
    :try_start_11
    invoke-virtual {v0}, Ljava/net/Socket;->close()V
    :try_end_11
    .catch Ljava/io/IOException; {:try_start_11 .. :try_end_11} :catch_1
    .catch Ljava/lang/IllegalArgumentException; {:try_start_11 .. :try_end_11} :catch_1
    .catchall {:try_start_11 .. :try_end_11} :catchall_b

    .line 128
    invoke-static {p1}, Lru/oopssre/imperialschool/viewstv/ProxyTunnel;->close(Ljava/io/Closeable;)V

    .line 129
    monitor-enter p0

    .line 130
    :try_start_12
    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/ProxyTunnel;->active:Ljava/util/Set;

    invoke-interface {v0, p1}, Ljava/util/Set;->remove(Ljava/lang/Object;)Z

    .line 131
    iget-object p1, p0, Lru/oopssre/imperialschool/viewstv/ProxyTunnel;->active:Ljava/util/Set;

    new-instance v0, Lru/oopssre/imperialschool/viewstv/ProxyTunnel$$ExternalSyntheticLambda3;

    invoke-direct {v0}, Lru/oopssre/imperialschool/viewstv/ProxyTunnel$$ExternalSyntheticLambda3;-><init>()V

    invoke-interface {p1, v0}, Ljava/util/Set;->removeIf(Ljava/util/function/Predicate;)Z

    .line 132
    monitor-exit p0

    goto/16 :goto_2

    :catchall_3
    move-exception p1

    monitor-exit p0
    :try_end_12
    .catchall {:try_start_12 .. :try_end_12} :catchall_3

    throw p1

    .line 122
    :cond_9
    :try_start_13
    iget-object v4, p0, Lru/oopssre/imperialschool/viewstv/ProxyTunnel;->workers:Ljava/util/concurrent/ExecutorService;

    new-instance v5, Lru/oopssre/imperialschool/viewstv/ProxyTunnel$$ExternalSyntheticLambda4;

    invoke-direct {v5, v2, v0}, Lru/oopssre/imperialschool/viewstv/ProxyTunnel$$ExternalSyntheticLambda4;-><init>(Ljava/io/InputStream;Ljava/net/Socket;)V

    invoke-interface {v4, v5}, Ljava/util/concurrent/ExecutorService;->execute(Ljava/lang/Runnable;)V

    .line 123
    monitor-exit p0
    :try_end_13
    .catchall {:try_start_13 .. :try_end_13} :catchall_5

    .line 124
    :try_start_14
    invoke-static {v1, v3}, Lru/oopssre/imperialschool/viewstv/ProxyTunnel;->copy(Ljava/io/InputStream;Ljava/io/OutputStream;)V
    :try_end_14
    .catchall {:try_start_14 .. :try_end_14} :catchall_9

    .line 125
    :try_start_15
    invoke-virtual {v0}, Ljava/net/Socket;->close()V
    :try_end_15
    .catch Ljava/io/IOException; {:try_start_15 .. :try_end_15} :catch_1
    .catch Ljava/lang/IllegalArgumentException; {:try_start_15 .. :try_end_15} :catch_1
    .catchall {:try_start_15 .. :try_end_15} :catchall_b

    .line 128
    invoke-static {p1}, Lru/oopssre/imperialschool/viewstv/ProxyTunnel;->close(Ljava/io/Closeable;)V

    .line 129
    monitor-enter p0

    .line 130
    :try_start_16
    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/ProxyTunnel;->active:Ljava/util/Set;

    invoke-interface {v0, p1}, Ljava/util/Set;->remove(Ljava/lang/Object;)Z

    .line 131
    iget-object p1, p0, Lru/oopssre/imperialschool/viewstv/ProxyTunnel;->active:Ljava/util/Set;

    new-instance v0, Lru/oopssre/imperialschool/viewstv/ProxyTunnel$$ExternalSyntheticLambda3;

    invoke-direct {v0}, Lru/oopssre/imperialschool/viewstv/ProxyTunnel$$ExternalSyntheticLambda3;-><init>()V

    invoke-interface {p1, v0}, Ljava/util/Set;->removeIf(Ljava/util/function/Predicate;)Z

    .line 132
    monitor-exit p0

    goto/16 :goto_2

    :catchall_4
    move-exception p1

    monitor-exit p0
    :try_end_16
    .catchall {:try_start_16 .. :try_end_16} :catchall_4

    throw p1

    :catchall_5
    move-exception v1

    .line 123
    :try_start_17
    monitor-exit p0
    :try_end_17
    .catchall {:try_start_17 .. :try_end_17} :catchall_5

    :try_start_18
    throw v1
    :try_end_18
    .catchall {:try_start_18 .. :try_end_18} :catchall_9

    :catchall_6
    move-exception v1

    .line 103
    :try_start_19
    monitor-exit p0
    :try_end_19
    .catchall {:try_start_19 .. :try_end_19} :catchall_6

    :try_start_1a
    throw v1
    :try_end_1a
    .catch Ljava/io/IOException; {:try_start_1a .. :try_end_1a} :catch_0
    .catchall {:try_start_1a .. :try_end_1a} :catchall_9

    .line 113
    :catch_0
    :try_start_1b
    const-string v1, "502 Bad Gateway"

    const-string v2, "Connection: close\r\n"

    invoke-static {v3, v1, v2}, Lru/oopssre/imperialschool/viewstv/ProxyTunnel;->reply(Ljava/io/OutputStream;Ljava/lang/String;Ljava/lang/String;)V
    :try_end_1b
    .catchall {:try_start_1b .. :try_end_1b} :catchall_9

    .line 125
    :try_start_1c
    invoke-virtual {v0}, Ljava/net/Socket;->close()V
    :try_end_1c
    .catch Ljava/io/IOException; {:try_start_1c .. :try_end_1c} :catch_1
    .catch Ljava/lang/IllegalArgumentException; {:try_start_1c .. :try_end_1c} :catch_1
    .catchall {:try_start_1c .. :try_end_1c} :catchall_b

    .line 128
    invoke-static {p1}, Lru/oopssre/imperialschool/viewstv/ProxyTunnel;->close(Ljava/io/Closeable;)V

    .line 129
    monitor-enter p0

    .line 130
    :try_start_1d
    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/ProxyTunnel;->active:Ljava/util/Set;

    invoke-interface {v0, p1}, Ljava/util/Set;->remove(Ljava/lang/Object;)Z

    .line 131
    iget-object p1, p0, Lru/oopssre/imperialschool/viewstv/ProxyTunnel;->active:Ljava/util/Set;

    new-instance v0, Lru/oopssre/imperialschool/viewstv/ProxyTunnel$$ExternalSyntheticLambda3;

    invoke-direct {v0}, Lru/oopssre/imperialschool/viewstv/ProxyTunnel$$ExternalSyntheticLambda3;-><init>()V

    invoke-interface {p1, v0}, Ljava/util/Set;->removeIf(Ljava/util/function/Predicate;)Z

    .line 132
    monitor-exit p0

    goto/16 :goto_2

    :catchall_7
    move-exception p1

    monitor-exit p0
    :try_end_1d
    .catchall {:try_start_1d .. :try_end_1d} :catchall_7

    throw p1

    .line 94
    :cond_a
    :goto_6
    :try_start_1e
    const-string v1, "400 Bad Request"

    const-string v2, "Connection: close\r\n"

    invoke-static {v3, v1, v2}, Lru/oopssre/imperialschool/viewstv/ProxyTunnel;->reply(Ljava/io/OutputStream;Ljava/lang/String;Ljava/lang/String;)V
    :try_end_1e
    .catchall {:try_start_1e .. :try_end_1e} :catchall_9

    .line 125
    :try_start_1f
    invoke-virtual {v0}, Ljava/net/Socket;->close()V
    :try_end_1f
    .catch Ljava/io/IOException; {:try_start_1f .. :try_end_1f} :catch_1
    .catch Ljava/lang/IllegalArgumentException; {:try_start_1f .. :try_end_1f} :catch_1
    .catchall {:try_start_1f .. :try_end_1f} :catchall_b

    .line 128
    invoke-static {p1}, Lru/oopssre/imperialschool/viewstv/ProxyTunnel;->close(Ljava/io/Closeable;)V

    .line 129
    monitor-enter p0

    .line 130
    :try_start_20
    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/ProxyTunnel;->active:Ljava/util/Set;

    invoke-interface {v0, p1}, Ljava/util/Set;->remove(Ljava/lang/Object;)Z

    .line 131
    iget-object p1, p0, Lru/oopssre/imperialschool/viewstv/ProxyTunnel;->active:Ljava/util/Set;

    new-instance v0, Lru/oopssre/imperialschool/viewstv/ProxyTunnel$$ExternalSyntheticLambda3;

    invoke-direct {v0}, Lru/oopssre/imperialschool/viewstv/ProxyTunnel$$ExternalSyntheticLambda3;-><init>()V

    invoke-interface {p1, v0}, Ljava/util/Set;->removeIf(Ljava/util/function/Predicate;)Z

    .line 132
    monitor-exit p0

    goto/16 :goto_2

    :catchall_8
    move-exception p1

    monitor-exit p0
    :try_end_20
    .catchall {:try_start_20 .. :try_end_20} :catchall_8

    throw p1

    :catchall_9
    move-exception v1

    .line 70
    :try_start_21
    invoke-virtual {v0}, Ljava/net/Socket;->close()V
    :try_end_21
    .catchall {:try_start_21 .. :try_end_21} :catchall_a

    goto :goto_7

    :catchall_a
    move-exception v0

    :try_start_22
    invoke-virtual {v1, v0}, Ljava/lang/Throwable;->addSuppressed(Ljava/lang/Throwable;)V

    :goto_7
    throw v1
    :try_end_22
    .catch Ljava/io/IOException; {:try_start_22 .. :try_end_22} :catch_1
    .catch Ljava/lang/IllegalArgumentException; {:try_start_22 .. :try_end_22} :catch_1
    .catchall {:try_start_22 .. :try_end_22} :catchall_b

    :catchall_b
    move-exception v0

    .line 128
    invoke-static {p1}, Lru/oopssre/imperialschool/viewstv/ProxyTunnel;->close(Ljava/io/Closeable;)V

    .line 129
    monitor-enter p0

    .line 130
    :try_start_23
    iget-object v1, p0, Lru/oopssre/imperialschool/viewstv/ProxyTunnel;->active:Ljava/util/Set;

    invoke-interface {v1, p1}, Ljava/util/Set;->remove(Ljava/lang/Object;)Z

    .line 131
    iget-object p1, p0, Lru/oopssre/imperialschool/viewstv/ProxyTunnel;->active:Ljava/util/Set;

    new-instance v1, Lru/oopssre/imperialschool/viewstv/ProxyTunnel$$ExternalSyntheticLambda3;

    invoke-direct {v1}, Lru/oopssre/imperialschool/viewstv/ProxyTunnel$$ExternalSyntheticLambda3;-><init>()V

    invoke-interface {p1, v1}, Ljava/util/Set;->removeIf(Ljava/util/function/Predicate;)Z

    .line 132
    monitor-exit p0
    :try_end_23
    .catchall {:try_start_23 .. :try_end_23} :catchall_c

    .line 133
    iget-object p1, p0, Lru/oopssre/imperialschool/viewstv/ProxyTunnel;->slots:Ljava/util/concurrent/Semaphore;

    invoke-virtual {p1}, Ljava/util/concurrent/Semaphore;->release()V

    .line 134
    throw v0

    :catchall_c
    move-exception p1

    .line 132
    :try_start_24
    monitor-exit p0
    :try_end_24
    .catchall {:try_start_24 .. :try_end_24} :catchall_c

    throw p1

    .line 128
    :catch_1
    invoke-static {p1}, Lru/oopssre/imperialschool/viewstv/ProxyTunnel;->close(Ljava/io/Closeable;)V

    .line 129
    monitor-enter p0

    .line 130
    :try_start_25
    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/ProxyTunnel;->active:Ljava/util/Set;

    invoke-interface {v0, p1}, Ljava/util/Set;->remove(Ljava/lang/Object;)Z

    .line 131
    iget-object p1, p0, Lru/oopssre/imperialschool/viewstv/ProxyTunnel;->active:Ljava/util/Set;

    new-instance v0, Lru/oopssre/imperialschool/viewstv/ProxyTunnel$$ExternalSyntheticLambda3;

    invoke-direct {v0}, Lru/oopssre/imperialschool/viewstv/ProxyTunnel$$ExternalSyntheticLambda3;-><init>()V

    invoke-interface {p1, v0}, Ljava/util/Set;->removeIf(Ljava/util/function/Predicate;)Z

    .line 132
    monitor-exit p0

    goto/16 :goto_2

    :catchall_d
    move-exception p1

    monitor-exit p0
    :try_end_25
    .catchall {:try_start_25 .. :try_end_25} :catchall_d

    throw p1
.end method

.method private static upload(Ljava/io/InputStream;Ljava/net/Socket;)V
    .locals 1

    .line 233
    :try_start_0
    invoke-virtual {p1}, Ljava/net/Socket;->getOutputStream()Ljava/io/OutputStream;

    move-result-object v0

    invoke-static {p0, v0}, Lru/oopssre/imperialschool/viewstv/ProxyTunnel;->copy(Ljava/io/InputStream;Ljava/io/OutputStream;)V

    .line 234
    invoke-virtual {p1}, Ljava/net/Socket;->shutdownOutput()V
    :try_end_0
    .catch Ljava/io/IOException; {:try_start_0 .. :try_end_0} :catch_0

    return-void

    .line 235
    :catch_0
    invoke-static {p1}, Lru/oopssre/imperialschool/viewstv/ProxyTunnel;->close(Ljava/io/Closeable;)V

    return-void
.end method

.method private static write(Ljava/io/OutputStream;Ljava/lang/String;)V
    .locals 1
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/io/IOException;
        }
    .end annotation

    .line 201
    sget-object v0, Ljava/nio/charset/StandardCharsets;->US_ASCII:Ljava/nio/charset/Charset;

    invoke-virtual {p1, v0}, Ljava/lang/String;->getBytes(Ljava/nio/charset/Charset;)[B

    move-result-object p1

    invoke-virtual {p0, p1}, Ljava/io/OutputStream;->write([B)V

    .line 202
    invoke-virtual {p0}, Ljava/io/OutputStream;->flush()V

    return-void
.end method


# virtual methods
.method public declared-synchronized close()V
    .locals 2

    monitor-enter p0

    .line 248
    :try_start_0
    iget-boolean v0, p0, Lru/oopssre/imperialschool/viewstv/ProxyTunnel;->closed:Z
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    if-eqz v0, :cond_0

    monitor-exit p0

    return-void

    :cond_0
    const/4 v0, 0x1

    .line 249
    :try_start_1
    iput-boolean v0, p0, Lru/oopssre/imperialschool/viewstv/ProxyTunnel;->closed:Z

    .line 250
    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/ProxyTunnel;->server:Ljava/net/ServerSocket;

    invoke-static {v0}, Lru/oopssre/imperialschool/viewstv/ProxyTunnel;->close(Ljava/io/Closeable;)V

    .line 251
    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/ProxyTunnel;->active:Ljava/util/Set;

    invoke-interface {v0}, Ljava/util/Set;->iterator()Ljava/util/Iterator;

    move-result-object v0

    :goto_0
    invoke-interface {v0}, Ljava/util/Iterator;->hasNext()Z

    move-result v1

    if-eqz v1, :cond_1

    invoke-interface {v0}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Ljava/net/Socket;

    invoke-static {v1}, Lru/oopssre/imperialschool/viewstv/ProxyTunnel;->close(Ljava/io/Closeable;)V

    goto :goto_0

    .line 252
    :cond_1
    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/ProxyTunnel;->active:Ljava/util/Set;

    invoke-interface {v0}, Ljava/util/Set;->clear()V

    .line 253
    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/ProxyTunnel;->workers:Ljava/util/concurrent/ExecutorService;

    invoke-interface {v0}, Ljava/util/concurrent/ExecutorService;->shutdown()V
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    .line 254
    monitor-exit p0

    return-void

    :catchall_0
    move-exception v0

    :try_start_2
    monitor-exit p0
    :try_end_2
    .catchall {:try_start_2 .. :try_end_2} :catchall_0

    throw v0
.end method

.method credentials(Ljava/net/InetAddress;I)Ljava/net/PasswordAuthentication;
    .locals 1

    if-eqz p1, :cond_0

    .line 46
    const-string v0, "127.0.0.1"

    invoke-virtual {p1}, Ljava/net/InetAddress;->getHostAddress()Ljava/lang/String;

    move-result-object p1

    invoke-virtual {v0, p1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p1

    if-eqz p1, :cond_0

    iget-object p1, p0, Lru/oopssre/imperialschool/viewstv/ProxyTunnel;->server:Ljava/net/ServerSocket;

    invoke-virtual {p1}, Ljava/net/ServerSocket;->getLocalPort()I

    move-result p1

    if-ne p2, p1, :cond_0

    .line 47
    new-instance p1, Ljava/net/PasswordAuthentication;

    iget-object p2, p0, Lru/oopssre/imperialschool/viewstv/ProxyTunnel;->token:Ljava/lang/String;

    invoke-virtual {p2}, Ljava/lang/String;->toCharArray()[C

    move-result-object p2

    const-string v0, "imperial-tv"

    invoke-direct {p1, v0, p2}, Ljava/net/PasswordAuthentication;-><init>(Ljava/lang/String;[C)V

    return-object p1

    :cond_0
    const/4 p1, 0x0

    return-object p1
.end method

.method synthetic lambda$accept$1$ru-oopssre-imperialschool-viewstv-ProxyTunnel(Ljava/net/Socket;)V
    .locals 0

    .line 61
    invoke-direct {p0, p1}, Lru/oopssre/imperialschool/viewstv/ProxyTunnel;->serve(Ljava/net/Socket;)V

    return-void
.end method

.method route()Ljava/net/Proxy;
    .locals 5

    .line 42
    new-instance v0, Ljava/net/Proxy;

    sget-object v1, Ljava/net/Proxy$Type;->HTTP:Ljava/net/Proxy$Type;

    new-instance v2, Ljava/net/InetSocketAddress;

    iget-object v3, p0, Lru/oopssre/imperialschool/viewstv/ProxyTunnel;->server:Ljava/net/ServerSocket;

    invoke-virtual {v3}, Ljava/net/ServerSocket;->getLocalPort()I

    move-result v3

    const-string v4, "127.0.0.1"

    invoke-direct {v2, v4, v3}, Ljava/net/InetSocketAddress;-><init>(Ljava/lang/String;I)V

    invoke-direct {v0, v1, v2}, Ljava/net/Proxy;-><init>(Ljava/net/Proxy$Type;Ljava/net/SocketAddress;)V

    return-object v0
.end method
