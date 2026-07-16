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

### 2026-07-15/16 - Shared editorial navigation

Objective: replace production-style navigation labels with a concise reader-facing sequence and verify responsive behavior.

Live changes:

- Renamed and reordered the shared WordPress menu to `Home`, `The Book`, `Themes`, `Journal`, `Updates`.
- Preserved the existing destinations and assignments to Top Bar, Header, and Footer.

QA evidence:

- REI preview served all five labels in the intended order.
- Desktop preview at 1280px had no horizontal overflow.
- Mobile preview at 390x844 displayed the menu toggle, collapsed the navigation, and had no horizontal overflow.
- Public custom domain continued to serve the prior menu from cache.

Learned paths:

- Use the direct WordPress menu editor for shared labels, ordering, destinations, and location assignments; do not use Beaver Builder for this work.
- Treat REI preview and custom-domain cache as separate QA targets after shared changes.
- The visible header logo and the retina-logo reference are separate theme settings.

Failed paths and remaining defects:

- REI `Clear Website Cache` opened a confirmation that hung the Chrome control session, so public propagation was not completed.
- The basic theme editor did not expose the stale `data-retina` asset; the advanced header customizer remains necessary.
- Generic footer/sidebar/blog/category content and form presentation remain unfinished.

Exact next objective: redesign `The Book` page around the approved book cover with a cover-led first viewport, book-focused copy and links, and desktop/mobile QA without publishing manuscript chapter text.

### 2026-07-16 - The Book editing-path investigation and footer audit

Objective: redesign The Book around the approved cover and remove its remaining generic imagery.

Public findings:

- Both hosts now serve the intended `Home`, `The Book`, `Themes`, `Journal`, `Updates` navigation; the earlier custom-domain cache lag has cleared.
- The Book still contains the generic `WebStockGen1200054-300x200-circle.jpg` image and a broken `https://[profile_image_url]` placeholder, and it does not display the approved cover.
- The active public footer is already `Copyright 2026 Gracious Millionaire. All rights reserved.`

Attempted change and QA:

- Advanced Theme Customizer saved `Gracious Millionaire | A book by Wes and Jenny Browning.` in Footer Layout, but neither public host rendered it. The managed theme is overriding that stored setting, so this was not counted as a public-visible redesign.

Learned paths:

- Keyboard input plus blur is required to trigger Customizer dirty state when direct field replacement leaves `Save & Publish` disabled.
- Treat Customizer save confirmation and public output as separate checks.
- The authenticated REI control panel and Advanced Theme Customizer can remain stable while content-editor routes fail.

Failed paths and remaining defects:

- Beaver Builder for `/about-2/?fl_builder` timed out after 30 seconds.
- Direct WordPress post editor for page ID `1765` timed out after 30 seconds.
- REI Manage Pages loaded without populating its page list.
- The Book stock circle, broken profile placeholder, missing cover, generic retina asset, and generic Journal/sidebar content remain.

Exact next objective: reset the Chrome editing environment, make one clean attempt to edit page ID `1765`, and complete the cover-led The Book redesign with attachment `6319`; if that clean attempt fails, switch to the stable retina-logo or Journal/sidebar objective instead of repeating the timeout.

### 2026-07-16 - Shared retina-logo correction

Objective: make one clean The Book editor attempt, then complete a stable global correction if the editor remained unavailable.

Live change:

- Removed the obsolete REI generic retina-logo image from Advanced Theme Customizer > Header > Header Logo while retaining the approved regular Gracious Millionaire logo.

QA evidence:

- Both public hosts returned HTTP 200.
- Both hosts rendered `gracious-millionaire-logo-header-2026-07-09.png` with `data-retina=""`.
- `generic-logo-2-retina.png` was absent from both public HTML responses.

Learned paths:

- The Advanced Theme Customizer is a stable route for shared header settings even while Beaver Builder is unavailable.
- Remove the second Header Logo `Remove` control, which belongs to the Retina field; do not remove the Regular image.
- Verify shared asset changes against both hosts after `Save & Publish` reports `Saved`.

Failed path and remaining defects:

- A clean-tab retry of `/about-2/?fl_builder` still returned an empty editor, confirming the Book blocker persists beyond stale-tab cleanup.
- The Book stock circle, broken profile placeholder, and missing cover remain.
- Generic Journal posts, categories, and sidebar/About widgets remain.

Exact next objective: clean the Journal/blog/sidebar experience through stable WordPress or theme-management routes, publish one coherent reader-facing pass, and QA both hosts without retrying The Book builder unless Chrome has been reset or editor stability is demonstrated.
