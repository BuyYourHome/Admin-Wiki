# Gracious Millionaire Element Map 025

Created 2026-07-17 after the completed About-page design and accessibility pass.

## Live Changes

- Promoted `About Gracious Millionaire` from H2 to the page's single H1.
- Promoted `A Faith-Centered Story`, `Wes and Jenny's Reflections`, and `Stories Still Being Edited` from H3 to parallel H2 headings.
- Replaced the generic circular `WebStockGen1200054` image with the already uploaded and approved `wes-jenny-building.jpg` attachment `6344`.
- Changed the replacement image to the 1024 by 576 landscape rendition.
- Added `Wes and Jenny Browning building the Gracious Millionaire book project` as the attachment alternative text and republished the module so both hosts render it.
- Hid the About-page Categories widget with the reversible Advanced visibility value `Never`.
- Left the public contact widget, address, phone, email, profile placeholder, forms, maps, and workflow settings unchanged.

## Public QA

Both `https://u113450.h.reiblackbook.com/generic6/about-2/` and `https://www.graciousmillionaire.com/about-2/` now show:

- one H1 for `About Gracious Millionaire`;
- the three feature headings as H2;
- no visible Categories or default-All output;
- the approved Wes-and-Jenny landscape image instead of the generic stock circle;
- the descriptive image alternative text;
- no desktop horizontal overflow.

Chrome disconnected when the temporary 390 by 844 viewport was being applied. Mobile QA was not rerun in this pass and remains the first verification step for the next stable browser session.

## Remaining Work

- Run 390-pixel mobile QA on the About page without reopening its builder unless a defect is found.
- Decide whether `Follow the book's progress` should remain H3 or become an H2 section heading after visual mobile review.
- The Book builder and Journal cache paths remain blocked/stale on their documented paths.
- The public contact widget, address, phone, email, broken profile placeholder, forms, maps, and workflow settings remain approval-bound.

## Exact Next Objective

Start with read-only 390-pixel About QA. If it passes, choose a stable native WordPress or theme surface that does not touch contact/workflow settings; do not retry the blocked Book or Journal paths without new stability evidence.
