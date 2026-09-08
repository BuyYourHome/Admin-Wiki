[CmdletBinding()]
param([switch]$PlanOnly,[switch]$Install,[switch]$Uninstall)
$ErrorActionPreference='Stop'
$release='0.3.0-assisted';$machine='WES-VIDEOEDITOR';$dispatcher='01a05d0c-8031-7d92-9474-ab2330008ddb';$quickbooks='01a05967-9a05-7081-a62e-616b2d8e61fd'
$root=Join-Path $env:LOCALAPPDATA "BuyYourHome\PRMessaging\low-token\releases\$release";$pkg=Join-Path $root 'low-token';$state=Join-Path $env:LOCALAPPDATA 'BuyYourHome\PRMessaging\low-token\assisted-quickbooks';$task='BYH PR Messaging Assisted Worker - Quickbooks'
$cli='C:\Users\IRAMa\AppData\Local\OpenAI\Codex\bin\1e3e57cdf0634c02\codex.exe';$ps='C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe'
if(@($PlanOnly,$Install,$Uninstall|Where-Object {$_}).Count -gt 1){throw 'ChooseOneAction'}
if($Uninstall){Unregister-ScheduledTask -TaskName $task -Confirm:$false -ErrorAction SilentlyContinue;[pscustomobject]@{release=$release;status='Uninstalled';task=$task;changed_heartbeat=$false}|ConvertTo-Json;return}
$source=$PSScriptRoot;$files=@('Common.ps1','Process.ps1','Canary.Guards.ps1','Invoke-AssistedWorker.ps1','Invoke-CodexQueueAdapter.ps1')
$hashes=@{};foreach($f in $files){$hashes[$f]=(Get-FileHash (Join-Path $source $f)).Hash}
$manager=Join-Path $source '..\Manage-ProjectRoomMessage.ps1';$helper=Join-Path $source '..\Claim-ProjectRoomDispatch.ps1'
$config=[ordered]@{schema_version=1;release=$release;expected_machine=$machine;expected_sid=[Security.Principal.WindowsIdentity]::GetCurrent().User.Value;owner='assisted-wve-quickbooks-0.3.0';generation='assisted-1';dispatcher_task_id=$dispatcher;queue_path='\\WES-VIDEOEDITOR\BYH-PRMessaging$';manager_path='C:\Codex\Wiki Files\tools\pr-messaging\Manage-ProjectRoomMessage.ps1';manager_sha256=(Get-FileHash $manager).Hash;helper_path='C:\Codex\Wiki Files\tools\pr-messaging\Claim-ProjectRoomDispatch.ps1';helper_sha256=(Get-FileHash $helper).Hash;adapter_path=(Join-Path $pkg 'Invoke-CodexQueueAdapter.ps1');adapter_sha256=$hashes['Invoke-CodexQueueAdapter.ps1'];client_path=(Join-Path $env:LOCALAPPDATA 'BuyYourHome\PRMessaging\client.json');manifest_path='C:\Codex\Wiki Files\config\pr-messaging-manifests\quickbooks.json';state_directory=$state;powershell_path=$ps;cli_path=$cli;cli_sha256=(Get-FileHash $cli).Hash;allowlist=@{project_room='Quickbooks';task_id=$quickbooks;machine=$machine}}
$plan=[ordered]@{schema_version=1;release=$release;machine=$env:COMPUTERNAME;identity=[Security.Principal.WindowsIdentity]::GetCurrent().Name;status='PlanOnly';install_performed=$false;schedule_registered=$false;task_name=$task;task_identity='InteractiveToken / current user';schedule='Every 60 seconds, indefinitely';destination_allowlist=$config.allowlist;heartbeat_preserved='pr-messaging-dispatcher-wes-videoeditor remains PAUSED';officeassist_preserved=$true;rollback='Unregister this task; retain state, journals and central records; do not resume old heartbeat';files=$hashes}
if(!$Install){$plan|ConvertTo-Json -Depth 8;return}
if($env:COMPUTERNAME -cne $machine -or [Security.Principal.WindowsIdentity]::GetCurrent().Name -ine 'WES-VIDEOEDITOR\IRAMa'){throw 'InstallationIdentityMismatch'}
$hb=Join-Path $env:USERPROFILE '.codex\automations\pr-messaging-dispatcher-wes-videoeditor\automation.toml';if((Get-FileHash $hb).Hash -ine '0CA185E83670F01538B373E8DADF4DA7DA41E9BCD044A1699277EE71D9A0687C'){throw 'HeartbeatMustRemainPaused'}
New-Item -ItemType Directory -Path $pkg,$state -Force|Out-Null
foreach($f in $files){Copy-Item (Join-Path $source $f) (Join-Path $pkg $f) -Force}
Copy-Item (Join-Path $source '..\Message-Integrity.ps1') (Join-Path $root 'Message-Integrity.ps1') -Force
$config|ConvertTo-Json -Depth 12|Set-Content (Join-Path $pkg 'config.json') -Encoding UTF8
$action=New-ScheduledTaskAction -Execute $ps -Argument "-NoProfile -ExecutionPolicy Bypass -File `"$(Join-Path $pkg 'Invoke-AssistedWorker.ps1')`" -ConfigPath `"$(Join-Path $pkg 'config.json')`""
$trigger=New-ScheduledTaskTrigger -Once -At (Get-Date).AddMinutes(1) -RepetitionInterval (New-TimeSpan -Seconds 60) -RepetitionDuration (New-TimeSpan -Days 3650)
$principal=New-ScheduledTaskPrincipal -UserId ([Security.Principal.WindowsIdentity]::GetCurrent().Name) -LogonType Interactive -RunLevel Limited
$settings=New-ScheduledTaskSettingsSet -ExecutionTimeLimit (New-TimeSpan -Seconds 55) -MultipleInstances IgnoreNew -StartWhenAvailable
Register-ScheduledTask -TaskName $task -Action $action -Trigger $trigger -Principal $principal -Settings $settings -Description 'Bounded Quickbooks-only PR messaging worker; manual Quickbooks opening may be required.' -Force|Out-Null
[pscustomobject]@{release=$release;status='Installed';install_performed=$true;schedule_registered=$true;task_name=$task;task_state=(Get-ScheduledTask -TaskName $task).State;task_user=$principal.UserId;schedule='Every 60 seconds, indefinitely';destination_allowlist=$config.allowlist;config_path=(Join-Path $pkg 'config.json');state_directory=$state;heartbeat_hash=(Get-FileHash $hb).Hash;officeassist_unchanged=$true}|ConvertTo-Json -Depth 8
