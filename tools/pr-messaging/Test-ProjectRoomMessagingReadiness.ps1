[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [string]$ProjectRoom,
    [Parameter(Mandatory = $true)]
    [string]$TaskId,
    [Parameter(Mandatory = $true)]
    [string]$ReadmePath,
    [Parameter(Mandatory = $true)]
    [string]$ManifestPath,
    [string]$RegistryPath,
    [string]$RoutingMapPath,
    [string]$ClientConfigPath,
    [string]$QueuePath = "\\WES-VIDEOEDITOR\BYH-PRMessaging$",
    [string]$ManageToolPath
)

$ErrorActionPreference = "Stop"
$repoRoot = (Resolve-Path (Join-Path $PSScriptRoot "..\..")).Path
if ([string]::IsNullOrWhiteSpace($RegistryPath)) {
    $RegistryPath = Join-Path $repoRoot "Agents and Automations Registry.md"
}
if ([string]::IsNullOrWhiteSpace($RoutingMapPath)) {
    $RoutingMapPath = Join-Path $repoRoot "Project Rooms\Jean Wright\working\dispatcher-routing-map.md"
}
if ([string]::IsNullOrWhiteSpace($ClientConfigPath)) {
    $ClientConfigPath = Join-Path $env:LOCALAPPDATA "BuyYourHome\PRMessaging\client.json"
}
if ([string]::IsNullOrWhiteSpace($ManageToolPath)) {
    $ManageToolPath = Join-Path $PSScriptRoot "Manage-ProjectRoomMessage.ps1"
}

$checks = @()
function Add-ReadinessCheck {
    param([string]$Name, [bool]$Passed, [string]$Detail)
    $script:checks += [pscustomobject][ordered]@{
        name = $Name
        passed = $Passed
        detail = $Detail
    }
}

foreach ($requiredPath in @($ReadmePath, $ManifestPath, $RegistryPath, $RoutingMapPath, $ClientConfigPath, $ManageToolPath)) {
    if (-not (Test-Path -LiteralPath $requiredPath)) {
        Add-ReadinessCheck -Name "required_file:$requiredPath" -Passed $false -Detail "Required readiness source is missing."
    }
}

if (@($checks | Where-Object { -not $_.passed }).Count -gt 0) {
    [pscustomobject][ordered]@{
        project_room = $ProjectRoom
        task_id = $TaskId
        machine = $env:COMPUTERNAME
        readiness_prerequisites_passed = $false
        dispatchable_declared = $false
        ready = $false
        checks = $checks
    } | ConvertTo-Json -Depth 20
    exit 1
}

$manifest = Get-Content -Raw -LiteralPath $ManifestPath | ConvertFrom-Json
$readmeText = Get-Content -Raw -LiteralPath $ReadmePath
$registryText = Get-Content -Raw -LiteralPath $RegistryPath
$routingText = Get-Content -Raw -LiteralPath $RoutingMapPath
$client = Get-Content -Raw -LiteralPath $ClientConfigPath | ConvertFrom-Json

Add-ReadinessCheck -Name "manifest_project_room" -Passed ($manifest.project_room -eq $ProjectRoom) -Detail "Manifest Project Room must match exactly."
Add-ReadinessCheck -Name "manifest_task_id" -Passed ($manifest.task_id -eq $TaskId) -Detail "Manifest task id must match exactly."
Add-ReadinessCheck -Name "execution_machine" -Passed ($manifest.execution_machine -eq $env:COMPUTERNAME) -Detail "Validation must run on the exact execution machine recorded in the manifest."
Add-ReadinessCheck -Name "readme_task_id" -Passed ($readmeText.Contains($TaskId)) -Detail "Project Room README must contain the exact task id."

$registryPattern = '(?ms)^##\s+' + [regex]::Escape($ProjectRoom) + '\s*\r?\n(?<body>.*?)(?=^##\s+|\z)'
$registryMatch = [regex]::Match($registryText, $registryPattern)
$registryHasTask = $registryMatch.Success -and $registryMatch.Groups['body'].Value.Contains($TaskId)
Add-ReadinessCheck -Name "registry_task_id" -Passed $registryHasTask -Detail "Registry section must contain the exact task id."

$routePattern = '(?m)^\|\s*' + [regex]::Escape($ProjectRoom) + '\s*\|[^\r\n]*\|\s*`?' + [regex]::Escape($TaskId) + '`?\s*\|'
$routeHasTask = [regex]::IsMatch($routingText, $routePattern)
Add-ReadinessCheck -Name "routing_task_id" -Passed $routeHasTask -Detail "Jean routing map row must contain the exact task id."

$clientMachineMatches = $client.machine -eq $manifest.execution_machine
$registrationMatches = @($client.registrations | Where-Object { $_.project_room -eq $ProjectRoom -and $_.task_id -eq $TaskId }).Count -eq 1
Add-ReadinessCheck -Name "client_machine" -Passed $clientMachineMatches -Detail "Machine-local client must identify the manifest execution machine."
Add-ReadinessCheck -Name "machine_registration" -Passed $registrationMatches -Detail "Machine-local client must contain one exact Project Room/task registration."

$health = & $ManageToolPath -Action Health -QueuePath $QueuePath | Out-String | ConvertFrom-Json
Add-ReadinessCheck -Name "host_access" -Passed ([bool]$health.available) -Detail "Canonical message tool must authenticate to the central host."

$readiness = $manifest.messaging_readiness
$validationMessageId = if ($null -ne $readiness) { [string]$readiness.validation_message_id } else { "" }
Add-ReadinessCheck -Name "readiness_status" -Passed ($null -ne $readiness -and $readiness.status -eq "ready") -Detail "Manifest messaging_readiness status must be ready."
Add-ReadinessCheck -Name "registration_evidence" -Passed ($null -ne $readiness -and -not [string]::IsNullOrWhiteSpace([string]$readiness.machine_registration_verified_at_utc)) -Detail "Manifest must record when the exact machine registration was verified."
Add-ReadinessCheck -Name "host_access_evidence" -Passed ($null -ne $readiness -and -not [string]::IsNullOrWhiteSpace([string]$readiness.host_access_verified_at_utc)) -Detail "Manifest must record when authenticated host access was verified."
Add-ReadinessCheck -Name "lifecycle_evidence" -Passed ($null -ne $readiness -and -not [string]::IsNullOrWhiteSpace([string]$readiness.lifecycle_completed_at_utc)) -Detail "Manifest must record when the synthetic lifecycle completed."
Add-ReadinessCheck -Name "notification_evidence" -Passed ($null -ne $readiness -and [int]$readiness.notification_count -eq 1) -Detail "Manifest must record exactly one synthetic task notification."
Add-ReadinessCheck -Name "validation_message_id" -Passed (-not [string]::IsNullOrWhiteSpace($validationMessageId)) -Detail "Manifest must identify the immutable synthetic validation record."

if (-not [string]::IsNullOrWhiteSpace($validationMessageId)) {
    try {
        $record = & $ManageToolPath -Action Get -QueuePath $QueuePath -MessageId $validationMessageId | Out-String | ConvertFrom-Json
        $eventNames = @($record.events | ForEach-Object { $_.event })
        $lifecyclePassed = (
            $record.payload.synthetic_test -eq $true -and
            $record.destination.project_room -eq $ProjectRoom -and
            $record.destination.task_id -eq $TaskId -and
            $record.state -eq "Completed" -and
            $record.receipt.project_room -eq $ProjectRoom -and
            $record.receipt.task_id -eq $TaskId -and
            [int]$record.attempt_count -eq 1 -and
            @($record.attempts).Count -eq 1 -and
            $record.attempts[0].outcome -eq "Delivered" -and
            [int]$record.result.data.notification_count -eq 1 -and
            [int]$record.result.data.notification_count -eq [int]$readiness.notification_count -and
            [string]$record.result.completed_at_utc -eq [string]$readiness.lifecycle_completed_at_utc -and
            $eventNames -contains "Accepted" -and
            $eventNames -contains "ProcessingStarted" -and
            $eventNames -contains "FinalResult"
        )
        Add-ReadinessCheck -Name "synthetic_lifecycle" -Passed $lifecyclePassed -Detail "Synthetic record must show one notification attempt and exact-identity Accepted, Processing, and Completed events."
    }
    catch {
        Add-ReadinessCheck -Name "synthetic_lifecycle" -Passed $false -Detail "Synthetic validation record could not be verified: $($_.Exception.Message)"
    }
}

$prerequisitesPassed = @($checks | Where-Object { -not $_.passed }).Count -eq 0
$dispatchableDeclared = $manifest.dispatchable -eq $true
Add-ReadinessCheck -Name "dispatchable_declared" -Passed $dispatchableDeclared -Detail "Manifest may declare dispatchable only after every prerequisite passes."
$ready = $prerequisitesPassed -and $dispatchableDeclared

[pscustomobject][ordered]@{
    project_room = $ProjectRoom
    task_id = $TaskId
    machine = $env:COMPUTERNAME
    readiness_prerequisites_passed = $prerequisitesPassed
    dispatchable_declared = $dispatchableDeclared
    ready = $ready
    checks = $checks
    checked_at_utc = [DateTime]::UtcNow.ToString("o")
} | ConvertTo-Json -Depth 20

if (-not $ready) { exit 1 }
