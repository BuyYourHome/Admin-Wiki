[CmdletBinding(SupportsShouldProcess = $true)]
param(
    [string]$ShareName = "BYH-PRMessaging$"
)

$ErrorActionPreference = "Stop"
$principal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
if (-not $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) { throw "Run this removal script from an elevated PowerShell session." }
if ($env:COMPUTERNAME -ne "WES-VIDEOEDITOR") { throw "This removal script is restricted to WES-VIDEOEDITOR." }

if ($PSCmdlet.ShouldProcess($ShareName, "Remove PR messaging share and firewall rule; preserve message data")) {
    Get-SmbShare -Name $ShareName -ErrorAction SilentlyContinue | Remove-SmbShare -Force
    Get-NetFirewallRule -DisplayName "BYH PR Messaging SMB Host" -ErrorAction SilentlyContinue | Remove-NetFirewallRule
    [pscustomobject]@{ result = "Removed"; share = $ShareName; data_preserved = $true } | ConvertTo-Json
}
