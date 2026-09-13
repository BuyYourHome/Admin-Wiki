[CmdletBinding()]
param()

$ErrorActionPreference = 'Stop'
$runner = [IO.Path]::GetFullPath((Join-Path $PSScriptRoot '..\Invoke-SafeAdminWikiSync.ps1'))
$testRoot = Join-Path (Join-Path $env:LOCALAPPDATA 'Temp') ('byh-sync-github-' + [guid]::NewGuid().ToString('N'))
$origin = Join-Path $testRoot 'origin.git'
$publisher = Join-Path $testRoot 'publisher'
$target = Join-Path $testRoot 'target'
$statusPath = Join-Path $testRoot 'status.json'

function Invoke-CheckedGit {
    param([string]$WorkingPath, [string[]]$Arguments)
    & git -C $WorkingPath @Arguments | Out-Null
    if ($LASTEXITCODE -ne 0) { throw "Git test setup failed: git -C $WorkingPath $($Arguments -join ' ')" }
}

function Invoke-Runner {
    & powershell.exe -NoProfile -ExecutionPolicy Bypass -File $runner -RepositoryPath $target -ExpectedRemote $origin -StatusPath $statusPath -SkipSkillSync
    $code = $LASTEXITCODE
    $status = Get-Content -Raw -LiteralPath $statusPath | ConvertFrom-Json
    [pscustomobject]@{ ExitCode = $code; Status = $status }
}

try {
    New-Item -ItemType Directory -Path $testRoot | Out-Null
    & git init --bare $origin | Out-Null
    if ($LASTEXITCODE -ne 0) { throw 'Could not initialize test origin.' }
    & git clone $origin $publisher | Out-Null
    if ($LASTEXITCODE -ne 0) { throw 'Could not clone test publisher.' }
    Invoke-CheckedGit $publisher @('config', 'user.name', 'Sync Github Test')
    Invoke-CheckedGit $publisher @('config', 'user.email', 'sync-github-test@invalid.example')
    Set-Content -LiteralPath (Join-Path $publisher 'baseline.txt') -Value 'baseline'
    Invoke-CheckedGit $publisher @('add', 'baseline.txt')
    Invoke-CheckedGit $publisher @('commit', '-m', 'Baseline')
    Invoke-CheckedGit $publisher @('branch', '-M', 'main')
    Invoke-CheckedGit $publisher @('push', '-u', 'origin', 'main')
    & git --git-dir=$origin symbolic-ref HEAD refs/heads/main
    if ($LASTEXITCODE -ne 0) { throw 'Could not point test origin HEAD to main.' }
    & git clone $origin $target | Out-Null
    if ($LASTEXITCODE -ne 0) { throw 'Could not clone test target.' }

    $current = Invoke-Runner
    if ($current.ExitCode -ne 0 -or $current.Status.result -ne 'AlreadyCurrent') { throw 'Already-current behavior failed.' }

    Set-Content -LiteralPath (Join-Path $target 'dirty-test.txt') -Value 'leave untouched'
    $dirtyFirst = Invoke-Runner
    if ($dirtyFirst.ExitCode -eq 0 -or $dirtyFirst.Status.result -ne 'Blocked' -or -not $dirtyFirst.Status.notification_required) { throw 'Dirty-worktree refusal failed.' }
    $dirtySecond = Invoke-Runner
    if ($dirtySecond.ExitCode -eq 0 -or -not $dirtySecond.Status.repeated_result -or $dirtySecond.Status.notification_required) { throw 'Repeated-failure suppression failed.' }
    if (-not (Test-Path -LiteralPath (Join-Path $target 'dirty-test.txt'))) { throw 'Dirty file was altered.' }
    Remove-Item -LiteralPath (Join-Path $target 'dirty-test.txt')

    Set-Content -LiteralPath (Join-Path $publisher 'update.txt') -Value 'fast-forward update'
    Invoke-CheckedGit $publisher @('add', 'update.txt')
    Invoke-CheckedGit $publisher @('commit', '-m', 'Fast-forward fixture')
    Invoke-CheckedGit $publisher @('push', 'origin', 'main')
    $fastForward = Invoke-Runner
    if ($fastForward.ExitCode -ne 0 -or $fastForward.Status.result -ne 'FastForwarded') { throw 'Safe fast-forward behavior failed.' }
    $targetHead = (& git -C $target rev-parse HEAD).Trim()
    $originHead = (& git -C $target rev-parse origin/main).Trim()
    if ($targetHead -ne $originHead) { throw 'Fast-forward verification failed.' }

    [pscustomobject]@{
        result = 'Passed'
        already_current = $current.Status.result
        dirty_refusal = $dirtyFirst.Status.result
        repeated_failure_suppressed = $dirtySecond.Status.repeated_result
        fast_forward = $fastForward.Status.result
        final_head = $targetHead
    } | ConvertTo-Json
}
finally {
    if (Test-Path -LiteralPath $testRoot) { Remove-Item -LiteralPath $testRoot -Recurse -Force }
}
