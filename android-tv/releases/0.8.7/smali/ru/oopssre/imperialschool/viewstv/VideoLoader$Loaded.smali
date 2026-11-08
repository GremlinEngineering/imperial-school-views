.class public final Lru/oopssre/imperialschool/viewstv/VideoLoader$Loaded;
.super Ljava/lang/Object;
.source "VideoLoader.java"

# interfaces
.implements Ljava/lang/AutoCloseable;


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lru/oopssre/imperialschool/viewstv/VideoLoader;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x11
    name = "Loaded"
.end annotation


# instance fields
.field private final closed:Ljava/util/concurrent/atomic/AtomicBoolean;

.field public final file:Ljava/io/File;

.field public final info:Lru/oopssre/imperialschool/viewstv/VideoInfo;

.field final synthetic this$0:Lru/oopssre/imperialschool/viewstv/VideoLoader;


# direct methods
.method constructor <init>(Lru/oopssre/imperialschool/viewstv/VideoLoader;Lru/oopssre/imperialschool/viewstv/VideoInfo;Ljava/io/File;)V
    .locals 0
    .annotation system Ldalvik/annotation/MethodParameters;
        accessFlags = {
            0x8010,
            0x0,
            0x0
        }
        names = {
            null,
            null,
            null
        }
    .end annotation

    .line 13
    iput-object p1, p0, Lru/oopssre/imperialschool/viewstv/VideoLoader$Loaded;->this$0:Lru/oopssre/imperialschool/viewstv/VideoLoader;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 12
    new-instance p1, Ljava/util/concurrent/atomic/AtomicBoolean;

    invoke-direct {p1}, Ljava/util/concurrent/atomic/AtomicBoolean;-><init>()V

    iput-object p1, p0, Lru/oopssre/imperialschool/viewstv/VideoLoader$Loaded;->closed:Ljava/util/concurrent/atomic/AtomicBoolean;

    .line 13
    iput-object p2, p0, Lru/oopssre/imperialschool/viewstv/VideoLoader$Loaded;->info:Lru/oopssre/imperialschool/viewstv/VideoInfo;

    iput-object p3, p0, Lru/oopssre/imperialschool/viewstv/VideoLoader$Loaded;->file:Ljava/io/File;

    return-void
.end method


# virtual methods
.method public close()V
    .locals 3

    .line 14
    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/VideoLoader$Loaded;->closed:Ljava/util/concurrent/atomic/AtomicBoolean;

    const/4 v1, 0x0

    const/4 v2, 0x1

    invoke-virtual {v0, v1, v2}, Ljava/util/concurrent/atomic/AtomicBoolean;->compareAndSet(ZZ)Z

    move-result v0

    if-eqz v0, :cond_0

    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/VideoLoader$Loaded;->this$0:Lru/oopssre/imperialschool/viewstv/VideoLoader;

    iget-object v0, v0, Lru/oopssre/imperialschool/viewstv/VideoLoader;->cache:Lru/oopssre/imperialschool/viewstv/CacheStore;

    iget-object v1, p0, Lru/oopssre/imperialschool/viewstv/VideoLoader$Loaded;->info:Lru/oopssre/imperialschool/viewstv/VideoInfo;

    iget-object v1, v1, Lru/oopssre/imperialschool/viewstv/VideoInfo;->sha:Ljava/lang/String;

    invoke-virtual {v0, v1}, Lru/oopssre/imperialschool/viewstv/CacheStore;->unpinVideo(Ljava/lang/String;)V

    :cond_0
    return-void
.end method
