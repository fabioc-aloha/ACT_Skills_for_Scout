# Verifies the installed automatic MCP registrations without changing Scout configuration.
[CmdletBinding()]
param(
    [string]$CatalogPath = $(if (Test-Path -LiteralPath (Join-Path $PSScriptRoot 'mcp-catalog\profiles.json')) {
        Join-Path $PSScriptRoot 'mcp-catalog\profiles.json'
    }
    else {
        Join-Path $PSScriptRoot '..\mcp-catalog\profiles.json'
    }),
    [string]$McpConfigPath = (Join-Path $HOME '.scout\m-mcp-servers.json'),
    [string]$FabricRuntimeRoot = (Join-Path $HOME '.scout\mcp-runtimes\fabric-docs'),
    [string]$YouTubeRuntimeRoot = (Join-Path $HOME '.scout\mcp-runtimes\youtube-mcp-tools'),
    [string]$AzureDevOpsOrganization = 'GlobalCustomerExperience',
    [string[]]$Profile = @(
        'flint',
        'fabric-docs-ro',
        'azure-devops-ro',
        'azure-kusto-ro',
        'youtube-mcp-tools'
    )
)

$ErrorActionPreference = 'Stop'
Import-Module (Join-Path $PSScriptRoot 'ActMcpProfileHelpers.psm1') -Force

$catalog = Get-ActMcpCatalog -CatalogPath $CatalogPath
$configuration = Get-ActMcpConfiguration -McpConfigPath $McpConfigPath
$failures = @()

foreach ($profileId in $Profile) {
    $selectedProfile = Get-ActMcpProfile -Catalog $catalog -ProfileId $profileId
    if (-not $selectedProfile.installable) {
        $failures += "Profile '$profileId' is not installable."
        continue
    }

    $expected = Resolve-ActMcpProfileEntry `
        -Profile $selectedProfile `
        -FabricRuntimeRoot $FabricRuntimeRoot `
        -YouTubeRuntimeRoot $YouTubeRuntimeRoot `
        -AzureDevOpsOrganization $AzureDevOpsOrganization
    $actualProperty = $configuration.servers.PSObject.Properties[$expected.config.name]
    if (-not $actualProperty) {
        $failures += "Profile '$profileId' is not registered."
        continue
    }
    if (-not (Test-ActMcpEntry -Actual $actualProperty.Value -Expected $expected)) {
        $failures += "Profile '$profileId' differs from its reviewed configuration."
        continue
    }

    Write-Output "MCP profile '$profileId' matches its reviewed configuration."
}

if ($failures) {
    throw ($failures -join [Environment]::NewLine)
}

Write-Output "Validated $($Profile.Count) MCP registration(s)."
