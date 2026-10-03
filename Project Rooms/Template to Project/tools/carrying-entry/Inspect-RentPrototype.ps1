param([Parameter(Mandatory)][string]$Workbook,[Parameter(Mandatory)][string]$Evidence)
$ErrorActionPreference='Stop'
$e=New-Object -ComObject Excel.Application
$e.Visible=$false;$e.DisplayAlerts=$false;$e.EnableEvents=$false;$e.AutomationSecurity=3
try {
    $b=$e.Workbooks.Open($Workbook,0,$true)
    $p=$b.Worksheets.Item('Profit');$s=$b.Worksheets.Item('Carrying')
    $codes=[ordered]@{};$controls=[ordered]@{};$errors=[ordered]@{}
    foreach($component in $b.VBProject.VBComponents){
        $cm=$component.CodeModule
        $codes[$component.Name]=$(if($cm.CountOfLines){$cm.Lines(1,$cm.CountOfLines)}else{''})
    }
    foreach($ws in $b.Worksheets){
        $shapes=@(foreach($sh in $ws.Shapes){[ordered]@{name=$sh.Name;type=$sh.Type;left=$sh.Left;top=$sh.Top;width=$sh.Width;height=$sh.Height;visible=$sh.Visible;action=$sh.OnAction}})
        $controls[$ws.Name]=$shapes
        try{$bad=$ws.UsedRange.SpecialCells(-4123,16);$errors[$ws.Name]=@($bad.Cells|Where-Object{$_.Text -match '^#'}|ForEach-Object{[ordered]@{cell=$_.Address();text=$_.Text;formula=$_.Formula2}})}catch{$errors[$ws.Name]=@()}
    }
    $mode=$p.Range('E1').Value2;$modes=[ordered]@{}
    foreach($n in 1,2,3){
        $p.Range('E1').Formula=[string]$n;$e.CalculateFullRebuild()
        $values=[ordered]@{}
        foreach($address in @('B9','C9','E9','K9','B43','E55','H58','K57','J58','M63','H15')){$values[$address]=$p.Range($address).Value2}
        $modes[[string]$n]=$values
    }
    $p.Range('E1').Formula=[string]$mode;$e.CalculateFullRebuild()
    $result=[ordered]@{file=$b.Name;calculation=$e.Calculation;mode=$mode;codes=$codes;controls=$controls;errors=$errors;modes=$modes;rentGrid=$s.Range('AK9:AM31').Value2;profitWidths=@(1..23|ForEach-Object{$p.Columns.Item($_).ColumnWidth})}
    $result|ConvertTo-Json -Depth 12|Set-Content -LiteralPath $Evidence
    $p.PageSetup.PrintArea='$A$1:$W$63';$p.PageSetup.Zoom=$false;$p.PageSetup.FitToPagesWide=1;$p.PageSetup.FitToPagesTall=1;$p.PageSetup.Orientation=2
    $p.ExportAsFixedFormat(0,[IO.Path]::ChangeExtension($Evidence,'.pdf'))
    $s.PageSetup.PrintArea='$AH$7:$AM$31';$s.PageSetup.Zoom=$false;$s.PageSetup.FitToPagesWide=1;$s.PageSetup.FitToPagesTall=1;$s.PageSetup.Orientation=1
    $s.ExportAsFixedFormat(0,[IO.Path]::ChangeExtension($Evidence,'.rent.pdf'))
    [ordered]@{modes=$modes;errorCount=($errors.Values|ForEach-Object{$_.Count}|Measure-Object -Sum).Sum;controlCount=($controls.Values|ForEach-Object{$_.Count}|Measure-Object -Sum).Sum;calculation=$e.Calculation}|ConvertTo-Json -Depth 6
} finally {
    if($b){$b.Close($false)};$e.Quit();[void][Runtime.InteropServices.Marshal]::FinalReleaseComObject($e)
    [GC]::Collect();[GC]::WaitForPendingFinalizers()
}
