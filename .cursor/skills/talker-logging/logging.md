# Talker wire-up checklist

When adding networking or BLoC features:

1. HTTP goes through `NetworkClient` so Dio logs appear automatically in debug.
2. BLoC transitions are observed globally — no per-bloc Talker setup needed.
3. For intentional breadcrumbs (push token source, wipe accept/reject), call `AppTalker.info/...`.
4. To inspect logs on device: Home → Settings → **Talker logs** (debug builds).

## Sensitive data

| Field | Policy |
|-------|--------|
| `Authorization` | Hidden from Dio logger headers |
| Login `password` | Still in request body logs in debug — treat as secret |
| Refresh / access tokens | Prefer not printing; use AppTalker messages without raw JWT |

## Verify

```bash
flutter pub get
flutter analyze lib/main.dart lib/core/service/talker lib/data/source/remote/network/client.dart
```

Open app → login → open Talker screen → confirm request/response and BLoC events appear.
