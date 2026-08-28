# Removes one exact ACT MCP profile registration only when -Apply is supplied.
[CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
param(
    [Parameter(Mandatory)][string]$Profile,
    [switch]$Apply,
    [string]$CatalogPath = $(if (Test-Path -LiteralPath (Join-Path $PSScriptRoot 'mcp-catalog\profiles.json')) {
        Join-Path $PSScriptRoot 'mcp-catalog\profiles.json'
    }
    else {
        Join-Path $PSScriptRoot '..\mcp-catalog\profiles.json'
    }),
    [string]$McpConfigPath = (Join-Path $HOME '.scout\m-mcp-servers.json'),
    [string]$FabricRuntimeRoot = (Join-Path $HOME '.scout\mcp-runtimes\fabric-docs'),
    [string]$AzureDevOpsOrganization
)

$ErrorActionPreference = 'Stop'
Import-Module (Join-Path $PSScriptRoot 'ActMcpProfileHelpers.psm1') -Force

$catalog = Get-ActMcpCatalog -CatalogPath $CatalogPath
$selectedProfile = Get-ActMcpProfile -Catalog $catalog -ProfileId $Profile
$entry = Resolve-ActMcpProfileEntry `
    -Profile $selectedProfile `
    -FabricRuntimeRoot $FabricRuntimeRoot `
    -AzureDevOpsOrganization $AzureDevOpsOrganization

if (-not $Apply) {
    Write-Output "Preview only for removal of profile '$Profile'."
    Write-Output ($entry | ConvertTo-Json -Depth 10)
    exit 0
}

$configuration = Get-ActMcpConfiguration -McpConfigPath $McpConfigPath
$existingProperty = $configuration.servers.PSObject.Properties[$entry.config.name]
if (-not $existingProperty) {
    Write-Output "MCP profile '$Profile' is not registered; nothing was changed."
    exit 0
}

if (-not (Test-ActMcpEntry -Actual $existingProperty.Value -Expected $entry)) {
    throw "The existing '$($entry.config.name)' entry differs from profile '$Profile' and was not removed."
}

if ($PSCmdlet.ShouldProcess($McpConfigPath, "Remove MCP profile '$Profile'")) {
    [void]$configuration.servers.PSObject.Properties.Remove($entry.config.name)
    $backupPath = Save-ActMcpConfiguration -Configuration $configuration -McpConfigPath $McpConfigPath
    Write-Output "Removed MCP profile '$Profile'. Backup: $backupPath"
    Write-Output 'Restart Scout to unload the server.'
}
