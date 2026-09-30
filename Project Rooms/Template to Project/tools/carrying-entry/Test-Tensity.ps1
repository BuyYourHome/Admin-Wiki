param([Parameter(Mandatory)][string]$Workbook,[string]$ProfitPreview)
$ErrorActionPreference='Stop'
function Assert($ok,$message){if(-not $ok){throw $message}}
$e=New-Object -ComObject Excel.Application
$e.Visible=$false;$e.DisplayAlerts=$false;$e.EnableEvents=$false;$e.AutomationSecurity=3
try {
    $b=$e.Workbooks.Open($Workbook,0,$false)
    Assert ($e.Calculation -eq -4105) 'Not Automatic on normal reopen.'
    $s=$b.Worksheets.Item('Carrying');$t=$s.ListObjects.Item('tblCarryingExpenses')
    $data=$t.DataBodyRange.Value2;$pairs=0
    foreach($col in 1,4,7,10,13,16,19,22,25,28,31,34){
        $cat=[string]$s.Cells.Item(5,$col).Value2
        if($cat -eq 'Mortgage Payment paid after Reinstatement'){$cat='Mortgage Payment'}
        $records=@(for($r=1;$r -le $data.GetLength(0);$r++){
            if($data[$r,1] -eq 'Yes' -and $data[$r,2] -eq $cat){[pscustomobject]@{date=$data[$r,3];amount=$data[$r,6];source=$r}}
        }) | Sort-Object date,source
        Assert (@($records).Count -le 21) "Grid overflow: $cat"
        $index=0
        foreach($record in $records){
            $r=8+$index;$date=$s.Cells.Item($r,$col);$amount=$s.Cells.Item($r,$col+1)
            Assert ($date.Value2 -eq $record.date) "Date pairing: $cat $r"
            Assert ($date.Text -ne '' -and $date.Text -notmatch '#') "Date not displayed: $cat $r"
            $expected=if($null -eq $record.amount){0}else{$record.amount}
            Assert ($amount.Value2 -ceq $expected) "Amount pairing: $cat $r"
            $index++;$pairs++
        }
    }
    $profit=$b.Worksheets.Item('Profit')
    Assert ($profit.Range('E1').Value2 -eq 1) 'Original Flip selection lost.'
    Assert ($profit.Range('C44').Value2 -eq $true) 'Original private-lender checkbox value lost.'
    foreach($pair in @(@('Option Button 8',1),@('Option Button 10',2),@('Option Button 13',3))){
        $profit.Shapes.Item($pair[0]).ControlFormat.Value=1
        Assert ($profit.Range('E1').Value2 -eq $pair[1]) "Mode control failed: $($pair[0])"
        Assert ([math]::Abs([double]$profit.Range('B43').Value2-17416.09) -lt .001) 'Carrying subtotal changed with mode.'
    }
    $profit.Shapes.Item('Option Button 8').ControlFormat.Value=1
    Assert ($b.Worksheets.Item('Docs').Range('E39').Value2 -eq 1850) 'Docs rent not connected.'
    $review=$b.Worksheets.Item('Review')
    Assert (([string]$review.Range('B5').Validation.Formula1).Split(',') -contains 'Carrying') 'Carrying destination missing.'
    Assert ($b.Names.Item('invoiceEntryReviewRequest').RefersToRange.Address() -eq '$B$1') 'Review request marker changed.'
    Assert ($null -eq $b.LinkSources(1)) 'External links present.'
    if($ProfitPreview){
        $profit.PageSetup.PrintArea='$A$27:$M$47';$profit.PageSetup.Orientation=2
        $profit.PageSetup.Zoom=$false;$profit.PageSetup.FitToPagesWide=1;$profit.PageSetup.FitToPagesTall=1
        $profit.ExportAsFixedFormat(0,$ProfitPreview)
    }
    [ordered]@{dateAmountPairs=$pairs;records=$t.ListRows.Count;modeControls='Flip, Hold, Slow Flip passed';reviewMarker=$b.Names.Item('invoiceEntryReviewRequest').RefersTo;docsRent=1850;changesSaved=$false} | ConvertTo-Json
}finally{
    if($b){$b.Close($false)}
    $e.Quit();[void][Runtime.InteropServices.Marshal]::FinalReleaseComObject($e)
    [GC]::Collect();[GC]::WaitForPendingFinalizers()
}
