# User-Global OneDrive Delivery Test

## Goal

Validate a low-friction delivery path in which one versioned ACT skill package is
published to the user's OneDrive library, then discovered by Scout on every
machine without any repository- or workspace-specific setup.

## v1.4.0 Source-Machine Publication and Flint MCP Canary

Commands in the historical v0.1.0-v1.1.1 records below predate the combined
preview-first bundle lifecycle. Current operational commands require `-Apply`
as documented in `USER-GLOBAL-DELIVERY.md`.

The curated Scout-native v1.4.0 package is the current publisher default. It
contains these 26 direct skill folders and is published to the source user's
OneDrive library. Its Flint MCP canary passed; fresh-conversation coverage for
all skills and second-machine validation remain pending:

```text
act-constellation-curation
act-critical-review
act-session-closeout
act-meditation-continuity
act-vscode-workspace-bootstrap
act-skill-library-update
act-critical-thinking
act-problem-framing
act-implementation-planning
act-systematic-debugging
act-test-driven-development
act-security-hardening
act-git-safety
act-documentation-hygiene
act-writing-craft
act-status-reporting
act-responsible-ai-review
act-library-health-audit
act-content-currency-audit
act-skill-inventory-report
act-feasibility-spike
act-browser-safety
act-project-capability-authoring
act-flint-readiness
act-flint-chart
act-flint-theme
```

Before treating v1.4.0 as delivered, publish it from the source machine, verify
the OneDrive manifest and all 26 folders, run the synced installer once on each
target machine to create missing junctions, invoke every skill in a fresh Scout
conversation, and complete a host-specific Flint MCP canary. The historical
results below remain evidence for their respective earlier package versions, not
proof of v1.4.0 discovery.

## Boundaries

- The GitHub repository is the source of truth.
- OneDrive distributes the published personal library; it is not a Git working
  copy and contains no `.git` directory.
- Each machine has one user-level bootstrap step to create named junctions under
  `%USERPROFILE%\.copilot\skills`.
- The bootstrap does not install skills into a repository, workspace, Scout's
  custom-skill inventory, a plugin, or a marketplace.
- Native Scout import and cloud sync are outside this delivery path.

## Historical v0.1.0 Test

The procedure and result below are the original three-skill v0.1.0 delivery
test. The v0.3.0 workspace-bootstrap addition requires a new publication and
fresh-conversation invocation record.

## Publish on One Machine

From the cloned repository, publish the current package and enable it on the
source machine:

```powershell
.\scripts\Install-ActSkillsForScout.ps1 -Publish
```

This creates the following OneDrive-synchronized library:

```text
%OneDrive%\Documents\ScoutSkills\ACT_Skills_for_Scout\
  Install-ActSkillsForScout.ps1
  Uninstall-ActSkillsForScout.ps1
  library-manifest.json
  skills\
    act-constellation-curation\
    act-critical-review\
    act-session-closeout\
```

The source installer updates only direct skill folders already managed by this
library. It does not remove obsolete folders or junctions.

## Bootstrap on Each Machine

After OneDrive finishes synchronizing, open PowerShell in the synced library and
run:

```powershell
.\Install-ActSkillsForScout.ps1
```

The bootstrap creates these named junctions only if no conflicting path exists:

```text
%USERPROFILE%\.copilot\skills\act-constellation-curation\
%USERPROFILE%\.copilot\skills\act-critical-review\
%USERPROFILE%\.copilot\skills\act-session-closeout\
```

Start a new Scout conversation and invoke each expected request from
[`PACKAGE-IMPORT-TEST-2026-08-26.md`](PACKAGE-IMPORT-TEST-2026-08-26.md).

## Acceptance Criteria

1. Publishing creates a OneDrive library with all three direct skill folders and
   the library manifest.
2. The bootstrap creates only junctions under the user-global Scout skills root.
3. A new Scout conversation discovers each installed skill from that root.
4. A second machine receives the library through OneDrive, runs the bootstrap
   once, and discovers the same skills without cloning this repository or
   configuring any project.
5. Updating a source package, republishing with `-Force`, and allowing OneDrive
   to synchronize changes the files visible through existing junctions.

## Current Result

On 2026-08-26, the v0.1.0 library was published on the source Windows machine
under `%OneDrive%\Documents\ScoutSkills\ACT_Skills_for_Scout`. OneDrive
replicated it to a second machine, where the synced bootstrap created the three
expected user-global junctions. Both machines showed:

```text
act-constellation-curation
act-critical-review
act-session-closeout
```

This passes library propagation and per-machine bootstrap. It does not yet prove
that a fresh Scout conversation invokes every installed skill, nor that a
republished update arrives through already-created junctions.

## v0.2.0 Source-Machine Result

On 2026-08-26, v0.2.0 was published to the OneDrive library and created the
fourth source-machine junction:

```text
act-vscode-workspace-bootstrap
```

The published manifest contains all four direct skill folders. The v0.2.0
library must still synchronize to the second machine, where the installer must
be rerun once to create its fourth junction. A fresh Scout conversation must
then validate discovery and user-approved workspace bootstrap behavior.

## v0.3.0 Source-Machine Result

Version 0.3.0 extends the workspace bootstrap skill with merge-safe GitHub and
Azure DevOps templates. On 2026-08-26 it was published to the source machine's
OneDrive library, whose manifest reported `0.3.0`; the global linked skill and
canonical stylesheet matched the package source by SHA-256.

The v0.3.0 library must still synchronize to the second machine, where the
installer must be rerun once to refresh the existing skill junction. A fresh
Scout conversation must then validate discovery and user-approved scaffold
behavior.

## v0.4.0 Source-Machine Result

Version 0.4.0 adds `act-skill-library-update`. On 2026-08-26 it was published
to the source machine's OneDrive library and its user-global junction was
created. The synced installer then manually linked it once on a second machine.
In a fresh Scout conversation there, the request `update skills` selected the
updater, read the v0.4.0 manifest, previewed the exact installer command,
requested confirmation, and preserved all five matching junctions.

This passes the v0.4.0 in-app update flow after its one-time per-machine
bootstrap. Future newly added updater skills still require the existing manual
installer run once before Scout can invoke them.

## v1.1.0 Source-Machine Result

Version 1.1.0 adds `act-skill-inventory-report`, which is read-only and reports
only the host inventory returned by `m_list_skills`. On 2026-08-26, it was
published to the source machine's OneDrive library, whose manifest reported
`1.1.0`, and its nineteenth user-global junction was created.

It must still be manually linked once on each additional machine and validated
in a fresh Scout conversation before it can be claimed as available.

## v1.1.1 Source-Machine Result

Version 1.1.1 hardens `act-skill-inventory-report` so every host-reported scope
receives a total row and non-bundled, non-Global-ACT rows remain `Not exposed`.
On 2026-08-26, it was published to the source OneDrive library, whose manifest
reported `1.1.1`, and all 19 source-machine junctions were confirmed. It must
still be validated against the host inventory on both machines in fresh Scout
conversations.

## v1.4.0 Source-Machine Result

On 2026-08-27, the v1.4.0 OneDrive library manifest reported 26 skill folders,
and each published `SKILL.md` matched its source package by SHA-256. The
source-machine bootstrap confirmed all 26 user-global junctions already pointed
to the published library.

The Flint canary passed in the active Scout host against
`flint-chart-mcp@0.5.1`: all six reviewed tools were exposed,
`list_chart_types` returned the Vega-Lite, ECharts, and Chart.js catalogs, and
a Vega-Lite bar chart validated without warnings and rendered successfully.
Local file references were disabled in the registered server configuration.

This passes source-machine publication, local link integrity, and the
host-specific Flint canary. It does not establish fresh-conversation discovery
for every v1.4.0 skill, second-machine propagation of v1.4.0, or a
cross-platform delivery claim.

On 2026-08-27, the published library was extended with
`Install-ActSkillsForScout.ps1` and `Uninstall-ActSkillsForScout.ps1`. The
source-machine copies matched the OneDrive library by SHA-256. An isolated
configuration test verified preview, reviewed-entry registration, safe
rollback, separate timestamped backups for consecutive writes, and refusal to
replace a differing `flint` entry. It did not modify the active Scout
configuration because that entry already matched the reviewed registration.

## Removal

From the synced OneDrive library, run:

```powershell
.\Uninstall-ActSkillsForScout.ps1
```

The removal script deletes only junctions whose target exactly matches this
library. It never removes the OneDrive source folders or a conflicting existing
skill path.
