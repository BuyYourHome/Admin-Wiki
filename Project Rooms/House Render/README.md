# House Render

## Purpose and ownership

House Render owns house-design visualizations and their source/version inventory, initially for **908 Pond Street**. Wes requested this room and transfer of Pond Street renders from Smart House and LED lighting in Jean Wright turn `01a178cb-3302-7900-87a6-bd0e9845b13f`, delegated as `prmsg-jean-create-pr-house-render-20261026-001`.

Own render intake, approved image-generation/edit requests, visual comparisons, render provenance, version selection, and render deliverable storage. Smart House retains website, gallery, voting and digital-twin implementation; LED lighting retains electrical/component planning; Home Assistant retains device integration. No purchase, construction approval, live publishing, device control or another room's file edits follows from render ownership.

## Current status

Verified migration package complete: 225 source references mapped to 195 distinct copied and SHA-256-verified files. One historical render is missing; uncertain older exterior lineage remains explicitly excluded. Dedicated chat: pending until the committed package is created. Branch: main. Automation: none; on demand only.

Authoritative external render root: `C:\Users\wesbr\Buy Your Home\Buy Your Home - Property\26-BYH -908 Pond St\Owning\Planning\House Render`. Binaries never belong in Admin Wiki Git. Existing generated originals, old saved packages, and public Sites copies remain intact. The old-to-new/hash map is [[Project Rooms/House Render/working/render-migration-inventory]]. Read [[Project Rooms/House Render/working/missing-context]] before claiming the historical source set is complete.

## Messaging Readiness

- Dispatchable: No — Pending messaging registration - not dispatchable.
- Execution machine: WESSTUDIO.
- Task id: pending.
- Manifest: `C:\Codex\Wiki Files\config\pr-messaging-manifests\house-render.json` (completed after chat creation).
- Guarded installer release 0.4.9 only permits the exact Codex Environment and Smart House endpoints. House Render requires worker-owner support and unattended validation; do not bypass the enrollment guard or manually complete a synthetic.

## Folder map

- `sources\render-provenance.md`: original chat generation references; no copied binary sources.
- `working\source-inventory.md`: authoritative input map.
- `working\render-migration-inventory.md`: full source/destination/hash mapping.
- `working\migration-log.md`: this one-time migration's verification result.
- `working\duplicate-and-conflict-log.md` and `missing-context.md`: aliases, provenance gaps, readiness blockers.
- `outputs\`: Markdown deliverable links; render files stay under the external root.
- Matching skill: `C:\Codex\Wiki Files\skills\house-render\SKILL.md`.

## Workflow

1. Confirm property, source image or selected version, exact requested changes, and output purpose.
2. Consult the inventory before generating or copying; preserve history and distinguish selected concepts from superseded alternatives.
3. Use the available image-generation skill/tool for authorized raster generation or creative edits. Do not generate new images merely to fill missing historical files.
4. Review against the supplied source and request. Label AI concepts; do not claim measured geometry, approved finishes, as-built condition, or engineering validation.
5. Save deliverables outside Git with provenance and hashes. Use existing canonical messaging for cross-PR handoffs only after readiness passes; publication needs separate authority in Smart House.
6. Routine render transactions use external runtime/Teams records. Git contains policy and deliberate migration summaries, not every routine operation.

## Central operating rules

Start PR: Before durable work, follow Start PR in C:\Codex\Wiki Files\Project Room Chat Startup Rule.md. Interpret unqualified requests under the Current PR Scope Rule in that file. Work on main unless Wes explicitly asks for a branch.

Delegation Contract: Follow C:\Codex\Wiki Files\Project Room Delegation Contract.md. Jean may delegate this PR's work only to its registered task; accept and return the same dispatch id under the central contract.

Action Ownership: Follow C:\Codex\Wiki Files\Project Room Delegation Contract.md. Perform only this PR's documented actions. Delegate another PR's action to its registered task; a missing task/thread id is a blocker, never permission to perform it locally. Return accepted, done, blocked, needs Wes, or rejected as wrong room.

PR Messaging: Follow C:\Codex\Wiki Files\Project Room Messaging Rule.md. The central message record is authoritative; task messages are wake-up signals, not delivery proof.

Approval and resume: Follow C:\Codex\Wiki Files\Project Room Confirmation And Resume Rule.md. Preserve scoped work and ask the exact decision only when a real authorization gap exists.

