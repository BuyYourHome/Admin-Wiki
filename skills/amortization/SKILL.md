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

- `project_spreadsheet_path` - full path to the project workbook.
- `output_folder` - folder supplied by the calling skill where the finished chart must be dropped.

Do not infer or search for the output folder when called by another skill. If `output_folder` is missing, stop and ask for it unless Wes has explicitly defined a standalone/manual run mode.

## Calling Skill Contract

When another skill calls this skill:

1. Accept the project spreadsheet path from the caller.
2. Accept the project-room output folder from the caller.
3. Write the finished amortization chart into that output folder.
4. Return the created output file path to the caller.

The calling skill may pass the project-room root, the `outputs` folder, or both only after that convention is explicitly defined. Until then, require a direct folder path for the destination where the file should be written.

The Contract for Deed process is the likely first caller. Do not edit the Contract for Deed skill or its project-room files while using this skill unless Wes explicitly asks for that separate process update.

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

The chart must be a standalone output file, not only an in-chat table. Save it in the `output_folder` supplied by the caller.

Until Wes defines a different required format, use the most practical review-ready format for the surrounding workflow:

- Use `.xlsx` when the result needs formulas, reusable rows, or spreadsheet review.
- Use `.docx` or `.pdf` when the result needs to be included in a formal document package.
- Use `.md` only for working notes or when Wes asks for Markdown.

Use a clear filename that includes the property/project name when available, such as:

`<Project> - 12 Month Amortization Chart.<ext>`

If a file with the same name already exists, create a versioned filename instead of overwriting it.

## Template Rule

Use the buyer-facing amortization template workbook as the layout source when it exists:

`C:\Codex\Wiki Files\Project Rooms\Amortization\templates\Buyer-Facing Amortization Chart Template.xlsx`

For buyer-facing outputs:

1. Copy the template workbook to the caller-supplied output folder.
2. Populate the copied workbook with values from the project spreadsheet.
3. Preserve the template's formatting, merged cells, column widths, print area, headers, and buyer-facing wording.
4. Export the populated copy to PDF when a PDF is needed.
5. Do not rebuild the visual layout from scratch unless the template is missing or Wes explicitly asks for a redesign.

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

1. Confirm the output file exists in the caller-supplied output folder.
2. Confirm the chart covers exactly 12 scheduled months unless the source data supports fewer payments because of payoff, balloon, or contract end.
3. Confirm the beginning balance, payment, interest, principal, and ending balance columns are populated.
4. Confirm buyer-facing metadata values are present and visible.
5. Confirm the output does not overwrite the source workbook or an existing deliverable unintentionally.
6. Report the output path, assumptions, and any missing or conflicting source data.

## Maintenance Boundaries

Canonical skill source lives under `C:\Codex\Wiki Files\skills`. Installed local copies under `%USERPROFILE%\.codex\skills` are deployed copies only.

When changing this skill:

1. Edit the wiki source first.
2. Update the Amortization project room when requirements or open design points change.
3. Commit the Admin wiki changes locally.
4. Do not sync the installed local skill unless Wes explicitly asks to sync, install, or make the updated skill active.
5. Do not push unless Wes explicitly asks or says the update is finished and ready to publish.
