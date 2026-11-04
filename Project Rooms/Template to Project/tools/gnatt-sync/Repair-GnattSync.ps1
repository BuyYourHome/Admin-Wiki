param(
 [Parameter(Mandatory)][ValidateSet('Inspect','Build','Upgrade','Verify','RefreshProbe')][string]$Mode,
 [Parameter(Mandatory)][string]$File,
 [Parameter(Mandatory)][string]$Evidence,
 [string]$Output,
 [switch]$ActivationTest,
 [string]$PreviewRange='$J$100:$Z$122'
)
$ErrorActionPreference='Stop'
function Assert($Condition,[string]$Message){if(-not $Condition){throw $Message}}
function CheckProcedureEnds([string]$Code){
 $kind=$null;$line=0
 foreach($text in ($Code -split "`r?`n")){
  $line++
  if($text -match '^\s*(?:(?:Public|Private|Friend|Static)\s+)?(Sub|Function|Property\s+(?:Get|Let|Set))\s+'){
   Assert (-not $kind) "Nested or unterminated VBA procedure near line $line."
   $kind=($Matches[1] -split '\s+')[0]
  }elseif($text -match '^\s*End\s+(Sub|Function|Property)\s*$'){
   Assert ($kind -eq $Matches[1]) "Mismatched VBA procedure ending at line $line."
   $kind=$null
  }
 }
 Assert (-not $kind) 'Unterminated VBA procedure.'
}
foreach($source in @('BYHGnattSync.bas','BYHGnattQueryWatcher.cls','GnattSheetEvents.vba')){CheckProcedureEnds (Get-Content -Raw -LiteralPath (Join-Path $PSScriptRoot $source))}
function Ready([scriptblock]$Action){
 $until=[datetime]::UtcNow.AddSeconds(90)
 while($true){try{return (& $Action)}catch{if($_.Exception.HResult -ne -2147418111 -or [datetime]::UtcNow -ge $until){throw};Start-Sleep -Milliseconds 500}}
}
function Metadata($Book){
 $m=[ordered]@{codes=[ordered]@{};queries=[ordered]@{};names=[ordered]@{};shapes=[ordered]@{};tables=[ordered]@{};refresh=[ordered]@{}}
 foreach($c in $Book.VBProject.VBComponents){$m.codes[$c.Name]=if($c.CodeModule.CountOfLines){$c.CodeModule.Lines(1,$c.CodeModule.CountOfLines)}else{''}}
 foreach($q in $Book.Queries){$m.queries[$q.Name]=$q.Formula}
 foreach($n in $Book.Names){$m.names[$n.Name]=$n.RefersTo}
 foreach($s in $Book.Worksheets){
  $a=@();foreach($p in $s.Shapes){$a+=,@($p.Name,$p.Left,$p.Top,$p.Width,$p.Height,$p.OnAction)};$m.shapes[$s.Name]=$a
  foreach($t in $s.ListObjects){$m.tables[$t.Name]=@($s.Name,$t.Range.Address(),@($t.ListColumns|ForEach-Object {$_.Name}))}
  foreach($qt in $s.QueryTables){$m.refresh["table:$($s.Name):$($qt.Name)"]=[ordered]@{background=$qt.BackgroundQuery;command=$qt.CommandText;style=$qt.RefreshStyle}}
 }
 foreach($connection in $Book.Connections){if($connection.Type -eq 1){$m.refresh["connection:$($connection.Name)"]=[ordered]@{background=$connection.OLEDBConnection.BackgroundQuery;command=$connection.OLEDBConnection.CommandText;all=$connection.RefreshWithRefreshAll}}}
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
 $indexColumn=$Table.ListColumns.Item('Index');$ix=$indexColumn.Index;$ir=$indexColumn.DataBodyRange.Formula2R1C1;$iv=$indexColumn.DataBodyRange.Value2
 for($i=1;$i -le $a.GetLength(0);$i++){$a[$i,$ix]=(@($ir[$i,1],$iv[$i,1])|ConvertTo-Json -Compress)}
 for($i=1;$i -le $a.GetLength(0);$i++){$row=@();for($j=1;$j -le $a.GetLength(1);$j++){$row+=,$a[$i,$j]};$rows+=($row|ConvertTo-Json -Compress -Depth 8)}
 return @($rows|Sort-Object)
}
function CheckAligned($Book){
 $s=$Book.Worksheets.Item('Gnatt Chart');$left=$s.ListObjects.Item('qryContractsToGnatt');$right=$s.ListObjects.Item('Contract_Edits')
 $a=$left.ListColumns.Item('Index').DataBodyRange.Value2;$b=$right.ListColumns.Item('Index').DataBodyRange.Value2
 for($i=1;$i -le $a.GetLength(0);$i++){Assert ($a[$i,1] -eq $b[$i,1]) "Gnatt mismatch at worksheet row $($i+24): $($a[$i,1]) versus $($b[$i,1])"}
 return $a.GetLength(0)
}
function WaitAligned($Book,$App,[int]$ExpectedCount=0){
 $until=[datetime]::UtcNow.AddSeconds(120)
 do {
  Start-Sleep -Seconds 2
  try {
   $pending=Ready {$App.Run("'$($Book.Name)'!BYHGnattSync.GnattIsPending")}
   Assert (-not $pending) 'Synchronization is pending.'
   $n=Ready {CheckAligned $Book};$state=Ready {$App.StatusBar};Assert (-not ($state -is [string] -and $state -like '*NOT synchronized*')) $state
   if($ExpectedCount -gt 0){Assert ($n -eq $ExpectedCount) "Expected $ExpectedCount displayed records; found $n."}
   return $n
  }
  catch {if([datetime]::UtcNow -ge $until){throw}}
 }while($true)
}
function SyncGnatt($App,[string]$Macro){
 $result=$App.Run(($Macro+'BYHGnattSync.RunGnattForAutomation'))
 Assert ($result -eq 'OK') "Gnatt test returned: $result"
}
function CheckMismatchRule($Sheet){
 $rules=$Sheet.Range('K25:K1048576').FormatConditions
 Assert ($rules.Count -eq 1) "Column K has $($rules.Count) rules."
 Assert ($rules.Item(1).AppliesTo.Address() -eq '$K$25:$K$1048576') 'Mismatch rule does not extend to the last row.'
 Assert ($rules.Item(1).Formula1 -eq '=AND($J25<>"",$J25<>$L25)') 'Mismatch formula is shifted.'
 Assert ($Sheet.Range('K24').FormatConditions.Count -eq 0) 'Broken header mismatch rule remains.'
}
$app=$null;$book=$null;$path=$File
if($Mode -in @('Build','Upgrade')){Assert ($Output -and -not(Test-Path -LiteralPath $Output)) 'Use a new output path.';Copy-Item -LiteralPath $File -Destination $Output;$path=$Output}
try {
 $app=New-Object -ComObject Excel.Application
 $app.Visible=$false;$app.DisplayAlerts=$false;$app.EnableEvents=$false;$app.AutomationSecurity=if($Mode -in @('Inspect','RefreshProbe')){3}else{1};$app.AskToUpdateLinks=$false
 $book=$app.Workbooks.Open($path,0,($Mode -notin @('Build','Upgrade')))
 $macro="'$($book.Name)'!"
 $sheet=$book.Worksheets.Item('Gnatt Chart');$edits=$sheet.ListObjects.Item('Contract_Edits');$view=$sheet.ListObjects.Item('qryContractsToGnatt')
 $before=Metadata $book
 $before|ConvertTo-Json -Depth 40|Set-Content -LiteralPath ([IO.Path]::ChangeExtension($Evidence,'.before.json')) -Encoding utf8
 $records=RecordMap $edits
 if($Mode -eq 'RefreshProbe'){
  $probe=@()
  foreach($connection in $book.Connections){
   if($connection.Type -ne 1){continue}
   Write-Output "Probe: $($connection.Name)"
   $connection.OLEDBConnection.BackgroundQuery=$false
   $connection.Refresh()
   $probe+=@{name=$connection.Name;refreshed=$true}
  }
  @{passed=$true;connections=$probe;after=(Metadata $book)}|ConvertTo-Json -Depth 40|Set-Content -LiteralPath $Evidence -Encoding utf8
  Write-Output 'Source connections refreshed with macros disabled; no workbook saved.'
 } elseif($Mode -eq 'Inspect'){
  $before|ConvertTo-Json -Depth 40|Set-Content -LiteralPath $Evidence -Encoding utf8
  $sheet.PageSetup.PrintArea=$PreviewRange;$sheet.PageSetup.Orientation=2;$sheet.PageSetup.Zoom=$false;$sheet.PageSetup.FitToPagesWide=1;$sheet.PageSetup.FitToPagesTall=1
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
 } elseif($Mode -eq 'Upgrade') {
  Assert (-not $book.ReadOnly) 'Working copy is read-only.'
  Assert ($edits.Range.Address() -eq '$L$24:$AN$294') 'Current owner layout differs; remap first.'
  Assert ($before.codes.Contains('BYHGnattSync')) 'Initial synchronization repair is not installed.'
  $cm=$book.VBProject.VBComponents.Item('BYHGnattSync').CodeModule
  $cm.DeleteLines(1,$cm.CountOfLines)
  $cm.AddFromString((Get-Content -Raw -LiteralPath (Join-Path $PSScriptRoot 'BYHGnattSync.bas')))
  $cm=$book.VBProject.VBComponents.Item('ThisWorkbook').CodeModule
  $oldEvent="Private Sub Workbook_SheetCalculate(ByVal Sh As Object)`r`n    If Sh.Name = ""Gnatt Chart"" Then BYHGnattSync.NoticeGnattCalculation`r`nEnd Sub"
  $newEvent="Private Sub Workbook_SheetCalculate(ByVal Sh As Object)`r`n    BYHGnattSync.NoticeGnattSource Sh`r`nEnd Sub`r`nPrivate Sub Workbook_SheetChange(ByVal Sh As Object, ByVal Target As Range)`r`n    BYHGnattSync.NoticeGnattSource Sh`r`nEnd Sub"
  Assert ($before.codes.ThisWorkbook.Contains($oldEvent)) 'Workbook source-notification integration point changed.'
  $expectedWorkbookCode=$before.codes.ThisWorkbook.Replace($oldEvent,$newEvent)
  $cm.DeleteLines(1,$cm.CountOfLines)
  $cm.AddFromString($expectedWorkbookCode)
  foreach($connection in $book.Connections){if($connection.Type -eq 1){$connection.OLEDBConnection.BackgroundQuery=$false}}
  foreach($refreshSheet in $book.Worksheets){foreach($refreshQuery in $refreshSheet.QueryTables){$refreshQuery.BackgroundQuery=$false}}
  $sheet.Range('K24:K1048576').FormatConditions.Delete()
  Write-Output 'Native upgrade: activate existing placeholders and normalize column K.'
  SyncGnatt $app $macro
  $count=CheckAligned $book
  CheckMismatchRule $sheet
  Assert ((RowFor $edits 214) -eq (RowFor $view 214)) 'Index 214 still differs.'
  Assert (($records|ConvertTo-Json -Compress) -ceq ((RecordMap $edits)|ConvertTo-Json -Compress)) 'Editable records changed.'
  $after=Metadata $book
  $after|ConvertTo-Json -Depth 40|Set-Content -LiteralPath ([IO.Path]::ChangeExtension($Evidence,'.after.json')) -Encoding utf8
  foreach($key in @('names','shapes','links','tables','queries')){Assert (($before[$key]|ConvertTo-Json -Depth 30 -Compress) -ceq ($after[$key]|ConvertTo-Json -Depth 30 -Compress)) "Unrelated metadata changed: $key"}
  $expectedRefresh=$before.refresh|ConvertTo-Json -Depth 20|ConvertFrom-Json -AsHashtable
  foreach($setting in $expectedRefresh.Values){$setting.background=$false}
  Assert (($expectedRefresh|ConvertTo-Json -Depth 20 -Compress) -ceq ($after.refresh|ConvertTo-Json -Depth 20 -Compress)) 'Refresh configuration changed beyond background serialization.'
  Assert ($after.codes.ThisWorkbook.TrimEnd("`r","`n") -ceq $expectedWorkbookCode.TrimEnd("`r","`n")) 'Workbook code changed beyond the exact source-notification integration.'
  foreach($name in $before.codes.Keys){if($name -notin @('BYHGnattSync','ThisWorkbook')){Assert ($before.codes[$name] -ceq $after.codes[$name]) "Unrelated VBA changed: $name"}}
  $app.Calculation=-4105
  $book.Save()
  @{passed=$true;aligned=$count;records=$edits.ListRows.Count;before=$before;after=$after;columnK=@{formula=$sheet.Range('K25').FormatConditions.Item(1).Formula1;appliesTo=$sheet.Range('K25').FormatConditions.Item(1).AppliesTo.Address()}}|ConvertTo-Json -Depth 40|Set-Content -LiteralPath $Evidence -Encoding utf8
  $sheet.PageSetup.PrintArea=$PreviewRange;$sheet.PageSetup.Orientation=2;$sheet.PageSetup.Zoom=$false;$sheet.PageSetup.FitToPagesWide=1;$sheet.PageSetup.FitToPagesTall=1
  $sheet.ExportAsFixedFormat(0,[IO.Path]::ChangeExtension($Evidence,'.pdf'))
  Write-Output "Upgrade passed: $count aligned displayed records; all editable records preserved."
 } else {
  Assert ($app.Calculation -eq -4105) 'Saved workbook is not Automatic.'
  $checks=[ordered]@{}
  $checks.open=CheckAligned $book
  [void]$app.Run(($macro+'BYHGnattSync.InitializeGnattSync'))
  [void]$app.Run(($macro+'BYHOthersSort.InitializeOthersSort'))
  SyncGnatt $app $macro
  $checks.initial=CheckAligned $book
  if($ActivationTest){
   CheckMismatchRule $sheet
   Write-Output 'Verify: activate unused Index 213 ahead of 214, then remove it again.'
   $base=$book.Worksheets.Item('Contract').ListObjects.Item('tblContractBase')
   $br=RowFor $base 213;$baseRecord=$base.ListRows.Item($br).Range.Formula2
   $baseRow=$base.ListRows.Item($br).Range
   $baseRow.Cells.Item(1,$base.ListColumns.Item('Assigned').Index).Value2='Glasgow DB'
   $baseRow.Cells.Item(1,$base.ListColumns.Item('Title').Index).Value2='Unsaved synchronization test'
   $baseRow.Cells.Item(1,$base.ListColumns.Item('Qty').Index).Value2='1'
   $baseRow.Cells.Item(1,$base.ListColumns.Item('Unit Price').Index).Value2='123.45'
   $app.EnableEvents=$true
   $glasgow=$book.Worksheets.Item('Glasgow').ListObjects.Item('tblContractGlasgow')
   [void]$glasgow.QueryTable.Refresh($false)
   Write-Output "Glasgow refresh: Index 213 row=$(RowFor $glasgow 213); left rows=$($view.ListRows.Count); pending=$($app.Run(($macro+'BYHGnattSync.GnattIsPending')))"
   $checks.activate=WaitAligned $book $app ($checks.initial+1)
   Assert ($checks.activate -eq $checks.initial+1) 'Activated item did not join the left query.'
   Assert ((RowFor $edits 213) -eq (RowFor $view 213)) 'Activated Index 213 not aligned.'
   Assert ((RowFor $edits 212) -gt $view.ListRows.Count) 'Unused Index 212 interrupts active records.'
   CheckMismatchRule $sheet
   $baseRow.Formula2=$baseRecord
   [void]$glasgow.QueryTable.Refresh($false)
   $checks.deactivate=WaitAligned $book $app $checks.initial
   Assert ($checks.deactivate -eq $checks.initial) 'Removing the test item did not restore the displayed count.'
   CheckMismatchRule $sheet
   $app.EnableEvents=$false
   Write-Output 'Verify: appended source item with a new editable record.'
   $appendFilter=$null
   if($view.AutoFilter.FilterMode){
    Assert ($view.AutoFilter.Filters.Item(1).On) 'Unexpected test filter; remap before adding a row.'
    $appendFilter=$view.AutoFilter.Filters.Item(1).Criteria1
    $view.AutoFilter.ShowAllData()
   }
   $newBase=$base.ListRows.Add();$newBase.Range.Cells.Item(1,$base.ListColumns.Item('Index').Index).Value2='999991'
   foreach($pair in @(@('Cost Code','Change Order'),@('Title','Unsaved appended-row test'),@('Assigned','Glasgow DB'),@('Qty','1'),@('Unit Price','15'))){$newBase.Range.Cells.Item(1,$base.ListColumns.Item($pair[0]).Index).Value2=$pair[1]}
   $newEdit=$edits.ListRows.Add();$newEdit.Range.Cells.Item(1,$edits.ListColumns.Item('Index').Index).Value2='999991'
   $newEdit.Range.Cells.Item(1,$edits.ListColumns.Item('Approve').Index).Value2='Yes'
   [void]$glasgow.QueryTable.Refresh($false)
   $appendRecords=RecordMap $edits
   try{SyncGnatt $app $macro}catch{
    $appendDiff=Compare-Object $appendRecords (RecordMap $edits) -CaseSensitive
    $appendDiff|ConvertTo-Json -Depth 10|Set-Content -LiteralPath ([IO.Path]::ChangeExtension($Evidence,'.append-diff.json')) -Encoding utf8
    Write-Output ($appendDiff|ConvertTo-Json -Depth 10)
    throw
   }
   $checks.append=CheckAligned $book
   Assert ($checks.append -eq $checks.initial+1) 'Appended item did not join the displayed query.'
   CheckMismatchRule $sheet
   $er=RowFor $edits 999991;$edits.ListRows.Item($er).Delete()
   $newBase.Delete()
   [void]$glasgow.QueryTable.Refresh($false)
   SyncGnatt $app $macro
   $checks.appendRestore=CheckAligned $book
   if($null -ne $appendFilter){$view.Range.AutoFilter(1,$appendFilter)}
   Write-Output 'Verify: repair fragmented conditional formatting and same-row red warning.'
   $extra=$sheet.Range('K207').FormatConditions.Add(2,[Type]::Missing,'=$J206<>$L207')
   SyncGnatt $app $macro
   CheckMismatchRule $sheet
   $testCell=$sheet.Range('J207');$originalIndex=$testCell.Value2;$testCell.Value2='999999'
   $sheet.Calculate()
   Assert ($sheet.Range('K207').DisplayFormat.Interior.Color -eq 255) 'Mismatch does not display red.'
   $testCell.Value2=[string]$originalIndex;$sheet.Calculate()
   Assert ($sheet.Range('K207').DisplayFormat.Interior.Color -ne 255) 'Matching Index remains red.'
   Assert ($sheet.Range('K208').DisplayFormat.Interior.Color -ne 255) 'Unused placeholder is incorrectly flagged.'
   $checks.singleRule=$true
  }
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
  if($ActivationTest){
   CheckMismatchRule $sheet
   if($null -ne $appendFilter){Assert ($view.AutoFilter.Filters.Item(1).On -and $view.AutoFilter.Filters.Item(1).Criteria1 -ceq $appendFilter) 'Owner filter was not restored.'}
   $checks.finalRuleAndFilter=$true
  }
  @{passed=$true;checks=$checks;status=$app.StatusBar}|ConvertTo-Json -Depth 15|Set-Content -LiteralPath $Evidence -Encoding utf8
  Write-Output ($checks|ConvertTo-Json -Compress)
 }
} catch {
 Write-Output ($_ | Format-List * -Force | Out-String)
 if($null -ne $app){try{Write-Output "Excel status: $($app.StatusBar)"}catch{}}
 if($null -ne $book){try{Write-Output "Diagnostic: left rows=$($view.ListRows.Count); events=$($app.EnableEvents); calculation=$($app.Calculation); pending=$($app.Run(($macro+'BYHGnattSync.GnattIsPending')))"}catch{}}
 throw
} finally {
 if($null -ne $book){
  if($Mode -notin @('Inspect','RefreshProbe')){
   try{[void]$app.Run(($macro+'BYHGnattSync.ReleaseGnattSync'))}catch{}
   try{[void]$app.Run(($macro+'BYHOthersSort.ReleaseOthersSort'))}catch{}
  }
  $app.EnableEvents=$false;$book.Close($false)
 }
 if($null -ne $app){$app.Quit()}
 if($null -ne $book){[void][Runtime.InteropServices.Marshal]::FinalReleaseComObject($book)}
 if($null -ne $app){[void][Runtime.InteropServices.Marshal]::FinalReleaseComObject($app)}
}
