.class final Lru/oopssre/imperialschool/viewstv/ProxyPreferences;
.super Ljava/lang/Object;
.source "ProxyPreferences.java"


# static fields
.field private static final ALIAS:Ljava/lang/String; = "imperial-tv-proxy"

.field private static instance:Lru/oopssre/imperialschool/viewstv/ProxyPreferences;


# instance fields
.field private volatile current:Lru/oopssre/imperialschool/viewstv/ProxyOptions;

.field private final prefs:Landroid/content/SharedPreferences;

.field private volatile unreadablePassword:Z


# direct methods
.method private constructor <init>(Landroid/content/Context;)V
    .locals 11

    .line 29
    const-string v0, "password"

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 30
    const-string v1, "proxy"

    const/4 v2, 0x0

    invoke-virtual {p1, v1, v2}, Landroid/content/Context;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;

    move-result-object p1

    iput-object p1, p0, Lru/oopssre/imperialschool/viewstv/ProxyPreferences;->prefs:Landroid/content/SharedPreferences;

    .line 31
    const-string v1, ""

    .line 33
    :try_start_0
    invoke-interface {p1, v0}, Landroid/content/SharedPreferences;->contains(Ljava/lang/String;)Z

    move-result v3

    if-eqz v3, :cond_0

    .line 34
    const-string v3, "AES/GCM/NoPadding"

    invoke-static {v3}, Ljavax/crypto/Cipher;->getInstance(Ljava/lang/String;)Ljavax/crypto/Cipher;

    move-result-object v3

    .line 35
    const-string v4, "iv"

    invoke-interface {p1, v4, v1}, Landroid/content/SharedPreferences;->getString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v4

    const/4 v5, 0x2

    invoke-static {v4, v5}, Landroid/util/Base64;->decode(Ljava/lang/String;I)[B

    move-result-object v4

    .line 36
    invoke-static {}, Lru/oopssre/imperialschool/viewstv/ProxyPreferences;->key()Ljavax/crypto/SecretKey;

    move-result-object v6

    new-instance v7, Ljavax/crypto/spec/GCMParameterSpec;

    const/16 v8, 0x80

    invoke-direct {v7, v8, v4}, Ljavax/crypto/spec/GCMParameterSpec;-><init>(I[B)V

    invoke-virtual {v3, v5, v6, v7}, Ljavax/crypto/Cipher;->init(ILjava/security/Key;Ljava/security/spec/AlgorithmParameterSpec;)V

    .line 37
    new-instance v4, Ljava/lang/String;

    invoke-interface {p1, v0, v1}, Landroid/content/SharedPreferences;->getString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object p1

    invoke-static {p1, v5}, Landroid/util/Base64;->decode(Ljava/lang/String;I)[B

    move-result-object p1

    invoke-virtual {v3, p1}, Ljavax/crypto/Cipher;->doFinal([B)[B

    move-result-object p1

    sget-object v0, Ljava/nio/charset/StandardCharsets;->UTF_8:Ljava/nio/charset/Charset;

    invoke-direct {v4, p1, v0}, Ljava/lang/String;-><init>([BLjava/nio/charset/Charset;)V
    :try_end_0
    .catch Ljava/security/GeneralSecurityException; {:try_start_0 .. :try_end_0} :catch_0
    .catch Ljava/io/IOException; {:try_start_0 .. :try_end_0} :catch_0
    .catch Ljava/lang/IllegalArgumentException; {:try_start_0 .. :try_end_0} :catch_0

    goto :goto_0

    :cond_0
    move-object v4, v1

    :goto_0
    move-object v8, v4

    goto :goto_1

    :catch_0
    const/4 p1, 0x1

    .line 41
    iput-boolean p1, p0, Lru/oopssre/imperialschool/viewstv/ProxyPreferences;->unreadablePassword:Z

    move-object v8, v1

    .line 43
    :goto_1
    iget-object p1, p0, Lru/oopssre/imperialschool/viewstv/ProxyPreferences;->prefs:Landroid/content/SharedPreferences;

    const-string v0, "http"

    invoke-interface {p1, v0, v2}, Landroid/content/SharedPreferences;->getBoolean(Ljava/lang/String;Z)Z

    move-result p1

    if-eqz p1, :cond_1

    sget-object p1, Lru/oopssre/imperialschool/viewstv/ProxyOptions$Type;->HTTP:Lru/oopssre/imperialschool/viewstv/ProxyOptions$Type;

    goto :goto_2

    :cond_1
    sget-object p1, Lru/oopssre/imperialschool/viewstv/ProxyOptions$Type;->SOCKS5:Lru/oopssre/imperialschool/viewstv/ProxyOptions$Type;

    :goto_2
    move-object v4, p1

    .line 44
    new-instance v3, Lru/oopssre/imperialschool/viewstv/ProxyOptions;

    iget-object p1, p0, Lru/oopssre/imperialschool/viewstv/ProxyPreferences;->prefs:Landroid/content/SharedPreferences;

    const-string v0, "host"

    invoke-interface {p1, v0, v1}, Landroid/content/SharedPreferences;->getString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v5

    iget-object p1, p0, Lru/oopssre/imperialschool/viewstv/ProxyPreferences;->prefs:Landroid/content/SharedPreferences;

    const-string v0, "port"

    invoke-interface {p1, v0, v2}, Landroid/content/SharedPreferences;->getInt(Ljava/lang/String;I)I

    move-result v6

    iget-object p1, p0, Lru/oopssre/imperialschool/viewstv/ProxyPreferences;->prefs:Landroid/content/SharedPreferences;

    const-string v0, "login"

    .line 45
    invoke-interface {p1, v0, v1}, Landroid/content/SharedPreferences;->getString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v7

    iget-object p1, p0, Lru/oopssre/imperialschool/viewstv/ProxyPreferences;->prefs:Landroid/content/SharedPreferences;

    const-string v0, "radio"

    invoke-interface {p1, v0, v2}, Landroid/content/SharedPreferences;->getBoolean(Ljava/lang/String;Z)Z

    move-result v9

    iget-object p1, p0, Lru/oopssre/imperialschool/viewstv/ProxyPreferences;->prefs:Landroid/content/SharedPreferences;

    const-string v0, "external"

    .line 46
    invoke-interface {p1, v0, v2}, Landroid/content/SharedPreferences;->getBoolean(Ljava/lang/String;Z)Z

    move-result v10

    invoke-direct/range {v3 .. v10}, Lru/oopssre/imperialschool/viewstv/ProxyOptions;-><init>(Lru/oopssre/imperialschool/viewstv/ProxyOptions$Type;Ljava/lang/String;ILjava/lang/String;Ljava/lang/String;ZZ)V

    iput-object v3, p0, Lru/oopssre/imperialschool/viewstv/ProxyPreferences;->current:Lru/oopssre/imperialschool/viewstv/ProxyOptions;

    .line 48
    :try_start_1
    iget-object p1, p0, Lru/oopssre/imperialschool/viewstv/ProxyPreferences;->current:Lru/oopssre/imperialschool/viewstv/ProxyOptions;

    invoke-virtual {p1}, Lru/oopssre/imperialschool/viewstv/ProxyOptions;->enabled()Z

    move-result p1

    if-eqz p1, :cond_4

    .line 49
    iget-boolean p1, p0, Lru/oopssre/imperialschool/viewstv/ProxyPreferences;->unreadablePassword:Z

    if-nez p1, :cond_3

    iget-object p1, p0, Lru/oopssre/imperialschool/viewstv/ProxyPreferences;->current:Lru/oopssre/imperialschool/viewstv/ProxyOptions;

    invoke-virtual {p1}, Lru/oopssre/imperialschool/viewstv/ProxyOptions;->error()Ljava/lang/String;

    move-result-object p1

    invoke-virtual {p1}, Ljava/lang/String;->isEmpty()Z

    move-result p1

    if-nez p1, :cond_2

    goto :goto_3

    .line 50
    :cond_2
    iget-object p1, p0, Lru/oopssre/imperialschool/viewstv/ProxyPreferences;->current:Lru/oopssre/imperialschool/viewstv/ProxyOptions;

    invoke-static {p1}, Lru/oopssre/imperialschool/viewstv/ProxyRouting;->apply(Lru/oopssre/imperialschool/viewstv/ProxyOptions;)V

    goto :goto_4

    .line 49
    :cond_3
    :goto_3
    iget-object p1, p0, Lru/oopssre/imperialschool/viewstv/ProxyPreferences;->current:Lru/oopssre/imperialschool/viewstv/ProxyOptions;

    invoke-static {p1}, Lru/oopssre/imperialschool/viewstv/ProxyRouting;->unavailable(Lru/oopssre/imperialschool/viewstv/ProxyOptions;)V
    :try_end_1
    .catch Ljava/io/IOException; {:try_start_1 .. :try_end_1} :catch_1

    goto :goto_4

    .line 53
    :catch_1
    iget-object p1, p0, Lru/oopssre/imperialschool/viewstv/ProxyPreferences;->current:Lru/oopssre/imperialschool/viewstv/ProxyOptions;

    invoke-static {p1}, Lru/oopssre/imperialschool/viewstv/ProxyRouting;->unavailable(Lru/oopssre/imperialschool/viewstv/ProxyOptions;)V

    :cond_4
    :goto_4
    return-void
.end method

.method static declared-synchronized get(Landroid/content/Context;)Lru/oopssre/imperialschool/viewstv/ProxyPreferences;
    .locals 2

    const-class v0, Lru/oopssre/imperialschool/viewstv/ProxyPreferences;

    monitor-enter v0

    .line 25
    :try_start_0
    sget-object v1, Lru/oopssre/imperialschool/viewstv/ProxyPreferences;->instance:Lru/oopssre/imperialschool/viewstv/ProxyPreferences;

    if-nez v1, :cond_0

    new-instance v1, Lru/oopssre/imperialschool/viewstv/ProxyPreferences;

    invoke-direct {v1, p0}, Lru/oopssre/imperialschool/viewstv/ProxyPreferences;-><init>(Landroid/content/Context;)V

    sput-object v1, Lru/oopssre/imperialschool/viewstv/ProxyPreferences;->instance:Lru/oopssre/imperialschool/viewstv/ProxyPreferences;

    .line 26
    :cond_0
    sget-object p0, Lru/oopssre/imperialschool/viewstv/ProxyPreferences;->instance:Lru/oopssre/imperialschool/viewstv/ProxyPreferences;
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    monitor-exit v0

    return-object p0

    :catchall_0
    move-exception p0

    :try_start_1
    monitor-exit v0
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    throw p0
.end method

.method private static key()Ljavax/crypto/SecretKey;
    .locals 6
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/security/GeneralSecurityException;,
            Ljava/io/IOException;
        }
    .end annotation

    .line 82
    const-string v0, "AndroidKeyStore"

    invoke-static {v0}, Ljava/security/KeyStore;->getInstance(Ljava/lang/String;)Ljava/security/KeyStore;

    move-result-object v1

    const/4 v2, 0x0

    .line 83
    invoke-virtual {v1, v2}, Ljava/security/KeyStore;->load(Ljava/security/KeyStore$LoadStoreParameter;)V

    .line 84
    const-string v3, "imperial-tv-proxy"

    invoke-virtual {v1, v3}, Ljava/security/KeyStore;->containsAlias(Ljava/lang/String;)Z

    move-result v4

    if-eqz v4, :cond_0

    invoke-virtual {v1, v3, v2}, Ljava/security/KeyStore;->getKey(Ljava/lang/String;[C)Ljava/security/Key;

    move-result-object v0

    check-cast v0, Ljavax/crypto/SecretKey;

    return-object v0

    .line 85
    :cond_0
    const-string v1, "AES"

    invoke-static {v1, v0}, Ljavax/crypto/KeyGenerator;->getInstance(Ljava/lang/String;Ljava/lang/String;)Ljavax/crypto/KeyGenerator;

    move-result-object v0

    .line 86
    new-instance v1, Landroid/security/keystore/KeyGenParameterSpec$Builder;

    const/4 v2, 0x3

    invoke-direct {v1, v3, v2}, Landroid/security/keystore/KeyGenParameterSpec$Builder;-><init>(Ljava/lang/String;I)V

    const/4 v2, 0x1

    new-array v3, v2, [Ljava/lang/String;

    const-string v4, "GCM"

    const/4 v5, 0x0

    aput-object v4, v3, v5

    .line 87
    invoke-virtual {v1, v3}, Landroid/security/keystore/KeyGenParameterSpec$Builder;->setBlockModes([Ljava/lang/String;)Landroid/security/keystore/KeyGenParameterSpec$Builder;

    move-result-object v1

    new-array v2, v2, [Ljava/lang/String;

    const-string v3, "NoPadding"

    aput-object v3, v2, v5

    .line 88
    invoke-virtual {v1, v2}, Landroid/security/keystore/KeyGenParameterSpec$Builder;->setEncryptionPaddings([Ljava/lang/String;)Landroid/security/keystore/KeyGenParameterSpec$Builder;

    move-result-object v1

    .line 89
    invoke-virtual {v1}, Landroid/security/keystore/KeyGenParameterSpec$Builder;->build()Landroid/security/keystore/KeyGenParameterSpec;

    move-result-object v1

    .line 86
    invoke-virtual {v0, v1}, Ljavax/crypto/KeyGenerator;->init(Ljava/security/spec/AlgorithmParameterSpec;)V

    .line 90
    invoke-virtual {v0}, Ljavax/crypto/KeyGenerator;->generateKey()Ljavax/crypto/SecretKey;

    move-result-object v0

    return-object v0
.end method


# virtual methods
.method current()Lru/oopssre/imperialschool/viewstv/ProxyOptions;
    .locals 1

    .line 57
    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/ProxyPreferences;->current:Lru/oopssre/imperialschool/viewstv/ProxyOptions;

    return-object v0
.end method

.method declared-synchronized save(Lru/oopssre/imperialschool/viewstv/ProxyOptions;)V
    .locals 7
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/io/IOException;,
            Ljava/security/GeneralSecurityException;
        }
    .end annotation

    monitor-enter p0

    .line 61
    :try_start_0
    invoke-virtual {p1}, Lru/oopssre/imperialschool/viewstv/ProxyOptions;->error()Ljava/lang/String;

    move-result-object v0

    .line 62
    invoke-virtual {v0}, Ljava/lang/String;->isEmpty()Z

    move-result v1

    if-eqz v1, :cond_2

    .line 63
    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/ProxyPreferences;->prefs:Landroid/content/SharedPreferences;

    invoke-interface {v0}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object v0

    const-string v1, "http"

    iget-object v2, p1, Lru/oopssre/imperialschool/viewstv/ProxyOptions;->type:Lru/oopssre/imperialschool/viewstv/ProxyOptions$Type;

    sget-object v3, Lru/oopssre/imperialschool/viewstv/ProxyOptions$Type;->HTTP:Lru/oopssre/imperialschool/viewstv/ProxyOptions$Type;

    const/4 v4, 0x1

    const/4 v5, 0x0

    if-ne v2, v3, :cond_0

    move v2, v4

    goto :goto_0

    :cond_0
    move v2, v5

    :goto_0
    invoke-interface {v0, v1, v2}, Landroid/content/SharedPreferences$Editor;->putBoolean(Ljava/lang/String;Z)Landroid/content/SharedPreferences$Editor;

    move-result-object v0

    const-string v1, "host"

    iget-object v2, p1, Lru/oopssre/imperialschool/viewstv/ProxyOptions;->host:Ljava/lang/String;

    .line 64
    invoke-interface {v0, v1, v2}, Landroid/content/SharedPreferences$Editor;->putString(Ljava/lang/String;Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    move-result-object v0

    const-string v1, "port"

    iget v2, p1, Lru/oopssre/imperialschool/viewstv/ProxyOptions;->port:I

    invoke-interface {v0, v1, v2}, Landroid/content/SharedPreferences$Editor;->putInt(Ljava/lang/String;I)Landroid/content/SharedPreferences$Editor;

    move-result-object v0

    const-string v1, "login"

    iget-object v2, p1, Lru/oopssre/imperialschool/viewstv/ProxyOptions;->login:Ljava/lang/String;

    invoke-interface {v0, v1, v2}, Landroid/content/SharedPreferences$Editor;->putString(Ljava/lang/String;Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    move-result-object v0

    const-string v1, "radio"

    iget-boolean v2, p1, Lru/oopssre/imperialschool/viewstv/ProxyOptions;->radio:Z

    .line 65
    invoke-interface {v0, v1, v2}, Landroid/content/SharedPreferences$Editor;->putBoolean(Ljava/lang/String;Z)Landroid/content/SharedPreferences$Editor;

    move-result-object v0

    const-string v1, "external"

    iget-boolean v2, p1, Lru/oopssre/imperialschool/viewstv/ProxyOptions;->external:Z

    invoke-interface {v0, v1, v2}, Landroid/content/SharedPreferences$Editor;->putBoolean(Ljava/lang/String;Z)Landroid/content/SharedPreferences$Editor;

    move-result-object v0

    .line 66
    iget-object v1, p1, Lru/oopssre/imperialschool/viewstv/ProxyOptions;->password:Ljava/lang/String;

    invoke-virtual {v1}, Ljava/lang/String;->isEmpty()Z

    move-result v1

    if-eqz v1, :cond_1

    .line 67
    const-string v1, "iv"

    invoke-interface {v0, v1}, Landroid/content/SharedPreferences$Editor;->remove(Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    move-result-object v1

    const-string v2, "password"

    invoke-interface {v1, v2}, Landroid/content/SharedPreferences$Editor;->remove(Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    goto :goto_1

    .line 69
    :cond_1
    const-string v1, "AES/GCM/NoPadding"

    invoke-static {v1}, Ljavax/crypto/Cipher;->getInstance(Ljava/lang/String;)Ljavax/crypto/Cipher;

    move-result-object v1

    .line 70
    invoke-static {}, Lru/oopssre/imperialschool/viewstv/ProxyPreferences;->key()Ljavax/crypto/SecretKey;

    move-result-object v2

    invoke-virtual {v1, v4, v2}, Ljavax/crypto/Cipher;->init(ILjava/security/Key;)V

    .line 71
    const-string v2, "iv"

    invoke-virtual {v1}, Ljavax/crypto/Cipher;->getIV()[B

    move-result-object v3

    const/4 v4, 0x2

    invoke-static {v3, v4}, Landroid/util/Base64;->encodeToString([BI)Ljava/lang/String;

    move-result-object v3

    invoke-interface {v0, v2, v3}, Landroid/content/SharedPreferences$Editor;->putString(Ljava/lang/String;Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    .line 72
    const-string v2, "password"

    iget-object v3, p1, Lru/oopssre/imperialschool/viewstv/ProxyOptions;->password:Ljava/lang/String;

    sget-object v6, Ljava/nio/charset/StandardCharsets;->UTF_8:Ljava/nio/charset/Charset;

    .line 73
    invoke-virtual {v3, v6}, Ljava/lang/String;->getBytes(Ljava/nio/charset/Charset;)[B

    move-result-object v3

    invoke-virtual {v1, v3}, Ljavax/crypto/Cipher;->doFinal([B)[B

    move-result-object v1

    .line 72
    invoke-static {v1, v4}, Landroid/util/Base64;->encodeToString([BI)Ljava/lang/String;

    move-result-object v1

    invoke-interface {v0, v2, v1}, Landroid/content/SharedPreferences$Editor;->putString(Ljava/lang/String;Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    .line 75
    :goto_1
    invoke-static {p1}, Lru/oopssre/imperialschool/viewstv/ProxyRouting;->apply(Lru/oopssre/imperialschool/viewstv/ProxyOptions;)V

    .line 76
    invoke-interface {v0}, Landroid/content/SharedPreferences$Editor;->apply()V

    .line 77
    iput-object p1, p0, Lru/oopssre/imperialschool/viewstv/ProxyPreferences;->current:Lru/oopssre/imperialschool/viewstv/ProxyOptions;

    .line 78
    iput-boolean v5, p0, Lru/oopssre/imperialschool/viewstv/ProxyPreferences;->unreadablePassword:Z
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 79
    monitor-exit p0

    return-void

    .line 62
    :cond_2
    :try_start_1
    new-instance p1, Ljava/lang/IllegalArgumentException;

    invoke-direct {p1, v0}, Ljava/lang/IllegalArgumentException;-><init>(Ljava/lang/String;)V

    throw p1

    :catchall_0
    move-exception p1

    monitor-exit p0
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    throw p1
.end method

.method unreadablePassword()Z
    .locals 1

    .line 58
    iget-boolean v0, p0, Lru/oopssre/imperialschool/viewstv/ProxyPreferences;->unreadablePassword:Z

    return v0
.end method
