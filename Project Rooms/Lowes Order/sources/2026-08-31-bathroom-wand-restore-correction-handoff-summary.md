# Bathroom Fixtures Wand Restore Correction Handoff Summary - 2026-08-31

## Source

- Source Project Room: Bathroom Fixtures
- Source task id: `01a0432b-d780-7b01-aed3-e0af40daa663`
- Durable message id: `bathroom-lowes-20260831-restore-deleted-wand-component-v1`
- Dispatch id: `bathroom-dispatch-20260831-restore-deleted-wand-component-v1`
- Payload hash: `250ae6f15393ce1ba619daf00bc4c5f1155e95d47e689026503f5b1eebfb7eaa`
- Destination task id: `019f5845-fb96-7370-baf2-b8f00fddffae`
- Destination Project Room: Lowes Order
- Requested cart ZIP: `27511`

## Authority

The durable PR-message record is authoritative. Lowes Order validated the destination task id and payload hash with `C:\Codex\Wiki Files\tools\pr-messaging\Manage-ProjectRoomMessage.ps1`, then wrote Accepted and Processing before inspecting the live Lowe's cart.

## Correction Rule

The payload authorized restoring only one uniquely missing selected showering-component line at its baseline quantity. If more than one selected line was missing, or if the deleted product could not be identified uniquely, Lowes Order had to make no additions and return Needs Wes with exact differences.

## Baseline Comparison Result

Live cart inspection found more than one selected baseline line missing. No additions were made.
