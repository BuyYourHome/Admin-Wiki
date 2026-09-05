param([string]$FixtureRoot,[string]$MessageId,[string]$ThreadId,[string]$AttemptId)
$ErrorActionPreference='Stop'
if(!(Test-Path -LiteralPath (Join-Path $FixtureRoot '.lowtoken-fixture'))){throw 'NotFixture'}
$path=Join-Path $FixtureRoot 'submissions.json'
$items=if(Test-Path -LiteralPath $path){@(Get-Content -LiteralPath $path -Raw|ConvertFrom-Json)}else{@()}
$items+=@{message_id=$MessageId;thread_id=$ThreadId;attempt_id=$AttemptId}
ConvertTo-Json -InputObject @($items) -Depth 5|Set-Content -LiteralPath $path -Encoding UTF8
$control=Get-Content -LiteralPath (Join-Path $FixtureRoot 'adapter-control.json') -Raw|ConvertFrom-Json
if($control.behavior -eq 'timeout'){Start-Sleep -Seconds 20}
if($control.behavior -eq 'error'){[Console]::Error.WriteLine('Injected adapter failure');exit 7}
'{"submitted":true,"fixture":true}'
