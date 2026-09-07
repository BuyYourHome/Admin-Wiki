# One manually authorized synthetic only. This is not a Live-mode switch.
function Get-LtCanaryId { 'prmsg-wve-serialized-worker-canary-20260907-001' }
function ConvertFrom-LtCanaryRecordList([string]$Json) {
    # Windows PowerShell ConvertFrom-Json emits a JSON array as one pipeline object.
    # Enumerate it explicitly before applying per-record destination predicates.
    $parsed=$Json|ConvertFrom-Json -ErrorAction Stop
    foreach($item in $parsed){
        if($item -is [array] -or [string]::IsNullOrWhiteSpace($item.message_id)){throw 'CanaryMalformedRecordList'}
        $item
    }
}
function Get-LtCanaryState { Join-Path $env:LOCALAPPDATA ('BuyYourHome\PRMessaging\low-token\'+(Get-LtCanaryId)) }
function Assert-LtCanaryIdentity {
    if($env:COMPUTERNAME -cne 'WES-VIDEOEDITOR' -or [Security.Principal.WindowsIdentity]::GetCurrent().Name -ine 'WES-VIDEOEDITOR\IRAMa'){throw 'CanaryWindowsIdentityMismatch'}
    $hb=Join-Path $env:USERPROFILE '.codex\automations\pr-messaging-dispatcher-wes-videoeditor\automation.toml'
    if((Get-FileHash -LiteralPath $hb).Hash -ine '0CA185E83670F01538B373E8DADF4DA7DA41E9BCD044A1699277EE71D9A0687C'){throw 'CanaryPausedHeartbeatChanged'}
}
function Assert-LtCanaryRecord($Record,[switch]$ForSubmission) {
    if($Record.message_id -cne (Get-LtCanaryId) -or $Record.dispatch_id -cne (Get-LtCanaryId) -or $Record.destination.project_room -cne 'Quickbooks' -or $Record.destination.task_id -cne '01a05967-9a05-7081-a62e-616b2d8e61fd' -or $Record.destination.machine -cne 'WES-VIDEOEDITOR' -or $Record.source.project_room -cne 'PR Messaging Dispatcher' -or $Record.source.task_id -cne '01a05d0c-8031-7d92-9474-ab2330008ddb' -or $Record.source.machine -cne 'WES-VIDEOEDITOR'){throw 'CanaryExactIdentityRequired'}
    if(!(Get-PrMessageHashEvidence $Record).valid -or $Record.authoritative -ne $true -or $Record.max_attempts -ne 1 -or $Record.authorization.authorized_by -cne 'Wes' -or $Record.authorization.instruction -cne 'authorize one real synthetic worker canary' -or $Record.payload.test_kind -cne 'serialized-worker-one-shot-20260907'){throw 'CanaryAuthorityOrHashMismatch'}
    foreach($value in @($Record.authorization.business_action_authorized,$Record.payload.business_action_authorized,$Record.payload.business_action_performed)){if($value -isnot [bool] -or $value){throw 'CanaryNoBusinessFlagsRequired'}}
    if($Record.payload.synthetic_test -isnot [bool] -or !$Record.payload.synthetic_test){throw 'CanarySyntheticRequired'}
    $created=[DateTimeOffset]::Parse($Record.created_at_utc)
    $expiry=[DateTimeOffset]::Parse($Record.authorization.submission_expires_at_utc)
    if($expiry -le $created -or ($expiry-$created).TotalMinutes -gt 65){throw 'CanaryExpiryInvalid'}
    if($ForSubmission -and [DateTimeOffset]::UtcNow -ge $expiry){throw 'CanarySubmissionExpired'}
}
function Assert-LtCanaryConfig($Config,[string]$Id) {
    Assert-LtCanaryIdentity
    if($Id -cne (Get-LtCanaryId) -or $Config.validation_message_id -cne $Id -or $Config.owner -cne $Id -or $Config.generation -cne 'one-shot-1' -or $Config.dispatcher_task_id -cne '01a05d0c-8031-7d92-9474-ab2330008ddb'){throw 'CanaryConfigIdentityMismatch'}
    if($Config.fixture_root -or $Config.adapter_kind -cne 'Canary' -or $Config.state_directory -cne (Get-LtCanaryState) -or $Config.queue_path -cne '\\WES-VIDEOEDITOR\BYH-PRMessaging$' -or $Config.manager_path -cne 'C:\Codex\Wiki Files\tools\pr-messaging\Manage-ProjectRoomMessage.ps1' -or $Config.adapter_path -cne 'C:\Codex\Wiki Files\tools\pr-messaging\low-token\Invoke-CodexQueueAdapter.ps1' -or $Config.client_path -cne (Join-Path $env:LOCALAPPDATA 'BuyYourHome\PRMessaging\client.json') -or $Config.manifest_directory -cne 'C:\Codex\Wiki Files\config\pr-messaging-manifests'){throw 'CanaryPathsMismatch'}
    Assert-LtUnder $Config.state_directory (Join-Path $env:LOCALAPPDATA 'BuyYourHome\PRMessaging\low-token')
    if($Config.cli_path -cne 'C:\Users\IRAMa\AppData\Local\OpenAI\Codex\bin\1e3e57cdf0634c02\codex.exe' -or $Config.cli_sha256 -ine '56A84DE2B617AF6B95B0C5C5D8AE120D3C2FB69008AB330C7E7DF3945B98B782'){throw 'CanaryCliMismatch'}
    if((Get-LtPackageHash $PSScriptRoot) -cne $Config.package_sha256 -or (Get-FileHash -LiteralPath $Config.manager_path).Hash -ine $Config.manager_sha256){throw 'CanaryReleaseMismatch'}
}
function New-LtCanarySubmissionMarker([string]$Path,$Evidence) {
    # Never remove this marker, including on failure. CreateNew is the final duplicate barrier.
    $stream=[IO.File]::Open($Path,[IO.FileMode]::CreateNew,[IO.FileAccess]::Write,[IO.FileShare]::None)
    try{$bytes=[Text.UTF8Encoding]::new($false).GetBytes(($Evidence|ConvertTo-Json -Depth 10));$stream.Write($bytes,0,$bytes.Length);$stream.Flush($true)}finally{$stream.Dispose()}
}
function Assert-LtCanaryAdapterState($Record,$Journal,$Config,[string]$Attempt) {
    Assert-LtCanaryRecord $Record -ForSubmission
    $a=@($Record.attempts)
    if($Record.payload_hash -cne $Config.payload_hash -or $Record.state -cne 'Delivery Attempted' -or $Record.receipt -or $Record.result -or $a.Count -ne 1 -or $Record.attempt_count -ne 1 -or $a[0].attempt_id -cne $Attempt -or $a[0].outcome -cne 'Pending' -or $a[0].transport_owner -cne $Config.owner -or $a[0].transport_generation -cne $Config.generation){throw 'CanaryAdapterClaimMismatch'}
    $e=@($Journal.entries)
    if($Journal.schema_version -ne 2 -or $Journal.owner -cne $Config.owner -or $Journal.generation -cne $Config.generation -or $e.Count -ne 1 -or $e[0].attempt_id -cne $Attempt -or $e[0].message_id -cne $Record.message_id -or $e[0].phase -cne 'submission_started' -or $e[0].payload_hash -cne $Config.payload_hash){throw 'CanaryAdapterJournalMismatch'}
}
