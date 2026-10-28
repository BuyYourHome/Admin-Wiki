# Visitor Conversations And Spoken Gallery Browsing

## Wes Authority — 2026-10-28

- Save conversations, introduce Pondster warmly on the first conversation, ask an optional first name and record it. On return, greet by that first name and ask what the visitor needs without another introduction.
- Wes selected **90 days** for conversations and remembered first names.
- Keep the saving notice out of the spoken introduction and title/header block. Wes specified that the written notice belongs **only in Voice controls**.
- Arbor was requested, but current official ChatGPT and Live API voice lists differ. Wes then explicitly selected **Keep Vesper — British, masculine**. No Arbor alias, custom voice, cloning or unsupported voice is deployed.
- Investigate the one-minute restart message. Confirmed closed conversations may restart immediately; failed-start backoff and active/uncertain-session fences remain.
- A guided gallery opens its first actual picture, with a short explanation that visitors can vote and change their vote. Add voice commands to move through its pictures.

## Implementation

### Private Text History And Greeting

The first-use written choice is in Contact’s Voice controls. Consent is required before website storage of conversation text or a name; visitors can continue without saving. There is no spoken saving announcement, public transcript feed, transcript lookup endpoint, visitor login requirement, or audio recording by the website.

Three private D1 tables store consented browser profiles, conversations and text events. Profile cookies are random, HttpOnly, SameSite=Strict and Secure on HTTPS; only a hash of the cookie is stored. The public endpoint returns only the current browser’s own preference/name, never transcripts, IDs or a list of visitors. Same-origin bounded mutations check profile ownership and expiry. Browser/typed exchanges and server-observed natural input/output transcript deltas are saved. Natural fragments retain exact text, repetitions, event IDs and timeline intervals; reflected audio is ignored. OpenAI session `store:false` remains unchanged. Text is application history, not a guarantee that every generated word was heard after an interruption.

Only the first name is kept in the greeting profile. A name is an unverified preference, never owner identity or permission. A full spoken/text transcript may naturally contain other words the visitor supplied. Names are optional, correctable in Voice controls and confirmed only after a successful save. Public navigation takes precedence over interpreting a short command as a name. Returning recognition works on the same browser cookie, not across devices or cleared cookies. “Not you? Start fresh” ends voice, clears that browser association and starts a new choice without showing or overwriting the previous visitor’s text. In-flight local responses are canceled on reset/stop.

Records expire at most 90 days from that profile’s consent; conversations cannot outlive the consent profile. Expired records are rejected by queries and writes. Bounded deletion runs on website preference requests, including the guide’s initial load. This is request-driven housekeeping, not a daily scheduled purge; an idle site can retain inaccessible expired rows until a later request. No separate automation was created. New/expired browsers receive a fresh choice. Existing saved records remain private until expiry when future saving is stopped or a browser is disassociated.

Schema changes are append-only migration `0003_mature_ink.sql`, its Drizzle snapshot and appended journal entry. Applied migrations are unchanged. No runtime DDL or production record reset is used. Saving errors are reported in Voice controls and do not silently claim that text was saved. Natural recording failures can continue as an explicitly unsaved conversation. Private owner review/export UI is not part of this request; records remain in the host’s private database.

### Restart And Gallery Actions

Admission and atomic reservation both exclude **closed + final usage confirmed** rows from the one-minute failure backoff. This does not remove starts from the rolling 100 allowance or release an active/pending/closing/unconfirmed session. Active/pending status messages take priority over the temporary retry message. No production session rows, keys, billing, quotas, concurrency or silence settings are reset.

Public Design actions support only first/next/previous/close picture commands. Named gallery requests open its first real picture, while empty galleries stay empty. The browser uses its actual current gallery/viewer selection; next/previous wrap within that gallery and include alternate views. One deck choice with two pictures retains one vote ID. The full-image viewer uses the existing explicit vote action and shows the current choice/change-vote state; Pondster never casts a visitor’s vote. Existing pointer gallery selection, section targets and one-shot virtual tour behavior remain.

## Verification And Release

Published as public Site version 77, source `b9687e60edbf33b5022556ea4cdd1e3ed1ed3a9b`, deployment `appgdep_6ae1f93fe9648191b9bf15ae3c15b6ee` succeeded 2026-10-28T13:31:56.087576+00:00 with environment revision 4. Full provenance and verification are in [[Project Rooms/Smart House/working/hosting-and-domain]]. Native owner-only database overview confirmed the new tables, and public browser checks confirmed the Voice-controls-only notice and full-image voting controls. Final TypeScript, production build, diff and 195-file secret check passed; 30 source text mirrors match. A fresh live microphone/provider round trip was not performed.

In-memory SQLite tests cover opt-in/private mode, first-name/return greetings, isolation, same-origin checks, deduplication, exact natural fragments/timing, ignored audio, expiry/deletion and the actual trusted sideband writer. Local browser checks used a synthetic first name, confirmed the return greeting after reload and the shared-computer reset. A typed gallery request opened Master Bath picture 1 of 6; Next, Previous and Close preserved its gallery. No microphone, paid voice connection, production transcript, production vote or comment was created by these tests.

## Official References

- [GPT-Live transcripts and lifecycle](https://developers.openai.com/api/docs/guides/live-conversations)
- [Server-side controls and sidebands](https://developers.openai.com/api/docs/guides/voice-server-controls)
- [Supported Live API voices](https://developers.openai.com/api/reference/resources/live/subresources/sessions/methods/accept)
- [ChatGPT voice choices](https://help.openai.com/en/articles/20001274-chatgpt-voice)
