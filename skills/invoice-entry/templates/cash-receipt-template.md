# Cash Collection Receipt Template

Use with `scripts\create-cash-receipt.py`. This template documents money collected; it is not a vendor purchase receipt.

## Required JSON

```json
{
  "receipt_number": "RCPT-YYYYMMDD-PROPERTY-SEQUENCE",
  "receipt_date": "YYYY-MM-DD",
  "receiving_entity": "Buy Your Home LLC",
  "project": "20-HM - 115 Rosebrooks Dr",
  "property_address": "115 Rosebrooks Dr",
  "received_from": "Cash buyer - name not recorded",
  "collected_by": "Name",
  "payment_method": "Cash",
  "collection_status": "Cash Received",
  "deposit_status": "Not Recorded",
  "application": "Estate Sale Proceeds / Project Credit",
  "items": [
    {
      "description": "Sold item",
      "quantity": 1,
      "amount": 0.00,
      "marketplace_item_id": "ES-..."
    }
  ],
  "total_collected": 0.00,
  "marketplace_reference": "Listing title, URL, draft ID, or authoritative source path",
  "source_reference": "Evidence confirming the completed sale and actual amount collected",
  "notes": "Optional factual note"
}
```

## Controls

- Replace every example value with supported facts; never issue a zero-value or placeholder receipt.
- `total_collected` must equal the item-line sum.
- State an unknown buyer name explicitly; do not silently invent one.
- Marketplace asking/listing price is not the amount collected.
- Rosebrooks Estate Sale exception: a direct Wes command `Receipt item #<item number>` confirms sale and cash collection at the item's current established Marketplace price unless Wes states a different amount or payment method.
- Keep `collection_status` and `deposit_status` separate.
- Run duplicate checks and PDF visual QA before filing or delivery.
- Use application `Estate Sale Proceeds / Project Credit` for the current Rosebrooks estate-sale workflow.
- Hold workbook posting as `Needs Review - Project Credit Placement` until an approved receipts/project-credit worksheet exists.
- After durable receipt recording, send the exact item/listing to Marketplace for the separately owned Facebook `Sold` update and preserve its returned status.
