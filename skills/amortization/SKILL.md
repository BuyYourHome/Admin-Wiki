---
name: amortization
description: Use when Codex needs to create a formal 12-month amortization chart from a Buy Your Home project spreadsheet, especially when called by another workflow such as Contract for Deed. Trigger when a caller provides a project spreadsheet and project-room output folder, asks for an amortization chart, amortization schedule, seller-financing payment schedule, or Contract for Deed amortization output.
---

# Amortization

## Source Of Truth

- Canonical skill source: `C:\Codex\Wiki Files\skills\amortization\SKILL.md`
- Planning project room: `C:\Codex\Wiki Files\Project Rooms\Amortization`
- Admin wiki source: `C:\Codex\Wiki Files`

Use this skill as a reusable output generator. Project-specific spreadsheets, notes, generated charts, and history stay in the calling process's project room unless Wes gives a different destination.

## Required Inputs

Require these inputs before generating an amortization chart:

- `project_name` - project/property name for output naming and buyer-facing title.
- `project_spreadsheet_path` - full path to the project workbook.
- `caller_destination_folder` - folder supplied by the calling skill where the finished PDF must be copied.
- `output_format` - optional; default is `PDF`.

Do not infer or search for the caller destination folder when called by another skill. If `caller_destination_folder` is missing, stop and ask for it unless Wes has explicitly defined a standalone/manual run mode.

## Calling Skill Contract

When another skill calls this skill:

1. Accept the project spreadsheet path from the caller.
2. Accept the caller destination folder from the caller.
3. Process inside the Amortization project room.
4. Write the finished PDF into the Amortization project-room `outputs` area.
5. Copy the finished PDF to the caller destination folder.
6. Return/report both PDF paths to the caller.

The calling skill must pass a direct destination folder path. The caller should not pass only its project-room root unless that root is also the intended delivery folder.

The Contract for Deed process is the likely first caller. CFD should call the Amortization generator and package the returned PDF; CFD should not generate the amortization chart itself.

## Spreadsheet Rule

Read the project spreadsheet and use the worksheet currently referred to as `amateurization`.

Worksheet lookup:

1. Prefer an exact worksheet named `amateurization`.
2. If it is missing, look for an exact worksheet named `amortization`.
3. If neither exists, report the missing worksheet and stop.

Do not rename worksheets, modify formulas, or overwrite the source workbook unless Wes explicitly asks for a workbook edit.

Use the spreadsheet skill/runtime for `.xlsx`, `.xls`, `.csv`, `.tsv`, or workbook-style operations when available.

## Output Rule

Create a formal amortization chart for the next 12 months.

The chart must be a standalone PDF output, not only an in-chat table. Save the finished PDF in the Amortization project-room `outputs` area and copy it to the caller destination folder.

Until Wes defines a different required format, use the most practical review-ready format for the surrounding workflow:

- Use `.xlsx` when the result needs formulas, reusable rows, or spreadsheet review.
- Use `.docx` or `.pdf` when the result needs to be included in a formal document package.
- Use `.md` only for working notes or when Wes asks for Markdown.

Use a clear filename that includes the property/project name when available, such as:

`<Project> - 12 Month Amortization Chart.<ext>`

If a file with the same name already exists, create a versioned filename instead of overwriting it.

## Generator Script

Use the Amortization project-room generator:

`C:\Codex\Wiki Files\Project Rooms\Amortization\scripts\New-AmortizationChart.ps1`

Call pattern:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File "C:\Codex\Wiki Files\Project Rooms\Amortization\scripts\New-AmortizationChart.ps1" -ProjectName "<project/property name>" -ProjectSpreadsheetPath "<project_spreadsheet_path>" -CallerDestinationFolder "<caller_destination_folder>"
```

Optional parameter:

- `-OutputFormat PDF` - default; create/copy only PDF to the caller.
- `-OutputFormat XLSX` or `-OutputFormat Both` - copy the populated workbook to the caller only when Wes specifically asks for it.

The script returns JSON containing:

- `amortization_project_room_pdf`
- `caller_pdf`
- `worksheet_used`
- `first_payment_date`
- `last_payment_date`
- `payment_rows`
- `missing_or_ambiguous_source_data`

## Template Rule

Use the buyer-facing amortization template workbook as the layout source when it exists:

`C:\Codex\Wiki Files\Project Rooms\Amortization\templates\Buyer-Facing Amortization Chart Template.xlsx`

For buyer-facing outputs:

1. Copy the template workbook to the Amortization project-room working area for the run.
2. Populate the copied workbook with values from the project spreadsheet.
3. Preserve the template's formatting, merged cells, column widths, print area, headers, and buyer-facing wording.
4. Export the populated copy to PDF using LibreOffice:
   `C:\Program Files\LibreOffice\program\soffice.exe`
5. Save the finished PDF in the Amortization project-room `outputs` area.
6. Copy only the finished PDF to the caller destination folder unless Wes specifically asks for the populated workbook too.
7. Do not place intermediate working XLSX files in the CFD project room by default.
8. Do not rebuild the visual layout from scratch unless the template is missing or Wes explicitly asks for a redesign.

Template value cells:

- `C3` - buyer name(s)
- `I3` - property
- `C4` - contract date
- `I4` - sale amount
- `C5` - down payment
- `I5` - loan amount
- `C6` - buyer rate
- `I6` - monthly total payment
- `A9:K20` - 12 payment rows
- `E21:J21` - totals for the displayed period

## Chart Content

Include the columns needed to make the 12-month schedule understandable and auditable. Unless the worksheet or caller specifies a different approved format, include:

- payment number,
- payment due date,
- beginning balance,
- interest rate when useful for buyer review,
- scheduled payment,
- interest,
- principal,
- escrow, fees, or other charges when present in the worksheet,
- ending balance.

Do not include cumulative-principal or cumulative-interest columns in the buyer-facing chart unless Wes explicitly asks for them.

Do not invent missing financial terms. If principal, interest rate, payment amount, first payment date, term, balloon terms, or other required values are missing or ambiguous, report the missing fields instead of producing a guessed chart.

## Buyer-Facing Layout

When the chart is for the buyer's benefit:

- Use a clean title only; do not include a subtitle such as `Prepared from...`.
- Do not include internal metadata such as source workbook path, source rows, or chart period.
- Do not include a bottom source note or implementation note.
- Keep only buyer-useful metadata, such as buyer name, property, contract date, sale amount, down payment, loan amount, buyer rate, and monthly total payment when those values are available.
- Merge or widen buyer-facing metadata label/value cells as needed so labels and values do not truncate. Labels such as `Contract Date` and `Down Payment` must be fully visible.
- In the current template, keep the buyer value wide enough at `C3:F3`; put the right-side metadata labels at `G3:G6` and values at `I3:I6`.
- After populating a copied template, verify both labels and values are visible. Do not treat a chart as complete if buyer, property, contract date, down payment, loan amount, buyer rate, or monthly payment values are blank or hidden.
- Wrap column headers so columns can be narrower.
- Narrow columns enough for a compact one-page chart while keeping values readable.

## Calculation Rules

Use values from the project spreadsheet as the source of truth. If values are calculated in the workbook, prefer the worksheet's exposed calculated values over re-deriving them unless the worksheet is incomplete or visibly wrong.

The generator reads cached workbook values directly from the spreadsheet package and does not modify the source spreadsheet.

Keep rounding consistent with the worksheet. If the worksheet does not specify rounding:

- round displayed currency to cents,
- carry calculation precision internally where the tool supports it,
- make any rounding assumption visible in the chart notes.

Do not smooth over one-cent differences. If workbook values and regenerated calculations do not match, flag the variance.

## Date Rules

The 12-month period should start from the next payment due date or another explicit schedule-start field in the worksheet.

If the start date is not clear, stop and report the ambiguity. Do not default to today's date unless Wes or the worksheet clearly says to do so.

## Verification

Before reporting completion:

1. Confirm the project-room PDF exists and is non-empty.
2. Confirm the copied caller PDF exists and is non-empty.
2. Confirm the chart covers exactly 12 scheduled months unless the source data supports fewer payments because of payoff, balloon, or contract end.
3. Confirm the beginning balance, payment, interest, principal, and ending balance columns are populated.
4. Confirm buyer-facing metadata values are present and visible.
5. Confirm the worksheet used, first payment date, and last payment date are reported.
6. Confirm the output does not overwrite the source workbook or an existing deliverable unintentionally.
7. Report the project-room PDF path, copied caller PDF path, assumptions, and any missing or conflicting source data.

## Maintenance Boundaries

Canonical skill source lives under `C:\Codex\Wiki Files\skills`. Installed local copies under `%USERPROFILE%\.codex\skills` are deployed copies only.

When changing this skill:

1. Edit the wiki source first.
2. Update the Amortization project room when requirements or open design points change.
3. Commit the Admin wiki changes locally.
4. Do not sync the installed local skill unless Wes explicitly asks to sync, install, or make the updated skill active.
5. Do not push unless Wes explicitly asks or says the update is finished and ready to publish.
