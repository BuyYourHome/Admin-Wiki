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
function Get-PrMessageHashEvidence($Record) {
    $canonical=[ordered]@{message_type=[string]$Record.message_type;parent_message_id=[string]$Record.parent_message_id;source=$Record.source;destination=$Record.destination;authorization=$Record.authorization;references=$Record.references;payload=$Record.payload}|ConvertTo-Json -Depth 30 -Compress
    $plain=Get-PrMessageDigest (Convert-PrMessageJsonEscaping $canonical $false)
    $html=Get-PrMessageDigest (Convert-PrMessageJsonEscaping $canonical $true)
    [pscustomobject]@{valid=($Record.payload_hash -cmatch '^[0-9a-f]{64}$' -and ($Record.payload_hash -ceq $plain -or $Record.payload_hash -ceq $html));default_hash=$plain;html_hash=$html}
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
function Test-PrAdministrativeClosure($Record) {
    if(!(Test-PrSupersededRecord $Record)){return $false}
    $c=$Record.administrative_closure
    if(!$c -or $c.schema_version -ne 1 -or $c.disposition -cne 'SupersededUndelivered' -or
        $c.message_id -cne $Record.message_id -or $c.payload_hash -cne $Record.payload_hash -or
        $c.superseded_by -cne 'prmsg-invoice-entry-poyner-spruill-qb-existence-audit-20260831-002' -or
        $c.authorized_by -cne 'Wes' -or $c.actor_task_id -cne '01a05d0c-8031-7d92-9474-ab2330008ddb' -or
        $c.delivery_claimed -isnot [bool] -or $c.delivery_claimed -ne $false -or
        $c.business_completion_claimed -isnot [bool] -or $c.business_completion_claimed -ne $false){return $false}
    try{[void][DateTimeOffset]::Parse($c.closed_at_utc)}catch{return $false}
    return $true
}
