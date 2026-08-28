# Fabric and Synapse MCP Evidence

## Purpose

This record advances the Fabric and Azure Synapse roster without installing or
activating any additional server. Entries remain non-installable until they meet
the catalog admission rules in [MCP-CATALOG.md](MCP-CATALOG.md).

## Fabric

| Record | Source and boundary | Admission blocker |
| --- | --- | --- |
| `fabric-ontology` | [Official Fabric IQ Ontology MCP](https://learn.microsoft.com/fabric/iq/ontology/how-to-use-ontology-mcp-server) is a hosted HTTP Preview service scoped to an ontology item. | Microsoft has not published a fixed tool inventory, read-only setting, OAuth scope contract, immutable version, or non-data canary. |
| `fabric-sql-endpoint` | [Official Fabric Data Warehouse MCP](https://learn.microsoft.com/fabric/data-warehouse/data-warehouse-mcp-server) is a hosted HTTP Preview service. Its only documented tool, `executeSQL`, can execute read and write T-SQL. | No server-side read-only mode or query allow-list. Any pilot needs an item-scoped endpoint, non-production item, and a database principal restricted to `SELECT`. |
| `powerbi-modeling` | [Microsoft Power BI Modeling MCP](https://github.com/microsoft/powerbi-modeling-mcp) is a local Preview server with a documented `--readonly` mode. | It still requires semantic-model write permission, lacks an independently verified immutable package release, and is governed by a preview EULA. |

`fabric-docs-ro` remains the only production Fabric profile because its pinned
local server runs solely in the embedded `docs` namespace, is read-only, and
does not access a Fabric tenant.

## Azure Synapse

Microsoft has no verified Azure Synapse Analytics-specific MCP server, Azure MCP
namespace, or supported sample. Azure MCP's Kusto namespace is Azure Data
Explorer support; it must not be described as Synapse support.

| Record | Source and boundary | Admission blocker |
| --- | --- | --- |
| `synapse-cdata` | [CData Azure Synapse MCP](https://github.com/CDataSoftware/azure-synapse-mcp-server-by-cdata) is a vendor Java/JDBC wrapper with table, column, and query tools. | Requires separately licensed CData software, a dedicated read-only principal, vendor security review, and a pinned source build before any pilot. |
| `synapse-quanti` | [Quanti MCP](https://github.com/quantiio/mcp) is a hosted third-party warehouse service that claims Azure Synapse support. | Hosted-service data handling, retention, credential flow, and versioning require commercial and security due diligence. |
| `synapse-community` | Other reviewed community repositories are unverified or expose arbitrary SQL, pipelines, Spark jobs, or notebook mutation. | They fail the catalog provenance or least-privilege threshold and are discovery-only. |

If a production Synapse capability becomes necessary, build or procure only a
read-only adapter that exposes `list_schemas`, `list_tables`, `describe_table`,
and a validated `query_readonly` operation. It must use a dedicated read-only
identity, a fixed endpoint/database allow-list, a single-statement `SELECT` or
metadata-query validator, row/time limits, and audit logs that exclude result
payloads. Its first canary should be `SELECT 1 AS ScoutCanary` against a
non-production database.
