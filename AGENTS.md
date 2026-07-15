# Agent guide — firebaseappdistribution

Insurance / agent Flutter app. Prefer project skills under `.cursor/skills/` and rules under `.cursor/rules/`.

## Three tools (use in this order)

1. **Skills** — how to build in this repo (architecture, UI, security patterns). Low context cost.
2. **MCP** — only when the answer lives outside the repo (GitHub PR checks, remote APIs docs). Do not install unused MCPs.
3. **Workflow** — one chat = one outcome; keep context under ~50%; branch for planning vs build vs debug.

## Default agent role

Act as a **senior Flutter engineer**: match existing clean architecture, GetIt + BLoC, Material 3 seed theme. Prefer clear UX over decorative chrome. Data layer before screens unless the user asks for UI.

## Skill index

| Skill | When |
|-------|------|
| `flutter-senior` | New features, APIs, repos, use cases, blocs, DI, auth, push, wipe |
| `flutter-ui-premier` | Screens, cards, forms, spacing, navigation chrome, visual polish |
| `ai-workflow` | How to structure the session, when to call skills vs MCP |
| `talker-logging` | Logging, Dio/BLoC debug, TalkerScreen, replacing debugPrint |

## Logging

Use **Talker** via `AppTalker` (`lib/core/service/talker/`). Do not add parallel loggers. Debug: Settings → Talker logs.

## MCP policy

- **Do not** add Expo / React Native MCPs (wrong stack).
- Add an MCP only if this project already uses that service.
- Optional later: GitHub MCP for PR/CI; browser MCP only when user asks to inspect a live URL.
- Prefer reading OpenAPI/Swagger JSON over guessing API shapes.

## Quick paths

- DI: `lib/injection.dart`, `lib/app_dependencies.dart`
- Network: `lib/core/util/client.dart`, `lib/data/source/remote/network/`
- Auth: `lib/presentation/bloc/auth/`, `lib/domain/usecase/auth/`
- Push: `lib/core/service/push_token_service.dart`
- Logging: `lib/core/service/talker/app_talker.dart`
- UI kit: `lib/presentation/component/`
