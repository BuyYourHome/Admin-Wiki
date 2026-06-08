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

## ACE-Informed Wiki Organization

The second video source introduces ACE as a stable orientation system:

| ACE Area | Thinking Mode | Admin Wiki Fit |
| --- | --- | --- |
| `Atlas` | Knowledge | Durable SOPs, source-of-truth rules, folder maps, registry pages, connector rules, and reference notes. |
| `Calendar` | Time | Dated logs, recurring summary cutoffs, meeting or reminder notes, and time-based review records. |
| `Efforts` | Action | Project rooms, active document packages, workflow redesigns, implementations, and open work with deliverables. |

The current Admin wiki already behaves partly like an ACE system even though it does not use those folder names. For AIOS, the practical implementation should not rename the existing wiki. Instead, `AIOS/vault-map.md` should explain the existing structure through the ACE lens so an AI tool can quickly decide whether a request is asking for durable knowledge, time-based context, or active project work.

## Proposed Vault-Map Sections

1. Source of truth and repository location.
2. Admin wiki orientation map.
3. ACE lens for the existing wiki:
   - Atlas-like areas: SOPs, rules, registries, maps, skills.
   - Calendar-like areas: logs, recurring cutoffs, dated summaries.
   - Efforts-like areas: Project Rooms and active deliverables.
4. Routing rules for common requests.
5. File creation and placement rules.
6. Privacy and AI-access boundaries.
7. Maintenance cadence and stale-context cleanup.

## Implementation Steps

1. Confirm AIOS scope: Admin wiki only, personal Obsidian vault, or both.
2. Confirm Wes does not need uninterrupted access during the implementation window.
3. Create the `AIOS/` folder in the wiki.
4. Draft `AIOS/me.md` from durable existing instructions, avoiding unsupported personal claims.
5. Draft `AIOS/vault-map.md` from the current wiki map and repository rules, using ACE as an explanatory lens without renaming the repo.
6. Draft `AIOS/skills-map.md` from the registry and canonical `skills/` folder.
7. Add tool-startup pointers only for tools Wes actually uses.
8. Add maintenance rules: review cadence, stale-rule cleanup, privacy exclusions, and AI-assisted content marking.
9. Test with a real workflow by giving an AI tool only the AIOS files and asking it to locate the right source docs.
10. Revise maps based on what the tool missed or misunderstood.

## Timing Strategy

Implementation should wait for a low-access window when Wes does not need active use of the wiki. The first implementation should remain an overlay only: add root-level `AIOS/` files and indexes, avoid renaming `C:\Codex\Wiki Files`, and avoid moving existing folders.

## Open Decisions

| Decision | Why It Matters |
| --- | --- |
| Should AIOS cover only `C:\Codex\Wiki Files` or broader personal/work knowledge? | Determines what the vault map is allowed to describe. |
| Should private journal, finance, legal, or personal files be explicitly excluded? | Needed for AI access and privacy boundaries. |
| Which tools need startup pointer files? | Avoids maintaining unused tool-specific files. |
| What marker should identify AI-assisted content? | Needed for provenance across future outputs. |

## Initial Recommendation

Start with an Admin-wiki-only AIOS. Use the existing Admin wiki rules as authoritative sources, keep the first version short, and test it against one concrete workflow before expanding it.
