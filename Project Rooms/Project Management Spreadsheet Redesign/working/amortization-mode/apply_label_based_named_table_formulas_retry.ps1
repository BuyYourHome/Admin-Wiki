$work = 'C:\Codex\Wiki Files\Project Rooms\Project Management Spreadsheet Redesign\working\amortization-mode\24_Project Management - 4121 Tensity Dr 2 - teams fetched 20260622-1615.xlsm'

$excel = New-Object -ComObject Excel.Application
$excel.Visible = $false
$excel.DisplayAlerts = $false

function Find-Cell($ws, $text) {
    $cell = $ws.Range('A1:AZ60').Find($text, [Type]::Missing, -4163, 1)
    if (-not $cell) {
        throw "Could not find label: $text"
    }
    return $cell
}

function Find-Contains($ws, $text) {
    $cell = $ws.Range('A1:AZ60').Find($text, [Type]::Missing, -4163, 2)
    if (-not $cell) {
        throw "Could not find label containing: $text"
    }
    return $cell
}

function Cell-Ref($ws, $cell) {
    return "='$($ws.Name)'!$($cell.Address($true, $true))"
}

function Right-Of-Label($ws, $labelCell) {
    $area = $labelCell.MergeArea
    return $ws.Cells.Item($area.Row, $area.Column + $area.Columns.Count)
}

function Set-WorkbookName($wb, $name, $refersTo) {
    foreach ($existing in @($wb.Names)) {
        if ($existing.Name -eq $name) {
            $existing.Delete()
            break
        }
    }
    $wb.Names.Add($name, $refersTo) | Out-Null
}

try {
    $wb = $excel.Workbooks.Open($work, $false, $false)
    $ws = $wb.Worksheets.Item('Amortization - Table Test')
    $cfd = $ws.ListObjects.Item('tblContractForDeed')
    $out = $ws.ListObjects.Item('tblBuyerOutputs')

    $contractDateLabel = Find-Cell $ws 'Contract Date:'
    $firstRateTermLabel = Find-Cell $ws 'First Rate Period Years/Months:'
    $rateChangeDateLabel = Find-Cell $ws 'Rate Change Date:'
    $contractTermLabel = Find-Cell $ws 'Contract Period Years/Months:'
    $endDateLabel = Find-Cell $ws 'End Date:'
    $rate1Label = Find-Cell $ws 'First Period Interest Rate:'
    $rate2Label = Find-Cell $ws 'Second Period Interest Rate:'

    $contractDate = Right-Of-Label $ws $contractDateLabel
    $firstRateYears = Right-Of-Label $ws $firstRateTermLabel
    $firstRateMonths = $firstRateYears.Offset(0, 1)
    $rateChangeDate = Right-Of-Label $ws $rateChangeDateLabel
    $contractYears = Right-Of-Label $ws $contractTermLabel
    $contractMonths = $contractYears.Offset(0, 1)
    $endDate = Right-Of-Label $ws $endDateLabel
    $rate1 = Right-Of-Label $ws $rate1Label
    $rate2 = Right-Of-Label $ws $rate2Label

    $rate1PaymentLabel = Find-Contains $ws 'Rate 1 Payment at'
    $rate2PaymentLabel = Find-Contains $ws 'Rate 2 Payment at'
    $rate1Payment = Right-Of-Label $ws $rate1PaymentLabel
    $rate2Payment = Right-Of-Label $ws $rate2PaymentLabel

    Set-WorkbookName $wb 'cfdContractDate' (Cell-Ref $ws $contractDate)
    Set-WorkbookName $wb 'cfdFirstRateYears' (Cell-Ref $ws $firstRateYears)
    Set-WorkbookName $wb 'cfdFirstRateMonths' (Cell-Ref $ws $firstRateMonths)
    Set-WorkbookName $wb 'cfdRateChangeDate' (Cell-Ref $ws $rateChangeDate)
    Set-WorkbookName $wb 'cfdContractYears' (Cell-Ref $ws $contractYears)
    Set-WorkbookName $wb 'cfdContractMonths' (Cell-Ref $ws $contractMonths)
    Set-WorkbookName $wb 'cfdEndDate' (Cell-Ref $ws $endDate)
    Set-WorkbookName $wb 'cfdRate1' (Cell-Ref $ws $rate1)
    Set-WorkbookName $wb 'cfdRate2' (Cell-Ref $ws $rate2)
    Set-WorkbookName $wb 'cfdRate1Payment' (Cell-Ref $ws $rate1Payment)
    Set-WorkbookName $wb 'cfdRate2Payment' (Cell-Ref $ws $rate2Payment)

    $rate1Payment.Formula = '=IF(cfdContractMonths<=0,0,ROUND(PMT(cfdRate1/12,cfdContractMonths,-$O$6,0),2))'
    $rate2Payment.Formula = '=IF(MAX(0,cfdContractMonths-cfdFirstRateMonths)<=0,0,ROUND(PMT(cfdRate2/12,MAX(0,cfdContractMonths-cfdFirstRateMonths),-IFERROR(XLOOKUP(cfdFirstRateMonths-1,tblBuyerOutputs[Period],tblContractForDeed[End Bal]),$O$6),0),2))'

    $summary = Find-Cell $ws 'Contract for Deed Summary'
    for ($r = $summary.Row + 1; $r -le $summary.Row + 10; $r++) {
        $label = [string]$ws.Cells.Item($r, $summary.Column).Text
        $valueCell = $ws.Cells.Item($r, $summary.Column + 3)
        switch ($label) {
            'Rate 1 Payment' { $valueCell.Formula = '=cfdRate1Payment' }
            'Rate 2 Payment' { $valueCell.Formula = '=cfdRate2Payment' }
            'Balance at Rate Change' { $valueCell.Formula = '=IFERROR(XLOOKUP(cfdFirstRateMonths-1,tblBuyerOutputs[Period],tblContractForDeed[End Bal]),"")' }
            'Month 12 Cash Flow' { $valueCell.Formula = '=IFERROR(XLOOKUP(12,tblScheduleIndex[Period],tblBuyerOutputs[Monthly Cash Flow]),"")' }
            'Cumulative Cash Flow' { $valueCell.Formula = '=IFERROR(XLOOKUP(cfdFirstRateMonths-1,tblBuyerOutputs[Period],tblBuyerOutputs[Cumul Cash Flow]),"")' }
            'Monthly Appreciation' { $valueCell.Formula = '=IFERROR(XLOOKUP(cfdFirstRateMonths-1,tblBuyerOutputs[Period],tblBuyerOutputs[Monthly Appr]),"")' }
            'Cumulative Appreciation' { $valueCell.Formula = '=IFERROR(XLOOKUP(cfdFirstRateMonths-1,tblBuyerOutputs[Period],tblBuyerOutputs[Cumul Appr]),"")' }
            'Rate Change Months' { $valueCell.Formula = '=cfdFirstRateMonths' }
        }
    }

    $cfd.ListColumns.Item('Int Rate').DataBodyRange.Formula = '=IF([@Date]="","",IF([@Date]<cfdRateChangeDate,cfdRate1,cfdRate2))'
    $cfd.ListColumns.Item('Payment').DataBodyRange.Formula = '=IF(OR([@Date]="",INDEX(tblBuyerOutputs[Period],ROW()-ROW(tblContractForDeed[#Headers]))="",INDEX(tblBuyerOutputs[Period],ROW()-ROW(tblContractForDeed[#Headers]))>cfdContractMonths-1),0,IF([@Beg]<=0,0,IF(INDEX(tblBuyerOutputs[Period],ROW()-ROW(tblContractForDeed[#Headers]))=cfdContractMonths-1,[@Beg]+[@Int],MIN(IF([@Date]<cfdRateChangeDate,cfdRate1Payment,cfdRate2Payment),[@Beg]+[@Int]))))'
    $cfd.ListColumns.Item('Int').DataBodyRange.Formula = '=IF(OR([@Date]<cfdContractDate,[@Date]>cfdEndDate),0,ROUND([@Beg]*([@[Int Rate]]/12),2))'
    $out.ListColumns.Item('Period').DataBodyRange.Formula = '=IF(OR(INDEX(tblContractForDeed[Date],ROW()-ROW(tblBuyerOutputs[#Headers]))<cfdContractDate,INDEX(tblContractForDeed[Date],ROW()-ROW(tblBuyerOutputs[#Headers]))>cfdEndDate),"",COUNTIFS(INDEX(tblContractForDeed[Date],1):INDEX(tblContractForDeed[Date],ROW()-ROW(tblBuyerOutputs[#Headers])),">="&cfdContractDate,INDEX(tblContractForDeed[Date],1):INDEX(tblContractForDeed[Date],ROW()-ROW(tblBuyerOutputs[#Headers])),"<="&cfdEndDate)-1)'

    $wb.ForceFullCalculation = $true
    $excel.CalculateFullRebuild()
    $wb.Save()
    $wb.Close($true)
}
finally {
    if ($excel) {
        $excel.Quit()
        [System.Runtime.InteropServices.Marshal]::ReleaseComObject($excel) | Out-Null
    }
}
