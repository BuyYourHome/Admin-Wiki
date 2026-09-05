# Read-only prerequisite for the authorized WVE canary; never claims or submits.
function Get-CpDisposition($Before,$Queue,$After,[string]$TaskId,[string]$ExpectedCwd) {
    $result=[ordered]@{disposition='Unknown';defer=$true;reason='IncompleteSnapshot';task_id=$TaskId;pending_count=$null;status_before=$null;status_after=$null}
    if(!$Before -or !$Before.thread){return [pscustomobject]$result}
    $result.status_before=$Before.thread.status.type
    if($Before.thread.id -cne $TaskId -or $Before.thread.cwd -ine $ExpectedCwd){$result.reason='IdentityOrRepositoryMismatch';return [pscustomobject]$result}
    if($Before.thread.status.type -ceq 'active'){$result.disposition='Busy';$result.reason='ActiveTask';return [pscustomobject]$result}
    if($Before.thread.status.type -cne 'idle'){$result.reason='RuntimeNotKnownIdle';return [pscustomobject]$result}
    if(!$Queue -or !($Queue.data -is [array])){$result.reason='PendingStateUnknown';return [pscustomobject]$result}
    $result.pending_count=@($Queue.data).Count
    if($result.pending_count -gt 0 -or $Queue.nextCursor){$result.disposition='Pending';$result.reason='QueuedSubmissionExists';return [pscustomobject]$result}
    if(!$After -or !$After.thread){$result.reason='SecondReadMissing';return [pscustomobject]$result}
    $result.status_after=$After.thread.status.type
    if($After.thread.id -cne $TaskId -or $After.thread.cwd -ine $ExpectedCwd){$result.reason='SecondReadIdentityMismatch';return [pscustomobject]$result}
    if($After.thread.status.type -ceq 'active'){$result.disposition='Busy';$result.reason='BecameActive';return [pscustomobject]$result}
    if($After.thread.status.type -cne 'idle'){$result.reason='SecondReadNotIdle';return [pscustomobject]$result}
    $result.disposition='IdleObserved';$result.defer=$false;$result.reason='TwoIdleReadsAndEmptyPendingPage'
    [pscustomobject]$result
}
function Invoke-CpProtocol([scriptblock]$Exchange,[string]$TaskId) {
    # This allowlist is the entire wire protocol. Never resume, start, steer,
    # queue/add, queue/start, approve, interrupt, or subscribe to a task.
    $init=& $Exchange @{id=1;method='initialize';params=@{clientInfo=@{name='byh_readonly_canary_probe';version='0.1.0'};capabilities=@{experimentalApi=$true}}}
    if(!$init){throw 'MissingInitializeResult'}
    $null=& $Exchange @{method='initialized';params=@{}}
    $before=& $Exchange @{id=2;method='thread/read';params=@{threadId=$TaskId;includeTurns=$false}}
    if($before.thread.status.type -cne 'idle'){return @{before=$before;queue=$null;after=$null}}
    $queue=& $Exchange @{id=3;method='thread/queue/list';params=@{threadId=$TaskId;limit=1}}
    $after=& $Exchange @{id=4;method='thread/read';params=@{threadId=$TaskId;includeTurns=$false}}
    @{before=$before;queue=$queue;after=$after}
}
function Invoke-CpRuntime([string]$CliPath,[string]$TaskId,[string]$ExpectedCwd,[int]$TimeoutSeconds=10) {
    $watch=[Diagnostics.Stopwatch]::StartNew()
    $p=[Diagnostics.Process]::new();$psi=[Diagnostics.ProcessStartInfo]::new()
    $psi.FileName=$CliPath;$psi.Arguments='app-server proxy';$psi.UseShellExecute=$false;$psi.CreateNoWindow=$true
    $psi.RedirectStandardInput=$true;$psi.RedirectStandardOutput=$true;$psi.RedirectStandardError=$true
    $psi.StandardOutputEncoding=[Text.UTF8Encoding]::new($false);$psi.StandardErrorEncoding=[Text.UTF8Encoding]::new($false)
    $p.StartInfo=$psi;$errorRead=$null;$started=$false
    $wire=[Collections.Generic.List[string]]::new()
    $result=[ordered]@{schema_version=1;probe_release='0.1.0';observed_at_utc=[DateTime]::UtcNow.ToString('o');task_id=$TaskId;disposition='Unknown';defer=$true;reason='RuntimeUnavailable';error_type=$null;error=$null;proxy_stderr=$null;proxy_exit_code=$null;methods_sent=@();elapsed_ms=0;claims=0;submissions=0;model_requests=0;canary_gate_satisfied=$false}
    try {
        $started=$p.Start();if(!$started){throw 'ProxyProcessNotStarted'}
        $errorRead=$p.StandardError.ReadToEndAsync()
        $exchange={param($request)
            $wire.Add($request.method)
            $p.StandardInput.WriteLine(($request|ConvertTo-Json -Depth 8 -Compress));$p.StandardInput.Flush()
            if(!$request.ContainsKey('id')){return}
            while($true){
                $remaining=[int]($TimeoutSeconds*1000-$watch.ElapsedMilliseconds)
                if($remaining -le 0){throw 'ReadOnlyProbeTimeout'}
                $lineTask=$p.StandardOutput.ReadLineAsync()
                if(!$lineTask.Wait($remaining)){throw 'ReadOnlyProbeTimeout'}
                $line=$lineTask.GetAwaiter().GetResult()
                if($null -eq $line){throw 'ProxyClosedBeforeReadOnlyResponse'}
                if($line.Length -gt 262144){throw 'ReadOnlyResponseTooLarge'}
                try{$reply=$line|ConvertFrom-Json -ErrorAction Stop}catch{throw 'MalformedReadOnlyResponse'}
                # Do not answer any server-initiated approval/tool request.
                if($reply.method -and $null -ne $reply.id){throw 'UnexpectedServerRequest'}
                if($null -eq $reply.id){continue}
                if($reply.id -ne $request.id){throw 'ResponseIdMismatch'}
                if($reply.error){throw ('ReadOnlyRpcError: '+($reply.error|ConvertTo-Json -Depth 5 -Compress))}
                if($null -eq $reply.result){throw 'ReadOnlyResultMissing'}
                return $reply.result
            }
        }.GetNewClosure()
        $snapshot=Invoke-CpProtocol $exchange $TaskId
        $decision=Get-CpDisposition $snapshot.before $snapshot.queue $snapshot.after $TaskId $ExpectedCwd
        foreach($property in $decision.PSObject.Properties){$result[$property.Name]=$property.Value}
        # Even IdleObserved is only a snapshot, not atomic authorization to submit.
        # Real busy/pending behavior and worker integration need separate proof.
    }catch{
        $result.error_type=$_.Exception.GetType().FullName;$result.error=$_.Exception.Message
    }finally{
        if($started){
            try{$p.StandardInput.Close()}catch{}
            if(!$p.WaitForExit(1000)){try{$p.Kill();$p.WaitForExit(1000)|Out-Null}catch{}}
            if($p.HasExited){$result.proxy_exit_code=$p.ExitCode}
            if($errorRead -and $errorRead.IsCompleted){$result.proxy_stderr=$errorRead.GetAwaiter().GetResult()}
        }
        $p.Dispose();$result.methods_sent=@($wire.ToArray());$result.elapsed_ms=$watch.ElapsedMilliseconds
    }
    [pscustomobject]$result
}
