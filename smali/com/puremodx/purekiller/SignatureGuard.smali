.class public final Lcom/puremodx/purekiller/SignatureGuard;
.super Ljava/lang/Object;
.source "SignatureGuard.java"

# Local signing-certificate SHA-256 pin check for apps you own.
# matches(Context, String) returns true only when a current signer fingerprint matches.
# This does not fetch remote config and cannot prevent a determined DEX patch.

.method private constructor <init>()V
    .locals 0
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V
    return-void
.end method

.method public static matches(Landroid/content/Context;Ljava/lang/String;)Z
    .locals 12

    if-eqz p0, :fail
    if-eqz p1, :fail

    invoke-virtual {p1}, Ljava/lang/String;->trim()Ljava/lang/String;
    move-result-object v0

    const-string v1, ":"
    const-string v2, ""
    invoke-virtual {v0, v1, v2}, Ljava/lang/String;->replace(Ljava/lang/CharSequence;Ljava/lang/CharSequence;)Ljava/lang/String;
    move-result-object v0

    const-string v1, " "
    const-string v2, ""
    invoke-virtual {v0, v1, v2}, Ljava/lang/String;->replace(Ljava/lang/CharSequence;Ljava/lang/CharSequence;)Ljava/lang/String;
    move-result-object v0

    sget-object v1, Ljava/util/Locale;->ROOT:Ljava/util/Locale;
    invoke-virtual {v0, v1}, Ljava/lang/String;->toUpperCase(Ljava/util/Locale;)Ljava/lang/String;
    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/String;->length()I
    move-result v1
    const/16 v2, 0x40
    if-ne v1, v2, :fail

    :try_start
    invoke-virtual {p0}, Landroid/content/Context;->getPackageManager()Landroid/content/pm/PackageManager;
    move-result-object v1

    invoke-virtual {p0}, Landroid/content/Context;->getPackageName()Ljava/lang/String;
    move-result-object v2

    sget v3, Landroid/os/Build$VERSION;->SDK_INT:I
    const/16 v4, 0x1c
    if-lt v3, v4, :legacy

    const/16 v3, 0x0800
    invoke-virtual {v1, v2, v3}, Landroid/content/pm/PackageManager;->getPackageInfo(Ljava/lang/String;I)Landroid/content/pm/PackageInfo;
    move-result-object v3

    iget-object v4, v3, Landroid/content/pm/PackageInfo;->signingInfo:Landroid/content/pm/SigningInfo;
    if-eqz v4, :fail

    invoke-virtual {v4}, Landroid/content/pm/SigningInfo;->getApkContentsSigners()[Landroid/content/pm/Signature;
    move-result-object v5
    goto :hash_signers

    :legacy
    const/16 v3, 0x40
    invoke-virtual {v1, v2, v3}, Landroid/content/pm/PackageManager;->getPackageInfo(Ljava/lang/String;I)Landroid/content/pm/PackageInfo;
    move-result-object v3

    iget-object v5, v3, Landroid/content/pm/PackageInfo;->signatures:[Landroid/content/pm/Signature;

    :hash_signers
    if-eqz v5, :fail
    array-length v6, v5
    if-eqz v6, :fail

    const-string v7, "SHA-256"
    invoke-static {v7}, Ljava/security/MessageDigest;->getInstance(Ljava/lang/String;)Ljava/security/MessageDigest;
    move-result-object v7

    const/4 v8, 0x0

    :loop
    if-ge v8, v6, :fail

    aget-object v9, v5, v8
    invoke-virtual {v9}, Landroid/content/pm/Signature;->toByteArray()[B
    move-result-object v10

    invoke-virtual {v7, v10}, Ljava/security/MessageDigest;->digest([B)[B
    move-result-object v10

    invoke-static {v10}, Lcom/puremodx/purekiller/SignatureGuard;->toHex([B)Ljava/lang/String;
    move-result-object v10

    invoke-virtual {v0, v10}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v11
    if-eqz v11, :next
    const/4 v11, 0x1
    return v11

    :next
    add-int/lit8 v8, v8, 0x1
    goto :loop

    :try_end
    .catch Ljava/lang/Exception; {:try_start .. :try_end} :fail

    :fail
    const/4 v0, 0x0
    return v0
.end method

.method private static toHex([B)Ljava/lang/String;
    .locals 7

    new-instance v0, Ljava/lang/StringBuilder;
    array-length v1, p0
    mul-int/lit8 v1, v1, 0x2
    invoke-direct {v0, v1}, Ljava/lang/StringBuilder;-><init>(I)V

    array-length v1, p0
    const/4 v2, 0x0

    :hex_loop
    if-ge v2, v1, :hex_done

    aget-byte v3, p0, v2
    and-int/lit16 v3, v3, 0xff

    const/16 v4, 0x10
    if-ge v3, v4, :hex_append
    const-string v5, "0"
    invoke-virtual {v0, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    :hex_append
    const/16 v4, 0x10
    invoke-static {v3, v4}, Ljava/lang/Integer;->toString(II)Ljava/lang/String;
    move-result-object v5
    invoke-virtual {v0, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    add-int/lit8 v2, v2, 0x1
    goto :hex_loop

    :hex_done
    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v0

    sget-object v1, Ljava/util/Locale;->ROOT:Ljava/util/Locale;
    invoke-virtual {v0, v1}, Ljava/lang/String;->toUpperCase(Ljava/util/Locale;)Ljava/lang/String;
    move-result-object v0
    return-object v0
.end method
