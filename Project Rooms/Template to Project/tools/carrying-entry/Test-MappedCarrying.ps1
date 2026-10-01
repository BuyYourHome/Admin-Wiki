param([Parameter(Mandatory)][string]$Workbook,[string]$ProfitPreview,[Parameter(Mandatory)][string]$Map)
$ErrorActionPreference='Stop'
$m=Get-Content -Raw -LiteralPath $Map | ConvertFrom-Json
$capacity=if($m.footer){[int]$m.footer-4}else{21}
function Assert($ok,$message){if(-not $ok){throw $message}}
function Set-Cell($cell,$value){[void]$cell.GetType().InvokeMember('Value2',[Reflection.BindingFlags]::SetProperty,$null,$cell,@($value))}
$e=New-Object -ComObject Excel.Application
$e.Visible=$false;$e.DisplayAlerts=$false;$e.EnableEvents=$false;$e.AutomationSecurity=1
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
        Assert (@($records).Count -le $capacity) "Grid overflow: $cat"
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
    Assert ($profit.Range('E1').Value2 -eq $m.mode) 'Original mode selection lost.'
    $modes=@()
    foreach($shape in $profit.Shapes){
        if($shape.Type -eq 8 -and $shape.FormControlType -eq 7 -and $shape.ControlFormat.LinkedCell.Replace('$','') -eq 'E1'){
            $shape.ControlFormat.Value=1;$modes+= $profit.Range('E1').Value2
            Assert ([math]::Abs([double]$profit.Range('B43').Value2-[double]$m.profitTotal) -lt .001) 'Carrying subtotal changed with mode.'
        }
    }
    Assert (($modes | Sort-Object) -join ',' -eq '1,2,3') 'Mode controls missing.'
    Assert ($b.Worksheets.Item('Docs').Range('E39').Value2 -eq $m.rent) 'Docs rent not connected.'
    $vendor=$b.Names.Item('ceVendor').RefersToRange;$date=$b.Names.Item('ceDate').RefersToRange
    Assert ($vendor.Validation.Formula1 -eq '=ceVendorList' -and $vendor.Validation.InCellDropdown) 'Vendor dropdown missing.'
    $insert=$s.Shapes.Item('ceInsertButton');$recurring=$s.Shapes.Item('ceRecurringButton')
    Assert ($insert.Width -eq $recurring.Width -and $insert.Height -eq $recurring.Height) 'Button dimensions differ.'
    Assert ($recurring.Top -gt $insert.Top+$insert.Height -and $recurring.Top+$recurring.Height -lt $s.Range('A5').Top) 'Button overlap.'
    $baseline=$profit.Range('B43').Value2;$originalRows=$t.ListRows.Count
    foreach($d in @('2026-01-10','2026-02-10','2026-03-10')){
        $r=$t.ListRows.Add().Range
        Set-Cell $r.Cells.Item(1,1) 'No';Set-Cell $r.Cells.Item(1,2) 'Labor'
        Set-Cell $r.Cells.Item(1,3) (([datetime]$d).ToOADate())
        Set-Cell $r.Cells.Item(1,4) 'TEST recurrence';Set-Cell $r.Cells.Item(1,5) ('TEST '+$d);Set-Cell $r.Cells.Item(1,6) 12.34
    }
    $vendor.Value2='TEST recurrence';$date.MergeArea.ClearContents()
    [void]$t.Range.AutoFilter(2,'Duke Electric')
    $msg=[string]$e.Run("'"+$b.Name.Replace("'","''")+"'!CarryingEntry_Prefill",0)
    Assert ($msg.StartsWith('Filled.') -and $date.Value2 -eq ([datetime]'2026-04-10').ToOADate()) 'Recurring date or description grouping failed.'
    $date.Formula2='=DATE(2027,1,2)'
    [void]$e.Run("'"+$b.Name.Replace("'","''")+"'!CarryingEntry_Prefill",0)
    Assert ($date.Formula2 -eq '=DATE(2027,1,2)') 'Entered Date formula changed.'
    $t.AutoFilter.ShowAllData()
    while($t.ListRows.Count -gt $originalRows){$t.ListRows.Item($t.ListRows.Count).Delete()}
    Assert ($profit.Range('B43').Value2 -eq $baseline) 'Prefill changed totals.'
    $review=$b.Worksheets.Item('Review')
    Assert (([string]$review.Range('B5').Validation.Formula1).Split(',') -contains 'Carrying') 'Carrying destination missing.'
    Assert ($b.Names.Item('invoiceEntryReviewRequest').RefersToRange.Address() -eq '$B$1') 'Review request marker changed.'
    Assert ($null -eq $b.LinkSources(1)) 'External links present.'
    if($ProfitPreview){
        $profit.PageSetup.PrintArea='$A$27:$M$47';$profit.PageSetup.Orientation=2
        $profit.PageSetup.Zoom=$false;$profit.PageSetup.FitToPagesWide=1;$profit.PageSetup.FitToPagesTall=1
        $profit.ExportAsFixedFormat(0,$ProfitPreview)
    }
    [ordered]@{dateAmountPairs=$pairs;records=$t.ListRows.Count;modeControls='Flip, Hold, Slow Flip passed';reviewMarker=$b.Names.Item('invoiceEntryReviewRequest').RefersTo;docsRent=$m.rent;changesSaved=$false} | ConvertTo-Json
}catch {Write-Output $_.ScriptStackTrace;throw}finally{
    if($b){$b.Close($false)}
    $e.Quit();[void][Runtime.InteropServices.Marshal]::FinalReleaseComObject($e)
    [GC]::Collect();[GC]::WaitForPendingFinalizers()
}
