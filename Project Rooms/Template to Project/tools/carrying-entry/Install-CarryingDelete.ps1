param([Parameter(Mandatory)][string]$Source,[Parameter(Mandatory)][string]$Output,[Parameter(Mandatory)][string]$Evidence)
$ErrorActionPreference='Stop'
if(Test-Path -LiteralPath $Output){throw 'Output exists.'}
[void](New-Item -ItemType Directory -Force -Path (Split-Path -Parent $Output))
Copy-Item -LiteralPath $Source -Destination $Output
$e=New-Object -ComObject Excel.Application
$e.Visible=$false;$e.DisplayAlerts=$false;$e.EnableEvents=$false;$e.AutomationSecurity=1
try{
    $b=$e.Workbooks.Open($Output,0,$false);$s=$b.Worksheets.Item('Carrying');$t=$s.ListObjects.Item('tblCarryingExpenses')
    if($b.ReadOnly){throw 'Read-only target.'}
    $cm=$b.VBProject.VBComponents.Item('BYHCarryingEdit').CodeModule
    $existing=$cm.Lines(1,$cm.CountOfLines)
    if($existing.Contains('CarryingEdit_DeleteSelected')){throw 'Delete already installed; reconcile instead of duplicate.'}
    $canonical=Get-Content -LiteralPath (Join-Path $PSScriptRoot 'BYHCarryingEdit.bas') -Raw
    $marker="' Delete Record toolbar action."
    $start=$canonical.IndexOf($marker);if($start -lt 0){throw 'Missing approved implementation.'}
    $cm.InsertLines($cm.CountOfLines+1,$canonical.Substring($start))
    $order=@('ceRecurringButton','ceInsertButton','ceEditButton','ceSaveButton','ceCancelButton','ceDeleteButton')
    $last=$s.Shapes.Item('ceCancelButton');$new=$last.Duplicate();$new.Name='ceDeleteButton'
    $new.TextFrame.Characters().Text='Delete Record';$new.ControlFormat.Enabled=$true
    $new.OnAction="'"+$b.Name.Replace("'","''")+"'!CarryingEdit_DeleteRecord"
    $left=$s.Shapes.Item($order[0]).Left;$top=$s.Shapes.Item($order[0]).Top
    $right=$b.Names.Item('ceButtonContext').RefersToRange.Left-8
    $total=0;foreach($name in $order){$total+=$s.Shapes.Item($name).Width}
    $gap=($right-$left-$total)/5
    if($gap -lt 6){throw 'Six existing-size buttons do not fit; no automatic resizing authorized.'}
    $positions=@()
    foreach($name in $order){$shape=$s.Shapes.Item($name);$shape.Left=[single]$left;$shape.Top=[single]$top;$positions+=@{name=$name;left=$shape.Left;width=$shape.Width;top=$shape.Top;height=$shape.Height};$left+=$shape.Width+$gap}
    $e.Calculation=-4105;$e.CalculateFullRebuild();$b.Save()
    [ordered]@{file=$b.Name;records=$t.ListRows.Count;gap=$gap;positions=$positions;macro=$new.OnAction}|ConvertTo-Json -Depth 5|Set-Content -LiteralPath $Evidence
    $s.PageSetup.PrintArea='$A$1:$AI$8';$s.PageSetup.Orientation=2;$s.PageSetup.Zoom=$false;$s.PageSetup.FitToPagesWide=1;$s.PageSetup.FitToPagesTall=1
    $s.ExportAsFixedFormat(0,[IO.Path]::ChangeExtension($Evidence,'.pdf'))
    Get-Content -LiteralPath $Evidence
} catch {
    Write-Output $_.ScriptStackTrace
    throw
} finally {
    if($b){$b.Close($false)};$e.Quit();[void][Runtime.InteropServices.Marshal]::FinalReleaseComObject($e)
    [GC]::Collect();[GC]::WaitForPendingFinalizers()
}
