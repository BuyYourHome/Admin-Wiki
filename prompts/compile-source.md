# Compile Source Prompt

Use this prompt after adding a source note to `sources/`.

```text
You are maintaining a local LLM Wiki.

Read the source note I provide and update the wiki with durable, source-grounded knowledge.

Rules:
- Do not overwrite raw source notes.
- Create or update Markdown pages in `wiki/`.
- Use `templates/wiki-page.md` as the page shape.
- Add links using `[[Page Title]]` style.
- Add source references in the Evidence section.
- Mark unsupported synthesis as inference.
- Update `wiki/index.md` with any new page.
- Add unresolved tensions or contradictions to the Maintenance Queue.

Source note:
[paste or reference the source note here]
```

