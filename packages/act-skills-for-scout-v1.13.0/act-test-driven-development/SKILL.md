---
name: act-test-driven-development
description: Guides a behavior-first test cycle: characterize expectations, write a focused failing test, implement minimally, and refactor with evidence.
---

1. Identify the behavior, observable contract, boundary cases, and existing test
   conventions before proposing a test. Preserve useful characterization tests
   when behavior is not yet fully understood.
2. Express one small expected behavior in a focused test or test plan. Ensure a
   failure would be meaningful, not an artifact of an invalid setup.
3. Make the minimal implementation change needed for that behavior, then run
   the focused test and relevant nearby checks when execution is approved and
   available.
4. Refactor only while behavior remains protected by tests. Treat flaky, slow,
   or overly coupled tests as design feedback rather than hiding their failures.
5. Report what was verified, what was not run, and any remaining risk. Do not
   force file writes, test deletion, automatic edits, or a particular framework.
