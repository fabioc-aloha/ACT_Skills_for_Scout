# Publishes when requested, then installs the entire user-global ACT skill bundle.
# The script is intentionally non-mutating until the caller supplies -Apply.
[CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
param(
    [string]$LibraryRoot = $(if ($env:OneDrive) {
        Join-Path $env:OneDrive 'Documents\ScoutSkills\ACT_Skills_for_Scout'
    }),
    [string]$SkillsRoot = (Join-Path $HOME '.copilot\skills'),
    [switch]$Publish,
    [switch]$Apply,
    [switch]$ExcalidrawDisabled,
    [string]$ScoutSettingsPath = (Join-Path $HOME '.scout\m-settings.json'),
    [string]$McpConfigPath = (Join-Path $HOME '.scout\m-mcp-servers.json'),
    [string]$FabricRuntimeRoot = (Join-Path $HOME '.scout\mcp-runtimes\fabric-docs'),
    [string]$YouTubeRuntimeRoot = (Join-Path $HOME '.scout\mcp-runtimes\youtube-mcp-tools'),
    [string]$McpEnvironmentRoot = (Join-Path $HOME '.scout\mcp-env'),
    [string]$AzureDevOpsOrganization = 'GlobalCustomerExperience'
)

$ErrorActionPreference = 'Stop'
if (-not $Apply) {
    Write-Output 'Preview only. Re-run with -Apply to publish/link all ACT skills.'
    exit 0
}

if (-not $ExcalidrawDisabled) {
    Write-Warning 'The bundled /excalidraw skill can interfere with the Mermaid and Illustrator skills.'
    $confirmation = Read-Host 'Disable /excalidraw in Scout, then enter Y to continue [Y/N]'
    if ($confirmation -notmatch '^(?i:y|yes)$') {
        throw 'Installation cancelled. Disable the bundled /excalidraw skill in Scout, then rerun the installer.'
    }
}

if (-not (Test-Path -LiteralPath $ScoutSettingsPath -PathType Leaf)) {
    throw "Scout settings were not found: $ScoutSettingsPath"
}

try {
    $scoutSettings = Get-Content -LiteralPath $ScoutSettingsPath -Raw | ConvertFrom-Json
}
catch {
    throw "Scout settings are not valid JSON: $($_.Exception.Message)"
}

$copilotCliSkillsProperty = $scoutSettings.PSObject.Properties['loadCopilotCliSkills']
if ($copilotCliSkillsProperty -and $copilotCliSkillsProperty.Value -isnot [bool]) {
    throw "Scout setting 'loadCopilotCliSkills' must be a Boolean: $ScoutSettingsPath"
}

if (-not $copilotCliSkillsProperty -or -not $copilotCliSkillsProperty.Value) {
    $baseBackupPath = "$ScoutSettingsPath.backup-$(Get-Date -Format 'yyyyMMddHHmmss')"
    $backupPath = $baseBackupPath
    $suffix = 1
    while (Test-Path -LiteralPath $backupPath) {
        $backupPath = "$baseBackupPath-$suffix"
        $suffix++
    }

    if ($PSCmdlet.ShouldProcess(
        $ScoutSettingsPath,
        "Enable Copilot CLI skill loading and create backup $backupPath"
    )) {
        if ($copilotCliSkillsProperty) {
            $copilotCliSkillsProperty.Value = $true
        }
        else {
            $scoutSettings | Add-Member -MemberType NoteProperty -Name 'loadCopilotCliSkills' -Value $true
        }

        Copy-Item -LiteralPath $ScoutSettingsPath -Destination $backupPath
        $json = $scoutSettings | ConvertTo-Json -Depth 20
        [System.IO.File]::WriteAllText(
            $ScoutSettingsPath,
            "$json$([Environment]::NewLine)",
            [System.Text.UTF8Encoding]::new($false)
        )
        Write-Output "Enabled Copilot CLI skill loading. Backup: $backupPath"
    }
    elseif (-not $WhatIfPreference) {
        throw 'Installation cancelled because Copilot CLI skill loading was not enabled.'
    }
}
else {
    Write-Output 'Copilot CLI skill loading is already enabled.'
}

$publisher = Join-Path $PSScriptRoot 'Publish-ActScoutBundleToOneDrive.ps1'
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
$profileInstaller = Join-Path $PSScriptRoot 'Install-ActMcpProfile.ps1'
$automaticProfiles = @(
    'flint',
    'fabric-docs-ro',
    'azure-devops-ro',
    'azure-kusto-ro',
    'youtube-mcp-tools',
    'powerbi-remote-pilot'
)
$fabricRtiEnvironmentFile = Join-Path $McpEnvironmentRoot 'fabric-rti.env'
if (Test-Path -LiteralPath $fabricRtiEnvironmentFile -PathType Leaf) {
    $fabricRtiEnvironment = Get-Content -LiteralPath $fabricRtiEnvironmentFile -Raw
    $allowUnknownServicesDisabled = $fabricRtiEnvironment -match '(?m)^\s*KUSTO_ALLOW_UNKNOWN_SERVICES\s*=\s*false\s*(?:#.*)?$'
    $knownServicesConfigured = $fabricRtiEnvironment -match '(?m)^\s*KUSTO_KNOWN_SERVICES\s*=\s*\S+'
    if (-not $allowUnknownServicesDisabled -or -not $knownServicesConfigured) {
        throw "Fabric RTI environment file must disable unknown services and define KUSTO_KNOWN_SERVICES: $fabricRtiEnvironmentFile"
    }

    $automaticProfiles += 'fabric-rti-ro'
}
elseif (-not $WhatIfPreference) {
    Write-Warning "Fabric RTI was not registered because its non-production allow-list file is absent: $fabricRtiEnvironmentFile"
}

if (-not (Test-Path -LiteralPath $profileInstaller -PathType Leaf)) {
    throw "MCP profile installer was not found: $profileInstaller"
}

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

foreach ($profile in $automaticProfiles) {
    $profileParameters = @{
        Profile = $profile
        Apply = $true
        Confirm = $false
        McpConfigPath = $McpConfigPath
        FabricRuntimeRoot = $FabricRuntimeRoot
        YouTubeRuntimeRoot = $YouTubeRuntimeRoot
    }
    if ($profile -eq 'azure-devops-ro') {
        $profileParameters.AzureDevOpsOrganization = $AzureDevOpsOrganization
    }
    if ($WhatIfPreference) {
        $profileParameters.WhatIf = $true
    }

    & $profileInstaller @profileParameters
}

if (-not (Test-Path -LiteralPath $fabricRtiEnvironmentFile -PathType Leaf)) {
    Write-Output 'Fabric RTI remains unregistered until its validated non-production Kusto allow-list is supplied.'
}
Write-Output 'Restart Scout to discover the user-global ACT skills.'
