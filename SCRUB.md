# SCRUB: the content gate

This repo is public. It must hold no credentials, no personal machine paths and no attribution trailers.
`scripts/scrub.sh` scans every tracked and untracked-not-ignored file; the GitHub Action `scrub` runs it on every
push and pull request and fails on any hit. `/save` and `/ship` run it locally first: a direct push to `main` is
checked by CI only after it has landed, so the local run is the real gate.

## Forbidden patterns (case-insensitive)

| Pattern | Catches |
|---|---|
| `password` followed by `:` or `=` | inline passwords in configs and docs |
| `AKIA` + 16 chars | AWS access key IDs |
| `ghp_` / `gho_` + 20 chars | GitHub tokens |
| `glpat-` | self-hosted git-forge tokens |
| `sk-` + 20 chars | API keys of several AI providers |
| `-----BEGIN ... PRIVATE KEY` | private keys |
| `pk_` + 6 digits | project-management API tokens |
| `co-authored-by` | attribution trailers in committed text |
| `/Users/`, `C:\Users\` | personal machine paths |

The script prints each hit as `file:line:match` and exits 1. Clean tree: `scrub: clean`, exit 0.

## Usage

```bash
bash scripts/scrub.sh                 # whole repo
bash scripts/scrub.sh path/to/file    # specific files, relative to where you run it (works from a project repo)
SCRUB_ONLY=3 bash scripts/scrub.sh    # one pattern, for testing
```

## False positives

Rewrite the line (e.g. "the password field" → "the secret field", a path under `/Users/` → `~/`). Never weaken a
pattern to make a hit go away.

## Credentials

Live in environment variables or `.env` / `.env.*` files, which are git-ignored and off limits to Claude
(denied in `.claude/settings.json`). Never paste one into a file in this repo.
