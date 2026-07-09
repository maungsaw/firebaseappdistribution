# Bundled Database Asset

- `secure_insurance_v3.db` — SQLCipher encrypted database (password: `1234567890`)

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

No password input is required in the UI.
