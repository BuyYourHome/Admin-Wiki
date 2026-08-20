param(
  [string]$AdminWikiRoot = 'C:\Codex\Wiki Files',
  [string]$OutputRoot = '',
  [string[]]$ProjectRoomNames = @(
    'Codex Environment',
    'Jean Wright',
    'Invoice Entry',
    'Email Monitor',
    'Doc Scan',
    'Manager',
    'Lowes Order',
    'Marketplace'
  )
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

function ConvertTo-SkillFolderName {
  param([Parameter(Mandatory)][string]$ProjectRoomName)

  $name = $ProjectRoomName.ToLowerInvariant()
  $name = $name -replace '&', ' and '
  $name = $name -replace '[^a-z0-9]+', '-'
  $name = $name.Trim('-')
  return $name
}

function ConvertTo-SafeFileName {
  param([Parameter(Mandatory)][string]$Name)

  $invalid = [System.IO.Path]::GetInvalidFileNameChars()
  $safe = $Name
  foreach ($char in $invalid) {
    $safe = $safe.Replace([string]$char, '-')
  }
  return $safe
}

$resolvedRoot = [System.IO.Path]::GetFullPath($AdminWikiRoot)
if ($resolvedRoot.TrimEnd('\') -ne 'C:\Codex\Wiki Files') {
  throw "AdminWikiRoot must be C:\Codex\Wiki Files. Received: $resolvedRoot"
}

if (-not (Test-Path -LiteralPath $resolvedRoot -PathType Container)) {
  throw "Admin wiki root does not exist: $resolvedRoot"
}

$gitFolder = Join-Path $resolvedRoot '.git'
if (-not (Test-Path -LiteralPath $gitFolder -PathType Container)) {
  throw "Admin wiki root is not a Git repository: $resolvedRoot"
}

if ([string]::IsNullOrWhiteSpace($OutputRoot)) {
  $OutputRoot = Join-Path $resolvedRoot 'Project Rooms\Codex Environment\outputs\project-room-chat-startup-prompts'
}

$resolvedOutput = [System.IO.Path]::GetFullPath($OutputRoot)
if (-not $resolvedOutput.StartsWith($resolvedRoot, [System.StringComparison]::OrdinalIgnoreCase)) {
  throw "OutputRoot must be under C:\Codex\Wiki Files. Received: $resolvedOutput"
}

New-Item -ItemType Directory -Path $resolvedOutput -Force | Out-Null

$startupRulePath = Join-Path $resolvedRoot 'Project Room Chat Startup Rule.md'
$ownershipRulePath = Join-Path $resolvedRoot 'Project Room File Ownership And Git Coordination Rule.md'
$adminHomePath = Join-Path $resolvedRoot 'Admin Home.md'
$agentsPath = Join-Path $resolvedRoot 'AGENTS.md'
$repoRulePath = Join-Path $resolvedRoot 'Repository Location Rule.md'
$workflowRulePath = Join-Path $resolvedRoot 'Project Room Workflow.md'
$agentUnitPath = Join-Path $resolvedRoot 'Agent Unit Standard.md'
$gitScopePath = Join-Path $resolvedRoot 'Git Work Scope Rule.md'
$skillSourceRulePath = Join-Path $resolvedRoot 'Codex Skill Source Rule.md'
$pythonRulePath = Join-Path $resolvedRoot 'Codex Python Runtime Rule.md'
$libreOfficeRulePath = Join-Path $resolvedRoot 'LibreOffice Location Rule.md'

$requiredRootFiles = @(
  $adminHomePath,
  $agentsPath,
  $repoRulePath,
  $workflowRulePath,
  $startupRulePath,
  $ownershipRulePath,
  $agentUnitPath,
  $gitScopePath,
  $skillSourceRulePath,
  $pythonRulePath,
  $libreOfficeRulePath
)

$missingRootFiles = @($requiredRootFiles | Where-Object { -not (Test-Path -LiteralPath $_ -PathType Leaf) })
if ($missingRootFiles.Count -gt 0) {
  throw "Required Admin wiki startup files are missing: $($missingRootFiles -join '; ')"
}

$manifestRows = New-Object System.Collections.Generic.List[object]

foreach ($projectRoomName in $ProjectRoomNames) {
  $roomPath = Join-Path $resolvedRoot ("Project Rooms\{0}" -f $projectRoomName)
  $readmePath = Join-Path $roomPath 'README.md'
  $skillFolderName = ConvertTo-SkillFolderName -ProjectRoomName $projectRoomName
  $skillPath = Join-Path $resolvedRoot ("skills\{0}\SKILL.md" -f $skillFolderName)
  $safeName = ConvertTo-SafeFileName -Name $projectRoomName
  $promptPath = Join-Path $resolvedOutput ("{0} - startup prompt.txt" -f $safeName)

  $roomExists = Test-Path -LiteralPath $roomPath -PathType Container
  $readmeExists = Test-Path -LiteralPath $readmePath -PathType Leaf
  $skillExists = Test-Path -LiteralPath $skillPath -PathType Leaf

  $skillInstruction = if ($skillExists) {
    "- C:\Codex\Wiki Files\skills\$skillFolderName\SKILL.md"
  } else {
    "- No matching skill was found at C:\Codex\Wiki Files\skills\$skillFolderName\SKILL.md. Report that and continue from the Project Room README and shared Admin rules."
  }

  $prompt = @"
Start PR for $projectRoomName.

Work only from the canonical Admin wiki Git repository:
C:\Codex\Wiki Files

Before doing file work, verify the default folder with Get-Location.
If the session default is not C:\Codex\Wiki Files, still use C:\Codex\Wiki Files explicitly as the workdir for every shell command and use absolute paths under C:\Codex\Wiki Files for all file reads and edits.

If any tool would use a relative path, stop and convert it to an absolute path under C:\Codex\Wiki Files first.

First, read:
- C:\Codex\Wiki Files\Admin Home.md
- C:\Codex\Wiki Files\AGENTS.md
- C:\Codex\Wiki Files\Repository Location Rule.md
- C:\Codex\Wiki Files\Project Room Workflow.md
- C:\Codex\Wiki Files\Project Room Chat Startup Rule.md
- C:\Codex\Wiki Files\Project Room File Ownership And Git Coordination Rule.md
- C:\Codex\Wiki Files\Agent Unit Standard.md
- C:\Codex\Wiki Files\Git Work Scope Rule.md
- C:\Codex\Wiki Files\Codex Skill Source Rule.md
- C:\Codex\Wiki Files\Codex Python Runtime Rule.md
- C:\Codex\Wiki Files\LibreOffice Location Rule.md
- C:\Codex\Wiki Files\Project Rooms\$projectRoomName\README.md
$skillInstruction

Then report:
- current folder
- git branch/status
- whether local main is behind origin/main
- whether the Project Room README exists
- whether the matching skill exists
- any startup blockers

Do not edit files until I give the next instruction.
"@

  Set-Content -LiteralPath $promptPath -Value $prompt -Encoding UTF8

  $manifestRows.Add([pscustomobject]@{
    ProjectRoom = $projectRoomName
    ChatTitle = $projectRoomName
    RoomExists = $roomExists
    ReadmeExists = $readmeExists
    SkillFolder = $skillFolderName
    SkillExists = $skillExists
    PromptPath = $promptPath
  })
}

$manifestPath = Join-Path $resolvedOutput 'manifest.md'
$manifest = New-Object System.Collections.Generic.List[string]
$manifest.Add('# Project Room Chat Startup Prompt Manifest')
$manifest.Add('')
$manifest.Add("Generated: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss zzz')")
$manifest.Add('')
$manifest.Add('Use these prompt files when creating matching Codex chats on a target computer. Create each chat in the Codex Desktop `Admin Wiki` project pointed at `C:\Codex\Wiki Files`.')
$manifest.Add('')
$manifest.Add('| Chat title | Project Room exists | README exists | Skill folder | Skill exists | Prompt file |')
$manifest.Add('| --- | --- | --- | --- | --- | --- |')

foreach ($row in $manifestRows) {
  $fileName = Split-Path -Leaf $row.PromptPath
  $manifest.Add(('| {0} | {1} | {2} | `{3}` | {4} | `{5}` |' -f $row.ChatTitle, $row.RoomExists, $row.ReadmeExists, $row.SkillFolder, $row.SkillExists, $fileName))
}

$manifest.Add('')
$manifest.Add('Important: identical chat names on multiple computers do not share conversation state. Each chat must run its startup prompt before doing file work.')

Set-Content -LiteralPath $manifestPath -Value $manifest -Encoding UTF8

[pscustomobject]@{
  AdminWikiRoot = $resolvedRoot
  OutputRoot = $resolvedOutput
  ManifestPath = $manifestPath
  ProjectRooms = $manifestRows
} | ConvertTo-Json -Depth 5
