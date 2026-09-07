[CmdletBinding()]
param([Parameter(Mandatory=$true)][ValidateSet('Prepare','Tick','Inspect')][string]$Action)
$ErrorActionPreference='Stop'
[Console]::OutputEncoding=[Text.UTF8Encoding]::new($false)
. "$PSScriptRoot\Common.ps1"
. "$PSScriptRoot\Canary.Guards.ps1"
Assert-LtCanaryIdentity
$id=Get-LtCanaryId
$state=Get-LtCanaryState
$configPath=Join-Path $state 'config.json'
$manager='C:\Codex\Wiki Files\tools\pr-messaging\Manage-ProjectRoomMessage.ps1'
$queue='\\WES-VIDEOEDITOR\BYH-PRMessaging$'
$dispatcher='01a05d0c-8031-7d92-9474-ab2330008ddb'
$destination='01a05967-9a05-7081-a62e-616b2d8e61fd'
function Get-Fingerprints {
    @(Get-ChildItem -LiteralPath (Join-Path $queue 'records') -Filter '*.json' -File | Sort-Object Name | ForEach-Object {[pscustomobject]@{name=$_.Name;sha256=(Get-FileHash -LiteralPath $_.FullName).Hash}})
}
if($Action -eq 'Prepare'){
    if(Test-Path -LiteralPath $state){throw 'CanaryStateAlreadyExistsDoNotRecreate'}
    $records=@(ConvertFrom-LtCanaryRecordList (& $manager -Action List))
    if(@($records|Where-Object message_id -CEQ $id).Count){throw 'CanaryIdAlreadyExistsDoNotReuse'}
    $holds=@($records|Where-Object {$_.destination.task_id -ceq $destination -and (Test-LtDestinationOutstanding $_)})
    if($holds.Count){throw ('CanaryDestinationOutstanding: '+($holds.message_id -join ','))}
    $client=Join-Path $env:LOCALAPPDATA 'BuyYourHome\PRMessaging\client.json'
    $manifestDirectory='C:\Codex\Wiki Files\config\pr-messaging-manifests'
    $before=Get-Fingerprints
    New-Item -ItemType Directory -Path $state -ErrorAction Stop|Out-Null
    Write-LtJson (Join-Path $state 'before-record-fingerprints.json') $before
    $authorization=[ordered]@{authorized_by='Wes';instruction='authorize one real synthetic worker canary';authorizing_task_id=$dispatcher;business_action_authorized=$false;submission_expires_at_utc=[DateTime]::UtcNow.AddMinutes(60).ToString('o');restrictions='Exactly one real worker/CLI submission to existing Quickbooks task. No production, business action, retry, heartbeat resume or recurring installation.'}
    $payload=[ordered]@{synthetic_test=$true;test_kind='serialized-worker-one-shot-20260907';business_action_authorized=$false;business_action_performed=$false;execution_instructions=@(
        'This is a transport-only synthetic, not QuickBooks or business work. Only this record is in scope. Do not open a browser, mailbox or QuickBooks; do not claim other records, send notifications, change automations or edit wiki files.',
        'Verify authoritative immutable hash, your exact registered Quickbooks task identity and synthetic no-business authorization. Deduplicate by message ID and hash; if a receipt/result already exists, reconcile without executing again.',
        'Use the documented PowerShell canonical manager wrapper under the normal Windows identity. Write your own exact Accepted receipt before any test work, then StartProcessing.',
        'Make one permitted read-only Codex desktop read_thread call for your own existing task. Record actual current recipient turn ID when available, whether the read_thread tool was callable and succeeded, and any exact tool error. Do not substitute browser or business actions.',
        'Write exactly one canonical Completed final result if this synthetic probe succeeds; otherwise write Blocked with the exact failure. Result data must include message_id, payload_hash, recipient_task_id, recipient_turn_id (or explicit unavailability), synthetic_test:true, execution_count:1, business_action_authorized:false, business_action_performed:false, desktop_tool_name, desktop_tool_available, desktop_tool_probe_succeeded and probe evidence. Do not send a separate return notification; canonical result is the return.'
    )}
    $r=(& $manager -Action Send -MessageId $id -DispatchId $id -MessageType status -SourceProjectRoom 'PR Messaging Dispatcher' -SourceTaskId $dispatcher -SourceMachine 'WES-VIDEOEDITOR' -DestinationProjectRoom 'Quickbooks' -DestinationTaskId $destination -DestinationMachine 'WES-VIDEOEDITOR' -AuthorizationJson ($authorization|ConvertTo-Json -Depth 10 -Compress) -PayloadJson ($payload|ConvertTo-Json -Depth 10 -Compress) -MaxAttempts 1 | ConvertFrom-Json)
    Assert-LtCanaryRecord $r -ForSubmission
    $manifests=@(Get-ChildItem -LiteralPath $manifestDirectory -Filter '*.json' -File|ForEach-Object{Read-LtJson $_.FullName})
    $reason=Test-LtRecord $r (Read-LtJson $client) $manifests $env:COMPUTERNAME 'Shadow' $id $records
    if($reason -cne 'Eligible'){throw ('CanaryPreparedButNotEligible: '+$reason)}
    $adapter=Join-Path $PSScriptRoot 'Invoke-CodexQueueAdapter.ps1'
    $cfg=[ordered]@{schema_version=1;release='0.2.0';expected_machine=$env:COMPUTERNAME;expected_sid=[Security.Principal.WindowsIdentity]::GetCurrent().User.Value;owner=$id;generation='one-shot-1';dispatcher_task_id=$dispatcher;fixture_root=$null;queue_path=$queue;manager_path=$manager;manager_sha256=(Get-FileHash -LiteralPath $manager).Hash;client_path=$client;manifest_directory=$manifestDirectory;state_directory=$state;powershell_path=(Get-Command powershell.exe).Source;max_tick_seconds=55;queued_receipt_warning_seconds=120;adapter_kind='Canary';adapter_path=$adapter;adapter_sha256=(Get-FileHash -LiteralPath $adapter).Hash;validation_message_id=$id;payload_hash=$r.payload_hash;package_sha256=(Get-LtPackageHash $PSScriptRoot);cli_path='C:\Users\IRAMa\AppData\Local\OpenAI\Codex\bin\1e3e57cdf0634c02\codex.exe';cli_sha256='56A84DE2B617AF6B95B0C5C5D8AE120D3C2FB69008AB330C7E7DF3945B98B782'}
    Assert-LtCanaryConfig ([pscustomobject]$cfg) $id
    Write-LtJson $configPath $cfg
    [pscustomobject]@{status='PreparedNotSubmitted';message_id=$id;payload_hash=$r.payload_hash;expires_at_utc=$authorization.submission_expires_at_utc;config_path=$configPath;package_sha256=$cfg.package_sha256;manager_sha256=$cfg.manager_sha256}|ConvertTo-Json
    return
}
if($Action -eq 'Tick'){
    & "$PSScriptRoot\Invoke-LowTokenWorker.ps1" -ConfigPath $configPath -Mode Canary -MessageId $id
    return
}
$record=(& $manager -Action Get -MessageId $id|ConvertFrom-Json)
Assert-LtCanaryRecord $record
$before=Read-LtJson (Join-Path $state 'before-record-fingerprints.json')
$after=Get-Fingerprints
$changed=@(foreach($b in $before){$a=@($after|Where-Object name -CEQ $b.name);if($a.Count -ne 1 -or $a[0].sha256 -cne $b.sha256){$b.name}})
$added=@($after|Where-Object {$_.name -cnotin @($before.name)}|ForEach-Object name)
$evidence=[ordered]@{checked_at_utc=[DateTime]::UtcNow.ToString('o');record=$record;terminal_verified=(Test-PrMessageTerminal $record);changed_preexisting_records=$changed;added_records=$added;submission_marker_exists=(Test-Path -LiteralPath (Join-Path $state 'submission-once.json'))}
foreach($name in @('journal','health','cli-result','adapter-process-result')){if(Test-Path -LiteralPath (Join-Path $state ($name+'.json'))){$evidence[$name]=Read-LtJson (Join-Path $state ($name+'.json'))}}
Write-LtJson (Join-Path $state 'inspection.json') $evidence
$evidence|ConvertTo-Json -Depth 30
