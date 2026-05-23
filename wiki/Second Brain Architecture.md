# Second Brain Architecture

## Summary

This project starts with a local Markdown wiki as the durable knowledge layer. Raw sources live in `sources/`; synthesized, linked, reviewable pages live in `wiki/`.

## Layers

### Source Layer

The source layer stores raw or lightly cleaned material. It should preserve provenance: title, URL or file path, date captured, author, and notes about reliability.

### Compiled Wiki Layer

The wiki layer contains human-readable pages that synthesize sources into stable concepts, decisions, and references. Pages should link to related pages and cite source notes.

### Structured Memory Layer

An OpenBrain-style layer can be added later for semantic search, deduplication, graph relationships, and MCP access. It should feed the wiki rather than replace it.

## Design Choice

Start with Markdown because it is portable, inspectable, versionable, and easy to use with Obsidian or any code editor.

