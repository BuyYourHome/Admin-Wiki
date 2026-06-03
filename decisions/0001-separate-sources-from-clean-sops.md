# 0001 - Separate Sources From Clean SOPs

## Decision

Keep original emails, spreadsheets, and attachments in `sources/`. Keep cleaned procedures in `wiki/`.

## Reason

Original source files are evidence. Clean SOP pages are operational summaries. Keeping them separate makes it easier to audit where each instruction came from and prevents accidental edits to source material.

## Consequences

- Every SOP page needs a source reference.
- Conflicts between source files should be visible instead of silently edited away.
- The wiki can improve over time without losing the original history.
