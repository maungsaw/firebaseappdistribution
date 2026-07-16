---
name: ai-workflow
description: >-
  AI development workflow for this repo: skills vs MCP vs context discipline,
  conversation branching, and when to load project guidance. Use when starting
  a large task, planning features, debugging across systems, or when the user
  mentions skills, MCP, context, or workflow.
---

# AI workflow (skills · MCP · context)

Based on the “three tools that matter” model: skills first, one MCP when needed, watch context.

## 1. Skills (cheap)

| Skill | Purpose |
|-------|---------|
| `flutter-senior` | Architecture, APIs, auth, push, wipe |
| `flutter-ui-premier` | Screens and visual clarity |
| `talker-logging` | AppTalker, Dio/BLoC logs, TalkerScreen |
| `ai-workflow` | This file — session strategy |

Load only what the task needs (progressive disclosure). Read linked `*.md` references only when deep detail is required.

## 2. MCP (expensive — selective)

Default in this repo: **Dart/Flutter MCP** (`.cursor/mcp.json`). Use for analyzer, pub, tests, devices, hot reload, pub.dev — not for reading files you already have open.

| MCP | When OK |
|-----|---------|
| Dart / Flutter | Analyze, format, pub, tests, launch/reload, runtime logs |
| GitHub | PR reviews, CI failures, issues (optional; `gh` often enough) |
| Figma | Only when implementing from a Figma link |
| Browser / fetch | User provides a live Scalar/docs URL to verify |
| Expo / RN MCP | **Never** — wrong stack |

Prefer:

- Local OpenAPI (`http://…/openapi/v1.json`) over guessing
- Dart MCP or `flutter analyze` for compile/analysis feedback

Details: [mcp.md](mcp.md)

## 3. Context discipline

- Soft cap: keep the thread under ~50% of useful context.
- **One conversation, one outcome** (plan ≠ implement ≠ debug ADB).
- Branch mentally or start a fresh chat when switching domains (auth vs wipe vs wireless ADB).
- Summarize decisions before long builds.

## Suggested session shapes

### Feature (API + UI)

1. Plan (endpoints, DTO fields) — chat A  
2. Data layer — chat B or continue if short  
3. UI polish — invoke `flutter-ui-premier`

### Bug (401 / network)

1. Log exact URL + body  
2. Compare to Scalar  
3. Fix path/trim/baseUrl — no UI redesign

### Device / push

1. Confirm FCM vs Pushy via `[PushToken]` logs  
2. Do not change architecture unless broken

## Agent script when user says “brainstorm then implement”

1. Short plan (bullets)
2. Implement smallest vertical slice
3. Analyze + tests if present
4. Report how to verify on device
