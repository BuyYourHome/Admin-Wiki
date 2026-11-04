param(
 [Parameter(Mandatory)][ValidateSet('Inspect','Build','Verify')][string]$Mode,
 [Parameter(Mandatory)][string]$File,
 [Parameter(Mandatory)][string]$Evidence,
 [string]$Output
)
$ErrorActionPreference='Stop'
function Assert($Condition,[string]$Message){if(-not $Condition){throw $Message}}
function Ready([scriptblock]$Action){
 $until=[datetime]::UtcNow.AddSeconds(90)
 while($true){try{return (& $Action)}catch{if($_.Exception.HResult -ne -2147418111 -or [datetime]::UtcNow -ge $until){throw};Start-Sleep -Milliseconds 500}}
}
function Metadata($Book){
 $m=[ordered]@{codes=[ordered]@{};queries=[ordered]@{};names=[ordered]@{};shapes=[ordered]@{};tables=[ordered]@{}}
 foreach($c in $Book.VBProject.VBComponents){$m.codes[$c.Name]=if($c.CodeModule.CountOfLines){$c.CodeModule.Lines(1,$c.CodeModule.CountOfLines)}else{''}}
 foreach($q in $Book.Queries){$m.queries[$q.Name]=$q.Formula}
 foreach($n in $Book.Names){$m.names[$n.Name]=$n.RefersTo}
 foreach($s in $Book.Worksheets){
  $a=@();foreach($p in $s.Shapes){$a+=,@($p.Name,$p.Left,$p.Top,$p.Width,$p.Height,$p.OnAction)};$m.shapes[$s.Name]=$a
  foreach($t in $s.ListObjects){$m.tables[$t.Name]=@($s.Name,$t.Range.Address(),@($t.ListColumns|ForEach-Object {$_.Name}))}
 }
 $m.links=@($Book.LinkSources(1));return $m
}
function ReplaceProcedure($Module,[string]$Name,[string]$Code){
 $start=$Module.ProcStartLine($Name,0);$count=$Module.ProcCountLines($Name,0)
 $Module.DeleteLines($start,$count)
 if($Code){$Module.InsertLines($start,$Code)}
}
function RowFor($Table,[int]$Id){
 $a=$Table.ListColumns.Item('Index').DataBodyRange.Value2
 for($i=1;$i -le $a.GetLength(0);$i++){if($a[$i,1] -eq $Id){return $i}}
 throw "Index $Id missing"
}
function RecordMap($Table){
 $rows=@();$a=$Table.DataBodyRange.Formula2
 for($i=1;$i -le $a.GetLength(0);$i++){$row=@();for($j=1;$j -le $a.GetLength(1);$j++){$row+=,$a[$i,$j]};$rows+=($row|ConvertTo-Json -Compress -Depth 8)}
 return @($rows|Sort-Object)
}
function CheckAligned($Book){
 $s=$Book.Worksheets.Item('Gnatt Chart');$left=$s.ListObjects.Item('qryContractsToGnatt');$right=$s.ListObjects.Item('Contract_Edits')
 $a=$left.ListColumns.Item('Index').DataBodyRange.Value2;$b=$right.ListColumns.Item('Index').DataBodyRange.Value2
 for($i=1;$i -le $a.GetLength(0);$i++){Assert ($a[$i,1] -eq $b[$i,1]) "Gnatt mismatch at worksheet row $($i+24): $($a[$i,1]) versus $($b[$i,1])"}
 return $a.GetLength(0)
}
function WaitAligned($Book,$App){
 $until=[datetime]::UtcNow.AddSeconds(120)
 do {
  Start-Sleep -Seconds 2
  try {
   $pending=Ready {$App.Run("'$($Book.Name)'!BYHGnattSync.GnattIsPending")}
   Assert (-not $pending) 'Synchronization is pending.'
   $n=Ready {CheckAligned $Book};$state=Ready {$App.StatusBar};Assert (-not ($state -is [string] -and $state -like '*NOT synchronized*')) $state;return $n
  }
  catch {if([datetime]::UtcNow -ge $until){throw}}
 }while($true)
}
function SyncGnatt($App,[string]$Macro){
 $result=$App.Run(($Macro+'BYHGnattSync.RunGnattForAutomation'))
 Assert ($result -eq 'OK') "Gnatt test returned: $result"
}
$app=$null;$book=$null;$path=$File
if($Mode -eq 'Build'){Assert ($Output -and -not(Test-Path -LiteralPath $Output)) 'Use a new output path.';Copy-Item -LiteralPath $File -Destination $Output;$path=$Output}
try {
 $app=New-Object -ComObject Excel.Application
 $app.Visible=$false;$app.DisplayAlerts=$false;$app.EnableEvents=$false;$app.AutomationSecurity=if($Mode -eq 'Inspect'){3}else{1};$app.AskToUpdateLinks=$false
 $book=$app.Workbooks.Open($path,0,($Mode -ne 'Build'))
 $macro="'$($book.Name)'!"
 $sheet=$book.Worksheets.Item('Gnatt Chart');$edits=$sheet.ListObjects.Item('Contract_Edits');$view=$sheet.ListObjects.Item('qryContractsToGnatt')
 $before=Metadata $book
 $before|ConvertTo-Json -Depth 40|Set-Content -LiteralPath ([IO.Path]::ChangeExtension($Evidence,'.before.json')) -Encoding utf8
 $records=RecordMap $edits
 if($Mode -eq 'Inspect'){
  $before|ConvertTo-Json -Depth 40|Set-Content -LiteralPath $Evidence -Encoding utf8
  $sheet.PageSetup.PrintArea='$J$100:$Z$122';$sheet.PageSetup.Orientation=2;$sheet.PageSetup.Zoom=$false;$sheet.PageSetup.FitToPagesWide=1;$sheet.PageSetup.FitToPagesTall=1
  $sheet.ExportAsFixedFormat(0,[IO.Path]::ChangeExtension($Evidence,'.pdf'))
  Write-Output 'Inspection complete; no workbook saved.'
 } elseif($Mode -eq 'Build'){
  Assert (-not $book.ReadOnly) 'Working copy is read-only.'
  Assert ($edits.Range.Address() -eq '$L$24:$AN$294') 'Current owner layout differs; remap first.'
  foreach($spec in @(@('BYHGnattSync',1,'BYHGnattSync.bas'),@('BYHGnattQueryWatcher',2,'BYHGnattQueryWatcher.cls'))){
   Assert (-not $before.codes.Contains($spec[0])) 'Repair is already installed.'
   $c=$book.VBProject.VBComponents.Add($spec[1]);$c.Name=$spec[0];$c.CodeModule.AddFromString((Get-Content -Raw -LiteralPath (Join-Path $PSScriptRoot $spec[2])))
  }
  $cm=$book.VBProject.VBComponents.Item('Module1').CodeModule
  Assert ($cm.Lines(1,$cm.CountOfLines) -match 'Public Sub SortContractEdits') 'Unexpected Module1.'
  $cm.DeleteLines(1,$cm.CountOfLines)
  $cm.AddFromString("Option Explicit`r`nPublic Sub SortContractEdits(Optional ByVal Sh As Worksheet)`r`n    BYHGnattSync.ScheduleGnattSync`r`nEnd Sub")
  $cm=$book.VBProject.VBComponents.Item($sheet.CodeName).CodeModule
  $cm.DeleteLines(1,$cm.CountOfLines)
  $cm.AddFromString((Get-Content -Raw -LiteralPath (Join-Path $PSScriptRoot 'GnattSheetEvents.vba')))
  $cm=$book.VBProject.VBComponents.Item('ThisWorkbook').CodeModule
  ReplaceProcedure $cm 'Workbook_Open' "Private Sub Workbook_Open()`r`n    BYHOthersSort.InitializeOthersSort`r`n    BYHGnattSync.InitializeGnattSync`r`nEnd Sub"
  ReplaceProcedure $cm 'Workbook_BeforeClose' "Private Sub Workbook_BeforeClose(Cancel As Boolean)`r`n    BYHGnattSync.ReleaseGnattSync`r`n    BYHOthersSort.ReleaseOthersSort`r`nEnd Sub"
  ReplaceProcedure $cm 'Workbook_AfterRefresh' ''
  ReplaceProcedure $cm 'Workbook_SheetChange' ''
  ReplaceProcedure $cm 'Workbook_SheetCalculate' "Private Sub Workbook_SheetCalculate(ByVal Sh As Object)`r`n    If Sh.Name = ""Gnatt Chart"" Then BYHGnattSync.NoticeGnattCalculation`r`nEnd Sub"
  $start=$cm.ProcStartLine('FullRecalcRebuild',0);$count=$cm.ProcCountLines('FullRecalcRebuild',0);$code=$cm.Lines($start,$count)
  $anchor='    BYHOthersSort.ScheduleOthersSync'
  Assert ($code.Contains($anchor)) 'Full Recalc integration point changed.'
  ReplaceProcedure $cm 'FullRecalcRebuild' ($code.Replace($anchor,($anchor+"`r`n    BYHGnattSync.ScheduleGnattSync")))
  $query=$book.Queries.Item('qryContractsToGnatt');$q=$query.Formula
  $old='{ {"Order", Order.Ascending} }';$new='{{"Order", Order.Ascending}, {"Index", Order.Ascending}}'
  Assert ($q.Contains($old)) 'Unexpected Gnatt query sort.'
  $query.Formula=$q.Replace($old,$new)
  Write-Output 'Native build: stabilize sort, refresh, and validate.'
  SyncGnatt $app $macro
  $count=CheckAligned $book
  Assert (($records|ConvertTo-Json -Compress) -ceq ((RecordMap $edits)|ConvertTo-Json -Compress)) 'Editable records changed.'
  $after=Metadata $book
  foreach($key in @('names','shapes','links','tables')){Assert (($before[$key]|ConvertTo-Json -Depth 30 -Compress) -ceq ($after[$key]|ConvertTo-Json -Depth 30 -Compress)) "Unrelated metadata changed: $key"}
  foreach($name in $before.queries.Keys){if($name -ne 'qryContractsToGnatt'){Assert ($before.queries[$name] -ceq $after.queries[$name]) "Unrelated query changed: $name"}}
  foreach($name in $before.codes.Keys){if($name -notin @('Module1','ThisWorkbook',$sheet.CodeName)){Assert ($before.codes[$name] -ceq $after.codes[$name]) "Unrelated VBA changed: $name"}}
  $app.Calculation=-4105
  $book.Save()
  @{passed=$true;aligned=$count;records=$edits.ListRows.Count;before=$before;after=$after}|ConvertTo-Json -Depth 40|Set-Content -LiteralPath $Evidence -Encoding utf8
  $sheet.PageSetup.PrintArea='$J$100:$Z$122';$sheet.PageSetup.Orientation=2;$sheet.PageSetup.Zoom=$false;$sheet.PageSetup.FitToPagesWide=1;$sheet.PageSetup.FitToPagesTall=1
  $sheet.ExportAsFixedFormat(0,[IO.Path]::ChangeExtension($Evidence,'.pdf'))
  Write-Output "Build passed: $count aligned displayed records; 270 edit records preserved."
 } else {
  Assert ($app.Calculation -eq -4105) 'Saved workbook is not Automatic.'
  $checks=[ordered]@{}
  $checks.open=CheckAligned $book
  [void]$app.Run(($macro+'BYHGnattSync.InitializeGnattSync'))
  [void]$app.Run(($macro+'BYHOthersSort.InitializeOthersSort'))
  SyncGnatt $app $macro
  $checks.initial=CheckAligned $book
  Write-Output 'Verify: automatic Rank edit and restore.'
  $app.EnableEvents=$true
  $r=RowFor $edits 74;$rank=$edits.ListColumns.Item('Rank').DataBodyRange.Cells.Item($r,1).Value2
  $edits.ListColumns.Item('Rank').DataBodyRange.Cells.Item($r,1).Value2='12'
  $checks.rank=WaitAligned $book $app
  $r=RowFor $edits 74;$edits.ListColumns.Item('Rank').DataBodyRange.Cells.Item($r,1).Value2='11'
  $checks.equalRank=WaitAligned $book $app
  Assert ((RowFor $edits 74) -lt (RowFor $edits 184)) 'Equal Order did not use Index as the tie breaker.'
  $r=RowFor $edits 74;$edits.ListColumns.Item('Rank').DataBodyRange.Cells.Item($r,1).Value2=[string]$rank
  $checks.rankRestore=WaitAligned $book $app
  Write-Output 'Verify: unapprove and reapprove Index 14.'
  $r=RowFor $edits 14;$approve=$edits.ListColumns.Item('Approve').DataBodyRange.Cells.Item($r,1).Value2
  $edits.ListColumns.Item('Approve').DataBodyRange.Cells.Item($r,1).Value2='No'
  Start-Sleep -Seconds 3
  $checks.unapproved=WaitAligned $book $app
  Assert ($view.ListRows.Count -eq $checks.initial-1) 'Unapproved item remains in the left query.'
  $r=RowFor $edits 14;Assert ($r -gt $view.ListRows.Count) 'Unapproved record remains beside an approved record.'
  $edits.ListColumns.Item('Approve').DataBodyRange.Cells.Item($r,1).Value2=$approve
  $checks.reapproved=WaitAligned $book $app
  Assert ($view.ListRows.Count -eq $checks.initial) 'Reapproval did not restore the record.'
  Write-Output 'Verify: manual calculation state and failure cleanup.'
  $app.EnableEvents=$false;$app.ScreenUpdating=$false;$app.Calculation=-4135
  SyncGnatt $app $macro
  Assert ($app.Calculation -eq -4135 -and -not $app.EnableEvents -and -not $app.ScreenUpdating) 'Caller state not restored.'
  $sheet.Protect('gnatt-test')
  $failure=$app.Run(($macro+'BYHGnattSync.RunGnattForAutomation'))
  Assert ($failure -like 'ERROR:*protected*' -and $app.StatusBar -like '*protected*') 'Failure was silent.'
  Assert ($app.Calculation -eq -4135 -and -not $app.EnableEvents -and -not $app.ScreenUpdating) 'Failure changed caller state.'
  $sheet.Unprotect('gnatt-test')
  SyncGnatt $app $macro
  $checks.cleanup=$true
  $app.Calculation=-4105;$app.EnableEvents=$true;$app.ScreenUpdating=$true
  Write-Output 'Verify: external query refresh event.'
  [void]$view.QueryTable.Refresh($false)
  Start-Sleep -Seconds 3
  $checks.queryRefresh=WaitAligned $book $app
  Write-Output 'Verify: Refresh All and post-refresh idle state.'
  $book.RefreshAll()
  Start-Sleep -Seconds 5
  $checks.refreshAll=WaitAligned $book $app
  Start-Sleep -Seconds 3
  $checks.idle=WaitAligned $book $app
  $app.EnableEvents=$false
  Assert (($records|ConvertTo-Json -Compress) -ceq ((RecordMap $edits)|ConvertTo-Json -Compress)) 'Test restore changed editable records.'
  $checks.recordsPreserved=$true
  $checks.final=CheckAligned $book
  @{passed=$true;checks=$checks;status=$app.StatusBar}|ConvertTo-Json -Depth 15|Set-Content -LiteralPath $Evidence -Encoding utf8
  Write-Output ($checks|ConvertTo-Json -Compress)
 }
} catch {
 Write-Output ($_ | Format-List * -Force | Out-String)
 if($null -ne $app){try{Write-Output "Excel status: $($app.StatusBar)"}catch{}}
 throw
} finally {
 if($null -ne $book){
  if($Mode -ne 'Inspect'){
   try{[void]$app.Run(($macro+'BYHGnattSync.ReleaseGnattSync'))}catch{}
   try{[void]$app.Run(($macro+'BYHOthersSort.ReleaseOthersSort'))}catch{}
  }
  $app.EnableEvents=$false;$book.Close($false)
 }
 if($null -ne $app){$app.Quit()}
 if($null -ne $book){[void][Runtime.InteropServices.Marshal]::FinalReleaseComObject($book)}
 if($null -ne $app){[void][Runtime.InteropServices.Marshal]::FinalReleaseComObject($app)}
}
