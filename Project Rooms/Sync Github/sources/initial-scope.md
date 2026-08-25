# Initial Scope

Source: Wes instruction dated 2026-08-22.

Authoritative requirements:

- Create a Project Room named `Sync GetHub`.
- The Project Room should run on all Buy Your Home computers.
- It should keep the canonical repository up to date.
- It must run at least once each day.
- It must account for changes made on all machines.

Implementation interpretation:

- GitHub is the shared exchange point.
- Each approved computer requires its own local scheduled run.
- Safe unattended updates are limited to fetching and clean fast-forward pulls.
- Local changes, local-only commits, and divergence must be preserved and reported rather than overwritten or resolved automatically.
