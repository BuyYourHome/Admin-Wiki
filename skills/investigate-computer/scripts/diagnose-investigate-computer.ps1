$ErrorActionPreference = 'Continue'

$outputRoot = 'C:\Users\wesbr\Documents\Security Incident Evidence\Investigate Computer'
New-Item -ItemType Directory -Force -Path $outputRoot | Out-Null

$stamp = Get-Date -Format 'yyyyMMdd-HHmmss'
$reportPath = Join-Path $outputRoot "investigate-computer-$stamp.md"
$jsonPath = Join-Path $outputRoot "investigate-computer-$stamp.json"

$knownRemoteAddresses = @('173.214.166.76', '52.20.40.101')
$knownRemotePorts = @(8041)
$folderPaths = @(
  'C:\Program Files (x86)\ScreenConnect Client (a2274db645c550f8)',
  'C:\Program Files\ScreenConnect',
  'C:\ProgramData\ScreenConnect',
  'C:\Program Files\RMM Agent',
  'C:\ProgramData\RMM Agent'
)

function ConvertTo-TableText {
  param($Value)
  if ($null -eq $Value -or @($Value).Count -eq 0) { return 'None found.' }
  return (($Value | Format-Table -AutoSize | Out-String).Trim())
}

$processes = Get-Process -Name 'ScreenConnect*','*RMM*' -ErrorAction SilentlyContinue |
  Select-Object Id, ProcessName, Path, StartTime

$services = Get-CimInstance Win32_Service |
  Where-Object {
    $_.Name -like '*ScreenConnect*' -or
    $_.DisplayName -like '*ScreenConnect*' -or
    $_.Name -like '*RMM*' -or
    $_.DisplayName -like '*RMM*'
  } |
  Select-Object Name, DisplayName, State, StartMode, PathName

$folders = $folderPaths | ForEach-Object {
  [pscustomobject]@{
    Path = $_
    Exists = Test-Path -LiteralPath $_
  }
}

$uninstallEntries = Get-ItemProperty `
  'HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*',
  'HKLM:\Software\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*',
  'HKCU:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*' `
  -ErrorAction SilentlyContinue |
  Where-Object {
    $_.DisplayName -like '*ScreenConnect*' -or
    $_.DisplayName -like '*RMM*'
  } |
  Select-Object DisplayName, DisplayVersion, Publisher, InstallLocation, UninstallString, SystemComponent

$startupEntries = Get-CimInstance Win32_StartupCommand |
  Where-Object {
    $_.Name -like '*ScreenConnect*' -or
    $_.Command -like '*ScreenConnect*' -or
    $_.Name -like '*RMM*' -or
    $_.Command -like '*RMM*'
  } |
  Select-Object Name, Command, Location, User

$scheduledTasks = @()
try {
  $scheduledTasks = Get-ScheduledTask -ErrorAction SilentlyContinue |
    Where-Object {
      $_.TaskName -like '*ScreenConnect*' -or
      $_.TaskPath -like '*ScreenConnect*' -or
      $_.TaskName -like '*RMM*' -or
      $_.TaskPath -like '*RMM*' -or
      ($_.Actions | Out-String) -like '*ScreenConnect*' -or
      ($_.Actions | Out-String) -like '*RMM*'
    } |
    Select-Object TaskName, TaskPath, State, Actions
} catch {
  $scheduledTasks = @([pscustomobject]@{ Error = $_.Exception.Message })
}

$connections = @()
try {
  $connections = Get-NetTCPConnection -State Established -ErrorAction SilentlyContinue |
    ForEach-Object {
      $process = Get-Process -Id $_.OwningProcess -ErrorAction SilentlyContinue
      [pscustomobject]@{
        LocalAddress = $_.LocalAddress
        LocalPort = $_.LocalPort
        RemoteAddress = $_.RemoteAddress
        RemotePort = $_.RemotePort
        PID = $_.OwningProcess
        Process = $process.ProcessName
      }
    } |
    Where-Object {
      $_.Process -like '*ScreenConnect*' -or
      $_.Process -like '*RMM*' -or
      $_.RemoteAddress -in $knownRemoteAddresses -or
      $_.RemotePort -in $knownRemotePorts
    }
} catch {
  $connections = @([pscustomobject]@{ Error = $_.Exception.Message })
}

$downloadIndicators = Get-ChildItem -LiteralPath 'C:\Users\wesbr\Downloads' `
  -Filter 'nsciotti_rmm_v2.4.0.68_oid972cd6b7-ceda-42fc-889f-8e5d1a4e7b65_bidbAdCnT-Gtk2-s8kVYe2EuA*.exe' `
  -ErrorAction SilentlyContinue |
  Select-Object FullName, Length, LastWriteTime

$summary = [pscustomobject]@{
  Created = (Get-Date).ToString('o')
  Computer = $env:COMPUTERNAME
  User = $env:USERNAME
  ProcessesFound = @($processes).Count
  ServicesFound = @($services).Count
  ExistingKnownFolders = @($folders | Where-Object Exists).Count
  UninstallEntriesFound = @($uninstallEntries).Count
  StartupEntriesFound = @($startupEntries).Count
  ScheduledTasksFound = @($scheduledTasks).Count
  SuspiciousConnectionsFound = @($connections).Count
  DownloadIndicatorsFound = @($downloadIndicators).Count
}

$result = [pscustomobject]@{
  Summary = $summary
  Processes = $processes
  Services = $services
  Folders = $folders
  UninstallEntries = $uninstallEntries
  StartupEntries = $startupEntries
  ScheduledTasks = $scheduledTasks
  Connections = $connections
  DownloadIndicators = $downloadIndicators
}

$result | ConvertTo-Json -Depth 8 | Set-Content -LiteralPath $jsonPath -Encoding UTF8

$report = @"
# Investigate Computer Diagnostic Report

Created: $($summary.Created)
Computer: $($summary.Computer)
User: $($summary.User)

## Summary

- ScreenConnect/RMM processes found: $($summary.ProcessesFound)
- ScreenConnect/RMM services found: $($summary.ServicesFound)
- Known remote-access folders still present: $($summary.ExistingKnownFolders)
- ScreenConnect/RMM uninstall entries found: $($summary.UninstallEntriesFound)
- ScreenConnect/RMM startup entries found: $($summary.StartupEntriesFound)
- ScreenConnect/RMM scheduled tasks found: $($summary.ScheduledTasksFound)
- Known suspicious active connections found: $($summary.SuspiciousConnectionsFound)
- Known suspicious RMM installer downloads found: $($summary.DownloadIndicatorsFound)

## Processes

~~~text
$(ConvertTo-TableText $processes)
~~~

## Services

~~~text
$(ConvertTo-TableText $services)
~~~

## Known Folders

~~~text
$(ConvertTo-TableText $folders)
~~~

## Uninstall Entries

~~~text
$(ConvertTo-TableText $uninstallEntries)
~~~

## Startup Entries

~~~text
$(ConvertTo-TableText $startupEntries)
~~~

## Scheduled Tasks

~~~text
$(ConvertTo-TableText $scheduledTasks)
~~~

## Known Suspicious Connections

~~~text
$(ConvertTo-TableText $connections)
~~~

## Known Download Indicators

~~~text
$(ConvertTo-TableText $downloadIndicators)
~~~

## Raw JSON

Raw structured output:

$jsonPath
"@

Set-Content -LiteralPath $reportPath -Value $report -Encoding UTF8
Write-Output $reportPath
