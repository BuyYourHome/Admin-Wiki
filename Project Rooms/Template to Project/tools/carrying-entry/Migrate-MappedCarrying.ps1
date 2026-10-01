param([Parameter(Mandatory)][string]$Source,[Parameter(Mandatory)][string]$Template,[Parameter(Mandatory)][string]$Output,[Parameter(Mandatory)][string]$Map)
$ErrorActionPreference='Stop'
$m=Get-Content -Raw -LiteralPath $Map | ConvertFrom-Json
$end=[int]$m.end
$left=if($m.tableLeft){[string]$m.tableLeft}else{'AI'}
$right=if($left -eq 'AL'){'AV'}else{'AS'}
$oldFooter=if($m.footer){[int]$m.footer}else{25}
$footer=$oldFooter+4
$tail=$oldFooter+4
$capacity=$footer-8
function Assert($ok,$message){if(-not $ok){throw $message}}
Assert (-not (Test-Path -LiteralPath $Output)) 'Output already exists.'
[void](New-Item -ItemType Directory -Path (Split-Path -Parent $Output) -Force)
Copy-Item -LiteralPath $Source -Destination $Output
$e=New-Object -ComObject Excel.Application
$e.Visible=$false;$e.DisplayAlerts=$false;$e.EnableEvents=$false;$e.AutomationSecurity=3
$e.CopyObjectsWithCells=$false
try {
    $b=$e.Workbooks.Open($Output,0,$false)
    $v=$b.GetType().InvokeMember('VBProject',[Reflection.BindingFlags]::GetProperty,$null,$b,$null)
    $p=$e.Workbooks.Open($Template,0,$true)
    Assert (-not $b.ReadOnly -and $b.FileFormat -eq 52) 'Expected writable XLSM.'
    $e.Calculation=-4135
    $s=$b.Worksheets.Item('Carrying');$t=$s.ListObjects.Item('tblCarryingExpenses')
    $ps=$p.Worksheets.Item('Carrying');$profit=$b.Worksheets.Item('Profit')
    Assert ($t.Range.Address() -eq ('$'+$left+'$2:$'+$right+'$'+$end)) 'Mapped project table map changed.'
    Assert ($t.ListRows.Count -eq $m.rows) 'Mapped project records changed.'
    Assert ($profit.Range('A41').Text -match 'Lawn') 'Profit Lawn mapping changed.'
    Assert ($profit.Range('H73').Text -eq 'Start Date') 'Profit date mapping changed.'
    Assert ($e.WorksheetFunction.CountA($s.Range(("BA1:BK"+$end))) -eq 0) 'Temporary table area occupied.'
    Assert ($e.WorksheetFunction.CountA($s.Range(('A1000:AG'+(999+$tail)))) -eq 0) 'Temporary grid area occupied.'
    foreach($change in $m.overrides){
        $cell=$s.Range($change.cell)
        Assert ($cell.Value2 -eq $change.before -and -not $cell.HasFormula) "Override source changed: $($change.cell)"
        $grid=$s.Range($change.grid)
        Assert ($grid.Value2 -eq $change.after -and -not $grid.HasFormula) "Grid authority changed: $($change.grid)"
        $cell.Value2=[double]$change.after
    }
    foreach($note in $m.notes){$cell=$s.Range($note.cell);$cell.Value2=[string]$cell.Value2+[string]$note.append}
    $filled=0
    for($r=3;$r -le $end;$r++){
        $cell=$t.ListColumns.Item('Vendor').DataBodyRange.Cells.Item($r-2,1)
        if(-not $cell.HasFormula -and [string]::IsNullOrWhiteSpace([string]$cell.Value2)){
            $cell.Value2=$t.ListColumns.Item('Category').DataBodyRange.Cells.Item($r-2,1).Value2;$filled++
        }
    }
    Assert ($filled -eq $m.blankVendors) 'Vendor baseline changed.'
    foreach($record in $m.additions){
        Assert ($s.Range($record.gridDate).Value2 -eq $record.date -and $s.Range($record.gridAmount).Value2 -eq $record.amount) 'New grid record changed.'
        $row=$t.ListRows.Add().Range
        $values=@('Yes',$record.category,[double]$record.date,$record.category,'',[double]$record.amount,'Migrated Carrying Grid','',$b.Name,'Migrated',$record.notes)
        for($c=1;$c -le 11;$c++){[void]$row.Cells.Item(1,$c).GetType().InvokeMember('Value2',[Reflection.BindingFlags]::SetProperty,$null,$row.Cells.Item(1,$c),@($values[$c-1]))}
    }
    $newEnd=$end+@($m.additions).Where({$null -ne $_}).Count
    $data=$t.Range.Formula2
    $originalNames=@($b.Names | ForEach-Object {$_.Name})
    $invalidNames=@($b.Names | Where-Object {$_.RefersTo -match '#REF!'} | ForEach-Object {$_.Name})
    Assert (-not ($originalNames -contains 'ceVersion')) 'Entry form already installed.'
    Assert ($v.Protection -eq 0) 'VBA project is protected.'
    $code=@{}
    foreach($c in $v.VBComponents){$code[$c.Name]=if($c.CodeModule.CountOfLines){$c.CodeModule.Lines(1,$c.CodeModule.CountOfLines)}else{''}}
    Assert (-not $code.ContainsKey('BYHCarryingEntry')) 'Module collision.'
    $totals=@(2,5,8,11,14,17,20,23,26,29,32 | ForEach-Object {$s.Cells.Item($oldFooter,$_).Value2})
    $profitBefore=[double]$m.profitTotal
    foreach($change in $m.totals){$totals[[int]$change.index]=[double]$change.value}
    # Relocate the entire source block through a non-overlapping empty location.
    if($left -eq 'AI'){
        [void]$s.Range(("AI1:AS"+$newEnd)).Cut($s.Range('BA1'))
        [void]$s.Range(("BA1:BK"+$newEnd)).Cut($s.Range('AL1'))
    }
    [void]$s.Range(('A1:AG'+$tail)).Cut($s.Range('A1000'))
    [void]$s.Range(('A1000:AG'+(999+$tail))).Cut($s.Range('A5'))
    $s.Range('A1:AJ4').Clear()
    $ps.Range('A1:AJ4').Copy($s.Range('A1'))
    # Copy presentation only; target records, escrow offsets and totals stay local.
    if($oldFooter -eq 25){$ps.Range('A5:AJ29').Copy();$s.Range('A5:AJ29').PasteSpecial(-4122)}else{
        $s.Range('A5:AJ7').UnMerge();$s.Range('A5:AJ7').Clear()
        $ps.Range('A5:AJ7').Copy($s.Range('A5'))
        $ps.Range('A8:AJ8').Copy();$s.Range(('A8:AJ'+($footer-1))).PasteSpecial(-4122)
        $ps.Range('A29:AJ29').Copy();$s.Range(('A'+$footer+':AJ'+$footer)).PasteSpecial(-4122)
    }
    for($col=1;$col -le 48;$col++){$s.Columns.Item($col).ColumnWidth=$ps.Columns.Item($col).ColumnWidth}
    for($row=1;$row -le $footer+4;$row++){$sourceRow=if($oldFooter -eq 25 -or $row -lt 8){$row}else{8};$s.Rows.Item($row).RowHeight=$ps.Rows.Item($sourceRow).RowHeight}
    foreach($addr in 'AH5','AH7','AI7'){$s.Range($addr).Value2=$ps.Range($addr).Value2}
    foreach($col in 1,2,4,5,7,8,10,11,13,14,16,17,19,20,22,23,25,26,28,29,31,32,34,35){
        for($row=8;$row -lt $footer;$row++){
            $s.Cells.Item($row,$col).Formula2R1C1=([string]$ps.Cells.Item(8,$col).Formula2R1C1).Replace('VALUE(tblCarryingExpenses[Amount])','tblCarryingExpenses[Amount]')
        }
    }
    $s.Range(('AI'+$footer)).Formula2='=SUMIFS(tblCarryingExpenses[Amount],tblCarryingExpenses[Category],AH$5,tblCarryingExpenses[Include],"Yes")'
    foreach($n in $p.Names){if($n.Name -cmatch '^ce[A-Z]'){[void]$b.Names.Add($n.Name,$n.RefersTo)}}
    $b.Names.Item('ceDisplayCapacity').RefersTo='='+$capacity
    foreach($name in 'Date','Category','Vendor','Description','Amount','Invoice','SourceFile','Notes','Feedback'){
        $b.Names.Item('ce'+$name).RefersToRange.MergeArea.ClearContents()
    }
    $s.Range('D4').Value2='Manual Entry';$s.Range('U4').Value2='Entered';$s.Range('U2').Value2=$true
    Assert ($e.WorksheetFunction.CountA($s.Columns.Item('AX')) -eq 0) 'Vendor helper occupied.'
    $s.Range('AX1').Value2='Vendor list'
    $s.Range('AX2').Formula2='=LET(v,TRIM(tblCarryingExpenses[Vendor]&""),SORT(UNIQUE(FILTER(v,v<>"",""))))'
    $s.Columns.Item('AX').Hidden=$true
    $input=$b.Names.Item('ceVendor').RefersToRange.MergeArea
    $input.Validation.Delete();$input.Validation.Add(3,1,1,'=ceVendorList')
    $input.Validation.InCellDropdown=$true;$input.Validation.ShowError=$false
    foreach($name in 'ceIncludeCheckbox','ceInsertButton','ceRecurringButton'){
        $src=$ps.Shapes.Item($name)
        $kind=if($name -eq 'ceIncludeCheckbox'){1}else{0}
        $shape=$s.Shapes.AddFormControl($kind,$src.Left,$src.Top,$src.Width,$src.Height)
        $shape.Name=$name;$shape.Placement=$src.Placement;$shape.Visible=-1;$shape.DrawingObject.PrintObject=$true
        if($kind -eq 0){
            $shape.TextFrame.Characters().Text=$src.TextFrame.Characters().Text
            $proc=if($name -eq 'ceInsertButton'){'CarryingEntry_Insert'}else{'CarryingEntry_Recurring'}
            $shape.OnAction="'"+$b.Name.Replace("'","''")+"'!"+$proc
        }else{$shape.TextFrame.Characters().Text='';$shape.ControlFormat.LinkedCell="'Carrying'!`$U`$2";$shape.ControlFormat.Value=1}
    }
    $s.Shapes.Item('ceRecurringButton').Width=$s.Shapes.Item('ceInsertButton').Width
    $s.Shapes.Item('ceRecurringButton').Height=$s.Shapes.Item('ceInsertButton').Height
    [void]$v.VBComponents.Import((Join-Path $PSScriptRoot 'BYHCarryingEntry.bas'))
    [void]$v.VBComponents.Import((Join-Path $PSScriptRoot 'BYHCarryingPrefill.bas'))
    foreach($c in $v.VBComponents){if($code.ContainsKey($c.Name)){
        $now=if($c.CodeModule.CountOfLines){$c.CodeModule.Lines(1,$c.CodeModule.CountOfLines)}else{''}
        Assert ($code[$c.Name] -ceq $now) "Existing VBA changed: $($c.Name)"
    }}
    # Native row insertion updates all dependent formulas and existing controls.
    [void]$profit.Rows.Item(41).Insert()
    $pp=$p.Worksheets.Item('Profit')
    $pp.Range('A41:K41').Copy();$profit.Range('A41:K41').PasteSpecial(-4122)
    $profit.Range('A41').Value2=$pp.Range('A41').Value2
    $profit.Range('B41').Formula2='=+Carrying!AI'+$footer+'/Profit!$B$28'
    if($m.connectEmptyCategories){
        $profit.Range('B40').Formula2='=+Carrying!AC'+$footer+'/Profit!$B$28'
        $profit.Range('B42').Formula2='=+Carrying!AF'+$footer+'/Profit!$B$28'
    }
    $profit.Range('J41').Formula2='=IF(OR($E$1=2,$E$1=3),-B41,0)*$B$28/($B$28+$B$9)'
    $profit.Range('B43').Formula2='=+B28*SUM(B31:B42)'
    # Fix heading references only; retain Mapped project's profit numerator/business logic.
    if(-not $m.keepReturnFormula){$profit.Range('L83').Formula2='=IF(H83=0,0,+J83/H83*$F$75/DAYS(J75,H75))'}
    $b.Worksheets.Item('Docs').Range('E39').Formula2='=Profit!C9'
    $dest=$b.Worksheets.Item('Review').Range([string]$m.review)
    $list=[string]$dest.Cells.Item(1,1).Validation.Formula1
    Assert (-not ($list.Split(',') -contains 'Carrying')) 'Destination already present; remap.'
    $dest.Validation.Modify(3,1,1,($list+',Carrying'))
    $dest.Validation.InCellDropdown=$true
    $e.CutCopyMode=$false
    $p.Close($false);$p=$null
    Assert ($t.Range.Address() -eq ("`$AL`$2:`$AV`$"+$newEnd)) 'Unexpected destination table position.'
    $after=$t.Range.Formula2
    for($r=1;$r -le $data.GetLength(0);$r++){for($c=1;$c -le $data.GetLength(1);$c++){
        Assert ($data[$r,$c] -ceq $after[$r,$c]) "Source record changed: $r,$c"
    }}
    Assert ($null -eq $b.LinkSources(1)) 'Unexpected workbook link.'
    foreach($n in $b.Names){
        Assert (-not ($n.RefersTo -match '\[.*\.xls')) "External name: $($n.Name)"
        Assert (-not ($n.RefersTo -match '#REF!') -or ($invalidNames -contains $n.Name)) "New invalid name: $($n.Name)"
    }
    $e.Calculation=-4105;$e.CalculateFullRebuild()
    $cols=@(2,5,8,11,14,17,20,23,26,29,32)
    for($i=0;$i -lt $cols.Count;$i++){
        Assert ([math]::Abs([double]$s.Cells.Item($footer,$cols[$i]).Value2-[double]$totals[$i]) -lt .001) "Category total changed: $($cols[$i])"
    }
    if([math]::Abs([double]$profit.Range('B43').Value2-[double]$profitBefore) -ge .001){
        [ordered]@{before=$profitBefore;after=$profit.Range('B43').Value2;laborFormula=$s.Range('AI29').Formula2;laborText=$s.Range('AI29').Text;laborHeader=$s.Range('AH5').Value2;months=$profit.Range('B28').Value2;rows=@(31..43 | ForEach-Object {@($_,$profit.Cells.Item($_,2).Formula2,$profit.Cells.Item($_,2).Value2)})} | ConvertTo-Json -Depth 5
        throw 'Profit total changed.'
    }
    Assert ($s.Range(('AI'+$footer)).Value2 -eq 0) 'Template Labor records leaked.'
    $b.Save()
    [ordered]@{output=$Output;records=$t.ListRows.Count;table=$t.Range.Address();carryingCost=$profit.Range('B43').Value2;docsRent=$b.Worksheets.Item('Docs').Range('E39').Value2;returnValue=$profit.Range('L83').Value2;calculation=$e.Calculation} | ConvertTo-Json
} catch { Write-Output $_.ScriptStackTrace; throw } finally {
    if($p){$p.Close($false)}
    if($b){$b.Close($false)}
    $e.Quit();[void][Runtime.InteropServices.Marshal]::FinalReleaseComObject($e)
    [GC]::Collect();[GC]::WaitForPendingFinalizers()
}
