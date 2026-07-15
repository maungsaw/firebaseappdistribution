# MCP guidance for this project

## Principle

MCP tool schemas load into context up front. Prefer **zero or one** MCP related to the task.

## Recommended (optional)

### GitHub

Use when: PR creation, CI check failures, issue triage.  
Not needed for everyday local Flutter coding.

### Docs / OpenAPI

Prefer `curl`/fetch of the team Scalar OpenAPI JSON on LAN:

- Base often in `lib/core/util/client.dart` → `ApiClient.baseUrl`
- Schema path historically: `/openapi/v1.json`

Do not POST login credentials from agents to shared servers unless the user explicitly asks and approves.

### Browser automation

Only if the user asks to interact with a page UI. Read-only fetch of docs is enough for most API work.

## Do not connect

- Expo MCP / EAS simulators
- Random SaaS MCPs “just in case”
- Global Supabase/Notion/etc. when unused here

## Local substitutes (prefer these)

| Need | Use |
|------|-----|
| Build errors | `flutter analyze`, IDE problems |
| Device connect | `adb devices`, project `tool/wireless_adb.ps1` |
| Wipe payload | `dart run tool/generate_wipe_payload.dart --device-id=…` |
| Tests | `flutter test test/…` |
