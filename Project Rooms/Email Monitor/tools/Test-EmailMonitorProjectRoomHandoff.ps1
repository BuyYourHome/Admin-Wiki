[CmdletBinding()]
param()

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$builder = Join-Path $PSScriptRoot 'Send-EmailMonitorProjectRoomHandoff.ps1'
$baseParameters = @{
    MessageId = 'test-email-monitor-authorization-001'
    MessageType = 'request'
    DestinationProjectRoom = 'Invoice Entry'
    DestinationTaskId = '01a03956-fa4f-77c1-9ab7-f709e5f1174e'
    DestinationMachine = 'OFFICEASSIST'
    ReferencesJson = (@(
        [ordered]@{
            reference_id = 'outlook:test-approval-001'
            kind = 'outlook_message'
            mailbox = 'OfficeAssist@BuyYourHomeLLC.com'
            outlook_message_id = 'NONPRODUCTION-OUTLOOK-MESSAGE-ID'
            sender = 'WesWill@BuyYourHomeLLC.com'
            received_at_utc = '2026-09-25T12:00:00Z'
            subject = 'NON-PRODUCTION authorization validation fixture'
        }
    ) | ConvertTo-Json -Depth 10 -Compress)
    PayloadJson = ([ordered]@{
        synthetic_test = $true
        requested_operation = 'Validate construction only; do not create a central record.'
        business_action_performed = $false
    } | ConvertTo-Json -Depth 10 -Compress)
}

$incompleteAuthorization = [ordered]@{
    instruction = 'Approved.'
    scope = 'Non-production validation fixture only.'
    evidence_reference = 'outlook:test-approval-001'
    business_action_authorized = $false
} | ConvertTo-Json -Compress

$rejected = $false
$rejectionMessage = $null
try {
    & $builder @baseParameters -AuthorizationJson $incompleteAuthorization -ValidateOnly | Out-Null
}
catch {
    $rejectionMessage = $_.Exception.Message
    $rejected = $rejectionMessage -like '*authorization.authorized_by is required*'
}
if (-not $rejected) {
    throw "Incomplete authorization was not rejected as required. Actual error: $rejectionMessage"
}

$mismatchedAuthorization = [ordered]@{
    authorized_by = 'Wes'
    instruction = 'Approved.'
    scope = 'Non-production validation fixture only.'
    evidence_reference = 'outlook:test-approval-001'
    business_action_authorized = $false
} | ConvertTo-Json -Compress
$mismatchRejected = $false
try {
    & $builder @baseParameters -AuthorizationJson $mismatchedAuthorization -ValidateOnly | Out-Null
}
catch {
    $mismatchRejected = $_.Exception.Message -like '*authorization.authorized_by must match*'
}
if (-not $mismatchRejected) {
    throw 'Mismatched claimed authorizer was not rejected.'
}

$completeAuthorization = [ordered]@{
    authorized_by = 'WesWill@BuyYourHomeLLC.com'
    instruction = 'Approved.'
    scope = 'Non-production validation fixture only.'
    evidence_reference = 'outlook:test-approval-001'
    business_action_authorized = $false
} | ConvertTo-Json -Compress

$validated = & $builder @baseParameters -AuthorizationJson $completeAuthorization -ValidateOnly | ConvertFrom-Json
if ($validated.valid -ne $true -or $validated.central_record_created -ne $false) {
    throw 'Complete authorization did not pass validation without central creation.'
}

[pscustomobject][ordered]@{
    test = 'Email Monitor Project Room handoff authorization validation'
    incomplete_authorization = 'Rejected before central creation'
    incomplete_error = $rejectionMessage
    mismatched_authorizer = 'Rejected before central creation'
    complete_authorization = 'Passed validation'
    central_records_created = 0
    result = 'PASS'
} | ConvertTo-Json -Depth 10
