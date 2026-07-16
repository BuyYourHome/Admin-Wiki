# Gracious Millionaire Element Map 015

Created 2026-07-16 after the confirmation-page Categories cleanup.

Audit targets:

- `https://graciousmillionaire.com/thank-you/`
- `https://u113450.h.reiblackbook.com/generic6/thank-you/`
- `https://graciousmillionaire.com/book-outline/`
- `https://graciousmillionaire.com/chapter-being-edited/`
- `https://graciousmillionaire.com/services/`
- `https://graciousmillionaire.com/about-2/`

## Run Summary

The confirmation page's embedded `Categories` module is now set to Beaver Builder visibility `Never`. This intentionally removes the empty/default `All` category from public output without using the deletion-confirmation path that previously stalled on Journal.

Both confirmation-page hosts returned HTTP 200 with no Categories heading, category link, or module node. The book-focused About block remained live, and the adjacent contact module remained present and unchanged.

Mobile QA at 390 x 844 confirmed no Categories output and no horizontal overflow on either host.

A read-only continuation scan found that Book Outline and Chapter Being Edited do not expose the mapped generic widget remnants. Book Themes and The Book still expose embedded Categories, contact content, and broken profile references; The Book also retains its stock circle.

No form settings, workflow routing, recipients, public contact details, DNS, manuscript content, purchases, or outbound messaging were changed.

## Current State

| Surface | Current state | Remaining action |
| --- | --- | --- |
| Confirmation Categories | Hidden at all breakpoints and absent from public HTML. | Retain. |
| Confirmation About block | Book-focused `About the Book` copy remains live. | Retain. |
| Confirmation contact block | Public address, phone, email, `Contact Us`, and broken profile reference remain. | Changes require specific approval. |
| Book Outline / Chapter status | No generic About, Categories, contact, broken-profile, or stock-circle remnants found in the read-only scan. | Retain. |
| Book Themes | Book-focused body copy is live, but embedded Categories, contact content, and broken profile reference remain. | Hide only the Categories module through the previously stable Themes builder path. |
| The Book page | Stock circle, embedded Categories/contact content, broken profile reference, and missing in-page cover remain. | Builder path remains blocked; do not retry without new stability evidence. |
| Journal public output | REI cache still exposes old posts, categories, public contact details, and broken profile reference. | Do not retry hanging cache-clear or builder-delete paths next run. |
| Request Updates mobile | No horizontal overflow, but the embedded map creates a large vertical gap. | Map/contact-layout changes require specific approval. |

## Obstacles And Learned Paths

- A module's Advanced `Visibility` setting can intentionally remove generic output at every breakpoint by selecting `Never`.
- This visibility path is reversible and avoids Beaver Builder's module-deletion confirmation, which has stalled Chrome on another page.
- Public QA must confirm the module node and category link are absent, not only that the heading is hidden.
- The adjacent contact module remained untouched and publicly present.
- The Book builder and Journal deletion/cache paths remain known failures.

## Exact Next Objective

Use the previously stable Book Themes Beaver Builder path to set only its embedded `Categories` module to visibility `Never`, publish, and QA both hosts at desktop and mobile sizes. Do not open or alter the adjacent contact module, public contact details, or broken profile reference without specific approval. Do not retry The Book or Journal deletion paths.
