param(
    [string]$WikiRoot = "C:\Codex\Wiki Files",
    [string]$CodexHome = "$env:USERPROFILE\.codex",
    [string]$ExpectedMachine = "WES-VIDEOEDITOR"
)

$ErrorActionPreference = "Stop"

function Get-DirectoryHash {
    param([Parameter(Mandatory = $true)][string]$Root)

    if (-not (Test-Path -LiteralPath $Root -PathType Container)) {
        return $null
    }

    $entries = Get-ChildItem -LiteralPath $Root -Recurse -File |
        Sort-Object FullName |
        ForEach-Object {
            $relative = [System.IO.Path]::GetRelativePath($Root, $_.FullName).Replace("\", "/")
            $fileHash = (Get-FileHash -Algorithm SHA256 -LiteralPath $_.FullName).Hash
            "$relative|$fileHash"
        }

    $bytes = [System.Text.Encoding]::UTF8.GetBytes(($entries -join "`n"))
    $sha = [System.Security.Cryptography.SHA256]::Create()
    try {
        return ([System.BitConverter]::ToString($sha.ComputeHash($bytes))).Replace("-", "")
    }
    finally {
        $sha.Dispose()
    }
}

$skillName = "quickbooks-invoice"
$sourcePath = Join-Path $WikiRoot "skills\$skillName"
$installedPath = Join-Path $CodexHome "skills\$skillName"
$sourceHash = Get-DirectoryHash -Root $sourcePath
$installedHash = Get-DirectoryHash -Root $installedPath

$skillCommit = (& git -C $WikiRoot log -1 --format=%H -- "skills/$skillName").Trim()
$published = $false
if ($skillCommit) {
    & git -C $WikiRoot merge-base --is-ancestor $skillCommit origin/main 2>$null
    $published = ($LASTEXITCODE -eq 0)
}

$machine = [Environment]::MachineName
$installedMatch = $null -ne $sourceHash -and $sourceHash -eq $installedHash
$machineMatch = $machine -ieq $ExpectedMachine

[ordered]@{
    skill = $skillName
    checked_at_utc = [DateTime]::UtcNow.ToString("o")
    machine = $machine
    expected_machine = $ExpectedMachine
    machine_match = $machineMatch
    canonical_path = $sourcePath
    installed_path = $installedPath
    canonical_tree_sha256 = $sourceHash
    installed_tree_sha256 = $installedHash
    installed_match = $installedMatch
    canonical_skill_commit = $skillCommit
    commit_published_to_origin_main = $published
    machine_installation_ready = ($machineMatch -and $installedMatch -and $published)
    new_session_activation = "must be recorded separately after a newly started task reads the installed skill"
} | ConvertTo-Json -Depth 4
