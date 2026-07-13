# Gracious Millionaire Git Performance

## Repository Settings

The Admin wiki repository uses these local Git settings to reduce large-worktree status scans:

- `core.untrackedCache=true`
- `feature.manyFiles=true`

These settings preserve normal untracked-file reporting. They do not hide files from Git status.

## Benchmark

On 2026-07-13, a normal `git status --short --branch` check fell from roughly 40 seconds to about 0.14 seconds after enabling the settings and refreshing the untracked cache.

## Recovery

If status becomes slow again:

1. Confirm no stale Git process is running.
2. Refresh the cache with `git update-index --untracked-cache`.
3. Re-run a normal status check.
4. Do not disable untracked-file reporting merely to make status appear faster.
