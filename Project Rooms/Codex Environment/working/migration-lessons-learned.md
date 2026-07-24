# Migration Lessons Learned

Last updated: 2026-07-22

These lessons came from the `WES-VIDEOEDITOR` setup and should be reused before preparing another target computer.

## Storage

- Do not begin the install sequence with less than 12 GB free on `C:`. Prefer 20 GB or more.
- A large secondary drive does not remove the `C:` requirement because Windows installers, app data, temp folders, user profile data, and the canonical Admin wiki path still use `C:`.
- OneDrive property videos can be strong cleanup candidates when using OneDrive `Free up space`, which removes local bytes without deleting the cloud file.
- Avoid deleting OneDrive business files outright during setup. Prefer `Free up space` or ask Wes to approve exact files before deleting.
- PowerShell folder-size scans can be misleading when they traverse junctions such as `AppData\Local\Application Data`. Skip junction-like paths and inspect large files directly.

## Windows Edition And Activation

- If Windows appears to revert from Pro to Home, verify with registry edition and `slmgr /dli` before taking licensing action.
- The reliable check is `EditionID = Professional` plus `License Status: Licensed`. Do not record product keys; the partial key from `slmgr /dli` is acceptable diagnostic context only.
- Do not change activation, license keys, BitLocker, Defender, firewall, Malwarebytes, or other security settings without exact approval.

## Remote Execution

- Windows Remote Desktop over the authorized private LAN was sufficient for setup, but WinRM did not respond from WesStudio.
- When WinRM is unavailable, have Wes run read-only PowerShell commands inside the verified remote session and paste only non-secret output.
- Git may not be available in the same PowerShell session immediately after install. Open a fresh elevated PowerShell window before treating `git` as missing.

## Codex Desktop And Project Setup

- The Windows desktop app may present as ChatGPT during onboarding, but the installed package can still be `OpenAI.Codex`.
- The Microsoft Store package id used for install was `9PLM9XGG6VKS`; verification should look for an `OpenAI.Codex` Appx package.
- For the onboarding work description, choose `Operations`.
- If the app says it does not find projects, create a local project manually:
  - Project name: `Admin Wiki`.
  - Source folder: `C:\Codex\Wiki Files`.
- The first project verification should be a read-only Codex task that confirms the working folder, reads `AGENTS.md` and `Admin Home.md`, reports branch `main`, and reports clean Git status.
- Allowing one read-only terminal check outside the sandbox is acceptable when the sandbox setup fails and the command only reads workspace/Git state.

## Canonical Repo And Skills

- Always use `C:\Codex\Wiki Files` as the Admin wiki working repo. Do not use the Teams-synced wiki folder as the working repo.
- Clone `BuyYourHome/Admin-Wiki` to `C:\Codex\Wiki Files`, confirm `main`, then run `C:\Codex\Wiki Files\tools\sync-codex-skills.ps1`.
- Verify installed skill count after sync. `WES-VIDEOEDITOR` had 29 installed skills after sync.

## Remaining Verification Pattern

- Core setup is not the same as full workflow readiness. Full readiness still requires connector/plugin sign-in checks and one low-risk live Admin wiki workflow from the target computer.

## Ongoing Updates

- Keeping target computers current should be its own mode, not mixed into first-time setup.
- Update mode should pull `C:\Codex\Wiki Files` with `git pull --ff-only`, run `tools\sync-codex-skills.ps1`, then start a fresh Codex task or restart Codex Desktop.
- A target update does not include pushing WesStudio changes to GitHub. WesStudio changes must be committed and pushed first under the Admin wiki push rules.
