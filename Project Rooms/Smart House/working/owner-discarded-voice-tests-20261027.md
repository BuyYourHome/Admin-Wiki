# Owner-discarded voice test reservations — 2026-10-27

## Authorization and exact scope

Wes directed: “I am not concerend about those sessions. They are throw away. lets get natural voice working.” Work began at `2026-10-27T14:09:50Z` in the owning Smart House chat. This authorizes releasing only the two previously identified local test reservations. It does not establish provider cancellation, final billing or permission to clear future unknown sessions automatically.

Version 62 used a guarded, idempotent operation in the existing admission path. It matched each exact request ID, original creation/expiry timestamps, state `unconfirmed`, null provider ID, zero stored usage and unconfirmed final usage. Native before/after comparison confirmed that only `state` changed, with no inserted/deleted row or other field changes:

| Request ID | Original created / expiry timestamps | State change |
| --- | --- | --- |
| `59bac828-75c8-4427-a212-e64084db8afc` | `1793012027127` / `1793012227127` | `unconfirmed` → `owner_waived` |
| `690cbd94-804a-4dc1-bf27-f2476a028659` | `1792990741567` / `1792990941567` | `unconfirmed` → `owner_waived` |

The preexisting failed request `aa4eb72d-ebce-4b7d-9d3b-f1a3c3064afc` was unchanged. The two old attempts still have null provider IDs, zero **stored** usage and `final_usage_confirmed = 0`; unknown usage is not claimed to be zero. Their audit history is retained. Late activation/finalization writes cannot revive or overwrite waived records. No public administration endpoint or data migration was added.

## Fresh end-to-end test

After publication, the custom-domain status endpoint returned HTTP 200 and `available: true`. Wes then personally started Natural conversation in Chrome and confirmed **“I hear a natural spoken answer.”** The resulting request `fee59c3f-99f8-4d74-a324-dfabb254d82c` was created at `1793111876107`, received a provider ID, and finished `closed` with 15 usage seconds and provider-confirmed final usage. Microphone capture was initiated by Wes, not automation.

The two-to-ten-second close drain keeps control transports open for finalization while immediately stopping local capture/playback. Tests cover delayed confirmation at five seconds, an unconfirmed ten-second timeout, diagnostic sanitization, and existing admission/usage rules. General unknown-session fences, concurrency limits, 20 global attempts per rolling 24 hours, four per visitor, 60-second cooldown, and the three-minute best-effort conversation cap remain unchanged.

Version 63 removed the one-time exact-ID release hook and its temporary test after verification. Synthetic `owner_waived` late-write and quota coverage remains in the ordinary server suite. No new credential, billing change, live device action, vote/comment write or support message was performed.

See [[Project Rooms/Smart House/working/pondster-natural-voice]] and [[Project Rooms/Smart House/working/hosting-and-domain]] for implementation and release identities.
