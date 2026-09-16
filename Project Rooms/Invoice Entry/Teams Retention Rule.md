# Invoice Entry Teams Retention Rule

## Authority And Scope

Wes's standing policy: Invoice Entry operational work and its transaction history belong in Teams/SharePoint, not the Admin wiki Git repository. Apply this automatically; do not ask Wes to override retention for each invoice. This rule controls over older Invoice Entry instructions that place operational status, logs, summaries, or registers under repository `working` or `sources` paths. It does not change another Project Room's ownership, central messaging protocol, approval gates, or workbook validation requirements.

## What Goes Where

- **Teams/SharePoint:** invoices, statements, receipts, time cards, source packets, attachments, drafts and final outputs, workbook copies, approval/delivery evidence, transaction-specific decisions, duplicate checks, processing and action logs, held-detail registers, source inventories, archive records, current work/status queues, and validation results. Markdown and JSON are operational data when they describe actual transactions; their file format does not make them wiki policy.
- **Admin wiki/GitHub:** reusable skills, SOPs, rules, schemas, templates, scripts, and generic process lessons. Static pointers to the Teams record locations are allowed. Do not reproduce invoice identities, amounts, row allocations, approval histories, or transaction-level status in those pointers or lessons.
- **Local temporary storage:** use a task artifact/temp folder outside the Git repository when local processing is necessary. Do not stage or commit these files. Retain unresolved evidence safely until its Teams copy is verified.

## Record Location And Startup

Keep original/final business documents and active workbooks in their established authoritative Teams/property folders; this rule does not relocate them. Keep supporting Invoice Entry records in the established SharePoint site `https://lifeisanadventure.sharepoint.com/sites/SellYourHome`, drive-relative folder `Office Admin/Scanned Files/Invoice Entry Working Archive/Operational Records`. Resolve the parent through the SharePoint connector; create the `Operational Records` child if absent after verifying the parent. Durable records and handoffs must identify the SharePoint site plus drive-relative path and, when available, the item URL or ID. Never use a sender computer's local synced path as the authoritative identity.

Use a local synced path only when a desktop application or local script requires filesystem access. Resolve it on the computer performing the work with `tools\sharepoint\Resolve-SharePointSyncedPath.ps1`, requiring an expected child such as `work-status.md`. Run the fallback through an approved local execution path under the signed-in Windows profile when the Codex sandbox cannot see OneDrive. The resolver checks that profile's registered sync roots and refuses missing or multiple matches. A resolved local path is temporary execution evidence; do not copy it into cross-machine instructions as though it were portable.

Preserve familiar logical record names beneath that root: `work-status.md`, `source-inventory.md`, `missing-context.md`, `duplicate-and-conflict-log.md`, `lowes-statement-held-detail-register.md`, `scanned-document-action-log.md`, `teams-working-archive-map.md`, and transaction packet/processing-log subfolders. These are Teams records, not Git-tracked files. Instruction references to those operational `working` filenames mean their Teams equivalents under this rule. Schemas, workflow instructions, scripts, and generic lookup configuration remain in the wiki.

The canonical current-status filename is `work-status.md`. The former `work-status-OfficeAssist.md` is retained only as migration evidence and must not receive new updates. On 2026-09-15 its newer content was promoted to `work-status.md`; the prior stale `work-status.md` was preserved in the dated legacy archive before replacement.

Before processing, read the Teams current state and the exact packet/processing evidence. Preserve canonical transaction IDs and verified outcomes so the move of a record never causes a repeated invoice, email, workbook entry, or upload. Follow the existing central messaging protocol separately; do not replace its authoritative records with a Teams copy or change routing/automation targets.

## Older Records And Safe Migration

Older records already in the wiki remain read-only historical evidence until migrated. Do not start a second empty ledger merely because the Teams record is absent. Reconcile the existing state, copy the in-scope operational record to Teams, verify content and file identity, then use that Teams record for subsequent updates. If the migration overlaps another owner's work, preserve the source and report that exact ownership issue; do not edit their files.

The 2026-09-15 repository-retention migration archived 124 former Git-tracked operational files under `Operational Records/Legacy Git Archive/2026-09-15 Repository Retention Cleanup`, preserving relative paths and recording SHA-256 verification in `migration-manifest.json`. Current operations must use the live records directly under `Operational Records`; the dated archive is historical evidence, not a writable queue.

Do not delete, truncate, revert, or remove tracked history until the authoritative Teams copy has been verified and the specific cleanup is authorized. A policy change alone does not authorize bulk migration, historical Git rewriting, or discarding uncommitted work. Existing pending transaction-log edits must not be swept into the policy commit.

## Completion And Failure Handling

Save the operational outcome and duplicate-prevention state to Teams and verify the saved record before reporting recordkeeping complete. Archiving working files must preserve the established source references and verify count/bytes or content/hash as applicable. A successful workbook entry remains successful even if later recordkeeping fails: report the separate Teams-recording blocker and do not repeat the business action.

If Teams is unavailable, preserve temporary evidence outside Git, report the exact access/save blocker, and resume the same record once access returns. Do not use a Git commit as a retention fallback or ask for blanket approval to publish operational data.

Routine invoice completion creates no Git commit or push. Commit/push only separately authorized reusable policy, skill, schema, template, or script changes under the normal Git rules. Keep operational data out of that commit even when Wes says to finish, commit, or push the workflow.
