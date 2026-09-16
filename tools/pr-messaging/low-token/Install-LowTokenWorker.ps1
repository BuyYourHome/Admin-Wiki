[CmdletBinding()]
param(
    [ValidateSet('Plan','Stage','StartValidation','PromoteLive','UpgradeLive','Rollback')]
    [string]$Action='Plan',
    [string]$ExpectedMachine='WES-VIDEOEDITOR',
    [string]$DispatcherTaskId='01a05d0c-8031-7d92-9474-ab2330008ddb',
    [string]$LegacyAutomationId='pr-messaging-dispatcher-wes-videoeditor',
    [switch]$AllowActiveEmbeddedFallback,
    [string]$ValidationMessageId
)
$ErrorActionPreference='Stop'
$release='0.4.3'
$queue='\\WES-VIDEOEDITOR\BYH-PRMessaging$'
$task="BYH PR Messaging Worker - $ExpectedMachine"
$root=Join-Path $env:LOCALAPPDATA "BuyYourHome\PRMessaging\low-token\releases\$release"
$pkg=Join-Path $root 'low-token'
$state=Join-Path $env:LOCALAPPDATA 'BuyYourHome\PRMessaging\low-token\production'
$configPath=Join-Path $pkg 'config.json'
$ownerPath=Join-Path (Join-Path $queue '.transport-owners') ($ExpectedMachine.ToUpperInvariant()+'.json')
$ps='C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe'
$wscript='C:\Windows\System32\wscript.exe'
$legacyTask='BYH PR Messaging Assisted Worker - Quickbooks'
$files=@('Common.ps1','Process.ps1','Canary.Guards.ps1','Invoke-LowTokenWorker.ps1','Invoke-CodexQueueAdapter.ps1','Invoke-ManagerCommand.ps1','Invoke-LowTokenWorkerHidden.vbs')
. (Join-Path $PSScriptRoot 'Common.ps1')

function New-LtWorkerTaskAction([string]$Package,[string]$WorkerConfig,[string]$Mode,[string]$MessageId='') {
    $launcher=Join-Path $Package 'Invoke-LowTokenWorkerHidden.vbs'
    $worker=Join-Path $Package 'Invoke-LowTokenWorker.ps1'
    $arguments="//B //NoLogo `"$launcher`" `"$ps`" `"$worker`" `"$WorkerConfig`" `"$Mode`""
    if(![string]::IsNullOrWhiteSpace($MessageId)){$arguments+=" `"$MessageId`""}
    New-ScheduledTaskAction -Execute $wscript -Argument $arguments
}

if($Action -eq 'Plan'){
    $embeddedFallbackException=([bool]$AllowActiveEmbeddedFallback -and $ExpectedMachine -ceq 'OFFICEASSIST' -and $LegacyAutomationId -ceq 'officeassist-morning-email-summary-and-instruction-monitor')
    [ordered]@{schema_version=1;release=$release;action=$Action;machine=$ExpectedMachine;dispatcher_task_id=$DispatcherTaskId;task_name=$task;schedule='Every 60 seconds, 24/7';launcher='wscript.exe hidden window host';stage_changes_transport=$false;validation='One exact synthetic record before live promotion';active_embedded_fallback_exception=$embeddedFallbackException;exclusive_owner=$ownerPath;rollback='Remove only this worker and owner; preserve journals and central records; explicitly restore the prior dispatcher.'}|ConvertTo-Json -Depth 8
    return
}
if($env:COMPUTERNAME -cne $ExpectedMachine){throw 'InstallationMachineMismatch'}
if($DispatcherTaskId -cnotmatch '^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$'){throw 'InvalidDispatcherTaskId'}

if($Action -eq 'UpgradeLive'){
    $sourceRelease=@($release,'0.4.2','0.4.1','0.4.0')|Where-Object {Test-Path -LiteralPath (Join-Path $env:LOCALAPPDATA "BuyYourHome\PRMessaging\low-token\releases\$_\low-token\config.json")}|Select-Object -First 1
    if([string]::IsNullOrWhiteSpace($sourceRelease)){throw 'LiveSourceConfigMissing'}
    $oldRoot=Join-Path $env:LOCALAPPDATA "BuyYourHome\PRMessaging\low-token\releases\$sourceRelease"
    $oldPkg=Join-Path $oldRoot 'low-token';$oldConfigPath=Join-Path $oldPkg 'config.json'
    $oldCfg=Read-LtJson $oldConfigPath
    if($oldCfg.release -cne $sourceRelease -or $oldCfg.expected_machine -cne $ExpectedMachine -or
        $oldCfg.dispatcher_task_id -cne $DispatcherTaskId -or (Get-LtPackageHash $oldPkg) -cne $oldCfg.package_sha256){throw 'LiveSourceConfigurationMismatch'}
    $owner=Read-LtJson $ownerPath
    if($owner.mode -cne 'Live' -or $owner.machine -cne $ExpectedMachine -or
        $owner.task_id -cne $DispatcherTaskId -or $owner.owner -cne $oldCfg.owner -or
        $owner.generation -cne $oldCfg.generation -or $owner.sid -cne $oldCfg.expected_sid){throw 'LiveSourceOwnerMismatch'}
    $scheduled=Get-ScheduledTask -TaskName $task -ErrorAction Stop
    Disable-ScheduledTask -TaskName $task|Out-Null
    $deadline=[DateTime]::UtcNow.AddSeconds(60)
    while((Get-ScheduledTask -TaskName $task).State -eq 'Running' -and [DateTime]::UtcNow -lt $deadline){Start-Sleep -Milliseconds 250}
    if((Get-ScheduledTask -TaskName $task).State -eq 'Running'){
        Enable-ScheduledTask -TaskName $task|Out-Null
        throw 'LiveWorkerDidNotBecomeIdle'
    }
    try{
        New-Item -ItemType Directory -Path $pkg -Force|Out-Null
        foreach($f in $files){Copy-Item -LiteralPath (Join-Path $PSScriptRoot $f) -Destination (Join-Path $pkg $f) -Force}
        Copy-Item -LiteralPath (Join-Path $PSScriptRoot '..\Message-Integrity.ps1') -Destination (Join-Path $root 'Message-Integrity.ps1') -Force
        . (Join-Path $pkg 'Common.ps1')
        $cfg=$oldCfg
        $cfg.release=$release
        $cfg.manager_sha256=(Get-FileHash 'C:\Codex\Wiki Files\tools\pr-messaging\Manage-ProjectRoomMessage.ps1').Hash
        $cfg.adapter_path=Join-Path $pkg 'Invoke-CodexQueueAdapter.ps1'
        $cfg.adapter_sha256=(Get-FileHash $cfg.adapter_path).Hash
        $cfg.package_sha256=Get-LtPackageHash $pkg
        Write-LtJson $configPath $cfg
        $taskAction=New-LtWorkerTaskAction $pkg $configPath 'Live'
        Set-ScheduledTask -TaskName $task -Action $taskAction|Out-Null
        Enable-ScheduledTask -TaskName $task|Out-Null
    }catch{
        Enable-ScheduledTask -TaskName $task -ErrorAction SilentlyContinue|Out-Null
        throw
    }
    [pscustomobject]@{release=$release;status='LiveUpgraded';task=$task;task_enabled=$true;config_path=$configPath;owner=$owner.owner;generation_preserved=$owner.generation;state_directory=$cfg.state_directory;journal_preserved=$true}|ConvertTo-Json -Depth 8
    return
}

if($Action -eq 'Rollback'){
    if(Test-Path -LiteralPath $configPath){
        . (Join-Path $pkg 'Common.ps1')
        $rollbackCfg=Read-LtJson $configPath
        $journalPath=Join-Path $rollbackCfg.state_directory 'journal.json'
        if(Test-Path -LiteralPath $journalPath){
            $journal=Read-LtJson $journalPath
            if(@($journal.entries|Where-Object phase -ne 'closed').Count){throw 'RollbackBlockedByOutstandingJournal'}
        }
        $owned=@((& $rollbackCfg.manager_path -Action List -QueuePath $queue|Out-String)|ConvertFrom-Json|Where-Object {@($_.attempts|Where-Object {$_.transport_owner -ceq $rollbackCfg.owner -and $_.outcome -eq 'Pending'}).Count})
        if($owned.Count){throw 'RollbackBlockedByOutstandingCentralAttempt'}
    }
    Disable-ScheduledTask -TaskName $task -ErrorAction SilentlyContinue|Out-Null
    Unregister-ScheduledTask -TaskName $task -Confirm:$false -ErrorAction SilentlyContinue
    if(Test-Path -LiteralPath $ownerPath){
        $owner=Get-Content -Raw -LiteralPath $ownerPath|ConvertFrom-Json
        if($owner.owner -cne ('low-token-'+$ExpectedMachine.ToLowerInvariant()) -or $owner.task_id -cne $DispatcherTaskId){throw 'ForeignTransportOwnerRefused'}
        Remove-Item -LiteralPath $ownerPath -Force
    }
    [pscustomobject]@{release=$release;status='RolledBack';task=$task;owner_removed=!(Test-Path -LiteralPath $ownerPath);state_preserved=$true}|ConvertTo-Json
    return
}

if($Action -eq 'Stage'){
    $clientPath=Join-Path $env:LOCALAPPDATA 'BuyYourHome\PRMessaging\client.json'
    if(!(Test-Path -LiteralPath $clientPath)){throw 'ClientRegistrationMissing'}
    $client=Get-Content -Raw -LiteralPath $clientPath|ConvertFrom-Json
    if($client.machine -cne $ExpectedMachine){throw 'ClientMachineMismatch'}
    $manifestDirectory='C:\Codex\Wiki Files\config\pr-messaging-manifests'
    $manifests=@(Get-ChildItem -LiteralPath $manifestDirectory -Filter '*.json' -File|ForEach-Object{Get-Content -Raw -LiteralPath $_.FullName|ConvertFrom-Json})
    $destinations=@()
    foreach($reg in @($client.registrations)){
        if($reg.task_id -ceq $DispatcherTaskId){continue}
        $matches=@($manifests|Where-Object {Test-LtStageManifest $_ $reg $ExpectedMachine})
        if($matches.Count -eq 1){$destinations+=@{project_room=$reg.project_room;task_id=$reg.task_id;machine=$ExpectedMachine}}
    }
    if(!$destinations.Count){throw 'NoDispatchableLocalDestinations'}
    $cli=(Get-Command codex.exe -ErrorAction Stop).Source
    New-Item -ItemType Directory -Path $pkg,$state -Force|Out-Null
    foreach($f in $files){Copy-Item -LiteralPath (Join-Path $PSScriptRoot $f) -Destination (Join-Path $pkg $f) -Force}
    Copy-Item -LiteralPath (Join-Path $PSScriptRoot '..\Message-Integrity.ps1') -Destination (Join-Path $root 'Message-Integrity.ps1') -Force
    . (Join-Path $pkg 'Common.ps1')
    $cfg=[ordered]@{schema_version=1;release=$release;expected_machine=$ExpectedMachine;expected_sid=[Security.Principal.WindowsIdentity]::GetCurrent().User.Value;owner=('low-token-'+$ExpectedMachine.ToLowerInvariant());generation=$release;dispatcher_task_id=$DispatcherTaskId;queue_path=$queue;manager_path='C:\Codex\Wiki Files\tools\pr-messaging\Manage-ProjectRoomMessage.ps1';manager_sha256=(Get-FileHash 'C:\Codex\Wiki Files\tools\pr-messaging\Manage-ProjectRoomMessage.ps1').Hash;client_path=$clientPath;manifest_directory=$manifestDirectory;state_directory=$state;powershell_path=$ps;max_tick_seconds=50;queued_receipt_warning_seconds=600;adapter_kind='CodexQueue';adapter_path=(Join-Path $pkg 'Invoke-CodexQueueAdapter.ps1');adapter_sha256=(Get-FileHash (Join-Path $pkg 'Invoke-CodexQueueAdapter.ps1')).Hash;cli_path=$cli;cli_sha256=(Get-FileHash $cli).Hash;destinations=@($destinations|Sort-Object project_room,task_id)}
    $cfg.package_sha256=Get-LtPackageHash $pkg
    Write-LtJson $configPath $cfg
    $taskAction=New-LtWorkerTaskAction $pkg $configPath 'Paused'
    $trigger=New-ScheduledTaskTrigger -Once -At (Get-Date).AddMinutes(1) -RepetitionInterval (New-TimeSpan -Seconds 60) -RepetitionDuration (New-TimeSpan -Days 3650)
    $principal=New-ScheduledTaskPrincipal -UserId ([Security.Principal.WindowsIdentity]::GetCurrent().Name) -LogonType Interactive -RunLevel Limited
    $settings=New-ScheduledTaskSettingsSet -ExecutionTimeLimit (New-TimeSpan -Seconds 55) -MultipleInstances IgnoreNew -StartWhenAvailable
    Register-ScheduledTask -TaskName $task -Action $taskAction -Trigger $trigger -Principal $principal -Settings $settings -Description '24/7 deterministic Project Room transport worker.' -Force|Out-Null
    Disable-ScheduledTask -TaskName $task|Out-Null
    [pscustomobject]@{release=$release;status='Staged';task=$task;task_enabled=$false;destinations=$cfg.destinations;config_path=$configPath;owner_written=$false}|ConvertTo-Json -Depth 8
    return
}

if(!(Test-Path -LiteralPath $configPath)){throw 'StagedConfigMissing'}
. (Join-Path $pkg 'Common.ps1')
$cfg=Read-LtJson $configPath
if($cfg.release -cne $release -or $cfg.expected_machine -cne $ExpectedMachine -or $cfg.dispatcher_task_id -cne $DispatcherTaskId){throw 'StagedConfigMismatch'}
if((Get-LtPackageHash $pkg) -cne $cfg.package_sha256){throw 'StagedPackageMismatch'}

if($Action -eq 'StartValidation'){
    Assert-LtId $ValidationMessageId
    $record=& $cfg.manager_path -Action Get -QueuePath $queue -MessageId $ValidationMessageId|ConvertFrom-Json
    $synthetic=$record.payload.synthetic_test -is [bool] -and $record.payload.synthetic_test -eq $true -and $record.authorization.business_action_authorized -ne $true -and $record.payload.business_action_performed -ne $true
    $pinned=@($cfg.destinations|Where-Object {$_.project_room -ceq $record.destination.project_room -and $_.task_id -ceq $record.destination.task_id -and $_.machine -ceq $ExpectedMachine})
    if(!$synthetic -or $pinned.Count -ne 1 -or $record.destination.machine -cne $ExpectedMachine -or $record.state -cne 'Queued' -or [int]$record.attempt_count -ne 0 -or [int]$record.max_attempts -ne 1){throw 'ValidationRecordNotSafe'}
    if(-not [string]::IsNullOrWhiteSpace($LegacyAutomationId)){
        $legacyAutomation=Join-Path $env:USERPROFILE ('.codex\automations\'+$LegacyAutomationId+'\automation.toml')
        $legacyActive=(Test-Path -LiteralPath $legacyAutomation) -and (Get-Content -Raw -LiteralPath $legacyAutomation) -notmatch '(?m)^status\s*=\s*"PAUSED"\s*$'
        if($legacyActive -and !(Test-LtActiveEmbeddedFallbackException $ExpectedMachine $LegacyAutomationId ([bool]$AllowActiveEmbeddedFallback))){throw 'LegacyHeartbeatMustBePaused'}
    }
    $cfg|Add-Member validation_message_id $ValidationMessageId -Force
    Write-LtJson $configPath $cfg
    Disable-ScheduledTask -TaskName $legacyTask -ErrorAction SilentlyContinue|Out-Null
    New-Item -ItemType Directory -Path (Split-Path -Parent $ownerPath) -Force|Out-Null
    Write-LtJson $ownerPath @{schema_version=1;owner=$cfg.owner;generation=$cfg.generation;mode='Validation';machine=$ExpectedMachine;sid=$cfg.expected_sid;task_id=$DispatcherTaskId;validation_message_id=$ValidationMessageId;created_at_utc=[DateTime]::UtcNow.ToString('o')}
    $taskAction=New-LtWorkerTaskAction $pkg $configPath 'Validation' $ValidationMessageId
    Set-ScheduledTask -TaskName $task -Action $taskAction|Out-Null
    Enable-ScheduledTask -TaskName $task|Out-Null
    [pscustomobject]@{release=$release;status='ValidationActive';message_id=$ValidationMessageId;task=$task;legacy_assisted_disabled=$true;active_embedded_fallback_guarded=[bool]$legacyActive;production_enabled=$false}|ConvertTo-Json
    return
}

if($Action -eq 'PromoteLive'){
    if([string]::IsNullOrWhiteSpace([string]$cfg.validation_message_id)){throw 'ValidationIdentityMissing'}
    $record=& $cfg.manager_path -Action Get -QueuePath $queue -MessageId $cfg.validation_message_id|ConvertFrom-Json
    if(!(Test-LtCompleted $record) -or [int]$record.attempt_count -ne 1){throw 'ValidationLifecycleIncomplete'}
    $currentManifests=@(Get-ChildItem -LiteralPath $cfg.manifest_directory -Filter '*.json' -File|ForEach-Object{Read-LtJson $_.FullName})
    foreach($destination in @($cfg.destinations)){
        $match=@($currentManifests|Where-Object {$_.project_room -ceq $destination.project_room -and $_.task_id -ceq $destination.task_id -and $_.execution_machine -ceq $ExpectedMachine -and $_.dispatchable -eq $true -and $_.messaging_readiness.status -ceq 'ready'})
        if($match.Count -ne 1){throw ('DestinationNotReadyForLive: '+$destination.project_room)}
    }
    Write-LtJson $ownerPath @{schema_version=1;owner=$cfg.owner;generation=$cfg.generation;mode='Live';machine=$ExpectedMachine;sid=$cfg.expected_sid;task_id=$DispatcherTaskId;validation_message_id=$cfg.validation_message_id;promoted_at_utc=[DateTime]::UtcNow.ToString('o')}
    $taskAction=New-LtWorkerTaskAction $pkg $configPath 'Live'
    Set-ScheduledTask -TaskName $task -Action $taskAction|Out-Null
    Enable-ScheduledTask -TaskName $task|Out-Null
    [pscustomobject]@{release=$release;status='Live';task=$task;schedule='Every 60 seconds, 24/7';destinations=$cfg.destinations;legacy_assisted_disabled=$true}|ConvertTo-Json -Depth 8
    return
}
