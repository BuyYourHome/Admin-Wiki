[CmdletBinding()]
param([string]$ScratchRoot = "C:\Codex\DocScanWork")

$ErrorActionPreference = "Stop"
if ([IO.Path]::GetFullPath($ScratchRoot).TrimEnd('\') -ne "C:\Codex\DocScanWork") { throw "Invalid scratch root." }
$requestDirectory = Join-Path $ScratchRoot 'Requests'
$resultDirectory = Join-Path $ScratchRoot 'Results'
$completedDirectory = Join-Path $ScratchRoot 'Completed Requests'
New-Item -ItemType Directory -Path $requestDirectory,$resultDirectory,$completedDirectory -Force | Out-Null
$downloadHelper = Join-Path $PSScriptRoot 'Invoke-DocScanScratch.ps1'

Get-ChildItem -LiteralPath $requestDirectory -Filter '*.json' -File | Sort-Object CreationTimeUtc | ForEach-Object {
    $requestFile = $_
    try {
        $request = Get-Content -Raw -LiteralPath $requestFile.FullName | ConvertFrom-Json
        if ([string]$request.request_id -ne $requestFile.BaseName) { throw "Request id does not match file name." }
        $raw = & $downloadHelper -Action Download -DownloadUrl ([uri]$request.download_url) -SourceFileName ([string]$request.source_file_name)
        $download = $raw | ConvertFrom-Json
        $result = [pscustomobject][ordered]@{
            schema_version = 1; request_id = $request.request_id; status = 'Completed'
            completed_at_utc = [DateTime]::UtcNow.ToString('o'); run_id = $download.run_id
            file_path = $download.file_path; size_bytes = $download.size_bytes; sha256 = $download.sha256
        }
    } catch {
        $result = [pscustomobject][ordered]@{
            schema_version = 1; request_id = $requestFile.BaseName; status = 'Failed'
            completed_at_utc = [DateTime]::UtcNow.ToString('o'); error = $_.Exception.Message
        }
    }
    $resultTemp = Join-Path $resultDirectory "$($requestFile.BaseName).json.tmp"
    $resultPath = Join-Path $resultDirectory "$($requestFile.BaseName).json"
    $result | ConvertTo-Json -Depth 5 | Set-Content -LiteralPath $resultTemp -Encoding UTF8
    Move-Item -LiteralPath $resultTemp -Destination $resultPath -Force
    Move-Item -LiteralPath $requestFile.FullName -Destination (Join-Path $completedDirectory $requestFile.Name) -Force
}
