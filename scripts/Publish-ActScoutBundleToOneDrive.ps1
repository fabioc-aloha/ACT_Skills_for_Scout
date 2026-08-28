# Copies the selected versioned package into the OneDrive distribution library.
# The generated library manifest is a deployment receipt, not the source package manifest.
[CmdletBinding()]
param(
    [string]$PackageRoot = (Join-Path $PSScriptRoot '..\packages\act-skills-for-scout-v1.11.0'),
    [string]$LibraryRoot = $(if ($env:OneDrive) {
        Join-Path $env:OneDrive 'Documents\ScoutSkills\ACT_Skills_for_Scout'
    }),
    [switch]$Force
)

$ErrorActionPreference = 'Stop'

if (-not $LibraryRoot) {
    throw 'OneDrive is not configured. Supply -LibraryRoot explicitly.'
}

$packagePath = (Resolve-Path -LiteralPath $PackageRoot).Path
$skills = Get-ChildItem -LiteralPath $packagePath -Directory |
    Where-Object { Test-Path -LiteralPath (Join-Path $_.FullName 'SKILL.md') }

if ($skills.Count -eq 0) {
    throw "No direct skill folders with SKILL.md were found in $packagePath."
}

$librarySkillsRoot = Join-Path $LibraryRoot 'skills'
New-Item -ItemType Directory -Path $librarySkillsRoot -Force | Out-Null

foreach ($skill in $skills) {
    $destination = Join-Path $librarySkillsRoot $skill.Name
    if ((Test-Path -LiteralPath $destination) -and -not $Force) {
        throw "$destination already exists. Re-run with -Force to update only this managed skill folder."
    }

    New-Item -ItemType Directory -Path $destination -Force | Out-Null
    $contents = Get-ChildItem -LiteralPath $skill.FullName -Force
    if ($contents) {
        Copy-Item -LiteralPath $contents.FullName -Destination $destination -Recurse -Force
    }
}

Copy-Item -LiteralPath (Join-Path $PSScriptRoot 'Install-ActSkillsForScout.ps1') `
    -Destination (Join-Path $LibraryRoot 'Install-ActSkillsForScout.ps1') -Force
Copy-Item -LiteralPath (Join-Path $PSScriptRoot 'Uninstall-ActSkillsForScout.ps1') `
    -Destination (Join-Path $LibraryRoot 'Uninstall-ActSkillsForScout.ps1') -Force
foreach ($profileArtifact in @(
    'ActMcpProfileHelpers.psm1',
    'Install-ActMcpProfile.ps1',
    'Uninstall-ActMcpProfile.ps1',
    'Test-ActMcpCatalog.ps1'
)) {
    Copy-Item -LiteralPath (Join-Path $PSScriptRoot $profileArtifact) `
        -Destination (Join-Path $LibraryRoot $profileArtifact) -Force
}
$catalogSource = Join-Path $packagePath 'mcp-catalog'
if (-not (Test-Path -LiteralPath $catalogSource -PathType Container)) {
    throw "MCP profile catalog was not found in the package: $catalogSource"
}
$catalogDestination = Join-Path $LibraryRoot 'mcp-catalog'
New-Item -ItemType Directory -Path $catalogDestination -Force | Out-Null
$catalogContents = Get-ChildItem -LiteralPath $catalogSource -Force
if ($catalogContents) {
    Copy-Item -LiteralPath $catalogContents.FullName -Destination $catalogDestination -Recurse -Force
}
Copy-Item -LiteralPath (Join-Path $packagePath 'docs\MCP-CATALOG.md') `
    -Destination (Join-Path $LibraryRoot 'MCP-CATALOG.md') -Force
Copy-Item -LiteralPath (Join-Path $packagePath 'docs\FABRIC-SYNAPSE-EVIDENCE.md') `
    -Destination (Join-Path $LibraryRoot 'FABRIC-SYNAPSE-EVIDENCE.md') -Force
Copy-Item -LiteralPath $PSCommandPath `
    -Destination (Join-Path $LibraryRoot 'Publish-ActScoutBundleToOneDrive.ps1') -Force
foreach ($obsoleteScript in 'Install-FlintMcpForScout.ps1', 'Uninstall-FlintMcpForScout.ps1') {
    $obsoletePath = Join-Path $LibraryRoot $obsoleteScript
    if (Test-Path -LiteralPath $obsoletePath -PathType Leaf) {
        Remove-Item -LiteralPath $obsoletePath -Force
        Write-Output "Removed obsolete library script $obsoleteScript."
    }
}

$packageManifest = Get-Content -LiteralPath (Join-Path $packagePath 'manifest.json') -Raw |
    ConvertFrom-Json
$manifest = [ordered]@{
    packageName = $packageManifest.name
    packageVersion = $packageManifest.version
    publishedAt = (Get-Date).ToUniversalTime().ToString('o')
    skills = @($skills.Name)
    mcpProfiles = @(
        (Get-Content -LiteralPath (Join-Path $catalogSource 'profiles.json') -Raw | ConvertFrom-Json).profiles.id
    )
}

$manifest | ConvertTo-Json | Set-Content -LiteralPath (Join-Path $LibraryRoot 'library-manifest.json') -Encoding utf8
Write-Output "Published $($skills.Count) skill folder(s) to $LibraryRoot."
