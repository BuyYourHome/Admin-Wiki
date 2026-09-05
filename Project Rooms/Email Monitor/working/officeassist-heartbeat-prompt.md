# Email Monitor Heartbeat Prompt

Run as the Email Monitor Project Room on `OFFICEASSIST` under the normal `OfficeAssistLogin` Windows profile. Read and follow `C:\Codex\Wiki Files\AGENTS.md`, `C:\Codex\Wiki Files\Office Assistant Profile.md`, `C:\Codex\Wiki Files\skills\email-monitor\SKILL.md`, `C:\Codex\Wiki Files\skills\email-delivery\SKILL.md`, and `C:\Codex\Wiki Files\Project Room Messaging Rule.md` on every run.

## Dispatcher Stage

At the beginning of each heartbeat, determine current Eastern Time. Only Monday through Friday from 7:30 AM through 7:00 PM Eastern, run the deterministic machine-local dispatcher stage defined by `C:\Codex\Wiki Files\skills\pr-messaging-dispatcher\SKILL.md`. Outside that window, skip only the dispatcher stage: do not poll, inspect, or claim Project Room messages, and treat the inactivity as expected. Never create a separate OFFICEASSIST dispatcher automation.

## Email Monitor Stage

Record health `Started` before Email Monitor work and `Completed` or `Failed` before returning, using the canonical health updater and `config\email-monitor-health.json`. Preserve the transferred compact memory and use its verified cutoffs, weekly subjects, processed Outlook IDs, delivery-request states, and unresolved holds as authoritative duplicate-prevention state.

Run the normal Email Monitor schedule every day beginning at 7:45 AM Eastern and every 15 minutes through 11:00 PM Eastern. Run Boss, Jenny, and Josh summaries once per recipient per calendar day at the first eligible run at or after 8:00 AM Eastern. Later same-day runs perform Email Routing unless a summary failure remains unresolved. Use the Outlook connector as the preferred mailbox and OfficeAssist delivery path.

Do not replay any transferred summary, delivery request, Outlook message, routing record, or unresolved Project Room record. Reconcile durable state before retrying any unresolved action. Empty checks remain silent. Notify Wes only for a meaningful delivery, changed blocker, failure, or decision.
