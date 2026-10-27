# Voice startup and optional model diagnostic — 2026-10-27

## Observed failure

This focused follow-up began at `2026-10-27T21:23:04Z` after Wes reported that voice was no longer working. His earlier version 67 spoken trial remains verified: request `e3d34401-b6a5-4a67-b0a1-3ff79853bf14` closed with 23 seconds of confirmed usage. No newer session existed in the initial native snapshot.

At `2026-10-27T21:22:04.944Z`, the hosted model-information diagnostic logged `stage=model-access`, HTTP 500, with no allowlisted error code or valid request ID. The status route itself returned HTTP 200 with unavailable in its JSON. Source review confirmed that the 500 was a received upstream response, rather than an invented timeout status; the available evidence cannot distinguish OpenAI from an upstream intermediary. The same approved key returned HTTP 200/ready from a read-only local model-information check at approximately `21:25:42Z`, while the hosted diagnostic still returned provider_error/500 at approximately `21:25:59Z`. No credential or quota failure was established.

Every explicit natural start previously required this optional metadata check before microphone acquisition. The diagnostic caches all results for 60 seconds per Worker isolate. A metadata failure could therefore prevent a voice attempt without creating a voice-session record, even after a real voice conversation had succeeded.

## Focused change

The client now requests ordinary `/api/voice/status` before capture. This retains configuration and read-only session admission. The opt-in `?check=provider` diagnostic remains available separately, with its existing implementation unchanged. The actual voice-session request establishes model/account availability through the existing server path.

Atomic reservation, global/browser limits, cooldown, concurrency, explicit click, provider permissions, quiet detection and the three-minute ceiling are unchanged. There is no automatic retry of session creation. The existing distinction between observed terminal create rejection and uncertain outcomes remains; uncertain sessions still occupy their normal fences. Actual authentication/model/allowance failures are reported by the real session request after microphone acquisition, using existing cleanup.

## Verification

The existing voice lifecycle suite passed with a regression assertion that startup uses the ordinary admission endpoint. TypeScript, production build, diff check and the 178-file secret scan passed. Independent review supports retaining admission and actual-create handling while removing the diagnostic as a startup prerequisite.

## Publication

- Source: `312b155de529e107cdc6cb3f83f1aa28483c3667`.
- Saved version: `appgprj_6ad4d98e08708191858cab113814704e~appgver_949cbfc1d35c8191a0bfa6c4ffaef502`, version **68**.
- Deployment: `appgdep_6ae117df09a081918aab2e2886d093c2`, succeeded `2026-10-27T21:30:16.258459+00:00`, environment revision **4**.
- Archive: `sha256:9b1cbe0ddc8d8c5d7ad34101ad053d0eacae289d6c1b6394ed7cfbabd6079ed6`, 125 files, 60,497,920 bytes.

The public homepage and ordinary admission endpoint returned HTTP 200; Contact and the exact tagline remain present, and anonymous admission was available. This does not prove visitor-specific availability or a successful voice session. Opening the public page in Codex returned queued. The two changed text sources are mirrored in gallery-source; public audience and private environment revision 4 are preserved.

Wes was asked to refresh Chrome, click the logo once, keep the page visible, hear Pondster and then stay quiet for about 30 seconds. The fresh version 68 spoken/quiet test is pending. No microphone or provider voice-session creation was performed by Codex. The read-only metadata comparisons created no voice session; no key, billing, vote/comment record or device setting changed.
