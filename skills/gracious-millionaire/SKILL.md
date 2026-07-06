---
name: gracious-millionaire
description: Use for Gracious Millionaire book and project-room work, including routed source-email intake, manuscript notes, chapter drafts, source ledgers, continuity review, heartbeat processing rules, and outputs under `Project Rooms\Gracious Millionaire`.
---

# Gracious Millionaire

## Source Of Truth

- Project room: `C:\Codex\Wiki Files\Project Rooms\Gracious Millionaire`
- Intake rules: `C:\Codex\Wiki Files\Project Rooms\Gracious Millionaire\working\intake-heartbeat-rules.md`
- Registry entry: `C:\Codex\Wiki Files\Agents and Automations Registry.md`
- Admin wiki source: `C:\Codex\Wiki Files`

Use this skill for Gracious Millionaire project-room processing. OfficeAssist email monitoring is owned by the OfficeAssist/Email Summary heartbeat, not by this project-room skill.

## Required Startup

1. Confirm the working folder is `C:\Codex\Wiki Files`.
2. Read `Admin Home.md`, `AGENTS.md`, `Project Room Workflow.md`, and `Project Rooms\Gracious Millionaire\README.md`.
3. Read `working\intake-heartbeat-rules.md`, `working\source-inventory.md`, `working\duplicate-and-conflict-log.md`, and `working\missing-context.md`.
4. Check `git status --short --branch` before durable edits.

## Workflow

1. Identify whether the request is source intake, manuscript development, continuity review, output drafting, or heartbeat-rule maintenance.
2. Preserve routed source emails as separate Markdown files under `sources\email\` when the active workflow calls for source routing.
3. Update source inventory and intake logs before drafting from new source material.
4. Keep manuscript notes and drafting analysis in `working\`.
5. Put review-ready drafts or final outputs in `outputs\`.
6. Mark unsupported factual or autobiographical claims instead of smoothing them into narrative.

## Boundaries

- Do not call the workflow `Project LumenScale`.
- Do not attach mailbox checking to the Gracious Millionaire project-room heartbeat.
- Do not query Outlook directly from this skill unless Wes explicitly authorizes that action in the current request and the Admin rules allow it.
- Do not send book responses, create new chats, delete source files, or push Git changes from heartbeat processing unless Wes explicitly asks.
