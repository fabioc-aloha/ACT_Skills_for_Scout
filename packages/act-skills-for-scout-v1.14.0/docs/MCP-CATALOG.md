# ACT MCP Profile Catalog

## Purpose

The MCP catalog ships reviewed profile definitions with the ACT skill library.
Applied ACT skill installation automatically registers the validated default
profiles; individual profile scripts remain available for preview, removal, and
exception handling.

## Install a Profile

From the published OneDrive library, preview or manage one profile:

```powershell
.\Install-ActMcpProfile.ps1 -Profile flint
```

Then register exactly that profile:

```powershell
.\Install-ActMcpProfile.ps1 -Profile flint -Apply -Confirm:$false
```

The installer backs up `%USERPROFILE%\.scout\m-mcp-servers.json`, refuses to
replace a nonmatching entry, and exposes only the profile's reviewed tool list.
It may replace only an exact match to a catalogued legacy profile with its
reviewed hardened successor. Restart Scout and run the profile's recorded
harmless canary.

To remove a profile, pass the same profile-specific arguments used at
installation:

```powershell
.\Uninstall-ActMcpProfile.ps1 -Profile flint -Apply -Confirm:$false
```

The profile uninstall script removes only an exact configuration match and
creates another timestamped backup.

## Catalog

| Profile | Status | Boundary and canary |
| --- | --- | --- |
| `flint` | Production | Pinned `flint-chart-mcp@0.5.1` with local file references disabled; canary: `validate_chart` using inline data. |
| `fabric-docs-ro` | Production | Pinned `Microsoft.Fabric.Mcp` 1.4.0 in local docs-only, read-only mode; no tenant access; canary: `docs` with `learn=true`. Requires .NET 10 SDK or later. |
| `azure-devops-ro` | Controlled pilot | Pinned `@azure-devops/mcp@2.9.0`, one supplied organization, interactive authentication, and host-level read-only tool filtering; canary: `core_list_projects`. |
| `azure-kusto-ro` | Controlled pilot | Pinned `@azure/mcp@3.0.0-beta.38` in read-only Kusto namespace mode; canary: use the `kusto` tool with `--learn`. Requires approved Azure identity and RBAC. |
| `fabric-rti-ro` | Controlled pilot | Pinned `microsoft-fabric-rti-mcp==0.6.2`; only reviewed Kusto query/schema/diagnostic tools; canary: `kusto_known_services`. Requires `uvx` and an explicit non-production service allow-list in `${mcpEnvDir}/fabric-rti.env`. |
| `youtube-mcp-tools` | Controlled pilot | Source-pinned, locally built YouTube research server at commit `0130a118a78432c82b6b3081ed866fc08bae9569`; no direct-provider variables are configured; canary: `youtube_quota_status`. |
| `powerbi-remote-pilot` | Controlled pilot, not installable | The `GetReportMetadata` canary passed against CPE Profiles Hub v1 on 2026-08-28. Scout exposed schema, report, visual, and DAX tools beyond the configured metadata allow-list, so the catalog does not automatically register this remote server until host-enforced tool filtering is demonstrated. |
| `m365-workiq-native` | Managed availability | Scout-provided WorkIQ capability. Confirm it is exposed by the host; do not register a duplicate external Work IQ MCP. |
| `synapse` | Deferred | No verified Microsoft-supported Synapse-specific MCP server contract exists. |
| `fabric-ontology` | Controlled pilot | Official hosted Fabric IQ Ontology Preview; it lacks a fixed tool/read-only/OAuth/versioning contract. |
| `fabric-sql-endpoint` | Controlled pilot | Official hosted Fabric SQL Endpoint Preview; its `executeSQL` tool is read/write and has no server-side read-only control. |
| `powerbi-modeling` | Controlled pilot | Official local Preview server with broad model capabilities and a preview EULA. |
| `synapse-cdata` | Controlled pilot | Vendor MCP requiring CData licensing, a dedicated read-only identity, and vendor security approval. |
| `synapse-quanti` | Discovery only | Third-party hosted MCP pending data handling, credential, and retention due diligence. |
| `synapse-community` | Discovery only | Unverified community implementations; do not install. |

See [`FABRIC-SYNAPSE-EVIDENCE.md`](FABRIC-SYNAPSE-EVIDENCE.md) for the
provenance, safety boundary, and admission path of every Fabric and Synapse
evidence record.

## Profile-Specific Requirements

`azure-devops-ro` requires an organization name:

```powershell
.\Install-ActMcpProfile.ps1 `
  -Profile azure-devops-ro `
  -AzureDevOpsOrganization <organization> `
  -Apply `
  -Confirm:$false
```

`fabric-docs-ro` installs only its pinned .NET tool into
`%USERPROFILE%\.scout\mcp-runtimes\fabric-docs` after explicit application. It
does not access a Fabric tenant or workspace. If the .NET 10 SDK is absent, the
automatic installer uses the pinned `Microsoft.DotNet.SDK.10` winget package.

Before installing `fabric-rti-ro`, create the reviewed host environment file
with `KUSTO_ALLOW_UNKNOWN_SERVICES=false` and an explicit
`KUSTO_KNOWN_SERVICES` allow-list of non-production endpoints. Do not include
credentials in the catalog, source package, or shared library.

Applied ACT installation automatically registers `flint`, `fabric-docs-ro`,
`azure-devops-ro` for `GlobalCustomerExperience`, `azure-kusto-ro`,
and `youtube-mcp-tools`. It registers `fabric-rti-ro` only after validating the
environment file above. It does not install Power BI Remote Pilot or any other
managed, deferred, or discovery-only catalog record.

The non-mutating `Test-ActMcpRegistrations.ps1` checks that all five automatic
profiles match their reviewed configuration. Run it after installation and
after any Scout update:

```powershell
.\Test-ActMcpRegistrations.ps1
```

Use `Uninstall-ActMcpProfile.ps1 -Profile powerbi-remote-pilot -Apply` to
remove an existing Power BI registration. The removal flow accepts the
user-specific OAuth alias that Scout adds locally, but no package configuration
contains that alias.

The YouTube profile clones and builds its reviewed source commit into
`%USERPROFILE%\.scout\mcp-runtimes\youtube-mcp-tools`. It exposes public
transcript and local rendering/prompt tools only, and does not configure
`YOUTUBE_API_KEY` or any
`YOUTUBE_MCP_DIRECT_*` variable. Treat any later credential or external
direct-provider configuration as a separate approval and data-egress decision.
The automatic installer recognizes only the catalogued prior broad YouTube
allow-list and replaces it with this credential-free allow-list.

## Admission Rules

Add or update a profile only after recording a pinned and independently
resolvable artifact, reviewed tool list, authentication boundary, data-egress
path, nonmutating canary, and exact uninstall match. A server without these
facts remains deferred or controlled pilot; it must not be silently substituted
with a floating package, an unpinned Git reference, or a different server.
