# Grocery List Project

This project tracks grocery requests from Boss and Mrs Boss, keeps a current grocery list, and learns recurring staples that should be added automatically.

## Main Files

- `data/current-grocery-list.md` - the active list to display when asked.
- `data/request-log.md` - dated record of requested items.
- `data/always-order.md` - staple items that should automatically appear on the list.
- `data/purchase-history.md` - record of what was bought or cleared.
- `wiki/Grocery List Rules.md` - operating rules for Jean Wright.

## Basic Workflow

1. When Boss or Mrs Boss requests an item, add it to `data/current-grocery-list.md`.
2. Add the request to `data/request-log.md`.
3. If an item is requested repeatedly, promote it to `data/always-order.md`.
4. When asked to display the grocery list, show the whole current list grouped by category.
5. When the list is cleared after shopping, keep history in `data/purchase-history.md`.
