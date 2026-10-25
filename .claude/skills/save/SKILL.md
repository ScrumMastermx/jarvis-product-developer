---
name: save
description: |
  Commit and push THIS workspace's notes (specs, meetings, project maps, learnings). Pull --rebase --autostash,
  scrub, stage non-secret files, plain one-line message, push.
  TRIGGERS: "/save", "save my notes", "save and push", "wrap up".
---

# Save: commit and push this workspace

Git only, inside `jarvis-product-developer/`. Project repos use `/ship`.

## Steps
1. `git rev-parse --show-toplevel` must end in `jarvis-product-developer`. Otherwise stop and say which repo you are in.
2. `git pull --rebase --autostash`. Conflict → stop, show files, ask. Never force-push.
3. `bash scripts/scrub.sh`. A hit → fix the line before committing.
4. `git status --short`. Never stage `.env*`, `*token*`, `*secret*`, or files over 5 MB. If `CLAUDE.md`,
   `.claude/` or `scripts/` changed, list those files and ask once: they change how the workspace behaves.
5. `git add <files>` then `git commit -m "<one plain line>"`, e.g. `Spec: invoice export v1`. No trailers,
   no generated-by lines. Check `git log -1 --format=%B`. Never amend.
6. `git pull --rebase --autostash && git push`. Rejected twice → stop and report.
7. Confirm in one line: `Saved and pushed: <N> files, <short hash>.` Nothing to commit → `Nothing to save.`
