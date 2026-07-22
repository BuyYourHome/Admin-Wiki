# Initial Technology Workplan

## Goal

Move from a broad idea into a controlled pilot that can read selected text in Wes's voice without losing control of voice samples, generated audio, or distribution.

## Recommended First Pilot Shape

Start with a private text-to-speech pilot before avatar video:

- input: one short, low-sensitivity text sample;
- output: downloadable audio file in Wes's voice;
- review: Wes listens and approves quality before any broader use;
- storage: keep test input, output, and notes in this project room or another Wes-approved private location;
- external service use: only after Wes approves the service and purpose.

This keeps the first test focused on voice quality, privacy, and workflow reliability before adding avatar complexity.

## Technology Categories To Research

| Category | What To Check | Notes |
|---|---|---|
| Voice cloning / custom voice TTS | Voice sample requirements, consent process, supported languages, file export, API access, commercial-use terms, deletion controls. | Current vendor documentation required before recommendation. |
| Local or private TTS | Whether acceptable quality can be achieved without uploading Wes's voice to a third-party hosted service. | May reduce privacy risk but can add setup complexity. |
| Document reading integrations | PDF, Word, web, email, SharePoint, Teams, markdown, clipboard, and browser workflows. | Prioritize the formats Wes wants read first. |
| Avatar video | Face likeness requirements, presenter options, script length limits, rendering time, watermarking, disclosure, and review controls. | Treat as a second phase unless Wes wants video first. |
| Automation/API layer | How Codex, scripts, or workflow tools can pass text to the voice service and retrieve output files. | Avoid permanent automation until the service and governance are chosen. |
| Storage and audit | Where samples, generated files, approvals, and vendor notes should live. | Sensitive identity material should have a clear location and retention rule. |

## Candidate Architecture

```text
Source text
  -> extraction/cleanup step
  -> approval or edit checkpoint
  -> voice generation service
  -> audio/video output
  -> review checkpoint
  -> approved storage or sharing destination
```

## Guardrails

- Do not upload voice samples until Wes approves the exact service.
- Do not use highly sensitive documents for early tests.
- Keep generated audio/video labeled as synthetic during pilot testing.
- Separate personal listening from business-facing publishing.
- Record vendor terms and test dates because this market changes quickly.

## Next Decision

Choose the first pilot target:

1. Private reading of documents or web pages.
2. Internal narration for business/admin materials.
3. Customer-facing audio or video.
4. Avatar video proof of concept.
