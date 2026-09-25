[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [ValidatePattern('^[A-Za-z0-9][A-Za-z0-9._-]{2,127}$')]
    [string]$MessageId,

    [string]$DispatchId,

    [Parameter(Mandatory = $true)]
    [ValidateSet('request', 'question', 'status', 'decision', 'result', 'improvement')]
    [string]$MessageType,

    [string]$ParentMessageId,

    [Parameter(Mandatory = $true)]
    [string]$DestinationProjectRoom,

    [Parameter(Mandatory = $true)]
    [ValidatePattern('^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$')]
    [string]$DestinationTaskId,

    [Parameter(Mandatory = $true)]
    [string]$DestinationMachine,

    [Parameter(Mandatory = $true)]
    [string]$AuthorizationJson,

    [Parameter(Mandatory = $true)]
    [string]$ReferencesJson,

    [Parameter(Mandatory = $true)]
    [string]$PayloadJson,

    [ValidateRange(1, 3)]
    [int]$MaxAttempts = 3,

    [switch]$ValidateOnly
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$sourceProjectRoom = 'Email Monitor'
$sourceTaskId = '01a03956-fe55-7f62-9c0a-17c18f763320'
$sourceMachine = 'OFFICEASSIST'
$managerPath = 'C:\Codex\Wiki Files\tools\pr-messaging\Manage-ProjectRoomMessage.ps1'
$manifestDirectory = 'C:\Codex\Wiki Files\config\pr-messaging-manifests'

function ConvertFrom-RequiredJson {
    param(
        [Parameter(Mandatory = $true)][string]$Json,
        [Parameter(Mandatory = $true)][string]$Name
    )

    try {
        $value = $Json | ConvertFrom-Json -ErrorAction Stop
    }
    catch {
        throw "$Name must be valid JSON: $($_.Exception.Message)"
    }

    if ($null -eq $value) {
        throw "$Name must not be null."
    }
    return $value
}

function Get-ObjectProperty {
    param($Object, [string]$Name)
    $property = @($Object.PSObject.Properties | Where-Object { $_.Name -ceq $Name })
    if ($property.Count -eq 0) { return $null }
    return $property[0].Value
}

function Assert-RequiredText {
    param($Object, [string]$Name, [string]$Path)
    $value = Get-ObjectProperty -Object $Object -Name $Name
    if ($null -eq $value -or [string]::IsNullOrWhiteSpace([string]$value)) {
        throw "AuthorizationMissing: $Path is required."
    }
    return [string]$value
}

$authorization = ConvertFrom-RequiredJson -Json $AuthorizationJson -Name 'AuthorizationJson'
$referencesValue = ConvertFrom-RequiredJson -Json $ReferencesJson -Name 'ReferencesJson'
$payload = ConvertFrom-RequiredJson -Json $PayloadJson -Name 'PayloadJson'

$authorizedBy = Assert-RequiredText -Object $authorization -Name 'authorized_by' -Path 'authorization.authorized_by'
$null = Assert-RequiredText -Object $authorization -Name 'instruction' -Path 'authorization.instruction'
$null = Assert-RequiredText -Object $authorization -Name 'scope' -Path 'authorization.scope'
$authorityReference = Assert-RequiredText -Object $authorization -Name 'evidence_reference' -Path 'authorization.evidence_reference'

$businessActionAuthorized = Get-ObjectProperty -Object $authorization -Name 'business_action_authorized'
if ($businessActionAuthorized -isnot [bool]) {
    throw 'AuthorizationMissing: authorization.business_action_authorized must be an explicit Boolean.'
}

$references = @($referencesValue)
if ($references.Count -lt 1) {
    throw 'SourceEvidenceMissing: references must contain at least one immutable source reference.'
}

$referenceIds = @{}
foreach ($reference in $references) {
    if ($null -eq $reference) {
        throw 'SourceEvidenceMissing: references must not contain null entries.'
    }
    $referenceId = Get-ObjectProperty -Object $reference -Name 'reference_id'
    if ([string]::IsNullOrWhiteSpace([string]$referenceId)) {
        throw 'SourceEvidenceMissing: every reference requires reference_id.'
    }
    if ($referenceIds.ContainsKey([string]$referenceId)) {
        throw "SourceEvidenceInvalid: duplicate reference_id '$referenceId'."
    }

    $hasLocator = $false
    foreach ($locatorName in @('outlook_message_id', 'outlook_link', 'message_id', 'task_turn_id', 'path', 'uri', 'value')) {
        $locator = Get-ObjectProperty -Object $reference -Name $locatorName
        if ($null -ne $locator -and -not [string]::IsNullOrWhiteSpace([string]$locator)) {
            $hasLocator = $true
            break
        }
    }
    if (-not $hasLocator) {
        throw "SourceEvidenceMissing: reference '$referenceId' requires an immutable locator."
    }
    $referenceIds[[string]$referenceId] = $reference
}

if (-not $referenceIds.ContainsKey($authorityReference)) {
    throw "AuthorizationEvidenceMismatch: authorization.evidence_reference '$authorityReference' does not identify a supplied reference."
}

$authorityEvidence = $referenceIds[$authorityReference]
$evidenceAuthorizer = Get-ObjectProperty -Object $authorityEvidence -Name 'authorizer'
if ([string]::IsNullOrWhiteSpace([string]$evidenceAuthorizer)) {
    $evidenceAuthorizer = Get-ObjectProperty -Object $authorityEvidence -Name 'sender'
}
if ([string]::IsNullOrWhiteSpace([string]$evidenceAuthorizer)) {
    throw "AuthorizationEvidenceMismatch: authority reference '$authorityReference' requires authorizer or sender."
}
if (-not [string]::Equals($authorizedBy, [string]$evidenceAuthorizer, [StringComparison]::OrdinalIgnoreCase)) {
    throw "AuthorizationEvidenceMismatch: authorization.authorized_by must match the authorizer or sender on '$authorityReference'."
}

if ([string]::IsNullOrWhiteSpace($DestinationProjectRoom) -or [string]::IsNullOrWhiteSpace($DestinationMachine)) {
    throw 'DestinationMissing: destination Project Room and manifest-resolved machine are required.'
}
if (@($payload.PSObject.Properties).Count -lt 1) {
    throw 'PayloadMissing: PayloadJson must contain the requested operation and scope-specific facts.'
}

if (-not (Test-Path -LiteralPath $manifestDirectory -PathType Container)) {
    throw "DestinationManifestMissing: $manifestDirectory"
}
$destinationManifests = @(
    Get-ChildItem -LiteralPath $manifestDirectory -Filter '*.json' -File | ForEach-Object {
        $manifest = Get-Content -LiteralPath $_.FullName -Raw -Encoding UTF8 | ConvertFrom-Json -ErrorAction Stop
        if ([string]$manifest.project_room -ceq $DestinationProjectRoom) { $manifest }
    }
)
if ($destinationManifests.Count -ne 1) {
    throw "DestinationManifestInvalid: expected exactly one manifest for '$DestinationProjectRoom', found $($destinationManifests.Count)."
}
$destinationManifest = $destinationManifests[0]
if ([string]$destinationManifest.task_id -cne $DestinationTaskId) {
    throw 'DestinationManifestMismatch: DestinationTaskId does not match the active destination manifest.'
}
if ([string]$destinationManifest.execution_machine -cne $DestinationMachine) {
    throw 'DestinationManifestMismatch: DestinationMachine does not match the active destination manifest.'
}
if ($destinationManifest.dispatchable -ne $true -or [string]$destinationManifest.messaging_readiness.status -cne 'ready') {
    throw 'DestinationNotDispatchable: the active destination manifest is not ready and dispatchable.'
}
if ($MessageType -cnotin @($destinationManifest.accepted_message_types)) {
    throw "DestinationMessageTypeRejected: '$MessageType' is not accepted by the active destination manifest."
}

$validationResult = [pscustomobject][ordered]@{
    valid = $true
    central_record_created = $false
    message_id = $MessageId
    message_type = $MessageType
    source = [pscustomobject][ordered]@{
        project_room = $sourceProjectRoom
        task_id = $sourceTaskId
        machine = $sourceMachine
    }
    destination = [pscustomobject][ordered]@{
        project_room = $DestinationProjectRoom
        task_id = $DestinationTaskId
        machine = $DestinationMachine
    }
    authorized_by = $authorizedBy
    evidence_reference = $authorityReference
}

if ($ValidateOnly) {
    $validationResult | ConvertTo-Json -Depth 10
    return
}

if ($env:COMPUTERNAME -cne $sourceMachine) {
    throw "WrongMachine: Email Monitor handoffs must be created on $sourceMachine."
}
if (-not (Test-Path -LiteralPath $managerPath -PathType Leaf)) {
    throw "ManagerMissing: $managerPath"
}

$sendParameters = @{
    Action = 'Send'
    MessageId = $MessageId
    DispatchId = if ([string]::IsNullOrWhiteSpace($DispatchId)) { $MessageId } else { $DispatchId }
    MessageType = $MessageType
    SourceProjectRoom = $sourceProjectRoom
    SourceTaskId = $sourceTaskId
    SourceMachine = $sourceMachine
    DestinationProjectRoom = $DestinationProjectRoom
    DestinationTaskId = $DestinationTaskId
    DestinationMachine = $DestinationMachine
    AuthorizationJson = $AuthorizationJson
    ReferencesJson = $ReferencesJson
    PayloadJson = $PayloadJson
    MaxAttempts = $MaxAttempts
}
if (-not [string]::IsNullOrWhiteSpace($ParentMessageId)) {
    $sendParameters.ParentMessageId = $ParentMessageId
}

& $managerPath @sendParameters
