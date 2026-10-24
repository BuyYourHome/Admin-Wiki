# Pondster identity and website guide

## Owner instruction — 2026-10-23; implementation — 2026-10-24

Wes directly named the house **Pondster**, asked for viewers and potential owners to speak to it by name and receive a response anywhere on the website, and identified **Jean Wright as the SI designer**, who can be referred to by name. Preserve the supplied role exactly; no expansion of SI was supplied. The property address remains **908 Pond Street** and the existing domain remains https://pondstr.com .

## Current website implementation

- Pondster is the header brand, page metadata identity, Design introduction, Explore and Manage identity, View introduction, and footer identity. Jean Wright is credited as SI designer in the introduction, footer, guide introduction, and named-answer content.
- A persistent Talk to Pondster control is mounted outside the five menu sections, preserving the guide conversation during navigation among Design, Explore, View, Built By, and Manage.
- Typed questions and quick prompts work without microphone access. The guide provides bounded public website answers and can navigate to room galleries, the viewing page, owner plans, or simulated lighting moods. It is a deterministic website guide, not an unrestricted general AI service or a live connection to Jean's chat.
- Browser speech recognition and speech synthesis provide optional named voice interaction where supported. Listening starts only after the visitor chooses Listen and grants microphone permission. Say Pondster or Jean Wright with a question. Speech replies are opt-in; starting Listen enables them, and the visitor can turn them off or request Read aloud.
- Listening status, Stop voice, close, Escape, and unsupported/denied/service error messages are visible. Close, Stop, and leaving the active tab stop listening; late recognition results cannot reopen it. The guide pauses recognition while it speaks, then resumes an explicitly requested listening session. It remains mounted while changing menus.
- The browser's speech service may receive audio. The interface discloses this before microphone use. The website has no audio upload endpoint, transcript database, owner identity verification, or real house control. Conversation state is temporary component memory, limited to recent messages.
- Only public facts are available. Saying someone is an owner does not reveal private records or unlock owner functionality. Votes require their actual gallery buttons. Viewing appointments and codes remain clearly simulated; no voice request sends a message, confirms a booking, or unlocks the house.

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
