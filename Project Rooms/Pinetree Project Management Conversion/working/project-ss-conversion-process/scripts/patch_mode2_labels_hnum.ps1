$ErrorActionPreference = "Stop"

$base = "C:\Codex\Wiki Files\Project Rooms\Pinetree Project Management Conversion"
$sourceMode2 = Join-Path $base "Need Verification\17_Project Management - 3413 Pinetree Ln - mode2 from empty template 20260530_155749.xlsm"
$pond = Join-Path $base "template-reference\26_Project Management - 908 Pond St 3 - template.xlsm"
$stamp = Get-Date -Format "yyyyMMdd_HHmmss"
$output = Join-Path $base "Need Verification\17_Project Management - 3413 Pinetree Ln - mode2 patched labels hnum $stamp.xlsm"
$summary = Join-Path $base "Need Verification\Pinetree mode2 patched labels hnum summary $stamp.md"

Copy-Item -LiteralPath $sourceMode2 -Destination $output -Force

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

function Set-CellFormula($ws, [string]$address, [string]$formula) {
    $cell = Cell-ForWrite $ws $address
    $cell.Formula = $formula
}

$targetWb = $null
$pondWb = $null
$verifyWb = $null
try {
    $targetWb = $excel.Workbooks.Open($output, 0, $false)
    $pondWb = $excel.Workbooks.Open($pond, 0, $true)
    $targetProfit = $targetWb.Worksheets.Item("Profit")
    $pondProfit = $pondWb.Worksheets.Item("Profit")

    foreach ($row in 1..68) {
        $addr = "A$row"
        if ($targetProfit.Range($addr).Text -eq "" -and $pondProfit.Range($addr).Text -ne "") {
            Set-CellFormula $targetProfit $addr $pondProfit.Range($addr).Formula
        }
    }

    # Pinetree has no mapped refinance setup; disable it so H22/H54 do not throw #NUM!.
    Set-CellFormula $targetProfit "Q1" "FALSE"
    Set-CellFormula $targetProfit "Q2" "FALSE"

    # Reconfirm key formulas.
    Set-CellFormula $targetProfit "B6" '=IF(B1="Flip",B4,IF(C1="hold",B4*(1+C5),+Amortization!O3))'
    Set-CellFormula $targetProfit "F15" '=IF(OR($R$3=1,$R$3=2,$R$3=3),IF(OR($R$3=1,$R$3=2),-C15,Amortization!AI9),0)'
    Set-CellFormula $targetProfit "D20" '=-C20'

    $targetWb.Save()
    $targetWb.Close($true)
    $targetWb = $null
    $pondWb.Close($false)
    $pondWb = $null

    $verifyWb = $excel.Workbooks.Open($output, 0, $true)
    $vProfit = $verifyWb.Worksheets.Item("Profit")
    $vGantt = $verifyWb.Worksheets.Item("Gnatt Chart")
    $checks = [ordered]@{
        Output = $output
        ProfitA4 = $vProfit.Range("A4").Text
        ProfitA14 = $vProfit.Range("A14").Text
        ProfitA21 = $vProfit.Range("A21").Text
        ProfitB2 = $vProfit.Range("B2").Text
        ProfitB4 = $vProfit.Range("B4").Value2
        ProfitB6 = $vProfit.Range("B6").Formula
        ProfitC19 = $vProfit.Range("C19").Formula
        ProfitD19 = $vProfit.Range("D19").Formula
        ProfitC20 = $vProfit.Range("C20").Value2
        ProfitD20 = $vProfit.Range("D20").Formula
        ProfitQ1 = $vProfit.Range("Q1").Formula
        ProfitQ2 = $vProfit.Range("Q2").Formula
        ProfitH22 = $vProfit.Range("H22").Text
        ProfitH54 = $vProfit.Range("H54").Text
        ProfitF15 = $vProfit.Range("F15").Formula
        GnattI2 = $vGantt.Range("I2").Formula
    }
    $verifyWb.Close($false)
    $verifyWb = $null

    $lines = @(
        "# Pinetree Mode 2 Patched Labels And H54",
        "",
        "Output workbook: ``$output``",
        "",
        "Created by copying the successful Mode 2 workbook, restoring missing Profit column A structural labels from Pond, and disabling unmapped refinance inputs to clear the H22/H54 #NUM! path.",
        "",
        "## Key Checks",
        ""
    )
    foreach ($key in $checks.Keys) { $lines += "- ${key}: ``$($checks[$key])``" }
    Set-Content -LiteralPath $summary -Value ($lines -join "`r`n")
    [pscustomobject]$checks | ConvertTo-Json -Depth 4
}
finally {
    if ($null -ne $verifyWb) { try { $verifyWb.Close($false) } catch {} }
    if ($null -ne $pondWb) { try { $pondWb.Close($false) } catch {} }
    if ($null -ne $targetWb) { try { $targetWb.Close($false) } catch {} }
    if ($null -ne $excel) {
        try { $excel.Quit() } catch {}
        [System.Runtime.InteropServices.Marshal]::ReleaseComObject($excel) | Out-Null
    }
    [GC]::Collect()
    [GC]::WaitForPendingFinalizers()
}
