# Bundled Database Asset

- `secure_insurance_v3.db` — SQLCipher encrypted database (password: `1234567890`)
- User fields `name`, `phone`, `nrc` use per-column AES keys with random IV (`iv.base64:cipher.base64`)
- `address` is stored as plain text

## Regenerate the file

```bash
flutter run -t tool/generate_database.dart -d <device-id>
```

Then pull from the device:

```bash
adb shell run-as com.sawhtunaung.firebaseappdistribution cp app_flutter/secure_insurance_v3.db /sdcard/Download/secure_insurance_v3.db
adb pull /sdcard/Download/secure_insurance_v3.db assets/database/secure_insurance_v3.db
```

## App behavior

On first launch, the app copies `assets/database/secure_insurance_v3.db` to:

`documents/db/secure_insurance_v3.db`

Database version 3 re-seeds user rows with the new per-column encryption format.

No password input is required in the UI.

## SQL injection test

Static checks on the bundled file:

```bash
flutter test test/bundled_db_sql_injection_test.dart
```

Live SQLCipher injection test on Android (recommended):

```bash
flutter test integration_test/bundled_db_sql_injection_test.dart -d <device-id>
```

Alternative one-shot tool (may keep `flutter run` attached after completion):

```bash
flutter run -t tool/test_bundled_db_sql_injection.dart -d <device-id>
```
