.class final enum Lru/oopssre/imperialschool/viewstv/SceneMusic$PlayerState;
.super Ljava/lang/Enum;
.source "SceneMusic.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lru/oopssre/imperialschool/viewstv/SceneMusic;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x4018
    name = "PlayerState"
.end annotation

.annotation system Ldalvik/annotation/Signature;
    value = {
        "Ljava/lang/Enum<",
        "Lru/oopssre/imperialschool/viewstv/SceneMusic$PlayerState;",
        ">;"
    }
.end annotation


# static fields
.field private static final synthetic $VALUES:[Lru/oopssre/imperialschool/viewstv/SceneMusic$PlayerState;

.field public static final enum IDLE:Lru/oopssre/imperialschool/viewstv/SceneMusic$PlayerState;

.field public static final enum PAUSED:Lru/oopssre/imperialschool/viewstv/SceneMusic$PlayerState;

.field public static final enum PLAYING:Lru/oopssre/imperialschool/viewstv/SceneMusic$PlayerState;

.field public static final enum PREPARING:Lru/oopssre/imperialschool/viewstv/SceneMusic$PlayerState;

.field public static final enum READY:Lru/oopssre/imperialschool/viewstv/SceneMusic$PlayerState;

.field public static final enum STARTING:Lru/oopssre/imperialschool/viewstv/SceneMusic$PlayerState;


# direct methods
.method private static synthetic $values()[Lru/oopssre/imperialschool/viewstv/SceneMusic$PlayerState;
    .locals 6

    .line 25
    sget-object v0, Lru/oopssre/imperialschool/viewstv/SceneMusic$PlayerState;->IDLE:Lru/oopssre/imperialschool/viewstv/SceneMusic$PlayerState;

    sget-object v1, Lru/oopssre/imperialschool/viewstv/SceneMusic$PlayerState;->PREPARING:Lru/oopssre/imperialschool/viewstv/SceneMusic$PlayerState;

    sget-object v2, Lru/oopssre/imperialschool/viewstv/SceneMusic$PlayerState;->READY:Lru/oopssre/imperialschool/viewstv/SceneMusic$PlayerState;

    sget-object v3, Lru/oopssre/imperialschool/viewstv/SceneMusic$PlayerState;->STARTING:Lru/oopssre/imperialschool/viewstv/SceneMusic$PlayerState;

    sget-object v4, Lru/oopssre/imperialschool/viewstv/SceneMusic$PlayerState;->PLAYING:Lru/oopssre/imperialschool/viewstv/SceneMusic$PlayerState;

    sget-object v5, Lru/oopssre/imperialschool/viewstv/SceneMusic$PlayerState;->PAUSED:Lru/oopssre/imperialschool/viewstv/SceneMusic$PlayerState;

    filled-new-array/range {v0 .. v5}, [Lru/oopssre/imperialschool/viewstv/SceneMusic$PlayerState;

    move-result-object v0

    return-object v0
.end method

.method static constructor <clinit>()V
    .locals 3

    .line 25
    new-instance v0, Lru/oopssre/imperialschool/viewstv/SceneMusic$PlayerState;

    const-string v1, "IDLE"

    const/4 v2, 0x0

    invoke-direct {v0, v1, v2}, Lru/oopssre/imperialschool/viewstv/SceneMusic$PlayerState;-><init>(Ljava/lang/String;I)V

    sput-object v0, Lru/oopssre/imperialschool/viewstv/SceneMusic$PlayerState;->IDLE:Lru/oopssre/imperialschool/viewstv/SceneMusic$PlayerState;

    new-instance v0, Lru/oopssre/imperialschool/viewstv/SceneMusic$PlayerState;

    const-string v1, "PREPARING"

    const/4 v2, 0x1

    invoke-direct {v0, v1, v2}, Lru/oopssre/imperialschool/viewstv/SceneMusic$PlayerState;-><init>(Ljava/lang/String;I)V

    sput-object v0, Lru/oopssre/imperialschool/viewstv/SceneMusic$PlayerState;->PREPARING:Lru/oopssre/imperialschool/viewstv/SceneMusic$PlayerState;

    new-instance v0, Lru/oopssre/imperialschool/viewstv/SceneMusic$PlayerState;

    const-string v1, "READY"

    const/4 v2, 0x2

    invoke-direct {v0, v1, v2}, Lru/oopssre/imperialschool/viewstv/SceneMusic$PlayerState;-><init>(Ljava/lang/String;I)V

    sput-object v0, Lru/oopssre/imperialschool/viewstv/SceneMusic$PlayerState;->READY:Lru/oopssre/imperialschool/viewstv/SceneMusic$PlayerState;

    new-instance v0, Lru/oopssre/imperialschool/viewstv/SceneMusic$PlayerState;

    const-string v1, "STARTING"

    const/4 v2, 0x3

    invoke-direct {v0, v1, v2}, Lru/oopssre/imperialschool/viewstv/SceneMusic$PlayerState;-><init>(Ljava/lang/String;I)V

    sput-object v0, Lru/oopssre/imperialschool/viewstv/SceneMusic$PlayerState;->STARTING:Lru/oopssre/imperialschool/viewstv/SceneMusic$PlayerState;

    new-instance v0, Lru/oopssre/imperialschool/viewstv/SceneMusic$PlayerState;

    const-string v1, "PLAYING"

    const/4 v2, 0x4

    invoke-direct {v0, v1, v2}, Lru/oopssre/imperialschool/viewstv/SceneMusic$PlayerState;-><init>(Ljava/lang/String;I)V

    sput-object v0, Lru/oopssre/imperialschool/viewstv/SceneMusic$PlayerState;->PLAYING:Lru/oopssre/imperialschool/viewstv/SceneMusic$PlayerState;

    new-instance v0, Lru/oopssre/imperialschool/viewstv/SceneMusic$PlayerState;

    const-string v1, "PAUSED"

    const/4 v2, 0x5

    invoke-direct {v0, v1, v2}, Lru/oopssre/imperialschool/viewstv/SceneMusic$PlayerState;-><init>(Ljava/lang/String;I)V

    sput-object v0, Lru/oopssre/imperialschool/viewstv/SceneMusic$PlayerState;->PAUSED:Lru/oopssre/imperialschool/viewstv/SceneMusic$PlayerState;

    invoke-static {}, Lru/oopssre/imperialschool/viewstv/SceneMusic$PlayerState;->$values()[Lru/oopssre/imperialschool/viewstv/SceneMusic$PlayerState;

    move-result-object v0

    sput-object v0, Lru/oopssre/imperialschool/viewstv/SceneMusic$PlayerState;->$VALUES:[Lru/oopssre/imperialschool/viewstv/SceneMusic$PlayerState;

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

    .line 25
    invoke-direct {p0, p1, p2}, Ljava/lang/Enum;-><init>(Ljava/lang/String;I)V

    return-void
.end method

.method public static valueOf(Ljava/lang/String;)Lru/oopssre/imperialschool/viewstv/SceneMusic$PlayerState;
    .locals 1
    .annotation system Ldalvik/annotation/MethodParameters;
        accessFlags = {
            0x8000
        }
        names = {
            null
        }
    .end annotation

    .line 25
    const-class v0, Lru/oopssre/imperialschool/viewstv/SceneMusic$PlayerState;

    invoke-static {v0, p0}, Ljava/lang/Enum;->valueOf(Ljava/lang/Class;Ljava/lang/String;)Ljava/lang/Enum;

    move-result-object p0

    check-cast p0, Lru/oopssre/imperialschool/viewstv/SceneMusic$PlayerState;

    return-object p0
.end method

.method public static values()[Lru/oopssre/imperialschool/viewstv/SceneMusic$PlayerState;
    .locals 1

    .line 25
    sget-object v0, Lru/oopssre/imperialschool/viewstv/SceneMusic$PlayerState;->$VALUES:[Lru/oopssre/imperialschool/viewstv/SceneMusic$PlayerState;

    invoke-virtual {v0}, [Lru/oopssre/imperialschool/viewstv/SceneMusic$PlayerState;->clone()Ljava/lang/Object;

    move-result-object v0

    check-cast v0, [Lru/oopssre/imperialschool/viewstv/SceneMusic$PlayerState;

    return-object v0
.end method
