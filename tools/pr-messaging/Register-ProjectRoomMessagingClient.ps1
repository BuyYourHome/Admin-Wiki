[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [string]$ProjectRoom,
    [Parameter(Mandatory = $true)]
    [string]$TaskId,
    [string]$QueuePath = "\\WES-VIDEOEDITOR\BYH-PRMessaging$",
    [string]$ConfigPath = (Join-Path $env:LOCALAPPDATA "BuyYourHome\PRMessaging\client.json")
)

$ErrorActionPreference = "Stop"
if (-not (Test-Path -LiteralPath $QueuePath)) { throw "PR messaging host is unavailable or access is denied: $QueuePath" }
$directory = Split-Path -Parent $ConfigPath
New-Item -ItemType Directory -Path $directory -Force | Out-Null
$existing = if (Test-Path -LiteralPath $ConfigPath) { Get-Content -Raw -LiteralPath $ConfigPath | ConvertFrom-Json } else { $null }
$registrations = if ($existing) { @($existing.registrations) } else { @() }
$registrations = @($registrations | Where-Object { $_.task_id -ne $TaskId })
$registrations += [pscustomobject][ordered]@{ project_room = $ProjectRoom; task_id = $TaskId; registered_at_utc = [DateTime]::UtcNow.ToString("o") }
$config = [pscustomobject][ordered]@{
    schema_version = 1
    machine = $env:COMPUTERNAME
    queue_path = $QueuePath
    spool_path = (Join-Path $env:LOCALAPPDATA "BuyYourHome\PRMessaging\spool")
    registrations = $registrations
}
$tempPath = "$ConfigPath.tmp"
$config | ConvertTo-Json -Depth 10 | Set-Content -LiteralPath $tempPath -Encoding UTF8
Move-Item -LiteralPath $tempPath -Destination $ConfigPath -Force
$config | ConvertTo-Json -Depth 10
