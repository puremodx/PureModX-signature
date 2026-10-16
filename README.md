# PureKiller — MT Manager Smali starter

Reusable local signing-certificate pin-check source for Android applications you own or are authorized to modify.

## Files

- `smali/com/puremodx/purekiller/SignatureGuard.smali` — checks installed signer certificate SHA-256 against a fingerprint passed by the app.
- `config/purekiller.json.example` — public GitHub Raw configuration example.
- `INTEGRATION.md` — MT Manager integration steps.

## Security limits

This is a local integrity check, not an unpatchable protection. A repackager able to modify DEX can patch out the check. GitHub Raw is public configuration hosting, not an authoritative verification backend. Never put secrets or private keys in the JSON file. For protected online features, have your own HTTPS backend independently authorize requests.

Use the SHA-256 digest of the signing certificate, not the APK file hash. Update the pin when you intentionally change signing keys, and account for valid signing-key rotation.

See [INTEGRATION.md](INTEGRATION.md) for MT Manager integration steps.