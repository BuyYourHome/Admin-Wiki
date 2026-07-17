# Gracious Millionaire Element Map 027

Created 2026-07-17 after the clean-Chrome retry completed Wes's routed `GM Site` requests.

## Current Public State

- Public domain: `https://www.graciousmillionaire.com/` responds over HTTPS with HTTP 200.
- REI preview: `https://u113450.h.reiblackbook.com/generic6/` responds over HTTPS with HTTP 200.
- Shared navigation now renders `Home`, `Books`, `Themes`, `Journal`, and `Updates` on both hosts.
- The former custom-home cache mismatch is resolved; neither homepage renders `The Book`.
- Footer remains `Copyright 2026 Gracious Millionaire. All rights reserved.`

## Homepage

- Page title/H1 remains `Gracious Millionaire` as the public project/site label.
- Hero copy identifies the work as a book project by Wes and Jenny Browning and links to the outline.
- The three public cards remain `Book Outline`, `About the Book`, and `Request Updates`.
- `Book Outline` now uses the approved July 16 moving-forward cover showing Wes and Jenny walking forward.
- Rendered cover asset: `gracious-millionaire-book-cover-current-smaller-the-2026-07-161.png`.
- Cover alt text: `Wes and Jenny Browning walking forward on the current book cover`.
- `Request Updates` now uses `reader-notebook-landscape.jpg`, replacing `faith-notes-landscape.jpg`.
- `About the Book` retains the approved Wes-and-Jenny landscape photo.
- Both public hosts render the new cover and reader/notebook image and no longer reference the July 10 cover or faith-notes image.

## Updates Page

- Page title/H1: `Request Book Updates`.
- Form presentation remains name, email, and optional phone with `GET STARTED >>` submit text.
- No form submission was performed and no routing, recipient, autoresponder, SMS, or email workflow was changed.
- The visible Google map is removed.
- The visible street address, phone, email, Contact Us widget, and Categories widget are removed.
- The public copy no longer calls Gracious Millionaire a working title.
- `About the Book` now references `Gracious Millionaire - Drawn by Grace` and `The L.D. Evans story` as related manuscripts in development.
- Both public hosts render the revised copy and omit the visible map and removed widgets.
- Remaining presentation defect: hiding the old left-column modules leaves excessive empty space above the narrow About the Book block. A later pass should rebuild or collapse the row rather than merely hiding modules.
- Public HTML retains one hidden `Haig Point` string even though no address is visible in the rendered page; this should be removed from underlying page data in a later safe cleanup.

## Media Records

- Reader/notebook attachment used by the homepage was observed as WordPress attachment `6349`.
- Native WordPress upload created approved-cover attachment `6350`, but Beaver Builder did not index that native upload.
- Beaver Builder therefore uploaded a selectable copy named `gracious-millionaire-book-cover-current-smaller-the-2026-07-161.png`; that copy is the live homepage asset.
- Attachment `6350` is an unused duplicate. Do not delete it without an explicit deletion decision.

## QA

- Desktop visual QA passed on the custom-domain homepage: the cover remains portrait, the reader/notebook image crops to landscape, card content is readable, and no overlap was observed.
- Desktop visual QA passed on the preview Updates page: map, address/contact blocks, and Categories are not visible.
- Exact HTML/asset checks passed on both hosts for `Books`, both related manuscript names, the reader/notebook image, the new cover, and cover alt text.
- A requested 390 by 844 viewport override did not change Chrome from 1920 pixels, even after reload. Mobile QA therefore remains unverified and must not be reported as passed.

## Remaining Generic Or Structural Work

- `Themes` and `Journal` remain public navigation surfaces and were not reaudited in this pass.
- The Updates form button still uses generic `GET STARTED >>` copy and should be changed to a book-specific command when a stable form-presentation path is available.
- The Updates page needs row/column reconstruction to remove the large empty area.
- Build a true `Books` page or section that presents the current book project and the two related manuscripts intentionally; the navigation label is plural, but the current destination still behaves as the former single-book About page.

## Exact Next Objective

Use a stable Updates-page layout path to collapse the hidden left column, move the form and About copy into a balanced full-width structure, and replace `GET STARTED >>` with book-specific submit text without changing form routing or sending a submission. Then run real mobile QA after confirming Chrome reports the requested viewport width.
