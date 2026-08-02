param([string]$RepositoryRoot = 'C:\Codex\Wiki Files')

$ErrorActionPreference = 'Stop'
$projectRoomsRoot = Join-Path $RepositoryRoot 'Project Rooms'
$outputPath = Join-Path $projectRoomsRoot 'Dashboard\site\project-rooms.js'
$groupConfigPath = Join-Path $projectRoomsRoot 'Dashboard\config\project-room-groups.json'
$groupConfig = Get-Content -LiteralPath $groupConfigPath -Raw | ConvertFrom-Json
$groupDefinitions = @($groupConfig.groups)
$groupNames = @($groupDefinitions | ForEach-Object { $_.name })
$groupAssignments = @{}
$groupConfig.assignments.PSObject.Properties | ForEach-Object { $groupAssignments[$_.Name] = $_.Value }

function Get-SectionText {
    param([string]$Text, [string]$Heading)
    $pattern = "(?ms)^##\s+$([regex]::Escape($Heading))\s*\r?\n(.*?)(?=^##\s+|\z)"
    $match = [regex]::Match($Text, $pattern)
    if (-not $match.Success) { return $null }
    $lines = $match.Groups[1].Value -split '\r?\n' | ForEach-Object { $_.Trim() } | Where-Object { $_ -and -not $_.StartsWith('#') -and -not $_.StartsWith('|') }
    return ((($lines | Select-Object -First 3) -join ' ') -replace '^[-*]\s*', '' -replace '`', '').Trim()
}

function Get-DocumentedModes {
    param([string[]]$Documents)
    $modes = [System.Collections.Generic.List[string]]::new()
    foreach ($document in $Documents) {
        if (-not $document) { continue }
        $lines = $document -split '\r?\n'
        $inModeSection = $false
        foreach ($line in $lines) {
            if ($line -match '^##\s+(.+?)\s*$') {
                $heading = $Matches[1].Trim()
                $inModeSection = $heading -in @('Modes', 'Supported Modes', 'Operating Modes')
                if ($heading -match '\bMode$' -and -not $modes.Contains($heading)) { $modes.Add($heading) }
                continue
            }
            if ($line -match '^###\s+(.+?)\s*$') {
                $heading = $Matches[1].Trim()
                if (($inModeSection -or $heading -match '\bMode$') -and -not $modes.Contains($heading)) { $modes.Add($heading) }
                continue
            }
            if ($inModeSection -and $line -match '^\d+\.\s+\*\*(.+?)\*\*') {
                $mode = $Matches[1].Trim()
                if (-not $modes.Contains($mode)) { $modes.Add($mode) }
            }
        }
    }
    return @($modes)
}

$rooms = foreach ($directory in Get-ChildItem -LiteralPath $projectRoomsRoot -Directory | Sort-Object Name) {
    $readme = Join-Path $directory.FullName 'README.md'
    if (-not (Test-Path -LiteralPath $readme)) { continue }
    $text = Get-Content -LiteralPath $readme -Raw
    $purpose = Get-SectionText -Text $text -Heading 'Purpose'
    if (-not $purpose) { $purpose = 'Canonical Project Room; open its README for current responsibilities.' }
    $statusMatch = [regex]::Match($text, '(?im)^Status:\s*([^\r\n.]+)')
    $skillMatch = [regex]::Match($text, 'skills\\([^\\`\r\n]+)\\SKILL\.md')
    $skillName = if ($skillMatch.Success) { $skillMatch.Groups[1].Value } else { '' }
    $skillText = ''
    if ($skillName) {
        $skillPath = Join-Path $RepositoryRoot "skills\$skillName\SKILL.md"
        if (Test-Path -LiteralPath $skillPath) { $skillText = Get-Content -LiteralPath $skillPath -Raw }
    }
    $modes = Get-DocumentedModes -Documents @($text, $skillText)
    $group = if ($groupAssignments.ContainsKey($directory.Name) -and $groupNames -contains $groupAssignments[$directory.Name]) { $groupAssignments[$directory.Name] } else { 'Other' }
    $groupDefinition = $groupDefinitions | Where-Object { $_.name -eq $group } | Select-Object -First 1
    $quickActions = @()
    if ($directory.Name -eq 'Entity Relationship') {
        $quickActions += [ordered]@{
            label = 'Open relationship diagram'
            href = '../../Entity%20Relationship/outputs/entity-relationship-chart.svg'
        }
    }
    [ordered]@{
        name = $directory.Name
        purpose = $purpose
        status = if ($statusMatch.Success) { $statusMatch.Groups[1].Value.Trim() } else { 'Status not recorded' }
        skill = $skillName
        group = $group
        groupBasis = $groupDefinition.basis
        modes = @($modes)
        readmeUrl = "../../$([uri]::EscapeDataString($directory.Name))/README.md"
        quickActions = @($quickActions)
    }
}

$json = $rooms | ConvertTo-Json -Depth 6
$groupsJson = $groupDefinitions | ConvertTo-Json -Depth 4
$indexData = "$groupsJson`n$json"
$bytes = [System.Text.UTF8Encoding]::new($false).GetBytes($indexData)
$hasher = [System.Security.Cryptography.SHA256]::Create()
try { $contentHash = ([System.BitConverter]::ToString($hasher.ComputeHash($bytes))).Replace('-', '') } finally { $hasher.Dispose() }
if (Test-Path -LiteralPath $outputPath) {
    $existing = Get-Content -LiteralPath $outputPath -Raw
    $existingHash = [regex]::Match($existing, "(?m)^window\.PROJECT_ROOMS_HASH = '([A-F0-9]+)';\r?$")
    if ($existingHash.Success -and $existingHash.Groups[1].Value -eq $contentHash) {
        Write-Output "Dashboard index unchanged: $($rooms.Count) Project Rooms"
        return
    }
}
$stamp = Get-Date -Format 'yyyy-MM-dd HH:mm'
$content = "window.PROJECT_ROOMS_UPDATED = '$stamp';`r`nwindow.PROJECT_ROOMS_HASH = '$contentHash';`r`nwindow.PROJECT_ROOM_GROUPS = $groupsJson;`r`nwindow.PROJECT_ROOMS = $json;`r`n"
[System.IO.File]::WriteAllText($outputPath, $content, [System.Text.UTF8Encoding]::new($false))
Write-Output "Dashboard index refreshed: $($rooms.Count) Project Rooms -> $outputPath"
