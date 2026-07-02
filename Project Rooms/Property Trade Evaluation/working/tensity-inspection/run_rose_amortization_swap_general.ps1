param(
  [Parameter(Mandatory=$true)][string]$TargetWorkbook,
  [Parameter(Mandatory=$true)][string]$RoseWorkbook,
  [Parameter(Mandatory=$true)][string]$OutputJson,
  [Parameter(Mandatory=$true)][string]$MigrationLog,
  [Parameter(Mandatory=$true)][string]$SourceTemplateUrl,
  [Parameter(Mandatory=$true)][string]$TargetWorkbookUrl,
  [Parameter(Mandatory=$true)][string]$RollbackPath
)

$ErrorActionPreference = "Stop"

function SafeDouble($value, [double]$fallback = 0) {
  if ($null -eq $value -or $value -eq "" -or $value -is [System.DBNull]) { return $fallback }
  try { return [double]$value } catch { return $fallback }
}

function IsNumericValue($value) {
  if ($null -eq $value -or $value -eq "" -or $value -is [System.DBNull]) { return $false }
  try { $null = [double]$value; return $true } catch { return $false }
}

function CellInfo($ws, [string]$addr) {
  $r = $ws.Range($addr)
  return [ordered]@{ address=$addr; value=$r.Text; value2=$r.Value2; formula=$r.Formula }
}

function ReplaceInSheet($ws, [string]$what, [string]$replacement) {
  try { $null = $ws.UsedRange.Replace($what, $replacement, 2) } catch {}
}

function BreakWorkbookLinks($wb, [string[]]$paths, [string]$progressLog) {
  foreach ($p in $paths) {
    if ([string]::IsNullOrWhiteSpace($p)) { continue }
    try {
      $wb.BreakLink($p, 1)
      Add-Content -LiteralPath $progressLog -Value "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') broke link: $p"
    } catch {
      Add-Content -LiteralPath $progressLog -Value "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') break link warning for ${p}: $($_.Exception.Message)"
    }
  }
}

function GetFirstNumeric($candidates, [double]$fallback = 0) {
  foreach ($c in $candidates) {
    if (IsNumericValue $c) { return [double]$c }
  }
  return $fallback
}

function GetFirstRate($candidates, [double]$fallback = 0) {
  foreach ($c in $candidates) {
    if (IsNumericValue $c) {
      $v = [double]$c
      if ($v -ge 0 -and $v -le 1) { return $v }
    }
  }
  return $fallback
}

function SetExcelNumber($range, [double]$value) {
  $range.Formula = $value.ToString([System.Globalization.CultureInfo]::InvariantCulture)
}

$excel = $null
$target = $null
$rose = $null

try {
  $progressLog = [System.IO.Path]::ChangeExtension($OutputJson, ".progress.log")
  Set-Content -LiteralPath $progressLog -Value "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') starting migration"

  $excel = New-Object -ComObject Excel.Application
  $excel.Visible = $false
  $excel.DisplayAlerts = $false
  $excel.AskToUpdateLinks = $false
  $excel.EnableEvents = $false
  $excel.AutomationSecurity = 3

  $target = $excel.Workbooks.Open($TargetWorkbook, 0, $false)
  $rose = $excel.Workbooks.Open($RoseWorkbook, 0, $true)

  $sheetNames = @($target.Worksheets | ForEach-Object { $_.Name })
  if ($sheetNames -notcontains "Amortization") { throw "Target workbook lacks Amortization sheet." }
  if ($sheetNames -notcontains "Docs") { throw "Target workbook lacks Docs sheet." }
  if ($sheetNames -contains "Replacement Docs") { throw "Target workbook has Replacement Docs; stop for review." }

  $roseAm = $rose.Worksheets.Item("Amortization")
  $roseDocs = $rose.Worksheets.Item("Docs")
  if (($roseDocs.Range("B7").Formula -notmatch "Amortization") -or
      ($roseDocs.Range("B10").Formula -notmatch "Amortization") -or
      ($roseAm.Range("AA4").Formula -eq "") -or
      ($roseAm.Range("Z9").Formula -eq "") -or
      ($roseAm.Range("Z10").Formula -eq "")) {
    throw "Rose template failed approved-layout checks."
  }

  $oldAm = $target.Worksheets.Item("Amortization")
  $docs = $target.Worksheets.Item("Docs")
  $profit = $target.Worksheets.Item("Profit")

  $alreadyRose = ($oldAm.Range("Z10").Formula -match "PMT") -and
                 ($docs.Range("B7").Formula -match "Amortization") -and
                 ($docs.Range("B10").Formula -match "Amortization!O5") -and
                 ($oldAm.Range("Q11").Formula -match "EDATE")
  if ($alreadyRose) {
    $result = [ordered]@{
      migrated_at=(Get-Date).ToString("yyyy-MM-dd HH:mm:ss zzz")
      status="skipped-already-rose-layout"
      target_project_workbook=$TargetWorkbook
      target_project_url=$TargetWorkbookUrl
      rollback_copy=$RollbackPath
      before=[ordered]@{
        docs_b7=CellInfo $docs "B7"; docs_b10=CellInfo $docs "B10"; docs_b14=CellInfo $docs "B14"
      }
      unresolved_issues=@()
    }
    $result | ConvertTo-Json -Depth 8 | Set-Content -LiteralPath $OutputJson -Encoding UTF8
    "# Rose Amortization Migration`n`n- Status: already on Rose layout; no workbook changes made." | Set-Content -LiteralPath $MigrationLog -Encoding UTF8
    return
  }

  $before = [ordered]@{
    docs_b7 = CellInfo $docs "B7"
    docs_b10 = CellInfo $docs "B10"
    docs_b11 = CellInfo $docs "B11"
    docs_b12 = CellInfo $docs "B12"
    docs_b14 = CellInfo $docs "B14"
    docs_b15 = CellInfo $docs "B15"
    docs_b17 = CellInfo $docs "B17"
    docs_b20 = CellInfo $docs "B20"
    docs_b21 = CellInfo $docs "B21"
    docs_b22 = CellInfo $docs "B22"
    docs_b23 = CellInfo $docs "B23"
    docs_b40 = CellInfo $docs "B40"
    docs_b41 = CellInfo $docs "B41"
    docs_b42 = CellInfo $docs "B42"
    docs_b50 = CellInfo $docs "B50"
    docs_b51 = CellInfo $docs "B51"
    docs_b52 = CellInfo $docs "B52"
    am_o3 = CellInfo $oldAm "O3"
    am_o4 = CellInfo $oldAm "O4"
    am_o5 = CellInfo $oldAm "O5"
    am_t4 = CellInfo $oldAm "T4"
    am_t5 = CellInfo $oldAm "T5"
    am_t6 = CellInfo $oldAm "T6"
  }

  $oldBaseArv = SafeDouble $profit.Range("B4").Value2
  $m4Value = SafeDouble $oldAm.Range("M4").Value2
  $m4DerivedAbove = 0
  if ($oldBaseArv -gt 0 -and $m4Value -gt 1) { $m4DerivedAbove = ($m4Value / $oldBaseArv) - 1 }
  $oldAboveArv = [double](GetFirstNumeric @($m4DerivedAbove, $oldAm.Range("H1").Value2, $oldAm.Range("P2").Value2) 0)
  if ($oldAboveArv -gt 1) { $oldAboveArv = 0 }
  $oldScenario = [double](GetFirstNumeric @($oldAm.Range("AW2").Value2, $oldAm.Range("T1").Value2) 1)
  if ($oldScenario -lt 1 -or $oldScenario -gt 3) { $oldScenario = 1 }
  $oldTermYears = [double](GetFirstNumeric @($docs.Range("B30").Value2, $docs.Range("B17").Value2, $oldAm.Range("O7").Value2, $oldAm.Range("O9").Value2, $oldAm.Range("C4").Value2) 30)
  if ($oldTermYears -gt 100 -or $oldTermYears -lt 1) { $oldTermYears = 30 }
  $oldLoanStart = $docs.Range("B33").Value2
  if (-not (IsNumericValue $oldLoanStart) -or [double]$oldLoanStart -lt 20000) { $oldLoanStart = $docs.Range("B20").Value2 }
  if (-not (IsNumericValue $oldLoanStart) -or [double]$oldLoanStart -lt 20000) { $oldLoanStart = $docs.Range("B18").Value2 }

  $oldSale = [double](GetFirstNumeric @($oldAm.Range("T4").Value2, $oldAm.Range("AA3").Value2, $oldAm.Range("AA4").Value2, $docs.Range("B14").Value2, $docs.Range("B10").Value2, $docs.Range("B7").Value2, $oldAm.Range("O3").Value2) 0)
  $oldDownRaw = [double](GetFirstNumeric @($oldAm.Range("T6").Value2, $oldAm.Range("AA4").Value2, $oldAm.Range("O4").Value2, $oldAm.Range("AA5").Value2, $docs.Range("B12").Value2, $docs.Range("B9").Value2, $docs.Range("B11").Value2) 0)
  $oldLoan = [double](GetFirstNumeric @($oldAm.Range("T5").Value2, $oldAm.Range("AA5").Value2, $oldAm.Range("O5").Value2, $oldAm.Range("AA6").Value2, $docs.Range("B13").Value2, $docs.Range("B12").Value2, $docs.Range("B10").Value2) 0)
  $oldPayment1 = [double](GetFirstNumeric @($oldAm.Range("Z8").Value2, $docs.Range("B24").Value2, $docs.Range("B14").Value2, $docs.Range("B12").Value2) 0)
  $oldPayment2 = [double](GetFirstNumeric @($oldAm.Range("Z9").Value2, $docs.Range("B28").Value2, $docs.Range("B15").Value2, $docs.Range("B13").Value2) 0)
  $financeAdjustment = 0
  if ($oldBaseArv -gt 0 -and $oldSale -gt 0 -and $oldDownRaw -gt 0 -and [Math]::Abs(($oldSale - $oldDownRaw) - $oldLoan) -lt 5) {
    $oldAboveArv = ($oldSale / $oldBaseArv) - 1
    $financeAdjustment = 0
  }
  $oldEarnest = 0

  $baseRate = [double](GetFirstNumeric @($profit.Range("B15").Value2, $oldAm.Range("C4").Value2, $oldAm.Range("C3").Value2) 0)
  $point1 = [double](GetFirstNumeric @($oldAm.Range("P6").Value2, $oldAm.Range("K2").Value2, $oldAm.Range("P1").Value2) 0)
  $point2 = [double](GetFirstNumeric @($oldAm.Range("Q6").Value2, $oldAm.Range("L2").Value2, $oldAm.Range("Q1").Value2, $point1) $point1)
  $point3 = [double](GetFirstNumeric @($oldAm.Range("R6").Value2, $oldAm.Range("M2").Value2, $oldAm.Range("R1").Value2, $point1) $point1)
  $reducedRate = [double](GetFirstRate @($oldAm.Range("AA8").Value2, $oldAm.Range("T9").Value2, $baseRate) $baseRate)
  $fullRate = [double](GetFirstRate @($oldAm.Range("AA9").Value2, $oldAm.Range("T10").Value2, $baseRate + $point1) ($baseRate + $point1))

  $insurance = [double](GetFirstNumeric @($docs.Range("B55").Value2, $oldAm.Range("T8").Value2) 0)
  $taxes = [double](GetFirstNumeric @($docs.Range("B54").Value2, $oldAm.Range("T9").Value2) 0)
  if ($taxes -lt 0.01 -or $taxes -lt $baseRate + 0.001) {
    if (IsNumericValue $oldAm.Range("T10").Value2 -and (SafeDouble $oldAm.Range("T10").Value2) -lt 1) {
      $taxes = 0
    }
  }

  $oldAmIndex = $oldAm.Index
  $roseAm.Copy($target.Worksheets.Item($oldAmIndex))
  $newAm = $target.Worksheets.Item($oldAmIndex)
  $newAm.Name = "Amortization - New"

  try { $target.ChangeLink($RoseWorkbook, $TargetWorkbook, 1) } catch {}

  SetExcelNumber $newAm.Range("AW2") $oldScenario
  SetExcelNumber $newAm.Range("K2") $oldEarnest
  SetExcelNumber $newAm.Range("P2") $oldAboveArv
  SetExcelNumber $newAm.Range("Q2") $oldAboveArv
  SetExcelNumber $newAm.Range("R2") $oldAboveArv
  SetExcelNumber $newAm.Range("P6") $point1
  SetExcelNumber $newAm.Range("Q6") $point2
  SetExcelNumber $newAm.Range("R6") $point3
  SetExcelNumber $newAm.Range("O9") $oldTermYears
  $newAm.Range("O11").Value2 = $oldLoanStart
  SetExcelNumber $newAm.Range("T9") $insurance
  SetExcelNumber $newAm.Range("T10") $taxes

  $newAm.Calculate()
  $financeBase = SafeDouble $newAm.Range("O3").Value2
  if ($oldDownRaw -gt 0 -and $financeBase -gt 0) {
    SetExcelNumber $newAm.Range("K3") ($oldDownRaw / $financeBase)
  } else {
    SetExcelNumber $newAm.Range("K3") (GetFirstNumeric @($oldAm.Range("O2").Value2, $oldAm.Range("K3").Value2, $profit.Range("B7").Value2) 0.1)
  }
  $newAm.Calculate()
  $financeBase = SafeDouble $newAm.Range("O3").Value2
  if ($oldSale -gt 0) {
    if ($financeAdjustment -eq 0 -and [Math]::Abs($financeBase - $oldSale) -lt 5) {
      SetExcelNumber $newAm.Range("X5") 0
    } else {
      SetExcelNumber $newAm.Range("X5") ($oldSale - $financeBase)
    }
  }

  $newAm.Calculate()
  $newLoan = GetFirstNumeric @($oldLoan, $newAm.Range("O5").Value2) (SafeDouble $newAm.Range("O5").Value2)
  SetExcelNumber $newAm.Range("AA9") $reducedRate
  SetExcelNumber $newAm.Range("AB9") $newLoan
  SetExcelNumber $newAm.Range("AC9") ($oldTermYears * 12)
  SetExcelNumber $newAm.Range("AA10") $fullRate
  SetExcelNumber $newAm.Range("AC10") ([Math]::Max(($oldTermYears * 12) - 60, 1))
  $newAm.Range("Z9").Formula = "=ROUND(PMT(AA9/12,AC9,AB9),0)*-1"
  $newAm.Calculate()
  $newAm.Range("AB10").Formula = "=ROUND(PV(AA9/12,AC9-60,-Z9),0)"
  $newAm.Range("Z10").Formula = "=ROUND(PMT(AA10/12,AC10,AB10),0)*-1"

  $oldAm.Name = "Amortization - Old"
  $newAm.Name = "Amortization"

  foreach ($ws in $target.Worksheets) {
    if ($ws.Name -ne "Amortization - Old") {
      ReplaceInSheet $ws "'Amortization - Old'!" "Amortization!"
      ReplaceInSheet $ws "Amortization - Old!" "Amortization!"
    }
  }

  $profit.Range("B5").Formula = "=+Amortization!O2"
  $profit.Range("B7").Formula = "=+Amortization!`$K`$3"
  $profit.Range("I9").Formula = "=IF(OR(C1=""Hold"",D1=""Slow Flip""),IF(C1=""hold"",+B9,+Amortization!AJ8),"""")"
  $profit.Range("G13").Formula = "=IF(R3=3,+Amortization!AJ11,0)"

  $docs.Range("B7").Formula = "=+Amortization!AA4"
  $docs.Range("B8").Formula = "=+Amortization!K2"
  $docs.Range("B9").Formula = "=+Amortization!`$O`$4"
  $docs.Range("B10").Formula = "=+Amortization!O5"
  $docs.Range("B11").Formula = "=SUM(B12:B12)"
  $docs.Range("B12").Formula = "=+Amortization!Z9"
  $docs.Range("B13").Formula = "=+Amortization!Z10"
  $docs.Range("B14").Formula = "=SUM(B13:B13)"
  $docs.Range("B15").Formula = "=+Amortization!O9"
  $docs.Range("B16").Formula = "=+B15*12"
  $docs.Range("B17").Formula = "=+B16-60"
  $docs.Range("B18").Formula = "=+Amortization!O11"
  $docs.Range("B19").Formula = "=+Amortization!Q11"
  $docs.Range("B20").Formula = "=+Amortization!O11"
  $docs.Range("B21").Formula = "=+`$B`$18+(`$B`$15*365)-DAY(+`$B`$18+(`$B`$15*365))+1"
  $docs.Range("B50").Formula = "=TEXT(Amortization!`$C`$4,""0.000%"")"
  $docs.Range("B51").Formula = "=TEXT(+Amortization!AA9,""0.000%"")"
  $docs.Range("B52").Formula = "=TEXT(Amortization!`$O`$7,""0.000%"")"

  $newAm.Calculate(); $profit.Calculate(); $docs.Calculate()

  $after = [ordered]@{
    docs_b7 = CellInfo $docs "B7"
    docs_b9 = CellInfo $docs "B9"
    docs_b10 = CellInfo $docs "B10"
    docs_b11 = CellInfo $docs "B11"
    docs_b14 = CellInfo $docs "B14"
    docs_b15 = CellInfo $docs "B15"
    docs_b18 = CellInfo $docs "B18"
    docs_b19 = CellInfo $docs "B19"
    docs_b20 = CellInfo $docs "B20"
    docs_b21 = CellInfo $docs "B21"
    docs_b50 = CellInfo $docs "B50"
    docs_b51 = CellInfo $docs "B51"
    docs_b52 = CellInfo $docs "B52"
    am_o3 = CellInfo $newAm "O3"
    am_o4 = CellInfo $newAm "O4"
    am_o5 = CellInfo $newAm "O5"
    am_x5 = CellInfo $newAm "X5"
    am_aa9 = CellInfo $newAm "AA9"
    am_ab9 = CellInfo $newAm "AB9"
    am_ac9 = CellInfo $newAm "AC9"
    am_aa10 = CellInfo $newAm "AA10"
    am_ab10 = CellInfo $newAm "AB10"
    am_ac10 = CellInfo $newAm "AC10"
  }

  BreakWorkbookLinks $target @($RoseWorkbook, [System.IO.Path]::GetFileName($RoseWorkbook)) $progressLog
  $target.Save()

  $result = [ordered]@{
    migrated_at=(Get-Date).ToString("yyyy-MM-dd HH:mm:ss zzz")
    status="migrated"
    source_template_workbook=$RoseWorkbook
    source_template_url=$SourceTemplateUrl
    target_project_workbook=$TargetWorkbook
    target_project_url=$TargetWorkbookUrl
    rollback_copy=$RollbackPath
    before=$before
    mapped_inputs=[ordered]@{
      oldSale=$oldSale; oldDownRaw=$oldDownRaw; oldLoan=$oldLoan; oldPayment1=$oldPayment1; oldPayment2=$oldPayment2; oldAboveArv=$oldAboveArv; oldTermYears=$oldTermYears; oldLoanStart=$oldLoanStart; reducedRate=$reducedRate; fullRate=$fullRate; insurance=$insurance; taxes=$taxes
    }
    after=$after
    manual_mappings=@(
      "Rose Amortization sheet copied beside old Amortization, then old sheet renamed Amortization - Old.",
      "Project inputs mapped from old Amortization/Profit/Docs outputs into Rose input cells.",
      "Docs B7:B21 and B50:B52 retargeted to Rose-layout Amortization outputs.",
      "Rose template external link broken through Excel before save."
    )
    unresolved_issues=@()
  }
  $result | ConvertTo-Json -Depth 8 | Set-Content -LiteralPath $OutputJson -Encoding UTF8

  $lines = @("# Rose Amortization Migration","")
  $lines += "- Migration time: $($result.migrated_at)"
  $lines += "- Source template workbook: $RoseWorkbook"
  $lines += "- Target project workbook: $TargetWorkbook"
  $lines += "- Rollback copy: $RollbackPath"
  $lines += ""
  $lines += "## Key Values"
  $lines += "| Field | Before | After |"
  $lines += "| --- | ---: | ---: |"
  $lines += "| Selling purchase price | $oldSale | $($after.docs_b7.value) |"
  $lines += "| Down payment | $oldDownRaw | $($after.docs_b9.value) |"
  $lines += "| Loan amount | $oldLoan | $($after.docs_b10.value) |"
  $lines += "| Monthly payment 1 | $oldPayment1 | $($after.docs_b11.value) |"
  $lines += "| Monthly payment 2 | $oldPayment2 | $($after.docs_b14.value) |"
  $lines += "| Term years | $oldTermYears | $($after.docs_b15.value) |"
  $lines += "| Loan start | $oldLoanStart | $($after.docs_b18.value) |"
  $lines += ""
  $lines += "## Manual Mapping"
  foreach ($m in $result.manual_mappings) { $lines += "- $m" }
  $lines += ""
  $lines += "## Unresolved Issues"
  $lines += "- Review formula-driven changes where old workbook had text placeholders or external links in Docs payment fields."
  $lines | Set-Content -LiteralPath $MigrationLog -Encoding UTF8
}
finally {
  if ($rose -ne $null) { $rose.Close($false) | Out-Null }
  if ($target -ne $null) { $target.Close($true) | Out-Null }
  if ($excel -ne $null) { $excel.Quit() | Out-Null; [System.Runtime.InteropServices.Marshal]::ReleaseComObject($excel) | Out-Null }
  [GC]::Collect(); [GC]::WaitForPendingFinalizers()
}
