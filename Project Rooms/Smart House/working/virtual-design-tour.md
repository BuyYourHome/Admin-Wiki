# View page virtual design tour

## Wes instruction — 2026-10-25

Wes directed creating a virtual tour from View that selects each room's video or most-voted design, combines the scenes with a soundtrack, and advances automatically. This is a public concept tour using the website's existing authorized assets, not a new recording of the completed house. Website implementation and publication are covered by the current room authority.

## Source and selection

- The shared `lib/designs.ts` catalog supplies current voting choices. The tour reads each populated gallery's existing `/api/votes?room=...` endpoint at the start of each new tour. It does not submit votes or change vote storage.
- Current populated galleries: Front Elevation, Media Center, Master Bath, and Garage Barn Door. Kitchen, ADU, Spiral Staircase, and Back Deck have no image choices yet and are omitted until available.
- Each populated gallery contributes its highest valid vote choice as a still scene. A tie uses the first matching gallery entry and is identified as joint lead. A gallery without votes uses its first image with a featured-preview label. Failed vote reads use a distinct votes-unavailable preview label, never a fabricated leader.
- After the selected Media Center and Garage images, the tour includes their existing illustrative motion films. They are explicitly separate from the chosen color/finish; the existing film is not recolored or represented as the winning design's film. Required football credit and source-use notice accompany the Media Center scene.
- Initial order: Front Elevation, Media Center choice, Media Center film, Master Bath, Garage choice, Garage film. Future populated galleries are appended in catalog order.

## Experience

The View page has a prominent tour invitation above the early-buying design paragraph. Starting it opens a modal player. Images remain uncropped for eight seconds; films play once and advance on completion. Scenes include their room, design name, vote status, and concept description. Playback includes pause/resume, previous/next, direct scene selection, optional full screen, replay, and music on/off. Closing the tour returns focus to its invitation; changing pages disposes playback. Leaving the tab pauses the tour and music.

The soundtrack is a quiet original Web Audio instrumental composition created in browser code, with no third-party music file, purchase, account, or outbound audio request. The invitation's checked soundtrack control makes sound expected on the Start click; no sound starts merely from opening View. Browsers without usable audio can continue the visual tour. Existing supplied motion films remain muted.

Loading and playback errors use labeled still fallbacks or permit skipping. Reduced-motion preferences remove image fades and progress animation. The tour closes the Pondster question panel before playback; no microphone, live house control, lock code, private owner record, or exact location is added.

## Validation and publication

The focused vote-selection and Web Audio lifecycle/race suites, full TypeScript check, and production build passed. Local Chrome verified automatic still-to-film and film-to-next progression, current vote selection and ties, quick pause/resume, 25-second final film completion, completion/replay controls, music enabled without startup errors on a clean page, Escape/focus/scroll-lock recovery, and phone fitting. The 390×844 modal was 376 pixels wide with 44-pixel or taller playback buttons and no page overflow. Audio was not recorded or independently listened to for musical quality. Native full-screen behavior and reduced-motion preference were reviewed in source but not exercised separately.

The generic build wrapper encountered a missing `npm` executable on this host. The exact existing build script, `node scripts/run-framework.mjs build`, completed with bundled Node and unchanged dependencies/configuration. The official Sites source helper then pushed the matching source and packaged the completed build. A process-only Git safe-directory entry was restricted to the established sandbox-owned Sites checkout; global Git trust was not changed.

Sites version 30 deployed successfully at `2026-10-25T19:26:40.662281+00:00`. Source commit: `0883f0b9215d84af9028ef3193eff5f1ccfb60d3`; saved version: `appgprj_6ad4d98e08708191858cab113814704e~appgver_44dac207488c8191aa27384320187bcd`; deployment: `appgdep_6ade57e7afb88191a9b5e25175ba78db`. A fresh custom-domain View page showed the invitation and live player. See [[Project Rooms/Smart House/working/hosting-and-domain]]. No production votes, comments, bookings, messages, microphone use, paid services, account changes, private records, DNS changes, or house-system actions were created.
