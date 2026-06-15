# Document Scanning Development Handoff

Use this handoff when resuming document-scanning development in a dedicated chat.

## Work From

- Canonical repo: `C:\Codex\Wiki Files`
- Project room: `C:\Codex\Wiki Files\Project Rooms\Document Scan`
- SOP: `C:\Codex\Wiki Files\Document Scanning SOP.md`
- Skill spec: `C:\Codex\Wiki Files\Document Scanning Skill Spec.md`
- Folder map: `C:\Codex\Wiki Files\Document Scanning Folder Map.md`
- Skill source: `C:\Codex\Wiki Files\skills\document-scanning\SKILL.md`
- Live automation config: `C:\Users\wesbr\.codex\automations\document-scanning\automation.toml`

## Preserve

- Never delete source scans.
- Never overwrite filed PDFs or image files silently.
- Route low-confidence documents to review and log why.
- Do not pay invoices or contact vendors.
- Keep statement review and invoice review workflows separate when separate folders/rules exist.
- Use the canonical wiki skill source, not the installed runtime copy, for durable skill edits.

## First Development Tasks

1. Audit the live automation config against the canonical skill and skill spec.
2. Confirm whether a dedicated document-scanning status/development chat already exists.
3. Verify JPG/JPEG processing rules are reflected consistently across the SOP, skill spec, and skill source.
4. Review invoice/project routing against `Invoice and Receipt Processing Notes.md` and `Invoice Project List.md`.
