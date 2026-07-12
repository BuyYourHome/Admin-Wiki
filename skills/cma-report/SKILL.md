---
name: cma-report
description: Create, rerun, finalize, and file Buy Your Home CMA report and related real-estate property report deliverables. Use when Codex prepares or updates a CMA report, valuation report, lender report, property packet, creditworthiness report tied to a property, or other formal report for a Buy Your Home property, including copying the completed report into the Teams-synced property Owning folder.
---

# CMA Report

## Rule

When the owner asks for a report for a property, keep the working copy in the project room or wiki workspace, then put a copy of the completed report in the matching Teams-synced property folder under `Owning`.

This is a standing instruction. A request for a property report counts as permission to copy the final report deliverable to Teams unless the owner explicitly says not to for that report.

## Destination

Property folders live under:

```text
C:\Users\wesbr\Buy Your Home\Buy Your Home - Property
```

For a property report, copy the final report file to:

```text
C:\Users\wesbr\Buy Your Home\Buy Your Home - Property\<Matched Property>\Owning
```

Use the existing property folder that best matches the report address or project name. Do not create a new property folder unless the owner explicitly asks.

## Workflow

1. Finish the report in the normal working location, usually a project room `outputs` folder.
2. Identify the property address or project name from the report request or the report title.
3. Match that address/project to exactly one folder under the property root.
4. Confirm the matched folder has an `Owning` subfolder.
5. Copy the final report file into `Owning` with a date prefix in `yy-mm-dd` format.
6. Do not overwrite an existing file silently. If the same filename already exists, create a timestamped copy unless the owner explicitly approves replacement.
7. In the final response, include both the working output path and the Teams `Owning` copy path.

## Report Wording

Use depersonalized source wording in CMA reports. When a value, condition, repair status, feature list, or assumption comes from the property owner or requester, label it `Owner-provided`.

Do not write the owner's personal name in report assumptions or valuation reasoning unless the owner explicitly asks for that wording.

## File Naming

Prefix the copied Teams file with the report date in `yy-mm-dd` format:

```text
26-06-05 4121-tensity-cma-report.docx
```

If the source report already starts with a `yy-mm-dd` prefix, keep that prefix instead of adding a second one.

## Matching Rules

- Prefer an exact address match, such as `4121 Tensity` matching `24-HM-4121 Tensity Dr`.
- If exactly one property folder contains the street number and street name, use it.
- If no property folder matches, report the blocker and leave the report in the project room.
- If multiple property folders match, list the candidates and ask the owner which one to use.
- Do not substitute a similar property folder without explicit permission.

## Script

Use `scripts/copy-report-to-owning.ps1` for deterministic copies when practical:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File "C:\Codex\Wiki Files\skills\cma-report\scripts\copy-report-to-owning.ps1" -ReportPath "<report path>" -PropertyQuery "<address or project>"
```

The script returns the destination path when the copy succeeds.
