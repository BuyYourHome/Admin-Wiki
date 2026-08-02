param([string]$RepositoryRoot = 'C:\Codex\Wiki Files')

$ErrorActionPreference = 'Stop'
$projectRoomsRoot = Join-Path $RepositoryRoot 'Project Rooms'
$outputPath = Join-Path $projectRoomsRoot 'Dashboard\site\project-rooms.js'
$groupConfigPath = Join-Path $projectRoomsRoot 'Dashboard\config\project-room-groups.json'
$attentionConfigPath = Join-Path $projectRoomsRoot 'Dashboard\config\project-room-attention.json'
$actionsConfigPath = Join-Path $projectRoomsRoot 'Dashboard\config\dashboard-actions.json'
$sopIndexPath = Join-Path $projectRoomsRoot 'SOPs\outputs\SOP Index.md'
$sopPagesPath = Join-Path $projectRoomsRoot 'SOPs\outputs\SOPs'
$groupConfig = Get-Content -LiteralPath $groupConfigPath -Raw | ConvertFrom-Json
$attentionConfig = Get-Content -LiteralPath $attentionConfigPath -Raw | ConvertFrom-Json
$actionsConfig = Get-Content -LiteralPath $actionsConfigPath -Raw | ConvertFrom-Json
$groupDefinitions = @($groupConfig.groups)
$groupNames = @($groupDefinitions | ForEach-Object { $_.name })
$groupAssignments = @{}
$groupConfig.assignments.PSObject.Properties | ForEach-Object { $groupAssignments[$_.Name] = $_.Value }
$attentionByRoom = @{}
foreach ($item in @($attentionConfig.items)) {
    if ($item.room -and $item.type -in @('confirmation-needed', 'approval-needed') -and $item.reason -and $item.source) {
        $attentionByRoom[$item.room] = [ordered]@{
            type = $item.type
            reason = $item.reason
            source = $item.source
            updatedAt = $item.updatedAt
        }
    }
}

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

function Get-SopViewerEntries {
    param([string]$IndexPath, [string]$PagesPath)

    if (-not (Test-Path -LiteralPath $IndexPath) -or -not (Test-Path -LiteralPath $PagesPath)) { return @() }
    $pagesByKey = @{}
    Get-ChildItem -LiteralPath $PagesPath -Filter '*.md' -File | ForEach-Object {
        if ($_.BaseName -match '^SOP - Item\s+(?<item>\d+)\s+-\s+(?<task>.+)$') {
            $key = "{0}|{1}" -f ([int]$Matches.item), $Matches.task.Trim().ToLowerInvariant()
            $pagesByKey[$key] = $_
        }
    }

    $indexText = Get-Content -LiteralPath $IndexPath -Raw
    $sopSection = [regex]::Match($indexText, '(?ms)^##\s+SOPs\s*\r?\n(.*?)(?=^##\s+Maintenance Queue)')
    $entries = [System.Collections.Generic.List[object]]::new()
    if ($sopSection.Success) {
        foreach ($line in ($sopSection.Groups[1].Value -split '\r?\n')) {
            if ($line -notmatch '^\|\s*(?<item>\d+)\s*\|\s*(?<category>[^|]*)\|\s*(?<task>[^|]*)\|') { continue }
            $item = [int]$Matches.item
            $task = $Matches.task.Trim()
            if (-not $task -or $task -eq 'N/A') { continue }
            $key = "{0}|{1}" -f $item, $task.ToLowerInvariant()
            $page = $pagesByKey[$key]
            $entries.Add([ordered]@{
                label = ('Item {0:D3} - {1}' -f $item, $task)
                available = [bool]$page
                href = if ($page) { '../../SOPs/outputs/SOPs/' + [uri]::EscapeDataString($page.Name) } else { $null }
            })
        }
    }
    return @($entries)
}

$sopViewerEntries = Get-SopViewerEntries -IndexPath $sopIndexPath -PagesPath $sopPagesPath

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
    $skillPath = ''
    $skillState = 'not-applicable'
    if ($skillName) {
        $skillPath = Join-Path $RepositoryRoot "skills\$skillName\SKILL.md"
        if (Test-Path -LiteralPath $skillPath) {
            $skillText = Get-Content -LiteralPath $skillPath -Raw
            $skillState = 'available'
        } else {
            $skillState = 'missing'
        }
    }
    $taskMatch = [regex]::Match($text, '(?i)(?:task|thread)\s+id[^0-9a-f]*([0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12})')
    $taskId = if ($taskMatch.Success) { $taskMatch.Groups[1].Value } else { '' }
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
    if ($directory.Name -eq 'Gracious Millionaire') {
        $quickActions += [ordered]@{
            label = 'Open GraciousMillionaire.com'
            href = 'https://graciousmillionaire.com'
        }
    }
    $room = [ordered]@{
        name = $directory.Name
        purpose = $purpose
        status = if ($statusMatch.Success) { $statusMatch.Groups[1].Value.Trim() } else { 'Status not recorded' }
        skill = $skillName
        skillPath = $skillPath
        skillState = $skillState
        taskId = $taskId
        attention = if ($attentionByRoom.ContainsKey($directory.Name)) { $attentionByRoom[$directory.Name] } else { $null }
        group = $group
        groupBasis = $groupDefinition.basis
        modes = @($modes)
        readmeUrl = "../../$([uri]::EscapeDataString($directory.Name))/README.md"
        quickActions = @($quickActions)
    }
    if ($directory.Name -eq 'SOPs') { $room.sopEntries = @($sopViewerEntries) }
    $room
}

$json = $rooms | ConvertTo-Json -Depth 6
$groupsJson = $groupDefinitions | ConvertTo-Json -Depth 4
$actionsJson = $actionsConfig | ConvertTo-Json -Depth 4
$indexData = "$groupsJson`n$actionsJson`n$json"
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
$content = "window.PROJECT_ROOMS_UPDATED = '$stamp';`r`nwindow.PROJECT_ROOMS_HASH = '$contentHash';`r`nwindow.PROJECT_ROOM_GROUPS = $groupsJson;`r`nwindow.DASHBOARD_ACTIONS = $actionsJson;`r`nwindow.PROJECT_ROOMS = $json;`r`n"
[System.IO.File]::WriteAllText($outputPath, $content, [System.Text.UTF8Encoding]::new($false))
Write-Output "Dashboard index refreshed: $($rooms.Count) Project Rooms -> $outputPath"
