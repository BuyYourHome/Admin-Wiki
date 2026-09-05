[CmdletBinding()]
param(
    [Parameter(Mandatory=$true)][string]$ManagerPath,
    [Parameter(Mandatory=$true)][string]$ExpectedManagerHash,
    [ValidateSet('List','ConditionalClaim','ReconcileAttempt')][string]$Action,
    [Parameter(Mandatory=$true)][string]$QueuePath,
    [string]$FixtureRoot,[string]$TransportOwner,[string]$Generation,
    [string]$Mode,[string]$ClientConfigPath,[string]$ManifestDirectory,
    [string]$ActorTaskId,[string]$ActorProjectRoom,[string]$MessageId,
    [string]$ExpectedHash,[string]$ExpectedVersion,[string]$ExpectedConfigHash,
    [string]$AttemptId,[string]$AttemptOutcome,[string]$Detail
)
$ErrorActionPreference='Stop'
# Windows PowerShell's default console encoding can best-fit Unicode quotes into
# bare ASCII quotes, destroying otherwise valid JSON. Preserve UTF-8 end to end.
[Console]::OutputEncoding=[Text.UTF8Encoding]::new($false)
if((Get-FileHash -LiteralPath $ManagerPath).Hash -ine $ExpectedManagerHash){throw 'ManagerReleaseMismatch'}
if($Action -ne 'List'){
    if($ManagerPath -cne (Join-Path $PSScriptRoot 'Manage-ProjectRoomMessage.Development.ps1')){throw 'MutationRequiresStagedFixtureManager'}
    . "$PSScriptRoot\Common.ps1"
    Assert-LtFixture $FixtureRoot @($QueuePath,$ClientConfigPath,$ManifestDirectory)
}
$forward=@{}
foreach($key in $PSBoundParameters.Keys){if($key -notin @('ManagerPath','ExpectedManagerHash')){$forward[$key]=$PSBoundParameters[$key]}}
& $ManagerPath @forward
