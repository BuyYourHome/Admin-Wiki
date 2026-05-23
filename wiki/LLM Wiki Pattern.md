# LLM Wiki Pattern

## Summary

The LLM Wiki pattern compiles source material into a persistent, interlinked knowledge base before questions are asked. This differs from basic retrieval workflows where the model repeatedly searches and synthesizes from raw chunks at answer time.

## Core Loop

1. Capture source material.
2. Extract important claims, concepts, people, tools, and open questions.
3. Create or update wiki pages.
4. Cross-link related pages.
5. Review for provenance, contradictions, and stale information.

## Strengths

- Preserves synthesis work.
- Makes knowledge browsable by humans.
- Gives future AI sessions better context.
- Works well with Git history.

## Risks

- Confident but unsupported claims.
- Stale pages after source material changes.
- Duplicate pages for the same concept.
- Cross-links that imply relationships not supported by the sources.

## Review Rule

Every important claim should point back to a source note or be clearly marked as an inference.

