---
name: talker-logging
description: >-
  Talker logging standard for this Flutter app (AppTalker, Dio logger, BLoC
  observer, TalkerScreen). Use when adding logs, debugging network/auth, or
  replacing debugPrint with project logging.
---

# Talker logging

This project uses [Talker](https://pub.dev/packages/talker_flutter) as the single logging surface.

## Required packages

- `talker_flutter`
- `talker_dio_logger` (HTTP)
- `talker_bloc_logger` (BLoC)

## Entry points

| Piece | Path |
|-------|------|
| Singleton | `lib/core/service/talker/app_talker.dart` → `AppTalker.instance` |
| Dio | `NetworkClient` adds `TalkerDioLogger` in **debug only** |
| BLoC | `Bloc.observer = TalkerBlocObserver(...)` in `main.dart` |
| UI | Settings → **Talker logs** (`AppRoutes.talker`) in debug |
| Routes | `TalkerRouteObserver` on `GoRouter` |

## How to log

```dart
AppTalker.debug('message');
AppTalker.info('message');
AppTalker.warning('message');
AppTalker.error('message', error, stackTrace);
```

Prefer `AppTalker` over new `debugPrint` for app/network/auth flows.

## Rules

- Do **not** invent a second logger.
- Dio logger is debug-only; `Authorization` header is hidden.
- Login request bodies may still contain password in debug — do not share TalkerScreen screenshots.
- Release builds keep `Talker` for crash handling via zone / `FlutterError`, but console Dio spam stays off.

## Deep dive

See [logging.md](logging.md) for wire-up checklist.
