# Source Inventory

| Source | Type | Status | Key Data | Use |
|---|---|---:|---|---|
| Owner-provided request | Owner-provided fact | background | Subject is a double-wide manufactured home at 5021 Sunnyfield Dr, Raleigh, NC 27610; land is not included | Subject type, ownership premise, and report request |
| `sources/public-web-source-notes.md` - Redfin 27610 housing market | Public market page | background | Median sale price $329,402, down 4.5% YoY, 49 DOM | Broad ZIP context only |
| `sources/public-web-source-notes.md` - Redfin Wake County mobile homes | Public listing search page | background | 2001 Auburn Rd around $229k; 1140 Polo Dr around $285k | Active manufactured-home listing context |
| `sources/public-web-source-notes.md` - 2001 Auburn Rd Realtor.com | Public listing page | background | 2 bed, 2 bath, 922 sq ft mobile home, listed $235k | Active small mobile/manufactured listing signal |
| `sources/public-web-source-notes.md` - 1104 Deep River Ct Realtor.com | Public listing page | background | 2 bed, 2 bath, 1,216 sq ft mobile home, listed $74,900 | Leased-lot/home-only lower-bound signal |
| `sources/public-web-source-notes.md` - 4308 Pearl Rd Redfin | Public property page | background | 2 bath, 1,620 sq ft mobile/manufactured home | Product-type context, not weighted without sale price |
| `sources/public-web-source-notes.md` - 2217 Holiday Dr Redfin | Public property page | outdated | 3 bed, 2 bath, 1,971 sq ft mobile/manufactured home, sold $55,001 in 2011 | Product-type context only |
| Wake County property record for 5021 Sunnyfield Dr | Official county source | missing | Parcel, assessed value, land ownership, building details | Required before final CMA |
| MLS or COMPER manufactured-home comps | MLS/county comparable-sales source | missing | Closed sales, condition, title/land terms, concessions | Required before final CMA |
| Subject details/photos | Owner/property-file source | missing | Year, size, bed/bath, condition, title status, park/lot rent | Required before final CMA |

## Status Notes

No source in this room yet confirms the subject's size, year, condition, title status, or lot/community terms. Land is treated as not included based on Owner-provided information.
