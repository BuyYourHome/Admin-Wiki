# Simplified OA Subfile Reassembly Verification

Source project-room file: `Simplified OA - 25-06-25 SELL_YOUR_HOME_LLC Simplified with Summary with Jeff Watson tracked edits.docx`
Source rule: Controlled local project-room source; Teams is final delivery/archive only unless Wes explicitly identifies a Teams file as a new source.
Reassembled file: `Reassembled OA Check - 00 - Reassembled Verification - Simplified OA with Jeff Watson tracked edits.docx`

## Result

- Source block count: 412
- Reassembled block count: 412
- Source block hash: `1f6fc3f90572cbf4e4a3ab405936d849745cca2b802c90c7810d88706f3c00b7`
- Reassembled block hash: `1f6fc3f90572cbf4e4a3ab405936d849745cca2b802c90c7810d88706f3c00b7`
- Verification result: PASS

The verification hash is calculated from the canonical OOXML for the ordered document body blocks, excluding the final section-properties block. The reassembled file is built by reading the generated subfile DOCXs from disk and concatenating their body blocks in manifest order. A PASS confirms the split and reassembly preserve the original body text and formatting XML.

## Segment Manifest

| File | Segment | Blocks | First Text |
| --- | --- | ---: | --- |
| `01 - Opening Paragraphs.docx` | Opening Paragraphs | 15 | AMENDED AND RESTATED OPERATING AGREEMENT |
| `02 - Summary of Operating Agreement Articles.docx` | Summary of Operating Agreement Articles | 105 | Summary of Operating Agreement Articles |
| `03 - Article 1 - Offices and Records.docx` | Article 1 - Offices and Records | 9 | Offices and Records |
| `04 - Article 2 - Membership Units.docx` | Article 2 - Membership Units | 23 | Membership Units |
| `05 - Article 3 - Buy-Sell Rights and Transfer Restrictions.docx` | Article 3 - Buy-Sell Rights and Transfer Restrictions | 41 | Buy-Sell Rights, New Members and |
| `06 - Article 4 - Meetings of Members.docx` | Article 4 - Meetings of Members | 59 | Meetings of Members |
| `07 - Article 5 - Managers.docx` | Article 5 - Managers | 43 | Manager(s) |
| `08 - Article 6 - Indemnification.docx` | Article 6 - Indemnification | 45 | Indemnification |
| `09 - Article 7 - Fiscal Matters.docx` | Article 7 - Fiscal Matters | 22 | FISCAL MATTERS |
| `10 - Article 8 - Dissolution.docx` | Article 8 - Dissolution | 21 | Dissolution |
| `11 - Article 9 - Special Provisions.docx` | Article 9 - Special Provisions | 10 | Special Provisions |
| `12 - Article 10 - Miscellaneous.docx` | Article 10 - Miscellaneous | 12 | Miscellaneous |
| `13 - Certification and Exhibit A.docx` | Certification and Exhibit A | 7 | CERTIFICATION |
