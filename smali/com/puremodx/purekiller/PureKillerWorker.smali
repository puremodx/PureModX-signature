.class public final Lcom/puremodx/purekiller/PureKillerWorker;
.super Ljava/lang/Object;
.implements Ljava/lang/Runnable;

.field private final appContext:Landroid/content/Context;

.method public constructor <init>(Landroid/content/Context;)V
    .locals 0
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V
    invoke-virtual {p1}, Landroid/content/Context;->getApplicationContext()Landroid/content/Context;
    move-result-object p1
    iput-object p1, p0, Lcom/puremodx/purekiller/PureKillerWorker;->appContext:Landroid/content/Context;
    return-void
.end method

.method public run()V
    .locals 1
    iget-object v0, p0, Lcom/puremodx/purekiller/PureKillerWorker;->appContext:Landroid/content/Context;
    invoke-static {v0}, Lcom/puremodx/purekiller/RemoteSignatureGuard;->enforce(Landroid/content/Context;)V
    return-void
.end method
