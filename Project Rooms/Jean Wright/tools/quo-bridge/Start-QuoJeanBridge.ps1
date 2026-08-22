[CmdletBinding()]
param()

$ErrorActionPreference = "Stop"

$label = "OfficeAssist Jean Instant Bridge"
$phoneNumberId = "PNH4YjkRKj"
$dataRoot = Join-Path $env:LOCALAPPDATA "BuyYourHome\Quo"
$quoCredentialPath = Join-Path $dataRoot "api-key.dpapi"
$webhookCredentialPath = Join-Path $dataRoot "webhook-key.dpapi"
$metadataPath = Join-Path $dataRoot "webhook.json"
$launcherLog = Join-Path $dataRoot "launcher.log"
$tunnelOutLog = Join-Path $dataRoot "cloudflared.out.log"
$tunnelErrorLog = Join-Path $dataRoot "cloudflared.error.log"
$listenerScript = "C:\Codex\Wiki Files\Project Rooms\Jean Wright\tools\quo-bridge\Invoke-QuoJeanBridge.ps1"

function Write-LauncherLog {
    param([string]$Message)
    Add-Content -LiteralPath $launcherLog -Value ("{0} {1}" -f [DateTime]::UtcNow.ToString("o"), $Message) -Encoding utf8
}

function Read-DpapiSecret {
    param([string]$Path)
    $secure = Get-Content -LiteralPath $Path | ConvertTo-SecureString
    $bstr = [Runtime.InteropServices.Marshal]::SecureStringToBSTR($secure)
    try { [Runtime.InteropServices.Marshal]::PtrToStringBSTR($bstr) }
    finally {
        if ($bstr -ne [IntPtr]::Zero) { [Runtime.InteropServices.Marshal]::ZeroFreeBSTR($bstr) }
    }
}

function Save-DpapiSecret {
    param([string]$Path, [string]$Value)
    $Value | ConvertTo-SecureString -AsPlainText -Force | ConvertFrom-SecureString | Set-Content -LiteralPath $Path -Encoding ascii
}

function Register-QuoWebhook {
    param([string]$PublicUrl)
    $key = Read-DpapiSecret -Path $quoCredentialPath
    try {
        $existing = Invoke-RestMethod -Method Get -Uri "https://api.quo.com/v1/webhooks" -Headers @{ Authorization = $key }
        $priorBridgeWebhooks = @($existing.data | Where-Object label -eq $label)
        $body = @{
            events = @("message.received")
            url = "$PublicUrl/quo"
            label = $label
            resourceIds = @($phoneNumberId)
            status = "enabled"
        } | ConvertTo-Json -Compress
        $created = Invoke-RestMethod -Method Post -Uri "https://api.quo.com/v1/webhooks/messages" `
            -Headers @{ Authorization = $key } -ContentType "application/json" -Body $body
        Save-DpapiSecret -Path $webhookCredentialPath -Value $created.data.key
        foreach ($webhook in $priorBridgeWebhooks) {
            Invoke-RestMethod -Method Delete -Uri "https://api.quo.com/v1/webhooks/$($webhook.id)" -Headers @{ Authorization = $key } | Out-Null
        }
        [pscustomobject]@{
            schema_version = 1
            webhook_id = $created.data.id
            label = $label
            public_url = $PublicUrl
            endpoint = "$PublicUrl/quo"
            registered_at_utc = [DateTime]::UtcNow.ToString("o")
        } | ConvertTo-Json -Depth 5 | Set-Content -LiteralPath $metadataPath -Encoding utf8
        $created.data.id
    }
    finally { Remove-Variable key -ErrorAction SilentlyContinue }
}

New-Item -ItemType Directory -Path $dataRoot -Force | Out-Null
if ($env:COMPUTERNAME -ne "OFFICEASSIST") { throw "This launcher must run on OFFICEASSIST." }
foreach ($required in @($quoCredentialPath, $listenerScript)) {
    if (-not (Test-Path -LiteralPath $required)) { throw "Required bridge dependency is missing: $required" }
}

$cloudflaredCommand = Get-Command cloudflared.exe -ErrorAction Stop
Remove-Item -LiteralPath $tunnelOutLog, $tunnelErrorLog -Force -ErrorAction SilentlyContinue

$listenerArguments = "-NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -File `"$listenerScript`""
$listener = Start-Process -FilePath "powershell.exe" -ArgumentList $listenerArguments -WindowStyle Hidden -PassThru
$tunnel = Start-Process -FilePath $cloudflaredCommand.Source -ArgumentList @(
    "tunnel", "--no-autoupdate", "--url", "http://127.0.0.1:8787"
) -WindowStyle Hidden -RedirectStandardError $tunnelErrorLog -RedirectStandardOutput $tunnelOutLog -PassThru

try {
    $deadline = [DateTime]::UtcNow.AddSeconds(45)
    $publicUrl = $null
    while ([DateTime]::UtcNow -lt $deadline -and -not $publicUrl) {
        if ($listener.HasExited) { throw "Local bridge listener exited with code $($listener.ExitCode)." }
        if ($tunnel.HasExited) { throw "Cloudflare tunnel exited with code $($tunnel.ExitCode)." }
        foreach ($log in @($tunnelErrorLog, $tunnelOutLog)) {
            if (Test-Path -LiteralPath $log) {
                $match = Select-String -LiteralPath $log -Pattern "https://[-a-z0-9]+\.trycloudflare\.com" -AllMatches | Select-Object -Last 1
                if ($match) { $publicUrl = $match.Matches[0].Value; break }
            }
        }
        if (-not $publicUrl) { Start-Sleep -Milliseconds 500 }
    }
    if (-not $publicUrl) { throw "Cloudflare quick tunnel did not provide a public URL within 45 seconds." }

    $webhookId = Register-QuoWebhook -PublicUrl $publicUrl
    Write-LauncherLog "Registered Quo webhook $webhookId through $publicUrl."

    while (-not $listener.HasExited -and -not $tunnel.HasExited) { Start-Sleep -Seconds 2 }
    if ($listener.HasExited) { throw "Local bridge listener exited with code $($listener.ExitCode)." }
    throw "Cloudflare tunnel exited with code $($tunnel.ExitCode)."
}
catch {
    Write-LauncherLog "Launcher failed: $($_.Exception.Message)"
    throw
}
finally {
    foreach ($process in @($listener, $tunnel)) {
        if ($process -and -not $process.HasExited) { Stop-Process -Id $process.Id -Force -ErrorAction SilentlyContinue }
    }
}
