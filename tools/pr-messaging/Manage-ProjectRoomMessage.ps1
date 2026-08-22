[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [ValidateSet("Initialize", "Send", "Get", "List", "StartAttempt", "MarkAttempt", "Accept", "StartProcessing", "Update", "Complete", "Block", "NeedsWes", "Reject", "SyncSpool", "Health")]
    [string]$Action,

    [string]$QueuePath = "\\WES-VIDEOEDITOR\BYH-PRMessaging$",
    [string]$SpoolPath = (Join-Path $env:LOCALAPPDATA "BuyYourHome\PRMessaging\spool"),
    [string]$MessageId,
    [string]$DispatchId,
    [ValidateSet("request", "question", "status", "decision", "result", "improvement")]
    [string]$MessageType,
    [string]$ParentMessageId,
    [string]$SourceProjectRoom,
    [string]$SourceTaskId,
    [string]$DestinationProjectRoom,
    [string]$DestinationTaskId,
    [string]$SourceMachine = $env:COMPUTERNAME,
    [string]$DestinationMachine,
    [string]$AuthorizationJson = "{}",
    [string]$ReferencesJson = "[]",
    [string]$PayloadJson = "{}",
    [string]$ResultJson = "{}",
    [string]$ActorProjectRoom,
    [string]$ActorTaskId,
    [string]$Detail,
    [string]$AttemptId,
    [ValidateSet("DeliveryAmbiguous", "NotDelivered", "Failed")]
    [string]$AttemptOutcome,
    [string]$State,
    [int]$MaxAttempts = 3,
    [switch]$ForceOffline
)

$ErrorActionPreference = "Stop"

function Get-UtcTimestamp { [DateTime]::UtcNow.ToString("o") }

function ConvertFrom-RequiredJson {
    param([string]$Json, [string]$Name)
    try { return $Json | ConvertFrom-Json }
    catch { throw "$Name must be valid JSON: $($_.Exception.Message)" }
}

function Assert-MessageId {
    param([string]$Id)
    if ([string]::IsNullOrWhiteSpace($Id) -or $Id -notmatch '^[A-Za-z0-9][A-Za-z0-9._-]{2,127}$') {
        throw "MessageId is required and must use only letters, numbers, dots, underscores, or hyphens."
    }
}

function Get-RecordPath {
    param([string]$Root, [string]$Id)
    Assert-MessageId -Id $Id
    Join-Path (Join-Path $Root "records") "$Id.json"
}

function Get-Sha256 {
    param([string]$Text)
    $sha = [Security.Cryptography.SHA256]::Create()
    try {
        $bytes = [Text.Encoding]::UTF8.GetBytes($Text)
        ([BitConverter]::ToString($sha.ComputeHash($bytes))).Replace("-", "").ToLowerInvariant()
    }
    finally { $sha.Dispose() }
}

function Get-PayloadHash {
    param($Source, $Destination, $Authorization, $References, $Payload, [string]$Type, [string]$ParentId)
    $canonical = [ordered]@{
        message_type = $Type
        parent_message_id = $ParentId
        source = $Source
        destination = $Destination
        authorization = $Authorization
        references = $References
        payload = $Payload
    } | ConvertTo-Json -Depth 30 -Compress
    Get-Sha256 -Text $canonical
}

function Read-Record {
    param([string]$Path)
    if (-not (Test-Path -LiteralPath $Path)) { throw "Message record not found: $Path" }
    Get-Content -Raw -LiteralPath $Path | ConvertFrom-Json
}

function Write-JsonAtomic {
    param([string]$Path, $Value)
    $directory = Split-Path -Parent $Path
    New-Item -ItemType Directory -Path $directory -Force | Out-Null
    $tempPath = Join-Path $directory ("." + [IO.Path]::GetFileName($Path) + "." + [guid]::NewGuid().ToString("N") + ".tmp")
    $Value | ConvertTo-Json -Depth 30 | Set-Content -LiteralPath $tempPath -Encoding UTF8
    Move-Item -LiteralPath $tempPath -Destination $Path -Force
}

function Invoke-WithQueueLock {
    param([scriptblock]$Operation)
    if (-not (Test-Path -LiteralPath $QueuePath)) { throw "Central PR messaging host is unavailable: $QueuePath" }
    $lockPath = Join-Path $QueuePath ".queue.lock"
    $deadline = [DateTime]::UtcNow.AddSeconds(15)
    $stream = $null
    while ($null -eq $stream -and [DateTime]::UtcNow -lt $deadline) {
        try {
            $stream = [IO.File]::Open($lockPath, [IO.FileMode]::OpenOrCreate, [IO.FileAccess]::ReadWrite, [IO.FileShare]::None)
        }
        catch [IO.IOException] { Start-Sleep -Milliseconds 200 }
    }
    if ($null -eq $stream) { throw "Timed out waiting for the cross-machine PR messaging lock." }
    try { & $Operation }
    finally { $stream.Dispose() }
}

function Add-Event {
    param($Record, [string]$Event, [string]$EventDetail, [string]$ProjectRoom, [string]$TaskId)
    $events = @($Record.events)
    $events += [pscustomobject][ordered]@{
        at_utc = Get-UtcTimestamp
        event = $Event
        detail = if ([string]::IsNullOrWhiteSpace($EventDetail)) { $null } else { $EventDetail }
        actor = [pscustomobject][ordered]@{ project_room = $ProjectRoom; task_id = $TaskId; machine = $env:COMPUTERNAME }
    }
    $Record.events = $events
    $Record.updated_at_utc = Get-UtcTimestamp
}

function Assert-DestinationActor {
    param($Record)
    if (-not [string]::IsNullOrWhiteSpace($ActorProjectRoom) -and $ActorProjectRoom -ne $Record.destination.project_room) {
        throw "ActorProjectRoom does not match the destination Project Room."
    }
    if (-not [string]::IsNullOrWhiteSpace($ActorTaskId) -and $ActorTaskId -ne $Record.destination.task_id) {
        throw "ActorTaskId does not match the destination task."
    }
}

function New-MessageRecord {
    $authorization = ConvertFrom-RequiredJson -Json $AuthorizationJson -Name "AuthorizationJson"
    $references = ConvertFrom-RequiredJson -Json $ReferencesJson -Name "ReferencesJson"
    $payload = ConvertFrom-RequiredJson -Json $PayloadJson -Name "PayloadJson"
    if ($null -eq $MessageType) { throw "MessageType is required for Send." }
    foreach ($required in @($SourceProjectRoom, $SourceTaskId, $DestinationProjectRoom, $DestinationTaskId)) {
        if ([string]::IsNullOrWhiteSpace($required)) { throw "Source and destination Project Room/task fields are required for Send." }
    }
    if ($MaxAttempts -lt 1) { throw "MaxAttempts must be at least 1." }
    $source = [pscustomobject][ordered]@{ project_room = $SourceProjectRoom; task_id = $SourceTaskId; machine = $SourceMachine }
    $destination = [pscustomobject][ordered]@{ project_room = $DestinationProjectRoom; task_id = $DestinationTaskId; machine = if ([string]::IsNullOrWhiteSpace($DestinationMachine)) { $null } else { $DestinationMachine } }
    $now = Get-UtcTimestamp
    [pscustomobject][ordered]@{
        schema_version = 1
        message_id = $MessageId
        dispatch_id = if ([string]::IsNullOrWhiteSpace($DispatchId)) { $null } else { $DispatchId }
        message_type = $MessageType
        parent_message_id = if ([string]::IsNullOrWhiteSpace($ParentMessageId)) { $null } else { $ParentMessageId }
        source = $source
        destination = $destination
        authorization = $authorization
        references = @($references)
        payload = $payload
        payload_hash = Get-PayloadHash -Source $source -Destination $destination -Authorization $authorization -References @($references) -Payload $payload -Type $MessageType -ParentId $ParentMessageId
        state = "Queued"
        authoritative = $true
        created_at_utc = $now
        updated_at_utc = $now
        max_attempts = $MaxAttempts
        attempt_count = 0
        attempts = @()
        status_updates = @()
        receipt = $null
        result = $null
        events = @([pscustomobject][ordered]@{
            at_utc = $now
            event = "Created"
            detail = "Durable message created before task notification."
            actor = $source
        })
    }
}

function Write-CentralMessage {
    param($Record)
    Invoke-WithQueueLock {
        $path = Get-RecordPath -Root $QueuePath -Id $Record.message_id
        if (Test-Path -LiteralPath $path) {
            $existing = Read-Record -Path $path
            if ($existing.payload_hash -ne $Record.payload_hash) { throw "MessageId already exists with different immutable content: $($Record.message_id)" }
            $existing
            return
        }
        $Record.state = "Queued"
        $Record.authoritative = $true
        Write-JsonAtomic -Path $path -Value $Record
        $Record
    }
}

if ($Action -eq "Initialize") {
    New-Item -ItemType Directory -Path (Join-Path $QueuePath "records") -Force | Out-Null
    New-Item -ItemType Directory -Path (Join-Path $QueuePath "health") -Force | Out-Null
    [pscustomobject]@{ result = "Initialized"; queue_path = $QueuePath; machine = $env:COMPUTERNAME } | ConvertTo-Json
    return
}

if ($Action -eq "Send") {
    Assert-MessageId -Id $MessageId
    $record = New-MessageRecord
    if (-not $ForceOffline -and (Test-Path -LiteralPath $QueuePath)) {
        Write-CentralMessage -Record $record | ConvertTo-Json -Depth 30
        return
    }
    New-Item -ItemType Directory -Path $SpoolPath -Force | Out-Null
    $record.state = "Pending Host"
    $record.authoritative = $false
    Add-Event -Record $record -Event "Spooled" -EventDetail "Central host unavailable; message is not delivered." -ProjectRoom $SourceProjectRoom -TaskId $SourceTaskId
    $spoolRecordPath = Join-Path $SpoolPath "$MessageId.json"
    if (Test-Path -LiteralPath $spoolRecordPath) {
        $existing = Read-Record -Path $spoolRecordPath
        if ($existing.payload_hash -ne $record.payload_hash) { throw "Spool already contains MessageId with different content: $MessageId" }
        $existing | ConvertTo-Json -Depth 30
        return
    }
    Write-JsonAtomic -Path $spoolRecordPath -Value $record
    $record | ConvertTo-Json -Depth 30
    return
}

if ($Action -eq "SyncSpool") {
    if (-not (Test-Path -LiteralPath $QueuePath)) { throw "Central PR messaging host is unavailable: $QueuePath" }
    New-Item -ItemType Directory -Path $SpoolPath -Force | Out-Null
    $synced = @()
    Get-ChildItem -LiteralPath $SpoolPath -Filter "*.json" -File -ErrorAction SilentlyContinue | ForEach-Object {
        $spooled = Read-Record -Path $_.FullName
        $central = Write-CentralMessage -Record $spooled
        if ($central.payload_hash -ne $spooled.payload_hash) { throw "Central hash mismatch for $($spooled.message_id)." }
        Remove-Item -LiteralPath $_.FullName -Force
        $synced += $spooled.message_id
    }
    [pscustomobject]@{ result = "Synced"; count = $synced.Count; message_ids = $synced } | ConvertTo-Json -Depth 10
    return
}

if ($Action -eq "Health") {
    $available = Test-Path -LiteralPath $QueuePath
    $records = @()
    if ($available) {
        $records = @(Get-ChildItem -LiteralPath (Join-Path $QueuePath "records") -Filter "*.json" -File -ErrorAction SilentlyContinue | ForEach-Object { Read-Record -Path $_.FullName })
    }
    $spooledCount = @(Get-ChildItem -LiteralPath $SpoolPath -Filter "*.json" -File -ErrorAction SilentlyContinue).Count
    [pscustomobject]@{
        host = "WES-VIDEOEDITOR"
        queue_path = $QueuePath
        available = $available
        total_messages = $records.Count
        attention_messages = @($records | Where-Object { $_.state -in @("Delivery Ambiguous", "Blocked", "Needs Wes", "Rejected as Wrong Room") }).Count
        pending_local_spool = $spooledCount
        checked_at_utc = Get-UtcTimestamp
    } | ConvertTo-Json
    return
}

if (-not (Test-Path -LiteralPath $QueuePath)) { throw "Central PR messaging host is unavailable: $QueuePath" }

if ($Action -eq "List") {
    $items = @(Get-ChildItem -LiteralPath (Join-Path $QueuePath "records") -Filter "*.json" -File -ErrorAction SilentlyContinue | ForEach-Object { Read-Record -Path $_.FullName })
    if (-not [string]::IsNullOrWhiteSpace($DestinationProjectRoom)) { $items = @($items | Where-Object { $_.destination.project_room -eq $DestinationProjectRoom }) }
    if (-not [string]::IsNullOrWhiteSpace($DestinationTaskId)) { $items = @($items | Where-Object { $_.destination.task_id -eq $DestinationTaskId }) }
    if (-not [string]::IsNullOrWhiteSpace($State)) { $items = @($items | Where-Object { $_.state -eq $State }) }
    ConvertTo-Json -InputObject @($items | Sort-Object created_at_utc) -Depth 30
    return
}

Assert-MessageId -Id $MessageId
Invoke-WithQueueLock {
    $recordPath = Get-RecordPath -Root $QueuePath -Id $MessageId
    $record = Read-Record -Path $recordPath
    if ($Action -eq "Get") { $record | ConvertTo-Json -Depth 30; return }

    switch ($Action) {
        "StartAttempt" {
            if ($record.state -notin @("Queued", "Delivery Ambiguous")) { throw "Cannot start delivery while state is '$($record.state)'." }
            if ([int]$record.attempt_count -ge [int]$record.max_attempts) { throw "Message reached its maximum delivery attempts." }
            if ([string]::IsNullOrWhiteSpace($AttemptId)) { $AttemptId = [guid]::NewGuid().ToString("N") }
            $attempts = @($record.attempts)
            $attempts += [pscustomobject][ordered]@{ attempt_id = $AttemptId; started_at_utc = Get-UtcTimestamp; completed_at_utc = $null; outcome = "Pending"; detail = $null }
            $record.attempts = $attempts
            $record.attempt_count = [int]$record.attempt_count + 1
            $record.state = "Delivery Attempted"
            Add-Event -Record $record -Event "DeliveryAttemptStarted" -EventDetail $AttemptId -ProjectRoom $ActorProjectRoom -TaskId $ActorTaskId
        }
        "MarkAttempt" {
            if ($record.state -ne "Delivery Attempted") { throw "No active delivery attempt exists." }
            if ([string]::IsNullOrWhiteSpace($AttemptOutcome)) { throw "AttemptOutcome is required." }
            $attempts = @($record.attempts)
            $index = $attempts.Count - 1
            if (-not [string]::IsNullOrWhiteSpace($AttemptId)) {
                $matches = @(0..($attempts.Count - 1) | Where-Object { $attempts[$_].attempt_id -eq $AttemptId })
                if ($matches.Count -ne 1) { throw "AttemptId was not found or was not unique." }
                $index = $matches[0]
            }
            $attempts[$index].completed_at_utc = Get-UtcTimestamp
            $attempts[$index].outcome = $AttemptOutcome
            $attempts[$index].detail = $Detail
            $record.attempts = $attempts
            if ($AttemptOutcome -eq "DeliveryAmbiguous") { $record.state = "Delivery Ambiguous" }
            elseif ($AttemptOutcome -eq "NotDelivered") { $record.state = "Queued" }
            else { $record.state = "Blocked" }
            Add-Event -Record $record -Event "DeliveryAttemptCompleted" -EventDetail "$AttemptOutcome`: $Detail" -ProjectRoom $ActorProjectRoom -TaskId $ActorTaskId
        }
        "Accept" {
            Assert-DestinationActor -Record $record
            if ($record.state -in @("Accepted", "Processing", "Completed", "Blocked", "Needs Wes")) { $record | ConvertTo-Json -Depth 30; return }
            $attempts = @($record.attempts)
            if ($attempts.Count -gt 0) {
                $index = $attempts.Count - 1
                if ($attempts[$index].outcome -eq "Pending") {
                    $attempts[$index].completed_at_utc = Get-UtcTimestamp
                    $attempts[$index].outcome = "Delivered"
                    $attempts[$index].detail = "Destination wrote the authoritative acceptance receipt."
                    $record.attempts = $attempts
                }
            }
            $record.state = "Accepted"
            $record.receipt = [pscustomobject][ordered]@{ accepted_at_utc = Get-UtcTimestamp; project_room = $record.destination.project_room; task_id = $record.destination.task_id; machine = $env:COMPUTERNAME; detail = $Detail }
            Add-Event -Record $record -Event "Accepted" -EventDetail $Detail -ProjectRoom $record.destination.project_room -TaskId $record.destination.task_id
        }
        "StartProcessing" {
            Assert-DestinationActor -Record $record
            if ($record.state -eq "Processing") { $record | ConvertTo-Json -Depth 30; return }
            if ($record.state -ne "Accepted") { throw "Message must be Accepted before Processing." }
            $record.state = "Processing"
            Add-Event -Record $record -Event "ProcessingStarted" -EventDetail $Detail -ProjectRoom $record.destination.project_room -TaskId $record.destination.task_id
        }
        "Update" {
            Assert-DestinationActor -Record $record
            if ($record.state -notin @("Accepted", "Processing")) { throw "Status updates require Accepted or Processing state." }
            $updates = @($record.status_updates)
            $updates += [pscustomobject][ordered]@{ at_utc = Get-UtcTimestamp; detail = $Detail; machine = $env:COMPUTERNAME }
            $record.status_updates = $updates
            Add-Event -Record $record -Event "StatusUpdated" -EventDetail $Detail -ProjectRoom $record.destination.project_room -TaskId $record.destination.task_id
        }
        default {
            Assert-DestinationActor -Record $record
            if ($record.state -notin @("Accepted", "Processing")) { throw "Final result requires Accepted or Processing state." }
            $resultObject = ConvertFrom-RequiredJson -Json $ResultJson -Name "ResultJson"
            $finalState = switch ($Action) { "Complete" { "Completed" } "Block" { "Blocked" } "NeedsWes" { "Needs Wes" } "Reject" { "Rejected as Wrong Room" } }
            $record.state = $finalState
            $record.result = [pscustomobject][ordered]@{ state = $finalState; completed_at_utc = Get-UtcTimestamp; detail = $Detail; data = $resultObject; machine = $env:COMPUTERNAME }
            Add-Event -Record $record -Event "FinalResult" -EventDetail "$finalState`: $Detail" -ProjectRoom $record.destination.project_room -TaskId $record.destination.task_id
        }
    }
    Write-JsonAtomic -Path $recordPath -Value $record
    $record | ConvertTo-Json -Depth 30
}
