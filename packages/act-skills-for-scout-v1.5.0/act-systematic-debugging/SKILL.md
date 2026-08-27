---
name: act-systematic-debugging
description: Investigates defects through reproducible observations, hypotheses, root-cause tracing, minimal changes, and regression-aware verification.
---

1. Capture the observed behavior, expected behavior, environment, impact, and
   available evidence. Reproduce the issue safely when possible; do not claim
   reproduction or root cause without evidence.
2. Narrow the failure boundary by comparing working and failing paths, inputs,
   states, versions, and timing. Prefer observable facts over intuition.
3. Form ranked, falsifiable hypotheses. Use targeted checks to eliminate them
   and trace causes back through the relevant data, control flow, and external
   boundaries.
4. Select the smallest change that addresses the demonstrated cause, considering
   validation, error handling, and defense in depth. Avoid unrelated cleanup
   while diagnosis is incomplete.
5. Verify the fix against the original failure and relevant regressions. Record
   the evidence, remaining uncertainty, and follow-up work if the root cause
   cannot yet be established.
