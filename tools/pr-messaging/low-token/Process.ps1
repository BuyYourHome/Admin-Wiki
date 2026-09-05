function ConvertTo-LtWindowsArgument([string]$Value) {
    # Windows argv quoting: double runs of slashes before quotes and the closing quote.
    '"' + [regex]::Replace([regex]::Replace($Value, '(\\*)"', '$1$1\"'), '(\\+)$', '$1$1') + '"'
}
function Invoke-LtProcess([string]$Executable,[string[]]$Arguments,[int]$TimeoutSeconds=15) {
    $psi=[Diagnostics.ProcessStartInfo]::new()
    $psi.FileName=$Executable; $psi.Arguments=($Arguments | ForEach-Object {ConvertTo-LtWindowsArgument $_}) -join ' '
    $psi.UseShellExecute=$false; $psi.CreateNoWindow=$true; $psi.RedirectStandardOutput=$true; $psi.RedirectStandardError=$true
    $psi.StandardOutputEncoding=[Text.UTF8Encoding]::new($false)
    $psi.StandardErrorEncoding=[Text.UTF8Encoding]::new($false)
    $p=[Diagnostics.Process]::new(); $p.StartInfo=$psi
    try {
        if (!$p.Start()) { throw 'ProcessNotStarted' }
        $out=$p.StandardOutput.ReadToEndAsync(); $err=$p.StandardError.ReadToEndAsync()
        if (!$p.WaitForExit($TimeoutSeconds*1000)) {
            # Only stop the child launched here, never the desktop app or daemon.
            try { $p.Kill() } catch { }
            $p.WaitForExit(2000) | Out-Null
            return [pscustomobject]@{timed_out=$true;exit_code=$null;stdout='';stderr='ChildTimeout; submission may have happened'}
        }
        [pscustomobject]@{timed_out=$false;exit_code=$p.ExitCode;stdout=$out.GetAwaiter().GetResult();stderr=$err.GetAwaiter().GetResult()}
    } finally { $p.Dispose() }
}
