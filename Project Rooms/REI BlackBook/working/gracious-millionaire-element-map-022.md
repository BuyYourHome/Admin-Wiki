# Gracious Millionaire Element Map 022

Created 2026-07-16 after the homepage semantic-hierarchy pass.

## Live Changes

- Changed `Follow the Gracious Millionaire Book Project` from H3 to H2 through the Heading module `Style` -> `Structure` -> `HTML Tag` control.
- Changed `Want updates as the book develops?` from H3 to H2 through the Call to Action module `Style` -> `Heading Structure` -> `Heading Tag` control.
- Retained the homepage H1 and the three card titles (`Book Outline`, `About the Book`, and `Request Updates`) as H3.
- Retained all homepage copy, destinations, images, form boundaries, and the full-resolution approved cover.

## Public QA

Both `https://graciousmillionaire.com/` and `https://u113450.h.reiblackbook.com/generic6/` render this order:

1. H1 `Gracious Millionaire`
2. H2 `Follow the Gracious Millionaire Book Project`
3. H3 `Book Outline`
4. H3 `About the Book`
5. H3 `Request Updates`
6. H2 `Want updates as the book develops?`

The cover renders from the approved 1024 x 1536 asset with descriptive alternative text. Desktop QA found no horizontal overflow on either host. The custom-domain homepage also passed 390-pixel mobile QA with all headings constrained to the content width and no horizontal overflow.

## Remaining Work

- Refine the portrait cover card's visual spacing without reducing cover quality or disturbing the other two cards.
- The Book and Journal remain on their previously documented blocked/stale paths.
- Forms, maps, public contact details, workflow settings, manuscript content, and personal-photo uploads remain approval-bound.

## Exact Next Objective

Use a stable Callout/column spacing path to balance the homepage cover card against the two landscape-image cards, then QA the three-card composition at desktop and mobile. If that path is unstable, choose a different shared visual cleanup and do not retry known Book or Journal failure paths.
