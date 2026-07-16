# Quick Mode

## Purpose

Use Quick mode when Wes wants new Gracious Millionaire source material inserted into the proper manuscript context without a total rewrite. Quick mode is also the default mode when the Gracious Millionaire project room receives new substantive book/source material.

Quick mode is an integration mode, not a full-manuscript rebuild. It finds new or changed source material, updates the shared Book Architecture, and revises the affected chapter area. When the architecture shows that the new material changes organization, Quick mode may move, split, join, or resequence the affected chapter group while leaving chapters outside that group materially intact.

Quick mode should work from the modular manuscript state when it exists: `outputs/quick-mode/manifest.md` plus one Markdown file per chapter under `outputs/quick-mode/chapters/`.

## Trigger

Use this mode when Wes says `Quick mode`, asks to quickly add new material to the manuscript, asks for a new source to be placed in its proper context, or when the project room receives new substantive book/source material and Wes has not directly requested another mode.

If Wes directly asks for a whole-book rethink, chapter-context influence across the whole manuscript, major redundancy reduction, or each chapter to materially affect all others, use Rewrite mode instead.

## Inputs

Before drafting, read and use:

- `working/source-inventory.md`
- `working/duplicate-and-conflict-log.md`
- `working/missing-context.md`
- `working/writing-style-guide.md`
- `working/book-objectives.md`
- `working/manuscript-edit-and-fact-notes.md`
- `working/book-architecture.md`
- the new authoritative source file or files being integrated
- the current Quick-mode manuscript, if one exists
- if no Quick-mode manuscript exists, the latest source-backed non-mode manuscript selected from the project-room source inventory

Original source files and current correction notes control over any manuscript text. Mode outputs from Interview, Dialogue, or Rewrite may be checked for coverage or presentation history, but they are not source material for Quick mode.

## Required Steps

1. Identify the new source material and whether it is new, duplicate, corrective, or superseding.
2. Update the affected story units, source references, voice ownership, themes, dependencies, and proposed placement in `working/book-architecture.md`.
3. Classify the work as a Simple Quick update or a Structural Quick update.
4. For a Simple Quick update, draft only the new or affected material and apply narrow continuity edits around the insertion point.
5. For a Structural Quick update, move, split, join, resequence, or transition the affected chapter group as required by the architecture.
6. Preserve chapters outside the affected structural group unless a factual correction or documented dependency requires a scoped edit.
7. Draft changed prose from original sources and the current Quick-mode manuscript state. Do not copy or adapt Rewrite, Dialogue, or Interview prose.
8. Save the output by editing the affected chapter Markdown files or adding new chapter files under `outputs/quick-mode/chapters/`, then update `outputs/quick-mode/manifest.md` when order, title, or status changes.
9. Update `working/source-inventory.md`, `working/officeassist-intake-log.md`, and any relevant working notes.
10. Rebuild the clickable HTML packet from the manifest. Do not edit the compiled HTML directly.

## Structural Quick Updates

A Structural Quick update is required when new or corrected source material changes chapter purpose, chronology, thematic ownership, narrator or speaker ownership, or the best grouping of existing story units. It may affect more than one chapter without becoming a whole-manuscript Rewrite pass.

Quick mode does not need to reconsider every unaffected chapter. It must, however, bring the complete affected chapter group into alignment with the current Book Architecture so the Quick manuscript does not remain trapped in an obsolete structure.

## Output Naming

Use this stable modular structure unless Wes directs otherwise:

- `outputs/quick-mode/manifest.md`
- `outputs/quick-mode/chapters/*.md`
- `outputs/Gracious Millionaire - Quick Mode.html`

Put the version id in the top manuscript heading and clickable packet heading, not in the file name.

The full single-file Markdown export `outputs/Gracious Millionaire - Quick Mode.md` is optional. Generate it only when Wes asks for a plain Markdown export, when another tool requires it, or when a specific delivery workflow needs it.

## Build Command

Use the Codex workspace Python runtime:

```powershell
& 'C:\Users\wesbr\.cache\codex-runtimes\codex-primary-runtime\dependencies\python\python.exe' 'C:\Codex\Wiki Files\Project Rooms\Gracious Millionaire\tools\manuscript_modules.py' build --manifest 'C:\Codex\Wiki Files\Project Rooms\Gracious Millionaire\outputs\quick-mode\manifest.md'
```

## Relationship To Interview Mode

The current Quick-mode manuscript is the only manuscript reference Interview mode may use. Interview mode still drafts from original source material and approved contextual source records; the Quick-mode manuscript is a manuscript reference for sequence and current included text, not the factual authority.
