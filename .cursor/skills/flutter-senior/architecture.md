# Architecture reference

## Package layout

| Path | Responsibility |
|------|----------------|
| `lib/presentation/screen/<feature>/` | UI; `index` list, `create`/`edit`/`detail`/`form` |
| `lib/presentation/bloc/<feature>/` | `bloc.dart`, `event.dart`, `state.dart`, barrel |
| `lib/domain/repositories/` | Abstract repos |
| `lib/domain/usecase/` | Use cases |
| `lib/data/repositories/` | Repo impls |
| `lib/data/source/remote/services/` | Abstract remote contracts |
| `lib/data/source/remote/iservices/` | Concrete remote services |
| `lib/data/source/remote/network/` | `NetworkClient`, `BaseNetworkService`, `intercreptor.dart` |
| `lib/data/source/local/daos/` | SQLite / SQLCipher DAOs |
| `lib/core/service/` | Cross-cutting: push, biometric, encryption, wipe |
| `lib/core/util/client.dart` | `ApiClient`, `ClientEndPoint` |

## GetIt registration order

`Injection.initInjector()`:

1. DAO
2. Network (`Dio`, `AuthService`)
3. Repositories
4. Use cases
5. Blocs (`AuthBloc` = lazySingleton for GoRouter; most others = factory)

Then `AppDependencies` provides blocs.

## Network

- Base URL: `${ApiClient.baseUrl}${ApiClient.clientVersion}` → e.g. `http://host:5132/api`
- Paths are relative to `/api` (e.g. `/auth`, `login` joined → `/auth/login`)
- `createWithSuffix(isProtected: false)` for login
- Protected client attaches `access_token`; refresh via `ClientEndPoint.refresh`

## Naming quirks (do not “fix” casually)

- `intercreptor.dart`, `entension.dart`, `funciton.dart`
- `BottomAppbarBloc`, `ForegroundScheculerService`

## Key entry files

- `lib/main.dart` — Firebase + Pushy + DB + scheduler
- `lib/core/function/router.dart` — GoRouter + auth redirect
- `lib/core/service/push_token_service.dart`
- `lib/core/service/notification/remote_wipe_security.dart`
