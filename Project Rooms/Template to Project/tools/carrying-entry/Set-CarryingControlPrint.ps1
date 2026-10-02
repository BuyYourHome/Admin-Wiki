param([Parameter(Mandatory)][string]$Workbook,[Parameter(Mandatory)][string]$PreviewPdf)
$ErrorActionPreference='Stop'
$e=New-Object -ComObject Excel.Application
$e.Visible=$false;$e.DisplayAlerts=$false;$e.EnableEvents=$false;$e.AutomationSecurity=3
try{
    $b=$e.Workbooks.Open($Workbook,0,$false);$s=$b.Worksheets.Item('Carrying')
    foreach($name in @('ceRecurringButton','ceInsertButton','ceEditButton','ceSaveButton','ceCancelButton')){$s.Shapes.Item($name).DrawingObject.PrintObject=$true}
    $e.Calculation=-4105;$b.Save()
    $grid=$b.Names.Item('ceEditGrid').RefersToRange;$footer=$grid.Row+$grid.Rows.Count
    $s.PageSetup.PrintArea="`$A`$1:`$AM`$$footer";$s.PageSetup.Orientation=2;$s.PageSetup.PaperSize=8
    $s.PageSetup.Zoom=$false;$s.PageSetup.FitToPagesWide=1;$s.PageSetup.FitToPagesTall=1
    $s.ExportAsFixedFormat(0,$PreviewPdf)
}finally{if($b){$b.Close($false)};$e.Quit();[void][Runtime.InteropServices.Marshal]::FinalReleaseComObject($e);[GC]::Collect();[GC]::WaitForPendingFinalizers()}
