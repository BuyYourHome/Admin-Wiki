[CmdletBinding()]
param([switch]$PlanOnly,[ValidateSet('Shadow','Validation','Live')][string]$Mode='Shadow')
$ErrorActionPreference='Stop'
# Development release cannot register a task/service, change transport ownership,
# or alter the desktop heartbeat. The installer emits a version-pinned review plan.
if(!$PlanOnly){throw 'InstallationNotAuthorizedInDevelopmentRelease; use -PlanOnly'}
if($Mode -ne 'Shadow'){throw 'CanaryAndLiveInstallationRequireSeparateReviewedRelease'}
$files=@(Get-ChildItem -LiteralPath $PSScriptRoot -File | Where-Object Extension -in @('.ps1','.json') | Sort-Object Name | ForEach-Object {@{path=$_.Name;sha256=(Get-FileHash -LiteralPath $_.FullName).Hash}})
[ordered]@{
    schema_version=1;release='0.2.0';status='PlanOnly';machine=$env:COMPUTERNAME
    intended_identity=[Security.Principal.WindowsIdentity]::GetCurrent().Name
    install_performed=$false;schedule_registered=$false;transport_ownership_changed=$false
    destination=(Join-Path $env:LOCALAPPDATA 'BuyYourHome\PRMessaging\low-token\releases\0.2.0')
    planned_schedule='Every 60 seconds, continuously, interactive normal Windows user; no SYSTEM/password task'
    default_mode='Shadow';live_enabled=$false;files=$files
    prerequisites=@('Review this development release and failure results','Independently approved fresh worker canary and exclusive test ownership','Serialized queue recovery, concurrency, outage and duplicate tests reviewed; no busy probe dependency','Reboot/login/offline/upgrade proof','Reviewed manager deployment with legacy ownership guard; drain before switching','Verify pinned package and client/manifest/ownership generation before activation')
    rollback=@('Stop new claims, reconcile pending submissions','Keep ambiguous IDs excluded; never reset or repeat submission','Drain new transport before exclusive-owner change','Restore backed-up heartbeat only after owner transition; never overlap claimers','Keep central records and journals; never undo business outcomes')
}|ConvertTo-Json -Depth 8
