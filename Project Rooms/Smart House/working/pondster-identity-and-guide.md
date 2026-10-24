# Pondster identity and website guide

## Owner instruction — 2026-10-23; implementation — 2026-10-24

Wes directly named the house **Pondster**, asked for viewers and potential owners to speak to it by name and receive a response anywhere on the website, and identified **Jean Wright as the SI designer**, who can be referred to by name. Preserve the supplied role exactly; no expansion of SI was supplied. The property address remains **908 Pond Street** and the existing domain remains https://pondstr.com .

## Current website implementation

- Pondster is the header brand, page metadata identity, Design introduction, Explore and Own identity, View introduction, and footer identity. Dean Wright is acknowledged as SI designer in plain-text credit and public role answers. The credit does not open a designer persona or conversation.
- A persistent Talk to Pondster control is mounted outside the five menu sections, preserving the guide conversation during navigation among Design, Explore, View, Own, and Built By.
- Typed questions and quick prompts work without microphone access. All questions are directed to Pondster. The guide provides bounded public website answers and can navigate to room galleries, the viewing page, owner plans, or simulated lighting moods. It is a deterministic website guide, not an unrestricted general AI service or a live connection to a designer's chat.
- Browser speech recognition and speech synthesis provide optional named voice interaction where supported. Listening starts only after the visitor chooses Listen and grants microphone permission. Say Pondster with a question; Jean Wright and Dean Wright are not wake names. A legacy question about Jean Wright receives the current Dean Wright designer credit from Pondster. Speech replies are opt-in; starting Listen enables them, and the visitor can turn them off or request Read aloud.
- Listening status, Stop voice, close, Escape, and unsupported/denied/service error messages are visible. Close, Stop, and leaving the active tab stop listening; late recognition results cannot reopen it. The guide pauses recognition while it speaks, then resumes an explicitly requested listening session. It remains mounted while changing menus.
- The browser's speech service may receive audio. The interface discloses this before microphone use. The website has no audio upload endpoint, transcript database, owner identity verification, or real house control. Conversation state is temporary component memory, limited to recent messages.
- Only public facts are available. Saying someone is an owner does not reveal private records or unlock owner functionality. Votes require their actual gallery buttons. Viewing appointments and codes remain clearly simulated; no voice request sends a message, confirms a booking, or unlocks the house.
- Each public page retains a comment section for visitors' thoughts. Questions use the Ask Pondster control; comments do not create another named assistant or designer conversation.

## Source and future work

Authoritative facts come from Wes's direct identity/role instruction, the existing supplied gallery/video catalog, verified Ashley profile/contact, and existing website behavior. No private operational notes are used as guide answers.

Browser API references: [SpeechRecognition](https://developer.mozilla.org/en-US/docs/Web/API/SpeechRecognition), [continuous results](https://developer.mozilla.org/en-US/docs/Web/API/SpeechRecognition/continuous), and [SpeechSynthesis](https://developer.mozilla.org/en-US/docs/Web/API/SpeechSynthesis). Recognition has limited browser support and some implementations send audio to a remote service. Never claim universal availability or wholly local audio processing.

Future unrestricted conversational AI, authenticated owner knowledge, and real house commands need separately identified service/account configuration and access rules. Home Assistant continues to own live integration/configuration. No provider account, credential, paid service, voice likeness, or device integration is created by this update.

Deployment and validation: see [[Project Rooms/Smart House/working/hosting-and-domain]].

## Validation

Focused resolver checks pass for the identity, exact Jean role, all six galleries and eleven current choices, simulated scenes, video, voting boundaries, simulated viewing, Ashley contact, owner restrictions, and unavailable facts. TypeScript checking and the production build pass.

Local browser checks confirmed Jean's answer, requested Front Elevation navigation, persistent conversation through Explore/View/Manage, and a requested Evening scene changing only the illustration. Escape closes the panel and returns keyboard focus to the launch control. A phone preview confirmed 375-pixel page/content width with the corrected panel entirely inside the viewport (left 12, right 363) and its bottom at 764 in an 844-pixel-high viewport.

No microphone was opened for testing and no ambient audio was captured. Actual speech recognition and audible playback are implemented but have not been verified end to end with a live microphone. They remain dependent on browser support, microphone permission, and the browser's speech service. Typed questions and page navigation were verified in the browser. No live lock, appointment, message, or production vote was initiated by these checks.

Published as Sites version 7 at https://pondstr.com . The custom-domain browser check confirmed the Pondster identity and Jean Wright response. Public audience and the existing domain were preserved.

## Current public anonymity — 2026-10-24

Wes directed the public site to remove the property address for now and say that Pondster needs to start anonymously. This supersedes earlier public address wording while retaining the internal property association for room operations. Public greetings, location answers, title/description, brand marks, footer, and viewing-request email links must withhold the address. The current copy says: "I need to start anonymously for now." The page-asset source and Ashley portrait are documented in [[Project Rooms/Smart House/working/viewing-and-realtor]].

## Pondster-only questions and designer acknowledgment — 2026-10-24

Wes's latest direct instruction is: "You can acknowledge Dean wright as the SI designer. But questions will only be directed to Pondster." Use **Dean Wright** for the current public SI designer credit. This supersedes the earlier Jean Wright public credit and dual-name interaction direction. Keep the original intake and prior validation above as historical records.

Pondster is the only question recipient and voice wake name. Dean Wright's credit is static text, without a click action or separate persona. Legacy Jean Wright questions may identify the current designer credit in Pondster's answer, but neither designer name activates listening or redirects a question. Public comments remain available for thoughts, and their Ask Pondster control sends questions to the house guide.
