param([Parameter(Mandatory)][string]$Source,[Parameter(Mandatory)][string]$Output,[Parameter(Mandatory)][string]$ExpectedSourceCommit)
$ErrorActionPreference='Stop'
function Assert($ok,$message){if(-not $ok){throw $message}}
function Normalize-Code([string]$code){
    # VBE normalizes this member's capitalization on native save; no other source differences are allowed.
    ((($code -replace '(?m)^Attribute VB_Name = "BYHCarryingPrefill"\r?\n','') -replace '\r\n',"`n") -replace 'Err\.description\b','Err.Description').Trim()
}
Assert (-not (Test-Path -LiteralPath $Output)) 'Output already exists.'
$expectedLines=git show "${ExpectedSourceCommit}:Project Rooms/Template to Project/tools/carrying-entry/BYHCarryingPrefill.bas"
Assert ($LASTEXITCODE -eq 0) 'Expected source commit unavailable.'
$expected=Normalize-Code ($expectedLines -join "`n")
[void](New-Item -ItemType Directory -Path (Split-Path -Parent $Output) -Force)
Copy-Item -LiteralPath $Source -Destination $Output
$e=New-Object -ComObject Excel.Application
$e.Visible=$false;$e.DisplayAlerts=$false;$e.EnableEvents=$false;$e.AutomationSecurity=3
try{
    $b=$e.Workbooks.Open($Output,0,$false)
    Assert (-not $b.ReadOnly -and $b.FileFormat -eq 52 -and -not $b.Date1904) 'Workbook state changed.'
    $v=$b.GetType().InvokeMember('VBProject',[Reflection.BindingFlags]::GetProperty,$null,$b,$null)
    Assert ($v.Protection -eq 0) 'VBA project protected.'
    $target=$v.VBComponents.Item('BYHCarryingPrefill')
    $actualTarget=Normalize-Code ($target.CodeModule.Lines(1,$target.CodeModule.CountOfLines))
    if($actualTarget -cne $expected){
        Compare-Object ($expected -split "`n") ($actualTarget -split "`n") -CaseSensitive | Format-Table -Wrap
        throw 'Existing prefill source differs from approved baseline.'
    }
    $code=@{};foreach($c in $v.VBComponents){if($c.Name -ne 'BYHCarryingPrefill'){$code[$c.Name]=if($c.CodeModule.CountOfLines){$c.CodeModule.Lines(1,$c.CodeModule.CountOfLines)}else{''}}}
    $v.VBComponents.Remove($target)
    [void]$v.VBComponents.Import((Join-Path $PSScriptRoot 'BYHCarryingPrefill.bas'))
    foreach($c in $v.VBComponents){if($code.ContainsKey($c.Name)){
        $actual=if($c.CodeModule.CountOfLines){$c.CodeModule.Lines(1,$c.CodeModule.CountOfLines)}else{''}
        Assert ($actual -ceq $code[$c.Name]) "Unrelated VBA changed: $($c.Name)"
    }}
    $e.Calculation=-4105;$e.CalculateFullRebuild();$b.Save()
    [ordered]@{records=$b.Worksheets.Item('Carrying').ListObjects.Item('tblCarryingExpenses').ListRows.Count;profit=$b.Worksheets.Item('Profit').Range('B43').Value2;changedModule='BYHCarryingPrefill';otherModulesPreserved=$code.Count}|ConvertTo-Json
}finally{
    if($b){$b.Close($false)};$e.Quit();[void][Runtime.InteropServices.Marshal]::FinalReleaseComObject($e)
    [GC]::Collect();[GC]::WaitForPendingFinalizers()
}
