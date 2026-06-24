# Wes's Voice

## Purpose

Develop a practical, permissioned system so Wes's audible voice can be used to read text aloud, with an optional video avatar path for situations where a visual presenter is useful.

## Owner Intent

Wes wants to connect usable technologies that can:

- read documents, messages, scripts, or other text in Wes's audible voice;
- support review and approval before any public or business-facing use;
- potentially generate a video-avatar presentation in selected situations;
- preserve control over voice likeness, consent, source recordings, generated media, and distribution.

## Current Status

- Status: project room created; initial scope captured.
- Current phase: discovery and architecture planning.
- Controlling source: Wes's project instruction in the Codex thread on 2026-06-24.
- Next action: decide the first use case and gather candidate technology sources.

## Initial Workstreams

1. Voice capture and consent
   - Define acceptable recordings for training or voice matching.
   - Decide where voice samples may be stored.
   - Define approval rules for generated voice output.

2. Text-to-speech workflow
   - Identify tools that can create high-quality speech in Wes's voice.
   - Test reading from common sources such as Word documents, PDFs, web pages, emails, scripts, and markdown notes.
   - Decide whether the output should be live playback, downloadable audio, or both.

3. Avatar and video
   - Identify when a video avatar is useful versus unnecessary.
   - Evaluate whether avatar output should use Wes's face, a stylized presenter, or a non-human visual identity.
   - Define extra review rules before any video output is shared.

4. Integrations
   - Explore connections with local files, SharePoint, Outlook, Teams, browser reading, and project-room outputs.
   - Separate personal/private reading workflows from business-facing media generation.

5. Governance
   - Track tool terms, consent requirements, privacy controls, commercial-use rights, and revocation/deletion options.
   - Keep generated media and source recordings organized.

## Room Layout

- `sources\` - source notes, product research, policy/terms excerpts, tool evaluations, and Wes-provided recordings or links.
- `working\` - inventories, open questions, architecture notes, comparison matrices, and draft workflows.
- `outputs\` - review-ready recommendations, implementation plans, prompts, scripts, or final workflow documents.

## Operating Rules

- Do not upload Wes's voice recordings, face images, or identity materials to any external service unless Wes explicitly approves the service and purpose.
- Do not generate public, customer-facing, legal, financial, or business communications in Wes's voice without a review and approval step.
- Mark technology claims as unsupported until backed by current vendor documentation, terms, or tested behavior.
- Prefer reversible pilots with exportable files before committing to a platform.
