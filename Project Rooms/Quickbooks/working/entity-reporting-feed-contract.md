# Entity Reporting Feed Contract

- Recorded: October 27, 2026. Target: January 1, 2027 under [[Project Rooms/Quickbooks/working/2027-01-01-entity-reporting-goal]].
- Scope: collection and reproducible external entity reporting; begin with the authorized BYH / Heritage export pilot.
- Status: design/reference only. No authenticated accounting connector or collector has been deployed by this work; no secrets were obtained or stored, and no QBO, system, or service changes were made.
- This contract does not change Invoice mode, authorize financial postings, cancel subscriptions, or approve migration/cutover.

## Evidence Labels And Authority

- **Verified documentation** below means official Intuit documentation or an identified Intuit Developer Support answer was read; it is not evidence from the live company.
- **Design requirement** means the proposed control for this collector, subject to implementation and acceptance evidence.
- **Untested** means current company payloads, column support, access, or end-to-end behavior have not been demonstrated.
- QBO remains the source ledger. External mappings must distinguish the company file, legal entity, property/project, bank/account owner, and intercompany counterpart.

## Verified Report Behavior

- Intuit's modernized Reports API became the only supported service after August 31, 2026; `GeneralLedger`, `JournalReport`, `TrialBalance`, `BalanceSheet`, and `ProfitAndLoss` remain documented reports. Row order can change, account hierarchies nest differently, and enclosing rows use `Section`; `qzurl` is unsupported. [Intuit migration notice](https://medium.com/intuitdev/upcoming-changes-to-reports-apis-5083ec9aadce)
- Intuit Developer Support states that GeneralLedger records do not provide unique identifiers by default. A transaction identifier, when present, must not be assumed to identify each debit/credit posting line. [Intuit identifier answer](https://help.developer.intuit.com/s/question/0D5TR000012mPNT0A2/how-to-identify-unique-records-in-generalledger-reports)
- Reports compute financial views using company accounting settings and can use compliance dates rather than raw transaction dates. Intuit documents a 400,000-cell response limit, possible incomplete results, and omitted inactive/zero rows; it recommends date chunks no larger than six months. Its older `qzurl` advice is superseded by the migration notice. [Intuit report guidance](https://medium.com/intuitdev/quickbooks-online-reports-api-best-practices-and-troubleshooting-31edc9934b4c)

## Snapshot And Posting Identity Requirements

- Preserve immutable raw report responses and a manifest: source realm/company, report name, basis, currency, period, parameters/minor version, retrieval time, response hash, row counts, totals, and completeness/error indicators.
- Begin with monthly GeneralLedger/JournalReport requests and independently reconcile period/account totals to TrialBalance, BalanceSheet, and ProfitAndLoss on the same basis.
- Parse returned column metadata and recursive sections; never assume fixed column positions, row order, or account-name hierarchy formatting.
- Replace a complete validated period snapshot atomically. Retain the previous snapshot for comparison and recovery; do not append a replacement report to the prior report's postings.
- A snapshot-local row path/occurrence is an artifact locator, not permanent financial identity. Preserve legitimate identical rows; hashes alone cannot distinguish them or survive edits.
- Store raw API objects separately under `(realmId, entityType, Id)` with versions, timestamps, hashes, and prior observed versions. Do not equate an API source line with a report posting line without verified correspondence.
- Raw objects explain/enrich source postings. Never add their totals to already-counted report postings as additional ledger activity.

### Source-Set Compatibility Gate

- Preserve individual files first; archival acceptance does not approve a file as the controlling financial revision. The current offline collector does not implement this multi-report gate or certify entity readiness.
- Before reconciliation, identify one versioned source-set manifest containing each immutable source hash/snapshot ID, verified source company/realm, report role, period, accounting basis, currency, retrieval/generation times, filters, class hierarchy, and authority for selecting the revision. Record unknown metadata as unknown, not as defaults.
- Establish a common extraction cutoff/source state, or an explicit reviewed bridge for changes between reports. Matching company/period/basis alone is insufficient. Different timestamps alone are not proof of incompatibility; unexplained control differences or missing revision evidence block certification.
- Compare company controls before attributing changes only to classes. Match classes by full hierarchy, not column position or repeated property labels; do not count both leaf classes and their subtotals.
- Preserve superseded baselines and revision candidates separately. Trace and rebase any previous manual ownership/reclassification overlays against the selected revision before applying them; never apply the report's recoding and an already-reflected manual adjustment twice. Cross-PR workpapers remain owned by their originating PR.
- Record the compatible-set decision, exceptions and mapping/overlay version used by every published statement. No approved set currently exists for complete BYH/Heritage entity statements; the actual two-P&L conflict is documented in [[Project Rooms/Quickbooks/working/entity-reporting-progress]].

## Raw Object Coverage And Settlement Context

- Baseline ordinary financial-object candidates: `Invoice`, `Payment`, `CreditMemo`, `SalesReceipt`, `RefundReceipt`, `Bill`, `BillPayment`, `VendorCredit`, `Purchase`, `Deposit`, `Transfer`, and `JournalEntry`.
- Baseline reference candidates: `Account`, `Item`, `Customer`, `Vendor`, `Class`, `Department`, `CompanyInfo`, and `Preferences`; include inactive records where the endpoint supports them.
- Capture all available source lines, account/class/location/customer/project references, amounts, taxes, currency/exchange-rate data, notes, links, object IDs, versions, and metadata; preserve absent fields as absent.
- Payment links and unapplied cash are material: `Payment.Line.LinkedTxn`, `UnappliedAmt`, and `DepositToAccountRef` explain application and Undeposited Funds; `BillPayment` links payments to bills and payment accounts. Read linked objects by their type/ID when required. [Payment reference](https://developer.intuit.com/app/developer/qbo/docs/api/accounting/all-entities/payment), [BillPayment reference](https://developer.intuit.com/app/developer/qbo/docs/api/accounting/all-entities/billpayment)
- The candidate lists are a design baseline, not a completeness guarantee. Inventory every transaction type appearing in full source reports, including payroll, tax, inventory, foreign-exchange, and system adjustments; resolve unsupported or unmatched postings explicitly.
- `JournalEntry` objects alone are not the full ledger. Bank-feed items or income/expense summaries alone are also insufficient.
- Keep voided objects/version evidence and deletion tombstones. A void and a hard deletion are different source events; do not merely drop zero-amount records. [Payment void/delete examples](https://developer.intuit.com/app/developer/qbo/docs/api/accounting/all-entities/payment)

## Change Collection, Cursors, And Recovery

- Verified documentation: CDC returns changed-object payloads, looks back at most 30 days, returns at most 1,000 objects, and places deleted objects after active objects. It is a current-state synchronization facility, not a full historical audit trail. [Intuit CDC guidance](https://medium.com/intuitdev/building-smarter-with-intuit-stay-in-sync-with-cdc-171f8094dd37)
- Poll using modification time (`changedSince`), not transaction date. Use overlap, idempotent application, and per-realm/entity checkpoints; advance checkpoints only after durable storage and successful validation/application.
- Treat a response at the CDC cap as potentially incomplete. Narrow entity requests/increase polling frequency or rebaseline with paginated object reads and fresh reports; never certify completeness from a capped response.
- Verify the supported CDC entity list against current documentation and live responses; unsupported entities require explicit periodic refresh/reconciliation.
- Current webhooks use CloudEvents including event `id`, `type`, `time`, `intuitentityid`, and `intuitaccountid`; supported Create/Update/Delete/Void/Merge events vary by entity. Authenticate signatures and retain event identity. [Current webhook contract](https://static.developer.intuit.com/output_html/qbo/docs/develop/webhooks/configure-webhooks.html)
- Queue webhooks asynchronously, deduplicate and tolerate reordering; retrieve current object state when applicable. Intuit recommends CDC reconciliation because webhook events can be missed. [Intuit webhook reliability](https://static.developer.intuit.com/output_html/qbo/docs/develop/webhooks/best-practices.html)
- For edits/backdating, invalidate both the prior and current affected report periods. Reference/account/item/class changes can require broader refresh; a bounded recent-period window cannot by itself prove all older history is unchanged.
- After an interruption, replay overlapping changes before publishing. After a gap beyond CDC retention or unresolved truncation, compare a fresh complete active-object inventory with stored IDs and rebuild affected reports; record that intermediate historical versions may be unrecoverable.
- Expose last successful complete sync, source cutoff, stale/incomplete status, retry history, and unresolved exceptions. Failed or partial runs must not replace the last validated published dataset.

## OAuth And Collector Boundary

- Minimum proposed ordinary Accounting REST scope: `com.intuit.quickbooks.accounting`. The separate QuickBooks Payments processing scope is not required merely to read Accounting `Payment`/`BillPayment` objects. [Intuit scope distinction](https://help.developer.intuit.com/s/question/0D5TR00001OXV0m0AH/does-authorizing-a-thirdparty-oauth2-app-to-a-quickbooks-online-company-require-an-admin-user-or-can-a-nonadmin-authorize-it-is-the-apps-access-strictly-limited-to-the-scopes-it-requests-and-can-an-admin-revoke-it-anytime)
- Accounting OAuth is not a read-only grant: Intuit documents invoice-creation REST operations under that same accounting scope. Enforce read-only collection in application code and outbound policy. [Intuit accounting-scope write example](https://medium.com/intuitdev/unlocking-project-tracking-with-the-projects-api-c0812fafa2dc)
- Allow only approved Accounting GET routes for entity reads, SELECT queries, reports, and CDC against the exact authorized realm. Deny Accounting POST/PUT/PATCH/DELETE, batch, send, payment-processing, create/update/delete/void operations, arbitrary URLs, and arbitrary query text.
- OAuth authorization/refresh/revocation is a separate credential-management surface; its required protocol POSTs do not authorize Accounting mutations. Keep credentials outside model output, Git, logs, and report artifacts.
- Sandbox and production must have explicit separate configurations. Prove the method/path/realm deny rules with controlled local/mock tests before enabling production reads.

## Untested Payload Contract And Storage

- Require live acceptance evidence for dates, transaction type, reference number, memo, account, debit/credit, classification, currency/home amounts, and any source transaction links needed for allocation.
- Candidate report column names include `tx_date`, `txn_type`, `doc_num`, `memo`, `account_name`, `debt_amt`, and `credit_amt`; these are unverified for the current realm/service and must not be promised as universally returned.
- Canonical GeneralLedger/JournalReport reference pages returned a JavaScript loading shell during research. Exact column support, returned IDs, source-line correspondence, permissions, and real report completeness remain untested.
- Store raw JSON/exports, financial databases, cursor/runtime state, generated statements, backups, and secrets outside this Git repository in approved protected application-data or Teams/SharePoint locations. Resolve the exact destination before extraction.
- Git retains design/code/configuration when authorized and concise manifests/readiness evidence without unnecessary financial data or secrets.

## Acceptance Evidence Before Operational Use

1. Confirm the exact company/realm, legal entities, basis/currency, reporting periods, source-account ownership, mapping version, protected storage, host/schedule, and exception owner.
2. Preserve a complete historical baseline or independently reconciled opening balances/open items; document provisional December 31 balances and the later year-end adjustment process.
3. Reconcile two closed BYH / Heritage pilot months: every source posting allocated or visibly excepted, entity debits/credits and balance sheets balanced, entity totals equal source totals, and intercompany/equity/open-item rollforwards supported without balancing plugs.
4. Demonstrate creation/edit/backdating, void/delete handling, moved-period replacement, duplicate/identical rows, missing webhook, interruption, CDC-cap/retention recovery, and stale-data failure behavior using authorized test evidence.
5. Repeated runs on unchanged inputs/mappings produce identical results; snapshot counts, hashes, totals, and source retrieval evidence explain every revision.
6. Verify read-only outbound enforcement, secure token handling, recoverable backups, and operational failure reporting. Record any source/API gaps before an evidence-backed go/no-go decision.
7. Obtain the specific production/cutover authority and required accounting review under the goal note; this reference contract alone establishes no readiness or cancellation authority.
