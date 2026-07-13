# Doc Scan Project Room

This project room holds development notes, source inventory, and review artifacts for the Buy Your Home Doc Scan workflow.

## Purpose

- Keep Doc Scan workflow development separate from general Admin Operations.
- Preserve the current authoritative workflow documents and skill source.
- Track routing rules, automation behavior, open questions, and review-ready handoffs in one place.
- Support future work on scanned PDFs, JPG/JPEG scans, invoice routing, statement routing, archive rules, and review folders.

## Current Status

- Status: active.
- Automation id: `doc-scan`.
- Schedule: every 15 minutes on weekdays from 10:00 AM through 4:45 PM Eastern.
- Defined operating modes: `working\doc-scan-modes.md`.
- Canonical skill source: `C:\Codex\Wiki Files\skills\doc-scan\SKILL.md`.
- Installed skill copy: `C:\Users\wesbr\.codex\skills\doc-scan\SKILL.md`.
- Live automation config: `C:\Users\wesbr\.codex\automations\doc-scan\automation.toml`.

## Room Layout

- `sources\` - source notes for controlling SOPs, maps, skill source, automation config, and related workflow inputs.
- `working\` - inventories, conflicts, open questions, route audits, and proposed changes.
- `outputs\` - review-ready specs, runbooks, handoffs, or finalized drafts.

## Operating Modes

The project room's defined scan modes are maintained in [[doc-scan-modes]]. Treat those modes as the project-room index for scan-category development, while the root SOP/spec/folder-map and canonical skill remain authoritative for the detailed routing rules.

## Authoritative Sources

- `C:\Codex\Wiki Files\Document Scanning SOP.md`
- `C:\Codex\Wiki Files\Document Scanning Skill Spec.md`
- `C:\Codex\Wiki Files\Document Scanning Folder Map.md`
- `C:\Codex\Wiki Files\skills\doc-scan\SKILL.md`
- `C:\Codex\Wiki Files\Invoice and Receipt Processing Notes.md`
- `C:\Codex\Wiki Files\Invoice Project List.md`
- `C:\Users\wesbr\.codex\automations\doc-scan\automation.toml`

## Development Boundary

Use this project room for development and design work. Do not change live scan routing, automation schedule, archive behavior, or skill behavior without updating the authoritative SOP/spec/map and the registry together.

Preserve source scans. Never delete source scan files as part of this workflow.
## Start PR Pointer

Before durable work, follow Start PR Mode in `C:\Codex\Wiki Files\Project Room Chat Startup Rule.md`.

Interpret unqualified requests under the Current PR Scope Rule in that file. Work on `main` unless Wes explicitly asks for a branch.
