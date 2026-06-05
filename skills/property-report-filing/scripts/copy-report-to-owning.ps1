param(
    [Parameter(Mandatory = $true)]
    [string]$ReportPath,

    [Parameter(Mandatory = $true)]
    [string]$PropertyQuery,

    [string]$PropertyRoot = "C:\Users\wesbr\Buy Your Home\Buy Your Home - Property",

    [switch]$Force
)

$ErrorActionPreference = "Stop"

function Normalize-Text {
    param([string]$Value)
    return ($Value.ToLowerInvariant() -replace '[^a-z0-9]+', ' ').Trim()
}

if (-not (Test-Path -LiteralPath $ReportPath)) {
    throw "Report file not found: $ReportPath"
}

if (-not (Test-Path -LiteralPath $PropertyRoot)) {
    throw "Property root not found: $PropertyRoot"
}

$resolvedReport = (Resolve-Path -LiteralPath $ReportPath).Path
$query = Normalize-Text $PropertyQuery
$tokens = @($query -split '\s+' | Where-Object { $_.Length -ge 3 })

if ($tokens.Count -eq 0) {
    throw "Property query is too short to match safely: $PropertyQuery"
}

$properties = Get-ChildItem -LiteralPath $PropertyRoot -Directory
$matches = foreach ($property in $properties) {
    $name = Normalize-Text $property.Name
    $score = 0
    foreach ($token in $tokens) {
        if ($name.Contains($token)) {
            $score++
        }
    }
    if ($score -gt 0) {
        [pscustomobject]@{
            Path = $property.FullName
            Name = $property.Name
            Score = $score
        }
    }
}

$bestScore = ($matches | Measure-Object -Property Score -Maximum).Maximum
$bestMatches = @($matches | Where-Object { $_.Score -eq $bestScore })

if ($bestMatches.Count -eq 0) {
    throw "No property folder matched '$PropertyQuery' under $PropertyRoot"
}

if ($bestMatches.Count -gt 1) {
    $names = ($bestMatches | Select-Object -ExpandProperty Name) -join '; '
    throw "Multiple property folders matched '$PropertyQuery': $names"
}

$owning = Join-Path $bestMatches[0].Path "Owning"
if (-not (Test-Path -LiteralPath $owning)) {
    throw "Matched property folder does not contain an Owning folder: $($bestMatches[0].Path)"
}

$fileName = Split-Path -Leaf $resolvedReport
$destination = Join-Path $owning $fileName

if (Test-Path -LiteralPath $destination) {
    if ($Force) {
        Remove-Item -LiteralPath $destination -Force
    } else {
        $base = [System.IO.Path]::GetFileNameWithoutExtension($fileName)
        $ext = [System.IO.Path]::GetExtension($fileName)
        $stamp = Get-Date -Format "yyyyMMdd_HHmmss"
        $destination = Join-Path $owning "$base - copy $stamp$ext"
    }
}

Copy-Item -LiteralPath $resolvedReport -Destination $destination

[pscustomobject]@{
    ReportPath = $resolvedReport
    PropertyFolder = $bestMatches[0].Path
    OwningFolder = $owning
    DestinationPath = $destination
}
