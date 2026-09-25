# Dot-sourced by the isolated manager copy; uses that manager's existing queue lock and writers.
function Assert-LtOwner {
    if($Mode -ceq 'Canary'){
        Assert-LtCanaryIdentity
        if($QueuePath -cne '\\WES-VIDEOEDITOR\BYH-PRMessaging$' -or $MessageId -cne (Get-LtCanaryId) -or $TransportOwner -cne $MessageId -or $Generation -cne 'one-shot-1' -or $ActorTaskId -cne '01a05d0c-8031-7d92-9474-ab2330008ddb' -or $ActorProjectRoom -cne 'PR Messaging Dispatcher'){throw 'CanaryClaimOwnerMismatch'}
        if($ClientConfigPath -cne (Join-Path $env:LOCALAPPDATA 'BuyYourHome\PRMessaging\client.json') -or $ManifestDirectory -cne 'C:\Codex\Wiki Files\config\pr-messaging-manifests'){throw 'CanaryClaimConfigurationMismatch'}
        return
    }
    $ownerPath = if($Mode -ceq 'Validation' -and (Test-Path -LiteralPath (Join-Path $QueuePath '.transport-owner.json'))){
        Join-Path $QueuePath '.transport-owner.json'
    } else {
        Get-LtTransportOwnerPath $QueuePath $env:COMPUTERNAME
    }
    $o = Read-LtJson $ownerPath
    if ($o.owner -cne $TransportOwner -or $o.generation -cne $Generation -or $o.machine -cne $env:COMPUTERNAME -or $o.sid -cne [Security.Principal.WindowsIdentity]::GetCurrent().User.Value) { throw 'TransportOwnershipMismatch' }
    if($o.task_id -cne $ActorTaskId){throw 'TransportActorMismatch'}
    if($Mode -ceq 'Validation'){
        if ($o.mode -cne 'Validation' -or $o.validation_message_id -cne $MessageId) { throw 'ExclusiveValidationOwnershipRequired' }
    } elseif($Mode -ceq 'Live') {
        if($o.mode -cne 'Live'){throw 'ExclusiveLiveOwnershipRequired'}
    } else { throw 'UnsupportedTransportMode' }
}
function Invoke-LtAdministrativeRetireObsoleteRollback($Record,[string]$RecordPath) {
    if($env:COMPUTERNAME -cne 'OFFICEASSIST' -or $ActorProjectRoom -cne 'PR Messaging Dispatcher' -or
        $ActorTaskId -cne '01a09d84-a309-7591-a790-e770fcb53dee' -or
        $TransportOwner -cne 'low-token-officeassist' -or $Generation -cne '0.4.0' -or $Mode -cne 'Live' -or
        $AuthorizationReference -cne 'Wes explicitly cancelled and authorized administrative retirement in Jean Wright on September 25, 2026.' -or
        [string]::IsNullOrWhiteSpace($Detail)){throw 'RollbackRetirementAuthorityMismatch'}
    if(!(Test-PrObsoleteRollbackRecord $Record)){throw 'ExactObsoleteRollbackRecordRequired'}
    if($ExpectedHash -cne $Record.payload_hash){throw 'RollbackRetirementHashMismatch'}
    if($ExpectedRecordVersion -cnotmatch '^[0-9a-f]{64}$' -or
        (Get-PrMessageDigest ($Record|ConvertTo-Json -Depth 30 -Compress)) -cne $ExpectedRecordVersion){throw 'RollbackRetirementVersionConflict'}
    Assert-LtOwner
    if($Record.administrative_closure){throw 'AdministrativeClosureConflict'}
    $closure=[pscustomobject][ordered]@{
        schema_version=1;message_id=$Record.message_id;payload_hash=$Record.payload_hash
        disposition='ObsoleteRollbackRetired';authorized_by='Wes';authorization_reference=$AuthorizationReference
        actor_project_room=$ActorProjectRoom;actor_task_id=$ActorTaskId;actor_machine=$env:COMPUTERNAME
        transport_owner=$TransportOwner;transport_generation=$Generation;transport_owner_task_id=$ActorTaskId
        closed_at_utc=Get-UtcTimestamp;original_state=$Record.state;record_version_before=$ExpectedRecordVersion
        delivery_status='Unresolved';delivery_claimed=$false;business_completion_claimed=$false
        detail='Rollback request retired at Wes''s direction; not delivered or completed. Original state, payload, and all attempts preserved. '+$Detail
    }
    $Record|Add-Member administrative_closure $closure
    if(!(Test-PrAdministrativeClosure $Record)){throw 'RollbackRetirementEvidenceInvalid'}
    Add-Event $Record 'AdministrativelyRetired' $closure.detail $ActorProjectRoom $ActorTaskId
    Write-JsonAtomic $RecordPath $Record
    return $Record
}
function Invoke-LtAdministrativeCloseExhaustedAmbiguous($Record,[string]$RecordPath) {
    if($ActorProjectRoom -cne 'PR Messaging Dispatcher' -or
        [string]::IsNullOrWhiteSpace($ActorTaskId) -or
        [string]::IsNullOrWhiteSpace($AuthorizationReference) -or
        [string]::IsNullOrWhiteSpace($Detail)){throw 'AdministrativeClosureAuthorityMissing'}
    if(Test-PrAdministrativeClosure $Record){
        if($Record.administrative_closure.disposition -cne 'ExhaustedAmbiguousUndelivered' -or
            $Record.administrative_closure.actor_task_id -cne $ActorTaskId){throw 'AdministrativeClosureConflict'}
        return $Record
    }
    if($Record.administrative_closure){throw 'AdministrativeClosureConflict'}
    if(!(Test-PrExhaustedAmbiguousRecord $Record 30)){throw 'ExhaustedAmbiguousRecordRequired'}
    if($ExpectedHash -cnotmatch '^[0-9a-f]{64}$' -or $ExpectedHash -cne $Record.payload_hash){throw 'AdministrativeClosureHashMismatch'}
    if($ExpectedRecordVersion -cnotmatch '^[0-9a-f]{64}$' -or
        (Get-PrMessageDigest ($Record|ConvertTo-Json -Depth 30 -Compress)) -cne $ExpectedRecordVersion){throw 'AdministrativeClosureVersionConflict'}
    $ownerPath=Get-LtTransportOwnerPath $QueuePath ([string]$Record.destination.machine)
    if(!(Test-Path -LiteralPath $ownerPath)){throw 'AdministrativeClosureLiveOwnerRequired'}
    $owner=Read-LtJson $ownerPath
    if($owner.mode -cne 'Live' -or $owner.machine -cne $Record.destination.machine -or
        $owner.task_id -cne $ActorTaskId -or $owner.owner -cne $TransportOwner -or
        $owner.generation -cne $Generation -or $owner.sid -cne [Security.Principal.WindowsIdentity]::GetCurrent().User.Value -or
        $env:COMPUTERNAME -cne $Record.destination.machine){throw 'AdministrativeClosureOwnerMismatch'}
    $closure=[pscustomobject][ordered]@{
        schema_version=1;message_id=$Record.message_id;payload_hash=$Record.payload_hash
        disposition='ExhaustedAmbiguousUndelivered';authorized_by='Wes'
        authorization_reference=$AuthorizationReference;actor_project_room=$ActorProjectRoom
        actor_task_id=$ActorTaskId;actor_machine=$env:COMPUTERNAME
        transport_owner=$owner.owner;transport_generation=$owner.generation;transport_owner_task_id=$owner.task_id
        closed_at_utc=Get-UtcTimestamp;delivery_claimed=$false;business_completion_claimed=$false;detail=$Detail
    }
    $Record|Add-Member administrative_closure $closure
    Add-Event $Record 'AdministrativelyClosed' $Detail $ActorProjectRoom $ActorTaskId
    Write-JsonAtomic $RecordPath $Record
    return $Record
}
function Invoke-LtAdministrativeCancelAuthorizedStatus($Record,[string]$RecordPath) {
    if($ActorProjectRoom -cne 'PR Messaging Dispatcher' -or
        [string]::IsNullOrWhiteSpace($ActorTaskId) -or
        [string]::IsNullOrWhiteSpace($AuthorizationReference) -or
        [string]::IsNullOrWhiteSpace($Detail)){throw 'StatusCancellationAuthorityMissing'}
    if(Test-PrAdministrativeClosure $Record){
        if($Record.administrative_closure.disposition -cne 'AuthorizedStatusCancelled' -or
            $Record.administrative_closure.actor_task_id -cne $ActorTaskId){throw 'AdministrativeClosureConflict'}
        return $Record
    }
    if($Record.administrative_closure){throw 'AdministrativeClosureConflict'}
    if(!(Test-PrAuthorizedStatusCancellationRecord $Record 30)){throw 'CancellableStatusRecordRequired'}
    if($ExpectedHash -cnotmatch '^[0-9a-f]{64}$' -or $ExpectedHash -cne $Record.payload_hash){throw 'StatusCancellationHashMismatch'}
    if($ExpectedRecordVersion -cnotmatch '^[0-9a-f]{64}$' -or
        (Get-PrMessageDigest ($Record|ConvertTo-Json -Depth 30 -Compress)) -cne $ExpectedRecordVersion){throw 'StatusCancellationVersionConflict'}
    $ownerPath=Get-LtTransportOwnerPath $QueuePath ([string]$Record.destination.machine)
    if(!(Test-Path -LiteralPath $ownerPath)){throw 'StatusCancellationLiveOwnerRequired'}
    $owner=Read-LtJson $ownerPath
    if($owner.mode -cne 'Live' -or $owner.machine -cne $Record.destination.machine -or
        $owner.task_id -cne $ActorTaskId -or $owner.owner -cne $TransportOwner -or
        $owner.generation -cne $Generation -or $owner.sid -cne [Security.Principal.WindowsIdentity]::GetCurrent().User.Value -or
        $env:COMPUTERNAME -cne $Record.destination.machine){throw 'StatusCancellationOwnerMismatch'}
    if(@($Record.attempts|Where-Object {$_.transport_owner -cne $owner.owner -or $_.transport_generation -cne $owner.generation}).Count){
        throw 'StatusCancellationAttemptOwnerMismatch'
    }
    $closure=[pscustomobject][ordered]@{
        schema_version=1;message_id=$Record.message_id;payload_hash=$Record.payload_hash
        disposition='AuthorizedStatusCancelled';authorized_by='Wes';authorization_reference=$AuthorizationReference
        actor_project_room=$ActorProjectRoom;actor_task_id=$ActorTaskId;actor_machine=$env:COMPUTERNAME
        transport_owner=$owner.owner;transport_generation=$owner.generation;transport_owner_task_id=$owner.task_id
        closed_at_utc=Get-UtcTimestamp;delivery_status='Unresolved';delivery_claimed=$false
        business_completion_claimed=$false;detail=$Detail
    }
    $Record|Add-Member administrative_closure $closure
    Add-Event $Record 'AdministrativelyClosed' $Detail $ActorProjectRoom $ActorTaskId
    Write-JsonAtomic $RecordPath $Record
    return $Record
}
function Invoke-LtAdministrativeCancelAcknowledgedStatus($Record,[string]$RecordPath) {
    if($ActorProjectRoom -cne 'PR Messaging Dispatcher' -or
        [string]::IsNullOrWhiteSpace($ActorTaskId) -or [string]::IsNullOrWhiteSpace($AttemptId) -or
        [string]::IsNullOrWhiteSpace($AuthorizationReference) -or
        [string]::IsNullOrWhiteSpace($Detail)){throw 'AcknowledgedStatusCancellationAuthorityMissing'}
    if(Test-PrAdministrativeClosure $Record){
        if($Record.administrative_closure.disposition -cne 'AcknowledgedStatusCancelled' -or
            $Record.administrative_closure.actor_task_id -cne $ActorTaskId -or
            $Record.administrative_closure.attempt_id -cne $AttemptId){throw 'AdministrativeClosureConflict'}
        return $Record
    }
    if($Record.administrative_closure){throw 'AdministrativeClosureConflict'}
    if(!(Test-PrAcknowledgedStatusCancellationRecord $Record $AttemptId 30)){throw 'CancellableAcknowledgedStatusRecordRequired'}
    if($ExpectedHash -cnotmatch '^[0-9a-f]{64}$' -or $ExpectedHash -cne $Record.payload_hash){throw 'AcknowledgedStatusCancellationHashMismatch'}
    if($ExpectedRecordVersion -cnotmatch '^[0-9a-f]{64}$' -or
        (Get-PrMessageDigest ($Record|ConvertTo-Json -Depth 30 -Compress)) -cne $ExpectedRecordVersion){throw 'AcknowledgedStatusCancellationVersionConflict'}
    $ownerPath=Get-LtTransportOwnerPath $QueuePath ([string]$Record.destination.machine)
    if(!(Test-Path -LiteralPath $ownerPath)){throw 'AcknowledgedStatusCancellationLiveOwnerRequired'}
    $owner=Read-LtJson $ownerPath
    if($Mode -cne 'Live' -or $owner.mode -cne 'Live' -or $owner.machine -cne $Record.destination.machine -or
        $owner.task_id -cne $ActorTaskId -or $owner.owner -cne $TransportOwner -or
        $owner.generation -cne $Generation -or $owner.sid -cne [Security.Principal.WindowsIdentity]::GetCurrent().User.Value -or
        $env:COMPUTERNAME -cne $Record.destination.machine){throw 'AcknowledgedStatusCancellationOwnerMismatch'}
    $attempt=@($Record.attempts|Where-Object attempt_id -CEQ $AttemptId)[0]
    if($attempt.transport_owner -cne $owner.owner -or $attempt.transport_generation -cne $owner.generation){throw 'AcknowledgedStatusCancellationAttemptOwnerMismatch'}
    if([string]::IsNullOrWhiteSpace($WorkerConfigPath) -or !(Test-Path -LiteralPath $WorkerConfigPath)){throw 'AcknowledgedStatusCancellationConfigMissing'}
    if($FixtureRoot){Assert-LtUnder $WorkerConfigPath $FixtureRoot}else{
        $expectedConfig=Join-Path $env:LOCALAPPDATA 'BuyYourHome\PRMessaging\low-token\releases\0.4.6\low-token\config.json'
        if([IO.Path]::GetFullPath($WorkerConfigPath) -cne [IO.Path]::GetFullPath($expectedConfig)){throw 'AcknowledgedStatusCancellationConfigPathMismatch'}
    }
    $cfg=Read-LtJson $WorkerConfigPath
    if($cfg.release -cne '0.4.6' -or $cfg.expected_machine -cne $env:COMPUTERNAME -or
        $cfg.expected_sid -cne $owner.sid -or $cfg.dispatcher_task_id -cne $ActorTaskId -or
        $cfg.owner -cne $owner.owner -or $cfg.generation -cne $owner.generation -or
        !(Test-LtPinnedDestination $cfg $Record.destination)){throw 'AcknowledgedStatusCancellationConfigMismatch'}
    if($FixtureRoot){Assert-LtUnder $cfg.state_directory $FixtureRoot;Assert-LtUnder $cfg.adapter_path $FixtureRoot;Assert-LtUnder $cfg.cli_path $FixtureRoot}else{
        Assert-LtUnder $cfg.state_directory (Join-Path $env:LOCALAPPDATA 'BuyYourHome\PRMessaging\low-token')
    }
    if(!(Test-Path -LiteralPath $cfg.adapter_path) -or (Get-FileHash -LiteralPath $cfg.adapter_path -Algorithm SHA256).Hash -ine $cfg.adapter_sha256 -or
        !(Test-Path -LiteralPath $cfg.cli_path) -or (Get-FileHash -LiteralPath $cfg.cli_path -Algorithm SHA256).Hash -ine $cfg.cli_sha256){throw 'AcknowledgedStatusCancellationPinnedBinaryMismatch'}
    $journalPath=Join-Path $cfg.state_directory 'journal.json'
    if(!(Test-Path -LiteralPath $journalPath)){throw 'AcknowledgedStatusCancellationJournalMissing'}
    $journal=Read-LtJson $journalPath
    if($journal.schema_version -ne 2 -or $journal.machine -cne $env:COMPUTERNAME -or
        $journal.sid -cne $owner.sid -or $journal.owner -cne $owner.owner -or
        $journal.generation -cne $owner.generation){throw 'AcknowledgedStatusCancellationJournalIdentityMismatch'}
    $entries=@($journal.entries|Where-Object attempt_id -CEQ $AttemptId)
    if($entries.Count -ne 1){throw 'AcknowledgedStatusCancellationJournalAttemptMismatch'}
    $entry=$entries[0];$evidence=$entry.submission_evidence
    if($entry.message_id -cne $Record.message_id -or $entry.payload_hash -cne $Record.payload_hash -or
        $entry.destination_task_id -cne $Record.destination.task_id -or $entry.phase -cne 'submitted' -or
        $entry.outcome -cne 'QueuedAwaitingReceipt' -or $entry.adapter_release -cne '0.4.6' -or
        $entry.adapter_sha256 -ine $cfg.adapter_sha256 -or !$evidence -or $evidence.timed_out -ne $false -or
        [int]$evidence.exit_code -ne 0 -or $evidence.accepted -ne $false -or
        $evidence.queue_acknowledged -ne $true -or $evidence.submission_marker_present -ne $true -or
        [string]::IsNullOrWhiteSpace([string]$evidence.queue_message_id)){throw 'AcknowledgedStatusCancellationSubmissionEvidenceMismatch'}
    $markerPath=Get-LtSubmissionMarkerPath $cfg.state_directory $Record.message_id $AttemptId
    if(!(Test-Path -LiteralPath $markerPath)){throw 'AcknowledgedStatusCancellationMarkerMissing'}
    $marker=Read-LtJson $markerPath
    $expectedNotice="PR Messaging transport wake-up only, not a new Wes instruction. MessageId $($Record.message_id); payload_hash $($Record.payload_hash). Retrieve and verify the authoritative record using C:\Codex\Wiki Files\tools\pr-messaging\Manage-ProjectRoomMessage.ps1 before accepting. Follow only its authorized scope. Notification is not delivery proof."
    $args=@($marker.arguments)
    if($marker.message_id -cne $Record.message_id -or $marker.attempt_id -cne $AttemptId -or
        $marker.executable -cne $cfg.cli_path -or $args.Count -ne 5 -or $args[0] -cne 'queue' -or
        $args[1] -cne '--thread' -or $args[2] -cne $Record.destination.task_id -or
        $args[3] -cne '--message' -or $args[4] -cne $expectedNotice){throw 'AcknowledgedStatusCancellationMarkerMismatch'}
    $lastPath=Join-Path $cfg.state_directory 'last-cli-result.json'
    if(!(Test-Path -LiteralPath $lastPath)){throw 'AcknowledgedStatusCancellationAdapterResultMissing'}
    $last=Read-LtJson $lastPath
    $expectedStdout="Queued message $($evidence.queue_message_id) for thread $($Record.destination.task_id)."
    if($last.message_id -cne $Record.message_id -or $last.thread_id -cne $Record.destination.task_id -or
        $last.attempt_id -cne $AttemptId -or $last.queue_message_id -cne $evidence.queue_message_id -or
        $last.submitted -ne $true -or $last.accepted -ne $false -or $last.timed_out -ne $false -or
        [int]$last.exit_code -ne 0 -or $last.reason -cne 'QueuedAwaitingReceipt' -or
        ([string]$last.stdout).Trim() -cne $expectedStdout -or
        ![string]::IsNullOrEmpty([string]$last.stderr)){throw 'AcknowledgedStatusCancellationAdapterResultMismatch'}
    $evidenceSnapshot=[ordered]@{journal_entry=$entry;marker=$marker;adapter_result=$last;config_release=$cfg.release;cli_sha256=$cfg.cli_sha256}
    $evidenceSha=Get-PrMessageDigest ($evidenceSnapshot|ConvertTo-Json -Depth 30 -Compress)
    $closure=[pscustomobject][ordered]@{
        schema_version=1;message_id=$Record.message_id;payload_hash=$Record.payload_hash
        disposition='AcknowledgedStatusCancelled';authorized_by='Wes';authorization_reference=$AuthorizationReference
        actor_project_room=$ActorProjectRoom;actor_task_id=$ActorTaskId;actor_machine=$env:COMPUTERNAME
        transport_owner=$owner.owner;transport_generation=$owner.generation;transport_owner_task_id=$owner.task_id
        attempt_id=$AttemptId;queue_message_id=$evidence.queue_message_id
        submission_status='QueueAcknowledgedAwaitingReceipt';evidence_sha256=$evidenceSha
        closed_at_utc=Get-UtcTimestamp;delivery_status='Unresolved';delivery_claimed=$false
        business_completion_claimed=$false;detail=$Detail
    }
    $Record|Add-Member administrative_closure $closure
    Add-Event $Record 'AdministrativelyClosed' $Detail $ActorProjectRoom $ActorTaskId
    Write-JsonAtomic $RecordPath $Record
    return $Record
}
function Invoke-LtAdministrativeQuarantineIntegrityFailure($Record,[string]$RecordPath) {
    if($ActorProjectRoom -cne 'PR Messaging Dispatcher' -or
        [string]::IsNullOrWhiteSpace($ActorTaskId) -or
        [string]::IsNullOrWhiteSpace($AuthorizationReference) -or
        [string]::IsNullOrWhiteSpace($Detail)){throw 'IntegrityQuarantineAuthorityMissing'}
    if(Test-PrAdministrativeClosure $Record){
        if($Record.administrative_closure.disposition -cne 'IntegrityFailureQuarantined' -or
            $Record.administrative_closure.actor_task_id -cne $ActorTaskId){throw 'AdministrativeClosureConflict'}
        return $Record
    }
    if($Record.administrative_closure){throw 'AdministrativeClosureConflict'}
    $hashes=Get-PrMessageHashEvidence $Record
    if($hashes.valid -or !(Test-PrMessageStructurallyTerminal $Record)){throw 'InvalidStructurallyTerminalRecordRequired'}
    if($ExpectedHash -cnotmatch '^[0-9a-f]{64}$' -or $ExpectedHash -cne $Record.payload_hash){throw 'IntegrityQuarantineHashMismatch'}
    if($ExpectedRecordVersion -cnotmatch '^[0-9a-f]{64}$' -or
        (Get-PrMessageDigest ($Record|ConvertTo-Json -Depth 30 -Compress)) -cne $ExpectedRecordVersion){throw 'IntegrityQuarantineVersionConflict'}
    $ownerPath=Get-LtTransportOwnerPath $QueuePath ([string]$Record.destination.machine)
    if(!(Test-Path -LiteralPath $ownerPath)){throw 'IntegrityQuarantineLiveOwnerRequired'}
    $owner=Read-LtJson $ownerPath
    if($owner.mode -cne 'Live' -or $owner.machine -cne $Record.destination.machine -or
        $owner.task_id -cne $ActorTaskId -or $owner.owner -cne $TransportOwner -or
        $owner.generation -cne $Generation -or $owner.sid -cne [Security.Principal.WindowsIdentity]::GetCurrent().User.Value -or
        $env:COMPUTERNAME -cne $Record.destination.machine){throw 'IntegrityQuarantineOwnerMismatch'}
    $closure=[pscustomobject][ordered]@{
        schema_version=1;message_id=$Record.message_id;payload_hash=$Record.payload_hash
        disposition='IntegrityFailureQuarantined';authorized_by='Wes'
        authorization_reference=$AuthorizationReference;actor_project_room=$ActorProjectRoom
        actor_task_id=$ActorTaskId;actor_machine=$env:COMPUTERNAME
        transport_owner=$owner.owner;transport_generation=$owner.generation;transport_owner_task_id=$owner.task_id
        observed_default_hash=$hashes.default_hash;observed_html_hash=$hashes.html_hash
        closed_at_utc=Get-UtcTimestamp;delivery_claimed=$false;business_completion_claimed=$false;detail=$Detail
    }
    $Record|Add-Member administrative_closure $closure
    Add-Event $Record 'AdministrativelyClosed' $Detail $ActorProjectRoom $ActorTaskId
    Write-JsonAtomic $RecordPath $Record
    return $Record
}
function Invoke-LtReconcileProvenPreSubmissionFailure($Record,[string]$RecordPath) {
    if($ActorProjectRoom -cne 'PR Messaging Dispatcher' -or
        [string]::IsNullOrWhiteSpace($ActorTaskId) -or
        [string]::IsNullOrWhiteSpace($AuthorizationReference) -or
        [string]::IsNullOrWhiteSpace($Detail)){throw 'PreSubmissionRepairAuthorityMissing'}
    if($ExpectedHash -cnotmatch '^[0-9a-f]{64}$' -or $ExpectedHash -cne $Record.payload_hash -or
        !(Get-PrMessageHashEvidence $Record).valid){throw 'PreSubmissionRepairHashMismatch'}
    if($ExpectedRecordVersion -cnotmatch '^[0-9a-f]{64}$' -or
        (Get-PrMessageDigest ($Record|ConvertTo-Json -Depth 30 -Compress)) -cne $ExpectedRecordVersion){throw 'PreSubmissionRepairVersionConflict'}
    if([string]::IsNullOrWhiteSpace($AttemptId)){throw 'PreSubmissionRepairAttemptRequired'}
    $attempts=@($Record.attempts|Where-Object attempt_id -CEQ $AttemptId)
    if($attempts.Count -ne 1){throw 'PreSubmissionRepairAttemptMismatch'}
    $attempt=$attempts[0]
    $alreadyRepaired=($Record.state -ceq 'Queued' -and $attempt.outcome -ceq 'NotDelivered' -and
        @($Record.events|Where-Object {$_.event -ceq 'DeliveryAmbiguityCorrected' -and $_.detail -match [regex]::Escape($AttemptId)}).Count -eq 1)
    if($alreadyRepaired){return $Record}
    if($Record.authoritative -ne $true -or $Record.state -cne 'Delivery Ambiguous' -or $Record.receipt -or $Record.result -or
        $attempt.outcome -cne 'DeliveryAmbiguous' -or [string]::IsNullOrWhiteSpace([string]$attempt.completed_at_utc)){
        throw 'PreSubmissionRepairAmbiguousAttemptRequired'
    }
    $ownerPath=Get-LtTransportOwnerPath $QueuePath ([string]$Record.destination.machine)
    if(!(Test-Path -LiteralPath $ownerPath)){throw 'PreSubmissionRepairLiveOwnerRequired'}
    $owner=Read-LtJson $ownerPath
    if($owner.mode -cne 'Live' -or $owner.machine -cne $Record.destination.machine -or
        $owner.task_id -cne $ActorTaskId -or $owner.owner -cne $TransportOwner -or
        $owner.generation -cne $Generation -or $owner.sid -cne [Security.Principal.WindowsIdentity]::GetCurrent().User.Value -or
        $env:COMPUTERNAME -cne $Record.destination.machine){throw 'PreSubmissionRepairOwnerMismatch'}
    if([string]::IsNullOrWhiteSpace($WorkerConfigPath) -or !(Test-Path -LiteralPath $WorkerConfigPath)){throw 'PreSubmissionRepairConfigMissing'}
    if($FixtureRoot){Assert-LtUnder $WorkerConfigPath $FixtureRoot}else{
        $expectedConfig=Join-Path $env:LOCALAPPDATA 'BuyYourHome\PRMessaging\low-token\releases\0.4.1\low-token\config.json'
        if([IO.Path]::GetFullPath($WorkerConfigPath) -cne [IO.Path]::GetFullPath($expectedConfig)){throw 'PreSubmissionRepairConfigPathMismatch'}
    }
    $cfg=Read-LtJson $WorkerConfigPath
    if($cfg.release -cne '0.4.1' -or $cfg.expected_machine -cne $env:COMPUTERNAME -or
        $cfg.expected_sid -cne $owner.sid -or $cfg.dispatcher_task_id -cne $ActorTaskId -or
        $cfg.owner -cne $owner.owner -or $cfg.generation -cne $owner.generation -or
        !(Test-LtPinnedDestination $cfg $Record.destination)){throw 'PreSubmissionRepairConfigMismatch'}
    if($FixtureRoot){Assert-LtUnder $cfg.state_directory $FixtureRoot}else{
        Assert-LtUnder $cfg.state_directory (Join-Path $env:LOCALAPPDATA 'BuyYourHome\PRMessaging\low-token')
    }
    $journalPath=Join-Path $cfg.state_directory 'journal.json'
    if(!(Test-Path -LiteralPath $journalPath)){throw 'PreSubmissionRepairJournalMissing'}
    $journal=Read-LtJson $journalPath
    if($journal.schema_version -ne 2 -or $journal.machine -cne $env:COMPUTERNAME -or
        $journal.sid -cne $owner.sid -or $journal.owner -cne $owner.owner -or
        $journal.generation -cne $owner.generation){throw 'PreSubmissionRepairJournalIdentityMismatch'}
    $entries=@($journal.entries|Where-Object attempt_id -CEQ $AttemptId)
    if($entries.Count -ne 1){throw 'PreSubmissionRepairJournalAttemptMismatch'}
    $entry=$entries[0]
    $evidence=$entry.submission_evidence
    if($entry.message_id -cne $Record.message_id -or $entry.payload_hash -cne $Record.payload_hash -or
        $entry.destination_task_id -cne $Record.destination.task_id -or $entry.phase -cne 'unresolved' -or
        $entry.outcome -cne 'DeliveryAmbiguous' -or $entry.adapter_release -cne '0.4.1' -or
        !$evidence -or $evidence.timed_out -ne $false -or [int]$evidence.exit_code -eq 0 -or
        $evidence.queue_acknowledged -eq $true){throw 'PreSubmissionRepairEvidenceMismatch'}
    $markerPath=Get-LtSubmissionMarkerPath $cfg.state_directory $Record.message_id $AttemptId
    if(Test-Path -LiteralPath $markerPath){throw 'PreSubmissionRepairMarkerPresent'}
    $priorDetail=[string]$attempt.detail
    $attempt.outcome='NotDelivered'
    $attempt.detail=$Detail
    $attempt|Add-Member correction ([pscustomobject][ordered]@{
        schema_version=1;reason='ProvenPreSubmissionFailure';prior_outcome='DeliveryAmbiguous'
        prior_detail=$priorDetail;authorization_reference=$AuthorizationReference
        corrected_by_task_id=$ActorTaskId;corrected_on_machine=$env:COMPUTERNAME
        corrected_at_utc=Get-UtcTimestamp;delivery_claimed=$false
    }) -Force
    $Record.state='Queued'
    Add-Event $Record 'DeliveryAmbiguityCorrected' "Attempt $AttemptId corrected to NotDelivered: $Detail" $ActorProjectRoom $ActorTaskId
    Write-JsonAtomic $RecordPath $Record
    return $Record
}
function Invoke-LtManagerOperation {
    Assert-LtId $MessageId
    $path = Get-RecordPath -Root $QueuePath -Id $MessageId
    if (!(Test-Path -LiteralPath $path)) { return [pscustomobject]@{claimed=$false;reason='MissingTarget'} }
    $r = Read-Record $path
    if ($Action -eq 'Inspect') { return [pscustomobject]@{record=$r;version=(Get-LtVersion $r)} }
    Assert-LtOwner
    if($Mode -ceq 'Canary'){Assert-LtCanaryRecord $r -ForSubmission:($Action -eq 'ConditionalClaim')}
    if ($ExpectedHash -cnotmatch '^[0-9a-f]{64}$' -or $r.payload_hash -cne $ExpectedHash -or !(Get-PrMessageHashEvidence $r).valid) { throw 'ImmutableHashMismatch' }
    if ([string]::IsNullOrWhiteSpace($AttemptId)) { throw 'AttemptIdRequired' }
    Assert-LtId $AttemptId
    $existing = @($r.attempts | Where-Object attempt_id -CEQ $AttemptId)
    if ($Action -eq 'ConditionalClaim') {
        if($r.destination.task_id -ceq $ActorTaskId){throw 'SelfNotificationForbidden'}
        if ($existing.Count -eq 1) {
            if ($existing[0].transport_owner -cne $TransportOwner -or $existing[0].transport_generation -cne $Generation) { throw 'AttemptOwnerMismatch' }
            return [pscustomobject]@{claimed=$true;idempotent=$true;may_submit=$false;attempt_id=$AttemptId;record=$r}
        }
        if ($existing.Count -gt 1) { throw 'DuplicateAttemptId' }
        if ([string]::IsNullOrWhiteSpace($ExpectedVersion) -or (Get-LtVersion $r) -cne $ExpectedVersion) { return [pscustomobject]@{claimed=$false;reason='VersionConflict'} }
        $client=Read-LtJson $ClientConfigPath
        $manifests=@(Get-ChildItem -LiteralPath $ManifestDirectory -Filter '*.json' -File | ForEach-Object { Read-LtJson $_.FullName })
        if ((Get-LtConfigHash $client $manifests) -cne $ExpectedConfigHash) { return [pscustomobject]@{claimed=$false;reason='ConfigurationConflict'} }
        $all=@(Get-ChildItem -LiteralPath (Join-Path $QueuePath 'records') -Filter '*.json' -File | ForEach-Object {Read-Record $_.FullName})
        $reason=Test-LtRecord $r $client $manifests $env:COMPUTERNAME $Mode $MessageId $all
        if ($reason -cne 'Eligible') { return [pscustomobject]@{claimed=$false;reason=$reason} }
        $attempt=[pscustomobject][ordered]@{attempt_id=$AttemptId;started_at_utc=(Get-UtcTimestamp);completed_at_utc=$null;outcome='Pending';detail=$null;transport_owner=$TransportOwner;transport_generation=$Generation}
        $r.attempts=@($r.attempts)+@($attempt); $r.attempt_count=[int]$r.attempt_count+1; $r.state='Delivery Attempted'
        Add-Event $r 'DeliveryAttemptStarted' $AttemptId $ActorProjectRoom $ActorTaskId
        Write-JsonAtomic $path $r
        return [pscustomobject]@{claimed=$true;idempotent=$false;may_submit=$true;attempt_id=$AttemptId;record=$r}
    }
    if ($existing.Count -ne 1) { throw 'AttemptNotUnique' }
    $attempt=$existing[0]
    if ($attempt.transport_owner -cne $TransportOwner -or $attempt.transport_generation -cne $Generation) { throw 'AttemptOwnerMismatch' }
    if ($r.receipt -and !(Test-LtReceipt $r)) { throw 'ReceiptIdentityMismatch' }
    if (Test-LtReceipt $r) {
        if ($attempt.outcome -eq 'Delivered') { return [pscustomobject]@{outcome='Delivered';record=$r;changed=$false} }
        $attempt.outcome='Delivered'; $attempt.completed_at_utc=Get-UtcTimestamp; $attempt.detail='Exact authoritative recipient receipt reconciled.'
        Add-Event $r 'DeliveryReconciled' $AttemptId $ActorProjectRoom $ActorTaskId
        Write-JsonAtomic $path $r
        return [pscustomobject]@{outcome='Delivered';record=$r;changed=$true}
    }
    if ($r.result -or $r.state -in @('Accepted','Processing','Completed','Blocked','Needs Wes','Rejected as Wrong Room')) { return [pscustomobject]@{outcome='RecipientStatePreserved';record=$r;changed=$false} }
    if ($attempt.outcome -ne 'Pending') { return [pscustomobject]@{outcome=$attempt.outcome;record=$r;changed=$false} }
    if ($AttemptOutcome -notin @('NotDelivered','DeliveryAmbiguous')) { throw 'RecoveryOutcomeRequired' }
    $attempt.outcome=$AttemptOutcome; $attempt.completed_at_utc=Get-UtcTimestamp; $attempt.detail=$Detail
    $r.state=if($AttemptOutcome -eq 'NotDelivered'){'Queued'}else{'Delivery Ambiguous'}
    Add-Event $r 'DeliveryAttemptCompleted' "$AttemptOutcome`: $Detail" $ActorProjectRoom $ActorTaskId
    Write-JsonAtomic $path $r
    [pscustomobject]@{outcome=$AttemptOutcome;record=$r;changed=$true}
}
