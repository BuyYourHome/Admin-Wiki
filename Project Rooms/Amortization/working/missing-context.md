# Missing Context

The project room has been started, but the following context is still needed before drafting the future `amortization` skill:

| Needed Item | Why It Matters | Status |
| --- | --- | --- |
| Skill inputs | Defines whether the skill expects principal, interest rate, term, start date, payment amount, balloon terms, extra payments, or CFD-specific fields. | missing |
| Project spreadsheet path | Needed so the skill can reliably locate the workbook. | missing |
| Worksheet name | The worksheet is currently referred to as `amateurization`; need to confirm exact spelling and whether the skill should tolerate alternate spellings. | missing |
| Skill outputs | Current target is a formal amortization chart for the next 12 months; need file type and presentation format. | missing |
| Chart columns | Defines required columns such as payment date, payment number, beginning balance, payment, interest, principal, escrow, fees, ending balance, and notes. | missing |
| Rounding and date rules | Prevents small calculation differences from changing payment schedules or balances. | missing |
| Contract for Deed integration point | Clarifies when the CFD process should call the `amortization` skill and what it should pass in. | missing |
| Source materials | Drafting should rely on authoritative sources rather than assumptions. | missing |
| Validation examples | Needed to test calculations against known-good amortization outputs. | missing |
