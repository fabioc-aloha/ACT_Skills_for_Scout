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
| Propagated deletion | The probe disappeared from both source and second instances. |

## Source Verification After Deletion

The source instance showed no local custom skills, no local probe folder, zero
metadata entries, and no pending sync writes.

## Conclusion

For Scout 1.0.73, the newly created probe was a cloud-synced, per-user
capability. It appeared disabled by default on a second instance, could be
enabled there through the UI, and its deletion propagated.

## Scope

This validates Scout-managed skills for one Microsoft 365 user across two Scout
instances. It does not validate public-package import, automatic release
updates, cross-account sharing, macOS, Plugin Mall, Copilot CLI, or enterprise
distribution. It also does not prove that deletion removes historical skills
already retained by another instance.

## Later Observation

After the probe completed, the second instance displayed many disabled ACT skills
that had previously been deleted on the source instance. Therefore, treat cloud
sync as per-skill propagation for newly observed lifecycle changes, not as a
reliable account-wide reconciliation or deletion mechanism. Each pre-existing
skill on each instance requires explicit inventory and a separate removal
decision.
