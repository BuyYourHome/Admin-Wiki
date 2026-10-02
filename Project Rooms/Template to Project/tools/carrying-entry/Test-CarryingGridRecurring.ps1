param([Parameter(Mandatory)][string]$Workbook)
$ErrorActionPreference='Stop'
function Assert($ok,$message){if(-not $ok){throw $message}}
function Set-Cell($cell,$value){[void]$cell.GetType().InvokeMember('Value2',[Reflection.BindingFlags]::SetProperty,$null,$cell,@($value))}
$e=New-Object -ComObject Excel.Application
$e.Visible=$false;$e.DisplayAlerts=$false;$e.EnableEvents=$false;$e.AutomationSecurity=1
try{
    $b=$e.Workbooks.Open($Workbook,0,$false);$s=$b.Worksheets.Item('Carrying');$t=$s.ListObjects.Item('tblCarryingExpenses')
    $original=$t.DataBodyRange.Formula2;$count=$t.ListRows.Count;$profit=$b.Worksheets.Item('Profit').Range('B43').Value2
    function Field($name){$b.Names.Item('ce'+$name).RefersToRange}
    function Run($name){$e.Run("'"+$b.Name.Replace("'","''")+"'!"+$name)}
    function Recur{[string](Run 'CarryingEdit_RecurringFromSelection')}
    if([bool]$e.Evaluate($b.Names.Item('ceEditActive').RefersTo)){[void](Run 'CarryingEdit_Cancel')}
    $grid=$b.Names.Item('ceEditGrid').RefersToRange
    $fields=@('Date','Category','Vendor','Description','Amount','Include','Invoice','Source','SourceFile','Status','Notes')
    Set-Cell (Field 'Vendor') 'UNRELATED VENDOR';Set-Cell (Field 'Amount') 777
    $prior=@{};foreach($f in $fields){$prior[$f]=(Field $f).Formula2}
    foreach($range in @($s.Range('A1'),$grid.Cells.Item(1,1).Resize(1,2),(Field 'Vendor'),$grid.Cells.Item($grid.Rows.Count,1))){
        $s.Activate();$range.Select();$result=Recur
        Assert ($result.StartsWith('Select a bill')) "Invalid selection accepted: $result"
        foreach($f in $fields){Assert ((Field $f).Formula2 -ceq $prior[$f]) "Invalid selection changed $f"}
    }
    $b.Worksheets.Item('Profit').Activate();$b.Worksheets.Item('Profit').Range('A1').Select()
    Assert ((Recur).StartsWith('Select a bill')) 'Other worksheet accepted.'
    $s.Activate();$grid.Cells.Item(1,7).Select();(Field 'Date').MergeArea.ClearContents()
    $result=Recur;Assert ($result.StartsWith('Filled.')) "Grid prefill failed: $result"
    Assert ((Field 'Category').Value2 -eq 'Private Money') 'Wrong category.'
    Assert ((Field 'Vendor').Value2 -ne 'UNRELATED VENDOR' -and (Field 'Vendor').Value2) 'Vendor not taken from grid.'
    $vendor=(Field 'Vendor').Value2
    $candidates=@(for($i=1;$i -le $count;$i++){if($t.DataBodyRange.Cells.Item($i,2).Value2 -eq 'Private Money' -and $t.DataBodyRange.Cells.Item($i,4).Value2 -eq $vendor){[pscustomobject]@{index=$i;date=[double]$t.DataBodyRange.Cells.Item($i,3).Value2;amount=$t.DataBodyRange.Cells.Item($i,6).Value2}}})
    $latest=$candidates | Sort-Object date,index | Select-Object -Last 1
    Assert ((Field 'Amount').Value2 -eq $latest.amount) 'Did not use latest matching bill.'
    if($null -eq (Field 'Date').Value2 -or (Field 'Date').Value2 -eq ''){
        Assert ($result.Contains('Date unclear')) 'Uncertain history not disclosed.'
    }else{Assert ((Field 'Date').Value2 -gt [math]::Floor($latest.date)) 'Suggested date not after latest bill.'}
    $expected=(Field 'Amount').Value2
    (Field 'Date').Formula2='=DATE(2030,1,15)';Set-Cell (Field 'Vendor') 'UNRELATED VENDOR'
    $grid.Cells.Item(1,8).Select();[void](Run 'CarryingEdit_RecurringGuard')
    Assert ((Field 'Vendor').Value2 -eq $vendor -and (Field 'Date').Formula2 -eq '=DATE(2030,1,15)') 'Amount selection or entered-date preservation failed.'
    Assert ($b.Names.Item('ceButtonContext').RefersToRange.Cells.Item(1,1).Value2.Contains('Select a bill')) 'Old context text.'
    # Same vendor, different category and a later date must not change grid routing.
    $added=$t.ListRows.Add();Set-Cell ($added.Range.Cells.Item(1,1)) 'Yes';Set-Cell ($added.Range.Cells.Item(1,2)) 'Labor'
    Set-Cell ($added.Range.Cells.Item(1,3)) 60000;Set-Cell ($added.Range.Cells.Item(1,4)) $vendor;Set-Cell ($added.Range.Cells.Item(1,6)) 999999
    $grid.Cells.Item(1,7).Select();$result=Recur
    Assert ($result.StartsWith('Filled.') -and (Field 'Amount').Value2 -eq $expected -and (Field 'Category').Value2 -eq 'Private Money') 'Multiple-category vendor routing failed.'
    $added.Delete()
    $t.DataBodyRange.Cells.Item($latest.index,4).Select();Assert ((Recur).StartsWith('Filled.')) 'Direct table selection failed.'
    $savedVendor=$t.DataBodyRange.Cells.Item($latest.index,4).Value2
    $t.DataBodyRange.Cells.Item($latest.index,4).ClearContents();$result=Recur
    Assert ($result -eq 'Not filled: the selected bill has no Vendor.') 'Blank vendor accepted.'
    Set-Cell ($t.DataBodyRange.Cells.Item($latest.index,4)) $savedVendor
    $grid.Cells.Item(1,7).Select();[void](Run 'CarryingEdit_Load');Set-Cell (Field 'Amount') 333
    Assert ((Recur).StartsWith('Finish Save Changes')) 'Active edit not guarded.'
    Assert ((Field 'Amount').Value2 -eq 333) 'Active edit overwritten.'
    [void](Run 'CarryingEdit_Cancel')
    $s.Protect();Assert ((Recur).StartsWith('Not filled: Carrying is read-only')) 'Protected sheet accepted.';$s.Unprotect()
    # Independent month-end history proves date inference remains connected to selection.
    foreach($day in @([datetime]'2026-12-31',[datetime]'2027-01-31',[datetime]'2027-02-28')){
        $added=$t.ListRows.Add();Set-Cell ($added.Range.Cells.Item(1,1)) 'Yes';Set-Cell ($added.Range.Cells.Item(1,2)) 'Water'
        Set-Cell ($added.Range.Cells.Item(1,3)) $day.ToOADate();Set-Cell ($added.Range.Cells.Item(1,4)) 'RECUR TEST';Set-Cell ($added.Range.Cells.Item(1,5)) 'Test only';Set-Cell ($added.Range.Cells.Item(1,6)) 12
    }
    (Field 'Date').MergeArea.ClearContents();$added.Range.Cells.Item(1,4).Select();$result=Recur
    Assert ($result.StartsWith('Filled.') -and (Field 'Date').Value2 -eq ([datetime]'2027-03-31').ToOADate()) 'Month-end next date failed.'
    for($i=0;$i -lt 3;$i++){$t.ListRows.Item($t.ListRows.Count).Delete()}
    Assert ($t.ListRows.Count -eq $count) 'Record count changed.'
    $after=$t.DataBodyRange.Formula2
    for($r=1;$r -le $count;$r++){for($c=1;$c -le 11;$c++){Assert ($original[$r,$c] -ceq $after[$r,$c]) "Source changed $r,$c"}}
    Assert ([math]::Abs($b.Worksheets.Item('Profit').Range('B43').Value2-$profit) -lt .000001) 'Profit changed.'
    Assert ($e.Calculation -eq -4105 -and -not $e.EnableEvents) 'Application state changed.'
    [ordered]@{passed='Grid date/amount selection, selected vendor/category, latest bill and next date, entered date formula, invalid/multicell/other-sheet/empty selection, category separation, table selection, blank vendor, active-edit guard, protection, no insertion';records=$count;profit=$profit;changesSaved=$false}|ConvertTo-Json
}catch{Write-Output $_.ScriptStackTrace;throw}finally{
    if($b){$b.Close($false)};$e.Quit();[void][Runtime.InteropServices.Marshal]::FinalReleaseComObject($e)
    [GC]::Collect();[GC]::WaitForPendingFinalizers()
}
