# Extending this workspace

Everything Claude knows about this workspace is a file in this repo. Add a file, commit, done.

## Add a skill (a `/command`)

```
.claude/skills/<name>/SKILL.md
```

```markdown
---
name: <name>
description: |
  One paragraph: what it does and what it produces.
  TRIGGERS: "/<name>", "phrases that should start it".
---

# <Name>: one-line purpose

## Steps
1. ...
## Rules
- ...
```

The folder name and `name:` must match. Keep steps numbered and concrete (which files, which commands, what the
reply looks like). Look at `.claude/skills/meeting/SKILL.md` for a small one and `review/SKILL.md` for one that
spawns an agent.

## Add a rule (always on)

`.claude/rules/<topic>.md`. Rules load in every session; keep them short and about behaviour, not about a single
project. Project-specific conventions belong in `notes/projects/<name>.md` or in that project's own `CLAUDE.md`.

## Add an agent (a specialist Claude spawns)

`.claude/agents/<name>.md` with frontmatter `name`, `description`, `model` (`opus`, `sonnet`, `haiku`), `tools`
(list). The body is its system prompt. Reference it from a skill ("spawn the `<name>` agent with ...").

## Add a hook (run a command on an event)

Hooks live in `.claude/settings.json` under `"hooks"`. They run shell commands before or after tool calls, on
prompt submit, and on stop. Use them for things that must happen every time without relying on Claude remembering
(a formatter after every edit, a secret scan before every commit). Hook scripts go in `scripts/` and must run
on Git Bash, macOS and Linux (plain `sh`, no platform-specific flags). Claude Code's own documentation has the
event names and the JSON shape: ask Claude "how do I add a PostToolUse hook" and it will look it up.

## Point at a new project

1. Clone it next to this repo: `../<folder>`.
2. Add a line to `projects.txt`: `<folder> <git-url>`.
3. `/onboard <folder>` writes `notes/projects/<folder>.md`.
4. Optional: the project gets its own `CLAUDE.md` for conventions that only apply there (Claude reads both).

## Add MCP servers (external tools: issue trackers, databases, browsers)

`claude mcp add` registers a server for this machine or this project. Add one when a workflow needs it (e.g.
reading tickets, querying a database), then write a skill that uses it. Keep credentials in environment
variables, never in the repo.

## Permissions

`.claude/settings.json` holds the allow and deny lists. Add read-only commands you run constantly to `allow`
to stop the prompts; add anything that must never be touched to `deny`. Each project can have its own
`.claude/settings.json` too.

## Keeping it healthy

- `bash scripts/scrub.sh` before every push (CI runs it too).
- Rules and skills are code: change them in a commit with a one-line message saying why.
- When a lesson repeats, `/learn` it; when a learning is a standing rule, promote it to `CLAUDE.md`.
