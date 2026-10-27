# Logo voice-start diagnosis and fix — 2026-10-27

## Evidence and scope

Focused diagnosis resumed at `2026-10-27T21:03:26Z` after Wes corrected his earlier successful-test report and said clicking the logo produced no answer. Read-only voice records showed four closed, provider-confirmed conversations from the same browser within 24 hours, no active conversation for that browser and no new provider start following version 66. Recent request logs showed repeated voice-status checks without voice-control calls. The former four-start browser cap explained the blocked start; anonymous status availability did not establish availability for this browser. No new screenshot was available to inspect, and the diagnosis does not rely on an unseen image.

## Change

- The browser allowance is now 20 starts per rolling 24 hours, within the unchanged global limit of 20. Both the atomic reservation and read-only admission query use the same constants and predicates.
- Fixed public messages distinguish a rolling daily limit, the existing 60-second cooldown, active conversation, pending/service check and unavailable session records. These expose no visitor identity, cookie, raw exception or private count.
- After an explicit start, the header preserves the controller's actual denial, failure or stop message, compacting long feedback while Contact retains the full message.
- Global concurrency two, one active conversation per browser, uncertain-session fences, the three-minute ceiling, quiet monitoring, provider permissions, keys and billing are unchanged. No stored row or browser cookie was reset.

## Verification and release

Worker/server mocks and real-SQLite admission/reservation equivalence passed, including four closed attempts followed by an allowed fifth, 19/20 boundaries, cooldown, concurrency, unknown outcomes and malformed/database failure cases. Independent source review found no concrete concern. TypeScript, production build, diff checks and the 178-file secret scan passed.

- Source: `35a5efbbeaecb32961ab458a799da7e578b70845`.
- Saved version: `appgprj_6ad4d98e08708191858cab113814704e~appgver_065619cee52881919074e7eb007f0b77`, version **67**.
- Deployment: `appgdep_6ae1147e0fd0819188bd228ef9b928cb`, succeeded `2026-10-27T21:15:51.374288+00:00`, environment revision **4**.
- Archive: `sha256:c4759a140a332241a2170c795feda930230a823ac154bc442140752c47ad2946`, 125 files, 60,497,920 bytes.

The custom-domain homepage and anonymous voice-status endpoint returned HTTP 200; Contact and the exact tagline remain present. Opening the public page in Codex returned queued. Codex made no provider voice call, microphone capture or production vote/comment write.

## Fresh spoken confirmation

Wes supplied a screenshot showing the initial inactive line, then confirmed after refreshing and clicking the signature: **Pondster now speaks**. The screenshot itself showed no denied attempt. Narrow source review found no persistent handler, mounting or decorative-overlay defect, so no additional website change was made.

The new request `e3d34401-b6a5-4a67-b0a1-3ff79853bf14`, created `2026-10-27T21:19:37.935Z`, has a provider ID, state `closed`, `usage_seconds=23` and `final_usage_confirmed=1`. User confirmation establishes audible speech after the refreshed logo click; the native record establishes clean finalization for that trial. A 23-second completed trial does not prove the 30-second quiet timer. That separate test remains pending, and Wes was asked to keep the page visible and quiet after Pondster finishes speaking.
