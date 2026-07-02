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

function CellInfo($ws, [string]$addr) {
  $r = $ws.Range($addr)
  return [ordered]@{
    address = $addr
    value = $r.Text
    value2 = $r.Value2
    formula = $r.Formula
  }
}

function SafeDouble($value, [double]$fallback = 0) {
  if ($null -eq $value -or $value -eq "") { return $fallback }
  return [double]$value
}

function Checkpoint([string]$message) {
  Write-Host "checkpoint: $message"
  if ($script:ProgressLog) {
    Add-Content -LiteralPath $script:ProgressLog -Value "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') checkpoint: $message"
  }
}

function ReplaceInSheet($ws, [string]$what, [string]$replacement) {
  try {
    $null = $ws.UsedRange.Replace($what, $replacement, 2)
    return
  } catch {
  }
}

function ReplaceFormulaTextInSheet($ws, [string]$what, [string]$replacement) {
  try {
    $formulaCells = $ws.UsedRange.SpecialCells(-4123)
  } catch {
    return
  }
  foreach ($cell in $formulaCells.Cells) {
    $formula = [string]$cell.Formula
    if ($formula -like "*$what*") {
      $cell.Formula = $formula.Replace($what, $replacement)
    }
  }
}

$excel = $null
$target = $null
$rose = $null

try {
  $script:ProgressLog = [System.IO.Path]::ChangeExtension($OutputJson, ".progress.log")
  Set-Content -LiteralPath $script:ProgressLog -Value "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') starting migration"
  $excel = New-Object -ComObject Excel.Application
  $excel.Visible = $false
  $excel.DisplayAlerts = $false
  $excel.AskToUpdateLinks = $false
  $excel.EnableEvents = $false
  $excel.AutomationSecurity = 3
  try { $excel.Calculation = -4135 } catch {}

  Checkpoint "opening workbooks"
  $target = $excel.Workbooks.Open($TargetWorkbook, 0, $false)
  $rose = $excel.Workbooks.Open($RoseWorkbook, 0, $true)

  $targetSheetsBefore = @()
  foreach ($ws in $target.Worksheets) { $targetSheetsBefore += $ws.Name }
  $roseSheets = @()
  foreach ($ws in $rose.Worksheets) { $roseSheets += $ws.Name }

  if ($targetSheetsBefore -notcontains "Amortization") { throw "Target workbook does not contain Amortization." }
  if ($targetSheetsBefore -notcontains "Docs") { throw "Target workbook does not contain Docs." }
  if ($targetSheetsBefore -contains "Replacement Docs") { throw "Target workbook unexpectedly contains Replacement Docs; this is not the current Teams workbook." }
  if ($roseSheets -notcontains "Amortization") { throw "Rose workbook does not contain Amortization." }
  if ($roseSheets -notcontains "Docs") { throw "Rose workbook does not contain Docs." }

  $roseAm = $rose.Worksheets.Item("Amortization")
  $roseDocs = $rose.Worksheets.Item("Docs")
  $approvedLayoutChecks = [ordered]@{
    rose_docs_b7 = CellInfo $roseDocs "B7"
    rose_docs_b10 = CellInfo $roseDocs "B10"
    rose_docs_b12 = CellInfo $roseDocs "B12"
    rose_docs_b13 = CellInfo $roseDocs "B13"
    rose_docs_b14 = CellInfo $roseDocs "B14"
    rose_docs_b15 = CellInfo $roseDocs "B15"
    rose_docs_b18 = CellInfo $roseDocs "B18"
    rose_docs_b19 = CellInfo $roseDocs "B19"
    rose_docs_b50 = CellInfo $roseDocs "B50"
    rose_am_aa4 = CellInfo $roseAm "AA4"
    rose_am_z9 = CellInfo $roseAm "Z9"
    rose_am_z10 = CellInfo $roseAm "Z10"
    rose_am_q11 = CellInfo $roseAm "Q11"
  }
  if (($roseDocs.Range("B7").Formula -notmatch "Amortization") -or
      ($roseDocs.Range("B10").Formula -notmatch "Amortization") -or
      ($roseDocs.Range("B12").Formula -notmatch "Amortization") -or
      ($roseDocs.Range("B13").Formula -notmatch "Amortization") -or
      ($roseDocs.Range("B15").Formula -notmatch "Amortization") -or
      ($roseDocs.Range("B18").Formula -notmatch "Amortization") -or
      ($roseAm.Range("AA4").Formula -eq "") -or
      ($roseAm.Range("Z9").Formula -eq "") -or
      ($roseAm.Range("Z10").Formula -eq "")) {
    throw "Rose Amortization layout was not approved by formula checks."
  }

  $oldAm = $target.Worksheets.Item("Amortization")
  $docs = $target.Worksheets.Item("Docs")
  $profit = $target.Worksheets.Item("Profit")

  $oldValues = [ordered]@{
    docs_b7_purchase_price = CellInfo $docs "B7"
    docs_b8_earnest_money = CellInfo $docs "B8"
    docs_b9_down_payment = CellInfo $docs "B9"
    docs_b10_loan_amount = CellInfo $docs "B10"
    docs_b11_monthly_payment_reduced_total = CellInfo $docs "B11"
    docs_b12_monthly_payment_reduced_pi = CellInfo $docs "B12"
    docs_b13_monthly_payment_full_pi = CellInfo $docs "B13"
    docs_b14_monthly_payment_full_total = CellInfo $docs "B14"
    docs_b15_term_years = CellInfo $docs "B15"
    docs_b18_loan_start = CellInfo $docs "B18"
    docs_b19_loan_end_first = CellInfo $docs "B19"
    docs_b20_loan_start_second = CellInfo $docs "B20"
    docs_b21_loan_end_final = CellInfo $docs "B21"
    docs_b50_base_rate = CellInfo $docs "B50"
    docs_b51_reduced_rate = CellInfo $docs "B51"
    docs_b52_full_rate = CellInfo $docs "B52"
    amort_o2_purchase_price = CellInfo $oldAm "O2"
    amort_o3_sale_price = CellInfo $oldAm "O3"
    amort_o4_down_payment = CellInfo $oldAm "O4"
    amort_o5_loan_amount = CellInfo $oldAm "O5"
    amort_c3_old_base_rate = CellInfo $oldAm "C3"
    amort_o7_term_years = CellInfo $oldAm "O7"
    amort_t8_insurance = CellInfo $oldAm "T8"
    amort_t9_taxes = CellInfo $oldAm "T9"
    amort_m4_above_arv = CellInfo $oldAm "M4"
    amort_o2_down_pct = CellInfo $oldAm "O2"
    amort_p1_point1 = CellInfo $oldAm "P1"
    amort_q1_point2 = CellInfo $oldAm "Q1"
    amort_r1_point3 = CellInfo $oldAm "R1"
    amort_aa8_reduced_rate = CellInfo $oldAm "AA8"
    amort_ab8_reduced_loan = CellInfo $oldAm "AB8"
    amort_ac8_reduced_months = CellInfo $oldAm "AC8"
    amort_aa9_full_rate = CellInfo $oldAm "AA9"
    amort_ab9_full_loan = CellInfo $oldAm "AB9"
    amort_ac9_full_months = CellInfo $oldAm "AC9"
  }

  $oldAboveArv = SafeDouble $oldAm.Range("M4").Value2
  $oldDownPct = SafeDouble $oldAm.Range("O2").Value2
  $oldBaseRate = SafeDouble $oldAm.Range("C3").Value2
  $oldPoint1 = SafeDouble $oldAm.Range("P1").Value2
  $oldPoint2 = SafeDouble $oldAm.Range("Q1").Value2
  $oldPoint3 = SafeDouble $oldAm.Range("R1").Value2
  $oldTermYears = SafeDouble $oldAm.Range("O7").Value2 30
  $oldLoanStart = $docs.Range("B18").Value2
  $oldInsurance = SafeDouble $oldAm.Range("T8").Value2
  $oldTaxes = SafeDouble $oldAm.Range("T9").Value2
  $oldScenario = $oldAm.Range("AW2").Value2
  $oldDocSale = SafeDouble $docs.Range("B7").Value2
  $oldEarnest = SafeDouble $docs.Range("B8").Value2
  $oldReducedRate = SafeDouble $oldAm.Range("AA8").Value2
  $oldReducedLoan = SafeDouble $oldAm.Range("AB8").Value2
  $oldReducedMonths = SafeDouble $oldAm.Range("AC8").Value2
  $oldFullRate = SafeDouble $oldAm.Range("AA9").Value2
  $oldFullLoan = SafeDouble $oldAm.Range("AB9").Value2
  $oldFullMonths = SafeDouble $oldAm.Range("AC9").Value2

  $oldAmIndex = $oldAm.Index
  Checkpoint "copying Rose Amortization sheet"
  $roseAm.Copy($target.Worksheets.Item($oldAmIndex))
  $newAm = $target.Worksheets.Item($oldAmIndex)
  $newAm.Name = "Amortization - New"

  $roseFile = [System.IO.Path]::GetFileName($RoseWorkbook)
  Checkpoint "localizing copied sheet links"
  try {
    $target.ChangeLink($RoseWorkbook, $TargetWorkbook, 1)
  } catch {
    Add-Content -LiteralPath $script:ProgressLog -Value "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') ChangeLink warning: $($_.Exception.Message)"
  }

  $newAm.Range("AW2").Value2 = $oldScenario
  $newAm.Range("K2").Value2 = $oldEarnest
  $newAm.Range("K3").Value2 = $oldDownPct
  $newAm.Range("P2").Value2 = $oldAboveArv
  $newAm.Range("Q2").Value2 = $oldAboveArv
  $newAm.Range("R2").Value2 = $oldAboveArv
  $newAm.Range("P6").Value2 = $oldPoint1
  $newAm.Range("Q6").Value2 = $oldPoint2
  $newAm.Range("R6").Value2 = $oldPoint3
  $newAm.Range("O9").Value2 = $oldTermYears
  $newAm.Range("O11").Value2 = $oldLoanStart
  $newAm.Range("T9").Value2 = $oldInsurance
  $newAm.Range("T10").Value2 = $oldTaxes
  $newAm.Range("AA9").Value2 = $oldReducedRate
  $newAm.Range("AB9").Value2 = $oldReducedLoan
  $newAm.Range("AC9").Value2 = $oldReducedMonths
  $newAm.Range("AA10").Value2 = $oldFullRate
  $newAm.Range("AB10").Value2 = $oldFullLoan
  $newAm.Range("AC10").Value2 = $oldFullMonths
  $newAm.Range("Z9").Formula = "=ROUND(PMT(AA9/12,AC9,AB9),0)*-1"
  $newAm.Range("Z10").Formula = "=ROUND(PMT(AA10/12,AC10,AB10),0)*-1"

  Checkpoint "calculating new amortization base"
  $newAm.Calculate()
  $financeSale = SafeDouble $newAm.Range("O3").Value2
  $newAm.Range("X5").Value2 = $oldDocSale - $financeSale
  $newAm.Calculate()

  Checkpoint "renaming sheets"
  $oldAm.Name = "Amortization - Old"
  $newAm.Name = "Amortization"

  Checkpoint "retargeting formulas"
  foreach ($ws in $target.Worksheets) {
    if ($ws.Name -ne "Amortization - Old") {
      ReplaceInSheet $ws "'Amortization - Old'!" "Amortization!"
      ReplaceInSheet $ws "Amortization - Old!" "Amortization!"
    }
  }

  Checkpoint "setting Docs and Profit formulas"
  $profit.Range("B5").Formula = "=+Amortization!O2"
  $profit.Range("B7").Formula = "=+Amortization!`$K`$3"
  $profit.Range("I9").Formula = "=IF(OR(C1=""Hold"",D1=""Slow Flip""),IF(C1=""hold"",+B9,+Amortization!AJ8),"""")"
  $profit.Range("G13").Formula = "=IF(R3=3,+Amortization!AJ11,0)"
  $profit.Range("F15").Formula = "=-C15"

  $docs.Range("B7").Formula = "=+Amortization!AA4"
  $docs.Range("B8").Formula = "=+Amortization!K2"
  $docs.Range("B9").Formula = "=+Amortization!`$O`$4"
  $docs.Range("B10").Formula = "=+Amortization!AA4"
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
  $docs.Range("B49").Formula = "=+Profit!C20-B48"
  $docs.Range("B50").Formula = "=TEXT(Amortization!`$C`$4,""0.000%"")"
  $docs.Range("B51").Formula = "=TEXT(+Amortization!AA9,""0.000%"")"
  $docs.Range("B52").Formula = "=TEXT(Amortization!`$O`$7,""0.000%"")"

  Checkpoint "calculating affected sheets"
  $newAm.Calculate()
  $profit.Calculate()
  $docs.Calculate()

  $afterValues = [ordered]@{
    docs_b7_purchase_price = CellInfo $docs "B7"
    docs_b8_earnest_money = CellInfo $docs "B8"
    docs_b9_down_payment = CellInfo $docs "B9"
    docs_b10_loan_amount = CellInfo $docs "B10"
    docs_b11_monthly_payment_reduced_total = CellInfo $docs "B11"
    docs_b12_monthly_payment_reduced_pi = CellInfo $docs "B12"
    docs_b13_monthly_payment_full_pi = CellInfo $docs "B13"
    docs_b14_monthly_payment_full_total = CellInfo $docs "B14"
    docs_b15_term_years = CellInfo $docs "B15"
    docs_b18_loan_start = CellInfo $docs "B18"
    docs_b19_loan_end_first = CellInfo $docs "B19"
    docs_b20_loan_start_second = CellInfo $docs "B20"
    docs_b21_loan_end_final = CellInfo $docs "B21"
    docs_b50_base_rate = CellInfo $docs "B50"
    docs_b51_reduced_rate = CellInfo $docs "B51"
    docs_b52_full_rate = CellInfo $docs "B52"
    amort_o2_purchase_price = CellInfo $newAm "O2"
    amort_o3_sale_price = CellInfo $newAm "O3"
    amort_o4_down_payment = CellInfo $newAm "O4"
    amort_o5_loan_amount = CellInfo $newAm "O5"
    amort_k3_down_pct = CellInfo $newAm "K3"
    amort_c4_base_rate = CellInfo $newAm "C4"
    amort_o9_term_years = CellInfo $newAm "O9"
    amort_o11_loan_start = CellInfo $newAm "O11"
    amort_t9_insurance = CellInfo $newAm "T9"
    amort_t10_taxes = CellInfo $newAm "T10"
    amort_aa9_reduced_rate = CellInfo $newAm "AA9"
    amort_ab9_reduced_loan = CellInfo $newAm "AB9"
    amort_ac9_reduced_months = CellInfo $newAm "AC9"
    amort_aa10_full_rate = CellInfo $newAm "AA10"
    amort_ab10_full_loan = CellInfo $newAm "AB10"
    amort_ac10_full_months = CellInfo $newAm "AC10"
    amort_z9_reduced_payment = CellInfo $newAm "Z9"
    amort_z10_full_payment = CellInfo $newAm "Z10"
  }

  $manualMappings = @(
    "Amortization!K2 from old Docs!B8 earnest money.",
    "Amortization!K3 from old Amortization!O2 down-payment percentage.",
    "Amortization!P2:R2 from old Amortization!M4 above-ARV setting.",
    "Amortization!P6:R6 from old Amortization!P1:R1 point settings.",
    "Amortization!O9 from old Amortization!O7 term years.",
    "Amortization!O11 from Docs!B18 loan start date.",
    "Amortization!T9:T10 from old insurance/tax escrow cells T8:T9.",
    "Amortization!AA9:AC10 from old reduced/full payment scenario table AA8:AC9.",
    "Amortization!X5 adjusted so Docs selling purchase price remains tied to the project sale value.",
    "Docs B7:B21/B49:B52 and Profit B5/B7/I9/G13/F15 retargeted to the new Rose-layout Amortization sheet."
  )

  Checkpoint "saving workbook"
  $target.Save()
  $result = [ordered]@{
    migrated_at = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss zzz")
    source_template_workbook = $RoseWorkbook
    source_template_url = $SourceTemplateUrl
    target_project_workbook = $TargetWorkbook
    target_project_url = $TargetWorkbookUrl
    rollback_copy = $RollbackPath
    sheets_before = $targetSheetsBefore
    sheets_after = @($target.Worksheets | ForEach-Object { $_.Name })
    approved_layout_checks = $approvedLayoutChecks
    before = $oldValues
    after = $afterValues
    manual_mappings = $manualMappings
    unresolved_issues = @()
  }
  $result | ConvertTo-Json -Depth 8 | Set-Content -LiteralPath $OutputJson -Encoding UTF8

  $lines = @()
  $lines += "# Tensity Rose Amortization Migration"
  $lines += ""
  $lines += "- Migration time: $($result.migrated_at)"
  $lines += "- Source template workbook: $RoseWorkbook"
  $lines += "- Source template SharePoint URL: $SourceTemplateUrl"
  $lines += "- Target project workbook: $TargetWorkbook"
  $lines += "- Target project SharePoint URL: $TargetWorkbookUrl"
  $lines += "- Rollback copy: $RollbackPath"
  $lines += ""
  $lines += "## Key Values"
  $lines += ""
  $lines += "| Field | Before | After |"
  $lines += "| --- | ---: | ---: |"
  foreach ($key in @("docs_b7_purchase_price","docs_b8_earnest_money","docs_b9_down_payment","docs_b10_loan_amount","docs_b11_monthly_payment_reduced_total","docs_b12_monthly_payment_reduced_pi","docs_b13_monthly_payment_full_pi","docs_b14_monthly_payment_full_total","docs_b15_term_years","docs_b18_loan_start","docs_b19_loan_end_first","docs_b20_loan_start_second","docs_b21_loan_end_final","docs_b50_base_rate","docs_b51_reduced_rate","docs_b52_full_rate")) {
    $lines += "| $key | $($oldValues[$key].value) | $($afterValues[$key].value) |"
  }
  $lines += ""
  $lines += "## Manual Mapping"
  foreach ($m in $manualMappings) { $lines += "- $m" }
  $lines += ""
  $lines += "## Unresolved Issues"
  $lines += "- None identified during workbook migration."
  $lines | Set-Content -LiteralPath $MigrationLog -Encoding UTF8
}
finally {
  if ($rose -ne $null) { $rose.Close($false) | Out-Null }
  if ($target -ne $null) { $target.Close($true) | Out-Null }
  if ($excel -ne $null) {
    $excel.Quit() | Out-Null
    [System.Runtime.InteropServices.Marshal]::ReleaseComObject($excel) | Out-Null
  }
  [GC]::Collect()
  [GC]::WaitForPendingFinalizers()
}
