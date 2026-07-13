$ErrorActionPreference = "Stop"

$base = "C:\Codex\Wiki Files\Project Rooms\Template to Project"
$target = Join-Path $base "Need Verification\17_Project Management - 3413 Pinetree Ln - mode2 labels-safe 20260530_163443.xlsm"
$pond = Join-Path $base "template-reference\26_Project Management - 908 Pond St 3 - template.xlsm"
$stamp = Get-Date -Format "yyyyMMdd_HHmmss"
$report = Join-Path $base "Need Verification\Pinetree mode2 labels-safe verification $stamp.md"

$excel = New-Object -ComObject Excel.Application
$excel.Visible = $false
$excel.DisplayAlerts = $false
$excel.EnableEvents = $false
$excel.AskToUpdateLinks = $false

$targetWb = $null
$pondWb = $null
try {
    $targetWb = $excel.Workbooks.Open($target, 0, $true)
    $pondWb = $excel.Workbooks.Open($pond, 0, $true)

    $profit = $targetWb.Worksheets.Item("Profit")
    $pondProfit = $pondWb.Worksheets.Item("Profit")
    $gantt = $targetWb.Worksheets.Item("Gnatt Chart")

    $missingLabels = New-Object System.Collections.Generic.List[string]
    foreach ($row in 1..68) {
        $addr = "A$row"
        if ($pondProfit.Range($addr).Text -ne "" -and $profit.Range($addr).Text -eq "") {
            $missingLabels.Add($addr)
        }
    }

    $refFormulas = New-Object System.Collections.Generic.List[string]
    $displayErrors = New-Object System.Collections.Generic.List[string]
    foreach ($ws in @($targetWb.Worksheets)) {
        $used = $ws.UsedRange
        if ($null -eq $used) { continue }
        foreach ($cell in @($used.Cells)) {
            $formula = [string]$cell.Formula
            $text = [string]$cell.Text
            if ($formula -like "*#REF!*") {
                if ($refFormulas.Count -lt 50) {
                    $refFormulas.Add("$($ws.Name)!$($cell.Address($false,$false)) = $formula")
                }
            }
            if ($text -match "^#(REF!|NUM!|VALUE!|DIV/0!|NAME\?|N/A)") {
                if ($displayErrors.Count -lt 50) {
                    $displayErrors.Add("$($ws.Name)!$($cell.Address($false,$false)) = $text")
                }
            }
        }
    }

    $checks = [ordered]@{
        Output = $target
        ProfitA4 = $profit.Range("A4").Text
        ProfitA14 = $profit.Range("A14").Text
        ProfitA21 = $profit.Range("A21").Text
        MissingProfitLabelsFromPondA1A68 = $missingLabels.Count
        ProfitB2 = $profit.Range("B2").Text
        ProfitB4 = $profit.Range("B4").Value2
        ProfitB6 = $profit.Range("B6").Formula
        ProfitC19 = $profit.Range("C19").Formula
        ProfitD19 = $profit.Range("D19").Formula
        ProfitC20 = $profit.Range("C20").Value2
        ProfitD20 = $profit.Range("D20").Formula
        ProfitQ1 = $profit.Range("Q1").Formula
        ProfitQ2 = $profit.Range("Q2").Formula
        ProfitH22 = $profit.Range("H22").Text
        ProfitH54 = $profit.Range("H54").Text
        ProfitF15 = $profit.Range("F15").Formula
        GnattI2 = $gantt.Range("I2").Formula
        RefFormulaCountCapped = $refFormulas.Count
        DisplayErrorCountCapped = $displayErrors.Count
    }

    $lines = @(
        "# Pinetree Labels-Safe Verification",
        "",
        "Workbook: ``$target``",
        "",
        "## Checks",
        ""
    )
    foreach ($key in $checks.Keys) { $lines += "- ${key}: ``$($checks[$key])``" }
    if ($missingLabels.Count -gt 0) {
        $lines += ""
        $lines += "## Missing Profit Labels"
        foreach ($item in $missingLabels) { $lines += "- $item" }
    }
    if ($refFormulas.Count -gt 0) {
        $lines += ""
        $lines += "## Formulas Containing #REF!"
        foreach ($item in $refFormulas) { $lines += "- ``$item``" }
    }
    if ($displayErrors.Count -gt 0) {
        $lines += ""
        $lines += "## Displayed Formula Errors"
        foreach ($item in $displayErrors) { $lines += "- ``$item``" }
    }
    Set-Content -LiteralPath $report -Value ($lines -join "`r`n")
    [pscustomobject]$checks | ConvertTo-Json -Depth 4
}
finally {
    if ($null -ne $pondWb) { try { $pondWb.Close($false) } catch {} }
    if ($null -ne $targetWb) { try { $targetWb.Close($false) } catch {} }
    if ($null -ne $excel) {
        try { $excel.Quit() } catch {}
        [System.Runtime.InteropServices.Marshal]::ReleaseComObject($excel) | Out-Null
    }
    [GC]::Collect()
    [GC]::WaitForPendingFinalizers()
}
