---
name: flutter-ui-premier
description: >-
  Premier Flutter UI/UX for this app: Material 3 seed theme, clear hierarchy,
  consistent cards, forms, and navigation. Use when building or polishing
  screens, cards, dialogs, auth UI, settings, lists, or visual design.
---

# Flutter UI — premier & clear

Design like a senior product + Flutter engineer: clarity first, polish second, no generic AI chrome.

## Brand & theme

- Seed: `Color(0x000950A8)` via `ColorScheme.fromSeed`
- Material 3 + `ThemeMode.system` (light/dark)
- Prefer `theme.colorScheme` / `textTheme` over hard-coded colors
- Reuse `GlobalFormField`, `GlobalSnackbar`, `GlobalWidget` loading/error

## Composition rules

1. **One job per screen section** — one headline purpose, one short supporting line if needed.
2. **Width alignment** — sibling cards share the same horizontal inset (Settings Agent / Phone Security / Master pattern: same padding, `borderRadius: 24` where established).
3. **Status must be scannable** — chip/badge for state (`Setup required`, `Verified`, `Tap to verify`).
4. **Primary action clear** — text + trailing `Icons.arrow_forward` for tappable rows (match Master list).
5. **Cards only when interactive or grouping related actions** — avoid card-soup.

## Auth / forms

- Labels clear (`Phone No.`, `Password`)
- Trim on submit; disable button while `AuthLoadingState`
- Errors via `GlobalSnackbar.showError`, not raw Dio dumps
- Prefer keyboard types / obscureText for password fields

## Navigation chrome

- Home: pill bottom bar + calculator FAB; respect scroll hide/show (`ScrollBottomBarListener`, `BottomAppbarBloc`)
- SafeArea / system UI: respect existing `SystemBottomBarService` behavior
- Do not invent a second bottom navigation pattern

## Visual quality bar

| Do | Don't |
|----|-------|
| Use existing radius/spacing system | Random one-off margins that break rhythm |
| Semantic colors (green verified, amber setup) | Rainbow accents unrelated to meaning |
| Tight hierarchy (title → chip → body → CTA) | Dense ListTile walls without states |
| Dark/light readable contrast | Low-contrast grey text on grey |

## Anti-patterns (this product)

- Purple/indigo default “AI landing” look
- Floating badge stickers on hero areas
- Multiple competing CTAs in one card
- Inset hero media or dashboard clutter on simple agent screens

## Checklist before finishing UI

- [ ] Aligns with neighboring cards (padding/radius)
- [ ] Loading / empty / error / success considered
- [ ] Tappable affordance obvious (chevron/arrow)
- [ ] Works in light and dark
- [ ] No hardcoded strings for theme colors when scheme exists

## Deep dive

- Component inventory: [design-system.md](design-system.md)
