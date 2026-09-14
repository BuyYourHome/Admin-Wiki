# IRS Source Review Tracker

Snapshot: 2026-09-11. Statuses: located, metadata indexed, contents reviewed, authority verified, unresolved, superseded. Tax filing status remains in [[tax-filing-status]] and must be supported by direct evidence.

| Source or issue | Status | Evidence / next action |
| --- | --- | --- |
| Five Corp entity source roots | metadata indexed | [[entity-source-index]]; contents, complete taxpayer population, ownership and tax classifications need review. |
| CPA folders 2019-2026 | metadata indexed | [[cpa-source-index]]; determine actual document tax years and filing acceptance from contents. |
| CPA folders 2017-2018 | unresolved | No CPA folder in year-root listings; prior-return coverage outside indexed roots remains unverified. |
| Property folders and workbooks | metadata indexed | [[property-source-index]]; root folder labels do not establish ownership or current workbook authority. |
| Multiple DONT USE workbook variants | unresolved | Locate by that phrase; select authoritative current workbook from owning workflow before analysis. |
| 585 repeated file-name groups | unresolved | Private `duplicate-name-candidates.json` beside catalog contains lookup keys. These are name matches, not proven duplicate contents. |
| Multiple operating-agreement versions | unresolved | Entity index provides document keys; check executed/approved status and governing effective date. |
| Form 2553 filename in BYH source | located | File existence does not prove IRS acceptance or effective tax classification. |
| All Properties channel versus Property folder | source mapping supported; direct link unverified | Exact Teams channel resolved; existing Properties source inventory and SharePoint folder verified. |
| QuickBooks reports and entity mappings | unresolved | Access route documented; no reports retrieved or handoff sent. |
| Local sync completeness | unresolved | Property and CPA descendants enumerated locally after SharePoint throttling; recheck source availability/current version before relying on contents. |

For later substantive source review, add source key, review date, exact supported finding, and remaining issue. Do not mark filed, accepted, paid, or closed based on filenames or this inventory.

## Substantive Review - 2026-09-12

See [[../outputs/2025-return-checklist-and-gaps|2025 return checklist and gaps]] for source keys, scope limits, supported findings and questions. This supersedes the earlier metadata-only status for the selected records below.

| Sources | Review | Remaining issue |
| --- | --- | --- |
| T08000, T08001 | BYH 2024 return schedules and IRS S-election acceptance examined; letter visually verified. | 2025 filing evidence and basis reconciliation. |
| T08006 | SYH 2024 return and retirement-account K-1 ownership examined. | 2025 custodian, allocation and income review. |
| T08003 | Joint 2024 return and selected carryforward/basis schedules examined. | Resolve basis worksheet differences before carryforward. |
| T08099 | Providence 2025 initial/final return and K-1s examined; initial/final boxes visually verified. | Acceptance, actual closure and loan/loss treatment. |
| T08104-T08106 | BYH NC extension cover/voucher and 2025 BS/P&L examined. | Federal/state extension and payment proof; unresolved ledger categories. |
| T07958, T08109, T08111 | Plan adoption first page visually examined and 2025 accounting reports reviewed. | Full plan document, account/entity mapping, valuation and related-party loan review. |
| E00038, E00031, E00149, E00103 | Selected OA text examined. | Executed status, conflicting text, 2025 effective ownership/custodian evidence. |
| T08107-T08108, T08110, T08113-T08116 | Located accounting workbooks. | Contents and ledger reconciliation not yet completed. |

No 2025 return marked accepted or paid. No full property or workbook reconciliation completed.

## Providence Legal Review - 2026-09-13

E00422, E00432 and E00436 reviewed for hierarchy, member identity and conditional vesting. Management is named general partner/equity holder above LLLP; sole ownership and executed percentages not established. Two subsidiary names appear as unverified candidates. See [[../sources/2026-09-13-providence-hierarchy-review]].

## Trust Ownership Correction - 2026-09-13

Wes says Browning Family Revocable Trust owns Heritage Management LLC. Current owner-confirmed mapping is trust -> Heritage, with 2025 effective date/percentage unverified. E00038 instead names BYH and must be reconciled with signed assignment/current authority. Heritage transactions being in BYH books is accounting-location evidence only; do not automatically include them on BYH's tax return. The signed 16-page trust PDF has now been visually read; revocation rights support preliminary grantor treatment, but reporting method and 2025 facts remain to verify. See [[../sources/2026-09-13-family-trust-review]].

## Trust Filing History And EIN Search - 2026-09-13

Wes confirms no prior trust Form 1041 filing and believes no trust EIN exists. Teams cloud folder listings and targeted searches found no EIN/SS-4 record; status is EIN not located, not confirmed absent. A signed July 13, 2023 assignment of 100% BYH membership to the family trust was also found and visually reviewed, requiring legal/tax shareholder reconciliation. See [[../sources/2026-09-13-trust-ein-search]] for paths, scope and evidence limits. Do not ask again about prior 1041 history.

## Solo Plan Documents Located - 2026-09-14

Wes identified Corp-BYH 401K LLC in Teams. Verified in the separate SellYourHome-Solo401K SharePoint site. Root and both subfolders inventoried: 24 files total. Signed plan package, certificate of trust, EIN records, successor-administrator records and nested LLC formation documents located. Selected adoption text confirms Buy Your Home Retirement Plan Trust, employer BYH, plan 001, effective October 17, 2024. Full document/signature and annual reporting review remains pending. Stop asking Wes to supply the already-located plan package; see [[../sources/2026-09-14-solo-plan-source-index]] for exact links and remaining checks. The earlier main-site inventory did not include this separate site.
