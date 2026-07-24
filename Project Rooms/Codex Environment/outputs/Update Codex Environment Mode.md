# Update Codex Environment Mode

Use this mode when Wes asks to keep an already prepared target computer current with changes made on WesStudio.

This mode updates the Admin wiki repository and wiki-managed Codex skills. It does not install new applications, add remote-control tools, change security settings, sign into accounts, approve connectors, or push changes to GitHub unless Wes separately authorizes that exact action.

## When To Use

- Wes asks to update another Codex/Admin wiki computer.
- A target computer already has the canonical repo at `C:\Codex\Wiki Files`.
- WesStudio has pushed approved Admin wiki changes to GitHub.
- A target computer needs updated Project Room files, rules, checklists, or skills.

## Before Updating

1. Confirm the target computer is authorized for this update session.
2. Confirm the target computer and user identity.
3. Confirm the target repo path is exactly `C:\Codex\Wiki Files`.
4. Confirm the target repo is on `main`.
5. Check target free space. Stop if `C:` has less than 5 GB free; warn if less than 12 GB free.
6. Do not use a Teams-synced wiki folder as the working repo.
7. Do not record passwords, tokens, recovery codes, or live secrets.

## Target Update Commands

Run these on the target computer in PowerShell:

```powershell
git -C 'C:\Codex\Wiki Files' status --short --branch
git -C 'C:\Codex\Wiki Files' fetch origin
git -C 'C:\Codex\Wiki Files' status --short --branch
```

If the target repo is clean and is only behind `origin/main`, update it:

```powershell
git -C 'C:\Codex\Wiki Files' pull --ff-only
powershell -ExecutionPolicy Bypass -File 'C:\Codex\Wiki Files\tools\sync-codex-skills.ps1'
```

Start a fresh Codex task or restart Codex Desktop after skill sync so the updated skills and rules load.

## Stop Conditions

Stop and report before changing anything if:

- `C:\Codex\Wiki Files` is missing.
- The target repo is not on `main`.
- `git status --short --branch` shows uncommitted changes.
- `git pull --ff-only` fails.
- The target has a different remote than `BuyYourHome/Admin-Wiki`.
- The target appears to be using a Teams-synced wiki folder as the working repo.
- The update would require credentials, MFA, account changes, paid apps, security-setting changes, or new connector approvals.

Do not reset, stash, force-pull, delete files, or overwrite target work without Wes approving that exact recovery action.

## Verification

After updating and syncing skills, run:

```powershell
$repoStatus = git -C 'C:\Codex\Wiki Files' status --short --branch
$latestCommit = git -C 'C:\Codex\Wiki Files' log -1 --oneline
$wikiSkills = Get-ChildItem -LiteralPath 'C:\Codex\Wiki Files\skills' -Directory -ErrorAction SilentlyContinue
$installedSkillsPath = Join-Path $env:USERPROFILE '.codex\skills'
$installedSkills = if (Test-Path -LiteralPath $installedSkillsPath) {
  Get-ChildItem -LiteralPath $installedSkillsPath -Directory -ErrorAction SilentlyContinue
} else {
  @()
}
$disk = Get-CimInstance Win32_LogicalDisk -Filter "DeviceID='C:'"

[ordered]@{
  Computer = $env:COMPUTERNAME
  User = $env:USERNAME
  RepoStatus = $repoStatus
  LatestCommit = $latestCommit
  WikiSkillCount = $wikiSkills.Count
  InstalledSkillCount = $installedSkills.Count
  CDriveFreeGB = [math]::Round($disk.FreeSpace / 1GB, 1)
} | ConvertTo-Json -Depth 4
```

Expected result:

- `RepoStatus` shows `main...origin/main` with no changed files listed.
- `LatestCommit` matches the intended GitHub commit.
- `InstalledSkillCount` matches `WikiSkillCount`.
- `CDriveFreeGB` remains adequate for normal operation.

## What This Mode Does Not Cover

- Installing Codex Desktop, Git, LibreOffice, Obsidian, Office, Chrome, or other apps.
- Creating the first Codex project on a target computer.
- Signing into Outlook, Teams, SharePoint, GitHub, browser, or plugin connectors.
- Testing a live business workflow.
- Pushing WesStudio changes to GitHub.

Use the target setup checklist or verification report template for those tasks.
