Start-Transcript -Path 'C:\Codex\Wiki Files\Project Rooms\Codex Environment Deployment\working\wesstudio-winrm-client-config.log' -Force
$ErrorActionPreference = 'Continue'
Start-Service WinRM
Set-Item -Path WSMan:\localhost\Client\TrustedHosts -Value 'Wes-VideoEditor' -Concatenate -Force
Get-Service WinRM | Select-Object Status,Name,DisplayName
Get-Item -Path WSMan:\localhost\Client\TrustedHosts | Select-Object Name,Value
Stop-Transcript
