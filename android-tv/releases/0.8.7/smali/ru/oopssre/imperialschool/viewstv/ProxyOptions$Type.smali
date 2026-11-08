.class final enum Lru/oopssre/imperialschool/viewstv/ProxyOptions$Type;
.super Ljava/lang/Enum;
.source "ProxyOptions.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lru/oopssre/imperialschool/viewstv/ProxyOptions;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x4018
    name = "Type"
.end annotation

.annotation system Ldalvik/annotation/Signature;
    value = {
        "Ljava/lang/Enum<",
        "Lru/oopssre/imperialschool/viewstv/ProxyOptions$Type;",
        ">;"
    }
.end annotation


# static fields
.field private static final synthetic $VALUES:[Lru/oopssre/imperialschool/viewstv/ProxyOptions$Type;

.field public static final enum HTTP:Lru/oopssre/imperialschool/viewstv/ProxyOptions$Type;

.field public static final enum SOCKS5:Lru/oopssre/imperialschool/viewstv/ProxyOptions$Type;


# direct methods
.method private static synthetic $values()[Lru/oopssre/imperialschool/viewstv/ProxyOptions$Type;
    .locals 2

    .line 8
    sget-object v0, Lru/oopssre/imperialschool/viewstv/ProxyOptions$Type;->SOCKS5:Lru/oopssre/imperialschool/viewstv/ProxyOptions$Type;

    sget-object v1, Lru/oopssre/imperialschool/viewstv/ProxyOptions$Type;->HTTP:Lru/oopssre/imperialschool/viewstv/ProxyOptions$Type;

    filled-new-array {v0, v1}, [Lru/oopssre/imperialschool/viewstv/ProxyOptions$Type;

    move-result-object v0

    return-object v0
.end method

.method static constructor <clinit>()V
    .locals 3

    .line 8
    new-instance v0, Lru/oopssre/imperialschool/viewstv/ProxyOptions$Type;

    const-string v1, "SOCKS5"

    const/4 v2, 0x0

    invoke-direct {v0, v1, v2}, Lru/oopssre/imperialschool/viewstv/ProxyOptions$Type;-><init>(Ljava/lang/String;I)V

    sput-object v0, Lru/oopssre/imperialschool/viewstv/ProxyOptions$Type;->SOCKS5:Lru/oopssre/imperialschool/viewstv/ProxyOptions$Type;

    new-instance v0, Lru/oopssre/imperialschool/viewstv/ProxyOptions$Type;

    const-string v1, "HTTP"

    const/4 v2, 0x1

    invoke-direct {v0, v1, v2}, Lru/oopssre/imperialschool/viewstv/ProxyOptions$Type;-><init>(Ljava/lang/String;I)V

    sput-object v0, Lru/oopssre/imperialschool/viewstv/ProxyOptions$Type;->HTTP:Lru/oopssre/imperialschool/viewstv/ProxyOptions$Type;

    invoke-static {}, Lru/oopssre/imperialschool/viewstv/ProxyOptions$Type;->$values()[Lru/oopssre/imperialschool/viewstv/ProxyOptions$Type;

    move-result-object v0

    sput-object v0, Lru/oopssre/imperialschool/viewstv/ProxyOptions$Type;->$VALUES:[Lru/oopssre/imperialschool/viewstv/ProxyOptions$Type;

    return-void
.end method

.method private constructor <init>(Ljava/lang/String;I)V
    .locals 0
    .annotation system Ldalvik/annotation/MethodParameters;
        accessFlags = {
            0x1000,
            0x1000
        }
        names = {
            null,
            null
        }
    .end annotation

    .annotation system Ldalvik/annotation/Signature;
        value = {
            "()V"
        }
    .end annotation

    .line 8
    invoke-direct {p0, p1, p2}, Ljava/lang/Enum;-><init>(Ljava/lang/String;I)V

    return-void
.end method

.method public static valueOf(Ljava/lang/String;)Lru/oopssre/imperialschool/viewstv/ProxyOptions$Type;
    .locals 1
    .annotation system Ldalvik/annotation/MethodParameters;
        accessFlags = {
            0x8000
        }
        names = {
            null
        }
    .end annotation

    .line 8
    const-class v0, Lru/oopssre/imperialschool/viewstv/ProxyOptions$Type;

    invoke-static {v0, p0}, Ljava/lang/Enum;->valueOf(Ljava/lang/Class;Ljava/lang/String;)Ljava/lang/Enum;

    move-result-object p0

    check-cast p0, Lru/oopssre/imperialschool/viewstv/ProxyOptions$Type;

    return-object p0
.end method

.method public static values()[Lru/oopssre/imperialschool/viewstv/ProxyOptions$Type;
    .locals 1

    .line 8
    sget-object v0, Lru/oopssre/imperialschool/viewstv/ProxyOptions$Type;->$VALUES:[Lru/oopssre/imperialschool/viewstv/ProxyOptions$Type;

    invoke-virtual {v0}, [Lru/oopssre/imperialschool/viewstv/ProxyOptions$Type;->clone()Ljava/lang/Object;

    move-result-object v0

    check-cast v0, [Lru/oopssre/imperialschool/viewstv/ProxyOptions$Type;

    return-object v0
.end method
