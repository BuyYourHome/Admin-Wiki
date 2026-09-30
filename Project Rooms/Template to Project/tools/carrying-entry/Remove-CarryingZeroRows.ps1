param([Parameter(Mandatory)][string]$Source,[Parameter(Mandatory)][string]$Output,
      [Parameter(Mandatory)][int]$ExpectedRows,[Parameter(Mandatory)][int]$ExpectedZeroRows,
      [Parameter(Mandatory)][string]$ProfitTotalCell)
$ErrorActionPreference='Stop'
function Assert($ok,$msg){if(-not $ok){throw $msg}}
Assert (-not (Test-Path -LiteralPath $Output)) 'Output exists.'
[void](New-Item -ItemType Directory -Path (Split-Path -Parent $Output) -Force)
Copy-Item -LiteralPath $Source -Destination $Output
$e=New-Object -ComObject Excel.Application
$e.Visible=$false;$e.DisplayAlerts=$false;$e.EnableEvents=$false;$e.AutomationSecurity=3
try {
    $b=$e.Workbooks.Open($Output,0,$false)
    Assert (-not $b.ReadOnly) 'Copy is read-only.'
    $s=$b.Worksheets.Item('Carrying');$t=$s.ListObjects.Item('tblCarryingExpenses')
    Assert ($t.ListRows.Count -eq $ExpectedRows) 'Record count changed; remap.'
    $amountCol=$t.ListColumns.Item('Amount').Index
    $before=$t.DataBodyRange.Formula2;$values=$t.DataBodyRange.Value2
    $total=$b.Worksheets.Item('Profit').Range($ProfitTotalCell).Value2
    $remove=[Collections.Generic.List[int]]::new()
    for($r=1;$r -le $ExpectedRows;$r++){
        $cell=$t.DataBodyRange.Cells.Item($r,$amountCol);$value=$values[$r,$amountCol]
        if(-not $cell.HasFormula -and $null -ne $value -and $value -isnot [string] -and $value -isnot [bool] -and $value -eq 0){$remove.Add($r)}
    }
    Assert ($remove.Count -eq $ExpectedZeroRows) 'Zero count changed; remap.'
    Assert ($remove.Count -lt $ExpectedRows) 'All-zero table needs an empty-table design review.'
    $e.Calculation=-4135
    # Delete table rows only, backwards; never shift the neighboring display grid.
    for($i=$remove.Count-1;$i -ge 0;$i--){$t.ListRows.Item($remove[$i]).Delete()}
    $after=$t.DataBodyRange.Formula2;$dest=0
    for($r=1;$r -le $ExpectedRows;$r++){
        if($remove.Contains($r)){continue};$dest++
        for($c=1;$c -le $before.GetLength(1);$c++){
            Assert ($before[$r,$c] -ceq $after[$dest,$c]) "Surviving record changed: $r,$c"
        }
    }
    $e.Calculation=-4105;$e.CalculateFullRebuild()
    Assert ([math]::Abs([double]$b.Worksheets.Item('Profit').Range($ProfitTotalCell).Value2-[double]$total) -lt .001) 'Profit total changed.'
    $b.Save()
    [ordered]@{removed=$remove.Count;remaining=$t.ListRows.Count;table=$t.Range.Address();profitTotal=$total;removedOriginalIndices=@($remove)} | ConvertTo-Json -Depth 3
}finally{
    if($b){$b.Close($false)};$e.Quit()
    [void][Runtime.InteropServices.Marshal]::FinalReleaseComObject($e)
    [GC]::Collect();[GC]::WaitForPendingFinalizers()
}
