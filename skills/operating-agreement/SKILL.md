---
name: operating-agreement
description: Use for Buy Your Home Admin operating-agreement work, including creating, revising, comparing, redlining, or organizing OA drafts for SYH, BYH, Investment Services, BYH 401K, and Heritage Management; selecting the correct OA build mode; preserving SYH/Jeff Watson source lineage; and applying the Operating Agreements project-room rules.
---

# Operating Agreement

## Source Of Truth

Use the Admin wiki and Operating Agreements project room as the source of truth.

- Wiki repository: `C:\Codex\Wiki Files`
- Project room: `C:\Codex\Wiki Files\Project Rooms\Operating Agreements`
- Mode register: `C:\Codex\Wiki Files\Project Rooms\Operating Agreements\working\oa-build-modes.md`
- Revision rules: `C:\Codex\Wiki Files\Project Rooms\Operating Agreements\working\oa-revision-rules.md`
- Source inventory: `C:\Codex\Wiki Files\Project Rooms\Operating Agreements\working\source-inventory.md`
- Version shortcuts: `C:\Codex\Wiki Files\Project Rooms\Operating Agreements\working\oa-version-shortcuts.md`
- BYH process workbook: `C:\Codex\Wiki Files\Project Rooms\Operating Agreements\working\BYH OA Process Control.xlsx`

Teams folders are source/delivery locations only when explicitly used for source refresh or final delivery. The Admin wiki project room is the working location.

## Required Startup

Before operating-agreement file work:

1. Use `C:\Codex\Wiki Files` as the working folder.
2. Check `git status --short --branch`.
3. Read `Admin Home.md`, `Project Room Workflow.md`, `Repository Location Rule.md`, `Git Work Scope Rule.md`, and `Codex Skill Source Rule.md` when editing this skill.
4. Read the Operating Agreements `README.md`, `working\oa-build-modes.md`, `working\oa-revision-rules.md`, and `working\source-inventory.md`.
5. If creating or editing a `.docx`, also use the `documents` skill and follow its render/QA workflow. If visual rendering fails because the local converter is unavailable, disclose that limitation and still perform structural DOCX checks.

## Mode Selection

Every OA drafting or revision request must select one mode before drafting:

- `SYH` - Sell Your Home, LLC.
- `BYH` - Buy Your Home, LLC.
- `Investment Services` - Investment Services LLC.
- `BYH 401K` - BYH 401K LLC.
- `Heritage Management` - Heritage Management LLC.

If the mode is not explicit, infer it only from the immediate context and state the selected mode. If the wrong entity would materially change the draft, ask Wes before drafting.

Keep mode outputs in the matching folder under `Project Rooms\Operating Agreements\working\`.

## Core Workflow

1. Identify the requested deliverable: answer, inventory update, comparison, draft, redline, clean draft, final package, or process/skill update.
2. Select the OA mode.
3. Identify the source document from the source inventory, version shortcut file, or Wes's explicit instruction.
4. Refresh the Teams/SharePoint source first when the project rules require refresh and the connector is available. If unavailable, disclose the limitation in notes and final response.
5. Preserve original source files. Edit only working copies, output drafts, or process notes.
6. Keep source lineage visible: distinguish Jeff Watson source language, Wes simplified language, Jeff later edits, and target-entity additions/replacements.
7. Record new source, draft, comparison, or process files in `working\source-inventory.md`.
8. Commit only the current chat's scoped OA body of work. Do not stage unrelated project rooms or prior local changes.

## BYH From SYH Conversion

BYH mode is a conversion workflow, not a simple entity-name swap.

When using SYH/Simplified OA material for BYH:

- Generate each requested BYH build fresh from the refreshed Simplified OA or approved Reassembled OA source using cumulative rules, unless Wes names another source.
- Use `working\BYH OA Process Control.xlsx` for the version log, rule register, article map, reference audit, open issues, build checklist, user inputs, and controlled lists.
- Preserve Jeff Watson red edits as source edits.
- Use green font for BYH additions and replacement text unless Wes changes the color rule.
- Strike SYH/retirement-account language that does not apply to BYH, except for approved clean-edit areas.
- Use clean edits for certification/signature pages and Exhibit A when historical text would confuse signing or ownership records.
- Do not renumber sections or delete numbered clauses unless Wes explicitly approves that cleanup.

## Safety And Review

- Do not provide final legal or tax advice.
- Flag legal, tax, authority, ownership, member-rights, entity-formation, ERISA, or controlling-version questions for attorney or CPA review.
- Mark unsupported claims as `[UNSUPPORTED]`.
- Treat signed agreements, signed amendments, and attorney-confirmed documents as potentially authoritative only after inventory review.
- For final clean versions, remove partial word/phrase strikeouts only when Wes asks to promote a review draft to final clean form.

## Skill Maintenance

This is a wiki-managed skill. Canonical source lives at:

`C:\Codex\Wiki Files\skills\operating-agreement\SKILL.md`

Installed runtime copies under `%USERPROFILE%\.codex\skills` are deployed copies, not the source of truth. Sync this skill only when Wes says it is ready to install or the update is intended to become active in future Codex sessions.
