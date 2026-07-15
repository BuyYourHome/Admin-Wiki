# GM Mode Iteration Ledger

Purpose: preserve design intent, implementation learning, QA evidence, unresolved defects, and the exact continuation point between `gm-mode-site-iteration` runs.

Rules:

- Append new entries; do not rewrite or delete prior lessons.
- Read this ledger with the current element map before selecting work.
- Each run should own one coherent design objective and carry it through implementation and QA.
- Record both successful and failed builder paths so later runs do not repeat avoidable work.
- End with one exact next objective, not a general suggestion to keep improving the site.

## Creative Charter

Gracious Millionaire should feel like a book and author experience conceived as a whole: generous, reflective, grounded, and personal. The book cover, Wes and Jenny, authentic photography, the book's themes, and the reader journey are the primary visual and structural signals. Generic real-estate-template patterns are temporary defects, not design constraints.

Preferred direction:

- Deep charcoal, warm white, restrained evergreen, and limited brass/gold accents.
- Editorial serif headings with clean sans-serif supporting text where builder controls permit.
- Large purposeful photography rather than interchangeable stock thumbnails.
- Public architecture centered on The Book, The Story, and The Practice.
- Clear navigation such as Home, The Book, Our Story, Journal, Updates, and Contact.
- No internal production labels in public navigation.

## Known Iterations

### 2026-07-15 - Homepage imagery and book-cover placement

Objective: create the first unmistakable book-centered visual signals on the homepage.

Live changes:

- Replaced the generic homepage hero background with approved Gracious Millionaire photography.
- Placed the approved Gracious Millionaire book cover in the first homepage card.
- Replaced two generic card images with `wes-jenny-building.jpg` and `faith-notes.jpg`.

QA evidence:

- Public homepage returned HTTP 200.
- Public HTML referenced the book cover, Wes/Jenny image, and faith-notes image.
- Prior stock-card image references were absent from the public homepage HTML.

Learned paths:

- Close stale Beaver Builder tabs before beginning a new design pass.
- The authenticated Beaver Builder file chooser can upload staged web-sized local images successfully.
- Publish through `Done` then `Publish Changes`, followed by public URL and HTML verification.

Remaining defects:

- Homepage card row needs editorial rebalancing around the cover.
- First card still points to `/about/` instead of the intended current destination.
- Generic retina-logo reference remains.
- Navigation labels, shared footer/sidebar, journal/blog/category surfaces, forms, and responsive presentation remain incomplete.

Exact next objective: redesign the shared header and navigation as the site's editorial frame, including public labels, destinations, active logo/retina logo assets, desktop spacing, and mobile-menu QA.
