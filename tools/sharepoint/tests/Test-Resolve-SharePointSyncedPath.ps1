$ErrorActionPreference = 'Stop'
Set-StrictMode -Version Latest

$resolver = Join-Path (Split-Path -Parent $PSScriptRoot) 'Resolve-SharePointSyncedPath.ps1'
$testRoot = Join-Path $env:TEMP ('byh-sharepoint-resolver-' + [guid]::NewGuid().ToString('N'))
$relative = 'Office Admin\Scanned Files\Invoice Entry Working Archive\Operational Records'
$site = 'https://lifeisanadventure.sharepoint.com/sites/SellYourHome'

function Assert-Equal {
    param($Expected, $Actual, [string]$Message)
    if ($Expected -ne $Actual) {
        throw "$Message Expected '$Expected'; received '$Actual'."
    }
}

try {
    $directRoot = Join-Path $testRoot 'direct'
    $directPath = Join-Path $directRoot 'Buy Your Home - Office Admin\Scanned Files\Invoice Entry Working Archive\Operational Records'
    New-Item -ItemType Directory -Path $directPath -Force | Out-Null
    New-Item -ItemType File -Path (Join-Path $directPath 'work-status.md') -Force | Out-Null

    $direct = & $resolver -SiteUrl $site -CanonicalRelativePath $relative -ExpectedChild 'work-status.md' -AdditionalRoot $directRoot -AdditionalRootsOnly
    Assert-Equal (Resolve-Path $directPath).Path $direct.local_path 'Direct library resolution failed.'

    $documentsRoot = Join-Path $testRoot 'documents'
    $documentsPath = Join-Path $documentsRoot 'Buy Your Home - Documents\Office Admin\Scanned Files\Invoice Entry Working Archive\Operational Records'
    New-Item -ItemType Directory -Path $documentsPath -Force | Out-Null
    New-Item -ItemType File -Path (Join-Path $documentsPath 'work-status.md') -Force | Out-Null

    $documents = & $resolver -SiteUrl $site -CanonicalRelativePath $relative -ExpectedChild 'work-status.md' -AdditionalRoot $documentsRoot -AdditionalRootsOnly
    Assert-Equal (Resolve-Path $documentsPath).Path $documents.local_path 'Documents library resolution failed.'

    $ambiguousRoot = Join-Path $testRoot 'ambiguous'
    foreach ($library in 'Buy Your Home - Office Admin', 'Another - Office Admin') {
        $path = Join-Path $ambiguousRoot "$library\Scanned Files\Invoice Entry Working Archive\Operational Records"
        New-Item -ItemType Directory -Path $path -Force | Out-Null
        New-Item -ItemType File -Path (Join-Path $path 'work-status.md') -Force | Out-Null
    }

    $ambiguousFailed = $false
    try {
        & $resolver -SiteUrl $site -CanonicalRelativePath $relative -ExpectedChild 'work-status.md' -AdditionalRoot $ambiguousRoot -AdditionalRootsOnly | Out-Null
    } catch {
        $ambiguousFailed = $_.Exception.Message -like '*multiple local paths*'
    }
    Assert-Equal $true $ambiguousFailed 'Ambiguous resolution did not fail closed.'

    $traversalFailed = $false
    try {
        & $resolver -SiteUrl $site -CanonicalRelativePath '..\Operational Records' -AdditionalRoot $directRoot -AdditionalRootsOnly | Out-Null
    } catch {
        $traversalFailed = $_.Exception.Message -like '*parent-directory*'
    }
    Assert-Equal $true $traversalFailed 'Parent-directory traversal did not fail closed.'

    [pscustomobject]@{
        passed = 4
        direct_layout = $direct.local_path
        documents_layout = $documents.local_path
        ambiguity_refused = $ambiguousFailed
        traversal_refused = $traversalFailed
    } | ConvertTo-Json -Depth 3
} finally {
    Remove-Item -LiteralPath $testRoot -Recurse -Force -ErrorAction SilentlyContinue
}
