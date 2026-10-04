[CmdletBinding()]
param(
    [string]$ManagerPath = "C:\Codex\Wiki Files\tools\pr-messaging\Manage-ProjectRoomMessage.ps1",
    [string]$QueuePath,
    [string]$DestinationProjectRoom = "Invoice Entry",
    [string]$DestinationTaskId = "01a03956-fa4f-77c1-9ab7-f709e5f1174e",
    [string]$DestinationMachine = "OFFICEASSIST",
    [string]$TriggerMessageId,
    [switch]$DependenciesReviewed,
    [string[]]$BlockingMessageId = @(),
    [ValidateRange(1, 10080)]
    [int]$AgedMinutes = 60
)

$ErrorActionPreference = "Stop"

if (-not (Test-Path -LiteralPath $ManagerPath)) {
    throw "Messaging manager not found: $ManagerPath"
}

$listArguments = @{
    Action = "List"
    DestinationProjectRoom = $DestinationProjectRoom
    DestinationTaskId = $DestinationTaskId
    DestinationMachine = $DestinationMachine
}
if (-not [string]::IsNullOrWhiteSpace($QueuePath)) {
    $listArguments.QueuePath = $QueuePath
}

$raw = & $ManagerPath @listArguments | Out-String
$records = if ([string]::IsNullOrWhiteSpace($raw)) { @() } else { @($raw | ConvertFrom-Json) }
$nonterminalStates = @("Queued", "Delivery Attempted", "Delivery Ambiguous", "Accepted", "Processing")
$now = [DateTime]::UtcNow

function ConvertTo-QueueItem {
    param($Record)
    $created = [DateTime]::Parse([string]$Record.created_at_utc).ToUniversalTime()
    [pscustomobject][ordered]@{
        message_id = [string]$Record.message_id
        dispatch_id = [string]$Record.dispatch_id
        payload_hash = [string]$Record.payload_hash
        state = [string]$Record.state
        created_at_utc = $created.ToString("o")
        age_minutes = [Math]::Floor(($now - $created).TotalMinutes)
    }
}

$unresolved = @($records | Where-Object {
    [string]$_.state -in $nonterminalStates
} | Sort-Object @{ Expression = { [DateTime]::Parse([string]$_.created_at_utc).ToUniversalTime() } }, @{ Expression = { [string]$_.message_id } })

$trigger = $null
$older = @()
if (-not [string]::IsNullOrWhiteSpace($TriggerMessageId)) {
    $triggerMatches = @($records | Where-Object { [string]$_.message_id -ceq $TriggerMessageId })
    if ($triggerMatches.Count -ne 1) {
        throw "Trigger message '$TriggerMessageId' was not found exactly once for the configured Invoice Entry destination."
    }
    $trigger = $triggerMatches[0]
    $triggerCreated = [DateTime]::Parse([string]$trigger.created_at_utc).ToUniversalTime()
    $older = @($unresolved | Where-Object {
        $created = [DateTime]::Parse([string]$_.created_at_utc).ToUniversalTime()
        $created -lt $triggerCreated -or ($created -eq $triggerCreated -and [string]$_.message_id -clt $TriggerMessageId)
    })
}

$aged = @($unresolved | Where-Object {
    $created = [DateTime]::Parse([string]$_.created_at_utc).ToUniversalTime()
    ($now - $created).TotalMinutes -ge $AgedMinutes
})

$result = [pscustomobject][ordered]@{
    processing_policy = 'NewActionableEndToEndBeforeRecovery'
    dependencies_reviewed = [bool]$DependenciesReviewed
    blocking_message_ids = @($BlockingMessageId)
    older_records_are_advisory = $true
    destination = [pscustomobject][ordered]@{
        project_room = $DestinationProjectRoom
        task_id = $DestinationTaskId
        machine = $DestinationMachine
    }
    checked_at_utc = $now.ToString("o")
    aged_threshold_minutes = $AgedMinutes
    trigger_message_id = if ($null -eq $trigger) { $null } else { [string]$trigger.message_id }
    trigger_state = if ($null -eq $trigger) { $null } else { [string]$trigger.state }
    older_unresolved_count = $older.Count
    older_unresolved = @($older | ForEach-Object { ConvertTo-QueueItem -Record $_ })
    aged_unresolved_count = $aged.Count
    aged_unresolved = @($aged | ForEach-Object { ConvertTo-QueueItem -Record $_ })
    all_unresolved_count = $unresolved.Count
    all_unresolved = @($unresolved | ForEach-Object { ConvertTo-QueueItem -Record $_ })
    external_output_allowed = (
        $null -ne $trigger -and
        [string]$trigger.state -eq "Processing" -and
        $DependenciesReviewed -and
        $BlockingMessageId.Count -eq 0 -and
        -not $trigger.administrative_closure
    )
}

$result | ConvertTo-Json -Depth 10
