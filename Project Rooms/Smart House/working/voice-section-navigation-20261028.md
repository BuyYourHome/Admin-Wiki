# Precise public section navigation — 2026-10-28

## Authority and observed behavior

Wes reported that voice navigation to the Living Room gallery scrolls correctly, but asking who the general contractor is only opens Contact. He instructed that relevant sections/cards must be revealed throughout the site. This is user confirmation of those specific version 72 navigation paths, not verification of every voice lifecycle behavior. The request began at `2026-10-28T01:52:00Z`; completion continued after an overnight gap.

The later question about whether Pondster is trained on all house facts was answered as discussion. Pondster uses approved public Site facts; a complete house knowledge base was not requested or implemented by this navigation change.

## Implemented destinations

- One shared public destination contract supplies both action validation and fixed DOM anchors. Optional sections must match their page; room, lighting and tour combinations are checked. Unknown targets and incompatible combinations are rejected, and extra URL/selector/command fields are stripped. No arbitrary DOM selector, external link, private record or device action is accepted.
- Contact supports individual GC, plumber, HVAC, realtor, company, trade-group and conversation sections. Multiple named trades reveal the first mentioned role while retaining the supplied facts.
- Explore supports house/system feature cards, expandable room-feature details, the proposed plan and an explicitly selected plan-room detail, plus the lighting illustration. Only the existing public gallery and plan-room identifiers are accepted.
- View supports the realtor, viewing preview, visual notebook and existing tour. Belong supports the preliminary drawing, guides, maintenance and handover cards. Built By supports company and contact sections; Design retains gallery navigation and adds the public introduction destination.
- A monotonic reveal request handles repeated same-page/same-card questions. The UI prepares collapsed details and waits for the requested floor-plan room's rendered marker before measuring. Stale frames and navigation cancel pending work. The actual fixed-header height is measured; reduced motion and native focus are preserved. Initial loads, votes and result refreshes do not request scrolling.
- Oversized voice destinations align beneath the header unless already aligned. A fully visible smaller card stays still. Existing pointer/Design gallery geometry remains unchanged. The old competing lighting scroll is replaced by the shared destination path. Existing tour start, voice stop and one-shot behavior remain.
- Natural voice delegates questions that clearly match a supported visual destination. A missed visual keyword match does not override authored public facts with a blanket refusal. Unmatched conversational follow-ups remain direct. Neither emitted navigation nor a guide reply is proof that a browser finished scrolling, so the voice prompt does not claim a completed scroll.

## Verification and limits

Destination/Guide matrix, actual UI handler/effect doubles, Contact/navigation, existing gallery geometry and server/client/context mocks passed. Tests cover section preservation across the trusted channel, menu/target compatibility, invalid/private targets, same-target repeats, room expansion, floor-plan readiness, stale frame cleanup, reduced motion, oversized sections and legacy tour/privacy behavior. TypeScript exposed a trade-union narrowing issue; it was corrected before release.

A current preview was opened on loopback port 19082; the older port 19081 preview was identified as obsolete and left untouched. Native in-app-browser checks used the local typed guide with voice off. The GC question revealed Glasgow Design Build below the header; a Master Bath question opened its Explore details; the Pantry question selected the Pantry and its detail frame. The initial oversized Pantry frame remained too low despite correct selection; the voice-only geometry fix was then verified with the detail frame directly beneath the header. The owned 19082 server was stopped after checking. No microphone, paid voice session, production vote/comment write or real device operation was performed.

Version 73 is published. After publication, the GC question was entered through the typed guide on public Pondstr.com with Voice off; its card was visibly aligned beneath the fixed header. The existing design-view regression also passed, preserving gallery/vote identities and seven tour scenes/three films. Final TypeScript, build, diff and 185-file source/build secret checks passed; twenty source text mirrors match. Exact release identifiers are in [[Project Rooms/Smart House/working/hosting-and-domain]].

A fresh natural spoken section-navigation trial remains unverified; end an existing conversation and refresh/start a new one after publication to load the new prompt and client code. The approved key, Vesper, voice lifecycle/limits, public audience, private-location boundary, catalog and media remain unchanged.
