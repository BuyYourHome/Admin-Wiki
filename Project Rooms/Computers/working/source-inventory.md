# Source Inventory

| Source | Type | Status | Notes |
| --- | --- | --- | --- |
| Wes instruction to create Computers PR | User instruction | authoritative | Computers tracks business computers, specifications, and configuration. |
| `Project Room Workflow.md` | Wiki rule | authoritative | Defines standard Project Room structure and durable outcome log pattern. |
| `Project Room Chat Startup Rule.md` | Wiki rule | authoritative | Defines Start PR and dedicated chat startup requirements. |
| `Project Room File Ownership And Git Coordination Rule.md` | Wiki rule | authoritative | Defines Project Room ownership, cross-PR boundaries, commit scope, and push safety. |
| `Agent Unit Standard.md` | Wiki rule | authoritative | Defines Project Room, skill, registry, chat, and automation package expectations. |
| `Codex Skill Source Rule.md` | Wiki rule | authoritative | Defines canonical skill source and sync expectations. |
| `Git Work Scope Rule.md` | Wiki rule | authoritative | Defines scoped commits and push behavior. |
| Future computer inspection reports | Source records | pending | Use direct machine inspection, vendor/system reports, or Wes-provided specs as authoritative once captured. |
| Codex Environment setup handoffs | Project Room handoff | pending | Use only final setup outcomes or referenced reports from Codex Environment unless Computers is explicitly assigned setup work. |
| `Project Rooms\Codex Environment\outputs\OfficeAssist Core Installation Progress.md` | Project Room handoff | authoritative | Source for OfficeAssist computer identity, core Codex/Admin wiki installation status, PR messaging validation, and Email Monitor production cutover status. |
| Wes instruction for Computers inventory ownership | User instruction | authoritative | Clarifies that Computers owns the authoritative business computer list; other Project Rooms should provide setup or verification handoffs rather than competing machine lists. |
| PR message `prmsg-homeassistant-computers-mini-20260823-001` / dispatch `homeassistant-computers-mini-20260823-001` | Jean Wright Project Room handoff | authoritative | Payload hash `150a86c47341da93300b9b1a89ff5a5299806594a549afce00a5758a0645462b`; verifies only that a non-Windows/non-Microsoft mini computer exists and runs Home Assistant. Referenced source note: `Project Rooms\Home Assistant\sources\initial-source-note.md`. |
| Wes-provided WES-VIDEOEDITOR identity/setup verification in Codex Environment chat, 2026-08-24 | User-provided audit and screenshots | authoritative | Source for Josh Kennedy assignment, Windows profile `IRAMa`, business identity `IRAManager@SellYourHomeRaleigh.com`, Codex Desktop installation, skill sync, Git identity, and OneDrive/Word/Outlook/Teams verification on WES-VIDEOEDITOR. |
| `outputs\computer-login-and-user-account-survey-2026-09-01.md` | Direct computer inspection report | authoritative | Read-only local inspection of WesStudio and authorized RDP inspection of WES-VIDEOEDITOR and OfficeAssist. Records account names, enabled/disabled status, profile/identity roles, source limitations, and the unsurveyed Home Assistant mini blocker without collecting secrets. |
| Wes identification of Jenny and LivingRoomMedia, 2026-09-01 | User-provided inventory update | authoritative | Verifies the two computer names and that neither currently has Windows Pro installed; all other inventory fields remain unverified. |
| Read-only local network discovery from WesStudio, 2026-09-01 | Direct network inspection | authoritative | Observed `Jennys.localdomain` at `10.0.0.140` and `LivingRoomMedia.localdomain` at `10.0.0.150`. Jenny responded to ping; LivingRoomMedia was present in the ARP cache but did not respond to ping. Neither exposed SMB, RDP, WinRM, or RPC for authenticated inventory. Addresses are observations and may change if assigned dynamically. |
