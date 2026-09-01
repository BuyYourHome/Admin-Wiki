---
name: lowes-order
description: Use for Buy Your Home Lowe's order project-room work, including organizing order sources, filling a Lowe's cart from email instructions through Chrome, preparing order drafts or handoffs, tracking missing order details, and maintaining outputs under `Project Rooms\Lowes Order`.
---

# Lowes Order

## Source Of Truth

- Project room: `C:\Codex\Wiki Files\Project Rooms\Lowes Order`
- Skill source: `C:\Codex\Wiki Files\skills\lowes-order\SKILL.md`
- Admin wiki source: `C:\Codex\Wiki Files`
- Registry: `C:\Codex\Wiki Files\Agents and Automations Registry.md`

Use this skill when Wes asks Codex to work on Lowe's order planning, organization, review, cart-filling, or documentation for Buy Your Home, or when Email Monitor routes an authorized Lowe's instruction from Wes, Jenny, or Josh Kennedy.

## Required Startup

Before Lowes Order file work:

1. Confirm the working folder is `C:\Codex\Wiki Files`.
2. Read `Admin Home.md`, `AGENTS.md`, `Repository Location Rule.md`, `Project Room Workflow.md`, `Project Room Chat Startup Rule.md`, `Agent Unit Standard.md`, `Codex Skill Source Rule.md`, and `Git Work Scope Rule.md`.
3. Read `Project Rooms\Lowes Order\README.md`, `working\source-inventory.md`, `working\duplicate-and-conflict-log.md`, and `working\missing-context.md`.
4. Check `git status --short --branch`.

## Workflow

1. Identify the project, property, or business purpose for the Lowe's order.
2. Put source material, product lists, screenshots, emails, or source summaries in `sources\`.
3. Update `working\source-inventory.md` before drafting order outputs.
4. Record duplicates, outdated product information, conflicting quantities, and unclear instructions in `working\duplicate-and-conflict-log.md`.
5. Record missing item details, quantity, pickup/delivery method, pickup person, budget, payment, timing, and approval questions in `working\missing-context.md`.
6. Draft order summaries, review checklists, or handoff notes in `outputs\` using authoritative sources only.
7. Mark unsupported order assumptions as `[UNSUPPORTED]` instead of smoothing them into a final recommendation.
8. When asked to fill a Lowe's cart from an email, follow the Cart Fill Workflow below.
9. Commit only scoped Lowes Order room, skill, registry, and index changes.

## Cart Fill Workflow

Use this workflow when Wes asks Codex to add Lowe's items to a cart from an email:

1. Retrieve the source email through an approved path, preferably the Outlook connector when available, or use the email text Wes provides in the chat.
2. Preserve a durable source copy or source summary in `Project Rooms\Lowes Order\sources` when the order will be part of the project-room record.
3. Extract requested item names, quantities, model numbers, item numbers, dimensions, colors, brands, delivery/pickup notes, project/property context, timing, and budget notes.
4. If a confirmed item has no stated quantity, assume quantity `1`, add that quantity to the cart, and record the assumption in the cart summary so Wes can adjust the quantity in the cart if needed.
5. Always confirm fulfillment before or during cart preparation: identify whether the order should be delivery/shipping or pickup, and if pickup is requested, identify the pickup person. Do not guess a delivery method or pickup person silently. If Wes or the authoritative source does not specify it, ask for the missing fulfillment decision or record it as a blocker in the cart summary.
6. Record missing or ambiguous order details in `working\missing-context.md` before making assumptions. Missing quantity alone does not block cart fill when the product match is confirmed.
7. Use Chrome for Lowe's website work when Wes expects the workflow to use his logged-in Lowe's session.
8. Verify the browser session appears to be the intended Lowe's account before changing the cart.
9. Search Lowe's for each requested item and prefer exact item numbers or model numbers when the email provides them.
10. Add only confirmed matches and requested or defaulted quantities to the Lowe's cart.
11. If several plausible products match or the requested item is unavailable, do not guess silently. Either skip the item and report it, or add the clearly supported closest match only when the email details justify it.
12. Stop at cart review and report matched items, skipped items, uncertain matches, price/availability issues, delivery/pickup questions, confirmed or missing fulfillment decision, defaulted quantities, and checkout decisions needed.
13. When the cart has been filled to the extent safely possible, send a cart-loaded notification from `OfficeAssist@BuyYourHomeLLC.com` to the instruction sender, Jenny at `Jenny@BuyYourHomeLLC.com`, and Wes at `WesWill@BuyYourHomeLLC.com`. The notification must include the Lowe's cart link `https://www.lowes.com/cart` and ask Wes to review and approve the cart on the Lowe's website. If Wes is the instruction sender, one approval notification to Wes with Jenny copied may serve both purposes.
14. If product ambiguity, availability, fulfillment, or another uncertainty prevents or limits cart preparation, send one question email from OfficeAssist to the instruction sender with Wes copied. Do not guess silently, except for the approved default quantity `1` rule.
15. Prefix every confirmation, question, and approval-notification subject with `[Lowes Order]`. In the body, state that the request was processed in Lowes Order mode. If the source email subject did not identify `Lowes Order` mode, tell the sender to identify `Lowes Order` in the subject next time.
16. Use `C:\Codex\Wiki Files\skills\email-delivery\SKILL.md` for every notification, save to OfficeAssist Sent Items, and verify sender, recipients, subject, and attachment status before reporting delivery.

## Boundaries

- Do not place purchases, spend money, submit orders, change payment details, or approve substitutions unless Wes explicitly approves the specific order action.
- Josh Kennedy at `IRAManager@SellYourHomeRaleigh.com` is an authorized OfficeAssist instruction sender for safe Lowe's cart preparation, but Josh cannot authorize checkout, payment, substitutions, paid services, account changes, or another Wes-gated action.
- Do not check out, submit payment, schedule delivery, accept substitutions, buy protection plans, use financing, or accept paid-service terms unless Wes explicitly approves that specific final action.
- Do not ask Wes for, store, or record Lowe's passwords. Use Wes's existing Chrome session or allow Wes to complete login/MFA directly.
- Do not bypass authentication, CAPTCHA, multi-factor prompts, or Lowe's account protections.
- Do not change account settings, saved addresses, saved payment methods, passwords, notification settings, or profile details unless Wes explicitly authorizes that specific action.
- Do not create Teams folders unless Wes explicitly asks.
- Do not move source files from another Project Room unless Wes authorizes that move.
- Do not create automations unless Wes asks for scheduled or event-triggered behavior.
- Do not commit unrelated dirty work or generated scratch folders.
- Do not push unless Wes asks, says the setup is finished, or the applicable Admin wiki rules make the deliverable ready to publish.

## Outputs

Use `C:\Codex\Wiki Files\Project Rooms\Lowes Order\outputs` for review-ready order drafts, cart-review summaries, item checklists, handoff notes, and final summaries.
## Start PR Pointer

Before durable work, follow Start PR in `C:\Codex\Wiki Files\Project Room Chat Startup Rule.md`.

Interpret unqualified requests under the Current PR Scope Rule in that file. Work on `main` unless Wes explicitly asks for a branch.
## Delegation Contract

Delegation Contract: Follow `C:\Codex\Wiki Files\Project Room Delegation Contract.md`. Jean may delegate this PR's work only to its registered task in `Project Rooms\Jean Wright\working\dispatcher-routing-map.md`; accept and return the same `dispatch_id` under the central contract.

## Action Ownership

Action Ownership: Follow `C:\Codex\Wiki Files\Project Room Delegation Contract.md`. Perform only this PR's documented actions. Delegate another PR's action to its registered task; a missing task/thread id is a blocker, never permission to perform it locally. Return `accepted`, `done`, `blocked`, `needs Wes`, or `rejected as wrong room`.
