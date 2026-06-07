# Video Source Notes: The 3-File AI System That Works With ANY MODEL

## Source

- Title: The 3-File AI System That Works With ANY MODEL
- Creator / channel: Linking Your Thinking with Nick Milo
- URL: https://www.youtube.com/watch?v=jbHB-rzKBAs
- Length: 14:20
- Captions reviewed: English automatic captions, retrieved 2026-06-07
- Source status: background

## Use Constraint

These notes paraphrase the video's auto-caption content for implementation planning. They are not a full transcript.

## Core Thesis

The video argues for a portable, file-based AI operating system that stays useful even when a specific AI tool, model, API, or vendor changes. The system should live in ordinary files and folders that the owner controls, rather than in one application's private setup.

## Timecoded Notes

| Time | Paraphrased Notes |
| --- | --- |
| 00:00-02:00 | AI workflows should not be locked into tools that may change, break, pivot, or disappear. The durable unit should be plain files that remain accessible across apps. The video's phrase for this is "file over AI," extending Obsidian's "file over app" idea into AI workflows. |
| 02:00-03:30 | The system has three layers: the user's knowledge base, map/manual files that explain that knowledge base, and replaceable AI tools. The knowledge base is the center because it contains the user's unique thinking and context. |
| 03:30-05:00 | A large vault is hard for AI to navigate directly. Map files reduce token waste and help AI find relevant files faster. These maps act as indexes and operating manuals for both humans and AI tools. |
| 05:00-08:00 | The first core file is `me.md`. It is a portable identity and working-preferences file. It should explain who the user is, how the user thinks, and how AI should collaborate. Tool-specific files, such as `claude.md`, can simply point to `me.md`. |
| 08:00-10:15 | The second core file is the vault map. It explains the structure of the knowledge base, where major types of information live, how to navigate folders, and how new notes should be created and named. It changes more often than `me.md` because priorities and folder structures evolve. |
| 10:15-12:00 | The third core map is the skills map. Skills are treated as portable Markdown process documents rather than vendor-specific tool features. A skill says when it should be used and how a repeated workflow should be performed. |
| 12:00-13:15 | The AIOS files should be reviewed periodically and pruned when bloated or outdated. The same gardening rhythm used for a knowledge base should apply to maps and skills. |
| 13:15-14:20 | Privacy and provenance need explicit rules. Users should be intentional about what AI can access, keep sensitive areas out of scope when appropriate, maintain backups, and clearly mark AI-assisted content. |

## Implementation-Relevant Concepts

- Keep AI operating rules in plain Markdown files controlled by the owner.
- Separate durable user/workflow context from tool-specific startup files.
- Use a small number of navigation maps so AI can find relevant sources without scanning the whole vault.
- Treat skills as portable process documentation.
- Add privacy, backup, and AI-generated-content marking rules to the system.
- Expect the tool layer to change; design the files so any model or app can read them.
