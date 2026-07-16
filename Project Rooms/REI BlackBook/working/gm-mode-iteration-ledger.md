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

### 2026-07-16 - Journal publishing and shared-sidebar cleanup

Objective: remove the off-topic Journal publishing surface through stable WordPress and theme-management routes.

Live backend changes:

- Changed all six generic template posts from published to private while preserving them in WordPress.
- Deleted `Best Tips Ever` and `Success Stories`, leaving the default `All` category.
- Removed the shared Primary Sidebar's `Recent Posts` and `Categories` widgets.

QA evidence:

- Native WordPress Posts reported `All (6)` and `Private (6)`.
- Native WordPress Categories reported one remaining category.
- Native WordPress Widgets reported no active widgets in `blog-sidebar`.
- Both public Journal hosts returned HTTP 200 but continued to serve old content with `X-Pj-Cache-Status: hit`.

Learned paths:

- REI Manage Blog toggles plus native WordPress Posts provide a reliable reversible unpublish workflow.
- Native Categories and Widgets routes are stable even when Beaver Builder is unreliable.
- The four lower Journal blocks are embedded Beaver Builder widget modules, not the shared Primary Sidebar.

Failed path and remaining defects:

- Journal Beaver Builder loaded, but confirming deletion of the stock post-grid module stalled Chrome control. No builder publish occurred.
- Public cache still exposes the six template posts, generic lower modules, a broken profile placeholder, and public contact/address details.
- Public contact/address removal or alteration requires Wes's specific approval under the heartbeat boundary.

Exact next objective: verify Journal cache propagation read-only; if stale content remains, avoid the known hanging cache-clear and builder-delete paths and complete a Request Updates form-presentation pass that does not alter workflows, recipients, outbound behavior, or public contact details.

### 2026-07-16 - Request Updates presentation

Objective: clarify the Request Updates reader experience without altering form workflows or public contact details.

Live changes:

- Changed the page heading from `Contact Wes and Jenny` to `Request Book Updates`.
- Replaced the generic follow-up sentence with `Request future Gracious Millionaire book updates. Name and email are required; phone is optional.`

QA evidence:

- Both public hosts returned HTTP 200 with the new heading and introduction.
- The old `Contact Wes and Jenny` heading was absent.
- Mobile QA at 390 x 844 showed no horizontal overflow and retained the expected fields.
- No form was submitted.

Learned paths:

- Request Updates text modules are stable in Beaver Builder.
- Surrounding text modules can be edited safely without entering the InsiteForms module or changing workflow behavior.
- Module Save, Builder Done, and Publish Changes propagated immediately to both hosts.

Remaining defects:

- The embedded map creates a large blank mobile gap before the form column.
- The page and its lower contact module expose public contact/address details; changing them requires Wes's specific approval.
- Journal still serves stale cached template content.
- The homepage cover card still points to `/about/` rather than `/about-2/`.

Exact next objective: correct the homepage book-cover card destination and CTA through the proven homepage builder path, rebalance the same card if stable, and QA both hosts at desktop and mobile sizes without retrying The Book or Journal deletion paths.

### 2026-07-16 - Homepage book-card destination and CTA

Objective: make the homepage book card lead clearly and reliably to the live book page.

Live changes:

- Changed the `About the Book` callout destination from `/about/` to `/about-2/`.
- Replaced the generic `Read More` CTA with `Explore the Book`.
- Kept the card image, heading, and CTA on the same corrected destination.

QA evidence:

- Both homepages and both `/about-2/` destinations returned HTTP 200.
- Both homepage HTML responses contained `Explore the Book` and the corrected `/about-2/` destination; the old card destination was absent.
- Mobile QA at 390 x 844 confirmed the card heading, CTA, destination, and no horizontal overflow on either host.

Learned paths:

- The homepage callout module remains stable in Beaver Builder.
- Destination and CTA text are edited together in the callout module's `Call To Action` tab.
- Module Save, Builder Done, and Publish Changes propagated immediately to both hosts.

Remaining defects:

- Book Outline and Request Updates homepage cards still use generic `Read More` labels.
- The Book builder remains blank and its stock circle, broken profile placeholder, and missing in-page cover remain.
- Journal public HTML remains stale behind the REI page cache.
- Request Updates map/contact presentation remains approval-bound.

Exact next objective: replace the remaining homepage `Read More` labels with specific reader-facing CTAs, verify each card destination, and QA the full card sequence on both hosts at desktop and mobile sizes without retrying The Book or Journal deletion paths.
