# Amortization Skill Requirements

## Working Intent

Create a future wiki-managed Codex skill named `amortization`.

## Likely Caller

The Contract for Deed process will probably call this skill when it needs a 12-month amortization chart.

## Input Source

- Read the project spreadsheet.
- Use the worksheet currently referred to as `amateurization`.
- Confirm whether `amateurization` is the actual worksheet name or a spelling variant that should be normalized to `amortization` in outputs.

## Expected Output

- Create a formal amortization chart for the next 12 months.
- Process inside the Amortization project room.
- Write the finished PDF into the Amortization project-room `outputs` area.
- Copy only the finished PDF to the destination folder supplied by the calling skill unless Wes asks for the populated workbook too.
- Use a buyer-facing layout by default when the chart will be given to buyers.
- Use the Amortization project-room template workbook as the layout source when it exists.
- Output format and some styling details remain open unless the caller or Wes specifies them.

## Generator Script

- Reusable generator: `Project Rooms/Amortization/scripts/New-AmortizationChart.ps1`.
- Required inputs:
  - `ProjectName`
  - `ProjectSpreadsheetPath`
  - `CallerDestinationFolder`
  - `OutputFormat`, default `PDF`
- Read worksheet `Amortization` first; fallback to `amateurization`.
- Do not modify the source spreadsheet.
- Export PDF using `C:\Program Files\LibreOffice\program\soffice.exe`.
- Return/report the Amortization project-room PDF path, copied caller PDF path, worksheet used, first and last payment dates, payment-row count, and missing/ambiguous source data.

## Template Rule

- Keep the buyer-facing template workbook in `Project Rooms/Amortization/templates/Buyer-Facing Amortization Chart Template.xlsx`.
- Copy the template to the caller-supplied output folder for each run.
- Copy the template to the Amortization project-room working area for each run.
- Populate the copied workbook in the Amortization project room with project-spreadsheet values.
- Preserve the template's formatting, merged cells, column widths, print area, headers, and buyer-facing wording.
- Export the populated copy to PDF when a PDF is needed.
- Copy only the finished PDF to the caller destination by default.
- Do not place intermediate working XLSX files in the CFD project room by default.
- Do not rebuild the visual layout from scratch unless the template is missing or Wes explicitly asks for a redesign.
- Verify both labels and values are visible before reporting completion.

## Buyer-Facing Layout Rules

- Wrap column headers so columns can be narrower.
- Do not include cumulative-principal or cumulative-interest columns unless Wes explicitly asks.
- Do not include a `Prepared from...` subtitle.
- Do not include internal metadata such as source workbook path, source rows, or chart period.
- Do not include a bottom source note or implementation note.
- Keep only buyer-useful metadata, such as buyer name, property, contract date, sale amount, down payment, loan amount, buyer rate, and monthly total payment when available.
- Merge or widen buyer-facing metadata label/value cells as needed so labels and values do not truncate. Labels such as `Contract Date` and `Down Payment` must be fully visible.
- In the current template, keep the buyer value wide enough at `C3:F3`; put the right-side metadata labels at `G3:G6` and values at `I3:I6`.

## Skill Call Contract

- A calling skill, such as the Contract for Deed skill, must pass the project-room folder where the amortization output file should be dropped.
- The `amortization` skill should not infer or search for the destination folder when called by another skill.
- The output path should be treated as a required input unless Wes later defines a standalone/manual run mode.

## Open Design Points

- How the CFD process passes the project spreadsheet path to the skill.
- Whether the caller passes the project-room root, the `outputs/` folder directly, or both.
- Whether the skill should modify the source spreadsheet, create a new workbook, create a PDF/DOCX chart, or create a Markdown/table output.
- Whether the 12-month period starts from the contract start date, next payment due date, current date, or another project-specific date.
- How to handle balloon payments, late payments, irregular first payments, escrow, fees, or extra principal.
