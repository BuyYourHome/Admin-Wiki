# Gracious Millionaire Element Map 032

Created 2026-07-17 after the plural Books-page presentation pass.

## Live Changes

- Changed the page H1 from `About Gracious Millionaire` to `Books by Wes and Jenny Browning`.
- Replaced the three generic feature headings with distinct manuscript H2 entries:
  - `Gracious Millionaire`
  - `Gracious Millionaire - Drawn by Grace`
  - `The L.D. Evans Story`
- Replaced the buried related-manuscript paragraph with a direct introduction stating that three manuscript projects are in development and that unfinished chapter content remains private.
- Reused the existing stable three-column callout modules; no row, column, navigation, form, or workflow structure was changed.

## QA

- Both `https://www.graciousmillionaire.com/about-2/` and `https://u113450.h.reiblackbook.com/generic6/about-2/` return HTTPS HTTP 200.
- Both hosts render exactly one H1, `Books by Wes and Jenny Browning`.
- Both hosts render all three manuscript names as H2 headings rather than only inside paragraph copy.
- Desktop visual QA shows all three entries in the first main content viewport with clean wrapping and no overlap.
- Both hosts report no horizontal overflow at the verified 1905-pixel browser width.
- Neither host contains `working title` or the hidden street-address string on the Books page.
- No manuscript chapter content was published.

## Remaining Work

- The three manuscript entries still use the template's inherited clock, award, and puzzle icons. These are visible but not book-specific.
- Dedicated cover art or approved descriptive imagery is not yet available for the two related manuscripts.
- True mobile QA remains pending because the prior Chrome viewport override did not change the actual browser width.
- The Updates row still has excess desktop whitespace, hidden address residue in public HTML, and a blocked structural-delete path.

## Exact Next Objective

Use a stable callout/icon path to replace the inherited generic manuscript icons with book-appropriate symbols, or complete confirmed-width mobile QA if a reliable narrow viewport becomes available. Do not retry the Updates structural row/column path until Beaver Builder can publish structural actions reliably.
