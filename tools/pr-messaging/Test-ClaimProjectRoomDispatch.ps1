[CmdletBinding()]
param()

$ErrorActionPreference = "Stop"
$testRoot = Join-Path $env:TEMP ("byh-prmsg-claim-" + [guid]::NewGuid().ToString("N"))
$queuePath = Join-Path $testRoot "queue"
$manifestDirectory = Join-Path $testRoot "manifests"
$clientConfigPath = Join-Path $testRoot "client.json"
$healthPath = Join-Path $testRoot "dispatcher-health.json"
$managerPath = Join-Path $PSScriptRoot "Manage-ProjectRoomMessage.ps1"
$helperPath = Join-Path $PSScriptRoot "Claim-ProjectRoomDispatch.ps1"
$destinationRoom = "Test Destination"
$destinationTaskId = "test-destination-task"

function Assert-Equal {
    param($Expected, $Actual, [string]$Message)
    if ($Expected -ne $Actual) {
        throw "$Message Expected '$Expected', received '$Actual'."
    }
}

try {
    New-Item -ItemType Directory -Path $queuePath, $manifestDirectory -Force | Out-Null

    [ordered]@{
        schema_version = 1
        machine = $env:COMPUTERNAME
        queue_path = $queuePath
        spool_path = (Join-Path $testRoot "spool")
        registrations = @(
            [ordered]@{
                project_room = $destinationRoom
                task_id = $destinationTaskId
                registered_at_utc = [DateTime]::UtcNow.ToString("o")
            }
        )
    } | ConvertTo-Json -Depth 8 | Set-Content -LiteralPath $clientConfigPath -Encoding UTF8

    [ordered]@{
        schema_version = 2
        project_room = $destinationRoom
        task_id = $destinationTaskId
        dispatchable = $true
        execution_machine = $env:COMPUTERNAME
        accepted_message_types = @("request")
    } | ConvertTo-Json -Depth 8 | Set-Content -LiteralPath (Join-Path $manifestDirectory "test-destination.json") -Encoding UTF8

    & $managerPath -Action Send -QueuePath $queuePath `
        -MessageId "test-older-message" -MessageType request `
        -SourceProjectRoom "Test Source" -SourceTaskId "test-source-task" `
        -DestinationProjectRoom $destinationRoom -DestinationTaskId $destinationTaskId `
        -DestinationMachine $env:COMPUTERNAME -PayloadJson '{"synthetic_test":true}' | Out-Null
    Start-Sleep -Milliseconds 20
    & $managerPath -Action Send -QueuePath $queuePath `
        -MessageId "test-target-message" -MessageType request `
        -SourceProjectRoom "Test Source" -SourceTaskId "test-source-task" `
        -DestinationProjectRoom $destinationRoom -DestinationTaskId $destinationTaskId `
        -DestinationMachine $env:COMPUTERNAME -PayloadJson '{"synthetic_test":true}' | Out-Null

    $claim = & $helperPath -ManagerPath $managerPath -QueuePath $queuePath `
        -ManifestDirectory $manifestDirectory -ClientConfigPath $clientConfigPath `
        -HealthPath $healthPath -ActorTaskId "test-dispatcher-task" `
        -MessageId "test-target-message" | ConvertFrom-Json

    Assert-Equal $true $claim.claimed "Exact-message run must claim a record."
    Assert-Equal "test-target-message" $claim.message_id "Exact-message run claimed the wrong record."
    Assert-Equal "test-target-message" $claim.requested_message_id "Claim output omitted the requested message id."

    $older = & $managerPath -Action Get -QueuePath $queuePath -MessageId "test-older-message" | ConvertFrom-Json
    $target = & $managerPath -Action Get -QueuePath $queuePath -MessageId "test-target-message" | ConvertFrom-Json
    Assert-Equal 0 $older.attempt_count "Older eligible record must remain untouched."
    Assert-Equal 1 $target.attempt_count "Target record must receive exactly one StartAttempt."

    $missing = & $helperPath -ManagerPath $managerPath -QueuePath $queuePath `
        -ManifestDirectory $manifestDirectory -ClientConfigPath $clientConfigPath `
        -HealthPath $healthPath -ActorTaskId "test-dispatcher-task" `
        -MessageId "test-missing-message" | ConvertFrom-Json
    Assert-Equal $false $missing.claimed "Missing exact message must fail closed."
    Assert-Equal $false $missing.target_filter.record_found "Missing exact message must be reported as not found."

    $unfiltered = & $helperPath -ManagerPath $managerPath -QueuePath $queuePath `
        -ManifestDirectory $manifestDirectory -ClientConfigPath $clientConfigPath `
        -HealthPath $healthPath -ActorTaskId "test-dispatcher-task" | ConvertFrom-Json
    Assert-Equal $true $unfiltered.claimed "Normal unfiltered run must still claim an eligible record."
    Assert-Equal "test-older-message" $unfiltered.message_id "Normal unfiltered run must retain oldest-first selection."

    [pscustomobject][ordered]@{
        passed = $true
        targeted_message = $claim.message_id
        targeted_attempt_count = $target.attempt_count
        older_attempt_count = $older.attempt_count
        missing_message_claimed = $missing.claimed
        unfiltered_message = $unfiltered.message_id
    } | ConvertTo-Json
}
finally {
    if (Test-Path -LiteralPath $testRoot) {
        Remove-Item -LiteralPath $testRoot -Recurse -Force
    }
}
