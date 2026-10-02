param([Parameter(Mandatory)][string]$Source,[Parameter(Mandatory)][string]$Output,
    [Parameter(Mandatory)][string]$Template,[Parameter(Mandatory)][string]$Inventory,
    [Parameter(Mandatory)][string]$Evidence)
$ErrorActionPreference='Stop'
function Assert($ok,$message){if(-not $ok){throw $message}}
function Code($component){if($component.CodeModule.CountOfLines){return $component.CodeModule.Lines(1,$component.CodeModule.CountOfLines)};return ''}
function NormalCode($text){return (($text -replace 'Attribute VB_Name = "[^"]+"\r?\n','' -replace "`r`n","`n").Replace('Application.Goto','Application.GoTo').Replace('Err.Description','Err.description')).Trim()}
$map=(Get-Content -LiteralPath $Inventory -Raw|ConvertFrom-Json).PSObject.Properties[[IO.Path]::GetFileName($Source)].Value
Assert ($map -and $map.table) 'Independent table inventory required.'
Assert ((Get-FileHash -LiteralPath $Source).Hash -eq $map.sha256) 'Source changed; inventory again.'
Assert (-not(Test-Path -LiteralPath $Output)) 'Output exists.'
Assert (@($map.grid|ForEach-Object{$_.overrides}).Count -eq 0) 'Map grid overrides before this update.'
[void](New-Item -ItemType Directory -Path (Split-Path -Parent $Output) -Force)
[void](New-Item -ItemType Directory -Path $Evidence -Force)
Copy-Item -LiteralPath $Source -Destination $Output
$e=New-Object -ComObject Excel.Application
$e.Visible=$false;$e.DisplayAlerts=$false;$e.EnableEvents=$false;$e.AutomationSecurity=3
try{
    $b=$e.Workbooks.Open($Output,0,$false);$s=$b.Worksheets.Item('Carrying');$t=$s.ListObjects.Item('tblCarryingExpenses')
    Assert (-not $b.ReadOnly -and $b.FileFormat -eq 52) 'Expected writable XLSM.'
    Assert ($t.Range.Address().Replace('$','') -eq $map.table -and $t.ListRows.Count -eq $map.rows.Count) 'Table map changed.'
    $baseline=$b.Worksheets.Item('Profit').Range('B43').Value2
    $v=$b.GetType().InvokeMember('VBProject',[Reflection.BindingFlags]::GetProperty,$null,$b,$null)
    $codes=@{};foreach($c in $v.VBComponents){$codes[$c.Name]=Code $c}
    $codes|ConvertTo-Json -Depth 4|Set-Content -LiteralPath (Join-Path $Evidence 'vba-before.json')
    foreach($name in @('BYHCarryingEntry','BYHCarryingPrefill')){
        Assert ($codes.ContainsKey($name)) "Missing approved module $name"
        Assert ((NormalCode $codes[$name]) -ceq (NormalCode (Get-Content -Raw (Join-Path $PSScriptRoot ($name+'.bas'))))) "Reconcile customized module $name"
    }
    $records=$t.DataBodyRange.Formula2
    $includeValue=$b.Names.Item('ceInclude').RefersToRange.Value2
    $newDesign=$map.header -eq 5
    $footer=[int]$map.footer
    if($newDesign){
        Assert ($s.Range('A5').Text -eq 'Duke Electric' -and $s.Range('AH5').Text -eq 'Labor') 'Unexpected grid.'
        $s.Rows.Item('1:2').Insert()|Out-Null;$footer+=2
        $s.Columns.Item('AK:AM').Insert()|Out-Null
        $proto=$e.Workbooks.Open($Template,0,$true);$ps=$proto.Worksheets.Item('Carrying')
        # Native inserts relocate project records and references; copy design only.
        $ps.Range('A1:AM6').Copy();$s.Range('A1:AM6').PasteSpecial(-4122)|Out-Null
        $s.Range('Y1:AI2').UnMerge();$s.Range('Y1:AI2').Merge()
        $s.Range('Y4:AI5').UnMerge();$s.Range('Y4:AI5').Merge()
        $s.Range('W3:X6').ClearContents()
        for($r=1;$r -le 9;$r++){$s.Rows.Item($r).RowHeight=$ps.Rows.Item($r).RowHeight}
        for($c=1;$c -le 39;$c++){$s.Columns.Item($c).ColumnWidth=$ps.Columns.Item($c).ColumnWidth}
        $ps.Range('A7:AM9').Copy();$s.Range('A7:AM9').PasteSpecial(-4122)|Out-Null
        $ps.Range('A10:AM10').Copy();$s.Range("A10:AM$($footer-1)").PasteSpecial(-4122)|Out-Null
        $ps.Range('A31:AM31').Copy();$s.Range("A${footer}:AM${footer}").PasteSpecial(-4122)|Out-Null
        for($r=10;$r -lt $footer;$r++){$s.Rows.Item($r).RowHeight=$ps.Rows.Item(10).RowHeight}
        $s.Rows.Item($footer).RowHeight=$ps.Rows.Item(31).RowHeight
        # Copy category display formulas without transferring source values or escrow assumptions.
        for($col=1;$col -le 39;$col+=3){
            $s.Cells.Item(7,$col).Value2=$ps.Cells.Item(7,$col).Value2
            $s.Cells.Item(9,$col).Value2=$ps.Cells.Item(9,$col).Value2
            $s.Cells.Item(9,$col+1).Value2=$ps.Cells.Item(9,$col+1).Value2
            foreach($j in @($col,($col+1))){
                $s.Range($s.Cells.Item(10,$j),$s.Cells.Item($footer-1,$j)).Formula2R1C1=$ps.Cells.Item(10,$j).Formula2R1C1
            }
            if($col -ne 25){
                $heading=$s.Cells.Item(7,$col).Address($true,$false)
                $s.Cells.Item($footer,$col+1).Formula2='=SUMIFS(tblCarryingExpenses[Amount],tblCarryingExpenses[Category],IF('+ $heading +'="Mortgage Payment paid after Reinstatement","Mortgage Payment",'+ $heading +'),tblCarryingExpenses[Include],"Yes")'
            }
        }
        $s.Range("A7:AM$footer").Interior.Color=$ps.Range('H11').Interior.Color
        $s.Range('Y1').Value2=$ps.Range('Y1').Value2
        $s.Range('Y4').MergeArea.ClearContents()
        foreach($name in @('ceRecurringButton','ceInsertButton','ceIncludeCheckbox')){try{$s.Shapes.Item($name).Delete()}catch{throw "Missing expected control $name"}}
        foreach($name in @('ceRecurringButton','ceInsertButton','ceEditButton','ceSaveButton','ceCancelButton','ceIncludeCheckbox')){
            $old=$ps.Shapes.Item($name)
            $new=$s.Shapes.AddFormControl($old.FormControlType,$old.Left,$old.Top,$old.Width,$old.Height)
            $new.Name=$name;$new.Placement=$old.Placement;$new.Visible=$old.Visible
            $new.DrawingObject.PrintObject=$old.DrawingObject.PrintObject
            $new.TextFrame.Characters().Text=$old.TextFrame.Characters().Text
            if($old.TextFrame.Characters().Font.Name -is [string]){$new.TextFrame.Characters().Font.Name=$old.TextFrame.Characters().Font.Name}
            if($old.TextFrame.Characters().Font.Size -is [double]){$new.TextFrame.Characters().Font.Size=$old.TextFrame.Characters().Font.Size}
            if($name -eq 'ceIncludeCheckbox'){
                $new.ControlFormat.LinkedCell='Carrying!$U$4'
                $inc=$b.Names.Item('ceInclude').RefersToRange
                [void]$inc.GetType().InvokeMember('Value2',[Reflection.BindingFlags]::SetProperty,$null,$inc,@($includeValue))
            }
        }
        $proto.Close($false);$proto=$null
        [void]$b.Names.Add('ceEditActive','=FALSE',$false)
        [void]$b.Names.Add('ceEditVersion','="1.0"',$false)
        [void]$b.Names.Add('ceEditGrid',"=Carrying!`$A`$10:`$AM`$$($footer-1)",$false)
        [void]$b.Names.Add('ceEditHeaders','=Carrying!$A$7:$AM$7',$false)
        [void]$b.Names.Add('ceButtonContext','=Carrying!$Y$1:$AI$2',$false)
        $b.Names.Item('ceFeedback').RefersTo='=Carrying!$Y$4'
        Assert (-not $codes.ContainsKey('BYHCarryingEdit')) 'Editor exists; reconcile before import.'
        [void]$v.VBComponents.Import((Join-Path $PSScriptRoot 'BYHCarryingEdit.bas'))
    }else{Assert ($map.header -eq 7 -and $map.capacity -eq 21 -and $s.Range('AK7').Text -eq 'Rent') 'Unknown existing design.'}
    $categories='Duke Electric,Mortgage Payment,Private Money,Refinance,Insurance Payments,Water,Natural Gas,HOA,Property Taxes,Excavator Rental,Lawn,Labor,Rent'
    $b.Names.Item('ceCategories').RefersTo='="'+$categories+'"'
    $b.Names.Item('ceCategory').RefersToRange.Validation.Modify(3,1,1,$categories)
    if($b.Names.Item('ceCategory').RefersToRange.Value2 -eq 'Casa Lending'){$b.Names.Item('ceCategory').RefersToRange.Value2='Refinance'}
    $s.Range('J7').Value2='Refinance'
    $renamed=0;$filled=0
    for($r=1;$r -le $t.ListRows.Count;$r++){
        $cat=$t.ListColumns.Item('Category').DataBodyRange.Cells.Item($r,1)
        $vendor=$t.ListColumns.Item('Vendor').DataBodyRange.Cells.Item($r,1)
        if(-not $vendor.HasFormula -and -not ([string]$vendor.Value2).Trim()){$vendor.Value2=$cat.Value2;$filled++}
        if($cat.Value2 -eq 'Casa Lending'){Assert (-not $cat.HasFormula) 'Formula category needs mapping.';$cat.Value2='Refinance';$renamed++}
    }
    # Category criteria only: vendor names, notes and source references stay untouched.
    foreach($cell in $s.Range("A7:AM$footer").Cells){if($cell.HasFormula -and ([string]$cell.Formula2).Contains('"Casa Lending"')){$cell.Formula2=([string]$cell.Formula2).Replace('"Casa Lending"','"Refinance"')}}
    $actions=@{ceRecurringButton='CarryingEdit_RecurringGuard';ceInsertButton='CarryingEdit_InsertGuard';ceEditButton='CarryingEdit_EditRecord';ceSaveButton='CarryingEdit_SaveChanges';ceCancelButton='CarryingEdit_CancelButton'}
    foreach($name in $actions.Keys){$s.Shapes.Item($name).OnAction="'"+$b.Name.Replace("'","''")+"'!"+$actions[$name]}
    $active=[bool]$e.Evaluate($b.Names.Item('ceEditActive').RefersTo)
    $s.Shapes.Item('ceSaveButton').ControlFormat.Enabled=$active;$s.Shapes.Item('ceCancelButton').ControlFormat.Enabled=$active
    $beforeDelete=$t.DataBodyRange.Formula2
    for($r=1;$r -le $map.rows.Count;$r++){for($c=1;$c -le 11;$c++){
        $expected=$records[$r,$c]
        if($c -eq 2 -and $expected -eq 'Casa Lending'){$expected='Refinance'}
        if($c -eq 4 -and -not ([string]$expected).Trim()){$expected=$records[$r,2]}
        Assert ($expected -ceq $beforeDelete[$r,$c]) "Record changed $r,$c"
    }}
    foreach($zero in @($map.zeros|Sort-Object -Descending)){
        $index=[int]$zero-([int]($map.rows[0].row)-1)
        $amount=$t.ListColumns.Item('Amount').DataBodyRange.Cells.Item($index,1)
        Assert (-not $amount.HasFormula -and $amount.Value2 -is [double] -and $amount.Value2 -eq 0) 'Zero cleanup map changed.'
        $t.ListRows.Item($index).Delete()
    }
    foreach($c in $v.VBComponents){if($codes.ContainsKey($c.Name)){Assert ((Code $c) -ceq $codes[$c.Name]) "Unrelated VBA changed: $($c.Name)"}}
    $afterCodes=@{};foreach($c in $v.VBComponents){$afterCodes[$c.Name]=Code $c}
    $afterCodes|ConvertTo-Json -Depth 4|Set-Content -LiteralPath (Join-Path $Evidence 'vba-after.json')
    $e.CutCopyMode=$false;$e.Calculation=-4105;$e.CalculateFullRebuild()
    Assert ([math]::Abs($b.Worksheets.Item('Profit').Range('B43').Value2-$baseline) -lt .000001) 'Expense total changed.'
    Assert ($null -eq $b.LinkSources(1)) 'Unexpected workbook links.'
    foreach($g in $map.grid){Assert ([math]::Abs($s.Cells.Item($footer,$g.col+1).Value2-$g.total) -lt .000001) "Category total changed: $($g.category)"}
    Assert ($s.Cells.Item($footer,38).Value2 -eq 0) 'Unexpected Rent income.'
    $s.Activate();$s.Range('A1').Select();$b.Save()
    $result=[ordered]@{file=$b.Name;rows=$t.ListRows.Count;table=$t.Range.Address();capacity=$map.capacity;footer=$footer;profit=$baseline;renamed=$renamed;vendorsFilled=$filled;zerosRemoved=@($map.zeros).Count;originalVba=$codes.Count;calculation=$e.Calculation}
    $result|ConvertTo-Json|Set-Content -LiteralPath (Join-Path $Evidence 'installation.json')
    $result|ConvertTo-Json
    $s.PageSetup.PrintArea="`$A`$1:`$AM`$$footer";$s.PageSetup.Orientation=2;$s.PageSetup.PaperSize=8
    $s.PageSetup.Zoom=$false;$s.PageSetup.FitToPagesWide=1;$s.PageSetup.FitToPagesTall=1
    $s.ExportAsFixedFormat(0,(Join-Path $Evidence 'Carrying.pdf'))
}catch{Write-Output $_.ScriptStackTrace;throw}finally{
    if($proto){$proto.Close($false)};if($b){$b.Close($false)};$e.Quit()
    [void][Runtime.InteropServices.Marshal]::FinalReleaseComObject($e);[GC]::Collect();[GC]::WaitForPendingFinalizers()
}
