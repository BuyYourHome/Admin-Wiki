[CmdletBinding()]
param()

$ErrorActionPreference = "Stop"

$taskName = "Codex - Quo Jean Instant Bridge"
$launcherPath = "C:\Codex\Wiki Files\Project Rooms\Jean Wright\tools\quo-bridge\Start-QuoJeanBridge.ps1"
$listenerPath = "C:\Codex\Wiki Files\Project Rooms\Jean Wright\tools\quo-bridge\Invoke-QuoJeanBridge.ps1"
$dataRoot = Join-Path $env:LOCALAPPDATA "BuyYourHome\Quo"
$quoCredentialPath = Join-Path $dataRoot "api-key.dpapi"
$openAiCredentialPath = Join-Path $dataRoot "openai-api-key.dpapi"
$metadataPath = Join-Path $dataRoot "webhook.json"

if ($env:COMPUTERNAME -ne "OFFICEASSIST") { throw "This installer must run on OFFICEASSIST." }
foreach ($required in @($launcherPath, $listenerPath, $quoCredentialPath, $openAiCredentialPath)) {
    if (-not (Test-Path -LiteralPath $required)) { throw "Required bridge dependency is missing: $required" }
}
if (-not (Get-Command cloudflared.exe -ErrorAction SilentlyContinue)) {
    throw "cloudflared.exe is not installed or is not available on PATH."
}

foreach ($script in @($launcherPath, $listenerPath)) {
    $tokens = $null
    $errors = $null
    [Management.Automation.Language.Parser]::ParseFile($script, [ref]$tokens, [ref]$errors) | Out-Null
    if ($errors.Count -gt 0) { throw "PowerShell syntax validation failed for ${script}: $($errors[0].Message)" }
}

$selfTest = & powershell.exe -NoProfile -ExecutionPolicy Bypass -File $listenerPath -SelfTest
if (-not $selfTest) { throw "OpenAI bridge self-test returned no result." }

$action = New-ScheduledTaskAction -Execute "powershell.exe" -Argument ("-NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -File `"{0}`"" -f $launcherPath)
$trigger = New-ScheduledTaskTrigger -AtLogOn -User "$env:USERDOMAIN\$env:USERNAME"
$settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries `
    -ExecutionTimeLimit ([TimeSpan]::Zero) -RestartCount 10 -RestartInterval (New-TimeSpan -Minutes 1)
$principal = New-ScheduledTaskPrincipal -UserId "$env:USERDOMAIN\$env:USERNAME" -LogonType Interactive -RunLevel Limited

Register-ScheduledTask -TaskName $taskName -Action $action -Trigger $trigger -Settings $settings -Principal $principal -Force | Out-Null
Start-ScheduledTask -TaskName $taskName

$deadline = [DateTime]::UtcNow.AddSeconds(60)
while ([DateTime]::UtcNow -lt $deadline -and -not (Test-Path -LiteralPath $metadataPath)) { Start-Sleep -Seconds 1 }
$task = Get-ScheduledTask -TaskName $taskName
$info = Get-ScheduledTaskInfo -TaskName $taskName
$metadata = if (Test-Path -LiteralPath $metadataPath) { Get-Content -Raw -LiteralPath $metadataPath | ConvertFrom-Json } else { $null }

[pscustomobject]@{
    task_name = $taskName
    task_state = [string]$task.State
    last_task_result = $info.LastTaskResult
    webhook_registered = ($null -ne $metadata)
    webhook_id = if ($metadata) { $metadata.webhook_id } else { $null }
    endpoint = if ($metadata) { $metadata.endpoint } else { $null }
    model = "gpt-5-mini"
}
