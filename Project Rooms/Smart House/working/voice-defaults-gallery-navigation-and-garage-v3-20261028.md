# Voice Defaults, Gallery Navigation And Garage V3

## Current Wes Instructions

This supersedes version 77’s initial saving choice. On 2026-10-28 Wes requested text saving **on by default**, with a visitor control to disable it. Keep the written notice only in Voice controls; do not announce saving in the spoken introduction or header. Keep 90-day expiry and no website audio recording. Existing opt-outs remain off.

The opening now says: “Hello, I’m Pondster, the voice and persona of this home. I’m glad you’re here. How would you like me to address you?” The offered first name or nickname is optional and never verifies identity or grants owner permission. A visitor answering Wes, Jean or Ashley is not asking for a public contact. First-name responses and corrections are handled in context, with actual navigation words excluded. Returning browsers retain the short first-name welcome.

## Default Saving And Opt-Out

The guide checks the current browser setting on load and initializes saving when no preference exists. There is no initial choice screen or spoken recording announcement. An existing private preference is respected. Setup failure continues without saving and reports it in Voice controls rather than silently claiming a saved transcript.

The opt-out ends the current call, disables saving for that server-side profile and sets a non-identifying private preference cookie. Even a stale profile cookie or an attached writer cannot append more text after the database flag is disabled. Existing private records retain their original expiry; disabling future capture does not delete the prior history. Starting fresh disassociates the previous visitor and creates the normal default setting for a new visitor.

Additive migration `0004_nappy_captain_america.sql` adds `created_at`, `saving_enabled` and `preference_basis` and a creation-time index. Existing migrations are unchanged. A default-created profile records `preference_basis=default_notice` and **consent_at=0**; default behavior must not be represented as explicit opt-in consent. Legacy explicit choices retain their legacy timestamp/basis. New explicit re-enabling is recorded separately. No runtime DDL, quota reset or uncertain-session release was added.

Ninety-day expiry remains enforced on reads and writes, with bounded request-driven deletion. No new scheduled purge or automation is created. Public browsing remains login-free; there is no public transcript reader. Conversation text stays out of Wiki Git, the public house-facts prompt and the buyer-transfer package. The public voice receives only its current browser greeting preference and current conversation, not a transcript archive.

## One Picture-Navigation Rule

Wes reported that Pondster acknowledged the Back Deck gallery without navigating, and clarified that navigation should be generic for pictures. The authored guide recognizes Back Deck/backdeck and visual wording such as “Can I see the back deck?” in addition to explicit gallery requests.

The same allowlisted first/next/previous/close actions apply to gallery pictures across the site, including alternate views. Named gallery actions open the first actual picture; visitors vote explicitly using the viewer button, and may change their vote. Empty galleries remain empty. Vote IDs and the existing one-choice/two-view deck relationship are preserved.

Natural voice has a narrow deterministic fallback for simple explicit gallery/picture requests when the model omits delegation. It waits one second for input fragments to settle, resolves through the authored guide and validates the action. This delay is an application heuristic, not a provider completed-turn signal. Recent input gaps identify a candidate request without replaying previous conversation. Negative, private and complex requests are excluded from this shortcut. A shared consumed-input watermark prevents a normal or delayed delegation from reopening the first image after the visitor has advanced. An unresolved early fragment does not discard the beginning of a later complete gallery request. The fallback is bounded to 100 picture actions per connection; the existing broader delegation, daily-start, concurrency and lifecycle limits are unchanged.

## Garage Images — Existing Choices Replaced

Wes supplied three v3 garage renderings. They replace the images for the existing three voting IDs, with full-image presentation and no new choices. All source files were visually inspected; no exact address or private equipment label was visible. The PNG pixel data and dimensions are preserved (1905×825); a metadata check found no text/EXIF chunks to remove. Web filenames omit the property address. Binary images are only in the independent Site checkout, not Wiki Git.

Source folder: `C:\Users\wesbr\Buy Your Home\Buy Your Home - Property\26-BYH -908 Pond St\Owning\Planning\House Render\color-studies\pond-garage-layout-20261028-v3`.

| Vote ID | Source filename | Public asset | SHA256 |
| --- | --- | --- | --- |
| garage-06 | 908-Pond-Garage-01-Warm-White-Approved-v3.png | garage-v3-warm-white.png | 7b1e5284828329ea28ed2abbed486a73209b5d73c5946ee2e14ce7ed5cfdffd4 |
| garage-07 | 908-Pond-Garage-02-Charcoal-Green-v3-Review.png | garage-v3-charcoal-green.png | 8c2e853ac2198523bb315dba053502886335c3f21b0666461e2ae7757e0bb5b8 |
| garage-08 | 908-Pond-Garage-03-Limewashed-Brick-v3-Review.png | garage-v3-limewashed-brick.png | 6074b037efd94880a471f5434eda6a1cee9947cb7f5f17b69acd204b90bbfc77 |

AI-concept and fit/installation caveats remain. A filename containing Approved does not establish approved construction documents or installed work. The catalog remains 31 choices, with seven tour scenes and three existing films; no film was regenerated.

## Conversation Review And Manuals

When Wes requested review of the last conversation, the private conversation and visitor tables were empty. The old call was not available to review or recover, and no transcript was invented. The Back Deck concern came directly from Wes’s subsequent description. Default saving applies to new page/call sessions after refresh; it cannot retroactively capture an old call.

Wes also requested the sound-system and camera-surveillance manufacturer manuals in Belong, with relevant equipment facts supplied to Pondster, and authorized placing the reference pictures appropriately. The current accessible thread content and attachment folder contain the older bath photo and the supplied garage render paths, but no equipment photos/model labels. The property’s Owning file search found no matching sound/camera/manual sources. Equipment identification and manuals remain pending the actual photo attachments, filenames or model numbers. Do not guess models, publish label serials/QR codes, claim installation, or configure devices. Use exact manufacturer manuals once identified; link public manuals and supply a source-backed public summary, keeping private configuration out of Pondster’s public knowledge.

## Release And Validation

Published as version 78. See [[Project Rooms/Smart House/working/hosting-and-domain]] for exact source/archive/deployment provenance. TypeScript, production build, 202-file secret-absence scan, default/opt-out/name/expiry SQLite tests, actual initialization checks and gallery/server regression tests passed. Tests cover no-delegation and delayed-delegation paths, a split Back Deck phrase, all gallery names, first/next/previous/close, private/negative guards and stable voting identity. Native owner-only database inspection confirms the new columns in production. Fresh browser verification was unavailable because the browser-control connection timed out; no fresh microphone/provider trial was performed. Existing public audience, environment revision 4, Vesper, 100 rolling starts and 30-second measurable-silence behavior remain.
