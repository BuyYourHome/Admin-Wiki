param([Parameter(Mandatory)][string]$Source,[Parameter(Mandatory)][string]$Template,
    [Parameter(Mandatory)][string]$Output,[Parameter(Mandatory)][string]$Inventory,
    [Parameter(Mandatory)][string]$Evidence,[ValidateSet('Banks','Pinetree')][string]$Project)
$ErrorActionPreference='Stop'
function Assert($ok,$message){if(-not $ok){throw $message}}
function Set-Cell($cell,$value){[void]$cell.GetType().InvokeMember('Value2',[Reflection.BindingFlags]::SetProperty,$null,$cell,@($value))}
function Code($c){if($c.CodeModule.CountOfLines){return $c.CodeModule.Lines(1,$c.CodeModule.CountOfLines)};return ''}
$m=(Get-Content -Raw -LiteralPath $Inventory|ConvertFrom-Json).PSObject.Properties[[IO.Path]::GetFileName($Source)].Value
Assert ($m -and (Get-FileHash -LiteralPath $Source).Hash -eq $m.sha256) 'Fresh source inventory required.'
Assert (-not(Test-Path -LiteralPath $Output)) 'Output exists.'
$records=[Collections.Generic.List[object]]::new()
if($Project -eq 'Banks'){
    Assert ($m.missingTable -and $m.cells.E1.value -eq 'Mortgage Payment paid after Reinstatement') 'Banks layout changed.'
    foreach($group in @(@('B','C','Duke Electric','Duke'),@('F','G','Mortgage Payment','Mortgage Payment'),@('J','K','Insurance Payments','Insurance Payments'))){
        for($row=5;$row -le 87;$row++){
            $dateCell=$group[0]+$row;$amountCell=$group[1]+$row
            $d=$m.cells.PSObject.Properties[$dateCell].Value;$a=$m.cells.PSObject.Properties[$amountCell].Value
            if($null -eq $a.value -or $a.value -eq 0){continue}
            Assert ($a.value -is [double] -or $a.value -is [long] -or $a.value -is [int]) "Non-numeric amount $amountCell"
            $records.Add([pscustomobject]@{dateCell=$dateCell;amountCell=$amountCell;date=$d.value;amount=$a.value;category=$group[2];vendor=$group[3];dateFormula=$d.formula;amountFormula=$a.formula})
        }
    }
    Assert ($records.Count -eq 160) 'Banks mapped record count changed.'
}else{Assert ($m.missingSheet) 'Pinetree now has Carrying; remap.'}
[void](New-Item -ItemType Directory -Path (Split-Path -Parent $Output) -Force)
[void](New-Item -ItemType Directory -Path $Evidence -Force)
$records|ConvertTo-Json -Depth 5|Set-Content -LiteralPath (Join-Path $Evidence 'record-map.json')
Copy-Item -LiteralPath $Source -Destination $Output
$e=New-Object -ComObject Excel.Application
# ForceDisable silently refuses native VBA-sheet copies; events remain disabled.
$e.Visible=$false;$e.DisplayAlerts=$false;$e.EnableEvents=$false;$e.AutomationSecurity=1
try{
    $b=$e.Workbooks.Open($Output,0,$false)
    Assert (-not $b.ReadOnly -and $b.FileFormat -eq 52) 'Expected writable XLSM.'
    Assert ($null -eq $b.LinkSources(1)) 'Source has external links; review first.'
    $e.Calculation=-4135
    $profit=$b.Worksheets.Item('Profit');$originalProfit=$profit.Range('B42').Value2
    $v=$b.GetType().InvokeMember('VBProject',[Reflection.BindingFlags]::GetProperty,$null,$b,$null)
    Assert ($v.Protection -eq 0) 'Protected VBA project.'
    $codes=@{};foreach($c in $v.VBComponents){$codes[$c.Name]=Code $c}
    $codes|ConvertTo-Json -Depth 5|Set-Content -LiteralPath (Join-Path $Evidence 'vba-before.json')
    $names=@{};foreach($n in $b.Names){$names[$n.Name]=$n.RefersTo}
    Assert (-not $names.ContainsKey('ceVersion')) 'Existing Carrying form must be reconciled.'
    if($Project -eq 'Banks'){
        $old=$b.Worksheets.Item('Carrying')
        foreach($r in $records){
            Assert ($old.Range($r.dateCell).Value2 -eq $r.date) "Date snapshot changed $($r.dateCell)"
            Assert ([math]::Abs($old.Range($r.amountCell).Value2-$r.amount) -lt .000001) "Amount snapshot changed $($r.amountCell)"
        }
        $old.Name='Carrying - Old';$anchor=$old
    }else{$anchor=$b.Worksheets.Item('Review')}
    $p=$e.Workbooks.Open($Template,0,$true);$ps=$p.Worksheets.Item('Carrying')
    $count=$b.Worksheets.Count;$e.CopyObjectsWithCells=$true
    $b.Activate();$anchor.Activate();$ps.Copy([Type]::Missing,$anchor)
    Assert ($b.Worksheets.Count -eq $count+1) 'Copy failed; no target changes may follow.'
    $s=$b.Worksheets.Item($anchor.Index+1);$s.Name='Carrying'
    $t=$s.ListObjects.Item(1);Assert ($t.ListColumns.Count -eq 11) 'Table schema mismatch.'
    $t.Name='tblCarryingExpenses'
    while($t.ListRows.Count){$t.ListRows.Item($t.ListRows.Count).Delete()}
    foreach($r in $records){
        $row=$t.ListRows.Add().Range
        $note='Value snapshot 2026-10-02 from Carrying - Old!'+$r.dateCell+':'+$r.amountCell+'. Legacy schedules retained; not payment verification.'
        if(([string]$r.dateFormula).StartsWith('=')){$note+=' Original Date formula: '+$r.dateFormula}
        if(([string]$r.amountFormula).StartsWith('=')){$note+=' Original Amount formula: '+$r.amountFormula}
        $status=if($null -eq $r.date){'Missing Data'}else{'Migrated Snapshot'}
        $values=@('Yes',$r.category,$r.date,$r.vendor,('Legacy '+$r.category+' entry'),$r.amount,'Legacy Grid Snapshot','',[IO.Path]::GetFileName($Source),$status,$note)
        for($c=1;$c -le 11;$c++){if($null -eq $values[$c-1]){$row.Cells.Item(1,$c).ClearContents()}else{Set-Cell $row.Cells.Item(1,$c) $values[$c-1]}}
    }
    $capacity=if($Project -eq 'Banks'){82}else{21};$footer=10+$capacity
    $s.Range("A10:AM$footer").ClearContents()
    $ps.Range('A10:AM10').Copy();$s.Range("A10:AM$($footer-1)").PasteSpecial(-4122)|Out-Null
    $ps.Range('A31:AM31').Copy();$s.Range("A${footer}:AM${footer}").PasteSpecial(-4122)|Out-Null
    for($r=10;$r -lt $footer;$r++){$s.Rows.Item($r).RowHeight=$ps.Rows.Item(10).RowHeight}
    $s.Rows.Item($footer).RowHeight=$ps.Rows.Item(31).RowHeight
    for($col=1;$col -le 39;$col+=3){
        foreach($j in @($col,($col+1))){$s.Range($s.Cells.Item(10,$j),$s.Cells.Item($footer-1,$j)).Formula2R1C1=([string]$ps.Cells.Item(10,$j).Formula2R1C1).Replace('HSTACK(tblCarryingExpenses[Date],','HSTACK(IF(tblCarryingExpenses[Date]="","",tblCarryingExpenses[Date]),')}
        $heading=$s.Cells.Item(7,$col).Address($true,$false)
        $s.Cells.Item($footer,$col+1).Formula2='=SUMIFS(tblCarryingExpenses[Amount],tblCarryingExpenses[Category],IF('+ $heading +'="Mortgage Payment paid after Reinstatement","Mortgage Payment",'+ $heading +'),tblCarryingExpenses[Include],"Yes")'
    }
    # Escrow allocations belong to individual projects, never the template.
    $s.Range("AA10:AA$($footer-1)").ClearContents()
    foreach($n in $p.Names){if($n.Name -cmatch '^ce[A-Z]'){[void]$b.Names.Add($n.Name,$n.RefersTo,$n.Visible)}}
    $b.Names.Item('ceEditGrid').RefersTo="=Carrying!`$A`$10:`$AM`$$($footer-1)"
    $b.Names.Item('ceDisplayCapacity').RefersTo='='+$capacity
    $b.Names.Item('ceEditActive').RefersTo='=FALSE'
    foreach($field in 'Date','Category','Vendor','Description','Amount','Invoice','SourceFile','Notes','Feedback'){$b.Names.Item('ce'+$field).RefersToRange.MergeArea.ClearContents()}
    Set-Cell $b.Names.Item('ceSource').RefersToRange 'Manual Entry'
    Set-Cell $b.Names.Item('ceStatus').RefersToRange 'Entered'
    Set-Cell $b.Names.Item('ceInclude').RefersToRange $true
    $s.Range('BA4').Formula2='=LET(v,TRIM(tblCarryingExpenses[Vendor]&""),SORT(UNIQUE(FILTER(v,v<>"",""))))'
    $s.Shapes.Item('ceIncludeCheckbox').ControlFormat.LinkedCell='Carrying!$U$4'
    $s.Shapes.Item('ceIncludeCheckbox').ControlFormat.Value=1
    $actions=@{ceRecurringButton='CarryingEdit_RecurringGuard';ceInsertButton='CarryingEdit_InsertGuard';ceEditButton='CarryingEdit_EditRecord';ceSaveButton='CarryingEdit_SaveChanges';ceCancelButton='CarryingEdit_CancelButton'}
    foreach($name in $actions.Keys){$s.Shapes.Item($name).OnAction="'"+$b.Name.Replace("'","''")+"'!"+$actions[$name]}
    $s.Shapes.Item('ceSaveButton').ControlFormat.Enabled=$false;$s.Shapes.Item('ceCancelButton').ControlFormat.Enabled=$false
    foreach($module in 'BYHCarryingEntry','BYHCarryingPrefill','BYHCarryingEdit'){
        Assert (-not $codes.ContainsKey($module)) "Unexpected existing module $module"
        [void]$v.VBComponents.Import((Join-Path $PSScriptRoot ($module+'.bas')))
    }
    foreach($c in $v.VBComponents){if($codes.ContainsKey($c.Name)){Assert ((Code $c) -ceq $codes[$c.Name]) "Original VBA changed: $($c.Name)"}elseif($c.Name -notlike 'BYHCarrying*'){Assert ($c.CodeModule.CountOfLines -eq 0) 'Unreviewed copied code.'}}
    if($Project -eq 'Banks'){
        Assert ($profit.Range('A41').Text -eq 'Lawn' -and $profit.Range('A42').Text -eq 'Carrying Cost') 'Profit map changed.'
        [void]$profit.Rows.Item(41).Insert()
        $p.Worksheets.Item('Profit').Range('A41:K41').Copy();$profit.Range('A41:K41').PasteSpecial(-4122)|Out-Null
        $profit.Range('A41').Value2='Labor(not in Vendor Tabs)'
        $profit.Range('J41').Formula2='=IF(OR($E$1=2,$E$1=3),-B41,0)*$B$28/($B$28+$B$9)'
        $cats=@('Duke Electric','Mortgage Payment','Private Money','Refinance','Insurance Payments','Water','Natural Gas','HOA','Property Taxes','Excavator Rental','Labor','Lawn')
        for($i=0;$i -lt $cats.Count;$i++){$profit.Cells.Item(31+$i,2).Formula2='=SUMIFS(tblCarryingExpenses[Amount],tblCarryingExpenses[Category],"'+$cats[$i]+'",tblCarryingExpenses[Include],"Yes")/$B$28'}
        $profit.Range('B43').Formula2='=B28*SUM(B31:B42)'
    }
    $review=$b.Worksheets.Item('Review').Range('B5:B217');$list=[string]$review.Cells.Item(1,1).Validation.Formula1
    Assert (-not $list.StartsWith('=')) 'Review uses a named list; map independently.'
    if(-not($list.Split(',') -contains 'Carrying')){$review.Validation.Modify(3,1,1,($list+',Carrying'))}
    foreach($n in @($b.Names)){
        if($n.RefersTo -match '\[.*\.xls|\.xls[mxb]?\x27?!'){
            Assert (-not $names.ContainsKey($n.Name)) "Original external name $($n.Name)"
            Assert ($n.Name -notmatch '(^|!)ce[A-Z]') "Unresolved form name $($n.Name)"
            $n.Delete()
        }
    }
    foreach($sheet in $b.Worksheets){foreach($f in $sheet.UsedRange.Formula2){Assert (-not([string]$f -match '^=.*\[.*\.xls')) "External formula on $($sheet.Name)"}}
    foreach($link in @($b.LinkSources(1))){if($link){Assert ([IO.Path]::GetFileName($link) -eq [IO.Path]::GetFileName($Template)) 'Unexpected link';$b.BreakLink($link,1)}}
    Assert ($null -eq $b.LinkSources(1)) 'External links remain.'
    $e.CutCopyMode=$false;$e.Calculation=-4105;$e.CalculateFullRebuild()
    Assert ($t.ListRows.Count -eq $records.Count) 'Record count mismatch.'
    $expected=($records|Measure-Object amount -Sum).Sum
    if($Project -eq 'Banks'){Assert ([math]::Abs($profit.Range('B43').Value2-$expected) -lt .000001) 'Mapped expenses mismatch.'}
    else{Assert ($profit.Range('B32').Value2 -eq 890.28 -and $profit.Range('B42').Value2 -eq $originalProfit) 'Pinetree estimates changed.'}
    $after=@{};foreach($c in $v.VBComponents){$after[$c.Name]=Code $c}
    $after|ConvertTo-Json -Depth 5|Set-Content -LiteralPath (Join-Path $Evidence 'vba-after.json')
    $s.Activate();$s.Range('A1').Select();$b.Save()
    [ordered]@{file=$b.Name;project=$Project;records=$records.Count;table=$t.Range.Address();capacity=$capacity;footer=$footer;expenseSnapshot=$expected;oldProfit=$originalProfit;profit=$profit.Range($(if($Project -eq 'Banks'){'B43'}else{'B42'})).Value2;calculation=$e.Calculation}|ConvertTo-Json|Tee-Object -FilePath (Join-Path $Evidence 'installation.json')
    $s.PageSetup.PrintArea="`$A`$1:`$AM`$$footer";$s.PageSetup.Orientation=2;$s.PageSetup.PaperSize=8
    $s.PageSetup.Zoom=$false;$s.PageSetup.FitToPagesWide=1;$s.PageSetup.FitToPagesTall=1
    $s.ExportAsFixedFormat(0,(Join-Path $Evidence 'Carrying.pdf'))
}catch{Write-Output $_.ScriptStackTrace;throw}finally{
    if($p){$p.Close($false)};if($b){$b.Close($false)};$e.Quit()
    [void][Runtime.InteropServices.Marshal]::FinalReleaseComObject($e);[GC]::Collect();[GC]::WaitForPendingFinalizers()
}
