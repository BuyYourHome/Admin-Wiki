# AI Project Room Workflow

Use an AI Project Room for any task that depends on multiple source files, emails, scans, notes, spreadsheets, or prior drafts.

The purpose is to prepare the source set before drafting, analyzing, rewriting, or making recommendations. Do not ask Codex to produce a final deliverable from a messy folder. Build the room first.

For repeatable workflow roles that combine a Project Room, skill, registry entry, chat/thread, or automation, also follow [[Agent Unit Standard]].

## When To Use

Use this workflow when:

- More than two or three source documents are involved.
- Source files may be old, duplicated, incomplete, or contradictory.
- The output will become an SOP, spreadsheet redesign, legal summary, financial analysis, property packet, automation spec, or durable operating rule.
- A mistake caused by blending old and new information would matter.

Skip this workflow for one-off answers, short emails, simple formulas, or tasks with one clearly authoritative source.

## Standard Folder Structure

Each room lives under:

```text
C:\Codex\Wiki Files\Project Rooms\<Project Name>\
```

Use these subfolders:

```text
sources\   Raw inputs copied or summarized into the room
working\   Inventories, audits, notes, and draft thinking
outputs\   Final deliverables or review-ready drafts
```

Preserve originals. If a file must be edited, edit a working copy or output file, not the raw source.

## Required Artifacts

Every Project Room should contain:

- `README.md` - purpose, scope, owner intent, current status, and next actions.
- `working/source-inventory.md` - table of every source and its status.
- `working/duplicate-and-conflict-log.md` - duplicate, outdated, conflicting, or unclear sources.
- `working/missing-context.md` - facts, decisions, or data still needed.
- `outputs/` - final deliverables or drafts once source preparation is complete.

## Source Status Terms

- `authoritative` - use this as a source of truth.
- `background` - useful context, but do not treat as controlling.
- `duplicate` - overlaps another source and should not be independently blended.
- `outdated` - superseded by newer information.
- `unclear` - may matter, but needs human review before use.
- `missing` - needed but not yet provided.

## Workflow

1. Define the project purpose and intended output in `README.md`.
2. Put source files, exports, notes, or source summaries in `sources\`.
3. Create `working/source-inventory.md` before drafting anything.
4. Identify duplicates, outdated sources, and conflicts in `working/duplicate-and-conflict-log.md`.
5. Identify unsupported claims and open questions in `working/missing-context.md`.
6. Ask Wes for decisions only when the ambiguity could cause the wrong outcome.
7. Draft the output using authoritative sources only.
8. Cite source files or source notes for factual claims whenever the output is analytical, legal, financial, or procedural.
9. Move review-ready deliverables to `outputs\`.
10. Commit durable Project Room changes to GitHub unless Wes says not to.

## Output Rule

When drafting from a Project Room, Codex must distinguish:

- facts supported by authoritative sources,
- reasonable recommendations based on those facts,
- assumptions made for drafting,
- unsupported items that still need confirmation.

Unsupported factual claims should be marked `[UNSUPPORTED]` in working drafts instead of being smoothed over.
