# Create Vendor Invoice Polished Invoice Template

Use this template for Create Vendor Invoice when a routed vendor email has no attached invoice and Invoice Entry needs to generate a formal invoice draft for vendor verification.

## Purpose

Create a professional one-page PDF invoice draft that can be sent back to the vendor for accuracy verification after Wes approves the outgoing email. The generated invoice is not a final invoice until the vendor confirms it.

## Required Inputs

- Vendor name.
- Vendor email.
- Bill-to name, normally `Buy Your Home`.
- Project/property.
- Draft date.
- Service period or line-item dates.
- Line-item descriptions.
- Quantity or hours.
- Rate, if known.
- Amount per line.
- Draft subtotal and total.
- Source email path, received time, and subject.
- Verification status text.

If rate, total, invoice number, project, or service detail is missing, show it as pending confirmation. Do not invent missing values.

## Required Layout

Use the Tim Fleming 2026-07-17 invoice draft as the approved visual model:

- Top-left brand/title: `Buy Your Home`.
- Top-right status block:
  - `INVOICE DRAFT`
  - `For vendor verification`
  - `Not approved for payment`
- Accent divider line below the header.
- Light blue status band with:
  - current verification status,
  - draft date.
- Three-column identity block:
  - Vendor,
  - Project,
  - Bill To.
- Teal-header line-item table with columns:
  - Service Period,
  - Description,
  - Hours or Qty,
  - Rate,
  - Amount.
- Right-aligned totals block:
  - Subtotal,
  - Tax,
  - Draft Total.
- Orange verification note stating that the draft must be confirmed before it is treated as final, filed to Teams, posted to a project spreadsheet, approved, or paid.
- Footer/source note with routed email source traceability.

## Output Rules

- Save the generated PDF in the packet working folder.
- Render the PDF to PNG and visually inspect it before using it.
- Confirm no clipped text, overlapping elements, unreadable glyphs, or broken table layout.
- Preserve the generation script or enough template data to regenerate the PDF later.
- Send the PDF to the vendor for verification when vendor identity, vendor email address, and source evidence are clear. Copy `WesWill@BuyYourHomeLLC.com` and `Jenny@BuyYourHomeLLC.com`, and sign the email as `Jean Wright`.
- Do not forward or attach the routed free-text source email to the vendor. The free-text source stays in the project room for traceability.

## Current Reference Implementation

Reference script:

`C:\Codex\Wiki Files\Project Rooms\Invoice Entry\working\create-vendor-invoice\2026-07-17-pond-tim-fleming-hours\make-polished-invoice.py`

Reference PDF:

`C:\Codex\Wiki Files\Project Rooms\Invoice Entry\working\create-vendor-invoice\2026-07-17-pond-tim-fleming-hours\tim-fleming-pond-hours-invoice-draft.pdf`
