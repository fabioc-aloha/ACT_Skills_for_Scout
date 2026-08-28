Set-StrictMode -Version Latest

function Get-ActMcpCatalog {
    param([Parameter(Mandatory)][string]$CatalogPath)

    if (-not (Test-Path -LiteralPath $CatalogPath -PathType Leaf)) {
        throw "MCP profile catalog was not found: $CatalogPath"
    }

    try {
        return Get-Content -LiteralPath $CatalogPath -Raw | ConvertFrom-Json
    }
    catch {
        throw "MCP profile catalog is not valid JSON: $($_.Exception.Message)"
    }
}

function Get-ActMcpProfile {
    param(
        [Parameter(Mandatory)]$Catalog,
        [Parameter(Mandatory)][string]$ProfileId
    )

    $profile = @($Catalog.profiles | Where-Object { $_.id -eq $ProfileId })
    if ($profile.Count -ne 1) {
        throw "Unknown MCP profile: $ProfileId"
    }

    return $profile[0]
}

function Resolve-ActMcpProfileEntry {
    param(
        [Parameter(Mandatory)]$Profile,
        [Parameter(Mandatory)][string]$FabricRuntimeRoot,
        [string]$AzureDevOpsOrganization
    )

    if (-not $Profile.installable) {
        throw "MCP profile '$($Profile.id)' is $($Profile.status) and cannot be installed."
    }

    if ($Profile.id -eq 'azure-devops-ro' -and [string]::IsNullOrWhiteSpace($AzureDevOpsOrganization)) {
        throw "MCP profile 'azure-devops-ro' requires -AzureDevOpsOrganization."
    }

    $organization = if ($AzureDevOpsOrganization) { $AzureDevOpsOrganization } else { '' }
    $command = $Profile.configuration.command.Replace('{{fabricRuntimeRoot}}', $FabricRuntimeRoot)
    $arguments = @(
        $Profile.configuration.args | ForEach-Object {
            $_.Replace('{{azureDevOpsOrganization}}', $organization)
        }
    )
    $config = [ordered]@{
        name = $Profile.configuration.name
        type = 'command'
        command = $command
        args = $arguments
    }
    $envFileProperty = $Profile.configuration.PSObject.Properties['envFile']
    if ($envFileProperty) {
        $config.envFile = $envFileProperty.Value
    }

    return [pscustomobject]@{
        builtin = $false
        config = [pscustomobject]$config
        tools = @($Profile.tools)
    }
}

function Test-ActMcpEntry {
    param(
        [Parameter(Mandatory)]$Actual,
        [Parameter(Mandatory)]$Expected
    )

    return ($Actual | ConvertTo-Json -Depth 10 -Compress) -eq
        ($Expected | ConvertTo-Json -Depth 10 -Compress)
}

function Get-ActMcpConfiguration {
    param([Parameter(Mandatory)][string]$McpConfigPath)

    if (-not (Test-Path -LiteralPath $McpConfigPath -PathType Leaf)) {
        throw "Scout MCP configuration was not found: $McpConfigPath"
    }

    try {
        $configuration = Get-Content -LiteralPath $McpConfigPath -Raw | ConvertFrom-Json
    }
    catch {
        throw "Scout MCP configuration is not valid JSON: $($_.Exception.Message)"
    }

    if ($null -eq $configuration.servers) {
        throw "Scout MCP configuration has no root 'servers' object: $McpConfigPath"
    }

    return $configuration
}

function Save-ActMcpConfiguration {
    param(
        [Parameter(Mandatory)]$Configuration,
        [Parameter(Mandatory)][string]$McpConfigPath
    )

    $baseBackupPath = "$McpConfigPath.backup-$(Get-Date -Format 'yyyyMMddHHmmss')"
    $backupPath = $baseBackupPath
    $suffix = 1
    while (Test-Path -LiteralPath $backupPath) {
        $backupPath = "$baseBackupPath-$suffix"
        $suffix++
    }

    Copy-Item -LiteralPath $McpConfigPath -Destination $backupPath
    $json = $Configuration | ConvertTo-Json -Depth 10
    [System.IO.File]::WriteAllText(
        $McpConfigPath,
        "$json$([Environment]::NewLine)",
        [System.Text.UTF8Encoding]::new($false)
    )

    return $backupPath
}
