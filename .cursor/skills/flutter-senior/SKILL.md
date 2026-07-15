---
name: flutter-senior
description: >-
  Senior Flutter architecture for this insurance app (clean layers, GetIt, BLoC,
  Dio, auth, FCM/Pushy, remote wipe). Use when adding features, APIs,
  repositories, use cases, blocs, DI, login, device register, push tokens, or
  security data flows.
---

# Flutter senior engineer

Act as a senior Flutter developer: pragmatic clean architecture, secure defaults, match this repo.

## Role checklist

- Read existing neighbors before writing new code.
- Prefer extending `BaseNetworkService` over raw Dio in feature services.
- Register every new service/repo/use case/bloc in `lib/injection.dart`.
- Export new public types via barrel files (`data.dart`, `domain.dart`, etc.).
- Do not rename typo filenames unless asked.

## Default delivery order

1. Contract (OpenAPI / existing endpoints)
2. DTOs + models
3. Remote service + repository + use case
4. BLoC events/states
5. DI + analyze
6. Screen only if requested

## Architecture map

```
Screen/Bloc → UseCase → AuthRepository (abstract)
                      → AuthRepositoryImpl → AuthServiceImpl → Dio
```

Auth DTOs: prefer `lib/data/dto/request/` and `lib/data/dto/response/` when present.

## Security non-negotiables

- Never wipe on unsigned `WIPE_DATA`; go through `performRemoteWipeIfRequested`.
- Device-bound wipe secrets use device id; do not hardcode wipe keys.
- Phone unlock: `PhoneSecuritySession` + `DeviceAuthService` (PIN/biometrics).
- Trim login credentials before `LoginRequestDto`.

## Push token

Use `PushTokenService.resolve()`. Prefer FCM when available; Pushy for no-GMS. Log `token_source`.

## After login

```
AuthLoginSuccessState → GoRouter home
                     → _registerDeviceInBackground() (best-effort)
```

## Anti-patterns

- Putting HTTP calls in widgets or BLoCs
- Skipping use case when the feature already uses use cases
- Double API prefix (`/api` + `/api/auth/...`)
- Treating device-register failure as login failure
- Adding a second logger instead of `AppTalker` / Talker

## Logging

Use skill `talker-logging`. Prefer `AppTalker.info/error/...` for breadcrumbs; Dio/BLoC already instrumented.

## Deep dive

- Full layer paths and quirks: [architecture.md](architecture.md)
- Auth + wipe sequences: [security-flows.md](security-flows.md)
