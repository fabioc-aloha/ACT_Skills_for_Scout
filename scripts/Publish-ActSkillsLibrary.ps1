[CmdletBinding()]
param(
    [string]$PackageRoot = (Join-Path $PSScriptRoot '..\packages\act-skills-for-scout-v0.1.0'),
    [string]$LibraryRoot = $(if ($env:OneDrive) {
        Join-Path $env:OneDrive 'ScoutSkills\ACT_Skills_for_Scout'
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

$packageManifest = Get-Content -LiteralPath (Join-Path $packagePath 'manifest.json') -Raw |
    ConvertFrom-Json
$manifest = [ordered]@{
    packageName = $packageManifest.name
    packageVersion = $packageManifest.version
    publishedAt = (Get-Date).ToUniversalTime().ToString('o')
    skills = @($skills.Name)
}

$manifest | ConvertTo-Json | Set-Content -LiteralPath (Join-Path $LibraryRoot 'library-manifest.json') -Encoding utf8
Write-Output "Published $($skills.Count) skill folder(s) to $LibraryRoot."
