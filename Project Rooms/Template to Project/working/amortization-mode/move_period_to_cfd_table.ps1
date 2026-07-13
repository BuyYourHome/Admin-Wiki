$work = 'C:\Codex\Wiki Files\Project Rooms\Template to Project\working\amortization-mode\24_Project Management - 4121 Tensity Dr 2 - teams fetched 20260622-1623.xlsm'

$excel = New-Object -ComObject Excel.Application
$excel.Visible = $false
$excel.DisplayAlerts = $false

try {
    $wb = $excel.Workbooks.Open($work, $false, $false)
    $ws = $wb.Worksheets.Item('Amortization - Table Test')

    $cfd = $ws.ListObjects.Item('tblContractForDeed')
    if (-not ($cfd.ListColumns | Where-Object { $_.Name -eq 'Period' })) {
        $ws.Columns.Item(25).Insert() | Out-Null
        $cfd = $ws.ListObjects.Item('tblContractForDeed')
        $cfd.Resize($ws.Range('N19:Y833'))
        $cfd.ListColumns.Item($cfd.ListColumns.Count).Name = 'Period'
    }

    $cfd = $ws.ListObjects.Item('tblContractForDeed')
    $out = $ws.ListObjects.Item('tblBuyerOutputs')

    $cfd.ListColumns.Item('Period').DataBodyRange.Formula = '=IF(OR([@Date]<cfdContractDate,[@Date]>cfdEndDate),"",COUNTIFS(INDEX(tblContractForDeed[Date],1):INDEX(tblContractForDeed[Date],ROW()-ROW(tblContractForDeed[#Headers])),">="&cfdContractDate,INDEX(tblContractForDeed[Date],1):INDEX(tblContractForDeed[Date],ROW()-ROW(tblContractForDeed[#Headers])),"<="&cfdEndDate)-1)'
    $cfd.ListColumns.Item('Payment').DataBodyRange.Formula = '=IF(OR([@Date]="",[@Period]="",[@Period]>cfdContractMonths-1),0,IF([@Beg]<=0,0,IF([@Period]=cfdContractMonths-1,[@Beg]+[@Int],MIN(IF([@Date]<cfdRateChangeDate,cfdRate1Payment,cfdRate2Payment),[@Beg]+[@Int]))))'

    $ws.Range('V11').Formula = '=IF(MAX(0,cfdContractMonths-cfdFirstRateMonths)<=0,0,ROUND(PMT(cfdRate2/12,MAX(0,cfdContractMonths-cfdFirstRateMonths),-IFERROR(XLOOKUP(cfdFirstRateMonths-1,tblContractForDeed[Period],tblContractForDeed[End Bal]),$O$6),0),2))'

    $summary = $ws.Cells.Find('Contract for Deed Summary')
    if ($summary) {
        for ($r = $summary.Row + 1; $r -le $summary.Row + 10; $r++) {
            $label = [string]$ws.Cells.Item($r, $summary.Column).Text
            $valueCell = $ws.Cells.Item($r, $summary.Column + 3)
            switch ($label) {
                'Balance at Rate Change' { $valueCell.Formula = '=IFERROR(XLOOKUP(cfdFirstRateMonths-1,tblContractForDeed[Period],tblContractForDeed[End Bal]),"")' }
                'Cumulative Cash Flow' { $valueCell.Formula = '=IFERROR(XLOOKUP(cfdFirstRateMonths-1,tblContractForDeed[Period],tblBuyerOutputs[Cumul Cash Flow]),"")' }
                'Monthly Appreciation' { $valueCell.Formula = '=IFERROR(XLOOKUP(cfdFirstRateMonths-1,tblContractForDeed[Period],tblBuyerOutputs[Monthly Appr]),"")' }
                'Cumulative Appreciation' { $valueCell.Formula = '=IFERROR(XLOOKUP(cfdFirstRateMonths-1,tblContractForDeed[Period],tblBuyerOutputs[Cumul Appr]),"")' }
            }
        }
    }

    $out = $ws.ListObjects.Item('tblBuyerOutputs')
    if ($out.ListColumns | Where-Object { $_.Name -eq 'Period' }) {
        $out.ListColumns.Item('Period').Delete()
    }

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
