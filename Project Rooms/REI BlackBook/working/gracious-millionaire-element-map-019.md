# Gracious Millionaire Element Map 019

Created 2026-07-16 after the stable-page accessibility and heading-hierarchy pass.

Audit targets:

- `https://graciousmillionaire.com/`
- `https://u113450.h.reiblackbook.com/generic6/`
- `https://graciousmillionaire.com/services/`
- `https://u113450.h.reiblackbook.com/generic6/services/`
- `https://graciousmillionaire.com/contact/`
- `https://u113450.h.reiblackbook.com/generic6/contact/`
- `https://graciousmillionaire.com/thank-you/`
- `https://u113450.h.reiblackbook.com/generic6/thank-you/`

## Run Summary

The homepage Book Outline card now uses the approved full-resolution 1024 by 1536 cover instead of the 150-pixel thumbnail. The cover has descriptive alternative text and renders responsively as a portrait cover on desktop and mobile.

Book Themes, Request Book Updates, and Update Request Received now each expose their visible page title as the single H1. The six Book Themes section names were corrected from H6 to H2, removing the page's skipped heading hierarchy.

Both hosts passed desktop QA. Public mobile QA at 390 by 844 showed one H1 per page, no Categories output, no horizontal overflow, and the responsive cover at 335 by 502.5 pixels. Existing forms, maps, contact modules, public details, and workflow settings were not opened or changed.

## Current State

| Surface | Current state | Remaining action |
| --- | --- | --- |
| Home | One H1, full-resolution approved cover with descriptive alt text, hero image, authentic photography, and reader CTAs are live. | Correct the H1-to-H3 section-heading gap and refine cover-card spacing. |
| Book Outline | One H1, full-resolution approved cover, book-project introduction, `Working chapter list` H2, and 25 status links are live. | Retain. |
| Chapter status | One H1, concise editing notice, no manuscript excerpt, and a working return link are live. | Retain. |
| Book Themes | One H1 and six H2 theme sections are live; no H6 headings or Categories output remain. | Retain hierarchy; improve icon/card spacing only if a stable path is useful. |
| Request Updates | `Request Book Updates` is the single H1; form, map, About, and contact content remain live; Categories is hidden. | Keep workflow settings closed; map/contact/profile changes require specific approval. |
| Confirmation | `Update Request Received` is the single H1; book-focused confirmation/About copy remains live; Categories is hidden. | Retain; adjacent contact changes require specific approval. |
| The Book | Stock circle, embedded contact content, broken profile reference, and missing in-page cover remain. | Builder path remains blocked; do not retry without stability evidence. |
| Journal | REI cache still exposes old posts, categories, public contact details, and broken profile reference. | Do not retry hanging cache-clear or builder-delete paths without new evidence. |

## Obstacles And Learned Paths

- Beaver Builder Callout modules expose semantic heading control at `Style` -> `Heading Structure` -> `Heading Tag`.
- The same path corrected the main Callout title and all six theme-section Callout titles without changing visible copy.
- The homepage cover Callout exposes image resolution at `Image` -> `Photo`; changing `Thumbnail - 150 x 150` to `Full Size` published the existing approved asset without a new upload.
- The old media panel did not expose alternative text. The reliable path was the native attachment editor at `wp-admin/post.php?post=6322&action=edit`, using `Alternative Text` and `Update`.
- The multi-page builder sequence timed out once after publishing Themes and Request Updates. Public QA showed those two changes had committed; the confirmation change was then completed in a separate focused builder session.
- Chrome tab finalization timed out twice after QA. No further browser actions were attempted; the next run should start with a fresh browser session and close stale GM tabs before builder work.
- The Book builder and Journal deletion/cache paths remain known failures.

## Exact Next Objective

Start with a fresh Chrome session and close stale GM builder tabs. On the homepage, correct the skipped H1-to-H3 hierarchy by promoting the major section headings to H2 while retaining card titles as H3, then refine the Book Outline cover-card spacing if the stable Callout Style path permits. QA desktop and 390-pixel mobile on both hosts. Do not retry The Book or Journal blocked paths, and do not alter forms, maps, public contact details, profile references, or workflow settings.
