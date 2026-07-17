# Gracious Millionaire Element Map 023

Created 2026-07-16 after the homepage card-composition pass.

## Live Changes

- Changed the `Book Outline` Callout photo position from `Above Heading` to `Left of Text and Heading` on desktop.
- Retained the approved book cover at full source resolution with no crop; Beaver Builder's responsive rules continue to place it full-width above the copy on mobile.
- Changed the `Request Updates` Callout image crop from `None` to `Landscape` so the two photographic cards use closer visual proportions.
- Retained all copy, destinations, H1/H2/H3 semantics, forms, contact details, and workflow settings.

## Public QA

Both `https://graciousmillionaire.com/` and `https://u113450.h.reiblackbook.com/generic6/` show the revised card composition. At a 1904-pixel desktop viewport, the cover renders at approximately 127 x 190 pixels beside its copy, the middle photo at 313 x 176 pixels, and the updates photo at 313 x 219 pixels. Neither host has horizontal overflow.

At 390 x 844, the cover automatically returns to a 335 x 503 portrait above its copy, the middle photo renders at 335 x 188, and the updates photo renders at 335 x 235. Mobile horizontal overflow is zero.

The cover still uses the approved 1024 x 1536 asset and the alternative text `Gracious Millionaire book cover by Wes and Jenny Browning`. The heading order remains one H1, two section H2s, and three card H3s. The three card destinations remain `/book-outline/`, `/about-2/`, and `/contact/`.

## Remaining Work

- The Book builder remains blocked and Journal public HTML remains stale on the previously documented paths.
- Continue the site-wide design pass on stable pages and shared components without reopening those paths until browser evidence changes.
- Forms, maps, public contact details, workflow settings, manuscript content, and personal-photo uploads remain approval-bound.

## Exact Next Objective

Run a cohesive typography-and-spacing pass across the stable About, Themes, Request Updates, and confirmation pages, standardizing section rhythm and image presentation while preserving forms, maps, contact data, and workflow settings. Do not retry the known Book or Journal failure paths unless the browser state materially changes.
