# Android Release Signing (prevents data loss on updates)

Losing all student names/accounts/results after “installing a new version” usually
means the old app was **uninstalled** before the new one was installed. Android
removes an app’s local data on uninstall.

## Why uninstall happens during updates
- **Different signing key:** Android only allows an update if the new APK/AAB is
  signed with the **same certificate** as the installed app. If keys differ,
  install fails and users often uninstall the old app first — deleting
  `math_heroes.sqlite` and all local progress.
- **Manual uninstall / Clear data** also deletes local data.

App identity must stay the same for updates:
- `applicationId`: `com.mathheroes.math_heroes`
- `versionCode`/`versionName`: from `pubspec.yaml` (currently `1.0.0+1`; bump
  `+number` for every release)

## This project’s release signing
`android/app/build.gradle` now supports a stable release keystore:
- If `android/key.properties` exists and points to a valid keystore file,
  **release** builds use it.
- Otherwise release builds fall back to the **debug** keystore (development
  convenience), which is risky for distributed updates.

`android/key.properties` and keystore files are gitignored.

## One-time setup
1. Create or obtain a release keystore (keep it backed up securely):
   ```bash
   keytool -genkeypair -v -keystore android/app/upload-keystore.jks \
     -keyalg RSA -keysize 2048 -validity 10000 -alias upload
   ```
2. Copy `android/key.properties.example` to `android/key.properties` and fill
   passwords/alias/path.
3. Build with the same command you use now; release signing will use that key.

## Updating devices without losing data
- **Never uninstall** the existing app before updating.
- Install an update signed with the **same key** as the installed version:
  ```bash
  adb install -r path/to/app-release.apk
  ```
- Check signatures before distributing a new build:
  ```bash
  apksigner verify --print-certs old.apk new.apk
  ```
  The certificate (SHA-256/SHA-1/subject) must match for an in-place update.

## If users already installed with different debug keys
Previous builds may have used the default Flutter debug keystore
(`~/.android/debug.keystore`) on a specific machine. Updates must use that same
keystore to preserve those installs. If you cannot use the same key, users must
reinstall and local data cannot be recovered unless they previously exported a
parent report (JSON/CSV) — exports do not restore the full app database.

## Data location
Local data is stored in the app sandbox, including the SQLite database created
by `lib/core/database/app_database.dart` (`math_heroes.sqlite`). Schema upgrades
in this project add columns/migrate data; they do not delete student data.
