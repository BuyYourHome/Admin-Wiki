$ErrorActionPreference = "Stop"

$base = "C:\Codex\Wiki Files\Project Rooms\Pinetree Project Management Conversion"
$input = Join-Path $base "Need Verification\17_Project Management - 3413 Pinetree Ln - mode2 retry seven-gate 20260531_104328.xlsm"
$source = Join-Path $base "sources\17_Project Management - 3413 Pinetree Ln - source.xlsx"
$stamp = Get-Date -Format "yyyyMMdd_HHmmss"
$output = Join-Path $base "Need Verification\17_Project Management - 3413 Pinetree Ln - mode2 retry hold-cache $stamp.xlsm"
$summary = Join-Path $base "Need Verification\Pinetree mode2 retry hold-cache summary $stamp.md"

Copy-Item -LiteralPath $input -Destination $output -Force

$excel = New-Object -ComObject Excel.Application
$excel.Visible = $false
$excel.DisplayAlerts = $false
$excel.EnableEvents = $false
$excel.AskToUpdateLinks = $false

function Cell-ForWrite($ws, [string]$address) {
    $cell = $ws.Range($address)
    if ([bool]$cell.MergeCells) { $cell = $cell.MergeArea.Cells.Item(1, 1) }
    return $cell
}

function Set-Value($ws, [string]$address, $value) {
    $cell = Cell-ForWrite $ws $address
    if ($value -is [bool]) {
        $cell.Formula = $(if ($value) { "TRUE" } else { "FALSE" })
    } elseif ($value -is [string]) {
        $cell.Formula = $value
    } elseif ($value -is [decimal] -or $value -is [int] -or $value -is [long] -or $value -is [float] -or $value -is [double]) {
        $cell.Value2 = [double]$value
    } else {
        $cell.Value = $value
    }
}

function Set-Formula($ws, [string]$address, [string]$formula) {
    (Cell-ForWrite $ws $address).Formula = $formula
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

    $sourceMonthlyCarry = 0.0
    foreach ($addr in @("B21","B22","B23","B24","B25","B26")) {
        $v = $srcProfit.Range($addr).Value2
        if ($null -ne $v) { $sourceMonthlyCarry += [double]$v }
    }
    $sourceTotalCarry = [double]$srcProfit.Range("B20").Value2 * $sourceMonthlyCarry

    Set-Value $profit "R3" 2
    Set-Value $profit "Q1" $false
    Set-Value $profit "Q2" $false
    Set-Value $profit "Q6" $false
    Set-Value $profit "Q12" (($srcProfit.Range("K4").Text).Trim().ToLower() -eq "yes")
    Set-Formula $profit "D15" '=-C15'
    Set-Formula $profit "D17" '=-C17'
    Set-Formula $profit "D18" '=-C18'
    Set-Formula $profit "D20" '=-C20'
    Set-Formula $profit "B21" '=-SUM(D14:D20)-F19'
    Set-Formula $profit "B6" '=IF(B1="Flip",B4,IF(C1="hold",B4*(1+C5),+Amortization!O3))'
    Set-Formula $profit "F15" '=IF(OR($R$3=1,$R$3=2,$R$3=3),IF(OR($R$3=1,$R$3=2),-C15,Amortization!AI9),0)'

    foreach ($addr in @("B25","E25","H25","K25","N25","Q25","T25","W25","Z25","AC25","AF25")) {
        Set-Value $carrying $addr 0
    }
    Set-Value $carrying "E25" $sourceTotalCarry

    Set-Value $profit "B64" $srcProfit.Range("B48").Value2
    Set-Formula $profit "D64" '=-B64'
    Set-Formula $profit "B66" '=IF(Q12<>TRUE,+B65*SUM(B64:C64),0)'
    Set-Formula $profit "D66" '=-B66'
    Set-Formula $profit "D67" '=+SUM(D64:E66)'

    try { $wb.RefreshAll() } catch {}
    try { $excel.CalculateUntilAsyncQueriesDone() } catch {}
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
        ScenarioR3 = Read-Cell $profit "R3"
        ScenarioB1 = Read-Cell $profit "B1"
        ScenarioC1 = Read-Cell $profit "C1"
        TotalCMA = Read-Cell $profit "B4"
        TotalPurchaseCost = Read-Cell $profit "K47"
        TotalRehabExpense = Read-Cell $profit "D67"
        TotalDebt = Read-Cell $profit "K44"
        MonthlyCarryingCost = Read-Cell $profit "K41"
        MonthlyIncome = Read-Cell $profit "I55"
        TotalProfit = Read-Cell $profit "I58"
        SourceMonthlyCarry = $sourceMonthlyCarry
        SourceTotalCarry = $sourceTotalCarry
        GnattI6 = Read-Cell $gantt "I6"
        Note = "Scenario locked to Hold; carrying fed via Carrying!E25 from old source monthly carrying; Profit rehab source-mapped because modern Gantt remains non-equivalent for old source vendor tabs."
    }
    $wb.Close($false)
    $wb = $null

    $lines = @(
        "# Pinetree Mode 2 Retry Hold Cache",
        "",
        "Output workbook: ``$output``",
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
