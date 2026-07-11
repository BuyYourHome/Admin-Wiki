# Amortization Project Room

## Branch And Push Mode

- Project branch: `project/amortization`.
- When this room starts or resumes durable file work, use `C:\Codex\Wiki Files` and switch to this branch when it is safe to do so.
- When Wes says `Push` in this room, commit and push only this room's intentional durable work, its matching skill source, and directly related registry or rule updates under [[Project Room Branch and Push Mode Rule]].
- `Push` does not update GitHub `main` unless Wes explicitly says `Push to main` or `promote to main`.

## Purpose

Own the reusable Amortization generator that creates buyer-facing 12-month amortization chart PDFs from project spreadsheets for Contract for Deed and other seller-financing workflows.

## Scope

- Topic: amortization.
- Current durable output: wiki-managed Codex skill named `amortization` plus the Amortization-owned generator script.
- Likely caller: the Contract for Deed process calls this skill when amortization calculations or schedules are needed.
- Expected source: a provided project spreadsheet path, using worksheet `Amortization` with fallback worksheet `amateurization`.
- Expected output: a formal buyer-facing amortization chart PDF for the next 12 scheduled payment rows.
- Caller destination: supplied by the calling skill; Amortization processes in its own project room and copies only the finished PDF to the caller destination by default.
- Owner intent: started at Wes's request on 2026-06-10.

## Spreadsheet Design Boundary

This project room generates buyer-facing amortization outputs from the current project spreadsheet. It does not own project workbook redesign, replacement-sheet swaps, or rollout of a redesigned `Amortization` worksheet across active projects.

When an Amortization task touches the structure of a project workbook's `Amortization` sheet, follow the Amortization rollout rules maintained in [[Project Spreadsheet Expense Placement Rules]] under the Project Management Spreadsheet Redesign project room. Those rules control Teams connector verification, rollback copies, reconnect-by-meaning validation, lesson capture, and project exceptions such as Cool Springs.

## Current Status

Reusable generator implemented under `scripts\New-AmortizationChart.ps1`.

## Folder Map

- `sources/` - raw source files, exported messages, notes, or source summaries.
- `working/` - source inventory, conflict review, missing context, and draft thinking.
- `outputs/` - review-ready drafts and final deliverables.
- `templates/` - buyer-facing workbook template used as the layout source.
- `scripts/` - reusable generator scripts owned by this project room.

## Next Actions

1. Continue testing the generator against additional project spreadsheets.
2. Add validation examples when known-good schedules are available.
3. Keep the template workbook updated as Wes refines the buyer-facing layout.
