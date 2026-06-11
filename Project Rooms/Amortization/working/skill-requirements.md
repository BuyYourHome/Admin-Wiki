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
- Output format and some styling details remain open unless the caller or Wes specifies them.

## Buyer-Facing Layout Rules

- Wrap column headers so columns can be narrower.
- Do not include cumulative-principal or cumulative-interest columns unless Wes explicitly asks.
- Do not include a `Prepared from...` subtitle.
- Do not include internal metadata such as source workbook path, source rows, or chart period.
- Do not include a bottom source note or implementation note.
- Keep only buyer-useful metadata, such as buyer name, property, contract date, sale amount, down payment, loan amount, buyer rate, and monthly total payment when available.

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
