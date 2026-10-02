param([Parameter(Mandatory)][string]$Source,[Parameter(Mandatory)][string]$Output,[Parameter(Mandatory)][string]$ExpectedSourceCommit)
$ErrorActionPreference='Stop'
function Assert($ok,$message){if(-not $ok){throw $message}}
function Normalize-Code([string]$code){
    (($code -replace '(?m)^Attribute VB_Name = "BYHCarryingEdit"\r?\n','') -replace '\r\n',"`n").Trim().Replace('Application.Goto','Application.GoTo').Replace('Err.Description','Err.description')
}
Assert (-not (Test-Path -LiteralPath $Output)) 'Output already exists.'
$expectedLines=git show "${ExpectedSourceCommit}:Project Rooms/Template to Project/tools/carrying-entry/BYHCarryingEdit.bas"
Assert ($LASTEXITCODE -eq 0) 'Expected source unavailable.'
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
    $target=$v.VBComponents.Item('BYHCarryingEdit')
    Assert ((Normalize-Code ($target.CodeModule.Lines(1,$target.CodeModule.CountOfLines))) -ceq $expected) 'Editor differs from approved baseline; reconcile.'
    $code=@{};foreach($c in $v.VBComponents){if($c.Name -ne 'BYHCarryingEdit'){$code[$c.Name]=if($c.CodeModule.CountOfLines){$c.CodeModule.Lines(1,$c.CodeModule.CountOfLines)}else{''}}}
    $v.VBComponents.Remove($target)
    [void]$v.VBComponents.Import((Join-Path $PSScriptRoot 'BYHCarryingEdit.bas'))
    foreach($c in $v.VBComponents){if($code.ContainsKey($c.Name)){
        $actual=if($c.CodeModule.CountOfLines){$c.CodeModule.Lines(1,$c.CodeModule.CountOfLines)}else{''}
        Assert ($actual -ceq $code[$c.Name]) "Unrelated VBA changed: $($c.Name)"
    }}
    $e.Calculation=-4105;$e.CalculateFullRebuild();$b.Save()
    [ordered]@{records=$b.Worksheets.Item('Carrying').ListObjects.Item('tblCarryingExpenses').ListRows.Count;profit=$b.Worksheets.Item('Profit').Range('B43').Value2;changedModule='BYHCarryingEdit';otherModulesPreserved=$code.Count}|ConvertTo-Json
}finally{
    if($b){$b.Close($false)};$e.Quit();[void][Runtime.InteropServices.Marshal]::FinalReleaseComObject($e)
    [GC]::Collect();[GC]::WaitForPendingFinalizers()
}
