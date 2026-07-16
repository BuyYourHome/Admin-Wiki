# Gracious Millionaire Element Map 010

Created 2026-07-16 after the WordPress Journal publishing, category, and shared-sidebar cleanup.

Audit targets:

- `https://graciousmillionaire.com/blog/`
- `https://u113450.h.reiblackbook.com/generic6/blog/`
- WordPress Posts, Categories, and Widgets administration for the Gracious Millionaire site

## Run Summary

All six off-topic template posts were changed from published to private through REI Manage Blog. WordPress independently confirmed `All (6)` and `Private (6)`. The posts were preserved rather than deleted.

The generic `Best Tips Ever` and `Success Stories` categories were deleted. The default `All` category remains. The shared WordPress `Recent Posts` and `Categories` widgets were removed from the Primary Sidebar, leaving that sidebar empty.

Public QA did not yet reflect those backend changes. Both hosts continued to return cached Journal HTML containing the six posts and generic sidebar content, with `X-Pj-Cache-Status: hit`. The prior REI cache-clear path is known to hang, so it was not repeated.

The Journal Beaver Builder loaded successfully, which is new evidence that the builder failure is page-specific rather than universal. However, confirming deletion of the stock post-grid module stalled the Chrome control session. No builder publish occurred, so no layout change from that attempt is claimed.

No forms were submitted and no lead routing, outbound workflow, public contact detail, DNS, purchase, manuscript, or messaging action was changed.

## Current State

| Surface | Current state | Remaining action |
| --- | --- | --- |
| WordPress posts | Six generic template posts are private and preserved. | Verify their disappearance after REI page-cache propagation. |
| Categories | Only the default `All` category remains. | Rename only when real Journal taxonomy is ready. |
| Shared Primary Sidebar | No active widgets remain. | Verify public effect after cache propagation. |
| Journal page layout | Cached public HTML still shows stock post cards, generic `About Us`, `Blog`, `Categories`, and `Contact Us` modules. | Do not retry the same builder deletion-confirmation path next run without a Chrome reset or new stability evidence. |
| Public privacy/contact block | Journal publicly exposes a street address, phone, email, and broken `[profile_image_url]` placeholder. | Requires Wes's specific approval before removing or changing public contact details. |
| Shared header/navigation | Approved logo and `Home`, `The Book`, `Themes`, `Journal`, `Updates` remain live. | Retain. |
| The Book | Stock circle, broken profile placeholder, and missing cover remain. | Builder path remains blocked; do not retry next run without new stability evidence. |

## Obstacles And Learned Paths

- REI Manage Blog publish toggles are a stable, reversible way to remove template posts from the public publishing state. Verify the resulting status in native WordPress Posts.
- Native WordPress Categories and Widgets routes are stable for taxonomy and shared-sidebar cleanup.
- The public Journal is served through an REI page cache independent of WordPress save confirmation. Public HTML and `X-Pj-Cache-Status` must be checked before reporting propagation.
- Journal Beaver Builder can load even while The Book builder remains unavailable, but module-delete confirmation currently stalls the Chrome control session. Do not repeat that path on the next heartbeat.
- The Journal's `About Us`, `Blog`, `Categories`, and `Contact Us` blocks are Beaver Builder widget modules embedded in page ID `1791`, not the shared WordPress Primary Sidebar.

## Exact Next Objective

Run read-only public QA for Journal cache propagation. If the private posts and removed shared widgets have propagated, document the visible reduction and select a different stable page objective. If cached template content remains, do not use the known hanging cache-clear or builder-delete paths; make a coherent Request Updates form-presentation audit/change that does not alter routing, recipients, autoresponders, public contact details, or outbound behavior. Separately request Wes's approval to remove the Journal contact/address block and broken profile placeholder.
