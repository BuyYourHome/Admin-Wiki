# Voice quiet cutoff, hover and Contact — 2026-10-27

## Authority and observed result

This follow-up began at `2026-10-27T21:58:12Z`. Wes confirmed version 68 speaks, but reported that it stayed at Voice on while quiet. He then confirmed the three-minute-ended message. Native request `aca140ab-2ec7-4b15-bdab-1ecd886f7fb7`, created `2026-10-27T21:55:25.382Z`, closed with 179 seconds of provider-confirmed usage. This verifies speech and the old duration ceiling, not a successful quiet cutoff.

Wes explicitly chose **only a 30-second silence timeout, with no three-minute cutoff during an active conversation**. He subsequently requested hover activation, a different live-header background, the live-only tagline **A home You can Relate to - I'm listening!**, Contact last in the menu, Contact sections for GC/plumber/HVAC, and a working spoken virtual-tour command.

GPT-Live bills active session duration by the second, including quiet time. The documented initialization charge is credited against a running session rather than added again. No billing setting changed. Reference: [OpenAI voice cost guide](https://developers.openai.com/api/docs/guides/voice-latency-cost).

## Published behavior

- Natural voice measures current microphone and remote-stream PCM in a browser-only Web Audio graph. A long analyser window covers polling intervals, and short RMS blocks detect brief speech without dilution. Buffers are cleared after each read; no samples are saved or uploaded by this meter. Browser-reported latched audio levels are no longer accepted as fresh evidence when counters stop advancing.
- The visible status shows speaking, hearing sound, thinking or a quiet countdown. Real audio and typing reset quiet time. Bounded server-work hints remain; redundant inactive hints do not reset the deadline. Thirty seconds of measurable quiet stops capture/playback and requests session closure. Missing measurement is never counted as silence; a persistently unavailable meter stops with an explicit health-error message. Setup, disconnect and finalization handling remain.
- Both application-level 180-second cutoffs are removed. An active conversation can continue while the connection is healthy. Server expiry bookkeeping now represents the setup deadline only; state-based active/uncertain fences, cooldown, global/browser start limits and usage recording remain. No schema migration or old-row release was added.
- A 500ms logo hover starts the selected voice once; leaving or clicking cancels the pending hover. A stationary pointer does not restart a timed-out conversation. Click/tap still toggles voice and keyboard focus only animates. Browser playback readiness is checked before microphone acquisition and paid-session creation; blocked playback asks for a click. Late readiness cannot resurrect a stopped attempt.
- Actual live voice changes the opaque header background and exact active tagline; connecting keeps the inactive wording. A separate announcement avoids reading every countdown tick to screen readers.
- Menu order is Design, Explore, View, Belong, Built By, Contact. View remains default and Own/Manage aliases remain. Contact has General contractor, Plumber and HVAC sections; Wes subsequently supplied the names and official websites recorded below.
- Explicit virtual-tour requests create a validated View/tour action and start the existing tour once. Ordinary View navigation does not start it. Starting the tour ends voice through the existing path. Native fullscreen and soundtrack remain subject to browser controls and existing fallback behavior.

## Verification and publication

PCM, server/real-SQLite, guide/context, Contact navigation/hover and client lifecycle regressions cover the changed behavior. These include continuing active conversation past ten minutes, measured quiet cutoff, unavailable-measurement cleanup, initial muted remote tracks, brief speech, missed sample intervals, playback denial before capture, cancellation, one-shot tour and invalid action rejection. Contact static rendering preserves the hidden guide and shows all three pending trade sections. Independent review identified the short analyser-window gap; it was corrected before publication.

The initial saved-only build passed its 179-file secret scan. The final complete update passed TypeScript, focused lifecycle/intent/guide/navigation/asset checks, Contact static rendering, the production build, diff checks and the 183-file secret scan. Mock checks do not prove audible navigation or the actual 30-second shutdown. No provider voice session or microphone was initiated by Codex.

## Additional authorized content and shutdown behavior

Wes added explicit farewell shutdown. Completed user phrases such as goodbye, goodbye for now, bye, we are done and stop listening close voice locally, with a text acknowledgement and the existing finalization drain. Polite framing is accepted, while generic thanks, quoted/negated farewells, questions about the word and longer requests are excluded. Natural input uses the existing 350ms caption debounce, not a newly invented provider event; manual/farewell flushing cannot recurse. Browser wake mode accepts a clear farewell without requiring Pondster's name. Focused intent, natural/browser lifecycle and actual Guide function checks passed.

Wes supplied new barn-door-stain wide and close-up deck renderings from the Rendering room. They replace the public views while retaining choice ID oak-courtyard, one choice, two views, existing votes and the wide tour/Explore primary. Visible title is Barn door stain. New public filenames avoid stale image caches. Original PNG bytes and provenance are preserved; both images were visually inspected, with no visible private address and no private source paths in printable metadata.

- Wide source: `C:\Users\wesbr\.codex\visualizations\2026\10\26\01a178f1-8292-7aa3-863d-f6de8a3c44f7\deck-stain\908-Pond-Deck-Wide-Barn-Door-Stain-v1.png`; SHA256 `51de8ada81599176c12ac4199a9b9ccb968521d771c36aed0713e7ced3255016`, 1671x941.
- Close-up source: same deck-stain directory, `908-Pond-Deck-Closeup-Barn-Door-Stain-v1.png`; SHA256 `59679e3d08347a43c863ad9612c8c836ee13c300af03d803fcb03ba75fdf22d0`, 1791x878.
- Public paths: `/images/deck/barn-door-stain-wide.png` and `/images/deck/barn-door-stain-closeup.png`. The old assets remain recoverable. Design-view and tour checks passed with 31 total choices and one deck scene.

Wes explicitly chose Belong for the two-page preliminary structural PDF. The public copy at `/documents/deck-structural-preliminary.pdf` removes the exact address prefix from both footer text operands and resets address-bearing metadata, using a fresh writer rather than visual overlays. All 14 decoded objects/streams and serialized bytes passed private-address/path scans. Poppler visual and pixel checks found differences only in the two footer regions, with structural/dimensional content unchanged. Preliminary labels and four public code-reference links remain. The original is unchanged outside Git; no binary is mirrored into Admin Wiki Git.

- Source: `C:\Users\wesbr\.codex\visualizations\2026\10\26\01a178f1-8292-7aa3-863d-f6de8a3c44f7\deck-structure\908-Pond-Deck-Structural-Basis-v1.pdf`; SHA256 `b00f7c492ce84726012154d25bcd97dcd1654bb837ce4b52cfb59e0fd9cb5b71`.
- Public sanitized PDF SHA256: `1e9ef4e7c62d3c5d6ef1d1a410b51194070bca300c14afec16fcd9491f90cf94`. The required PDF edit marker ran once. Belong identifies it as a preliminary design reference; it is not represented as an approved construction document.

Wes supplied the selected trade identities and requested website lookup. Primary official pages and public HTTP checks verified [Glasgow Design Build](https://glasgowdb.com/), [True Service](https://www.trueserviceinc.com/) and [Executive Plumbing Company](https://www.executiveplumbingcompany.com/). Contact now lists their names, roles and website links, replacing placeholders. Their project roles come from Wes; no license, guarantee, pricing or equipment claim was inferred. Pondster's guide and voice context also know these public contacts and the preliminary Belong drawing. Existing private-address and specification gates remain.

Version 69 was saved from source b353df8261a092ac478b0033ce733a12d5ae02ec but was not deployed; these subsequent user additions are included in the next publication. No public release or fresh voice trial is inferred from that saved-only version.

## Final release — version 70

- Source: `6036d1ee845e84caa286f8ec4219628a3d1fd84c`.
- Saved version: `appgprj_6ad4d98e08708191858cab113814704e~appgver_f0435ba8e70c8191a61f9a023733d240`.
- Deployment: `appgdep_6ae128a636408191908ea0864771a9a6`, succeeded `2026-10-27T22:41:54.602454+00:00`, environment revision **4**.
- Archive: `sha256:90798bbc985d78d0c48c1e85737ae90d4ef251a95f260ed7e309eb96353f3179`, 128 files, 66,406,400 bytes.

Public https://pondstr.com returned HTTP 200 with the exact six-menu order and all three official trade links. Ordinary anonymous voice admission was available with HTTP 200; no provider metadata prerequisite was reintroduced. Both new deck PNGs and the sanitized PDF returned HTTP 200 with correct MIME types and exact source/verified-public SHA256 matches. The served PDF is 31,384 bytes. Opening the public page in Codex returned queued, which is not browser visual proof.

Wes was asked to end any old conversation, refresh Chrome, hover or click if requested, then remain quiet with the pointer still for about 35 seconds. The real version 70 hover/greeting/countdown shutdown and spoken tour/farewell results are pending. No automatic microphone or paid voice test was run by Codex. Preserve this distinction until the user result and native session finalization are checked.

A later response selected the successful-countdown option, but Wes then clarified that he was not aware of a test. Do not count that selection as completed live verification. Native reads through `2026-10-27T22:47:05Z` showed no new public session after version70 publication; the latest recorded start was `22:30:32.443Z`. No service-side closure or billing-stop proof is inferred for a version70 trial. The published implementation and passing code/asset/PDF checks remain verified; actual voice behavior remains unverified.
