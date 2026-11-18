$script:states = @('awaiting_approval', 'approved_awaiting_send', 'technical_blocker', 'submission_uncertain', 'declined', 'sent_verified', 'superseded')
$script:transitions = @{
    awaiting_approval = @('approved_awaiting_send', 'declined', 'technical_blocker', 'submission_uncertain', 'sent_verified', 'superseded')
    approved_awaiting_send = @('technical_blocker', 'submission_uncertain', 'sent_verified', 'superseded')
    technical_blocker = @('awaiting_approval', 'approved_awaiting_send', 'submission_uncertain', 'sent_verified', 'declined', 'superseded')
    submission_uncertain = @('technical_blocker', 'awaiting_approval', 'approved_awaiting_send', 'sent_verified', 'superseded')
    declined = @()
    sent_verified = @()
    superseded = @()
}

function Get-EmailApprovalDirectory {
    param([string]$QueuePath)
    Join-Path $QueuePath 'health\email-approval-attention'
}

function Assert-EmailApprovalSnapshot {
    param($Snapshot, [string]$ApprovalId)
    if ($Snapshot.schema_version -ne 1 -or $Snapshot.approval_id -cne $ApprovalId -or
        $ApprovalId -cnotmatch '^[0-9a-f]{32}$' -or $Snapshot.package_hash -cnotmatch '^[0-9a-f]{64}$' -or
        $Snapshot.state -cnotin $script:states -or !$Snapshot.updated_at_utc) {
        throw 'Invalid email approval snapshot.'
    }
    if ($Snapshot.central_message_id -or $Snapshot.central_payload_hash) {
        if ($Snapshot.central_message_id -notmatch '^[A-Za-z0-9][A-Za-z0-9._-]{2,127}$' -or
            $Snapshot.central_payload_hash -cnotmatch '^[0-9a-f]{64}$') {
            throw 'Invalid email approval central correlation.'
        }
    }
    $null = [DateTimeOffset]$Snapshot.updated_at_utc
}

function Get-EmailApprovalSnapshot {
    param([string]$QueuePath)
    $directory = Get-EmailApprovalDirectory $QueuePath
    if (!(Test-Path -LiteralPath $directory -PathType Container -ErrorAction Stop)) { return }
    foreach ($file in Get-ChildItem -LiteralPath $directory -Filter '*.json' -File -ErrorAction Stop) {
        $snapshot = Get-Content -LiteralPath $file.FullName -Encoding UTF8 -Raw -ErrorAction Stop | ConvertFrom-Json -ErrorAction Stop
        Assert-EmailApprovalSnapshot $snapshot $file.BaseName
        $snapshot
    }
}

function Set-EmailApprovalSnapshot {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)][string]$QueuePath,
        [Parameter(Mandatory)][guid]$ApprovalId,
        [Parameter(Mandatory)][ValidatePattern('^[0-9a-fA-F]{64}$')][string]$PackageHash,
        [Parameter(Mandatory)][ValidateSet('awaiting_approval', 'approved_awaiting_send', 'technical_blocker', 'submission_uncertain', 'declined', 'sent_verified', 'superseded')][string]$State,
        [string]$CentralMessageId,
        [string]$CentralPayloadHash
    )

    $id = $ApprovalId.ToString('N')
    if ($ApprovalId -eq [guid]::Empty) { throw 'An email approval ID is required.' }
    $snapshot = [ordered]@{
        schema_version = 1; approval_id = $id; package_hash = $PackageHash.ToLowerInvariant()
        central_message_id = $CentralMessageId; central_payload_hash = ([string]$CentralPayloadHash).ToLowerInvariant()
        state = $State.ToLowerInvariant(); updated_at_utc = [DateTime]::UtcNow.ToString('o')
    }
    Assert-EmailApprovalSnapshot ([pscustomobject]$snapshot) $id
    $directory = Get-EmailApprovalDirectory $QueuePath
    # Do not create a substitute store if the approved shared health root is unavailable.
    if (!(Test-Path -LiteralPath (Join-Path $QueuePath 'health') -PathType Container -ErrorAction Stop)) { throw 'Email approval attention store is unavailable.' }
    $null = [IO.Directory]::CreateDirectory($directory)
    $path = Join-Path $directory "$id.json"
    $lock = [IO.File]::Open((Join-Path $directory "$id.lock"), 'OpenOrCreate', 'Write', 'None')
    $temp = Join-Path $directory "$id.$([guid]::NewGuid().ToString('N')).tmp"
    try {
        $exists = [IO.File]::Exists($path)
        if ($exists) {
            $previous = Get-Content -LiteralPath $path -Encoding UTF8 -Raw -ErrorAction Stop | ConvertFrom-Json -ErrorAction Stop
            Assert-EmailApprovalSnapshot $previous $id
            if ($previous.package_hash -cne $snapshot.package_hash -or [string]$previous.central_message_id -cne $snapshot.central_message_id -or
                [string]$previous.central_payload_hash -cne $snapshot.central_payload_hash) {
                throw 'Email approval ID belongs to a different immutable request.'
            }
            if ($previous.state -ceq $snapshot.state) { return $previous }
            if ($snapshot.state -cnotin $script:transitions[$previous.state]) { throw 'Invalid email approval status transition.' }
        } elseif ($snapshot.state -cnotin @('awaiting_approval', 'technical_blocker', 'submission_uncertain')) {
            throw 'Record a pending decision or blocker before publishing an email approval outcome.'
        }
        [IO.File]::WriteAllText($temp, ($snapshot | ConvertTo-Json -Compress), [Text.UTF8Encoding]::new($false))
        if ($exists) { [IO.File]::Replace($temp, $path, [NullString]::Value) } else { [IO.File]::Move($temp, $path) }
        [pscustomobject]$snapshot
    } finally {
        $lock.Dispose()
        if ([IO.File]::Exists($temp)) { [IO.File]::Delete($temp) }
    }
}

Export-ModuleMember -Function Get-EmailApprovalDirectory, Get-EmailApprovalSnapshot, Set-EmailApprovalSnapshot
