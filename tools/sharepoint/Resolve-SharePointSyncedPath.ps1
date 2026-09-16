[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [ValidatePattern('^https://')]
    [string]$SiteUrl,

    [Parameter(Mandatory = $true)]
    [string]$CanonicalRelativePath,

    [string[]]$ExpectedChild = @(),

    [string[]]$AdditionalRoot = @(),

    [switch]$AdditionalRootsOnly,

    [switch]$AsJson
)

$ErrorActionPreference = 'Stop'
Set-StrictMode -Version Latest

function Add-ExistingRoot {
    param(
        [System.Collections.Generic.List[string]]$Roots,
        [string]$Path
    )

    if ([string]::IsNullOrWhiteSpace($Path)) {
        return
    }

    if (Test-Path -LiteralPath $Path -PathType Container) {
        $resolved = (Resolve-Path -LiteralPath $Path).Path.TrimEnd('\')
        if (-not $Roots.Contains($resolved)) {
            $Roots.Add($resolved)
        }
    }
}

$suppliedRelativePath = $CanonicalRelativePath.Replace('/', '\').Trim()
if ([IO.Path]::IsPathRooted($suppliedRelativePath)) {
    throw 'CanonicalRelativePath must be relative, not a Windows or UNC path.'
}

$relative = $suppliedRelativePath.TrimStart('\')
if ([string]::IsNullOrWhiteSpace($relative)) {
    throw 'CanonicalRelativePath must identify a folder beneath the SharePoint site.'
}

if (@($relative -split '\\' | Where-Object { $_ -eq '.' -or $_ -eq '..' }).Count -gt 0) {
    throw 'CanonicalRelativePath may not contain current-directory or parent-directory segments.'
}

$roots = [System.Collections.Generic.List[string]]::new()
foreach ($root in $AdditionalRoot) {
    Add-ExistingRoot -Roots $roots -Path $root
}

if (-not $AdditionalRootsOnly) {
    foreach ($environmentName in 'OneDriveCommercial', 'OneDrive') {
        Add-ExistingRoot -Roots $roots -Path ([Environment]::GetEnvironmentVariable($environmentName, 'Process'))
        Add-ExistingRoot -Roots $roots -Path ([Environment]::GetEnvironmentVariable($environmentName, 'User'))
    }

    $accountsPath = 'HKCU:\Software\Microsoft\OneDrive\Accounts'
    if (Test-Path -LiteralPath $accountsPath) {
        foreach ($account in Get-ChildItem -LiteralPath $accountsPath -ErrorAction SilentlyContinue) {
            $properties = Get-ItemProperty -LiteralPath $account.PSPath -ErrorAction SilentlyContinue
            if ($null -ne $properties -and $null -ne $properties.PSObject.Properties['UserFolder']) {
                Add-ExistingRoot -Roots $roots -Path ([string]$properties.PSObject.Properties['UserFolder'].Value)
            }
        }
    }

    Add-ExistingRoot -Roots $roots -Path (Join-Path $env:USERPROFILE 'Buy Your Home')
}

if ($roots.Count -eq 0) {
    throw 'No registered or supplied OneDrive/SharePoint sync roots were found for the current Windows identity.'
}

$segments = @($relative -split '\\' | Where-Object { $_ -ne '' })
$firstSegment = $segments[0]
$remaining = if ($segments.Count -gt 1) {
    [string]::Join('\', $segments[1..($segments.Count - 1)])
} else {
    ''
}

$candidatePaths = [System.Collections.Generic.List[string]]::new()
function Add-Candidate {
    param([string]$Path)

    if (-not (Test-Path -LiteralPath $Path -PathType Container)) {
        return
    }

    foreach ($child in $ExpectedChild) {
        if (-not (Test-Path -LiteralPath (Join-Path $Path $child))) {
            return
        }
    }

    $resolved = (Resolve-Path -LiteralPath $Path).Path.TrimEnd('\')
    if (-not $candidatePaths.Contains($resolved)) {
        $candidatePaths.Add($resolved)
    }
}

foreach ($root in $roots) {
    Add-Candidate -Path (Join-Path $root $relative)

    foreach ($library in Get-ChildItem -LiteralPath $root -Directory -ErrorAction SilentlyContinue) {
        Add-Candidate -Path (Join-Path $library.FullName $relative)

        if ($library.Name -eq $firstSegment -or $library.Name.EndsWith("- $firstSegment", [System.StringComparison]::OrdinalIgnoreCase)) {
            $libraryCandidate = if ($remaining) {
                Join-Path $library.FullName $remaining
            } else {
                $library.FullName
            }
            Add-Candidate -Path $libraryCandidate
        }
    }
}

if ($candidatePaths.Count -eq 0) {
    throw "The canonical SharePoint folder '$relative' was not found beneath the current identity's verified sync roots. Use the SharePoint connector or synchronize the required library."
}

if ($candidatePaths.Count -gt 1) {
    throw "The canonical SharePoint folder '$relative' resolved to multiple local paths: $([string]::Join('; ', $candidatePaths)). Refuse to guess."
}

$result = [ordered]@{
    site_url = $SiteUrl
    canonical_relative_path = $relative.Replace('\', '/')
    local_path = $candidatePaths[0]
    expected_children = @($ExpectedChild)
    resolved_for_identity = [Security.Principal.WindowsIdentity]::GetCurrent().Name
}

if ($AsJson) {
    $result | ConvertTo-Json -Depth 4
} else {
    [pscustomobject]$result
}
