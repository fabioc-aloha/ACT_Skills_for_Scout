# ACT MCP Profile Catalog

## Purpose

The MCP catalog ships reviewed profile definitions with the ACT skill library.
Profiles are individually previewed, installed, and removed; installing the ACT
skills never registers an MCP server implicitly.

## Install a Profile

From the published OneDrive library, preview one profile:

```powershell
.\Install-ActMcpProfile.ps1 -Profile flint
```

Then register exactly that profile:

```powershell
.\Install-ActMcpProfile.ps1 -Profile flint -Apply -Confirm:$false
```

The installer backs up `%USERPROFILE%\.scout\m-mcp-servers.json`, refuses to
replace a nonmatching entry, and exposes only the profile's reviewed tool list.
Restart Scout and run the profile's recorded harmless canary.

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
| `fabric-docs-ro` | Production | Pinned `Microsoft.Fabric.Mcp` 1.4.0 in local docs-only, read-only mode; no tenant access; canary: `docs_list-item-types`. Requires .NET 10 SDK or later. |
| `azure-devops-ro` | Controlled pilot | Pinned `@azure-devops/mcp@2.9.0`, one supplied organization, interactive authentication, and host-level read-only tool filtering; canary: `core_list_projects`. |
| `azure-kusto-ro` | Controlled pilot | Pinned `@azure/mcp@3.0.0-beta.38` in read-only Kusto namespace mode; canary: use the `kusto` tool with `--learn`. Requires approved Azure identity and RBAC. |
| `fabric-rti-ro` | Controlled pilot | Pinned `microsoft-fabric-rti-mcp==0.6.2`; only reviewed Kusto query/schema/diagnostic tools; canary: `kusto_known_services`. Requires `uvx` and an explicit non-production service allow-list in `${mcpEnvDir}/fabric-rti.env`. |
| `youtube-mcp-tools` | Controlled pilot | Source-pinned YouTube research server at commit `0130a118a78432c82b6b3081ed866fc08bae9569`; no direct-provider variables are configured; canary: `youtube_quota_status`. |
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
does not access a Fabric tenant or workspace.

Before installing `fabric-rti-ro`, create the reviewed host environment file
with `KUSTO_ALLOW_UNKNOWN_SERVICES=false` and an explicit
`KUSTO_KNOWN_SERVICES` allow-list of non-production endpoints. Do not include
credentials in the catalog, source package, or shared library.

The YouTube profile exposes public transcript and local rendering/prompt tools
only. It does not configure `YOUTUBE_API_KEY` or any
`YOUTUBE_MCP_DIRECT_*` variable. Treat any later credential or external
direct-provider configuration as a separate approval and data-egress decision.

## Admission Rules

Add or update a profile only after recording a pinned and independently
resolvable artifact, reviewed tool list, authentication boundary, data-egress
path, nonmutating canary, and exact uninstall match. A server without these
facts remains deferred or controlled pilot; it must not be silently substituted
with a floating package, an unpinned Git reference, or a different server.
