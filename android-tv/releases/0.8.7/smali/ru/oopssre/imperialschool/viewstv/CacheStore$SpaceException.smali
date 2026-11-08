.class public final Lru/oopssre/imperialschool/viewstv/CacheStore$SpaceException;
.super Ljava/io/IOException;
.source "CacheStore.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lru/oopssre/imperialschool/viewstv/CacheStore;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x19
    name = "SpaceException"
.end annotation


# direct methods
.method constructor <init>()V
    .locals 1

    .line 14
    const-string v0, "\u041d\u0435\u0434\u043e\u0441\u0442\u0430\u0442\u043e\u0447\u043d\u043e \u043c\u0435\u0441\u0442\u0430 \u043d\u0430 \u0442\u0435\u043b\u0435\u0432\u0438\u0437\u043e\u0440\u0435"

    invoke-direct {p0, v0}, Ljava/io/IOException;-><init>(Ljava/lang/String;)V

    return-void
.end method
