# ACT Skills for Scout

User-global delivery testbed for Artificial Critical Thinking skills in Microsoft
Scout.

## Status

**Curated Scout-native v1.2.0 package pending source publication,
fresh-conversation validation, and second-machine validation. Not a Plugin Mall
package.**

This repository is the versioned source for portable Agent Skills folders. Its
delivery testbed publishes a selected package to a OneDrive-synchronized personal
library, then exposes every direct skill folder at Scout's user-global discovery
root (`~/.copilot/skills`) through named Windows junctions.

This design intentionally avoids per-repository and per-workspace installation.
Every Scout conversation on an installed machine can discover the same skills.

### Current Evidence

Windows local-folder discovery passed on Scout 1.0.73: the probe was discovered
from `~/.copilot/skills` in a new conversation, while
`loadCopilotCliSkills` remained disabled. The probe did not appear in the
in-app custom-skill inventory. After removal, the non-discovery check was
intercepted by an unexpected ACT bridge and is therefore inconclusive. Updates,
rollback, UI management, macOS, cross-device behavior, Copilot plugins, and
Plugin Mall remain unvalidated.

### Native Scout Lifecycle Result

Scout-managed skill lifecycle propagation passed between two instances signed
into the same Microsoft 365 user. The probe arrived disabled on the second
instance, ran after the user enabled it in the Skills UI, and disappeared from
both instances after source deletion. This does not prove that historical skills
deleted elsewhere are reconciled automatically; the second instance later showed
many retained disabled ACT skills. Native Scout import and sync are therefore
optional convenience paths, not the source of truth for installation, updates,
or cleanup. See [CLOUD-SYNC-REPORT-2026-08-26.md](docs/CLOUD-SYNC-REPORT-2026-08-26.md).

### User-Global Delivery Target

```text
GitHub repository (versioned source)
        |
        v
OneDrive\Documents\ScoutSkills\ACT_Skills_for_Scout\skills\
        |
        v
%USERPROFILE%\.copilot\skills\<skill-name>\  (named junctions)
        |
        v
All Scout conversations on that machine
```

The publishing machine updates the OneDrive library from a chosen versioned
package. OneDrive propagates that library to the user's other machines. Each
machine runs the local bootstrap once to add user-level junctions. No project
configuration, repository files, or Scout setting changes are required.

The v1.2.0 package contains 22 direct skills and is the publisher default. It
is pending source publication, fresh-conversation validation, and
second-machine validation. The historical v1.1.1 source-machine publication
and its 19 confirmed junctions remain recorded below and in the delivery
documentation.

See the [v1.2.0 package inventory](packages/act-skills-for-scout-v1.2.0/README.md)
and [provenance](packages/act-skills-for-scout-v1.2.0/PROVENANCE.md) for the
full payload and its source-derived adaptations.

See [USER-GLOBAL-DELIVERY.md](docs/USER-GLOBAL-DELIVERY.md) for the operational
mechanism and [USER-GLOBAL-DELIVERY-TEST.md](docs/USER-GLOBAL-DELIVERY-TEST.md)
for its acceptance record.

## Quick Start

To publish v1.2.0 on the source machine and enable it for that user, run:

```powershell
Set-Location C:\Development\ACT_Skills_for_Scout
.\scripts\Install-ActSkillsForScout.ps1 -Publish
```

After OneDrive synchronizes, each additional machine enables the same library
with one command:

```powershell
Set-Location "$env:OneDrive\Documents\ScoutSkills\ACT_Skills_for_Scout"
.\Install-ActSkillsForScout.ps1
```

## Repository Layout

| Path | Purpose |
| --- | --- |
| `packages/` | Future versioned ACT Skills for Scout packages. |
| `scripts/` | OneDrive publisher and safe user-global bootstrap/removal scripts. |
| `docs/USER-GLOBAL-DELIVERY.md` | User-global OneDrive delivery architecture and operations. |
| `probes/local-folder/` | Harmless disposable package used to test local Scout discovery. |
| `docs/USER-GLOBAL-DELIVERY-TEST.md` | OneDrive-backed delivery procedure and acceptance criteria. |
| `docs/TEST-PLAN.md` | Required evidence and stop conditions for the probe. |
| `docs/PROBE-REPORT-2026-08-26.md` | Windows discovery result and remaining validation work. |
| `docs/CLOUD-SYNC-REPORT-2026-08-26.md` | Source-to-second-instance creation, activation, and deletion result. |
| `docs/UNINSTALL.md` | Removal instructions for every planned delivery path. |

## Safety Rules

- Do not install a Copilot plugin, register a marketplace, enable
  `loadCopilotCliSkills`, or modify Scout settings from this repository.
- The first probe contains no scripts, references, assets, MCP configuration,
  credentials, external calls, or filesystem writes.
- The bootstrap only creates named junctions for direct skill folders. It never
  writes into a repository or workspace.
- A folder listing is not evidence of Scout discovery; validate in a new Scout
  conversation.
- A future production package must remain an Agent Skills-compatible folder with
  `SKILL.md` as its portable contract.
- v1.0.0 source-derived guidance is curated rather than copied, and excludes
  plugin, runtime, MCP, credential, and tool-bound artifacts.

See [the test plan](docs/TEST-PLAN.md) before any test and
[uninstall instructions](docs/UNINSTALL.md) before installing anything.
