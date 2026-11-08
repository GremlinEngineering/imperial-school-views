.class Lru/oopssre/imperialschool/viewstv/RadioPlayback$1;
.super Ljava/lang/Object;
.source "RadioPlayback.java"

# interfaces
.implements Landroidx/media3/common/Player$Listener;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lru/oopssre/imperialschool/viewstv/RadioPlayback;->createEngine()V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic this$0:Lru/oopssre/imperialschool/viewstv/RadioPlayback;


# direct methods
.method constructor <init>(Lru/oopssre/imperialschool/viewstv/RadioPlayback;)V
    .locals 0
    .annotation system Ldalvik/annotation/MethodParameters;
        accessFlags = {
            0x8010
        }
        names = {
            null
        }
    .end annotation

    .line 76
    iput-object p1, p0, Lru/oopssre/imperialschool/viewstv/RadioPlayback$1;->this$0:Lru/oopssre/imperialschool/viewstv/RadioPlayback;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public onEvents(Landroidx/media3/common/Player;Landroidx/media3/common/Player$Events;)V
    .locals 2

    .line 78
    iget-object p2, p0, Lru/oopssre/imperialschool/viewstv/RadioPlayback$1;->this$0:Lru/oopssre/imperialschool/viewstv/RadioPlayback;

    invoke-static {p2}, Lru/oopssre/imperialschool/viewstv/RadioPlayback;->access$000(Lru/oopssre/imperialschool/viewstv/RadioPlayback;)Lru/oopssre/imperialschool/viewstv/RadioPlayback$Session;

    move-result-object p2

    .line 79
    invoke-interface {p1}, Landroidx/media3/common/Player;->getCurrentMediaItem()Landroidx/media3/common/MediaItem;

    move-result-object v0

    if-eqz p2, :cond_0

    if-eqz v0, :cond_0

    .line 80
    iget-object v1, p2, Lru/oopssre/imperialschool/viewstv/RadioPlayback$Session;->id:Ljava/lang/String;

    iget-object v0, v0, Landroidx/media3/common/MediaItem;->mediaId:Ljava/lang/String;

    invoke-virtual {v1, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_0

    invoke-virtual {p2, p1}, Lru/oopssre/imperialschool/viewstv/RadioPlayback$Session;->report(Landroidx/media3/common/Player;)V

    :cond_0
    return-void
.end method
