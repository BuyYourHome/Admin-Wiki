# Installer-only library; never loaded by a tick or copied into a live package.
# Read-only platform adapters permit isolated tests. The production CLI exposes no fixture override.
function Invoke-LtValidationEnrollment {
    [CmdletBinding()]
    param(
        [string]$ConfigPath,[string]$StateDirectory,[string]$ManifestPath,[string]$OwnerPath,
        [string]$Machine,[string]$Sid,[string]$DispatcherTaskId,[string]$ProjectRoom,[string]$DestinationTaskId,
        [string]$ValidationMessageId,[string]$ExpectedLiveConfigHash,[string]$ExpectedOwnerGeneration,
        [string]$ExpectedManifestHash,[string]$ExpectedSyntheticPayloadHash,
        [string]$CurrentCliPath,[string]$CurrentCliHash,
        [string]$ExpectedActionExecute,[string]$ExpectedActionArguments,
        [scriptblock]$GetScheduleEvidence,[scriptblock]$ReadValidationRecord
    )
    $ErrorActionPreference='Stop'
    foreach($hash in @($ExpectedLiveConfigHash,$ExpectedManifestHash,$ExpectedSyntheticPayloadHash,$CurrentCliHash)){
        if($hash -notmatch '^[0-9a-fA-F]{64}$'){throw 'EnrollmentExpectedHashRequired'}
    }
    if([string]::IsNullOrWhiteSpace($ExpectedOwnerGeneration)){throw 'EnrollmentExpectedGenerationRequired'}
    Assert-LtId $ValidationMessageId;Assert-LtUuid $DestinationTaskId;Assert-LtUuid $DispatcherTaskId
    if($DestinationTaskId -ceq $DispatcherTaskId){throw 'SelfNotificationForbidden'}
    if(!(Test-Path -LiteralPath $StateDirectory -PathType Container)){throw 'EnrollmentStateMissing'}
    $lock=$null
    try{
        # The same exclusive lock held by every natural worker tick. Busy means no mutation.
        try{$lock=[IO.File]::Open((Join-Path $StateDirectory 'worker.lock'),[IO.FileMode]::OpenOrCreate,[IO.FileAccess]::ReadWrite,[IO.FileShare]::None)}
        catch{throw 'WorkerAlreadyRunning'}
        $cfg=Read-LtJson $ConfigPath
        $configHash=(Get-FileHash -LiteralPath $ConfigPath -Algorithm SHA256).Hash
        # Authenticate the config before trusting its executable paths. For an idempotent
        # repeat, prove the current file is exactly the authorized additive transformation.
        if($configHash -ine $ExpectedLiveConfigHash){
            $priorPath=Join-Path (Join-Path $StateDirectory 'enrollments') ($DestinationTaskId+'--'+$ValidationMessageId+'.before.json')
            if(!(Test-Path -LiteralPath $priorPath) -or (Get-FileHash -LiteralPath $priorPath).Hash -ine $ExpectedLiveConfigHash){throw 'EnrollmentLiveConfigHashMismatch'}
            $prior=Read-LtJson $priorPath
            if(@($prior.destinations|Where-Object {$_.task_id -ceq $DestinationTaskId -or $_.project_room -ceq $ProjectRoom}).Count){throw 'EnrollmentInvalidBeforeImage'}
            $prior.destinations=@($prior.destinations)+@([pscustomobject][ordered]@{project_room=$ProjectRoom;task_id=$DestinationTaskId;machine=$Machine})
            if((Get-LtSha256 ($prior|ConvertTo-Json -Depth 30)) -ine $configHash){throw 'EnrollmentLiveConfigHashMismatch'}
        }
        $manifestHash=(Get-FileHash -LiteralPath $ManifestPath -Algorithm SHA256).Hash
        if($manifestHash -ine $ExpectedManifestHash){throw 'EnrollmentManifestHashMismatch'}
        $manifest=Read-LtJson $ManifestPath
        if($cfg.schema_version -ne 1 -or $cfg.release -cne '0.4.7' -or $cfg.expected_machine -cne $Machine -or
            $cfg.expected_sid -cne $Sid -or $cfg.dispatcher_task_id -cne $DispatcherTaskId -or
            $cfg.generation -cne $ExpectedOwnerGeneration -or $cfg.state_directory -cne $StateDirectory -or
            $cfg.adapter_kind -cne 'CodexQueue'){throw 'EnrollmentLiveConfigIdentityMismatch'}
        $package=Split-Path -Parent $ConfigPath
        if((Get-LtPackageHash $package) -ine $cfg.package_sha256){throw 'EnrollmentPackageMismatch'}
        foreach($pin in @(@($cfg.manager_path,$cfg.manager_sha256),@($cfg.adapter_path,$cfg.adapter_sha256),@($cfg.cli_path,$cfg.cli_sha256))){
            if(!(Test-Path -LiteralPath $pin[0] -PathType Leaf) -or (Get-FileHash -LiteralPath $pin[0] -Algorithm SHA256).Hash -ine $pin[1]){throw 'EnrollmentExecutablePinMismatch'}
        }
        if($cfg.cli_path -cne $CurrentCliPath -or $cfg.cli_sha256 -ine $CurrentCliHash){throw 'EnrollmentCurrentCliMismatch'}
        $ownerHash=(Get-FileHash -LiteralPath $OwnerPath -Algorithm SHA256).Hash
        $owner=Read-LtJson $OwnerPath
        if($owner.mode -cne 'Live' -or $owner.machine -cne $Machine -or $owner.sid -cne $Sid -or
            $owner.task_id -cne $DispatcherTaskId -or $owner.owner -cne $cfg.owner -or
            $owner.generation -cne $ExpectedOwnerGeneration){throw 'EnrollmentLiveOwnerMismatch'}
        $schedule=& $GetScheduleEvidence
        if(!$schedule.enabled -or $schedule.principal_sid -cne $Sid -or @($schedule.actions).Count -ne 1 -or
            $schedule.actions[0].execute -ine $ExpectedActionExecute -or
            $schedule.actions[0].arguments -cne $ExpectedActionArguments -or
            [string]::IsNullOrWhiteSpace($schedule.snapshot_hash)){throw 'EnrollmentScheduledActionMismatch'}
        $clientHash=(Get-FileHash -LiteralPath $cfg.client_path -Algorithm SHA256).Hash
        $client=Read-LtJson $cfg.client_path
        $regs=@($client.registrations|Where-Object {$_.project_room -ceq $ProjectRoom -or $_.task_id -ceq $DestinationTaskId})
        if($client.machine -cne $Machine -or $regs.Count -ne 1 -or $regs[0].project_room -cne $ProjectRoom -or
            $regs[0].task_id -cne $DestinationTaskId){throw 'EnrollmentRegistrationMismatch'}
        $allManifests=@(Get-ChildItem -LiteralPath $cfg.manifest_directory -Filter '*.json' -File|ForEach-Object{Read-LtJson $_.FullName})
        $matches=@($allManifests|Where-Object {$_.project_room -ceq $ProjectRoom -or $_.task_id -ceq $DestinationTaskId})
        if($matches.Count -ne 1 -or $manifest.schema_version -ne 2 -or $manifest.project_room -cne $ProjectRoom -or
            $manifest.task_id -cne $DestinationTaskId -or $manifest.execution_machine -cne $Machine -or
            $manifest.dispatchable -isnot [bool] -or $manifest.dispatchable -ne $false -or
            $manifest.messaging_readiness.status -cne 'validation_ready' -or
            $manifest.messaging_readiness.validation_message_id -cne $ValidationMessageId -or
            $manifest.messaging_readiness.dispatcher_task_id -cne $DispatcherTaskId){throw 'EnrollmentValidationManifestMismatch'}
        $record=& $ReadValidationRecord $cfg $ValidationMessageId
        Assert-LtUuid ([string]$record.source.task_id)
        Assert-LtId ([string]$record.dispatch_id)
        if(!(Get-PrMessageHashEvidence $record).valid -or $record.payload_hash -cne $ExpectedSyntheticPayloadHash -or
            $record.message_id -cne $ValidationMessageId -or [string]::IsNullOrWhiteSpace($record.dispatch_id) -or
            $record.authoritative -ne $true -or $record.destination.project_room -cne $ProjectRoom -or
            $record.destination.task_id -cne $DestinationTaskId -or $record.destination.machine -cne $Machine){throw 'EnrollmentSyntheticIdentityMismatch'}
        $synthetic=($record.payload.synthetic_test -is [bool] -and $record.payload.synthetic_test -eq $true -and
            $record.authorization.business_action_authorized -is [bool] -and $record.authorization.business_action_authorized -eq $false -and
            $record.payload.business_action_authorized -is [bool] -and $record.payload.business_action_authorized -eq $false -and
            $record.payload.business_action_performed -is [bool] -and $record.payload.business_action_performed -eq $false)
        if(!$synthetic -or $record.authorization.authorized_by -cne 'Wes' -or
            [string]::IsNullOrWhiteSpace($record.authorization.instruction) -or [string]::IsNullOrWhiteSpace($record.source.project_room) -or
            $record.message_type -cnotin @($manifest.accepted_message_types) -or [int]$record.max_attempts -ne 1 -or
            $record.source.machine -cnotin @('OFFICEASSIST','WES-VIDEOEDITOR') -or $record.source.machine -ceq $Machine -or
            $manifest.messaging_readiness.cross_machine_source -cne $record.source.machine){throw 'EnrollmentNotCrossMachineSynthetic'}
        $pins=@($cfg.destinations|Where-Object {$_.task_id -ceq $DestinationTaskId -or $_.project_room -ceq $ProjectRoom})
        $receiptDir=Join-Path $StateDirectory 'enrollments'
        $receiptPath=Join-Path $receiptDir ($DestinationTaskId+'--'+$ValidationMessageId+'.json')
        $receipt=if(Test-Path -LiteralPath $receiptPath){Read-LtJson $receiptPath}else{$null}
        if($receipt -and ($receipt.before_config_hash -ine $ExpectedLiveConfigHash -or
            $receipt.manifest_hash -ine $ExpectedManifestHash -or $receipt.payload_hash -cne $ExpectedSyntheticPayloadHash -or
            $receipt.task_id -cne $DestinationTaskId -or $receipt.project_room -cne $ProjectRoom -or
            $receipt.machine -cne $Machine -or $receipt.sid -cne $Sid -or $receipt.dispatcher_task_id -cne $DispatcherTaskId -or
            $receipt.generation -cne $ExpectedOwnerGeneration -or $receipt.message_id -cne $ValidationMessageId)){
            throw 'EnrollmentReceiptMismatch'
        }
        if($pins.Count){
            if($pins.Count -ne 1 -or $pins[0].task_id -cne $DestinationTaskId -or $pins[0].project_room -cne $ProjectRoom -or
                $pins[0].machine -cne $Machine -or !$receipt -or $receipt.after_config_hash -ine $configHash){throw 'EnrollmentUnprovenExistingPin'}
            # No mutation even when a tick has already submitted. Never rollback or retry delivery.
            return [pscustomobject]@{status='AlreadyEnrolled';config_hash=$configHash;receipt_path=$receiptPath;message_state=$record.state;changed=$false}
        }
        if($configHash -ine $ExpectedLiveConfigHash){throw 'EnrollmentLiveConfigHashMismatch'}
        if($record.state -cne 'Queued' -or [int]$record.attempt_count -ne 0 -or @($record.attempts).Count -ne 0 -or
            $record.receipt -or $record.result -or $record.administrative_closure){throw 'EnrollmentSyntheticNotPristine'}
        $journalPath=Join-Path $StateDirectory 'journal.json'
        $journalHash=(Get-FileHash -LiteralPath $journalPath -Algorithm SHA256).Hash
        $journal=Read-LtJson $journalPath
        if($journal.schema_version -ne 2 -or $journal.machine -cne $Machine -or $journal.sid -cne $Sid -or
            $journal.owner -cne $cfg.owner -or $journal.generation -cne $ExpectedOwnerGeneration -or $null -eq $journal.entries){throw 'EnrollmentJournalMismatch'}
        if(@($journal.entries|Where-Object {$_.destination_task_id -ceq $DestinationTaskId}).Count){throw 'EnrollmentDestinationHasJournalHistory'}
        $cfg.destinations=@($cfg.destinations)+@([pscustomobject][ordered]@{project_room=$ProjectRoom;task_id=$DestinationTaskId;machine=$Machine})
        $json=$cfg|ConvertTo-Json -Depth 30
        $bytes=[Text.UTF8Encoding]::new($false).GetBytes($json)
        $afterHash=Get-LtSha256 $json
        if($receipt -and $receipt.after_config_hash -ine $afterHash){throw 'EnrollmentPreparedConfigMismatch'}
        $scheduleNow=& $GetScheduleEvidence
        if((Get-FileHash -LiteralPath $ConfigPath).Hash -ine $configHash -or
            (Get-FileHash -LiteralPath $ManifestPath).Hash -ine $manifestHash -or
            (Get-FileHash -LiteralPath $cfg.client_path).Hash -ine $clientHash -or
            (Get-FileHash -LiteralPath $OwnerPath).Hash -ine $ownerHash -or
            (Get-FileHash -LiteralPath $journalPath).Hash -ine $journalHash -or
            $scheduleNow.snapshot_hash -cne $schedule.snapshot_hash){throw 'EnrollmentGuardChanged'}
        if(!$receipt){
            Write-LtJson $receiptPath ([ordered]@{schema_version=1;machine=$Machine;sid=$Sid;project_room=$ProjectRoom;task_id=$DestinationTaskId;
                dispatcher_task_id=$DispatcherTaskId;generation=$ExpectedOwnerGeneration;message_id=$ValidationMessageId;
                payload_hash=$ExpectedSyntheticPayloadHash;manifest_hash=$ExpectedManifestHash;before_config_hash=$configHash;
                after_config_hash=$afterHash;journal_hash=$journalHash;owner_hash=$ownerHash;schedule_hash=$schedule.snapshot_hash;
                created_at_utc=[DateTime]::UtcNow.ToString('o')})
        }
        $tmp=Join-Path (Split-Path -Parent $ConfigPath) ('.enroll-'+[guid]::NewGuid().ToString('N')+'.tmp')
        $stream=[IO.File]::Open($tmp,[IO.FileMode]::CreateNew,[IO.FileAccess]::Write,[IO.FileShare]::None)
        try{$stream.Write($bytes,0,$bytes.Length);$stream.Flush($true)}finally{$stream.Dispose()}
        $backup=Join-Path $receiptDir ($DestinationTaskId+'--'+$ValidationMessageId+'.before.json')
        if(Test-Path -LiteralPath $backup){throw 'EnrollmentBackupAlreadyExists'}
        # Local NTFS atomic replace. Retain prepared receipt, backup and temporary evidence on error.
        [IO.File]::Replace($tmp,$ConfigPath,$backup)
        if((Get-FileHash -LiteralPath $ConfigPath).Hash -ine $afterHash){throw 'EnrollmentPostWriteMismatchPreserveEvidence'}
        return [pscustomobject]@{status='EnrolledValidationDestination';config_hash=$afterHash;prior_config_hash=$configHash;
            receipt_path=$receiptPath;backup_path=$backup;destination_count=@($cfg.destinations).Count;changed=$true;
            delivery_started=$false;mode='Live';generation=$ExpectedOwnerGeneration}
    }finally{if($lock){$lock.Dispose()}}
}
