# Home Acct Supplemental Preservation Manifest

## Identity And Storage

- QuickBooks company: `Home Acct`
- Company ID: `1362476170`
- Authenticated Intuit identity: Wes / `WesWill@BuyYourHomeLLC.com`
- Extraction cutoff: October 27, 2026
- Report basis: cash where the report exposed an accounting-basis control
- Primary storage: `Office Admin/QuickBooks Records Preservation/Home Acct/2026-10-27 Pre-Cancellation Archive`

The exact downloaded supplemental source bytes are preserved together in `Reports and Lists/Home Acct Supplemental Preservation 2026-10-27.zip`. The ZIP is 3,231,742 bytes, contains 16 entries totaling 7,684,452 uncompressed bytes, and has SHA-256 `1741A3456B0713A9DC6AD09C6AB25657953826AA6D94FA820490B574B4144570`. SharePoint folder read-back matched the ZIP name and byte size. The individually uploaded Excel workbooks are convenient viewing copies; SharePoint normalized their stored workbook sizes, so the ZIP and the source hashes below are the exact-byte controls.

## Supplemental Files

| Source artifact | Source bytes | Readability/control | SHA-256 |
| --- | ---: | --- | --- |
| Chart of Accounts CSV | 19,246 | 316 CSV data rows | `7CC75EAA428FE5D02C69690F324385979026D10D4B58CF2098D2AB1886030F12` |
| Class List CSV | 807 | 49 CSV data rows, including report-layout rows; live UI showed 40 classes | `B6F0A513B8BC3D08C4CA05F2AAE9EC94B155370D2A6D08EFF3D61C8746339D6E` |
| Recurring Transactions PDF | 178,950 | three readable pages | `C140EF4EFA50BFB89A7459A2E807E852602788C530CEF31F987096A2F413C4EF` |
| Audit Log, All Events, 2019-10-28 through 2019-12-31 | 452,050 | 3,278 CSV rows | `BB86DDE57F6835925377B8079FF15CF139CCE16607D6E642118D06AABA558225` |
| Audit Log, All Events, January 2020 | 328,077 | 2,608 CSV rows | `BDB3CFB4F1B0EC32ED522AC7DC852B9F6D09CF9EBA010B6BB802865A38BF21D7` |
| Audit Log, All Transactions, 2020 | 1,074,623 | 9,649 CSV rows | `FC18DCE41A22A4650E5B80B33BEC243CBFF8A04AC575E5D6DEAD2DC397481741` |
| Audit Log, All Transactions, 2021 H1 | 534,823 | 4,688 CSV rows | `0B127969A4A479D1DE44E6DAC0E4355D74D3DE8591D4694BC7F80220E30CD9DD` |
| Audit Log, All Transactions, 2021 H2 | 801,987 | 6,895 CSV rows | `6AE2EC72B46469B440714B7A1C595F21D0D1CC65384851642260367B9CF47BAF` |
| Audit Log, All Transactions, 2022 | 986,289 | 8,144 CSV rows | `FD3D45F7E07F115D90D3579046C2CDAB02575D2F41D5AC2AA4947231184D341D` |
| Audit Log, All Transactions, 2023 | 100,290 | 887 CSV rows | `284C159168514627963194C3E2724703E46E89DB1C139C77A68086EEE14CCFD4` |
| Audit Log, All Transactions, 2024 | 49,078 | 434 CSV rows | `704AD13AC91CF3600344BA366F5978356D0CBA6F4F0314E2EBBEF0A278F69DED` |
| Audit Log, All Transactions, 2025 | 41,341 | 368 CSV rows | `7B7675C85469724D8A15DAA7F028E3F79CB3F0135CC61CE88E34002C9607D9A8` |
| Audit Log, All Transactions, 2026-01-01 through 2026-10-27 | 32,335 | 304 CSV rows | `0B477266495DEBEC2782D44605E9AB05A484ECE60F7A8866A9F954D3BFE4D6BC` |
| A/R Aging Detail as of 2026-10-27 | 9,022 | readable XLSX, 18 rows by 8 columns | `DBEB66E76AEE3EEEC159256B0F21763D26991491AB11FC946B989D68F87709C0` |
| A/P Aging Detail as of 2026-10-27 | 100,912 | readable XLSX, 2,166 rows by 9 columns | `41D48EDE80146BAFB2B34BA2A9D75ED41C311E28F0E9EA0C163C9D588B94B373` |
| Transaction Detail by Account, All Dates | 2,974,622 | readable XLSX, 52,469 rows by 10 columns | `83B39A84C83B80CF9F5636C68580EE66B7ED0AF620EAB216266B96A5F755C19A` |

Products and Services was empty in the live company. The Classes and Locations screen showed 40 classes and zero locations. The Chart of Accounts export contains 21 bank-type and 11 credit-card-type rows.

## Coverage Limits And Stop Gate

- QuickBooks exposed audit history only from October 28, 2019 through the cutoff. The financial `All Transactions` view was partitioned so every exported period remained below the product's row limit. The broader `All Events` view exceeded the product limit after January 2020, so non-transaction banking/system events from February 2020 onward were not exhaustively exported. The transaction audit files preserve the financial-event lifecycle, not every automated banking/system event.
- QuickBooks reconciliation history is account-by-account and provides no bulk company export. Thirty-two bank/credit-card account rows exist in the Chart of Accounts export. Individual reconciliation reports were not exhaustively exported. The All Dates Transaction Detail by Account workbook preserves account/register activity but is not a substitute for reconciliation reports.
- Currency was not separately certified from a company-settings export.
- These exports, PDFs, CSVs, attachments and manifests are historical records. They are not a guaranteed directly restorable QuickBooks company backup.
- Wes will provide the independent backup later. Until it is supplied and verified, the preservation gate remains open and subscription cancellation remains blocked.

No QuickBooks record, setting, payment, subscription or company data was changed during this extraction.
