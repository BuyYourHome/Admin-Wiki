[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [ValidateSet("Create", "Get", "List", "StartAttempt", "MarkAttempt", "Accept", "StartProcessing", "Complete", "Fail", "MarkAlertSent")]
    [string]$Action,

    [string]$QueuePath = "$env:USERPROFILE\.codex\automations\officeassist-morning-email-summary-and-instruction-monitor\dispatch-queue",
    [string]$DispatchId,
    [string]$Mode,
    [string]$DestinationProjectRoom,
    [string]$DestinationTaskId,
    [string]$SourceJson,
    [string]$PayloadJson,
    [string]$AttemptId,
    [ValidateSet("DeliveryAmbiguous", "NotDelivered", "Failed")]
    [string]$AttemptOutcome,
    [string]$ReceiptTaskId,
    [string]$Detail,
    [string]$MessageId,
    [int]$MaxAttempts = 3,
    [int]$AlertAfterMinutes = 0
)

$ErrorActionPreference = "Stop"

function ConvertFrom-JsonObject {
    param(
        [string]$Json,
        [string]$Name
    )

    if ([string]::IsNullOrWhiteSpace($Json)) {
        throw "$Name is required."
    }

    try {
        return $Json | ConvertFrom-Json
    }
    catch {
        throw "$Name must be valid JSON: $($_.Exception.Message)"
    }
}

function Get-UtcTimestamp {
    return [DateTime]::UtcNow.ToString("o")
}

function Get-RecordPath {
    param([string]$Id)

    if ([string]::IsNullOrWhiteSpace($Id)) {
        throw "DispatchId is required for action $Action."
    }
    if ($Id -notmatch '^[A-Za-z0-9][A-Za-z0-9._-]{2,127}$') {
        throw "DispatchId contains unsupported characters or has an invalid length."
    }

    return Join-Path (Join-Path $QueuePath "records") "$Id.json"
}

function Read-Record {
    param([string]$Path)

    if (-not (Test-Path -LiteralPath $Path)) {
        throw "Dispatch record not found: $Path"
    }
    return Get-Content -LiteralPath $Path -Raw | ConvertFrom-Json
}

function Write-Record {
    param(
        [string]$Path,
        [object]$Record
    )

    $directory = Split-Path -Parent $Path
    New-Item -ItemType Directory -Path $directory -Force | Out-Null
    $tempPath = Join-Path $directory ("." + [IO.Path]::GetFileName($Path) + "." + [guid]::NewGuid().ToString("N") + ".tmp")
    $Record | ConvertTo-Json -Depth 30 | Set-Content -LiteralPath $tempPath -Encoding UTF8
    Move-Item -LiteralPath $tempPath -Destination $Path -Force
}

function Add-Event {
    param(
        [object]$Record,
        [string]$Event,
        [string]$EventDetail
    )

    $events = @($Record.events)
    $events += [pscustomobject][ordered]@{
        at_utc = Get-UtcTimestamp
        event = $Event
        detail = if ([string]::IsNullOrWhiteSpace($EventDetail)) { $null } else { $EventDetail }
    }
    $Record.events = $events
    $Record.updated_at_utc = Get-UtcTimestamp
}

function Get-PayloadHash {
    param(
        [object]$Source,
        [object]$Payload,
        [string]$DispatchMode,
        [string]$ProjectRoom,
        [string]$TaskId
    )

    $canonical = [ordered]@{
        mode = $DispatchMode
        destination_project_room = $ProjectRoom
        destination_task_id = $TaskId
        source = $Source
        payload = $Payload
    } | ConvertTo-Json -Depth 30 -Compress
    $bytes = [Text.Encoding]::UTF8.GetBytes($canonical)
    $sha = [Security.Cryptography.SHA256]::Create()
    try {
        return ([BitConverter]::ToString($sha.ComputeHash($bytes))).Replace("-", "").ToLowerInvariant()
    }
    finally {
        $sha.Dispose()
    }
}

New-Item -ItemType Directory -Path (Join-Path $QueuePath "records") -Force | Out-Null
$mutex = New-Object Threading.Mutex($false, "BuyYourHomeEmailMonitorDispatchQueue")
$lockTaken = $false

try {
    $lockTaken = $mutex.WaitOne([TimeSpan]::FromSeconds(15))
    if (-not $lockTaken) {
        throw "Timed out waiting for the dispatch queue lock."
    }

    if ($Action -eq "List") {
        $records = Get-ChildItem -LiteralPath (Join-Path $QueuePath "records") -Filter "*.json" -File -ErrorAction SilentlyContinue |
            ForEach-Object { Get-Content -LiteralPath $_.FullName -Raw | ConvertFrom-Json } |
            Sort-Object created_at_utc
        $records | ConvertTo-Json -Depth 30
        return
    }

    $recordPath = Get-RecordPath -Id $DispatchId

    if ($Action -eq "Create") {
        if ([string]::IsNullOrWhiteSpace($Mode) -or [string]::IsNullOrWhiteSpace($DestinationProjectRoom) -or [string]::IsNullOrWhiteSpace($DestinationTaskId)) {
            throw "Mode, DestinationProjectRoom, and DestinationTaskId are required for Create."
        }
        if ($MaxAttempts -lt 1) {
            throw "MaxAttempts must be at least 1."
        }

        $source = ConvertFrom-JsonObject -Json $SourceJson -Name "SourceJson"
        $payload = ConvertFrom-JsonObject -Json $PayloadJson -Name "PayloadJson"
        $payloadHash = Get-PayloadHash -Source $source -Payload $payload -DispatchMode $Mode -ProjectRoom $DestinationProjectRoom -TaskId $DestinationTaskId

        if (Test-Path -LiteralPath $recordPath) {
            $existing = Read-Record -Path $recordPath
            if ($existing.payload_hash -ne $payloadHash) {
                throw "DispatchId already exists with different content: $DispatchId"
            }
            $existing | ConvertTo-Json -Depth 30
            return
        }

        $now = [DateTime]::UtcNow
        $record = [pscustomobject][ordered]@{
            schema_version = 1
            dispatch_id = $DispatchId
            mode = $Mode
            destination = [pscustomobject][ordered]@{
                project_room = $DestinationProjectRoom
                task_id = $DestinationTaskId
            }
            source = $source
            payload = $payload
            payload_hash = $payloadHash
            state = "Queued"
            created_at_utc = $now.ToString("o")
            updated_at_utc = $now.ToString("o")
            max_attempts = $MaxAttempts
            attempt_count = 0
            alert_due_at_utc = $now.AddMinutes($AlertAfterMinutes).ToString("o")
            alert_sent_at_utc = $null
            alert_message_id = $null
            attempts = @()
            receipt = $null
            completion = $null
            events = @([pscustomobject][ordered]@{
                at_utc = $now.ToString("o")
                event = "Created"
                detail = "Durable dispatch record created before task notification."
            })
        }
        Write-Record -Path $recordPath -Record $record
        $record | ConvertTo-Json -Depth 30
        return
    }

    $record = Read-Record -Path $recordPath

    switch ($Action) {
        "Get" {
            $record | ConvertTo-Json -Depth 30
            return
        }
        "StartAttempt" {
            if ($record.state -notin @("Queued", "Delivery Ambiguous")) {
                throw "Cannot start an attempt while dispatch state is '$($record.state)'."
            }
            if ([int]$record.attempt_count -ge [int]$record.max_attempts) {
                throw "Dispatch has reached its maximum attempt count."
            }
            if ([string]::IsNullOrWhiteSpace($AttemptId)) {
                $AttemptId = [guid]::NewGuid().ToString("N")
            }
            $attempts = @($record.attempts)
            $attempts += [pscustomobject][ordered]@{
                attempt_id = $AttemptId
                started_at_utc = Get-UtcTimestamp
                completed_at_utc = $null
                outcome = "Pending"
                detail = $null
            }
            $record.attempts = $attempts
            $record.attempt_count = [int]$record.attempt_count + 1
            $record.state = "Send Attempted"
            Add-Event -Record $record -Event "SendAttemptStarted" -EventDetail $AttemptId
        }
        "MarkAttempt" {
            if ($record.state -ne "Send Attempted") {
                throw "Cannot mark an attempt while dispatch state is '$($record.state)'."
            }
            if ([string]::IsNullOrWhiteSpace($AttemptOutcome)) {
                throw "AttemptOutcome is required for MarkAttempt."
            }
            $attempts = @($record.attempts)
            if ($attempts.Count -eq 0) {
                throw "No send attempt exists."
            }
            $index = $attempts.Count - 1
            if (-not [string]::IsNullOrWhiteSpace($AttemptId)) {
                $matches = 0..($attempts.Count - 1) | Where-Object { $attempts[$_].attempt_id -eq $AttemptId }
                if (@($matches).Count -ne 1) {
                    throw "AttemptId was not found or was not unique."
                }
                $index = @($matches)[0]
            }
            $attempts[$index].completed_at_utc = Get-UtcTimestamp
            $attempts[$index].outcome = $AttemptOutcome
            $attempts[$index].detail = if ([string]::IsNullOrWhiteSpace($Detail)) { $null } else { $Detail }
            $record.attempts = $attempts
            switch ($AttemptOutcome) {
                "DeliveryAmbiguous" { $record.state = "Delivery Ambiguous" }
                "NotDelivered" { $record.state = "Queued" }
                "Failed" { $record.state = "Failed" }
            }
            Add-Event -Record $record -Event "SendAttemptCompleted" -EventDetail "$AttemptOutcome`: $Detail"
        }
        "Accept" {
            if ($record.state -in @("Accepted", "Processing", "Completed")) {
                $record | ConvertTo-Json -Depth 30
                return
            }
            if (-not [string]::IsNullOrWhiteSpace($ReceiptTaskId) -and $ReceiptTaskId -ne $record.destination.task_id) {
                throw "ReceiptTaskId does not match the dispatch destination task."
            }
            $record.state = "Accepted"
            $attempts = @($record.attempts)
            if ($attempts.Count -gt 0 -and $attempts[$attempts.Count - 1].outcome -eq "Pending") {
                $attempts[$attempts.Count - 1].completed_at_utc = Get-UtcTimestamp
                $attempts[$attempts.Count - 1].outcome = "Accepted"
                $attempts[$attempts.Count - 1].detail = "Durable receipt written by destination."
                $record.attempts = $attempts
            }
            $record.receipt = [pscustomobject][ordered]@{
                status = "accepted"
                task_id = if ([string]::IsNullOrWhiteSpace($ReceiptTaskId)) { $record.destination.task_id } else { $ReceiptTaskId }
                accepted_at_utc = Get-UtcTimestamp
                detail = if ([string]::IsNullOrWhiteSpace($Detail)) { $null } else { $Detail }
            }
            Add-Event -Record $record -Event "Accepted" -EventDetail $Detail
        }
        "StartProcessing" {
            if ($record.state -eq "Processing") {
                $record | ConvertTo-Json -Depth 30
                return
            }
            if ($record.state -ne "Accepted") {
                throw "Dispatch must be Accepted before processing starts."
            }
            $record.state = "Processing"
            Add-Event -Record $record -Event "ProcessingStarted" -EventDetail $Detail
        }
        "Complete" {
            if ($record.state -eq "Completed") {
                $record | ConvertTo-Json -Depth 30
                return
            }
            if ($record.state -notin @("Accepted", "Processing")) {
                throw "Dispatch must be Accepted or Processing before completion."
            }
            $record.state = "Completed"
            $record.completion = [pscustomobject][ordered]@{
                completed_at_utc = Get-UtcTimestamp
                detail = if ([string]::IsNullOrWhiteSpace($Detail)) { $null } else { $Detail }
            }
            Add-Event -Record $record -Event "Completed" -EventDetail $Detail
        }
        "Fail" {
            if ($record.state -eq "Completed") {
                throw "A completed dispatch cannot be failed."
            }
            $record.state = "Failed"
            Add-Event -Record $record -Event "Failed" -EventDetail $Detail
        }
        "MarkAlertSent" {
            if ($record.state -in @("Accepted", "Processing", "Completed")) {
                throw "An acknowledged dispatch does not require a missing-acknowledgment alert."
            }
            if ($null -ne $record.alert_sent_at_utc -and -not [string]::IsNullOrWhiteSpace([string]$record.alert_sent_at_utc)) {
                $record | ConvertTo-Json -Depth 30
                return
            }
            $record.alert_sent_at_utc = Get-UtcTimestamp
            $record.alert_message_id = if ([string]::IsNullOrWhiteSpace($MessageId)) { $null } else { $MessageId }
            Add-Event -Record $record -Event "MissingAcknowledgmentAlertSent" -EventDetail $Detail
        }
    }

    Write-Record -Path $recordPath -Record $record
    $record | ConvertTo-Json -Depth 30
}
finally {
    if ($lockTaken) {
        $mutex.ReleaseMutex()
    }
    $mutex.Dispose()
}
