param([Parameter(Mandatory)][string]$Source,[Parameter(Mandatory)][string]$Template,[Parameter(Mandatory)][string]$Output)
$ErrorActionPreference='Stop'
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
    Assert ($t.Range.Address() -eq '$AI$2:$AS$134') 'Outrigger table map changed.'
    Assert ($t.ListRows.Count -eq 132) 'Outrigger records changed.'
    Assert ($profit.Range('A41').Text -match 'Lawn') 'Profit Lawn mapping changed.'
    Assert ($profit.Range('H73').Text -eq 'Start Date') 'Profit date mapping changed.'
    Assert ($e.WorksheetFunction.CountA($s.Range('BA1:BK134')) -eq 0) 'Temporary table area occupied.'
    Assert ($e.WorksheetFunction.CountA($s.Range('A1000:AG1028')) -eq 0) 'Temporary grid area occupied.'
    Assert ($s.Range('Q12').Value2 -eq 38.78 -and $s.Range('Q13').Value2 -eq 77.56) 'Grid override map changed.'
    Assert ($s.Range('P12').Value2 -eq $s.Range('AK86').Value2 -and $s.Range('P13').Value2 -eq $s.Range('AK87').Value2) 'Water dates do not match.'
    Assert ($s.Range('AN86').Value2 -eq 55.15 -and $null -eq $s.Range('AN87').Value2) 'Water source map changed.'
    $s.Range('AN86').Value2=38.78;$s.Range('AN87').Value2=77.56
    $s.Range('AS86').Value2=[string]$s.Range('AS86').Value2+'; Grid override Carrying!Q12, 2026-09-30: 55.15 -> 38.78'
    $s.Range('AS87').Value2=[string]$s.Range('AS87').Value2+'; Grid override Carrying!Q13, 2026-09-30: blank -> 77.56'
    for($r=3;$r -le 134;$r++){
        Assert ($null -eq $s.Cells.Item($r,38).Value2 -and -not $s.Cells.Item($r,38).HasFormula) "Vendor map changed: $r"
        $s.Cells.Item($r,38).Value2=$s.Cells.Item($r,36).Value2
    }
    $data=$t.Range.Formula2
    $originalNames=@($b.Names | ForEach-Object {$_.Name})
    $invalidNames=@($b.Names | Where-Object {$_.RefersTo -match '#REF!'} | ForEach-Object {$_.Name})
    Assert (-not ($originalNames -contains 'ceVersion')) 'Entry form already installed.'
    Assert ($v.Protection -eq 0) 'VBA project is protected.'
    $code=@{}
    foreach($c in $v.VBComponents){$code[$c.Name]=if($c.CodeModule.CountOfLines){$c.CodeModule.Lines(1,$c.CodeModule.CountOfLines)}else{''}}
    Assert (-not $code.ContainsKey('BYHCarryingEntry')) 'Module collision.'
    $totals=@(2,5,8,11,14,17,20,23,26,29,32 | ForEach-Object {$s.Cells.Item(25,$_).Value2})
    $profitBefore=15879.46
    $totals[5]=392.98
    # Relocate the entire source block through a non-overlapping empty location.
    [void]$s.Range('AI1:AS134').Cut($s.Range('BA1'))
    [void]$s.Range('BA1:BK134').Cut($s.Range('AL1'))
    [void]$s.Range('A1:AG29').Cut($s.Range('A1000'))
    [void]$s.Range('A1000:AG1028').Cut($s.Range('A5'))
    $s.Range('A1:AJ4').Clear()
    $ps.Range('A1:AJ4').Copy($s.Range('A1'))
    # Copy presentation only; target records, escrow offsets and totals stay local.
    $ps.Range('A5:AJ29').Copy();$s.Range('A5:AJ29').PasteSpecial(-4122)
    for($col=1;$col -le 48;$col++){$s.Columns.Item($col).ColumnWidth=$ps.Columns.Item($col).ColumnWidth}
    for($row=1;$row -le 33;$row++){$s.Rows.Item($row).RowHeight=$ps.Rows.Item($row).RowHeight}
    foreach($addr in 'AH5','AH7','AI7'){$s.Range($addr).Value2=$ps.Range($addr).Value2}
    foreach($col in 1,2,4,5,7,8,10,11,13,14,16,17,19,20,22,23,25,26,28,29,31,32,34,35){
        for($row=8;$row -le 28;$row++){
            $s.Cells.Item($row,$col).Formula2=([string]$ps.Cells.Item($row,$col).Formula2).Replace('VALUE(tblCarryingExpenses[Amount])','tblCarryingExpenses[Amount]')
        }
    }
    $s.Range('AI29').Formula2='=SUMIFS(tblCarryingExpenses[Amount],tblCarryingExpenses[Category],AH$5,tblCarryingExpenses[Include],"Yes")'
    foreach($n in $p.Names){if($n.Name -cmatch '^ce[A-Z]'){[void]$b.Names.Add($n.Name,$n.RefersTo)}}
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
    $profit.Range('B41').Formula2='=+Carrying!AI29/Profit!$B$28'
    $profit.Range('J41').Formula2='=IF(OR($E$1=2,$E$1=3),-B41,0)*$B$28/($B$28+$B$9)'
    $profit.Range('B43').Formula2='=+B28*SUM(B31:B42)'
    # Fix heading references only; retain Outrigger's profit numerator/business logic.
    $profit.Range('L83').Formula2='=IF(H83=0,0,+J83/H83*$F$75/DAYS(J75,H75))'
    $b.Worksheets.Item('Docs').Range('E39').Formula2='=Profit!C9'
    $dest=$b.Worksheets.Item('Review').Range('B5:B225')
    $list=[string]$dest.Cells.Item(1,1).Validation.Formula1
    Assert (-not ($list.Split(',') -contains 'Carrying')) 'Destination already present; remap.'
    $dest.Validation.Modify(3,1,1,($list+',Carrying'))
    $dest.Validation.InCellDropdown=$true
    $e.CutCopyMode=$false
    $p.Close($false);$p=$null
    Assert ($t.Range.Address() -eq '$AL$2:$AV$134') 'Unexpected destination table position.'
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
        Assert ([math]::Abs([double]$s.Cells.Item(29,$cols[$i]).Value2-[double]$totals[$i]) -lt .001) "Category total changed: $($cols[$i])"
    }
    if([math]::Abs([double]$profit.Range('B43').Value2-[double]$profitBefore) -ge .001){
        [ordered]@{before=$profitBefore;after=$profit.Range('B43').Value2;laborFormula=$s.Range('AI29').Formula2;laborText=$s.Range('AI29').Text;laborHeader=$s.Range('AH5').Value2;months=$profit.Range('B28').Value2;rows=@(31..43 | ForEach-Object {@($_,$profit.Cells.Item($_,2).Formula2,$profit.Cells.Item($_,2).Value2)})} | ConvertTo-Json -Depth 5
        throw 'Profit total changed.'
    }
    Assert ($s.Range('AI29').Value2 -eq 0) 'Template Labor records leaked.'
    $b.Save()
    [ordered]@{output=$Output;records=$t.ListRows.Count;table=$t.Range.Address();carryingCost=$profit.Range('B43').Value2;docsRent=$b.Worksheets.Item('Docs').Range('E39').Value2;returnValue=$profit.Range('L83').Value2;calculation=$e.Calculation} | ConvertTo-Json
} catch { Write-Output $_.ScriptStackTrace; throw } finally {
    if($p){$p.Close($false)}
    if($b){$b.Close($false)}
    $e.Quit();[void][Runtime.InteropServices.Marshal]::FinalReleaseComObject($e)
    [GC]::Collect();[GC]::WaitForPendingFinalizers()
}
