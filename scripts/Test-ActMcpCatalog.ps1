# Validates the static ACT MCP profile catalog without installing or registering a server.
[CmdletBinding()]
param(
    [string]$CatalogPath = $(if (Test-Path -LiteralPath (Join-Path $PSScriptRoot 'mcp-catalog\profiles.json')) {
        Join-Path $PSScriptRoot 'mcp-catalog\profiles.json'
    }
    else {
        Join-Path $PSScriptRoot '..\mcp-catalog\profiles.json'
    })
)

$ErrorActionPreference = 'Stop'
Import-Module (Join-Path $PSScriptRoot 'ActMcpProfileHelpers.psm1') -Force

$catalog = Get-ActMcpCatalog -CatalogPath $CatalogPath
if ($catalog.schemaVersion -ne 1) {
    throw "Unsupported MCP catalog schema version: $($catalog.schemaVersion)"
}

$profiles = @($catalog.profiles)
if ($profiles.Count -eq 0) {
    throw 'MCP catalog has no profiles.'
}

$duplicateIds = $profiles | Group-Object id | Where-Object { $_.Count -gt 1 }
if ($duplicateIds) {
    throw "MCP catalog has duplicate profile IDs: $($duplicateIds.Name -join ', ')"
}

foreach ($profile in $profiles) {
    if ([string]::IsNullOrWhiteSpace($profile.id) -or [string]::IsNullOrWhiteSpace($profile.status)) {
        throw 'Every MCP profile requires an ID and status.'
    }

    if ($profile.installable) {
        if ($null -eq $profile.configuration -or @($profile.tools).Count -eq 0) {
            throw "Installable MCP profile '$($profile.id)' requires configuration and a nonempty tool allow-list."
        }
        if ($profile.configuration.args -match 'YOUTUBE_MCP_DIRECT_') {
            throw "Profile '$($profile.id)' must not configure a direct-provider environment variable."
        }
    }
    elseif ([string]::IsNullOrWhiteSpace($profile.reason)) {
        throw "Non-installable MCP profile '$($profile.id)' requires a reason."
    }
}

Write-Output "MCP catalog $($catalog.releaseVersion) passed with $($profiles.Count) profiles."
foreach ($status in ($profiles | Group-Object status | Sort-Object Name)) {
    Write-Output "$($status.Name): $($status.Count)"
}
