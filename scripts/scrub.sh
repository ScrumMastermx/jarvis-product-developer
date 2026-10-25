#!/usr/bin/env bash
# scrub.sh - fail if any file in this repo contains credential-like content, personal paths or attribution trailers.
# Usage: scripts/scrub.sh [file ...]   (no args = tracked files + untracked-not-ignored files)
# Test hook: SCRUB_ONLY=<n> runs only the nth pattern (1-based).
# See SCRUB.md. Works with GNU grep (CI) and BSD grep (macOS): no \b, no \s.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
CALLER_PWD="$PWD"

PATTERNS=(
  'password[[:space:]]*[:=]'
  'AKIA[0-9A-Z]{16}'
  'ghp_[A-Za-z0-9]{20,}'
  'gho_[A-Za-z0-9]{20,}'
  'glpat-'
  'sk-[A-Za-z0-9]{20,}'
  '-----BEGIN .*PRIVATE KEY'
  'pk_[0-9]{6,}'
  'co-authored-by'
  '/Users/'
  'C:\\Users\\'
)

# Explicit paths are resolved against the caller's directory (so /ship can call this from a project repo);
# a path that does not exist is an error, never a silent "clean".
candidates=()
if [ "$#" -gt 0 ]; then
  for f in "$@"; do
    case "$f" in /*|[A-Za-z]:*) candidates+=("$f") ;; *) candidates+=("$CALLER_PWD/$f") ;; esac
  done
else
  cd "$ROOT"
  while IFS= read -r -d '' f; do candidates+=("$ROOT/$f"); done \
    < <(git ls-files -z --cached --others --exclude-standard)
fi

scan=()
for f in ${candidates[@]+"${candidates[@]}"}; do
  case "$f" in "$ROOT"/scripts/scrub.sh|"$ROOT"/SCRUB.md) continue ;; esac
  if [ -f "$f" ]; then scan+=("$f"); else echo "scrub: no such file: $f" >&2; exit 2; fi
done

hits=0
if [ "${#scan[@]}" -gt 0 ]; then
  n=0
  for p in "${PATTERNS[@]}"; do
    n=$((n + 1))
    if [ -n "${SCRUB_ONLY:-}" ] && [ "$n" != "$SCRUB_ONLY" ]; then continue; fi
    rc=0
    out="$(grep -nEioIH -e "$p" -- "${scan[@]}")" || rc=$?
    if [ "$rc" -gt 1 ]; then echo "scrub: grep error on pattern: $p" >&2; exit 2; fi
    if [ -n "$out" ]; then printf '%s\n' "$out"; hits=1; fi
  done
fi

if [ "$hits" -ne 0 ]; then
  echo "scrub: FAILED - forbidden content found (see SCRUB.md)" >&2
  exit 1
fi
echo "scrub: clean"
