# Missing Context

| Question or Gate | Status | Decision Needed |
| --- | --- | --- |
| Approved interim execution method | ready | Wes authorized authenticated Chrome browser control for now. The earlier Zapier MCP path is superseded while this decision remains active. |
| Authenticated browser access | pending on `WES-VIDEOEDITOR` | The prior `WESSTUDIO` Intuit session does not establish browser readiness on the new execution machine. Verify the authenticated company chooser on `WES-VIDEOEDITOR`; any login challenge requires Wes interaction. |
| Visible company set | ready | Readiness validation showed `Buy Your Home LLC`, `BYH 401K LLC`, `Heritage Management LLC`, `Home Acct`, and `Sell Your Home LLC` without selecting one. |
| Exact QuickBooks target company/file | per-bill gate | The validated Invoice Entry handoff must name the target company; the browser must visibly match it before any bill entry begins. Current rule: BYH and Heritage Management property transactions both use `Buy Your Home LLC`; preserve the separate property entity and coding. |
| Safe validation environment | pending on `WES-VIDEOEDITOR` | Repeat the no-production-impact company-chooser inspection on the new execution machine without selecting a company or changing any record. |
| Exact vendor and bill coding | per-bill gate | The handoff must provide the exact vendor and all required account/item, property/project, class, location, tax, terms, dates, and vendor-invoice-number mappings. Do not create or alter a vendor or infer missing coding. |
| Duplicate protection validation | per-bill gate | Reconcile the durable dispatch id in the action log and search QuickBooks using supplied vendor-invoice identity, vendor, amount, bill date, vendor invoice number, property/project, and known transaction id before creation. |
| Ambiguous submission recovery | per-bill gate | A browser error after submission or failed read-back blocks retry until the action log and QuickBooks search reconcile whether a bill exists. |
| Project Room messaging lifecycle | pending on `WES-VIDEOEDITOR` | Register exact task `01a05967-9a05-7081-a62e-616b2d8e61fd`, verify host access, and complete a new one-notification Accepted/Processing/Completed synthetic lifecycle on `WES-VIDEOEDITOR`. The earlier `WESSTUDIO` lifecycle is historical only. |
