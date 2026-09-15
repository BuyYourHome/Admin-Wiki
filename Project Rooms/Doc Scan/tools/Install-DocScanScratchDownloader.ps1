[CmdletBinding()]
param([string]$TaskName = 'Codex - Doc Scan Scratch Downloader')

$ErrorActionPreference = 'Stop'
$launcher = Join-Path $PSScriptRoot 'Invoke-DocScanScratchDownloaderHidden.vbs'
if (!(Test-Path -LiteralPath $launcher)) { throw 'Hidden launcher is missing.' }
$action = New-ScheduledTaskAction -Execute 'C:\Windows\System32\wscript.exe' -Argument "//B //NoLogo `"$launcher`""
$trigger = New-ScheduledTaskTrigger -Once -At (Get-Date).AddMinutes(1) -RepetitionInterval (New-TimeSpan -Minutes 1)
$principal = New-ScheduledTaskPrincipal -UserId "$env:USERDOMAIN\$env:USERNAME" -LogonType Interactive -RunLevel Limited
$settings = New-ScheduledTaskSettingsSet -MultipleInstances IgnoreNew -ExecutionTimeLimit (New-TimeSpan -Minutes 2)
Register-ScheduledTask -TaskName $TaskName -Action $action -Trigger $trigger -Principal $principal -Settings $settings -Description 'Processes constrained Doc Scan raw-download requests under OfficeAssistLogin without displaying a console.' -Force | Out-Null
Get-ScheduledTask -TaskName $TaskName | Select-Object TaskName,State,@{n='UserId';e={$_.Principal.UserId}},@{n='RunLevel';e={$_.Principal.RunLevel}},@{n='Execute';e={@($_.Actions)[0].Execute}},@{n='Arguments';e={@($_.Actions)[0].Arguments}}
