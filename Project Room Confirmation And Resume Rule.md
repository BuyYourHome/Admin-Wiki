# Project Room Confirmation And Resume Rule

Mandatory for every existing and future Project Room, delegated workflow, and automated intake. This is the global confirmation fallback, not a new approval requirement for already-authorized work.

## When To Ask

- First verify the existing user instruction, standing authority, exact scope, and applicable restrictions. A change of chat or machine alone does not require renewed permission.
- Ask only when a real authorization gap, material scope change, reserved decision, or explicit platform/tool confirmation requirement prevents the next action. Never invent a universal requirement to repeat financial details or acknowledge risk for every send.
- Technical failures require diagnosis or a concrete technical decision, not renewed business approval. An uncertain previous external action requires reconciliation, not a YES that could cause a duplicate.
- No rule here overrides platform permissions, safety review, ownership boundaries, or required action-time confirmation. Do not change tools or execution paths to evade a refusal.

## Mandatory Question Before Ending The Turn

The action-owning PR must present one concise, self-contained question when approval is the actual blocker. A bare `Needs Wes`, `Blocked`, or "authorize this package" is insufficient.

Use this pattern with actual verified details, not placeholders:

> Approval needed [request ID]: May I [exact action] on [exact resource/version] for [exact recipients or destination]? [Material effect or sensitive information involved.] This does not authorize [excluded actions]. Reply YES to proceed or NO to decline.

For email, identify actual From, To, CC/BCC, subject, attachment name/version and material contents, plus any required exclusion. For workbook changes identify the authoritative workbook, intended rows/changes, and duplicate check. Apply the equivalent exact-resource summary to purchases, deletion, publishing, legal documents, account changes, and other gated actions. Disclose material risks plainly without demanding ceremonial wording.

If a platform approval UI is required, use it; a chat YES is not a substitute for that UI. If direct confirmation must occur in the executing chat, identify its exact name and machine and provide the ready-to-answer question. Do not represent an agent-forwarded YES as a direct user message.

## Preserve And Resume

1. Preserve the prepared artifact/package, request ID, immutable hash/version, verified authority, refusal evidence, duplicate checks, submission certainty, owning chat, exact question, and remaining steps in the workflow's existing approved runtime or Teams/SharePoint state. Do not put transactional approval logs in Git.
2. Notify the originating PR of the precise decision needed through its authorized return path. Retain the continuation even if the existing messaging protocol closes this attempt as `Needs Wes`; do not invent a new central state or rewrite immutable records.
3. A direct user YES unambiguously answering the displayed question authorizes that exact action within applicable rules. Wes need not restate every listed detail or say "go" afterward. If several questions are pending and the answer is ambiguous, ask only which request he means. Silence is never approval.
4. Before execution, revalidate package identity, scope, current restrictions and duplicate/external-action evidence. Changed recipients, attachments, amounts, target resources, or material effects require a new scoped question. Do not reuse the old YES for a changed package.
5. Resume the remaining authorized steps immediately when the answer is received and the gate permits. Verify the external outcome, record evidence, and return the result to the originating PR. Never repeat a verified action, reset delivery attempts, or automatically retry an uncertain submission. Use the existing supported linked-continuation mechanism where a terminal transport record needs follow-up.
6. A NO declines only the proposed action unless Wes says otherwise. Record it in the approved operational state, notify the origin, and do not re-prompt on unchanged scheduled runs. Continue independent work still authorized.
7. If approval still does not satisfy the platform, retain the exact sanitized refusal and report the remaining limitation. Do not enter a repeated YES loop, claim success, or seek a workaround to the denial.

## Visibility And Completion

- Surface the question in the same turn that establishes the approval blocker. On unattended work, use the existing authorized attention surface; if notification itself cannot be delivered, report that limitation in the chat and retained status. Do not claim Wes was notified without evidence.
- Keep pending questions visible in the existing attention list with request ID, owner, question, and next step. No new polling automation or schedule change is authorized by this rule; unchanged pending requests should not create repeated notifications.
- The originating PR retains end-to-end responsibility for tracking the outcome; delegation, acceptance, or a confirmation request is not business completion. The receiving PR owns its action and return evidence.
- This rule cannot guarantee an unloaded chat wakes up. Report execution/wake-up failure separately from missing approval. Do not ask for renewed invoice or email approval to fix a transport failure.

## Required Review Cases

A compliant workflow must handle: existing exact authority without re-prompting; a genuine gate with a specific YES/NO question; YES and automatic continuation; NO and no action; ambiguous YES; changed package; uncertain prior send; continued platform refusal; and an unavailable receiving chat. Review these cases when changing an affected workflow.
