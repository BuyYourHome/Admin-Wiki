# Wiki Maintenance Rules

This workspace is a local Markdown wiki inspired by Andrej Karpathy's LLM Wiki pattern.

## Directory Contract

- `sources/` contains source notes, URLs, excerpts, and provenance. Treat these as the evidence layer.
- `wiki/` contains synthesized pages. These pages can be created and updated by the assistant.
- `wiki/index.md` is the table of contents. Update it whenever adding or renaming wiki pages.
- `wiki/log.md` is append-only. Add a dated entry after meaningful ingests or maintenance passes.

## Source Discipline

- Keep important claims tied to a source note or a direct URL.
- Prefer primary sources: Karpathy's website, GitHub, official project pages, papers, talks, and company announcements.
- Mark interpretation as `Inference:` when it goes beyond the cited source.
- Do not overwrite source notes when the upstream source changes; create a new captured note or add a dated update.

## Page Style

- Use short summaries, concrete bullets, and Obsidian-style links such as `[[Andrej Karpathy]]`.
- Each page should include `Evidence`, `Related Pages`, `Open Questions`, and `Review Notes`.
- Keep pages useful for future answers, not just summaries of one source.

## Workflows

### Ingest

1. Add a source note in `sources/`.
2. Update or create the relevant page in `wiki/`.
3. Add links from `wiki/index.md`.
4. Append an entry to `wiki/log.md`.

### Query

1. Read `wiki/index.md` first.
2. Read the relevant wiki pages.
3. Check source notes for high-impact factual claims.
4. If the answer creates durable synthesis, offer to file it back into the wiki.

### Lint

Periodically check for:

- pages with no inbound links,
- claims without evidence,
- stale career or project status,
- duplicate concepts,
- contradictions between pages,
- open questions that now have answers.
