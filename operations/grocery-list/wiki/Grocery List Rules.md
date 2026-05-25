# Grocery List Rules

## Purpose

Maintain one current grocery list for Boss and Mrs Boss and learn recurring staples over time.

## Request Sources

Accepted request sources:

- direct message in Codex from Boss,
- direct instruction saying Mrs Boss requested an item,
- future email/text source if connected and approved.

Boss and Mrs Boss have equal authority for grocery list requests. If their instructions directly conflict, ask before changing the list.

## Display Rule

When Boss or Mrs Boss asks to display the grocery list, show the entire contents of `data/current-grocery-list.md`, cleaned up for readability and grouped logically by how items are usually found in the store.

Use practical shopping sections such as produce, meat/seafood, dairy/eggs, bakery, pantry, frozen, drinks, household/cleaning, personal/health, and other. Reorder items for shopping flow when helpful rather than simply copying file order.

## Add Rule

When a grocery item is requested:

1. Determine the best category.
2. Add the item to the current list if it is not already there.
3. If it is already there, update quantity or add a note.
4. Log the request in `data/request-log.md`.
5. Check whether the item appears often enough to suggest always-order status.

## Always-Order Rule

Always-order items are staples. They should be included automatically whenever the list is restarted after shopping.

Examples might include milk, eggs, coffee, paper towels, or other staples, but do not assume any item is a staple until Boss or Mrs Boss confirms it or repeated request history supports it.

## Clear Rule

When Boss says the grocery list is done, bought, or cleared:

1. Move the completed items into `data/purchase-history.md`.
2. Clear non-staple items from `data/current-grocery-list.md`.
3. Re-add active staples from `data/always-order.md`.
