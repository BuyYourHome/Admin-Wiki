# Gracious Millionaire Element Map 016

Created 2026-07-16 after the Book Themes Categories cleanup.

Audit targets:

- `https://graciousmillionaire.com/services/`
- `https://u113450.h.reiblackbook.com/generic6/services/`
- `https://graciousmillionaire.com/contact/`
- `https://u113450.h.reiblackbook.com/generic6/contact/`

## Run Summary

The Book Themes page's embedded `Categories` module is now set to Beaver Builder visibility `Never`. Both public hosts dropped the Categories heading, default `All` link, and module node.

Both hosts returned HTTP 200. The book-focused About block remained live, and the adjacent contact module remained present and unchanged. Mobile QA at 390 x 844 showed no Categories output and no horizontal overflow.

A read-only continuation scan confirmed that Request Updates still exposes the same embedded Categories/default-All output. Its book-focused About block is live, while its map, contact content, and broken profile reference remain approval-bound.

No form settings, workflow routing, recipients, public contact details, DNS, manuscript content, purchases, or outbound messaging were changed.

## Current State

| Surface | Current state | Remaining action |
| --- | --- | --- |
| Book Themes Categories | Hidden at all breakpoints and absent from public HTML. | Retain. |
| Book Themes About block | Book-focused `About the Book` copy remains live. | Retain. |
| Book Themes contact block | Public contact content and broken profile reference remain. | Changes require specific approval. |
| Request Updates Categories | Embedded Categories/default-All output remains on both hosts. | Hide only this module through the stable Request Updates builder path. |
| Request Updates form | Book-focused heading/copy remain; workflow behavior is unchanged. | Do not enter form settings without specific workflow approval. |
| Request Updates map/contact | Embedded map, public contact details, and broken profile reference remain. | Changes require specific approval. |
| The Book page | Stock circle, embedded Categories/contact content, broken profile reference, and missing in-page cover remain. | Builder path remains blocked. |
| Journal public output | REI cache still exposes old posts, categories, public contact details, and broken profile reference. | Do not retry hanging cache-clear or builder-delete paths next run. |

## Obstacles And Learned Paths

- Advanced visibility `Never` again removed isolated generic Categories output without invoking module deletion.
- Book Themes published immediately to both hosts with cache misses during QA.
- Public QA confirmed the adjacent contact module by its unchanged module node, without opening its settings.
- Request Updates is the next stable page with the same isolated module defect.
- The Book builder and Journal deletion/cache paths remain known failures.

## Exact Next Objective

Use the stable Request Updates Beaver Builder path to set only its embedded `Categories` module to visibility `Never`, publish, and QA both hosts at desktop and mobile sizes. Do not open or alter the form, embedded map, adjacent contact module, public contact details, or broken profile reference without specific approval. Do not retry The Book or Journal deletion paths.
