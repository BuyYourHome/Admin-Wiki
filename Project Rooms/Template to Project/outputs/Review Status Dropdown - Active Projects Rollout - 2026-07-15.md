# Review Status Dropdown - Active Projects Rollout

Date: 2026-07-15

## Scope

Applied the approved Review design to every approved active project workbook after the Outrigger pilot:

- Added `Import Date` immediately before the existing invoice-date column in `tblInvoiceReview`.
- Applied the approved eight-value dropdown to every Status data cell.
- Preserved formulas, existing table data, formatting, request checkbox, `invoiceEntryReviewRequest`, workbook names, links, calculation mode, and iteration settings.
- Left historical Import Date cells blank when the actual processing date was unknown.
- Kept Review rows as audit records.

Excluded and inactive projects were not changed.

## Teams Replacements

| Project | Review range | Legacy mapping | Teams SHA-256 |
| --- | --- | --- | --- |
| Outrigger | `A4:P22` | 13 `Moved` to `Posted`; 3 legacy Needs Review variants normalized | `A8217E759738416CE2E65381E9089E3CDF1A638AAF43320CF1649AFFF328CEC4` |
| Rose | `A4:P16` | 11 legacy Needs Review variants normalized | `4BA05D72097C9836CCDED84262856E4C70122F2B44EAA4693DE80E95B0BD9C2E` |
| Pond | `A4:P16` | 2 legacy Needs Review variants normalized | `E31E4D22384FFF3087B4CEC39F77789C5A258EB4333ECAD58D9756C512E921AA` |
| Banks | `A4:P19` | None required | `58E9B37423BB9297D629B650D0872E9ADBA660DEC6A0B9FC022CBE33719E0325` |
| Pinetree | `A4:P19` | None required | `9D1DB38DD9AD9364B9D0A90F0F8F0FD8D02E3EB05A14EC6D9093186F80CD33D8` |
| Pleasant Garden | `A4:P19` | None required | `9E71215926C24494E2BE6A004F274DB14EB433FC044765853CD2658B48EFFA92` |
| Rosebrooks | `A4:P19` | None required | `891907D8DBFBB0496C8BCF82AB7A2169560958EB45DC50B54FB17271BFFCA905` |
| Cool Springs | `A4:P19` | None required | `47DA9C7CEA3244CC4327E3C7883A3D3226F273A7D1C600DC643D27D52BC02484` |
| Tensity | `A4:P19` | None required | `81C18B543F04E962F97AED6E74AC9C0829AB01D11B3E2002E635D7ECABE55D41` |
| Britton | `A4:P18` | None required | `2E2EC0153C53A428739B0A0FD11928A59952F574DB087DBC0C0978319428B965` |

Each listed hash matched the exact workbook downloaded from Teams after replacement.

## Final Validation

All ten active workbooks passed:

- `Import Date` is immediately before the invoice-date column.
- Status validation covers every table data row.
- Status validation uses exactly the eight approved values.
- Invalid Status values: `0`.
- Remaining legacy `Moved` values: `0`.
- `invoiceEntryReviewRequest` refers absolutely to `=Review!$B$1`.
- Native Review request checkbox control is preserved.
- External workbook links: `0`.
- Calculation mode: Automatic.
- Iterative calculation settings preserved.
- Formula count and formula-error address set unchanged from each fresh Teams baseline.
- Visual Review-sheet render completed for every workbook.

## Teams Links

- [Outrigger](https://lifeisanadventure.sharepoint.com/sites/SellYourHome/_layouts/15/Doc.aspx?sourcedoc=%7BBAFDD468-E840-4D85-9AE4-FC5C59512E62%7D&file=27_Project%20Management%20-%207001%20Outrigger%20Dr.xlsm&action=default&mobileredirect=true)
- [Rose](https://lifeisanadventure.sharepoint.com/sites/SellYourHome/_layouts/15/Doc.aspx?sourcedoc=%7BD39E03A5-035A-4BBF-9346-ADD40A7758EE%7D&file=28_Project%20Management%20-%20320%20Rose%20Pl.xlsm&action=default&mobileredirect=true)
- [Pond](https://lifeisanadventure.sharepoint.com/sites/SellYourHome/_layouts/15/Doc.aspx?sourcedoc=%7BD8E3E437-A104-4D18-A8C2-79698ECCD735%7D&file=26_Project%20Management%20-%20908%20Pond%20St%203.xlsm&action=default&mobileredirect=true)
- [Banks](https://lifeisanadventure.sharepoint.com/sites/SellYourHome/_layouts/15/Doc.aspx?sourcedoc=%7B1285A8AD-93C4-4909-91D7-A1496C5E5E6A%7D&file=07_Project%20Management%20-%203325%20Banks%20Rd.xlsm&action=default&mobileredirect=true)
- [Pinetree](https://lifeisanadventure.sharepoint.com/sites/SellYourHome/_layouts/15/Doc.aspx?sourcedoc=%7B82D7F937-5C3A-4823-B955-C8B6596AB856%7D&file=17_Project%20Management%20-%203413%20Pinetree%20Ln.xlsm&action=default&mobileredirect=true)
- [Pleasant Garden](https://lifeisanadventure.sharepoint.com/sites/SellYourHome/_layouts/15/Doc.aspx?sourcedoc=%7BA9A3AF5E-0546-4309-ABAF-512560A2A438%7D&file=18_Project%20Management%20-%201426%20Pleasant%20Garden%20Ln.xlsm&action=default&mobileredirect=true)
- [Rosebrooks](https://lifeisanadventure.sharepoint.com/sites/SellYourHome/_layouts/15/Doc.aspx?sourcedoc=%7B5EC3294D-9743-47F7-8692-B607638A1E26%7D&file=20_Project%20Management%20-%20115%20Rosebrooks%20Dr.xlsm&action=default&mobileredirect=true)
- [Cool Springs](https://lifeisanadventure.sharepoint.com/sites/SellYourHome/_layouts/15/Doc.aspx?sourcedoc=%7B13A9AC8D-8615-43BB-9A39-8B80452AF194%7D&file=22_Project%20Management%20-%202325%20Cool%20Springs%20Rd%204.xlsm&action=default&mobileredirect=true)
- [Tensity](https://lifeisanadventure.sharepoint.com/sites/SellYourHome/_layouts/15/Doc.aspx?sourcedoc=%7BFB8825B0-06EF-4B3E-8015-A106EEEA5C7C%7D&file=24_Project%20Management%20-%204121%20Tensity%20Dr%202.xlsm&action=default&mobileredirect=true)
- [Britton](https://lifeisanadventure.sharepoint.com/sites/SellYourHome/_layouts/15/Doc.aspx?sourcedoc=%7BF62181DD-9C77-480C-BA49-0076362AAD44%7D&file=25_Project%20Management%20-%20612%20Britton%20Ct.xlsm&action=default&mobileredirect=true)
