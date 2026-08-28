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
    [string]$YouTubeRuntimeRoot = (Join-Path $HOME '.scout\mcp-runtimes\youtube-mcp-tools'),
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
    return
}
$entry = Resolve-ActMcpProfileEntry `
    -Profile $selectedProfile `
    -FabricRuntimeRoot $FabricRuntimeRoot `
    -YouTubeRuntimeRoot $YouTubeRuntimeRoot `
    -AzureDevOpsOrganization $AzureDevOpsOrganization

if (-not $Apply) {
    Write-Output "Preview only for profile '$Profile' ($($selectedProfile.status))."
    Write-Output "Canary after restart: $($selectedProfile.canary)"
    Write-Output ($entry | ConvertTo-Json -Depth 10)
    return
}

if ($Profile -eq 'fabric-docs-ro') {
    $fabricExecutable = Join-Path $FabricRuntimeRoot $selectedProfile.runtime.executable
    if (-not (Test-Path -LiteralPath $fabricExecutable -PathType Leaf)) {
        if ($WhatIfPreference) {
            Write-Output "What if: install $($selectedProfile.runtime.package) $($selectedProfile.runtime.version) to $FabricRuntimeRoot."
            return
        }

        $dotnet = Get-Command dotnet -ErrorAction SilentlyContinue
        $dotnetPath = if ($dotnet) { $dotnet.Path } else { $null }
        $sdks = if ($dotnetPath) { @(& $dotnetPath --list-sdks 2>$null) } else { @() }
        $minimumSdkPattern = "^$($selectedProfile.runtime.minimumSdkMajor)\."
        if (-not ($sdks | Where-Object { $_ -match $minimumSdkPattern })) {
            $winget = Get-Command winget -ErrorAction SilentlyContinue
            if (-not $winget) {
                throw "Profile 'fabric-docs-ro' requires .NET $($selectedProfile.runtime.minimumSdkMajor) SDK or later, but winget is unavailable to install it."
            }

            if ($PSCmdlet.ShouldProcess(
                'Microsoft.DotNet.SDK.10',
                "Install .NET $($selectedProfile.runtime.minimumSdkMajor) SDK prerequisite"
            )) {
                & $winget.Path install `
                    --id Microsoft.DotNet.SDK.10 `
                    --exact `
                    --silent `
                    --accept-package-agreements `
                    --accept-source-agreements
                if ($LASTEXITCODE -ne 0) {
                    throw "Failed to install the .NET $($selectedProfile.runtime.minimumSdkMajor) SDK prerequisite."
                }
            }

            $dotnet = Get-Command dotnet -ErrorAction SilentlyContinue
            if (-not $dotnet) {
                $defaultDotnetPath = Join-Path $env:ProgramFiles 'dotnet\dotnet.exe'
                if (Test-Path -LiteralPath $defaultDotnetPath -PathType Leaf) {
                    $dotnet = Get-Item -LiteralPath $defaultDotnetPath
                }
            }
            $dotnetPath = if ($dotnet.PSObject.Properties['Path']) {
                $dotnet.Path
            }
            else {
                $dotnet.FullName
            }
            $sdks = if ($dotnetPath) { @(& $dotnetPath --list-sdks 2>$null) } else { @() }
            if (-not ($sdks | Where-Object { $_ -match $minimumSdkPattern })) {
                throw "Profile 'fabric-docs-ro' requires a .NET $($selectedProfile.runtime.minimumSdkMajor) SDK or later."
            }
        }

        if ($PSCmdlet.ShouldProcess(
            $FabricRuntimeRoot,
            "Install $($selectedProfile.runtime.package) $($selectedProfile.runtime.version)"
        )) {
            New-Item -ItemType Directory -Path $FabricRuntimeRoot -Force | Out-Null
            & $dotnetPath tool install `
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

if ($Profile -eq 'youtube-mcp-tools') {
    $youtubeExecutable = Join-Path $YouTubeRuntimeRoot $selectedProfile.runtime.executable
    if (Test-Path -LiteralPath $youtubeExecutable -PathType Leaf) {
        $actualCommit = (& git -C $YouTubeRuntimeRoot rev-parse HEAD).Trim()
        if ($LASTEXITCODE -ne 0 -or $actualCommit -ne $selectedProfile.runtime.commit) {
            throw "YouTube MCP runtime does not match the reviewed source commit: $YouTubeRuntimeRoot"
        }
    }
    else {
        if ($WhatIfPreference) {
            Write-Output "What if: build YouTube MCP source $($selectedProfile.runtime.commit) in $YouTubeRuntimeRoot."
            return
        }
        if (Test-Path -LiteralPath $YouTubeRuntimeRoot) {
            throw "YouTube MCP runtime path already exists and is not the reviewed build: $YouTubeRuntimeRoot"
        }

        $git = Get-Command git -ErrorAction SilentlyContinue
        $node = Get-Command node -ErrorAction SilentlyContinue
        if (-not $git -or -not $node) {
            throw "Profile 'youtube-mcp-tools' requires Git and Node.js $($selectedProfile.runtime.minimumNodeMajor) or later."
        }
        $nodeMajor = [int]((& $node.Path --version).TrimStart('v').Split('.')[0])
        if ($nodeMajor -lt $selectedProfile.runtime.minimumNodeMajor) {
            throw "Profile 'youtube-mcp-tools' requires Node.js $($selectedProfile.runtime.minimumNodeMajor) or later."
        }

        if ($PSCmdlet.ShouldProcess(
            $YouTubeRuntimeRoot,
            "Build YouTube MCP source $($selectedProfile.runtime.commit)"
        )) {
            & $git.Path clone --quiet --no-checkout $selectedProfile.runtime.repository $YouTubeRuntimeRoot
            if ($LASTEXITCODE -ne 0) {
                throw 'Failed to clone the reviewed YouTube MCP source.'
            }
            & $git.Path -C $YouTubeRuntimeRoot checkout --quiet $selectedProfile.runtime.commit
            if ($LASTEXITCODE -ne 0) {
                throw 'Failed to check out the reviewed YouTube MCP source commit.'
            }
            & npm --prefix $YouTubeRuntimeRoot install --ignore-scripts --no-audit --no-fund --loglevel=error
            if ($LASTEXITCODE -ne 0) {
                throw 'Failed to restore the reviewed YouTube MCP dependencies.'
            }
            & npm --prefix $YouTubeRuntimeRoot run build
            if ($LASTEXITCODE -ne 0) {
                throw 'Failed to build the reviewed YouTube MCP source.'
            }
        }
    }

    if (-not (Test-Path -LiteralPath $youtubeExecutable -PathType Leaf)) {
        throw "YouTube MCP executable was not found after the reviewed build: $youtubeExecutable"
    }
}

$configuration = Get-ActMcpConfiguration -McpConfigPath $McpConfigPath
$existingProperty = $configuration.servers.PSObject.Properties[$entry.config.name]
if ($existingProperty) {
    if (Test-ActMcpEntry -Actual $existingProperty.Value -Expected $entry) {
        Write-Output "MCP profile '$Profile' is already registered with the reviewed configuration."
        return
    }

    $legacyToolsProperty = $selectedProfile.PSObject.Properties['legacyTools']
    if ($legacyToolsProperty) {
        $legacyEntry = [pscustomobject]@{
            builtin = $entry.builtin
            config = $entry.config
            tools = @($legacyToolsProperty.Value)
        }
        if (Test-ActMcpEntry -Actual $existingProperty.Value -Expected $legacyEntry) {
            if ($PSCmdlet.ShouldProcess(
                $McpConfigPath,
                "Replace the known legacy '$($entry.config.name)' entry with the reviewed read-only profile"
            )) {
                [void]$configuration.servers.PSObject.Properties.Remove($entry.config.name)
                $configuration.servers | Add-Member -MemberType NoteProperty -Name $entry.config.name -Value $entry
                $backupPath = Save-ActMcpConfiguration -Configuration $configuration -McpConfigPath $McpConfigPath
                Write-Output "Hardened the known legacy MCP profile '$Profile'. Backup: $backupPath"
                Write-Output "Restart Scout, then run the reviewed canary: $($selectedProfile.canary)"
            }
            elseif (-not $WhatIfPreference) {
                throw "Legacy MCP profile '$Profile' was not hardened."
            }
            return
        }
    }

    throw "The existing '$($entry.config.name)' entry differs from profile '$Profile' and was not changed."
}

if ($PSCmdlet.ShouldProcess($McpConfigPath, "Register MCP profile '$Profile'")) {
    $configuration.servers | Add-Member -MemberType NoteProperty -Name $entry.config.name -Value $entry
    $backupPath = Save-ActMcpConfiguration -Configuration $configuration -McpConfigPath $McpConfigPath
    Write-Output "Registered MCP profile '$Profile'. Backup: $backupPath"
    Write-Output "Restart Scout, then run the reviewed canary: $($selectedProfile.canary)"
}
