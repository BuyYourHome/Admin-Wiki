$work = 'C:\Codex\Wiki Files\Project Rooms\Template to Project\working\amortization-mode\24_Project Management - 4121 Tensity Dr 2 - teams fetched 20260622-1520.xlsm'

$excel = New-Object -ComObject Excel.Application
$excel.Visible = $false
$excel.DisplayAlerts = $false

try {
    $wb = $excel.Workbooks.Open($work, $false, $false)
    $ws = $wb.Worksheets.Item('Amortization - Table Test')
    $cfd = $ws.ListObjects.Item('tblContractForDeed')
    $out = $ws.ListObjects.Item('tblBuyerOutputs')

    $contractDate = $ws.Range('J12').Value2
    $rateChangeDate = $ws.Range('S12').Value2
    $endDate = $ws.Range('S13').Value2
    $oldRateMonths = $ws.Range('P12').Value2

    if ($rateChangeDate -eq $contractDate -and $oldRateMonths -gt 0) {
        $ws.Range('S12').Value2 = $excel.WorksheetFunction.EDate($ws.Range('J12'), [int]$oldRateMonths)
    }
    $ws.Range('S13').Value2 = $endDate

    $ws.Range('O12').Formula = '=IFERROR($P$12/12,"")'
    $ws.Range('P12').Formula = '=IFERROR(DATEDIF($J$12,$S$12,"m"),0)'
    $ws.Range('O13').Formula = '=IFERROR($P$13/12,"")'
    $ws.Range('P13').Formula = '=IFERROR(DATEDIF($J$12,$S$13,"m")+1,0)'

    $ws.Range('V8').Formula = '=IF($P$12<=0,0,ROUND(PMT($O$8/12,$P$12,-$O$6,0),2))'
    $ws.Range('O9').Formula = '=IF($P$12<=0,0,ROUND(PMT($O$8/12,$P$12,-$O$6,0),2))'
    $ws.Range('P9').Formula = '=IF($P$12<=0,0,ROUND(PMT(P8/12,$P$12,-P6,0),2))'
    $ws.Range('Q9').Formula = '=IF($P$12<=0,0,ROUND(PMT(Q8/12,$P$12,-Q6,0),2))'
    $ws.Range('R9').Formula = '=IF($P$12<=0,0,ROUND(PMT(R8/12,$P$12,-R6,0),2))'
    $ws.Range('V10').Formula = '=IF(MAX(0,$P$13-$P$12)<=0,0,ROUND(PMT($O$10/12,MAX(0,$P$13-$P$12),-IFERROR(XLOOKUP($P$12-1,tblBuyerOutputs[Period],tblContractForDeed[End Bal]),$O$6),0),2))'

    $ws.Range('AB5').Formula = '=IFERROR(XLOOKUP($P$12-1,tblBuyerOutputs[Period],tblContractForDeed[End Bal]),"")'
    $ws.Range('AB10').Formula = '=$P$12'

    $cfd.ListColumns.Item('Int Rate').DataBodyRange.Formula = '=IF([@Date]="","",IF([@Date]<$S$12,$O$8,$O$10))'
    $cfd.ListColumns.Item('Payment').DataBodyRange.Formula = '=IF(OR([@Date]="",[@Date]<$J$12,[@Date]>$S$13),0,IF([@Beg]<=0,0,IF(AND([@Date]<$S$12,$V$10=0,INDEX(tblBuyerOutputs[Period],ROW()-ROW(tblContractForDeed[#Headers]))=$P$12-1),[@Beg]+[@Int],MIN(IF([@Date]<$S$12,$V$8,$V$10),[@Beg]+[@Int]))))'
    $cfd.ListColumns.Item('Int').DataBodyRange.Formula = '=IF(OR([@Date]<$J$12,[@Date]>$S$13),0,ROUND([@Beg]*([@[Int Rate]]/12),2))'

    $out.ListColumns.Item('Period').DataBodyRange.Formula = '=IF(OR(INDEX(tblContractForDeed[Date],ROW()-ROW(tblBuyerOutputs[#Headers]))<$J$12,INDEX(tblContractForDeed[Date],ROW()-ROW(tblBuyerOutputs[#Headers]))>$S$13),"",COUNTIFS(INDEX(tblContractForDeed[Date],1):INDEX(tblContractForDeed[Date],ROW()-ROW(tblBuyerOutputs[#Headers])),">="&$J$12,INDEX(tblContractForDeed[Date],1):INDEX(tblContractForDeed[Date],ROW()-ROW(tblBuyerOutputs[#Headers])),"<="&$S$13)-1)'

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
