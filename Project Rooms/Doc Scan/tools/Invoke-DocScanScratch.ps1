[CmdletBinding(DefaultParameterSetName = "Download")]
param(
    [Parameter(Mandatory = $true)]
    [ValidateSet("Download", "Cleanup")]
    [string]$Action,

    [Parameter(Mandatory = $true, ParameterSetName = "Download")]
    [uri]$DownloadUrl,

    [Parameter(Mandatory = $true, ParameterSetName = "Download")]
    [string]$SourceFileName,

    [Parameter(Mandatory = $true, ParameterSetName = "Cleanup")]
    [string]$RunId,

    [string]$ScratchRoot = "C:\Codex\DocScanWork"
)

$ErrorActionPreference = "Stop"

function Assert-ScratchRoot {
    if ([IO.Path]::GetFullPath($ScratchRoot).TrimEnd('\') -ne "C:\Codex\DocScanWork") {
        throw "ScratchRoot must be C:\Codex\DocScanWork."
    }
}

Assert-ScratchRoot

if ($Action -eq "Download") {
    if ($DownloadUrl.Scheme -ne "https" -or $DownloadUrl.Host -notmatch '(^|\.)oaiusercontent\.com$') {
        throw "DownloadUrl must use HTTPS on an oaiusercontent.com host."
    }

    if ([IO.Path]::GetFileName($SourceFileName) -ne $SourceFileName) {
        throw "SourceFileName must be a file name without a path."
    }

    $extension = [IO.Path]::GetExtension($SourceFileName).ToLowerInvariant()
    if ($extension -notin @(".pdf", ".jpg", ".jpeg")) {
        throw "Only PDF, JPG, and JPEG scan files are allowed."
    }

    $safeStem = [IO.Path]::GetFileNameWithoutExtension($SourceFileName) -replace '[^A-Za-z0-9._-]', '_'
    $newRunId = "{0}-{1}-{2}" -f ([DateTime]::UtcNow.ToString("yyyyMMddTHHmmssfffZ")), $safeStem, ([guid]::NewGuid().ToString("N").Substring(0, 8))
    $runPath = Join-Path $ScratchRoot $newRunId
    New-Item -ItemType Directory -Path $runPath -Force | Out-Null
    $destinationPath = Join-Path $runPath $SourceFileName

    try {
        Invoke-WebRequest -Uri $DownloadUrl.AbsoluteUri -OutFile $destinationPath
        $item = Get-Item -LiteralPath $destinationPath
        $hash = Get-FileHash -LiteralPath $destinationPath -Algorithm SHA256
        [pscustomobject][ordered]@{
            action = "Downloaded"
            run_id = $newRunId
            file_path = $item.FullName
            size_bytes = $item.Length
            sha256 = $hash.Hash.ToLowerInvariant()
        } | ConvertTo-Json -Depth 4
    }
    catch {
        if (Test-Path -LiteralPath $runPath) {
            Remove-Item -LiteralPath $runPath -Recurse -Force
        }
        throw
    }
    return
}

if ($RunId -notmatch '^[A-Za-z0-9._-]+$') {
    throw "RunId contains unsupported characters."
}

$targetPath = Join-Path $ScratchRoot $RunId
if (-not (Test-Path -LiteralPath $targetPath -PathType Container)) {
    throw "Scratch run folder does not exist: $targetPath"
}

$resolvedRoot = (Resolve-Path -LiteralPath $ScratchRoot).Path.TrimEnd('\')
$resolvedTarget = (Resolve-Path -LiteralPath $targetPath).Path
if ([IO.Path]::GetDirectoryName($resolvedTarget).TrimEnd('\') -ne $resolvedRoot) {
    throw "Cleanup target must be a direct child of the Doc Scan scratch root."
}

Remove-Item -LiteralPath $resolvedTarget -Recurse -Force
[pscustomobject][ordered]@{
    action = "Cleaned"
    run_id = $RunId
    removed_path = $resolvedTarget
} | ConvertTo-Json -Depth 4
