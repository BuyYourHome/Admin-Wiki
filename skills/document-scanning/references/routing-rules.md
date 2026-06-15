# Routing Rules

Use the folder map as the routing authority. Prefer exact folder matches over fuzzy matches.

Primary routing:

- Bank statements: `2026\Bank Statement\...`
- Credit cards: `2026\Credit Cards\...`
- Lines of credit: `2026\Line of Credit\...`
- Non-property-specific loans: `2026\Loans\...`
- Mortgage statements: match the related property folder under `C:\Users\wesbr\Buy Your Home\Buy Your Home - Property`, drill into that property's `Owning` folder, then save in the folder named for the mortgage company.
- Property insurance documents from insurance companies or mortgage companies: match the related property folder under `C:\Users\wesbr\Buy Your Home\Buy Your Home - Property`, drill into that property's `Owning` folder, then save there unless a clearly matching insurance-company or mortgage-company subfolder already exists.
- Project/property invoices and receipts: match the related property folder under `C:\Users\wesbr\Buy Your Home\Buy Your Home - Property`, drill into that property's `Owning` folder, then save there unless a more specific approved subfolder already exists.
- General invoices that are not project-related: `2026\Invoices & Receipts\{Vendor}`
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

If no confident statement/account destination exists, route to `2026\_Needs Review` and log the reason.

If no confident property insurance destination or tracking status exists, route to `2026\_Needs Review` and log the reason. Keep insurance review with statement/account review unless Boss creates a separate insurance review folder later.

If no confident invoice or receipt destination exists, route to `2026\Invoices & Receipts\_Needs Review` and log the reason. Do not use the statement review folder for invoice exceptions.
