param([string]$RepositoryRoot = 'C:\Codex\Wiki Files')

$ErrorActionPreference = 'Stop'
$projectRoomsRoot = Join-Path $RepositoryRoot 'Project Rooms'
$outputPath = Join-Path $projectRoomsRoot 'Dashboard\site\project-rooms.js'
$groups = @{
    'Jean Wright'='Intake & Coordination'; 'Email Monitor'='Intake & Coordination'; 'Create PR'='Intake & Coordination'; 'Dashboard'='Intake & Coordination'
    'Doc Scan'='Document Intake'; 'SOPs'='Document Intake'
    'Invoice Entry'='Accounting & Project Data'; 'Template to Project'='Accounting & Project Data'; 'Project Management Spreadsheet Rewrite'='Accounting & Project Data'; 'Amortization'='Accounting & Project Data'
    'New Project'='Real Estate Transactions'; 'Contract for Deed'='Real Estate Transactions'; 'Credit Worthiness Evaluator'='Real Estate Transactions'; 'CMA Report'='Real Estate Transactions'; 'Property Trade Evaluation'='Real Estate Transactions'
    'Operating Agreements'='Legal & Entity'; 'Entity Relationship'='Legal & Entity'; 'Brynda Suit'='Legal & Entity'; 'Confidential'='Legal & Entity'; 'Estate Documents'='Legal & Entity'; 'Geico Insurance Claim'='Legal & Entity'
    'Gracious Millionaire'='Publishing & Public Work'; 'REI BlackBook'='Publishing & Public Work'; 'LD Evans'='Publishing & Public Work'; 'Jennys Drawings'='Publishing & Public Work'; 'Voices'='Publishing & Public Work'
    'AIOS'='Systems & Maintenance'; 'Codex Environment'='Systems & Maintenance'; 'Computers'='Systems & Maintenance'; 'Investigate Computer'='Systems & Maintenance'; 'Marketplace'='Systems & Maintenance'; 'Lowes Order'='Systems & Maintenance'; 'Manager'='Systems & Maintenance'
}

function Get-SectionText {
    param([string]$Text, [string]$Heading)
    $pattern = "(?ms)^##\s+$([regex]::Escape($Heading))\s*\r?\n(.*?)(?=^##\s+|\z)"
    $match = [regex]::Match($Text, $pattern)
    if (-not $match.Success) { return $null }
    $lines = $match.Groups[1].Value -split '\r?\n' | ForEach-Object { $_.Trim() } | Where-Object { $_ -and -not $_.StartsWith('#') -and -not $_.StartsWith('|') }
    return ((($lines | Select-Object -First 3) -join ' ') -replace '^[-*]\s*', '' -replace '`', '').Trim()
}

$rooms = foreach ($directory in Get-ChildItem -LiteralPath $projectRoomsRoot -Directory | Sort-Object Name) {
    $readme = Join-Path $directory.FullName 'README.md'
    if (-not (Test-Path -LiteralPath $readme)) { continue }
    $text = Get-Content -LiteralPath $readme -Raw
    $purpose = Get-SectionText -Text $text -Heading 'Purpose'
    if (-not $purpose) { $purpose = 'Canonical Project Room; open its README for current responsibilities.' }
    $statusMatch = [regex]::Match($text, '(?im)^Status:\s*([^\r\n.]+)')
    $skillMatch = [regex]::Match($text, 'skills\\([^\\`\r\n]+)\\SKILL\.md')
    [ordered]@{
        name = $directory.Name
        purpose = $purpose
        status = if ($statusMatch.Success) { $statusMatch.Groups[1].Value.Trim() } else { 'Status not recorded' }
        skill = if ($skillMatch.Success) { $skillMatch.Groups[1].Value } else { '' }
        group = if ($groups.ContainsKey($directory.Name)) { $groups[$directory.Name] } else { 'Other' }
        readmeUrl = "../../$([uri]::EscapeDataString($directory.Name))/README.md"
    }
}

$json = $rooms | ConvertTo-Json -Depth 5
$bytes = [System.Text.UTF8Encoding]::new($false).GetBytes($json)
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
$content = "window.PROJECT_ROOMS_UPDATED = '$stamp';`r`nwindow.PROJECT_ROOMS_HASH = '$contentHash';`r`nwindow.PROJECT_ROOMS = $json;`r`n"
[System.IO.File]::WriteAllText($outputPath, $content, [System.Text.UTF8Encoding]::new($false))
Write-Output "Dashboard index refreshed: $($rooms.Count) Project Rooms -> $outputPath"
