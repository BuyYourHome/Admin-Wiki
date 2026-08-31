# Missing Context

| Question or Gate | Status | Decision Needed |
| --- | --- | --- |
| Approved interim execution method | ready | Wes authorized authenticated Chrome browser control for now. The earlier Zapier MCP path is superseded while this decision remains active. |
| Authenticated browser access | ready on `WES-VIDEOEDITOR` | Read-only Chrome validation reached the authenticated QuickBooks company chooser. Any future login challenge remains a per-run blocker requiring Wes interaction. |
| Visible company set | ready | Readiness validation showed `Buy Your Home LLC`, `BYH 401K LLC`, `Heritage Management LLC`, `Home Acct`, and `Sell Your Home LLC` without selecting one. |
| Exact QuickBooks target company/file | per-bill gate | The validated Invoice Entry handoff must name the target company; the browser must visibly match it before any bill entry begins. Current rule: BYH and Heritage Management property transactions both use `Buy Your Home LLC`; preserve the separate property entity and coding. |
| Safe validation environment | ready on `WES-VIDEOEDITOR` | At `2026-08-31T22:31:07.0879564Z`, the chooser showed five expected companies. No company was selected and no QuickBooks data changed. |
| Exact vendor and bill coding | per-bill gate | The handoff must provide the exact vendor and all required account/item, property/project, class, location, tax, terms, dates, and vendor-invoice-number mappings. Do not create or alter a vendor or infer missing coding. |
| Duplicate protection validation | per-bill gate | Reconcile the durable dispatch id in the action log and search QuickBooks using supplied vendor-invoice identity, vendor, amount, bill date, vendor invoice number, property/project, and known transaction id before creation. |
| Ambiguous submission recovery | per-bill gate | A browser error after submission or failed read-back blocks retry until the action log and QuickBooks search reconcile whether a bill exists. |
| Project Room messaging lifecycle | ready on `WES-VIDEOEDITOR` | Exact task registered, central host access verified, and corrected record `prmsg-quickbooks-invoice-wve-readiness-correction-20260831-001` completed Accepted/Processing/Completed after exactly one notification with `synthetic_test: true`, exact identity, and payload-hash verification. |
