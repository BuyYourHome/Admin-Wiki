# Karpathy LLM Wiki Pattern

## Summary

The Karpathy LLM Wiki pattern is a way to make knowledge compound across AI sessions. Instead of repeatedly asking an LLM to retrieve and synthesize raw files, the assistant maintains a persistent Markdown wiki that integrates sources, updates related pages, links concepts, and records open questions.

## Core Idea

The wiki sits between raw sources and answers:

- Raw sources are the evidence layer and should remain stable.
- The wiki is the maintained synthesis layer.
- A schema or instruction file tells the assistant how to ingest, query, and lint.

This workspace implements that idea with `sources/`, `wiki/`, `AGENTS.md`, `wiki/index.md`, and `wiki/log.md`.

## Operating Loop

- Ingest: Add a source note, extract durable claims, update existing pages, create missing pages, and log the change.
- Query: Answer from the wiki first, then consult source notes for high-impact claims.
- Lint: Check for stale claims, contradictions, orphan pages, missing cross-links, and topics that need better sourcing.

## Practical Implications

- Good answers should not disappear into chat history; durable synthesis can become a wiki page.
- The assistant should do the repetitive maintenance work: summaries, cross-links, page updates, and bookkeeping.
- The human remains responsible for source selection, review, and direction.

## Evidence

- Source: [[../sources/2026-05-14 - Karpathy LLM Wiki gist]]
- Source: https://gist.github.com/karpathy/442a6bf555914893e9891c11519de94f

## Related Pages

- [[Karpathy Wiki Home]]
- [[Second Brain Architecture]]
- [[LLM Wiki Pattern]]
- [[Karpathy Source Map]]

## Open Questions

- When this wiki reaches roughly 100 source notes, should it add a local Markdown search tool?
- What exact citation style should be enforced for pages that summarize many sources?

## Review Notes

- Last reviewed: 2026-05-14
- Confidence: High for the pattern summary.
- Staleness risk: Low for the core pattern, medium for community tooling around it.
