param([Parameter(Mandatory)][string]$Workbook)
$ErrorActionPreference='Stop'
function Normalize-Code([string]$code){
    ((($code -replace '(?m)^Attribute VB_Name = "[^"]+"\r?\n','') -replace '\r\n',"`n") -replace 'Err\.description\b','Err.Description').Trim()
}
$e=New-Object -ComObject Excel.Application
$e.Visible=$false;$e.DisplayAlerts=$false;$e.EnableEvents=$false;$e.AutomationSecurity=3
try{
    $b=$e.Workbooks.Open($Workbook,0,$true)
    $v=$b.GetType().InvokeMember('VBProject',[Reflection.BindingFlags]::GetProperty,$null,$b,$null)
    foreach($name in 'BYHCarryingEntry','BYHCarryingPrefill'){
        $m=$v.VBComponents.Item($name).CodeModule
        $expected=Normalize-Code (Get-Content -Raw -LiteralPath (Join-Path $PSScriptRoot ($name+'.bas')))
        $actual=Normalize-Code ($m.Lines(1,$m.CountOfLines))
        if($actual -cne $expected){throw "Current source mismatch: $name"}
        Write-Output "Verified canonical source: $name"
    }
}finally{
    if($b){$b.Close($false)};$e.Quit()
    [void][Runtime.InteropServices.Marshal]::FinalReleaseComObject($e)
    [GC]::Collect();[GC]::WaitForPendingFinalizers()
}
