param([Parameter(Mandatory)][string]$Workbook,[string]$PreviewPdf)
$ErrorActionPreference='Stop'
function Assert($ok,$message){if(-not $ok){throw $message}}
function Set-Cell($cell,$value){[void]$cell.GetType().InvokeMember('Value2',[Reflection.BindingFlags]::SetProperty,$null,$cell,@($value))}
$e=New-Object -ComObject Excel.Application
$e.Visible=$false;$e.DisplayAlerts=$false;$e.EnableEvents=$false;$e.AutomationSecurity=1
try{
    $b=$e.Workbooks.Open($Workbook,0,$false)
    $s=$b.Worksheets.Item('Carrying');$t=$s.ListObjects.Item('tblCarryingExpenses');$p=$b.Worksheets.Item('Profit')
    $count=$t.ListRows.Count;$baseline=[double]$p.Range('B43').Value2
    $initial=$t.DataBodyRange.Formula2
    function Field($name){$b.Names.Item('ce'+$name).RefersToRange}
    function Run($name,$arg=$null){if($null -eq $arg){$e.Run("'"+$b.Name.Replace("'","''")+"'!"+$name)}else{$e.Run("'"+$b.Name.Replace("'","''")+"'!"+$name,$arg)}}
    function Cancel{[string](Run 'CarryingEdit_Cancel')}
    function Load($index){[string](Run 'CarryingEdit_Load' $index)}
    function Save{[string](Run 'CarryingEdit_Save')}
    $passed=[Collections.Generic.List[string]]::new()
    Assert ($e.Calculation -eq -4105) 'Not Automatic on reopen.'
    Assert ($s.Shapes.Item('ceSaveButton').ControlFormat.Enabled -eq $false) 'Save initially enabled.'
    Set-Cell (Field 'Vendor') 'PENDING draft'
    Set-Cell (Field 'Amount') 777
    $s.Activate();$s.Range('A8').Select()
    $result=[string](Run 'CarryingEdit_Load')
    Assert ($result.StartsWith('Editing ') -and (Field 'Amount').Value2 -eq 60.23) "Grid load failed: $result"
    Assert ($s.Shapes.Item('ceSaveButton').ControlFormat.Enabled) 'Save not enabled.'
    [void](Run 'CarryingEdit_InsertGuard');Assert ($t.ListRows.Count -eq $count) 'Insert guard failed.'
    [void](Run 'CarryingEdit_RecurringGuard');Assert ((Field 'Amount').Value2 -eq 60.23) 'Recurring overwrote edit.'
    Set-Cell (Field 'Amount') 61.23
    $result=Save
    Assert ($result.StartsWith('Saved changes') -and $t.ListRows.Count -eq $count) "Save failed: $result"
    Assert ([math]::Abs($p.Range('B43').Value2-$baseline-1) -lt .001) 'Edited amount did not reach Profit.'
    Assert ((Field 'Vendor').Value2 -eq 'PENDING draft' -and (Field 'Amount').Value2 -eq 777) "Pending entry not restored: vendor=$((Field 'Vendor').Value2), amount=$((Field 'Amount').Value2)."
    Assert ($t.DataBodyRange.Cells.Item(1,6).Value2 -eq 61.23) 'Wrong source row edited.'
    $after=$t.DataBodyRange.Formula2
    for($r=1;$r -le $count;$r++){for($c=1;$c -le 11;$c++){if($r -eq 1 -and $c -eq 6){continue};Assert ($initial[$r,$c] -ceq $after[$r,$c]) "Unrelated field changed $r,$c"}}
    $passed.Add('Grid selection, single-field save, automatic totals, pending-form restore and entry guards')
    Write-Output $passed[$passed.Count-1]
    [void](Load 1);Set-Cell (Field 'Amount') 99999;[void](Cancel)
    Assert ($t.DataBodyRange.Cells.Item(1,6).Value2 -eq 61.23) 'Cancel changed record.'
    [void](Load 1);$result=Save;Assert ($result -eq 'No changes; edit closed.') 'No-op save failed.'
    [void](Load 1);Set-Cell (Field 'Category') 'invalid category';$result=Save
    Assert ($result.StartsWith('Not saved: select a valid')) 'Invalid category accepted.'
    [void](Cancel)
    [void](Load 1);Set-Cell (Field 'Date') 'not a date';$result=Save
    Assert ($result.StartsWith('Not saved: enter a valid Date')) 'Invalid date accepted.'
    [void](Cancel)
    [void](Load 1);Set-Cell (Field 'Amount') 'not an amount';$result=Save
    Assert ($result.StartsWith('Not saved: Amount')) 'Invalid amount accepted.'
    [void](Cancel)
    $passed.Add('Cancel, no-op save and rejected input preservation')
    Write-Output $passed[$passed.Count-1]
    # An untouched blank and fractional date must survive an unrelated edit.
    $blank=0
    for($r=1;$r -le $count;$r++){if($null -eq $t.DataBodyRange.Cells.Item($r,6).Value2){$blank=$r;break}}
    Assert ($blank -gt 0) 'Expected mapped blank record.'
    $dateBefore=$t.DataBodyRange.Cells.Item($blank,3).Value2
    [void](Load $blank);Set-Cell (Field 'Notes') 'TEST blank preserved';$result=Save
    Assert ($result.StartsWith('Saved') -and $null -eq $t.DataBodyRange.Cells.Item($blank,6).Value2 -and $dateBefore -eq $t.DataBodyRange.Cells.Item($blank,3).Value2) 'Blank/date changed.'
    $passed.Add('Unchanged blank amounts and original date fractions preserved')
    Write-Output $passed[$passed.Count-1]
    foreach($invoice in '00001','00002'){
        $row=$t.ListRows.Add().Range
        $vals=@('Yes','Labor',([datetime]'2026-10-01').ToOADate(),'TEST edit vendor','TEST edit record',12.34,'Manual Entry',$invoice,'TEST only','Entered','')
        for($c=1;$c -le 11;$c++){if($c -notin 3,6){$row.Cells.Item(1,$c).NumberFormat='@'};Set-Cell $row.Cells.Item(1,$c) $vals[$c-1]}
        $row.Cells.Item(1,3).NumberFormat='m/d/yyyy'
        if($invoice -eq '00002'){$row.Cells.Item(1,3).Value2+=1;$row.Cells.Item(1,6).Value2=90.12}
    }
    $one=$count+1;$two=$count+2
    [void](Load $one);Set-Cell (Field 'Invoice') '00002';Set-Cell (Field 'Amount') 999
    [void]$t.Range.AutoFilter(2,'Duke Electric')
    $result=Save;Assert ($result -eq 'Not saved: possible duplicate vendor/invoice number.') "Hidden duplicate missed: $result"
    Assert ($t.DataBodyRange.Cells.Item($one,6).Value2 -eq 12.34) 'Rejected duplicate partially wrote.'
    [void](Cancel);$t.AutoFilter.ShowAllData()
    [void](Load $one);Set-Cell (Field 'Invoice') '00077';Set-Cell (Field 'Description') '=1+1';Set-Cell (Field 'Amount') -2.34
    Set-Cell (Field 'Include') $false
    $result=Save;Assert ($result.StartsWith('Saved')) "Credit edit failed: $result"
    Assert ($t.DataBodyRange.Cells.Item($one,5).Value2 -eq '=1+1' -and -not $t.DataBodyRange.Cells.Item($one,5).HasFormula) 'Text became formula.'
    Assert ($t.DataBodyRange.Cells.Item($one,8).Value2 -ceq '00077') 'Leading zeros lost.'
    Assert ($t.DataBodyRange.Cells.Item($one,1).Value2 -eq 'No') 'Include not saved.'
    $passed.Add('Hidden duplicate rejection, literal text, leading-zero identifiers, credit and Include edits')
    Write-Output $passed[$passed.Count-1]
    $t.DataBodyRange.Cells.Item($one,6).Formula2='=1+1'
    $t.DataBodyRange.Cells.Item($one,3).Formula2='=DATE(2026,10,1)'
    [void](Load $one);Set-Cell (Field 'Notes') 'TEST formula retained';$result=Save
    Assert ($result.StartsWith('Saved') -and $t.DataBodyRange.Cells.Item($one,6).Formula2 -eq '=1+1' -and $t.DataBodyRange.Cells.Item($one,3).Formula2 -eq '=DATE(2026,10,1)') 'Unchanged source formulas lost.'
    [void](Load $one);Set-Cell (Field 'Amount') 17
    $t.DataBodyRange.Cells.Item($one,11).Value2='TEST external change'
    $result=Save;Assert ($result.StartsWith('Not saved: record changed')) 'Stale row allowed.'
    Assert ($t.DataBodyRange.Cells.Item($one,6).Formula2 -eq '=1+1') 'Stale edit changed value.'
    [void](Cancel)
    $passed.Add('Source formulas preserved and concurrent changes rejected')
    Write-Output $passed[$passed.Count-1]
    [void](Load $one);Set-Cell (Field 'Amount') 18
    [void]$t.Range.Sort($t.ListColumns.Item('Date').DataBodyRange,2,[Type]::Missing,[Type]::Missing,1,[Type]::Missing,1,1)
    $result=Save;Assert ($result.StartsWith('Saved')) "Save after sort failed: $result"
    $found=@(for($r=1;$r -le $t.ListRows.Count;$r++){if($t.DataBodyRange.Cells.Item($r,8).Value2 -ceq '00077'){$r}})
    Assert ($found.Count -eq 1 -and $t.DataBodyRange.Cells.Item($found[0],6).Value2 -eq 18) 'Sort changed edit target.'
    $passed.Add('Record identity survives table sorting')
    Write-Output $passed[$passed.Count-1]
    [void](Load $found[0]);$s.Protect();$result=Save
    Assert ($result.StartsWith('Not saved: Carrying is read-only')) 'Protected edit allowed.'
    $s.Unprotect();[void](Cancel)
    Assert ($e.EnableEvents -eq $false) 'Event state changed.'
    $passed.Add('Protected worksheet rejected and event state preserved')
    if($PreviewPdf){
        # Render the unmodified delivered layout from a separate read-only reopen below.
        $b.Close($false);$b=$e.Workbooks.Open($Workbook,0,$true);$s=$b.Worksheets.Item('Carrying')
        $s.PageSetup.PrintArea='$A$1:$AJ$15';$s.PageSetup.Orientation=2;$s.PageSetup.Zoom=$false
        $s.PageSetup.FitToPagesWide=1;$s.PageSetup.FitToPagesTall=1
        $s.ExportAsFixedFormat(0,$PreviewPdf)
    }
    [ordered]@{passed=$passed;baselineRecords=$count;baselineProfit=$baseline;changesSaved=$false}|ConvertTo-Json -Depth 4
}catch{Write-Output $_.ScriptStackTrace;throw}finally{
    if($b){$b.Close($false)};$e.Quit();[void][Runtime.InteropServices.Marshal]::FinalReleaseComObject($e)
    [GC]::Collect();[GC]::WaitForPendingFinalizers()
}
