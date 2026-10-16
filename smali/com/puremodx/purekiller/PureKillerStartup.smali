.class public final Lcom/puremodx/purekiller/PureKillerStartup;
.super Ljava/lang/Object;

.method private constructor <init>()V
    .locals 0
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V
    return-void
.end method

# Insert after invoke-super in Application.onCreate or Activity.onCreate:
# invoke-static {p0}, Lcom/puremodx/purekiller/PureKillerStartup;->start(Landroid/content/Context;)V
.method public static start(Landroid/content/Context;)V
    .locals 2
    if-eqz p0, :done
    new-instance v0, Ljava/lang/Thread;
    new-instance v1, Lcom/puremodx/purekiller/PureKillerWorker;
    invoke-direct {v1, p0}, Lcom/puremodx/purekiller/PureKillerWorker;-><init>(Landroid/content/Context;)V
    invoke-direct {v0, v1}, Ljava/lang/Thread;-><init>(Ljava/lang/Runnable;)V
    const-string v1, "PureKiller-Verify"
    invoke-virtual {v0, v1}, Ljava/lang/Thread;->setName(Ljava/lang/String;)V
    invoke-virtual {v0}, Ljava/lang/Thread;->start()V
    :done
    return-void
.end method
