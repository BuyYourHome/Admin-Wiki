[CmdletBinding()]
param([Parameter(Mandatory=$true)][string]$ConfigPath)
$ErrorActionPreference='Stop'
. "$PSScriptRoot\Common.ps1"
. "$PSScriptRoot\Process.ps1"
$started=[DateTime]::UtcNow
$cfg=Read-LtJson $ConfigPath
$sid=[Security.Principal.WindowsIdentity]::GetCurrent().User.Value
$health=[ordered]@{schema_version=1;release='0.3.0-assisted';mode='Live-Assisted';machine=$env:COMPUTERNAME;sid=$sid;started_at_utc=$started.ToString('o');status='Starting';claims=0;submissions=0;model_requests=0;candidate_count=0;attention=@();reconciled=@();next_tick_at_utc=$started.AddSeconds(60).ToString('o')}
$lock=$null
function Save-State($Value,[string]$Path){Write-LtJson $Path $Value}
try {
    if($cfg.schema_version -ne 1 -or $cfg.release -cne '0.3.0-assisted'){throw 'UnsupportedAssistedRelease'}
    if($env:COMPUTERNAME -cne $cfg.expected_machine -or $sid -cne $cfg.expected_sid){throw 'WorkerIdentityMismatch'}
    if($cfg.allowlist.project_room -cne 'Quickbooks' -or $cfg.allowlist.task_id -ne '01a05967-9a05-7081-a62e-616b2d8e61fd' -or $cfg.allowlist.machine -ne 'WES-VIDEOEDITOR'){throw 'AllowlistMismatch'}
    foreach($pair in @(@($cfg.manager_path,$cfg.manager_sha256),@($cfg.helper_path,$cfg.helper_sha256),@($cfg.adapter_path,$cfg.adapter_sha256))){if(!(Test-Path -LiteralPath $pair[0]) -or (Get-FileHash -LiteralPath $pair[0]).Hash -ine $pair[1]){throw 'PinnedReleaseMismatch'}}
    if(!(Test-Path -LiteralPath $cfg.client_path) -or !(Test-Path -LiteralPath $cfg.manifest_path)){throw 'RegistrationOrManifestMissing'}
    $lock=[IO.File]::Open((Join-Path $cfg.state_directory 'worker.lock'),[IO.FileMode]::OpenOrCreate,[IO.FileAccess]::ReadWrite,[IO.FileShare]::None)
    $records=@((& $cfg.manager_path -Action List -QueuePath $cfg.queue_path | Out-String)|ConvertFrom-Json)
    $client=Read-LtJson $cfg.client_path;$manifest=Read-LtJson $cfg.manifest_path
    if($client.machine -cne $cfg.expected_machine -or $manifest.task_id -cne $cfg.allowlist.task_id -or $manifest.execution_machine -cne $cfg.allowlist.machine -or $manifest.dispatchable -ne $true){throw 'QuickbooksRegistrationOrManifestMismatch'}
    $statePath=Join-Path $cfg.state_directory 'worker-state.json';$state=if(Test-Path -LiteralPath $statePath){Read-LtJson $statePath}else{[pscustomobject]@{schema_version=1;owner=$cfg.owner;entries=@()}}
    if($state.schema_version -ne 1 -or $state.owner -cne $cfg.owner){throw 'WorkerStateMismatch'}
    $active=@($state.entries|Where-Object phase -ne 'closed')
    foreach($entry in $active){$r=@($records|Where-Object message_id -CEQ $entry.message_id);if($r.Count -ne 1){$health.attention+=@{message_id=$entry.message_id;reason='RecordMissingOrDuplicate'};continue};$r=$r[0];if((Get-PrMessageHashEvidence $r).valid -and (Test-LtCompleted $r)){$entry.phase='closed';$entry.outcome='Completed';$health.reconciled+=@{message_id=$entry.message_id;outcome='Completed'};continue};$health.attention+=@{message_id=$entry.message_id;reason='DestinationOutstanding'}}
    Save-State $state $statePath
    $records=@((& $cfg.manager_path -Action List -QueuePath $cfg.queue_path | Out-String)|ConvertFrom-Json)
    $candidates=@($records|Where-Object {$_.destination.project_room -ceq 'Quickbooks' -and $_.destination.task_id -ceq $cfg.allowlist.task_id -and $_.destination.machine -ceq $cfg.allowlist.machine -and $_.state -in @('Queued','Delivery Ambiguous') -and !$_.receipt -and !$_.result -and @($_.attempts|Where-Object outcome -eq 'Pending').Count -eq 0 -and [int]$_.attempt_count -lt [int]$_.max_attempts}|Sort-Object created_at_utc,message_id)
    $health.candidate_count=$candidates.Count
    if($active.Count -gt 0){$health.status='HoldingOutstanding';return}
    if(!$candidates.Count){$health.status='Empty';return}
    $target=$candidates[0]
    $claim=& $cfg.helper_path -ManagerPath $cfg.manager_path -QueuePath $cfg.queue_path -ManifestDirectory (Split-Path -Parent $cfg.manifest_path) -ClientConfigPath $cfg.client_path -ActorTaskId $cfg.dispatcher_task_id -MessageId $target.message_id | ConvertFrom-Json
    if(!$claim.claimed){$health.status='NoClaim';$health.attention+=@{message_id=$target.message_id;reason='HelperDenied'};return}
    $health.claims=1
    $entry=[pscustomobject]@{message_id=$claim.message_id;destination_task_id=$claim.destination_task_id;payload_hash=$claim.payload_hash;attempt_id=$claim.attempt_id;phase='claimed';started_at_utc=$started.ToString('o');queue_message_id=$null;outcome=$null}
    $state.entries=@($state.entries|Where-Object phase -eq 'closed')+$entry;Save-State $state $statePath
    $args=@('-NoProfile','-ExecutionPolicy','Bypass','-File',$cfg.adapter_path,'-LiveConfigPath',$ConfigPath,'-MessageId',$claim.message_id,'-ThreadId',$claim.destination_task_id,'-DispatcherTaskId',$cfg.dispatcher_task_id,'-PayloadHash',$claim.payload_hash,'-CliPath',$cfg.cli_path,'-ExpectedCliHash',$cfg.cli_sha256,'-AttemptId',$claim.attempt_id,'-TimeoutSeconds','10')
    $health.submissions=1;$answer=Invoke-LtProcess $cfg.powershell_path $args 15
    $adapterResult=if($answer.stdout){try{$answer.stdout|ConvertFrom-Json}catch{$null}}else{$null}
    if($adapterResult -and $adapterResult.submitted -eq $true){$entry.phase='submitted';$entry.queue_message_id=$adapterResult.queue_message_id;$entry.outcome='QueuedAwaitingReceipt';$health.status='SubmittedAwaitingReceipt';$health.attention+=@{message_id=$entry.message_id;reason='QueuedAwaitingReceipt'}}else{$entry.phase='unresolved';$entry.outcome='SubmissionUncertain';$health.status='SubmissionUncertain';$health.attention+=@{message_id=$entry.message_id;reason='SubmissionUncertain'}}
    Save-State $state $statePath
}catch{$health.status='Blocked';$health.error=$_.Exception.Message}
finally{$health.completed_at_utc=[DateTime]::UtcNow.ToString('o');$health.elapsed_ms=([DateTime]::UtcNow-$started).TotalMilliseconds;if($lock){$lock.Dispose()};try{Write-LtJson (Join-Path $cfg.state_directory 'health.json') $health}catch{};$health|ConvertTo-Json -Depth 12}
