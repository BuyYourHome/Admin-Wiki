# Duplicate And Conflict Log

| Item | Status | Notes |
| --- | --- | --- |
| Project Room or matching skill named `Quickbooks Invoice` / `quickbooks-invoice` | no duplicate found | No existing matching room, skill, registry entry, routing row, manifest, or task was found during setup review. |
| Invoice Entry versus Quickbooks Invoice ownership | clarified | Invoice Entry owns intake, source validation, mappings, approval gates, and handoff preparation. Quickbooks Invoice owns connector-backed creation and read-back verification only. |
| Browser versus connector execution | resolved | Browser automation is prohibited as a substitute for a missing connector. |
| Duplicate QuickBooks invoice risk | open gate | The workflow must search using dispatch id, source invoice identity, customer, amount, date, and known transaction id before any creation. |
| Safe connector validation versus production bookkeeping | resolved | Validation must use a non-production sandbox, connector dry run, or another specifically approved no-production-impact path. It must not send, apply payment, mark paid, void/delete, or alter unrelated books. |
