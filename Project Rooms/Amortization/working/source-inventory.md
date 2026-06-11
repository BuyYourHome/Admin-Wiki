# Source Inventory

| Source | Location | Status | Notes |
| --- | --- | --- | --- |
| Project spreadsheet | TBD | missing | Future skill should read this spreadsheet. Need path, file format, and whether it is copied into `sources/` or referenced in place. |
| Worksheet referred to as `amateurization` | Project spreadsheet | missing | Need exact worksheet name and whether spelling is intentional in the spreadsheet. |
| Amortization skill source | `skills/amortization/SKILL.md` | authoritative | Reusable skill rules for Amortization-owned chart generation. |
| Amortization generator script | `Project Rooms/Amortization/scripts/New-AmortizationChart.ps1` | authoritative | Callable generator used by CFD and other workflows. |
| Buyer-facing amortization chart template | `Project Rooms/Amortization/templates/Buyer-Facing Amortization Chart Template.xlsx` | authoritative | Layout source for generated buyer-facing amortization chart workbooks and PDFs. |
| 320 Rose generated PDF test | `Project Rooms/Amortization/outputs/320 Rose Pl/320 Rose Pl - 12 Month Amortization Chart.pdf` | background | Successful generator test output from the 320 Rose project spreadsheet. |
| Known-good amortization example | TBD | missing | Needed to validate the generated 12-month chart. |

## Status Terms

- `authoritative` - use this as a source of truth.
- `background` - useful context, but do not treat as controlling.
- `duplicate` - overlaps another source and should not be independently blended.
- `outdated` - superseded by newer information.
- `unclear` - may matter, but needs human review before use.
- `missing` - needed but not yet provided.
