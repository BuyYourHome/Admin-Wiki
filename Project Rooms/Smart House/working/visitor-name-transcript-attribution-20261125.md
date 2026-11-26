# Guest Names And Private Text Transcripts

## Wes Authority

On November 25, 2026 Wes asked Pondster to track guests who identify themselves and retain their text transcripts, without saving voice recordings. He also requested a private review of who had conversed besides himself. This continues the existing optional name preference, default text saving, visitor opt-out, and 90-day retention policy. It does not authorize publishing visitor names or conversation contents.

## Verified Starting State

Owner-only Sites database reads confirmed saved visitor and Pondster text, including typed and natural-voice conversations. The complete visitor-profile scan did not identify another named guest. Anonymous browser profiles are not a count of distinct people and cannot distinguish Wes's own visits from other visitors.

The old schema kept a name only on the mutable browser profile. Consequently, looking up an earlier conversation through the profile's current name could misattribute a shared-browser conversation. Existing text must not be retroactively assigned a name from that mutable profile.

## Required Attribution

- Keep the remembered browser name at the start of each new conversation separate from a name explicitly supplied during that conversation.
- Preserve the first self-reported name and its timestamp for that conversation; retain subsequent name reports or corrections as private timestamped history.
- A later profile-name change must not rewrite earlier conversation attribution. Do not merge profiles based on matching names.
- Associate a name with a conversation only after checking the same browser profile, saving preference, valid current conversation and expiry. A name is an unverified address preference, never proof of identity or owner authority.
- Preserve optional naming, the existing greeting and returning-browser behavior, the controls-only written notice, opt-out and existing retention deadline.
- Retain text only. Audio events are ignored by the website's history writer. No public transcript reader or visitor list is introduced.

## Retention And Review Limits

Text, name history and conversation metadata inherit the profile's deadline, at most 90 days from profile creation. Bounded request-driven cleanup remains in place; this is not an independent daily purge. Existing opt-outs stay off. Anonymous past conversations cannot be reliably identified after the fact.

Raw visitor names, transcript text, identifiers and live database exports belong outside Wiki Git, public house facts and the buyer-transfer package. Owner inspection uses the native Sites database reader. No production microphone test or synthetic guest conversation is needed for this update.

## Implementation And Checks

Additive generated migration `0006_cuddly_siren.sql` introduces nullable conversation snapshots and a private name-event table. Existing conversations remain unattributed. New conversations capture the remembered name directly from the current database profile; a separately saved first explicit name and timestamp never change when the profile is renamed. Later corrections retain their own previous/new names, source, time and original expiry.

Typed and Browser voice name replies include their exact conversation ID. The name form uses the current active natural attempt ID or local conversation ID, with ownership/open/expiry checks at the server. When no current conversation exists, a form change stays profile-level. A recorder refreshes external name changes before parsing another name. Atomic writes and stable request IDs prevent a delayed or concurrent replay from reverting a later correction or announcing the stale name. Bounded expiry drains child records before deleting their parents.

Four temporary-database/transport test suites passed: attribution, existing visitor history, live client lifecycle and live server. They cover a migration over an existing conversation, immutable attribution, later corrections, same-time replay, form association, ownership, closed sessions, opt-out, expiry, public-response isolation and ignored audio. Independent review and attribution execution found no blocker. TypeScript, production build, whitespace checks and a 239-file source text credential/privacy scan passed. No live paid voice session was started.

## Release

Published as public Site version 95, source `52041688ed5c35abd6bde61ebe03a6f1e8805b49`. Saved version `appgprj_6ad4d98e08708191858cab113814704e~appgver_9b5c765b969c8191af9c3521ee784a1e`; deployment `appgdep_6b07784fb9788191879e8c9062a9c43c` succeeded at 2026-11-26T00:07:55.782637Z with environment revision 5. The existing public audience, domain and runtime bindings remain in place.

The deployment archive contained 170 files, 120012800 bytes, SHA256 `38b1306feb85130de172382e0c7a93d75e57e7d214606594aa34e6395aa36438`. Native owner-only inspection confirmed the new table and all three conversation columns in production. A preexisting conversation still has null attribution fields; no historical name backfill or production test guest was created. The current new history table was empty at inspection, as expected immediately after deployment.

The custom-domain homepage and anonymous preference GET both returned HTTP 200. The preference response remained private/no-store and exposed only the anonymous browser preference, with no name, IDs or history. Eleven owned source text mirrors were hash-verified against the pushed Site source. No raw guest records were copied to the Wiki.
