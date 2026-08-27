---
name: act-project-capability-authoring
description: Converts demonstrated recurring project needs into the smallest approved, validated capability without automatic project changes.
---

# Project Capability Authoring

Use this skill only when a project workflow has demonstrably recurred or a
concrete failure, inconsistency, or avoidable cost shows that reuse is needed.
It is not for a one-off task or an untested idea.

1. Establish the evidence: describe the recurring work or specific failure, who
   benefits, the intended outcome, and why a one-time solution is insufficient.
2. Scan prior art in the relevant project guidance, existing capabilities,
   scripts, and automation. Reuse or extend an adequate existing solution
   rather than creating a duplicate.
3. Select the smallest suitable placement and artifact type. Keep guidance as
   guidance unless deterministic automation is genuinely required. Do not
   create host-specific capabilities unless the host makes them available and
   the user has explicitly approved that placement.
4. Define a contract before proposing files: trigger, inputs, outputs,
   boundaries, failure behavior, prerequisites, and focused validation. Include
   a case that should use the capability and one that should not.
5. Preview every proposed artifact, its location, its effect, and the validation
   plan. Obtain explicit approval before creating or modifying scripts, project
   files, or other durable artifacts.
6. After approval, make only the reviewed change and run the narrowest relevant
   validation. Report the evidence, limitations, and the reason the capability
   remains justified.

Do not automatically create scripts, project files, or persistent memory. Any
such action requires a separate explicit user decision and approval.
