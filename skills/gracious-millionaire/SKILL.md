---
name: gracious-millionaire
description: Use for Gracious Millionaire book and project-room work, including routed source-email intake, manuscript notes, chapter drafts, source ledgers, continuity review, heartbeat processing rules, and outputs under `Project Rooms\Gracious Millionaire`.
---

# Gracious Millionaire

## Source Of Truth

- Project room: `C:\Codex\Wiki Files\Project Rooms\Gracious Millionaire`
- Intake rules: `C:\Codex\Wiki Files\Project Rooms\Gracious Millionaire\working\intake-heartbeat-rules.md`
- Registry entry: `C:\Codex\Wiki Files\Agents and Automations Registry.md`
- Admin wiki source: `C:\Codex\Wiki Files`

Use this skill for Gracious Millionaire project-room processing. OfficeAssist email monitoring is owned by the OfficeAssist/Email Summary heartbeat, not by this project-room skill.

## Required Startup

1. Confirm the working folder is `C:\Codex\Wiki Files`.
2. Read `Admin Home.md`, `AGENTS.md`, `Project Room Workflow.md`, and `Project Rooms\Gracious Millionaire\README.md`.
3. Read `working\intake-heartbeat-rules.md`, `working\source-inventory.md`, `working\duplicate-and-conflict-log.md`, and `working\missing-context.md`.
4. Check `git status --short --branch` before durable edits.

## Workflow

1. Identify whether the request is source intake, manuscript development, continuity review, output drafting, or heartbeat-rule maintenance.
2. Preserve routed source emails as separate Markdown files under `sources\email\` when the active workflow calls for source routing.
3. Expect Email Summary, OfficeAssist, or another approved mailbox-checking workflow to direct-message this project-room thread after routing a Gracious Millionaire email, including the routed source path and short summary. Treat that direct message as the primary processing trigger; use the project-room heartbeat only as backup for already-routed files.
4. Update source inventory and intake logs before drafting from new source material.
5. Keep manuscript notes and drafting analysis in `working\`.
6. Put review-ready drafts or final outputs in `outputs\`.
7. Mark unsupported factual or autobiographical claims instead of smoothing them into narrative.

## New Subject Material Default

When new substantive Gracious Millionaire book/source material arrives, run Interview mode first and then Rewrite mode unless Wes explicitly limits the task to intake, formatting, a typo fix, or another narrow action.

Interview mode should first turn the new material into source-grounded Jean/Wes/Jenny interview or conversation scenes with role boundaries, question maps, source-confidence notes, and voice/fairness review. Rewrite mode should then integrate that interview-informed material into the whole manuscript so chapter context, themes, redundancy, sequencing, and chapter jobs are reconsidered across the book.

## Manuscript Packaging

Generated manuscripts and clickable review packets should include one AI-generation/provenance note near the beginning of the manuscript. Do not place repeated GPT, AI-generation, source-process, or model-explanation notes at the top of each chapter.

Generated manuscripts and clickable review packets should include the current Gracious Millionaire book cover at the top before the outline. Use `outputs/book-cover/gracious-millionaire-book-cover-wes-and-jenny-browning-2026-07-10-email.jpg` for review packets and `outputs/book-cover/gracious-millionaire-book-cover-wes-and-jenny-browning-2026-07-10.png` for full-resolution use unless a newer cover is explicitly marked current.

## Rewrite Mode

Use Rewrite mode when Wes says `Rewrite mode`, asks for a whole-manuscript rewrite where each chapter should materially affect the others, or expresses concern that a rewrite is not changing enough as the source base grows.

Also use Rewrite mode after the required Interview mode pass for new substantive subject material.

Before drafting in Rewrite mode, read `Project Rooms\Gracious Millionaire\working\rewrite-mode.md` and follow it. The required Rewrite mode steps are:

1. Create a source-to-chapter map.
2. Create a whole-book thesis map.
3. Create a redundancy and contradiction map.
4. Create chapter job statements for every chapter or section.
5. Write a true source-packet-based manuscript rewrite.

Rewrite mode is not a polish pass. Do not simply start from the latest manuscript and smooth, bridge, or lightly rephrase it. Use the latest manuscript only as a reference; draft from authoritative source packets, the source maps, the whole-book thesis map, the redundancy/contradiction map, and the chapter job statements.

If most chapters change only lightly, do not label the work a full Rewrite mode pass. Mark it as a polish, integration, or continuity pass instead.

## Dialogue Mode

Use Dialogue mode when Wes says `Dialogue mode`, asks for the manuscript to become a conversation between Wes and Jenny, or asks for a conversational version of chapters or the whole manuscript.

Before drafting in Dialogue mode, read `Project Rooms\Gracious Millionaire\working\dialogue-mode.md` and follow it. The required Dialogue mode steps are:

1. Build a source-to-speaker map.
2. Create a conversation chapter map.
3. Define the role of each speaker.
4. Create chapter conversation goals.
5. Convert source material into dialogue scenes.
6. Add source-confidence labels in working notes.
7. Reduce repeated lessons through conversation.
8. Run a voice and fairness review.
9. Produce the manuscript and review packet.

Dialogue mode should read like a crafted book dialogue, not a fake transcript. Do not invent Jenny's side where source material does not support it, and do not put Wes's conclusions into Jenny's voice unless Jenny source material supports that conclusion. Where one side is missing, keep the passage as narration, have the other speaker ask an unanswered question, or mark the need for more source material.

## Interview Mode

Use Interview mode when Wes says `Interview mode`, asks for Jean to interview Wes and Jenny, or asks for a manuscript version where interview questions guide the conversation.

Also use Interview mode first for new substantive subject material before any Rewrite mode integration pass.

Before drafting in Interview mode, read `Project Rooms\Gracious Millionaire\working\interview-mode.md` and follow it. The required Interview mode steps are:

1. Build a source-to-role map.
2. Create an interview chapter map.
3. Create a Jean question map.
4. Define speaker boundaries.
5. Create chapter interview goals.
6. Convert source material into interview scenes.
7. Add source-confidence labels in working notes.
8. Reduce repeated lessons and questions.
9. Run a voice and fairness review.
10. Produce the manuscript and review packet.

Interview mode builds from Dialogue mode but adds Jean as a source-grounded interviewer. Jean is the AI office assistant mentioned in the book and employed by Wes and Jenny. Jean should be active editorial, emotionally intelligent, and willing to press into the human meaning of the material rather than sounding mechanical or procedural. Jean may ask, clarify, bridge, invite contrast, and point out tension, and may draw from approved contextual project-room sources not directly provided by Wes or Jenny when forming interview questions. There are no artificial limits on what Jean can ask; she may ask direct questions about faith, money, marriage, leadership, caution, regret, motives, patience, risk, and unresolved outcomes. The guardrail is on unsupported answers, unsupported factual assertions, and forced conclusions, not on honest questions.

Interview mode manuscripts should revolve around themes Jean presents, with property sequence supporting those themes rather than controlling the whole manuscript. Unanswered questions should remain visible as live struggles when the source material has not resolved them. Jean must not supply unsupported facts or conclusions, and must not put contextual-source material into Wes's or Jenny's mouth unless their own source material supports it. Avoid reader-facing process language such as "the source says," "the transcript preserved," or "the input states"; frame questions naturally as "in your book," "in the material you gave me," "in one of your videos," or by naming the lived event directly. Some scenes may be direct Wes/Jenny dialogue; other scenes may be Jean asking a question that Wes or Jenny answers. Use the speaker label `Jean`.

For Interview mode, Jean may draw from approved YouTube transcripts, teaching notes, video/source notes, and related working notes to sharpen questions. Build and maintain a source library for the Buy Your Home YouTube channel `@buyyourhome8397` with video title, URL, date when available, description, transcript when available, and any owned/authorized video or audio download location when the full recording is useful for tone, sequence, or visual context.

## Boundaries

- Do not call the workflow `Project LumenScale`.
- Do not attach mailbox checking to the Gracious Millionaire project-room heartbeat.
- Do not query Outlook directly from this skill unless Wes explicitly authorizes that action in the current request and the Admin rules allow it.
- Do not send book responses, create new chats, delete source files, or push Git changes from heartbeat processing unless Wes explicitly asks.
