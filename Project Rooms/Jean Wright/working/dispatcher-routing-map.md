# Jean Dispatcher Routing Map

Updated: 2026-08-04

Use this map when Jean Wright routes work to a specialized Project Room. A task/thread id of `pending` is a visible routing blocker: Jean must not create a substitute task, perform the specialized work locally, or send the work to another PR. Create PR must record a usable dedicated task/thread id before the room becomes dispatchable.

This is the live task registry for the universal [[Project Room Delegation Contract]]. Every listed Project Room is subject to that contract, whether its task is registered, pending, parent-routed, or otherwise explicitly blocked.

| Project Room | Matching Skill | Known Task/Thread Id | Dispatcher Route | Notes |
| --- | --- | --- | --- | --- |
| Admin Wiki Maintenance | pending | pending | Jean handles only when Wes authorizes shared Admin governance work. | No matching skill at rollout. |
| AIOS | `aios` | pending | Route planning or AIOS system-design work here. | Active/planning. |
| Amortization | `amortization` | pending | Route amortization-table support here, usually as a support handoff from Contract for Deed or spreadsheet work. | Support PR. |
| Brynda Suit | `brynda-suit` | `019f61c3-d4c0-7a52-a5a0-e4066ea9b303` | Route Brynda Suit source review and response drafting here. | Do not send replies without Wes approval unless that PR's rules authorize it. |
| CMA Report | `cma-report` | pending | Route CMA/property-report work here. | Per-property CMA rooms are child/output rooms. |
| CMA Report - 5009 Sunnyfield Dr | shared `cma-report` | pending | Route through CMA Report. | Per-property output room; no separate skill. |
| CMA Report - 5021 Sunnyfield Dr | shared `cma-report` | pending | Route through CMA Report. | Per-property output room; no separate skill. |
| CMA Report - 5512 Desert Willow Ln | shared `cma-report` | pending | Route through CMA Report. | Per-property output room; no separate skill. |
| Codex Environment | `codex-environment` | `019f84d0-78d4-7013-8c07-42c01f961be1` | Route Codex/machine environment setup and replication here. | Use for multi-machine readiness. |
| Computers | `computers` | `019f96e9-c663-7550-bf20-5829f6cb6c88` | Route computer inventory, specs, and device-readiness work here. | Distinct from Codex app behavior. |
| Confidential | `confidential` | `019f47a8-b32a-73a0-9bc4-9e493f1b0c5e` | Route confidential sensitive-source organization here. | Keep handoffs minimal and avoid unnecessary source copying. |
| Contract for Deed | `contract-for-deed` | pending | Route seller-financing and CFD package work here. | Uses Email Monitor for delivery. |
| Create PR | `create-pr` | `019f8be8-ab4a-7d63-a9e6-b3924b6e960c` | Route PR creation, standardization, and relationship-diagram mode here. | New PRs should be dispatcher-ready. |
| Credit Worthiness Evaluator | `credit-worthiness-evaluator` | pending | Route buyer credit-worthiness evaluation work here. | Coordinate with Contract for Deed only under scoped handoff. |
| Dashboard | `dashboard` | `019fc52f-858a-72e1-926b-a0f6fbf0fd89` | Route local Dashboard source, configuration, refresh-tool, and Dashboard-documentation work here only. | Dedicated Dashboard task verified. Local-only unless Wes explicitly authorizes publication. |
| Doc Scan | `doc-scan` | `019ecc0d-02b4-73a3-9c20-dacda5d811d0` | Route scanned-document process design, active scan-processing questions, and scanned-statement intake here before Invoice Entry. | Existing dedicated Doc Scan task verified 2026-08-04; Invoice Entry handoffs route onward only after Doc Scan prepares structured packets. |
| Email Monitor | `email-monitor` | `01a029bf-81d2-76e1-9960-64558a57640b` | Route mailbox summaries, email intake routing, and Email Delivery mode to the OfficeAssist task. | Email delivery authority for OfficeAssist sends; predecessor WesStudio task `019ecba7-f1cc-7ac1-aaf7-d89a3f21b582` is rollback-only pending post-cutover verification. |
| Entity Relationship | `entity-relationship` | pending | Route entity relationship diagrams and entity-mapping work here. | Planning/diagram PR. |
| Facebook Engagement | `facebook-engagement` | `019fe20a-db88-7602-a4a7-544d1be0ceee` | Route authorized photo review and Facebook Page post-draft work here. | Dedicated task confirmed by Wes on 2026-08-08; no Google Photos access or external Facebook action is authorized by task registration alone. |
| Estate Documents | pending | pending | Route only if Wes identifies estate-document organization or creates a skill. | Source/manual room at rollout. |
| Geico Insurance Claim | pending | pending | Route only if Wes identifies insurance-claim work or creates a skill. | Source/manual room at rollout. |
| Gracious Millionaire | `gracious-millionaire` | `019eb9b0-6780-7fb3-a278-29a18d17998c` | Route book manuscript and GM source work here. | Website work may belong to REI BlackBook. |
| Investigate Computer | `investigate-computer` | pending | Route computer-health investigation automation work here. | Uses Email Monitor when outbound email is required. |
| Invoice Entry | `invoice-entry` | `019fbf4f-c629-7dd1-a3f6-0de33de0ed8f` | Route invoice, receipt, statement, and time-card processing here through the durable dispatch queue before task notification. | Keep source documents outside Git; require the same dispatch ID in the durable accepted receipt. |
| Jean Wright | `jean-wright` | current Admin Operations chat | Owns dispatcher, general admin instructions, OfficeAssist coordination, and cross-PR routing. | Do not create another Jean Wright chat unless Wes asks. |
| Jean's Voice | shared `jean-wright` | `019fbe57-fcd9-7c83-be74-e377c7b9c4d0` | Route every Wes business/admin request directly to Jean Wright task `019e8e54-f8c3-7233-88dd-e1dffd79c9a6`. | Voice interface only; do not create worker tasks or perform specialized work locally. |
| Jennys Drawings | `jennys-drawings` | `019f700e-419a-7280-ba62-c01fe032b5b7` | Route Jenny's drawing/source organization and review packets here. | Uses Email Monitor for delivery. |
| LD Evans | `ld-evans` | `019f6ffe-d7b7-71f0-87d7-17b8e453f59e` | Route LD Evans manuscript/source work here. | Uses Email Monitor for delivery. |
| Lowes Order | `lowes-order` | `019f5845-fb96-7370-baf2-b8f00fddffae` | Route Lowes order workflow work here if still active. | Determine active/archive status when next used. |
| Marketplace | `marketplace` | `019fb5b0-6c29-7b32-822b-aa13b5920c29` | Route Facebook Marketplace tool sourcing, resale-profit evaluation, Messenger offer/conversation work, and seller-agreement reporting here. | Requires authorized Facebook/Messenger browser session; email notifications use Email Delivery rules. |
| Manager | `manager` | `019f8274-5b7e-7170-a051-f7944954de82` | Route Josh/manager task-register work here. | Email Monitor obtains Manager Tasks from this task. |
| Network Roadmap | `network-roadmap` | `01a02e19-01af-79a1-a770-42298d31eed6` | Route network identity, device-management, and messaging transport planning here. | Active dedicated task; exact approval is required before infrastructure changes. |
| Home Assistant | `home-assistant` | `01a02e53-5f75-7103-b5e7-17b842547cef` | Route Home Assistant configuration, automation, diagnostics, backups, and updates here. | Active dedicated task; exact approval is required for consequential changes. |
| New Project | `new-project` | pending | Route new real-estate project setup workflow here. | Create PR owns PR creation; New Project owns property project creation workflow. |
| Operating Agreements | `operating-agreement` | pending | Route operating-agreement drafting and source work here. | Skill folder name is singular. Rename only with explicit authorization. |
| Project Management Spreadsheet Rewrite | shared `template-to-project` | pending | Route through Template to Project unless Wes revives this as separate active work. | Legacy/planning room. |
| Property Trade Evaluation | `property-trade-evaluation` | pending | Route property trade case-study/evaluation work here. | Confirm source spreadsheet/property context before analysis. |
| REI BlackBook | `rei-blackbook` | `019f4691-5466-7f72-9683-ab5d3b750c25` | Route GM Site and REI BlackBook website/worktools work here. | Uses Email Monitor for completion email delivery. |
| SOPs | `sops` | pending | Route SOP creation, extraction, and maintenance here. | SOP source material should follow SOP room rules. |
| Sync GetHub | `sync-gethub` | `01a02a26-6ffa-7e52-a8ce-825ca0bfe3f0` | Route Admin wiki repository freshness checks, computer enrollment, and safe clean fast-forward work here. | Dedicated task registered. WesStudio automation is active; other computers require separate installation and verification. |
| Template to Project | `template-to-project` | pending | Route project spreadsheet template and worksheet-mode rollout work here. | Also owns Project Management Spreadsheet Rewrite continuation by default. |
| Voices | `voices` | pending | Route voice likeness, TTS, avatar/video, and consent-governance work here. | Planning PR. |

## Handoff Defaults

- Default mode: `route-and-return`.
- Use `route-and-monitor` only when Wes asks Jean to monitor or when the handoff is an email/delivery safety workflow that must report verification.
- Use `multi-pr-bundle` only when the destination scopes are distinct and each handoff can be made independently.
- If no task/thread id is known or it is `pending`, Jean reports the destination and blocker instead of creating a new task, performing the work locally, or substituting another PR.
