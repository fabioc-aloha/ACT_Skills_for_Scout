# Removes the entire user-global ACT and Flint bundle only when -Apply is supplied.
# Matching checks prevent this script from removing another tool's registration.
[CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
param(
    [string]$LibraryRoot = $(if ($env:OneDrive) {
        Join-Path $env:OneDrive 'Documents\ScoutSkills\ACT_Skills_for_Scout'
    }),
    [string]$SkillsRoot = (Join-Path $HOME '.copilot\skills'),
    [switch]$Apply,
    [string]$McpConfigPath = (Join-Path $HOME '.scout\m-mcp-servers.json')
)

$ErrorActionPreference = 'Stop'
if (-not $Apply) {
    Write-Output 'Preview only. Re-run with -Apply to remove all ACT skill junctions and unregister Flint.'
    exit 0
}

$libraryPath = (Resolve-Path -LiteralPath $LibraryRoot).Path
$librarySkillsRoot = Join-Path $libraryPath 'skills'
$skills = Get-ChildItem -LiteralPath $librarySkillsRoot -Directory |
    Where-Object { Test-Path -LiteralPath (Join-Path $_.FullName 'SKILL.md') }

foreach ($skill in $skills) {
    $destination = Join-Path $SkillsRoot $skill.Name
    if (-not (Test-Path -LiteralPath $destination)) {
        continue
    }

    $existing = Get-Item -LiteralPath $destination -Force
    if ($existing.LinkType -ne 'Junction') {
        Write-Warning "$destination is not this library's junction and was not changed."
        continue
    }

    $target = @($existing.Target | ForEach-Object { [System.IO.Path]::GetFullPath($_) })
    if ($target -notcontains $skill.FullName) {
        Write-Warning "$destination is not this library's junction and was not changed."
        continue
    }

    if ($PSCmdlet.ShouldProcess($destination, 'Remove ACT Scout skill junction')) {
        Remove-Item -LiteralPath $destination -Force
        Write-Output "Removed junction for $($skill.Name)."
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

$expectedArguments = @('-y', 'flint-chart-mcp@0.5.1', '--disable-file-reference')
$expectedTools = @(
    'render_chart',
    'compile_chart',
    'validate_chart',
    'list_chart_types',
    'list_themes',
    'create_chart_view'
)
$expectedEnvFile = '${mcpEnvDir}/flint.env'
$existingProperty = $configuration.servers.PSObject.Properties['flint']
if (-not $existingProperty) {
    Write-Output 'Flint is not registered; nothing was changed.'
    exit 0
}

$entry = $existingProperty.Value
$matches = $entry.builtin -eq $false `
    -and $entry.config.name -eq 'flint' `
    -and $entry.config.type -eq 'command' `
    -and $entry.config.command -eq 'npx' `
    -and $entry.config.envFile -eq $expectedEnvFile `
    -and @($entry.config.args).Count -eq $expectedArguments.Count `
    -and -not (Compare-Object -ReferenceObject $expectedArguments -DifferenceObject @($entry.config.args)) `
    -and @($entry.tools).Count -eq $expectedTools.Count `
    -and -not (Compare-Object -ReferenceObject $expectedTools -DifferenceObject @($entry.tools))
if (-not $matches) {
    throw "The existing 'flint' entry differs from the reviewed configuration and was not removed."
}

Write-Output "Scout MCP configuration: $McpConfigPath"
$baseBackupPath = "$McpConfigPath.backup-$(Get-Date -Format 'yyyyMMddHHmmss')"
$backupPath = $baseBackupPath
$suffix = 1
while (Test-Path -LiteralPath $backupPath) {
    $backupPath = "$baseBackupPath-$suffix"
    $suffix++
}
if ($PSCmdlet.ShouldProcess($McpConfigPath, "Remove Flint MCP entry and create backup $backupPath")) {
    # Keep a recovery copy before changing the shared Scout MCP configuration.
    Copy-Item -LiteralPath $McpConfigPath -Destination $backupPath
    [void]$configuration.servers.PSObject.Properties.Remove('flint')
    $json = $configuration | ConvertTo-Json -Depth 10
    [System.IO.File]::WriteAllText(
        $McpConfigPath,
        "$json$([Environment]::NewLine)",
        [System.Text.UTF8Encoding]::new($false)
    )
    Write-Output "Removed Flint registration. Backup: $backupPath"
    Write-Output 'Restart Scout to unload the server.'
}
