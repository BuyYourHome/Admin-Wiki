# IRS Source Path Index

Inventory completed 2026-09-11. This is the IRS room's starting point for answering source-specific questions. The index locates records; it does not establish legal ownership, tax classification, amounts, document completeness, filing acceptance, or payment status.

## Coverage

| Source area | Inventory | Detailed index |
| --- | --- | --- |
| Teams folders beginning Corp | Five root entity folders, 489 files, 43 descendant folders; SharePoint metadata | [[entity-source-index]] |
| Office Admin CPA folders | 2019-2026, 374 files; CPA roots verified in SharePoint, descendants from local sync | [[cpa-source-index]] |
| All Properties source area | 6,383 files, including five hidden files; 7,150 total descendant file/folder entries from local sync | [[property-source-index]] |
| QuickBooks | Access route: Quickbooks Invoice PR; records and company mapping not yet retrieved | [[source-inventory]] |

Detailed catalog: `C:\Users\wesbr\AppData\Local\BYH\IRS\source-index\source-path-catalog.json`.

The catalog contains 8,122 entries, including files and folders, with lookup keys, source areas, exact paths, local paths or SharePoint URLs/Graph references, observation time, and verification status. It is machine-local operational metadata outside Git. Another computer must use the SharePoint roots or rebuild its local catalog; do not assume this path exists there. Full source contents were not copied or read for this inventory.

## How To Answer A Specific Question

1. Read this guide and choose the entity, CPA year, property, or QuickBooks source area.
2. Run `Find-SourcePath.ps1` in this working folder with `-Terms` (all terms must match), optional `-Area`, or an exact `-Key` from the indexes. Examples: `-Area CPA -Terms '2024','BYH'`; `-Area Property -Terms '3325 Banks','Closing'`; `-Area Entity -Terms 'Investment Services','Operating Agreement'`.
3. Use the returned exact local path or connector Graph URL to open the source. For cloud records, use the SharePoint fetch connector; for local synced records, verify the file is available and current before reading. Search results alone support only location statements.
4. Read the relevant document before answering questions about its contents. Cite the actual source. Distinguish filename clues, extracted facts, and unresolved issues.
5. If competing copies exist, compare them and establish authority before using one. Never use a workbook marked DONT USE as the current accounting source.
6. Preserve sensitive contents in their source system. Store only minimal sanitized pointers and approved summaries in Git.
7. Record substantive verification outcomes in [[source-review-tracker]], with source key and date. Recheck current source metadata when answering later questions; this is a dated snapshot, not a live monitor. Lookup keys refer to this snapshot and must not be silently reassigned.

## Source Roots

- SharePoint site: `https://lifeisanadventure.sharepoint.com/sites/SellYourHome`.
- Document library: `Shared Documents`.
- Entity sources: the five root folders beginning `Corp`; exact paths and identifiers are in the private catalog because some folder names contain tax identifiers.
- CPA source: `Office Admin/<year>/CPA`. 2017 and 2018 year folders exist but no CPA folder was found in their SharePoint or local root listings; this is not proof that returns for those years do not exist elsewhere.
- Property source: `Property`; local sync `C:\Users\wesbr\Buy Your Home\Buy Your Home - Property`.
- All Properties channel resolved in Teams: team `Buy Your Home`, team ID `84c6d646-6a63-4acf-a328-6c8a065503d3`, channel ID `19:558bbb29b5fb45798f0e366470886c12@thread.skype`. The Properties room identifies the Property library folder as its source; direct channel-files-folder linkage was not returned by the available connector.
- Quickbooks registered task at inventory time: `01a05967-9a05-7081-a62e-616b2d8e61fd`. Recheck the current routing map before a future authorized handoff. Its documented Invoice mode does not itself establish tax-report extraction support. No handoff or bookkeeping action was performed for this inventory.

## Inventory Limits And Refresh

All descendants of the five Corp roots were listed through SharePoint without unresolved pagination. All local descendants of Property and the eight CPA folders were enumerated, including hidden entries. Local sync can lag the server; root checks do not prove every descendant is synchronized. SharePoint rate limiting caused the property and CPA descendant inventory to use the documented local fallback. No online completeness or content-verification claim is made for those descendants.

The catalog includes templates, offers, closed-property folders, marketing files, and non-tax material found within the requested roots. Inclusion does not make an item a current tax source. Additional financial records elsewhere in Office Admin are not recursively indexed by this run. Source timestamps are filesystem metadata where available, not tax-year evidence.

Refresh on an authorized inventory request or verify the relevant path during a specific question. No scheduled automation was created. Keep the private JSON catalogs outside Git. Rebuild in a new dated snapshot if replacing the catalog, and preserve referenced old lookup keys or update all referring indexes together.
