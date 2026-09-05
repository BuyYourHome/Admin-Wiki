# Missing Context

| Question or Gate | Status | Decision Needed |
| --- | --- | --- |
| Approved interim execution method | ready | Wes authorized authenticated Chrome browser control for now. The earlier Zapier MCP path is superseded while this decision remains active. |
| Authenticated browser access | ready on `WES-VIDEOEDITOR` | The retained Intuit session continued successfully on 2026-09-02, opened the exact `Buy Your Home LLC` company, and supported duplicate-safe creation and read-back of Poyner Spruill bill `1277608` as transaction `13399`. No payment, paid-status, or send action occurred. |
| Visible company set | ready | Readiness validation showed `Buy Your Home LLC`, `BYH 401K LLC`, `Heritage Management LLC`, `Home Acct`, and `Sell Your Home LLC` without selecting one. |
| Exact QuickBooks target company/file | per-bill gate | The validated Invoice Entry handoff must name the target company; the browser must visibly match it before any bill entry begins. Current rule: BYH and Heritage Management property transactions both use `Buy Your Home LLC`; preserve the separate property entity and coding. |
| Safe validation environment | ready on `WES-VIDEOEDITOR` | At `2026-08-31T22:31:07.0879564Z`, the chooser showed five expected companies. No company was selected and no QuickBooks data changed. |
| Exact vendor and bill coding | per-bill gate | The handoff must provide the exact vendor and all required account/item, property/project, class, location, tax, terms, dates, and vendor-invoice-number mappings. Do not create or alter a vendor or infer missing coding. |
| Duplicate protection validation | per-bill gate | Reconcile the durable dispatch id in the action log and search QuickBooks using supplied vendor-invoice identity, vendor, amount, bill date, vendor invoice number, property/project, and known transaction id before creation. |
| Ambiguous submission recovery | per-bill gate | A browser error after submission or failed read-back blocks retry until the action log and QuickBooks search reconcile whether a bill exists. |
| Project Room messaging lifecycle | ready and dispatchable on `WES-VIDEOEDITOR` | `Quickbooks` is registered to the unchanged task id. Linked correction `prmsg-quickbooks-renamed-identity-validation-20260902-correction-001` completed unattended at `2026-09-02T09:40:19.2516703Z` after one delivered notification, with matching canonical/installed hashes, `manual_intervention: false`, and no business action. |
