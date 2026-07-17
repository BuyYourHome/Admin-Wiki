# Gracious Millionaire Element Map 040

Date: 2026-07-17
Status: Current working map. Supersedes map 039.

## Live Objective Completed

The Books page now presents three image-backed title buttons in a consistent editorial selector. The selector replaces the prior icon-only manuscript-title strip and gives each manuscript a distinct destination.

## Books Page

- Public URL: `https://www.graciousmillionaire.com/about-2/`
- Preview URL: `https://u113450.h.reiblackbook.com/generic6/about-2/`
- New section: `Explore the Books`
- Intro: `Select a title to see the manuscript outline, current public material, and project updates.`
- Layout: three columns on desktop and one column at 720 pixels and below.
- Image treatment: fixed 2:3 display ratio, clipped with `object-fit: cover`, followed by a dark full-width title button.
- The old three-title icon row remains in Beaver Builder but is hidden through page-scoped CSS. Its headings have zero rendered dimensions on the public page.

| Title | Image | Destination |
| --- | --- | --- |
| Gracious Millionaire | Current Wes-and-Jenny moving-forward cover, 1024 x 1536 | `https://www.graciousmillionaire.com/book-outline/` |
| Gracious Millionaire - Drawn by Grace | Jenny-style Drawn by Grace cover, 683 x 1024; WordPress attachment 6388 | `https://www.graciousmillionaire.com/gracious-millionaire-drawn-by-grace/` |
| The L.D. Evans Story | Historical shepherd frame from the Google Photos `Leaving Home - Chapter 5, Shepard Part B.wmv` source, cropped to 241 x 360; WordPress attachment 6389 | `https://www.graciousmillionaire.com/the-l-d-evans-story/` |

The local L.D. Evans crop is private/local working material and must not be committed. Wes authorized its public use for this Books-page objective.

## New Title Pages

- `Gracious Millionaire - Drawn by Grace`: `https://www.graciousmillionaire.com/gracious-millionaire-drawn-by-grace/`
- `The L.D. Evans Story`: `https://www.graciousmillionaire.com/the-l-d-evans-story/`
- Each page includes its selected image, a short manuscript-in-development description, and a `Return to Books` link.
- No manuscript chapter content was published.

## QA

- Production Books page contains exactly one selector, three cards, and three title buttons with the expected destinations.
- All three images render at 327 x 492 pixels in the desktop selector and report `object-fit: cover`.
- The prior icon headings are effectively hidden with zero rendered dimensions.
- At a true 390 x 844 viewport, the selector becomes one 295-pixel column; all button labels fit without clipping and the page has no horizontal overflow.
- Both new title pages render the expected H1, descriptive image alternative text, status copy, and `Return to Books` link.
- Books and both new title pages expose no inherited address or phone output.
- No form, workflow, recipient, notification, contact detail, DNS setting, or manuscript chapter changed.

## Implementation Lesson

In the Beaver Builder HTML module, use a single source block and verify the saved textarea contains one selector before publishing. A failed first replacement left the selector duplicated; selecting all, clearing the module, filling the exact source once, saving, and republishing corrected it. Public-host cardinality checks are required after builder publication.

## Remaining Backlog

1. Select and place a more personal homepage main image when the exact photo is approved for public upload.
2. Design the approved Journal weekly-email signup presentation, but do not activate delivery or recipient workflows without exact approval.
3. Design the Buy Your Home-style contact-form presentation, but do not change routing, recipients, or outbound behavior without exact approval.
4. Continue chapter-publication work only for chapters Wes explicitly approves, with the approved chapters visibly distinguished in the clickable outline.
5. Consider replacing the low-resolution L.D. Evans video frame if a stronger portrait or higher-resolution family image is identified in Google Photos.

Exact next objective: select and place the approved personal homepage image, or define the Journal signup/contact-form delivery specifications before activation.
