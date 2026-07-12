# Lowes Order Project Room

## Purpose

This Project Room holds the repeatable workflow for Buy Your Home Lowe's order work.

Use this room when Wes asks Codex to plan, organize, review, or document Lowe's ordering tasks, including source notes, order requirements, follow-up decisions, cart-filling from email instructions, and review-ready outputs.

## Scope

In scope:

- Lowe's order source notes, product lists, project/property context, and working decisions.
- Workflow rules for preparing order drafts, handoffs, or a Lowe's cart for review.
- Using Chrome with Wes's existing Lowe's session to search the Lowe's website and add email-requested items to the cart.
- Review-ready outputs under `outputs\`.
- Matching wiki-managed skill instructions under `C:\Codex\Wiki Files\skills\lowes-order\SKILL.md`.

Out of scope:

- Placing purchases, spending money, changing payment details, or submitting orders unless Wes explicitly approves the specific order action.
- Using another person's Lowe's account, creating a new account, resetting passwords, or changing account settings unless Wes explicitly asks for that specific action.
- Creating Teams folders unless Wes explicitly asks for a final deliverable there.
- Moving source files from another Project Room unless Wes authorizes the move.
- Creating automations unless Wes explicitly asks for scheduled or event-triggered behavior.

## Folder Map

- `sources\` - raw order notes, product information, screenshots, emails, or source summaries.
- `working\source-inventory.md` - inventory of source material and authority status.
- `working\duplicate-and-conflict-log.md` - duplicate, outdated, conflicting, or unclear source notes.
- `working\missing-context.md` - open questions and decisions needed before final ordering work.
- `outputs\` - review-ready order drafts, checklists, handoffs, or summaries.

## Current Status

Status: draft.

This room was created as the standard workspace for Lowe's order workflow work. No order-specific sources have been added yet.

## Matching Skill

- Skill source: `C:\Codex\Wiki Files\skills\lowes-order\SKILL.md`

## Dedicated Chat

- Chat name: `Lowes Order`
- Thread id: `019f5845-fb96-7370-baf2-b8f00fddffae`

## Branch And Push Mode

- Project branch: `project/lowes-order`
- Before durable file work, confirm the repo is `C:\Codex\Wiki Files` and switch to this branch when safe.
- If Git processes, lock files, or unrelated dirty files block switching, report the blocker instead of forcing, stashing, resetting, or deleting files.
- Commit only scoped Lowes Order room, matching skill, and directly related registry/index changes.
- Push only when Wes explicitly asks, says the work is finished, or the applicable Admin wiki rules define the deliverable as final and ready to publish.

## Cart Fill Workflow

When Wes asks Lowes Order to fill a cart from an email:

1. Get the source email through an approved path, preferably the Outlook connector when available, or from email text Wes provides in the chat.
2. Save or summarize the email source in `sources\` when the order will become a durable project-room record.
3. Extract item names, quantities, model numbers, dimensions, colors, brand requirements, delivery/pickup notes, project/property context, and stated urgency.
4. Record missing or ambiguous item details in `working\missing-context.md` before guessing.
5. Use Chrome with Wes's existing signed-in Lowe's session when browser interaction is needed.
6. Open the Lowe's website, verify the session appears to be the intended account, and avoid changing account, payment, address, or profile settings.
7. Search for each requested item on the Lowe's website and choose matches based on the email details.
8. Prefer exact item numbers or model numbers when the email provides them.
9. If multiple plausible matches exist, choose the closest match only when the source details clearly support it; otherwise leave the item out of the cart and report the decision needed.
10. Add confirmed matches and quantities to the Lowe's cart.
11. Stop at cart review. Do not check out, place the order, submit payment, approve substitutions, schedule delivery, or change pickup/delivery details unless Wes explicitly approves that specific final action.
12. Report the cart status, matched items, missing items, substitutions or uncertainties, price/availability issues, pickup/delivery questions, and the exact approval needed before checkout.

## Safety Rules For Website Use

- Logging in through Chrome means using Wes's existing browser session or a login Wes directly completes. Do not ask for or store passwords.
- Do not bypass authentication, CAPTCHA, multi-factor prompts, or Lowe's account protections.
- Do not save payment details, change saved cards, change addresses, enroll in paid services, or accept terms for a paid service unless Wes explicitly authorizes that specific action.
- If the Lowe's site presents a higher-impact prompt, price change, unavailable item, substitution, delivery fee, warranty, protection plan, financing offer, or account setting change, stop and report the decision needed.

## Next Actions

1. Add authoritative Lowe's order source material to `sources\` when Wes provides it or when an email-based order needs a durable record.
2. Update the source inventory before drafting order outputs or filling a cart.
3. Record any missing item details, property/project assignment, budget, delivery/pickup details, or approval decisions in `working\missing-context.md`.
4. Fill a Lowe's cart only from authoritative email or user-provided instructions, then stop at cart review unless Wes explicitly approves checkout.
5. Draft review-ready order outputs in `outputs\` only from authoritative sources.
