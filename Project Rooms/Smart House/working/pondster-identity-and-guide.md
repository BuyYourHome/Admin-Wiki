# Pondster identity and website guide

## Owner instruction — 2026-10-23; implementation — 2026-10-24

Wes directly named the house **Pondster**, asked for viewers and potential owners to speak to it by name and receive a response anywhere on the website, and identified **Jean Wright as the SI designer**, who can be referred to by name. Preserve the supplied role exactly; no expansion of SI was supplied. The property address remains **908 Pond Street** and the existing domain remains https://pondstr.com .

## Current website implementation

- Pondster is the public voice and identity of the house, reflected in the header brand, metadata, introductions, and footer. Jean Wright is acknowledged as SI designer in plain-text credit and public role answers. The credit does not open a designer persona or conversation.
- Authored page storytelling, metadata, gallery descriptions, status/error feedback, and guide replies use Pondster's first-person I/my/me voice. Ashley's introduction says "Meet Ashley, my realtor." Visitor comments, visitor-composed email text, quoted external credits, and required notices keep their original voices. Functional menu items, labels, and names may remain neutral.
- Only the location and address are confidential. The opening introduces Pondster clearly, then makes a playful witness-protection joke about keeping the location secret. Do not imply that the house's name or identity is confidential.
- A persistent Talk to Pondster control is mounted outside the five menu sections, preserving the guide conversation during navigation among Design, Explore, View, Own, and Built By.
- Typed questions and quick prompts work without microphone access. All questions are directed to Pondster. The guide provides bounded public website answers and can navigate to room galleries, the viewing page, owner plans, or simulated lighting moods. It is a deterministic website guide, not an unrestricted general AI service or a live connection to a designer's chat.
- Feature requests use the shared Explore content: each known room's concept/plan feature list is available in Pondster's replies and opens Explore. General feature questions open the house and room overview. A requested lighting mood brings its illustration into view after navigation. See [[Project Rooms/Smart House/working/explore-features]].
- Browser speech recognition and speech synthesis provide optional named voice interaction where supported. Listening starts only after the visitor chooses Listen and grants microphone permission. Say Pondster with a question; the designer's name is not a wake name. Questions about the designer receive the Jean Wright credit from Pondster. Speech replies are opt-in; starting Listen enables them, and the visitor can turn them off or request Read aloud.
- Listening status, Stop voice, close, Escape, and unsupported/denied/service error messages are visible. Close, Stop, and leaving the active tab stop listening; late recognition results cannot reopen it. The guide pauses recognition while it speaks, then resumes an explicitly requested listening session. It remains mounted while changing menus.
- The browser's speech service may receive audio. The interface discloses this before microphone use. The website has no audio upload endpoint, transcript database, owner identity verification, or real house control. Conversation state is temporary component memory, limited to recent messages.
- Only public facts are available. Saying someone is an owner does not reveal private records or unlock owner functionality. Votes require their actual gallery buttons. Viewing appointments and codes remain clearly simulated; no voice request sends a message, confirms a booking, or unlocks the house.
- Each public page retains a comment section for visitors' thoughts. Questions use the Ask me control to open Pondster; comments do not create another named assistant or designer conversation.

## Source and future work

Authoritative facts come from Wes's direct identity/role instruction, the existing supplied gallery/video catalog, verified Ashley profile/contact, and existing website behavior. No private operational notes are used as guide answers.

Browser API references: [SpeechRecognition](https://developer.mozilla.org/en-US/docs/Web/API/SpeechRecognition), [continuous results](https://developer.mozilla.org/en-US/docs/Web/API/SpeechRecognition/continuous), and [SpeechSynthesis](https://developer.mozilla.org/en-US/docs/Web/API/SpeechSynthesis). Recognition has limited browser support and some implementations send audio to a remote service. Never claim universal availability or wholly local audio processing.

Future unrestricted conversational AI, authenticated owner knowledge, and real house commands need separately identified service/account configuration and access rules. Home Assistant continues to own live integration/configuration. No provider account, credential, paid service, voice likeness, or device integration is created by this update.

Deployment and validation: see [[Project Rooms/Smart House/working/hosting-and-domain]].

## Validation

Focused resolver checks pass for the identity, exact Jean role, all eight galleries and eleven current choices, simulated scenes, video, voting boundaries, simulated viewing, Ashley contact, owner restrictions, and unavailable facts. TypeScript checking and the production build pass.

Local browser checks confirmed Jean's answer, requested Front Elevation navigation, persistent conversation through Explore/View/Manage, and a requested Evening scene changing only the illustration. Escape closes the panel and returns keyboard focus to the launch control. A phone preview confirmed 375-pixel page/content width with the corrected panel entirely inside the viewport (left 12, right 363) and its bottom at 764 in an 844-pixel-high viewport.

No microphone was opened for testing and no ambient audio was captured. Actual speech recognition and audible playback are implemented but have not been verified end to end with a live microphone. They remain dependent on browser support, microphone permission, and the browser's speech service. Typed questions and page navigation were verified in the browser. No live lock, appointment, message, or production vote was initiated by these checks.

Published as Sites version 7 at https://pondstr.com . The custom-domain browser check confirmed the Pondster identity and Jean Wright response. Public audience and the existing domain were preserved.

## Earlier public anonymity wording — 2026-10-24; clarified below

Wes initially directed the public site to remove the property address for now and say that Pondster needs to start anonymously. This superseded earlier public address wording while retaining the internal property association for room operations. Public greetings, location answers, title/description, brand marks, footer, and viewing-request email links must withhold the address. The earlier copy said: "I need to start anonymously for now." The later clarification below makes the location confidential while keeping Pondster's identity public. The page-asset source and Ashley portrait are documented in [[Project Rooms/Smart House/working/viewing-and-realtor]].

## Earlier designer acknowledgment wording — 2026-10-24; name corrected below

The earlier instruction was: "You can acknowledge Dean wright as the SI designer. But questions will only be directed to Pondster." At that point the public credit used Dean Wright and questions were directed only to Pondster. The name was subsequently corrected to Jean Wright below. Keep this instruction, the original intake, and prior validation as historical records.

The Pondster-only question recipient and voice wake name remain in force. The designer acknowledgment stays static text, without a click action or separate persona. Public comments remain available for thoughts, and their Ask Pondster control sends questions to the house guide.

## Current identity, location privacy, and designer correction — 2026-10-24

Wes clarified: "It's Jean Wright, not Dean. The opening paragraph should be clearer. Pondster is the voice and identity of the house. It's location is what needs to be confidential. Make a joke about being in witness protection".

Use **Jean Wright** as the current SI designer credit. **Pondster is the public voice and identity of the house; only its location and address are confidential.** The opening should state that identity clearly and use the requested witness-protection joke for the secret location. This supersedes the earlier Dean credit and ambiguous anonymous-identity wording. All questions and voice wake requests still go only to Pondster; Jean Wright is acknowledged through static credit, without a separate designer persona.

## First-person house voice — 2026-10-24

Wes directed all website wording to use Pondster's first-person voice, including "Meet Ashley, my realtor." Write authored page stories, metadata, gallery descriptions, feedback, and guide answers as the house speaking through I, my, and me. Keep neutral functional menus, field labels, and names clear. Do not rewrite visitors' saved comments or composed email text, quoted third-party credits, or required notices as Pondster's statements.

This changes voice, not authority or facts. Jean Wright remains a static SI designer acknowledgment, Pondster remains the only question recipient and voice wake name, and only the location/address stays confidential with the witness-protection joke. AI design labels, simulated lighting and viewing, unavailable owner tools, and the absence of live house controls remain explicit. Publication and final runtime validation are recorded separately in [[Project Rooms/Smart House/working/hosting-and-domain]].

## Brand prominence and logo motion — 2026-10-24

Wes requested a larger, predominant Pondster headline, an animated logo, and a single-line “Come meet me” heading on desktop. The shared header uses a large serif Pondster wordmark with a subordinate first-person tagline. View's forced heading break is removed; desktop keeps the phrase together, while phones may wrap naturally if needed. Keep all five navigation items usable and the brand readable at narrow widths.

Wes then requested a more animated logo with a stylized growing vine and fireworks. The current header draws a curling vine around the P/HOME monogram and beneath the wordmark, opens seven leaves, and finishes with two small bursts. The sequence finishes within 4.8 seconds and replays on pointer entry or keyboard focus. The earlier light sweep/glint now runs once. Reduced-motion preferences show a static vine and hide fireworks, with no hover lift. The artwork is decorative and cannot block the home link or menu. See the version 24 release in [[Project Rooms/Smart House/working/hosting-and-domain]].
