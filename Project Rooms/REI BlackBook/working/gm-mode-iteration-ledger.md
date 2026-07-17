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

### 2026-07-16 - Homepage card sequence

Objective: replace the remaining generic homepage card actions and verify each card's semantic destination.

Live changes:

- Changed the `Book Outline` CTA from `Read More` to `View the Outline`.
- Corrected the Book Outline image, title, and CTA destination from `/services/` to `/book-outline/`.
- Changed the `Request Updates` CTA from `Read More` to `Request Updates` while retaining `/contact/`.

QA evidence:

- Both homepages and both `/book-outline/` destinations returned HTTP 200.
- Both homepage responses contained the three reader-facing callout labels and no generic callout `Read More` label.
- The obsolete Book Outline card destination to `/services/` was absent.
- Mobile QA at 390 x 844 confirmed all three labels and destinations with no horizontal overflow on either host.

Learned paths:

- The three homepage callout modules remain stable in Beaver Builder.
- A live destination can still be semantically wrong; compare every card purpose with the canonical page path during QA.
- Module Save, Builder Done, and Publish Changes propagated immediately to both hosts.

Remaining defects:

- The homepage lower invitation still uses the generic `Contact Us` button label, though its `/contact/` destination is correct.
- The Book builder remains blank and its stock circle, broken profile placeholder, and missing in-page cover remain.
- Journal public HTML remains stale behind the REI page cache.
- Request Updates map/contact presentation remains approval-bound.

Exact next objective: replace the homepage lower `Contact Us` button with `Request Book Updates`, retain `/contact/`, and QA the complete homepage command hierarchy on both hosts at desktop and mobile sizes without retrying The Book or Journal deletion paths.

### 2026-07-16 - Homepage lower CTA and confirmation propagation

Objective: finish the homepage command hierarchy, then audit confirmation-page command language without entering form settings.

Live changes:

- Changed the homepage lower CTA from `Contact Us` to `Request Book Updates` while retaining `/contact/`.
- Published the confirmation page's already-saved book-focused `About the Book` block, replacing stale public multi-service placeholder copy.

QA evidence:

- Both homepages returned HTTP 200 with `Request Book Updates`, the correct `/contact/` destination, and no lower `Contact Us` button.
- Both confirmation pages returned HTTP 200 with the book-focused About block and without the placeholder multi-service language.
- Mobile QA at 390 x 844 showed no horizontal overflow on any affected page.

Learned paths:

- Homepage CTA button text and destination are isolated in the CTA module's `Button` tab.
- The confirmation builder contained the desired saved About state even while public output was stale.
- Publishing the current page state can propagate a saved module change without re-editing it.

Remaining defects:

- The confirmation page still exposes the embedded `Categories` block and default `All` link.
- Its contact module still exposes public address, phone, email, and a broken `[profile_image_url]` reference; those changes remain approval-bound.
- The Book builder remains blocked and Journal public HTML remains stale.

Exact next objective: remove the confirmation page's embedded Categories module through the stable builder path, leave the adjacent contact module untouched, and QA both hosts at desktop and mobile sizes without retrying The Book or Journal deletion paths.

### 2026-07-16 - Confirmation Categories cleanup

Objective: remove the confirmation page's empty/default Categories output without touching its adjacent contact module.

Live change:

- Set the Categories widget module's Advanced visibility to `Never` and published the page.

QA evidence:

- Both confirmation-page hosts returned HTTP 200 with no Categories heading, `/category/posts/` link, or Categories module node.
- The book-focused About block remained live.
- The adjacent contact module remained present and unchanged.
- Mobile QA at 390 x 844 showed no Categories output and no horizontal overflow on either host.

Learned paths:

- Advanced visibility `Never` is a reversible alternative to module deletion for isolated generic output.
- Avoiding the deletion-confirmation path prevents repetition of the Journal builder stall.
- Verify absence by heading, link, and module node after publishing.

Remaining defects:

- Book Themes still exposes an embedded Categories block, adjacent contact content, and a broken profile reference.
- The Book builder remains blocked and Journal public HTML remains stale.
- Public contact details and profile-reference changes remain approval-bound.

Exact next objective: hide only the Book Themes Categories module through its stable builder path, leave the adjacent contact module untouched, and QA both hosts at desktop and mobile sizes without retrying The Book or Journal deletion paths.

### 2026-07-16 - Book Themes Categories cleanup

Objective: remove the Book Themes empty/default Categories output without touching its adjacent contact module.

Live change:

- Set the Book Themes Categories widget module's Advanced visibility to `Never` and published the page.

QA evidence:

- Both Book Themes hosts returned HTTP 200 with no Categories heading, default category link, or Categories module node.
- The book-focused About block remained live.
- The adjacent contact module remained present and unchanged.
- Mobile QA at 390 x 844 showed no Categories output and no horizontal overflow on either host.

Learned paths:

- The reversible visibility path works consistently across separate Beaver Builder pages.
- Checking the adjacent module node provides a narrow verification that out-of-scope contact content was preserved.

Remaining defects:

- Request Updates still exposes the same Categories/default-All block.
- Its map, contact content, broken profile reference, and form workflow remain approval-bound.
- The Book builder remains blocked and Journal public HTML remains stale.

Exact next objective: hide only the Request Updates Categories module through its stable builder path, leave the form, map, and contact module untouched, and QA both hosts at desktop and mobile sizes without retrying The Book or Journal deletion paths.

### 2026-07-16 - Request Updates Categories cleanup

Objective: remove the Request Updates empty/default Categories output without touching its form, map, or adjacent contact module.

Live change:

- Set the Request Updates Categories widget module's Advanced visibility to `Never` and published the page.

QA evidence:

- Both Request Updates hosts returned HTTP 200 with no Categories heading, default category link, or Categories module node.
- The book-focused About block, InsiteForm, embedded map, and adjacent contact module remained present and unchanged.
- Mobile QA at 375 px showed no Categories output and no horizontal overflow on either host.

Learned paths:

- The reversible visibility path works consistently across three separate Beaver Builder pages.
- Checking the form, map, and contact nodes provides a narrow verification that out-of-scope functionality and public details were preserved.

Remaining defects:

- Request Updates still contains an embedded map, public contact content, and a broken profile reference; those changes remain approval-bound.
- The Book builder remains blocked and Journal public HTML remains stale.
- The remaining stable pages need a cohesive site-wide generic-module and visual-spacing audit.

Exact next objective: audit the stable Home, Book Outline, Chapter status, Book Themes, Request Updates, and confirmation surfaces as one reader journey; remove any remaining non-contact generic modules and complete a cohesive typography/spacing refinement on the highest-impact stable page without retrying The Book or Journal blocked paths.

### 2026-07-16 - Book Outline and chapter-status reader journey

Objective: make the stable outline/status path feel intentionally book-centered while preserving the working chapter structure and keeping manuscript content private.

Live changes:

- Placed the approved full-resolution book cover at the top of the Book Outline at 320 by 480 pixels with descriptive alt text.
- Removed the duplicate body H1 from the Book Outline and added a `Working chapter list` H2.
- Preserved all 25 working chapter links and the update-request link.
- Removed the duplicate body H1 from the shared chapter-status page and strengthened the visual emphasis of its status and return link.

QA evidence:

- Both outline hosts show exactly one H1, the cover, the `Working chapter list` H2, and all 25 chapter links.
- Both chapter-status hosts show exactly one H1 and a working return link to the outline.
- The cover loads from the approved full-resolution 1024 by 1536 asset, renders at 320 by 480, and has descriptive alt text.
- Categories output remains absent and desktop QA found no horizontal overflow.

Learned paths:

- Standard WordPress pages can be edited reliably at `wp-admin/post.php?post=<id>&action=edit` through the classic editor Text mode, followed by `Update` and public QA.
- Preserve the existing body/list before replacing only the intended lead section.
- REI/WordPress stripped the first flex/image inline-sizing declarations. A screenshot exposed the oversized cover, and native `width`/`height` attributes with `aligncenter` corrected it.

Remaining defects:

- Homepage cover alt text and stable top-section heading semantics still need a focused pass.
- The Book builder remains blocked and Journal public HTML remains stale.
- Form workflow, map/contact content, public details, and broken profile references remain approval-bound.

Exact next objective: audit the Home cover alt text and the Book Themes, Request Updates, and confirmation top sections as one semantic-heading and spacing pass; leave forms, map/contact modules, public details, and profile references untouched, and do not retry The Book or Journal blocked paths without new evidence.

### 2026-07-16 - Stable-page accessibility and heading hierarchy

Objective: improve homepage cover quality/accessibility and establish a coherent heading hierarchy across the stable Themes, Updates, and confirmation pages.

Live changes:

- Changed the homepage Book Outline card from the 150-pixel thumbnail to the approved full-resolution 1024 by 1536 cover.
- Added `Gracious Millionaire book cover by Wes and Jenny Browning` as the cover alternative text through the native media editor.
- Changed `Book Themes`, `Request Book Updates`, and `Update Request Received` from H2 to the single H1 on their pages.
- Changed the six Book Themes section titles from H6 to H2 while preserving their visible copy and icons.

QA evidence:

- Both hosts show the full-resolution homepage cover with descriptive alt text and one H1 on Home, Themes, Updates, and confirmation.
- Both Themes hosts show all six core theme names as H2 and no H6 headings.
- Categories output remains absent and desktop QA found no horizontal overflow.
- Public mobile QA at 390 by 844 passed across all four pages; the cover rendered at 335 by 502.5 pixels without overflow.
- Existing forms and maps remained present; no form submission or workflow/contact setting was opened.

Learned paths:

- Callout semantic headings are editable at `Style` -> `Heading Structure` -> `Heading Tag`.
- Callout image resolution is editable at `Image` -> `Photo`; `Full Size` reused the approved asset without an upload.
- Alternative text for the old media stack is reliable through the native attachment editor rather than the Beaver Builder media panel.
- Large multi-page builder sequences can time out after partial success. Public-QA each page, then finish missing pages in separate focused builder sessions.

Remaining defects:

- The homepage still skips from H1 to H3; its major section headings should become H2 while card titles remain H3.
- The Book builder remains blocked and Journal public HTML remains stale.
- Form workflow, map/contact content, public details, and broken profile references remain approval-bound.
- Chrome tab finalization timed out twice after QA; the next run should begin with a fresh browser session and close stale GM tabs.

Exact next objective: start with a fresh Chrome session, correct the homepage H1-to-H3 heading gap and cover-card spacing through stable Callout controls, QA desktop/mobile on both hosts, and leave The Book, Journal, forms, maps, contact details, and workflow settings untouched.

### 2026-07-16 - Fresh-session Chrome blocker escalation

Objective: recover from the prior tab-finalization timeout, close stale GM tabs, and continue the homepage hierarchy pass.

Live changes:

- None. The live site was not inspected or edited after browser control failed.

Evidence:

- A fresh Chrome control session initialized successfully.
- The combined controlled-tab and user-tab discovery request timed out before returning any tab state.
- Without authoritative tab state, no live builder page was opened.

Learned path:

- A fresh control-session binding alone does not recover this failure. Require a Chrome or Codex Chrome-extension reset and successful tab discovery before resuming builder work.

Remaining defects:

- Homepage H1-to-H3 hierarchy and cover-card spacing remain the next safe visual objective.
- The Book builder and Journal cache paths remain blocked.
- Form workflow, map/contact content, public details, and profile references remain approval-bound.

Exact next objective: after Chrome/Codex extension reset, verify tab discovery, close stale GM tabs, and complete the homepage heading/spacing pass; do not retry the same builder path while tab discovery is unavailable.

### 2026-07-16 - Chrome tab-discovery recovery

Objective: open the Gracious Millionaire REI BlackBook control panel in Chrome and verify recovery from the tab-discovery blocker.

Live changes:

- None. No website content or settings changed.

Evidence:

- Wes explicitly authorized opening REI BlackBook in Chrome.
- A fresh Chrome window opened in the selected Default profile.
- Controlled-tab discovery returned normally.
- The REI BlackBook control panel for site `48842` loaded and was left open.

Learned path:

- When extension, native-host, and Chrome diagnostics pass but tab discovery hangs, opening a fresh selected-profile Chrome window can restore control without reinstalling the extension.

Exact next objective: resume the homepage H2/H3 hierarchy and cover-card spacing pass, then publish and QA both hosts at desktop and mobile.

### 2026-07-16 - Homepage semantic hierarchy

Objective: correct the homepage H1-to-H3 gap while preserving card-title semantics and the approved cover.

Pages/components touched:

- Homepage standalone Heading module.
- Homepage final Call to Action module.

Live changes:

- Promoted `Follow the Gracious Millionaire Book Project` from H3 to H2.
- Promoted `Want updates as the book develops?` from H3 to H2.
- Retained the H1, three H3 card titles, copy, destinations, images, and workflow boundaries.

QA evidence:

- Both public hosts render one H1, two section H2s, and three card H3s in the intended order.
- The approved cover remains 1024 x 1536 with descriptive alternative text.
- Both hosts passed desktop horizontal-overflow checks.
- The custom domain passed 390-pixel mobile heading-width and horizontal-overflow checks.

What worked:

- Standalone Heading: `Style` -> `Structure` -> `HTML Tag`.
- Call to Action: `Style` -> `Heading Structure` -> `Heading Tag`.
- Fresh-window Chrome recovery remained stable through publish, QA, viewport reset, and tab finalization.

Remaining defects:

- The portrait cover card still needs visual spacing refinement against the landscape cards.
- The Book and Journal remain blocked/stale; form, contact, workflow, manuscript, and personal-photo boundaries remain unchanged.

Exact next objective: balance the homepage cover-card spacing through a stable Callout or column-spacing control, then QA the three-card composition at desktop and mobile.

### 2026-07-16 - Homepage card composition

Objective: balance the portrait book-cover card against the two photographic cards without degrading the cover or mobile layout.

Pages/components touched:

- Homepage `Book Outline` Callout image position.
- Homepage `Request Updates` Callout image crop.

Live changes:

- Positioned the uncropped, full-resolution book cover left of its heading and copy on desktop.
- Applied a landscape crop to the updates photograph so its card is closer in proportion to the middle photographic card.
- Preserved all copy, links, headings, forms, contact data, and workflow settings.

QA evidence:

- Both public hosts render the revised desktop composition with zero horizontal overflow.
- At 390 x 844, Beaver Builder automatically restores the cover to a 335 x 503 portrait above its copy; mobile overflow remains zero.
- The approved cover remains 1024 x 1536 with descriptive alternative text.
- Heading order remains H1, H2, three H3 card titles, then H2; destinations remain outline, About, and Updates.

What worked:

- Callout image layout is stable at `Image` -> `Position`; `Left of Text and Heading` preserves the portrait asset on desktop and automatically stacks it on mobile.
- Callout image shape is stable at `Image` -> `Crop`; `Landscape` improves photographic-card balance without replacing the source image.
- Clicking the exact Callout module opens its settings directly when hover controls are unavailable.

Remaining defects:

- The Book builder and Journal cache paths remain blocked/stale.
- Stable secondary pages still need a cohesive typography-and-spacing pass.
- Forms, maps, contact details, workflows, manuscript content, and personal-photo uploads remain approval-bound.

Exact next objective: standardize section rhythm and image presentation across the stable About, Themes, Request Updates, and confirmation pages; do not retry Book or Journal unless browser evidence changes.

### 2026-07-16 - Stable secondary-page audit

Objective: standardize typography and image presentation across stable secondary pages.

Pages/components inspected:

- About the Book.
- Book Themes.
- Request Book Updates.
- Update Request Received.

Live changes:

- None. The About builder opened, but the settings panel timed out during the first heading-control inspection. A fresh Chrome control session also timed out during tab recovery and cleanup.

Audit evidence:

- About still has an H2 page title, three H3 feature titles, a generic circular stock image with empty alternative text, and a visible Categories/All block.
- Themes, Updates, and confirmation retain their corrected H1/H2 structure and hidden Categories blocks without horizontal overflow.
- The already uploaded `wes-jenny-building.jpg` is the approved replacement candidate for the About stock image; no new personal image upload is needed.

What changed in the operating map:

- About joins Book and Journal as a builder path that should not be retried on the next heartbeat without a Chrome reset, stale-tab cleanup, or direct evidence that settings access is stable.

Exact next objective: use a stable native WordPress or theme surface for a useful design improvement, perform read-only public QA, or stop quietly if no stable improvement remains. Do not retry About, Book, or Journal Beaver Builder paths until browser stability changes.

### 2026-07-17 - About-page design and accessibility recovery

Objective: complete the About-page hierarchy, generic-image replacement, and Categories cleanup after Wes requested another retry.

Pages/components touched:

- About-page primary Callout and three feature Callouts.
- About-page Photo module.
- About-page Categories widget.
- WordPress media attachment `6344`.

Live changes:

- Changed the page title from H2 to H1.
- Changed the three parallel feature headings from H3 to H2.
- Replaced the generic circular stock image with the approved `wes-jenny-building.jpg` landscape rendition.
- Added descriptive alternative text and republished the image module so it propagated to both hosts.
- Hid the Categories/default-All widget through Advanced visibility `Never`.

QA evidence:

- Both public hosts render one H1, the three feature H2s, the approved landscape image with descriptive alt text, no Categories output, and no desktop horizontal overflow.
- Contact details, profile placeholder, forms, maps, and workflow settings were not opened or changed.
- Chrome disconnected as the 390 by 844 viewport was applied, so mobile QA remains unverified.

What worked:

- A fresh builder tab recovered the previously unstable About path.
- Stable Beaver Builder module `data-node` values plus exact visible text reliably opened settings.
- The existing WordPress attachment was selectable by media ID `6344`; reselecting after the native attachment-alt update refreshed cached markup on both hosts.

Remaining defects:

- Run read-only 390-pixel About QA.
- Decide whether `Follow the book's progress` should remain H3 after mobile visual review.
- Book and Journal remain blocked/stale; public contact and workflow details remain approval-bound.

Exact next objective: run read-only mobile About QA first, then choose a stable native WordPress or theme objective that does not touch blocked Book/Journal or approval-bound contact/workflow settings.

### 2026-07-17 - Routed GM Site instruction intake and partial implementation

Objective: process Wes's routed GM Site email covering title status, newer cover, Books navigation, related manuscripts, Request Updates imagery, and removal of map/address content.

Live changes:

- Changed and saved the shared WordPress menu label from `The Book` to `Books`.

Staged but unpublished changes:

- Set the Updates-page map, address/phone rich text, Categories, and Contact Us widgets to Advanced visibility `Never`.
- Replaced the working-title sentence with book copy referencing `Gracious Millionaire - Drawn by Grace` and `The L.D. Evans story`.

QA evidence:

- Preview homepage and both Updates-page hosts render `Books`.
- Custom homepage still renders cached `The Book`.
- Both public Updates hosts still render the old working-title copy, map, address, and contact block because the builder changes were not published.

Asset decisions and blockers:

- Approved July 16 moving-forward cover identified; WordPress upload timed out before file selection.
- Existing media attachment `6325` (`reader-notebook.jpg`) selected as a stronger Request Updates image candidate.
- Chrome control failed while recovering the staged builder tab. Windows Computer Use can publish it, but public website editing requires action-time confirmation.

Exact next objective: after confirmation, publish and QA the staged Updates changes, replace the Request Updates card image with attachment `6325`, upload/place the approved July 16 cover through a stable file-chooser path, and verify both hosts plus mobile layout.

### 2026-07-17 - Clean-Chrome GM Site completion pass

Objective: complete the routed GM Site request after Wes closed stale tabs, restarted Chrome, and confirmed the ChatGPT extension setup.

Pages/components touched:

- Shared navigation host propagation.
- Updates page Beaver Builder state.
- Homepage Book Outline and Request Updates callout images.
- WordPress media library and cover attachment metadata.

Live changes:

- Published the staged Updates-page visibility changes, removing the visible map, address/phone block, Categories widget, and Contact Us widget.
- Published the revised About the Book copy referencing `Gracious Millionaire - Drawn by Grace` and `The L.D. Evans story` without calling the project a working title.
- Replaced the homepage Request Updates `faith-notes` image with `reader-notebook` attachment `6349` using the existing landscape crop.
- Uploaded and placed the approved July 16 moving-forward cover with descriptive alt text.
- Confirmed `Books` now renders on both homepage hosts; the earlier custom-domain cache mismatch is resolved.

QA evidence:

- Both homepage hosts return HTTP 200 and render `Books`, `reader-notebook`, the new cover asset, and the cover alt text; neither host references the July 10 cover or faith-notes image.
- Both Updates hosts return HTTP 200, include both related manuscript names, and omit working-title language and the visible map.
- Desktop screenshots show a coherent three-card homepage with portrait cover and landscape Request Updates image.
- Chrome ignored the requested 390 by 844 override and continued reporting a 1920-pixel viewport, so mobile QA remains unverified.

What worked:

- Closing stale tabs and restarting Chrome restored reliable builder navigation, snapshots, settings edits, publishing, uploads, and public QA.
- Publishing the completed Request Updates image before reloading preserved that change while refreshing Beaver Builder for the cover pass.
- Beaver Builder's own uploader made the cover selectable after the native WordPress upload did not appear in its media index.

What failed or remains:

- Native attachment `6350` is an unused duplicate because Beaver Builder did not index it; leave it in place unless deletion is explicitly approved.
- The Updates page has excessive whitespace because hidden left-column modules did not collapse the row structure.
- Public HTML still contains one hidden `Haig Point` string despite no visible address.
- Mobile viewport QA remains blocked by an ineffective Chrome viewport override.

Exact next objective: rebuild the Updates row into a balanced full-width layout, change `GET STARTED >>` to book-specific submit text without touching routing or sending the form, remove the hidden address residue, and rerun genuine mobile QA after confirming the actual browser width.

### 2026-07-17 - Updates structural retry stopped after repeated timeout

Objective: collapse the hidden map column, improve the Updates layout, and replace generic submit text without touching form routing.

Result:

- Chrome initially connected and rendered the Beaver Builder page normally after the clean restart.
- The hidden map column and its delete control were identified.
- Beaver Builder displayed its expected confirmation dialog, but Chrome timed out while accepting/applying the deletion and timed out again when the builder tab was reclaimed.
- No publish action completed and public QA showed no live-state change from map 027.

Lesson:

- A clean Chrome restart can restore inspection and simple editing but does not prove Beaver Builder can complete structural deletes or row reconstruction.
- Treat structural-action completion and successful publish as the stability test; do not infer stability from page load alone.
- Stop after the repeated timeout instead of retrying the same structural path in the same or next heartbeat.

Exact next objective: avoid the Updates structural path and use a stable non-structural or native WordPress path to audit or improve Themes, Journal, or the plural Books destination.

### 2026-07-17 - Books, Themes, and Journal public audit

Objective: avoid the timed-out Updates structure and identify a stable, useful next improvement.

Findings:

- Books and Themes still publish working-title language on both hosts, contrary to Wes's routed GM Site instruction.
- The Books destination remains a single-project About page rather than a plural multi-manuscript presentation.
- Journal still publishes generic Blog/category/newsletter output, the multi-service-company placeholder, and the full street-address, phone, and email block.
- Books and Themes also retain the public Contact Us block.
- All audited URLs returned HTTPS HTTP 200.

Result:

- No live changes. Known hanging structural paths were not retried.
- Contact-detail removal remains approval-bound and was not performed.

Exact next objective: use a stable text-only path to remove approved working-title language after Chrome stability is restored, and obtain explicit approval before removing public Contact Us blocks from Books, Themes, or Journal.

### 2026-07-17 - Approved public contact and generic-content cleanup

Objective: apply Wes's approval to remove the public Contact Us blocks from Books, Themes, and Journal and complete related approved cleanup.

Live changes:

- Books: removed both working-title references, added both related manuscript names, and hid the Contact Us module.
- Themes: removed the remaining working-title reference, added both related manuscript names, and hid the Contact Us module.
- Journal: changed Blog to Editing Notes; hid the private stock-post grid, category selector, newsletter button, generic multi-service About block, Categories, and Contact Us; replaced the orphaned newsletter copy with a neutral Notes in Progress status message.

QA:

- Both public hosts returned HTTPS HTTP 200 for Books, Themes, and Journal.
- Books and Themes contain neither working-title nor street-address text and include both related manuscript names.
- Journal contains the intentional editing-status copy and omits stock posts, categories, newsletter prompts, multi-service copy, address, phone, and contact output.
- Desktop screenshots showed clean layouts with no overlap or broken content.
- No form submission or workflow/routing change occurred.

Exact next objective: improve the Updates submit label through a stable presentation-only path, preserve all routing, and leave the blocked structural-delete path alone until builder stability is demonstrated.

### 2026-07-17 - Updates submit-label presentation pass

Objective: replace the generic Updates submit label without changing form routing, recipients, notifications, or delivery behavior.

Live changes:

- Updated the REI form submit-button record to `REQUEST BOOK UPDATES`.
- Confirmed Beaver Builder continued serving stale embedded `GET STARTED >>` markup after the form-record publish.
- Added page-scoped CSS that visually renders `REQUEST BOOK UPDATES` on the existing submit button while preserving the submit element, action, fields, and loading indicator.

QA:

- Both public hosts return HTTPS HTTP 200.
- Computed-style checks on both hosts confirm the new generated label and hidden stale text.
- Public desktop visual QA shows the new label centered with no clipping or overlap.
- No form was submitted and no Form Details, Run Workflow, thank-you, recipient, notification, SMS, or email setting was changed.

Lesson:

- The REI form record and Beaver Builder's embedded module markup can remain out of sync after both are published.
- A page-scoped CSS label is the stable presentation-only fallback for this legacy form module when workflow behavior must remain untouched.

Exact next objective: improve the plural Books destination through a stable non-structural path or complete genuine mobile QA after confirming the actual browser width. Continue to avoid the Updates structural-delete path.

### 2026-07-17 - Prominent plural Books presentation

Objective: make the three manuscript projects visibly distinct instead of leaving the related titles buried in paragraph copy.

Live changes:

- Changed the Books-page H1 to `Books by Wes and Jenny Browning`.
- Reused the three existing callout headings for `Gracious Millionaire`, `Gracious Millionaire - Drawn by Grace`, and `The L.D. Evans Story`.
- Rewrote the introduction to state directly that three manuscript projects are in development while keeping unfinished chapter content private.

QA:

- Both public hosts return HTTPS HTTP 200 and render one H1 plus all three manuscript names as H2 headings.
- Desktop screenshots show the three titles in the first main content viewport with clean wrapping and no overlap.
- No horizontal overflow was present at the verified 1905-pixel viewport.
- The Books page contains no working-title or street-address text.
- No chapter content, form, routing, recipient, notification, or delivery setting was changed.

What worked:

- The existing callout title fields remain a stable non-structural Beaver Builder path for prominent content changes.
- Reusing the three-column feature row created a clear multi-manuscript presentation without row or column edits.

Exact next objective: replace the inherited generic clock/award/puzzle icons through the stable callout path or complete genuine mobile QA when a confirmed narrow viewport is available.

### 2026-07-17 - Books manuscript icon cleanup

Objective: replace inherited generic feature icons with symbols that support the three manuscript entries.

Live changes:

- `Gracious Millionaire`: clock -> book icon.
- `Gracious Millionaire - Drawn by Grace`: award -> open-heart icon.
- `The L.D. Evans Story`: puzzle -> manuscript/document icon.

QA:

- Both public hosts return HTTPS HTTP 200 and contain the intended `fa-book`, `fa-heart-o`, and `fa-file-text-o` classes.
- The H1 and three manuscript H2 headings remain unchanged.
- Desktop screenshots show consistent icon sizing, clean title wrapping, and no overlap or horizontal overflow at the verified 1905-pixel viewport.
- No chapter content, page structure, form, routing, recipient, notification, or delivery setting changed.

What worked:

- Callout `Image` -> `Replace`, followed by icon-library search and module Save, is a stable presentation-only path for replacing inherited template icons.

Exact next objective: complete genuine mobile QA when a confirmed narrow viewport is available, or continue with another stable non-structural public-page improvement.

### 2026-07-17 - Responsive QA, semantic cleanup, image alignment, and GB Site intake

Objective: complete genuine narrow-viewport QA, correct stable public defects, and process Wes's routed `GB Site` instruction without crossing manuscript-publication or outbound-workflow boundaries.

Live changes:

- Confirmation: replaced the remaining working-title statement with current book-focused copy.
- Journal: promoted `Editing Notes` to H1 and `Notes in Progress` to H2.
- Homepage: corrected the actual live Request Updates media attachment alt text and republished the callout.
- Homepage: changed the Request Updates image crop from Landscape to Panorama to align it more closely with the `About the Book` image height.

QA:

- Completed genuine 390 x 844 reader-journey checks across Home, Books, Themes, Journal, Updates, Outline, and Confirmation with no horizontal overflow found.
- Verified the confirmation copy and Journal heading hierarchy on both public hosts.
- Verified both hosts serve `reader-notebook-panorama.jpg` with descriptive alt text.
- No form submission or outbound workflow/routing change occurred.

New intake and review work:

- Processed `sources\email\2026-07-17-210050-gb-site.md`; the source inventory already contained the routed file and Outlook message id, so no duplicate source row was added.
- Prepared `gracious-millionaire-theme-page-excerpt-candidates-001.md` with six short candidates marked not approved for publication.

What worked:

- True responsive QA requires confirming the reported inner width after applying the viewport capability.
- For Beaver Builder images, identify the attachment id actually referenced by the live module before editing metadata, then republish the module so cached derivatives inherit the new alt text.
- Full Size plus Panorama crop is a stable non-structural path for correcting callout image proportions.

What remains:

- Theme excerpt approval, six linked theme pages, form/workflow specifications, approved logo and personal hero asset.
- Confirmation Contact Us/address/broken profile output remains an approval-needed privacy defect.
- Updates structural whitespace and hidden address residue remain blocked on the repeated structural-delete path.

Exact next objective: obtain excerpt decisions and build the six linked theme pages from approved copy; do not activate weekly-email/contact delivery or publish a personal photo without the required specific approvals.

### 2026-07-17 - Revised logo review set

Objective: respond to Wes's request to revisit the logo while preserving approval control over public branding.

Review assets created:

- Full revised logo concept 002.
- Cropped horizontal header lockup at 1840 x 390.
- Compact GM monogram at 390 x 390 for narrow/mobile placement.

Design change:

- Simplified the original concept by removing the plant, ornamental dividers, comparison-sheet labels, and competing flourishes.
- Retained a compact GM monogram, open doorway, forward path, editorial serif wordmark, charcoal, evergreen, and restrained brass.

QA:

- Exact text reads `GRACIOUS MILLIONAIRE`.
- The horizontal crop has sufficient padding and a header-oriented aspect ratio.
- The compact mark remains legible as a standalone square asset.

Live status:

- No website change or public upload occurred. The current live logo remains unchanged pending approval.
- No personal photo, form, workflow, contact detail, or manuscript content was published.

Exact next objective: after logo approval, replace the live header branding and QA both hosts at desktop/mobile sizes; otherwise resume with approved theme-page copy when excerpt decisions arrive.

### 2026-07-17 - Approved logo publication

Objective: publish Wes-approved revised logo concept 002 and verify responsive header behavior on both public hosts.

Live changes:

- Uploaded the 1840 x 390 horizontal logo lockup to WordPress.
- Set the media attachment alternative text to `Gracious Millionaire logo`.
- Replaced both regular and retina header-logo settings with the approved asset and published the Customizer.

QA:

- Both `graciousmillionaire.com` and the REI preview host serve the new logo asset.
- Desktop headers show clean wordmark/navigation alignment without overlap.
- True 390 x 844 checks on both hosts show the full wordmark above the collapsed Menu control with no clipping or horizontal overflow.
- No form, workflow, recipient, notification, contact detail, DNS setting, manuscript content, or personal photo changed.

What worked:

- The controlled-browser file-chooser event plus `chooser.setFiles()` is the reliable WordPress media-upload path; filling the file input or waiting for a native picker is not.
- Reusing the same high-resolution horizontal lockup for regular and retina fields preserves clarity while the theme scales it correctly at desktop and mobile sizes.

Exact next objective: obtain decisions on the six theme excerpt candidates, then create and link the six theme pages using approved copy only.

### 2026-07-17 - Approved linked theme pages

Objective: publish the six approved theme excerpts on dedicated pages and connect the existing Themes callouts.

Live changes:

- Created six published child pages beneath Book Themes for Stewardship, Faith and Calling, Work and Responsibility, Generosity, Jenny's Perspective, and Lessons Still Unfinished.
- Published the exact approved excerpt on each page without internal chapter labels, architecture codes, or production notes.
- Added public navigation back to Themes and Books.
- Linked each existing Themes icon and title to its matching child page through the callout Link field.

QA:

- The public Themes index exposes six matching icon/title links.
- All six pages load on both hosts with one H1, the exact approved blockquote, and working navigation links.
- No theme page exposes the inherited address or phone output.
- True 390 x 844 QA passed for the Themes index and Jenny's Perspective with no horizontal overflow.
- No form, workflow, recipient, notification, contact detail, DNS setting, personal photo, or unapproved manuscript text changed.

What worked:

- Assigning Book Themes as Parent before native WordPress publication produced stable nested `/services/<theme>/` routes.
- A Callout module link applies to both its icon and heading while CTA Type remains `None`, so the existing visual design did not require a new button or structural edit.

Exact next objective: select and approve the exact personal homepage hero image for public upload, or define Journal signup/contact-form delivery specifications before activation.
