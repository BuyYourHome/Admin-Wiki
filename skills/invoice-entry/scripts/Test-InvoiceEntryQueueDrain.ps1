[CmdletBinding()]
param()

$ErrorActionPreference = "Stop"
$testRoot = Join-Path $env:TEMP ("invoice-entry-queue-drain-" + [guid]::NewGuid().ToString("N"))
$queuePath = Join-Path $testRoot "queue"
$recordsPath = Join-Path $queuePath "records"
$helperPath = Join-Path $PSScriptRoot "Get-InvoiceEntryQueueDrain.ps1"
$managerPath = "C:\Codex\Wiki Files\tools\pr-messaging\Manage-ProjectRoomMessage.ps1"
$taskId = "01a03956-fa4f-77c1-9ab7-f709e5f1174e"

function Assert-Equal {
    param($Expected, $Actual, [string]$Message)
    if ($Expected -ne $Actual) {
        throw "$Message Expected '$Expected', received '$Actual'."
    }
}

function Write-TestRecord {
    param([string]$MessageId, [string]$State, [DateTime]$Created, [string]$Task = $taskId)
    [ordered]@{
        message_id = $MessageId
        dispatch_id = "dispatch-$MessageId"
        payload_hash = ("a" * 64)
        state = $State
        created_at_utc = $Created.ToUniversalTime().ToString("o")
        destination = [ordered]@{
            project_room = "Invoice Entry"
            task_id = $Task
            machine = "OFFICEASSIST"
        }
    } | ConvertTo-Json -Depth 8 | Set-Content -LiteralPath (Join-Path $recordsPath "$MessageId.json") -Encoding UTF8
}

try {
    New-Item -ItemType Directory -Path $recordsPath -Force | Out-Null
    $now = [DateTime]::UtcNow
    Write-TestRecord -MessageId "older-b" -State "Accepted" -Created $now.AddHours(-3)
    Write-TestRecord -MessageId "older-a" -State "Queued" -Created $now.AddHours(-3)
    Write-TestRecord -MessageId "completed-old" -State "Completed" -Created $now.AddHours(-4)
    Write-TestRecord -MessageId "trigger" -State "Processing" -Created $now.AddHours(-1)
    Write-TestRecord -MessageId "newer" -State "Queued" -Created $now.AddMinutes(-10)
    Write-TestRecord -MessageId "other-task" -State "Queued" -Created $now.AddHours(-5) -Task "other-task"

    $first = & $helperPath -ManagerPath $managerPath -QueuePath $queuePath -TriggerMessageId "trigger" | ConvertFrom-Json
    Assert-Equal 2 $first.older_unresolved_count "Older unresolved count is wrong."
    Assert-Equal "older-a" $first.older_unresolved[0].message_id "Equal-time ordering must use message ID."
    Assert-Equal "older-b" $first.older_unresolved[1].message_id "Equal-time ordering must use message ID."
    Assert-Equal 3 $first.aged_unresolved_count "Aged watchdog count is wrong."
    Assert-Equal $false $first.external_output_allowed "Output requires explicit dependency review."

    $reviewed = & $helperPath -ManagerPath $managerPath -QueuePath $queuePath -TriggerMessageId "trigger" -DependenciesReviewed | ConvertFrom-Json
    Assert-Equal $true $reviewed.external_output_allowed "Unrelated older work must not gate a reviewed new request."
    $blocked = & $helperPath -ManagerPath $managerPath -QueuePath $queuePath -TriggerMessageId "trigger" -DependenciesReviewed -BlockingMessageId "older-b" | ConvertFrom-Json
    Assert-Equal $false $blocked.external_output_allowed "A genuine dependency must still block output."
    $queued = & $helperPath -ManagerPath $managerPath -QueuePath $queuePath -TriggerMessageId "newer" -DependenciesReviewed | ConvertFrom-Json
    Assert-Equal $false $queued.external_output_allowed "Unaccepted queued work cannot produce output."

    (Get-Content -Raw -LiteralPath (Join-Path $recordsPath "older-a.json") | ConvertFrom-Json) | ForEach-Object {
        $_.state = "Completed"
        $_ | ConvertTo-Json -Depth 8 | Set-Content -LiteralPath (Join-Path $recordsPath "older-a.json") -Encoding UTF8
    }
    (Get-Content -Raw -LiteralPath (Join-Path $recordsPath "older-b.json") | ConvertFrom-Json) | ForEach-Object {
        $_.state = "Needs Wes"
        $_ | ConvertTo-Json -Depth 8 | Set-Content -LiteralPath (Join-Path $recordsPath "older-b.json") -Encoding UTF8
    }

    $second = & $helperPath -ManagerPath $managerPath -QueuePath $queuePath -TriggerMessageId "trigger" -DependenciesReviewed | ConvertFrom-Json
    Assert-Equal 0 $second.older_unresolved_count "Terminal older records must clear the gate."
    Assert-Equal $true $second.external_output_allowed "A processing trigger with no older unresolved records must allow output."
    Assert-Equal 2 $second.all_unresolved_count "Only trigger and newer record should remain unresolved."

    [pscustomobject][ordered]@{
        passed = $true
        initial_older = $first.older_unresolved_count
        final_older = $second.older_unresolved_count
        output_allowed = $second.external_output_allowed
        aged_after_terminal = $second.aged_unresolved_count
    } | ConvertTo-Json
}
finally {
    if (Test-Path -LiteralPath $testRoot) {
        Remove-Item -LiteralPath $testRoot -Recurse -Force
    }
}
