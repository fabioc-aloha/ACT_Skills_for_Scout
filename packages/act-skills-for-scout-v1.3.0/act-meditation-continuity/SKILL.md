---
name: act-meditation-continuity
description: Consolidates substantive Scout work into a concise, approval-first repository handoff and evidence-based reusable-capability candidates without automatic writes.
---

# Meditation Continuity

Use this Scout-native continuity practice only at the end of substantive work,
before a handoff, or after a real reusable insight or failure. Do not use it for
routine execution: a handoff or candidate without new signal creates noise.

## Review the Current State

1. Identify the current target repository or workspace. Inspect the actual Git
   branch, latest commit, working-tree status, current work, recorded decisions,
   failures, any repo-root `HANDOFF.md`, and relevant local skills, instructions,
   prompts, scripts, and automation patterns.
2. Separate **verified facts** (directly observed), **assumptions** (reasonable
   but unconfirmed), and **unverified history** (reported or inferred without
   current evidence). Do not present assumptions or history as facts.
3. Never include credentials, private Microsoft 365 content, personal data, or
   opaque application state in a handoff, candidate, or postmortem. Do not make
   persistent-memory claims, create source scripts or host-specific folders, or
   treat session context as a durable record.

## Preserve Continuity Deliberately

1. Prepare a concise proposed update for repo-root `HANDOFF.md` containing the
   objective and project state; verified completed work; decisions and approval
   boundaries; observed Git branch, latest commit, and working-tree state;
   unresolved risks or blocks; and the next safe action.
2. If `HANDOFF.md` already exists, preserve its valid content and merge or update
   only relevant sections. Never blindly overwrite it.
3. Preview the exact proposed content and obtain explicit approval before
   creating or modifying `HANDOFF.md`. Approval to assess continuity is not
   approval to write a project file.

## Extract Only Demonstrated Reuse

1. Retain an automation candidate only when recurrence is demonstrated by at
   least two occurrences, or by a concrete repeated failure. Reject one-off,
   aspirational, duplicate, or unverified candidates.
2. Before proposing an artifact, scan existing project-local skills, guidance,
   prompts, scripts, and automation. Prefer reuse or extension over duplication.
3. For each retained candidate, describe its trigger, inputs, outputs, failure
   modes, placement, validation, owner, and rollback. State the recurrence
   evidence and why existing local patterns are insufficient.
4. Route an approved project-local artifact to
   `act-project-capability-authoring`. Route a cross-machine reusable candidate
   first to `act-constellation-curation`; package, release, or publication work
   needs a separate explicit approval and workflow.
5. Do not automatically create a local skill or script, change project files,
   write memory, publish a package, change OneDrive, or share across machines.

## Learn from Failures

For a real failure, propose a concise postmortem that records the actual root
cause, the generalizable pattern, and prevention. Do not assign blame or claim a
root cause without evidence. Keep it proposed unless its destination and write
are separately approved.

## Report

Report the current state; the handoff candidate and required action; retained
and rejected candidates with evidence; any postmortem candidate; and the next
safe action. If no durable signal exists, say so and leave no artifact behind.
