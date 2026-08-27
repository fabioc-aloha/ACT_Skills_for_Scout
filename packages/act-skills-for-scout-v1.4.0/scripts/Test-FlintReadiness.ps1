[CmdletBinding()]
param(
    [Parameter(Mandatory)]
    [ValidateNotNullOrEmpty()]
    [string]$RuntimeRoot,
    [string[]]$AvailableMcpTool = @()
)

$ErrorActionPreference = 'Stop'
$expectedVersion = '0.5.1'
$packageName = 'flint-chart-mcp'
$expectedTools = @(
    'render_chart',
    'compile_chart',
    'validate_chart',
    'list_chart_types',
    'list_themes',
    'create_chart_view'
)

function Get-CommandVersion {
    param(
        [Parameter(Mandatory)]
        [string]$Command,
        [Parameter(Mandatory)]
        [string[]]$Arguments
    )

    $commandInfo = Get-Command -Name $Command -ErrorAction SilentlyContinue
    if (-not $commandInfo) {
        return [pscustomobject]@{ Available = $false; Path = $null; Version = $null }
    }

    $version = (& $commandInfo.Source @Arguments 2>$null | Select-Object -First 1).Trim()
    return [pscustomobject]@{
        Available = $true
        Path = $commandInfo.Source
        Version = $version
    }
}

$node = Get-CommandVersion -Command 'node' -Arguments @('--version')
$npm = Get-CommandVersion -Command 'npm' -Arguments @('--version')
$nodeCommand = if ($node.Path) { $node.Path } else { 'node' }
$registry = $null
if ($npm.Available) {
    $registry = (& $npm.Path config get registry 2>$null | Select-Object -First 1).Trim()
    if (-not $registry) {
        $registry = '(npm returned no configured registry)'
    }
}

$packagePath = Join-Path $RuntimeRoot 'node_modules\flint-chart-mcp\package.json'
$installedVersion = $null
$packageState = 'not installed at the selected runtime root'
if (Test-Path -LiteralPath $packagePath -PathType Leaf) {
    try {
        $installedVersion = (Get-Content -LiteralPath $packagePath -Raw | ConvertFrom-Json).version
        $packageState = if ($installedVersion -eq $expectedVersion) {
            'installed at the reviewed pin'
        }
        else {
            "installed at $installedVersion (reviewed pin is $expectedVersion)"
        }
    }
    catch {
        $packageState = "package metadata could not be read: $($_.Exception.Message)"
    }
}

$observedTools = @($AvailableMcpTool | Where-Object { -not [string]::IsNullOrWhiteSpace($_) } | Sort-Object -Unique)
$missingTools = @($expectedTools | Where-Object { $_ -notin $observedTools })

Write-Output 'Flint MCP readiness preview (non-mutating)'
Write-Output "runtime root: $RuntimeRoot"
Write-Output "node: $($node.Available) $($node.Version) $($node.Path)"
Write-Output "npm: $($npm.Available) $($npm.Version) $($npm.Path)"
Write-Output "configured registry: $(if ($registry) { $registry } else { '(unavailable because npm was not found)' })"
Write-Output "package state: $packageState"

if ($observedTools.Count -eq 0) {
    Write-Output 'MCP tools: unverified; no host-discovered tool names were supplied.'
    Write-Output 'MCP configuration discovery: required; this preview does not search unknown host configuration locations.'
}
else {
    Write-Output "observed MCP tools: $($observedTools -join ', ')"
    Write-Output "missing reviewed tools: $(if ($missingTools.Count) { $missingTools -join ', ' } else { '(none)' })"
}

Write-Output ''
Write-Output 'Exact approval-gated plan:'
if (-not $node.Available -or -not $npm.Available) {
    Write-Output '1. Install Node.js and npm through an approved machine policy, then rerun this preview.'
}
else {
    Write-Output "1. Review the configured registry above; do not install until it is explicitly approved."
    Write-Output "2. If the selected runtime is absent or not $expectedVersion, run:"
    Write-Output "   & `"$($npm.Path)`" install --prefix `"$RuntimeRoot`" --save-exact --no-audit --no-fund $packageName@$expectedVersion"
}
Write-Output '3. Discover the Scout host-specific MCP configuration location and schema; do not guess or write it.'
Write-Output "4. After explicit approval, configure stdio server 'flint' with command `"$nodeCommand`" and argument `"$RuntimeRoot\node_modules\$packageName\dist\cli.js`"."
Write-Output "5. Reload only as documented by the host, then confirm: $($expectedTools -join ', ')."
Write-Output '6. Validate and visually inspect a harmless canary render before relying on the capability.'
Write-Output 'Rollback: reinstall the recorded previously working exact package version at this same runtime root, restore the approved host launch path if needed, reload, and repeat the canary.'
Write-Output 'This preview did not install packages, download content, write MCP configuration, enter secrets, or accept terms.'
