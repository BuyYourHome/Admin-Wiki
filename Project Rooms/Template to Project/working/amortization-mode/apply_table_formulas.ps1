$work = 'C:\Codex\Wiki Files\Project Rooms\Template to Project\working\amortization-mode\24_Project Management - 4121 Tensity Dr 2 - table formula work 20260622-124730.xlsm'

$excel = New-Object -ComObject Excel.Application
$excel.Visible = $false
$excel.DisplayAlerts = $false

try {
    $wb = $excel.Workbooks.Open($work, $false, $false)
    $ws = $wb.Worksheets.Item('Amortization - Table Test')
    $cfd = $ws.ListObjects.Item('tblContractForDeed')
    $out = $ws.ListObjects.Item('tblBuyerOutputs')

    $cfd.ListColumns.Item('Date').DataBodyRange.Formula = '=INDEX(tblSubjectToLoan[Date],ROW()-ROW(tblContractForDeed[#Headers]))'
    $cfd.ListColumns.Item('Beg').DataBodyRange.Formula = '=IF(ROW()=ROW(tblContractForDeed[#Headers])+1,$O$6,IF(INDEX(tblContractForDeed[End Bal],ROW()-ROW(tblContractForDeed[#Headers])-1)<0,0,INDEX(tblContractForDeed[End Bal],ROW()-ROW(tblContractForDeed[#Headers])-1)))'
    $cfd.ListColumns.Item('Int Rate').DataBodyRange.Formula = '=IF(INDEX(tblBuyerOutputs[Period],ROW()-ROW(tblContractForDeed[#Headers]))="","",IF(INDEX(tblBuyerOutputs[Period],ROW()-ROW(tblContractForDeed[#Headers]))<$P$12,$O$8,$O$10))'
    $cfd.ListColumns.Item('Payment').DataBodyRange.Formula = '=IF(INDEX(tblBuyerOutputs[Period],ROW()-ROW(tblContractForDeed[#Headers]))="",0,IF([@Beg]<=0,0,IF(AND(INDEX(tblBuyerOutputs[Period],ROW()-ROW(tblContractForDeed[#Headers]))=$P$12-1,$V$10=0),[@Beg]+[@Int],MIN(IF(INDEX(tblBuyerOutputs[Period],ROW()-ROW(tblContractForDeed[#Headers]))<$P$12,$V$8,$V$10),[@Beg]+[@Int]))))'
    $cfd.ListColumns.Item('Princ').DataBodyRange.Formula = '=IF([@Payment]=0,0,MAX(0,MIN([@Beg],[@Payment]-[@Int])))'
    $cfd.ListColumns.Item('Int').DataBodyRange.Formula = '=IF($S$12<=[@Date],ROUND([@Beg]*([@[Int Rate]]/12),2),0)'
    $cfd.ListColumns.Item('Ins').DataBodyRange.Formula = '=IF([@Payment]=0,0,$W$2)'
    $cfd.ListColumns.Item('Taxes').DataBodyRange.Formula = '=IF([@Princ]=0,0,$W$3)'
    $cfd.ListColumns.Item('Total').DataBodyRange.Formula = '=SUM([@Princ],[@Int],[@Ins],[@Taxes])'
    $cfd.ListColumns.Item('Cumul Princ').DataBodyRange.Formula = '=SUM(INDEX(tblContractForDeed[Princ],1):INDEX(tblContractForDeed[Princ],ROW()-ROW(tblContractForDeed[#Headers])))'
    $cfd.ListColumns.Item('End Bal').DataBodyRange.Formula = '=IF([@Beg]<=0,0,[@Beg]-[@Princ])'

    $out.ListColumns.Item('Pay Delta').DataBodyRange.Formula = '=IF(INDEX(tblContractForDeed[Payment],ROW()-ROW(tblBuyerOutputs[#Headers]))=0,0,INDEX(tblContractForDeed[Payment],ROW()-ROW(tblBuyerOutputs[#Headers]))-INDEX(tblSubjectToLoan[Payment],ROW()-ROW(tblBuyerOutputs[#Headers])))'
    $out.ListColumns.Item('Period').DataBodyRange.Formula = '=IF(INDEX(tblContractForDeed[Date],ROW()-ROW(tblBuyerOutputs[#Headers]))<$S$12,"",COUNTIFS(INDEX(tblContractForDeed[Date],1):INDEX(tblContractForDeed[Date],ROW()-ROW(tblBuyerOutputs[#Headers])),">="&$S$12)-1)'
    $out.ListColumns.Item('Monthly Cash Flow').DataBodyRange.Formula = '=IF(INDEX(tblContractForDeed[Payment],ROW()-ROW(tblBuyerOutputs[#Headers]))=0,0,INDEX(tblContractForDeed[Payment],ROW()-ROW(tblBuyerOutputs[#Headers]))-INDEX(tblSubjectToLoan[Payment],ROW()-ROW(tblBuyerOutputs[#Headers])))-IFERROR([@PMI],0)'
    $out.ListColumns.Item('Cumul Cash Flow').DataBodyRange.Formula = '=IF(INDEX(tblContractForDeed[Payment],ROW()-ROW(tblBuyerOutputs[#Headers]))=0,IF(ROW()=ROW(tblBuyerOutputs[#Headers])+1,0,INDEX(tblBuyerOutputs[Cumul Cash Flow],ROW()-ROW(tblBuyerOutputs[#Headers])-1)),[@[Monthly Cash Flow]]+IF(ROW()=ROW(tblBuyerOutputs[#Headers])+1,0,INDEX(tblBuyerOutputs[Cumul Cash Flow],ROW()-ROW(tblBuyerOutputs[#Headers])-1)))'
    $out.ListColumns.Item('Monthly Appr').DataBodyRange.Formula = '=IF(INDEX(tblContractForDeed[End Bal],ROW()-ROW(tblBuyerOutputs[#Headers]))<=0,0,($O$6+IF(ROW()=ROW(tblBuyerOutputs[#Headers])+1,0,INDEX(tblBuyerOutputs[Cumul Appr],ROW()-ROW(tblBuyerOutputs[#Headers])-1)))*$AK$2/12)'
    $out.ListColumns.Item('Cumul Appr').DataBodyRange.Formula = '=IF(INDEX(tblContractForDeed[End Bal],ROW()-ROW(tblBuyerOutputs[#Headers]))<=0,0,IF(ROW()=ROW(tblBuyerOutputs[#Headers])+1,0,INDEX(tblBuyerOutputs[Cumul Appr],ROW()-ROW(tblBuyerOutputs[#Headers])-1))+[@[Monthly Appr]])'

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
