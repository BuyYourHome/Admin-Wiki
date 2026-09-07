param([string]$FixtureRoot,[string]$MessageId,[string]$ThreadId,[string]$AttemptId)
$ErrorActionPreference='Stop'
if(!(Test-Path -LiteralPath (Join-Path $FixtureRoot '.lowtoken-fixture'))){throw 'NotFixture'}
# Each invocation gets a unique CreateNew file; racing writes cannot hide a duplicate.
$path=Join-Path $FixtureRoot ('submission-'+[guid]::NewGuid().ToString('N')+'.json')
$bytes=[Text.UTF8Encoding]::new($false).GetBytes((@{message_id=$MessageId;thread_id=$ThreadId;attempt_id=$AttemptId;pid=$PID;at_utc=[DateTime]::UtcNow.ToString('o')}|ConvertTo-Json -Compress))
$stream=[IO.File]::Open($path,[IO.FileMode]::CreateNew,[IO.FileAccess]::Write,[IO.FileShare]::None)
try{$stream.Write($bytes,0,$bytes.Length);$stream.Flush($true)}finally{$stream.Dispose()}
$control=Get-Content -LiteralPath (Join-Path $FixtureRoot 'adapter-control.json') -Raw|ConvertFrom-Json
if($control.behavior -eq 'timeout'){Start-Sleep -Seconds 20}
if($control.behavior -eq 'error'){[Console]::Error.WriteLine('Injected adapter failure');exit 7}
if($control.behavior -eq 'malformed'){'not-json';exit 0}
if($control.behavior -eq 'delay'){Start-Sleep -Seconds 3}
$reply=@{submitted=$true;accepted=$false;fixture=$true;message_id=$MessageId;thread_id=$ThreadId;attempt_id=$AttemptId;queue_message_id=[guid]::NewGuid().ToString()}
if($control.behavior -eq 'wrong-target'){$reply.thread_id='99999999-9999-4999-8999-999999999999'}
$reply | ConvertTo-Json -Compress
