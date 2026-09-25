# Read-only legacy hash compatibility and transport-final verification.
# Preserve JSON token order/numeric spelling; translate ONLY five HTML escapes
# inside string tokens. Escaped backslashes are consumed as units, so literal
# text such as \\u0027 is never interpreted as an apostrophe.
function Convert-PrMessageJsonEscaping([string]$Json,[bool]$Html) {
    [regex]::Replace($Json, '"(?:\\.|[^"\\])*"', [Text.RegularExpressions.MatchEvaluator]{
        param($token)
        $inner=$token.Value.Substring(1,$token.Value.Length-2)
        $converted=[regex]::Replace($inner, '\\(?:u[0-9a-fA-F]{4}|.)|[^\\]', [Text.RegularExpressions.MatchEvaluator]{
            param($part)
            $v=$part.Value
            $character=switch -CaseSensitive ($v) {
                '\u0027' { "'" } '\u0026' { '&' } '\u003c' { '<' } '\u003C' { '<' }
                '\u003e' { '>' } '\u003E' { '>' } '\u0022' { '"' } '\"' { '"' }
                default { $v }
            }
            if($Html){ switch -CaseSensitive ($character){
                "'" { '\u0027' } '&' { '\u0026' } '<' { '\u003c' } '>' { '\u003e' } '"' { '\u0022' }
                default { $character }
            }} else { if($character -ceq '"'){'\"'}else{$character} }
        })
        '"'+$converted+'"'
    })
}
function Get-PrMessageDigest([string]$Text) {
    $sha=[Security.Cryptography.SHA256]::Create()
    try{([BitConverter]::ToString($sha.ComputeHash([Text.Encoding]::UTF8.GetBytes($Text)))).Replace('-','').ToLowerInvariant()}finally{$sha.Dispose()}
}
function Convert-PrMessageLegacyDateValues($Value) {
    if($null -eq $Value){return $null}
    if($Value -is [DateTime]){return $Value.ToUniversalTime().ToString('o')}
    if($Value -is [DateTimeOffset]){return $Value.ToUniversalTime().ToString('o')}
    if($Value -is [string] -and $Value -cmatch '^(?<prefix>\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}\.)(?<fraction>\d{1,6})Z$'){
        return $Matches.prefix+$Matches.fraction.PadRight(7,'0')+'Z'
    }
    if($Value -is [Collections.IDictionary]){
        $copy=[ordered]@{}
        foreach($key in $Value.Keys){$copy[$key]=Convert-PrMessageLegacyDateValues $Value[$key]}
        return $copy
    }
    if($Value -is [Collections.IEnumerable] -and $Value -isnot [string]){
        return @($Value|ForEach-Object {Convert-PrMessageLegacyDateValues $_})
    }
    if($Value.GetType().FullName -ceq 'System.Management.Automation.PSCustomObject'){
        $copy=[ordered]@{}
        foreach($property in $Value.PSObject.Properties){$copy[$property.Name]=Convert-PrMessageLegacyDateValues $property.Value}
        return [pscustomobject]$copy
    }
    return $Value
}
function Get-PrMessageHashEvidence($Record) {
    $immutable=[ordered]@{message_type=[string]$Record.message_type;parent_message_id=[string]$Record.parent_message_id;source=$Record.source;destination=$Record.destination;authorization=$Record.authorization;references=$Record.references;payload=$Record.payload}
    $canonical=$immutable|ConvertTo-Json -Depth 30 -Compress
    $plain=Get-PrMessageDigest (Convert-PrMessageJsonEscaping $canonical $false)
    $html=Get-PrMessageDigest (Convert-PrMessageJsonEscaping $canonical $true)
    $legacyCanonical=(Convert-PrMessageLegacyDateValues $immutable)|ConvertTo-Json -Depth 30 -Compress
    $legacyPlain=Get-PrMessageDigest (Convert-PrMessageJsonEscaping $legacyCanonical $false)
    $legacyHtml=Get-PrMessageDigest (Convert-PrMessageJsonEscaping $legacyCanonical $true)
    [pscustomobject]@{
        valid=($Record.payload_hash -cmatch '^[0-9a-f]{64}$' -and
            $Record.payload_hash -cin @($plain,$html,$legacyPlain,$legacyHtml))
        default_hash=$plain;html_hash=$html
        legacy_datetime_default_hash=$legacyPlain;legacy_datetime_html_hash=$legacyHtml
    }
}
function Test-PrMessageTerminal($Record) {
    if(!(Get-PrMessageHashEvidence $Record).valid){return $false}
    if($Record.state -cnotin @('Completed','Blocked','Needs Wes','Rejected as Wrong Room') -or $Record.result.state -cne $Record.state){return $false}
    $r=$Record.receipt
    if(!$r -or $r.project_room -cne $Record.destination.project_room -or $r.task_id -cne $Record.destination.task_id -or $r.machine -cne $Record.destination.machine -or $Record.result.machine -cne $Record.destination.machine){return $false}
    try{return ([DateTimeOffset]::Parse($Record.result.completed_at_utc) -ge [DateTimeOffset]::Parse($r.accepted_at_utc))}catch{return $false}
}
function Test-PrSupersededRecord($Record) {
    return ($Record.message_id -ceq 'prmsg-invoice-entry-poyner-spruill-qb-existence-audit-20260831-001' -and
        $Record.payload_hash -ceq 'c796ce3a15c09244bc8de8af3ea7c893928862e462bb13cc8421012b7c79f91c' -and
        (Get-PrMessageHashEvidence $Record).valid -and $Record.destination.task_id -ceq '01a05967-9a05-7081-a62e-616b2d8e61fd' -and
        $Record.destination.machine -ceq 'WES-VIDEOEDITOR' -and $Record.state -ceq 'Blocked' -and !$Record.receipt -and !$Record.result -and
        $Record.attempt_count -eq 1 -and @($Record.attempts).Count -eq 1 -and
        $Record.attempts[0].attempt_id -ceq 'invalid-control-total-20260831-001' -and $Record.attempts[0].outcome -ceq 'Failed')
}
function Test-PrMessageStructurallyTerminal($Record) {
    if($Record.authoritative -ne $true -or
        $Record.state -cnotin @('Completed','Blocked','Needs Wes','Rejected as Wrong Room') -or
        !$Record.result -or $Record.result.state -cne $Record.state){return $false}
    $r=$Record.receipt
    if(!$r -or $r.project_room -cne $Record.destination.project_room -or
        $r.task_id -cne $Record.destination.task_id -or $r.machine -cne $Record.destination.machine -or
        $Record.result.machine -cne $Record.destination.machine){return $false}
    try{return ([DateTimeOffset]::Parse($Record.result.completed_at_utc) -ge [DateTimeOffset]::Parse($r.accepted_at_utc))}catch{return $false}
}
function Test-PrObsoleteRollbackRecord($Record) {
    if($Record.message_id -cne 'prmsg-doc-scan-rollback-review-20260824-001' -or
        $Record.payload_hash -cne 'dc03b0ab70b657a77dcd0df7327c5e5cca5bbef6529232c5b186fd2ec48289b9' -or
        !(Get-PrMessageHashEvidence $Record).valid -or $Record.authoritative -ne $true -or
        $Record.destination.project_room -cne 'Doc Scan' -or
        $Record.destination.task_id -cne '01a029bf-8534-7b73-a330-55015eb2a722' -or
        $Record.destination.machine -cne 'OFFICEASSIST' -or $Record.state -cne 'Queued' -or
        $Record.receipt -or $Record.result -or $Record.attempt_count -ne 3 -or $Record.max_attempts -ne 3){return $false}
    $a=@($Record.attempts)
    $ids=@('49e711c01d79407f9c4f1e7409f42d71','dispatcher-officeassist-prmsg-doc-scan-rollback-review-20260824-001-2','dispatcher-officeassist-prmsg-doc-scan-rollback-review-20260824-001-3')
    if($a.Count -ne 3){return $false}
    for($i=0;$i -lt 3;$i++){
        $outcome=if($i -eq 0){'DeliveryAmbiguous'}else{'NotDelivered'}
        if($a[$i].attempt_id -cne $ids[$i] -or $a[$i].outcome -cne $outcome){return $false}
        try{
            $start=[DateTimeOffset]::Parse([string]$a[$i].started_at_utc)
            $end=[DateTimeOffset]::Parse([string]$a[$i].completed_at_utc)
            if($end -lt $start -or $end -gt [DateTimeOffset]::UtcNow.AddMinutes(-30)){return $false}
        }catch{return $false}
    }
    if(@($Record.events|Where-Object event -notin @('Created','DeliveryAttemptStarted','DeliveryAttemptCompleted','AdministrativelyRetired')).Count){return $false}
    return $true
}
function Test-PrExhaustedAmbiguousRecord($Record,[int]$MinimumAgeMinutes=30) {
    if($MinimumAgeMinutes -lt 1 -or !(Get-PrMessageHashEvidence $Record).valid -or
        $Record.authoritative -ne $true -or $Record.state -cne 'Delivery Ambiguous' -or
        $Record.receipt -or $Record.result -or [int]$Record.max_attempts -lt 1 -or
        [int]$Record.attempt_count -ne [int]$Record.max_attempts){return $false}
    $attempts=@($Record.attempts)
    if($attempts.Count -ne [int]$Record.attempt_count -or
        @($attempts|Where-Object {$_.outcome -eq 'Pending' -or [string]::IsNullOrWhiteSpace([string]$_.completed_at_utc)}).Count -or
        !@($attempts|Where-Object outcome -eq 'DeliveryAmbiguous').Count){return $false}
    try{
        $latest=@($attempts|ForEach-Object{[DateTimeOffset]::Parse($_.completed_at_utc)}|Sort-Object -Descending|Select-Object -First 1)[0]
        return (([DateTimeOffset]::UtcNow-$latest).TotalMinutes -ge $MinimumAgeMinutes)
    }catch{return $false}
}
function Test-PrAuthorizedStatusCancellationRecord($Record,[int]$MinimumAgeMinutes=30) {
    if($MinimumAgeMinutes -lt 1 -or !(Get-PrMessageHashEvidence $Record).valid -or
        $Record.authoritative -ne $true -or $Record.message_type -cne 'status' -or
        $Record.state -cne 'Delivery Ambiguous' -or $Record.receipt -or $Record.result -or
        $Record.administrative_closure -or [int]$Record.max_attempts -lt 1 -or
        [int]$Record.attempt_count -lt 1 -or [int]$Record.attempt_count -ge [int]$Record.max_attempts -or
        $Record.authorization.business_action_authorized -ne $false -or
        $Record.authorization.production_claims_authorized -ne $false -or
        $Record.payload.status -cne 'Blocked' -or $Record.payload.business_action_performed -ne $false -or
        [int]$Record.payload.production_claims -ne 0 -or [int]$Record.payload.forced_runs -ne 0 -or
        [int]$Record.payload.live_automation_calls -ne 0){return $false}
    $attempts=@($Record.attempts)
    if($attempts.Count -ne [int]$Record.attempt_count -or
        @($attempts|Where-Object {$_.outcome -eq 'Pending' -or [string]::IsNullOrWhiteSpace([string]$_.completed_at_utc)}).Count -or
        !@($attempts|Where-Object outcome -eq 'DeliveryAmbiguous').Count){return $false}
    try{
        $latest=@($attempts|ForEach-Object{[DateTimeOffset]::Parse($_.completed_at_utc)}|Sort-Object -Descending|Select-Object -First 1)[0]
        return (([DateTimeOffset]::UtcNow-$latest).TotalMinutes -ge $MinimumAgeMinutes)
    }catch{return $false}
}
function Test-PrAcknowledgedStatusCancellationRecord($Record,[string]$AttemptId,[int]$MinimumAgeMinutes=30) {
    if($MinimumAgeMinutes -lt 1 -or [string]::IsNullOrWhiteSpace($AttemptId) -or
        !(Get-PrMessageHashEvidence $Record).valid -or $Record.authoritative -ne $true -or
        $Record.message_type -cne 'status' -or $Record.state -cne 'Delivery Attempted' -or
        $Record.receipt -or $Record.result -or $Record.administrative_closure -or
        [int]$Record.max_attempts -lt 1 -or [int]$Record.attempt_count -lt 1 -or
        [int]$Record.attempt_count -ge [int]$Record.max_attempts -or
        $Record.authorization.business_action_authorized -ne $false -or
        $Record.authorization.production_claims_authorized -ne $false -or
        $Record.payload.business_action_performed -ne $false -or
        [int]$Record.payload.production_claims -ne 0 -or [int]$Record.payload.forced_runs -ne 0){return $false}
    $attempts=@($Record.attempts)
    $matching=@($attempts|Where-Object attempt_id -CEQ $AttemptId)
    if($attempts.Count -ne [int]$Record.attempt_count -or $matching.Count -ne 1 -or
        $matching[0].outcome -cne 'Pending' -or $null -ne $matching[0].completed_at_utc -or
        [string]::IsNullOrWhiteSpace([string]$matching[0].started_at_utc)){return $false}
    try{
        $startedValue=$matching[0].started_at_utc
        $started=if($startedValue -is [DateTimeOffset]){$startedValue}elseif($startedValue -is [DateTime]){[DateTimeOffset]$startedValue}else{[DateTimeOffset]::Parse([string]$startedValue)}
        return (([DateTimeOffset]::UtcNow-$started).TotalMinutes -ge $MinimumAgeMinutes)
    }catch{return $false}
}
function Test-PrAdministrativeClosure($Record) {
    $c=$Record.administrative_closure
    if(!$c -or $c.schema_version -ne 1 -or
        $c.message_id -cne $Record.message_id -or $c.payload_hash -cne $Record.payload_hash -or
        $c.authorized_by -cne 'Wes' -or [string]::IsNullOrWhiteSpace([string]$c.actor_task_id) -or
        $c.delivery_claimed -isnot [bool] -or $c.delivery_claimed -ne $false -or
        $c.business_completion_claimed -isnot [bool] -or $c.business_completion_claimed -ne $false){return $false}
    try{[void][DateTimeOffset]::Parse($c.closed_at_utc)}catch{return $false}
    if($c.disposition -ceq 'ObsoleteRollbackRetired'){
        return ((Test-PrObsoleteRollbackRecord $Record) -and
            $c.actor_project_room -ceq 'PR Messaging Dispatcher' -and
            $c.actor_task_id -ceq '01a09d84-a309-7591-a790-e770fcb53dee' -and
            $c.transport_owner_task_id -ceq $c.actor_task_id -and $c.actor_machine -ceq 'OFFICEASSIST' -and
            $c.transport_owner -ceq 'low-token-officeassist' -and $c.transport_generation -ceq '0.4.0' -and
            $c.original_state -ceq 'Queued' -and $c.delivery_status -ceq 'Unresolved' -and
            $c.authorization_reference -ceq 'Wes explicitly cancelled and authorized administrative retirement in Jean Wright on September 25, 2026.' -and
            $c.record_version_before -cmatch '^[0-9a-f]{64}$')
    }
    if($c.disposition -ceq 'SupersededUndelivered'){
        return ((Test-PrSupersededRecord $Record) -and
            $c.superseded_by -ceq 'prmsg-invoice-entry-poyner-spruill-qb-existence-audit-20260831-002' -and
            $c.actor_task_id -ceq '01a05d0c-8031-7d92-9474-ab2330008ddb')
    }
    if($c.disposition -ceq 'ExhaustedAmbiguousUndelivered'){
        return ((Test-PrExhaustedAmbiguousRecord $Record 1) -and
            ![string]::IsNullOrWhiteSpace([string]$c.authorization_reference) -and
            $c.actor_project_room -ceq 'PR Messaging Dispatcher' -and
            $c.actor_task_id -ceq $c.transport_owner_task_id -and
            $c.actor_machine -ceq $Record.destination.machine -and
            $c.transport_owner -cmatch '^low-token-[a-z0-9-]+$' -and
            ![string]::IsNullOrWhiteSpace([string]$c.transport_generation))
    }
    if($c.disposition -ceq 'IntegrityFailureQuarantined'){
        $hashes=Get-PrMessageHashEvidence $Record
        return (!$hashes.valid -and (Test-PrMessageStructurallyTerminal $Record) -and
            $c.observed_default_hash -ceq $hashes.default_hash -and
            $c.observed_html_hash -ceq $hashes.html_hash -and
            ![string]::IsNullOrWhiteSpace([string]$c.authorization_reference) -and
            $c.actor_project_room -ceq 'PR Messaging Dispatcher' -and
            $c.actor_task_id -ceq $c.transport_owner_task_id -and
            $c.actor_machine -ceq $Record.destination.machine -and
            $c.transport_owner -cmatch '^low-token-[a-z0-9-]+$' -and
            ![string]::IsNullOrWhiteSpace([string]$c.transport_generation))
    }
    if($c.disposition -ceq 'AuthorizedStatusCancelled'){
        $withoutClosure=$Record|ConvertTo-Json -Depth 30|ConvertFrom-Json
        $withoutClosure.PSObject.Properties.Remove('administrative_closure')
        return ((Test-PrAuthorizedStatusCancellationRecord $withoutClosure 1) -and
            ![string]::IsNullOrWhiteSpace([string]$c.authorization_reference) -and
            $c.actor_project_room -ceq 'PR Messaging Dispatcher' -and
            $c.actor_task_id -ceq $c.transport_owner_task_id -and
            $c.actor_machine -ceq $Record.destination.machine -and
            $c.transport_owner -cmatch '^low-token-[a-z0-9-]+$' -and
            ![string]::IsNullOrWhiteSpace([string]$c.transport_generation) -and
            $c.delivery_status -ceq 'Unresolved')
    }
    if($c.disposition -ceq 'AcknowledgedStatusCancelled'){
        $withoutClosure=$Record|ConvertTo-Json -Depth 30|ConvertFrom-Json
        $withoutClosure.PSObject.Properties.Remove('administrative_closure')
        return ((Test-PrAcknowledgedStatusCancellationRecord $withoutClosure ([string]$c.attempt_id) 1) -and
            ![string]::IsNullOrWhiteSpace([string]$c.authorization_reference) -and
            $c.actor_project_room -ceq 'PR Messaging Dispatcher' -and
            $c.actor_task_id -ceq $c.transport_owner_task_id -and
            $c.actor_machine -ceq $Record.destination.machine -and
            $c.transport_owner -cmatch '^low-token-[a-z0-9-]+$' -and
            ![string]::IsNullOrWhiteSpace([string]$c.transport_generation) -and
            $c.submission_status -ceq 'QueueAcknowledgedAwaitingReceipt' -and
            $c.queue_message_id -cmatch '^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$' -and
            $c.evidence_sha256 -cmatch '^[0-9a-f]{64}$' -and
            $c.delivery_status -ceq 'Unresolved')
    }
    return $false
}
