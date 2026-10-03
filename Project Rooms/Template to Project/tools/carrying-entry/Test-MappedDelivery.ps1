param([Parameter(Mandatory)][string]$Workbook,[Parameter(Mandatory)][string]$Evidence)
$ErrorActionPreference='Stop'
function Assert($ok,$message){if(-not $ok){throw $message}}
$expected=Get-Content -Raw -LiteralPath (Join-Path $Evidence 'vba-after.json')|ConvertFrom-Json
$before=Get-Content -Raw -LiteralPath (Join-Path $Evidence 'vba-before.json')|ConvertFrom-Json
$e=New-Object -ComObject Excel.Application
$e.Visible=$false;$e.DisplayAlerts=$false;$e.EnableEvents=$false;$e.AutomationSecurity=1
try{
    $b=$e.Workbooks.Open($Workbook,0,$false);$s=$b.Worksheets.Item('Carrying')
    Assert ($e.Calculation -eq -4105 -and $null -eq $b.LinkSources(1)) 'Calculation/link check failed.'
    $v=$b.GetType().InvokeMember('VBProject',[Reflection.BindingFlags]::GetProperty,$null,$b,$null)
    foreach($c in $v.VBComponents){
        $txt=if($c.CodeModule.CountOfLines){$c.CodeModule.Lines(1,$c.CodeModule.CountOfLines)}else{''}
        Assert ($expected.PSObject.Properties[$c.Name] -and $txt -ceq $expected.PSObject.Properties[$c.Name].Value) "Delivered VBA differs: $($c.Name)"
        if($before.PSObject.Properties[$c.Name]){Assert ($txt -ceq $before.PSObject.Properties[$c.Name].Value) "Original VBA changed: $($c.Name)"}
    }
    $control=$s.Shapes.Item('ceIncludeCheckbox').ControlFormat;$input=$b.Names.Item('ceInclude').RefersToRange
    $control.Value=-4146;Assert ($input.Value2 -eq $false) 'Checkbox does not clear linked value.'
    $control.Value=1;Assert ($input.Value2 -eq $true) 'Checkbox does not set linked value.'
    $records=$s.ListObjects.Item('tblCarryingExpenses').ListRows.Count
    $result=[ordered]@{file=$b.Name;nativeReopen=$true;records=$records;vbaModules=$v.VBComponents.Count;originalModulesPreserved=@($before.PSObject.Properties).Count;checkboxLinked=$true;automatic=$true;externalLinks=0;changesSaved=$false}
    $result|ConvertTo-Json|Tee-Object -FilePath (Join-Path $Evidence 'delivered-native.json')
}finally{if($b){$b.Close($false)};$e.Quit();[void][Runtime.InteropServices.Marshal]::FinalReleaseComObject($e);[GC]::Collect();[GC]::WaitForPendingFinalizers()}
