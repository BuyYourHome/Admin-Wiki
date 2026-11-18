[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [string[]]$MessageId,
    [string]$QueuePath = '\\WES-VIDEOEDITOR\BYH-PRMessaging$',
    [switch]$FailIfUnfinished
)

$ErrorActionPreference = 'Stop'
$manager = 'C:\Codex\Wiki Files\tools\pr-messaging\Manage-ProjectRoomMessage.ps1'
$taskId = '01a03956-fa4f-77c1-9ab7-f709e5f1174e'
$identity = (& whoami.exe).Trim()
$machine = $env:COMPUTERNAME
if ($QueuePath -ceq '\\WES-VIDEOEDITOR\BYH-PRMessaging$') {
    if ($identity -ine 'OfficeAssist\OfficeAssistLogin' -or $machine -ine 'OFFICEASSIST') {
        throw "Messaging context mismatch: $identity / $machine"
    }
} else {
    # Tests may read only explicitly marked temporary fixtures, never another share.
    $fixtureRoot = [IO.Path]::GetFullPath($QueuePath).TrimEnd('\')
    $tempRoot = [IO.Path]::GetFullPath([IO.Path]::GetTempPath()).TrimEnd('\') + '\'
    if (!$fixtureRoot.StartsWith($tempRoot, [StringComparison]::OrdinalIgnoreCase) -or
        !(Test-Path -LiteralPath (Join-Path $fixtureRoot '.invoice-entry-run-closure-fixture'))) {
        throw 'Only the canonical queue or a marked temporary test fixture is supported.'
    }
}
. 'C:\Codex\Wiki Files\tools\pr-messaging\Message-Integrity.ps1'

$outcomes = @()
$attention = @()
$ids = @($MessageId | Select-Object -Unique)
foreach ($id in $ids) {
    $reason = $null
    $owner = 'Invoice Entry'
    $nextAction = 'Continue the exact request or record a specific blocker and responsible owner.'
    $requiresUser = $false
    $record = $null
    try {
        $record = (& $manager -Action Get -QueuePath $QueuePath -MessageId $id) | ConvertFrom-Json
        if ($record.message_id -cne $id -or $record.authoritative -ne $true -or !(Test-PrMessageHashValid $record)) {
            $reason = 'RecordIntegrityFailure'
        } elseif ($record.destination.task_id -cne $taskId -or
            $record.destination.project_room -cne 'Invoice Entry' -or
            $record.destination.machine -cne 'OFFICEASSIST') {
            $reason = 'DestinationMismatch'
        } elseif (!$record.receipt -or $record.receipt.payload_hash -cne $record.payload_hash -or
            $record.receipt.message_id -cne $record.message_id) {
            $reason = 'MissingOrMismatchedAcceptanceReceipt'
        } elseif ($record.state -in @('Accepted', 'Processing')) {
            $reason = 'AcceptedWorkHasNoFinalOutcome'
        } elseif (!(Test-PrMessageTerminal $record) -or
            [string]::IsNullOrWhiteSpace([string]$record.result.detail)) {
            $reason = 'MissingOrInvalidFinalOutcome'
        } elseif ($record.state -in @('Blocked', 'Needs Wes')) {
            $owner = [string]$record.result.data.blocker_owner
            $nextAction = [string]$record.result.data.next_action
            if ([string]::IsNullOrWhiteSpace($nextAction)) {
                $nextAction = [string]$record.result.data.remaining
            }
            if ([string]::IsNullOrWhiteSpace($owner) -or [string]::IsNullOrWhiteSpace($nextAction)) {
                $reason = 'BlockerHasNoOwnerOrNextAction'
                $owner = 'Invoice Entry'
                $nextAction = 'Record the exact blocker, responsible owner, and next action without repeating a business action.'
            } else {
                $requiresUser = $record.state -ceq 'Needs Wes'
            }
        }
    } catch {
        $reason = 'CanonicalReadFailed'
        $nextAction = $_.Exception.Message
    }
    $state = if ($record) { [string]$record.state } else { 'Unknown' }
    $outcomes += [pscustomobject][ordered]@{
        message_id = $id; state = $state; valid_run_outcome = !$reason; failure = $reason
    }
    if ($reason -or $state -in @('Blocked', 'Needs Wes')) {
        $attention += [pscustomobject][ordered]@{
            message_id = $id; state = $state; reason = $reason
            owner = $owner; required_action = $nextAction
            requires_user_attention = $requiresUser
            central_record_reference = (Join-Path (Join-Path $QueuePath 'records') "$id.json")
        }
    }
}
$failed = @($outcomes | Where-Object { !$_.valid_run_outcome })
[pscustomobject][ordered]@{
    checked_at_utc = [DateTime]::UtcNow.ToString('o')
    identity = $identity; machine = $machine
    can_end_run = $failed.Count -eq 0
    checked_count = $ids.Count; unfinished_or_invalid_count = $failed.Count
    business_completion_inferred = $false
    outcomes = $outcomes; attention_items = $attention
} | ConvertTo-Json -Depth 10
if ($FailIfUnfinished -and $failed.Count) {
    throw "InvoiceEntryRunIncomplete: $($failed.Count) exact record(s) lack a verified result or an owned actionable blocker."
}
