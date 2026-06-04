$ErrorActionPreference = "Stop"

$base = "C:\Codex\Wiki Files\Project Rooms\Pinetree Project Management Conversion"
$sourceWorkbook = Join-Path $base "Need Verification\17_Project Management - 3413 Pinetree Ln - mode2 retry seven-gate 20260531_104328.xlsm"
$stamp = Get-Date -Format "yyyyMMdd_HHmmss"
$output = Join-Path $base "Need Verification\17_Project Management - 3413 Pinetree Ln - mode2 retry seven-gate refreshed $stamp.xlsm"
$summary = Join-Path $base "Need Verification\Pinetree mode2 retry seven-gate refreshed summary $stamp.md"

Copy-Item -LiteralPath $sourceWorkbook -Destination $output -Force

$excel = New-Object -ComObject Excel.Application
$excel.Visible = $false
$excel.DisplayAlerts = $false
$excel.EnableEvents = $false
$excel.AskToUpdateLinks = $false

function Read-Cell($ws, [string]$address) {
    $cell = $ws.Range($address)
    return [ordered]@{
        Formula = [string]$cell.Formula
        Text = [string]$cell.Text
        Value = $cell.Value2
    }
}

function Wait-Excel($excel) {
    try { $excel.CalculateUntilAsyncQueriesDone() } catch {}
    $deadline = (Get-Date).AddMinutes(5)
    while ((Get-Date) -lt $deadline) {
        try {
            if ($excel.CalculationState -eq 0 -and -not $excel.Ready) {
                Start-Sleep -Milliseconds 500
            } elseif ($excel.CalculationState -eq 0) {
                break
            } else {
                Start-Sleep -Milliseconds 500
            }
        } catch {
            Start-Sleep -Milliseconds 500
            break
        }
    }
}

$wb = $null
try {
    $wb = $excel.Workbooks.Open($output, 0, $false)

    foreach ($conn in @($wb.Connections)) {
        try { $conn.OLEDBConnection.BackgroundQuery = $false } catch {}
        try { $conn.ODBCConnection.BackgroundQuery = $false } catch {}
    }

    foreach ($ws in @($wb.Worksheets)) {
        foreach ($qt in @($ws.QueryTables)) {
            try { $qt.BackgroundQuery = $false } catch {}
            try { $qt.Refresh($false) | Out-Null } catch {}
        }
        foreach ($lo in @($ws.ListObjects)) {
            try { $lo.QueryTable.BackgroundQuery = $false } catch {}
            try { $lo.QueryTable.Refresh($false) | Out-Null } catch {}
        }
    }

    foreach ($conn in @($wb.Connections)) {
        try { $conn.Refresh() | Out-Null } catch {}
        Wait-Excel $excel
    }

    $wb.RefreshAll()
    Wait-Excel $excel
    $excel.CalculateFullRebuild()
    Wait-Excel $excel

    $profit = $wb.Worksheets.Item("Profit")
    $gantt = $wb.Worksheets.Item("Gnatt Chart")
    $checks = [ordered]@{
        Output = $output
        TotalCMA = Read-Cell $profit "B4"
        TotalPurchaseCost = Read-Cell $profit "K47"
        TotalRehabExpense = Read-Cell $profit "D67"
        TotalDebt = Read-Cell $profit "K44"
        MonthlyCarryingCost = Read-Cell $profit "K41"
        MonthlyIncome = Read-Cell $profit "I55"
        TotalProfit = Read-Cell $profit "I58"
        ProfitB64 = Read-Cell $profit "B64"
        ProfitD67 = Read-Cell $profit "D67"
        GnattI2 = Read-Cell $gantt "I2"
        GnattI3 = Read-Cell $gantt "I3"
        GnattI4 = Read-Cell $gantt "I4"
        GnattI5 = Read-Cell $gantt "I5"
        GnattI6 = Read-Cell $gantt "I6"
        ContractRowsVisible = $wb.Worksheets.Item("Contract").Range("A2").CurrentRegion.Rows.Count - 1
    }

    $wb.Save()
    $wb.Close($true)
    $wb = $null

    $lines = @(
        "# Pinetree Retry Seven-Gate Refreshed",
        "",
        "Output workbook: ``$output``",
        "",
        "This copy was refreshed after Contract table data was already loaded. Refresh steps forced query/listobject connection refreshes to run in foreground where Excel exposed that option, waited for async queries, then performed full recalculation.",
        "",
        "## Checks",
        ""
    )
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
    [GC]::Collect()
    [GC]::WaitForPendingFinalizers()
}
