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

## Marketplace Pause

- Marketplace is paused by Wes as of 2026-08-05.
- While paused, do not search or browse for listings, evaluate new opportunities, contact or reply to sellers, monitor seller conversations, negotiate, send Marketplace notifications, or take another Marketplace workflow action.
- Preserve existing records and pending statuses without processing them as active work.
- Resume Marketplace activity only after Wes explicitly says to resume Marketplace.
- Narrow exception: Wes may explicitly activate Estate Sale Mode for one named sale without resuming general Marketplace activity. Follow `C:\Codex\Wiki Files\Project Rooms\Marketplace\Estate Sale Mode.md` and keep the general heartbeat, seller sourcing, and unrelated conversations paused.

## Estate Sale Mode

Use `C:\Codex\Wiki Files\Project Rooms\Marketplace\Estate Sale Mode.md` when Wes starts a repeatable estate-sale workflow.

- Activate the mode separately for each sale. Record the sale name, target date, price-protection date, approved showing windows, general pickup area, and publication authority.
- Prepare separate posts for searchable higher-value items and logical bundles for related low-value items or sets. Do not rely on one listing containing all unrelated items.
- Publication requires separate authorization for the applicable sale or posting session.
- After publication, Marketplace may answer whether an item is still available only from the current item record, answer supported factual questions, and share the showing dates and windows Wes supplied.
- Marketplace may ask which approved window works for the buyer, but may not invent availability or promise an appointment outside it.
- Do not reduce or signal flexibility below the listed price before the recorded price-protection date. On or after that date, ask Wes or follow a separately recorded reduction schedule; do not reduce automatically.
- Do not accept an offer, reserve or hold an item, accept payment or a deposit, mark an item sold, disclose an exact address or private phone number, arrange delivery or shipping, or make another commitment without the required specific authority.
- Keep buyer replies concise, factual, non-deceptive, and free of unsupported condition or performance claims.
- Pause or close the mode immediately when Wes directs. Closing one sale does not alter another Marketplace workflow.

## Start PR

Before durable work, follow Start PR in `C:\Codex\Wiki Files\Project Room Chat Startup Rule.md`. Interpret unqualified requests under the Current PR Scope Rule in that file. Work on `main` unless Wes explicitly asks for a branch.

## Required Startup

Before Marketplace file work:

1. Confirm the working folder is `C:\Codex\Wiki Files`.
2. Confirm the current branch is `main`.
3. Read `Project Room Chat Startup Rule.md`, `Project Room File Ownership And Git Coordination Rule.md`, `Project Rooms\Marketplace\README.md`, and this skill source.
4. Read root rules needed for the request, including `AGENTS.md`, `Repository Location Rule.md`, `Project Room Workflow.md`, `Agent Unit Standard.md`, `Git Work Scope Rule.md`, `Codex Skill Source Rule.md`, and `Connector and Plugin Usage Rules.md`.
5. Check `git status --short --branch`.

## Workflow

0. Confirm Marketplace is not paused before starting any workflow action.
1. Identify whether the request is search, listing evaluation, offer calculation, Messenger outreach, seller conversation, agreement reporting, completed-purchase recording, or output/report creation.
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
14. When Wes confirms a completed purchase, update the listing register and route one separate formal purchase-invoice request per seller/listing to the existing Invoice Entry task, `019fbf4f-c629-7dd1-a3f6-0de33de0ed8f`. Mark it `Paid - Cash` unless Wes states another payment method; treat the seller as issuer and Buy Your Home as customer; include the purchase date, seller display name, listing title and URL, item description, and actual purchase amount. Use `Marketplace resale inventory` as the destination unless Wes identifies another business or property destination, and do not guess a workbook or worksheet.
15. Keep seller phone numbers, pickup addresses, and unnecessary personal contact details out of the invoice request and Git records. Record Invoice Entry's returned status and output paths when available.
16. Preserve review-ready opportunity reports and deal summaries under `outputs\`.
17. Commit only scoped Marketplace room, matching skill, registry, Jean routing map, and Admin Home changes.

## Offer And Messenger Authority

- Messenger access requires an authorized logged-in browser session.
- Do not store Facebook credentials, MFA codes, recovery codes, seller private contact details beyond deal necessity, payment details, or other live secrets.
- Do not send an offer above the recorded maximum safe offer.
- Do not agree to buy, pay, place a deposit, reserve, schedule pickup, exchange addresses, exchange phone numbers, ship, or otherwise make a binding commitment without Wes's specific approval for the exact deal.
- If a seller asks for payment method, deposit, off-platform contact, delivery, shipping, address, or pickup timing, stop and ask Wes unless he already approved that exact next step.
- After Wes specifically approves proceeding with an exact deal and pickup, Marketplace has standing authority to ask the seller for a local callable phone number. Wes must receive that number before he leaves to pick up or buy the listing.
- Do not mark a deal ready for pickup, tell Wes to depart, or treat pickup logistics as complete until the seller has provided a local phone number that Wes can call.
- Do not send Wes's phone number or another Buy Your Home phone number to the seller without separate specific approval.
- Keep the actual seller phone number out of Git-tracked files. Record only whether the local number was received and whether any apparent problem remains; leave the number in Messenger or another approved private channel needed for the deal.
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
## Delegation Contract

Delegation Contract: Follow `C:\Codex\Wiki Files\Project Room Delegation Contract.md`. Jean may delegate this PR's work only to its registered task in `Project Rooms\Jean Wright\working\dispatcher-routing-map.md`; accept and return the same `dispatch_id` under the central contract.

## Action Ownership

Action Ownership: Follow `C:\Codex\Wiki Files\Project Room Delegation Contract.md`. Perform only this PR's documented actions. Delegate another PR's action to its registered task; a missing task/thread id is a blocker, never permission to perform it locally. Return `accepted`, `done`, `blocked`, `needs Wes`, or `rejected as wrong room`.
