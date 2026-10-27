# HM And Home Records Preservation Package

## Request And Status

Wes asked on October 27, 2026: "I would like to close the subscriptions to HM and Home right away. How do I preserve those records if I do". Preserve this as an archive-priority instruction within the [[Project Rooms/Quickbooks/working/2027-01-01-entity-reporting-goal]]. It is not evidence that either subscription was canceled or that a complete archive exists.

Targets: the actual `Heritage Management LLC` and `Home Acct` QuickBooks Online company files. Verify their live company identifiers and visible names before extraction. Do not substitute the combined Buy Your Home file for either target.

Status: authenticated access, exact target identity, target billing status and All Dates General Ledger availability are verified. The native QuickBooks reports/lists and all attachments visible in each target's Attachments list were downloaded, hashed, opened or structure-checked, uploaded to the protected Teams `Office Admin` primary archive, and read back by folder listing. Wes will provide the independent backup later. No subscription, payment, accounting record or company setting has been changed.

## Verified Availability And Gaps

- Metadata searches of existing local Office Admin CPA yearfolders for 2019-2026, the IRS source-path catalog, and private IRS workpaper filenames found no standalone HM/Home accounting archive. This is bounded search evidence, not proof that no copy exists anywhere.
- The existing BYH 2025 General Ledger and P&L exports remain available. They do not establish that the separate HM file is empty, duplicated, migrated, or completely preserved. No Home Acct source was found in the searched locations.
- On October 27, the current task's host was verified as `WesStudio`. The registered Quickbooks execution target remains `WES-VIDEOEDITOR`, task `01a05967-9a05-7081-a62e-616b2d8e61fd`.
- Two read-only browser inventory attempts timed out and reset their kernel before returning any browser/company state. No extraction or cancellation was attempted.
- After Wes completed the user-only Intuit sign-in, the continuation on registered target `Wes-VideoEditor` verified the authenticated company chooser under the Wes/`WesWill@BuyYourHomeLLC.com` session. The exact visible QuickBooks Online companies were `Buy Your Home LLC`, `BYH 401K LLC`, `Heritage Management LLC`, `Home Acct`, and `Sell Your Home LLC`. A separate `Canceled companies (1)` control was visible but was not opened.
- `Heritage Management LLC`, company ID `9341 4542 8085 1491`, opened successfully. Its billing page showed QuickBooks Plus as `SUBSCRIBED`, $140/month plus applicable taxes, next charge November 1, 2026, billed to Wes's authenticated account. QuickBooks Online Payments also displayed as subscribed. An All Dates General Ledger was available on accrual basis; the first visible dated row in the first visible account section was March 6, 2025.
- `Home Acct`, company ID `1362 4761 70`, opened successfully. Its billing page showed QuickBooks Plus as `SUBSCRIBED`, $140/month plus applicable taxes, next charge November 19, 2026, billed to Wes's authenticated account. An All Dates General Ledger was available on cash basis; the first visible dated row in the first visible account section was November 17, 2015.
- The first visible General Ledger dates are not certified company-wide earliest dates because the reports were organized by account and only visible rows were inspected. They prove live report access, not certified company-wide earliest activity. Native exports were subsequently completed as documented below. The visible cancellation controls were not clicked; no QuickBooks data or settings were changed. Payment-card and merchant identifiers were intentionally excluded from the wiki.
- The verified WesStudio pilot archive is not present at the same path on this host, and no current-user `BYH Quickbooks Data` root exists. No local archive folder was created on this host.
- Wes selected the Buy Your Home Teams `Office Admin` channel as the protected primary location. On October 27, 2026, SharePoint folder creation and read-back verification succeeded at `Office Admin/QuickBooks Records Preservation`. Separate `Heritage Management LLC` and `Home Acct` trees each contain `2026-10-27 Pre-Cancellation Archive` with `Reports and Lists`, `Attachments`, and `Manifests and Verification` subfolders. The native export packages and manifests documented below are now present. A second folder on the same SharePoint site was intentionally not represented as an independent backup.

## Primary Archive Extraction Completed October 27, 2026

Heritage Management LLC has one All Dates QuickBooks export package containing General Ledger, Journal, Profit and Loss, Balance Sheet, Trial Balance, Customers, Employees and Vendors. The package is 130,054 bytes with SHA-256 `02C44EF0B2A9CADCB1874C1E3B75C6F6A6F19D12C3A52AF520D56427A84B7D4F`. All eight XLSX members opened successfully in read-only validation. The separate Attachments list displayed one item; its 36,045-byte export ZIP has SHA-256 `4FCA0337A6993C5A2AE25D771DCA2868415CC9B7CAA00ED79CD39F2BEF4AD25D` and contains one PDF.

Home Acct's first All Dates request with General Ledger and Journal exceeded QuickBooks' export size limit. The detail was therefore exported in four nonoverlapping periods: 2015-2017, 2018-2020, 2021-2023, and January 1, 2024 through October 27, 2026. A separate All Dates summary/list package contains Profit and Loss, Balance Sheet, Trial Balance, Customers, Employees and Vendors. All 14 XLSX members across the five packages opened successfully in read-only validation. The exact byte sizes, worksheet dimensions and SHA-256 values are in the Teams manifest. QuickBooks displayed 275 Home Acct attachments over six pages; all six page selections were exported as ZIPs with 50, 50, 50, 50, 50 and 25 members and uploaded to the corresponding `Attachments` folder.

Each company folder now contains a Markdown preservation manifest in `Manifests and Verification`. The manifests record company identifiers, package names, date ranges, byte sizes, SHA-256 values, worksheet dimensions, attachment counts, verification evidence and limitations. SharePoint read-back matched every uploaded file's name and byte size. The primary archive contains 2 Heritage files plus its manifest and 11 Home files plus its manifest.

This completes the native QuickBooks Export data and Attachments-list extraction into the protected primary location. It does not complete the broader preservation checklist or create a restorable QuickBooks company backup. Chart of Accounts, products/services/items, classes/locations, open A/R and A/P aging, registers, reconciliation reports, audit log, recurring templates and other settings still require separate collection or an explicitly accepted gap. Wes stated that he will provide an independent backup later. No cancellation should proceed until that backup and the remaining coverage are verified.

## Required Read-Only Extraction

For each exact company, preserve a separate dated package outside Git:

1. Company name/identifier, extraction date, earliest available transaction date, last transaction date, currency, accounting basis, and all applied filters. Cover all history, not only the current year or a default recent date range.
2. Complete General Ledger and Journal detail, by year or smaller nonoverlapping partitions when required. Include all available accounts, transaction types, classes, source identifiers, debit/credit detail, beginning balances, inactive references, and source links. Preserve original files/responses without substituting summarized entity allocations.
3. Trial Balance, Balance Sheet and P&L controls at each year-end and the extraction cutoff. Preserve the applicable cash/accrual basis explicitly; include both where needed to explain source history.
4. Open A/R and A/P detail and aging, unapplied customer/vendor credits and payments, outstanding checks/deposits, bank/credit-card registers, loans, fixed assets and equity schedules when present.
5. Account, class/location, customer, vendor, item/product/service and other relevant master lists, including inactive entries where supported.
6. Reconciliation reports, audit-log history available through the product, and material original transaction PDFs. Report the actual history exposed rather than claiming an audit log covers all company years.
7. All available attached documents, exported separately with sufficient transaction linkage to find their source. Identify unexportable or missing attachments explicitly. Preserve relevant recurring-template/settings information needed to understand historical processing, without exporting credentials or tokens.

## Storage And Verification

- Use the verified separate `Heritage Management LLC` and `Home Acct` trees under the Teams `Office Admin/QuickBooks Records Preservation` folder as the protected primary archive, with an independent backup in a separate storage location. Financial exports, attachments and databases must not be committed to the Admin wiki.
- Keep a manifest of source company, file/report/partition, period/basis/filter parameters, byte size, SHA-256 hash, extraction time, and record/control counts. A hash proves file identity, not accounting completeness.
- Open the saved files; verify date/partition coverage, transaction counts, opening/closing controls and representative transaction-to-attachment links. Explain every mismatch or missing record.
- Excel/PDF exports are a historical archive, not a guaranteed complete directly restorable QuickBooks company backup. If restoration is required, select and test a supported backup/conversion method before relying on it.
- Record a final cutoff and any later activity separately. Archived source activity is not authorization to import it into BYH; avoid counting transactions already present there twice.
- Preserve the archive manifest and cancellation confirmation, if cancellation is separately performed. Verify retained read-only access after cancellation; do not delete the Intuit login, purge company data, or request account erasure as an archive method.

## Retention Evidence Checked October 27, 2026

Intuit's current US cancellation article says a single canceled subscription normally retains read-only access for one year. It also states that customers with multiple subscriptions can retain indefinite read-only access by keeping at least one subscription under the same login. Verify the actual HM/Home/retained-company login arrangement; this product policy is not a substitute for independent archives.

- [Intuit cancellation and retention policy](https://quickbooks.intuit.com/learn-support/en-us/help-article/cancel-products-services/cancel-quickbooks-online-subscription-trial/L0MFTXlbw_US_en_US)
- [Intuit data export, including separate attachments](https://quickbooks.intuit.com/learn-support/en-us/help-article/list-management/export-reports-lists-data-quickbooks-online/L1xleDrLp_US_en_US)
- [Intuit reconciliation report export limitations](https://quickbooks.intuit.com/learn-support/en-us/help-article/export-reports/view-print-export-reconciliation-report/L1yNaVaOG_US_en_US)

## Action Boundary And Continuation

Prepared next action: collect the remaining preservation categories listed above, or record Wes's explicit acceptance of any category that QuickBooks cannot export. When Wes supplies the independent backup destination, copy and verify the completed primary packages there without another `go`. Do not substitute the combined BYH source or begin cancellation before the remaining coverage and independent copy are verified.

The handoff must explicitly prohibit subscription cancellation, financial postings, payments, deletion, data import, account/settings changes, purchases, new account creation, and credential disclosure. Stop on an actual user-only authentication challenge or uncertain target company. Return archive locations, coverage, hashes, reconciliations, and the smallest unresolved gap. Ask separately for the specific cancellation decision only after preservation/access requirements are verified.
