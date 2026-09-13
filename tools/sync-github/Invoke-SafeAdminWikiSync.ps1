[CmdletBinding()]
param(
    [string]$RepositoryPath = 'C:\Codex\Wiki Files',
    [string]$ExpectedRemote = 'https://github.com/BuyYourHome/Admin-Wiki.git',
    [string]$StatusPath = (Join-Path $env:LOCALAPPDATA 'BuyYourHome\SyncGithub\status.json'),
    [string]$SkillSyncScript = 'C:\Codex\Wiki Files\tools\sync-codex-skills.ps1',
    [switch]$SkipSkillSync
)

$ErrorActionPreference = 'Stop'
$expectedRepo = [IO.Path]::GetFullPath($RepositoryPath).TrimEnd('\')
$startedAt = [DateTime]::UtcNow
$previousEventKey = $null

function Invoke-Git {
    param([Parameter(Mandatory = $true)][string[]]$Arguments)
    $savedPreference = $ErrorActionPreference
    try {
        $ErrorActionPreference = 'Continue'
        $output = @(& git -C $script:expectedRepo @Arguments 2>&1)
        $exitCode = $LASTEXITCODE
    }
    finally {
        $ErrorActionPreference = $savedPreference
    }
    if ($exitCode -ne 0) {
        throw "git $($Arguments -join ' ') failed ($exitCode): $($output -join [Environment]::NewLine)"
    }
    (($output | ForEach-Object { $_.ToString() }) -join "`n").Trim()
}

function Get-AheadBehind {
    $text = Invoke-Git -Arguments @('rev-list', '--left-right', '--count', 'main...origin/main')
    $parts = $text -split '\s+'
    if ($parts.Count -ne 2) { throw "Unexpected ahead/behind output: $text" }
    [pscustomobject]@{ Ahead = [int]$parts[0]; Behind = [int]$parts[1] }
}

function Write-AtomicStatus {
    param([System.Collections.IDictionary]$Status)
    $directory = Split-Path -Parent $StatusPath
    New-Item -ItemType Directory -Path $directory -Force | Out-Null
    $tempPath = Join-Path $directory ('.status.' + [guid]::NewGuid().ToString('N') + '.tmp')
    $Status.completed_at_utc = [DateTime]::UtcNow.ToString('o')
    $Status.duration_seconds = [math]::Round(([DateTime]::UtcNow - $startedAt).TotalSeconds, 3)
    $Status.event_key = @($Status.result, $Status.blocker, $Status.before_head, $Status.after_head, $Status.origin_main, $Status.ahead, $Status.behind) -join '|'
    $Status.notification_required = ($Status.result -notin @('AlreadyCurrent', 'FastForwarded')) -and ($Status.event_key -ne $previousEventKey)
    $Status.repeated_result = ($Status.event_key -eq $previousEventKey)
    $Status | ConvertTo-Json -Depth 10 | Set-Content -LiteralPath $tempPath -Encoding UTF8
    Move-Item -LiteralPath $tempPath -Destination $StatusPath -Force
}

if (Test-Path -LiteralPath $StatusPath) {
    try { $previousEventKey = (Get-Content -Raw -LiteralPath $StatusPath | ConvertFrom-Json).event_key } catch { $previousEventKey = $null }
}

$status = [ordered]@{
    schema_version = 1
    computer = $env:COMPUTERNAME
    windows_user = [Security.Principal.WindowsIdentity]::GetCurrent().Name
    repository = $expectedRepo
    expected_remote = $ExpectedRemote
    started_at_utc = $startedAt.ToString('o')
    result = 'Blocked'
    action = 'None'
    blocker = $null
    before_head = $null
    after_head = $null
    origin_main = $null
    ahead = $null
    behind = $null
    skills_synchronized = $false
}

try {
    if (-not (Test-Path -LiteralPath $expectedRepo -PathType Container)) { throw "Repository path does not exist: $expectedRepo" }
    $repoTop = [IO.Path]::GetFullPath((Invoke-Git -Arguments @('rev-parse', '--show-toplevel'))).TrimEnd('\')
    if (-not $repoTop.Equals($expectedRepo, [StringComparison]::OrdinalIgnoreCase)) { throw "Wrong repository: $repoTop" }
    $branch = Invoke-Git -Arguments @('branch', '--show-current')
    if ($branch -ne 'main') { throw "Wrong branch: $branch" }
    $remote = Invoke-Git -Arguments @('remote', 'get-url', 'origin')
    if ($remote.TrimEnd('/') -ne $ExpectedRemote.TrimEnd('/')) { throw "Wrong origin: $remote" }

    $status.before_head = Invoke-Git -Arguments @('rev-parse', 'HEAD')
    $dirty = Invoke-Git -Arguments @('status', '--porcelain=v1', '--untracked-files=all')
    if ($dirty) { throw "Worktree is dirty: $($dirty -replace "`n", '; ')" }

    $null = Invoke-Git -Arguments @('fetch', 'origin', 'main')
    $status.action = 'Fetched'
    $status.origin_main = Invoke-Git -Arguments @('rev-parse', 'origin/main')
    $relation = Get-AheadBehind
    $status.ahead = $relation.Ahead
    $status.behind = $relation.Behind

    if ($relation.Ahead -gt 0 -and $relation.Behind -gt 0) { throw "Local main has diverged: ahead $($relation.Ahead), behind $($relation.Behind)" }
    if ($relation.Ahead -gt 0) { throw "Local main is ahead by $($relation.Ahead) commit(s)" }

    if ($relation.Behind -gt 0) {
        $null = Invoke-Git -Arguments @('pull', '--ff-only', 'origin', 'main')
        $status.action = 'FastForwarded'
        $status.after_head = Invoke-Git -Arguments @('rev-parse', 'HEAD')
        if (-not $SkipSkillSync) {
            if (-not (Test-Path -LiteralPath $SkillSyncScript -PathType Leaf)) { throw "Skill sync script is missing after fast-forward: $SkillSyncScript" }
            & powershell.exe -NoProfile -ExecutionPolicy Bypass -File $SkillSyncScript
            if ($LASTEXITCODE -ne 0) { throw "Skill synchronization failed with exit code $LASTEXITCODE" }
            $status.skills_synchronized = $true
        }
        $status.result = 'FastForwarded'
    }
    else {
        $status.after_head = $status.before_head
        $status.result = 'AlreadyCurrent'
    }

    $finalDirty = Invoke-Git -Arguments @('status', '--porcelain=v1', '--untracked-files=all')
    if ($finalDirty) { throw "Worktree became dirty: $($finalDirty -replace "`n", '; ')" }
    $finalBranch = Invoke-Git -Arguments @('branch', '--show-current')
    if ($finalBranch -ne 'main') { throw "Branch changed unexpectedly: $finalBranch" }
    $status.origin_main = Invoke-Git -Arguments @('rev-parse', 'origin/main')
    $finalRelation = Get-AheadBehind
    $status.ahead = $finalRelation.Ahead
    $status.behind = $finalRelation.Behind
    if ($status.after_head -ne $status.origin_main -or $finalRelation.Ahead -ne 0 -or $finalRelation.Behind -ne 0) {
        throw 'Final repository verification failed: local main does not equal origin/main'
    }

    Write-AtomicStatus -Status $status
    exit 0
}
catch {
    $status.blocker = $_.Exception.Message
    if (-not $status.after_head) {
        try { $status.after_head = Invoke-Git -Arguments @('rev-parse', 'HEAD') } catch { $status.after_head = $status.before_head }
    }
    if (-not $status.origin_main) {
        try { $status.origin_main = Invoke-Git -Arguments @('rev-parse', 'origin/main') } catch { $status.origin_main = $null }
    }
    if ($null -eq $status.ahead -or $null -eq $status.behind) {
        try {
            $relation = Get-AheadBehind
            $status.ahead = $relation.Ahead
            $status.behind = $relation.Behind
        } catch { }
    }
    Write-AtomicStatus -Status $status
    Write-Error $status.blocker
    exit 1
}
