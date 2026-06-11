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
- Write the output file into the project-room output folder supplied by the calling skill.
- Use a buyer-facing layout by default when the chart will be given to buyers.
- Use the Amortization project-room template workbook as the layout source when it exists.
- Output format and some styling details remain open unless the caller or Wes specifies them.

## Template Rule

- Keep the buyer-facing template workbook in `Project Rooms/Amortization/templates/Buyer-Facing Amortization Chart Template.xlsx`.
- Copy the template to the caller-supplied output folder for each run.
- Populate the copied workbook with project-spreadsheet values.
- Preserve the template's formatting, merged cells, column widths, print area, headers, and buyer-facing wording.
- Export the populated copy to PDF when a PDF is needed.
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
