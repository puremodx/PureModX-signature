# MT Manager integration

1. Back up your APK. Only modify apps you own or are authorized to change.
2. Open the APK in MT Manager and use its DEX/Smali editor.
3. Add `SignatureGuard.smali` at `com/puremodx/purekiller/SignatureGuard.smali`, avoiding duplicate class names and ensuring it is placed in a DEX that MT Manager can rebuild.
4. Obtain the SHA-256 fingerprint of your intended release signing certificate from a trusted build using `apksigner verify --print-certs app-release.apk` or your signing keystore details. It must be the certificate digest, not the APK file digest.
5. From app startup, call `SignatureGuard.matches(Context, String)` with the app context and your 64-character fingerprint. If it returns false, take your app's failure path (for example, finish the task and disable protected features).
6. Rebuild, sign with your release key, install, and test both the normal build and a deliberately re-signed test build.

## GitHub Raw config

This repository includes a public JSON example at `config/purekiller.json.example`. Upload it to your default branch and use the `raw.githubusercontent.com` URL for public, non-secret settings only. The provided Smali class does not download this JSON; the host app needs separate HTTPS fetching and JSON parsing if you require remote settings. Treat remote JSON as configuration, never as proof of authenticity by itself.

## Important

A DEX-resident check can be patched by an attacker who can modify the client. It cannot guarantee that verification survives signature-kill tools. Use a backend that independently authorizes sensitive operations when stronger enforcement is required.