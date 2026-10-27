# Back Deck choice and logo greeting — 2026-10-27

## Authority and source

The combined request began at `2026-10-27T20:05:51Z` in the owning Smart House chat. Wes supplied two deck PNGs and expressly identified them as **one choice with two views**. He also asked: “Can Pondstr respond when I click or hover over the logo. Currently, I have to speak first”. The implemented scope is a brief greeting after explicit voice startup and a native hover invitation, with no microphone or audio startup from hover.

Authoritative read copies are in `C:\Users\wesbr\Buy Your Home\Buy Your Home - Property\26-BYH -908 Pond St\Owning\Planning\House Render\generated\Deck`. Wes also supplied links to the same files in the [SharePoint Deck folder](https://lifeisanadventure.sharepoint.com/sites/SellYourHome/Shared%20Documents/Property/26-BYH%20-908%20Pond%20St/Owning/Planning/House%20Render/generated/Deck/). Exact source sizes, hashes and public-copy mapping are in [[Project Rooms/Smart House/working/source-inventory#Back Deck oak courtyard views — 2026-10-27]]. Originals remain outside Admin Wiki Git.

## Published website behavior

- Back Deck gains one voting choice, `oak-courtyard`, titled **Oak courtyard deck**. `V13-REVIEW-908-Pond-Deck-Cleaned-Oak.png` is the overview; `Owner-Closeup-908-Pond-Deck-2026-10-27.png` is its closeup. Both were visually inspected as the same concept, without a visible address.
- Anonymous public copies are `/images/deck/oak-courtyard-overview.png` and `/images/deck/oak-courtyard-closeup.png`, byte-identical to their respective sources. They are two views of the same vote, not two voting choices. The overview is the Back Deck primary image for Explore and the tour.
- The published catalog contains 31 active choices across nine galleries. Populating Back Deck adds a seventh tour scene; the three existing films remain. These images are design concepts, not installation or construction-validation evidence.
- A new Natural conversation seeds a short trusted developer greeting and sends its instructions once through the trusted server sideband after the browser acknowledges provider `session.started`. The fixed acknowledgement contains no greeting text. The greeting begins “Hello, I’m Pondster. What would you like to know about me?” Vesper remains the selected natural voice; provider data-channel permissions, admission limits and cleanup rules are preserved.
- Explicit Browser voice startup uses the same short spoken greeting through browser synthesis. Recognition pauses during speech and resumes the selected question/wake mode afterward. Ordinary panel opening, typed Ask, mode changes and native hover do not start voice. The static chat introduction uses **voice and persona**.

The [official GPT-Live greeting guidance](https://developers.openai.com/api/docs/guides/live-conversations#greet-before-the-caller-speaks) supports the startup developer input plus one post-start `session.commentary.append`, with a unique event ID, null delegation ID and active input track. An acknowledgement establishes acceptance, not audible playback; the model may paraphrase or remain silent. The once-only gate governs the application prompt, not a promise of exact speech.

## Verification

Focused natural server/context/client and Browser voice mocks passed, including readiness timing, duplicate/cancelled/failed starts, trusted seed validation, and synthesis/listening pause-resume. Guide, tour and design-view checks passed for the current catalog. Final TypeScript, production build, source diff and 177-file private secret-absence scan passed. All 21 changed text mirrors match the independent checkout.

Browser automation initialization timed out once; that attempt provides no browser interaction verification. The local HTTP vote-write test failed with `EACCES` before its initial GET and retains prior-catalog expectations, so it was not a complete passing run and executed no write. Codex performed no production vote write, provider call or microphone capture for this request.

Version 65 is published. Live image HEAD requests returned HTTP 200 with image/png for both views; read-only Back Deck vote results returned HTTP 200 with zero total at verification, and voice status returned HTTP 200 with available=true. Wes confirmed: Yes, Pondster greets me first. Native request 16723377-bc0a-40b9-b058-4541fd859618 received a provider ID and closed with 94 seconds of provider-confirmed final usage (final_usage_confirmed=1). This verifies the fresh Vesper greeting and clean closure for this trial.

## Release — version 65

- Source: `3f679988b8e1a164fd49a27b6520d3eb554c8e6a`.
- Saved version: `appgprj_6ad4d98e08708191858cab113814704e~appgver_905826905abc8191aabd0e68690ac40a`.
- Deployment: `appgdep_6ae10951d3d48191bf95ec7ac739ecd9`, succeeded `2026-10-27T20:28:13.646080+00:00`, environment revision **4**.
- Archive: `sha256:2dd0836a153a6b34179ec925fbd0868b3c779b0da2cd1553ec45fb4b248977f6`, 125 files, 60467200 bytes.

The official source helper pushed and packaged the verified source. Public access is preserved. No production vote/comment write, provider voice call, new key or billing action was performed by Codex. Opening the public page in Codex returned queued. Source PNG chunk inspection found no text/EXIF chunks and no private location/path strings in the overview provenance chunk; original provenance remains intact.
