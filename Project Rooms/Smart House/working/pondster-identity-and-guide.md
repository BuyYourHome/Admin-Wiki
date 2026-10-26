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
- Wes's requested hot-water recirculation, multi-person proximity/TV direction, personalized voice bath/shower, and exterior-camera/TV surveillance plans are public guide topics. Shared `systemFeatures` text is descriptive only; requests to operate these systems receive the plan plus an explicit no-live-control explanation. General security-camera questions may describe the plan; private credentials, owner profiles, footage/feeds, and unverified hardware details remain unavailable. No recognition technology or installed device is inferred.
- Browser speech recognition and speech synthesis provide optional voice interaction where supported. The default **Ask by voice** captures one explicitly addressed question without requiring a wake name, then stops recognition. **Keep listening for “Pondster”** is a separate opt-in named mode; the designer's name is not a wake name. Listening begins only on the visitor's button action and browser microphone permission. Starting voice enables spoken replies; the visitor can turn these off or request Read aloud. All questions still go only to Pondster.
- Recognized words appear in temporary “I heard” feedback, including unmatched wake requests. Microphone permission, missing microphone, blocked browser service, network failure, unsupported browser, and startup timeout have distinct recovery messages. Chrome/Edge are suggested alternatives, without a universal support guarantee. The interface distinguishes preparing speech from actual playback and exposes Stop during either, including output-only browsers.
- Close, Stop, Escape, and leaving the active tab stop voice; late recognition/speech callbacks cannot reopen it or replace current status. An idle tab change does not claim that listening was active. The guide pauses recognition while it speaks, then resumes an explicitly requested named session. Named mode reconnects after silence twice, stops after a third idle end, and resets that count when it hears words. Recognition startup is bounded to 10 seconds; speech startup to 8 seconds; active playback has a text-length duration watchdog capped at two minutes. It remains mounted while changing menus.
- The browser's speech service may receive audio. The interface discloses this before microphone use. The website has no audio upload endpoint, transcript database, owner identity verification, or real house control. Conversation state is temporary component memory, limited to recent messages.
- Only public facts are available. Saying someone is an owner does not reveal private records or unlock owner functionality. Votes require their actual gallery buttons. Viewing appointments and codes remain clearly simulated; no voice request sends a message, confirms a booking, or unlocks the house.
- Each public page retains a comment section for visitors' thoughts. Questions use the Ask me control to open Pondster; comments do not create another named assistant or designer conversation.

## Source and future work

On 2026-10-25 Wes authorized natural OpenAI voice. The public-only integration is prepared locally, while the existing browser guide remains the live implementation. Secure OpenAI Developers API setup and actual speech verification are pending. See [[Project Rooms/Smart House/working/pondster-natural-voice]]; do not infer that Codex's private session or credentials are exposed.

Authoritative facts come from Wes's direct identity/role instruction, the existing supplied gallery/video catalog, verified Ashley profile/contact, and existing website behavior. No private operational notes are used as guide answers.

Browser API references: [SpeechRecognition](https://developer.mozilla.org/en-US/docs/Web/API/SpeechRecognition), [continuous results](https://developer.mozilla.org/en-US/docs/Web/API/SpeechRecognition/continuous), and [SpeechSynthesis](https://developer.mozilla.org/en-US/docs/Web/API/SpeechSynthesis). Recognition has limited browser support and some implementations send audio to a remote service. Never claim universal availability or wholly local audio processing.

Future unrestricted conversational AI, authenticated owner knowledge, and real house commands need separately identified service/account configuration and access rules. Home Assistant continues to own live integration/configuration. No provider account, credential, paid service, voice likeness, or device integration is created by this update.

Deployment and validation: see [[Project Rooms/Smart House/working/hosting-and-domain]].

## Voice failure repair — 2026-10-24

Wes reported that Pondster's voice feature did not work. Review found silent discard of unmatched wake transcripts, an unguarded recognition constructor, stale cancelled-speech errors overwriting current feedback, and no timeout for stalled speech startup. The live embedded browser exposed the recognition and synthesis controls, which establishes API presence only; it does not prove the speech service works. No specific microphone/service root cause was established for Wes's attempt.

The repair uses an injected browser-speech controller with deterministic no-hardware tests covering direct questions, named requests and unmatched feedback, distinct failures, bounded idle reconnection, startup/playback timeouts, both recognition/speech completion orders, stale callbacks, tab hiding, and cleanup. TypeScript and the existing public-guide tests pass. Browser checks verify the new mode controls, typed fallback, keyboard close/focus recovery, and the panel fitting a 390×844 phone viewport without horizontal overflow. Actual microphone recognition and audible speaker playback were not exercised; neither microphone permission nor ambient audio was accessed. Browser/service dependence remains a real verification limit.

## Chrome owner confirmation — 2026-10-25

Wes answered the earlier diagnostic question: Chrome listened but did not answer. Read-only inspection of his open Chrome tab showed the old “Say my name. Ask about me.” / “Listen for Pondster” interface, without the published Ask by voice repair. The tab was idle, with no unfinished typed question. Refreshing that same tab loaded the current controls from the existing version 29 publication; no code change or new deployment was needed.

Wes then initiated Ask by voice himself. The page displayed recognized words, appended his question and Pondster's public feature reply, and showed “I’m speaking.” He answered the follow-up: **“It answers normally now.”** This confirms recognition and answering in the refreshed Chrome one-question flow, with owner-confirmed normal playback. Codex did not activate the microphone, grant microphone permission, or capture audio.

The existing deterministic voice tests and an additional no-file cumulative-result probe passed. Named continuous listening and other browsers were not validated by this owner check. Initial no-microphone limitations below remain historical evidence of the earlier checks, superseded for this explicit Chrome flow by the owner confirmation.

## Initial guide validation

Focused resolver checks passed for the identity, exact Jean role, all eight galleries and eleven then-current choices, simulated scenes, video, voting boundaries, simulated viewing, Ashley contact, owner restrictions, and unavailable facts. TypeScript checking and the production build passed. Later Master Bath additions are recorded in [[Project Rooms/Smart House/working/master-bath-color-concepts]].

Local browser checks confirmed Jean's answer, requested Front Elevation navigation, persistent conversation through Explore/View/Manage, and a requested Evening scene changing only the illustration. Escape closes the panel and returns keyboard focus to the launch control. A phone preview confirmed 375-pixel page/content width with the corrected panel entirely inside the viewport (left 12, right 363) and its bottom at 764 in an 844-pixel-high viewport.

During the initial checks no microphone was opened and no ambient audio was captured; actual speech recognition and audible playback had not yet been verified end to end. They depend on browser support, microphone permission, and the browser's speech service. Typed questions and page navigation were verified in the browser. No live lock, appointment, message, or production vote was initiated by those checks. See the later Chrome owner confirmation above for the successful one-question voice check.

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

Wes requested a larger, predominant Pondster headline, an animated logo, and a single-line “Come meet me” heading on desktop. The initial shared header used a large serif Pondster wordmark with a subordinate first-person tagline; the version 37 signature styling below supersedes that serif treatment. View's forced heading break is removed; desktop keeps the phrase together, while phones may wrap naturally if needed. Keep all five navigation items usable and the brand readable at narrow widths.

Wes then requested a more animated logo with a stylized growing vine and fireworks. The current header draws a curling vine around the P/HOME monogram and beneath the wordmark, opens seven leaves, and finishes with two small bursts. The sequence finishes within 4.8 seconds and replays on pointer entry or keyboard focus. The earlier light sweep/glint now runs once. Reduced-motion preferences show a static vine and hide fireworks, with no hover lift. The artwork is decorative and cannot block the home link or menu. See the version 24 release in [[Project Rooms/Smart House/working/hosting-and-domain]].

## Signature headline — version 37, 2026-10-25

Wes requested: “I want the head line Pondster to be a signature.” The published change scopes self-hosted Allura Regular to `.brand-name`, with 400 weight, normal letterspacing, 52–76px desktop sizing, and 60px mobile sizing. Existing green ink, vine/fireworks, tagline text, and accessible Pondster home-link text remain unchanged. A 16px mobile tagline top margin keeps it clear of the vine leaves.

Official source: https://github.com/google/fonts/tree/main/ofl/allura . The font uses OFL 1.1; its license ships alongside it in the public Sites source. TTF SHA256: `9C142B2E515832C0DFC4FF8B8EA18F40314943BF937B72E2B23C4661BAC14CC6`. Keep the font binary outside Admin Wiki Git.

Local Chrome at 1920×911 and 390×844 confirmed the loaded signature was readable and uncropped, with the mobile tagline clear of the vine. The production build and version 37 publication passed. Fresh https://pondstr.com/#design visually confirmed the signature, home link, menu, and existing header text. Proof is outside Git at `C:\Users\wesbr\.codex\visualizations\2026\10\25\pondster-signature-live.png`. Exact release identifiers are in [[Project Rooms/Smart House/working/hosting-and-domain]]. No production votes, comments, bookings, or voice usage occurred.

## Matching signature initial — version 38, 2026-10-25

Wes requested the signature's P in place of the serif P inside the square, and asked to see the result in chat. Use the same Allura signature face in `.monogram-initial` (52px desktop, 46px phone, line height .72). Preserve HOME in Arial, the square, vine/fireworks, accessible Pondster home link, and signature wordmark. Local desktop/phone fitting, the production build, and the published custom-domain initial were verified. Live proof: `C:\Users\wesbr\.codex\visualizations\2026\10\25\pondster-signature-p-live.png`. Exact publication identity is in [[Project Rooms/Smart House/working/hosting-and-domain]].

## One continuous signature — version 39, 2026-10-25

Wes clarified: do not repeat the P; continue the signature outside the square. This supersedes version 38's separate initial plus full wordmark. Render Pondster once as a single uninterrupted text node so Allura's P-to-o shaping remains natural. Place the decorative square behind its initial and let the lettering continue across its edge; the square contains only the HOME label. Preserve the accessible full-name home link, tagline, vine/fireworks, and phone fitting. Desktop/phone visual checks, production build, and live header verification passed. Proof: `C:\Users\wesbr\.codex\visualizations\2026\10\25\pondster-continuous-signature-live.png`. Release identity is in [[Project Rooms/Smart House/working/hosting-and-domain]].

## Approved I Am annotation — version 40, 2026-10-25

Wes requested "I Am" between P and d and required a preview before any page update. He approved the separate concept with "Publish." Keep the small copper Georgia italic words above "on" within that negative space, without splitting the Pondster text or adding another P. Base placement is left64/top9/type12px at a 76px signature, with the three dimensions scaling together via the scoped signature-size variable; phone signature size is 60px. Preserve the full-name accessible home link and mark the annotation decorative. Desktop/phone fit, build, and live custom-domain placement passed. Approved preview and live proof are outside Git at `C:\Users\wesbr\.codex\visualizations\2026\10\25\pondster-i-am-preview.png` and `pondster-i-am-live.png`. Exact release identifiers are in [[Project Rooms/Smart House/working/hosting-and-domain]].

## No vine — current, version 41, 2026-10-25

Wes rejected the botanical decoration with "Lose the vine," then explicitly authorized publication. The fuller climbing-vine concept remained a separate unpublished preview. Do not reintroduce any vine, leaves, or vine-growth animation without a new instruction. Keep the continuous Pondster signature, approved I Am annotation, square/HOME label, two firework bursts, monogram glint, and accessible home link. Source vectors and obsolete vine styles/keyframes are removed, rather than merely hidden. Local desktop/phone visual checks, build, and live verification passed; exact publication/proof is in [[Project Rooms/Smart House/working/hosting-and-domain]].

## Header sizing and visitor wording — version 43, 2026-10-25

Wes explicitly requested a 50% larger Pondster logo, the tagline "A home with a voice.", the Own eyebrow "Own / Your future Owner experience", and a one-line Design headline on computers with two lines on phones. Preserve these user-specified exceptions to first-person labels. The continuous signature, I Am placement, HOME frame, fireworks, accessible home link, and absence of a vine remain intact. Signature sizes are 78–114px desktop and 90px phone. Keep the tighter Design header gap and fit down to a 320px phone. Exact release and visual evidence: [[Project Rooms/Smart House/working/hosting-and-domain]].
## Exact approved headlines and Your HOME — version 44, 2026-10-25

Use "Virtually - A Reality" then "Have a say." on Design, retaining one desktop line and two phone lines. Explore uses "Get to know me." then "Like The Back Of Your Hand". These are direct Wes wording choices. Inside the square, burnt-orange "Your" now sits below the signature P and above HOME, using #a75936. Preserve the single uninterrupted signature, I Am, 50% enlarged scale, A home with a voice tagline, fireworks, and accessible home link. Release and visual proof: [[Project Rooms/Smart House/working/hosting-and-domain]].

## Explore wording correction — version 45, 2026-10-25

Wes corrected Explore to "Get to know me." followed by "Like The Back Of Your Room". This supersedes version 44's "Like The Back Of Your Hand" wording; retain that earlier section as release history. The production build and fresh live verification passed for version 45. Exact release details are in [[Project Rooms/Smart House/working/hosting-and-domain]]; live proof remains outside Git at `C:\Users\wesbr\.codex\visualizations\2026\10\25\pondster-back-of-room-live.png`.

## Room separation, Belong, and shared spacing — version 46, 2026-10-25

After pausing for clarification, Wes confirmed the exact British spelling **Home Theatre** and resumed the separation request. Living Room retains room ID `media-center` and six cabinet choices, `media-01` through `media-06`. Home Theatre retains room ID `spiral-staircase` and seven choices: `spiral-01` plus six `spiral-basement-{slug}` palettes. The catalog has 30 active choices across nine galleries. Retire `media-07` and six `media-basement-{slug}` duplicates from the visible Living Room catalog and scores, preserving historical vote rows, retained IDs, and all assets. The original theatre still and film belong only to Home Theatre; Living Room keeps its separate turning-TV film.

The current menu is **Design, Explore, View, Belong, Built By**. Belong is the visitor-facing page/comment label, with canonical `#belong`; legacy `#own`/`#manage` links, internal `Own` actions, and the `own` comments key remain compatible. All five pages use matching header-to-content top gaps of **20px desktop / 18px phone**.

Version 46 is live at https://pondstr.com; fresh live checks confirmed Living Room's six choices, Home Theatre's seven, and Belong navigation. See [[Project Rooms/Smart House/working/hosting-and-domain]] for exact release and verification details. Natural voice remains prepared but unpublished, pending secure API setup.

## Signed Explore heading — current, version 47, 2026-10-25

Use the exact feature heading "What makes me, Pondster." on Explore. Render only Pondster in the established Allura signature font, as accessible live text, with the period outside the signature span. Keep the version46 Living Room/Home Theatre separation,30 active choices, Belong menu and compatible IDs, and matching20px/18px page gaps. Local desktop/phone fit, build, and live checks passed. Release and proof: [[Project Rooms/Smart House/working/hosting-and-domain]].
