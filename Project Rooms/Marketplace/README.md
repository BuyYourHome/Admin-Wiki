# Marketplace Project Room

## Purpose

This Project Room owns the Facebook Marketplace tools workflow: finding tool listings, evaluating buy price versus likely resale value, calculating a safe offer, using Facebook Messenger to make and negotiate that offer when authorized, and notifying Wes by email when a seller reaches an agreement.

Use this room when Wes asks Codex to search Facebook Marketplace for tools, evaluate a listing for resale profit, prepare or send an offer through Messenger, continue a seller conversation, or report Marketplace opportunities.

## Scope

In scope:

- Searching Facebook Marketplace through an authorized logged-in browser session.
- Evaluating tool listings for resale potential using listing price, condition, brand, model, included accessories, local pickup cost, likely resale price, estimated fees, repair/cleaning risk, and desired profit margin.
- Recording listing evaluations, seller-message status, offer decisions, agreement status, and email notifications.
- Sending Messenger offers and follow-up questions only within the authority and safety boundaries below.
- Sending Wes an OfficeAssist email when a seller accepts an offer or when Wes approval is needed for a next step.
- Recording completed purchases and routing one cash-paid purchase-invoice request per purchased listing to Invoice Entry.

Out of scope:

- Checkout, payment, deposits, pickup scheduling, address exchange, shipping commitment, or any purchase commitment without Wes's specific approval.
- Buying tools, spending money, changing Facebook account settings, posting listings, creating new accounts, or altering payment methods.
- Misrepresenting identity, using deceptive scripts, spamming sellers, or evading Facebook platform limits.
- Storing Facebook credentials, seller personal contact details beyond what is necessary for the deal record, payment details, MFA codes, or other live secrets.
- Using another person's Facebook/Messenger account unless Wes explicitly authorizes that account and session for the specific run.

## Folder Map

- `sources\` - listing source notes, exported listing summaries, comparison references, and Wes-provided buying criteria.
- `working\source-inventory.md` - inventory of source material and whether it is authoritative.
- `working\duplicate-and-conflict-log.md` - duplicate listings, stale listings, conflicting resale estimates, or ambiguous seller details.
- `working\missing-context.md` - missing search criteria, margin targets, offer limits, account/session access, or approval decisions.
- `working\listing-evaluation-register.md` - durable register of listings reviewed and deal math.
- `working\marketplace-action-log.md` - durable outcome log for searches, evaluations, offers, conversations, agreements, and email notifications.
- `outputs\` - review-ready opportunity summaries, offer recommendations, deal reports, and handoffs.

## Current Status

Status: active.

The dedicated Marketplace chat is active and ready to receive Marketplace requests. This Project Room pursues Facebook Marketplace tools, evaluates profitable resale pricing, uses Messenger to make offers and engage sellers within approved authority, and emails Wes if an agreement is reached. An active heartbeat checks tracked seller conversations that are awaiting responses.

## Matching Skill

- Skill source: `C:\Codex\Wiki Files\skills\marketplace\SKILL.md`

## Dedicated Chat

- Chat name: `Marketplace`
- Thread id: `019fb5b0-6c29-7b32-822b-aa13b5920c29`

## Seller Response Heartbeat

- Automation id: `marketplace-seller-response-monitor`.
- Status: active.
- Schedule: every 15 minutes from 8:00 AM through 9:45 PM Eastern, daily.
- Target: this Marketplace chat.
- Check only tracked seller conversations whose register status indicates that a response is pending.
- Stay quiet and make no file or Git changes when no new response exists.
- Record new responses without processing the same message twice.
- Continue only concise, non-binding negotiation at or below the listing's recorded maximum safe offer.
- If the seller accepts, appears ready to agree, or offers a profitable counter within the recorded maximum, stop and notify Wes through Email Delivery before any commitment.
- Payment, deposits, reservations, pickup scheduling, shipping, addresses, phone numbers, and other commitments remain gated to Wes.
- Once Wes specifically approves an exact deal and pickup, the heartbeat may ask the seller for a local callable phone number. Do not tell Wes to leave for pickup until that number has been received.

## Start PR

Before durable work, follow Start PR Mode in `C:\Codex\Wiki Files\Project Room Chat Startup Rule.md`. Interpret unqualified requests under the Current PR Scope Rule in that file. Work on `main` unless Wes explicitly asks for a branch.

## Dispatcher Intake And Return

This room is dispatcher-ready under `C:\Codex\Wiki Files\Project Room Chat Startup Rule.md`. When Jean Wright routes Marketplace work here, return `accepted`, `done`, `blocked`, `needs Wes`, `rejected as wrong room`, or `routed onward with approval`.

## Ownership And Git Mode

- Working branch: `main`.
- Before durable file work, confirm the repo is `C:\Codex\Wiki Files` and the current branch is `main`.
- Follow `Project Room File Ownership And Git Coordination Rule.md` for Project Room ownership, shared Admin files, cross-PR edits, fetch/pull safety, and push safety.
- Commit only scoped Marketplace room, matching skill, registry, Jean routing map, and Admin Home changes.
- Push only when Wes explicitly asks, says the work is finished, or the applicable Admin wiki rules define the deliverable as final and ready to publish.

## Offer Authority

- Messenger access requires an authorized logged-in browser session.
- Do not send a Messenger offer unless the listing is clearly identified, the maximum offer is calculated and recorded, and the message stays at or below that maximum offer.
- If Wes gives exact search criteria or a maximum offer rule, follow it. If no approved maximum exists, draft the offer or ask Wes for approval before sending.
- Offers should be non-deceptive and concise, such as asking whether the seller would accept the offered amount.
- Do not agree to buy, pay, meet, pick up, ship, send a deposit, provide an address, exchange phone numbers, or make a binding commitment without Wes's specific approval for that exact deal.
- If the seller accepts or proposes a counteroffer that appears profitable, stop before commitment and send Wes an email notification through Email Monitor's Email Delivery mode or `skills\email-delivery\SKILL.md`.
- For every approved pickup or purchase, obtain a local callable phone number from the seller before Wes leaves. This is a mandatory pre-departure requirement, not an optional seller-detail question.
- After Wes approves the exact deal and pickup, Marketplace has standing authority to request the seller's local number. Do not send Wes's number to the seller without separate approval.
- Do not store the actual seller phone number in Git. Record only that the number was received and whether it appears usable; retain the number only in Messenger or another approved private deal channel.

## Evaluation Standard

For each listing, record:

- listing title and URL,
- seller display name when visible,
- location or pickup area,
- asking price,
- tool brand/model,
- condition and included accessories,
- comparable resale price source or estimate,
- likely resale price,
- estimated selling fees, shipping, local pickup cost, repair/cleaning risk, and holding risk,
- target gross profit and margin,
- maximum safe offer,
- recommended offer,
- confidence level,
- open questions.

## Email Notification Rule

When a seller accepts an offer or the conversation reaches a likely agreement:

- Send Wes an email from `OfficeAssist@BuyYourHomeLLC.com` to `WesWill@BuyYourHomeLLC.com`.
- Use a subject like `[Marketplace] Seller accepted offer - <tool/listing>`.
- Include listing URL, seller display name, accepted price, expected resale price, estimated profit, pickup/shipping status, open risks, and the recommended next action.
- Verify the sent copy in OfficeAssist Sent Items under the applicable Email Delivery rules.
- Do not proceed to payment, pickup, or personal-information exchange until Wes approves.

## Completed Purchase Invoice Rule

When Wes confirms that a Marketplace listing was purchased:

1. Update the listing register to show the actual purchase price, purchase date, payment status, and final deal outcome.
2. Record the purchase in `working\marketplace-action-log.md`.
3. Send a direct handoff to the existing Invoice Entry task, `019f3d56-b310-75c0-b084-616bfc1e9f59`, requesting one separate formal purchase invoice for each seller/listing.
4. Mark the invoice `Paid - Cash` unless Wes states a different payment method. The seller is the issuer and Buy Your Home is the customer.
5. Include the listing URL, seller display name, item description, actual purchase amount, purchase date, and source traceability. Use `Marketplace resale inventory` as the destination unless Wes identifies a property or another business destination; do not guess a project workbook or worksheet.
6. Do not include seller phone numbers, pickup addresses, or other unnecessary personal contact details in the invoice or Git-tracked handoff record.
7. Record Invoice Entry's returned status and output paths when available.

## Next Actions

1. Confirm Wes's buying criteria: tool categories, brands, search radius, minimum expected profit, minimum margin, maximum cash outlay, and preferred pickup areas.
2. Confirm the authorized Facebook/Messenger browser session.
3. Start the first Marketplace search and record listing evaluations in `working\listing-evaluation-register.md`.
