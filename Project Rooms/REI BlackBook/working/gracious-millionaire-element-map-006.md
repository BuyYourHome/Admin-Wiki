# Gracious Millionaire Element Map 006

Created 2026-07-15 after Wes requested a more visible GM Mode pass with new photos and book-cover placement.

Audit targets:

- `https://www.graciousmillionaire.com/`
- `https://u113450.h.reiblackbook.com/generic6/`

## Run Summary

Live homepage changes completed:

- Closed a stale `Update Request Received` Beaver Builder tab from an earlier timed-out GM Mode run.
- Uploaded the staged web-sized Gracious Millionaire photo set from `sources\gracious-millionaire-photos\web-sized\` into WordPress Media Library.
- Replaced the Home hero/background image with an uploaded landscape/walking image, removing the generic phone/keyboard stock image from the first viewport.
- Placed the uploaded Gracious Millionaire book cover in the first homepage card.
- Replaced the second homepage card image with `wes-jenny-building.jpg`.
- Replaced the third homepage card image with `faith-notes.jpg`.
- Published the Beaver Builder changes.

Public QA:

- `https://www.graciousmillionaire.com/` returned HTTP `200`.
- Public homepage visually shows the new hero image.
- Public homepage visually shows the book cover, Wes/Jenny photo, and faith-notes image in the card section.
- Public homepage HTML now references:
  - `gracious-millionaire-book-cover-wes-and-jenny-browning-2026-07-10-email.jpg`
  - `wes-jenny-building.jpg`
  - `faith-notes.jpg`
- Public homepage HTML no longer references the old card-image assets `BlogStockGen_0053`, `BlogStockGen_0054`, or `BlogStockGen_0044`.

No form submissions, lead-routing changes, outbound workflows, public contact-detail changes, DNS changes, purchases, manuscript chapter publication, or outbound messages were made.

## Current Global State

| Element | Current state after live pass | Remaining action |
| --- | --- | --- |
| Main navigation on original template pages | `Home`, `Book Themes`, `About the Book`, `Request Updates`, `Editing Notes`. | Keep; verify after deeper builder/menu work. |
| Main navigation on newer Book Outline and Chapter Being Edited pages | Still shows `Home`, `Services`, `About`, `Contact`, `Blog`. | Fix menu inheritance or menu assignment for newer pages. |
| Site logo | Visible header logo is Gracious Millionaire. Public HTML still has `data-retina` pointing to the old generic REI BlackBook retina logo asset. | Replace/remove the old generic retina-logo reference when the header/logo settings path is stable. |
| Footer copyright | Still `Copyright 2015 . All rights reserved.` | Update when footer editing path is confirmed. |
| Homepage hero image | Replaced with uploaded Gracious Millionaire landscape/walking image. | QA mobile crop in a later visual pass. |
| Homepage card images | First card now uses book cover; second uses Wes/Jenny photo; third uses faith-notes photo. | Decide whether to rebalance card heights/layout so the vertical cover does not dominate the row. |
| Shared/sidebar About Us widget | Request Updates, Book Themes, and About the Book use `About the Book` with book-focused copy. Update Request Received and Editing Notes still show generic multi-service-company placeholder. | Retry only after builder stability is confirmed, or find a global/template edit path. |
| Shared/sidebar Blog widget | Still shows generic internet-success/creative/goals posts. | Replace with book update links or hide until approved posts exist. |
| Shared/sidebar Categories widget | Still `All`, `Best Tips Ever`, `Success Stories`. | Replace with book categories or hide. |
| Contact/request form | Presentation still includes existing fields and `GET STARTED >>` button. | Button/field presentation can be improved, but do not activate or change lead/SMS/email workflows without separate approval. |

## Obstacles Behind The Slow Visible Progress

- The scheduled heartbeat was following the current map rule not to retry the same Beaver Builder path after repeated timeout failures. That kept later scheduled runs conservative.
- A stale GM builder tab was still open in Chrome; closing it improved the homepage builder path.
- Earlier local-file uploads were blocked by Chrome extension file access. On this run, the controlled file-chooser upload worked.
- The site has several separate edit surfaces: Beaver Builder page modules, REI merge fields, menu assignment, footer/sidebar widgets, blog/category widgets, and theme/header settings. Fixing one surface does not automatically update the others.
- The remaining generic sidebar/footer/menu items are not all on the same reliable builder path. The `Update Request Received` and `Editing Notes` widget path previously timed out and should still be treated as unstable unless Chrome stays healthy.
- Public-contact fields and form/SMS/lead-routing settings are intentionally constrained because changing them has outside consequences.

## Next Live Edit Pass

Recommended order:

1. Improve homepage card layout now that the cover is visible, especially cover size/row balance on desktop and mobile.
2. Fix the homepage `About the Book` card link, which still points to `/about/` instead of `/about-2/`.
3. Replace/remove the old generic `data-retina` logo reference in the header.
4. Fix Book Outline and Chapter Being Edited navigation labels.
5. Replace or hide generic Blog/Categories widgets and fix footer copyright.
6. Retry remaining About-widget cleanup on Update Request Received and Editing Notes only if the builder remains stable.
