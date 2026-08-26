# Cloud-Sync Skill Probe Report

**Date**: 2026-08-26
**Source platform**: Windows 11 Enterprise Insider Preview
**Scout version**: 1.0.73
**Probe package**: `probes/cloud-sync/act-skills-for-scout-sync-probe/SKILL.md`

## Result

The native Scout custom-skill lifecycle synchronized the probe between two Scout
instances signed into the same Microsoft 365 user.

| Stage | Observed result |
| --- | --- |
| Create on source | `act-skills-for-scout-sync-probe` appeared in source inventory and Skills UI. |
| Propagate | The second instance displayed the exact skill without a manual folder copy. |
| Default state | The propagated skill arrived disabled on the second instance. |
| Enable on second instance | The user enabled it through the Skills UI. |
| Invoke on second instance | A new conversation returned `ACT-SCOUT-SYNC-PROBE-20260826-6CBF` exactly. |
| Delete on source | The probe was deleted through Scout's native lifecycle. |
| Propagated deletion | The skill disappeared from both source and second instances. |

## Source Verification After Deletion

The source instance showed no local custom skills, no local probe folder, zero
metadata entries, and no pending sync writes.

## Conclusion

For Scout 1.0.73, a skill created through the native in-app lifecycle is a
cloud-synced, per-user capability. It appears disabled by default on a second
instance and can be enabled there through the UI. Deletion propagates.

## Scope

This validates Scout-managed skills for one Microsoft 365 user across two Scout
instances. It does not validate public-package import, automatic release
updates, cross-account sharing, macOS, Plugin Mall, Copilot CLI, or enterprise
distribution.
