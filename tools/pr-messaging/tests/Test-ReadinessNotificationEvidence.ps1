$ErrorActionPreference='Stop'
$validator=Join-Path $PSScriptRoot '..\Test-ProjectRoomMessagingReadiness.ps1'
$manager=Join-Path $PSScriptRoot 'ReadinessFixtureManager.ps1'
$root=Join-Path $env:TEMP ('byh-readiness-'+[guid]::NewGuid().ToString('N'))
$task='01a14585-ffe6-7850-8db1-efcdd58e7071'
$room='Smart House'
$id='synthetic-readiness-001'
$completed='2026-10-17T01:49:56.633467Z'
$passed=0

function Save-Json([string]$Path,$Value){
    [IO.File]::WriteAllText($Path,($Value|ConvertTo-Json -Depth 20),[Text.UTF8Encoding]::new($false))
}
function Run-Case([string]$Name,[bool]$ExpectedReady,$Record,$Manifest){
    Save-Json (Join-Path $root 'record.json') $Record
    Save-Json (Join-Path $root 'manifest.json') $Manifest
    $output=& powershell.exe -NoProfile -ExecutionPolicy Bypass -File $validator `
        -ProjectRoom $room -TaskId $task -ReadmePath (Join-Path $root 'README.md') `
        -ManifestPath (Join-Path $root 'manifest.json') -RegistryPath (Join-Path $root 'registry.md') `
        -RoutingMapPath (Join-Path $root 'routing.md') -ClientConfigPath (Join-Path $root 'client.json') `
        -QueuePath $root -ManageToolPath $manager
    $exit=$LASTEXITCODE
    $result=$output|Out-String|ConvertFrom-Json
    if([bool]$result.ready -ne $ExpectedReady -or (($exit -eq 0) -ne $ExpectedReady)){
        throw "$Name returned ready=$($result.ready), exit=$exit"
    }
    if(!$ExpectedReady -and @($result.checks|Where-Object {$_.name -eq 'synthetic_lifecycle' -and !$_.passed}).Count -ne 1){
        throw "$Name did not fail the synthetic lifecycle check"
    }
    $script:passed++
}

try{
    [void][IO.Directory]::CreateDirectory($root)
    [IO.File]::WriteAllText((Join-Path $root 'README.md'),"Smart House $task")
    [IO.File]::WriteAllText((Join-Path $root 'registry.md'),"## Smart House`nTask $task`n")
    [IO.File]::WriteAllText((Join-Path $root 'routing.md'),"| Smart House | Owner | ``$task`` |`n")
    Save-Json (Join-Path $root 'client.json') ([ordered]@{machine=$env:COMPUTERNAME;registrations=@(@{project_room=$room;task_id=$task})})
    $manifest=[ordered]@{project_room=$room;task_id=$task;execution_machine=$env:COMPUTERNAME;dispatchable=$true;
        messaging_readiness=@{status='ready';machine_registration_verified_at_utc='verified';host_access_verified_at_utc='verified';
            lifecycle_completed_at_utc=$completed;notification_count=1;validation_message_id=$id}}
    $record=[ordered]@{payload=@{synthetic_test=$true};destination=@{project_room=$room;task_id=$task};state='Completed';
        receipt=@{project_room=$room;task_id=$task};attempt_count=1;attempts=@(@{outcome='Delivered'});
        result=@{completed_at_utc=$completed;data=@{}};events=@(@{event='Accepted'},@{event='ProcessingStarted'},@{event='FinalResult'})}

    Run-Case 'missing redundant count' $true $record $manifest
    $manifest.messaging_readiness.lifecycle_completed_at_utc='2026-10-17T01:49:56.6334670Z'
    Run-Case 'same UTC instant with different precision' $true $record $manifest
    $manifest.messaging_readiness.lifecycle_completed_at_utc='2026-10-17T01:49:57.633467Z'
    Run-Case 'different UTC instant' $false $record $manifest
    $manifest.messaging_readiness.lifecycle_completed_at_utc=$completed
    $record.result.data.notification_count=1
    Run-Case 'matching explicit count' $true $record $manifest
    $record.result.data.notification_count=2
    Run-Case 'contradictory explicit count' $false $record $manifest
    $record.result.data.Remove('notification_count')
    $record.attempts[0].outcome='NotDelivered'
    Run-Case 'undelivered attempt' $false $record $manifest
    $record.attempts[0].outcome='Delivered'
    $record.attempt_count=2
    Run-Case 'extra attempt' $false $record $manifest
    $record.attempt_count=1
    $manifest.messaging_readiness.notification_count=2
    Run-Case 'manifest count mismatch' $false $record $manifest
    "Passed $passed readiness notification evidence cases"
}
finally{
    $full=[IO.Path]::GetFullPath($root)
    $temp=[IO.Path]::GetFullPath($env:TEMP).TrimEnd('\')+'\'
    if($full.StartsWith($temp,[StringComparison]::OrdinalIgnoreCase) -and [IO.Directory]::Exists($full)){
        [IO.Directory]::Delete($full,$true)
    }
}
