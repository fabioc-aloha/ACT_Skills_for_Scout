# ACT Skills for Scout v0.1.0 Import Test

## Goal

Test importing three separate Agent Skills folders through Scout's Skills UI,
then verify source-instance discovery and same-user cloud synchronization.

## Package

`packages/act-skills-for-scout-v0.1.0/`

| Skill | Expected plain-language request |
| --- | --- |
| `act-constellation-curation` | "Review this proposed Scout capability using the ACT constellation curation process." |
| `act-critical-review` | "Critically review this proposal and identify the strongest alternative." |
| `act-session-closeout` | "Create a concise repository handoff for this session." |

## Source-Instance Procedure

1. In Scout Skills UI, select **Import**.
2. Import each of the three skill folders individually:
   - `act-constellation-curation`
   - `act-critical-review`
   - `act-session-closeout`
3. Confirm all three appear in the UI.
4. Start a new Scout conversation for each expected request and record whether the
   matching skill is selected.
5. For `act-session-closeout`, confirm the reference checklist remains available
   on demand without being copied into the top-level skill instructions.

## Second-Instance Procedure

1. Refresh or restart Scout.
2. Confirm all three skills appear without manual import.
3. Confirm they arrive disabled by default.
4. Enable only `act-critical-review`.
5. In a new conversation, run its expected request and record the result.

## Stop Conditions

Stop if import requires a format other than a skill folder, strips the
`references/` folder, auto-enables the skills on the second instance, or changes
MCP/server/settings configuration.

## Cleanup

Delete each imported skill through the source instance Skills UI. Confirm
deletion propagates to the second instance. Do not remove other skills.
