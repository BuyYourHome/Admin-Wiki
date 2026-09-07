[CmdletBinding()]
param([string]$TaskName = 'Codex - Doc Scan Scratch Downloader')

$ErrorActionPreference = 'Stop'
$processor = Join-Path $PSScriptRoot 'Process-DocScanDownloadRequests.ps1'
$action = New-ScheduledTaskAction -Execute 'powershell.exe' -Argument "-NoProfile -ExecutionPolicy Bypass -File `"$processor`""
$trigger = New-ScheduledTaskTrigger -Once -At (Get-Date).AddMinutes(1) -RepetitionInterval (New-TimeSpan -Minutes 1)
$principal = New-ScheduledTaskPrincipal -UserId "$env:USERDOMAIN\$env:USERNAME" -LogonType Interactive -RunLevel Limited
$settings = New-ScheduledTaskSettingsSet -MultipleInstances IgnoreNew -ExecutionTimeLimit (New-TimeSpan -Minutes 2)
Register-ScheduledTask -TaskName $TaskName -Action $action -Trigger $trigger -Principal $principal -Settings $settings -Description 'Processes constrained Doc Scan raw-download requests under OfficeAssistLogin.' -Force | Out-Null
Get-ScheduledTask -TaskName $TaskName | Select-Object TaskName,State,@{n='UserId';e={$_.Principal.UserId}},@{n='RunLevel';e={$_.Principal.RunLevel}}
