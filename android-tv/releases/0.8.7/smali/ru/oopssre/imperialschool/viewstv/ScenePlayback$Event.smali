.class public final enum Lru/oopssre/imperialschool/viewstv/ScenePlayback$Event;
.super Ljava/lang/Enum;
.source "ScenePlayback.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lru/oopssre/imperialschool/viewstv/ScenePlayback;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x4019
    name = "Event"
.end annotation

.annotation system Ldalvik/annotation/Signature;
    value = {
        "Ljava/lang/Enum<",
        "Lru/oopssre/imperialschool/viewstv/ScenePlayback$Event;",
        ">;"
    }
.end annotation


# static fields
.field private static final synthetic $VALUES:[Lru/oopssre/imperialschool/viewstv/ScenePlayback$Event;

.field public static final enum BUFFERING:Lru/oopssre/imperialschool/viewstv/ScenePlayback$Event;

.field public static final enum COMPLETED:Lru/oopssre/imperialschool/viewstv/ScenePlayback$Event;

.field public static final enum FAILED:Lru/oopssre/imperialschool/viewstv/ScenePlayback$Event;

.field public static final enum PREPARED:Lru/oopssre/imperialschool/viewstv/ScenePlayback$Event;

.field public static final enum STARTED:Lru/oopssre/imperialschool/viewstv/ScenePlayback$Event;


# direct methods
.method private static synthetic $values()[Lru/oopssre/imperialschool/viewstv/ScenePlayback$Event;
    .locals 5

    .line 4
    sget-object v0, Lru/oopssre/imperialschool/viewstv/ScenePlayback$Event;->PREPARED:Lru/oopssre/imperialschool/viewstv/ScenePlayback$Event;

    sget-object v1, Lru/oopssre/imperialschool/viewstv/ScenePlayback$Event;->STARTED:Lru/oopssre/imperialschool/viewstv/ScenePlayback$Event;

    sget-object v2, Lru/oopssre/imperialschool/viewstv/ScenePlayback$Event;->BUFFERING:Lru/oopssre/imperialschool/viewstv/ScenePlayback$Event;

    sget-object v3, Lru/oopssre/imperialschool/viewstv/ScenePlayback$Event;->COMPLETED:Lru/oopssre/imperialschool/viewstv/ScenePlayback$Event;

    sget-object v4, Lru/oopssre/imperialschool/viewstv/ScenePlayback$Event;->FAILED:Lru/oopssre/imperialschool/viewstv/ScenePlayback$Event;

    filled-new-array {v0, v1, v2, v3, v4}, [Lru/oopssre/imperialschool/viewstv/ScenePlayback$Event;

    move-result-object v0

    return-object v0
.end method

.method static constructor <clinit>()V
    .locals 3

    .line 4
    new-instance v0, Lru/oopssre/imperialschool/viewstv/ScenePlayback$Event;

    const-string v1, "PREPARED"

    const/4 v2, 0x0

    invoke-direct {v0, v1, v2}, Lru/oopssre/imperialschool/viewstv/ScenePlayback$Event;-><init>(Ljava/lang/String;I)V

    sput-object v0, Lru/oopssre/imperialschool/viewstv/ScenePlayback$Event;->PREPARED:Lru/oopssre/imperialschool/viewstv/ScenePlayback$Event;

    new-instance v0, Lru/oopssre/imperialschool/viewstv/ScenePlayback$Event;

    const-string v1, "STARTED"

    const/4 v2, 0x1

    invoke-direct {v0, v1, v2}, Lru/oopssre/imperialschool/viewstv/ScenePlayback$Event;-><init>(Ljava/lang/String;I)V

    sput-object v0, Lru/oopssre/imperialschool/viewstv/ScenePlayback$Event;->STARTED:Lru/oopssre/imperialschool/viewstv/ScenePlayback$Event;

    new-instance v0, Lru/oopssre/imperialschool/viewstv/ScenePlayback$Event;

    const-string v1, "BUFFERING"

    const/4 v2, 0x2

    invoke-direct {v0, v1, v2}, Lru/oopssre/imperialschool/viewstv/ScenePlayback$Event;-><init>(Ljava/lang/String;I)V

    sput-object v0, Lru/oopssre/imperialschool/viewstv/ScenePlayback$Event;->BUFFERING:Lru/oopssre/imperialschool/viewstv/ScenePlayback$Event;

    new-instance v0, Lru/oopssre/imperialschool/viewstv/ScenePlayback$Event;

    const-string v1, "COMPLETED"

    const/4 v2, 0x3

    invoke-direct {v0, v1, v2}, Lru/oopssre/imperialschool/viewstv/ScenePlayback$Event;-><init>(Ljava/lang/String;I)V

    sput-object v0, Lru/oopssre/imperialschool/viewstv/ScenePlayback$Event;->COMPLETED:Lru/oopssre/imperialschool/viewstv/ScenePlayback$Event;

    new-instance v0, Lru/oopssre/imperialschool/viewstv/ScenePlayback$Event;

    const-string v1, "FAILED"

    const/4 v2, 0x4

    invoke-direct {v0, v1, v2}, Lru/oopssre/imperialschool/viewstv/ScenePlayback$Event;-><init>(Ljava/lang/String;I)V

    sput-object v0, Lru/oopssre/imperialschool/viewstv/ScenePlayback$Event;->FAILED:Lru/oopssre/imperialschool/viewstv/ScenePlayback$Event;

    invoke-static {}, Lru/oopssre/imperialschool/viewstv/ScenePlayback$Event;->$values()[Lru/oopssre/imperialschool/viewstv/ScenePlayback$Event;

    move-result-object v0

    sput-object v0, Lru/oopssre/imperialschool/viewstv/ScenePlayback$Event;->$VALUES:[Lru/oopssre/imperialschool/viewstv/ScenePlayback$Event;

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

    .line 4
    invoke-direct {p0, p1, p2}, Ljava/lang/Enum;-><init>(Ljava/lang/String;I)V

    return-void
.end method

.method public static valueOf(Ljava/lang/String;)Lru/oopssre/imperialschool/viewstv/ScenePlayback$Event;
    .locals 1
    .annotation system Ldalvik/annotation/MethodParameters;
        accessFlags = {
            0x8000
        }
        names = {
            null
        }
    .end annotation

    .line 4
    const-class v0, Lru/oopssre/imperialschool/viewstv/ScenePlayback$Event;

    invoke-static {v0, p0}, Ljava/lang/Enum;->valueOf(Ljava/lang/Class;Ljava/lang/String;)Ljava/lang/Enum;

    move-result-object p0

    check-cast p0, Lru/oopssre/imperialschool/viewstv/ScenePlayback$Event;

    return-object p0
.end method

.method public static values()[Lru/oopssre/imperialschool/viewstv/ScenePlayback$Event;
    .locals 1

    .line 4
    sget-object v0, Lru/oopssre/imperialschool/viewstv/ScenePlayback$Event;->$VALUES:[Lru/oopssre/imperialschool/viewstv/ScenePlayback$Event;

    invoke-virtual {v0}, [Lru/oopssre/imperialschool/viewstv/ScenePlayback$Event;->clone()Ljava/lang/Object;

    move-result-object v0

    check-cast v0, [Lru/oopssre/imperialschool/viewstv/ScenePlayback$Event;

    return-object v0
.end method
