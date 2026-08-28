# ACT Skills for Scout v1.8.0

Production Scout-native package for user-global Scout discovery through the
OneDrive-backed ACT skill library. It is published to the source user's library
and its Flint MCP canary passed; fresh-conversation coverage for all skills and
second-machine validation remain pending.

## Contents

| Skill | Use it for |
| --- | --- |
| `act-constellation-curation` | Review a proposed Scout capability, integration, or distribution decision. |
| `act-critical-review` | Test a material proposal against alternatives, evidence gaps, risks, and falsifiers. |
| `act-session-closeout` | Create a concise repository handoff at the end of substantive work. |
| `act-meditation-continuity` | Consolidate substantive work into an approval-first handoff and evidence-based reusable-capability candidates. |
| `act-vscode-workspace-bootstrap` | Add merge-safe GitHub/Azure DevOps, editor, and Scout `.vscode` scaffolding to a selected workspace. |
| `act-skill-library-update` | Update the current machine's linked ACT skills from the synced OneDrive library after explicit approval. |
| `act-critical-thinking` | Challenge reasoning with traceable evidence, alternatives, assumptions, and falsifiers. |
| `act-problem-framing` | Establish a decision-ready problem statement, scope, constraints, and success signals. |
| `act-implementation-planning` | Produce a proportionate implementation plan with dependencies, risks, and verification points. |
| `act-systematic-debugging` | Investigate a defect through reproduction, evidence, hypotheses, minimal fixes, and verification. |
| `act-test-driven-development` | Plan or practice a behavior-first test cycle without forcing edits or deletion. |
| `act-security-hardening` | Review a change for proportionate security controls and safe Markdown-rendering boundaries. |
| `act-git-safety` | Plan Git work with explicit consent, checkpoints, and non-destructive operations. |
| `act-documentation-hygiene` | Keep documentation accurate, discoverable, consistent, and aligned with repository conventions. |
| `act-writing-craft` | Improve a message's clarity, structure, and usefulness while preserving its authorial voice. |
| `act-status-reporting` | Write an evidence-bounded status report without assuming access to external systems. |
| `act-responsible-ai-review` | Assess stakeholder, privacy, responsibility, and reversibility implications of an AI-related decision. |
| `act-library-health-audit` | Review a knowledge or skill library for coherence, duplication, gaps, and maintainability. |
| `act-content-currency-audit` | Identify possibly stale content and make proposal-first recommendations for updates. |
| `act-skill-inventory-report` | Report the live host skill inventory with optional read-only ACT library diagnostics. |
| `act-feasibility-spike` | Reduce a technical unknown through a disposable, evidence-led feasibility experiment. |
| `act-browser-safety` | Use browser interaction only when necessary and available, with privacy and consent safeguards. |
| `act-project-capability-authoring` | Propose the smallest approved capability for a demonstrated recurring project need. |
| `act-office-native-authoring` | Create a native Word, PowerPoint, or Excel artifact from approved source material without converting Markdown. |
| `act-flint-readiness` | Assess whether the pinned Flint MCP capability is safely ready without installing or configuring it. |
| `act-flint-chart` | Create and visually verify a Flint chart only through MCP surfaces available in the active host. |
| `act-flint-theme` | Author and visually verify a Flint theme only through MCP surfaces available in the active host. |

## Delivery Scope

When published, this 27-skill package is delivered to:

```text
%OneDrive%\Documents\ScoutSkills\ACT_Skills_for_Scout\skills\
```

Each machine exposes its direct skill folders through named junctions under
`%USERPROFILE%\.copilot\skills\`. See
[`../../docs/USER-GLOBAL-DELIVERY.md`](../../docs/USER-GLOBAL-DELIVERY.md).

The direct skill payload has no scripts, credentials, or runtime installation
artifact. The published library root includes a preview-first installer and
rollback script for individually selected MCP profiles; neither script is part
of a direct skill payload and both require explicit `-Apply`. See
[`docs/MCP-CATALOG.md`](docs/MCP-CATALOG.md).
Its source-derived content is adapted as portable guidance; see
[`PROVENANCE.md`](PROVENANCE.md).
The workspace bootstrap skill includes static templates and writes them to a
target workspace only after the user explicitly approves a reviewed merge plan.

## Version History

`v1.8.0` expands the MCP catalog with non-installable evidence records for
Fabric Ontology, Fabric SQL Endpoint, Power BI Modeling, CData Synapse, Quanti
Synapse, and unverified Synapse community servers. The records retain their
admission blockers and do not register or activate a server.
`v1.7.0` adds a reviewed MCP profile catalog with separately installed Flint,
Fabric docs, Azure DevOps, Azure Kusto, Fabric RTI, and YouTube profiles; it
records Scout-managed Microsoft 365 availability and deferred Synapse/Fabric
hosted surfaces. No profile is registered by installing the ACT skills.
`v1.6.0` adds `act-office-native-authoring`, which uses available Scout
Co-create Office capabilities to create native Word, PowerPoint, and Excel
artifacts from approved source material rather than converting Markdown.
`v1.4.0` adds the MCP-gated `act-flint-readiness`, `act-flint-chart`, and
`act-flint-theme` skills plus a version-pinned Flint capability document and
non-mutating readiness preview. Source-machine publication, all 26 local
junctions, and the Flint canary passed on 2026-08-27; fresh-conversation
coverage for all skills and second-machine validation remain pending. `v1.3.0`
adds `act-meditation-continuity`, an approval-first Scout-native
continuity practice adapted from meditation and session-closeout guidance; it is
pending source publication and runtime validation. `v1.2.0` adds portable
feasibility-spike, browser-safety, and project-capability-authoring guidance. `v1.1.1` hardens `act-skill-inventory-report` with
complete scope totals and strict host-versus-manifest diagnostics. `v1.1.0`
adds that read-only host-inventory report.
`v1.0.0` expands the pilot into an 18-skill curated Scout-native payload.
`v0.4.0` adds `act-skill-library-update` for user-confirmed in-app updates.
`v0.3.0` extends `act-vscode-workspace-bootstrap` with merge-safe GitHub and
Azure DevOps templates. `v0.2.0` adds the initial `.vscode` bootstrap skill, and
v0.1.0 is retained as the initial three-skill delivery-test artifact.
