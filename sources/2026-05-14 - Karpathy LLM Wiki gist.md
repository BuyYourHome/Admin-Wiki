# Karpathy LLM Wiki Gist

## Metadata

- Title: LLM Wiki
- Author / creator: Andrej Karpathy
- URL or file path: https://gist.github.com/karpathy/442a6bf555914893e9891c11519de94f
- Date captured: 2026-05-14
- Date published: 2026-04-04
- Source type: GitHub Gist / idea file
- Reliability notes: Primary source for the LLM Wiki pattern. The gist explicitly describes itself as abstract and not a fixed implementation.

## Raw Notes

Karpathy describes an LLM-maintained Markdown wiki that sits between raw sources and the user. Instead of re-deriving answers from raw chunks each time, the assistant incrementally compiles sources into durable pages, updates related entities and concepts, tracks contradictions, and uses an index and log to keep the system navigable.

The architecture has three layers: raw sources, the wiki, and a schema file that tells the assistant how to operate. The operating loop is ingest, query, and lint. Karpathy also frames Obsidian as the human-facing browsing environment, the LLM as the maintainer, and the wiki as the durable artifact.

## Key Claims

- Raw sources should remain the source of truth.
- The wiki should be a persistent, compounding artifact rather than a temporary answer.
- The assistant should own wiki maintenance, including summaries, cross-references, contradictions, and bookkeeping.
- `index.md` is content-oriented; `log.md` is chronological.
- The exact implementation should be adapted to the user's domain and tools.

## Concepts

- LLM Wiki
- Compounding knowledge base
- Raw source layer
- Wiki layer
- Schema layer
- Ingest / query / lint workflow
- Obsidian as wiki IDE

## People / Organizations / Tools

- Andrej Karpathy
- OpenAI Codex
- Claude Code
- Obsidian
- qmd

## Questions Raised

- How much human review should happen before wiki updates become trusted?
- At what scale should this workspace add search beyond `index.md`?
- What citation format should be used when the wiki becomes larger?

## Suggested Wiki Pages

- [[Karpathy LLM Wiki Pattern]]
- [[Second Brain Architecture]]
- [[Karpathy Wiki Home]]
