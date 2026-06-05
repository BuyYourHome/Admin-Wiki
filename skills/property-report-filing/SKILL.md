---
name: property-report-filing
description: File completed real-estate property report deliverables into the Teams-synced property Owning folder. Use when Codex creates, finalizes, or delivers a property report, including CMA reports, valuation reports, lender reports, property packets, creditworthiness reports tied to a property, or other formal reports for a Buy Your Home property.
---

# Property Report Filing

## Rule

When Wes asks for a report for a property, keep the working copy in the project room or wiki workspace, then put a copy of the completed report in the matching Teams-synced property folder under `Owning`.

This is a standing instruction. A request for a property report counts as permission to copy the final report deliverable to Teams unless Wes explicitly says not to for that report.

## Destination

Property folders live under:

```text
C:\Users\wesbr\Buy Your Home\Buy Your Home - Property
```

For a property report, copy the final report file to:

```text
C:\Users\wesbr\Buy Your Home\Buy Your Home - Property\<Matched Property>\Owning
```

Use the existing property folder that best matches the report address or project name. Do not create a new property folder unless Wes explicitly asks.

## Workflow

1. Finish the report in the normal working location, usually a project room `outputs` folder.
2. Identify the property address or project name from the report request or the report title.
3. Match that address/project to exactly one folder under the property root.
4. Confirm the matched folder has an `Owning` subfolder.
5. Copy the final report file into `Owning`.
6. Do not overwrite an existing file silently. If the same filename already exists, create a timestamped copy unless Wes explicitly approves replacement.
7. In the final response, include both the working output path and the Teams `Owning` copy path.

## Matching Rules

- Prefer an exact address match, such as `4121 Tensity` matching `24-HM-4121 Tensity Dr`.
- If exactly one property folder contains the street number and street name, use it.
- If no property folder matches, report the blocker and leave the report in the project room.
- If multiple property folders match, list the candidates and ask Wes which one to use.
- Do not substitute a similar property folder without explicit permission.

## Script

Use `scripts/copy-report-to-owning.ps1` for deterministic copies when practical:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File "C:\Codex\Wiki Files\skills\property-report-filing\scripts\copy-report-to-owning.ps1" -ReportPath "<report path>" -PropertyQuery "<address or project>"
```

The script returns the destination path when the copy succeeds.

