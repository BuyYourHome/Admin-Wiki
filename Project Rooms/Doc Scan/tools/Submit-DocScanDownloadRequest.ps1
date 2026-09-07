[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)][uri]$DownloadUrl,
    [Parameter(Mandatory = $true)][string]$SourceFileName,
    [string]$ScratchRoot = "C:\Codex\DocScanWork"
)

$ErrorActionPreference = "Stop"
if ([IO.Path]::GetFullPath($ScratchRoot).TrimEnd('\') -ne "C:\Codex\DocScanWork") { throw "Invalid scratch root." }
if ($DownloadUrl.Scheme -ne "https" -or $DownloadUrl.Host -notmatch '(^|\.)oaiusercontent\.com$') { throw "Invalid download host." }
if ([IO.Path]::GetFileName($SourceFileName) -ne $SourceFileName) { throw "SourceFileName must not contain a path." }
if ([IO.Path]::GetExtension($SourceFileName).ToLowerInvariant() -notin @('.pdf','.jpg','.jpeg')) { throw "Unsupported scan type." }

$requestId = [guid]::NewGuid().ToString('N')
$requestDirectory = Join-Path $ScratchRoot 'Requests'
$resultDirectory = Join-Path $ScratchRoot 'Results'
New-Item -ItemType Directory -Path $requestDirectory,$resultDirectory -Force | Out-Null
$request = [pscustomobject][ordered]@{
    schema_version = 1
    request_id = $requestId
    created_at_utc = [DateTime]::UtcNow.ToString('o')
    download_url = $DownloadUrl.AbsoluteUri
    source_file_name = $SourceFileName
}
$temporaryPath = Join-Path $requestDirectory "$requestId.json.tmp"
$requestPath = Join-Path $requestDirectory "$requestId.json"
$request | ConvertTo-Json -Depth 4 | Set-Content -LiteralPath $temporaryPath -Encoding UTF8
Move-Item -LiteralPath $temporaryPath -Destination $requestPath
[pscustomobject][ordered]@{ request_id=$requestId; request_path=$requestPath; result_path=(Join-Path $resultDirectory "$requestId.json") } | ConvertTo-Json
