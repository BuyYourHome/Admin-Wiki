param(
 [Parameter(Mandatory)][ValidateSet('Build','Reorder','Verify')][string]$Mode,
 [Parameter(Mandatory)][string]$File,
 [Parameter(Mandatory)][string]$Evidence,
 [string]$Output
)
$ErrorActionPreference='Stop'
function Assert($Ok,[string]$Why){if(-not $Ok){throw $Why}}
function ReadWhenReady([scriptblock]$Action){
 $limit=[datetime]::UtcNow.AddSeconds(45)
 while($true){try{return (& $Action)}catch{if($_.Exception.HResult -ne -2147418111 -or [datetime]::UtcNow -ge $limit){throw};Start-Sleep -Milliseconds 500}}
}
function Codes($Book){$d=[ordered]@{};foreach($c in $Book.VBProject.VBComponents){$d[$c.Name]=if($c.CodeModule.CountOfLines){$c.CodeModule.Lines(1,$c.CodeModule.CountOfLines)}else{''}};return $d}
function Metadata($Book){
 $d=[ordered]@{queries=[ordered]@{};names=[ordered]@{};shapes=[ordered]@{};codes=(Codes $Book)}
 foreach($q in $Book.Queries){$d.queries[$q.Name]=$q.Formula}
 foreach($n in $Book.Names){$d.names[$n.Name]=$n.RefersTo}
 foreach($s in $Book.Worksheets){$sh=@();foreach($p in $s.Shapes){$sh+=@($p.Name,$p.Left,$p.Top,$p.Width,$p.Height,$p.OnAction)};$d.shapes[$s.Name]=$sh}
 $d.links=@($Book.LinkSources(1));return $d
}
function PriceMap($Table,[string]$Field){
 $d=[ordered]@{};$id=$Table.ListColumns.Item('Index').Index;$col=$Table.ListColumns.Item($Field).Index
 $data=$Table.DataBodyRange.Value2
 for($r=1;$r -le $data.GetLength(0);$r++){$d[[string]$data[$r,$id]]=$data[$r,$col]};return $d
}
function SamePrices($Left,$Right){
 Assert ($Left.Count -eq $Right.Count) 'Price record count changed.'
 foreach($k in $Left.Keys){Assert ($Right.Contains($k)) "Index lost: $k";Assert (($Left[$k]|ConvertTo-Json -Compress) -ceq ($Right[$k]|ConvertTo-Json -Compress)) "Price changed for $k"}
}
function IndexRow($Table,$Index){$data=$Table.ListColumns.Item('Index').DataBodyRange.Value2;for($r=1;$r -le $data.GetLength(0);$r++){if($data[$r,1] -eq $Index){return $r}};throw "Index $Index not found"}
function Aligned($Source,$Target){
 Assert ($Source.ListRows.Count -le $Target.ListRows.Count) 'Missing override rows.'
 $a=$Source.ListColumns.Item('Index').DataBodyRange.Value2;$b=$Target.ListColumns.Item('Index').DataBodyRange.Value2
 for($r=1;$r -le $a.GetLength(0);$r++){Assert ($a[$r,1] -eq $b[$r,1]) "Misaligned row $r"}
}
function NativeSort($Table,[string]$Field,[int]$Direction){$Table.Sort.SortFields.Clear();[void]$Table.Sort.SortFields.Add($Table.ListColumns.Item($Field).DataBodyRange,0,$Direction);$Table.Sort.Header=1;$Table.Sort.Apply()}
$app=$null;$book=$null;$path=$File
if($Mode -ne 'Verify') {Assert ($Output -and -not(Test-Path -LiteralPath $Output)) 'New output required.';Copy-Item -LiteralPath $File -Destination $Output;$path=$Output}
try {
 $app=New-Object -ComObject Excel.Application
 $app.Visible=$false;$app.DisplayAlerts=$false;$app.EnableEvents=$false;$app.AutomationSecurity=1;$app.AskToUpdateLinks=$false
 $book=$app.Workbooks.Open($path,0,($Mode -eq 'Verify'))
 $macro="'$($book.Name)'!"
 $openingMode=$app.Calculation
 if($Mode -eq 'Verify'){Assert ($openingMode -eq -4105) 'Saved workbook did not open in Automatic mode.'}
 $app.Calculation=-4105;$app.Calculate()
 $s=$book.Worksheets.Item('Others');$main=$s.ListObjects.Item('tblContractOthers');$over=$s.ListObjects.Item('tblOthersPriceOverrides')
 $headerHeight=$s.Rows.Item(4).RowHeight
 $before=if($Mode -ne 'Verify'){Metadata $book}else{@{}}
 $prices=PriceMap $over 'Unit Price Override';$computed=PriceMap $main 'Unit Price 2'
 if($Mode -eq 'Build') {
  Assert (-not $book.ReadOnly) 'Work copy is read-only.'
  Assert ($main.Range.Address() -eq '$A$4:$P$57' -and $over.Range.Address() -eq '$T$4:$W$57') 'Owner layout changed; remap before editing.'
  Assert ($app.WorksheetFunction.CountA($s.Range('X4:X58')) -eq 0) 'Helper column is occupied.'
  $new=$over.ListColumns.Add();$new.Name='_Display Order';$new.Range.EntireColumn.Hidden=$true
  $main.ListColumns.Item('Unit Price 2').Range.EntireColumn.Hidden=$true
  $s.Range('T2').Value2='Edit yellow prices. Override rows follow the main table by Index when macros are enabled. Inactive items stay below active items.'
  foreach($spec in @(@('BYHOthersSort',1,'BYHOthersSort.bas'),@('BYHOthersQueryWatcher',2,'BYHOthersQueryWatcher.cls'))){
   Assert (-not $before.codes.Contains($spec[0])) 'Synchronization module already exists.'
   $component=$book.VBProject.VBComponents.Add($spec[1]);$component.Name=$spec[0]
   $component.CodeModule.AddFromString((Get-Content -Raw -LiteralPath (Join-Path $PSScriptRoot $spec[2])))
  }
  $sheetCode=$book.VBProject.VBComponents.Item($s.CodeName).CodeModule
  Assert ($sheetCode.CountOfLines -eq 0) 'Existing Others sheet events need manual integration.'
  $sheetCode.AddFromString((Get-Content -Raw -LiteralPath (Join-Path $PSScriptRoot 'OthersSheetEvents.vba')))
  $cm=$book.VBProject.VBComponents.Item('ThisWorkbook').CodeModule
  $start=$cm.ProcStartLine('FullRecalcRebuild',0);$count=$cm.ProcCountLines('FullRecalcRebuild',0)
  $originalFullRecalc=$cm.Lines($start,$count)
  $hook='    BYHOthersSort.ScheduleOthersSync'
  $anchor='    MsgBox "All data refreshed and model fully recalculated.", vbInformation'
  Assert ($originalFullRecalc.Contains($anchor)) 'Full Recalc integration point changed.'
  $cm.DeleteLines($start,$count)
  $cm.InsertLines($start,$originalFullRecalc.Replace($anchor,($hook+"`r`n"+$anchor)))
  Assert ($before.codes.ThisWorkbook -notmatch 'Sub Workbook_Open|Sub Workbook_BeforeClose') 'Existing lifecycle events need manual integration.'
  $cm.AddFromString("Private Sub Workbook_Open()`r`n    BYHOthersSort.InitializeOthersSort`r`nEnd Sub`r`n`r`nPrivate Sub Workbook_BeforeClose(Cancel As Boolean)`r`n    BYHOthersSort.ReleaseOthersSort`r`nEnd Sub")
  [void]$app.Run(($macro+'BYHOthersSort.SyncOthersPrices'),$true)
  $app.Calculate()
  Aligned $main $over
  SamePrices $prices (PriceMap $over 'Unit Price Override')
  SamePrices $computed (PriceMap $main 'Unit Price 2')
  $after=Metadata $book
  @{before=$before;after=$after}|ConvertTo-Json -Depth 35|Set-Content -LiteralPath ([IO.Path]::ChangeExtension($Evidence,'.metadata.json')) -Encoding utf8
  foreach($key in @('queries','names','shapes','links')){Assert (($before[$key]|ConvertTo-Json -Depth 20 -Compress) -ceq ($after[$key]|ConvertTo-Json -Depth 20 -Compress)) "Unrelated change: $key"}
  foreach($key in $before.codes.Keys){if($key -notin @('ThisWorkbook',$s.CodeName)){Assert ($before.codes[$key] -ceq $after.codes[$key]) "Unrelated VBA changed: $key"}}
  $s.Rows.Item(4).RowHeight=$headerHeight
  $book.Save()
  @{passed=$true;before=$before;after=$after;overridePrices=$prices;computedPrices=$computed;table=$over.Range.Address();hiddenPrice=$s.Columns.Item('H').Hidden;hiddenHelper=$new.Range.EntireColumn.Hidden}|ConvertTo-Json -Depth 35|Set-Content -LiteralPath $Evidence -Encoding utf8
  $s.PageSetup.PrintArea='$M$1:$W$24';$s.PageSetup.Orientation=2;$s.PageSetup.Zoom=$false;$s.PageSetup.FitToPagesWide=1;$s.PageSetup.FitToPagesTall=1
  $s.ExportAsFixedFormat(0,[IO.Path]::ChangeExtension($Evidence,'.pdf'))
 } elseif($Mode -eq 'Reorder') {
  Assert (-not $book.ReadOnly) 'Work copy is read-only.'
  Assert ($main.Range.Address() -eq '$A$4:$P$57' -and $over.Range.Address() -eq '$T$4:$X$57') 'Owner layout changed; remap before editing.'
  $headers=@($over.ListColumns|ForEach-Object {$_.Name})
  Assert (($headers -join '|') -eq 'Index|Item|Unit Price Override|Mapping Note|_Display Order') 'Unexpected override schema.'
  Assert (-not $over.AutoFilter.FilterMode) 'Review the independent override filter before moving columns.'
  $approved=$main.AutoFilter.Filters.Item($main.ListColumns.Item('Approve').Index)
  Assert ($approved.On -and $approved.Criteria1 -in @('Yes','=Yes')) 'Review the latest main-table filter before editing.'
  for($i=1;$i -le $main.ListColumns.Count;$i++){if($i -ne $main.ListColumns.Item('Approve').Index){Assert (-not $main.AutoFilter.Filters.Item($i).On) 'Additional main-table filter needs mapping.'}}
  $criterion=$approved.Criteria1
  $widths=@{};foreach($c in $over.ListColumns){$widths[$c.Name]=$c.Range.EntireColumn.ColumnWidth}
  $hidden=@();for($r=5;$r -le 57;$r++){$hidden+= $s.Rows.Item($r).Hidden}
  $app.Calculation=-4135
  $main.AutoFilter.ShowAllData()
  $over.ListColumns.Item('Unit Price Override').Range.Cut()
  $over.ListColumns.Item('Index').Range.Insert(-4161)
  $app.CutCopyMode=$false
  Assert ((@($over.ListColumns|ForEach-Object {$_.Name}) -join '|') -eq 'Unit Price Override|Index|Item|Mapping Note|_Display Order') 'Column move failed.'
  foreach($c in $over.ListColumns){$c.Range.EntireColumn.ColumnWidth=$widths[$c.Name]}
  [void]$main.Range.AutoFilter($main.ListColumns.Item('Approve').Index,$criterion)
  for($r=5;$r -le 57;$r++){$s.Rows.Item($r).Hidden=$hidden[$r-5]}
  $s.Rows.Item(4).RowHeight=$headerHeight
  $app.Calculation=-4105;$app.Calculate()
  [void]$app.Run(($macro+'BYHOthersSort.SyncOthersPrices'),$true)
  Aligned $main $over
  SamePrices $prices (PriceMap $over 'Unit Price Override')
  SamePrices $computed (PriceMap $main 'Unit Price 2')
  $after=Metadata $book
  foreach($key in @('queries','names','shapes','links','codes')){Assert (($before[$key]|ConvertTo-Json -Depth 25 -Compress) -ceq ($after[$key]|ConvertTo-Json -Depth 25 -Compress)) "Unrelated change: $key"}
  $book.Save()
  @{passed=$true;before=$before;after=$after;overridePrices=$prices;computedPrices=$computed;table=$over.Range.Address();headers=@($over.ListColumns|ForEach-Object {$_.Name});priceCell=$over.ListColumns.Item('Unit Price Override').DataBodyRange.Cells.Item(1,1).Address()}|ConvertTo-Json -Depth 35|Set-Content -LiteralPath $Evidence -Encoding utf8
  $s.PageSetup.PrintArea='$M$1:$W$24';$s.PageSetup.Orientation=2;$s.PageSetup.Zoom=$false;$s.PageSetup.FitToPagesWide=1;$s.PageSetup.FitToPagesTall=1
  $s.ExportAsFixedFormat(0,[IO.Path]::ChangeExtension($Evidence,'.pdf'))
 } else {
  Write-Output 'Verify: opening, manual sorts, and immediate price update.'
  Assert ($s.Columns.Item('H').Hidden -and $over.ListColumns.Item('_Display Order').Range.EntireColumn.Hidden) 'Calculated/helper column is visible.'
  [void]$app.Run(($macro+'BYHOthersSort.InitializeOthersSort'))
  Aligned $main $over
  NativeSort $main 'Index' 2
  [void]$app.Run(($macro+'BYHOthersSort.SyncOthersPrices'))
  Aligned $main $over;SamePrices $prices (PriceMap $over 'Unit Price Override')
  NativeSort $over 'Unit Price Override' 2
  [void]$app.Run(($macro+'BYHOthersSort.SyncOthersPrices'))
  Aligned $main $over;SamePrices $prices (PriceMap $over 'Unit Price Override')
  $r=IndexRow $over 208;$cell=$over.ListColumns.Item('Unit Price Override').DataBodyRange.Cells.Item($r,1);$saved=$cell.Value2
  $cell.Value2='2101'
  Assert ((PriceMap $main 'Unit Price 2')['208'] -eq 2101) 'Price did not update automatically.'
  $cell.Value2=[string]$saved
  $base=$book.Worksheets.Item('Contract').ListObjects.Item('tblContractBase')
  $r=IndexRow $base 45;$assigned=$base.ListColumns.Item('Assigned').DataBodyRange.Cells.Item($r,1);$savedAssigned=$assigned.Value2
  Write-Output 'Verify: event-driven sort and query refresh.'
  $app.EnableEvents=$true
  NativeSort $main 'Title' 1
  ReadWhenReady {$s.Calculate()}
  Start-Sleep -Seconds 3
  $s.Activate()
  $over.ListColumns.Item('Unit Price Override').DataBodyRange.Cells.Item(1,1).Select()
  Write-Output "Events=$($app.EnableEvents); status=$($app.StatusBar)"
  Aligned $main $over
  SamePrices $prices (PriceMap $over 'Unit Price Override')
  $assigned.Value2='Glasgow DB'
  [void]$main.QueryTable.Refresh($false)
  Start-Sleep -Seconds 3
  ReadWhenReady {$s.Calculate()}
  Start-Sleep -Seconds 3
  Aligned $main $over
  Assert ((IndexRow $over 45) -gt $main.ListRows.Count) 'Inactive price was not retained below active rows.'
  SamePrices $prices (PriceMap $over 'Unit Price Override')
  $assigned.Value2=$savedAssigned
  [void]$main.QueryTable.Refresh($false)
  Start-Sleep -Seconds 3
  ReadWhenReady {$s.Calculate()}
  Start-Sleep -Seconds 3
  Aligned $main $over;SamePrices $prices (PriceMap $over 'Unit Price Override')
  $app.EnableEvents=$false
  Write-Output 'Verify: missing and duplicate indexes.'
  # Reserve one blank override under an inactive key; never delete rows beside another table.
  $r=IndexRow $over 44;Assert ($null -eq $over.ListColumns.Item('Unit Price Override').DataBodyRange.Cells.Item($r,1).Value2) 'Test expects blank override.'
  $over.ListColumns.Item('Index').DataBodyRange.Cells.Item($r,1).Value2='999999'
  [void]$app.Run(($macro+'BYHOthersSort.SyncOthersPrices'))
  Aligned $main $over
  Assert ($main.ListRows.Count -eq 53 -and $over.ListRows.Count -eq 54) 'New/inactive Index test changed the main table.'
  Assert ((IndexRow $over 999999) -eq 54) 'Inactive test record was not retained at the bottom.'
  $over.Resize($s.Range('T4:X57'));$s.Range('T58:X58').ClearContents()
  SamePrices $prices (PriceMap $over 'Unit Price Override')
  # Duplicate keys must fail without losing any saved price or leaving events disabled.
  $r=IndexRow $over 45;$idCell=$over.ListColumns.Item('Index').DataBodyRange.Cells.Item($r,1);$idCell.Value2='44'
  [void]$app.Run(($macro+'BYHOthersSort.TrySyncOthersPrices'))
  $failed=$app.StatusBar -like '*Duplicate Index in the override table*'
  Assert $failed 'Duplicate Index was silently accepted.'
  Assert (-not $app.EnableEvents) 'Synchronization changed caller event state.'
  $idCell.Value2='45';[void]$app.Run(($macro+'BYHOthersSort.TrySyncOthersPrices'))
  SamePrices $prices (PriceMap $over 'Unit Price Override')
  # Test our alignment in Manual mode without changing the separately deferred Full Recalc design.
  Write-Output 'Verify: alignment in Manual mode.'
  $app.Calculation=-4135
  [void]$app.Run(($macro+'BYHOthersSort.SyncOthersPrices'),$true)
  Assert ($app.Calculation -eq -4135 -and -not $app.EnableEvents) 'Alignment failed to restore caller settings.'
  $app.Calculation=-4105
  Aligned $main $over;SamePrices $prices (PriceMap $over 'Unit Price Override');SamePrices $computed (PriceMap $main 'Unit Price 2')
  @{passed=$true;automatic=$true;reverseSort=$true;overrideSort=$true;priceEdit=$true;refreshEvents=$true;inactiveRetained=$true;missingIndexAdded=$true;duplicateRejected=$true;alignmentManualMode=$true;pricesUnchanged=$true;changesSaved=$false}|ConvertTo-Json|Set-Content -LiteralPath $Evidence -Encoding utf8
 }
 @{mode=$Mode;passed=$true;records=$main.ListRows.Count;overrides=$over.ListRows.Count}|ConvertTo-Json
}catch{
 Write-Output $_.ScriptStackTrace
 if($app){Write-Output "Failed with events=$($app.EnableEvents); status=$($app.StatusBar)"}
 if($main -and $over){
  Write-Output 'Main indexes:';Write-Output ($main.ListColumns.Item('Index').DataBodyRange.Value2|ConvertTo-Json -Compress)
  Write-Output 'Override data:';Write-Output ($over.DataBodyRange.Value2|ConvertTo-Json -Compress)
 }
 throw
}finally{
 Write-Output 'Cleanup: closing workbook.'
 if($book){$app.EnableEvents=$false;try{[void]$app.Run(($macro+'BYHOthersSort.ReleaseOthersSort'))}catch{};$book.Close($false);[void][Runtime.InteropServices.Marshal]::FinalReleaseComObject($book)}
 if($app){$app.Quit();[void][Runtime.InteropServices.Marshal]::FinalReleaseComObject($app)}
 Write-Output 'Cleanup: complete.'
}
