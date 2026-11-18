[CmdletBinding()]
param(
    [Parameter(Mandatory)][guid]$ApprovalId,
    [Parameter(Mandatory)][string]$PackageHash,
    [Parameter(Mandatory)][string]$State,
    [string]$CentralMessageId,
    [string]$CentralPayloadHash
)

$ErrorActionPreference = 'Stop'
if ($env:COMPUTERNAME -ine 'OFFICEASSIST' -or
    [Security.Principal.WindowsIdentity]::GetCurrent().Name -ine 'OfficeAssist\OfficeAssistLogin') {
    throw 'Publish email approval status only from the approved OFFICEASSIST normal-user context.'
}

Import-Module (Join-Path $PSScriptRoot 'EmailApprovalAttention.psm1') -Scope Local
$snapshot = Set-EmailApprovalSnapshot @PSBoundParameters -QueuePath '\\WES-VIDEOEDITOR\BYH-PRMessaging$'
$snapshot | Select-Object approval_id, state, updated_at_utc | ConvertTo-Json -Compress
