---
name: aios
description: Use for Buy Your Home AIOS work, including the Admin wiki AI operating-system overlay, startup files, vault maps, privacy/routing rules, AIOS Project Room materials, and new-chat smoke testing.
---

# AIOS

## Source Of Truth

- Project room: `C:\Codex\Wiki Files\Project Rooms\AIOS`
- AIOS startup file: `C:\Codex\Wiki Files\AIOS\start-here.md`
- Admin wiki source: `C:\Codex\Wiki Files`

Use this skill for the AIOS overlay and its routing/privacy/startup materials.

## Required Startup

1. Confirm the working folder is `C:\Codex\Wiki Files`.
2. Read `Admin Home.md`, `AGENTS.md`, `Project Room Workflow.md`, and `Project Rooms\AIOS\README.md`.
3. Read the relevant AIOS file being changed, usually `AIOS\start-here.md`, `AIOS\vault-map.md`, `AIOS\skills-map.md`, or `AIOS\privacy-rules.md`.
4. Check `git status --short --branch`.

## Workflow

1. Identify whether the request is design, startup routing, privacy/rules, source intake, smoke testing, or implementation planning.
2. Keep source notes in the AIOS Project Room `sources\`.
3. Keep routing tests, implementation outlines, and missing decisions in `working\`.
4. Edit root `AIOS\` files only when Wes asks to update the actual AIOS overlay.
5. Record routing failures or privacy misses in the project room before changing broad startup behavior.

## Boundaries

- Do not restructure the wiki or move major folders merely because an AIOS idea suggests it.
- Do not start physical ACE folder migration unless Wes explicitly approves that project and timing.
- Preserve existing Admin wiki rules as controlling unless Wes approves a replacement.
## Start PR Pointer

Before durable work, follow Start PR Mode in `C:\Codex\Wiki Files\Project Room Chat Startup Rule.md`.

Interpret unqualified requests under the Current PR Scope Rule in that file. Work on `main` unless Wes explicitly asks for a branch.
