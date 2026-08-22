[CmdletBinding()]
param(
    [string]$QueueRoot = "\\WES-VIDEOEDITOR\BYH-PRMessaging$",
    [switch]$AsJson
)

$recordsPath = Join-Path $QueueRoot "records"
if (-not (Test-Path -LiteralPath $recordsPath)) {
    throw "Project Room messaging host is unavailable at $QueueRoot."
}

$records = @(
    Get-ChildItem -LiteralPath $recordsPath -Filter "*.json" -File -ErrorAction Stop |
        ForEach-Object { Get-Content -LiteralPath $_.FullName -Raw | ConvertFrom-Json }
)

$pendingStates = @("Pending Host", "Queued", "Delivery Attempted", "Delivery Ambiguous", "Accepted", "Processing")
$summary = [ordered]@{
    host = $QueueRoot
    checked_at = [DateTime]::UtcNow.ToString("o")
    total_messages = $records.Count
    pending_messages = @($records | Where-Object { $_.state -in $pendingStates }).Count
    needs_wes = @($records | Where-Object { $_.state -eq "Needs Wes" }).Count
    blocked = @($records | Where-Object { $_.state -eq "Blocked" }).Count
    delivery_ambiguous = @($records | Where-Object { $_.state -eq "Delivery Ambiguous" }).Count
    rejected_wrong_room = @($records | Where-Object { $_.state -eq "Rejected as Wrong Room" }).Count
    by_state = [ordered]@{}
}

foreach ($group in @($records | Group-Object -Property state | Sort-Object Name)) {
    $summary.by_state[$group.Name] = $group.Count
}

if ($AsJson) {
    $summary | ConvertTo-Json -Depth 5
} else {
    [pscustomobject]$summary
}
