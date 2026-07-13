$work = 'C:\Codex\Wiki Files\Project Rooms\Template to Project\working\amortization-mode\24_Project Management - 4121 Tensity Dr 2 - teams fetched 20260622-1540.xlsm'

$excel = New-Object -ComObject Excel.Application
$excel.Visible = $false
$excel.DisplayAlerts = $false

try {
    $wb = $excel.Workbooks.Open($work, $false, $false)
    $ws = $wb.Worksheets.Item('Amortization - Table Test')
    $cfd = $ws.ListObjects.Item('tblContractForDeed')

    $ws.Range('V8').Formula = '=IF($P$13<=0,0,ROUND(PMT($O$8/12,$P$13,-$O$6,0),2))'
    $ws.Range('O9').Formula = '=IF($P$13<=0,0,ROUND(PMT($O$8/12,$P$13,-$O$6,0),2))'
    $ws.Range('P9').Formula = '=IF($P$13<=0,0,ROUND(PMT(P8/12,$P$13,-P6,0),2))'
    $ws.Range('Q9').Formula = '=IF($P$13<=0,0,ROUND(PMT(Q8/12,$P$13,-Q6,0),2))'
    $ws.Range('R9').Formula = '=IF($P$13<=0,0,ROUND(PMT(R8/12,$P$13,-R6,0),2))'
    $ws.Range('V10').Formula = '=IF(MAX(0,$P$13-$P$12)<=0,0,ROUND(PMT($O$10/12,MAX(0,$P$13-$P$12),-IFERROR(XLOOKUP($P$12-1,tblBuyerOutputs[Period],tblContractForDeed[End Bal]),$O$6),0),2))'

    $cfd.ListColumns.Item('Payment').DataBodyRange.Formula = '=IF(OR([@Date]="",INDEX(tblBuyerOutputs[Period],ROW()-ROW(tblContractForDeed[#Headers]))="",INDEX(tblBuyerOutputs[Period],ROW()-ROW(tblContractForDeed[#Headers]))>$P$13-1),0,IF([@Beg]<=0,0,IF(INDEX(tblBuyerOutputs[Period],ROW()-ROW(tblContractForDeed[#Headers]))=$P$13-1,[@Beg]+[@Int],MIN(IF([@Date]<$S$12,$V$8,$V$10),[@Beg]+[@Int]))))'

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
