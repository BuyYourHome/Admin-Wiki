$ErrorActionPreference = "Stop"

$base = "C:\Codex\Wiki Files\Project Rooms\Pinetree Project Management Conversion"
$input = Join-Path $base "Need Verification\17_Project Management - 3413 Pinetree Ln - mode2 retry seven-gate 20260531_104328.xlsm"
$source = Join-Path $base "sources\17_Project Management - 3413 Pinetree Ln - source.xlsx"
$stamp = Get-Date -Format "yyyyMMdd_HHmmss"
$output = Join-Path $base "Need Verification\17_Project Management - 3413 Pinetree Ln - mode2 retry seven-gate carrying-patched $stamp.xlsm"
$summary = Join-Path $base "Need Verification\Pinetree mode2 retry seven-gate carrying-patched summary $stamp.md"

Copy-Item -LiteralPath $input -Destination $output -Force

$excel = New-Object -ComObject Excel.Application
$excel.Visible = $false
$excel.DisplayAlerts = $false
$excel.EnableEvents = $false
$excel.AskToUpdateLinks = $false

function Cell-ForWrite($ws, [string]$address) {
    $cell = $ws.Range($address)
    if ([bool]$cell.MergeCells) {
        $cell = $cell.MergeArea.Cells.Item(1, 1)
    }
    return $cell
}

function Set-Value($ws, [string]$address, $value) {
    $cell = Cell-ForWrite $ws $address
    if ($null -eq $value) {
        $cell.Formula = ""
    } elseif ($value -is [bool]) {
        $cell.Formula = $(if ($value) { "TRUE" } else { "FALSE" })
    } elseif ($value -is [string]) {
        $cell.Formula = $value
    } elseif ($value -is [decimal] -or $value -is [int] -or $value -is [long] -or $value -is [float] -or $value -is [double]) {
        $cell.Value2 = [double]$value
    } else {
        $cell.Value = $value
    }
}

function Read-Cell($ws, [string]$address) {
    $cell = $ws.Range($address)
    return [ordered]@{
        Formula = [string]$cell.Formula
        Text = [string]$cell.Text
        Value = $cell.Value2
    }
}

$wb = $null
$srcWb = $null
try {
    $wb = $excel.Workbooks.Open($output, 0, $false)
    $srcWb = $excel.Workbooks.Open($source, 0, $true)
    $srcProfit = $srcWb.Worksheets.Item("Profit")
    $profit = $wb.Worksheets.Item("Profit")
    $carrying = $wb.Worksheets.Item("Carrying")
    $gantt = $wb.Worksheets.Item("Gnatt Chart")

    $months = [double]$srcProfit.Range("B20").Value2
    $monthlyMortgage = [double]$srcProfit.Range("B21").Value2
    $sourceMonthlyCarry = 0.0
    foreach ($addr in @("B21","B22","B23","B24","B25","B26")) {
        $v = $srcProfit.Range($addr).Value2
        if ($null -ne $v) { $sourceMonthlyCarry += [double]$v }
    }
    $sourceTotalCarry = $months * $sourceMonthlyCarry

    # Preserve Profit formulas by feeding the modern Carrying sheet totals.
    foreach ($addr in @("B25","E25","H25","K25","N25","Q25","T25","W25","Z25","AC25","AF25")) {
        Set-Value $carrying $addr 0
    }
    Set-Value $carrying "E25" $sourceTotalCarry

    $excel.CalculateFullRebuild()
    $wb.Save()
    $wb.Close($true)
    $wb = $null
    $srcWb.Close($false)
    $srcWb = $null

    $wb = $excel.Workbooks.Open($output, 0, $true)
    $excel.CalculateFullRebuild()
    $profit = $wb.Worksheets.Item("Profit")
    $gantt = $wb.Worksheets.Item("Gnatt Chart")
    $checks = [ordered]@{
        Output = $output
        SourceMonthlyCarry = $sourceMonthlyCarry
        SourceTotalCarry = $sourceTotalCarry
        TotalCMA = Read-Cell $profit "B4"
        TotalPurchaseCost = Read-Cell $profit "K47"
        TotalRehabExpense = Read-Cell $profit "D67"
        TotalDebt = Read-Cell $profit "K44"
        MonthlyCarryingCost = Read-Cell $profit "K41"
        MonthlyIncome = Read-Cell $profit "I55"
        TotalProfit = Read-Cell $profit "I58"
        ProfitC42 = Read-Cell $profit "C42"
        ProfitB64 = Read-Cell $profit "B64"
        GnattI6 = Read-Cell $gantt "I6"
        Note = "Carrying sheet fed from source monthly carrying total because source lacks a modern Carrying tab. Gantt remains stale/unreconciled; Profit rehab is source-mapped."
    }
    $wb.Close($false)
    $wb = $null

    $lines = @(
        "# Pinetree Retry Seven-Gate Carrying Patched",
        "",
        "Output workbook: ``$output``",
        "",
        "This copy feeds the modern Carrying sheet from the old source monthly carrying total so `Profit!K41` derives from the source instead of inherited template carrying rows.",
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
    if ($null -ne $srcWb) { try { $srcWb.Close($false) } catch {} }
    if ($null -ne $wb) { try { $wb.Close($false) } catch {} }
    if ($null -ne $excel) {
        try { $excel.Quit() } catch {}
        [System.Runtime.InteropServices.Marshal]::ReleaseComObject($excel) | Out-Null
    }
    [GC]::Collect()
    [GC]::WaitForPendingFinalizers()
}
