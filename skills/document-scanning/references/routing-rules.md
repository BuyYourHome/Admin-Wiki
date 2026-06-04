# Routing Rules

Use the folder map as the routing authority. Prefer exact folder matches over fuzzy matches.

Primary routing:

- Bank statements: `2026\Bank Statement\...`
- Credit cards: `2026\Credit Cards\...`
- Lines of credit: `2026\Line of Credit\...`
- Loans and mortgages: `2026\Loans\...`
- Quest invoices: `2026\Quest\Invoices\...`
- Quest receipts: `2026\Quest\Receipts\...`
- General receipts: `2026\Receipts`
- CPA forms: `2026\CPA\...`
- Tax/property tax documents: `2026\Taxes` or `2026\Tax-Properties`
- Donations: `2026\Donations`
- Medical: `2026\Medical`

Match using:

- Last 4 account digits in the destination folder name.
- Institution/vendor name in the destination folder name.
- Business/entity terms such as BYH, SYH, Heritage Mgmt, Hollinger Investments, personal/home, or 401K.

If no confident destination exists, route to `_Needs Review` and log the reason.
