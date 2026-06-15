# Open Brain / LLM Wiki Starter

This project is a local-first second brain setup inspired by Andrej Karpathy's LLM Wiki pattern.

The practical starting point is a Markdown wiki:

1. Save source material in `sources/`.
2. Ask an AI assistant to compile durable wiki pages in `wiki/`.
3. Keep claims tied to source notes.
4. Review and revise pages over time instead of re-answering the same questions from scratch.

OpenBrain-style memory can be added later as a structured store behind the wiki. For now, the wiki is the human-readable layer and the durable artifact.

## Folder Layout

```text
sources/              Raw inputs: notes, URLs, transcripts, PDFs summarized to text
wiki/                 Compiled knowledge pages
wiki/index.md         Table of contents and map of the wiki
templates/            General wiki and project-room templates
prompts/              Reusable prompts for compiling and maintaining the wiki
decisions/            Architecture and workflow decisions
Project Rooms/        Source-preparation workspaces for complex projects
```

## Recommended First Workflow

1. Put one source in `sources/`.
2. Ask the assistant to run the prompt in `prompts/compile-source.md`.
3. Review the generated page in `wiki/`.
4. Add links from `wiki/index.md`.
5. Repeat with new sources.

For SOP work, use `Project Rooms/SOPs/` instead of the generic `sources/` and `wiki/` folders.

## Project Rooms

For complex work involving multiple sources, use `Project Room Workflow.md` before drafting. Project Rooms keep raw inputs, working inventories, conflict checks, and final outputs separated so Codex can reason from authoritative sources instead of blending stale or conflicting files.

## When To Add OpenBrain

Add an OpenBrain-style database or MCP memory layer when you need:

- Cross-agent memory shared by multiple assistants.
- Semantic search over many small thoughts.
- Deduplication and relationship extraction.
- An API that tools can read and write.

Keep the Markdown wiki even then. It is the browsable, reviewable output layer.
