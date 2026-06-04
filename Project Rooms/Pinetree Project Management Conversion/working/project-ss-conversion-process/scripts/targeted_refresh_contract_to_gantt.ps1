$ErrorActionPreference = "Stop"
$base = "C:\Codex\Wiki Files\Project Rooms\Pinetree Project Management Conversion"
$input = Join-Path $base "Need Verification\17_Project Management - 3413 Pinetree Ln - mode2 retry seven-gate 20260531_104328.xlsm"
$stamp = Get-Date -Format "yyyyMMdd_HHmmss"
$output = Join-Path $base "Need Verification\17_Project Management - 3413 Pinetree Ln - mode2 retry targeted-refresh $stamp.xlsm"
$summary = Join-Path $base "Need Verification\Pinetree mode2 retry targeted-refresh summary $stamp.md"
Copy-Item -LiteralPath $input -Destination $output -Force

$order = @(
    "Query - tblContractBase",
    "Query - tblUpdateContractGlasgow",
    "Query - tblUpdateContractOthers",
    "Query - tbUpdateContractTim",
    "Query - qryUpdateContractDependency",
    "Query - QryUpdateContractGlasgow",
    "Query - qryUpdateContractOthers",
    "Query - qryUpdateContractTim",
    "Query - tblContractDependency",
    "Query - tblContractGlasgow",
    "Query - tblContractOthers",
    "Query - tblContractTim",
    "Query - qryContractsToGnatt",
    "Query - qryGnattToDraws"
)

$excel = New-Object -ComObject Excel.Application
$excel.Visible = $false
$excel.DisplayAlerts = $false
$excel.EnableEvents = $false
$excel.AskToUpdateLinks = $false

function Read-Cell($ws, [string]$address) {
    $cell = $ws.Range($address)
    return [ordered]@{ Formula = [string]$cell.Formula; Text = [string]$cell.Text; Value = $cell.Value2 }
}

$wb = $null
try {
    $wb = $excel.Workbooks.Open($output, 0, $false)
    $log = New-Object System.Collections.Generic.List[string]
    foreach ($name in $order) {
        $log.Add("Refreshing $name")
        try {
            $wb.Connections.Item($name).Refresh() | Out-Null
            try { $excel.CalculateUntilAsyncQueriesDone() } catch {}
            $log.Add("Done $name")
        } catch {
            $log.Add("Failed $name :: $($_.Exception.Message)")
        }
    }
    $excel.CalculateFullRebuild()
    $profit = $wb.Worksheets.Item("Profit")
    $gantt = $wb.Worksheets.Item("Gnatt Chart")
    $checks = [ordered]@{
        Output = $output
        GnattI2 = Read-Cell $gantt "I2"
        GnattI3 = Read-Cell $gantt "I3"
        GnattI4 = Read-Cell $gantt "I4"
        GnattI5 = Read-Cell $gantt "I5"
        GnattI6 = Read-Cell $gantt "I6"
        TotalPurchaseCost = Read-Cell $profit "K47"
        TotalRehabExpense = Read-Cell $profit "D67"
        MonthlyCarryingCost = Read-Cell $profit "K41"
        MonthlyIncome = Read-Cell $profit "I55"
        TotalProfit = Read-Cell $profit "I58"
    }
    $wb.Save()
    $wb.Close($true)
    $wb = $null

    $lines = @(
        "# Pinetree Targeted Contract-To-Gantt Refresh",
        "",
        "Output workbook: ``$output``",
        "",
        "## Refresh Log",
        ""
    )
    foreach ($item in $log) { $lines += "- $item" }
    $lines += ""
    $lines += "## Checks"
    $lines += ""
    foreach ($key in $checks.Keys) {
        $value = $checks[$key]
        if ($value -is [System.Collections.IDictionary]) {
            $lines += "- ${key}: Formula=``$($value.Formula)`` Text=``$($value.Text)`` Value=``$($value.Value)``"
        } else {
            $lines += "- ${key}: ``$value``"
        }
    }
    Set-Content -LiteralPath $summary -Value ($lines -join "`r`n")
    [pscustomobject]$checks | ConvertTo-Json -Depth 6
}
finally {
    if ($null -ne $wb) { try { $wb.Close($false) } catch {} }
    if ($null -ne $excel) {
        try { $excel.Quit() } catch {}
        [System.Runtime.InteropServices.Marshal]::ReleaseComObject($excel) | Out-Null
    }
}
