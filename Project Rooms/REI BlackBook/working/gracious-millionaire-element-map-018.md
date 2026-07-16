# Gracious Millionaire Element Map 018

Created 2026-07-16 after the Book Outline and chapter-status reader-journey refinement.

Audit targets:

- `https://graciousmillionaire.com/book-outline/`
- `https://u113450.h.reiblackbook.com/generic6/book-outline/`
- `https://graciousmillionaire.com/chapter-being-edited/`
- `https://u113450.h.reiblackbook.com/generic6/chapter-being-edited/`

## Run Summary

The Book Outline now uses the approved full-resolution Gracious Millionaire cover as its first content visual, centered at 320 by 480 pixels with descriptive alt text. The page keeps its 25 working chapter links, adds a `Working chapter list` subheading, and no longer repeats a second H1 inside the body.

The shared chapter-status page no longer repeats its H1. Its status sentence has clearer emphasis and its return link remains visible and routes to the outline.

Both public hosts returned HTTP 200. Each page has exactly one H1, the outline has all 25 chapter links, the full-resolution cover renders at the intended size, the status return link works, Categories output remains absent, and desktop QA found no horizontal overflow. No manuscript chapter text, forms, workflows, recipients, public contact details, DNS, purchases, or outbound messages were changed.

## Current State

| Surface | Current state | Remaining action |
| --- | --- | --- |
| Home | Approved cover, hero image, authentic photography, and reader CTAs are live. | Audit cover alt text and top-section typography when the builder is stable. |
| Book Outline | One H1, full-resolution approved cover, book-project introduction, `Working chapter list` H2, and 25 status links are live. | Retain and include in future responsive audits. |
| Chapter status | One H1, concise editing notice, no manuscript excerpt, and a working return link are live. | Retain. |
| Book Themes | Book-focused body and About block are live; Categories is hidden. | Improve heading semantics/spacing without entering contact settings. |
| Request Updates | Book-focused heading/copy and form remain live; Categories is hidden. | Keep workflow settings closed; map/contact/profile changes require specific approval. |
| Confirmation | Book-focused confirmation/About copy is live; Categories is hidden. | Improve heading semantics/spacing without touching adjacent contact content. |
| The Book | Stock circle, embedded contact content, broken profile reference, and missing in-page cover remain. | Builder path remains blocked; do not retry without stability evidence. |
| Journal | REI cache still exposes old posts, categories, public contact details, and broken profile reference. | Do not retry hanging cache-clear or builder-delete paths without new evidence. |

## Obstacles And Learned Paths

- Standard WordPress pages can be edited reliably through `wp-admin/post.php?post=<id>&action=edit` when the Beaver Builder page is not involved.
- Use the classic editor Text mode, preserve the existing body/list, publish with `Update`, and verify both public hosts.
- REI/WordPress stripped flex and image inline-sizing declarations from the first cover layout. The first QA screenshot exposed an oversized cover before the run ended.
- Native `width` and `height` attributes plus the theme-supported `aligncenter` class produced a stable 320 by 480 cover on both hosts.
- The outline currently uses WordPress page ID `6144`; the shared chapter-status page uses ID `6142`.
- The Book builder and Journal deletion/cache paths remain known failures.

## Exact Next Objective

Audit the Home cover alt text and the Book Themes, Request Updates, and confirmation top sections as one semantic-heading and spacing pass. Add or correct H1/H2 structure where the stable builder path permits, keep the approved cover and photography, and leave all forms, map/contact modules, public details, and profile references untouched. Do not retry The Book or Journal blocked paths without new stability evidence.
