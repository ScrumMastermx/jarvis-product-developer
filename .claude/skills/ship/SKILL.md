---
name: ship
description: |
  Land a change: pull --rebase, run the tests, run the scrub gate, commit with a plain one-line message, push,
  open the pull request with gh (summary, test evidence, second-pass findings). Never force-pushes.
  TRIGGERS: "/ship", "ship it", "open the PR", "push and open a PR", "land this".
---

# Ship: tests, scrub, commit, push, PR

Runs inside the project repo she is working in (not this workspace, unless the change is here).

## Preconditions (stop if any fails)
- `/review` has run on this diff and its findings are fixed. If not, run it first.
- On a feature branch, not `main`. If on `main`: create `feat/<slug>` or `fix/<slug>` and move the changes.

## Steps
1. `git pull --rebase --autostash` against the target branch. Conflict → stop, list the files, ask.
2. Run the project's test command. Red → stop, paste the output. Never ship red.
3. `bash <this-workspace>/scripts/scrub.sh <changed files>` (the gate also exists in the project if it adopted
   it). A hit → fix the line, never weaken the pattern.
4. `git status --short`. Never stage `.env*`, `*token*`, `*secret*`, or files over 5 MB. Formatting-only
   changes go in their own commit.
5. `git commit -m "<one imperative line>"`, e.g. `Add retry to invoice sync`. Check `git log -1 --format=%B`
   holds only that line: no trailers, no generated-by, no links.
6. `git push -u origin <branch>`. Rejected → pull --rebase once more, push once more. Rejected again → stop.
7. `gh pr create --base <target> --title "<the commit line>" --body-file <tmp>` where the body has:
   **What** (3 lines) · **Why** · **Tests** (the command and the pasted summary line) · **Review**: "checklist +
   adversarial second pass ran; findings fixed: <list or none>; delete-the-fix: N tests fail without the change"
   · **Notes for the reviewer** (deploy order, config changes, anything irreversible).
8. Reply with the PR URL and the one-line test result.

## Never
- `--force`, `--force-with-lease`, history rewrites on a shared branch, `git add -A` without reading the list.
- Attribution trailers or generated-by lines in the commit or the PR body.
- Pushing with failing or skipped tests.
