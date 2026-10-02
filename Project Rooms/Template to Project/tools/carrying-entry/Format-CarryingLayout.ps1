param([Parameter(Mandatory)][string]$Source,[string]$Output,[Parameter(Mandatory)][string]$PreviewPdf,[switch]$Apply,[switch]$KeepEscrowColumn,[switch]$ContextBox,[switch]$OrangeGrid)
$ErrorActionPreference='Stop'
function Assert($condition,$message){if(-not $condition){throw $message}}
$path=$Source
if($Apply){
    Assert ($Output -and -not (Test-Path -LiteralPath $Output)) 'Supply a new output path.'
    [void](New-Item -ItemType Directory -Path (Split-Path -Parent $Output) -Force)
    Copy-Item -LiteralPath $Source -Destination $Output
    $path=$Output
}
$e=New-Object -ComObject Excel.Application
$e.Visible=$false;$e.DisplayAlerts=$false;$e.EnableEvents=$false;$e.AutomationSecurity=3
try{
    $b=$e.Workbooks.Open($path,0,$false)
    $s=$b.Worksheets.Item('Carrying');$t=$s.ListObjects.Item('tblCarryingExpenses')
    $headers=$b.Names.Item('ceEditHeaders').RefersToRange
    $grid=$b.Names.Item('ceEditGrid').RefersToRange
    $buttons=@('ceRecurringButton','ceInsertButton','ceEditButton','ceSaveButton','ceCancelButton')
    $names=@{};foreach($n in $b.Names){if($n.Name -like 'ce*'){$names[$n.Name]=$n.RefersTo}}
    $widths=@();for($c=1;$c -le 36;$c++){$widths+= $s.Columns.Item($c).ColumnWidth}
    $shapes=@();foreach($shape in $s.Shapes){$shapes+= [ordered]@{name=$shape.Name;left=$shape.Left;top=$shape.Top;width=$shape.Width;height=$shape.Height;action=$shape.OnAction}}
    $rows=@();for($r=1;$r -le 9;$r++){$rows+=$s.Rows.Item($r).RowHeight}
    $labels=@();for($c=1;$c -le 36;$c+=3){$labels+=$headers.Cells.Item(1,$c).Text}
    $before=$t.DataBodyRange.Formula2;$profit=$b.Worksheets.Item('Profit').Range('B43').Value2
    if($Apply){
        Assert ($headers.Row -eq 7 -and $grid.Row -eq 10 -and $headers.Columns.Count -eq 36) 'Remap the current presentation before formatting.'
        Assert ($s.Range('G7').Text -eq 'Private Money' -and $s.Range('AH7').Text -eq 'Labor') 'Unexpected category map.'
        $target=@($s.Columns.Item(7).ColumnWidth,$s.Columns.Item(8).ColumnWidth,$s.Columns.Item(9).ColumnWidth)
        $orange=$s.Range('H11').Interior.Color
        if($OrangeGrid){Assert ($orange -eq 49407) 'Remap owner orange sample before applying grid fill.'}
        $geometry=@{};foreach($name in $buttons){$shape=$s.Shapes.Item($name);$geometry[$name]=@($shape.Width,$shape.Height,$shape.OnAction)}
        for($c=1;$c -le 36;$c++){$s.Columns.Item($c).ColumnWidth=$target[($c-1)%3]}
        if($KeepEscrowColumn){$s.Columns.Item(27).ColumnWidth=$widths[26]}
        $start=$s.Range('A1').Left+6;$end=$s.Range('AJ1').Left+$s.Range('AJ1').Width-6
        if($ContextBox){$end=$s.Range('V1').Left+$s.Range('V1').Width-12}
        $total=0;foreach($name in $buttons){$total+=$geometry[$name][0]}
        $gap=($end-$start-$total)/($buttons.Count-1)
        Assert ($gap -ge 8) 'Insufficient toolbar space.'
        $band=$s.Range('A1:AJ2');$x=$start
        foreach($name in $buttons){
            $shape=$s.Shapes.Item($name);$shape.Width=$geometry[$name][0];$shape.Height=$geometry[$name][1]
            Assert ($shape.Height -le $band.Height-4) 'Button exceeds owner toolbar height.'
            $shape.Left=$x;$shape.Top=$band.Top+($band.Height-$shape.Height)/2
            Assert ($shape.OnAction -ceq $geometry[$name][2]) "Action changed: $name"
            $x+=$shape.Width+$gap
        }
        $after=$t.DataBodyRange.Formula2
        for($r=1;$r -le $before.GetLength(0);$r++){for($c=1;$c -le $before.GetLength(1);$c++){Assert ($before[$r,$c] -ceq $after[$r,$c]) 'Source record changed.'}}
        foreach($name in $names.Keys){Assert ($b.Names.Item($name).RefersTo -ceq $names[$name]) "Name changed: $name"}
        for($r=1;$r -le 9;$r++){Assert ($s.Rows.Item($r).RowHeight -eq $rows[$r-1]) 'Owner row height changed.'}
        if($ContextBox){
            $box=$s.Range('W1:AJ2')
            Assert ($e.WorksheetFunction.CountA($box) -eq 0) 'Context box would overwrite existing content.'
            $box.Merge();$box.WrapText=$true;$box.VerticalAlignment=-4108;$box.HorizontalAlignment=-4131
            $box.Font.Size=10;$box.Interior.Color=15132390;$box.Borders.LineStyle=1;$box.Borders.Color=11184810
            $box.Cells.Item(1,1).Value2='Do not type into the orange grid. Select a bill and use Edit Record. Each button shows its purpose here; action results appear below.'
            [void]$b.Names.Add('ceButtonContext',"=Carrying!`$W`$1:`$AJ`$2",$false)
            $v=$b.GetType().InvokeMember('VBProject',[Reflection.BindingFlags]::GetProperty,$null,$b,$null)
            $codes=@{};foreach($component in $v.VBComponents){$codes[$component.Name]=if($component.CodeModule.CountOfLines){$component.CodeModule.Lines(1,$component.CodeModule.CountOfLines)}else{''}}
            $expected=(& git show '27cb3d7b:Project Rooms/Template to Project/tools/carrying-entry/BYHCarryingEdit.bas') -join "`n"
            $expected=($expected -replace 'Attribute VB_Name = "BYHCarryingEdit"\r?\n','').Trim()
            $expected=$expected.Replace('Application.Goto','Application.GoTo').Replace('Err.Description','Err.description')
            $actual=($codes['BYHCarryingEdit'] -replace "`r`n","`n").Trim()
            if($actual -cne $expected){Compare-Object ($expected -split "`n") ($actual -split "`n") -CaseSensitive | Select-Object -First 12 | Format-Table -Wrap | Out-String | Write-Output}
            Assert ($actual -ceq $expected) 'Editor differs from approved source; reconcile before updating.'
            $v.VBComponents.Remove($v.VBComponents.Item('BYHCarryingEdit'))
            [void]$v.VBComponents.Import((Join-Path $PSScriptRoot 'BYHCarryingEdit.bas'))
            foreach($component in $v.VBComponents){if($component.Name -ne 'BYHCarryingEdit'){
                $current=if($component.CodeModule.CountOfLines){$component.CodeModule.Lines(1,$component.CodeModule.CountOfLines)}else{''}
                Assert ($current -ceq $codes[$component.Name]) "Unrelated VBA changed: $($component.Name)"
            }}
        }
        if($OrangeGrid){$s.Range('A7:AJ31').Interior.Color=$orange}
        $e.Calculation=-4105;$e.CalculateFullRebuild()
        Assert ([math]::Abs($b.Worksheets.Item('Profit').Range('B43').Value2-$profit) -lt .000001) 'Profit changed.'
        $b.Save()
    }
    [ordered]@{applied=[bool]$Apply;table=$t.Range.Address();records=$t.ListRows.Count;profit=$profit;headers=$headers.Address();grid=$grid.Address();names=$names;originalWidths=$widths;rowHeights=$rows;labels=$labels;originalShapes=$shapes;targetWidths=$target;buttonGap=$gap}|ConvertTo-Json -Depth 6
    # Preview-only print changes are discarded after exporting.
    $s.PageSetup.PrintArea='$A$1:$AJ$31';$s.PageSetup.Orientation=2;$s.PageSetup.PaperSize=8
    $s.PageSetup.Zoom=$false;$s.PageSetup.FitToPagesWide=1;$s.PageSetup.FitToPagesTall=1
    $s.ExportAsFixedFormat(0,$PreviewPdf)
}finally{
    if($b){$b.Close($false)};$e.Quit();[void][Runtime.InteropServices.Marshal]::FinalReleaseComObject($e)
    [GC]::Collect();[GC]::WaitForPendingFinalizers()
}
