param([Parameter(Mandatory)][string]$Workbook)
$ErrorActionPreference='Stop'
$e=New-Object -ComObject Excel.Application
$e.Visible=$false;$e.DisplayAlerts=$false;$e.EnableEvents=$false;$e.AutomationSecurity=3
try{
    $b=$e.Workbooks.Open($Workbook,0,$false)
    if($b.ReadOnly){throw 'Expected writable temporary workbook.'}
    foreach($name in 'baseCost','baseIdxTxt','editsIdxTxt','editsParentKeyTxt'){
        $n=$b.Names.Item('Carrying!'+$name)
        if($n.RefersTo -notmatch 'rosebrooks-carrying-1327-source-26\.xlsm'){throw "Unexpected name source: $name"}
        $n.Delete()
    }
    foreach($link in @($b.LinkSources(1))){if($link){
        if([IO.Path]::GetFileName([string]$link) -ne 'rosebrooks-carrying-1327-source-26.xlsm'){throw 'Unexpected link source.'}
        $b.BreakLink($link,1)
    }}
    if($null -ne $b.LinkSources(1)){throw 'External link remains.'}
    $e.Calculation=-4105;$e.CalculateFullRebuild();$b.Save()
    Write-Output 'Removed four unused copied external names; saved with Automatic calculation.'
}finally{
    if($b){$b.Close($false)};$e.Quit()
    [void][Runtime.InteropServices.Marshal]::FinalReleaseComObject($e)
    [GC]::Collect();[GC]::WaitForPendingFinalizers()
}
