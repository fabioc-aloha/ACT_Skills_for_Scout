# Cloud-Sync Skill Probe

## Goal

Verify whether a skill created through Scout's native in-app lifecycle appears
on a second Scout instance signed into the same Microsoft 365 user.

## Package Under Test

`probes/cloud-sync/act-skills-for-scout-sync-probe/SKILL.md`

Expected skill name: `act-skills-for-scout-sync-probe`
Expected response: `ACT-SCOUT-SYNC-PROBE-20260826-6CBF`

## Procedure

1. Create the probe through Scout's native skill lifecycle on the source device.
2. Confirm it appears in the source device's skill inventory and UI.
3. Wait for cloud sync to complete.
4. On a separate Scout instance signed into the same user, refresh or restart
   Scout and inspect the Skills UI.
5. Record whether the exact skill name and description appear. This UI presence
   is the primary propagation evidence.
6. Optionally run the exact cloud-sync probe request and record the response.
7. Delete the probe through Scout's native skill lifecycle on the source device.
8. Confirm deletion from the source inventory, then verify its disappearance on
   the second instance.

## Current Result

All success criteria passed on 2026-08-26. See
[CLOUD-SYNC-REPORT-2026-08-26.md](CLOUD-SYNC-REPORT-2026-08-26.md).

The result applies only to the probe. Later observation found historical ACT
skills retained on the second instance after source-side deletion, so the test
does not establish account-wide cleanup behavior.

## Success Criteria

- The second instance displays the exact probe skill without a manual file copy.
- The second instance can run the probe if requested.
- The newly created probe deletion propagates, leaving no probe skill on either
  instance.

## Boundaries

This test does not validate public-package import, Plugin Mall, Copilot CLI,
local-folder delivery, cross-account sharing, or enterprise distribution.
