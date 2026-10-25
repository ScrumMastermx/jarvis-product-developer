---
name: learn
description: |
  Save a correction, a confirmed approach or a lesson to notes/learnings.md (rule → why → how to apply). If it
  is a standing preference, propose a one-line addition to CLAUDE.md.
  TRIGGERS: "/learn", "remember this", "lesson learned", "note that", "next time do X", "don't do that again".
---

# Learn: keep the lesson

## Steps
1. State the lesson as a rule in one line (what to do, not what went wrong).
2. Add **Why**: the incident or constraint behind it, with date and project. **How to apply**: when it kicks in.
3. Check `notes/learnings.md` for an entry that already covers it. Update that one instead of duplicating.
4. Prepend the entry under `## YYYY-MM-DD <rule>`.
5. If the rule is a standing preference about how to work (not a one-off), propose the exact line to add to
   `CLAUDE.md` or the relevant `.claude/rules/*.md`, and wait for her yes before editing those files.

## What not to save
- One-off typos, in-session redirects, anything obvious from reading the code.
- Secrets, personal data, client-confidential details. Describe the shape of the lesson, not the data.
