# MCP guidance for this project

## Principle

MCP tool schemas load into context up front. Prefer **zero or one** MCP related to the task. This repo ships **Dart/Flutter MCP only** by default (see `.cursor/mcp.json`).

## Configured: Dart / Flutter MCP (`dart`)

Official server: `dart mcp-server` (Dart SDK ≥ 3.9). Project config:

```json
{
  "mcpServers": {
    "dart": {
      "command": "C:\\flutter\\bin\\dart.bat",
      "args": ["mcp-server", "--flutter-sdk", "C:\\flutter"]
    }
  }
}
```

### When to use it

| Need | MCP capability (typical) |
|------|---------------------------|
| Analyzer / fix errors after edits | `analyze_files`, analysis |
| Format / pub / deps | `dart_fix`, `pub`, package tools |
| Run unit/widget tests | `run_tests`, `dart_fix` |
| Find packages on pub.dev | `pub_dev_search` |
| Devices / launch / hot reload | `list_devices`, `launch_app`, `hot_reload`, `hot_restart`, `stop_app` |
| Runtime errors / app logs | `get_runtime_errors`, `get_app_logs` |
| Widget tree / UI inspect | `widget_inspector` (app must be running + DTD) |

### When not to use it

- Reading/editing source you already have in the workspace → use Read / Grep / ApplyPatch.
- LAN OpenAPI shape → fetch OpenAPI JSON (below), not MCP.
- Wireless ADB pair/connect quirks → `adb` / `tool/wireless_adb.ps1`.
- Remote-wipe payload → `dart run tool/generate_wipe_payload.dart --device-id=…`.

### After changing `mcp.json`

1. Cursor → **Settings → Tools & Integrations → MCP**
2. Ensure **dart** is enabled / green
3. If stuck: Command Palette → **Developer: Reload Window**

## Recommended stack for *this* Flutter app (brainstorm → decision)

| Server | Verdict | Why |
|--------|---------|-----|
| **Dart/Flutter MCP** | **Yes (default)** | Analyze, pub, tests, devices, hot reload, pub.dev — matches our stack |
| **Figma MCP** | Optional / user | Only when implementing or syncing UI from Figma links |
| **GitHub MCP** | Optional | PR/CI/issue triage; day-to-day Flutter work does not need it |
| Browser / Playwright MCP | Rare | Only if user asks to click through a live web UI |
| Docs MCP | Skip | Prefer local OpenAPI + Flutter/Dart docs via fetch or memory |
| Expo / EAS / RN MCP | **Never** | Wrong stack |
| Random SaaS (Notion, Supabase, …) | **Never** unless the app integrates them |

Keep the MCP count low — each extra server burns tokens on tool schemas every turn.

## Optional: GitHub MCP (not pre-installed)

Add only if you regularly need PR/CI from the agent. Prefer `gh` CLI in the shell when possible. If you do add GitHub MCP, store the token in Cursor env / secrets — **never** commit PATs into `mcp.json`.

## Docs / OpenAPI (prefer over guessing APIs)

- Base URL often in `lib/core/util/client.dart` → `ApiClient.baseUrl`
- Schema path historically: `/openapi/v1.json`
- Do not POST login credentials from agents unless the user explicitly asks and approves.

## Do not connect

- Expo MCP / EAS simulators
- Random SaaS MCPs “just in case”
- Global Supabase/Notion/etc. when unused here

## Local substitutes (still prefer when cheaper)

| Need | Use |
|------|-----|
| Build errors | `flutter analyze`, IDE problems, or Dart MCP analyze |
| Device connect | `adb devices`, project `tool/wireless_adb.ps1` |
| Wipe payload | `dart run tool/generate_wipe_payload.dart --device-id=…` |
| Tests | `flutter test test/…` or Dart MCP `run_tests` |
