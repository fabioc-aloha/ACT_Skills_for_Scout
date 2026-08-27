# ACT Skills for Scout v0.3.0

Pilot package for user-global Scout discovery through the OneDrive-backed ACT
skill library.

## Contents

| Skill | Use it for |
| --- | --- |
| `act-constellation-curation` | Review a proposed Scout capability, integration, or distribution decision. |
| `act-critical-review` | Test a material proposal against alternatives, evidence gaps, risks, and falsifiers. |
| `act-session-closeout` | Create a concise repository handoff at the end of substantive work. |
| `act-vscode-workspace-bootstrap` | Add merge-safe GitHub/Azure DevOps, editor, and Scout `.vscode` scaffolding to a selected workspace. |

## Delivery Scope

This package is published to:

```text
%OneDrive%\Documents\ScoutSkills\ACT_Skills_for_Scout\skills\
```

Each machine exposes its direct skill folders through named junctions under
`%USERPROFILE%\.copilot\skills\`. See
[`../../docs/USER-GLOBAL-DELIVERY.md`](../../docs/USER-GLOBAL-DELIVERY.md).

The package has no scripts, credentials, MCP configuration, or external calls.
The workspace bootstrap skill includes static templates and writes them to a
target workspace only after the user explicitly approves a reviewed merge plan.

## Version History

`v0.3.0` extends `act-vscode-workspace-bootstrap` with merge-safe GitHub and
Azure DevOps templates. `v0.2.0` adds the initial `.vscode` bootstrap skill, and
v0.1.0 is retained as the initial three-skill delivery-test artifact.
