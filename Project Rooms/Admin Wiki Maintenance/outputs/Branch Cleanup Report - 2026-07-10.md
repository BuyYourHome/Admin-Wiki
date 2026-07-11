# Branch Cleanup Report - 2026-07-10

## Purpose

This report inventories local Admin Wiki branches and recommends a safe cleanup path. No branches were deleted, merged, rebased, or pushed while creating this report.

## Current State

- Repository: `C:\Codex\Wiki Files`
- Current branch: `codex/rei-blackbook-gm-mode-30min`
- Current branch status: ahead of `origin/codex/rei-blackbook-gm-mode-30min` by 24 commits
- `main` is also ahead of `origin/main` by 9 commits
- The working tree contains many unrelated modified and untracked project-room outputs. These should not be bundled into branch cleanup commits.

## Key Findings

1. Branch names are only hints. Git does not know which chat or project room owns a branch unless that relationship is documented elsewhere.
2. Several Gracious Millionaire / REI BlackBook branches are stacked snapshots of the same broad body of work.
3. Some older branches are contained by newer branches and can likely be deleted later, but only after the containing branch is pushed or otherwise preserved.
4. Several branches contain local-only commits. Those branches should not be deleted until their unique commits are reviewed.
5. `main` has local commits not on GitHub. This should be resolved before broad branch deletion.

## Priority Branches

| Branch | Status | Main Concern | Recommendation |
| --- | --- | --- | --- |
| `codex/rei-blackbook-gm-mode-30min` | ahead 24 vs upstream; current branch | Current active REI BlackBook / Gracious Millionaire work | Keep active. Decide whether to push a scoped branch or split unrelated commits before pushing. |
| `main` | ahead 9 vs `origin/main` | Local commits exist on main and are not on GitHub | Review and push/merge deliberately before cleanup. Do not assume GitHub has these commits. |
| `codex/gracious-millionaire-modes` | ahead 30 vs upstream | Contains Gracious Millionaire mode work plus Confidential/Synchrony/Jenny-related commits not present on current branch | Preserve and review before deletion. May need splitting by topic. |
| `codex/rei-blackbook-gracious-millionaire-clean` | ahead 12 vs upstream | Mostly overlapped by later REI branches, but has at least one unique commit: `Restore Sullivan Surveying packet` | Review that unique commit before deletion. |
| `codex/document-scan-defined-modes` | ahead 5 vs upstream | Tip is contained by current Gracious/REI branches, but it still has local-only commits relative to its own upstream | Safe to delete only after current containing branch is pushed/preserved. |
| `codex/project-room-chat-startup` | ahead 1, behind 26 vs `origin/main` | Useful rule commit exists on an outdated branch | Recreate or cherry-pick onto current main instead of pushing this branch as-is. |
| `codex/project-spreadsheet-invoice-entry-lessons` | ahead 1 vs upstream | Invoice-entry Statement Mode work not clearly contained elsewhere | Preserve and review before deletion. |
| `codex/gracious-millionaire-direct-handoff` | ahead 1 vs upstream | Has an invoice-entry restoration commit on a Gracious branch | Review before deletion; may be duplicate or misfiled work. |

## Branches Likely Safe To Archive Or Delete Later

These branches appear contained by newer branches or by `origin/main`, but should not be deleted until the containing branch is pushed/preserved and Wes approves cleanup.

| Branch | Why It Looks Lower Risk | Cleanup Recommendation |
| --- | --- | --- |
| `codex/project-spreadsheet-invoice-entry-room` | Contained by `main`, `origin/main`, and current Gracious/REI branches | Candidate for local and remote deletion after confirmation. |
| `codex/rei-blackbook-gm-contact-cleanup` | Contained by `codex/rei-blackbook-gm-broader-scope` | Candidate for deletion after broader-scope branch is preserved. |
| `codex/rei-blackbook-gm-upload-success` | Contained by `codex/rei-blackbook-gm-broader-scope` | Candidate for deletion after broader-scope branch is preserved. |
| `codex/rei-blackbook-gracious-millionaire` | Contained by current Gracious/REI branches and `codex/gracious-millionaire-modes` | Candidate for deletion after current Gracious/REI work is preserved. |
| `codex/document-scan-defined-modes` | Contained by current Gracious/REI branches and `codex/gracious-millionaire-modes` | Candidate for deletion only after the containing branch is preserved. |

## Historical Branches To Keep For Now

These branches are aligned with their remote upstreams but are not merged into `origin/main`. They may represent completed project-room work that was intentionally left on feature branches, or work that still needs a merge decision.

| Branch Group | Branches | Recommendation |
| --- | --- | --- |
| Amortization | `codex/amortization-footer-versioning`, `codex/amortization-rollout-rules`, `codex/spreadsheet-amortization-rules` | Keep until Wes decides whether these rules/outputs should be merged into main. |
| Contract for Deed | `codex/cfd-amortization-teams-output`, `codex/cfd-full-package-runner`, `codex/cfd-spreadsheet-refactor` | Keep. These contain transaction/package workflow work and spreadsheet artifacts. |
| Document Scan | `codex/document-scan-insurance-rules` | Keep until Doc Scan rules are reviewed against current main. |
| Gracious Millionaire early work | `codex/gracious-millionaire-bill-johnson`, `gracious-millionaire-project-room` | Keep. These are older source/manuscript branches that may still preserve project history. |
| Invoice Entry | `codex/invoice-entry-rename-packet` | Keep until Invoice Entry current-state consolidation is complete. |

## Recommended Cleanup Plan

### Step 1 - Freeze Deletions

Do not delete any branches yet. The repo has multiple local-only commit sets and current dirty worktree output.

### Step 2 - Preserve Current Active Work

Decide what should happen to `codex/rei-blackbook-gm-mode-30min`, which is the active branch and is 24 commits ahead of GitHub.

Options:

- Push this branch as a preservation branch if the whole branch should be saved as-is.
- Create a clean scoped branch from `origin/main` and cherry-pick only the REI BlackBook / Gracious Millionaire website commits.
- Split out unrelated commits, such as MOU or Sullivan Surveying items, before pushing.

### Step 3 - Resolve Local `main`

`main` is 9 commits ahead of `origin/main`. Review those commits and either push them, cherry-pick them into scoped branches, or otherwise preserve them before deleting old feature branches.

### Step 4 - Review Gracious / REI Overlap

Compare and resolve:

- `codex/rei-blackbook-gm-mode-30min`
- `codex/gracious-millionaire-modes`
- `codex/rei-blackbook-gm-broader-scope`
- `codex/rei-blackbook-gracious-millionaire-clean`

Known issue:

- `codex/rei-blackbook-gracious-millionaire-clean` has at least one unique commit not in `codex/rei-blackbook-gm-broader-scope`: `9d6dee8e Restore Sullivan Surveying packet`.

### Step 5 - Delete Only Confirmed Duplicates

After preservation, delete only branches that are confirmed ancestors of preserved branches or `origin/main`.

First candidates:

- `codex/project-spreadsheet-invoice-entry-room`
- `codex/rei-blackbook-gm-contact-cleanup`
- `codex/rei-blackbook-gm-upload-success`
- `codex/rei-blackbook-gracious-millionaire`

## Practical Decision Rule

For each branch, use this rule:

- If the branch has local-only commits, preserve first.
- If the branch is not merged into `origin/main`, do not delete unless its tip is contained by a preserved branch.
- If the branch is both contained and pushed, it can be deleted after Wes approves.
- If the branch includes legal, financial, project-room rule, skill, automation, or source-material changes, review before deletion even if it appears duplicated.

## Next Recommended Action

Create a focused preservation branch for the current active Gracious Millionaire / REI BlackBook work, or push `codex/rei-blackbook-gm-mode-30min` as a preservation snapshot if Wes wants the fastest safety step.

After that, separately resolve local `main` and the Gracious/REI overlap branches.
