# Gracious Millionaire Element Map 009

Created 2026-07-16 after the shared retina-logo correction and one clean The Book editor retry.

Audit targets:

- `https://graciousmillionaire.com/`
- `https://u113450.h.reiblackbook.com/generic6/`
- `https://graciousmillionaire.com/about-2/`

## Run Summary

The stale global retina-logo override was removed through Advanced Theme Customizer > Header > Header Logo and published. Both public hosts now return the approved `gracious-millionaire-logo-header-2026-07-09.png` as the header image with `data-retina=""`; the generic `generic-logo-2-retina.png` reference is absent.

One clean Beaver Builder retry for The Book at `/about-2/?fl_builder` still produced an empty editor surface. No second content-editor attempt was made. The page's stock circle, broken profile placeholder, and missing cover therefore remain.

No forms were submitted and no lead routing, outbound workflow, public contact detail, DNS, purchase, manuscript, or messaging action was changed.

## Current Public State

| Surface | Current state | Remaining action |
| --- | --- | --- |
| Shared header | Approved Gracious Millionaire header logo is active; the obsolete retina override is empty on both hosts. | Retain and verify during later responsive passes. |
| Shared navigation | `Home`, `The Book`, `Themes`, `Journal`, `Updates` is live on both hosts. | Retain until dedicated Our Story/Contact destinations are built. |
| Home | Book-focused hero photography and the approved cover are live. | Rebalance the cover card and correct its destination when the builder is stable. |
| The Book `/about-2/` | Book-focused copy remains, but the page still contains `WebStockGen1200054-300x200-circle.jpg`, a broken `https://[profile_image_url]` placeholder, and no book cover. | Do not retry the same builder path next run without a Chrome reset or new stability evidence. |
| Footer | Public output remains `Copyright 2026 Gracious Millionaire. All rights reserved.` | Locate the managed footer source only when stronger editorial copy is ready. |
| Journal/blog/sidebar | Generic posts, categories, and About widgets remain. | Use stable WordPress/blog/theme routes for the next coherent cleanup pass. |
| Request form | Existing fields and presentation remain; workflow was not touched. | Improve presentation only unless Wes separately approves routing or outbound changes. |

## Obstacles And Learned Paths

- A clean-tab Beaver Builder retry did not load The Book, confirming the failure is not only stale-tab accumulation.
- Do not retry `/about-2/?fl_builder` on the next heartbeat unless Chrome has been reset or there is direct evidence that Beaver Builder is stable again.
- The stable retina-logo route is REI Theme control panel > Advanced Options > Customizer > Header > Header Logo. Remove only the Retina image, retain the Regular image, publish, and verify public HTML.
- Customizer save confirmation is insufficient by itself. Both hosts must be checked for the removed asset and the active regular logo.

## Exact Next Objective

Clean the Journal/blog/sidebar experience through stable WordPress or theme-management routes: remove or repurpose generic posts, categories, and About widgets; preserve book-focused material; publish one coherent reader-facing Journal pass; and QA both hosts. Avoid The Book builder on that run unless Chrome has been reset or the editor is demonstrably stable.
