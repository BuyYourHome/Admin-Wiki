# Migration Lessons Learned

Last updated: 2026-08-20

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
- Treat app installation, repo setup, skill sync, connector availability, connector account access, and live workflow execution as separate readiness gates.
- Plugin or connector capabilities advertised to a Codex session do not prove account sign-in, permissions, or live connectivity. Verify each material connector with a read-only access check before depending on it.
- GitHub readiness should be verified with both local Git and the GitHub connector:
  - Local Git should be able to read `origin/main`, such as with `git ls-remote origin HEAD`.
  - The GitHub connector should be able to see `BuyYourHome/Admin-Wiki`, branch `main`, and the latest expected commit.
- Outlook readiness should verify key mailbox visibility without opening message bodies. For the completed `WES-VIDEOEDITOR` setup, the visible accounts were `OfficeAssist@BuyYourHomeLLC.com`, `IRAManager@SellYourHomeRaleigh.com`, and `WesWill@BuyYourHomeLLC.com`.
- Teams readiness should confirm the expected business context, including the `Buy Your Home` team and important channels such as `Office Admin` and `General`.
- SharePoint may be partially ready even when keyword search has connector errors. Record per-computer caveats instead of treating all SharePoint access as either fully working or fully broken.
- A low-risk live Admin wiki workflow is the final readiness gate before marking a target computer as Codex-ready.

## Completed WES-VIDEOEDITOR Setup Lessons

- `D:` is useful for OneDrive and bulk files, but the canonical Admin wiki repo should remain at `C:\Codex\Wiki Files` so every computer uses the same expected working path.
- When relocating OneDrive to `D:`, unlink old business accounts first, then connect the intended account and confirm the new `UserFolder` path before syncing large content.
- During OneDrive setup, choose whether to enable Desktop, Documents, and Pictures backup deliberately. For Codex environment replication, skipping PC folder backup avoids unexpected Desktop/Documents/Pictures redirection.
- Do not manually rename or move a connected OneDrive root folder after setup unless the sync client is intentionally reconfigured. A folder-name typo is less risky than breaking a working OneDrive sync by moving the live root underneath it.
- Windows `Temporary files` cleanup with `Cleanup system files` is the safer path for removing `Windows.old` and previous-installation files. Do not manually delete `Windows.old` during target setup.
- Exact skill counts may differ after sync because local/system skills can exist outside the wiki-managed skill set. For readiness, verify that sync completed, the wiki-managed skills exist, and the required project skill is available.
- A final target verification report should distinguish:
  - local machine state,
  - Admin wiki Git state,
  - installed skills,
  - Codex Desktop project readiness,
  - connector/plugin availability,
  - connector account access,
  - known caveats,
  - and the final low-risk workflow result.

## Ongoing Updates

- Keeping target computers current should be its own mode, not mixed into first-time setup.
- Update mode should pull `C:\Codex\Wiki Files` with `git pull --ff-only`, run `tools\sync-codex-skills.ps1`, then start a fresh Codex task or restart Codex Desktop.
- A target update does not include pushing WesStudio changes to GitHub. WesStudio changes must be committed and pushed first under the Admin wiki push rules.
