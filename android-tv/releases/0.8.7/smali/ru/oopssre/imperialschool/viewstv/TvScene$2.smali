.class Lru/oopssre/imperialschool/viewstv/TvScene$2;
.super Ljava/lang/Object;
.source "TvScene.java"

# interfaces
.implements Lru/oopssre/imperialschool/viewstv/VideoController$Listener;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lru/oopssre/imperialschool/viewstv/TvScene;-><init>(Lru/oopssre/imperialschool/viewstv/TvScene$Host;)V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic this$0:Lru/oopssre/imperialschool/viewstv/TvScene;


# direct methods
.method constructor <init>(Lru/oopssre/imperialschool/viewstv/TvScene;)V
    .locals 0
    .annotation system Ldalvik/annotation/MethodParameters;
        accessFlags = {
            0x8010
        }
        names = {
            null
        }
    .end annotation

    .line 60
    iput-object p1, p0, Lru/oopssre/imperialschool/viewstv/TvScene$2;->this$0:Lru/oopssre/imperialschool/viewstv/TvScene;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public catalogue()V
    .locals 1

    .line 60
    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/TvScene$2;->this$0:Lru/oopssre/imperialschool/viewstv/TvScene;

    invoke-virtual {v0}, Lru/oopssre/imperialschool/viewstv/TvScene;->catalogue()V

    return-void
.end method

.method public changed()V
    .locals 1

    .line 60
    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/TvScene$2;->this$0:Lru/oopssre/imperialschool/viewstv/TvScene;

    invoke-virtual {v0}, Lru/oopssre/imperialschool/viewstv/TvScene;->videoStatusChanged()V

    return-void
.end method
