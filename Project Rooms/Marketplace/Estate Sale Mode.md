# Estate Sale Mode

Estate Sale Mode is a repeatable Marketplace workflow for preparing and managing item listings for one named sale. It is separate from ordinary Marketplace sourcing and seller negotiation.

## Activation

- Wes must explicitly start Estate Sale Mode for each sale.
- Record the sale name, target sale date, price-protection date, approved showing dates and time windows, general pickup area, and whether publication is authorized.
- Starting this mode does not resume the general Marketplace heartbeat, seller sourcing, tool-buying activity, or any unrelated Marketplace conversation.
- If a required showing window or date is missing, prepare the listings but do not invent availability or send scheduling information.

## Listing Structure

- Use separate posts for recognizable, searchable, higher-value items.
- Bundle related low-value items, matching sets, duplicates, or accessories that are more useful together.
- Do not place all unrelated items into one large listing merely because they belong to the same sale.
- A general estate-sale announcement post may supplement the item listings when separately authorized, but it does not replace accurate item posts.
- Prepare each listing offline first with item id, title, category, condition, photos, description, asking price, expected sale range, private price notes, and open questions.

## Pricing

- Support prices with the best available item identity, condition facts, current retail context, sold comparables when available, and relevant local asking prices.
- Keep the private expected range, quick-sale recommendation, and any minimum acceptable price out of public listings and buyer messages.
- Do not reduce, counter below, or signal flexibility below the listed price before the recorded price-protection date.
- Before that date, a lower offer may be acknowledged without acceptance: state that the listed price is firm until the established date.
- On or after the price-protection date, do not reduce automatically. Ask Wes or follow a separately recorded reduction schedule.
- Never accept an offer, mark an item sold, or make a price commitment unless Wes has authorized that exact result or an explicit mode rule covers it.

## Buyer Conversation Authority

Once Wes has separately authorized publication and a buyer responds to an active estate-sale listing, Marketplace may:

- answer whether the item is still available, but only from the current item record;
- give the approved showing date and time window exactly as Wes supplied it;
- answer factual questions supported by the listing packet or Wes's recorded notes;
- ask which approved showing window works for the buyer;
- state that an unknown fact will be checked rather than guessing; and
- keep the conversation concise, courteous, and non-deceptive.

Marketplace may not:

- invent or expand Wes's availability;
- promise a private appointment outside an approved window;
- reduce the price before the price-protection date;
- accept a lower offer after that date without Wes approval or a recorded reduction schedule;
- reserve or hold an item, promise first priority, accept payment or a deposit, or confirm a sale;
- disclose an exact address, private phone number, access instruction, payment detail, or other private contact information without separate authorization;
- arrange delivery, shipping, pickup, or another commitment outside the approved showing instructions; or
- claim an item is available, working, complete, authentic, safe, or defect-free when the record does not support that statement.

## Availability Replies

- If the item record says `available`, Marketplace may say it is currently available.
- If Wes has confirmed a pending transaction or hold, describe only the recorded status; do not create a new hold.
- If the record is uncertain or may be stale, say availability is being checked and route the question to Wes.
- Mark an item `sold` or `unavailable` only after Wes confirms the outcome or another authorized source conclusively establishes it.

Suggested reply when supported:

```text
Yes, it is currently available. Wes is available to show it during [approved date and time window]. Let me know whether that window works for you.
```

Suggested reply to an early lower offer:

```text
Thanks for the offer. The listed price is firm until [price-protection date]. The item is currently available, and Wes can show it during [approved date and time window].
```

## Publication And Privacy Gates

- Creating content or an unpublished draft is not publication authority.
- Wes must separately authorize publishing the listings for each sale or posting session.
- Review every photo for faces, mail, paperwork, exact addresses, license plates, keys, access codes, prescription labels, or other private details before publication.
- Do not expose a private minimum price, internal pricing notes, exact home address, or contact number in Git or public listing content.

## Records

Maintain one item record per listing or bundle with:

- stable item id and listing URL;
- availability status;
- public asking price and protected-through date;
- approved showing window and general area;
- factual condition, testing, measurements, included parts, and defects;
- buyer-question status and last supported reply;
- Wes decision needed; and
- final sold, withdrawn, donated, or unsold outcome.

Record material buyer conversations without storing unnecessary personal information in Git. Do not process the same buyer message twice.

## Closing The Mode

- Wes may pause or close Estate Sale Mode at any time.
- Closing the mode stops buyer replies and listing activity for that sale unless Wes gives a different instruction.
- Preserve the item records and final outcomes for reference.
- Closing one sale does not activate, close, pause, or resume another Marketplace workflow.
