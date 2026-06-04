$ErrorActionPreference = "Stop"

$base = "C:\Codex\Wiki Files\Project Rooms\Pinetree Project Management Conversion"
$template = Join-Path $base "template-reference\Project Management - empty template from Pond Excel-native labels-safe 20260530_163443.xlsm"
$source = Join-Path $base "sources\17_Project Management - 3413 Pinetree Ln - source.xlsx"
$output = Join-Path $base "Need Verification\17_Project Management - 3413 Pinetree Ln - current conversion review.xlsm"
$summary = Join-Path $base "Need Verification\Pinetree current conversion review summary.md"

Copy-Item -LiteralPath $template -Destination $output -Force

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
    (Cell-ForWrite $ws $address).Formula = $formula
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
    return [ordered]@{ Formula = [string]$cell.Formula; Text = [string]$cell.Text; Value = $cell.Value2 }
}

function Clear-TableBody($table) {
    if ($null -ne $table.DataBodyRange) {
        $table.DataBodyRange.ClearContents()
    }
}

function Set-TableValue($table, [int]$row, [int]$col, $value) {
    if ($row -gt $table.ListRows.Count) {
        $table.ListRows.Add() | Out-Null
    }
    $cell = $table.DataBodyRange.Cells.Item($row, $col)
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

function Rebuild-GanttCache($targetWb, $sourceWb) {
    $sourceGantt = $sourceWb.Worksheets.Item("Gnatt Chart")
    $targetGantt = $targetWb.Worksheets.Item("Gnatt Chart")
    $contract = $targetWb.Worksheets.Item("Contract").ListObjects.Item("tblContractBase")
    $tabsSummary = $targetGantt.ListObjects.Item("TabsSummary")
    $contractsToGantt = $targetGantt.ListObjects.Item("qryContractsToGnatt")

    Clear-TableBody $tabsSummary
    Clear-TableBody $contractsToGantt

    $outputRow = 1
    for ($r = 8; $r -le 22; $r++) {
        $description = $sourceGantt.Cells.Item($r, 5).Value2
        $qty = $sourceGantt.Cells.Item($r, 6).Value2
        $unitPrice = $sourceGantt.Cells.Item($r, 7).Value2
        $price = $sourceGantt.Cells.Item($r, 8).Value2
        if ($null -ne $description -or $null -ne $qty -or $null -ne $unitPrice -or $null -ne $price) {
            $idx = 892 + $outputRow
            Set-TableValue $tabsSummary $outputRow 1 "Vendor Tabs"
            Set-TableValue $tabsSummary $outputRow 4 $description
            Set-TableValue $tabsSummary $outputRow 5 $qty
            Set-TableValue $tabsSummary $outputRow 6 $unitPrice
            Set-TableValue $tabsSummary $outputRow 7 $price
            Set-TableValue $tabsSummary $outputRow 10 $idx
            Set-TableValue $tabsSummary $outputRow 13 0
            Set-TableValue $tabsSummary $outputRow 16 "No"
            Set-TableValue $tabsSummary $outputRow 17 0
            Set-TableValue $tabsSummary $outputRow 20 1
            Set-TableValue $tabsSummary $outputRow 22 9999.01
            Set-TableValue $tabsSummary $outputRow 26 "Yes"

            Set-TableValue $contractsToGantt $outputRow 1 "Vendor Tabs"
            Set-TableValue $contractsToGantt $outputRow 4 $description
            Set-TableValue $contractsToGantt $outputRow 5 $qty
            Set-TableValue $contractsToGantt $outputRow 6 $unitPrice
            Set-TableValue $contractsToGantt $outputRow 7 $price
            Set-TableValue $contractsToGantt $outputRow 10 $idx
            $outputRow++
        }
    }

    for ($r = 1; $r -le $contract.ListRows.Count; $r++) {
        $rowRange = $contract.ListRows.Item($r).Range
        $idx = $rowRange.Cells.Item(1, 1).Value2
        $costCode = $rowRange.Cells.Item(1, 2).Value2
        $title = $rowRange.Cells.Item(1, 3).Value2
        $description = $rowRange.Cells.Item(1, 4).Value2
        $qty = $rowRange.Cells.Item(1, 5).Value2
        $unitPrice = $rowRange.Cells.Item(1, 6).Value2
        $assigned = $rowRange.Cells.Item(1, 7).Value2
        $dependency = $rowRange.Cells.Item(1, 8).Value2
        if ($null -ne $idx -or $null -ne $costCode -or $null -ne $title -or $null -ne $description -or $null -ne $qty -or $null -ne $unitPrice -or $null -ne $assigned) {
            $price = 0
            if ($null -ne $qty -and $null -ne $unitPrice) {
                $price = [double]$qty * [double]$unitPrice
            }
            Set-TableValue $contractsToGantt $outputRow 1 $assigned
            Set-TableValue $contractsToGantt $outputRow 2 $costCode
            Set-TableValue $contractsToGantt $outputRow 3 $title
            Set-TableValue $contractsToGantt $outputRow 4 $description
            Set-TableValue $contractsToGantt $outputRow 5 $qty
            Set-TableValue $contractsToGantt $outputRow 6 $unitPrice
            Set-TableValue $contractsToGantt $outputRow 7 $price
            Set-TableValue $contractsToGantt $outputRow 8 $dependency
            Set-TableValue $contractsToGantt $outputRow 10 $idx
            $outputRow++
        }
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
    $carrying = $targetWb.Worksheets.Item("Carrying")

    $sourceMonthlyCarry = 0.0
    foreach ($addr in @("B21","B22","B23","B24","B25","B26")) {
        $v = $srcProfit.Range($addr).Value2
        if ($null -ne $v) { $sourceMonthlyCarry += [double]$v }
    }
    $sourceTotalCarry = [double]$srcProfit.Range("B20").Value2 * $sourceMonthlyCarry

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
    Set-Value $profit "Q6" $false
    Set-Value $profit "Q12" (($srcProfit.Range("K4").Text).Trim().ToLower() -eq "yes")

    Set-Formula $profit "B6" '=IF(B1="Flip",B4,IF(C1="hold",B4*(1+C5),+Amortization!O3))'
    Set-Formula $profit "D15" '=-C15'
    Set-Formula $profit "D17" '=-C17'
    Set-Formula $profit "D18" '=-C18'
    Set-Formula $profit "D20" '=-C20'
    Set-Formula $profit "B21" '=-SUM(D14:D20)-F19'
    Set-Formula $profit "F15" '=IF(OR($R$3=1,$R$3=2,$R$3=3),IF(OR($R$3=1,$R$3=2),-C15,Amortization!AI9),0)'
    Set-Formula $profit "B64" "='Gnatt Chart'!I6"
    Set-Formula $profit "D64" '=-B64'
    Set-Formula $profit "B66" '=IF(Q12<>TRUE,+B65*SUM(B64:C64),0)'
    Set-Formula $profit "D66" '=-B66'
    Set-Formula $profit "D67" '=+SUM(D64:E66)'

    foreach ($addr in @("B25","E25","H25","K25","N25","Q25","T25","W25","Z25","AC25","AF25")) {
        Set-Value $carrying $addr 0
    }
    Set-Value $carrying "E25" $sourceTotalCarry

    # Buying closing costs: source B53:B70 -> target B69:B86.
    for ($i = 0; $i -le 17; $i++) {
        Set-Value $profit ("B" + (69 + $i)) $srcProfit.Range("B" + (53 + $i)).Value2
    }
    # Selling closing costs: source B74:B81 -> target B90:B97.
    for ($i = 0; $i -le 7; $i++) {
        Set-Value $profit ("B" + (90 + $i)) $srcProfit.Range("B" + (74 + $i)).Value2
    }

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

    # RefreshAll hangs in automation for this workbook, so rebuild the Gantt query output
    # from the Pinetree source rows while preserving Profit's formula path through Gantt.
    Rebuild-GanttCache $targetWb $sourceWb
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
        TotalCMA = Read-Cell $vProfit "B4"
        TotalPurchaseCost = Read-Cell $vProfit "K47"
        TotalRehabExpense = Read-Cell $vProfit "D67"
        TotalDebt = Read-Cell $vProfit "K44"
        MonthlyCarryingCost = Read-Cell $vProfit "K41"
        MonthlyIncome = Read-Cell $vProfit "I55"
        TotalProfit = Read-Cell $vProfit "I58"
        BuyingClosingCostTotal = Read-Cell $vProfit "D87"
        SellingClosingCostTotal = Read-Cell $vProfit "D98"
        ProfitB64 = Read-Cell $vProfit "B64"
        GnattI6 = Read-Cell $vGantt "I6"
        GnattVendorMaterials = Read-Cell $vGantt "I2"
        GnattGlasgow = Read-Cell $vGantt "I3"
        GnattTim = Read-Cell $vGantt "I4"
        GnattBuyYourHome = Read-Cell $vGantt "I5"
        ProfitB6 = $vProfit.Range("B6").Formula
        ProfitF15 = $vProfit.Range("F15").Formula
        ContractRowsLoaded = ($targetRow - 2)
        Note = "B64 preserved as Gantt formula. B53:B70 buying closing costs mapped to B69:B86. Gantt cache rebuilt from Pinetree source rows because Excel query refresh hangs in automation."
    }
    $verifyWb.Close($false)
    $verifyWb = $null

    $lines = @(
        "# Pinetree Current Conversion Review",
        "",
        "Output workbook: ``$output``",
        "",
        "This is the overwrite target for current review. It preserves `Profit!B64` as a formula to the Gantt Chart and includes buying closing costs from source `B53:B70` mapped to target `B69:B86`.",
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
