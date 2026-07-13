$work = 'C:\Codex\Wiki Files\Project Rooms\Template to Project\working\amortization-mode\24_Project Management - 4121 Tensity Dr 2 - teams fetched 20260622-1558.xlsm'

$excel = New-Object -ComObject Excel.Application
$excel.Visible = $false
$excel.DisplayAlerts = $false

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

    Set-WorkbookName $wb 'cfdContractDate' "='Amortization - Table Test'!`$J`$13"
    Set-WorkbookName $wb 'cfdFirstRateMonths' "='Amortization - Table Test'!`$P`$13"
    Set-WorkbookName $wb 'cfdRateChangeDate' "='Amortization - Table Test'!`$S`$13"
    Set-WorkbookName $wb 'cfdContractMonths' "='Amortization - Table Test'!`$P`$14"
    Set-WorkbookName $wb 'cfdEndDate' "='Amortization - Table Test'!`$S`$14"
    Set-WorkbookName $wb 'cfdRate1' "='Amortization - Table Test'!`$O`$8"
    Set-WorkbookName $wb 'cfdRate2' "='Amortization - Table Test'!`$O`$11"
    Set-WorkbookName $wb 'cfdRate1Payment' "='Amortization - Table Test'!`$V`$8"
    Set-WorkbookName $wb 'cfdRate2Payment' "='Amortization - Table Test'!`$V`$11"

    $ws.Range('V8').Formula = '=IF(cfdContractMonths<=0,0,ROUND(PMT(cfdRate1/12,cfdContractMonths,-$O$6,0),2))'
    $ws.Range('V11').Formula = '=IF(MAX(0,cfdContractMonths-cfdFirstRateMonths)<=0,0,ROUND(PMT(cfdRate2/12,MAX(0,cfdContractMonths-cfdFirstRateMonths),-IFERROR(XLOOKUP(cfdFirstRateMonths-1,tblBuyerOutputs[Period],tblContractForDeed[End Bal]),$O$6),0),2))'

    $ws.Range('AB3').Formula = '=cfdRate1Payment'
    $ws.Range('AB4').Formula = '=cfdRate2Payment'
    $ws.Range('AB5').Formula = '=IFERROR(XLOOKUP(cfdFirstRateMonths-1,tblBuyerOutputs[Period],tblContractForDeed[End Bal]),"")'
    $ws.Range('AB7').Formula = '=IFERROR(XLOOKUP(cfdFirstRateMonths-1,tblBuyerOutputs[Period],tblBuyerOutputs[Cumul Cash Flow]),"")'
    $ws.Range('AB8').Formula = '=IFERROR(XLOOKUP(cfdFirstRateMonths-1,tblBuyerOutputs[Period],tblBuyerOutputs[Monthly Appr]),"")'
    $ws.Range('AB9').Formula = '=IFERROR(XLOOKUP(cfdFirstRateMonths-1,tblBuyerOutputs[Period],tblBuyerOutputs[Cumul Appr]),"")'
    $ws.Range('AB10').Formula = '=cfdFirstRateMonths'

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
