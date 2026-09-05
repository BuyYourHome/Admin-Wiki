[CmdletBinding()]
param(
    [string]$ManagerPath,
    [string]$QueuePath,
    [string]$ManifestDirectory,
    [string]$ClientConfigPath = (Join-Path $env:LOCALAPPDATA "BuyYourHome\PRMessaging\client.json"),
    [string]$HealthPath,
    [string]$ActorProjectRoom = "PR Messaging Dispatcher",
    [Parameter(Mandatory = $true)]
    [string]$ActorTaskId,
    [string]$MessageId
)

$ErrorActionPreference = "Stop"
$runStartedAtUtc = [DateTime]::UtcNow.ToString("o")
$dispatcherTimeZoneId = "Eastern Standard Time"
$dispatcherWindowStart = [TimeSpan]::FromHours(7.5)
$dispatcherWindowEnd = [TimeSpan]::FromHours(19)

if ([string]::IsNullOrWhiteSpace($HealthPath)) {
    $HealthPath = Join-Path $env:LOCALAPPDATA "BuyYourHome\PRMessaging\dispatcher-health.json"
}

function Get-DispatcherScheduleState {
    $timeZone = [TimeZoneInfo]::FindSystemTimeZoneById($dispatcherTimeZoneId)
    $utcNow = [DateTime]::UtcNow
    $localNow = [TimeZoneInfo]::ConvertTimeFromUtc($utcNow, $timeZone)
    $isWeekday = $localNow.DayOfWeek -notin @([DayOfWeek]::Saturday, [DayOfWeek]::Sunday)
    $isOpen = $isWeekday -and $localNow.TimeOfDay -ge $dispatcherWindowStart -and $localNow.TimeOfDay -le $dispatcherWindowEnd

    $nextLocal = $null
    if ($isWeekday) {
        $windowStart = $localNow.Date.Add($dispatcherWindowStart)
        if ($localNow -lt $windowStart) {
            $nextLocal = $windowStart
        }
        elseif ($localNow.TimeOfDay -le $dispatcherWindowEnd) {
            $minutesSinceStart = ($localNow - $windowStart).TotalMinutes
            $nextOffsetMinutes = [Math]::Ceiling($minutesSinceStart / 5.0) * 5
            $candidate = $windowStart.AddMinutes($nextOffsetMinutes)
            if ($candidate -le $localNow) {
                $candidate = $candidate.AddMinutes(5)
            }
            if ($candidate.TimeOfDay -le $dispatcherWindowEnd) {
                $nextLocal = $candidate
            }
        }
    }

    if ($null -eq $nextLocal) {
        $nextDate = $localNow.Date.AddDays(1)
        while ($nextDate.DayOfWeek -in @([DayOfWeek]::Saturday, [DayOfWeek]::Sunday)) {
            $nextDate = $nextDate.AddDays(1)
        }
        $nextLocal = $nextDate.Add($dispatcherWindowStart)
    }

    $unspecifiedNext = [DateTime]::SpecifyKind($nextLocal, [DateTimeKind]::Unspecified)
    [pscustomobject][ordered]@{
        time_zone = "America/New_York"
        weekdays = @("Monday", "Tuesday", "Wednesday", "Thursday", "Friday")
        start_local = "07:30"
        end_local = "19:00"
        interval_minutes = 5
        is_open_now = $isOpen
        next_scheduled_run_at_utc = [TimeZoneInfo]::ConvertTimeToUtc($unspecifiedNext, $timeZone).ToString("o")
    }
}

function Write-DispatcherHealth {
    param(
        [string]$Status,
        [string]$Detail,
        [Nullable[bool]]$Claimed = $null,
        [int]$CandidateCount = 0,
        [string]$MessageId = $null
    )

    try {
        $schedule = Get-DispatcherScheduleState
        $healthDirectory = Split-Path $HealthPath -Parent
        if (-not (Test-Path -LiteralPath $healthDirectory)) {
            New-Item -ItemType Directory -Path $healthDirectory -Force | Out-Null
        }
        $health = [pscustomobject][ordered]@{
            schema_version = 2
            machine = $env:COMPUTERNAME
            dispatcher_task_id = $ActorTaskId
            status = $Status
            detail = $Detail
            claimed = $Claimed
            candidate_count = $CandidateCount
            message_id = $MessageId
            run_started_at_utc = $runStartedAtUtc
            updated_at_utc = [DateTime]::UtcNow.ToString("o")
            schedule = $schedule
        }
        $temporaryPath = "$HealthPath.tmp"
        $health | ConvertTo-Json -Depth 8 | Set-Content -LiteralPath $temporaryPath -Encoding UTF8
        Move-Item -LiteralPath $temporaryPath -Destination $HealthPath -Force
    }
    catch {
        # Health reporting must never alter dispatch eligibility or queue state.
    }
}

trap {
    $failure = $_
    Write-DispatcherHealth -Status "Failed" -Detail $failure.Exception.Message
    throw $failure
}

Write-DispatcherHealth -Status "Running" -Detail "Claim evaluation started."

if ([string]::IsNullOrWhiteSpace($ManagerPath)) {
    $ManagerPath = Join-Path $PSScriptRoot "Manage-ProjectRoomMessage.ps1"
}
if ([string]::IsNullOrWhiteSpace($ManifestDirectory)) {
    $ManifestDirectory = Join-Path (Split-Path (Split-Path $PSScriptRoot -Parent) -Parent) "config\pr-messaging-manifests"
}

if (-not (Test-Path -LiteralPath $ManagerPath)) { throw "Messaging manager not found: $ManagerPath" }
if (-not (Test-Path -LiteralPath $ManifestDirectory)) { throw "Manifest directory not found: $ManifestDirectory" }
if (-not (Test-Path -LiteralPath $ClientConfigPath)) { throw "Messaging client config not found: $ClientConfigPath" }

$machine = $env:COMPUTERNAME
$client = Get-Content -Raw -LiteralPath $ClientConfigPath | ConvertFrom-Json
if ([string]$client.machine -ne $machine) { throw "Client machine '$($client.machine)' does not match '$machine'." }

$manifests = @{}
Get-ChildItem -LiteralPath $ManifestDirectory -Filter "*.json" -File | ForEach-Object {
    $manifest = Get-Content -Raw -LiteralPath $_.FullName | ConvertFrom-Json
    if (-not [string]::IsNullOrWhiteSpace([string]$manifest.project_room)) {
        $manifests[[string]$manifest.project_room] = $manifest
    }
}

$recordsJson = if ([string]::IsNullOrWhiteSpace($QueuePath)) {
    (& $ManagerPath -Action List | Out-String)
}
else {
    (& $ManagerPath -Action List -QueuePath $QueuePath | Out-String)
}
$records = if ([string]::IsNullOrWhiteSpace($recordsJson)) {
    @()
}
else {
    @($recordsJson | ConvertFrom-Json)
}
$targetMatches = if ([string]::IsNullOrWhiteSpace($MessageId)) {
    @()
}
else {
    @($records | Where-Object { [string]$_.message_id -ceq $MessageId })
}
if ($targetMatches.Count -gt 1) {
    throw "Authoritative queue returned duplicate records for MessageId '$MessageId'."
}
$scopedRecords = if ([string]::IsNullOrWhiteSpace($MessageId)) {
    @($records)
}
else {
    @($targetMatches)
}
$candidates = @($scopedRecords | Where-Object {
    $_.destination.machine -eq $machine -and
    $_.state -in @("Queued", "Delivery Ambiguous")
} | Sort-Object created_at_utc)
$targetFilter = if ([string]::IsNullOrWhiteSpace($MessageId)) {
    $null
}
else {
    $targetRecord = if ($targetMatches.Count -eq 1) { $targetMatches[0] } else { $null }
    [pscustomobject][ordered]@{
        requested_message_id = $MessageId
        record_found = $null -ne $targetRecord
        destination_machine_matches = $null -ne $targetRecord -and $targetRecord.destination.machine -eq $machine
        state_is_candidate = $null -ne $targetRecord -and $targetRecord.state -in @("Queued", "Delivery Ambiguous")
    }
}

$skipCounts = [ordered]@{
    receipt_or_result = 0
    pending_attempt = 0
    attempts_exhausted = 0
    manifest_missing = 0
    task_id_mismatch = 0
    execution_machine_mismatch = 0
    message_type_not_accepted = 0
    registration_mismatch = 0
    not_dispatchable = 0
}

foreach ($record in $candidates) {
    if ($null -ne $record.receipt -or $null -ne $record.result) {
        $skipCounts.receipt_or_result++
        continue
    }

    $attempts = @($record.attempts)
    if (@($attempts | Where-Object { $_.outcome -eq "Pending" }).Count -gt 0) {
        $skipCounts.pending_attempt++
        continue
    }
    if ([int]$record.attempt_count -ge [int]$record.max_attempts) {
        $skipCounts.attempts_exhausted++
        continue
    }

    $room = [string]$record.destination.project_room
    if (-not $manifests.ContainsKey($room)) {
        $skipCounts.manifest_missing++
        continue
    }
    $manifest = $manifests[$room]

    if ([string]$manifest.task_id -ne [string]$record.destination.task_id) {
        $skipCounts.task_id_mismatch++
        continue
    }
    if ([string]$manifest.execution_machine -ne $machine) {
        $skipCounts.execution_machine_mismatch++
        continue
    }
    if ([string]$record.message_type -notin @($manifest.accepted_message_types)) {
        $skipCounts.message_type_not_accepted++
        continue
    }

    $registration = @($client.registrations | Where-Object {
        $_.project_room -eq $room -and $_.task_id -eq $record.destination.task_id
    })
    if ($registration.Count -ne 1) {
        $skipCounts.registration_mismatch++
        continue
    }

    $validationException = (
        $manifest.dispatchable -ne $true -and
        $manifest.messaging_readiness.status -eq "validation_ready" -and
        $manifest.messaging_readiness.validation_message_id -eq $record.message_id -and
        $record.payload.synthetic_test -eq $true -and
        $record.authorization.business_action_authorized -ne $true -and
        $record.payload.business_action_performed -ne $true
    )
    if ($manifest.dispatchable -ne $true -and -not $validationException) {
        $skipCounts.not_dispatchable++
        continue
    }

    $attemptNumber = [int]$record.attempt_count + 1
    $attemptId = "dispatcher-$($machine.ToLowerInvariant())-$($record.message_id)-$attemptNumber"
    $startAttemptArguments = @{
        Action = "StartAttempt"
        MessageId = $record.message_id
        AttemptId = $attemptId
        ActorProjectRoom = $ActorProjectRoom
        ActorTaskId = $ActorTaskId
    }
    if (-not [string]::IsNullOrWhiteSpace($QueuePath)) {
        $startAttemptArguments.QueuePath = $QueuePath
    }
    $updated = & $ManagerPath @startAttemptArguments | ConvertFrom-Json

    $claim = [pscustomobject][ordered]@{
        claimed = $true
        requested_message_id = if ([string]::IsNullOrWhiteSpace($MessageId)) { $null } else { $MessageId }
        message_id = $updated.message_id
        dispatch_id = $updated.dispatch_id
        payload_hash = $updated.payload_hash
        destination_project_room = $updated.destination.project_room
        destination_task_id = $updated.destination.task_id
        destination_machine = $updated.destination.machine
        attempt_id = $attemptId
        attempt_count = $updated.attempt_count
        max_attempts = $updated.max_attempts
        notification_instruction = "Notify the exact destination task once. Require Accepted, Processing, and a valid final state for this same message id and payload hash."
        candidate_count = $candidates.Count
        skip_counts = [pscustomobject]$skipCounts
        target_filter = $targetFilter
    }
    Write-DispatcherHealth -Status "Completed" -Detail "One eligible record was claimed." -Claimed $true -CandidateCount $candidates.Count -MessageId $updated.message_id
    $claim | ConvertTo-Json -Depth 10
    return
}

$noClaim = [pscustomobject][ordered]@{
    claimed = $false
    machine = $machine
    candidate_count = $candidates.Count
    eligible_record_count = 0
    oldest_candidate_message_id = if ($candidates.Count -gt 0) { $candidates[0].message_id } else { $null }
    skip_counts = [pscustomobject]$skipCounts
    target_filter = $targetFilter
}
Write-DispatcherHealth -Status "Completed" -Detail "No eligible record was claimed." -Claimed $false -CandidateCount $candidates.Count
$noClaim | ConvertTo-Json -Depth 10
