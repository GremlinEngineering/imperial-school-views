.class final Lru/oopssre/imperialschool/viewstv/ProxyOptions;
.super Ljava/lang/Object;
.source "ProxyOptions.java"


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lru/oopssre/imperialschool/viewstv/ProxyOptions$Type;
    }
.end annotation


# instance fields
.field final external:Z

.field final host:Ljava/lang/String;

.field final login:Ljava/lang/String;

.field final password:Ljava/lang/String;

.field final port:I

.field final radio:Z

.field final type:Lru/oopssre/imperialschool/viewstv/ProxyOptions$Type;


# direct methods
.method constructor <init>(Lru/oopssre/imperialschool/viewstv/ProxyOptions$Type;Ljava/lang/String;ILjava/lang/String;Ljava/lang/String;ZZ)V
    .locals 0

    .line 16
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 17
    invoke-static {p1}, Ljava/util/Objects;->requireNonNull(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object p1

    check-cast p1, Lru/oopssre/imperialschool/viewstv/ProxyOptions$Type;

    iput-object p1, p0, Lru/oopssre/imperialschool/viewstv/ProxyOptions;->type:Lru/oopssre/imperialschool/viewstv/ProxyOptions$Type;

    .line 18
    invoke-virtual {p2}, Ljava/lang/String;->trim()Ljava/lang/String;

    move-result-object p1

    iput-object p1, p0, Lru/oopssre/imperialschool/viewstv/ProxyOptions;->host:Ljava/lang/String;

    .line 19
    iput p3, p0, Lru/oopssre/imperialschool/viewstv/ProxyOptions;->port:I

    .line 20
    iput-object p4, p0, Lru/oopssre/imperialschool/viewstv/ProxyOptions;->login:Ljava/lang/String;

    .line 21
    iput-object p5, p0, Lru/oopssre/imperialschool/viewstv/ProxyOptions;->password:Ljava/lang/String;

    .line 22
    iput-boolean p6, p0, Lru/oopssre/imperialschool/viewstv/ProxyOptions;->radio:Z

    .line 23
    iput-boolean p7, p0, Lru/oopssre/imperialschool/viewstv/ProxyOptions;->external:Z

    return-void
.end method

.method static authority(Ljava/lang/String;I)Ljava/lang/String;
    .locals 3

    .line 54
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const/16 v1, 0x3a

    invoke-virtual {p0, v1}, Ljava/lang/String;->indexOf(I)I

    move-result v1

    if-ltz v1, :cond_0

    const-string v1, "["

    invoke-virtual {p0, v1}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z

    move-result v2

    if-nez v2, :cond_0

    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2, v1}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v2, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p0

    const-string v1, "]"

    invoke-virtual {p0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p0

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    :cond_0
    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p0

    const-string v0, ":"

    invoke-virtual {p0, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p0

    invoke-virtual {p0, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object p0

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method

.method private static hasControls(Ljava/lang/String;)Z
    .locals 3

    const/4 v0, 0x0

    move v1, v0

    .line 67
    :goto_0
    invoke-virtual {p0}, Ljava/lang/String;->length()I

    move-result v2

    if-ge v1, v2, :cond_1

    invoke-virtual {p0, v1}, Ljava/lang/String;->charAt(I)C

    move-result v2

    invoke-static {v2}, Ljava/lang/Character;->isISOControl(C)Z

    move-result v2

    if-eqz v2, :cond_0

    const/4 p0, 0x1

    return p0

    :cond_0
    add-int/lit8 v1, v1, 0x1

    goto :goto_0

    :cond_1
    return v0
.end method

.method static validHost(Ljava/lang/String;)Z
    .locals 5

    const-string v0, "https://"

    const/4 v1, 0x0

    const/16 v2, 0x1bb

    .line 45
    :try_start_0
    invoke-static {p0, v2}, Lru/oopssre/imperialschool/viewstv/ProxyOptions;->authority(Ljava/lang/String;I)Ljava/lang/String;

    move-result-object v3

    .line 46
    new-instance v4, Ljava/lang/StringBuilder;

    invoke-direct {v4, v0}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v4, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-static {v0}, Ljava/net/URI;->create(Ljava/lang/String;)Ljava/net/URI;

    move-result-object v0

    .line 47
    invoke-virtual {v0}, Ljava/net/URI;->getRawAuthority()Ljava/lang/String;

    move-result-object v4

    invoke-virtual {v3, v4}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v3

    if-eqz v3, :cond_0

    invoke-virtual {v0}, Ljava/net/URI;->getHost()Ljava/lang/String;

    move-result-object v3

    if-eqz v3, :cond_0

    invoke-virtual {v0}, Ljava/net/URI;->getPort()I

    move-result v3

    if-ne v3, v2, :cond_0

    .line 48
    invoke-virtual {v0}, Ljava/net/URI;->getUserInfo()Ljava/lang/String;

    move-result-object v2

    if-nez v2, :cond_0

    invoke-virtual {v0}, Ljava/net/URI;->getRawPath()Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v2}, Ljava/lang/String;->isEmpty()Z

    move-result v2

    if-eqz v2, :cond_0

    invoke-virtual {v0}, Ljava/net/URI;->getRawQuery()Ljava/lang/String;

    move-result-object v2

    if-nez v2, :cond_0

    .line 49
    invoke-virtual {v0}, Ljava/net/URI;->getRawFragment()Ljava/lang/String;

    move-result-object v0

    if-nez v0, :cond_0

    invoke-virtual {p0}, Ljava/lang/String;->length()I

    move-result v0

    const/16 v2, 0xfd

    if-gt v0, v2, :cond_0

    const-string v0, "%"

    invoke-virtual {p0, v0}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z

    move-result p0
    :try_end_0
    .catch Ljava/lang/IllegalArgumentException; {:try_start_0 .. :try_end_0} :catch_0

    if-nez p0, :cond_0

    const/4 p0, 0x1

    return p0

    :catch_0
    :cond_0
    return v1
.end method


# virtual methods
.method enabled()Z
    .locals 1

    .line 26
    iget-boolean v0, p0, Lru/oopssre/imperialschool/viewstv/ProxyOptions;->radio:Z

    if-nez v0, :cond_1

    iget-boolean v0, p0, Lru/oopssre/imperialschool/viewstv/ProxyOptions;->external:Z

    if-eqz v0, :cond_0

    goto :goto_0

    :cond_0
    const/4 v0, 0x0

    return v0

    :cond_1
    :goto_0
    const/4 v0, 0x1

    return v0
.end method

.method error()Ljava/lang/String;
    .locals 4

    .line 29
    invoke-virtual {p0}, Lru/oopssre/imperialschool/viewstv/ProxyOptions;->enabled()Z

    move-result v0

    const-string v1, ""

    if-nez v0, :cond_0

    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/ProxyOptions;->host:Ljava/lang/String;

    invoke-virtual {v0}, Ljava/lang/String;->isEmpty()Z

    move-result v0

    if-eqz v0, :cond_0

    iget v0, p0, Lru/oopssre/imperialschool/viewstv/ProxyOptions;->port:I

    if-nez v0, :cond_0

    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/ProxyOptions;->login:Ljava/lang/String;

    invoke-virtual {v0}, Ljava/lang/String;->isEmpty()Z

    move-result v0

    if-eqz v0, :cond_0

    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/ProxyOptions;->password:Ljava/lang/String;

    invoke-virtual {v0}, Ljava/lang/String;->isEmpty()Z

    move-result v0

    if-eqz v0, :cond_0

    return-object v1

    .line 30
    :cond_0
    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/ProxyOptions;->host:Ljava/lang/String;

    invoke-static {v0}, Lru/oopssre/imperialschool/viewstv/ProxyOptions;->validHost(Ljava/lang/String;)Z

    move-result v0

    if-nez v0, :cond_1

    const-string v0, "\u0423\u043a\u0430\u0436\u0438\u0442\u0435 \u0438\u043c\u044f \u0441\u0435\u0440\u0432\u0435\u0440\u0430 \u0438\u043b\u0438 IP-\u0430\u0434\u0440\u0435\u0441 \u043f\u0440\u043e\u043a\u0441\u0438."

    return-object v0

    .line 31
    :cond_1
    iget v0, p0, Lru/oopssre/imperialschool/viewstv/ProxyOptions;->port:I

    const/4 v2, 0x1

    if-lt v0, v2, :cond_b

    const v2, 0xffff

    if-le v0, v2, :cond_2

    goto/16 :goto_3

    .line 32
    :cond_2
    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/ProxyOptions;->login:Ljava/lang/String;

    invoke-virtual {v0}, Ljava/lang/String;->isEmpty()Z

    move-result v0

    if-eqz v0, :cond_3

    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/ProxyOptions;->password:Ljava/lang/String;

    invoke-virtual {v0}, Ljava/lang/String;->isEmpty()Z

    move-result v0

    if-nez v0, :cond_3

    const-string v0, "\u0423\u043a\u0430\u0436\u0438\u0442\u0435 \u043b\u043e\u0433\u0438\u043d \u043f\u0440\u043e\u043a\u0441\u0438."

    return-object v0

    .line 33
    :cond_3
    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/ProxyOptions;->login:Ljava/lang/String;

    const/16 v2, 0x3a

    invoke-virtual {v0, v2}, Ljava/lang/String;->indexOf(I)I

    move-result v0

    if-ltz v0, :cond_4

    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/ProxyOptions;->type:Lru/oopssre/imperialschool/viewstv/ProxyOptions$Type;

    sget-object v2, Lru/oopssre/imperialschool/viewstv/ProxyOptions$Type;->HTTP:Lru/oopssre/imperialschool/viewstv/ProxyOptions$Type;

    if-eq v0, v2, :cond_a

    :cond_4
    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/ProxyOptions;->login:Ljava/lang/String;

    invoke-static {v0}, Lru/oopssre/imperialschool/viewstv/ProxyOptions;->hasControls(Ljava/lang/String;)Z

    move-result v0

    if-nez v0, :cond_a

    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/ProxyOptions;->password:Ljava/lang/String;

    invoke-static {v0}, Lru/oopssre/imperialschool/viewstv/ProxyOptions;->hasControls(Ljava/lang/String;)Z

    move-result v0

    if-eqz v0, :cond_5

    goto :goto_2

    .line 35
    :cond_5
    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/ProxyOptions;->type:Lru/oopssre/imperialschool/viewstv/ProxyOptions$Type;

    sget-object v2, Lru/oopssre/imperialschool/viewstv/ProxyOptions$Type;->SOCKS5:Lru/oopssre/imperialschool/viewstv/ProxyOptions$Type;

    if-ne v0, v2, :cond_6

    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/ProxyOptions;->login:Ljava/lang/String;

    invoke-virtual {v0}, Ljava/lang/String;->isEmpty()Z

    move-result v0

    if-nez v0, :cond_6

    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/ProxyOptions;->password:Ljava/lang/String;

    invoke-virtual {v0}, Ljava/lang/String;->isEmpty()Z

    move-result v0

    if-eqz v0, :cond_6

    .line 36
    const-string v0, "\u0423\u043a\u0430\u0436\u0438\u0442\u0435 \u043f\u0430\u0440\u043e\u043b\u044c SOCKS5."

    return-object v0

    .line 37
    :cond_6
    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/ProxyOptions;->type:Lru/oopssre/imperialschool/viewstv/ProxyOptions$Type;

    sget-object v2, Lru/oopssre/imperialschool/viewstv/ProxyOptions$Type;->SOCKS5:Lru/oopssre/imperialschool/viewstv/ProxyOptions$Type;

    if-ne v0, v2, :cond_7

    const/16 v0, 0xff

    goto :goto_0

    :cond_7
    const/16 v0, 0x400

    .line 38
    :goto_0
    iget-object v2, p0, Lru/oopssre/imperialschool/viewstv/ProxyOptions;->login:Ljava/lang/String;

    sget-object v3, Ljava/nio/charset/StandardCharsets;->UTF_8:Ljava/nio/charset/Charset;

    invoke-virtual {v2, v3}, Ljava/lang/String;->getBytes(Ljava/nio/charset/Charset;)[B

    move-result-object v2

    array-length v2, v2

    if-gt v2, v0, :cond_9

    iget-object v2, p0, Lru/oopssre/imperialschool/viewstv/ProxyOptions;->password:Ljava/lang/String;

    sget-object v3, Ljava/nio/charset/StandardCharsets;->UTF_8:Ljava/nio/charset/Charset;

    invoke-virtual {v2, v3}, Ljava/lang/String;->getBytes(Ljava/nio/charset/Charset;)[B

    move-result-object v2

    array-length v2, v2

    if-le v2, v0, :cond_8

    goto :goto_1

    :cond_8
    return-object v1

    .line 39
    :cond_9
    :goto_1
    const-string v0, "\u041b\u043e\u0433\u0438\u043d \u0438\u043b\u0438 \u043f\u0430\u0440\u043e\u043b\u044c \u0441\u043b\u0438\u0448\u043a\u043e\u043c \u0434\u043b\u0438\u043d\u043d\u044b\u0439."

    return-object v0

    .line 34
    :cond_a
    :goto_2
    const-string v0, "\u041f\u0440\u043e\u0432\u0435\u0440\u044c\u0442\u0435 \u0441\u0438\u043c\u0432\u043e\u043b\u044b \u0432 \u043b\u043e\u0433\u0438\u043d\u0435 \u0438 \u043f\u0430\u0440\u043e\u043b\u0435."

    return-object v0

    .line 31
    :cond_b
    :goto_3
    const-string v0, "\u0423\u043a\u0430\u0436\u0438\u0442\u0435 \u043f\u043e\u0440\u0442 \u043e\u0442 1 \u0434\u043e 65535."

    return-object v0
.end method

.method sameServer(Lru/oopssre/imperialschool/viewstv/ProxyOptions;)Z
    .locals 2

    .line 58
    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/ProxyOptions;->type:Lru/oopssre/imperialschool/viewstv/ProxyOptions$Type;

    iget-object v1, p1, Lru/oopssre/imperialschool/viewstv/ProxyOptions;->type:Lru/oopssre/imperialschool/viewstv/ProxyOptions$Type;

    if-ne v0, v1, :cond_0

    iget v0, p0, Lru/oopssre/imperialschool/viewstv/ProxyOptions;->port:I

    iget v1, p1, Lru/oopssre/imperialschool/viewstv/ProxyOptions;->port:I

    if-ne v0, v1, :cond_0

    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/ProxyOptions;->host:Ljava/lang/String;

    iget-object v1, p1, Lru/oopssre/imperialschool/viewstv/ProxyOptions;->host:Ljava/lang/String;

    invoke-virtual {v0, v1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_0

    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/ProxyOptions;->login:Ljava/lang/String;

    iget-object v1, p1, Lru/oopssre/imperialschool/viewstv/ProxyOptions;->login:Ljava/lang/String;

    .line 59
    invoke-virtual {v0, v1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_0

    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/ProxyOptions;->password:Ljava/lang/String;

    iget-object p1, p1, Lru/oopssre/imperialschool/viewstv/ProxyOptions;->password:Ljava/lang/String;

    invoke-virtual {v0, p1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p1

    if-eqz p1, :cond_0

    const/4 p1, 0x1

    return p1

    :cond_0
    const/4 p1, 0x0

    return p1
.end method

.method sameSettings(Lru/oopssre/imperialschool/viewstv/ProxyOptions;)Z
    .locals 2

    .line 63
    iget-boolean v0, p0, Lru/oopssre/imperialschool/viewstv/ProxyOptions;->radio:Z

    iget-boolean v1, p1, Lru/oopssre/imperialschool/viewstv/ProxyOptions;->radio:Z

    if-ne v0, v1, :cond_0

    iget-boolean v0, p0, Lru/oopssre/imperialschool/viewstv/ProxyOptions;->external:Z

    iget-boolean v1, p1, Lru/oopssre/imperialschool/viewstv/ProxyOptions;->external:Z

    if-ne v0, v1, :cond_0

    invoke-virtual {p0, p1}, Lru/oopssre/imperialschool/viewstv/ProxyOptions;->sameServer(Lru/oopssre/imperialschool/viewstv/ProxyOptions;)Z

    move-result p1

    if-eqz p1, :cond_0

    const/4 p1, 0x1

    return p1

    :cond_0
    const/4 p1, 0x0

    return p1
.end method
