# Verification

## Proof of completion
"Done" requires one of:
(a) test output pasted, (b) a named manual check executed with its observed result, (c) for UI, the feature used in a browser with what was seen described.
None of the three → not done. Say what remains.

Existing tests passing is not proof of new work: the new or changed path must be exercised.

## Delete-the-fix check
Before calling a fix tested: revert the fix hunk, keep the tests, run them. Suite still green → the tests do not observe the fix. Write the one that fails, then restore the fix.

## Three-level artifact check
Every file or function claimed as created must pass all three:
1. **Exists**: the path reads.
2. **Substantive**: no `TODO`, `FIXME`, `placeholder`, `return null`, `return {}`, bare `pass`, empty handlers.
3. **Wired**: imported and called somewhere. An orphan file does not count.

## Reports from agents
A subagent saying "created X with Y" is a claim. Read X, grep for Y, check it is imported, then report.
