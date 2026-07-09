# Interview Mode

## Purpose

Use Interview mode when Wes asks for the Gracious Millionaire manuscript to be shaped as an interview conducted by Jean with Wes and Jenny.

Interview mode is based on Dialogue mode, but it adds Jean as an active interviewer. Jean is the AI office assistant mentioned in the book and employed by Wes and Jenny. Some passages may be direct dialogue between Wes and Jenny. Other passages may have Jean asking a question that Wes or Jenny answers. The result should read like a crafted book interview, not a fake transcript or staged Q&A.

Use the speaker label `Jean`.

## Trigger

Use this mode when Wes says `Interview mode`, asks for Jean to interview Wes and Jenny, or asks for a manuscript version where interview questions guide the conversation.

If Wes asks only for Dialogue mode, Rewrite mode, an outline, typo fix, or clickable-outline repair, do not use Interview mode unless he explicitly asks.

## Required Inputs

Before drafting, read and use:

- `working/source-inventory.md`
- `working/duplicate-and-conflict-log.md`
- `working/missing-context.md`
- `working/writing-style-guide.md`
- `working/book-objectives.md`
- `working/manuscript-edit-and-fact-notes.md`
- `working/dialogue-mode.md`
- all authoritative Wes source files needed for the current manuscript span
- all authoritative Jenny source files needed for the current manuscript span
- approved contextual project-room sources that can help Jean ask better questions, including contextual source sets, prior working notes, source inventories, video/source notes, and manuscript fact notes
- the latest manuscript only as a reference, not as the interview base

## Required Steps

1. Build a source-to-role map.
   - Identify which material came from Wes.
   - Identify which material came from Jenny.
   - Identify which contextual project-room sources did not come directly from Wes or Jenny but may help Jean ask informed questions.
   - Identify what Jean may ask based on Wes sources, Jenny sources, contextual sources, contradictions, missing context, or chapter goals.
   - Mark material that should remain narration because neither Wes nor Jenny has source support for saying it directly.
   - Save the map in `working/` with a versioned name such as `interview-v1-source-to-role-map.md`.

2. Create an interview chapter map.
   - Decide which chapters should be Jean-led interviews.
   - Decide which chapters should contain mostly Wes/Jenny dialogue with only light Jean framing.
   - Decide which Jenny chapters should stay whole and separate, with Jean introducing, questioning, or inviting Wes to respond around them instead of absorbing them.
   - Identify chapters where Jean should not appear because the material works better as uninterrupted memoir or direct dialogue.
   - Save the map in `working/` with a versioned name such as `interview-v1-chapter-map.md`.

3. Create a Jean question map.
   - Draft the questions Jean should ask in each chapter or section.
   - Tie each question to a Wes source, Jenny source, contextual project-room source, tension, correction, missing-context note, or book objective.
   - Mark questions that are leading, speculative, repetitive, or unsupported so they can be revised or removed.
   - Save the map in `working/` with a versioned name such as `interview-v1-jean-question-map.md`.

4. Define speaker boundaries.
   - Wes may answer from his memories, source material, interpretation, spiritual lessons, business lessons, and unfinished learning.
   - Jenny may answer from her memories, caution, safety concerns, emotional reality, practical questions, corrections, and her own source material.
   - Jean may ask, clarify, bridge, invite contrast, and point out tension.
   - Jean may draw from approved contextual project-room sources not directly provided by Wes or Jenny when forming interview questions, transitions, and prompts.
   - Jean should not supply independent facts or conclusions not grounded in the project-room sources, and should not put contextual-source material into Wes's or Jenny's mouth unless their own source material supports it.
   - Save the boundaries in `working/` with a versioned name such as `interview-v1-speaker-boundaries.md`.

5. Create chapter interview goals.
   - For every chapter or section, state what the interview is trying to uncover.
   - Identify where Jean should ask a direct question, where Wes and Jenny should speak to each other, and where brief narration should carry the story.
   - Identify where unresolved tension should remain unresolved rather than forced into agreement.
   - Save the goals in `working/` with a versioned name such as `interview-v1-chapter-goals.md`.

6. Convert source material into interview scenes.
   - Use brief setting paragraphs only where needed.
   - Let Jean ask direct, source-grounded questions.
   - Let Wes and Jenny answer, clarify, correct, challenge, and occasionally speak directly to each other.
   - Keep the interview from becoming mechanical; vary question length, answer length, direct dialogue, and narration.
   - Do not invent a transcript or imply the interview actually happened unless the source says it did.
   - Save the manuscript in `outputs/` with a versioned name such as `Gracious Millionaire - Interview Manuscript v1.md`.

7. Add source-confidence labels in working notes.
   - `direct source`: the question or answer is clearly supported by source material from that speaker.
   - `faithful reconstruction`: the phrasing is a reasonable reconstruction based on that speaker's source material.
   - `contextual source`: Jean's question or transition is informed by approved project-room source material not directly provided by Wes or Jenny.
   - `interviewer inference`: Jean's question is inferred from a source tension, open question, contradiction, or book objective.
   - `unsupported`: do not include in the manuscript unless Wes approves or new source material supports it.
   - Save the labels or audit in `working/` with a versioned name such as `interview-v1-source-confidence-audit.md`.

8. Reduce repeated lessons and questions.
   - If several chapters repeat the same lesson, let one interview carry it fully.
   - Let later chapters echo the lesson briefly through a Jean callback or a Wes/Jenny callback.
   - Avoid having Jean ask the same question in different words across multiple chapters.

9. Run a voice and fairness review.
   - Check that Jean does not lead the witnesses or force the conclusion.
   - Check that Jenny is not used only as a foil, critic, or editor.
   - Check that Wes's voice remains reflective and honest.
   - Check that both Wes and Jenny are allowed to disagree, correct, or leave something unresolved where the sources support that tension.
   - Check that Jean's questions serve the manuscript instead of drawing attention to Jean.
   - Save the review in `working/` with a versioned name such as `interview-v1-voice-and-fairness-review.md`.

10. Produce the manuscript and review packet.
   - Save the Interview mode manuscript as a separate output version.
   - Create a clickable outline by chapter or interview scene.
   - Include a note that the interview manuscript is generated from source material and is not a verbatim transcript.

## Guardrails

- Do not invent Jenny's answers where source material does not support them.
- Do not invent Wes's answers where source material does not support them.
- Do not let Jean provide unsupported facts, spiritual conclusions, or business conclusions.
- Do not let Jean turn contextual project-room material into a claimed memory, belief, or conclusion from Wes or Jenny unless Wes or Jenny source material supports that attribution.
- Do not make Jean the main character.
- Do not flatten tension between Wes and Jenny into easy agreement.
- Where an answer is missing, have Jean ask the question and leave it unanswered, keep the passage as narration, or mark the need for more source material.

## Quality Gate

Before treating the Interview mode manuscript as review-ready, create a short `working/` note that answers:

- Which chapters were Jean-led interviews?
- Which chapters remained mostly Wes/Jenny dialogue?
- Which Jean questions came directly from source material?
- Which Jean questions were informed by contextual project-room source material not directly provided by Wes or Jenny?
- Which Jean questions were interviewer inferences?
- Where did Jenny's source material directly shape the answers?
- Where did Wes's source material directly shape the answers?
- What additional Jenny or Wes source would make the interview stronger?

## Delivery Rule

An Interview mode manuscript is a significant manuscript change. After the review-ready manuscript is created, regenerate the stable current Jenny clickable chapter review packet and send it through the approved OfficeAssist workflow unless Wes gives a stricter recipient instruction for that specific send.
