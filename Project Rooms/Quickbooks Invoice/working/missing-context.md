# Missing Context

| Question or Gate | Status | Decision Needed |
| --- | --- | --- |
| Approved interim execution method | ready | Wes authorized authenticated Chrome browser control for now. The earlier Zapier MCP path is superseded while this decision remains active. |
| Authenticated browser access | ready with per-run check | The existing Intuit session reached the QuickBooks Online company chooser. Any later login challenge is a blocker and requires Wes interaction. |
| Visible company set | ready | Readiness validation showed `Buy Your Home LLC`, `BYH 401K LLC`, `Heritage Management LLC`, `Home Acct`, and `Sell Your Home LLC` without selecting one. |
| Exact QuickBooks target company/file | per-invoice gate | The validated Invoice Entry handoff must name the target company; the browser must visibly match it before any invoice entry begins. |
| Safe validation environment | ready | No-production-impact company-chooser inspection passed without selecting a company or changing any record. |
| Duplicate protection validation | per-invoice gate | Reconcile the durable dispatch id in the action log and search QuickBooks using supplied invoice identity, customer, amount, date, invoice number, and known transaction id before creation. |
| Ambiguous submission recovery | per-invoice gate | A browser error after submission or failed read-back blocks retry until the action log and QuickBooks search reconcile whether an invoice exists. |
| Project Room messaging lifecycle | ready | Exact task registration, host access, and corrected synthetic lifecycle `prmsg-quickbooks-invoice-readiness-validation-20260831-1342-correction-001` completed on `WESSTUDIO` after exactly one notification. Per-invoice browser safety gates still apply. |
