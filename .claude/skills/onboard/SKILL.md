---
name: onboard
description: |
  Map an unfamiliar project repo at ../<name>: stack, entry points, how to run and test, conventions, risks.
  Writes notes/projects/<name>.md so every later question starts from it.
  TRIGGERS: "/onboard <name>", "map this repo", "I'm new to this codebase", "how is this project organised".
---

# Onboard: map a project once

Read-only in the project. Output: `notes/projects/<name>.md`.

## Steps
1. Confirm `../<name>` exists. If not, check `projects.txt` for its URL and offer the clone command; do not
   clone unasked.
2. Read in this order: `README*`, package manifests (`package.json`, `pyproject.toml`, `requirements*.txt`,
   `go.mod`, `*.csproj`, `composer.json`, `Gemfile`), CI config (`.github/workflows`, `.*-ci.yml`,
   `Jenkinsfile`), `docker-compose*`, `Makefile`, env examples (`.env.example`, never `.env`), the top-level
   folder tree two levels deep, the main entry point, one representative test.
3. Write the map:
   - **Stack**: languages, frameworks, versions as declared (not guessed).
   - **Run**: the exact commands to install, run locally, and run tests. Mark each `verified` (you ran it) or
     `from docs` (you read it).
   - **Layout**: what lives where, in 10 lines or fewer.
   - **Entry points**: main, routes/handlers, jobs, migrations.
   - **Conventions**: naming, test style, lint/format tools, branch and commit conventions, PR template.
   - **Integrations**: external services, by name, with the file that configures them (never the credential).
   - **Risks and unknowns**: no tests in area X, generated code, pinned old versions, anything you could not read.
4. Reply with the Run block and the three biggest risks. Offer to verify the `from docs` commands by running
   them (install and tests only, nothing that deploys or writes to a remote).

## Rules
- Never quote a password, key or token found in the repo; write "a credential is configured in <file>".
- "Not found" over a plausible guess, every time.
