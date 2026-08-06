# Dashboard LAN Hosting

## Purpose

This document records the WesStudio LAN-only hosting design for the Buy Your Home Dashboard.

## Host Architecture

- Host machine: WesStudio
- Repository root: `C:\Codex\Wiki Files`
- LAN host URL: `http://10.0.0.105:8765/`
- Listener script: `Project Rooms\Dashboard\tools\Dashboard-LanServer.ps1`
- Hidden startup wrapper: `Project Rooms\Dashboard\tools\Start-DashboardLanHostHidden.vbs`
- Scheduled task name: `BYH Dashboard LAN Host`
- Firewall rule name: `BYH Dashboard LAN Host TCP 8765`
- Scope: private LAN only, subnet `10.0.0.0/24`, TCP port `8765`

## Read-Only Rules

The LAN host serves only these approved read-only paths:

- `Project Rooms\Dashboard\site\*`
- `Project Rooms\<Room>\README.md`
- `Project Rooms\SOPs\outputs\SOPs\*.md`
- `Project Rooms\Entity Relationship\outputs\entity-relationship-chart.svg`

The LAN host does not expose arbitrary files under `C:\Codex\Wiki Files`.

The LAN host rejects write or host-management behavior from remote clients:

- Remote clients cannot use `POST` request paths.
- `__dashboard-refresh` returns a read-only refusal.
- Remote clients do not receive active Codex deep links.
- Remote clients cannot use Dashboard refresh or deletion workflow controls.
- Local WesStudio access through the LAN-host view may record a delegated deletion request, but it still cannot use refresh or other host-management actions through the LAN URL.

Local Dashboard management remains available through the existing local-only Dashboard launch tools on WesStudio.

## Startup

Use `Project Rooms\Dashboard\tools\Register-DashboardLanHost.ps1` to:

1. register the private-only Windows Defender Firewall rule,
2. register the scheduled task,
3. start the scheduled task immediately.

The scheduled task runs at sign-in and starts the LAN host on port `8765` through the hidden VBS launcher so startup does not leave a visible blank PowerShell window.

If the firewall rule already matches the approved scope and only the task action needs to be refreshed, rerun the same script with `-SkipFirewallUpdate`.

## Local Validation

Validate from WesStudio:

1. Open `http://127.0.0.1:8765/`
2. Open `http://10.0.0.105:8765/`
3. Confirm the Dashboard renders.
4. Confirm the local LAN-host view can record a deletion request from `Review deletion`.
5. Confirm the SOPs panel shows only documented Markdown-backed SOP pages.
6. Confirm `http://10.0.0.105:8765/skills/dashboard/SKILL.md` returns `Not found`.
7. Confirm refresh is refused in LAN host mode.

## Remote Validation

From another device on `10.0.0.0/24` while the network profile remains Private:

1. Open `http://10.0.0.105:8765/`
2. Confirm the Dashboard loads.
3. Confirm the page shows a read-only LAN notice.
4. Confirm `Ask Jean`, refresh, and deletion-request creation remain unavailable.
5. Open one Project Room README and one SOP page to confirm approved read-only document views work.
6. Confirm `http://10.0.0.105:8765/skills/dashboard/SKILL.md` does not load.

## Current Admin Follow-Up

As of 2026-08-03, the repo-side hidden-start design is complete, but replacing the already registered scheduled task from this Codex session remained blocked by Windows access control. The current firewall rule already matches the approved scope. To refresh only the task action under an elevated PowerShell, run:

`C:\WINDOWS\System32\WindowsPowerShell\v1.0\powershell.exe -NoProfile -ExecutionPolicy Bypass -File "C:\Codex\Wiki Files\Project Rooms\Dashboard\tools\Register-DashboardLanHost.ps1" -HostIp "10.0.0.105" -RemoteSubnet "10.0.0.0/24" -Port 8765 -RepositoryRoot "C:\Codex\Wiki Files" -SkipFirewallUpdate`

## Rollback

Run:

`Project Rooms\Dashboard\tools\Remove-DashboardLanHost.ps1 -StopRunningServer`

Rollback removes:

- scheduled task `BYH Dashboard LAN Host`
- firewall rule `BYH Dashboard LAN Host TCP 8765`
- currently running LAN host process when `-StopRunningServer` is used

After rollback, the existing local-only Dashboard launch flow remains available.
