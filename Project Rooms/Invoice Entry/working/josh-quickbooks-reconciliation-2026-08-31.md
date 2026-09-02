# Josh Kennedy LLC QuickBooks Reconciliation - 2026-08-31

## Authority And Scope

- Parent message: `prmsg-jean-josh-quickbooks-reconciliation-20260831-001`
- Payload hash: `499c74325628b889974903417a10d60578c96a3a1ceffcf9056d3e485361c28e`
- Requested operation: inventory authoritative Josh Kennedy / Josh Kennedy LLC payable invoices, exclude non-payable or duplicate presentations, reconcile eligible obligations against QuickBooks, and route eligible missing bills only after `Quickbooks` is dispatchable.
- Prohibited actions preserved: no payment, paid status, external contact, or inferred approval.

## Reconciliation Result

The authoritative Invoice Entry record contains two approved, unpaid Josh Kennedy LLC obligations. No authoritative QuickBooks record, bill id, or completed Josh duplicate-search result exists in the `Quickbooks` action log. This does **not** prove the bills are absent from QuickBooks.

At the time of the initial audit, the workflow now named `Quickbooks` was not dispatchable. Its manifest named task `01a05967-9a05-7081-a62e-616b2d8e61fd` on `WES-VIDEOEDITOR`, but recorded `dispatchable: false`, messaging readiness `pending`, and browser readiness `pending_machine_validation`. Invoice Entry therefore created no child production handoff and performed no live QuickBooks action.

| Source invoice or presentation | Period | Amount | Authoritative classification | QuickBooks reconciliation | Action |
| --- | --- | ---: | --- | --- | --- |
| `TC-JK-20260724-BACKOFFICE-001` and `TC-JK-20260724-TENSITY-001` | Week ending 2026-07-24 | Historical components of later total | Superseded historical weekly presentations consolidated into `INV-JKLLC-20260731-001` | Not searched as separate obligations | Excluded; never create separate bills |
| `PCA-JK-20260731-TENSITY-001` / prior `TC-JK-20260731-TENSITY-001` | Week ending 2026-07-31 | Historical component of later total | Superseded historical weekly presentation consolidated into `INV-JKLLC-20260731-001` | Not searched as a separate obligation | Excluded; never create a separate bill |
| `SP-JK-20260731-001` | 2026-07-20 through 2026-07-31 | `$2,500.00` | Denied by Wes and retired | Not eligible for QuickBooks creation | Excluded; do not revive or pay |
| `INV-JKLLC-20260731-001` | 2026-07-16 through 2026-07-31 | `$2,500.00` | Approved by Wes; unpaid; allocations `$199.57` BackOffice and `$2,300.43` Tensity | No authoritative QuickBooks bill id or search result found; existence remains unverified | Eligible payable obligation, but not handoff-ready until Quickbooks Invoice is dispatchable and exact QuickBooks terms/due-date and line mappings, including BackOffice, are supplied without inference |
| `INV-JKLLC-20260815-001` | 2026-08-01 through 2026-08-15 | `$2,708.33` | Approved by Wes - Not Paid; allocations `$1,899.20` Tensity, `$310.17` BackOffice, `$404.56` Rosebrooks, `$94.40` Pond | No authoritative QuickBooks bill id or search result found; existence remains unverified | Eligible payable obligation, but not handoff-ready until Quickbooks Invoice is dispatchable and exact QuickBooks terms/due-date and all line mappings, including BackOffice, are supplied without inference |
| `INV-JKLLC-20260831-001` | 2026-08-16 through 2026-08-31 | `$2,708.33` draft amount | Period-open draft through August 29; unresolved August 25 allocation; not approved, finalized, filed, posted, or payable | Not eligible for QuickBooks creation | Excluded until the period closes, source allocation is resolved, and Wes approves the exact invoice |

## Approved Source Evidence

### `INV-JKLLC-20260731-001`

- Vendor: `Josh Kennedy LLC`
- Target QuickBooks company under the current rule: `Buy Your Home LLC`
- Approved source PDF: `C:\Users\wesbr\Buy Your Home\Buy Your Home - Office Admin\Scanned Files\Invoice Entry Working Archive\Generated\2026-08-03-Josh-Semimonthly-Approved-Format\26-07-31 - Josh Kennedy LLC - Time Card Invoice - 2026-07-16 to 2026-07-31.pdf`
- SHA-256: `2593B5352F7C6A8D472A3C227FDA208D421488AB3024B9616216EE4EFA488A69`
- Source approval: Wes approved on 2026-08-03; later changes were limited to format.
- Missing production-handoff fields: exact QuickBooks due date or terms and exact line-level QuickBooks mappings, including BackOffice. These facts may not be inferred.

### `INV-JKLLC-20260815-001`

- Vendor: `Josh Kennedy LLC`
- Target QuickBooks company under the current rule: `Buy Your Home LLC`
- Approved source PDF: `C:\Users\wesbr\Buy Your Home\Buy Your Home - Office Admin\Invoices & Receipts\26-08-15 - Josh Kennedy LLC - Time Card Invoice - 2026-08-01 to 2026-08-15.pdf`
- SHA-256: `BDE66D2ABBB68AFED75223DB18E0A41BAD4DE0DB3B4DB14B20908ADD3C377427`
- Source approval: Wes approved the exact closed-period invoice on 2026-08-21.
- Missing production-handoff fields: exact QuickBooks due date or terms and exact line-level QuickBooks mappings, including BackOffice. These facts may not be inferred.

## Required Next Step

After the `Quickbooks` owner records its manifest as dispatchable and completes the registered machine/browser readiness checks, Invoice Entry must re-read this reconciliation, confirm the exact QuickBooks terms and mappings for each approved obligation, and send one duplicate-safe handoff per eligible obligation or an explicitly authorized combined batch. `Quickbooks` must then search before creation, save no more than once, and read the saved bill back. An existing-match result must be returned with its QuickBooks transaction id; an ambiguous result must block retry.

## Resume Result - 2026-08-31

- Resume message: `prmsg-jean-josh-quickbooks-reconciliation-resume-20260831-001`
- Payload hash: `4d4e1ed88ebc8ad0d2d3f28a95fb7152d848c37dee87ef65b20c254c511fa9d7`
- Authoritative readiness evidence: `prmsg-jean-quickbooks-wve-browser-readiness-retry-20260831-002` completed for the task now registered to `Quickbooks` as `01a05967-9a05-7081-a62e-616b2d8e61fd` on `WES-VIDEOEDITOR`, with messaging and Chrome readiness passed, `dispatchable: true`, five visible companies, no company selected, and no QuickBooks data changed.
- The existing invoice inventory was reused without repeating or expanding it.

The approved PDFs were read directly. They confirm:

| Invoice | Invoice date | Supported destinations | Unsupported production-handoff fields | Result |
| --- | --- | --- | --- | --- |
| `INV-JKLLC-20260731-001` | `2026-07-31` | BackOffice `$199.57`; `24-HM - 4121 Tensity Dr` `$2,300.43` | No due date or terms on the PDF; no authoritative QuickBooks vendor identifier; no exact BackOffice or Tensity customer/project/job mapping; no exact account/item, class, location, or tax mapping | No child handoff created; `Needs Wes` |
| `INV-JKLLC-20260815-001` | `2026-08-15` | Tensity `$1,899.20`; BackOffice `$310.17`; Rosebrooks `$404.56`; Pond `$94.40` | No due date or terms on the PDF; no authoritative QuickBooks vendor identifier; no complete exact customer/project/job mapping for all four lines; no exact account/item, class, location, or tax mapping | No child handoff created; `Needs Wes` |

The Tim Fleming supervised bill proves only that its Pond and Rosebrooks lines used `BYH:908`, `BYH:115`, and `Property Asset:Property Asset Improvements`. It does not establish a reusable Josh labor rule, a Tensity mapping, a BackOffice mapping, Josh's exact QuickBooks vendor record, or the missing terms. Reusing those values would be an unsupported accounting inference.

No immutable production child message was created because neither obligation meets the `Quickbooks` required-handoff contract. Wes or an authoritative accounting mapping source must supply the exact vendor record, due date or terms, and all required account/item, customer/project/job, class, location, and tax mappings for each line. After those facts are supplied, Invoice Entry may create the exact child handoff and require live duplicate search, one save only when absent, and full read-back.
