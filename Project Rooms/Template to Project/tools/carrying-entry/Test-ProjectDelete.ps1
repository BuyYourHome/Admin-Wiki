param([Parameter(Mandatory)][string]$Workbook,[Parameter(Mandatory)][string]$Evidence)
$ErrorActionPreference='Stop'
function Assert($ok,$message){if(-not $ok){throw $message}}
function Set-Cell($cell,$value){[void]$cell.GetType().InvokeMember('Value2',[Reflection.BindingFlags]::SetProperty,$null,$cell,@($value))}
function Set-Formulas($range,$value){$args=[object[]]::new(1);$args[0]=$value;[void]$range.GetType().InvokeMember('Formula2',[Reflection.BindingFlags]::SetProperty,$null,$range,$args)}
function Same($a,$b){if(($null -eq $a -or $a -ceq '') -and ($null -eq $b -or $b -ceq '')){return $true};return $a -ceq $b}
$e=New-Object -ComObject Excel.Application
$e.Visible=$false;$e.DisplayAlerts=$false;$e.EnableEvents=$false;$e.AutomationSecurity=1
try{
 $b=$e.Workbooks.Open($Workbook,0,$false);$s=$b.Worksheets.Item('Carrying');$t=$s.ListObjects.Item('tblCarryingExpenses')
 function Run($name){$e.Run("'"+$b.Name.Replace("'","''")+"'!"+$name)}
 function Choose($range){$s.Activate();$range.Select()}
 $count=$t.ListRows.Count;$original=$null;$values=$null
 if($count){$original=$t.DataBodyRange.Formula2;$values=$t.DataBodyRange.Value2}
 $grid=$b.Names.Item('ceEditGrid').RefersToRange;$gf=$grid.Formula2
 $head=$b.Names.Item('ceEditHeaders').RefersToRange
 $form=@{};foreach($f in @('Date','Category','Vendor','Description','Amount','Include','Invoice','Source','SourceFile','Status','Notes')){$form[$f]=$b.Names.Item('ce'+$f).RefersToRange.Formula2}
 $cm=$b.VBProject.VBComponents.Item('BYHCarryingEdit').CodeModule
 $line=0;$start=$cm.ProcStartLine('DeleteConfirm',0)
 for($i=$start;$i -lt $start+$cm.ProcCountLines('DeleteConfirm',0);$i++){if($cm.Lines($i,1) -match '^\s*DeleteConfirm = '){$line=$i;break}}
 Assert ($line -gt 0 -and $cm.Lines($line,1).Contains('vbDefaultButton2')) 'Confirmation must default No.'
 Assert ($e.Calculation -eq -4105) 'Calculation must be Automatic.'
 $lastRight=0;$positions=@()
 foreach($n in @('ceRecurringButton','ceInsertButton','ceEditButton','ceSaveButton','ceCancelButton','ceDeleteButton')){
  $sh=$s.Shapes.Item($n);Assert ($sh.Visible -eq -1 -and $sh.Left -ge $lastRight -and $sh.Top+$sh.Height -le $s.Range('A3').Top) "Button overlap/visibility: $n"
  $lastRight=$sh.Left+$sh.Width;$positions+=@{name=$n;left=$sh.Left;top=$sh.Top;width=$sh.Width;height=$sh.Height}
 }
 Assert ($lastRight -lt $b.Names.Item('ceButtonContext').RefersToRange.Left) 'Context overlap.'
 Assert ($s.Shapes.Item('ceDeleteButton').OnAction.EndsWith('!CarryingEdit_DeleteRecord')) 'Delete macro binding.'
 $cm.InsertLines($cm.CountOfLines+1,@'
Public Function DeleteTest_RowIndex() As Long
    DeleteTest_RowIndex = EditChosenRow(EditTable())
End Function
Public Sub DeleteTest_Filter()
    EditTable().Range.AutoFilter Field:=2, Criteria1:="Labor"
End Sub
Public Sub DeleteTest_Unfilter()
    EditTable().AutoFilter.ShowAllData
End Sub
'@)
 # Test-only edits stay in memory. Production keeps the real confirmation.
 $b.Names.Item('ceEditActive').RefersTo='=FALSE'
 $cm.ReplaceLine($line,'    DeleteConfirm = False')
 $samples=[Collections.Generic.List[object]]::new();$mapped=0;$undated=0
 for($col=1;$col -le $head.Columns.Count;$col+=3){
  $category=[string]$head.Cells.Item(1,$col).Value2
  if($category -eq 'Mortgage Payment paid after Reinstatement'){$category='Mortgage Payment'}
  $matching=@(for($r=1;$r -le $count;$r++){if($values[$r,1] -eq 'Yes' -and $values[$r,2] -eq $category){[pscustomobject]@{row=$r;date=$values[$r,3];amount=$values[$r,6]}}})
  $matching=@($matching|Sort-Object @{Expression={if($null -eq $_.date -or $_.date -eq ''){[double]::MaxValue}else{[double]$_.date}}},row)
  Assert ($matching.Count -le $grid.Rows.Count) "Grid overflow: $category"
  for($i=0;$i -lt $matching.Count;$i++){
   $m=$matching[$i];$date=$grid.Cells.Item($i+1,$col);$amount=$grid.Cells.Item($i+1,$col+1)
   Assert (Same $date.Value2 $m.date) "Grid date mismatch: $category row $i"
   Assert ((Same $amount.Value2 $m.amount) -or ($m.amount -eq $null -and $amount.Value2 -eq 0)) "Grid amount mismatch: $category row $i"
   Choose $amount;Assert ((Run 'DeleteTest_RowIndex') -eq $m.row) "Wrong source mapping: $category row $i"
   $mapped++
   if($i -eq 0 -or -not $m.date){
    if(-not $m.date){$undated++}
    $samples.Add([pscustomobject]@{cell=$amount.Address();row=$m.row;category=$category})
   }
  }
 }
 $tested=@();$ambiguous=@()
 foreach($sample in $samples){
  Choose $s.Range($sample.cell);$result=[string](Run 'CarryingEdit_DeleteSelected')
  if($result.Contains('ambiguous')){$ambiguous+=$sample.cell;continue}
  Assert ($result.StartsWith('Delete cancelled') -and $t.ListRows.Count -eq $count) "Cancel failed $($sample.cell): $result"
  $cm.ReplaceLine($line,'    DeleteConfirm = True')
  $result=[string](Run 'CarryingEdit_DeleteSelected')
  Assert ($result.StartsWith('Deleted ') -and $t.ListRows.Count -eq $count-1) "Delete failed $($sample.cell): $result"
  $survivors=$null;if($t.ListRows.Count){$survivors=$t.DataBodyRange.Formula2}
  for($r=1;$r -le $count;$r++){
   if($r -eq $sample.row){continue};$dest=$r;if($r -gt $sample.row){$dest--}
   for($c=1;$c -le 11;$c++){Assert (Same $original[$r,$c] $survivors[$dest,$c]) "Surviving record changed $r,$c"}
  }
  $gridAfter=$grid.Formula2
  for($r=1;$r -le $gridAfter.GetLength(0);$r++){for($c=1;$c -le $gridAfter.GetLength(1);$c++){Assert (Same $gf[$r,$c] $gridAfter[$r,$c]) "Grid shifted $r,$c"}}
  foreach($key in $form.Keys){Assert (Same $form[$key] $b.Names.Item('ce'+$key).RefersToRange.Formula2) "Form changed $key"}
  $tested+=$sample
  $t.ListRows.Add()|Out-Null;Set-Formulas $t.DataBodyRange $original;$e.CalculateFullRebuild()
  $cm.ReplaceLine($line,'    DeleteConfirm = False')
 }
 # Header, spacer, multi-selection and active filters must not cause deletion.
 $cm.ReplaceLine($line,'    DeleteConfirm = True')
 foreach($range in @($head.Cells.Item(1,1),$grid.Cells.Item(1,3),$s.Range('A4'),$grid.Cells.Item(1,1).Resize(1,2))){
  Choose $range;$result=[string](Run 'CarryingEdit_DeleteSelected');Assert ($result.StartsWith('Not deleted') -and $t.ListRows.Count -eq $count) 'Invalid selection allowed.'
 }
 if($count){
  [void](Run 'DeleteTest_Filter');Choose $grid.Cells.Item(1,1);$result=[string](Run 'CarryingEdit_DeleteSelected')
  Assert ($result.Contains('filter') -and $t.ListRows.Count -eq $count) 'Filter guard failed.';[void](Run 'DeleteTest_Unfilter')
 }else{
  Choose $grid.Cells.Item(1,1);$result=[string](Run 'CarryingEdit_DeleteSelected');Assert ($result.StartsWith('Not deleted')) 'Empty table deletion allowed.'
  $row=$t.ListRows.Add().Range;$v=@('Yes','Rent',([datetime]'2026-10-01').ToOADate(),'TEST Delete','TEST only',12.34,'TEST','DELETE-TEST','TEST','Entered','Never saved')
  for($c=1;$c -le 11;$c++){Set-Cell $row.Cells.Item(1,$c) $v[$c-1]};$e.CalculateFullRebuild()
  $rentCol=0;for($col=1;$col -le $head.Columns.Count;$col+=3){if($head.Cells.Item(1,$col).Value2 -eq 'Rent'){$rentCol=$col;break}}
  Assert ($rentCol -gt 0) 'Rent test category missing.'
  Choose $grid.Cells.Item(1,$rentCol+1);$result=[string](Run 'CarryingEdit_DeleteSelected')
  Assert ($result.StartsWith('Deleted Rent') -and $t.ListRows.Count -eq 0) "Empty-interface synthetic test failed: $result"
 }
 Assert ($e.EnableEvents -eq $false) 'Event state not restored.'
 $result=[ordered]@{file=$b.Name;passed=$true;baselineRecords=$count;mappedRecords=$mapped;undatedSelections=$undated;deletedAndRestoredSamples=$tested;ambiguousSelectionsSafelyBlocked=$ambiguous;positions=$positions;changesSaved=$false}
 $result|ConvertTo-Json -Depth 6|Set-Content -LiteralPath $Evidence
 $result|ConvertTo-Json -Depth 6
}catch{Write-Output $_.ScriptStackTrace;throw}finally{
 if($b){$b.Close($false)};$e.Quit();[void][Runtime.InteropServices.Marshal]::FinalReleaseComObject($e);[GC]::Collect();[GC]::WaitForPendingFinalizers()
}
