# Roadmap

Goal-backward: each phase states what must be **true** when it is done, not a task list.

## Phase 0: installed and useful on day one

**Goal**: the developer runs Claude in this workspace on Windows and gets a first spec and a first review out of it.

Success criteria:
- `bash scripts/setup.sh` completes on their machine and `claude` starts in the folder.
- At least one project is cloned next to the workspace, listed in `projects.txt`, and mapped by `/onboard`.
- One `/spec` is written from a real client conversation, with its open questions listed.
- One `/review` has run on a real diff and its findings were fixed before the PR.

Dependencies: Git for Windows, Claude Code, access to the project repos.

## Phase 1: shaped by real use (fill in after two weeks)

To be defined once we know what they use it for. Candidate directions, pick by observed need:

- **GitHub PR workflow**: review comments posted from `/review` with their yes; PR templates; `gh` auth in setup.
- **Client-facing status**: a `/status` skill that turns `notes/` into a weekly client update (decisions, done,
  next, open questions).
- **Stack-specific review rules**: once the stack is known, a `.claude/rules/<stack>.md` with the pitfalls that
  actually bit (framework defaults, ORM traps, build quirks).
- **Project templates**: scaffolds for the kind of project they start most often.
- **Test infrastructure**: a `/e2e` skill wired to the project's end-to-end runner.

Success criteria: written when the direction is chosen.

## Phase 2: growth

- Hooks for the things that must never be forgotten (format on save, scrub on commit).
- MCP servers for the tools they live in (issue tracker, database, browser).
- Learnings promoted into rules; rules that never fire removed.

## Non-goals (for now)

- No company-specific or client-specific content in this public repo. Those live in each project's own `CLAUDE.md`
  or a private notes repo.
- No automation that writes to a client-visible system without an explicit yes in the session.
