# Gracious Millionaire Element Map 013

Created 2026-07-16 after the homepage card-sequence correction.

Audit targets:

- `https://graciousmillionaire.com/`
- `https://u113450.h.reiblackbook.com/generic6/`
- `https://graciousmillionaire.com/book-outline/`
- `https://u113450.h.reiblackbook.com/generic6/book-outline/`

## Run Summary

The homepage's three-card reader journey now uses specific actions and correct destinations:

- `Book Outline` now uses `View the Outline` and routes its image, title, and CTA to `/book-outline/` instead of the unrelated `/services/` page.
- `About the Book` retains `Explore the Book` and `/about-2/`.
- `Request Updates` now uses `Request Updates` and retains `/contact/`.

Both homepages and both outline destinations returned HTTP 200. Neither homepage contains a generic callout `Read More` CTA, and the old Book Outline card route to `/services/` is absent.

Mobile QA at 390 x 844 confirmed all three labels and destinations with no horizontal overflow on either homepage.

No form settings, workflow routing, recipients, public contact details, DNS, manuscript content, purchases, or outbound messaging were changed.

## Current State

| Surface | Current state | Remaining action |
| --- | --- | --- |
| Homepage hero | Approved cover remains primary; `View Outline` routes to `/book-outline/`. | Retain. |
| Homepage card sequence | `View the Outline`, `Explore the Book`, and `Request Updates` now match their destinations. | Retain. |
| Homepage lower invitation | Copy is book-focused and routes correctly to `/contact/`, but the button still says `Contact Us`. | Replace with a reader-facing updates label through the stable homepage CTA module. |
| The Book page | Stock circle, broken profile placeholder, and missing in-page cover remain. | Builder path remains blocked; do not retry without new stability evidence. |
| Journal backend | Six template posts are private; generic categories are deleted; shared Primary Sidebar is empty. | Retain pending public propagation. |
| Journal public output | REI cache still exposes old posts, categories, public contact details, and `[profile_image_url]`. | Do not retry hanging cache-clear or builder-delete paths next run. |
| Request Updates mobile | No horizontal overflow, but the embedded map creates a large vertical gap. | Map/contact-layout changes require specific approval because they affect public contact/address presentation. |

## Obstacles And Learned Paths

- Homepage callout modules remain stable for coordinated destination and CTA changes.
- The Book Outline card had a semantic routing defect hidden behind a plausible `services` URL; destination QA must compare the visible purpose to the actual canonical page, not only test HTTP status.
- Module Save, Builder Done, and Publish Changes propagated immediately to both hosts.
- The stale-cache problem remains isolated to the Journal surface.
- The Book builder and Journal deletion/cache paths remain known failures and should not consume the next heartbeat without new evidence.

## Exact Next Objective

Use the stable homepage CTA module to replace the lower `Contact Us` button with `Request Book Updates`, retain its `/contact/` destination, and QA the full homepage command hierarchy on both hosts at desktop and mobile sizes. If that objective completes cleanly, audit the Update Request Received page for any remaining generic command language without entering form or workflow settings. Do not retry The Book or Journal deletion paths, and continue to require specific approval before changing the public map/contact/address block.
