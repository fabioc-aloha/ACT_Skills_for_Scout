[CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
param(
    [string]$LibraryRoot = $(if ($env:OneDrive) {
        Join-Path $env:OneDrive 'Documents\ScoutSkills\ACT_Skills_for_Scout'
    }),
    [string]$SkillsRoot = (Join-Path $HOME '.copilot\skills'),
    [switch]$Publish,
    [switch]$Apply,
    [string]$McpConfigPath = (Join-Path $HOME '.scout\m-mcp-servers.json')
)

$ErrorActionPreference = 'Stop'
if (-not $Apply) {
    Write-Output 'Preview only. Re-run with -Apply to publish/link all ACT skills and register Flint.'
    exit 0
}

$publisher = Join-Path $PSScriptRoot 'Publish-ActSkillsLibrary.ps1'
if ($Publish) {
    if (-not (Test-Path -LiteralPath $publisher)) {
        throw '-Publish is available only from the ACT Skills for Scout source repository.'
    }

    & $publisher -LibraryRoot $LibraryRoot -Force
}

if (-not $LibraryRoot) {
    throw 'OneDrive is not configured. Supply -LibraryRoot explicitly.'
}

$libraryPath = (Resolve-Path -LiteralPath $LibraryRoot).Path
$librarySkillsRoot = Join-Path $libraryPath 'skills'
$skills = Get-ChildItem -LiteralPath $librarySkillsRoot -Directory |
    Where-Object { Test-Path -LiteralPath (Join-Path $_.FullName 'SKILL.md') }

if ($skills.Count -eq 0) {
    throw "No direct skill folders with SKILL.md were found in $librarySkillsRoot."
}

New-Item -ItemType Directory -Path $SkillsRoot -Force | Out-Null

foreach ($skill in $skills) {
    $destination = Join-Path $SkillsRoot $skill.Name
    if (Test-Path -LiteralPath $destination) {
        $existing = Get-Item -LiteralPath $destination -Force
        if ($existing.LinkType -eq 'Junction') {
            $target = @($existing.Target | ForEach-Object { [System.IO.Path]::GetFullPath($_) })
            if ($target -contains $skill.FullName) {
                Write-Output "$($skill.Name) is already linked."
                continue
            }
        }

        throw "$destination already exists and is not this library's junction. It was not changed."
    }

    if ($PSCmdlet.ShouldProcess($destination, "Create junction to $($skill.FullName)")) {
        New-Item -ItemType Junction -Path $destination -Target $skill.FullName | Out-Null
        Write-Output "Linked $($skill.Name)."
    }
}

if (-not (Test-Path -LiteralPath $McpConfigPath -PathType Leaf)) {
    throw "Scout MCP configuration was not found: $McpConfigPath"
}

try {
    $configuration = Get-Content -LiteralPath $McpConfigPath -Raw | ConvertFrom-Json
}
catch {
    throw "Scout MCP configuration is not valid JSON: $($_.Exception.Message)"
}
if ($null -eq $configuration.servers) {
    throw "Scout MCP configuration has no root 'servers' object: $McpConfigPath"
}

$arguments = @('-y', 'flint-chart-mcp@0.5.1', '--disable-file-reference')
$expectedTools = @(
    'render_chart',
    'compile_chart',
    'validate_chart',
    'list_chart_types',
    'list_themes',
    'create_chart_view'
)
$envFile = '${mcpEnvDir}/flint.env'
$existingProperty = $configuration.servers.PSObject.Properties['flint']
$existingEntry = if ($existingProperty) { $existingProperty.Value } else { $null }

function Test-FlintEntry {
    param([Parameter(Mandatory)]$Entry)

    return $Entry.builtin -eq $false `
        -and $Entry.config.name -eq 'flint' `
        -and $Entry.config.type -eq 'command' `
        -and $Entry.config.command -eq 'npx' `
        -and $Entry.config.envFile -eq $envFile `
        -and @($Entry.config.args).Count -eq $arguments.Count `
        -and -not (Compare-Object -ReferenceObject $arguments -DifferenceObject @($Entry.config.args)) `
        -and @($Entry.tools).Count -eq $expectedTools.Count `
        -and -not (Compare-Object -ReferenceObject $expectedTools -DifferenceObject @($Entry.tools))
}

if ($existingEntry -and -not (Test-FlintEntry -Entry $existingEntry)) {
    throw "The existing 'flint' entry differs from the reviewed configuration and was not changed."
}

Write-Output "Scout MCP configuration: $McpConfigPath"
Write-Output 'Package resolved on launch: flint-chart-mcp@0.5.1'
Write-Output 'Local file references: disabled'
if ($existingEntry) {
    Write-Output 'Flint is already registered with the reviewed configuration.'
    exit 0
}

$entry = [pscustomobject]@{
    builtin = $false
    config = [pscustomobject]@{
        name = 'flint'
        type = 'command'
        command = 'npx'
        args = $arguments
        envFile = $envFile
    }
    tools = $expectedTools
}
Write-Output 'Proposed Flint entry:'
Write-Output ($entry | ConvertTo-Json -Depth 4)
$baseBackupPath = "$McpConfigPath.backup-$(Get-Date -Format 'yyyyMMddHHmmss')"
$backupPath = $baseBackupPath
$suffix = 1
while (Test-Path -LiteralPath $backupPath) {
    $backupPath = "$baseBackupPath-$suffix"
    $suffix++
}
if ($PSCmdlet.ShouldProcess($McpConfigPath, "Add Flint MCP entry and create backup $backupPath")) {
    Copy-Item -LiteralPath $McpConfigPath -Destination $backupPath
    $configuration.servers | Add-Member -MemberType NoteProperty -Name 'flint' -Value $entry
    $json = $configuration | ConvertTo-Json -Depth 10
    [System.IO.File]::WriteAllText(
        $McpConfigPath,
        "$json$([Environment]::NewLine)",
        [System.Text.UTF8Encoding]::new($false)
    )
    Write-Output "Registered Flint. Backup: $backupPath"
    Write-Output 'Restart Scout, then confirm the six Flint tools and run a harmless visual canary.'
}
