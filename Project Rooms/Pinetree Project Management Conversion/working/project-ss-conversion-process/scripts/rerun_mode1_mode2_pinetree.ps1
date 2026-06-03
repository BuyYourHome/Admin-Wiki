$ErrorActionPreference = "Stop"

$base = "C:\Codex\Wiki Files\Project Rooms\Pinetree Project Management Conversion"
$pond = Join-Path $base "template-reference\26_Project Management - 908 Pond St 3 - template.xlsm"
$source = Join-Path $base "sources\17_Project Management - 3413 Pinetree Ln - source.xlsx"
$stamp = Get-Date -Format "yyyyMMdd_HHmmss"
$emptyTemplate = Join-Path $base "template-reference\Project Management - empty template from Pond Excel-native labels-safe $stamp.xlsm"
$emptySummary = Join-Path $base "template-reference\Project Management empty template labels-safe summary $stamp.md"
$output = Join-Path $base "Need Verification\17_Project Management - 3413 Pinetree Ln - mode2 labels-safe $stamp.xlsm"
$summary = Join-Path $base "Need Verification\Pinetree mode2 labels-safe summary $stamp.md"
$payload = Join-Path $env:TEMP "pinetree_payload_labels_safe_$stamp.json"

Copy-Item -LiteralPath $pond -Destination $emptyTemplate -Force

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
    if ($null -eq $value) { return }
    $cell = Cell-ForWrite $ws $address
    try {
        if ($value -is [bool]) {
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
    } catch {
        throw "Failed writing $($ws.Name)!$address value '$value' type '$($value.GetType().FullName)': $($_.Exception.Message)"
    }
}

function Set-Formula($ws, [string]$address, [string]$formula) {
    $cell = Cell-ForWrite $ws $address
    $cell.Formula = $formula
}

function Clear-Cell($ws, [string]$address) {
    $cell = Cell-ForWrite $ws $address
    try {
        $cell.ClearContents()
    } catch {
        try {
            $cell.Formula = ""
        } catch {
            throw "Failed clearing $($ws.Name)!$address via $($cell.Address($false,$false)): $($_.Exception.Message)"
        }
    }
}

function Clear-ConstantsOnly($ws, [string]$address) {
    try {
        $constants = $ws.Range($address).SpecialCells(2)
        $constants.ClearContents()
    } catch {
        # no constants
    }
}

$wb = $null
$sourceWb = $null
$targetWb = $null
$verifyWb = $null
try {
    # Mode 1: make a labels-safe empty template.
    $wb = $excel.Workbooks.Open($emptyTemplate, 0, $false)
    $profit = $wb.Worksheets.Item("Profit")

    $profitInputCells = @(
        "B2","E2","G2","K2","B4","C5","B9","K7","K9","K13",
        "C14","B15","C15","B17","C17","C18","B25","C19","C20","C26",
        "B28","B43","C43","B44","B46","Q1","Q2","Q3","Q4","Q5",
        "C47","C48","C49","C50","C51","B59","B60","B65"
    )
    foreach ($addr in $profitInputCells) { Clear-Cell $profit $addr }
    foreach ($r in 69..98) {
        Clear-Cell $profit ("B" + $r)
    }
    Set-Formula $profit "B6" '=IF(B1="Flip",B4,IF(C1="hold",B4*(1+C5),+Amortization!O3))'
    Set-Formula $profit "F15" '=IF(OR($R$3=1,$R$3=2,$R$3=3),IF(OR($R$3=1,$R$3=2),-C15,Amortization!AI9),0)'
    Set-Formula $profit "D20" '=-C20'

    $amort = $wb.Worksheets.Item("Amortization")
    foreach ($addr in @("M4","P2","Q2","R2","AW2")) { Clear-Cell $amort $addr }

    # Clear project rows on other tabs, preserving headers/labels where practical.
    $clearMap = @{}
    foreach ($sheetName in $clearMap.Keys) {
        $ws = $wb.Worksheets.Item($sheetName)
        foreach ($range in $clearMap[$sheetName]) { Clear-ConstantsOnly $ws $range }
    }

    $wb.Save()
    $wb.Close($true)
    $wb = $null

    # Validate empty template can reopen.
    $verifyWb = $excel.Workbooks.Open($emptyTemplate, 0, $true)
    $vProfit = $verifyWb.Worksheets.Item("Profit")
    $emptyChecks = [ordered]@{
        EmptyTemplate = $emptyTemplate
        ProfitA4 = $vProfit.Range("A4").Text
        ProfitA14 = $vProfit.Range("A14").Text
        ProfitA21 = $vProfit.Range("A21").Text
        ProfitB4 = $vProfit.Range("B4").Text
        ProfitB6 = $vProfit.Range("B6").Formula
        ProfitF15 = $vProfit.Range("F15").Formula
        ProfitC19 = $vProfit.Range("C19").Text
        ProfitD19 = $vProfit.Range("D19").Formula
        ProfitD20 = $vProfit.Range("D20").Formula
    }
    $verifyWb.Close($false)
    $verifyWb = $null

    $emptyLines = @(
        "# Labels-Safe Empty Template",
        "",
        "Output workbook: ``$emptyTemplate``",
        "",
        "Created from Pond using Excel-native cleanup with Profit labels preserved.",
        "",
        "## Checks",
        ""
    )
    foreach ($key in $emptyChecks.Keys) { $emptyLines += "- ${key}: ``$($emptyChecks[$key])``" }
    Set-Content -LiteralPath $emptySummary -Value ($emptyLines -join "`r`n")

    # Mode 2: load Pinetree into the new empty template.
    Copy-Item -LiteralPath $emptyTemplate -Destination $output -Force
    $env:MODE2_TEMPLATE = $emptyTemplate
    $env:MODE2_PAYLOAD = $payload
    & "C:\Users\wesbr\.cache\codex-runtimes\codex-primary-runtime\dependencies\python\python.exe" "C:\Codex\Wiki Files\prepare_pinetree_payload_v2.py" | Out-Null
    $payloadData = Get-Content -LiteralPath $payload -Raw | ConvertFrom-Json

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
    Set-Value $profit "B44" $srcProfit.Range("E29").Value2
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

    for ($i = 0; $i -le 18; $i++) {
        Set-Value $profit ("B" + (69 + $i)) $srcProfit.Range("B" + (53 + $i)).Value2
    }
    for ($i = 0; $i -le 9; $i++) {
        Set-Value $profit ("B" + (89 + $i)) $srcProfit.Range("B" + (73 + $i)).Value2
    }
    Set-Formula $profit "B6" '=IF(B1="Flip",B4,IF(C1="hold",B4*(1+C5),+Amortization!O3))'
    Set-Formula $profit "F15" '=IF(OR($R$3=1,$R$3=2,$R$3=3),IF(OR($R$3=1,$R$3=2),-C15,Amortization!AI9),0)'
    Set-Formula $profit "D20" '=-C20'

    foreach ($assignment in $payloadData.assignments) {
        $tgtWs = $targetWb.Worksheets.Item($assignment.sheet)
        Set-Value $tgtWs $assignment.addr $assignment.value
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

    $targetWb.Save()
    $targetWb.Close($true)
    $targetWb = $null
    $sourceWb.Close($false)
    $sourceWb = $null

    $verifyWb = $excel.Workbooks.Open($output, 0, $true)
    $vProfit = $verifyWb.Worksheets.Item("Profit")
    $vGantt = $verifyWb.Worksheets.Item("Gnatt Chart")
    $checks = [ordered]@{
        Output = $output
        EmptyTemplate = $emptyTemplate
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
        ProfitH22 = $vProfit.Range("H22").Text
        ProfitH54 = $vProfit.Range("H54").Text
        ProfitF15 = $vProfit.Range("F15").Formula
        GnattI2 = $vGantt.Range("I2").Formula
        ContractRowsLoaded = ($targetRow - 2)
        Misc2ReviewNote = "Source MISC 2 not loaded in core pass; needs explicit destination decision."
    }
    $verifyWb.Close($false)
    $verifyWb = $null

    $lines = @(
        "# Pinetree Mode 2 Labels-Safe Conversion",
        "",
        "Output workbook: ``$output``",
        "",
        "Created by rerunning Mode 1 and Mode 2 from Pond with Profit labels preserved and refinance disabled unless explicitly mapped.",
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
    if ($null -ne $sourceWb) { try { $sourceWb.Close($false) } catch {} }
    if ($null -ne $targetWb) { try { $targetWb.Close($false) } catch {} }
    if ($null -ne $wb) { try { $wb.Close($false) } catch {} }
    if ($null -ne $excel) {
        try { $excel.Quit() } catch {}
        [System.Runtime.InteropServices.Marshal]::ReleaseComObject($excel) | Out-Null
    }
    if (Test-Path -LiteralPath $payload) { Remove-Item -LiteralPath $payload -Force }
    [GC]::Collect()
    [GC]::WaitForPendingFinalizers()
}
