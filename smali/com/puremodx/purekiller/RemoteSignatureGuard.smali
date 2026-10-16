.class public final Lcom/puremodx/purekiller/RemoteSignatureGuard;
.super Ljava/lang/Object;
.source "RemoteSignatureGuard.java"

# Reads public GitHub Raw JSON and compares certificate_sha256 with the
# installed app signing certificate. Call verify(Context) on a worker thread.
# Network config is public and can be patched/redirected in a modified client.

.field public static final CONFIG_URL:Ljava/lang/String; = "https://raw.githubusercontent.com/puremodx/PureModX-signature/main/PureModXsignature.json"

.method private constructor <init>()V
    .locals 0
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V
    return-void
.end method

.method public static verify(Landroid/content/Context;)Z
    .locals 16

    if-eqz p0, :no

    :try_start
    new-instance v0, Ljava/net/URL;
    sget-object v1, Lcom/puremodx/purekiller/RemoteSignatureGuard;->CONFIG_URL:Ljava/lang/String;
    invoke-direct {v0, v1}, Ljava/net/URL;-><init>(Ljava/lang/String;)V

    invoke-virtual {v0}, Ljava/net/URL;->openConnection()Ljava/net/URLConnection;
    move-result-object v0

    const/16 v1, 0x3a98
    invoke-virtual {v0, v1}, Ljava/net/URLConnection;->setConnectTimeout(I)V
    invoke-virtual {v0, v1}, Ljava/net/URLConnection;->setReadTimeout(I)V

    const-string v1, "Accept"
    const-string v2, "application/json"
    invoke-virtual {v0, v1, v2}, Ljava/net/URLConnection;->setRequestProperty(Ljava/lang/String;Ljava/lang/String;)V

    invoke-virtual {v0}, Ljava/net/URLConnection;->getInputStream()Ljava/io/InputStream;
    move-result-object v1

    new-instance v2, Ljava/io/ByteArrayOutputStream;
    invoke-direct {v2}, Ljava/io/ByteArrayOutputStream;-><init>()V

    const/16 v3, 0x400
    new-array v3, v3, [B

    :read_loop
    invoke-virtual {v1, v3}, Ljava/io/InputStream;->read([B)I
    move-result v4
    if-lez v4, :read_done
    const/16 v5, 0x10000
    invoke-virtual {v2}, Ljava/io/ByteArrayOutputStream;->size()I
    move-result v6
    add-int/2addr v6, v4
    if-gt v6, v5, :no_close
    const/4 v5, 0x0
    invoke-virtual {v2, v3, v5, v4}, Ljava/io/ByteArrayOutputStream;->write([BII)V
    goto :read_loop

    :read_done
    invoke-virtual {v1}, Ljava/io/InputStream;->close()V
    const-string v3, "UTF-8"
    invoke-virtual {v2, v3}, Ljava/io/ByteArrayOutputStream;->toString(Ljava/lang/String;)Ljava/lang/String;
    move-result-object v2

    new-instance v3, Lorg/json/JSONObject;
    invoke-direct {v3, v2}, Lorg/json/JSONObject;-><init>(Ljava/lang/String;)V

    const-string v2, "enabled"
    invoke-virtual {v3, v2}, Lorg/json/JSONObject;->optBoolean(Ljava/lang/String;)Z
    move-result v2
    if-eqz v2, :no

    const-string v2, "certificate_sha256"
    invoke-virtual {v3, v2}, Lorg/json/JSONObject;->optString(Ljava/lang/String;)Ljava/lang/String;
    move-result-object v2

    invoke-static {p0, v2}, Lcom/puremodx/purekiller/SignatureGuard;->matches(Landroid/content/Context;Ljava/lang/String;)Z
    move-result v2
    return v2

    :no_close
    invoke-virtual {v1}, Ljava/io/InputStream;->close()V
    goto :no

    :try_end
    .catch Ljava/lang/Exception; {:try_start .. :try_end} :no

    :no
    const/4 v0, 0x0
    return v0
.end method

# Call this only from a worker thread. It closes the app process on any
# failed config fetch, disabled config, malformed JSON, or certificate mismatch.
.method public static enforce(Landroid/content/Context;)V
    .locals 1

    invoke-static {p0}, Lcom/puremodx/purekiller/RemoteSignatureGuard;->verify(Landroid/content/Context;)Z
    move-result v0
    if-nez v0, :done

    invoke-static {}, Landroid/os/Process;->myPid()I
    move-result v0
    invoke-static {v0}, Landroid/os/Process;->killProcess(I)V
    const/16 v0, 0xa
    invoke-static {v0}, Ljava/lang/System;->exit(I)V

    :done
    return-void
.end method
