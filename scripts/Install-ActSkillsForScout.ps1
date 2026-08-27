[CmdletBinding(SupportsShouldProcess)]
param(
    [string]$LibraryRoot = $(if ($env:OneDrive) {
        Join-Path $env:OneDrive 'Documents\ScoutSkills\ACT_Skills_for_Scout'
    }),
    [string]$SkillsRoot = (Join-Path $HOME '.copilot\skills'),
    [switch]$Publish
)

$ErrorActionPreference = 'Stop'

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
