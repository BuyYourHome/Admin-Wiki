[CmdletBinding(SupportsShouldProcess = $true)]
param(
    [string]$DataPath = "D:\BuyYourHome\PRMessaging",
    [string]$ShareName = "BYH-PRMessaging$",
    [Parameter(Mandatory = $true)]
    [string[]]$AllowedPrincipal,
    [string]$RemoteSubnet = "10.0.0.0/24"
)

$ErrorActionPreference = "Stop"
$principal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
if (-not $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) { throw "Run this installer from an elevated PowerShell session." }
if ($env:COMPUTERNAME -ne "WES-VIDEOEDITOR") { throw "This host installer is restricted to WES-VIDEOEDITOR; current computer is $env:COMPUTERNAME." }
if (-not (Test-Path -LiteralPath "D:\")) { $DataPath = "C:\ProgramData\BuyYourHome\PRMessaging" }

if ($PSCmdlet.ShouldProcess($DataPath, "Create secured PR messaging data store")) {
    New-Item -ItemType Directory -Path (Join-Path $DataPath "records") -Force | Out-Null
    New-Item -ItemType Directory -Path (Join-Path $DataPath "health") -Force | Out-Null
    $acl = New-Object Security.AccessControl.DirectorySecurity
    $acl.SetAccessRuleProtection($true, $false)
    foreach ($entry in @("NT AUTHORITY\SYSTEM", "BUILTIN\Administrators")) {
        $rule = New-Object Security.AccessControl.FileSystemAccessRule($entry, "FullControl", "ContainerInherit,ObjectInherit", "None", "Allow")
        $acl.AddAccessRule($rule)
    }
    foreach ($entry in $AllowedPrincipal) {
        $rule = New-Object Security.AccessControl.FileSystemAccessRule($entry, "Modify", "ContainerInherit,ObjectInherit", "None", "Allow")
        $acl.AddAccessRule($rule)
    }
    Set-Acl -LiteralPath $DataPath -AclObject $acl

    $existingShare = Get-SmbShare -Name $ShareName -ErrorAction SilentlyContinue
    if ($existingShare -and $existingShare.Path -ne $DataPath) { throw "SMB share $ShareName already exists at another path: $($existingShare.Path)" }
    if (-not $existingShare) {
        New-SmbShare -Name $ShareName -Path $DataPath -FullAccess "BUILTIN\Administrators" -ChangeAccess $AllowedPrincipal -EncryptData $true -FolderEnumerationMode AccessBased | Out-Null
    }
    else {
        Set-SmbShare -Name $ShareName -EncryptData $true -FolderEnumerationMode AccessBased -Force | Out-Null
    }

    $ruleName = "BYH PR Messaging SMB Host"
    Get-NetFirewallRule -DisplayName $ruleName -ErrorAction SilentlyContinue | Remove-NetFirewallRule
    New-NetFirewallRule -DisplayName $ruleName -Direction Inbound -Action Allow -Protocol TCP -LocalPort 445 -Profile Private -RemoteAddress $RemoteSubnet | Out-Null

    [pscustomobject]@{
        result = "Installed"
        computer = $env:COMPUTERNAME
        data_path = $DataPath
        share = "\\$env:COMPUTERNAME\$ShareName"
        smb_encryption = $true
        allowed_principals = $AllowedPrincipal
        firewall_rule = $ruleName
        remote_subnet = $RemoteSubnet
    } | ConvertTo-Json -Depth 10
}
