#!/usr/bin/env bash
# setup.sh - one-time (re-runnable) machine check and git setup for this workspace.
# Supports macOS, Linux, and Git Bash on Windows (MINGW/MSYS).
#   bash scripts/setup.sh          check tools, set safe git defaults, ask for git identity if missing
#   bash scripts/setup.sh --check  report only: no prompts, no writes
set -euo pipefail

CHECK_ONLY=0
case "${1:-}" in
  --check) CHECK_ONLY=1 ;;
  "") ;;
  *) printf 'usage: bash scripts/setup.sh [--check]\n' >&2; exit 2 ;;
esac

say()  { printf '%s\n' "$*"; }
warn() { printf 'WARNING: %s\n' "$*" >&2; }
die()  { printf 'ERROR: %s\n' "$*" >&2; exit 1; }

# ---- 1. platform ------------------------------------------------------------
case "$(uname -s)" in
  Darwin)               OS=mac ;;
  Linux)                OS=linux ;;
  MINGW*|MSYS*|CYGWIN*) OS=windows ;;   # Git Bash on Windows
  *)                    die "Unsupported OS ($(uname -s)). Use macOS, Linux, or Git Bash on Windows." ;;
esac
say "== 1/4 Platform: $OS"

# ---- 2. tools ---------------------------------------------------------------
say "== 2/4 Required tools"
missing=()
for t in git curl; do
  if command -v "$t" >/dev/null 2>&1; then say "  ok      $t ($("$t" --version 2>/dev/null | head -n1))"; else say "  MISSING $t"; missing+=("$t"); fi
done
if command -v claude >/dev/null 2>&1 || command -v claude.cmd >/dev/null 2>&1; then
  say "  ok      claude"
else
  warn "claude (Claude Code) not found on PATH. Install it from https://claude.ai/code and reopen this terminal."
fi
# gh is what /ship uses to open pull requests; without it /ship stops after the push and prints the compare URL.
if command -v gh >/dev/null 2>&1; then
  if gh auth status >/dev/null 2>&1; then say "  ok      gh (signed in)"; else warn "gh is installed but not signed in: run  gh auth login  (needed by /ship to open PRs)"; fi
else
  case "$OS" in
    windows) warn "gh (GitHub CLI) not found: admin PowerShell  winget install GitHub.cli  then reopen Git Bash and run  gh auth login" ;;
    mac)     warn "gh (GitHub CLI) not found:  brew install gh  then  gh auth login" ;;
    *)       warn "gh (GitHub CLI) not found: https://cli.github.com then  gh auth login" ;;
  esac
fi
if [ "${#missing[@]}" -gt 0 ]; then
  case "$OS" in
    mac)     say "Install with Homebrew (https://brew.sh):  brew install ${missing[*]}" ;;
    windows) say "Install from an admin PowerShell:  winget install Git.Git GitHub.cli   (curl ships with Git for Windows), then reopen Git Bash" ;;
    linux)   say "Install with apt:  sudo apt update && sudo apt install ${missing[*]}" ;;
  esac
  die "Install the missing tools above, then re-run scripts/setup.sh"
fi

say "  Optional runtimes (depends on the projects you work in):"
for t in node npm python3 python; do
  # On Windows, "python"/"python3" may be the Microsoft Store alias stub: running it opens the Store. Detect it
  # by its path (WindowsApps) and never execute it.
  if [ "$OS" = windows ] && command -v "$t" 2>/dev/null | grep -qi 'WindowsApps'; then
    say "  --      $t is the Microsoft Store stub, not Python (see docs/SETUP-WINDOWS.md troubleshooting)"; continue
  fi
  if command -v "$t" >/dev/null 2>&1 && "$t" --version >/dev/null 2>&1; then
    say "  ok      $t ($("$t" --version 2>/dev/null | head -n1))"
  else
    say "  --      $t not found (install only if a project needs it)"
  fi
done

# ---- 3. git defaults --------------------------------------------------------
say "== 3/4 Git defaults"
set_if_unset() { # $1 key, $2 value, $3 why
  local cur; cur="$(git config --global --get "$1" 2>/dev/null || true)"
  if [ -n "$cur" ]; then
    say "  $1 = $cur (kept)"
  elif [ "$CHECK_ONLY" = 1 ]; then
    say "  $1 unset (would set to $2: $3)"
  else
    git config --global "$1" "$2"; say "  $1 = $2 ($3)"
  fi
}
set_if_unset core.autocrlf false "LF line endings everywhere; .gitattributes enforces it per repo"
set_if_unset pull.rebase true "linear history, no accidental merge commits"
set_if_unset init.defaultBranch main "new repos start on main"

for key in user.name user.email; do
  cur="$(git config --global --get "$key" 2>/dev/null || true)"
  if [ -n "$cur" ]; then
    say "  $key = $cur"
  elif [ "$CHECK_ONLY" = 1 ] || [ ! -t 0 ]; then
    warn "$key is not set. Set it yourself:  git config --global $key \"...\""
  else
    printf '  %s is not set. Enter it: ' "$key"
    read -r val || val=""
    if [ -n "$val" ]; then git config --global "$key" "$val"; say "  $key = $val"; else warn "$key left unset; run: git config --global $key \"...\""; fi
  fi
done

# ---- 4. done ----------------------------------------------------------------
say "== 4/4 Done"
if [ "$CHECK_ONLY" = 1 ]; then
  say "Check complete. Run without --check to apply the git defaults."
else
  say "Next: in this folder run  claude  and type  /onboard <project>  for a repo in ../ or  /spec  to start a feature."
  say "First time? docs/SETUP-WINDOWS.md has the walkthrough; docs/EXTENDING.md shows how to add skills."
fi
