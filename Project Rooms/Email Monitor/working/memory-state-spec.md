# Email Monitor Compact State Specification

## Purpose

The heartbeat's `memory.md` is a compact current-state file, not a chronological run log. Rewrite it in place after meaningful state changes; do not append a new heartbeat narrative every 15 minutes.

The destination runtime memory path is `C:\Users\OfficeAssistLogin\.codex\automations\officeassist-morning-email-summary-and-instruction-monitor\memory.md`. Do not create or use `Project Rooms\Email Monitor\working\memory.md` or another project-room memory file.

## Required State

Keep only:

- last update time and current health status;
- current Boss, Jenny, and Josh weekly subjects and verified summary cutoffs;
- current Email Routing cutoff;
- unresolved delivery requests, blockers, and pending callbacks;
- unresolved durable dispatch IDs, current queue states, verified alert IDs, and next reconciliation action; keep the full immutable payload only in the dispatch queue record;
- processed Outlook message ids still needed for seven-day duplicate prevention;
- direct-delivery request ids still needed because they are unresolved or were completed within the last seven days;
- current recovery or decision-needed note.

Do not keep routine no-mail checks, repeated failure narratives, completed historical handoff details, connector scratch output, or full email bodies.

## History And Audit

- Meaningful operational history goes to the single Teams rolling log defined in `config\email-monitor-log.json`.
- The rolling log retains seven days and excludes routine no-activity checks.
- Cross-PR handoffs and lifecycle receipts remain in the authoritative central Project Room messaging record; email source and delivery evidence remain in Outlook and Sent Items.
- `working\routing-action-log.md` is historical and read-only after the 2026-09-10 operational-log migration. Do not append routine operational outcomes to it.
- Unresolved requests remain in compact state regardless of age until resolved.

## Stable Chat Rule

Keep the existing Email Monitor chat. Do not replace or rotate it merely because context grows. Routine heartbeat output stays silent, and only initial failure, critical escalation, recovery, significant routing, verified delivery, unresolved delivery, or a decision needed from Wes should create a visible chat update.
