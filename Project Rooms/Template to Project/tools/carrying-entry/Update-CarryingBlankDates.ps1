param([Parameter(Mandatory)][string]$Workbook,[Parameter(Mandatory)][string]$Evidence)
$ErrorActionPreference='Stop'
$e=New-Object -ComObject Excel.Application
$e.Visible=$false;$e.DisplayAlerts=$false;$e.EnableEvents=$false;$e.AutomationSecurity=1
try{
    $b=$e.Workbooks.Open($Workbook,0,$false)
    if($b.ReadOnly){throw 'Read-only working copy'}
    $s=$b.Worksheets.Item('Carrying');$grid=$b.Names.Item('ceEditGrid').RefersToRange
    for($c=1;$c -le 39;$c+=3){foreach($col in @($c,($c+1))){
        $range=$grid.Columns.Item($col)
        $f=[string]$range.Cells.Item(1,1).Formula2R1C1
        if(-not $f.Contains('HSTACK(tblCarryingExpenses[Date],')){throw 'Unexpected date/amount formula'}
        $range.Formula2R1C1=$f.Replace('HSTACK(tblCarryingExpenses[Date],','HSTACK(IF(tblCarryingExpenses[Date]="","",tblCarryingExpenses[Date]),')
    }}
    $v=$b.GetType().InvokeMember('VBProject',[Reflection.BindingFlags]::GetProperty,$null,$b,$null)
    $v.VBComponents.Remove($v.VBComponents.Item('BYHCarryingEdit'))
    [void]$v.VBComponents.Import((Join-Path $PSScriptRoot 'BYHCarryingEdit.bas'))
    $codes=@{};foreach($c in $v.VBComponents){$codes[$c.Name]=if($c.CodeModule.CountOfLines){$c.CodeModule.Lines(1,$c.CodeModule.CountOfLines)}else{''}}
    $codes|ConvertTo-Json -Depth 5|Set-Content -LiteralPath (Join-Path $Evidence 'vba-after.json')
    $e.Calculation=-4105;$e.CalculateFullRebuild();$b.Save()
    $footer=$grid.Row+$grid.Rows.Count
    $s.PageSetup.PrintArea="`$A`$1:`$AM`$$footer";$s.PageSetup.Orientation=2;$s.PageSetup.PaperSize=8
    $s.PageSetup.Zoom=$false;$s.PageSetup.FitToPagesWide=1;$s.PageSetup.FitToPagesTall=1
    $s.ExportAsFixedFormat(0,(Join-Path $Evidence 'Carrying.pdf'))
}finally{if($b){$b.Close($false)};$e.Quit();[void][Runtime.InteropServices.Marshal]::FinalReleaseComObject($e);[GC]::Collect();[GC]::WaitForPendingFinalizers()}
