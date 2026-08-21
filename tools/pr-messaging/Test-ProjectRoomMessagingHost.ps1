[CmdletBinding()]
param(
    [string]$QueuePath = "\\WES-VIDEOEDITOR\BYH-PRMessaging$",
    [string]$SpoolPath = (Join-Path $env:LOCALAPPDATA "BuyYourHome\PRMessaging\spool")
)

$manager = Join-Path $PSScriptRoot "Manage-ProjectRoomMessage.ps1"
$health = & $manager -Action Health -QueuePath $QueuePath -SpoolPath $SpoolPath | ConvertFrom-Json
$share = Get-SmbConnection -ServerName "WES-VIDEOEDITOR" -ErrorAction SilentlyContinue | Where-Object { $_.ShareName -eq "BYH-PRMessaging$" } | Select-Object -First 1
[pscustomobject]@{
    host_available = [bool]$health.available
    queue_path = $QueuePath
    smb_dialect = if ($share) { $share.Dialect } else { $null }
    smb_encrypted = if ($share) { [bool]$share.Encrypted } else { $null }
    total_messages = $health.total_messages
    attention_messages = $health.attention_messages
    pending_local_spool = $health.pending_local_spool
    checked_at_utc = [DateTime]::UtcNow.ToString("o")
} | ConvertTo-Json
