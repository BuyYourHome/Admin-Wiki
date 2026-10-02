param([Parameter(Mandatory)][string]$Workbook,[Parameter(Mandatory)][string]$TestCopy)
$ErrorActionPreference='Stop'
function Assert($ok,$message){if(-not $ok){throw $message}}
Assert (-not (Test-Path -LiteralPath $TestCopy)) 'Disposable test already exists.'
Copy-Item -LiteralPath $Workbook -Destination $TestCopy
$e=New-Object -ComObject Excel.Application
$e.Visible=$false;$e.DisplayAlerts=$false;$e.EnableEvents=$false;$e.AutomationSecurity=1
try{
    $b=$e.Workbooks.Open($TestCopy,0,$false)
    function Run($name,$arg=$null){if($null -eq $arg){$e.Run("'"+$b.Name.Replace("'","''")+"'!"+$name)}else{$e.Run("'"+$b.Name.Replace("'","''")+"'!"+$name,$arg)}}
    $before=$b.Worksheets.Item('Carrying').ListObjects.Item('tblCarryingExpenses').DataBodyRange.Formula2
    [void](Run 'CarryingEdit_Load' 1)
    $b.Names.Item('ceAmount').RefersToRange.Value2=98765
    $b.Save();$b.Close($false);$b=$null
    $b=$e.Workbooks.Open($TestCopy,0,$false)
    $result=[string](Run 'CarryingEdit_Save')
    Assert ($result.StartsWith('Not saved: select Cancel Edit')) "Stale saved session allowed: $result"
    [void](Run 'CarryingEdit_InsertGuard')
    $table=$b.Worksheets.Item('Carrying').ListObjects.Item('tblCarryingExpenses')
    Assert ($table.ListRows.Count -eq 56) 'Stale edit inserted a row.'
    $result=[string](Run 'CarryingEdit_Cancel')
    Assert ($result -eq 'Stale edit cleared; source record unchanged.') 'Stale cancellation failed.'
    Assert ($null -eq $b.Names.Item('ceAmount').RefersToRange.Value2) 'Stale form amount retained.'
    $after=$table.DataBodyRange.Formula2
    for($r=1;$r -le 56;$r++){for($c=1;$c -le 11;$c++){Assert ($before[$r,$c] -ceq $after[$r,$c]) 'Reopen changed a source record.'}}
    Write-Output 'Saved/reopened edit refused; insert blocked; cancellation cleared stale inputs; all source records preserved.'
}finally{
    if($b){$b.Close($false)};$e.Quit();[void][Runtime.InteropServices.Marshal]::FinalReleaseComObject($e)
    [GC]::Collect();[GC]::WaitForPendingFinalizers()
}
