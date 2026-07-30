---
name: marketplace
description: Use for Buy Your Home Marketplace project-room work, including Facebook Marketplace tool sourcing, resale-profit evaluation, offer calculation, authorized Messenger conversations, seller-agreement tracking, and Wes email notifications under `Project Rooms\Marketplace`.
---

# Marketplace

## Source Of Truth

- Project room: `C:\Codex\Wiki Files\Project Rooms\Marketplace`
- Skill source: `C:\Codex\Wiki Files\skills\marketplace\SKILL.md`
- Admin wiki source: `C:\Codex\Wiki Files`
- Registry: `C:\Codex\Wiki Files\Agents and Automations Registry.md`
- Jean routing map: `C:\Codex\Wiki Files\Project Rooms\Jean Wright\working\dispatcher-routing-map.md`
- Listing register: `C:\Codex\Wiki Files\Project Rooms\Marketplace\working\listing-evaluation-register.md`
- Outcome log: `C:\Codex\Wiki Files\Project Rooms\Marketplace\working\marketplace-action-log.md`

Use this skill when Wes asks Codex to search Facebook Marketplace for tools, evaluate a listing for resale profit, calculate an offer, send or draft a Messenger offer, continue a seller conversation, or notify Wes that a seller accepted an offer.

## Start PR

Before durable work, follow Start PR Mode in `C:\Codex\Wiki Files\Project Room Chat Startup Rule.md`. Interpret unqualified requests under the Current PR Scope Rule in that file. Work on `main` unless Wes explicitly asks for a branch.

## Required Startup

Before Marketplace file work:

1. Confirm the working folder is `C:\Codex\Wiki Files`.
2. Confirm the current branch is `main`.
3. Read `Project Room Chat Startup Rule.md`, `Project Room File Ownership And Git Coordination Rule.md`, `Project Rooms\Marketplace\README.md`, and this skill source.
4. Read root rules needed for the request, including `AGENTS.md`, `Repository Location Rule.md`, `Project Room Workflow.md`, `Agent Unit Standard.md`, `Git Work Scope Rule.md`, `Codex Skill Source Rule.md`, and `Connector and Plugin Usage Rules.md`.
5. Check `git status --short --branch`.

## Workflow

1. Identify whether the request is search, listing evaluation, offer calculation, Messenger outreach, seller conversation, agreement reporting, or output/report creation.
2. Confirm the authorized Facebook/Messenger browser session before browsing or messaging.
3. Confirm Wes's buying criteria when broad searching: tool categories, brands, search radius, minimum expected profit, minimum margin, maximum cash outlay, and pickup constraints.
4. For each listing, capture listing URL, title, asking price, seller display name, location, visible condition, included accessories, and open questions.
5. Estimate resale value using current comparable data when available. Record source, assumptions, and confidence.
6. Calculate estimated costs and risk: Marketplace price, local travel/pickup cost, repairs/cleaning, missing parts, resale fees, shipping if relevant, holding risk, and time sensitivity.
7. Calculate maximum safe offer and recommended offer.
8. Record the evaluation in `working\listing-evaluation-register.md`.
9. Send a Messenger offer only when the listing is identified, the maximum offer is recorded, and the message stays at or below an approved maximum. If no approved max-offer rule exists, ask Wes before sending.
10. Engage sellers with concise, non-deceptive questions and negotiation messages. Do not spam, misrepresent identity, or evade Facebook limits.
11. If a seller accepts or appears ready to agree, stop before payment, pickup, deposit, shipping, address exchange, phone-number exchange, or other commitment.
12. Notify Wes by email through Email Monitor's Email Delivery mode or `skills\email-delivery\SKILL.md`.
13. Record the final outcome in `working\marketplace-action-log.md`.
14. Preserve review-ready opportunity reports and deal summaries under `outputs\`.
15. Commit only scoped Marketplace room, matching skill, registry, Jean routing map, and Admin Home changes.

## Offer And Messenger Authority

- Messenger access requires an authorized logged-in browser session.
- Do not store Facebook credentials, MFA codes, recovery codes, seller private contact details beyond deal necessity, payment details, or other live secrets.
- Do not send an offer above the recorded maximum safe offer.
- Do not agree to buy, pay, place a deposit, reserve, schedule pickup, exchange addresses, exchange phone numbers, ship, or otherwise make a binding commitment without Wes's specific approval for the exact deal.
- If a seller asks for payment method, deposit, off-platform contact, delivery, shipping, address, or pickup timing, stop and ask Wes unless he already approved that exact next step.
- Do not buy restricted, illegal, recalled, unsafe, counterfeit, stolen, or suspicious goods.

## Evaluation Fields

Record these facts when available:

- listing title and URL,
- seller display name,
- location or pickup area,
- asking price,
- brand/model,
- condition and included accessories,
- missing parts or damage,
- comparable resale source or estimate,
- likely resale price,
- estimated costs and risk,
- target gross profit,
- target margin,
- maximum safe offer,
- recommended offer,
- confidence,
- next message or blocker.

## Email Notification

When a seller accepts an offer or the conversation reaches a likely agreement:

1. Prepare an email from `OfficeAssist@BuyYourHomeLLC.com` to `WesWill@BuyYourHomeLLC.com`.
2. Use a subject like `[Marketplace] Seller accepted offer - <tool/listing>`.
3. Include listing URL, seller display name, accepted price, expected resale price, estimated profit, pickup/shipping status, open risks, and recommended next action.
4. Send through Email Monitor's Email Delivery mode or `skills\email-delivery\SKILL.md`.
5. Verify the sent copy in OfficeAssist Sent Items when the delivery workflow requires verification.
6. Do not proceed to payment, pickup, or personal-information exchange until Wes approves.

## Dispatcher Intake And Return

This room is dispatcher-ready under `C:\Codex\Wiki Files\Project Room Chat Startup Rule.md`.

When receiving a Jean handoff, confirm the `dispatch_id`, source listing or message, requested action, and any Messenger/email authority. Return one of: `accepted`, `done`, `blocked`, `needs Wes`, `rejected as wrong room`, or `routed onward with approval`.

## Boundaries

- Do not create Teams folders unless Wes explicitly asks.
- Do not edit another Project Room's files or matching skill unless Wes explicitly authorizes that specific cross-PR edit.
- Do not create automations unless Wes asks for scheduled or event-triggered behavior.
- Do not commit unrelated dirty work or generated scratch folders.
- Do not push unless Wes asks, says the setup is finished, or the applicable Admin wiki rules make the deliverable ready to publish.

## Outputs

Use `C:\Codex\Wiki Files\Project Rooms\Marketplace\outputs` for review-ready opportunity summaries, offer recommendations, seller-agreement reports, and handoffs.
