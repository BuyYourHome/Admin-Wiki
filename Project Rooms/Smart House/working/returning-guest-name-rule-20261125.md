# Returning-Guest Name Assumption

## Wes Instruction

Wes clarified: “If you say, welcome back Wes, and Wes does not correct you, you should assume your talking to Wes”. Apply that as the conversation's working name. A direct visitor correction or self-identification takes precedence. This affects conversation labels and reports, not identity verification, permissions or owner access.

## Correction To The Earlier Review

The earlier archive labeled legacy name fields unrecorded without fully considering self-identification in the captured words. Private review found explicit names and a requested relational address that the labels missed. Missing structured fields do not mean no name was spoken. Do not infer that a relationship label identifies the speaker as the named relative. The actual guest/date mappings stay in the private source and owner review, outside Wiki Git.

Pondster's remembered greeting uses its browser cookie, not an IP-to-person lookup. A shared browser can be used by another speaker. The working-name assumption follows Wes's rule only when the captured Pondster greeting is followed by visitor participation and no correction; a greeting-only record does not establish a conversation participant.

## Required Behavior

- Resolve effective names from the captured speaker turns and conversation-bound name reports, not the profile's current mutable name.
- Treat an actual captured returning greeting followed by uncorrected visitor participation as an assumed name. Preserve that evidence basis internally.
- Reassemble voice fragments before looking for a visitor's name. Direct statements such as the synthetic example “This is Alex talking” override the greeting assumption.
- Preserve a bounded requested relational address such as the synthetic example “Pat's son”; do not truncate it into “Pat's” or attribute that guest to Pat.
- If the visitor rejects the greeted name without providing another, leave the effective label unknown until another address is supplied.
- Ignore quoted examples, other people's names and Pondster's own statements as visitor self-identification.
- Keep raw transcripts, historical snapshot fields, public access and authorization checks unchanged. Historical reports may derive a label from captured evidence without rewriting the old records.

The owner-only review and future transcript emails should use the same resolver. The previously delivered archive remains a historical copy; no correction email was requested in this turn.

## Release

The shared resolver reconstructs captured speaker turns, applies explicit name reports and ordered corrections, and otherwise applies the uncorrected named-greeting assumption. It excludes quoted examples, embedded descriptions of greetings, third-person name references and greeting-only records. Negative corrections without a replacement leave the effective label unknown. Live instructions use the same conversational rule, and the name parser recognizes direct speaking introductions and bounded relational addresses.

Future owner emails lead with the effective guest label rather than empty legacy name fields. A bounded owner-only review tool exposes the same derived labels and evidence with pagination. It performs no history/profile writes. Seven targeted/regression suites and independent review passed, including correction precedence, examples, fragment assembly, aliases, read-only snapshots, owner isolation, expiry and cursor bounds. TypeScript, production build, whitespace and the 246-file source credential/privacy scan passed. No paid voice test or email resend was performed.

The live historical review exposed an additional ordinary introduction form; the final parser also handles a bounded proper-name introduction such as the synthetic “Oh, this is Alex”, with guards against descriptive house comments and questions. The identity, visitor and email suites passed again, followed by TypeScript, production build and source/privacy checks.

Published as public Site version 98, source `a71c526bbbf189ccb0f652308d6459e6acac6900`. Saved version `appgprj_6ad4d98e08708191858cab113814704e~appgver_ed19372026e8819183eb93397dcbff5c`; deployment `appgdep_6b0789c7089c819183c51d9dc76e7639` succeeded at 2026-11-26T01:22:26.856662Z with unchanged environment revision 5. Archive: 172 files, 120074240 bytes, SHA256 `c2a972b9dd299f81640beb523a6c006c31e2a00bad91d3e2c7ce75da6c0ac444`.

A fresh installed owner connection reviewed all 21 unexpired conversations in one page, without bounds/truncation flags. Both the returning-name assumption and explicit visitor overrides were verified against captured evidence. Actual guest labels and dates remain private and are not copied to the Wiki. Anonymous and forged-owner-header requests to the private review endpoint were denied with HTTP 401. Seven final source text mirrors match the pushed source. No raw transcript, profile record, access policy or email schedule was changed by the review, and no correction email was sent.
