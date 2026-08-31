# Duplicate And Conflict Log

| Item | Status | Notes |
| --- | --- | --- |
| Project Room or matching skill named `Quickbooks Invoice` / `quickbooks-invoice` | no duplicate found | No existing matching room, skill, registry entry, routing row, manifest, or task was found during setup review. |
| Invoice Entry versus Quickbooks Invoice ownership | clarified | Invoice Entry owns vendor-invoice intake, source validation, mappings, approval gates, and handoff preparation. Quickbooks Invoice owns controlled QuickBooks bill creation and read-back verification only. |
| Customer invoice versus vendor bill | resolved by Wes | Vendor invoices sent through this PR are entered as QuickBooks bills. Customer-invoice creation is out of scope. |
| Heritage Management entity versus QuickBooks company file | resolved by Wes | Heritage Management property transactions are currently held in the `Buy Your Home LLC` QuickBooks company file. Preserve the Heritage Management property/project identity separately; do not select the visible `Heritage Management LLC` file for these transactions under the current rule. |
| Browser versus connector execution | superseded by Wes decision | Durable decision `prmsg-jean-quickbooks-browser-control-decision-20260831-001` authorizes authenticated Chrome browser control as the interim method. The prior connector-only/browser-prohibited rule no longer controls while this authorization remains active. |
| Duplicate QuickBooks bill risk | open gate | The workflow must search using dispatch id, source vendor-invoice identity, vendor, amount, bill date, vendor invoice number, property/project, and known transaction id before any creation. |
| Safe readiness validation versus production bookkeeping | resolved | Company-chooser inspection verified authenticated access and five visible companies without selecting one or changing any record. Production actions remain governed by validated handoff, exact-company, duplicate, one-save, read-back, and no-unrelated-action gates. |
