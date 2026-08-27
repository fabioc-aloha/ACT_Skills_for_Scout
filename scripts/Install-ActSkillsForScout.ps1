[CmdletBinding(SupportsShouldProcess)]
param(
    [string]$LibraryRoot = (Join-Path $PSScriptRoot 'skills'),
    [string]$SkillsRoot = (Join-Path $HOME '.copilot\skills')
)

$ErrorActionPreference = 'Stop'

$libraryPath = (Resolve-Path -LiteralPath $LibraryRoot).Path
$skills = Get-ChildItem -LiteralPath $libraryPath -Directory |
    Where-Object { Test-Path -LiteralPath (Join-Path $_.FullName 'SKILL.md') }

if ($skills.Count -eq 0) {
    throw "No direct skill folders with SKILL.md were found in $libraryPath."
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
