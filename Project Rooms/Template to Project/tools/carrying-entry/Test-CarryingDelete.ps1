param([Parameter(Mandatory)][string]$Workbook,[Parameter(Mandatory)][string]$Evidence)
$ErrorActionPreference='Stop'
function Assert($ok,$message){if(-not $ok){throw $message}}
function Near($a,$b){[math]::Abs([double]$a-[double]$b) -lt .000001}
function Set-Cell($cell,$value){[void]$cell.GetType().InvokeMember('Value2',[Reflection.BindingFlags]::SetProperty,$null,$cell,@($value))}
function Set-Formulas($range,$value){$args=[object[]]::new(1);$args[0]=$value;[void]$range.GetType().InvokeMember('Formula2',[Reflection.BindingFlags]::SetProperty,$null,$range,$args)}
$e=New-Object -ComObject Excel.Application
$e.Visible=$false;$e.DisplayAlerts=$false;$e.EnableEvents=$false;$e.AutomationSecurity=1
try{
    $b=$e.Workbooks.Open($Workbook,0,$false);$s=$b.Worksheets.Item('Carrying');$p=$b.Worksheets.Item('Profit');$t=$s.ListObjects.Item('tblCarryingExpenses')
    function Run($name){$e.Run("'"+$b.Name.Replace("'","''")+"'!"+$name)}
    function Field($name){$b.Names.Item('ce'+$name).RefersToRange}
    function Choose($address){$s.Activate();$s.Range($address).Select()}
    function Calc{$e.CalculateFullRebuild()}
    $cm=$b.VBProject.VBComponents.Item('BYHCarryingEdit').CodeModule
    $line=0;$start=$cm.ProcStartLine('DeleteConfirm',0)
    for($i=$start;$i -lt $start+$cm.ProcCountLines('DeleteConfirm',0);$i++){if($cm.Lines($i,1) -match '^\s*DeleteConfirm = '){$line=$i;break}}
    Assert ($line -gt 0 -and $cm.Lines($line,1).Contains('vbDefaultButton2')) 'Real confirmation must default to No.'
    function Answer($expression){$cm.ReplaceLine($line,'    '+$expression)}
    $harness=$b.VBProject.VBComponents.Add(1);$harness.Name='DeleteTestOnly'
    $harness.CodeModule.AddFromString(@'
Public deleteTestPrompt As String
Public Function DeleteTest_Cancel(ByVal p As String) As Boolean
    deleteTestPrompt = p
    DeleteTest_Cancel = False
End Function
Public Function DeleteTest_Prompt() As String
    DeleteTest_Prompt = deleteTestPrompt
End Function
Public Sub DeleteTest_Reverse()
    Dim lo As ListObject
    Set lo = ThisWorkbook.Worksheets("Carrying").ListObjects("tblCarryingExpenses")
    lo.Sort.SortFields.Clear
    lo.Sort.SortFields.Add Key:=lo.ListColumns("Date").Range, Order:=xlDescending
    lo.Sort.Header = xlYes
    lo.Sort.Apply
End Sub
Public Sub DeleteTest_Filter()
    ThisWorkbook.Worksheets("Carrying").ListObjects("tblCarryingExpenses").Range.AutoFilter Field:=2, Criteria1:="Labor"
End Sub
Public Sub DeleteTest_Unfilter()
    ThisWorkbook.Worksheets("Carrying").ListObjects("tblCarryingExpenses").AutoFilter.ShowAllData
End Sub
'@)
    $count=$t.ListRows.Count;$original=$t.DataBodyRange.Formula2;$expenses=$p.Range('B43').Value2;$rent=$p.Range('V19').Value2
    $grid=$b.Names.Item('ceEditGrid').RefersToRange;$gridFormula=$grid.Formula2
    $form=@{};foreach($f in @('Date','Category','Vendor','Description','Amount','Include','Invoice','Source','SourceFile','Status','Notes')){$form[$f]=(Field $f).Formula2}
    $passed=[Collections.Generic.List[string]]::new()
    Assert ($e.Calculation -eq -4105 -and $count -eq 68) 'Unexpected candidate baseline.'
    Assert ($s.Shapes.Item('ceDeleteButton').OnAction.EndsWith('!CarryingEdit_DeleteRecord')) 'Button binding wrong.'
    Answer 'DeleteConfirm = DeleteTest_Cancel(deletePrompt)';Choose 'AL10'
    $result=[string](Run 'CarryingEdit_DeleteSelected')
    Assert ($result.StartsWith('Delete cancelled') -and $t.ListRows.Count -eq $count) "Cancel failed: $result"
    $prompt=[string](Run 'DeleteTest_Prompt')
    Assert ($prompt.Contains('Ever Cardoza') -and $prompt.Contains('TENSITY-RENT-2025-07') -and $prompt.Contains('Undo cannot restore')) 'Confirmation lacks record identity or recovery warning.'
    $passed.Add('Real confirmation defaults No; matching record preview and Cancel preserve all rows')
    Answer 'DeleteConfirm = True'
    foreach($address in @('AK7','AL31','AM10','AL30','AO61','A4','AK10:AL10')){
        Choose $address;$result=[string](Run 'CarryingEdit_DeleteSelected')
        Assert ($result.StartsWith('Not deleted') -and $t.ListRows.Count -eq $count) "Invalid selection accepted: $address $result"
    }
    $p.Activate();$p.Range('C9').Select();$result=[string](Run 'CarryingEdit_DeleteSelected');Assert ($result.StartsWith('Not deleted')) 'Wrong sheet allowed.'
    $b.Names.Item('ceEditActive').RefersTo='=TRUE';Choose 'AL10';$result=[string](Run 'CarryingEdit_DeleteSelected')
    Assert ($result.Contains('Cancel Edit') -and $t.ListRows.Count -eq $count) 'Active edit allowed deletion.';$b.Names.Item('ceEditActive').RefersTo='=FALSE'
    $s.Protect();Choose 'AL10';$result=[string](Run 'CarryingEdit_DeleteSelected');$s.Unprotect()
    Assert ($result.StartsWith('Not deleted') -and $t.ListRows.Count -eq $count) 'Protection bypassed.'
    $f=$s.Range('AL10').Formula2;Set-Cell $s.Range('AL10') 1850;Choose 'AL10';$result=[string](Run 'CarryingEdit_DeleteSelected');$s.Range('AL10').Formula2=$f
    Assert ($result.StartsWith('Not deleted') -and $t.ListRows.Count -eq $count) 'Overwritten grid accepted.'
    $duplicate=$t.ListRows.Add();Set-Formulas $duplicate.Range $t.ListRows.Item(57).Range.Formula2;Calc
    Choose 'AL10';$result=[string](Run 'CarryingEdit_DeleteSelected');Assert ($result.Contains('ambiguous') -and $t.ListRows.Count -eq $count+1) 'Identical duplicate not rejected.';$duplicate.Delete();Calc
    $passed.Add('Header/total/spacer/blank/multiple/table/wrong-sheet selections, active edit, protection, overwritten grid and duplicate rejected')
    Answer 'ThisWorkbook.Worksheets("Carrying").ListObjects("tblCarryingExpenses").DataBodyRange.Cells(57, 6).Value2 = 1851: DeleteConfirm = True'
    Choose 'AL10';$result=[string](Run 'CarryingEdit_DeleteSelected');Assert ($result.Contains('record changed') -and $t.ListRows.Count -eq $count) 'Changed record deleted after confirmation.'
    Set-Cell $t.DataBodyRange.Cells.Item(57,6) 1850;Calc
    Answer 'DeleteConfirm = True';Choose 'AL10';[void](Run 'DeleteTest_Filter');Assert ($t.AutoFilter.Filters.Item(2).On) 'Test filter not active.'
    $result=[string](Run 'CarryingEdit_DeleteSelected')
    Assert ($result.Contains('clear the Carrying table filter') -and $t.ListRows.Count -eq $count -and $t.AutoFilter.Filters.Item(2).On) "Filtered deletion was not safely blocked: $result"
    [void](Run 'DeleteTest_Unfilter');Calc;Choose 'AL10';$result=[string](Run 'CarryingEdit_DeleteSelected');Calc
    Assert ($result.StartsWith('Deleted Rent') -and $t.ListRows.Count -eq $count-1) "Confirmed delete failed: $result"
    Assert (Near $p.Range('V19').Value2 ($rent-1850)) 'Deleted Rent did not update Profit.'
    Assert (Near $p.Range('B43').Value2 $expenses) 'Rent deletion changed expenses.'
    Assert ($p.Range('V20').Value2 -eq 11) 'Deleted rental month not removed.'
    for($r=1;$r -le $count;$r++){
        if($r -eq 57){continue};$dest=$r;if($r -gt 57){$dest--}
        for($c=1;$c -le 11;$c++){Assert ($original[$r,$c] -ceq $t.DataBodyRange.Cells.Item($dest,$c).Formula2) "Wrong surviving record $r,$c"}
    }
    for($r=1;$r -le $grid.Rows.Count;$r++){for($c=1;$c -le $grid.Columns.Count;$c++){Assert ($gridFormula[$r,$c] -ceq $grid.Cells.Item($r,$c).Formula2) "Grid shifted $r,$c"}}
    foreach($key in $form.Keys){Assert ($form[$key] -ceq (Field $key).Formula2) "Pending form changed $key"}
    $passed.Add('Active table filter blocks deletion without changing filter; confirmed unfiltered deletion removes exactly one record; survivors/form/grid unchanged; Profit recalculates')
    $t.ListRows.Add()|Out-Null;Set-Formulas $t.DataBodyRange $original;Calc
    Answer 'Call DeleteTest_Reverse: DeleteConfirm = True';Choose 'AL10';$result=[string](Run 'CarryingEdit_DeleteSelected');Calc
    Assert ($result.StartsWith('Deleted Rent') -and $t.ListRows.Count -eq $count-1) "Re-sorted record not safely found: $result"
    Assert ($e.WorksheetFunction.CountIf($t.ListColumns.Item('Invoice #').DataBodyRange,'TENSITY-RENT-2025-07') -eq 0) 'Wrong row after sorting.'
    Assert (Near $p.Range('B43').Value2 $expenses) 'Sort/delete changed expenses.'
    $t.ListRows.Add()|Out-Null;Set-Formulas $t.DataBodyRange $original;Calc
    Answer 'DeleteConfirm = True';Choose 'B10';$result=[string](Run 'CarryingEdit_DeleteSelected');Calc
    Assert ($result.StartsWith('Deleted Duke Electric') -and (Near $p.Range('B43').Value2 ($expenses-60.23))) "Expense deletion wrong: $result"
    Assert (Near $p.Range('V19').Value2 $rent) 'Expense deletion changed rent.'
    $passed.Add('Re-sort during confirmation resolves same full record; expense deletion affects only its own totals')
    while($t.ListRows.Count -gt 1){$t.ListRows.Item($t.ListRows.Count).Delete()};Calc
    Choose 'B10';$result=[string](Run 'CarryingEdit_DeleteSelected');Calc
    Assert ($result.StartsWith('Deleted ') -and $t.ListRows.Count -eq 0) "Last-row deletion failed: $result"
    Choose 'B10';$result=[string](Run 'CarryingEdit_DeleteSelected');Assert ($result.StartsWith('Not deleted')) 'Empty table allowed deletion.'
    foreach($f in @('Date','Category','Vendor','Description','Amount','Invoice','Source','SourceFile','Status','Notes')){(Field $f).MergeArea.ClearContents()}
    Set-Cell (Field 'Date') ([datetime]'2026-10-01').ToOADate();Set-Cell (Field 'Category') 'Rent';Set-Cell (Field 'Vendor') 'TEST';Set-Cell (Field 'Description') 'TEST';Set-Cell (Field 'Amount') 10;Set-Cell (Field 'Status') 'Collected';Set-Cell (Field 'Include') $true
    [void](Run 'CarryingEdit_InsertGuard');Calc
    $populated=0;$blank=0
    foreach($record in $t.ListRows){if($e.WorksheetFunction.CountA($record.Range) -eq 0){$blank++}else{$populated++}}
    Assert ($populated -eq 1 -and $p.Range('V19').Value2 -eq 10) ("Insert after last-row deletion failed. Rows="+$t.ListRows.Count+" rent="+$p.Range('V19').Value2+" feedback="+(Field 'Feedback').Value2)
    Assert ($e.EnableEvents -eq $false) 'Event setting not restored.'
    $passed.Add('Last/empty table safe; normal insertion still works afterwards; event settings restored')
    [ordered]@{passed=$passed;changesSaved=$false;baselineRows=$count;baselineExpenses=$expenses;baselineRent=$rent;emptyInsertBlankRows=$blank;confirmationPrompt=$prompt}|ConvertTo-Json -Depth 5|Set-Content -LiteralPath $Evidence
    Get-Content -LiteralPath $Evidence
}catch{Write-Output $_.ScriptStackTrace;throw}finally{
    if($b){$b.Close($false)};$e.Quit();[void][Runtime.InteropServices.Marshal]::FinalReleaseComObject($e)
    [GC]::Collect();[GC]::WaitForPendingFinalizers()
}
