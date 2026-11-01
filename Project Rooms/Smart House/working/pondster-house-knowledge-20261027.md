# Pondster house knowledge and natural tour requests — 2026-10-27

## Request and diagnosis

Wes reported that Pondster often says it lacks a verified answer to questions about the house. His example was “Can you show me around the house?” This request began at `2026-10-28T01:10:35Z` (October 27 Eastern).

The natural-voice prompt required every substantive house question to delegate to a deterministic keyword guide, even when the model already had the relevant authored public facts. The guide rejected broad words such as bathrooms or equipment before checking known features, and ordinary room descriptions often returned a gallery inventory instead of the room's published plans. The example tour wording did not match the tour action.

## Intended answer contract

- Natural conversation uses the authored public website facts to answer questions and contextual follow-ups directly. Explicit website navigation, gallery, lighting illustration and virtual-tour actions still delegate and wait for the returned action before claiming completion.
- Describe known plans confidently in Pondster's first person, with future wording. Alternative finishes remain design choices. A plan is not proof of installation, approval or final equipment specification.
- The bounded typed/Browser guide uses published room/system features and proposed floor-plan summaries for ordinary house questions. The floor-plan summaries describe the proposed first floor; they do not establish a whole-house bedroom/bathroom count.
- “Can you show me around the house?” launches the existing View tour. It uses the existing one-shot action, not a new tour or voice backend.
- Qualify the specific missing detail instead of denying known parts of a question. Preserve limits for unknown pricing, property totals, equipment details, private location/access and live operations.
- Keep the existing approved key, Vesper voice, model, session limits, measured 30-second silence shutdown and farewell handling. No provider request or microphone capture is needed for code regression checks.

## Source boundary

Runtime facts come only from the public Site sources: `lib/features.js`, the current design catalog, `lib/floor-plan.ts` summaries and existing public page information. No Admin Wiki, owner records, private property sources or rendering history are imported into runtime. The selected TV mount remains the manual MM-MAX1; the automatic film remains illustrative.

Official references: [Live prompting](https://developers.openai.com/api/docs/guides/live-prompting), [Live delegation](https://developers.openai.com/api/docs/guides/live-delegation).

## Verification and release

Guide and Live-context regressions passed, including ordinary room/system questions, the exact tour phrase, proposed pantry/bedroom relationships, manual mount behavior and negative tests for private location, unknown equipment, asking price and whole-house counts. Mocked server/real-SQLite lifecycle checks also passed. Independent review found and corrected the interior-placement false refusal and preserved Contact as the last menu item. Only public room names and summaries enter the new layout context; no polygons or dimensions are imported.

The exact source/publication identifiers are in [[Project Rooms/Smart House/working/hosting-and-domain]]. A passing prompt/configuration test does not prove a spoken model response. Fresh audible behavior remains unverified until a real user conversation supplies evidence. No microphone, provider voice request, key, billing or session-record change was performed for these checks.
