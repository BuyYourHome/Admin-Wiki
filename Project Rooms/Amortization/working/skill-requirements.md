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
- Output format, styling, required columns, and filing destination are not yet specified.

## Open Design Points

- How the CFD process passes the project spreadsheet path to the skill.
- Whether the skill should modify the source spreadsheet, create a new workbook, create a PDF/DOCX chart, or create a Markdown/table output.
- Whether the 12-month period starts from the contract start date, next payment due date, current date, or another project-specific date.
- How to handle balloon payments, late payments, irregular first payments, escrow, fees, or extra principal.

