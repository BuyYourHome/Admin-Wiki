[CmdletBinding()]
param(
    [ValidateSet('01a05967-9a05-7081-a62e-616b2d8e61fd','01a05d0c-8031-7d92-9474-ab2330008ddb')]
    [string]$TaskId='01a05967-9a05-7081-a62e-616b2d8e61fd',
    [ValidateRange(1,15)][int]$TimeoutSeconds=10,
    [string]$EvidencePath
)
$ErrorActionPreference='Stop'
[Console]::OutputEncoding=[Text.UTF8Encoding]::new($false)
. "$PSScriptRoot\CodexReadOnlyProbe.ps1"
. "$PSScriptRoot\..\low-token\Common.ps1"
$identity=[Security.Principal.WindowsIdentity]::GetCurrent()
if($env:COMPUTERNAME -cne 'WES-VIDEOEDITOR' -or $identity.Name -ine 'WES-VIDEOEDITOR\IRAMa'){throw 'NormalWveIdentityRequired'}
$cli='C:\Users\IRAMa\AppData\Local\OpenAI\Codex\bin\1e3e57cdf0634c02\codex.exe'
$expected='56A84DE2B617AF6B95B0C5C5D8AE120D3C2FB69008AB330C7E7DF3945B98B782'
if((Get-FileHash -LiteralPath $cli).Hash -cne $expected){throw 'CliReleaseMismatch'}
if($EvidencePath){Assert-LtUnder $EvidencePath (Join-Path $env:LOCALAPPDATA 'BuyYourHome\PRMessaging\low-token-canary')}
$r=Invoke-CpRuntime $cli $TaskId 'C:\Codex\Wiki Files' $TimeoutSeconds
$r|Add-Member identity $identity.Name
$r|Add-Member cli_sha256 $expected
$r|Add-Member cli_version '0.153.1'
$r|Add-Member probe_sha256 (Get-LtPackageHash $PSScriptRoot)
if($EvidencePath){Write-LtJson $EvidencePath $r}
$r|ConvertTo-Json -Depth 8
