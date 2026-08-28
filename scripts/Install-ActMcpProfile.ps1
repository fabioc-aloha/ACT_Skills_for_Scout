# Registers one reviewed ACT MCP profile only when -Apply is supplied.
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
if (-not $selectedProfile.installable) {
    Write-Output "Profile '$Profile' is $($selectedProfile.status)."
    Write-Output $selectedProfile.summary
    Write-Output $selectedProfile.reason
    if ($Apply) {
        throw "MCP profile '$Profile' cannot be installed."
    }
    exit 0
}
$entry = Resolve-ActMcpProfileEntry `
    -Profile $selectedProfile `
    -FabricRuntimeRoot $FabricRuntimeRoot `
    -AzureDevOpsOrganization $AzureDevOpsOrganization

if (-not $Apply) {
    Write-Output "Preview only for profile '$Profile' ($($selectedProfile.status))."
    Write-Output "Canary after restart: $($selectedProfile.canary)"
    Write-Output ($entry | ConvertTo-Json -Depth 10)
    exit 0
}

if ($Profile -eq 'fabric-docs-ro') {
    $fabricExecutable = Join-Path $FabricRuntimeRoot $selectedProfile.runtime.executable
    if (-not (Test-Path -LiteralPath $fabricExecutable -PathType Leaf)) {
        if ($WhatIfPreference) {
            Write-Output "What if: install $($selectedProfile.runtime.package) $($selectedProfile.runtime.version) to $FabricRuntimeRoot."
            exit 0
        }

        $dotnet = Get-Command dotnet -ErrorAction SilentlyContinue
        if (-not $dotnet) {
            throw "Profile 'fabric-docs-ro' requires a .NET $($selectedProfile.runtime.minimumSdkMajor) SDK or later."
        }

        $sdks = @(& $dotnet.Path --list-sdks 2>$null)
        $minimumSdkPattern = "^$($selectedProfile.runtime.minimumSdkMajor)\."
        if (-not ($sdks | Where-Object { $_ -match $minimumSdkPattern })) {
            throw "Profile 'fabric-docs-ro' requires a .NET $($selectedProfile.runtime.minimumSdkMajor) SDK or later."
        }

        if ($PSCmdlet.ShouldProcess(
            $FabricRuntimeRoot,
            "Install $($selectedProfile.runtime.package) $($selectedProfile.runtime.version)"
        )) {
            New-Item -ItemType Directory -Path $FabricRuntimeRoot -Force | Out-Null
            & $dotnet.Path tool install `
                --tool-path $FabricRuntimeRoot `
                $selectedProfile.runtime.package `
                --version $selectedProfile.runtime.version
            if ($LASTEXITCODE -ne 0) {
                throw "Failed to install $($selectedProfile.runtime.package) $($selectedProfile.runtime.version)."
            }
        }
    }

    if (-not (Test-Path -LiteralPath $fabricExecutable -PathType Leaf)) {
        throw "Fabric MCP executable was not found after installation: $fabricExecutable"
    }
}

$configuration = Get-ActMcpConfiguration -McpConfigPath $McpConfigPath
$existingProperty = $configuration.servers.PSObject.Properties[$entry.config.name]
if ($existingProperty) {
    if (Test-ActMcpEntry -Actual $existingProperty.Value -Expected $entry) {
        Write-Output "MCP profile '$Profile' is already registered with the reviewed configuration."
        exit 0
    }

    throw "The existing '$($entry.config.name)' entry differs from profile '$Profile' and was not changed."
}

if ($PSCmdlet.ShouldProcess($McpConfigPath, "Register MCP profile '$Profile'")) {
    $configuration.servers | Add-Member -MemberType NoteProperty -Name $entry.config.name -Value $entry
    $backupPath = Save-ActMcpConfiguration -Configuration $configuration -McpConfigPath $McpConfigPath
    Write-Output "Registered MCP profile '$Profile'. Backup: $backupPath"
    Write-Output "Restart Scout, then run the reviewed canary: $($selectedProfile.canary)"
}
