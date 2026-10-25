# Code Quality

## Before any PR
1. **Simplify pass** (when the change adds 50+ lines or a new abstraction): shrink the diff. Reuse > standard library > installed dependency > new code. Delete > write. Skip for one-liners.
2. **Self-review** the full diff against the task. Remove debugging leftovers, dead code, unrelated edits.
3. **`/review`**: checklist + adversarial second pass + delete-the-fix check. Fix every finding before opening the PR. No "follow-up later" parking lot.
4. Security-sensitive change (auth, sessions, payments, personal data, permissions) → the review runs the security checklist in full, no sampling.

## During implementation
- A fix that hides a symptom (swallows an error, skips a test, silences a log) → stop, surface the root cause.
- Scope grows beyond the task (adjacent files "while here") → stop, state the drift, revert or ask.
- Three failed attempts on the same issue → stop and document (see `bug-fixing.md`).
- Formatting-only changes and behaviour changes live in separate commits; unrelated changes in separate PRs. A behaviour flip buried in a reformat is invisible to reviewers.

## Never simplify away
Input validation at boundaries, error handling, authentication and authorization checks, accessibility, explicitly requested behaviour.

## Always
- No untested code pushed. "Tested" means the suite ran and its output is in the PR, not "lint passed".
- Follow the conventions of the repo you are in over personal defaults.
- Type hints / types on public signatures; no unused imports.
