---
name: review
description: |
  Pre-PR code review of the current diff (or a branch / PR number via gh): checklist pass with the code-reviewer
  agent, adversarial second pass that tries to refute the change, delete-the-fix mutation check, then fix the
  findings. Never approves itself.
  TRIGGERS: "/review", "review this", "review my changes", "review PR 12", "is this ready".
---

# Review: three passes, then fix

Target: the working tree diff by default (`git diff` + `git diff --cached` + untracked files). With an argument:
a branch (`git diff main...<branch>`) or a PR number (`gh pr diff <n>`; `gh pr view <n>` for the description).

## Pass 1: checklist
Spawn the `code-reviewer` agent (`.claude/agents/code-reviewer.md`) with the diff, the PR or task description,
and the spec from `notes/specs/` if one exists. It returns findings most-severe first, the traceability table,
and the roast.

## Pass 2: adversarial
Spawn a `general-purpose` agent with the same diff and this brief: "Your job is to REFUTE this change. Assume
it is wrong. Find the input, state or sequence that breaks it. Find what the tests do not observe. Find the
safety net that was removed. Report only concrete failure scenarios: input → wrong output." Do not hand it
pass 1's conclusions; it must not anchor.

## Pass 3: delete-the-fix
Revert the non-test part of the diff (`git stash push -- <non-test files>` or a temporary patch), run the
tests, restore. Suite still green → the tests do not witness the change: blocker, write the missing test.
Report `mutation: fix removed → N tests fail` or `→ suite still green [BLOCKER]`.

## Report
Most severe first, each as `file:line · what breaks · how (input → outcome)`. Mark `[second-pass-only]`
findings. Where the two passes disagree, show both takes. Then a `Second pass` section stating that it ran.

## Fix
Fix every finding (correctness and quality). No parking lot. Re-run the tests, paste the output. Then say in one
line what is still open, if anything, and that it is ready for `/ship` or not.

## Rules
- Review the lines the change touched; pre-existing issues in untouched lines are noted in one sentence, not fixed.
- Bundled fixes shipped with a feature are reviewed, not dismissed as noise.
- Security findings are blockers. Style findings are suggestions.
- Never post a review or approval on a PR unless she says so explicitly.
