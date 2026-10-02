param([Parameter(Mandatory)][string]$Source,[Parameter(Mandatory)][string]$Output,[Parameter(Mandatory)][string]$PreviewPdf)
$ErrorActionPreference='Stop'
function Assert($ok,$message){if(-not $ok){throw $message}}
Assert (-not(Test-Path -LiteralPath $Output)) 'Output exists.'
[void](New-Item -ItemType Directory -Path (Split-Path -Parent $Output) -Force)
Copy-Item -LiteralPath $Source -Destination $Output
$e=New-Object -ComObject Excel.Application
$e.Visible=$false;$e.DisplayAlerts=$false;$e.EnableEvents=$false;$e.AutomationSecurity=3
try{
    $b=$e.Workbooks.Open($Output,0,$false);$s=$b.Worksheets.Item('Carrying');$p=$b.Worksheets.Item('Profit')
    Assert (-not $b.ReadOnly -and $b.FileFormat -eq 52) 'Expected writable XLSM.'
    $t=$s.ListObjects.Item('tblCarryingExpenses');$records=$t.DataBodyRange.Formula2;$count=$t.ListRows.Count;$total=$p.Range('B43').Value2
    Assert ($t.Range.Address() -eq '$AL$4:$AV$60' -and $s.Range('AH7').Value2 -eq 'Labor') 'Remap latest table/grid before adding Rent.'
    Assert ($s.Range('Y1').MergeArea.Address() -eq '$Y$1:$AI$2') 'Owner context merge changed.'
    Assert ($p.Range('B43').Formula2 -eq '=+B28*SUM(B31:B42)') 'Remap Profit total before changing it.'
    $contextStyle=@($s.Range('Y1').Font.Name,$s.Range('Y1').Font.Size,$s.Range('Y1').Interior.Color,$s.Range('Y1').WrapText)
    $v=$b.GetType().InvokeMember('VBProject',[Reflection.BindingFlags]::GetProperty,$null,$b,$null)
    $code=@{};foreach($c in $v.VBComponents){$code[$c.Name]=if($c.CodeModule.CountOfLines){$c.CodeModule.Lines(1,$c.CodeModule.CountOfLines)}else{''}}
    # Insert whole columns so Excel moves all source/helper references together.
    $s.Columns.Item('AK:AM').Insert() | Out-Null
    $s.Range('AH7:AJ31').Copy($s.Range('AK7'))
    for($i=0;$i -lt 3;$i++){$s.Columns.Item(37+$i).ColumnWidth=$s.Columns.Item(7+$i).ColumnWidth}
    $s.Range('AK7').Value2='Rent'
    $b.Names.Item('ceEditHeaders').RefersTo='=Carrying!$A$7:$AM$7'
    $b.Names.Item('ceEditGrid').RefersTo='=Carrying!$A$10:$AM$30'
    $categories=[string]$e.Evaluate($b.Names.Item('ceCategories').RefersTo)
    Assert (-not ($categories.Split(',') -contains 'Rent')) 'Rent already exists.'
    $categories+=',Rent';$b.Names.Item('ceCategories').RefersTo='="'+$categories+'"'
    $s.Range('C4').Validation.Modify(3,1,1,$categories)
    $b.Names.Item('ceButtonContext').RefersTo='=Carrying!$Y$1:$AI$2'
    $s.Range('Y1').Value2='Recurring Bill: Select a bill''s date or amount in the grid. The selected vendor and category choose the latest matching bill. Review the fields, then Insert Record.'
    Assert ($t.Range.Address() -eq '$AO$4:$AY$60' -and $t.ListRows.Count -eq $count) 'Table move failed.'
    $after=$t.DataBodyRange.Formula2
    for($r=1;$r -le $count;$r++){for($c=1;$c -le 11;$c++){Assert ($records[$r,$c] -ceq $after[$r,$c]) "Record changed $r,$c"}}
    Assert ($s.Range('Y1').MergeArea.Address() -eq '$Y$1:$AI$2') 'Context merge changed.'
    $afterStyle=@($s.Range('Y1').Font.Name,$s.Range('Y1').Font.Size,$s.Range('Y1').Interior.Color,$s.Range('Y1').WrapText)
    for($i=0;$i -lt $contextStyle.Count;$i++){Assert ($contextStyle[$i] -eq $afterStyle[$i]) 'Context formatting changed.'}
    foreach($c in $v.VBComponents){$actual=if($c.CodeModule.CountOfLines){$c.CodeModule.Lines(1,$c.CodeModule.CountOfLines)}else{''};Assert ($actual -ceq $code[$c.Name]) "VBA changed: $($c.Name)"}
    $e.Calculation=-4105;$e.CalculateFullRebuild()
    Assert ($s.Range('AL31').Value2 -eq 0 -and [math]::Abs($p.Range('B43').Value2-$total) -lt .000001) 'Initial totals changed.'
    $e.CutCopyMode=$false;$b.Save()
    [ordered]@{records=$count;total=$total;newCategory='AK:AM';sourceTable=$t.Range.Address();context=$b.Names.Item('ceButtonContext').RefersTo;rentInExpenseTotal=$false}|ConvertTo-Json
    $s.PageSetup.PrintArea='$A$1:$AM$31';$s.PageSetup.Orientation=2;$s.PageSetup.PaperSize=8
    $s.PageSetup.Zoom=$false;$s.PageSetup.FitToPagesWide=1;$s.PageSetup.FitToPagesTall=1
    $s.ExportAsFixedFormat(0,$PreviewPdf)
}finally{
    if($b){$b.Close($false)};$e.Quit();[void][Runtime.InteropServices.Marshal]::FinalReleaseComObject($e)
    [GC]::Collect();[GC]::WaitForPendingFinalizers()
}
