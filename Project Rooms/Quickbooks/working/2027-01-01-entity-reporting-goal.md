# January 1, 2027 QuickBooks Entity Reporting Goal

## Owner Instruction And Status

- Recorded: October 27, 2026, America/New_York.
- Target: January 1, 2027, America/New_York.
- Owner instruction: Wes said, "Lets make it a goal to have this in place by Jan 1," following discussion of one QuickBooks file, entity classes, separate balance sheets, and an automatic data feed for Codex reporting.
- Status: Active goal; planning and an offline source-snapshot prototype are recorded. See [[Project Rooms/Quickbooks/working/entity-reporting-progress]] for verified captures, coverage findings and remaining access requirements. Authenticated automatic collection, complete entity reporting, migration and production readiness remain unproven.
- Owning Project Room: Quickbooks. Registered execution target: `WES-VIDEOEDITOR`, task `01a05967-9a05-7081-a62e-616b2d8e61fd`, as documented in [[Project Rooms/Quickbooks/README]]. This note does not claim that a task handoff or deployment occurred.

## Intended Outcome

Record the agreed entities' ongoing transactions in one QuickBooks Online company file with consistent entity/class and property coding. Retrieve the complete accounting data into persistent reporting storage and produce reproducible separate trial balances, balance sheets, and profit-and-loss statements for each entity.

Start with an export-based Buy Your Home / Heritage Management pilot because their property transactions already share the Buy Your Home company file under the current documented rule. Confirm that the pilot covers transaction types used by the remaining entities before extending the design.

The January 1 target is an operational goal, not a declaration that final December 31 balances will already be available. Establish a controlled process for provisional opening balances and subsequent year-end adjustments.

## Proposed Milestones

These are planning targets. Record completed evidence separately; reaching a date does not establish completion or authorize cutover.

| Target | Milestone | Completion Evidence |
| --- | --- | --- |
| November 13, 2026 | Confirm exact entity scope, target company, reporting basis, account ownership, opening-balance sources, and data-access coverage. | Entity/account map; source inventory; proof that exports or the proposed connector expose required postings and settlement links. |
| November 30, 2026 | Complete the BYH / Heritage export pilot. | Separate entity reports for two closed months, independently reconciled to source balances; intercompany and equity rollforwards; visible exceptions without balancing plugs. |
| December 15, 2026 | Validate automatic collection and repeatable reporting. | Authorized collector on the agreed host/schedule; tests of new, edited, voided/deleted and backdated activity as applicable; interrupted-run recovery and duplicate protection; last-successful-sync and failure reporting. |
| December 23, 2026 | Complete parallel reporting for the agreed entity scope and preliminary go/no-go review. | Independently reconciled reports for all included entities, supported opening balances, resolved material exceptions, and documented migration/rollback plan. |
| December 28-30, 2026 | Correct remaining differences and rehearse cutover. | Repeated collection/reporting agrees on unchanged source data; recoverable historical baseline; reviewed cutover checklist and responsibilities. |
| December 31, 2026 | Confirm readiness and obtain the specific production decision. | Evidence-backed go/no-go decision from Wes; required accounting review complete; unresolved blockers disclosed. |
| January 1, 2027 | Target operational start. | Approved cutover, functioning collection, separate entity reports, and a documented opening-balance adjustment process. Preserve the existing workflow if readiness or authority is incomplete. |

## Required Reporting Controls

1. Assign every posting to its entity using documented account ownership, class/property mapping, and invoice/bill/payment links. Do not assume that an expense class identifies the owner of the related bank or liability balance.
2. Keep bank accounts, credit cards, assets, liabilities, equity, retained earnings, and owner contributions/distributions attributable to their legal owner.
3. Maintain paired intercompany due-to/from entries and reconcile reciprocal balances. Retain them in standalone reports; apply any justified eliminations only in a separate combined/consolidated view.
4. Validate each entity's debits and credits, balance-sheet equation, income/equity rollforward, bank/card balances, and A/R and A/P detail. Reconcile the sum of entity postings to the complete source ledger before any consolidation eliminations.
5. Preserve source company and transaction identifiers where available, posting dates, modification/deletion evidence, import/run identifiers, and links to source support. Never infer completeness solely from a bank feed or an income/expense summary.
6. Produce identical results from unchanged inputs and mapping versions. Surface ambiguous ownership, incomplete data, and stale collection as explicit exceptions; do not guess or use unexplained balancing entries.
7. Store credentials, source exports, financial databases, and generated statements outside Git in approved protected locations. Git retains the design, code/configuration when authorized, and concise readiness evidence.

## Open Dependencies And Decisions

- Confirm the legal entities and accounts to include. The earlier five visible company names included `Home Acct` and `BYH 401K LLC`; visible company names are not proof of five equivalent legal-entity scopes. Review personal/retirement reporting requirements before inclusion.
- Confirm the exact target QuickBooks company, subscription capabilities, entity/property class structure, and whether locations should supplement the design.
- Establish access to complete source data and independently reconciled opening balances. No callable QuickBooks accounting connector has been demonstrated in this planning request.
- Select and authorize the connector/API method, secure credential storage, host availability, collection frequency, protected storage, and operational exception owner. Enforce reporting-only behavior in the collector; do not assume that an OAuth grant itself is read-only.
- Decide between a forward cutover using opening balances/open items and a full historical transaction migration. The goal does not silently select either method.
- Obtain accounting review of the entity separation, reporting basis, equity, and intercompany treatment before relying on the new reports for production or filing.

## Authorization And Completion Boundaries

This record establishes the goal and proposed plan. It does not change the existing Invoice mode, authorize new financial postings or payments, select paid services, expose credentials, cancel legacy company files, or perform production migration/cutover. Apply the specific authority and access requirements when those actions are prepared.

No recurring automation, reminder, live QuickBooks connection, or remote task notification was created by recording this plan. Implementation progress must be supported by actual evidence, not by the goal's active status.

Next milestone work: restore usable read-only company access, execute the prepared HM/Home preservation scope, and obtain posting-complete sources and independent controls for the BYH / Heritage pilot before changing live books. Existing BYH exports have been preserved and structurally audited as documented in [[Project Rooms/Quickbooks/working/entity-reporting-progress]].

## References

- [[Project Rooms/Quickbooks/README]] and [[skills/quickbooks/SKILL]]: current operating scope, entity-versus-company-file rule, and execution target.
- [Intuit: balance sheet by class or location](https://quickbooks.intuit.com/learn-support/en-global/help-article/balance-sheet/run-balance-sheet-class-location-quickbooks-online/L2wj2NQT2_ROW_en): class/header limitations discussed during planning; reverify before implementation.
- [Intuit: export QuickBooks Online data](https://quickbooks.intuit.com/learn-support/en-us/help-article/list-management/export-reports-lists-data-quickbooks-online/L1xleDrLp_US_en_US): export-based pilot source.
- [Intuit: webhook reliability practices](https://static.developer.intuit.com/output_html/qbo/docs/develop/webhooks/best-practices.html): change notification and reconciliation design reference; not proof of an implemented connector.
