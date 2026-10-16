# PureKiller GitHub Raw JSON integration

The DEX source is in:
- `smali/com/puremodx/purekiller/SignatureGuard.smali`
- `smali/com/puremodx/purekiller/RemoteSignatureGuard.smali`

Raw configuration URL:
`https://raw.githubusercontent.com/puremodx/PureModX-signature/main/PureModXsignature.json`

## Required Android permission

Add this to the app manifest, directly under the `<manifest>` element:

```xml
<uses-permission android:name="android.permission.INTERNET" />
```

## What it does

`RemoteSignatureGuard.verify(Context)` downloads the JSON over HTTPS, requires `enabled: true`, reads `certificate_sha256`, and checks the installed app signing certificate with `SignatureGuard.matches(Context, String)`.

`RemoteSignatureGuard.enforce(Context)` closes the app process when the request fails, JSON is invalid, the config is disabled, or the signer fingerprint mismatches.

## Call from a worker thread only

This code performs network I/O synchronously. **Do not call it on Android's main/UI thread.** Invoke it from a background thread or executor, then post UI changes to the main thread if needed. A simple Java-equivalent usage is:

```java
new Thread(() -> {
    RemoteSignatureGuard.enforce(getApplicationContext());
}).start();
```

In Smali, create/start a worker thread or use an existing background executor. Do not call `enforce` directly from `Application.onCreate()` on the main thread.

## JSON schema

```json
{
  "enabled": true,
  "algorithm": "SHA512withRSA",
  "certificate_sha256": "YOUR_CERTIFICATE_SHA256"
}
```

The `algorithm` field is informational in this implementation; certificate matching uses SHA-256 over the signing certificate bytes.

## Important limits

- GitHub Raw is public configuration, not a security authority. Anyone can read it, and a modified client can patch the URL, verifier, or failure path.
- A network failure fails closed in this implementation, so offline launches may close the app.
- The DEX source has been committed but has not been assembled and tested inside MT Manager in this environment. Test in a backup of an app you own before release.
- For valuable online features, use a server that independently authorizes each protected operation; a local check alone cannot guarantee anti-tamper protection.
