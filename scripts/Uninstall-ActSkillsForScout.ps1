# Removes the user-global ACT skill bundle only when -Apply is supplied.
[CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
param(
    [string]$LibraryRoot = $(if ($env:OneDrive) {
        Join-Path $env:OneDrive 'Documents\ScoutSkills\ACT_Skills_for_Scout'
    }),
    [string]$SkillsRoot = (Join-Path $HOME '.copilot\skills'),
    [switch]$Apply
)

$ErrorActionPreference = 'Stop'
if (-not $Apply) {
    Write-Output 'Preview only. Re-run with -Apply to remove all ACT skill junctions.'
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

Write-Output 'Remove MCP profiles separately with Uninstall-ActMcpProfile.ps1 -Profile <profile> -Apply.'
