# 24/7 Deterministic Worker Release 0.4.6

Date: 2026-09-16

## Purpose

Release `0.4.6` corrects a stale versioned Codex CLI pin discovered on OFFICEASSIST after a Codex application update.

## Verified Failure

The installed `0.4.5` worker referenced a deleted `codex.exe` path. Three attempts for the Josh September 15 Time Card record exited before creating a submission marker or notifying Invoice Entry. All three attempts were authoritatively recorded `NotDelivered`; the exhausted record remains immutable history.

## Change

- `UpgradeLive` resolves and reviews the current normal-user `codex.exe` under `%LOCALAPPDATA%\OpenAI\Codex\bin\<version>\codex.exe`.
- The upgrade pins the reviewed absolute path and SHA-256 in the new release configuration.
- Unreviewed locations and reparse points are rejected.
- Ordinary ticks do not auto-discover or auto-trust a replacement executable.
- A missing pinned executable reports `CliExecutableMissing` without retaining raw command output.
- Owner generation, journal, state directory, scheduled task, hidden launcher, schedule, destination pins, and central records are preserved.

## Recovery

After installing `0.4.6`, verify the configured CLI path and hash match the current executable. The exhausted Josh record must not be reset or reused. Its source workflow may create one new immutable successor only after the corrected adapter passes a non-production transport check or an otherwise bounded authorized recovery check.
