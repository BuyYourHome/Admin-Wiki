# Gracious Millionaire Element Map 014

Created 2026-07-16 after the homepage lower-CTA correction and confirmation-page propagation pass.

Audit targets:

- `https://graciousmillionaire.com/`
- `https://u113450.h.reiblackbook.com/generic6/`
- `https://graciousmillionaire.com/thank-you/`
- `https://u113450.h.reiblackbook.com/generic6/thank-you/`

## Run Summary

The homepage lower invitation now uses `Request Book Updates` instead of the generic `Contact Us` button while retaining the correct `/contact/` destination.

A read-only confirmation-page audit found that public output still showed the old placeholder `About Us` multi-service-company copy, even though Beaver Builder loaded successfully with the previously saved book-focused `About the Book` replacement. Publishing the current page state flushed that mismatch. Both hosts now show the book-focused block and no longer contain the placeholder multi-service language.

Both affected pages returned HTTP 200. Mobile QA at 390 x 844 confirmed the new homepage CTA and propagated confirmation-page copy with no horizontal overflow on either host.

No form settings, workflow routing, recipients, public contact details, DNS, manuscript content, purchases, or outbound messaging were changed.

## Current State

| Surface | Current state | Remaining action |
| --- | --- | --- |
| Homepage command hierarchy | Hero, three cards, and lower invitation use reader-facing actions; lower CTA is `Request Book Updates`. | Retain. |
| Confirmation heading/body | `Update Request Received` and book-editing confirmation copy are live. | Retain. |
| Confirmation About block | Book-focused `About the Book` copy is live on both hosts; placeholder multi-service copy is gone. | Retain. |
| Confirmation Categories | Embedded `Categories` block exposes the empty/default `All` category. | Remove through the now-stable confirmation-page builder path without touching contact content. |
| Confirmation contact block | Public address, phone, email, `Contact Us`, and a broken `[profile_image_url]` reference remain embedded. | Changes require specific approval because they alter public contact/address presentation. |
| The Book page | Stock circle, broken profile placeholder, and missing in-page cover remain. | Builder path remains blocked; do not retry without new stability evidence. |
| Journal public output | REI cache still exposes old posts, categories, public contact details, and `[profile_image_url]`. | Do not retry hanging cache-clear or builder-delete paths next run. |
| Request Updates mobile | No horizontal overflow, but the embedded map creates a large vertical gap. | Map/contact-layout changes require specific approval. |

## Obstacles And Learned Paths

- The homepage CTA module is stable; its button label and destination are isolated in the `Button` tab.
- A Beaver Builder page can contain the desired saved module state while public output serves an older version. When that occurs, publish the current page state before re-editing the module.
- Publishing the confirmation page changed its public cache from stale placeholder output to the saved book-focused block.
- The confirmation-page builder is currently stable after agent-created tabs are cleaned up.
- The Book builder and Journal deletion/cache paths remain known failures and should not consume the next heartbeat without new evidence.

## Exact Next Objective

Use the now-stable confirmation-page Beaver Builder path to remove the embedded `Categories` module and its default `All` link, publish, and QA both hosts at desktop and mobile sizes. Do not open or alter the adjacent contact module, its broken profile reference, address, phone, or email without specific approval. Do not retry The Book or Journal deletion paths.
