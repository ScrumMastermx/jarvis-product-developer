# Bug Fixing

Given a bug report: fix it. Point at the log, the failing test, the error, then resolve it. No hand-holding needed.

## Classification
- **Bug** (wrong behaviour, wrong logic, type error) → fix now.
- **Missing critical** (no error handling, no input validation, missing auth check) → add now.
- **Blocking** (missing dependency, broken import, wrong type) → fix to unblock.
- **Architectural** (new table, library swap, breaking API change) → stop and ask.

## Attempt limit
Three failed attempts on the same issue → stop, write down what was tried and what was observed, hand it back.

**Attempt two is a re-decomposition, not a retry.** Split the problem into smaller units (one predicate, one call site, one query), fix the smallest unit that reproduces. Do not re-run the same patch with more care.

## Always
- Reproduce before fixing. A fix without a repro is a guess.
- Add the test that would have caught it, and confirm it fails without the fix (`verification.md`).
- Say what the root cause was in the PR, in one sentence.
