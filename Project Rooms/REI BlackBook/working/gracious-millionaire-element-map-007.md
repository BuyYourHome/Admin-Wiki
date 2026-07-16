# Gracious Millionaire Element Map 007

Created 2026-07-16 after the shared header/navigation GM Mode pass.

Audit targets:

- `https://www.graciousmillionaire.com/`
- `https://u113450.h.reiblackbook.com/generic6/`

## Run Summary

Live WordPress menu changes completed:

- Reordered and renamed the shared menu to `Home`, `The Book`, `Themes`, `Journal`, `Updates`.
- Kept the destinations on the current live pages: `/`, `/about-2/`, `/services/`, `/blog/`, and `/contact/`.
- Confirmed the menu remains assigned to Top Bar, Header, and Footer locations.

QA results:

- The REI preview serves the new labels and order.
- Desktop preview at 1280px had no horizontal overflow.
- Mobile preview at 390x844 collapsed the navigation, displayed the menu toggle, and had no horizontal overflow.
- The visible Gracious Millionaire header logo remains active.
- The public custom domain still served the previous menu after the WordPress save. The REI cache-clear confirmation hung in the authenticated control panel, so public-domain propagation is not yet verified.
- The header `data-retina` attribute still references the generic REI BlackBook retina logo.

No forms were submitted and no lead routing, outbound workflow, public contact detail, DNS, purchase, manuscript, or messaging action was changed.

## Current Global State

| Element | Current state | Remaining action |
| --- | --- | --- |
| Shared menu in WordPress/REI preview | `Home`, `The Book`, `Themes`, `Journal`, `Updates`, in that order. | Verify the same menu on the public custom domain after cache propagation. |
| Menu destinations | `/`, `/about-2/`, `/services/`, `/blog/`, `/contact/`. | Keep until dedicated Our Story/Contact pages are approved and built. |
| Visible header logo | Correct Gracious Millionaire logo. | Retain. |
| Retina logo | Still points to `generic-logo-2-retina.png`. | Replace or remove through the advanced theme/header customizer when stable. |
| Responsive header | Preview passes at 1280px and 390x844; mobile toggle appears and navigation collapses. | Recheck public custom domain after cache propagation. |
| Homepage imagery | Approved hero photo, book cover, Wes/Jenny image, and faith-notes image are live. | Rebalance the vertical cover card and fix its link to `/about-2/`. |
| Footer/sidebar/blog widgets | Generic footer copyright, blog posts, categories, and two About widgets remain. | Replace or remove in later coherent passes. |
| Request form | Existing fields and `GET STARTED >>` presentation remain. | Improve presentation only; do not alter routing or outbound automation without explicit approval. |

## Obstacles

- REI/WordPress serves the new menu immediately on the preview URL while the custom domain can retain an older cached header.
- The `Clear Website Cache` control opens a confirmation dialog that hung the Chrome control session instead of completing cleanly.
- The visible logo and retina logo are separate theme settings. The basic theme screen exposes the visible logo but not the stale retina reference.
- Beaver Builder remains a separate, slower path for page modules and should not be used for shared-menu work.

## Exact Next Objective

Redesign the `The Book` page around the approved book cover: establish a cover-led editorial first viewport, replace remaining generic imagery/copy on that page, correct its calls to action and internal links, and QA desktop/mobile without publishing manuscript chapter text.
