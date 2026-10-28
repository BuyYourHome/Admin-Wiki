# Site-wide voice controls and logo — 2026-10-28

## Wes's requested scope

Continue the gallery voice/restart corrections. Make website controls voice operable, move the Design introduction below the gallery, align the tagline's bottom with the logo rectangle, add an orange exclamation mark after Pondster with fireworks originating there, and remove the diamond inside the P. Ordinary implementation, testing and publication are authorized; public audience and existing account/voice configuration remain unchanged.

## Shared voice controls

Natural conversation and Browser voice use the same application handler. Explicit control verbs can activate named buttons/links/disclosures/plan-room buttons, fill labelled fields with supplied text, choose available dropdown options, check/uncheck settings, scroll, and control a current video or tour. Existing semantic navigation, gallery first/next/previous/enlarge/close and explicit current-picture voting remain supported. A deterministic fallback handles clear control commands when the model omits delegation, with the existing deduplication and per-call bounds.

Labels are text to match, never executable code, selectors or URLs. Only rendered controls in the current view are eligible; an open modal excludes the background. Hidden/inert/aria-hidden fields, disabled/read-only controls and ambiguous matches cannot be silently activated. Form validation and server processing remain authoritative. Voice does not automatically submit a comment merely because text was supplied; the visitor must explicitly activate Post comment. Existing field limits and dropdown options are respected. Explicit named dates require a year; voice must not invent one. Time values can normalize an explicit AM/PM choice to an existing option.

Control results use a correlated, bounded receipt. Pondster acknowledges activation or a changed setting, with no claim that an asynchronous form submission, download or external navigation completed. Voting retains its stronger saved-choice response check. Unknown, disabled, ambiguous, missing and physical-click-required cases have fixed feedback. Browser security prompts, file pickers and some native media/fullscreen actions can still require a physical gesture; the site does not bypass them.

The virtual tour retains an ongoing voice conversation and includes its own Start/Stop voice and Voice controls. Next/Previous/First/Close apply to its active views rather than opening a different gallery. Existing music, playback, room and fullscreen controls remain the actual implementation. Quiet-off and goodbye still end voice. There is no automatic paid restart, new service, real appointment booking, live camera/lock access or home-device control.

## Layout and branding

The first-person Pondster/Cary/SI-designer introduction now follows the Design gallery workspace. The tagline uses the rectangle's existing height/drop variables for its bottom alignment. The signature has a burnt-orange exclamation mark; the decorative bursts are positioned inside that mark, and the P diamond pseudo-element is removed. Fireworks respect reduced-motion preferences and have no pointer events. Other logo wording, Your/Home placement, menu order and public-location boundary are preserved.

## Verification limits

Focused tests execute the real control parser/resolver/dispatcher with DOM doubles, actual page action handlers and vote-result flow. Coverage includes modal scope, hidden controls, duplicate labels, disabled/read-only/length boundaries, dropdown and checkbox behavior, date/time formatting, media/gesture results, scrolling, generic server receipt feedback, late/duplicate actions, gallery identity, goodbye/restart and tour logic. TypeScript, production build and secret checks are required before packaging. No automated live vote/comment submission, physical microphone call or new paid test session is performed.

Computer-use access to the existing public Site tab timed out again during this request. A fresh rendered visual/interaction test could not be completed. Code/layout checks are not evidence of exact pixel appearance or real Chrome speech behavior. The version 79 test call's saved text was separately verified through owner-only records; see [[spoken-gallery-voting-enlargement-and-restart-20261028]].

## Publication

Version **81** published successfully at `2026-10-28T16:00:48.293559+00:00`. Source `e318b97c3f1ee850cf9ccd31ade491d5913c7015`; saved version `appgprj_6ad4d98e08708191858cab113814704e~appgver_2f02655267b08191becef42c9cc1797f`; deployment `appgdep_6ae21c223a708191a0612d07ee40173b`; environment revision 4, public audience unchanged. Archive `sha256:3630240b826bc7a25ef9f060e54a2e63fd2950e2b64eb9385385abf078ea8637`, 136 files / 74,106,880 bytes. TypeScript, focused checks, production build and the 207-file secret scan passed. Site source was pushed by the supported helper; native publication returned succeeded. Public site: https://pondstr.com; native alias: https://pondstr.coolnewt4097.chatgpt.site.

Source mirrors match the released checkout. One pre-existing trailing space in the tour JSX is retained for source fidelity; it was verified present before this release and is not a functional change.


## Follow-up — fireworks from the upper tip

Wes approved the logo and requested only that fireworks originate at the top of the exclamation point. The CSS now uses left .33em and top calc(.065em - 90px), with bottom auto. A read-only independent review of the bundled Allura font found unitsPerEm 1000, typo/hhea ascent 800, descent 450 and USE_TYPO_METRICS enabled. With line-height .95, the baseline is .65em; the exclamation upper tip at (330,585) maps to (.33em,.065em). The unchanged SVG origin is 90px below its top. This anchors the existing bursts to the glyph tip at responsive font sizes. SVG, animation, tagline and other logo styling are unchanged.

Version **82** published at `2026-10-28T16:58:51.339390+00:00`. Source `5f31c916823759f8230f7a21fbeac9707b58732b`; saved version `appgprj_6ad4d98e08708191858cab113814704e~appgver_d8f9c3c78ae88191a325a049c612c987`; deployment `appgdep_6ae229c02d688191b2e5e16aa2b8e1ca`; environment revision 4. Archive `sha256:3a95cede504b5bd1a5e82b1c1f702a9d10bcd14e0104527b8f7db98d26e7d960`, 136 files / 74,106,880 bytes. Public audience retained. Build, whitespace check and secret scan passed; no fresh browser preview was available.
