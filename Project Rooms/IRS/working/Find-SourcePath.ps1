param(
 [string[]]$Terms=@(),
 [ValidateSet('Entity','CPA','Property','All')][string]$Area='All',
 [string]$Key,
 [ValidateRange(1,10000)][int]$Limit=50,
 [string]$CatalogPath='C:\Users\wesbr\AppData\Local\BYH\IRS\source-index\source-path-catalog.json'
)
$ErrorActionPreference='Stop'
if(-not(Test-Path -LiteralPath $CatalogPath)){throw "Private IRS catalog unavailable on this machine: $CatalogPath. Read source-path-index.md for source roots."}
$catalog=Get-Content -Raw -LiteralPath $CatalogPath | ConvertFrom-Json
$matches=@($catalog.records | Where-Object {
 $record=$_
 $ok=($Area -eq 'All' -or $record.area -eq $Area) -and (-not $Key -or $record.key -eq $Key)
 foreach($term in $Terms){if($record.path.IndexOf($term,[StringComparison]::OrdinalIgnoreCase) -lt 0){$ok=$false}}
 $ok
})
if($matches.Count -gt $Limit){Write-Warning ("Showing $Limit of "+$matches.Count+' matches. Narrow Terms or increase Limit.')}
$matches | Select-Object -First $Limit key,area,kind,path,local_path,exact_url,graph_url,observed_utc,verification
