param(
    [string]$WikiRoot = "C:\Codex\Wiki Files",
    [string]$CodexHome = "$env:USERPROFILE\.codex",
    [switch]$WhatIf
)

$ErrorActionPreference = "Stop"

$sourceRoot = Join-Path $WikiRoot "skills"
$targetRoot = Join-Path $CodexHome "skills"

if (-not (Test-Path -LiteralPath $sourceRoot)) {
    throw "Wiki skills folder not found: $sourceRoot"
}

if (-not (Test-Path -LiteralPath $targetRoot)) {
    if ($WhatIf) {
        Write-Host "Would create $targetRoot"
    } else {
        New-Item -ItemType Directory -Path $targetRoot -Force | Out-Null
    }
}

$skills = Get-ChildItem -LiteralPath $sourceRoot -Directory | Where-Object {
    Test-Path -LiteralPath (Join-Path $_.FullName "SKILL.md")
}

foreach ($skill in $skills) {
    $target = Join-Path $targetRoot $skill.Name
    if ($WhatIf) {
        Write-Host "Would sync $($skill.FullName) -> $target"
        continue
    }

    if (Test-Path -LiteralPath $target) {
        Remove-Item -LiteralPath $target -Recurse -Force
    }

    Copy-Item -LiteralPath $skill.FullName -Destination $target -Recurse -Force
    Write-Host "Synced $($skill.Name)"
}

Write-Host "Codex skill sync complete."
