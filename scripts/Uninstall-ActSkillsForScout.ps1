[CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
param(
    [string]$LibraryRoot = (Join-Path $PSScriptRoot 'skills'),
    [string]$SkillsRoot = (Join-Path $HOME '.copilot\skills')
)

$ErrorActionPreference = 'Stop'

$libraryPath = (Resolve-Path -LiteralPath $LibraryRoot).Path
$skills = Get-ChildItem -LiteralPath $libraryPath -Directory |
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
