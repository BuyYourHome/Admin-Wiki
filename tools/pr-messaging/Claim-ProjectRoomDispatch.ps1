[CmdletBinding()]
param(
    [string]$ManagerPath,
    [string]$ManifestDirectory,
    [string]$ClientConfigPath = (Join-Path $env:LOCALAPPDATA "BuyYourHome\PRMessaging\client.json"),
    [string]$ActorProjectRoom = "PR Messaging Dispatcher",
    [Parameter(Mandatory = $true)]
    [string]$ActorTaskId
)

$ErrorActionPreference = "Stop"

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

$recordsJson = (& $ManagerPath -Action List | Out-String)
$records = if ([string]::IsNullOrWhiteSpace($recordsJson)) {
    @()
}
else {
    @($recordsJson | ConvertFrom-Json)
}
$candidates = @($records | Where-Object {
    $_.destination.machine -eq $machine -and
    $_.state -in @("Queued", "Delivery Ambiguous")
} | Sort-Object created_at_utc)

foreach ($record in $candidates) {
    if ($null -ne $record.receipt -or $null -ne $record.result) { continue }

    $attempts = @($record.attempts)
    if (@($attempts | Where-Object { $_.outcome -eq "Pending" }).Count -gt 0) { continue }
    if ([int]$record.attempt_count -ge [int]$record.max_attempts) { continue }

    $room = [string]$record.destination.project_room
    if (-not $manifests.ContainsKey($room)) { continue }
    $manifest = $manifests[$room]

    if ([string]$manifest.task_id -ne [string]$record.destination.task_id) { continue }
    if ([string]$manifest.execution_machine -ne $machine) { continue }
    if ([string]$record.message_type -notin @($manifest.accepted_message_types)) { continue }

    $registration = @($client.registrations | Where-Object {
        $_.project_room -eq $room -and $_.task_id -eq $record.destination.task_id
    })
    if ($registration.Count -ne 1) { continue }

    $validationException = (
        $manifest.dispatchable -ne $true -and
        $manifest.messaging_readiness.status -eq "validation_ready" -and
        $manifest.messaging_readiness.validation_message_id -eq $record.message_id -and
        $record.payload.synthetic_test -eq $true -and
        $record.authorization.business_action_authorized -ne $true -and
        $record.payload.business_action_performed -ne $true
    )
    if ($manifest.dispatchable -ne $true -and -not $validationException) { continue }

    $attemptNumber = [int]$record.attempt_count + 1
    $attemptId = "dispatcher-$($machine.ToLowerInvariant())-$($record.message_id)-$attemptNumber"
    $updated = & $ManagerPath -Action StartAttempt `
        -MessageId $record.message_id `
        -AttemptId $attemptId `
        -ActorProjectRoom $ActorProjectRoom `
        -ActorTaskId $ActorTaskId | ConvertFrom-Json

    [pscustomobject][ordered]@{
        claimed = $true
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
    } | ConvertTo-Json -Depth 10
    return
}

[pscustomobject][ordered]@{
    claimed = $false
    machine = $machine
    eligible_record_count = 0
} | ConvertTo-Json
