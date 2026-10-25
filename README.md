# Jarvis Product Developer

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE) [![scrub](https://github.com/ScrumMastermx/jarvis-product-developer/actions/workflows/scrub.yml/badge.svg)](https://github.com/ScrumMastermx/jarvis-product-developer/actions/workflows/scrub.yml)

A ready-made [Claude Code](https://claude.ai/code) workspace for a developer who also gathers requirements:
build features, review code like a senior engineer, turn client conversations into specs, and keep
the lessons. Stack-agnostic. Everything Claude needs is in this repo: no global config required.

## In 60 seconds

- `CLAUDE.md` tells Claude who you are and the hard rules (never invent, prove it works, no secrets, plain commits).
- `.claude/rules/` are the engineering standards that apply in every session.
- `.claude/skills/` are the commands below. `.claude/agents/code-reviewer.md` is the reviewer `/review` spawns.
- `notes/` is yours: specs, meeting notes, project maps, learnings. The code you work on lives in sibling
  folders (`../<project>`), listed in `projects.txt`.

## Install

**Windows** (step by step with troubleshooting: [docs/SETUP-WINDOWS.md](docs/SETUP-WINDOWS.md))

1. Admin PowerShell: `winget install Git.Git`
2. Install Claude Code: https://claude.ai/code (follow the Windows installer), sign in once.
3. Git Bash:
   ```bash
   mkdir -p ~/code && cd ~/code
   git clone https://github.com/ScrumMastermx/jarvis-product-developer.git
   cd jarvis-product-developer && bash scripts/setup.sh
   claude
   ```

**macOS / Linux**: install Git and Claude Code, then the same three lines.

## Commands

| Type | What happens |
|---|---|
| `/onboard shop-api` | Maps a project repo in `../shop-api`: stack, entry points, how to run and test → `notes/projects/` |
| `/spec` | Interviews you about a feature → `notes/specs/<slug>.md` with Given/When/Then acceptance criteria |
| `/meeting` | Raw client or team notes → decisions, action items, open questions, candidate requirements |
| `/plan` | Reads the code first, lists files, risks, test plan and blind spots, then waits for your go |
| `/test` | Writes and runs tests for the changed code (unit for logic, end-to-end for user flows) |
| `/review` | Reviews the diff with a checklist, an adversarial second pass and a delete-the-fix check, then fixes |
| `/ship` | Pull, test, scrub, commit, push, open the PR with the evidence |
| `/learn` | Saves a correction or lesson to `notes/learnings.md` |
| `/save` | Commits and pushes your notes in this repo |

Plain questions work too: "how does login work in shop-api?" gets an answer with file references.

## Extend

Add a skill, rule, agent or project in minutes: [docs/EXTENDING.md](docs/EXTENDING.md). Where this is
headed: [ROADMAP.md](ROADMAP.md).

## Guardrails

`scripts/scrub.sh` blocks credentials, personal paths and attribution trailers; it runs locally before every
push and in CI on every push and PR ([SCRUB.md](SCRUB.md)). Tokens never live in this repo.

## License

MIT, see [LICENSE](LICENSE).
