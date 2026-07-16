# Gracious Millionaire Element Map 017

Created 2026-07-16 after the Request Updates Categories cleanup.

Audit targets:

- `https://graciousmillionaire.com/contact/`
- `https://u113450.h.reiblackbook.com/generic6/contact/`

## Run Summary

The Request Updates page's embedded `Categories` module is now set to Beaver Builder visibility `Never`. Both public hosts dropped the Categories heading, default `All` link, and module node.

Both hosts returned HTTP 200. The book-focused About block, InsiteForm, embedded map, and adjacent contact module remained present and unchanged. Mobile QA at 375 px showed no Categories output and no horizontal overflow.

No form settings, workflow routing, recipients, public contact details, DNS, manuscript content, purchases, or outbound messaging were changed.

## Current State

| Surface | Current state | Remaining action |
| --- | --- | --- |
| Request Updates Categories | Hidden at all breakpoints and absent from public HTML. | Retain. |
| Request Updates About/form | Book-focused copy and form remain live; workflow behavior is unchanged. | Retain; do not enter workflow settings without specific approval. |
| Request Updates map/contact | Embedded map, public contact details, and broken profile reference remain. | Changes require specific approval. |
| Confirmation Categories | Hidden and absent from public HTML. | Retain. |
| Book Themes Categories | Hidden and absent from public HTML. | Retain. |
| Homepage | Book cover, hero image, authentic photography, and reader CTAs are live. | Include in the next cohesive visual audit. |
| The Book page | Stock circle, embedded Categories/contact content, broken profile reference, and missing in-page cover remain. | Builder path remains blocked; do not retry without stability evidence. |
| Journal public output | REI cache still exposes old posts, categories, public contact details, and broken profile reference. | Do not retry hanging cache-clear or builder-delete paths without new evidence. |

## Obstacles And Learned Paths

- Advanced visibility `Never` removed isolated generic Categories output consistently across the confirmation, Book Themes, and Request Updates pages.
- Request Updates published immediately to both hosts with cache misses during QA.
- Public QA confirmed the form, map, and contact nodes remained present without opening their settings.
- The remaining Request Updates map/contact/profile defects require specific approval because they expose or alter public contact information or form-adjacent presentation.
- The Book builder and Journal deletion/cache paths remain known failures.

## Exact Next Objective

Audit the stable Home, Book Outline, Chapter status, Book Themes, Request Updates, and confirmation surfaces as one reader journey. Remove any remaining non-contact generic modules found on those stable pages and complete a cohesive typography/spacing refinement on the highest-impact stable page. Preserve the live book cover and approved photography. Do not retry The Book or Journal blocked paths, and do not alter form workflow, map, public contact details, or profile references without specific approval.
