# Gracious Millionaire Element Map 012

Created 2026-07-16 after the homepage book-card destination and CTA correction.

Audit targets:

- `https://graciousmillionaire.com/`
- `https://u113450.h.reiblackbook.com/generic6/`
- `https://graciousmillionaire.com/about-2/`
- `https://u113450.h.reiblackbook.com/generic6/about-2/`

## Run Summary

The homepage `About the Book` card now routes readers to the live book page at `/about-2/` instead of the obsolete `/about/` destination. Its generic `Read More` CTA is now `Explore the Book`.

The card image, heading, and CTA share the corrected destination. Both homepages and both book-page destinations returned HTTP 200. Public HTML on both hosts contained the new CTA and `/about-2/` destination and did not retain the old card destination.

Mobile QA at 390 x 844 confirmed the card heading and CTA, the correct destination, and no horizontal overflow on either homepage. The approved book cover remains the dominant homepage hero visual and Open Graph image; the supporting `About the Book` card retains the Wes-and-Jenny building photograph.

No form settings, workflow routing, recipients, public contact details, DNS, manuscript content, purchases, or outbound messaging were changed.

## Current State

| Surface | Current state | Remaining action |
| --- | --- | --- |
| Homepage book opening | Approved cover is the primary visual and Open Graph image. | Retain. |
| About the Book card | Image, title, and `Explore the Book` CTA route to `/about-2/`. | Retain. |
| Other homepage cards | Book Outline and Request Updates still use generic `Read More` CTA labels. | Replace with specific reader-facing labels in one stable homepage pass. |
| The Book page | Stock circle, broken profile placeholder, and missing in-page cover remain. | Builder path remains blocked; do not retry without new stability evidence. |
| Journal backend | Six template posts are private; generic categories are deleted; shared Primary Sidebar is empty. | Retain pending public propagation. |
| Journal public output | REI cache still exposes old posts, categories, public contact details, and `[profile_image_url]`. | Do not retry hanging cache-clear or builder-delete paths next run. |
| Request Updates mobile | No horizontal overflow, but the embedded map creates a large vertical gap. | Map/contact-layout changes require specific approval because they affect public contact/address presentation. |

## Obstacles And Learned Paths

- The homepage callout module is stable in Beaver Builder and supports coordinated destination and CTA edits through its `Call To Action` tab.
- Save the module, use Builder `Done` -> `Publish Changes`, and verify the exact destination and label on both hosts.
- Public and preview hosts propagated this homepage change immediately; the stale-cache problem remains isolated to the Journal surface.
- Responsive QA should verify both link semantics and document overflow at the selected mobile breakpoint.
- The Book builder and Journal deletion/cache paths remain known failures and should not consume the next heartbeat without new evidence.

## Exact Next Objective

Use the stable homepage Beaver Builder path to replace the remaining generic `Read More` labels with specific reader-facing CTAs, align each card destination with its visible purpose, and QA the full card sequence on both hosts at desktop and mobile sizes. Do not retry The Book or Journal deletion paths. Continue to require specific approval before changing the public map/contact/address block.
