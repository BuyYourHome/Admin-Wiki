# Spoken gallery voting, enlargement and restart — 2026-10-28

## Authority and observed behavior

After version 79, Wes confirmed spoken Next/Previous worked and clarified that enlargement and voting were not voice controlled. He also reported that voice would not reactivate after goodbye and showed the explicit microphone-off status. These are ordinary authorized website corrections; no change to audience, API credentials, voice/model, pricing or home devices is included.

## Changes

- Explicit commands such as “enlarge this picture,” “make it bigger,” and “zoom in” open/maximize the current gallery image. Enlargement preserves its current alternate view and voting ID. Enlarge/Restore size and Close remain available on screen. This is a full-window website viewer, not a browser fullscreen permission request.
- “Vote for this one,” “record my vote for this picture,” and “change my vote to this one” submit the picture actually open in the viewer through the existing voting endpoint. A casual preference, negated request, question about voting, arbitrary design ID or unopened image cannot cast a guessed vote. Unresolved named preferences open their gallery and explain how to select a picture.
- Natural voice waits for a correlated browser result before announcing a saved vote. Result messages allow only known statuses and public design titles. Duplicate actions/results are ignored, missing results expire after ten seconds, failures are not reported as success, and only a response confirming the selected ID counts as saved. Browser voice and typed answers use the same actual result. No extra approval dialog is added for an explicit current-picture vote request.
- A click immediately following a hover start no longer toggles a connecting voice session off. A subsequent deliberate click can still stop. Goodbye stops capture/playback; an explicit restart acquires a fresh microphone, and late closure of the old call cannot stop the new one. No automatic paid restart is introduced. The hover/click sequence is a plausible explanation of the reported status, not established proof of the exact user gesture.
- The browser revision changes with this action protocol; stale pages must refresh before paid startup. Voice remains Vesper, the quiet timeout remains 30 seconds, and the rolling allowance remains 100 starts.

## Recording verification

An owner-only production check after the successful gallery test found one completed natural conversation at the test time with nonempty visitor and Pondster text. The first bounded event page contained both roles; further text was not needed for this verification. Its voice session was closed. This establishes that text capture worked for that test call, without claiming complete reconstruction or universal future reliability. No transcript text, visitor name, cookie, private record ID or raw log is copied into Git. Earlier unsaved calls are not recovered.

## Validation and publication

Focused tests exercise real page handlers and vote endpoint outcomes with mocked responses, explicit and rejected phrases, preserved alternate-view identity, stale/unopened/same-choice guards, delayed/duplicate/failed/missing vote results, actual logo hover/click handlers, and goodbye/restart with late old-session events. Existing routing, voice lifecycle, quiet timeout, visitor-history and component checks remain applicable. Browser infrastructure has not provided a fresh visual/microphone trial; tests use no real microphone, live vote write or paid provider call.

Version **80** published successfully at `2026-10-28T15:25:43.497670+00:00`. Source `190e1d4f0e62756d8d5818ca4bb77ed36cc2bc6b`; saved version `appgprj_6ad4d98e08708191858cab113814704e~appgver_dd5eed332c7881919e0d4b8a1e838ab2`; deployment `appgdep_6ae213eb9d848191b99282c95841b0cd`; environment revision 4, public audience. Archive `sha256:43697dc84dac67dfa293c750a693586d0cc9063688b9ab345732b460e13c2895`, 136 files / 74,076,160 bytes. Build, focused checks and secret scan passed. The later site-wide control and logo work is recorded separately in [[site-wide-voice-controls-and-logo-20261028]].
