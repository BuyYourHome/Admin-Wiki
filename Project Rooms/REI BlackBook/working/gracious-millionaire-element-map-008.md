# Gracious Millionaire Element Map 008

Created 2026-07-16 after the The Book editing-path investigation and shared-footer audit.

Audit targets:

- `https://graciousmillionaire.com/`
- `https://u113450.h.reiblackbook.com/generic6/`
- `https://graciousmillionaire.com/about-2/`
- `https://u113450.h.reiblackbook.com/generic6/about-2/`

## Run Summary

Public QA confirmed that the navigation change from map 007 has propagated to both hosts. The shared sequence is now `Home`, `The Book`, `Themes`, `Journal`, `Updates` on the REI preview and public custom domain.

The planned cover-led redesign of The Book page was not completed. Both available page-editing paths timed out before an editable page loaded:

- Beaver Builder at `/about-2/?fl_builder` timed out after 30 seconds.
- The direct WordPress post editor for page ID `1765` timed out after 30 seconds.

The Advanced Theme Customizer remained responsive. Its Footer Layout setting was changed from the obsolete 2015 copyright text to `Gracious Millionaire | A book by Wes and Jenny Browning.` and reported `Saved`. Public QA did not render that saved value. Both public hosts continue to render the separate managed-theme footer value `Copyright 2026 Gracious Millionaire. All rights reserved.` Treat the Customizer field as overridden, not as proof of a public-visible footer change.

No forms were submitted and no lead routing, outbound workflow, public contact detail, DNS, purchase, manuscript, or messaging action was changed.

## Current Public State

| Surface | Current state | Remaining action |
| --- | --- | --- |
| Shared navigation | Both public hosts serve `Home`, `The Book`, `Themes`, `Journal`, `Updates`. | Retain until dedicated Our Story/Contact destinations are built. |
| Home | Book-focused hero copy, approved photography, and the approved book cover are live. | Rebalance the cover card and correct its destination where needed. |
| The Book `/about-2/` | Title is `About the Book - Gracious Millionaire`; copy is book-focused but the page still contains `WebStockGen1200054-300x200-circle.jpg`, a broken `https://[profile_image_url]` placeholder, and no book cover. | Replace the first viewport with the approved cover, remove both generic/broken images, tighten copy and links, and QA desktop/mobile. |
| Footer | Public output is `Copyright 2026 Gracious Millionaire. All rights reserved.` The Advanced Customizer stores different text that is not rendered. | Locate the managed footer source only when a stronger editorial footer is ready; do not rely on Customizer save status. |
| Retina logo | Header still references the generic REI BlackBook retina asset. | Replace or remove through a stable advanced header path. |
| Journal/blog/sidebar | Generic posts, categories, and About widgets remain. | Redesign or remove in later coherent passes. |
| Request form | Existing fields and presentation remain; workflow was not touched. | Improve presentation only unless Wes separately approves routing or outbound changes. |

## Obstacles And Learned Paths

- The authenticated session is valid and REI control-panel/theme surfaces are stable, but both content-editor routes for page ID `1765` currently hang.
- The REI Manage Pages route loaded its shell but did not populate the page list, indicating another unstable AJAX path rather than an authentication failure.
- Advanced Theme Customizer fields require real keyboard input plus blur to trigger the dirty state; programmatic field replacement alone did not enable `Save & Publish`.
- A Customizer `Saved` state verifies only the stored setting. Public HTML verification is required because the REI managed theme can render a different override.
- The public custom-domain menu cache has now caught up without another cache-clear attempt.

## Exact Next Objective

Reset the Chrome editing environment by closing stale Gracious Millionaire builder/editor tabs or restarting Chrome, then retry The Book page ID `1765` through one content-editor path only. Build a cover-led first viewport using approved media attachment `6319`, remove the stock circle and broken profile placeholder, correct internal calls to action, publish, and QA both hosts at desktop and mobile sizes. If the first clean editor attempt still times out, stop repeating that path and complete a coherent stable-surface objective such as the retina-logo correction or Journal/sidebar cleanup.
