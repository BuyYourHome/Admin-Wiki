param(
    [string]$RepositoryRoot = 'C:\Codex\Wiki Files'
)

$ErrorActionPreference = 'Stop'
$managerPath = Join-Path $RepositoryRoot 'tools\pr-messaging\Manage-ProjectRoomMessage.ps1'
$transactionRooms = @(
    'Doc Scan',
    'Email Monitor',
    'Invoice Entry',
    'Lowes Order',
    'Marketplace',
    'Quickbooks',
    'Quickbooks Invoice'
)

function Get-SafeText {
    param([object]$Value, [int]$MaximumLength = 700)

    $text = ([string]$Value -replace '\s+', ' ').Trim()
    if ($text.Length -le $MaximumLength) { return $text }
    return $text.Substring(0, $MaximumLength - 3).TrimEnd() + '...'
}

function Get-FirstScalarProperty {
    param(
        [object]$Value,
        [string[]]$Names,
        [int]$Depth = 0
    )

    if ($null -eq $Value -or $Depth -gt 3) { return $null }
    foreach ($name in $Names) {
        $property = $Value.PSObject.Properties[$name]
        if ($property -and $null -ne $property.Value -and $property.Value -isnot [System.Collections.IEnumerable]) {
            return $property.Value
        }
        if ($property -and $property.Value -is [string]) { return $property.Value }
    }
    foreach ($property in $Value.PSObject.Properties) {
        if ($null -eq $property.Value -or $property.Value -is [string] -or $property.Value.GetType().IsPrimitive) { continue }
        $found = Get-FirstScalarProperty -Value $property.Value -Names $Names -Depth ($Depth + 1)
        if ($null -ne $found -and [string]$found) { return $found }
    }
    return $null
}

function Get-AttentionClassification {
    param([object]$Record, [string]$Detail)

    if ($Record.state -eq 'Delivery Ambiguous') { return 'automatic-recovery' }
    if ($Record.state -eq 'Needs Wes') { return 'wes-decision' }
    if ($Detail -match '(?i)access denied|unavailable|unreachable|missing|not retriev|not found|timeout|credential|connector|browser|host|attachment|pdf') {
        return 'system-blocker'
    }
    return 'workflow-blocker'
}

function Get-NextAction {
    param([object]$Record, [string]$Classification)

    switch ($Classification) {
        'automatic-recovery' {
            if ([int]$Record.attempt_count -lt [int]$Record.max_attempts) {
                return 'The destination dispatcher may retry this same record automatically.'
            }
            return 'Automatic attempts are exhausted; the owning Project Room must reconcile delivery.'
        }
        'wes-decision' { return 'Wes must provide the decision described in this record.' }
        'system-blocker' { return 'The owning Project Room should retry after the missing dependency is restored.' }
        default { return 'The owning Project Room must resolve or clarify the documented workflow blocker.' }
    }
}

if (-not (Test-Path -LiteralPath $managerPath)) {
    throw "Canonical Project Room message manager is missing: $managerPath"
}

$recordsJson = (& $managerPath -Action List | Out-String)
$records = if ([string]::IsNullOrWhiteSpace($recordsJson)) { @() } else { @($recordsJson | ConvertFrom-Json) }
$items = [System.Collections.Generic.List[object]]::new()
$latestTerminalByReference = @{}

foreach ($record in $records) {
    if ($record.state -notin @('Completed', 'Rejected as Wrong Room')) { continue }
    $reference = Get-FirstScalarProperty -Value $record.result.data -Names @('invoice', 'invoice_number', 'bill_number', 'transaction_id')
    $referenceText = Get-SafeText -Value $reference -MaximumLength 120
    $referenceKey = if ($referenceText) { $referenceText.ToLowerInvariant() } else { '' }
    if (-not $referenceKey) { continue }
    $current = $latestTerminalByReference[$referenceKey]
    if (-not $current -or [string]$record.updated_at_utc -gt [string]$current.updated_at_utc) {
        $latestTerminalByReference[$referenceKey] = $record
    }
}

foreach ($record in $records) {
    if ($record.state -notin @('Delivery Ambiguous', 'Blocked', 'Needs Wes')) { continue }
    if ($record.payload.synthetic_test -eq $true -or $record.result.data.synthetic_test -eq $true) { continue }
    if ($record.source.project_room -notin $transactionRooms -and $record.destination.project_room -notin $transactionRooms) { continue }
    if ($record.message_id -match '(?i)readiness|profile-migration|docscan-remediation|rollback-review|connector-readiness|browser-readiness|machine-readiness|dispatcher-validation') { continue }

    $detail = Get-SafeText -Value $record.result.detail
    if (-not $detail) {
        $lastEvent = @($record.events | Where-Object { $_.event -eq 'FinalResult' } | Select-Object -Last 1)
        $detail = Get-SafeText -Value $lastEvent.detail
    }
    if (-not $detail) { $detail = 'No safe blocker detail was recorded.' }
    if ($detail -match '(?i)\bsuperseded\b') { continue }

    $classification = Get-AttentionClassification -Record $record -Detail $detail
    $data = $record.result.data
    $amount = Get-FirstScalarProperty -Value $data -Names @('amount', 'total', 'balance_due', 'balance')
    $company = Get-FirstScalarProperty -Value $data -Names @('company', 'company_name', 'entity')
    $project = Get-FirstScalarProperty -Value $data -Names @('project', 'property', 'project_name', 'property_address')
    $reference = Get-FirstScalarProperty -Value $data -Names @('invoice', 'invoice_number', 'bill_number', 'transaction_id')
    $referenceText = Get-SafeText -Value $reference -MaximumLength 120
    $referenceKey = if ($referenceText) { $referenceText.ToLowerInvariant() } else { '' }
    $laterTerminal = if ($referenceKey) { $latestTerminalByReference[$referenceKey] } else { $null }
    if ($laterTerminal -and [string]$laterTerminal.updated_at_utc -gt [string]$record.updated_at_utc) { continue }

    $items.Add([ordered]@{
        messageId = [string]$record.message_id
        state = [string]$record.state
        classification = $classification
        sourceRoom = [string]$record.source.project_room
        destinationRoom = [string]$record.destination.project_room
        destinationMachine = [string]$record.destination.machine
        updatedAt = [string]$record.updated_at_utc
        attemptCount = [int]$record.attempt_count
        maxAttempts = [int]$record.max_attempts
        reference = Get-SafeText -Value $reference -MaximumLength 120
        amount = if ($null -ne $amount -and [string]$amount) { [string]$amount } else { '' }
        company = Get-SafeText -Value $company -MaximumLength 120
        project = Get-SafeText -Value $project -MaximumLength 160
        blocker = $detail
        exactDecision = if ($classification -eq 'wes-decision') { $detail } else { '' }
        nextAction = Get-NextAction -Record $record -Classification $classification
    })
}

$classificationRank = @{ 'wes-decision' = 0; 'automatic-recovery' = 1; 'system-blocker' = 2; 'workflow-blocker' = 3 }
$sorted = @($items | Sort-Object @{ Expression = { $classificationRank[$_.classification] } }, @{ Expression = { $_.updatedAt }; Descending = $true })
$payload = [ordered]@{
    ok = $true
    generatedAtUtc = [DateTime]::UtcNow.ToString('yyyy-MM-ddTHH:mm:ssZ')
    counts = [ordered]@{
        total = $sorted.Count
        wesDecision = @($sorted | Where-Object { $_.classification -eq 'wes-decision' }).Count
        automaticRecovery = @($sorted | Where-Object { $_.classification -eq 'automatic-recovery' }).Count
        systemBlocker = @($sorted | Where-Object { $_.classification -eq 'system-blocker' }).Count
        workflowBlocker = @($sorted | Where-Object { $_.classification -eq 'workflow-blocker' }).Count
    }
    items = $sorted
}

$payload | ConvertTo-Json -Depth 7 -Compress
