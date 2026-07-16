# Gracious Millionaire Element Map 011

Created 2026-07-16 after the Request Updates presentation pass and responsive QA.

Audit targets:

- `https://graciousmillionaire.com/contact/`
- `https://u113450.h.reiblackbook.com/generic6/contact/`
- `https://graciousmillionaire.com/blog/`
- `https://u113450.h.reiblackbook.com/generic6/blog/`

## Run Summary

The Request Updates page was clarified without entering form settings or changing any workflow behavior:

- `Contact Wes and Jenny` became `Request Book Updates`.
- The introduction became `Request future Gracious Millionaire book updates. Name and email are required; phone is optional.`

Both public hosts returned HTTP 200 and contained the new heading and introduction. The old heading was absent. Mobile QA at 390 x 844 showed no horizontal overflow.

The form was not submitted. Its fields, consent language, button, routing, recipients, autoresponders, redirect behavior, and outbound behavior were not changed.

Journal cache QA remained unchanged: both hosts still returned `X-Pj-Cache-Status: hit` and old HTML containing the six template posts, deleted category names, embedded contact details, and the broken profile placeholder.

No public contact detail, DNS, purchase, manuscript, or messaging action was changed.

## Current State

| Surface | Current state | Remaining action |
| --- | --- | --- |
| Request Updates heading/copy | `Request Book Updates` and clear required/optional-field copy are live on both hosts. | Retain. |
| Request Updates form | Name, email, and phone fields plus existing consent and `GET STARTED >>` button remain. | Do not alter workflow behavior without specific approval. Button/field presentation can be improved in a future safe pass. |
| Request Updates mobile | No horizontal overflow at 390px, but the embedded map creates a large empty vertical gap before the content column. | Map/contact-layout changes require specific approval because they affect public contact/address presentation. |
| Journal backend | Six template posts are private; generic categories are deleted; shared Primary Sidebar is empty. | Retain pending public propagation. |
| Journal public output | REI cache still exposes old posts, categories, public contact details, and `[profile_image_url]`. | Do not retry hanging cache-clear or builder-delete paths next run. |
| Home cover card | Approved cover is live but the first card still points to `/about/` rather than The Book destination `/about-2/`. | Correct destination and reader-facing CTA through the proven homepage builder path. |
| The Book | Stock circle, broken profile placeholder, and missing cover remain. | Builder path remains blocked; do not retry next run without new stability evidence. |

## Obstacles And Learned Paths

- Request Updates page text modules are stable in Beaver Builder even while The Book and Journal deletion paths are unreliable.
- Safe form-presentation work can be isolated to surrounding text modules; do not open the InsiteForms settings panel when workflow changes are not approved.
- Publish through module Save, Builder Done, and Publish Changes, then verify both hosts independently.
- Responsive QA must include vertical composition, not only overflow. The current embedded map dominates mobile space and separates the form from the heading.
- Journal's REI page cache remains independent of the saved WordPress post/category/widget state.

## Exact Next Objective

Use the proven homepage Beaver Builder path to correct the approved book-cover card destination from `/about/` to `/about-2/`, make its CTA explicitly reader-facing, rebalance the cover card if the same stable module permits it, publish, and QA both hosts at desktop and mobile sizes. Do not retry The Book or Journal deletion paths. Continue to request specific approval before removing the public map/contact/address block or broken profile placeholder.
