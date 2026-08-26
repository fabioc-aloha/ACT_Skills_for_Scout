# ACT Skills for Scout v0.1.0

Pilot package for testing Scout Skills UI import and cloud synchronization.

## Contents

| Skill | Use it for |
| --- | --- |
| `act-constellation-curation` | Review a proposed Scout capability, integration, or distribution decision. |
| `act-critical-review` | Test a material proposal against alternatives, evidence gaps, risks, and falsifiers. |
| `act-session-closeout` | Create a concise repository handoff at the end of substantive work. |

## Import Scope

This is a harmless pilot package. It contains only Markdown instructions and one
Markdown reference. It has no scripts, assets, credentials, MCP configuration,
external calls, or file-writing actions.

Import each **direct skill folder** through Scout's Skills UI. Do not select
this package root: it is a catalog folder and intentionally has no root
`SKILL.md`.

```text
act-constellation-curation/
act-critical-review/
act-session-closeout/
```

Do not copy these folders into an undocumented internal storage path.

## Expected UI Result

The Skills UI should display three separately manageable skills. On another
Scout instance under the same user, each synchronized skill should arrive
disabled by default.

## Uninstall

Delete each of the three skill entries through the Skills UI on the source
instance, then verify deletion on the second instance. See
[`../../docs/CLOUD-SYNC-TEST.md`](../../docs/CLOUD-SYNC-TEST.md).
