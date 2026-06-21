$ErrorActionPreference = "Stop"

$base = "C:\Codex\Wiki Files\Project Rooms\Project Management Spreadsheet Redesign"
$template = Join-Path $base "template-reference\Project Management - empty template from Pond Excel-native labels-safe 20260530_163443.xlsm"
$source = Join-Path $base "sources\17_Project Management - 3413 Pinetree Ln - source.xlsx"
$stamp = Get-Date -Format "yyyyMMdd_HHmmss"
$output = Join-Path $base "Need Verification\17_Project Management - 3413 Pinetree Ln - mode2 retry seven-gate $stamp.xlsm"
$summary = Join-Path $base "Need Verification\Pinetree mode2 retry seven-gate summary $stamp.md"

Copy-Item -LiteralPath $template -Destination $output -Force

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
    } elseif ($value -is [datetime]) {
        $cell.Value = $value
    } elseif ($value -is [decimal] -or $value -is [int] -or $value -is [long] -or $value -is [float] -or $value -is [double]) {
        $cell.Value2 = [double]$value
    } else {
        $cell.Value = $value
    }
}

function Set-Formula($ws, [string]$address, [string]$formula) {
    $cell = Cell-ForWrite $ws $address
    $cell.Formula = $formula
}

function Clear-ConstantsOnly($ws, [string]$address) {
    try {
        $constants = $ws.Range($address).SpecialCells(2)
        $constants.ClearContents()
    } catch {
        # no constants
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

$targetWb = $null
$sourceWb = $null
$verifyWb = $null
try {
    $targetWb = $excel.Workbooks.Open($output, 0, $false)
    $sourceWb = $excel.Workbooks.Open($source, 0, $true)
    $srcProfit = $sourceWb.Worksheets.Item("Profit")
    $profit = $targetWb.Worksheets.Item("Profit")
    $amort = $targetWb.Worksheets.Item("Amortization")

    $cma = [double]$srcProfit.Range("B4").Value2
    $deposit = $srcProfit.Range("B7").Value2
    if ($null -eq $deposit) { $deposit = 0 }
    Set-Value $amort "M4" $srcProfit.Range("C5").Value2
    if ($cma -ne 0) {
        Set-Value $amort "P2" ([double]$deposit / $cma)
        Set-Value $amort "Q2" ([double]$deposit / $cma)
        Set-Value $amort "R2" ([double]$deposit / $cma)
    }
    Set-Value $amort "AW2" 1

    Set-Value $profit "R3" 2
    Set-Value $profit "B2" "3413 Pinetree Ln"
    Set-Value $profit "E2" "Greenville NC, 27858"
    Set-Value $profit "G2" ""
    Set-Value $profit "B4" $srcProfit.Range("B4").Value2
    Set-Value $profit "C5" $srcProfit.Range("C5").Value2
    Set-Value $profit "B9" $srcProfit.Range("B8").Value2
    Set-Value $profit "K7" $srcProfit.Range("K6").Value2
    Set-Value $profit "K9" $srcProfit.Range("K8").Value2
    Set-Value $profit "K13" (($srcProfit.Range("K4").Text).Trim().ToLower() -eq "yes")
    Set-Value $profit "C14" $srcProfit.Range("B12").Value2
    Set-Value $profit "B15" $srcProfit.Range("B13").Value2
    Set-Value $profit "C15" $srcProfit.Range("C13").Value2
    Set-Value $profit "B17" $srcProfit.Range("B15").Value2
    Set-Value $profit "C17" $srcProfit.Range("C15").Value2
    Set-Value $profit "C18" $srcProfit.Range("C16").Value2
    Set-Value $profit "B25" $srcProfit.Range("B17").Value2
    Set-Value $profit "C20" $srcProfit.Range("B18").Value2
    Set-Value $profit "C26" $srcProfit.Range("C19").Value2
    Set-Value $profit "B28" $srcProfit.Range("B20").Value2
    Set-Value $profit "B43" $srcProfit.Range("B28").Value2
    Set-Value $profit "C43" (($srcProfit.Range("C28").Text).Trim().ToLower() -in @("yes","true","1"))
    Set-Value $profit "B46" $srcProfit.Range("B31").Value2
    Set-Value $profit "Q1" $false
    Set-Value $profit "Q2" $false
    Set-Value $profit "Q3" ([bool]$srcProfit.Range("B32").Value2)
    Set-Value $profit "C47" $srcProfit.Range("C32").Value2
    Set-Value $profit "Q4" ([bool]$srcProfit.Range("B33").Value2)
    Set-Value $profit "C49" $srcProfit.Range("C33").Value2
    Set-Value $profit "Q5" ([bool]$srcProfit.Range("B34").Value2)
    Set-Value $profit "C48" $srcProfit.Range("C34").Value2
    Set-Value $profit "C50" $srcProfit.Range("C35").Value2
    Set-Value $profit "C51" $srcProfit.Range("C36").Value2
    Set-Value $profit "B59" $srcProfit.Range("B44").Value2
    Set-Value $profit "B60" $srcProfit.Range("B45").Value2
    Set-Value $profit "B65" $srcProfit.Range("B49").Value2

    # Critical retry corrections.
    Set-Value $profit "Q6" $false
    Set-Value $profit "Q12" (($srcProfit.Range("K4").Text).Trim().ToLower() -eq "yes")
    Set-Formula $profit "B6" '=IF(B1="Flip",B4,IF(C1="hold",B4*(1+C5),+Amortization!O3))'
    Set-Formula $profit "D15" '=-C15'
    Set-Formula $profit "D17" '=-C17'
    Set-Formula $profit "D18" '=-C18'
    Set-Formula $profit "D20" '=-C20'
    Set-Formula $profit "B21" '=-SUM(D14:D20)-F19'
    Set-Formula $profit "F15" '=IF(OR($R$3=1,$R$3=2,$R$3=3),IF(OR($R$3=1,$R$3=2),-C15,Amortization!AI9),0)'

    # The old source's rehab truth is its Gantt summary. Do not copy old vendor tabs
    # into the modern vendor tabs because column meanings differ.
    Set-Value $profit "B64" $srcProfit.Range("B48").Value2
    Set-Formula $profit "D64" '=-B64'
    Set-Formula $profit "B66" '=IF(Q12<>TRUE,+B65*SUM(B64:C64),0)'
    Set-Formula $profit "D66" '=-B66'
    Set-Formula $profit "D67" '=+SUM(D64:E66)'

    $srcProposal = $sourceWb.Worksheets.Item("ProposalUpdate")
    $contract = $targetWb.Worksheets.Item("Contract")
    Clear-ConstantsOnly $contract "A2:H214"
    $targetRow = 2
    for ($r = 5; $r -le $srcProposal.UsedRange.Rows.Count; $r++) {
        $party = $srcProposal.Cells.Item($r, 1).Value2
        $item = $srcProposal.Cells.Item($r, 2).Value2
        $costCode = $srcProposal.Cells.Item($r, 3).Value2
        $title = $srcProposal.Cells.Item($r, 4).Value2
        $desc = $srcProposal.Cells.Item($r, 5).Value2
        $qty = $srcProposal.Cells.Item($r, 6).Value2
        $unitPrice = $srcProposal.Cells.Item($r, 7).Value2
        if ($null -ne $party -or $null -ne $item -or $null -ne $costCode -or $null -ne $title -or $null -ne $desc -or $null -ne $qty -or $null -ne $unitPrice) {
            if ($null -eq $item) { $item = $targetRow - 1 }
            $assigned = "Buy Your Home"
            if (($party -as [string]).Trim().ToLower() -eq "glasgow") { $assigned = "Glasgow DB" }
            Set-Value $contract ("A" + $targetRow) $item
            Set-Value $contract ("B" + $targetRow) $costCode
            Set-Value $contract ("C" + $targetRow) $title
            Set-Value $contract ("D" + $targetRow) $desc
            Set-Value $contract ("E" + $targetRow) $qty
            Set-Value $contract ("F" + $targetRow) $unitPrice
            Set-Value $contract ("G" + $targetRow) $assigned
            Set-Value $contract ("H" + $targetRow) $item
            $targetRow++
        }
    }

    $targetWb.ForceFullCalculation = $true
    $targetWb.RefreshAll()
    $excel.CalculateFullRebuild()
    $targetWb.Save()
    $targetWb.Close($true)
    $targetWb = $null
    $sourceWb.Close($false)
    $sourceWb = $null

    $verifyWb = $excel.Workbooks.Open($output, 0, $true)
    $excel.CalculateFullRebuild()
    $vProfit = $verifyWb.Worksheets.Item("Profit")
    $vGantt = $verifyWb.Worksheets.Item("Gnatt Chart")
    $checks = [ordered]@{
        Output = $output
        TotalCMA = (Read-Cell $vProfit "B4")
        TotalPurchaseCost = (Read-Cell $vProfit "K47")
        TotalRehabExpense = (Read-Cell $vProfit "D67")
        TotalDebt = (Read-Cell $vProfit "K44")
        MonthlyCarryingCost = (Read-Cell $vProfit "K41")
        MonthlyIncome = (Read-Cell $vProfit "I55")
        TotalProfit = (Read-Cell $vProfit "I58")
        ProfitB6 = $vProfit.Range("B6").Formula
        ProfitF15 = $vProfit.Range("F15").Formula
        ProfitQ6 = $vProfit.Range("Q6").Formula
        ProfitB64 = (Read-Cell $vProfit "B64")
        ProfitD67 = (Read-Cell $vProfit "D67")
        GnattI2 = $vGantt.Range("I2").Formula
        ContractRowsLoaded = ($targetRow - 2)
        Note = "Skipped old-source vendor-tab copy because old and modern vendor tab columns do not align."
    }
    $verifyWb.Close($false)
    $verifyWb = $null

    $lines = @(
        "# Pinetree Mode 2 Retry Seven-Gate",
        "",
        "Output workbook: ``$output``",
        "",
        "Created from the labels-safe empty template. This retry skips copying old source vendor tabs into modern vendor tabs because their column meanings do not align. It disables unmapped template estimates and maps the old source rehab truth from source Profit/Gantt summary into the new Profit rehab summary path.",
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
    if ($null -ne $verifyWb) { try { $verifyWb.Close($false) } catch {} }
    if ($null -ne $sourceWb) { try { $sourceWb.Close($false) } catch {} }
    if ($null -ne $targetWb) { try { $targetWb.Close($false) } catch {} }
    if ($null -ne $excel) {
        try { $excel.Quit() } catch {}
        [System.Runtime.InteropServices.Marshal]::ReleaseComObject($excel) | Out-Null
    }
    [GC]::Collect()
    [GC]::WaitForPendingFinalizers()
}
