param([string]$Action,[string]$QueuePath,[string]$MessageId)

if($Action -eq 'Health'){
    '{"available":true}'
    return
}
if($Action -eq 'Get' -and $MessageId -eq 'synthetic-readiness-001'){
    Get-Content -Raw -LiteralPath (Join-Path $QueuePath 'record.json')
    return
}
throw 'UnexpectedFixtureManagerCall'
