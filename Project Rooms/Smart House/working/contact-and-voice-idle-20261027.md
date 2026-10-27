# Contact, voice-only logo and silence timeout — 2026-10-27

## Authority and prepared behavior

This request began at `2026-10-27T20:33:59Z` in the owning Smart House chat. Wes requested that a conversation end after 30 seconds of silence, then directed that the logo start/stop voice without opening a dialog. He requested a Contact menu destination for voice/text conversation and existing public contact information, asked about voice navigation, and specified the exact tagline **A Home You can Relate to. Talk to me!**

- The logo explicitly starts or stops the selected voice mode without automatically opening Contact. Header states reflect voice activity. Escape and entering the tour stop voice. Hover and ordinary page navigation do not start capture or audio.
- Contact contains the voice/text dialog and existing public contact links. The guide child remains mounted when hidden, allowing voice to run without an open dialog. This does not remove explicit stop, Escape, tour or cleanup behavior.
- Menu order is **Design, Explore, View, Belong, Contact, Built By**, keeping Built By last. View remains the default; historical Own/Manage aliases still open Belong. Public voice navigation supports the six destinations while retaining internal Own compatibility.
- Contact comments reuse the existing public-comment path and storage with an allowed Contact page key; no database migration was added. Public context also corrects the tour count to seven scenes.
- Vesper and the short trusted greeting remain unchanged. A conversation ended by inactivity requires an explicit new start, such as a logo click; it does not automatically listen or reconnect.

## Natural conversation silence measurement

The meter begins only after provider/media readiness and samples WebRTC statistics every 250ms. It measures local microphone media-source audio and Pondster inbound audio, preferring interval RMS from total audio energy and sample-duration deltas. The activity floor is `0.005`. A fresh, measurable quiet sample on both sides starts the 30-second deadline; microphone activity, Pondster output, real typing or a submitted text question resets it. Transcript gaps are not used as evidence of silence.

Freshness and counter validation prevent stale or reset statistics from establishing quiet. Flat energy counters retain a valid reported audio level; without one they remain unknown rather than becoming an invented zero. Only one statistics query is in flight. A one-second query timeout disables that attempt’s silence meter and ignores its eventual result.

The exposed `silenceAvailable` state is null while checking, true only when both directions are measurable, and false when metrics are unavailable, stale or failed. The interface states the limitation honestly: unsupported measurement does not promise a 30-second shutdown or cut unknown speech. The existing three-minute overall limit remains the fallback and ceiling.

Trusted server hints distinguish queued work from waiting for an assistant response. Each hold is bounded to 30 seconds; queued work clears when the server’s pending callbacks finish, and measured Pondster output clears response wait. These hints come from the server’s own lifecycle, not client claims, and cannot hold a session indefinitely. Ongoing audio keeps a long answer active even without transcript events.

Inactivity uses the existing graceful stop: local microphone capture and playback end immediately, close requests are sent, and transports may drain for up to ten seconds for provider `session.closed`. A local drain timeout does not establish provider closure or confirmed final usage. Existing admission limits, provider permissions and conservative handling of unknown outcomes remain.

## Verification before publication

- TypeScript, production build, source diff check and the 178-file secret scan passed.
- Natural client/server and Browser voice mock suites passed, including silence timing, activity/typing resets, bounded waits, unsupported/stale/hung metrics, cancellation and cleanup.
- Contact navigation across six destinations, comment validation, guide and public-context checks passed.
- React static rendering passed for Contact public links and preservation of the hidden guide child.

Actual browser UI interaction has not been verified for this release; earlier browser automation was unavailable. Audible behavior and an actual 30-second quiet test in Chrome/Edge remain pending after publication. Codex used no provider API call, microphone or production vote/comment write for this request. No new assets, dependencies or database migration were added.

## Publication and corrected test report

Version 66 published successfully at `2026-10-27T20:59:29.149434+00:00`, environment revision 4. Source: `6c733c5d13186982276e2b07b7e1de504b3cb0d9`. Saved version: `appgprj_6ad4d98e08708191858cab113814704e~appgver_1766eac5e9888191994e5a527b2af5e1`. Deployment: `appgdep_6ae110a3a47c81918136bff480b51dc0`. Archive: `sha256:1c2c2fc54a4eb84876db4cf6375436ac99ce026dfd2c2662a8eba5b7a14fcda6`, 125 files, 60,497,920 bytes.

The custom-domain homepage and voice status returned HTTP 200; Contact, the tagline and the read-only Contact comments endpoint were present. This anonymous availability check did not prove availability for Wes's existing browser. Opening the page in Codex returned queued.

Wes initially answered that voice started without the panel, paused work, then corrected that report: he had not completed the test and received no answer when clicking. The initial answer is retracted as verification. Read-only records identified four closed, provider-confirmed conversations from his browser within the rolling 24-hour window, reaching the former four-start browser cap. No new provider session followed version 66. The prior version 65 audible greeting remains valid historical evidence, but proves neither version 66 behavior nor the silence timeout.

Version 67 fixes the browser allowance and exposes blocked-start reasons in the header. It retains this release's Contact, tagline, logo and quiet-detection implementation. Wes subsequently confirmed **Pondster now speaks** after refreshing and clicking the signature. The fresh request `e3d34401-b6a5-4a67-b0a1-3ff79853bf14` closed with 23 seconds of provider-confirmed usage. This verifies resumed logo speech and finalization, while the actual 30-second quiet test remains pending. See [[Project Rooms/Smart House/working/voice-browser-limit-fix-20261027]] and [[Project Rooms/Smart House/working/hosting-and-domain]].
