# Decision 0001: Start With A Markdown Wiki

## Status

Accepted

## Context

The goal is to build a personal knowledge system inspired by OpenBrain and Karpathy's LLM Wiki. There are two broad paths:

- A structured memory database with embeddings, graph relationships, and MCP access.
- A compiled Markdown wiki that humans and AI assistants can both read.

## Decision

Start with the Markdown wiki.

## Rationale

Markdown is easier to inspect, edit, back up, and version. It gives immediate value without database setup. A structured OpenBrain-style layer can be added later once the shape of the knowledge base is clear.

## Consequences

The first version will rely on disciplined source notes, page templates, and assistant prompts. Search and deduplication will be manual or assistant-assisted until a database layer is added.

