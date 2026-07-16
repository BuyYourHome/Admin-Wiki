# Dialogue Mode

## Purpose

Use Dialogue mode when Wes asks for the Gracious Millionaire manuscript to be shaped as a conversation between Wes and Jenny.

Dialogue mode turns source material into a crafted book dialogue where the source base supports it. It should read like a give-and-take conversation, not a fake transcript. The mode may use brief narration and scene-setting where needed, but the manuscript should favor Wes and Jenny asking, clarifying, challenging, remembering, correcting, and reflecting together.

## Trigger

Use this mode when Wes says `Dialogue mode`, asks for the manuscript to be written as a conversation between Wes and Jenny, or asks for a conversational version of chapters or the whole manuscript.

If Wes asks only for an outline, typo fix, clickable-outline repair, or normal manuscript rewrite, do not use Dialogue mode unless he explicitly asks.

## Required Inputs

Before drafting, read and use:

- `working/source-inventory.md`
- `working/duplicate-and-conflict-log.md`
- `working/missing-context.md`
- `working/writing-style-guide.md`
- `working/book-objectives.md`
- `working/manuscript-edit-and-fact-notes.md`
- `working/book-architecture.md`
- all authoritative Wes source files needed for the current manuscript span
- all authoritative Jenny source files needed for the current manuscript span
- the latest manuscript only as a reference, not as the dialogue base

## Required Steps

1. Build a source-to-speaker map.
   - Identify which material came from Wes.
   - Identify which material came from Jenny.
   - Mark material that can only be narrated because only one voice exists.
   - Mark anything that must not be put into Jenny's mouth without a Jenny source.
   - Save the map in `working/` with a versioned name such as `dialogue-v1-source-to-speaker-map.md`.

2. Create a conversation chapter map.
   - Use the current Book Architecture for sequence, story coverage, voice ownership, themes, dependencies, and unresolved questions.
   - Decide which chapters can become true Wes/Jenny dialogue.
   - Decide which chapters should remain mostly Wes narration with Jenny questions or responses.
   - Decide which Jenny chapters should stay whole and separate, with Wes responding around them instead of absorbing them.
   - Save the map in `working/` with a versioned name such as `dialogue-v1-conversation-chapter-map.md`.
   - Document any intentional departure from the current Book Architecture.

3. Define the role of each speaker.
   - Wes may carry memory, interpretation, spiritual lesson, business lesson, and unfinished learning.
   - Jenny may carry caution, safety, memory from her side, emotional reality, practical questions, and correction.
   - Jean/GPT voice, if used at all, should provide only light transitions and should not replace Wes or Jenny.
   - Save the speaker role notes in `working/` with a versioned name such as `dialogue-v1-speaker-role-notes.md`.

4. Create chapter conversation goals.
   - For each chapter or section, state what the conversation is trying to uncover.
   - State what question, tension, correction, or shared discovery should move the chapter.
   - Identify where the chapter should preserve unresolved tension instead of forcing agreement.
   - Save the goals in `working/` with a versioned name such as `dialogue-v1-chapter-conversation-goals.md`.

5. Convert source material into dialogue scenes.
   - Use short setting paragraphs only where needed.
   - Let Wes and Jenny ask, challenge, clarify, remember, and correct.
   - Preserve disagreement or tension instead of smoothing it away.
   - Keep Wes's voice reflective, story-driven, and faith-centered.
   - Keep Jenny's voice cautious, practical, safety-aware, and personally grounded where her sources support that voice.
   - Do not invent a transcript or imply the conversation actually happened unless the source says it did.
   - Save the manuscript in `outputs/` with a versioned name such as `Gracious Millionaire - Dialogue Manuscript v1.md`.

6. Add source-confidence labels in working notes.
   - `direct source`: the spoken idea is clearly supported by source material from that speaker.
   - `faithful reconstruction`: the dialogue phrasing is a reasonable reconstruction based on that speaker's source material.
   - `unsupported`: do not include in the manuscript unless Wes approves or new source material supports it.
   - Save the labels or audit in `working/` with a versioned name such as `dialogue-v1-source-confidence-audit.md`.

7. Reduce repeated lessons through conversation.
   - If several chapters repeat the same lesson, let one chapter carry it fully.
   - Let later chapters echo the lesson briefly through a callback between Wes and Jenny.
   - Avoid repeated conclusions that make the conversation feel staged or circular.

8. Run a voice and fairness review.
   - Check that Jenny is not used only as a foil, critic, or editor.
   - Check that Wes's voice remains reflective and honest.
   - Check that the dialogue does not make either person say something stronger, softer, or more certain than the sources support.
   - Check that Jenny's separate story material remains whole and recognizable when Wes has asked for it to stay separate.
   - Save the review in `working/` with a versioned name such as `dialogue-v1-voice-and-fairness-review.md`.

9. Produce the manuscript and review packet.
   - Save the Dialogue mode manuscript as a separate output version.
   - Create a clickable outline by chapter or scene.
   - Include a note that the dialogue is generated from source material and is not a verbatim transcript.

## Guardrails

- Do not invent Jenny's side where source material does not support it.
- Do not put Wes's conclusions into Jenny's voice unless Jenny source material supports that conclusion.
- Do not flatten tension between Wes and Jenny into easy agreement.
- Do not make either speaker omniscient about later lessons unless the source material supports that perspective.
- Where a speaker's side is missing, keep the passage as narration, have the other speaker ask an unanswered question, or mark the need for more source material.

## Quality Gate

Before treating the Dialogue mode manuscript as review-ready, create a short `working/` note that answers:

- Which chapters became true dialogue?
- Which chapters stayed mostly narration, and why?
- Where did Jenny's source material directly shape the chapter?
- Where did Wes's source material directly shape the chapter?
- Where did the draft use faithful reconstruction rather than direct source?
- What additional Jenny or Wes source would make the dialogue stronger?

## Delivery Rule

A Dialogue mode manuscript is a significant manuscript change. After the review-ready manuscript is created, regenerate the stable current Jenny clickable chapter review packet and send it through the approved OfficeAssist workflow unless Wes gives a stricter recipient instruction for that specific send.
