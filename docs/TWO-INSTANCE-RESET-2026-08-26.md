# Two-Instance Reset Baseline

**Date**: 2026-08-26
**Scope**: Two Scout instances signed into the same Microsoft 365 user.

## Scout-Visible Baseline

Both instances are reset to the same visible Scout state:

| Surface | State |
| --- | --- |
| Custom skills in native inventory | None |
| Bundled skills | Ten enabled |
| Local custom-skill metadata | Empty |
| Automations | None |
| Heartbeat | Disabled |

This is the baseline for subsequent ACT Skills for Scout package-import and
cloud-sync tests.

## Second-Instance Reset Evidence

The second instance created a SHA-256-verified backup outside OneDrive and Git at
`C:\Users\fabioc\AppData\Local\ScoutSkillBackups\20260826T173816-0400`.

Its native skill inventory initially showed 50 enabled global skills and 10
bundled skills. A deletion attempt for `global-act-tenets` reported that the
skill was non-deletable, while a subsequent native inventory showed only the 10
bundled skills. The cause of that inventory change is not established.

The reset did not modify settings, M365 sign-in, Teams relay, cloud-sync
configuration, memory, sessions, OneDrive, Copilot settings, MCP servers, or
marketplace/plugin installations.

## Retained Storage Boundary

The second instance still has backed-up and locally present marketplace/plugin
source folders. They do not appear in the Scout native skill inventory. They
were intentionally retained because their ownership and use by other hosts were
not established.

The reset therefore proves Scout-visible parity, not storage-level parity.
Future tests must inventory native skill state before and after every action and
must not infer behavior from retained source folders alone.
