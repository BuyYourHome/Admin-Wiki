# Gracious Millionaire

## Matching Skill

- Skill source: `C:\Codex\Wiki Files\skills\gracious-millionaire\SKILL.md`

## Purpose

This project room gathers source material for a book called *Gracious Millionaire*.

The separate emails in `sources/email/` are early chapter starts, fragments, and seed ideas. They should be treated as source material for a book manuscript, not as ordinary correspondence.

## Scope

- Preserve each email as its own markdown source file.
- Use the emails as chapter seeds and thematic source material.
- Preserve Wes's writing voice, especially the reflective, story-driven, faith-centered style documented in `working/writing-style-guide.md`.
- Before rewriting manuscript sections, check `working/manuscript-edit-and-fact-notes.md` for current factual corrections, framing changes, perception notes, and open editorial direction.
- Use [[rewrite-mode|Rewrite mode]] when Wes asks for a source-based whole-manuscript rewrite where the context of one chapter should materially influence all others. Rewrite mode requires source-to-chapter mapping, whole-book thesis mapping, redundancy/contradiction mapping, chapter job statements, and a true source-packet-based rewrite rather than a light polish of the latest manuscript.
- Use [[quick-mode|Quick mode]] when Wes asks to add new source material into the manuscript without a total rewrite. Quick mode inserts new or changed material into its proper manuscript context, applies only narrow continuity edits around the insertion point, and leaves unrelated chapters materially intact.
- Use [[dialogue-mode|Dialogue mode]] when Wes asks for a manuscript shaped as a give-and-take conversation between Wes and Jenny. Dialogue mode requires source-to-speaker mapping, conversation chapter mapping, speaker role notes, chapter conversation goals, source-confidence labels, and a voice/fairness review so dialogue is source-grounded rather than invented transcript.
- Use [[interview-mode|Interview mode]] when Wes asks for Jean to interview Wes and Jenny. Interview mode builds from Dialogue mode but adds Jean, the AI office assistant mentioned in the book and employed by Wes and Jenny, as a source-grounded interviewer who may draw from approved contextual project-room sources to ask stronger questions, invite contrast, and sometimes step aside for direct Wes/Jenny dialogue.
- For Interview mode, the only manuscript reference allowed is the current Quick-mode manuscript. Interview mode still drafts from original source material and approved contextual source records; the Quick-mode manuscript is used only as the current sequence/inclusion reference, not as factual authority.
- For new substantive book/source material received by the project room, use Quick mode only by default. Quick mode should place the new material into its proper manuscript context, apply only narrow continuity edits around the insertion point, and preserve unrelated chapters. Use Interview mode, Rewrite mode, or Dialogue mode only when Wes directly requests that mode.
- Mode independence rule: no manuscript mode output is source material for another manuscript mode. Original source files, inventories, correction notes, factual notes, style guides, book objectives, and approved contextual source records are the controlling inputs. Interview, Dialogue, Rewrite, and clickable packet outputs may be checked for coverage or presentation history, but they must not become the prose base, factual authority, source packet, or compression target for another mode.
- Unless Wes explicitly asks for an abridged, summary, or condensed manuscript, full-manuscript Rewrite mode should preserve the substantive depth and scale of the source-backed manuscript while reducing true redundancy.
- In generated manuscripts and clickable packets, place the AI-generation/provenance explanation once near the beginning of the manuscript. Do not put repeated GPT or AI-explanation notes at the top of each chapter.
- Include the current Gracious Millionaire book cover at the top of generated manuscripts and clickable packets. The current cover asset is `outputs/book-cover/gracious-millionaire-book-cover-wes-and-jenny-browning-2026-07-10-email.jpg` for review packets and `outputs/book-cover/gracious-millionaire-book-cover-wes-and-jenny-browning-2026-07-10.png` for full-resolution use.
- Use modular manuscript outputs for efficient compilation. Each mode may keep one Markdown file per chapter under `outputs/<mode-slug>/chapters/` with `outputs/<mode-slug>/manifest.md` controlling order, title, status, cover, version id, and compiled output path.
- For Quick mode, the current modular manuscript state is `outputs/quick-mode/manifest.md` plus `outputs/quick-mode/chapters/*.md`. The normal review deliverable is the compiled clickable HTML at `outputs/Gracious Millionaire - Quick Mode.html`.
- Do not edit compiled HTML directly. Edit the relevant chapter Markdown file and/or manifest, then rebuild the HTML with `tools/manuscript_modules.py build --manifest outputs/quick-mode/manifest.md` using the Codex workspace Python runtime.
- A full single-file Markdown manuscript is optional. Generate it only when Wes asks for a plain Markdown export, a tool requires it, or a delivery workflow specifically needs it. The chapter files plus manifest are the working manuscript state.
- Modular chapter files are manuscript-state files for their mode, not factual source material. Original project-room source files, inventories, factual notes, correction notes, style guides, book objectives, and current Wes/Jenny direction remain the source authority.
- New OfficeAssist instruction emails with a subject containing `gracious millionaire`, or otherwise clearly belonging to the Gracious Millionaire book/project-room workflow, should be routed into this room as source material by the OfficeAssist email monitor. The OfficeAssist monitor should not attach its mailbox-monitoring heartbeat to the Gracious Millionaire thread, create a new chat, or process the writing task unless Wes explicitly asks for processing there.
- Preserve routed OfficeAssist emails as individual Markdown files under `sources/email/`, including available sender, recipients, sent/received time, subject, message id or web link, and body text.
- When Wes authorizes any Codex role to check email and that check finds a Gracious Millionaire email, the role that performed the mailbox check must immediately preserve that email as an individual Markdown source file under `sources/email/`, update `working/officeassist-intake-log.md`, and send a direct follow-up message to the existing Gracious Millionaire project-room thread with the routed source path and a short summary. Do not wait for a separate routing instruction after the email is found.
- Current Gracious Millionaire project-room thread id for manual project-room work: `019eb9b0-6780-7fb3-a278-29a18d17998c`.
- Do not create a new chat for routed Gracious Millionaire emails unless Wes explicitly asks for one.
- Active project-room heartbeat automation: `gracious-millionaire-project-room-heartbeat`, defined at `C:\Users\wesbr\.codex\automations\gracious-millionaire-project-room-heartbeat\automation.toml`.
- Direct message handoff from OfficeAssist or another approved mailbox-checking process is the primary processing trigger for newly routed Gracious Millionaire emails. The heartbeat checks the project room every 15 minutes from 8:00 AM through 11:45 PM Eastern in the current local config and is only a backup processor for newly routed Markdown/source items that contain clear Gracious Millionaire writing instructions.
- Naming rule: do not call this project-room process `Project LumenScale`. Use plain names such as `Gracious Millionaire project-room process`, `Gracious Millionaire project-room heartbeat`, or `Gracious Millionaire project room`.
- Intake-heartbeat behavior is defined in [[intake-heartbeat-rules]]. The Gracious Millionaire project-room role may act only on markdown files, project-room source files, intake logs, and other source material already dropped into this project room by OfficeAssist or another approved process.
- When this project-room role finds a new routed Markdown file or intake-log item with a clear Gracious Millionaire writing instruction, it should begin processing that source under the intake-heartbeat rules instead of only reporting that the file exists.
- This project-room role must not query Outlook, OfficeAssist mail, Wes mail, Jenny mail, or any mailbox directly. It only processes Markdown/source files already dropped into the Gracious Millionaire project room. If Wes asks whether a new email exists, answer from routed project-room files and intake logs only, or tell Wes that OfficeAssist must route the email first.
- Maintain a stable current Jenny clickable chapter review packet at `outputs/jenny-chapter-review-current/Gracious Millionaire - Jenny Clickable Chapter Review - CURRENT.html`. After significant manuscript changes, regenerate this current packet from the current mode's manifest and chapter files when a modular manuscript exists; otherwise regenerate it from the latest full manuscript so Jenny can click chapter links and read the current chapter text one by one.
- Include the Foreword in the clickable outline whenever a manuscript version has a Foreword; do not start the outline at the Introduction unless the manuscript itself has no Foreword.
- When sending a clickable outline email, include the current manuscript word count, estimated page count, and a brief comparison to typical book lengths. Use the current manuscript word count when available. Use a formatted PDF/DOCX page count when one exists; otherwise estimate page count at about 250 words per manuscript page and label it approximate. Compare the word count in plain language to common nonfiction ranges such as short book or novella length around 20,000-40,000 words, standard nonfiction around 50,000-80,000 words, and longer trade nonfiction above 80,000 words.
- Significant manuscript changes include new chapters, removed or reordered chapters, major chapter rewrites, full-manuscript revision passes, and fact corrections that materially affect chapter content. Minor typo fixes do not require resending the packet unless Wes asks.
- After regenerating the current Jenny clickable chapter review packet for a significant manuscript change, send it from `OfficeAssist@BuyYourHomeLLC.com` to `Jenny@BuyYourHomeLLC.com` and copy `WesWill@BuyYourHomeLLC.com`, then verify the sent copy in OfficeAssist Sent Items.
- The Gracious Millionaire project-room role may use the shared `skills\email-delivery\SKILL.md` workflow for this review-packet email only. This permission applies to the heartbeat too when it has just processed a new chapter, major chapter rewrite, full-manuscript revision pass, or fact correction that materially affects chapter content.
- If a heartbeat prompt contains a generic `do not send email` boundary, read it as `do not send unrelated email`; it does not override the specific Jenny review-packet send requirement after a significant manuscript change.
- The project-room heartbeat still must not query any mailbox directly, send unrelated email, approve invoices, move money, modify legal or financial documents, delete source files, create new chats, or take unrelated external actions.
- If the Jenny review-packet email cannot be sent or verified safely through the OfficeAssist email-delivery workflow, notify Wes immediately in this Gracious Millionaire thread with the blocker and the intended attachment path.

## Current Status

Started. Initial email source files were created from the retrievable messages in the `WesWill@BuyYourHomeLLC.com` Outlook folder before the mailbox boundary was tightened. Going forward, mailbox intake belongs to OfficeAssist or another approved intake process, not this project-room role.

- `Inbox/Gracious Millionaire`
- `Inbox/Gracious Millionaire/Tribes`

## Next Actions

- Decide whether each email is a chapter opening, a chapter section, an appendix note, or a discarded fragment.
- Build a chapter map from the source themes.
- Use Rewrite mode for the next full-manuscript rebuild if Wes expects source growth to materially change chapter structure, emphasis, or sequencing.
- Use Dialogue mode when Wes wants the same source material tested as a Wes/Jenny conversational manuscript.
- Use Interview mode when Wes wants Jean to guide the same source material through interview questions with Wes and Jenny.
- Monitor the active intake heartbeat and refine processing rules as new routed chapter sources arrive.
## Start PR Pointer

Before durable work, follow Start PR Mode in `C:\Codex\Wiki Files\Project Room Chat Startup Rule.md`.

Interpret unqualified requests under the Current PR Scope Rule in that file. Work on `main` unless Wes explicitly asks for a branch.
