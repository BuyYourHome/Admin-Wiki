# GM Mode Run Lock

Status: inactive.

This file is the coordination lock for `gm-mode-site-iteration`.

When a GM Mode run starts, it should replace this file with an active lock that includes:

- status: active
- start time
- automation id
- thread id
- run purpose
- stale-time rule: 3 hours after start
- cleanup rule: clear or reset this file at normal completion

If this file shows an active lock less than 3 hours old, a later GM Mode run must not inspect or edit the live site. It should stop quietly unless a user-visible notice is needed.

If the active lock is 3 hours old or older, the later run may treat it as stale, record a stale-lock takeover in the project room, replace the lock, and proceed.
