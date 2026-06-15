# Document Scan Project Room

This project room holds development notes, source inventory, and review artifacts for the Buy Your Home document-scanning workflow.

## Purpose

- Keep document-scanning workflow development separate from general Admin Operations.
- Preserve the current authoritative workflow documents and skill source.
- Track routing rules, automation behavior, open questions, and review-ready handoffs in one place.
- Support future work on scanned PDFs, JPG/JPEG scans, invoice routing, statement routing, archive rules, and review folders.

## Current Status

- Status: active.
- Automation id: `document-scanning`.
- Schedule: daily at 10:00 AM, 12:00 PM, 2:00 PM, and 4:00 PM.
- Canonical skill source: `C:\Codex\Wiki Files\skills\document-scanning\SKILL.md`.
- Installed skill copy: `C:\Users\wesbr\.codex\skills\document-scanning\SKILL.md`.
- Live automation config: `C:\Users\wesbr\.codex\automations\document-scanning\automation.toml`.

## Room Layout

- `sources\` - source notes for controlling SOPs, maps, skill source, automation config, and related workflow inputs.
- `working\` - inventories, conflicts, open questions, route audits, and proposed changes.
- `outputs\` - review-ready specs, runbooks, handoffs, or finalized drafts.

## Authoritative Sources

- `C:\Codex\Wiki Files\Document Scanning SOP.md`
- `C:\Codex\Wiki Files\Document Scanning Skill Spec.md`
- `C:\Codex\Wiki Files\Document Scanning Folder Map.md`
- `C:\Codex\Wiki Files\skills\document-scanning\SKILL.md`
- `C:\Codex\Wiki Files\Invoice and Receipt Processing Notes.md`
- `C:\Codex\Wiki Files\Invoice Project List.md`
- `C:\Users\wesbr\.codex\automations\document-scanning\automation.toml`

## Development Boundary

Use this project room for development and design work. Do not change live scan routing, automation schedule, archive behavior, or skill behavior without updating the authoritative SOP/spec/map and the registry together.

Preserve source scans. Never delete source scan files as part of this workflow.
