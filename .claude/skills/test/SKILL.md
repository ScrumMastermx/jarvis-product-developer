---
name: test
description: |
  Design and write tests for the changed code: unit tests for logic, end-to-end tests for any user-facing flow,
  failure-safe teardown. Runs them and pastes the output.
  TRIGGERS: "/test", "write tests", "add tests for", "cover this", "is this tested".
---

# Test: write, run, prove

## Steps
1. **Find the change.** `git diff` (or the files they name). List the behaviours it adds or alters, one line each.
2. **Find the project's way.** Read `notes/projects/<name>.md` for the test runner, fixture style and folder
   layout. If none, grep for the test config (`pytest.ini`, `jest.config`, `vitest.config`, `*.test.*`) and copy
   the nearest existing test's shape. Conventions of the repo win.
3. **Design.** For each behaviour: the test name, the setup, the assertion. Mark which are **unit** (pure logic)
   and which are **end-to-end** (a user flow through the real entry point). Every user-facing flow gets at least
   one end-to-end test. Include the edge cases: empty, very long, special characters, duplicate submit, no
   permission, failure of a dependency.
4. **Write.** Teardown is failure-safe: fixtures / `finally`, never cleanup at the end of the test body. Global
   state changed (env vars, module patches, dependency overrides) is restored by the fixture.
5. **Run.** Execute the suite the project's way. Paste the output: counts, failures, duration.
6. **Delete-the-fix check.** Revert the implementation change, keep the tests, run again: the new tests must
   fail. Restore. Report the result in one line.

## Rules
- A test that passes with the fix removed is not a test. Rewrite it.
- No test that only asserts a file exists or a function was called, unless that is the behaviour.
- If the suite cannot run here (missing service, missing credentials), say exactly what is missing. Do not claim
  a run.
