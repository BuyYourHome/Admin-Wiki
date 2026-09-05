# Dot-sourced by the isolated manager copy; uses that manager's existing queue lock and writers.
function Assert-LtOwner {
    $o = Read-LtJson (Join-Path $QueuePath '.transport-owner.json')
    if ($o.owner -cne $TransportOwner -or $o.generation -cne $Generation -or $o.machine -cne $env:COMPUTERNAME -or $o.sid -cne [Security.Principal.WindowsIdentity]::GetCurrent().User.Value) { throw 'TransportOwnershipMismatch' }
    if($o.task_id -cne $ActorTaskId){throw 'TransportActorMismatch'}
    if ($o.mode -cne 'Validation' -or $Mode -cne 'Validation' -or $o.validation_message_id -cne $MessageId) { throw 'ExclusiveValidationOwnershipRequired' }
}
function Invoke-LtManagerOperation {
    Assert-LtId $MessageId
    $path = Get-RecordPath -Root $QueuePath -Id $MessageId
    if (!(Test-Path -LiteralPath $path)) { return [pscustomobject]@{claimed=$false;reason='MissingTarget'} }
    $r = Read-Record $path
    if ($Action -eq 'Inspect') { return [pscustomobject]@{record=$r;version=(Get-LtVersion $r)} }
    Assert-LtOwner
    if ($ExpectedHash -cnotmatch '^[0-9a-f]{64}$' -or $r.payload_hash -cne $ExpectedHash -or (Get-LtPayloadHash $r) -cne $ExpectedHash) { throw 'ImmutableHashMismatch' }
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
