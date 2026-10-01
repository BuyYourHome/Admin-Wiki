param([Parameter(Mandatory)][string]$Before,[Parameter(Mandatory)][string]$After)
$ErrorActionPreference='Stop'
$e=New-Object -ComObject Excel.Application
$e.Visible=$false;$e.DisplayAlerts=$false;$e.EnableEvents=$false;$e.AutomationSecurity=3
try {
    $snapshots=@()
    foreach($path in @($Before,$After)){
        $b=$e.Workbooks.Open($path,0,$true)
        $v=$b.GetType().InvokeMember('VBProject',[Reflection.BindingFlags]::GetProperty,$null,$b,$null)
        $code=@{}
        foreach($c in $v.VBComponents){$code[$c.Name]=if($c.CodeModule.CountOfLines){$c.CodeModule.Lines(1,$c.CodeModule.CountOfLines)}else{''}}
        $snapshots+=,$code;$b.Close($false);$b=$null
    }
    if($snapshots[0].Count -ne $snapshots[1].Count){throw 'VBA component count changed.'}
    foreach($name in $snapshots[0].Keys){if($snapshots[0][$name] -cne $snapshots[1][$name]){throw "VBA source changed: $name"}}
    "Verified unchanged VBA source for $($snapshots[0].Count) components."
}finally{if($b){$b.Close($false)};$e.Quit();[void][Runtime.InteropServices.Marshal]::FinalReleaseComObject($e)}
