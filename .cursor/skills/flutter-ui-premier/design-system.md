# Design system notes

## Theme source

`lib/main.dart` — Material 3 `ColorScheme.fromSeed(seedColor: Color(0x000950A8))`.

## Shared components (`lib/presentation/component/`)

| Widget | Use |
|--------|-----|
| `GlobalFormField` (`textfield.dart`) | Standard text inputs |
| `PhoneSecurityCard` | Security status + CTA on Settings |
| `SecurityUnlockDialog` helpers | Gate sensitive screens |
| `ScrollBottomBarListener` | Hide bottom bar on scroll down |
| `RecordableList` / `PdfViewer` / file picker | Feature-specific |

## Settings home pattern

`lib/presentation/screen/setting/index.dart`:

1. Agent profile container (`primaryContainer` @ 0.4, radius 24)
2. `PhoneSecurityCard` (same width language)
3. `DynamicMasterSectionCard` for menu list

Phone security states:

- Setup required (amber) → `View setup steps →`
- Tap to verify (primary) → `Verify now →`
- Verified (green) → lock control

## Snackbars / feedback

`GlobalSnackbar` in `lib/core/function/toast.dart` (exported via function barrel). Prefer these over ad-hoc `ScaffoldMessenger` banners.

## Navigation

- Routes: `AppRoutes` / `RouteName` in `lib/core/util/`
- Shell: `HomeScreen` tabs Policy / Product / Settings
- Auth gate: `AppRouter` + `AuthBloc` as `refreshListenable`
