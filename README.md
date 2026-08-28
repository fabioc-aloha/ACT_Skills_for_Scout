# ACT Skills for Scout

![ACT Skills for Scout banner](assets/act-skills-scout-banner.svg)

Install a user-global bundle of 27 ACT skills and a curated MCP profile catalog
for Microsoft Scout on Windows.

## Prerequisites

- Microsoft Scout
- OneDrive signed in for the user
- Node.js, npm, and `npx` available on `PATH`

## Install on Your Primary Machine

Clone this repository, open PowerShell at the repository root, then preview the
operation:

```powershell
.\scripts\Install-ActSkillsForScout.ps1 -Publish
```

Apply the installation:

```powershell
.\scripts\Install-ActSkillsForScout.ps1 -Publish -Apply
```

This publishes the bundle to
`%OneDrive%\Documents\ScoutSkills\ACT_Skills_for_Scout`, creates user-global
skill junctions under `%USERPROFILE%\.copilot\skills`, and publishes the
individually selectable MCP profile catalog. Restart Scout when the command
completes.

Before any installation changes, the script requires confirmation that the
built-in `/excalidraw` skill was disabled in Scout because it can interfere with
the Mermaid and Illustrator skills. For an intentional unattended install, pass
`-ExcalidrawDisabled` to attest that this was already done.

## Install an MCP Profile

MCP servers are not enabled by the skill installer. From the synced library,
preview and then apply one reviewed profile:

```powershell
.\Install-ActMcpProfile.ps1 -Profile flint
.\Install-ActMcpProfile.ps1 -Profile flint -Apply -Confirm:$false
```

See [`docs/MCP-CATALOG.md`](docs/MCP-CATALOG.md) for the production, pilot,
managed, and deferred profiles plus their prerequisites and harmless canaries.

## Install or Update on Another Machine

Wait for OneDrive to synchronize, then run:

```powershell
Set-Location "$env:OneDrive\Documents\ScoutSkills\ACT_Skills_for_Scout"
.\Install-ActSkillsForScout.ps1 -Apply
```

The command creates missing skill links and preserves matching links. Install
or update MCP profiles independently after a synchronized update, then restart
Scout.

## Update the Publishing Machine

Pull the new repository version and rerun the complete publishing command:

```powershell
git pull
.\scripts\Install-ActSkillsForScout.ps1 -Publish -Apply
```

## Uninstall

From the synced OneDrive bundle folder, preview removal:

```powershell
.\Uninstall-ActSkillsForScout.ps1
```

Then apply it:

```powershell
.\Uninstall-ActSkillsForScout.ps1 -Apply -Confirm:$false
```

This removes only ACT skill junctions that point to this bundle and the exact
reviewed Flint registration. It preserves the OneDrive library and creates a
timestamped backup of Scout's MCP configuration.

## Included Capabilities

The bundle provides reasoning, planning, review, documentation, safety,
continuity, browser-safety, native Office authoring, and Flint chart/theme
skills. Its MCP catalog includes individually selectable Flint, Fabric,
Azure DevOps, Azure Kusto, Fabric RTI, and YouTube profiles.
