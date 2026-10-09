[CmdletBinding()]
param([string]$EvidenceDirectory)
$ErrorActionPreference='Stop'
. "$PSScriptRoot\Test-LowTokenWorker.ps1" -LibraryOnly

function EnrollmentFixture {
    $f=Fixture
    $machine=$env:COMPUTERNAME;$room='Codex Environment';$dispatcher=$f.source;$task=$f.task
    $client=[pscustomobject]@{machine=$machine;registrations=@([pscustomobject]@{project_room=$room;task_id=$task})}
    $manifest=[pscustomobject]@{
        schema_version=2;project_room=$room;skill='codex-environment';task_id=$task;dispatchable=$false;execution_machine=$machine
        accepted_message_types=@('status');messaging_readiness=[pscustomobject]@{status='validation_ready';validation_message_id=$f.id;dispatcher_task_id=$dispatcher;dispatcher_automation_id='pr-messaging-dispatcher';cross_machine_source='REMOTE-SOURCE';manual_intervention=$null}
    }
    $record=Record $f;$record.destination.project_room=$room;$record.destination.machine=$machine;$record.source.machine='REMOTE-SOURCE';$record.payload_hash=Get-LtPayloadHash $record
    $config=Read-LtJson $f.config;$config.expected_machine=$machine;$config.dispatcher_task_id=$dispatcher
    $config|Add-Member destinations @([pscustomobject]@{project_room='Existing Room';task_id='33333333-3333-4333-8333-333333333333';machine=$machine}) -Force
    [pscustomobject]@{f=$f;machine=$machine;room=$room;dispatcher=$dispatcher;task=$task;client=$client;manifest=$manifest;record=$record;config=$config;hash=$record.payload_hash}
}
function Enroll($x){New-LtValidationEnrollmentConfig $x.config $x.client @($x.manifest) $x.record $x.machine $x.dispatcher $x.room $x.task $x.f.id $x.hash}

Check 'validation destination enrollment is additive and preserves config identity' {
    $x=EnrollmentFixture;$answer=Enroll $x
    Assert (!$answer.already_enrolled -and @($answer.config.destinations).Count -eq 2)
    Assert (@($answer.config.destinations|Where-Object project_room -eq 'Existing Room').Count -eq 1)
    Assert (@($answer.config.destinations|Where-Object {$_.project_room -ceq $x.room -and $_.task_id -ceq $x.task -and $_.machine -ceq $x.machine}).Count -eq 1)
    Assert ($answer.config.owner -ceq $x.config.owner -and $answer.config.generation -ceq $x.config.generation -and $answer.config.state_directory -ceq $x.config.state_directory)
}
Check 'validation destination enrollment is idempotent without duplicate pin' {$x=EnrollmentFixture;$first=Enroll $x;$x.config=$first.config;$second=Enroll $x;Assert ($second.already_enrolled -and @($second.config.destinations).Count -eq 2)}
foreach($fault in @('record-hash','record-machine','record-task','record-attempt','business','manifest-status','manifest-message','manifest-dispatcher','manifest-automation','manifest-manual','registration-duplicate','destination-conflict')){
    Check ('validation destination enrollment rejects '+$fault) {
        $x=EnrollmentFixture
        switch($fault){
            'record-hash'{$x.hash='a'*64}
            'record-machine'{$x.record.destination.machine='OTHER';$x.record.payload_hash=Get-LtPayloadHash $x.record;$x.hash=$x.record.payload_hash}
            'record-task'{$x.record.destination.task_id='44444444-4444-4444-8444-444444444444';$x.record.payload_hash=Get-LtPayloadHash $x.record;$x.hash=$x.record.payload_hash}
            'record-attempt'{$x.record.attempt_count=1;$x.record.attempts=@([pscustomobject]@{attempt_id='attempt-one';outcome='NotDelivered'});$x.record.payload_hash=Get-LtPayloadHash $x.record;$x.hash=$x.record.payload_hash}
            'business'{$x.record.payload.business_action_authorized=$true;$x.record.payload_hash=Get-LtPayloadHash $x.record;$x.hash=$x.record.payload_hash}
            'manifest-status'{$x.manifest.messaging_readiness.status='ready'}
            'manifest-message'{$x.manifest.messaging_readiness.validation_message_id='other-message'}
            'manifest-dispatcher'{$x.manifest.messaging_readiness.dispatcher_task_id='44444444-4444-4444-8444-444444444444'}
            'manifest-automation'{$x.manifest.messaging_readiness.dispatcher_automation_id='other-automation'}
            'manifest-manual'{$x.manifest.messaging_readiness.manual_intervention=$false}
            'registration-duplicate'{$x.client.registrations=@($x.client.registrations)+@($x.client.registrations[0])}
            'destination-conflict'{$x.config.destinations+=@([pscustomobject]@{project_room=$x.room;task_id='44444444-4444-4444-8444-444444444444';machine=$x.machine})}
        }
        $rejected=$false;try{Enroll $x|Out-Null}catch{$rejected=$true};Assert $rejected
    }
}
Check 'installer enrollment is scoped and preserves runtime structures' {
    $text=Get-Content -Raw -LiteralPath (Join-Path $release 'Install-LowTokenWorker.ps1');$start=$text.IndexOf("if(`$Action -eq 'EnrollValidationDestination')");$end=$text.IndexOf("if(`$Action -eq 'UpgradeLive')",$start)
    Assert ($start -ge 0 -and $end -gt $start);$block=$text.Substring($start,$end-$start)
    Assert ($block.Contains("`$ExpectedMachine -cne 'WESSTUDIO'") -and $block.Contains("`$DestinationProjectRoom -cne 'Codex Environment'") -and $block.Contains('019f84d0-78d4-7013-8c07-42c01f961be1'))
    foreach($required in @('ExpectedManifestSha256','ExpectedValidationPayloadHash','ExpectedConfigSha256','ExpectedOwnerGeneration','journalHash','ownerHash','Get-LtReviewedCli','Disable-ScheduledTask','Enable-ScheduledTask')){Assert $block.Contains($required) ('Missing guard '+$required)}
    Assert (!$block.Contains('Set-ScheduledTask') -and !$block.Contains('Write-LtJson $ownerPath') -and !$block.Contains('Write-LtJson $journalPath'))
}
$summary=@{passed=@($results|Where-Object passed).Count;failed=@($results|Where-Object {!$_.passed}).Count;tests=$results;production_actions=0;real_cli_submissions=0}
if($EvidenceDirectory){New-Item -ItemType Directory -Path $EvidenceDirectory -Force|Out-Null;Write-LtJson (Join-Path $EvidenceDirectory 'destination-enrollment-tests.json') $summary}
$summary|ConvertTo-Json -Depth 8
if($summary.failed){exit 1}
