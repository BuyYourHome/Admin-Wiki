param([Parameter(Mandatory)][string]$Source,[Parameter(Mandatory)][string]$Template,
      [Parameter(Mandatory)][string]$Output,[Parameter(Mandatory)][string]$Map,
      [string]$SourcePreview)
$ErrorActionPreference='Stop'
function Assert($ok,$message){if(-not $ok){throw $message}}
function Set-Cell($cell,$value){[void]$cell.GetType().InvokeMember('Value2',[Reflection.BindingFlags]::SetProperty,$null,$cell,@($value))}
$m=Get-Content -Raw -LiteralPath $Map | ConvertFrom-Json
Assert ((Get-FileHash -LiteralPath $Source).Hash -eq $m.sourceHash) 'Source snapshot changed.'
Assert (-not (Test-Path -LiteralPath $Output)) 'Output already exists.'
[void](New-Item -ItemType Directory -Path (Split-Path -Parent $Output) -Force)
Copy-Item -LiteralPath $Source -Destination $Output
$e=New-Object -ComObject Excel.Application
$e.Visible=$false;$e.DisplayAlerts=$false;$e.EnableEvents=$false;$e.AutomationSecurity=3
try{
    $b=$e.Workbooks.Open($Output,0,$false)
    Assert (-not $b.ReadOnly -and $b.FileFormat -eq 52) 'Expected writable XLSM.'
    $e.Calculation=-4135
    $old=$b.Worksheets.Item('Carrying');$profit=$b.Worksheets.Item('Profit')
    Assert ($old.ListObjects.Count -eq 0 -and $profit.Range('A41').Text -match 'Lawn') 'Source layout changed.'
    Assert ($profit.Range('H73').Text -eq 'Start Date' -and $profit.Range('J73').Text -eq 'End Date') 'Profit date mapping changed.'
    Assert ($null -eq $b.LinkSources(1)) 'Source workbook has external links.'
    $oldMode=$profit.Range('E1').Value2
    $oldNames=@{};foreach($n in $b.Names){$oldNames[$n.Name]=$n.RefersTo}
    Assert (-not $oldNames.ContainsKey('ceVersion')) 'Form already exists; remap.'
    $v=$b.GetType().InvokeMember('VBProject',[Reflection.BindingFlags]::GetProperty,$null,$b,$null)
    Assert ($v.Protection -eq 0) 'VBA project protected.'
    $code=@{};foreach($c in $v.VBComponents){$code[$c.Name]=if($c.CodeModule.CountOfLines){$c.CodeModule.Lines(1,$c.CodeModule.CountOfLines)}else{''}}
    foreach($r in $m.records){
        Assert ($old.Range($r.dateCell).Value2 -eq $r.date) "Native date differs from saved snapshot: $($r.dateCell)"
        $amount=$old.Range($r.amountCell).Value2
        Assert (($null -eq $amount -and $null -eq $r.amount) -or ($null -ne $amount -and $null -ne $r.amount -and [math]::Abs([double]$amount-[double]$r.amount) -lt .000001)) "Native amount differs from snapshot: $($r.amountCell)"
    }
    if($SourcePreview){
        $area=$old.PageSetup.PrintArea;$orientation=$old.PageSetup.Orientation;$zoom=$old.PageSetup.Zoom
        $wide=$old.PageSetup.FitToPagesWide;$tall=$old.PageSetup.FitToPagesTall
        $old.PageSetup.PrintArea='$A$1:$AA$49';$old.PageSetup.Orientation=2;$old.PageSetup.Zoom=$false
        $old.PageSetup.FitToPagesWide=1;$old.PageSetup.FitToPagesTall=1
        $old.ExportAsFixedFormat(0,$SourcePreview)
        $old.PageSetup.PrintArea=$area;$old.PageSetup.Orientation=$orientation;$old.PageSetup.Zoom=$zoom
        $old.PageSetup.FitToPagesWide=$wide;$old.PageSetup.FitToPagesTall=$tall
    }
    $p=$e.Workbooks.Open($Template,0,$true);$ps=$p.Worksheets.Item('Carrying')
    # Keep the source sheet intact; native renaming maintains its internal references.
    $old.Name='Carrying - Old'
    $ps.Copy([Type]::Missing,$old)
    $s=$b.Worksheets.Item($old.Index+1);$s.Name='Carrying'
    $t=$s.ListObjects.Item('tblCarryingExpenses')
    while($t.ListRows.Count -gt 0){$t.ListRows.Item($t.ListRows.Count).Delete()}
    foreach($r in $m.records){
        $row=$t.ListRows.Add().Range
        $origin='Carrying - Old!'+$r.dateCell+':'+$r.amountCell
        $notes='Value snapshot 2026-10-01 from '+$origin+'. Not independent payment verification.'
        if($r.amountFormula){$notes+=' Original Amount formula: '+$r.amountFormula}
        if($r.dateFormula){$notes+=' Original Date formula: '+$r.dateFormula}
        $status=if($null -eq $r.amount){'Missing Data'}else{'Migrated Snapshot'}
        $values=@('Yes',$r.category,[double]$r.date,$r.vendor,('Legacy '+$r.category+' entry'),$r.amount,'Legacy Grid Snapshot','',$m.sourceName,$status,$notes)
        for($c=1;$c -le 11;$c++){if($null -eq $values[$c-1]){$row.Cells.Item(1,$c).ClearContents()}else{Set-Cell $row.Cells.Item(1,$c) $values[$c-1]}}
    }
    # No project-specific template escrow assumptions belong in Rosebrooks.
    $s.Range('AA8:AA28').ClearContents()
    foreach($col in 1,2,4,5,7,8,10,11,13,14,16,17,19,20,22,23,25,26,28,29,31,32,34,35){
        for($r=8;$r -le 28;$r++){$s.Cells.Item($r,$col).Formula2=([string]$ps.Cells.Item($r,$col).Formula2).Replace('VALUE(tblCarryingExpenses[Amount])','tblCarryingExpenses[Amount]')}
    }
    foreach($col in 1,4,7,10,13,16,19,22,25,28,31,34){
        $label=[string]$s.Cells.Item(5,$col).Value2
        $category=if($label -eq 'Mortgage Payment paid after Reinstatement'){'Mortgage Payment'}else{$label}
        $s.Cells.Item(29,$col+1).Formula2='=SUMIFS(tblCarryingExpenses[Amount],tblCarryingExpenses[Category],"'+$category+'",tblCarryingExpenses[Include],"Yes")'
    }
    foreach($n in $p.Names){if($n.Name -cmatch '^ce[A-Z]'){[void]$b.Names.Add($n.Name,$n.RefersTo)}}
    foreach($name in 'Date','Category','Vendor','Description','Amount','Invoice','SourceFile','Notes','Feedback'){$b.Names.Item('ce'+$name).RefersToRange.MergeArea.ClearContents()}
    $s.Range('D4').Value2='Manual Entry';$s.Range('U4').Value2='Entered';$s.Range('U2').Value2=$true
    $s.Range('AX2').Formula2='=LET(v,TRIM(tblCarryingExpenses[Vendor]&""),SORT(UNIQUE(FILTER(v,v<>"",""))))'
    $s.Shapes.Item('ceIncludeCheckbox').ControlFormat.LinkedCell="'Carrying'!`$U`$2"
    $s.Shapes.Item('ceIncludeCheckbox').ControlFormat.Value=1
    $s.Shapes.Item('ceInsertButton').OnAction="'"+$b.Name.Replace("'","''")+"'!CarryingEntry_Insert"
    $s.Shapes.Item('ceRecurringButton').OnAction="'"+$b.Name.Replace("'","''")+"'!CarryingEntry_Recurring"
    $s.Shapes.Item('ceRecurringButton').Width=$s.Shapes.Item('ceInsertButton').Width
    $s.Shapes.Item('ceRecurringButton').Height=$s.Shapes.Item('ceInsertButton').Height
    [void]$v.VBComponents.Import((Join-Path $PSScriptRoot 'BYHCarryingEntry.bas'))
    [void]$v.VBComponents.Import((Join-Path $PSScriptRoot 'BYHCarryingPrefill.bas'))
    foreach($c in $v.VBComponents){if($code.ContainsKey($c.Name)){
        $now=if($c.CodeModule.CountOfLines){$c.CodeModule.Lines(1,$c.CodeModule.CountOfLines)}else{''}
        Assert ($now -ceq $code[$c.Name]) "Original VBA changed: $($c.Name)"
    }elseif($c.Name -notin @('BYHCarryingEntry','BYHCarryingPrefill')){Assert ($c.CodeModule.CountOfLines -eq 0) 'Unreviewed copied sheet code.'}}
    [void]$profit.Rows.Item(41).Insert()
    $p.Worksheets.Item('Profit').Range('A41:K41').Copy();$profit.Range('A41:K41').PasteSpecial(-4122)
    $profit.Range('A41').Value2='Labor(not in Vendor Tabs)'
    $profit.Range('J41').Formula2='=IF(OR($E$1=2,$E$1=3),-B41,0)*$B$28/($B$28+$B$9)'
    $totalCols=@('B','E','H','K','N','Q','T','W','Z','AC','AI','AF')
    for($i=0;$i -lt $totalCols.Count;$i++){$profit.Cells.Item(31+$i,2).Formula2='=Carrying!'+$totalCols[$i]+'29/Profit!$B$28'}
    $profit.Range('B43').Formula2='=B28*SUM(B31:B42)'
    # Apply the already-approved date-reference repair, not the deferred rent correction.
    $profit.Range('L83').Formula2='=IF(H83=0,0,+J83/H83*$F$75/DAYS(J75,H75))'
    $review=$b.Worksheets.Item('Review').Range('B5:B230')
    $list=[string]$review.Cells.Item(1,1).Validation.Formula1
    Assert (-not ($list.Split(',') -contains 'Carrying')) 'Review map changed.'
    $review.Validation.Modify(3,1,1,($list+',Carrying'))
    $p.Close($false);$p=$null;$e.CutCopyMode=$false
    # Remove only copied external template names. Existing names remain owned by the target.
    foreach($n in @($b.Names)){
        if($n.RefersTo -match '\[.*\.xls'){
            Assert (-not $oldNames.ContainsKey($n.Name)) "Original external name: $($n.Name)"
            Assert ($n.Name -notmatch '^ce[A-Z]') "Unresolved form name: $($n.Name)"
            $n.Delete()
        }
    }
    foreach($sheet in $b.Worksheets){
        try{$formulas=$sheet.UsedRange.SpecialCells(-4123)}catch{$formulas=$null}
        if($formulas){foreach($cell in $formulas){Assert (-not ([string]$cell.Formula2 -match '\[.*\.xls')) "External cell formula: $($sheet.Name)!$($cell.Address())"}}
    }
    foreach($link in @($b.LinkSources(1))){if($link){Assert ([string]$link -like '*rosebrooks-carrying-1252-source-26*') 'Unexpected external source';$b.BreakLink($link,1)}}
    Assert ($null -eq $b.LinkSources(1)) 'External workbook link remains.'
    $e.Calculation=-4105;$e.CalculateFullRebuild()
    Assert ($t.ListRows.Count -eq 24) 'Record count mismatch.'
    Assert ([math]::Abs([double]$profit.Range('B43').Value2-10848.20) -lt .001) 'Carrying total mismatch.'
    Assert ($profit.Range('E1').Value2 -eq $oldMode) 'Project mode changed.'
    Assert ($b.Worksheets.Item('Docs').Range('E39').Formula2 -eq "=+'Carrying - Old'!E5" -or $b.Worksheets.Item('Docs').Range('E39').Formula2 -eq "='Carrying - Old'!E5") 'Deferred Docs link changed.'
    foreach($prop in $m.totals.PSObject.Properties){
        $actual=$e.WorksheetFunction.SumIfs($t.ListColumns.Item('Amount').DataBodyRange,$t.ListColumns.Item('Category').DataBodyRange,$prop.Name)
        Assert ([math]::Abs($actual-[double]$prop.Value) -lt .001) "Category total mismatch: $($prop.Name)"
    }
    $s.Activate();$s.Range('A1').Select()
    $b.Save()
    [ordered]@{output=$Output;records=$t.ListRows.Count;table=$t.Range.Address();profitTotal=$profit.Range('B43').Value2;oldTab=$old.Name;docs=$b.Worksheets.Item('Docs').Range('E39').Formula2;originalModulesPreserved=$code.Count;calculation=$e.Calculation}|ConvertTo-Json
}catch{Write-Output $_.ScriptStackTrace;throw}finally{
    if($p){$p.Close($false)};if($b){$b.Close($false)};$e.Quit()
    [void][Runtime.InteropServices.Marshal]::FinalReleaseComObject($e)
    [GC]::Collect();[GC]::WaitForPendingFinalizers()
}
