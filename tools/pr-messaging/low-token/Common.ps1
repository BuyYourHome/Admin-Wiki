# Development release 0.2.0. No production activation in this package.
. "$PSScriptRoot\..\Message-Integrity.ps1"
function Get-LtSha256([string]$Text) {
    $sha = [Security.Cryptography.SHA256]::Create()
    try { ([BitConverter]::ToString($sha.ComputeHash([Text.Encoding]::UTF8.GetBytes($Text)))).Replace('-', '').ToLowerInvariant() }
    finally { $sha.Dispose() }
}
function Get-LtPayloadHash($Record) {
    $c = [ordered]@{message_type=[string]$Record.message_type;parent_message_id=[string]$Record.parent_message_id;source=$Record.source;destination=$Record.destination;authorization=$Record.authorization;references=$Record.references;payload=$Record.payload}
    Get-LtSha256 ($c | ConvertTo-Json -Depth 30 -Compress)
}
function Get-LtVersion($Record) { Get-LtSha256 ($Record | ConvertTo-Json -Depth 30 -Compress) }
function Read-LtJson([string]$Path) { Get-Content -LiteralPath $Path -Raw -Encoding UTF8 -ErrorAction Stop | ConvertFrom-Json -ErrorAction Stop }
function Write-LtJson([string]$Path, $Value) {
    $dir = Split-Path -Parent $Path
    if (!(Test-Path -LiteralPath $dir)) { New-Item -ItemType Directory -Path $dir -Force | Out-Null }
    $tmp = Join-Path $dir ('.' + [guid]::NewGuid().ToString('N') + '.tmp')
    $bytes = [Text.UTF8Encoding]::new($false).GetBytes(($Value | ConvertTo-Json -Depth 30))
    $stream = [IO.File]::Open($tmp, [IO.FileMode]::CreateNew, [IO.FileAccess]::Write, [IO.FileShare]::None)
    try { $stream.Write($bytes,0,$bytes.Length); $stream.Flush($true) } finally { $stream.Dispose() }
    if (Test-Path -LiteralPath $Path) { [IO.File]::Replace($tmp,$Path,[NullString]::Value) } else { [IO.File]::Move($tmp,$Path) }
}
function Assert-LtId([string]$Id) {
    if ([string]::IsNullOrWhiteSpace($Id) -or $Id -cnotmatch '^[A-Za-z0-9][A-Za-z0-9._-]{2,127}$') { throw 'InvalidOrBlankMessageId' }
}
function Assert-LtUuid([string]$Id) {
    if ($Id -cnotmatch '^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$') { throw 'InvalidTaskUuid' }
}
function Assert-LtUnder([string]$Path,[string]$Root) {
    $p = [IO.Path]::GetFullPath($Path); $r = [IO.Path]::GetFullPath($Root).TrimEnd('\','/') + [IO.Path]::DirectorySeparatorChar
    if (!$p.StartsWith($r,[StringComparison]::OrdinalIgnoreCase)) { throw 'PathOutsideFixture' }
    $walk=$p
    while($walk -and $walk.Length -ge $r.TrimEnd('\','/').Length){
        if(Test-Path -LiteralPath $walk){if((Get-Item -LiteralPath $walk -Force).Attributes -band [IO.FileAttributes]::ReparsePoint){throw 'ReparsePointForbidden'}}
        $walk=Split-Path -Parent $walk
    }
}
function Get-LtPackageHash([string]$Directory) {
    $parts=@(Get-ChildItem -LiteralPath $Directory -Filter '*.ps1' -File|Sort-Object Name|ForEach-Object{$_.Name+':'+(Get-FileHash -LiteralPath $_.FullName).Hash})
    $parts+=@('Message-Integrity.ps1:'+(Get-FileHash -LiteralPath (Join-Path $Directory '..\Message-Integrity.ps1')).Hash)
    Get-LtSha256 ($parts -join "`n")
}
function Assert-LtFixture([string]$Root,[string[]]$Paths) {
    if ([string]::IsNullOrWhiteSpace($Root) -or $Root.StartsWith('\\')) { throw 'FixtureRootRequired' }
    $rootFull = [IO.Path]::GetFullPath($Root)
    Assert-LtUnder $rootFull ([IO.Path]::GetTempPath())
    if (!(Test-Path -LiteralPath (Join-Path $rootFull '.lowtoken-fixture'))) { throw 'FixtureMarkerMissing' }
    foreach ($p in $Paths) { if (![string]::IsNullOrWhiteSpace($p)) { Assert-LtUnder $p $rootFull } }
}
function Get-LtConfigHash($Client,$Manifests) {
    Get-LtSha256 (([ordered]@{client=$Client;manifests=@($Manifests | Sort-Object project_room)} | ConvertTo-Json -Depth 30 -Compress))
}
function Test-LtRecord($Record,$Client,$Manifests,[string]$Machine,[string]$Mode,[string]$MessageId,$AllRecords=@()) {
    if (!$Record) { return 'MissingTarget' }
    if ($MessageId -and $Record.message_id -cne $MessageId) { return 'WrongTarget' }
    if (!(Get-PrMessageHashEvidence $Record).valid) { return 'HashMismatch' }
    try { Assert-LtId $Record.message_id; Assert-LtUuid $Record.destination.task_id; Assert-LtUuid $Record.source.task_id } catch { return 'InvalidIdentity' }
    if ($Record.authoritative -ne $true) { return 'NotAuthoritative' }
    if ($Record.destination.machine -cne $Machine -or $Client.machine -cne $Machine) { return 'MachineMismatch' }
    if ($Record.receipt -or $Record.result) { return 'ReceiptOrResult' }
    if ($Record.state -notin @('Queued','Delivery Ambiguous')) { return 'StateNotEligible' }
    if (@($Record.attempts).Count -ne [int]$Record.attempt_count) { return 'AttemptCountMismatch' }
    if (@($Record.attempts | Where-Object outcome -eq 'Pending').Count) { return 'PendingAttempt' }
    if ([int]$Record.attempt_count -ge [int]$Record.max_attempts -or [int]$Record.max_attempts -lt 1) { return 'AttemptsExhausted' }
    if (@($Record.attempts | Where-Object outcome -ne 'NotDelivered').Count) { return 'SubmissionUnresolved' }
    if ([string]::IsNullOrWhiteSpace($Record.authorization.authorized_by) -or [string]::IsNullOrWhiteSpace($Record.authorization.instruction) -or [string]::IsNullOrWhiteSpace($Record.source.project_room) -or [string]::IsNullOrWhiteSpace($Record.source.machine)) { return 'AuthorizationMissing' }
    $m = @($Manifests | Where-Object project_room -CEQ $Record.destination.project_room)
    if ($m.Count -ne 1) { return 'ManifestMissingOrDuplicate' }
    $m = $m[0]
    if ($m.task_id -cne $Record.destination.task_id) { return 'TaskMismatch' }
    if ($m.execution_machine -cne $Machine) { return 'ManifestMachineMismatch' }
    if ($Record.message_type -cnotin @($m.accepted_message_types)) { return 'MessageTypeNotAccepted' }
    $regs = @($Client.registrations | Where-Object { $_.project_room -ceq $Record.destination.project_room -and $_.task_id -ceq $Record.destination.task_id })
    if ($regs.Count -ne 1) { return 'RegistrationMismatch' }
    $synthetic = ($Record.payload.synthetic_test -is [bool] -and $Record.payload.synthetic_test -eq $true -and $Record.authorization.business_action_authorized -is [bool] -and $Record.authorization.business_action_authorized -eq $false -and $Record.payload.business_action_authorized -is [bool] -and $Record.payload.business_action_authorized -eq $false -and $Record.payload.business_action_performed -is [bool] -and $Record.payload.business_action_performed -eq $false)
    if ($Mode -eq 'Validation') {
        if ([string]::IsNullOrWhiteSpace($MessageId)) { return 'ValidationFilterRequired' }
        if (!$synthetic) { return 'NotExplicitSynthetic' }
        if ($Record.authorization.authorized_by -cne 'Wes') { return 'ValidationAuthorizationMissing' }
        if ($m.messaging_readiness.validation_message_id -cne $MessageId) { return 'ValidationManifestMismatch' }
        if ([int]$Record.max_attempts -ne 1) { return 'ValidationBudgetMustBeOne' }
    }
    $exception = $synthetic -and $m.messaging_readiness.status -ceq 'validation_ready' -and $m.messaging_readiness.validation_message_id -ceq $Record.message_id
    if ($m.dispatchable -ne $true -and !$exception) { return 'NotDispatchable' }
    foreach ($other in @($AllRecords)) {
        if ($other.message_id -cne $Record.message_id -and $other.destination.task_id -ceq $Record.destination.task_id -and (Test-LtDestinationOutstanding $other)) { return 'DestinationOutstanding' }
    }
    if ($Record.attempt_count -gt 0) {
        $last = @($Record.attempts)[-1]
        if (!$last.completed_at_utc) { return 'AttemptMissingCompletion' }
        $delay = if ($Record.attempt_count -eq 1) { 300 } else { 900 }
        if (([DateTime]::UtcNow - [DateTime]::Parse($last.completed_at_utc).ToUniversalTime()).TotalSeconds -lt $delay) { return 'RetryDelay' }
    }
    return 'Eligible'
}
function Test-LtReceipt($Record) {
    $r=$Record.receipt
    return ($null -ne $r -and $r.project_room -ceq $Record.destination.project_room -and $r.task_id -ceq $Record.destination.task_id -and $r.machine -ceq $Record.destination.machine)
}
function Test-LtCompleted($Record) {
    # Acceptance proves delivery, not completion. Only verified completion releases a slot.
    if (!(Test-LtReceipt $Record) -or $Record.state -cne 'Completed' -or $Record.result.state -cne 'Completed' -or $Record.result.machine -cne $Record.destination.machine) { return $false }
    try {
        $accepted=[DateTimeOffset]::Parse($Record.receipt.accepted_at_utc)
        $completed=[DateTimeOffset]::Parse($Record.result.completed_at_utc)
        return ($completed -ge $accepted)
    } catch { return $false }
}
function Test-LtDestinationOutstanding($Record) {
    $attempts=@($Record.attempts)
    if (!$attempts.Count -and !$Record.receipt -and !$Record.result -and $Record.state -eq 'Queued') { return $false }
    if (!(Get-PrMessageHashEvidence $Record).valid) { return $true }
    if ((Test-PrMessageTerminal $Record) -or (Test-PrAdministrativeClosure $Record)) { return $false }
    if (!$Record.receipt -and !$Record.result -and $Record.state -eq 'Queued' -and $attempts.Count -gt 0 -and !@($attempts | Where-Object outcome -ne 'NotDelivered').Count) { return $false }
    return $true
}
function Test-LtQueueAcknowledgment($Response,[string]$MessageId,[string]$ThreadId,[string]$AttemptId) {
    if ($Response.timed_out -or $Response.exit_code -ne 0) { return $false }
    try {
        $a=$Response.stdout | ConvertFrom-Json -ErrorAction Stop
        Assert-LtUuid $a.queue_message_id
        return ($a.submitted -is [bool] -and $a.submitted -eq $true -and $a.accepted -is [bool] -and $a.accepted -eq $false -and $a.message_id -ceq $MessageId -and $a.thread_id -ceq $ThreadId -and $a.attempt_id -ceq $AttemptId)
    } catch { return $false }
}
