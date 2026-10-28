# Natural voice start allowance — 2026-10-28

Wes asked whether the website safeguard could be adjusted. He was told the 20-start cap is controlled by Pondster and was offered 100/200/no daily cap, with an explicit statement that raising it allows more paid voice sessions. He selected **100 starts per rolling 24 hours**. This authorizes that specific allowance change; no new account, key, billing setting or unlimited access was requested.

The site-wide allowance is now 100 starts in the preceding 24 hours. The matching browser allowance derives from the same constant and is also 100. The existing read-only admission query and atomic reservation query both use that constant. Completed/failed/uncertain history remains in the count until it ages out; no cookie, stored row, usage record or reservation was reset or waived.

The 30-second measured-silence shutdown, absence of a three-minute ongoing-conversation cutoff, one-minute restart cooldown, two concurrent site sessions, one concurrent session per browser, uncertain-session fences and bounded per-conversation work/text limits remain unchanged. Those separate 20-message/delegation limits were not mistaken for the daily-start setting.

The existing real in-memory SQLite suite passed with updated boundaries: starts 1–100 are admitted subject to the other safeguards; the 101st is rejected. The former 20-start state now allows a 21st start. At 99 starts read-only admission agrees with the atomic INSERT; at 100 both reject. Records exactly 24 hours old no longer consume the rolling allowance, while records one millisecond newer do. Existing cooldown, active/uncertain session and owner-waiver preservation regressions remain.

Final TypeScript/build/secret checks, publication identifiers and public availability verification are recorded in [[Project Rooms/Smart House/working/hosting-and-domain]]. No microphone or paid test session is required for the quota/admission checks.

Version 75 is published. Server/real-SQLite regressions, final TypeScript, build, diff and 185-file source/build secret checks passed; two text mirrors match. Native in-app-browser inspection of public Pondstr.com with Voice off showed Talk naturally available and no rolling daily-cap banner. The 30-second quiet and no-three-minute-cutoff text remains visible. No session was started, and the temporary verification tab was closed.
