---
name: plan
description: |
  Plan a non-trivial change (3+ steps or an architectural choice) before touching code: read the affected code,
  list files to change, risks, test plan, and blind spots; then wait for a go.
  TRIGGERS: "/plan", "plan this", "how would you approach", "before we start", any task that will touch 3+ files.
---

# Plan: read first, then propose, then wait

No edits in this skill. Output is a plan in the reply (and, if asked, `notes/specs/<slug>-plan.md`).

## Steps
1. **Read the code that the task touches.** Grep for the symbols involved, read the callers and the tests. If
   `notes/projects/<name>.md` exists, read it for how the project runs and tests.
2. **Blind spots** (the part people skip). Three short lists:
   - *Implicit invariants*: things the current code assumes that nothing enforces (ordering, nullability,
     single writer, timezone, currency, one tenant).
   - *Adjacent blast radius*: callers, jobs, migrations, configs, other repos in `projects.txt` that read the
     same data or contract.
   - *Silent decisions*: choices the task will make if nobody states them (default values, error behaviour,
     backwards compatibility, naming). Each one as a question with your recommended answer.
3. **Plan.** Numbered steps, each naming the file(s) to touch and what changes. Smallest change that satisfies the
   task. Separate behaviour from formatting.
4. **Test plan.** Which tests prove it: unit for logic, end-to-end for the user flow, plus the delete-the-fix check.
   Name the command that runs them.
5. **Risks and rollback.** What could break, how you would notice, how to undo.
6. **Stop.** End with "Go, or change something?" and wait. On "go", execute the plan step by step, then `/test`
   and `/review`.

## Rules
- Something you could not read (missing folder, no access) is listed as unknown, never assumed.
- If the task turns out to be a one-liner, say so and skip the ceremony.
- If the plan needs an architectural choice (new table, new dependency, breaking API), the choice is hers: present
  options with a recommendation, do not pick silently.
