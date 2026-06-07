# AIOS Implementation Outline

## Proposed Goal

Create a portable AI operating system for the Buy Your Home admin wiki that lets AI tools understand Wes's context, navigate the wiki, and run repeatable workflows from Markdown files that remain useful across tools.

## Proposed File Set

| File | Purpose | Starting Inputs |
| --- | --- | --- |
| `AIOS/me.md` | Wes / office-admin identity, collaboration preferences, tone, authority boundaries, safety defaults, and communication preferences. | Existing `AGENTS.md` instructions, email sender safety rules, calendar scheduling rules, and user preferences captured in the wiki. |
| `AIOS/vault-map.md` | Map of the Admin wiki structure, source-of-truth rules, project rooms, operations folders, skills, automations, and where AI should look first. | `Admin Home.md`, `Repository Location Rule.md`, `Project Room Workflow.md`, `Connector and Plugin Usage Rules.md`, and key folder structure. |
| `AIOS/skills-map.md` | Index of durable workflow skills and when to use each one. | `Agents and Automations Registry.md`, `Codex Skill Source Rule.md`, and `skills/` source folders. |

## Optional Supporting Structure

```text
AIOS/
  me.md
  vault-map.md
  skills-map.md
  tool-startup/
    codex.md
    claude.md
    chatgpt.md
  maintenance-log.md
```

Tool-specific startup files should be thin pointers to the portable AIOS files, not the source of truth.

## Implementation Steps

1. Confirm AIOS scope: Admin wiki only, personal Obsidian vault, or both.
2. Create the `AIOS/` folder in the wiki.
3. Draft `AIOS/me.md` from durable existing instructions, avoiding unsupported personal claims.
4. Draft `AIOS/vault-map.md` from the current wiki map and repository rules.
5. Draft `AIOS/skills-map.md` from the registry and canonical `skills/` folder.
6. Add tool-startup pointers only for tools Wes actually uses.
7. Add maintenance rules: review cadence, stale-rule cleanup, privacy exclusions, and AI-assisted content marking.
8. Test with a real workflow by giving an AI tool only the AIOS files and asking it to locate the right source docs.
9. Revise maps based on what the tool missed or misunderstood.

## Open Decisions

| Decision | Why It Matters |
| --- | --- |
| Should AIOS cover only `C:\Codex\Wiki Files` or broader personal/work knowledge? | Determines what the vault map is allowed to describe. |
| Should private journal, finance, legal, or personal files be explicitly excluded? | Needed for AI access and privacy boundaries. |
| Which tools need startup pointer files? | Avoids maintaining unused tool-specific files. |
| What marker should identify AI-assisted content? | Needed for provenance across future outputs. |

## Initial Recommendation

Start with an Admin-wiki-only AIOS. Use the existing Admin wiki rules as authoritative sources, keep the first version short, and test it against one concrete workflow before expanding it.
