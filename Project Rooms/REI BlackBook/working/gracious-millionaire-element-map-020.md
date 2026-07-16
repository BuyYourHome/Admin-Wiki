# Gracious Millionaire Element Map 020

Created 2026-07-16 after the fresh-session Chrome blocker check. No live website changes were made in this run.

## Run Summary

The run acquired the GM Mode lock and attempted the exact map 019 recovery path: create a fresh Chrome browser-control session, list existing Gracious Millionaire/REI BlackBook tabs, and close stale builder tabs before touching the site.

Chrome timed out before it could return either the controlled-tab list or the user-tab list. Because the browser could not prove which tabs were active, the run did not inspect or edit the live site. This is an escalation from the prior end-of-run tab-finalization timeout: Chrome tab discovery itself is now unavailable.

The last verified public state remains map 019: the homepage uses the full-resolution approved cover with descriptive alt text; Home, Book Themes, Request Updates, and confirmation each have one H1; the six core theme headings are H2; Categories output is absent; desktop and 390-pixel mobile QA passed on both hosts.

## Current State

| Surface | Last verified state | Remaining action |
| --- | --- | --- |
| Home | One H1, full-resolution approved cover with alt text, hero image, authentic photography, and reader CTAs are live. | Correct the H1-to-H3 section-heading gap and refine cover-card spacing after Chrome recovery. |
| Book Outline | One H1, approved cover, `Working chapter list` H2, and 25 status links are live. | Retain. |
| Chapter status | One H1, editing notice, and return link are live. | Retain. |
| Book Themes | One H1 and six H2 theme sections are live; no H6 or Categories output remains. | Retain. |
| Request Updates | One H1; form, map, About, and contact content remain live; Categories is hidden. | Keep workflow settings closed; contact/map changes remain approval-bound. |
| Confirmation | One H1; book-focused confirmation/About copy remains live; Categories is hidden. | Retain. |
| The Book | Known stock/broken content remains. | Builder path remains blocked; do not retry without stability evidence. |
| Journal | Known stale REI cache remains. | Do not retry hanging cache-clear or builder-delete paths without new evidence. |

## Current Blocker

- The previous run's `chrome.tabs.finalize({keep:[]})` timed out twice.
- This run created a fresh Chrome control session, but `chrome.tabs.list()` / `chrome.user.openTabs()` timed out before returning tab state.
- No safe browser tab could be selected or created after that failure.
- Do not retry the homepage builder on the next heartbeat unless Chrome or the Codex Chrome extension has been reset and stale GM builder tabs have been closed, or tab discovery returns normally.

## Exact Next Objective

After Wes resets Chrome or the Codex Chrome extension, confirm that tab discovery works and close stale GM builder tabs. Then correct the homepage H1-to-H3 heading gap by promoting the major section headings to H2 while retaining card titles as H3, refine the Book Outline cover-card spacing through stable Callout controls, and QA both hosts at desktop and 390-pixel mobile. Do not alter forms, maps, public contact details, profile references, workflow settings, The Book, or Journal.
