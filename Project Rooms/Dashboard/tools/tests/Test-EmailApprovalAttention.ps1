$ErrorActionPreference = 'Stop'
$tools = Split-Path -Parent $PSScriptRoot
$repo = (Resolve-Path -LiteralPath (Join-Path $tools '..\..\..')).Path
Import-Module (Join-Path $tools 'EmailApprovalAttention.psm1') -Force
$tempRoot = (Resolve-Path -LiteralPath ([IO.Path]::GetTempPath())).Path.TrimEnd('\')
$fixture = Join-Path $tempRoot "byh-email-approval-test-$([guid]::NewGuid().ToString('N'))"

function Assert-Case($Condition, $Description) {
    if (!$Condition) { throw "Failed: $Description" }
    Write-Output "Passed: $Description"
}

function Read-Attention {
    & (Join-Path $tools 'Get-TransactionAttention.ps1') -RepositoryRoot $repo -QueuePath $fixture | ConvertFrom-Json
}

function Rejects([scriptblock]$Call, [string]$Pattern) {
    try { & $Call | Out-Null } catch { return $_.Exception.Message -match $Pattern }
    return $false
}

try {
    $records = Join-Path $fixture 'records'
    $null = [IO.Directory]::CreateDirectory($records)
    $null = [IO.Directory]::CreateDirectory((Join-Path $fixture 'health'))
    $bound = @{
        QueuePath = $fixture; ApprovalId = [guid]::NewGuid(); PackageHash = 'a' * 64
        CentralMessageId = 'fixture-email-legacy-approval'; CentralPayloadHash = 'b' * 64
    }
    $direct = @{ QueuePath = $fixture; ApprovalId = [guid]::NewGuid(); PackageHash = 'c' * 64 }
    $uncertain = @{ QueuePath = $fixture; ApprovalId = [guid]::NewGuid(); PackageHash = 'd' * 64 }

    $legacy = @{
        message_id = $bound.CentralMessageId; payload_hash = $bound.CentralPayloadHash; state = 'Needs Wes'
        created_at_utc = '2026-11-17T12:00:00Z'; updated_at_utc = '2026-11-17T12:10:00Z'
        source = @{ project_room = 'Invoice Entry' }; destination = @{ project_room = 'Email Monitor'; machine = 'OFFICEASSIST' }
        result = @{ detail = 'Private fixture content user@example.invalid' }
    }
    $legacyPath = Join-Path $records "$($bound.CentralMessageId).json"
    $legacy | ConvertTo-Json -Depth 6 | Set-Content -LiteralPath $legacyPath -Encoding UTF8
    $transport = $legacy.Clone()
    $transport.message_id = 'fixture-transport-uncertain'
    $transport.state = 'Delivery Ambiguous'
    $transport.result = @{ detail = 'No receipt' }
    $transport | ConvertTo-Json -Depth 6 | Set-Content -LiteralPath (Join-Path $records 'fixture-transport-uncertain.json') -Encoding UTF8
    $initial = Read-Attention
    Assert-Case ($initial.emailApprovalFeed -eq 'not-initialized' -and $initial.counts.wesDecision -eq 1) 'Missing feed is not an empty-snapshot claim; legacy decisions remain visible'
    Assert-Case (Rejects { Set-EmailApprovalSnapshot @bound -State 'approved_awaiting_send' } 'before publishing') 'A fresh ID cannot start as approved'

    $pending = Set-EmailApprovalSnapshot @bound -State 'awaiting_approval'
    $same = Set-EmailApprovalSnapshot @bound -State 'awaiting_approval'
    Assert-Case (([DateTimeOffset]$same.updated_at_utc) -eq ([DateTimeOffset]$pending.updated_at_utc)) 'Unchanged status is idempotent'
    $null = Set-EmailApprovalSnapshot @direct -State 'awaiting_approval'
    $null = Set-EmailApprovalSnapshot @uncertain -State 'submission_uncertain'
    $show = Read-Attention
    $browserJson = $show | ConvertTo-Json -Depth 9
    Assert-Case ($show.counts.wesDecision -eq 2 -and $show.counts.automaticRecovery -eq 2 -and $show.emailApprovalFeed -eq 'available') 'Direct and delegated decisions appear once; uncertain sends and transport stay separate'
    Assert-Case ($browserJson -notmatch 'user@example\.invalid|fixture-email-legacy-approval|package_hash|central_payload_hash|[a-d]{64}') 'Browser receives no package binding or private text from tracked records'

    $wrong = $bound.Clone()
    $wrong.PackageHash = 'e' * 64
    Assert-Case (Rejects { Set-EmailApprovalSnapshot @wrong -State 'approved_awaiting_send' } 'different immutable request') 'Changed package cannot reuse its previous approval ID'
    $null = Set-EmailApprovalSnapshot @bound -State 'approved_awaiting_send'
    $show = Read-Attention
    Assert-Case ($show.counts.wesDecision -eq 1 -and $show.counts.approvedAwaitingSend -eq 1) 'Approval moves to awaiting send and is not counted or hidden as completed'
    Assert-Case (Rejects { Set-EmailApprovalSnapshot @bound -State 'awaiting_approval' } 'Invalid email approval status transition') 'A stale pending update cannot reopen the decision'
    $null = Set-EmailApprovalSnapshot @bound -State 'technical_blocker'
    $show = Read-Attention
    Assert-Case ($show.counts.wesDecision -eq 1 -and $show.counts.systemBlocker -eq 1 -and $show.counts.approvedAwaitingSend -eq 0) 'A send refusal is a separate blocker, not another YES request'
    $null = Set-EmailApprovalSnapshot @bound -State 'sent_verified'
    $null = Set-EmailApprovalSnapshot @direct -State 'declined'
    $show = Read-Attention
    Assert-Case ($show.counts.wesDecision -eq 0 -and $show.counts.approvedAwaitingSend -eq 0 -and $show.counts.total -eq 2) 'Verified and declined items close without resurfacing the old Needs Wes record'
    Assert-Case (Rejects { Set-EmailApprovalSnapshot @direct -State 'awaiting_approval' } 'Invalid email approval status transition') 'Declined decisions cannot be reopened'

    $legacy.payload_hash = 'f' * 64
    $legacy | ConvertTo-Json -Depth 6 | Set-Content -LiteralPath $legacyPath -Encoding UTF8
    Assert-Case ((Read-Attention).counts.wesDecision -eq 1) 'A different central version is not hidden by exact-ID correlation'

    $corrupt = Join-Path (Get-EmailApprovalDirectory $fixture) 'corrupt.json'
    [IO.File]::WriteAllText($corrupt, '{bad fixture')
    Assert-Case ((Read-Attention).emailApprovalFeed -eq 'unavailable') 'Invalid feed data is reported unavailable'
} finally {
    if (Test-Path -LiteralPath $fixture) {
        $resolved = (Resolve-Path -LiteralPath $fixture).Path
        if ((Split-Path -Parent $resolved) -eq $tempRoot -and (Split-Path -Leaf $resolved) -match '^byh-email-approval-test-[0-9a-f]{32}$') {
            Remove-Item -LiteralPath $resolved -Recurse -Force
        }
    }
}
